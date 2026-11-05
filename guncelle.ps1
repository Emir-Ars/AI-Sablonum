[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$TargetDirectory,
    [switch]$Uygula
)

# Kurulu projeyi yeni şablon sürümüne getirir. -Uygula yoksa yalnız rapor verir, hiçbir şey yazmaz.
# Hiçbir dosya silinmez; üzerine yazılacak her dosya önce yedeklenir.
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
$utf8 = New-Object Text.UTF8Encoding($false, $true)
$createdDirectories = New-Object 'Collections.Generic.List[string]'
$changeLog = New-Object 'Collections.Generic.List[string]'
$writeStarted = $false

# kur.ps1 ile aynı tutulmalı
function Get-LocalPath {
    param([string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) { throw 'Boş hedef veya kaynak yolu kullanılamaz.' }
    foreach ($rawPart in $Path.Replace('/', '\').Split('\')) {
        if ($rawPart -eq '.' -or $rawPart -eq '..' -or $rawPart.Length -eq 0) { continue }
        if ($rawPart.EndsWith('.') -or $rawPart.EndsWith(' ')) { throw ('Geçersiz Windows yol bileşeni: ' + $rawPart) }
    }
    $providerInfo = $null
    $providerDrive = $null
    $providerPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path, [ref]$providerInfo, [ref]$providerDrive)
    if ($providerInfo.Name -ne 'FileSystem') { throw 'Yalnız dosya sistemi yolları kullanılabilir.' }
    $absolutePath = [IO.Path]::GetFullPath($providerPath)
    if ($absolutePath -notmatch '^[A-Za-z]:\\') { throw 'Yalnız yerel sürücü üzerindeki yollar kullanılabilir.' }
    $driveInfo = New-Object IO.DriveInfo([IO.Path]::GetPathRoot($absolutePath))
    if ($driveInfo.DriveType -eq [IO.DriveType]::Network) { throw 'Ağ sürücüsüne kurulum yapılmaz.' }
    foreach ($part in $absolutePath.Substring(3).Split('\')) {
        if ($part.Length -eq 0) { continue }
        if ($part.EndsWith('.') -or $part.EndsWith(' ') -or $part.IndexOfAny([IO.Path]::GetInvalidFileNameChars()) -ge 0) { throw ('Geçersiz Windows yol bileşeni: ' + $part) }
        if ($part -match '^(?i:CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])(?:\.|$)') { throw ('Ayrılmış Windows adı kullanılamaz: ' + $part) }
    }
    return $absolutePath.TrimEnd('\')
}

# kur.ps1 ile aynı tutulmalı
function Test-InDirectory {
    param([string]$Path, [string]$Directory)
    return ($Path.Equals($Directory, [StringComparison]::OrdinalIgnoreCase) -or $Path.StartsWith($Directory.TrimEnd('\') + '\', [StringComparison]::OrdinalIgnoreCase))
}

# kur.ps1 ile aynı tutulmalı
function Assert-UnredirectedPath {
    param([string]$Path)
    $currentPath = $Path
    while (-not [string]::IsNullOrEmpty($currentPath)) {
        if (Test-Path -LiteralPath $currentPath) {
            $item = Get-Item -LiteralPath $currentPath -Force
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { throw ('Bağlantılı/yönlendirilmiş yol kullanılmaz: ' + $currentPath) }
        }
        $parentPath = [IO.Path]::GetDirectoryName($currentPath)
        if ($parentPath -eq $currentPath) { break }
        $currentPath = $parentPath
    }
}

# kur.ps1 ile aynı tutulmalı
function Get-PackagePath {
    param([string]$Root, [string]$RelativePath)
    if ([string]::IsNullOrWhiteSpace($RelativePath) -or [IO.Path]::IsPathRooted($RelativePath) -or $RelativePath.Contains('\') -or $RelativePath.Split('/') -contains '..' -or $RelativePath.Split('/') -contains '.') { throw 'Sürüm kaydında geçersiz göreli yol.' }
    $absolutePath = Get-LocalPath (Join-Path $Root $RelativePath)
    if (-not (Test-InDirectory $absolutePath $Root) -or $absolutePath -eq $Root) { throw 'Göreli yol izin verilen dizinin dışına çıkıyor.' }
    return $absolutePath
}

# kur.ps1 ile aynı tutulmalı
function Get-BytesHash {
    param([byte[]]$Bytes)
    $hasher = [Security.Cryptography.SHA256]::Create()
    try { return ([BitConverter]::ToString($hasher.ComputeHash($Bytes))).Replace('-', '').ToLowerInvariant() }
    finally { $hasher.Dispose() }
}

# kur.ps1 ile aynı tutulmalı
function Split-AgentsBytes {
    param([byte[]]$Bytes)
    $text = $utf8.GetString($Bytes)
    $found = [regex]::Matches($text, '(?m)^## Projeye özel kurallar\r?$')
    if ($found.Count -ne 1) { return $null }
    $offset = $utf8.GetByteCount($text.Substring(0, $found[0].Index))
    $common = New-Object byte[] $offset
    [Array]::Copy($Bytes, 0, $common, 0, $offset)
    $tail = New-Object byte[] ($Bytes.Length - $offset)
    [Array]::Copy($Bytes, $offset, $tail, 0, $tail.Length)
    return [pscustomobject]@{ Common = $common; Tail = $tail }
}

# kur.ps1 ile aynı tutulmalı
function New-InstallDirectory {
    param([string]$Path)
    if (Test-Path -LiteralPath $Path) {
        if (-not (Test-Path -LiteralPath $Path -PathType Container)) { throw ('Klasör yerine dosya var: ' + $Path) }
        Assert-UnredirectedPath $Path
        return
    }
    $parentPath = [IO.Path]::GetDirectoryName($Path)
    if (-not [string]::IsNullOrEmpty($parentPath)) { New-InstallDirectory $parentPath }
    Assert-UnredirectedPath $Path
    [IO.Directory]::CreateDirectory($Path) | Out-Null
    $createdDirectories.Add($Path)
}

function Write-NewFile {
    # Yalnız yeni dosya: var olan dosyanın üzerine yazmaz (CreateNew).
    param([string]$Path, [byte[]]$Bytes)
    Assert-UnredirectedPath $Path
    New-InstallDirectory ([IO.Path]::GetDirectoryName($Path))
    $stream = New-Object IO.FileStream($Path, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::None)
    try { $stream.Write($Bytes, 0, $Bytes.Length) }
    finally { $stream.Dispose() }
}

function Write-ExistingFile {
    # Var olan dosyanın üzerine yazar; yalnız yedek alındıktan ve dosya planlanan hâlde olduğu doğrulandıktan sonra çağrılır.
    param([string]$Path, [byte[]]$Bytes)
    Assert-UnredirectedPath $Path
    $stream = New-Object IO.FileStream($Path, [IO.FileMode]::Truncate, [IO.FileAccess]::Write, [IO.FileShare]::None)
    try { $stream.Write($Bytes, 0, $Bytes.Length) }
    finally { $stream.Dispose() }
}

function Test-ReadOnlyFile {
    param([string]$Path)
    return (((Get-Item -LiteralPath $Path -Force).Attributes -band [IO.FileAttributes]::ReadOnly) -ne 0)
}

try {
    if ($PSVersionTable.PSVersion -lt [version]'5.1') { throw 'Windows PowerShell 5.1 veya daha yenisi gerekir.' }
    $sourceRoot = Get-LocalPath $PSScriptRoot
    $targetRoot = Get-LocalPath $TargetDirectory
    if ($targetRoot -eq [IO.Path]::GetPathRoot($targetRoot).TrimEnd('\')) { throw 'Sürücü köküne güncelleme yapılmaz.' }
    if ((Test-InDirectory $targetRoot $sourceRoot) -or (Test-InDirectory $sourceRoot $targetRoot)) { throw 'Kaynak paketle iç içe bir hedefe güncelleme yapılmaz.' }
    $profileRoot = Get-LocalPath ([Environment]::GetFolderPath('UserProfile'))
    if ($targetRoot -eq $profileRoot) { throw 'Kullanıcı ev klasörüne güncelleme yapılmaz; bir proje klasörü seç.' }
    $protectedRoots = @((Join-Path $profileRoot '.codex'), (Join-Path $profileRoot '.claude'), (Join-Path $profileRoot '.agents'), (Join-Path $profileRoot '.vscode'), (Join-Path $profileRoot '.vscode-insiders'))
    $appDataRoot = [Environment]::GetFolderPath('ApplicationData')
    if (-not [string]::IsNullOrWhiteSpace($appDataRoot)) {
        $protectedRoots += Join-Path $appDataRoot 'Code\User'
        $protectedRoots += Join-Path $appDataRoot 'Code - Insiders\User'
    }
    foreach ($variableName in @('CODEX_HOME', 'CLAUDE_CONFIG_DIR')) {
        $configuredRoot = [Environment]::GetEnvironmentVariable($variableName)
        if (-not [string]::IsNullOrWhiteSpace($configuredRoot)) { $protectedRoots += Get-LocalPath $configuredRoot }
    }
    foreach ($protectedRoot in $protectedRoots) {
        if (Test-InDirectory $targetRoot (Get-LocalPath $protectedRoot)) { throw 'Global yapay zekâ dizinine güncelleme yapılmaz.' }
    }
    Assert-UnredirectedPath $sourceRoot
    Assert-UnredirectedPath $targetRoot
    if (-not (Test-Path -LiteralPath $targetRoot -PathType Container)) { throw 'Hedef klasör yok; önce kur.ps1 ile kurulum yapılmalı.' }

    # --- Kaynak paket (kur.ps1 ile aynı doğrulamalar) ---
    $versionPath = Join-Path $sourceRoot 'surum.json'
    if (-not (Test-Path -LiteralPath $versionPath -PathType Leaf)) { throw 'Kaynak pakette surum.json eksik.' }
    Assert-UnredirectedPath $versionPath
    [byte[]]$versionBytes = [IO.File]::ReadAllBytes($versionPath)
    if ($versionBytes.Length -ge 3 -and $versionBytes[0] -eq 239 -and $versionBytes[1] -eq 187 -and $versionBytes[2] -eq 191) { throw 'surum.json UTF-8 BOM olmadan kaydedilmeli.' }
    $version = $utf8.GetString($versionBytes) | ConvertFrom-Json
    if ($version.schemaVersion -ne 2 -or $version.version -notmatch '^\d+\.\d+\.\d+$' -or $version.packageStatus -notin @('development', 'release') -or $version.minimumPowerShellVersion -ne '5.1') { throw 'Sürüm kaydının biçimi veya alanları geçersiz.' }
    if (@($version.copyFiles).Count -lt 1 -or @($version.copyFiles).Count -gt 100) { throw 'Sürüm kaydının kaynak dosya listesi geçersiz.' }
    $allowedSourcePrefixes = @('genel/', 'sablon/')
    $blockedTargetPrefixes = @('.git/', '.claude/', '.codex/', '.agents/', '.vscode/', '.ai-sablon/')
    $requiredTargets = @('AGENTS.md', 'docs/DURUM.md', 'docs/aktif-asama/PLAN.md')
    $expectedGenerated = @('CLAUDE.md', '.ai-sablon/kurulum.json')
    if (@($version.generatedFiles).Count -ne 2 -or @(Compare-Object ($version.generatedFiles | Sort-Object) ($expectedGenerated | Sort-Object)).Count -ne 0) { throw 'Üretilecek dosya listesi geçersiz.' }
    $pendingFeatures = @($version.pendingFeatures | Where-Object { $null -ne $_ })
    if (@($pendingFeatures | Where-Object { $_ -isnot [string] -or $_ -notmatch '^[a-z0-9-]+$' }).Count -gt 0 -or @($pendingFeatures | Select-Object -Unique).Count -ne $pendingFeatures.Count) { throw 'Bekleyen bileşen listesi geçersiz.' }

    $payload = New-Object 'Collections.Generic.List[object]'
    $sourceFiles = New-Object 'Collections.Generic.List[object]'
    $seenTargets = @{}
    foreach ($copy in $version.copyFiles) {
        if ($copy.source -isnot [string] -or $copy.target -isnot [string] -or $seenTargets.ContainsKey($copy.target)) { throw 'Kaynak/hedef dosya eşlemesi geçersiz veya tekrarlı.' }
        if (@($allowedSourcePrefixes | Where-Object { $copy.source.StartsWith($_, [StringComparison]::Ordinal) }).Count -eq 0) { throw ('Kaynak şablon klasörlerinin dışında: ' + $copy.source) }
        if (@($blockedTargetPrefixes | Where-Object { $copy.target.StartsWith($_, [StringComparison]::OrdinalIgnoreCase) }).Count -gt 0 -or $copy.target -in $expectedGenerated) { throw ('Bu hedefe dosya kopyalanamaz: ' + $copy.target) }
        $sourcePath = Get-PackagePath $sourceRoot $copy.source
        $targetPath = Get-PackagePath $targetRoot $copy.target
        Assert-UnredirectedPath $sourcePath
        if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) { throw ('Kaynak dosya eksik: ' + $copy.source) }
        [byte[]]$sourceBytes = [IO.File]::ReadAllBytes($sourcePath)
        $sourceHash = Get-BytesHash $sourceBytes
        if ($copy.source.EndsWith('.md')) {
            if ($sourceBytes.Length -ge 3 -and $sourceBytes[0] -eq 239 -and $sourceBytes[1] -eq 187 -and $sourceBytes[2] -eq 191) { throw ('Markdown kaynağı BOM içeriyor: ' + $copy.source) }
            $utf8.GetString($sourceBytes) | Out-Null
        }
        if ($copy.source.EndsWith('.ps1') -and ($sourceBytes.Length -lt 3 -or $sourceBytes[0] -ne 239 -or $sourceBytes[1] -ne 187 -or $sourceBytes[2] -ne 191)) { throw ('PowerShell betiği UTF-8 BOM içermeli: ' + $copy.source) }
        $sourceFiles.Add([pscustomobject]@{path=$copy.source; sha256=$sourceHash})
        $payload.Add([pscustomobject]@{relativePath=$copy.target; path=$targetPath; bytes=$sourceBytes; sha256=$sourceHash})
        $seenTargets[$copy.target] = $true
    }
    foreach ($requiredTarget in $requiredTargets) { if (-not $seenTargets.ContainsKey($requiredTarget)) { throw ('Zorunlu kurulum dosyası eksik: ' + $requiredTarget) } }
    if ($version.packageStatus -eq 'release' -and $pendingFeatures.Count -gt 0) { throw 'Yayımlanmış paket bekleyen bileşen içeremez.' }
    $sourceFiles.Add([pscustomobject]@{path='surum.json'; sha256=(Get-BytesHash $versionBytes)})
    $sourceFiles.Add([pscustomobject]@{path='kur.ps1'; sha256=(Get-BytesHash ([IO.File]::ReadAllBytes((Join-Path $sourceRoot 'kur.ps1'))))})
    $sourceFiles.Add([pscustomobject]@{path='guncelle.ps1'; sha256=(Get-BytesHash ([IO.File]::ReadAllBytes($PSCommandPath)))})

    # CLAUDE.md metni kur.ps1 ile aynı olmalı.
    $claudeText = "@AGENTS.md`n`n# Claude için proje girişi`n`nÇalışma kuralları yukarıdaki AGENTS.md içindedir. Oturuma docs/DURUM.md ile başla; uygulama için kullanıcının yetkilendirdiği kapsamı bekle.`n"
    [byte[]]$claudeBytes = $utf8.GetBytes($claudeText)
    $payload.Add([pscustomobject]@{relativePath='CLAUDE.md'; path=(Get-PackagePath $targetRoot 'CLAUDE.md'); bytes=$claudeBytes; sha256=(Get-BytesHash $claudeBytes)})

    $newAgentsItem = @($payload | Where-Object { $_.relativePath -eq 'AGENTS.md' })[0]
    $newAgentsSplit = Split-AgentsBytes $newAgentsItem.bytes
    if ($null -eq $newAgentsSplit) { throw 'AGENTS.md kaynağında "## Projeye özel kurallar" başlığı tam bir kez bulunmalı.' }
    $newCommonHash = Get-BytesHash $newAgentsSplit.Common

    # --- Hedefteki kurulum kaydı ---
    $aiDir = Get-PackagePath $targetRoot '.ai-sablon'
    $recordPath = Get-PackagePath $targetRoot '.ai-sablon/kurulum.json'
    Assert-UnredirectedPath $aiDir
    Assert-UnredirectedPath $recordPath
    if (-not (Test-Path -LiteralPath $recordPath -PathType Leaf)) { throw 'Hedefte .ai-sablon/kurulum.json yok; bu klasör kur.ps1 ile kurulmamış.' }
    [byte[]]$recordBytes = [IO.File]::ReadAllBytes($recordPath)
    try { $record = $utf8.GetString($recordBytes) | ConvertFrom-Json } catch { throw ('Kurulum kaydı okunamadı veya bozuk: ' + $_.Exception.Message) }
    if ($null -eq $record -or $record.schemaVersion -ne 1) { throw 'Kurulum kaydının şema sürümü desteklenmiyor.' }
    if ($record.templateVersion -isnot [string] -or $record.templateVersion -notmatch '^\d+\.\d+\.\d+$') { throw 'Kurulum kaydındaki sürüm geçersiz.' }
    if ([version]$record.templateVersion -gt [version]$version.version) { throw ('Kurulu sürüm (' + $record.templateVersion + ') bu paketten (' + $version.version + ') yeni; eski pakete geri dönülmez.') }
    $recordedHashes = @{}
    $recordOrder = New-Object 'Collections.Generic.List[string]'
    foreach ($entry in @($record.installedFiles)) {
        if ($null -eq $entry -or $entry.path -isnot [string] -or $entry.sha256 -isnot [string] -or $entry.sha256 -notmatch '^[0-9a-f]{64}$') { throw 'Kurulum kaydındaki installedFiles girdisi geçersiz.' }
        if ($recordedHashes.ContainsKey($entry.path)) { throw ('Kurulum kaydında tekrarlı yol: ' + $entry.path) }
        $recordedHashes[$entry.path] = $entry.sha256
        $recordOrder.Add($entry.path)
    }
    $recordedCommon = $null
    if ($null -ne $record.PSObject.Properties['agentsCommonSha256']) {
        if ($record.agentsCommonSha256 -isnot [string] -or $record.agentsCommonSha256 -notmatch '^[0-9a-f]{64}$') { throw 'Kurulum kaydındaki agentsCommonSha256 geçersiz.' }
        $recordedCommon = $record.agentsCommonSha256
    }

    # --- Plan (bu aşamada hiçbir şey yazılmaz) ---
    $plan = New-Object 'Collections.Generic.List[object]'
    $newRecordedHashes = @{}
    $problems = New-Object 'Collections.Generic.List[string]'
    $finalCommon = $recordedCommon
    $agentsManualBytes = $null
    foreach ($item in $payload) {
        $rel = $item.relativePath
        $entry = [pscustomobject]@{ Rel = $rel; Path = $item.path; Action = ''; Detail = ''; Bytes = $null; CurHash = $null; NewHash = $item.sha256 }
        $plan.Add($entry)
        Assert-UnredirectedPath $item.path
        $exists = Test-Path -LiteralPath $item.path
        if ($exists -and -not (Test-Path -LiteralPath $item.path -PathType Leaf)) { throw ('Dosya yerine klasör var: ' + $rel) }
        $recordedHash = $null
        if ($recordedHashes.ContainsKey($rel)) { $recordedHash = $recordedHashes[$rel] }
        if (-not $exists) {
            if ($null -ne $recordedHash) { $entry.Action = 'Silinmis'; $entry.Detail = 'kayıtlı ama hedefte yok; kullanıcı silmiş sayıldı, geri yazılmaz' }
            else {
                $entry.Action = 'Ekle'; $entry.Bytes = $item.bytes
                # Üst yollardan biri dosyaysa yazma aşamasında kısmi durum oluşmasın diye şimdi yakala.
                $ancestor = [IO.Path]::GetDirectoryName($item.path)
                while (-not [string]::IsNullOrEmpty($ancestor) -and (Test-InDirectory $ancestor $targetRoot)) {
                    if ((Test-Path -LiteralPath $ancestor) -and -not (Test-Path -LiteralPath $ancestor -PathType Container)) { $problems.Add('Üst yol dosya: ' + $ancestor); break }
                    $ancestor = [IO.Path]::GetDirectoryName($ancestor)
                }
            }
            continue
        }
        [byte[]]$currentBytes = [IO.File]::ReadAllBytes($item.path)
        $entry.CurHash = Get-BytesHash $currentBytes
        if ($rel -eq 'AGENTS.md') {
            $currentSplit = $null
            try { $currentSplit = Split-AgentsBytes $currentBytes } catch { $currentSplit = $null }
            if ($null -eq $currentSplit) { $entry.Action = 'AgentsDokunma'; $entry.Detail = '"## Projeye özel kurallar" başlığı tam bir kez bulunamadı veya dosya UTF-8 değil; dokunulmadı'; $agentsManualBytes = $newAgentsSplit.Common; continue }
            $currentCommonHash = Get-BytesHash $currentSplit.Common
            if ($currentCommonHash -eq $newCommonHash) { $entry.Action = 'AgentsAyni'; $entry.Detail = 'ortak kısım güncel'; $finalCommon = $newCommonHash; continue }
            if ($null -ne $recordedCommon -and $currentCommonHash -eq $recordedCommon) {
                if (Test-ReadOnlyFile $item.path) { $problems.Add('Salt okunur dosya: ' + $rel) }
                $merged = New-Object byte[] ($newAgentsSplit.Common.Length + $currentSplit.Tail.Length)
                [Array]::Copy($newAgentsSplit.Common, 0, $merged, 0, $newAgentsSplit.Common.Length)
                [Array]::Copy($currentSplit.Tail, 0, $merged, $newAgentsSplit.Common.Length, $currentSplit.Tail.Length)
                $entry.Action = 'AgentsGuncelle'; $entry.Detail = 'ortak kısım yenilenecek, "Projeye özel kurallar" bölümü korunacak'; $entry.Bytes = $merged
                $finalCommon = $newCommonHash
                continue
            }
            $entry.Action = 'AgentsElle'
            if ($null -eq $recordedCommon) { $entry.Detail = 'kayıtta agentsCommonSha256 yok (eski kurulum); ortak kısma dokunulmadı' } else { $entry.Detail = 'ortak kısım kurulumdan sonra değiştirilmiş; dokunulmadı' }
            $agentsManualBytes = $newAgentsSplit.Common
            continue
        }
        if ($entry.CurHash -eq $item.sha256) { $entry.Action = 'Ayni'; continue }
        if ($null -ne $recordedHash -and $entry.CurHash -eq $recordedHash) {
            if (Test-ReadOnlyFile $item.path) { $problems.Add('Salt okunur dosya: ' + $rel) }
            $entry.Action = 'Guncelle'; $entry.Bytes = $item.bytes
            continue
        }
        $entry.Action = 'Kullanici'
        if ($null -eq $recordedHash) { $entry.Detail = 'kayıtta yok ve içerik farklı' } else { $entry.Detail = 'kurulumdan sonra değiştirilmiş' }
    }
    $payloadPaths = @{}
    foreach ($item in $payload) { $payloadPaths[$item.relativePath] = $true }
    $orphans = @($recordOrder | Where-Object { -not $payloadPaths.ContainsKey($_) })
    if ($problems.Count -gt 0) { throw ('Yazılamayacak dosyalar var; hiçbir şey değiştirilmedi:' + [Environment]::NewLine + ($problems -join [Environment]::NewLine)) }

    # --- Rapor ---
    $labels = [ordered]@{
        Ekle = 'Eklenecek'
        Guncelle = 'Güncellenecek'
        AgentsGuncelle = 'AGENTS.md ortak kısmı güncellenecek'
        AgentsAyni = 'AGENTS.md ortak kısmı zaten güncel'
        AgentsElle = 'AGENTS.md elle birleştirme gerekiyor'
        AgentsDokunma = 'AGENTS.md dokunulmadı'
        Ayni = 'Aynı (işlem yok)'
        Kullanici = 'Kullanıcı değiştirmiş (dokunulmayacak)'
        Silinmis = 'Kullanıcı silmiş (geri yazılmayacak)'
    }
    Write-Output ('Hedef: ' + $targetRoot)
    Write-Output ('Kurulu sürüm: v' + $record.templateVersion + ' -> paket sürümü: v' + $version.version)
    foreach ($key in $labels.Keys) {
        $rows = @($plan | Where-Object { $_.Action -eq $key })
        if ($rows.Count -eq 0) { continue }
        Write-Output ($labels[$key] + ' (' + $rows.Count + '):')
        foreach ($row in $rows) { if ($row.Detail) { Write-Output ('  ' + $row.Rel + ' - ' + $row.Detail) } else { Write-Output ('  ' + $row.Rel) } }
    }
    if ($orphans.Count -gt 0) {
        Write-Output ('Artık şablonda yok (silinmeyecek) (' + $orphans.Count + '):')
        foreach ($orphan in $orphans) { Write-Output ('  ' + $orphan) }
    }

    if (-not $Uygula) {
        Write-Output 'Kuru çalıştırma: hiçbir dosya yazılmadı. Uygulamak için -Uygula ekle.'
    } else {
        # --- Uygulama ---
        $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
        $backupName = $stamp
        $suffix = 1
        while (Test-Path -LiteralPath (Get-PackagePath $targetRoot ('.ai-sablon/yedek/' + $backupName))) { $suffix++; $backupName = $stamp + '-' + $suffix }
        $manualPath = Get-PackagePath $targetRoot '.ai-sablon/yeni-AGENTS-ortak.md'
        Assert-UnredirectedPath $manualPath

        $overwrites = New-Object 'Collections.Generic.List[object]'
        foreach ($row in $plan) { if ($row.Action -eq 'Guncelle' -or $row.Action -eq 'AgentsGuncelle') { $overwrites.Add([pscustomobject]@{ Rel = $row.Rel; Path = $row.Path; ExpectedHash = $row.CurHash }) } }
        $manualExists = ($null -ne $agentsManualBytes) -and (Test-Path -LiteralPath $manualPath)
        if ($manualExists) { $overwrites.Add([pscustomobject]@{ Rel = '.ai-sablon/yeni-AGENTS-ortak.md'; Path = $manualPath; ExpectedHash = (Get-BytesHash ([IO.File]::ReadAllBytes($manualPath))) }) }

        $versionChanged = ($record.templateVersion -ne $version.version)
        $anyChange = @($plan | Where-Object { $_.Action -in @('Ekle', 'Guncelle', 'AgentsGuncelle') }).Count -gt 0
        $refreshNeeded = @($plan | Where-Object { $_.Action -eq 'Ayni' -and $recordedHashes.ContainsKey($_.Rel) -and $recordedHashes[$_.Rel] -ne $_.CurHash }).Count -gt 0
        $commonChanged = ($finalCommon -ne $recordedCommon)
        $writeRecord = $anyChange -or $versionChanged -or $refreshNeeded -or $commonChanged
        if ($writeRecord) { $overwrites.Add([pscustomobject]@{ Rel = '.ai-sablon/kurulum.json'; Path = $recordPath; ExpectedHash = (Get-BytesHash $recordBytes) }) }

        # Kayıt ve elle birleştirme dosyası salt okunursa yazmadan önce dur (yarım güncelleme olmasın).
        if ($writeRecord -and (Test-ReadOnlyFile $recordPath)) { throw 'Salt okunur dosya, hiçbir dosya değiştirilmedi: .ai-sablon/kurulum.json' }
        if ($manualExists -and (Test-ReadOnlyFile $manualPath)) { throw 'Salt okunur dosya, hiçbir dosya değiştirilmedi: .ai-sablon/yeni-AGENTS-ortak.md' }

        if ($overwrites.Count -eq 0 -and $null -eq $agentsManualBytes -and -not $anyChange) {
            Write-Output 'Güncellenecek bir şey yok.'
        } else {
            # 1. aşama: bütün yedekler alınır ve doğrulanır; biri başarısızsa hiçbir dosya değiştirilmez.
            $backupPaths = @{}
            foreach ($target in $overwrites) {
                $backupPath = Get-PackagePath $targetRoot ('.ai-sablon/yedek/' + $backupName + '/' + $target.Rel)
                Assert-UnredirectedPath $backupPath
                [byte[]]$original = [IO.File]::ReadAllBytes($target.Path)
                if ((Get-BytesHash $original) -ne $target.ExpectedHash) { throw ('Yedek öncesi dosya değişmiş, işlem durduruldu (hiçbir dosya değiştirilmedi): ' + $target.Rel) }
                try {
                    Write-NewFile $backupPath $original
                    if ((Get-BytesHash ([IO.File]::ReadAllBytes($backupPath))) -ne $target.ExpectedHash) { throw 'Yedek doğrulanamadı.' }
                } catch { throw ('Yedek alınamadı, hiçbir dosya değiştirilmedi: ' + $target.Rel + ' (' + $_.Exception.Message + ')') }
                $backupPaths[$target.Rel] = $backupPath
            }

            # 2. aşama: yazma. Hiçbir dosya silinmez.
            $writeStarted = $true
            $failures = New-Object 'Collections.Generic.List[string]'
            foreach ($row in $plan) {
                if ($row.Action -eq 'Ekle') {
                    try { Write-NewFile $row.Path $row.Bytes; $changeLog.Add('Eklendi: ' + $row.Rel) }
                    catch { $failures.Add('Eklenemedi: ' + $row.Rel + ' (' + $_.Exception.Message + ')') }
                } elseif ($row.Action -eq 'Guncelle' -or $row.Action -eq 'AgentsGuncelle') {
                    try {
                        if ((Get-BytesHash ([IO.File]::ReadAllBytes($row.Path))) -ne $row.CurHash) { throw 'dosya planlamadan sonra değişmiş' }
                        Write-ExistingFile $row.Path $row.Bytes
                        $changeLog.Add('Güncellendi: ' + $row.Rel + ' (yedek: ' + $backupPaths[$row.Rel] + ')')
                    } catch { $failures.Add('Güncellenemedi: ' + $row.Rel + ' (' + $_.Exception.Message + ')') }
                }
            }
            if ($null -ne $agentsManualBytes) {
                try {
                    if ($manualExists) { Write-ExistingFile $manualPath $agentsManualBytes } else { Write-NewFile $manualPath $agentsManualBytes }
                    $changeLog.Add('Yazıldı: .ai-sablon/yeni-AGENTS-ortak.md (AGENTS.md ortak kısmının yeni hâli; elle birleştir)')
                } catch { $failures.Add('Yazılamadı: .ai-sablon/yeni-AGENTS-ortak.md (' + $_.Exception.Message + ')') }
            }
            if ($failures.Count -gt 0) { throw ('Bazı dosyalar yazılamadı; kurulum kaydı güncellenmedi:' + [Environment]::NewLine + ($failures -join [Environment]::NewLine)) }

            # 3. aşama: bütün yazmalar başarılıysa kayıt en son güncellenir.
            if ($writeRecord) {
                $hashMap = [ordered]@{}
                foreach ($path in $recordOrder) { $hashMap[$path] = $recordedHashes[$path] }
                foreach ($row in $plan) {
                    switch ($row.Action) {
                        'Ekle' { $hashMap[$row.Rel] = $row.NewHash }
                        'Guncelle' { $hashMap[$row.Rel] = $row.NewHash }
                        'AgentsGuncelle' { $hashMap[$row.Rel] = (Get-BytesHash $row.Bytes) }
                        'Ayni' { $hashMap[$row.Rel] = $row.CurHash }
                        'AgentsAyni' { if (-not $hashMap.Contains($row.Rel)) { $hashMap[$row.Rel] = $row.CurHash } }
                    }
                }
                $installedFiles = @($hashMap.Keys | ForEach-Object { [pscustomobject]@{ path = $_; sha256 = $hashMap[$_] } })
                $newRecord = [ordered]@{}
                foreach ($property in $record.PSObject.Properties) { $newRecord[$property.Name] = $property.Value }
                $newRecord['schemaVersion'] = 1
                $newRecord['templateVersion'] = $version.version
                $newRecord['packageStatus'] = $version.packageStatus
                $newRecord['updatedAt'] = [DateTimeOffset]::Now.ToString('o')
                $newRecord['pendingFeatures'] = $pendingFeatures
                $newRecord['sourceFiles'] = $sourceFiles.ToArray()
                $newRecord['installedFiles'] = $installedFiles
                if ($null -ne $finalCommon) { $newRecord['agentsCommonSha256'] = $finalCommon }
                [byte[]]$newRecordBytes = $utf8.GetBytes((ConvertTo-Json -InputObject $newRecord -Depth 8) + [Environment]::NewLine)
                Write-ExistingFile $recordPath $newRecordBytes
                $changeLog.Add('Güncellendi: .ai-sablon/kurulum.json (yedek: ' + $backupPaths['.ai-sablon/kurulum.json'] + ')')
            }
            Write-Output ('Güncelleme tamamlandı: ' + $changeLog.Count + ' işlem.')
            foreach ($line in $changeLog) { Write-Output ('  ' + $line) }
            if ($null -ne $agentsManualBytes) { Write-Output 'UYARI: AGENTS.md ortak kısmı otomatik güncellenmedi; .ai-sablon/yeni-AGENTS-ortak.md dosyasını AGENTS.md ile elle birleştir.' }
        }
    }
} catch {
    [Console]::Error.WriteLine(('Güncelleme başarısız: ' + $_.Exception.Message))
    if ($writeStarted) {
        [Console]::Error.WriteLine('Tamamlanmamış işlem; otomatik silme veya geri alma yapılmadı.')
        [Console]::Error.WriteLine(('Değişen dosyalar ve yedekler:' + [Environment]::NewLine + ($changeLog -join [Environment]::NewLine)))
        [Console]::Error.WriteLine(('Oluşan klasörler:' + [Environment]::NewLine + ($createdDirectories -join [Environment]::NewLine)))
    } else { [Console]::Error.WriteLine('Ön kontrol veya yedekleme başarısız; hedefteki hiçbir dosya değiştirilmedi.') }
    exit 1
}
