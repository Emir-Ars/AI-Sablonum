[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$TargetDirectory
)

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
$createdFiles = New-Object 'Collections.Generic.List[string]'
$createdDirectories = New-Object 'Collections.Generic.List[string]'
$writeStarted = $false

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

function Test-InDirectory {
    param([string]$Path, [string]$Directory)
    return ($Path.Equals($Directory, [StringComparison]::OrdinalIgnoreCase) -or $Path.StartsWith($Directory.TrimEnd('\') + '\', [StringComparison]::OrdinalIgnoreCase))
}

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

function Get-PackagePath {
    param([string]$Root, [string]$RelativePath)
    if ([string]::IsNullOrWhiteSpace($RelativePath) -or [IO.Path]::IsPathRooted($RelativePath) -or $RelativePath.Contains('\') -or $RelativePath.Split('/') -contains '..' -or $RelativePath.Split('/') -contains '.') { throw 'Sürüm kaydında geçersiz göreli yol.' }
    $absolutePath = Get-LocalPath (Join-Path $Root $RelativePath)
    if (-not (Test-InDirectory $absolutePath $Root) -or $absolutePath -eq $Root) { throw 'Göreli yol izin verilen dizinin dışına çıkıyor.' }
    return $absolutePath
}

function Get-BytesHash {
    param([byte[]]$Bytes)
    $hasher = [Security.Cryptography.SHA256]::Create()
    try { return ([BitConverter]::ToString($hasher.ComputeHash($Bytes))).Replace('-', '').ToLowerInvariant() }
    finally { $hasher.Dispose() }
}

# guncelle.ps1 ile aynı tutulmalı
function Get-LfHash {
    # CRLF -> LF çevrilmiş baytların SHA-256'sı; satır sonu farkı hash'i değiştirmez.
    param([byte[]]$Bytes)
    $list = New-Object 'Collections.Generic.List[byte]' ($Bytes.Length)
    for ($i = 0; $i -lt $Bytes.Length; $i++) {
        if ($Bytes[$i] -eq 13 -and ($i + 1) -lt $Bytes.Length -and $Bytes[$i + 1] -eq 10) { continue }
        $list.Add($Bytes[$i])
    }
    return Get-BytesHash ($list.ToArray())
}

# guncelle.ps1 ile aynı tutulmalı
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

function Write-NewInstallFile {
    param([string]$Path, [byte[]]$Bytes)
    Assert-UnredirectedPath $Path
    New-InstallDirectory ([IO.Path]::GetDirectoryName($Path))
    $stream = New-Object IO.FileStream($Path, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::None)
    $createdFiles.Add($Path)
    try { $stream.Write($Bytes, 0, $Bytes.Length) }
    finally { $stream.Dispose() }
}

try {
    if ($PSVersionTable.PSVersion -lt [version]'5.1') { throw 'Windows PowerShell 5.1 veya daha yenisi gerekir.' }
    $sourceRoot = Get-LocalPath $PSScriptRoot
    $targetRoot = Get-LocalPath $TargetDirectory
    if ($targetRoot -eq [IO.Path]::GetPathRoot($targetRoot).TrimEnd('\')) { throw 'Sürücü köküne kurulum yapılmaz.' }
    if ((Test-InDirectory $targetRoot $sourceRoot) -or (Test-InDirectory $sourceRoot $targetRoot)) { throw 'Kaynak paketle iç içe bir hedefe kurulum yapılmaz.' }
    $profileRoot = Get-LocalPath ([Environment]::GetFolderPath('UserProfile'))
    if ($targetRoot -eq $profileRoot) { throw 'Kullanıcı ev klasörüne kurulum yapılmaz; bir proje klasörü seç.' }
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
        if (Test-InDirectory $targetRoot (Get-LocalPath $protectedRoot)) { throw 'Global yapay zekâ dizinine kurulum yapılmaz.' }
    }
    Assert-UnredirectedPath $sourceRoot
    Assert-UnredirectedPath $targetRoot

    $versionPath = Join-Path $sourceRoot 'surum.json'
    if (-not (Test-Path -LiteralPath $versionPath -PathType Leaf)) { throw 'Kaynak pakette surum.json eksik.' }
    Assert-UnredirectedPath $versionPath
    $utf8 = New-Object Text.UTF8Encoding($false, $true)
    [byte[]]$versionBytes = [IO.File]::ReadAllBytes($versionPath)
    if ($versionBytes.Length -ge 3 -and $versionBytes[0] -eq 239 -and $versionBytes[1] -eq 187 -and $versionBytes[2] -eq 191) { throw 'surum.json UTF-8 BOM olmadan kaydedilmeli.' }
    $version = $utf8.GetString($versionBytes) | ConvertFrom-Json
    if ($version.schemaVersion -ne 2 -or $version.version -notmatch '^\d+\.\d+\.\d+$' -or $version.packageStatus -notin @('development', 'release') -or $version.minimumPowerShellVersion -ne '5.1') { throw 'Sürüm kaydının biçimi veya alanları geçersiz.' }
    $knownAgentsCommonLfSha256 = @()
    if ($null -ne $version.PSObject.Properties['knownAgentsCommonLfSha256']) {
        $knownAgentsCommonLfSha256 = $version.knownAgentsCommonLfSha256
        if ($knownAgentsCommonLfSha256 -isnot [array] -or $knownAgentsCommonLfSha256.Count -gt 100) { throw 'Sürüm kaydındaki bilinen hash listesi geçersiz.' }
        if (@($knownAgentsCommonLfSha256 | Where-Object { $_ -isnot [string] -or $_ -cnotmatch '^[0-9a-f]{64}$' }).Count -gt 0 -or @($knownAgentsCommonLfSha256 | Select-Object -Unique).Count -ne $knownAgentsCommonLfSha256.Count) { throw 'Sürüm kaydındaki bilinen hash listesi geçersiz.' }
    }

    if (@($version.copyFiles).Count -lt 1 -or @($version.copyFiles).Count -gt 100) { throw 'Sürüm kaydının kaynak dosya listesi geçersiz.' }
    # Kaynaklar yalnız şablon klasörlerinden gelir; hedefler araç ve Git ayar klasörlerine yazılamaz.
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
    # Satır sonu farkı ortak kısmı değiştirilmiş saydırmasın diye LF hash'i kayda yazılır.
    $agentsPayload = @($payload | Where-Object { $_.relativePath -eq 'AGENTS.md' })[0]
    $agentsSplit = Split-AgentsBytes $agentsPayload.bytes
    if ($null -eq $agentsSplit) { throw 'AGENTS.md kaynağında "## Projeye özel kurallar" başlığı tam bir kez bulunmalı.' }
    $agentsCommonLfSha256 = Get-LfHash $agentsSplit.Common
    $sourceFiles.Add([pscustomobject]@{path='surum.json'; sha256=(Get-BytesHash $versionBytes)})
    $sourceFiles.Add([pscustomobject]@{path='kur.ps1'; sha256=(Get-BytesHash ([IO.File]::ReadAllBytes($PSCommandPath)))})

    $claudeText = "@AGENTS.md`n`n# Claude için proje girişi`n`nÇalışma kuralları yukarıdaki AGENTS.md içindedir. Oturuma docs/DURUM.md ile başla; uygulama için kullanıcının yetkilendirdiği kapsamı bekle.`n"
    [byte[]]$claudeBytes = $utf8.GetBytes($claudeText)
    $payload.Add([pscustomobject]@{relativePath='CLAUDE.md'; path=(Get-PackagePath $targetRoot 'CLAUDE.md'); bytes=$claudeBytes; sha256=(Get-BytesHash $claudeBytes)})
    $recordPath = Get-PackagePath $targetRoot '.ai-sablon/kurulum.json'
    $outputPaths = @($payload | ForEach-Object { $_.path }) + @($recordPath)
    $conflicts = New-Object 'Collections.Generic.List[string]'
    foreach ($outputPath in $outputPaths) {
        Assert-UnredirectedPath $outputPath
        if (Test-Path -LiteralPath $outputPath) { $conflicts.Add($outputPath) }
        $parentPath = [IO.Path]::GetDirectoryName($outputPath)
        while (-not [string]::IsNullOrEmpty($parentPath)) {
            if ((Test-Path -LiteralPath $parentPath) -and -not (Test-Path -LiteralPath $parentPath -PathType Container)) { $conflicts.Add($parentPath) }
            $parentPath = [IO.Path]::GetDirectoryName($parentPath)
        }
    }
    if ($conflicts.Count -gt 0) { throw ('Hedef çakışması; hiçbir dosya yazılmadı:' + [Environment]::NewLine + (($conflicts | Select-Object -Unique) -join [Environment]::NewLine)) }

    $writeStarted = $true
    foreach ($file in $payload) { Write-NewInstallFile $file.path $file.bytes }
    $installedFiles = @($payload | ForEach-Object { [pscustomobject]@{path=$_.relativePath; sha256=$_.sha256} })
    $record = [ordered]@{
        schemaVersion = 1
        templateVersion = $version.version
        packageStatus = $version.packageStatus
        installedAt = [DateTimeOffset]::Now.ToString('o')
        pendingFeatures = $pendingFeatures
        sourceFiles = $sourceFiles.ToArray()
        installedFiles = $installedFiles
        agentsCommonLfSha256 = $agentsCommonLfSha256
    }
    [byte[]]$recordBytes = $utf8.GetBytes((ConvertTo-Json -InputObject $record -Depth 8) + [Environment]::NewLine)
    Write-NewInstallFile $recordPath $recordBytes
    Write-Output ('Kurulum tamamlandı: ' + $targetRoot)
    Write-Output ('Sürüm: v' + $version.version + '; paket: ' + $version.packageStatus + '; dosya sayısı: ' + $createdFiles.Count)
    if ($version.packageStatus -eq 'development') { Write-Output ('UYARI: Geliştirme paketi. Bekleyen bileşenler: ' + ($pendingFeatures -join ', ')) }
} catch {
    [Console]::Error.WriteLine(('Kurulum başarısız: ' + $_.Exception.Message))
    if ($writeStarted) {
        [Console]::Error.WriteLine('Tamamlanmamış işlem; otomatik silme yapılmadı.')
        [Console]::Error.WriteLine(('Oluşan dosyalar:' + [Environment]::NewLine + ($createdFiles -join [Environment]::NewLine)))
        [Console]::Error.WriteLine(('Oluşan klasörler:' + [Environment]::NewLine + ($createdDirectories -join [Environment]::NewLine)))
    } else { [Console]::Error.WriteLine('Ön kontrol başarısız; hedefe hiçbir dosya yazılmadı.') }
    exit 1
}
