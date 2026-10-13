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

function Read-ProjectFile {
    param([string]$RelativePath)
    if ($texts.ContainsKey($RelativePath)) { return }
    try {
        $absolutePath = Join-Path $projectRoot $RelativePath
        Assert-PlainPath $absolutePath
        if (-not (Test-Path -LiteralPath $absolutePath -PathType Leaf)) {
            Add-Finding 'HATA' 'E_MISSING_FILE' ('Zorunlu/başvurulan dosya bulunamadı: ' + $RelativePath)
            return
        }
        [byte[]]$bytes = [IO.File]::ReadAllBytes($absolutePath)
        $hasBom = ($bytes.Length -ge 3 -and $bytes[0] -eq 239 -and $bytes[1] -eq 187 -and $bytes[2] -eq 191)
        if ($RelativePath.EndsWith('.ps1')) {
            if (-not $hasBom) { throw 'PowerShell betiği UTF-8 BOM içermeli.' }
            $texts[$RelativePath] = $utf8.GetString($bytes, 3, $bytes.Length - 3)
        } else {
            if ($hasBom) { throw 'Markdown/JSON UTF-8 BOM olmadan kaydedilmeli.' }
            $texts[$RelativePath] = $utf8.GetString($bytes)
        }
        $fileBytes[$RelativePath] = $bytes
    } catch { Add-Finding 'HATA' 'E_FILE_READ' ($RelativePath + ': ' + $_.Exception.Message) }
}

