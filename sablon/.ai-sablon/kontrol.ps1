[CmdletBinding()]
param(
    [string]$ProjectDirectory,
    [switch]$AsJson
)

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
$findings = New-Object 'Collections.Generic.List[object]'
$texts = @{}
$fileBytes = @{}
$projectRoot = $null
$utf8 = New-Object Text.UTF8Encoding($false, $true)

function Add-Finding {
    param([string]$Level, [string]$Code, [string]$Message)
    $findings.Add([pscustomobject]@{level=$Level; code=$Code; message=$Message})
}

function Test-InProject {
    param([string]$Path)
    return ($Path.Equals($projectRoot, [StringComparison]::OrdinalIgnoreCase) -or $Path.StartsWith($projectRoot + '\', [StringComparison]::OrdinalIgnoreCase))
}

function Assert-PlainPath {
    param([string]$Path)
    $currentPath = $Path
    while (-not [string]::IsNullOrEmpty($currentPath)) {
        if (Test-Path -LiteralPath $currentPath) {
            $item = Get-Item -LiteralPath $currentPath -Force
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { throw 'Bağlantılı/yönlendirilmiş yol denetlenmez.' }
        }
        $currentPath = [IO.Path]::GetDirectoryName($currentPath)
    }
}

function Get-Hash {
    param([byte[]]$Bytes)
    $hasher = [Security.Cryptography.SHA256]::Create()
    try { return ([BitConverter]::ToString($hasher.ComputeHash($Bytes))).Replace('-', '').ToLowerInvariant() }
    finally { $hasher.Dispose() }
}

function Get-Field {
    param([string]$Text, [string]$Name)
    $match = [regex]::Match($Text, '(?m)^[ \t]*-[ \t]*' + [regex]::Escape($Name) + ':[ \t]*([^\r\n]*)')
    if ($match.Success) { return $match.Groups[1].Value.Trim().Replace('**', '') }
    return ''
}

function Get-StepId {
    param([string]$Text)
    $match = [regex]::Match($Text, '(?<![\d.])\d+(?:\.\d+)+(?![\d.])')
    if ($match.Success) { return $match.Value }
    return ''
}

function Get-CodeFence {
    param([string]$Line)
    $tick = [string][char]96
    $opening = [regex]::Match($Line, '^[ \t]{0,3}(?<fence>' + $tick + '{3,}|~{3,})(?<info>.*)$')
    if ($opening.Success) {
        $fence = $opening.Groups['fence'].Value
        if ($fence[0] -ne [char]96 -or -not $opening.Groups['info'].Value.Contains($tick)) { return $fence }
    }
    return ''
}

function Remove-CodeBlocks {
    param([string]$Text)
    $cleanLines = New-Object 'Collections.Generic.List[string]'
    $fenceCharacter = ''
    $fenceLength = 0
    $insideComment = $false
    foreach ($line in ($Text -split '\r?\n')) {
        if ($fenceLength -gt 0) {
            if ($line -match ('^[ \t]{0,3}' + [regex]::Escape($fenceCharacter) + '{' + $fenceLength + ',}[ \t]*$')) { $fenceLength = 0 }
            continue
        }
        if (-not $insideComment) {
            $fence = Get-CodeFence $line
            if ($fence.Length -gt 0) {
                $fenceCharacter = [string]$fence[0]
                $fenceLength = $fence.Length
                continue
            }
        }
        if ($insideComment) {
            $commentEnd = $line.IndexOf('-->')
            if ($commentEnd -lt 0) { continue }
            $line = $line.Substring($commentEnd + 3)
            $insideComment = $false
        }
        $visiblePrefix = ''
        while ($line.Contains('<!--')) {
            $commentStart = $line.IndexOf('<!--')
            $visiblePrefix += $line.Substring(0, $commentStart)
            $commentEnd = $line.IndexOf('-->', $commentStart + 4)
            if ($commentEnd -lt 0) { $insideComment = $true; $line = ''; break }
            $line = $line.Substring($commentEnd + 3)
        }
        $line = $visiblePrefix + $line
        $fence = Get-CodeFence $line
        if ($fence.Length -gt 0) {
            $fenceCharacter = [string]$fence[0]
            $fenceLength = $fence.Length
            continue
        }
        $cleanLines.Add($line)
    }
    return ($cleanLines -join [Environment]::NewLine)
}

function Test-FilledField {
    param([string]$Text)
    return (-not [string]::IsNullOrWhiteSpace($Text) -and $Text -notmatch '^(Henüz\b|TODO\b|TBD\b|\[.*\]$)')
}

function Test-HashList {
    param($Entries, [string[]]$Expected, [string]$Name)
    $seenPaths = @{}
    foreach ($entry in @($Entries)) {
        if ($null -eq $entry -or $entry.path -isnot [string] -or $entry.sha256 -isnot [string] -or $entry.sha256 -notmatch '^[a-fA-F0-9]{64}$' -or $entry.path -cnotin $Expected -or $seenPaths.ContainsKey($entry.path)) {
            Add-Finding 'HATA' 'E_METADATA_FILES' ($Name + ': geçersiz/tekrarlı yol veya SHA-256 alanı.')
            continue
        }
        $seenPaths[$entry.path] = $entry.sha256
    }
    if ($seenPaths.Count -ne $Expected.Count) { Add-Finding 'HATA' 'E_METADATA_FILES' ($Name + ': zorunlu dosya listesi eksik veya farklı.') }
    return $seenPaths
}

try {
    if ($PSVersionTable.PSVersion -lt [version]'5.1') { throw 'Windows PowerShell 5.1 veya daha yenisi gerekir.' }
    if (-not $PSBoundParameters.ContainsKey('ProjectDirectory')) { $ProjectDirectory = Split-Path $PSScriptRoot -Parent }
    if ([string]::IsNullOrWhiteSpace($ProjectDirectory)) { throw 'Proje yolu boş olamaz.' }
    $providerInfo = $null
    $providerDrive = $null
    $providerPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ProjectDirectory, [ref]$providerInfo, [ref]$providerDrive)
    if ($providerInfo.Name -ne 'FileSystem') { throw 'Proje yolu dosya sistemi üzerinde olmalı.' }
    $projectRoot = [IO.Path]::GetFullPath($providerPath).TrimEnd('\')
    if ($projectRoot -notmatch '^[A-Za-z]:\\' -or $projectRoot.Length -lt 4) { throw 'Yerel bir proje klasörü seç.' }
    if (-not (Test-Path -LiteralPath $projectRoot -PathType Container)) { throw 'Proje klasörü bulunamadı.' }
    Assert-PlainPath $projectRoot

    $markdownFiles = @('AGENTS.md', 'CLAUDE.md', 'docs/PLAN.md', 'docs/KARARLAR.md', 'docs/GUNLUK.md', 'docs/DEVIR.md')
    $requiredFiles = $markdownFiles + @('.ai-sablon/kontrol.ps1', '.ai-sablon/kurulum.json')
    $readFiles = $requiredFiles
    if (Test-Path -LiteralPath (Join-Path $projectRoot 'README.md') -PathType Leaf) { $readFiles += 'README.md' }
    foreach ($relativePath in $readFiles) {
        try {
            $absolutePath = Join-Path $projectRoot $relativePath
            Assert-PlainPath $absolutePath
            if (-not (Test-Path -LiteralPath $absolutePath -PathType Leaf)) {
                Add-Finding 'HATA' 'E_MISSING_FILE' ('Zorunlu dosya bulunamadı: ' + $relativePath)
                continue
            }
            [byte[]]$bytes = [IO.File]::ReadAllBytes($absolutePath)
            $hasBom = ($bytes.Length -ge 3 -and $bytes[0] -eq 239 -and $bytes[1] -eq 187 -and $bytes[2] -eq 191)
            if ($relativePath.EndsWith('.ps1')) {
                if (-not $hasBom) { throw 'PowerShell betiği UTF-8 BOM içermeli.' }
                $texts[$relativePath] = $utf8.GetString($bytes, 3, $bytes.Length - 3)
            } else {
                if ($hasBom) { throw 'Markdown/JSON UTF-8 BOM olmadan kaydedilmeli.' }
                $texts[$relativePath] = $utf8.GetString($bytes)
            }
            $fileBytes[$relativePath] = $bytes
        } catch { Add-Finding 'HATA' 'E_FILE_READ' ($relativePath + ': ' + $_.Exception.Message) }
    }

    if ($texts.ContainsKey('CLAUDE.md') -and ($texts['CLAUDE.md'] -split '\r?\n')[0] -cne '@AGENTS.md') {
        Add-Finding 'HATA' 'E_CLAUDE_IMPORT' 'CLAUDE.md ilk satırı @AGENTS.md olmalı.'
    }

    foreach ($relativePath in ($markdownFiles + @('README.md'))) {
        if (-not $texts.ContainsKey($relativePath)) { continue }
        $documentText = Remove-CodeBlocks $texts[$relativePath]
        foreach ($link in [regex]::Matches($documentText, '!?\[[^\]\r\n]*\]\((?<target><[^>]+>|[^)\r\n]+)\)')) {
            $target = $link.Groups['target'].Value.Trim()
            if ($target.StartsWith('<') -and $target.EndsWith('>')) { $target = $target.Substring(1, $target.Length - 2) }
            else { $target = $target -replace ('\s+["' + "'" + '].*$'), '' }
            if ($target.StartsWith('#') -or ($target -match '^[a-zA-Z][a-zA-Z0-9+.-]*:' -and $target -notmatch '^[A-Za-z]:[/\\]')) { continue }
            try {
                $target = [Uri]::UnescapeDataString(($target -split '#', 2)[0])
                if ([string]::IsNullOrWhiteSpace($target)) { continue }
                $basePath = [IO.Path]::GetDirectoryName((Join-Path $projectRoot $relativePath))
                if ([IO.Path]::IsPathRooted($target)) { $linkedPath = [IO.Path]::GetFullPath($target) }
                else { $linkedPath = [IO.Path]::GetFullPath((Join-Path $basePath $target)) }
                if (-not (Test-InProject $linkedPath)) {
                    Add-Finding 'UYARI' 'W_EXTERNAL_LINK' ($relativePath + ': proje dışındaki yerel bağlantı denetlenmedi.')
                    continue
                }
                Assert-PlainPath $linkedPath
                if (-not (Test-Path -LiteralPath $linkedPath)) { Add-Finding 'HATA' 'E_BROKEN_LINK' ($relativePath + ': bağlantı hedefi bulunamadı: ' + $target) }
            } catch { Add-Finding 'HATA' 'E_LINK_PATH' ($relativePath + ': bağlantı yolu denetlenemedi: ' + $_.Exception.Message) }
        }
    }

    if ($texts.ContainsKey('.ai-sablon/kurulum.json')) {
        try {
            $record = $texts['.ai-sablon/kurulum.json'] | ConvertFrom-Json
            if ($null -eq $record -or ($record.schemaVersion -isnot [int] -and $record.schemaVersion -isnot [long]) -or $record.schemaVersion -ne 1 -or $record.templateVersion -isnot [string] -or $record.templateVersion -notmatch '^\d+\.\d+\.\d+$' -or $record.packageStatus -cnotin @('development', 'release')) { throw 'Sürüm kaydının temel alanları geçersiz.' }
            $installedAt = [DateTimeOffset]::MinValue
            if ($record.installedAt -isnot [string] -or $record.installedAt -notmatch '^\d{4}-\d{2}-\d{2}T.*(?:Z|[+-]\d{2}:\d{2})$' -or -not [DateTimeOffset]::TryParse($record.installedAt, [Globalization.CultureInfo]::InvariantCulture, [Globalization.DateTimeStyles]::None, [ref]$installedAt)) { throw 'Kurulum tarihi saat dilimi içeren geçerli bir tarih olmalı.' }
            if ($null -eq $record.PSObject.Properties['pendingFeatures'] -or $record.pendingFeatures -isnot [array]) { throw 'Bekleyen bileşenler bir JSON dizisi olmalı.' }
            $pending = @($record.pendingFeatures)
            if (@($pending | Where-Object { $_ -cnotin @('manual-validation', 'editor-behavior-validation') }).Count -gt 0 -or @($pending | Select-Object -Unique).Count -ne $pending.Count) { throw 'Bekleyen bileşen listesi geçersiz.' }
            if ($pending -contains 'manual-validation') { throw 'Kontrol betiği kurulmuşken elle denetim bekliyor gösterilemez.' }
            if ($record.packageStatus -eq 'release' -and $pending.Count -gt 0) { throw 'Yayımlanmış paket bekleyen bileşen içeremez.' }
            if ($record.packageStatus -eq 'development') { Add-Finding 'UYARI' 'W_DEVELOPMENT' 'Paket geliştirme durumunda; gerçek araç davranış denemeleri tamamlanmış sayılmaz.' }
            if ($pending -contains 'editor-behavior-validation') { Add-Finding 'UYARI' 'W_EDITOR_PENDING' 'Codex/Claude VS Code davranış denemeleri bekliyor.' }
            $installedPaths = $markdownFiles + @('.ai-sablon/kontrol.ps1')
            $sourcePaths = @('genel/KURALLAR.md', 'sablon/docs/PLAN.md', 'sablon/docs/KARARLAR.md', 'sablon/docs/GUNLUK.md', 'sablon/docs/DEVIR.md', 'sablon/.ai-sablon/kontrol.ps1', 'surum.json', 'kur.ps1')
            if ($record.sourceFiles -isnot [array] -or $record.installedFiles -isnot [array]) { throw 'Kaynak ve kurulan dosya listeleri JSON dizisi olmalı.' }
            $sourceHashes = Test-HashList $record.sourceFiles $sourcePaths 'sourceFiles'
            $installedHashes = Test-HashList $record.installedFiles $installedPaths 'installedFiles'
            $copyPairs = @{
                'AGENTS.md'='genel/KURALLAR.md'
                'docs/PLAN.md'='sablon/docs/PLAN.md'
                'docs/KARARLAR.md'='sablon/docs/KARARLAR.md'
                'docs/GUNLUK.md'='sablon/docs/GUNLUK.md'
                'docs/DEVIR.md'='sablon/docs/DEVIR.md'
                '.ai-sablon/kontrol.ps1'='sablon/.ai-sablon/kontrol.ps1'
            }
            foreach ($targetPath in $copyPairs.Keys) {
                $sourcePath = $copyPairs[$targetPath]
                if ($sourceHashes.ContainsKey($sourcePath) -and $installedHashes.ContainsKey($targetPath) -and $sourceHashes[$sourcePath] -ne $installedHashes[$targetPath]) {
                    Add-Finding 'HATA' 'E_METADATA_HASH_PAIR' ('Kurulum kaydında kopyalanan kaynak/çıktı özetleri farklı: ' + $targetPath)
                }
            }
            $updatedFiles = @()
            foreach ($relativePath in $installedPaths) {
                if ($fileBytes.ContainsKey($relativePath) -and $installedHashes.ContainsKey($relativePath) -and (Get-Hash $fileBytes[$relativePath]) -ne $installedHashes[$relativePath]) { $updatedFiles += $relativePath }
            }
            if ($updatedFiles.Count -gt 0) { Add-Finding 'BILGI' 'I_UPDATED_FILES' ('Kurulum fotoğrafından farklı dosyalar var; proje belgeleri düzenlenebilir. Bu fark tek başına hata değildir: ' + ($updatedFiles -join ', ')) }
        } catch { Add-Finding 'HATA' 'E_METADATA' ('Kurulum kaydı: ' + $_.Exception.Message) }
    }

    $steps = @{}
    $currentStep = ''
    if ($texts.ContainsKey('docs/PLAN.md')) {
        $plan = Remove-CodeBlocks $texts['docs/PLAN.md']
        $currentStep = Get-StepId (Get-Field $plan 'Güncel çalışma birimi')
        $section = [regex]::Match($plan, '(?ms)^## Seçilen aşamanın ayrıntıları\s*\r?\n(?<body>.*?)(?=^## |\z)')
        if (-not $section.Success) { Add-Finding 'UYARI' 'W_PLAN_FORMAT' 'Plan: seçilen aşamanın ayrıntıları başlığı bulunamadı.' }
        foreach ($row in ($section.Groups['body'].Value -split '\r?\n')) {
            if ($row -notmatch '^\s*\|') { continue }
            $cells = @([regex]::Split($row.Trim().Trim('|'), '(?<!\\)\|') | ForEach-Object { $_.Trim().Replace('**', '') })
            if ($cells.Count -lt 1 -or $cells[0] -notmatch '^\d+(?:\.\d+)+$') { continue }
            if ($cells.Count -ne 5) { Add-Finding 'UYARI' 'W_PLAN_FORMAT' ('Plan: eksik alt adım satırı: ' + $cells[0]); continue }
            if ([string]::IsNullOrWhiteSpace($cells[1]) -or [string]::IsNullOrWhiteSpace($cells[2]) -or [string]::IsNullOrWhiteSpace($cells[3])) { Add-Finding 'UYARI' 'W_PLAN_FIELDS' ('Plan: kapsam/kabul ölçütü/doğrulama alanı eksik: ' + $cells[0]) }
            if ($steps.ContainsKey($cells[0])) { Add-Finding 'UYARI' 'W_PLAN_FORMAT' ('Plan: tekrarlı alt adım satırı: ' + $cells[0]); continue }
            $status = $cells[4]
            if ($status -notin @('Planlandı', 'Uygulanıyor', 'Uygulandı — doğrulama bekliyor', 'Doğrulandı', 'Kullanıcı kararı bekliyor')) { Add-Finding 'UYARI' 'W_PLAN_STATUS' ('Plan: tanınmayan durum: ' + $cells[0] + ' / ' + $status) }
            $steps[$cells[0]] = $status
        }
        if ($currentStep -ne '' -and -not $steps.ContainsKey($currentStep)) { Add-Finding 'UYARI' 'W_CURRENT_STEP' 'Plan: güncel alt adım ayrıntı tablosunda bulunamadı.' }
    }

    $loggedSteps = @{}
    if ($texts.ContainsKey('docs/GUNLUK.md')) {
        $journal = Remove-CodeBlocks $texts['docs/GUNLUK.md']
        $entries = [regex]::Matches($journal, '(?ms)^## \d{4}-\d{2}-\d{2} \d{2}:\d{2}[^\r\n]*\r?\n(?<body>.*?)(?=^## |\z)')
        foreach ($entry in $entries) {
            $body = $entry.Groups['body'].Value
            $unitText = Get-Field $body 'Çalışma birimi'
            if (-not (Test-FilledField $unitText)) { Add-Finding 'UYARI' 'W_LOG_FIELDS' 'Günlük: tarihli çalışma kaydında Çalışma birimi alanı eksik.'; continue }
            $unit = Get-StepId $unitText
            if ($unit -ne '') { $loggedSteps[$unit] = $true }
            $unitLabel = $unitText
            if ($unit -ne '') { $unitLabel = $unit }
            foreach ($field in @('Yapılan iş ve nedeni', 'Değişen dosyalar', 'Doğrulama', 'Başarısız', 'Atlanan', 'Çalıştırılamayan')) {
                if (-not (Test-FilledField (Get-Field $body $field))) { Add-Finding 'UYARI' 'W_LOG_FIELDS' ('Günlük: ' + $unitLabel + ' kaydında alan eksik: ' + $field) }
            }
        }
        foreach ($unit in $steps.Keys) {
            if ($steps[$unit] -in @('Doğrulandı', 'Uygulandı — doğrulama bekliyor') -and -not $loggedSteps.ContainsKey($unit)) { Add-Finding 'UYARI' 'W_LOG_MISSING' ('Plan: ' + $unit + ' uygulanmış/doğrulanmış, eşleşen tarihli Günlük kaydı yok.') }
        }
        if ($steps.Count -eq 0 -and $entries.Count -eq 0) { Add-Finding 'BILGI' 'I_STARTUP' 'Temiz başlangıç belgeleri: henüz alt adım veya çalışma kaydı yok.' }
    }

    if ($texts.ContainsKey('docs/DEVIR.md')) {
        $handoff = Remove-CodeBlocks $texts['docs/DEVIR.md']
        if ($currentStep -ne '' -and (Get-StepId (Get-Field $handoff 'Güncel çalışma birimi')) -ne $currentStep) { Add-Finding 'UYARI' 'W_HANDOFF_STEP' 'Devir: güncel çalışma birimi Plan ile eşleşmiyor veya alan eksik.' }
        if ($currentStep -ne '' -and (Get-Field $handoff 'Kayıt zamanı') -notmatch '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}') { Add-Finding 'UYARI' 'W_HANDOFF_TIME' 'Devir: proje başlamışken tarih/saat kaydı eksik.' }
    }

    if ($texts.ContainsKey('docs/KARARLAR.md')) {
        $decisions = Remove-CodeBlocks $texts['docs/KARARLAR.md']
        foreach ($entry in [regex]::Matches($decisions, '(?ms)^## K-\d+[^\r\n]*\r?\n(?<body>.*?)(?=^## |\z)')) {
            foreach ($field in @('Karar', 'Gerekçe', 'Etki')) {
                if (-not (Test-FilledField (Get-Field $entry.Groups['body'].Value $field))) { Add-Finding 'UYARI' 'W_DECISION_FIELDS' ('Kararlar: gerçek karar kaydında alan eksik: ' + $field) }
            }
        }
    }
} catch { Add-Finding 'HATA' 'E_PROJECT' $_.Exception.Message }

Add-Finding 'BILGI' 'I_LIMITS' 'Bu denetim kayıt yapısını inceler; kullanıcı onayını, testlerin gerçekten çalıştığını veya kodun doğruluğunu kanıtlamaz. Ağ/Git işlemi ve dosya yazımı yapmaz.'
$errorCount = @($findings | Where-Object { $_.level -eq 'HATA' }).Count
$warningCount = @($findings | Where-Object { $_.level -eq 'UYARI' }).Count
$exitCode = 0
$status = 'PASS'
if ($errorCount -gt 0) { $exitCode = 1; $status = 'FAIL' }
elseif ($warningCount -gt 0) { $exitCode = 2; $status = 'WARN' }
$result = [ordered]@{projectDirectory=$projectRoot; status=$status; errors=$errorCount; warnings=$warningCount; findings=$findings.ToArray()}
if ($AsJson) { ConvertTo-Json -InputObject $result -Depth 6 }
else {
    Write-Output ('Elle denetim: ' + $projectRoot)
    foreach ($finding in $findings) { Write-Output ($finding.level + ': ' + $finding.message) }
    Write-Output ('Hata: ' + $errorCount + '; uyarı: ' + $warningCount + '; çıkış kodu: ' + $exitCode)
}
exit $exitCode
