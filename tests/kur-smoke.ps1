[CmdletBinding()]
param(
    [switch]$KeepTemp
)

# Kurucu (kur.ps1) için duman testi. Ek modül gerektirmez (Pester yok), Windows PowerShell 5.1 ile çalışır.
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
$utf8NoBom = New-Object Text.UTF8Encoding($false)
$repoRoot = Split-Path -Parent $PSScriptRoot
$kurPath = Join-Path $repoRoot 'kur.ps1'
$tempBase = [IO.Path]::GetFullPath($env:TEMP)
$runRoot = Join-Path $tempBase ('ai-sablon-smoke-' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
$counts = @{ pass = 0; fail = 0; skip = 0 }
$cleanupJunctions = New-Object 'Collections.Generic.List[string]'
$cleanupLocked = New-Object 'Collections.Generic.List[string]'

# --- Yardımcılar ---

function Get-FileSha {
    param([string]$Path)
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

function Invoke-ChildScript {
    # Betiği ayrı bir powershell.exe sürecinde çalıştırır; çıkış kodu, stdout ve stderr döner.
    param([string]$ScriptPath, [string[]]$ScriptArguments)
    $outFile = Join-Path $runRoot ('cikti-' + [Guid]::NewGuid().ToString('N') + '.out')
    $errFile = Join-Path $runRoot ('cikti-' + [Guid]::NewGuid().ToString('N') + '.err')
    $argumentList = @('-NoProfile', '-File', ('"' + $ScriptPath + '"'))
    foreach ($argument in $ScriptArguments) {
        if ($argument.StartsWith('-')) { $argumentList += $argument } else { $argumentList += ('"' + $argument + '"') }
    }
    $process = Start-Process -FilePath 'powershell.exe' -ArgumentList $argumentList -Wait -PassThru -NoNewWindow -RedirectStandardOutput $outFile -RedirectStandardError $errFile
    $stdout = [IO.File]::ReadAllText($outFile, $utf8NoBom)
    $stderr = [IO.File]::ReadAllText($errFile, $utf8NoBom)
    return [pscustomobject]@{ Code = $process.ExitCode; Out = $stdout; Err = $stderr }
}

function Invoke-Kur {
    param([string]$Target, [string]$Script = $kurPath)
    return Invoke-ChildScript $Script @('-TargetDirectory', $Target)
}

function Get-Snapshot {
    # Klasördeki her dosya için hash, boyut ve son yazma zamanı.
    param([string]$Directory)
    $map = @{}
    if (-not (Test-Path -LiteralPath $Directory)) { return $map }
    $prefix = $Directory.TrimEnd('\') + '\'
    foreach ($file in Get-ChildItem -LiteralPath $Directory -Recurse -File -Force) {
        $relative = $file.FullName.Substring($prefix.Length)
        $map[$relative] = '{0}|{1}|{2}' -f (Get-FileSha $file.FullName), $file.Length, $file.LastWriteTimeUtc.Ticks
    }
    return $map
}

function Compare-Snapshot {
    # Fark yoksa $null, varsa kısa açıklama döner.
    param($Before, $After)
    foreach ($key in $Before.Keys) {
        if (-not $After.ContainsKey($key)) { return ('Dosya kaybolmuş: ' + $key) }
        if ($After[$key] -ne $Before[$key]) { return ('Dosya değişmiş: ' + $key) }
    }
    foreach ($key in $After.Keys) { if (-not $Before.ContainsKey($key)) { return ('Yeni dosya oluşmuş: ' + $key) } }
    return $null
}

function Assert-True {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { throw $Message }
}

function Skip-Scenario {
    param([string]$Reason)
    throw ('ATLANDI: ' + $Reason)
}

function Invoke-Scenario {
    param([string]$Name, [scriptblock]$Body)
    try {
        & $Body
        Write-Output ('GEÇTİ: ' + $Name)
        $counts.pass++
    } catch {
        $message = $_.Exception.Message
        if ($message.StartsWith('ATLANDI: ')) {
            Write-Output ('ATLANDI: ' + $Name + ' -> ' + $message.Substring(9))
            $counts.skip++
        } else {
            Write-Output ('KALDI: ' + $Name + ' -> ' + $message)
            $counts.fail++
        }
    }
}

function New-PackageCopy {
    # Kaynak paketin kurulumda kullanılan kısmının geçici kopyası ("eski sürüm" ve bozuk paket senaryoları için).
    param([string]$Destination)
    New-Item -ItemType Directory -Force -Path $Destination | Out-Null
    foreach ($name in @('kur.ps1', 'surum.json')) { Copy-Item -LiteralPath (Join-Path $repoRoot $name) -Destination $Destination }
    foreach ($name in @('genel', 'sablon')) { Copy-Item -LiteralPath (Join-Path $repoRoot $name) -Destination $Destination -Recurse }
    if (Test-Path -LiteralPath (Join-Path $repoRoot 'guncelle.ps1')) { Copy-Item -LiteralPath (Join-Path $repoRoot 'guncelle.ps1') -Destination $Destination }
}

function Write-TextNoBom {
    param([string]$Path, [string]$Text)
    [IO.File]::WriteAllText($Path, $Text, $utf8NoBom)
}


function Get-TextLfHash {
    # Beklenen hash metin üzerinden hesaplanır; üretimdeki bayt döngüsünü kopyalamaz.
    param([string]$Text)
    $hasher = [Security.Cryptography.SHA256]::Create()
    try { return ([BitConverter]::ToString($hasher.ComputeHash($utf8NoBom.GetBytes($Text.Replace("`r`n", "`n"))))).Replace('-', '').ToLowerInvariant() }
    finally { $hasher.Dispose() }
}

function Read-AgentsParts {
    param([string]$Path)
    $text = [IO.File]::ReadAllText($Path, $utf8NoBom)
    $markers = [regex]::Matches($text, '(?m)^## Projeye özel kurallar\r?$')
    Assert-True ($markers.Count -eq 1) 'Test verisinde tek özel bölüm başlığı olmalı.'
    return [pscustomobject]@{
        Common = $text.Substring(0, $markers[0].Index)
        TailBase64 = [Convert]::ToBase64String($utf8NoBom.GetBytes($text.Substring($markers[0].Index)))
    }
}

function Set-PackageMarkdownLineEndings {
    param([string]$Directory, [string]$LineEnding)
    foreach ($file in Get-ChildItem -LiteralPath $Directory -Recurse -File -Filter '*.md') {
        $text = [IO.File]::ReadAllText($file.FullName, $utf8NoBom).Replace("`r`n", "`n")
        Write-TextNoBom $file.FullName ($text.Replace("`n", $LineEnding))
    }
}

$versionInfo = [IO.File]::ReadAllText((Join-Path $repoRoot 'surum.json'), $utf8NoBom) | ConvertFrom-Json

try {
    New-Item -ItemType Directory -Force -Path $runRoot | Out-Null
    Write-Output ('Geçici kök: ' + $runRoot)

    # --- Senaryo 1-3: temiz kurulum (üçü aynı hedefi paylaşır) ---
    $cleanTarget = Join-Path $runRoot 's1-temiz'
    $cleanResult = $null

    Invoke-Scenario '1 Temiz kurulum' {
        $script:cleanResult = Invoke-Kur $cleanTarget
        Assert-True ($cleanResult.Code -eq 0) ('Çıkış kodu 0 değil: ' + $cleanResult.Code + ' / ' + $cleanResult.Err)
        $expected = @($versionInfo.copyFiles | ForEach-Object { $_.target }) + @($versionInfo.generatedFiles)
        foreach ($relative in $expected) {
            Assert-True (Test-Path -LiteralPath (Join-Path $cleanTarget $relative) -PathType Leaf) ('Eksik dosya: ' + $relative)
        }
        $actualCount = @(Get-ChildItem -LiteralPath $cleanTarget -Recurse -File -Force).Count
        Assert-True ($cleanResult.Out -match 'dosya sayısı: (\d+)') 'Çıktıda dosya sayısı yok.'
        Assert-True ([int]$Matches[1] -eq $actualCount) ('Çıktıdaki dosya sayısı ' + $Matches[1] + ', gerçek ' + $actualCount)
    }

    Invoke-Scenario '2 Hash bütünlüğü' {
        Assert-True ($null -ne $cleanResult -and $cleanResult.Code -eq 0) 'Senaryo 1 başarısız; hash kontrolü yapılamaz.'
        foreach ($copy in $versionInfo.copyFiles) {
            $sourceHash = Get-FileSha (Join-Path $repoRoot ($copy.source.Replace('/', '\')))
            $targetHash = Get-FileSha (Join-Path $cleanTarget ($copy.target.Replace('/', '\')))
            Assert-True ($sourceHash -eq $targetHash) ('Hash farklı: ' + $copy.target)
        }
        $record = [IO.File]::ReadAllText((Join-Path $cleanTarget '.ai-sablon\kurulum.json'), $utf8NoBom) | ConvertFrom-Json
        $expectedCount = @($versionInfo.copyFiles).Count + 1
        Assert-True (@($record.installedFiles).Count -eq $expectedCount) ('installedFiles sayısı ' + @($record.installedFiles).Count + ', beklenen ' + $expectedCount)
        foreach ($entry in $record.installedFiles) {
            $actual = Get-FileSha (Join-Path $cleanTarget ($entry.path.Replace('/', '\')))
            Assert-True ($actual -eq $entry.sha256) ('Kayıtlı hash gerçek dosyadan farklı: ' + $entry.path)
        }
        $parts = Read-AgentsParts (Join-Path $cleanTarget 'AGENTS.md')
        Assert-True ($null -ne $record.PSObject.Properties['agentsCommonLfSha256']) 'Temiz kurulumda LF hash alanı yok.'
        Assert-True ($record.agentsCommonLfSha256 -eq (Get-TextLfHash $parts.Common)) 'Temiz kurulumdaki ortak LF hash yanlış.'
        Assert-True ($null -eq $record.PSObject.Properties['agentsCommonSha256']) 'Temiz kurulumda eski bayt hash alanı var.'
    }

    Invoke-Scenario '3 Encoding (BOM)' {
        Assert-True ($null -ne $cleanResult -and $cleanResult.Code -eq 0) 'Senaryo 1 başarısız; encoding kontrolü yapılamaz.'
        foreach ($file in Get-ChildItem -LiteralPath $cleanTarget -Recurse -File -Force -Filter '*.md') {
            $bytes = [IO.File]::ReadAllBytes($file.FullName)
            Assert-True (-not ($bytes.Length -ge 3 -and $bytes[0] -eq 239 -and $bytes[1] -eq 187 -and $bytes[2] -eq 191)) ('Kurulu .md dosyasında BOM var: ' + $file.Name)
        }
        $kurBytes = [IO.File]::ReadAllBytes($kurPath)
        Assert-True ($kurBytes[0] -eq 239 -and $kurBytes[1] -eq 187 -and $kurBytes[2] -eq 191) 'kur.ps1 BOM''lu değil.'
    }

    Invoke-Scenario '4 Tekrar kurulum' {
        Assert-True ($null -ne $cleanResult -and $cleanResult.Code -eq 0) 'Senaryo 1 başarısız; tekrar kurulum denenemez.'
        $before = Get-Snapshot $cleanTarget
        $second = Invoke-Kur $cleanTarget
        Assert-True ($second.Code -eq 1) ('İkinci kurulum çıkış kodu 1 değil: ' + $second.Code)
        $difference = Compare-Snapshot $before (Get-Snapshot $cleanTarget)
        Assert-True ($null -eq $difference) $difference
    }

    Invoke-Scenario '5 Çakışma' {
        $target = Join-Path $runRoot 's5-cakisma'
        New-Item -ItemType Directory -Force -Path $target | Out-Null
        $original = 'rastgele icerik ' + [Guid]::NewGuid().ToString('N')
        Write-TextNoBom (Join-Path $target 'AGENTS.md') $original
        $result = Invoke-Kur $target
        Assert-True ($result.Code -eq 1) ('Çıkış kodu 1 değil: ' + $result.Code)
        Assert-True ($result.Err -match 'hiçbir dosya yazılmadı') 'Hata iletisinde "hiçbir dosya yazılmadı" yok.'
        Assert-True ([IO.File]::ReadAllText((Join-Path $target 'AGENTS.md'), $utf8NoBom) -eq $original) 'AGENTS.md içeriği değişmiş.'
        Assert-True (@(Get-ChildItem -LiteralPath $target -Recurse -Force).Count -eq 1) 'Hedefte başka dosya veya klasör oluşmuş.'
    }

    Invoke-Scenario '6 Mevcut proje dosyası' {
        $target = Join-Path $runRoot 's6-proje'
        New-Item -ItemType Directory -Force -Path (Join-Path $target 'src') | Out-Null
        $original = 'uygulama dosyasi ' + [Guid]::NewGuid().ToString('N')
        Write-TextNoBom (Join-Path $target 'src\app.txt') $original
        $result = Invoke-Kur $target
        Assert-True ($result.Code -eq 0) ('Çıkış kodu 0 değil: ' + $result.Code + ' / ' + $result.Err)
        Assert-True ([IO.File]::ReadAllText((Join-Path $target 'src\app.txt'), $utf8NoBom) -eq $original) 'app.txt değişmiş.'
    }

    Invoke-Scenario '7a Yol güvenliği: junction hedef' {
        $real = Join-Path $runRoot 's7-gercek'
        $junction = Join-Path $runRoot 's7-junction'
        New-Item -ItemType Directory -Force -Path $real | Out-Null
        try { New-Item -ItemType Junction -Path $junction -Target $real | Out-Null }
        catch { Skip-Scenario ('Junction oluşturulamadı: ' + $_.Exception.Message) }
        $cleanupJunctions.Add($junction)
        $result = Invoke-Kur $junction
        Assert-True ($result.Code -eq 1) ('Çıkış kodu 1 değil: ' + $result.Code)
        Assert-True (@(Get-ChildItem -LiteralPath $real -Force).Count -eq 0) 'Junction''ın gösterdiği klasöre dosya yazılmış.'
    }

    Invoke-Scenario '7b Yol güvenliği: kullanıcı ev klasörü' {
        $homeDir = [Environment]::GetFolderPath('UserProfile')
        $agentsPath = Join-Path $homeDir 'AGENTS.md'
        $docsPath = Join-Path $homeDir 'docs'
        if ((Test-Path -LiteralPath $agentsPath) -or (Test-Path -LiteralPath $docsPath)) { Skip-Scenario 'Ev klasöründe zaten AGENTS.md veya docs var.' }
        $result = Invoke-Kur $homeDir
        Assert-True ($result.Code -eq 1) ('Çıkış kodu 1 değil: ' + $result.Code)
        # Paket ev klasörünün içindeyse kur.ps1 önce "iç içe" kontrolünde durur; iki ileti de doğru reddin kanıtıdır.
        Assert-True ($result.Err -match 'ev klasörüne|iç içe') 'Hata iletisinde ev klasörü veya iç içe hedef uyarısı yok.'
        Assert-True (-not (Test-Path -LiteralPath $agentsPath) -and -not (Test-Path -LiteralPath $docsPath)) 'Ev klasöründe AGENTS.md veya docs oluşmuş.'
    }

    Invoke-Scenario '8 Orta aşamada hata' {
        $package = Join-Path $runRoot 's8-paket'
        New-PackageCopy $package
        $json = [IO.File]::ReadAllText((Join-Path $package 'surum.json'), $utf8NoBom) | ConvertFrom-Json
        $json.copyFiles = @($json.copyFiles) + @([pscustomobject]@{ source = 'sablon/docs/YOL_HARITASI.md'; target = 'docs/kilitli/x.md' })
        Write-TextNoBom (Join-Path $package 'surum.json') ((ConvertTo-Json -InputObject $json -Depth 8) + "`n")
        $target = Join-Path $runRoot 's8-hedef'
        $locked = Join-Path $target 'docs\kilitli'
        New-Item -ItemType Directory -Force -Path $locked | Out-Null
        Write-TextNoBom (Join-Path $target 'keep.txt') 'onceden var'
        $null = & icacls.exe $locked '/deny' '*S-1-1-0:(WD,AD)'
        if ($LASTEXITCODE -ne 0) { Skip-Scenario ('ACL ayarlanamadı (icacls hata kodu ' + $LASTEXITCODE + ').') }
        $cleanupLocked.Add($locked)
        $probe = Join-Path $locked 'deneme.tmp'
        $writable = $true
        try { [IO.File]::WriteAllText($probe, 'x') } catch { $writable = $false }
        if ($writable) { Remove-Item -LiteralPath $probe -Force; Skip-Scenario 'ACL yazmayı engellemedi.' }
        $result = Invoke-Kur $target (Join-Path $package 'kur.ps1')
        Assert-True ($result.Code -eq 1) ('Çıkış kodu 1 değil: ' + $result.Code)
        Assert-True ($result.Err -match 'otomatik silme yapılmadı') 'Hata iletisinde "otomatik silme yapılmadı" yok.'
        Assert-True ($result.Err.Contains((Join-Path $target 'AGENTS.md'))) 'Oluşan dosyalar listesinde AGENTS.md yok.'
        Assert-True (Test-Path -LiteralPath (Join-Path $target 'keep.txt')) 'Önceden var olan dosya silinmiş.'
        Assert-True (Test-Path -LiteralPath (Join-Path $target 'AGENTS.md')) 'Yazılan dosya otomatik silinmiş.'
    }

    # --- Güncelleme senaryoları (guncelle.ps1) ---
    # "Eski sürüm": paket kopyasında sürüm düşürülür, genel/KURALLAR.md ortak kısmı ile iki şablon dosyası değiştirilir.
    $guncellePath = Join-Path $repoRoot 'guncelle.ps1'
    $oldPackage = Join-Path $runRoot 'u-eski-paket'
    New-PackageCopy $oldPackage
    $oldVersionText = [IO.File]::ReadAllText((Join-Path $oldPackage 'surum.json'), $utf8NoBom)
    Write-TextNoBom (Join-Path $oldPackage 'surum.json') ($oldVersionText -replace '"version":\s*"[^"]+"', '"version": "0.2.0"')
    $oldRules = [IO.File]::ReadAllText((Join-Path $oldPackage 'genel\KURALLAR.md'), $utf8NoBom)
    Write-TextNoBom (Join-Path $oldPackage 'genel\KURALLAR.md') ($oldRules.Replace('# Çalışma kuralları', '# Çalışma kuralları (eski sürüm)'))
    foreach ($name in @('YOL_HARITASI.md', 'PROJE.md')) {
        $oldFile = Join-Path $oldPackage ('sablon\docs\' + $name)
        Write-TextNoBom $oldFile ([IO.File]::ReadAllText($oldFile, $utf8NoBom) + "`neski satir`n")
    }
    $agentsMarker = '(?m)^## Projeye özel kurallar\r?$'

    function New-OldInstall {
        param([string]$Name)
        $target = Join-Path $runRoot $Name
        $result = Invoke-Kur $target (Join-Path $oldPackage 'kur.ps1')
        Assert-True ($result.Code -eq 0) ('Eski sürüm kurulumu başarısız: ' + $result.Err)
        return $target
    }

    function Invoke-Guncelle {
        param([string]$Target, [switch]$Apply, [string]$Script = $guncellePath)
        $arguments = @('-TargetDirectory', $Target)
        if ($Apply) { $arguments += '-Uygula' }
        return Invoke-ChildScript $Script $arguments
    }

    Invoke-Scenario 'U1 Güncelle: kuru çalıştırma hiçbir dosyayı değiştirmez' {
        $target = New-OldInstall 'u1'
        $before = Get-Snapshot $target
        $result = Invoke-Guncelle $target
        Assert-True ($result.Code -eq 0) ('Çıkış kodu 0 değil: ' + $result.Code + ' / ' + $result.Err)
        Assert-True ($result.Out -match 'Kuru çalıştırma') 'Kuru çalıştırma iletisi yok.'
        $difference = Compare-Snapshot $before (Get-Snapshot $target)
        Assert-True ($null -eq $difference) $difference
    }

    Invoke-Scenario 'U2 Güncelle: değiştirilmemiş güncellenir, kullanıcı değişikliği korunur ve raporlanır' {
        $target = New-OldInstall 'u2'
        $userText = "kullanici notu`n"
        $projePath = Join-Path $target 'docs\PROJE.md'
        Write-TextNoBom $projePath ([IO.File]::ReadAllText($projePath, $utf8NoBom) + $userText)
        $projeHash = Get-FileSha $projePath
        $result = Invoke-Guncelle $target -Apply
        Assert-True ($result.Code -eq 0) ('Çıkış kodu 0 değil: ' + $result.Code + ' / ' + $result.Err)
        $newSource = Get-FileSha (Join-Path $repoRoot 'sablon\docs\YOL_HARITASI.md')
        Assert-True ((Get-FileSha (Join-Path $target 'docs\YOL_HARITASI.md')) -eq $newSource) 'Değiştirilmemiş dosya güncellenmemiş.'
        Assert-True ((Get-FileSha $projePath) -eq $projeHash) 'Kullanıcının değiştirdiği dosya değişmiş.'
        Assert-True ($result.Out -match 'Kullanıcı değiştirmiş[\s\S]*docs/PROJE\.md') 'Kullanıcı değişikliği raporlanmamış.'
        $record = [IO.File]::ReadAllText((Join-Path $target '.ai-sablon\kurulum.json'), $utf8NoBom) | ConvertFrom-Json
        Assert-True ($record.templateVersion -eq $versionInfo.version) 'Kayıttaki sürüm güncellenmemiş.'
    }

    Invoke-Scenario 'U3 Güncelle: AGENTS.md ortak kısmı yenilenir, özel bölüm bayt bayt korunur' {
        $target = New-OldInstall 'u3'
        $agentsPath = Join-Path $target 'AGENTS.md'
        $original = [IO.File]::ReadAllText($agentsPath, $utf8NoBom)
        $userRule = "- Kullanıcının eklediği özel kural`r`n"
        Write-TextNoBom $agentsPath ($original + $userRule)
        $edited = [IO.File]::ReadAllText($agentsPath, $utf8NoBom)
        $tailBefore = $edited.Substring([regex]::Match($edited, $agentsMarker).Index)
        $result = Invoke-Guncelle $target -Apply
        Assert-True ($result.Code -eq 0) ('Çıkış kodu 0 değil: ' + $result.Code + ' / ' + $result.Err)
        $after = [IO.File]::ReadAllText($agentsPath, $utf8NoBom)
        $source = [IO.File]::ReadAllText((Join-Path $repoRoot 'genel\KURALLAR.md'), $utf8NoBom)
        $afterMarker = [regex]::Match($after, $agentsMarker).Index
        $sourceMarker = [regex]::Match($source, $agentsMarker).Index
        Assert-True ($after.Substring(0, $afterMarker) -ceq $source.Substring(0, $sourceMarker)) 'Ortak kısım yeni sürümle aynı değil.'
        Assert-True ($after.Substring($afterMarker) -ceq $tailBefore) 'Projeye özel bölüm değişmiş.'
        Assert-True (-not $after.Contains('(eski sürüm)')) 'Eski ortak kısım hâlâ duruyor.'
    }

    Invoke-Scenario 'U4 Güncelle: ortak hash alanları yok ve sürüm tanınmıyorsa ortak kısma dokunulmaz' {
        $target = New-OldInstall 'u4'
        $recordPath = Join-Path $target '.ai-sablon\kurulum.json'
        $record = [IO.File]::ReadAllText($recordPath, $utf8NoBom) | ConvertFrom-Json
        $record.PSObject.Properties.Remove('agentsCommonSha256')
        $record.PSObject.Properties.Remove('agentsCommonLfSha256')
        Write-TextNoBom $recordPath ((ConvertTo-Json -InputObject $record -Depth 8) + "`n")
        $agentsHash = Get-FileSha (Join-Path $target 'AGENTS.md')
        $result = Invoke-Guncelle $target -Apply
        Assert-True ($result.Code -eq 0) ('Çıkış kodu 0 değil: ' + $result.Code + ' / ' + $result.Err)
        Assert-True ((Get-FileSha (Join-Path $target 'AGENTS.md')) -eq $agentsHash) 'AGENTS.md değişmiş.'
        $manual = Join-Path $target '.ai-sablon\yeni-AGENTS-ortak.md'
        Assert-True (Test-Path -LiteralPath $manual) 'yeni-AGENTS-ortak.md yazılmamış.'
        $source = [IO.File]::ReadAllText((Join-Path $repoRoot 'genel\KURALLAR.md'), $utf8NoBom)
        $expectedCommon = $source.Substring(0, [regex]::Match($source, $agentsMarker).Index)
        Assert-True ([IO.File]::ReadAllText($manual, $utf8NoBom) -ceq $expectedCommon) 'yeni-AGENTS-ortak.md yeni ortak kısımla aynı değil.'
        Assert-True ((Get-FileSha (Join-Path $target 'docs\YOL_HARITASI.md')) -eq (Get-FileSha (Join-Path $repoRoot 'sablon\docs\YOL_HARITASI.md'))) 'Diğer dosyalar güncellenmemiş.'
    }

    Invoke-Scenario 'U5 Güncelle: yedekler eski hâli içerir, ikinci çalıştırma değişiklik yapmaz' {
        $target = New-OldInstall 'u5'
        $agentsPath = Join-Path $target 'AGENTS.md'
        Write-TextNoBom $agentsPath ([IO.File]::ReadAllText($agentsPath, $utf8NoBom) + "- ozel`n")
        $overwritten = @('AGENTS.md', 'docs\YOL_HARITASI.md', '.ai-sablon\kurulum.json')
        $oldHashes = @{}
        foreach ($relative in $overwritten) { $oldHashes[$relative] = Get-FileSha (Join-Path $target $relative) }
        $result = Invoke-Guncelle $target -Apply
        Assert-True ($result.Code -eq 0) ('Çıkış kodu 0 değil: ' + $result.Code + ' / ' + $result.Err)
        $backupDirs = @(Get-ChildItem -LiteralPath (Join-Path $target '.ai-sablon\yedek') -Directory)
        Assert-True ($backupDirs.Count -eq 1) 'Tek yedek klasörü bekleniyordu.'
        foreach ($relative in $overwritten) {
            $backupFile = Join-Path $backupDirs[0].FullName $relative
            Assert-True (Test-Path -LiteralPath $backupFile) ('Yedek yok: ' + $relative)
            Assert-True ((Get-FileSha $backupFile) -eq $oldHashes[$relative]) ('Yedek eski hâlle aynı değil: ' + $relative)
        }
        $before = Get-Snapshot $target
        $second = Invoke-Guncelle $target -Apply
        Assert-True ($second.Code -eq 0) ('İkinci çalıştırma çıkış kodu 0 değil: ' + $second.Code + ' / ' + $second.Err)
        $difference = Compare-Snapshot $before (Get-Snapshot $target)
        Assert-True ($null -eq $difference) ('İkinci çalıştırma dosya değiştirmiş: ' + $difference)
    }

    Invoke-Scenario 'U6 Güncelle: eski paketle geri sürüme düşürme reddedilir' {
        $target = Join-Path $runRoot 'u6'
        $install = Invoke-Kur $target
        Assert-True ($install.Code -eq 0) ('Kurulum başarısız: ' + $install.Err)
        $before = Get-Snapshot $target
        $result = Invoke-Guncelle $target -Apply -Script (Join-Path $oldPackage 'guncelle.ps1')
        Assert-True ($result.Code -eq 1) ('Çıkış kodu 1 değil: ' + $result.Code)
        $difference = Compare-Snapshot $before (Get-Snapshot $target)
        Assert-True ($null -eq $difference) $difference
    }

    Invoke-Scenario 'U7 Güncelle: kullanıcının sildiği dosya geri yazılmaz, kayıtsız hedef reddedilir' {
        $target = New-OldInstall 'u7'
        Remove-Item -LiteralPath (Join-Path $target 'docs\ACIK_KONULAR.md') -Force
        $result = Invoke-Guncelle $target -Apply
        Assert-True ($result.Code -eq 0) ('Çıkış kodu 0 değil: ' + $result.Code + ' / ' + $result.Err)
        Assert-True (-not (Test-Path -LiteralPath (Join-Path $target 'docs\ACIK_KONULAR.md'))) 'Silinen dosya geri yazılmış.'
        $plain = Join-Path $runRoot 'u7-kayitsiz'
        New-Item -ItemType Directory -Force -Path $plain | Out-Null
        $rejected = Invoke-Guncelle $plain -Apply
        Assert-True ($rejected.Code -eq 1) 'Kurulum kaydı olmayan hedef reddedilmedi.'
        Assert-True (@(Get-ChildItem -LiteralPath $plain -Force).Count -eq 0) 'Kayıtsız hedefe dosya yazılmış.'
    }

    Invoke-Scenario 'U8 Güncelle: salt okunur dosya yazma ve yedekleme öncesi reddedilir' {
        $target = New-OldInstall 'u8'
        $locked = Join-Path $target 'docs\YOL_HARITASI.md'
        $originalAttributes = [IO.File]::GetAttributes($locked)
        try {
            [IO.File]::SetAttributes($locked, ($originalAttributes -bor [IO.FileAttributes]::ReadOnly))
            $before = Get-Snapshot $target
            $result = Invoke-Guncelle $target -Apply
            Assert-True ($result.Code -eq 1) ('Çıkış kodu 1 değil: ' + $result.Code)
            Assert-True ($result.Err -match 'Salt okunur') 'Salt okunur uyarısı yok.'
            $difference = Compare-Snapshot $before (Get-Snapshot $target)
            Assert-True ($null -eq $difference) $difference
            Assert-True (-not (Test-Path -LiteralPath (Join-Path $target '.ai-sablon\yedek'))) 'Hata öncesinde yedek klasörü oluşmuş.'
        } finally {
            [IO.File]::SetAttributes($locked, $originalAttributes)
        }
    }

    Invoke-Scenario 'U9 Güncelle: üst yol dosyaysa hiçbir dosya değiştirilmez' {
        $target = New-OldInstall 'u9'
        $package = Join-Path $runRoot 'u9-paket'
        New-PackageCopy $package
        $versionPath = Join-Path $package 'surum.json'
        $version = [IO.File]::ReadAllText($versionPath, $utf8NoBom) | ConvertFrom-Json
        $version.copyFiles = @($version.copyFiles) + @([pscustomobject]@{ source = 'sablon/docs/arsiv/BENIOKU.md'; target = 'docs/yeni/ek.md' })
        Write-TextNoBom $versionPath ((ConvertTo-Json -InputObject $version -Depth 8) + "`n")
        Write-TextNoBom (Join-Path $target 'docs\yeni') 'üst yol dosyası'
        $before = Get-Snapshot $target
        $result = Invoke-Guncelle $target -Apply -Script (Join-Path $package 'guncelle.ps1')
        Assert-True ($result.Code -eq 1) ('Çıkış kodu 1 değil: ' + $result.Code)
        Assert-True ($result.Err -match 'Üst yol dosya') 'Üst yol dosya uyarısı yok.'
        $difference = Compare-Snapshot $before (Get-Snapshot $target)
        Assert-True ($null -eq $difference) $difference
    }

    Invoke-Scenario 'U10 Güncelle: başlıksız AGENTS.md korunur ve elle birleştirme dosyası yazılır' {
        $target = New-OldInstall 'u10'
        $path = Join-Path $target 'AGENTS.md'
        $text = [IO.File]::ReadAllText($path, $utf8NoBom)
        Write-TextNoBom $path ([regex]::Replace($text, '(?m)^## Projeye özel kurallar\r?\n?', ''))
        $before = Get-FileSha $path
        $result = Invoke-Guncelle $target -Apply
        Assert-True ($result.Code -eq 0) ('Güncelleme başarısız: ' + $result.Err)
        Assert-True ((Get-FileSha $path) -eq $before) 'Başlıksız AGENTS.md değişmiş.'
        Assert-True ($result.Out -match 'dokunulmadı') 'Dokunulmadı raporu yok.'
        $manual = Join-Path $target '.ai-sablon\yeni-AGENTS-ortak.md'
        $expected = Read-AgentsParts (Join-Path $repoRoot 'genel\KURALLAR.md')
        Assert-True (Test-Path -LiteralPath $manual) 'Elle birleştirme dosyası yok.'
        Assert-True ([Convert]::ToBase64String([IO.File]::ReadAllBytes($manual)) -ceq [Convert]::ToBase64String($utf8NoBom.GetBytes($expected.Common))) 'Elle birleştirme dosyası paket ortak baytlarıyla aynı değil.'
    }

    Invoke-Scenario 'U11 Güncelle: v0.1 kuru çalıştırmada ve uygulamada reddedilir' {
        $target = New-OldInstall 'u11'
        $path = Join-Path $target '.ai-sablon\kurulum.json'
        $record = [IO.File]::ReadAllText($path, $utf8NoBom) | ConvertFrom-Json
        $record.templateVersion = '0.1.0'
        Write-TextNoBom $path ((ConvertTo-Json -InputObject $record -Depth 8) + "`n")
        $before = Get-Snapshot $target
        foreach ($apply in @($false, $true)) {
            $result = Invoke-Guncelle $target -Apply:$apply
            Assert-True ($result.Code -eq 1) ('Çıkış kodu 1 değil: ' + $result.Code)
            Assert-True ($result.Err -match 'v0.2 öncesi') 'v0.2 öncesi uyarısı yok.'
            $difference = Compare-Snapshot $before (Get-Snapshot $target)
            Assert-True ($null -eq $difference) $difference
        }
    }

    Invoke-Scenario 'U12 Güncelle: CRLF kurulum LF paketten güncellenirken özel bölüm ve CRLF korunur' {
        $package = Join-Path $runRoot 'u12-crlf-paket'
        New-PackageCopy $package
        $rulesPath = Join-Path $package 'genel\KURALLAR.md'
        Write-TextNoBom $rulesPath ([IO.File]::ReadAllText($rulesPath, $utf8NoBom).Replace('# Çalışma kuralları', '# Çalışma kuralları (eski sürüm)'))
        Set-PackageMarkdownLineEndings $package "`r`n"
        $target = Join-Path $runRoot 'u12'
        $install = Invoke-Kur $target (Join-Path $package 'kur.ps1')
        Assert-True ($install.Code -eq 0) ('CRLF kurulumu başarısız: ' + $install.Err)
        $agentsPath = Join-Path $target 'AGENTS.md'
        Write-TextNoBom $agentsPath ([IO.File]::ReadAllText($agentsPath, $utf8NoBom) + "- Özel Türkçe kural`r`n")
        $before = Read-AgentsParts $agentsPath
        $lfPackage = Join-Path $runRoot 'u12-lf-paket'
        New-PackageCopy $lfPackage
        Set-PackageMarkdownLineEndings $lfPackage "`n"
        $expected = Read-AgentsParts (Join-Path $lfPackage 'genel\KURALLAR.md')
        Assert-True (-not $expected.Common.Contains("`r")) 'Güncelleme test paketi LF değil.'
        $result = Invoke-Guncelle $target -Apply -Script (Join-Path $lfPackage 'guncelle.ps1')
        Assert-True ($result.Code -eq 0) ('Güncelleme başarısız: ' + $result.Err)
        $after = Read-AgentsParts $agentsPath
        Assert-True ($after.Common.Replace("`r`n", "`n") -ceq $expected.Common) 'Ortak kısım yeni LF sürümle aynı değil.'
        $fullText = [IO.File]::ReadAllText($agentsPath, $utf8NoBom)
        Assert-True ($fullText.Contains("`r`n") -and -not [regex]::IsMatch($fullText, '(?<!\r)\n')) 'CRLF korunmamış veya yalın LF oluşmuş.'
        Assert-True ($before.TailBase64 -ceq $after.TailBase64) 'Özel bölümün baytları değişmiş.'
    }

    Invoke-Scenario 'U13 Güncelle: yalnız satır sonu farkı aynı sayılır ve dosya yeniden yazılmaz' {
        $package = Join-Path $runRoot 'u13-lf-paket'
        New-PackageCopy $package
        Set-PackageMarkdownLineEndings $package "`n"
        $target = Join-Path $runRoot 'u13'
        $install = Invoke-Kur $target (Join-Path $package 'kur.ps1')
        Assert-True ($install.Code -eq 0) ('Kurulum başarısız: ' + $install.Err)
        $path = Join-Path $target 'docs\YOL_HARITASI.md'
        $lfText = [IO.File]::ReadAllText($path, $utf8NoBom)
        Assert-True (-not $lfText.Contains("`r")) 'Başlangıç dosyası LF değil.'
        Write-TextNoBom $path ($lfText.Replace("`n", "`r`n"))
        $beforeHash = Get-FileSha $path
        $beforeTime = [IO.File]::GetLastWriteTimeUtc($path).Ticks
        $result = Invoke-Guncelle $target -Apply -Script (Join-Path $package 'guncelle.ps1')
        Assert-True ($result.Code -eq 0) ('Güncelleme başarısız: ' + $result.Err)
        $sameSection = [regex]::Match($result.Out, '(?ms)^Aynı \(işlem yok\) \(\d+\):\r?\n(.*?)(?=^\S|\z)').Groups[1].Value
        Assert-True ($sameSection.Contains('  docs/YOL_HARITASI.md')) 'Satır sonu farkı Aynı listesinde değil.'
        Assert-True ((Get-FileSha $path) -eq $beforeHash -and [IO.File]::GetLastWriteTimeUtc($path).Ticks -eq $beforeTime) 'Dosya yeniden yazılmış.'
        $before = Get-Snapshot $target
        $second = Invoke-Guncelle $target -Apply -Script (Join-Path $package 'guncelle.ps1')
        Assert-True ($second.Code -eq 0) ('İkinci çalıştırma başarısız: ' + $second.Err)
        $difference = Compare-Snapshot $before (Get-Snapshot $target)
        Assert-True ($null -eq $difference) $difference
    }

    Invoke-Scenario 'U14 Güncelle: kayıtta hash yokken bilinen eski sürüm yenilenir' {
        $target = New-OldInstall 'u14'
        $agentsPath = Join-Path $target 'AGENTS.md'
        Write-TextNoBom $agentsPath ([IO.File]::ReadAllText($agentsPath, $utf8NoBom) + "- özel bölüm`n")
        $before = Read-AgentsParts $agentsPath
        $recordPath = Join-Path $target '.ai-sablon\kurulum.json'
        $record = [IO.File]::ReadAllText($recordPath, $utf8NoBom) | ConvertFrom-Json
        $record.PSObject.Properties.Remove('agentsCommonSha256')
        $record.PSObject.Properties.Remove('agentsCommonLfSha256')
        Write-TextNoBom $recordPath ((ConvertTo-Json -InputObject $record -Depth 8) + "`n")
        $package = Join-Path $runRoot 'u14-paket'
        New-PackageCopy $package
        $versionPath = Join-Path $package 'surum.json'
        $version = [IO.File]::ReadAllText($versionPath, $utf8NoBom) | ConvertFrom-Json
        $version.knownAgentsCommonLfSha256 = @($version.knownAgentsCommonLfSha256) + @((Get-TextLfHash $before.Common))
        Write-TextNoBom $versionPath ((ConvertTo-Json -InputObject $version -Depth 8) + "`n")
        $result = Invoke-Guncelle $target -Apply -Script (Join-Path $package 'guncelle.ps1')
        Assert-True ($result.Code -eq 0) ('Güncelleme başarısız: ' + $result.Err)
        $after = Read-AgentsParts $agentsPath
        $expected = Read-AgentsParts (Join-Path $package 'genel\KURALLAR.md')
        Assert-True ($after.Common.Replace("`r`n", "`n") -ceq $expected.Common.Replace("`r`n", "`n")) 'Bilinen ortak kısım yenilenmemiş.'
        Assert-True ($after.TailBase64 -ceq $before.TailBase64) 'Özel bölüm değişmiş.'
        Assert-True ($result.Out -match 'bilinen eski sürüm') 'Bilinen sürüm ayrıntısı yok.'
        $record = [IO.File]::ReadAllText($recordPath, $utf8NoBom) | ConvertFrom-Json
        Assert-True ($record.agentsCommonLfSha256 -eq (Get-TextLfHash $expected.Common)) 'LF hash kayda yazılmamış.'
        Assert-True ($null -eq $record.PSObject.Properties['agentsCommonSha256']) 'Eski bayt hash alanı kalmış.'
    }

    Invoke-Scenario 'U15 Güncelle: v0.3.0 bayt hash kaydı LF hash alanına taşınır' {
        $target = New-OldInstall 'u15'
        $agentsPath = Join-Path $target 'AGENTS.md'
        $parts = Read-AgentsParts $agentsPath
        $recordPath = Join-Path $target '.ai-sablon\kurulum.json'
        $record = [IO.File]::ReadAllText($recordPath, $utf8NoBom) | ConvertFrom-Json
        $record.templateVersion = '0.3.0'
        $record.PSObject.Properties.Remove('agentsCommonLfSha256')
        $commonPath = Join-Path $runRoot 'u15-ortak-baytlar'
        Write-TextNoBom $commonPath $parts.Common
        $record | Add-Member -NotePropertyName 'agentsCommonSha256' -NotePropertyValue (Get-FileSha $commonPath) -Force
        Write-TextNoBom $recordPath ((ConvertTo-Json -InputObject $record -Depth 8) + "`n")
        $result = Invoke-Guncelle $target -Apply
        Assert-True ($result.Code -eq 0) ('Güncelleme başarısız: ' + $result.Err)
        $after = Read-AgentsParts $agentsPath
        $expected = Read-AgentsParts (Join-Path $repoRoot 'genel\KURALLAR.md')
        Assert-True ($after.Common.Replace("`r`n", "`n") -ceq $expected.Common.Replace("`r`n", "`n")) 'v0.3.0 ortak kısmı yenilenmemiş.'
        Assert-True ($parts.TailBase64 -ceq $after.TailBase64) 'Özel bölüm değişmiş.'
        $record = [IO.File]::ReadAllText($recordPath, $utf8NoBom) | ConvertFrom-Json
        Assert-True ($record.agentsCommonLfSha256 -eq (Get-TextLfHash $expected.Common)) 'LF hash alanı yanlış.'
        Assert-True ($null -eq $record.PSObject.Properties['agentsCommonSha256']) 'Eski hash alanı kaldırılmamış.'
    }

    Invoke-Scenario 'K-liste Geçersiz bilinen hash listeleri yazmadan reddedilir' {
        $package = Join-Path $runRoot 'k-liste-paket'
        New-PackageCopy $package
        $versionPath = Join-Path $package 'surum.json'
        $original = [IO.File]::ReadAllText($versionPath, $utf8NoBom)
        $validHash = $versionInfo.knownAgentsCommonLfSha256[0]
        $cases = @(
            [pscustomobject]@{ Name = 'xyz'; Value = @($versionInfo.knownAgentsCommonLfSha256) + @('xyz') },
            [pscustomobject]@{ Name = 'null'; Value = $null },
            [pscustomobject]@{ Name = 'skaler'; Value = $validHash },
            [pscustomobject]@{ Name = 'tekrar'; Value = @($validHash, $validHash) },
            [pscustomobject]@{ Name = 'buyuk-harf'; Value = @($validHash.ToUpperInvariant()) },
            [pscustomobject]@{ Name = 'sayi'; Value = @(17) },
            [pscustomobject]@{ Name = 'sinir'; Value = @(1..101 | ForEach-Object { '{0:x64}' -f $_ }) }
        )
        foreach ($case in $cases) {
            $version = $original | ConvertFrom-Json
            $version.knownAgentsCommonLfSha256 = $case.Value
            Write-TextNoBom $versionPath ((ConvertTo-Json -InputObject $version -Depth 8) + "`n")
            $target = Join-Path $runRoot ('k-liste-' + $case.Name)
            New-Item -ItemType Directory -Path $target | Out-Null
            $result = Invoke-Kur $target (Join-Path $package 'kur.ps1')
            Assert-True ($result.Code -eq 1) ($case.Name + ': geçersiz liste kabul edilmiş.')
            Assert-True ($result.Err -match 'bilinen hash listesi geçersiz') ($case.Name + ': liste hata iletisi yok.')
            Assert-True (@(Get-ChildItem -LiteralPath $target -Recurse -Force).Count -eq 0) ($case.Name + ': hedef boş değil.')
            $installed = New-OldInstall ('k-guncelle-' + $case.Name)
            $before = Get-Snapshot $installed
            $update = Invoke-Guncelle $installed -Apply -Script (Join-Path $package 'guncelle.ps1')
            Assert-True ($update.Code -eq 1 -and $update.Err -match 'bilinen hash listesi geçersiz') ($case.Name + ': güncelleyici listeyi reddetmemiş.')
            $difference = Compare-Snapshot $before (Get-Snapshot $installed)
            Assert-True ($null -eq $difference) $difference
        }
    }

    Invoke-Scenario 'U16 Güncelle: iki hash alanı varsa yalnız LF alanı kullanılır ve kullanıcı değişikliği korunur' {
        $target = New-OldInstall 'u16'
        $agentsPath = Join-Path $target 'AGENTS.md'
        $parts = Read-AgentsParts $agentsPath
        Write-TextNoBom $agentsPath ($parts.Common + "- Kullanıcının ortak kısma eklediği kural`n" + $utf8NoBom.GetString([Convert]::FromBase64String($parts.TailBase64)))
        $changed = Read-AgentsParts $agentsPath
        $commonPath = Join-Path $runRoot 'u16-ortak'
        Write-TextNoBom $commonPath $changed.Common
        $recordPath = Join-Path $target '.ai-sablon\kurulum.json'
        $record = [IO.File]::ReadAllText($recordPath, $utf8NoBom) | ConvertFrom-Json
        $oldLfHash = $record.agentsCommonLfSha256
        $record | Add-Member -NotePropertyName 'agentsCommonSha256' -NotePropertyValue (Get-FileSha $commonPath) -Force
        Write-TextNoBom $recordPath ((ConvertTo-Json -InputObject $record -Depth 8) + "`n")
        $beforeHash = Get-FileSha $agentsPath
        $result = Invoke-Guncelle $target -Apply
        Assert-True ($result.Code -eq 0) ('Güncelleme başarısız: ' + $result.Err)
        Assert-True ((Get-FileSha $agentsPath) -eq $beforeHash) 'Eşleşen eski bayt hash LF alanının önüne geçmiş.'
        $record = [IO.File]::ReadAllText($recordPath, $utf8NoBom) | ConvertFrom-Json
        Assert-True ($record.agentsCommonLfSha256 -eq $oldLfHash) 'Elle birleştirmede eski LF hash korunmamış.'
        Assert-True ($null -eq $record.PSObject.Properties['agentsCommonSha256']) 'LF alanı yazılmasına rağmen eski alan kalmış.'
    }

    Invoke-Scenario 'U17 Güncelle: aynı sürüm ve içerikte eski kayıt taşınır, AGENTS.md yeniden yazılmaz' {
        $package = Join-Path $runRoot 'u17-lf-paket'
        New-PackageCopy $package
        Set-PackageMarkdownLineEndings $package "`n"
        $target = Join-Path $runRoot 'u17'
        $install = Invoke-Kur $target (Join-Path $package 'kur.ps1')
        Assert-True ($install.Code -eq 0) ('Kurulum başarısız: ' + $install.Err)
        $recordPath = Join-Path $target '.ai-sablon\kurulum.json'
        $record = [IO.File]::ReadAllText($recordPath, $utf8NoBom) | ConvertFrom-Json
        $hash = $record.agentsCommonLfSha256
        $record.PSObject.Properties.Remove('agentsCommonLfSha256')
        $record | Add-Member -NotePropertyName 'agentsCommonSha256' -NotePropertyValue $hash -Force
        Write-TextNoBom $recordPath ((ConvertTo-Json -InputObject $record -Depth 8) + "`n")
        $agentsPath = Join-Path $target 'AGENTS.md'
        $beforeHash = Get-FileSha $agentsPath
        $beforeTime = [IO.File]::GetLastWriteTimeUtc($agentsPath).Ticks
        $result = Invoke-Guncelle $target -Apply -Script (Join-Path $package 'guncelle.ps1')
        Assert-True ($result.Code -eq 0) ('Kayıt geçişi başarısız: ' + $result.Err)
        Assert-True ((Get-FileSha $agentsPath) -eq $beforeHash -and [IO.File]::GetLastWriteTimeUtc($agentsPath).Ticks -eq $beforeTime) 'Güncel AGENTS.md yeniden yazılmış.'
        $record = [IO.File]::ReadAllText($recordPath, $utf8NoBom) | ConvertFrom-Json
        Assert-True ($record.agentsCommonLfSha256 -eq $hash -and $null -eq $record.PSObject.Properties['agentsCommonSha256']) 'Aynı hash değerinde kayıt alanı taşınmamış.'
        $before = Get-Snapshot $target
        $second = Invoke-Guncelle $target -Apply -Script (Join-Path $package 'guncelle.ps1')
        Assert-True ($second.Code -eq 0) ('İkinci çalıştırma başarısız: ' + $second.Err)
        $difference = Compare-Snapshot $before (Get-Snapshot $target)
        Assert-True ($null -eq $difference) $difference
    }

} finally {
    # Yalnız bu çalıştırmanın kendi oluşturduğu kök klasör silinir.
    foreach ($junction in $cleanupJunctions) { if (Test-Path -LiteralPath $junction) { try { [IO.Directory]::Delete($junction) } catch { } } }
    foreach ($locked in $cleanupLocked) { if (Test-Path -LiteralPath $locked) { $null = & icacls.exe $locked '/remove:d' '*S-1-1-0' } }
    $safeToRemove = $runRoot.StartsWith($tempBase + '\ai-sablon-smoke-', [StringComparison]::OrdinalIgnoreCase) -and (Test-Path -LiteralPath $runRoot)
    if ($KeepTemp) { Write-Output ('Geçici klasör korundu: ' + $runRoot) }
    elseif ($safeToRemove) { Remove-Item -LiteralPath $runRoot -Recurse -Force }
}

Write-Output ('Toplam: geçti={0} kaldı={1} atlandı={2}' -f $counts.pass, $counts.fail, $counts.skip)
if ($counts.fail -gt 0) { exit 1 }
exit 0