function Get-ArchiveFiles {
    $root = Join-Path $projectRoot 'docs/arsiv'
    if (-not (Test-Path -LiteralPath $root)) { return }
    $pending = New-Object 'Collections.Generic.Queue[string]'
    $pending.Enqueue($root)
    while ($pending.Count -gt 0) {
        $directory = $pending.Dequeue()
        try {
            Assert-PlainPath $directory
            if (-not (Test-Path -LiteralPath $directory -PathType Container)) { throw 'Arşiv yolu klasör olmalı.' }
            # Özyinelemeli listeleme yönlendirilmiş bir alt klasöre girmeden önce kontrol edemez.
            foreach ($item in (Get-ChildItem -LiteralPath $directory -Force | Sort-Object Name)) {
                if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
                    Add-Finding 'HATA' 'E_ARCHIVE_PATH' ('Arşivde bağlantılı/yönlendirilmiş yol denetlenmez: ' + $item.Name)
                    continue
                }
                if ($item.PSIsContainer) { $pending.Enqueue($item.FullName) }
                elseif ($item.Extension -ieq '.md') { $item.FullName.Substring($projectRoot.Length + 1).Replace('\', '/') }
            }
        } catch { Add-Finding 'HATA' 'E_ARCHIVE_PATH' ('Arşiv okunamadı: ' + $_.Exception.Message) }
    }
}

function Get-InlineCodeSpans {
    param([string]$Text)
    $tick = [string][char]96
    $pattern = '(?s)(?<!' + $tick + ')(?<fence>' + $tick + '+)(?!' + $tick + ')(?<body>.*?)(?<!' + $tick + ')\k<fence>(?!' + $tick + ')'
    foreach ($match in [regex]::Matches($Text, $pattern)) {
        [pscustomobject]@{Index=$match.Index; Length=$match.Length; Body=$match.Groups['body'].Value}
    }
}

function Mask-InlineCode {
    param([string]$Text)
    $masked = $Text.ToCharArray()
    foreach ($span in (Get-InlineCodeSpans $Text)) {
        for ($i = $span.Index; $i -lt ($span.Index + $span.Length); $i++) { $masked[$i] = ' ' }
    }
    return ($masked -join '')
}

function Get-DocumentHeadings {
    param([string]$Text)
    $seen = @{}
    $pattern = '(?m)^ {0,3}#{1,6}[ \t]+(?<title>[^\r\n]+)|^ {0,3}(?![#>|<]|[-*+]\s|\d+[.)]\s)(?<setext>[^\r\n]+)\r?\n {0,3}(?:=+|-+)[ \t]*\r?$'
    foreach ($match in [regex]::Matches($Text, $pattern)) {
        if ($match.Groups['title'].Success) { $title = ($match.Groups['title'].Value -replace '[ \t]+#+[ \t]*$', '').Trim() }
        else { $title = $match.Groups['setext'].Value.Trim() }
        $plain = ''
        $cursor = 0
        # Kod içindeki HTML/biçim işaretleri metindir; yalnız kod dışını temizle.
        $spans = @(Get-InlineCodeSpans $title) + @([pscustomobject]@{Index=$title.Length; Length=0; Body=''})
        foreach ($span in $spans) {
            $part = [Net.WebUtility]::HtmlDecode(($title.Substring($cursor, $span.Index - $cursor) -replace '<[^>]*>', ''))
            $part = $part -replace '\[([^\]]+)\]\([^)]+\)', '$1'
            $part = $part -replace '(?<!\w)_([^_]+)_(?!\w)', '$1'
            $plain += $part.Replace('*', '') + $span.Body
            $cursor = $span.Index + $span.Length
        }
        $plain = $plain.Replace([string][char]0x0130, ('i' + [char]0x0307)).ToLowerInvariant()
        $base = ($plain -replace '[^\p{L}\p{M}\p{N}_\- ]', '').Replace(' ', '-')
        $anchor = $base
        $number = 0
        while ($seen.ContainsKey($anchor)) { $number++; $anchor = $base + '-' + $number }
        $seen[$anchor] = $true
        [pscustomobject]@{Title=$title; Anchor=$anchor; Offset=$match.Index}
    }
    $customPattern = '(?is)<(?:a\b[^>]*?\b(?:name|id)|[a-z][\w:-]*\b[^>]*?\bid)\s*=\s*(?:"(?<anchor>[^"]+)"|''(?<anchor>[^'']+)'')[^>]*>'
    foreach ($match in [regex]::Matches((Mask-InlineCode $Text), $customPattern)) {
        [pscustomobject]@{Title=''; Anchor=[Net.WebUtility]::HtmlDecode($match.Groups['anchor'].Value); Offset=$match.Index}
    }
}

function Get-DocumentLinks {
    param([string]$RelativePath, [string]$Text)
    $Text = Mask-InlineCode $Text
    foreach ($link in [regex]::Matches($Text, '!?(?<label>\[[^\]\r\n]*\])\((?<target><[^>]+>|[^)\r\n]+)\)')) {
        $target = $link.Groups['target'].Value.Trim()
        if ($target.StartsWith('<') -and $target.EndsWith('>')) { $target = $target.Substring(1, $target.Length - 2) }
        else { $target = $target -replace ('\s+["' + "'" + '].*$'), '' }
        if ($target -match '^[a-zA-Z][a-zA-Z0-9+.-]*:' -and $target -notmatch '^[A-Za-z]:[/\\]') { continue }
        try {
            $parts = $target -split '#', 2
            $fileTarget = [Uri]::UnescapeDataString($parts[0])
            $fragment = ''
            if ($parts.Count -eq 2) { $fragment = [Uri]::UnescapeDataString($parts[1]) }
            $basePath = [IO.Path]::GetDirectoryName((Join-Path $projectRoot $RelativePath))
            if ($fileTarget -eq '') { $linkedPath = Join-Path $projectRoot $RelativePath }
            elseif ([IO.Path]::IsPathRooted($fileTarget)) { $linkedPath = [IO.Path]::GetFullPath($fileTarget) }
            else { $linkedPath = [IO.Path]::GetFullPath((Join-Path $basePath $fileTarget)) }
            if (-not (Test-InProject $linkedPath)) {
                Add-Finding 'UYARI' 'W_EXTERNAL_LINK' ($RelativePath + ': proje dışındaki yerel bağlantı denetlenmedi.')
                continue
            }
            Assert-PlainPath $linkedPath
            if (-not (Test-Path -LiteralPath $linkedPath)) {
                Add-Finding 'HATA' 'E_BROKEN_LINK' ($RelativePath + ': bağlantı hedefi bulunamadı: ' + $fileTarget)
                continue
            }
            $resolved = $linkedPath.Substring($projectRoot.Length).TrimStart('\').Replace('\', '/')
            $heading = $null
            $valid = $true
            if ($fragment -ne '' -and [IO.Path]::GetExtension($linkedPath) -ieq '.md') {
                Read-ProjectFile $resolved
                if (-not $texts.ContainsKey($resolved)) { $valid = $false }
                else {
                    $heading = @(Get-DocumentHeadings (Remove-CodeBlocks $texts[$resolved]) | Where-Object { $_.Anchor -ceq $fragment }) | Select-Object -First 1
                    if ($null -eq $heading) {
                        Add-Finding 'HATA' 'E_BROKEN_ANCHOR' ($RelativePath + ': başlık bulunamadı: ' + $target)
                        $valid = $false
                    }
                }
            }
            [pscustomobject]@{Path=$resolved; Fragment=$fragment; Heading=$heading; Valid=$valid; Offset=$link.Index}
        } catch { Add-Finding 'HATA' 'E_LINK_PATH' ($RelativePath + ': bağlantı yolu denetlenemedi: ' + $_.Exception.Message) }
    }
}

function Get-SectionLinks {
    param([string]$Path, [string]$Heading)
    $text = Remove-CodeBlocks $texts[$Path]
    $section = [regex]::Match($text, '(?ms)^## (?:' + $Heading + ')[ \t]*\r?\n(?<body>.*?)(?=^## |\z)')
    if (-not $section.Success) { return }
    $body = $section.Groups['body']
    $linksByFile[$Path] | Where-Object { $_.Offset -ge $body.Index -and $_.Offset -lt ($body.Index + $body.Length) }
}

function Read-PlanSteps {
    param([string]$Path)
    $text = Remove-CodeBlocks $texts[$Path]
    $section = [regex]::Match($text, '(?ms)^## Seçilen aşamanın ayrıntıları\s*\r?\n(?<body>.*?)(?=^## |\z)')
    if (-not $section.Success) { Add-Finding 'UYARI' 'W_PLAN_FORMAT' ($Path + ': seçilen aşamanın ayrıntıları başlığı bulunamadı.') }
    $seen = @{}
    foreach ($row in ($section.Groups['body'].Value -split '\r?\n')) {
        if ($row -notmatch '^\s*\|') { continue }
        $cells = @([regex]::Split($row.Trim().Trim('|'), '(?<!\\)\|') | ForEach-Object { $_.Trim().Replace('**', '') })
        if ($cells.Count -lt 1 -or $cells[0] -notmatch '^\d+(?:\.\d+)+$') { continue }
        if ($cells.Count -ne 5) { Add-Finding 'UYARI' 'W_PLAN_FORMAT' ($Path + ': eksik alt adım satırı: ' + $cells[0]); continue }
        $valid = -not ([string]::IsNullOrWhiteSpace($cells[1]) -or [string]::IsNullOrWhiteSpace($cells[2]) -or [string]::IsNullOrWhiteSpace($cells[3]))
        if (-not $valid) { Add-Finding 'UYARI' 'W_PLAN_FIELDS' ($Path + ': kapsam/kabul ölçütü/doğrulama alanı eksik: ' + $cells[0]) }
        if ($seen.ContainsKey($cells[0])) { Add-Finding 'UYARI' 'W_PLAN_FORMAT' ($Path + ': tekrarlı alt adım satırı: ' + $cells[0]); continue }
        if ($cells[4] -notin @('Planlandı', 'Uygulanıyor', 'Uygulandı — doğrulama bekliyor', 'Doğrulandı', 'Kullanıcı kararı bekliyor')) {
            Add-Finding 'UYARI' 'W_PLAN_STATUS' ($Path + ': tanınmayan durum: ' + $cells[0] + ' / ' + $cells[4])
            $valid = $false
        }
        $seen[$cells[0]] = $true
        [pscustomobject]@{Id=$cells[0]; Status=$cells[4]; Path=$Path; Valid=$valid}
    }
}

function Read-LogEntries {
    param([string]$Path)
    $text = Remove-CodeBlocks $texts[$Path]
    foreach ($entry in [regex]::Matches($text, '(?ms)^## (?<title>\d{4}-\d{2}-\d{2} \d{2}:\d{2}[^\r\n]*)\r?\n(?<body>.*?)(?=^## |\z)')) {
        $body = $entry.Groups['body'].Value
        $unitText = Get-Field $body 'Çalışma birimi'
        $valid = Test-FilledField $unitText
        if (-not $valid) { Add-Finding 'UYARI' 'W_LOG_FIELDS' ($Path + ': tarihli çalışma kaydında Çalışma birimi alanı eksik.') }
        else {
            foreach ($field in @('Yapılan iş ve nedeni', 'Değişen dosyalar', 'Doğrulama', 'Başarısız', 'Atlanan', 'Çalıştırılamayan')) {
                if (-not (Test-FilledField (Get-Field $body $field))) {
                    Add-Finding 'UYARI' 'W_LOG_FIELDS' ($Path + ': ' + $unitText + ' kaydında alan eksik: ' + $field)
                    $valid = $false
                }
            }
        }
        $time = [datetime]::MinValue
        if (-not [datetime]::TryParseExact($entry.Groups['title'].Value.Substring(0, 16), 'yyyy-MM-dd HH:mm', [Globalization.CultureInfo]::InvariantCulture, [Globalization.DateTimeStyles]::None, [ref]$time)) {
            Add-Finding 'UYARI' 'W_LOG_TIME' ($Path + ': tarihli çalışma kaydında geçersiz tarih/saat: ' + $entry.Groups['title'].Value)
            $valid = $false
        }
        $title = ($entry.Groups['title'].Value -replace '[ \t]+#+[ \t]*$', '').Trim()
        [pscustomobject]@{Title=$title; Unit=$unitText; Id=(Get-StepId $unitText); Valid=$valid; Path=$Path; Offset=$entry.Index}
    }
}

function Test-PlanReachable {
    param([string]$From, [string]$To, [hashtable]$Graph)
    $pending = New-Object 'Collections.Generic.Queue[string]'
    $visited = @{}
    $pending.Enqueue($From)
    while ($pending.Count -gt 0) {
        $path = $pending.Dequeue()
        if ($visited.ContainsKey($path)) { continue }
        $visited[$path] = $true
        foreach ($next in @($Graph[$path])) {
            if ($next -eq $To) { return $true }
            if ($null -ne $next) { $pending.Enqueue($next) }
        }
    }
    return $false
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
    $archiveFiles = @(Get-ArchiveFiles)
    foreach ($relativePath in ($readFiles + $archiveFiles)) { Read-ProjectFile $relativePath }

    if ($texts.ContainsKey('CLAUDE.md') -and ($texts['CLAUDE.md'] -split '\r?\n')[0] -cne '@AGENTS.md') {
        Add-Finding 'HATA' 'E_CLAUDE_IMPORT' 'CLAUDE.md ilk satırı @AGENTS.md olmalı.'
    }

    $linksByFile = @{}
    foreach ($relativePath in ($markdownFiles + @('README.md') + $archiveFiles)) {
        if (-not $texts.ContainsKey($relativePath)) { continue }
        $documentText = Remove-CodeBlocks $texts[$relativePath]
        $linksByFile[$relativePath] = @(Get-DocumentLinks $relativePath $documentText)
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

    $planPaths = @(@('docs/PLAN.md') + @($archiveFiles | Where-Object { $_ -match '/PLAN\.md$' }) | Where-Object { $texts.ContainsKey($_) })
    $logPaths = @(@('docs/GUNLUK.md') + @($archiveFiles | Where-Object { $_ -match '/GUNLUK\.md$' }) | Where-Object { $texts.ContainsKey($_) })
    $allSteps = @(foreach ($path in $planPaths) { Read-PlanSteps $path })
    $logEntriesByFile = @{}
    $logIdentities = @{}
    foreach ($path in $logPaths) {
        $logEntriesByFile[$path] = @(Read-LogEntries $path)
        foreach ($entry in $logEntriesByFile[$path]) {
            $identity = $entry.Title + ' | ' + $entry.Unit
            if ($logIdentities.ContainsKey($identity)) {
                Add-Finding 'UYARI' 'W_LOG_DUPLICATE' ('Aynı tarihli başlık/çalışma birimi birden çok yerde: ' + $logIdentities[$identity] + ' / ' + $path + '. Yarım aktarım veya kayıt çakışmasını incele.')
            } else { $logIdentities[$identity] = $path }
        }
    }
    $evidence = @{}
    foreach ($step in $allSteps) {
        $journalPath = [IO.Path]::GetDirectoryName($step.Path).Replace('\', '/') + '/GUNLUK.md'
        $hasLog = @($logEntriesByFile[$journalPath] | Where-Object { $_.Valid -and $_.Id -eq $step.Id }).Count -gt 0
        $evidence[$step.Path + '|' + $step.Id] = $hasLog
        if ($step.Status -in @('Doğrulandı', 'Uygulandı — doğrulama bekliyor') -and -not $hasLog) {
            Add-Finding 'UYARI' 'W_LOG_MISSING' ($step.Path + ': ' + $step.Id + ' uygulanmış/doğrulanmış, aynı dizinde alanları dolu tarihli Günlük kaydı yok.')
        }
    }

    $currentStep = ''
    $activeSteps = @($allSteps | Where-Object { $_.Path -eq 'docs/PLAN.md' })
    if ($texts.ContainsKey('docs/PLAN.md')) {
        $currentStep = Get-StepId (Get-Field (Remove-CodeBlocks $texts['docs/PLAN.md']) 'Güncel çalışma birimi')
        if ($currentStep -ne '' -and $currentStep -notin @($activeSteps | ForEach-Object { $_.Id })) { Add-Finding 'UYARI' 'W_CURRENT_STEP' 'Plan: güncel alt adım aktif ayrıntı tablosunda bulunamadı.' }
    }
    if ($activeSteps.Count -eq 0 -and @($logEntriesByFile['docs/GUNLUK.md']).Count -eq 0) { Add-Finding 'BILGI' 'I_STARTUP' 'Aktif başlangıç belgeleri: henüz alt adım veya çalışma kaydı yok.' }

    $reopenGraph = @{}
    $documentGraph = @{}
    foreach ($path in $linksByFile.Keys) { $documentGraph[$path] = @($linksByFile[$path] | Where-Object Valid | ForEach-Object { $_.Path }) }
    foreach ($path in $planPaths) {
        $reopenGraph[$path] = @(Get-SectionLinks $path 'Yeniden açılma' | Where-Object { $_.Valid -and $_.Path -in $planPaths -and $_.Path -ne $path } | ForEach-Object { $_.Path })
        if ($path -eq 'docs/PLAN.md') { continue }
        $journalPath = [IO.Path]::GetDirectoryName($path).Replace('\', '/') + '/GUNLUK.md'
        $closing = @(Get-SectionLinks $path 'Kapanış|Hazırlık ve aşama kapanışı' | Where-Object {
            $link = $_
            $link.Valid -and $link.Path -eq $journalPath -and $null -ne $link.Heading -and @($logEntriesByFile[$journalPath] | Where-Object { $_.Valid -and $_.Offset -eq $link.Heading.Offset }).Count -gt 0
        })
        if ($closing.Count -eq 0) { Add-Finding 'UYARI' 'W_ARCHIVE_CLOSURE' ($path + ': kapanış bölümünden aynı dizindeki dolu tarihli Günlük kaydına başlık bağlantısı yok. Gerçek kapanış anlamı ayrıca incelenmeli.') }
        if (-not (Test-PlanReachable 'docs/PLAN.md' $path $documentGraph)) { Add-Finding 'UYARI' 'W_ARCHIVE_REFERENCE' ($path + ': aktif Plan üzerinden arşiv bağlantısı bulunamadı.') }
    }
    foreach ($path in ($archiveFiles | Where-Object { $_ -match '/(?:GUNLUK|KARARLAR)\.md$' })) {
        $archivePlan = [IO.Path]::GetDirectoryName($path).Replace('\', '/') + '/PLAN.md'
        if (-not $texts.ContainsKey($archivePlan)) { Add-Finding 'UYARI' 'W_ARCHIVE_PLAN' ($path + ': aynı dizinde okunabilir arşiv Plan yok; kapsam ve kapanış eşleştirilemedi.') }
    }
    foreach ($group in ($allSteps | Group-Object Id)) {
        $owners = @($group.Group)
        $eligible = @{}
        foreach ($owner in $owners) {
            if ($owner.Valid -and ($owner.Status -notin @('Doğrulandı', 'Uygulandı — doğrulama bekliyor') -or $evidence[$owner.Path + '|' + $owner.Id])) { $eligible[$owner.Path] = $true }
        }
        # İlişki, başka bir işin veya eksik kanıtlı ara sürümün üzerinden kurulamaz.
        $stepGraph = @{}
        foreach ($path in $eligible.Keys) { $stepGraph[$path] = @($reopenGraph[$path] | Where-Object { $eligible.ContainsKey($_) }) }
        for ($i = 0; $i -lt $owners.Count; $i++) {
            for ($j = $i + 1; $j -lt $owners.Count; $j++) {
                $a = $owners[$i]; $b = $owners[$j]
                $forward = Test-PlanReachable $a.Path $b.Path $stepGraph
                $backward = Test-PlanReachable $b.Path $a.Path $stepGraph
                if ($forward -xor $backward) {
                    Add-Finding 'BILGI' 'I_REOPEN_LINK' ($group.Name + ': önceki Plan bağlantısıyla ilişkili tarihsel sürümler var; bu ilişki işin anlamını veya yeni sonucu kanıtlamaz.')
                } else { Add-Finding 'UYARI' 'W_STEP_DUPLICATE' ($group.Name + ': birden çok Plan tanımı ilişki/yerel kanıt açısından belirsiz: ' + $a.Path + ' / ' + $b.Path) }
            }
        }
    }
    if ($archiveFiles.Count -gt 0) { Add-Finding 'BILGI' 'I_ARCHIVES' ('Arşivde ' + $archiveFiles.Count + ' Markdown belgesi okundu; kayıpsız aktarım veya gerçek test yürütmesi bu taramadan çıkarılamaz.') }

    if ($texts.ContainsKey('docs/DEVIR.md')) {
        $handoff = Remove-CodeBlocks $texts['docs/DEVIR.md']
        if ($currentStep -ne '' -and (Get-StepId (Get-Field $handoff 'Güncel çalışma birimi')) -ne $currentStep) { Add-Finding 'UYARI' 'W_HANDOFF_STEP' 'Devir: güncel çalışma birimi Plan ile eşleşmiyor veya alan eksik.' }
        if ($currentStep -ne '' -and (Get-Field $handoff 'Kayıt zamanı') -notmatch '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}') { Add-Finding 'UYARI' 'W_HANDOFF_TIME' 'Devir: proje başlamışken tarih/saat kaydı eksik.' }
    }

    $decisionIds = @{}
    foreach ($path in (@('docs/KARARLAR.md') + @($archiveFiles | Where-Object { $_ -match '/KARARLAR\.md$' }))) {
        if (-not $texts.ContainsKey($path)) { continue }
        $decisions = Remove-CodeBlocks $texts[$path]
        foreach ($entry in [regex]::Matches($decisions, '(?ms)^## (?<id>K-\d+)[^\r\n]*\r?\n(?<body>.*?)(?=^## |\z)')) {
            $id = $entry.Groups['id'].Value
            if ($decisionIds.ContainsKey($id)) { Add-Finding 'UYARI' 'W_DECISION_DUPLICATE' ($id + ': tekrarlı karar kimliği: ' + $decisionIds[$id] + ' / ' + $path) }
            else { $decisionIds[$id] = $path }
            foreach ($field in @('Karar', 'Gerekçe', 'Etki')) {
                if (-not (Test-FilledField (Get-Field $entry.Groups['body'].Value $field))) { Add-Finding 'UYARI' 'W_DECISION_FIELDS' ($path + ': gerçek karar kaydında alan eksik: ' + $field) }
            }
        }
    }
} catch { Add-Finding 'HATA' 'E_PROJECT' $_.Exception.Message }

Add-Finding 'BILGI' 'I_LIMITS' 'Bu denetim mevcut kayıt/bağlantı yapısını inceler; kullanıcı onayını, kabulün anlamını, test yürütmesini, kod doğruluğunu veya her izi silinmiş geçmişin kayıpsızlığını kanıtlamaz. Ağ/Git işlemi ve dosya yazımı yapmaz.'
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
