[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
$repoRoot = Split-Path $PSScriptRoot -Parent
$testRoot = Join-Path ([IO.Path]::GetTempPath()) ('ai-sablon-tests-' + [Guid]::NewGuid().ToString('N'))
$shellPath = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
$utf8 = New-Object Text.UTF8Encoding($false)
$results = New-Object 'Collections.Generic.List[object]'
$caseNumber = 0
$outputFiles = @('AGENTS.md', 'CLAUDE.md', 'docs/PLAN.md', 'docs/KARARLAR.md', 'docs/GUNLUK.md', 'docs/DEVIR.md', '.ai-sablon/kontrol.ps1', '.ai-sablon/kurulum.json')
$packageFiles = @('kur.ps1', 'surum.json', 'genel/KURALLAR.md', 'sablon/docs/PLAN.md', 'sablon/docs/KARARLAR.md', 'sablon/docs/GUNLUK.md', 'sablon/docs/DEVIR.md', 'sablon/.ai-sablon/kontrol.ps1')
if ($PSVersionTable.PSVersion -lt [version]'5.1' -or -not (Test-Path -LiteralPath $shellPath -PathType Leaf)) { throw 'Mevcut Windows PowerShell 5.1 gerekir; paket kurulmaz.' }
[IO.Directory]::CreateDirectory($testRoot) | Out-Null

function Assert-True {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { throw $Message }
}

function Assert-Equal {
    param($Actual, $Expected, [string]$Message)
    if ($Actual -cne $Expected) { throw ($Message + '; beklenen: ' + $Expected + '; gözlenen: ' + $Actual) }
}

function Get-Hash {
    param([byte[]]$Bytes)
    $hasher = [Security.Cryptography.SHA256]::Create()
    try { return ([BitConverter]::ToString($hasher.ComputeHash($Bytes))).Replace('-', '').ToLowerInvariant() }
    finally { $hasher.Dispose() }
}

function Write-TestFile {
    param([string]$Path, [string]$Text, [bool]$Bom = $false)
    Assert-True ($Path.StartsWith($testRoot + '\', [StringComparison]::OrdinalIgnoreCase)) 'Test yazımı geçici test kökünün dışına çıkamaz.'
    [IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($Path)) | Out-Null
    [IO.File]::WriteAllText($Path, $Text, (New-Object Text.UTF8Encoding($Bom)))
}

function Remove-TestFile {
    param([string]$Path)
    Assert-True ($Path.StartsWith($testRoot + '\', [StringComparison]::OrdinalIgnoreCase)) 'Test silmesi geçici test kökünün dışına çıkamaz.'
    Assert-True (Test-Path -LiteralPath $Path -PathType Leaf) 'Yalnız bu testin mevcut örnek dosyası silinir.'
    [IO.File]::Delete($Path)
}

function New-TestJunction {
    param([string]$LinkPath, [string]$Destination)
    foreach ($path in @($LinkPath, $Destination)) {
        Assert-True ([IO.Path]::GetFullPath($path).StartsWith($testRoot + '\', [StringComparison]::OrdinalIgnoreCase)) 'Yönlendirme yalnız geçici test kökünde oluşturulur.'
    }
    Assert-True (Test-Path -LiteralPath $Destination -PathType Container) 'Yönlendirme hedefi örnek klasör olmalı.'
    Assert-True (-not (Test-Path -LiteralPath $LinkPath)) 'Yönlendirme mevcut dosyanın üzerine kurulamaz.'
    try { New-Item -ItemType Junction -Path $LinkPath -Target $Destination -ErrorAction Stop | Out-Null }
    catch { throw ('ATLANDI: Ortamda örnek junction oluşturulamadı: ' + $_.Exception.Message) }
}

function New-Fixture {
    $script:caseNumber++
    $folder = Join-Path $testRoot ('senaryo-' + $script:caseNumber)
    $source = Join-Path $folder 'Türkçe kaynak paket'
    $target = Join-Path $folder "Örnek Proje Şığöçü 'deneme'"
    foreach ($relativePath in $packageFiles) {
        $destination = Join-Path $source $relativePath
        [IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($destination)) | Out-Null
        [IO.File]::WriteAllBytes($destination, [IO.File]::ReadAllBytes((Join-Path $repoRoot $relativePath)))
    }
    return [pscustomobject]@{folder=$folder; source=$source; target=$target}
}

function Invoke-Script {
    param([string]$Path, [string[]]$Arguments, [hashtable]$Environment = @{})
    $startInfo = New-Object Diagnostics.ProcessStartInfo
    $startInfo.FileName = $shellPath
    $allArguments = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $Path) + $Arguments
    $startInfo.Arguments = (($allArguments | ForEach-Object { '"' + $_.Replace('"', '\"') + '"' }) -join ' ')
    $startInfo.WorkingDirectory = $testRoot
    $startInfo.UseShellExecute = $false
    $startInfo.CreateNoWindow = $true
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true
    $startInfo.StandardOutputEncoding = $utf8
    $startInfo.StandardErrorEncoding = $utf8
    foreach ($key in $Environment.Keys) { $startInfo.EnvironmentVariables[$key] = $Environment[$key] }
    $process = [Diagnostics.Process]::Start($startInfo)
    try {
        $stdoutTask = $process.StandardOutput.ReadToEndAsync()
        $stderrTask = $process.StandardError.ReadToEndAsync()
        if (-not $process.WaitForExit(30000)) { $process.Kill(); throw 'Test alt işlemi 30 saniyede tamamlanmadı.' }
        $stdout = $stdoutTask.GetAwaiter().GetResult()
        $stderr = $stderrTask.GetAwaiter().GetResult()
        return [pscustomobject]@{exitCode=$process.ExitCode; stdout=$stdout; stderr=$stderr; output=($stdout + $stderr)}
    } finally { $process.Dispose() }
}

function Install-Fixture {
    param($Fixture)
    $run = Invoke-Script (Join-Path $Fixture.source 'kur.ps1') @('-TargetDirectory', $Fixture.target)
    Assert-Equal $run.exitCode 0 $run.output
}

function Invoke-Check {
    param($Fixture, [switch]$DefaultDirectory)
    $arguments = @('-AsJson')
    if (-not $DefaultDirectory) { $arguments += @('-ProjectDirectory', $Fixture.target) }
    $run = Invoke-Script (Join-Path $Fixture.target '.ai-sablon/kontrol.ps1') $arguments
    $data = $run.stdout | ConvertFrom-Json
    return [pscustomobject]@{exitCode=$run.exitCode; data=$data; output=$run.output}
}

function Assert-Code {
    param($Check, [string]$Code, [bool]$Present = $true)
    $found = @($Check.data.findings | Where-Object { $_.code -eq $Code }).Count -gt 0
    Assert-Equal $found $Present ('Denetim bulgusu: ' + $Code)
}

function Get-Snapshot {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return '<yok>' }
    $entries = @(Get-ChildItem -LiteralPath $Path -Recurse -Force | Sort-Object FullName | ForEach-Object {
        $relativePath = $_.FullName.Substring($Path.Length)
        if ($_.PSIsContainer) { 'D ' + $relativePath }
        else { 'F ' + $relativePath + ' ' + (Get-Hash ([IO.File]::ReadAllBytes($_.FullName))) }
    })
    return ($entries -join [Environment]::NewLine)
}

function Set-Record {
    param($Fixture, [scriptblock]$Change)
    $path = Join-Path $Fixture.target '.ai-sablon/kurulum.json'
    $record = [IO.File]::ReadAllText($path) | ConvertFrom-Json
    & $Change $record
    Write-TestFile $path (ConvertTo-Json -InputObject $record -Depth 8)
}

function Set-Plan {
    param($Fixture, [string]$Id = '1.1', [string]$Status = 'Doğrulandı')
    $path = Join-Path $Fixture.target 'docs/PLAN.md'
    $text = [IO.File]::ReadAllText($path)
    $text = $text.Replace('- Güncel çalışma birimi: Henüz seçilmedi.', '- Güncel çalışma birimi: ' + $Id)
    $row = '| ' + $Id + ' | Sentetik iş | Sentetik kabul ölçütü | Örnek kontrol | ' + $Status + ' |'
    $text = $text.Replace('|---|---|---|---|---|', '|---|---|---|---|---|' + [Environment]::NewLine + $row)
    Write-TestFile $path $text
}

function Set-Handoff {
    param($Fixture, [string]$Id = '1.1')
    $path = Join-Path $Fixture.target 'docs/DEVIR.md'
    $text = [IO.File]::ReadAllText($path)
    $text = $text.Replace('- Güncel çalışma birimi: Henüz seçilmedi.', '- Güncel çalışma birimi: ' + $Id)
    $text = $text.Replace('- Kayıt zamanı: Henüz proje oturumu başlamadı.', '- Kayıt zamanı: 2020-01-02 03:04.')
    Write-TestFile $path $text
}

function Add-Log {
    param($Fixture, [string]$Id = '1.1')
    $lines = @(
        '## 2020-01-02 03:04 — Sentetik çalışma kaydı',
        '',
        ('- Çalışma birimi: ' + $Id),
        '- Yapılan iş ve nedeni: Yalnız denetim testinin örnek verisi.',
        '- Değişen dosyalar: Örnek belge.',
        '- Doğrulama: örnek-komut; sentetik sonuç. Gerçek ürün testi çalıştırıldığı iddia edilmez.',
        '- Başarısız: yok.',
        '- Atlanan: yok.',
        '- Çalıştırılamayan: yok.'
    )
    $path = Join-Path $Fixture.target 'docs/GUNLUK.md'
    Write-TestFile $path ([IO.File]::ReadAllText($path) + [Environment]::NewLine + ($lines -join [Environment]::NewLine) + [Environment]::NewLine)
}

function Test-Case {
    param([string]$Name, [scriptblock]$Body)
    try {
        & $Body
        $results.Add([pscustomobject]@{name=$Name; status='passed'; detail=''})
        Write-Output ('GEÇTİ: ' + $Name)
    } catch {
        if ($_.Exception.Message.StartsWith('ATLANDI:')) {
            $results.Add([pscustomobject]@{name=$Name; status='skipped'; detail=$_.Exception.Message})
            Write-Output ('ATLANDI: ' + $Name + ' — ' + $_.Exception.Message)
        } else {
            $results.Add([pscustomobject]@{name=$Name; status='failed'; detail=$_.Exception.Message})
            Write-Output ('BAŞARISIZ: ' + $Name + ' — ' + $_.Exception.Message)
        }
    }
}

Test-Case 'Üç betik geçerli PowerShell ve UTF-8 BOM içerir' {
    foreach ($relativePath in @('kur.ps1', 'sablon/.ai-sablon/kontrol.ps1', 'tests/Kurulum.Tests.ps1')) {
        $path = Join-Path $repoRoot $relativePath
        $bytes = [IO.File]::ReadAllBytes($path)
        Assert-Equal ($bytes[0..2] -join ' ') '239 187 191' ($relativePath + ' BOM')
        $tokens = $null
        $parseErrors = $null
        [Management.Automation.Language.Parser]::ParseFile($path, [ref]$tokens, [ref]$parseErrors) | Out-Null
        Assert-Equal @($parseErrors).Count 0 ($relativePath + ' ayrıştırma')
    }
}

Test-Case 'Yeni Türkçe/boşluklu hedefe 8 dosya ve doğru özetler kurulur' {
    $f = New-Fixture
    Install-Fixture $f
    Assert-Equal @(Get-ChildItem -LiteralPath $f.target -Recurse -Force -File).Count 8 'Kurulan dosya sayısı'
    $record = [IO.File]::ReadAllText((Join-Path $f.target '.ai-sablon/kurulum.json')) | ConvertFrom-Json
    Assert-Equal $record.templateVersion '0.1.0' 'Şablon sürümü'
    Assert-Equal $record.packageStatus 'development' 'Paket durumu'
    Assert-Equal @($record.sourceFiles).Count 8 'Kaynak sayısı'
    Assert-Equal @($record.installedFiles).Count 7 'Özetli çıktı sayısı'
    Assert-Equal ($record.pendingFeatures -join ',') 'editor-behavior-validation' 'Bekleyen bileşen'
    foreach ($entry in $record.sourceFiles) { Assert-Equal (Get-Hash ([IO.File]::ReadAllBytes((Join-Path $f.source $entry.path)))) $entry.sha256 'Kaynak özeti' }
    foreach ($entry in $record.installedFiles) { Assert-Equal (Get-Hash ([IO.File]::ReadAllBytes((Join-Path $f.target $entry.path)))) $entry.sha256 'Kurulan dosya özeti' }
    Assert-True (-not (Test-Path -LiteralPath (Join-Path $f.target 'genel'))) 'Kaynak deponun klasörü hedefe taşınamaz.'
    Assert-True (-not (Test-Path -LiteralPath (Join-Path $f.target 'tests'))) 'Ürün test betiği hedefe taşınamaz.'
}

Test-Case 'Mevcut boş hedef ve ilgisiz proje dosyaları korunur' {
    $f = New-Fixture
    Write-TestFile (Join-Path $f.target 'README.md') 'Kullanıcının belgesi'
    Write-TestFile (Join-Path $f.target 'src/app.txt') 'Kullanıcının dosyası'
    Install-Fixture $f
    Assert-Equal ([IO.File]::ReadAllText((Join-Path $f.target 'README.md'))) 'Kullanıcının belgesi' 'README korunması'
    Assert-Equal ([IO.File]::ReadAllText((Join-Path $f.target 'src/app.txt'))) 'Kullanıcının dosyası' 'Ürün dosyası korunması'
}

Test-Case 'İkinci kurulum hiçbir dosyayı değiştirmez' {
    $f = New-Fixture
    Install-Fixture $f
    $before = Get-Snapshot $f.target
    $run = Invoke-Script (Join-Path $f.source 'kur.ps1') @('-TargetDirectory', $f.target)
    Assert-Equal $run.exitCode 1 'İkinci kurulum çıkışı'
    Assert-Equal (Get-Snapshot $f.target) $before 'İkinci kurulumda değişiklik'
}

foreach ($relativePath in $outputFiles) {
    Test-Case ('Çakışmada yazmama: ' + $relativePath) {
        $f = New-Fixture
        Write-TestFile (Join-Path $f.target $relativePath) 'Mevcut kullanıcı dosyası'
        $before = Get-Snapshot $f.target
        $run = Invoke-Script (Join-Path $f.source 'kur.ps1') @('-TargetDirectory', $f.target)
        Assert-Equal $run.exitCode 1 'Çakışma çıkışı'
        Assert-Equal (Get-Snapshot $f.target) $before 'Çakışmada dosyaya yazıldı'
    }
}

Test-Case 'Birden çok çakışma birlikte bildirilir' {
    $f = New-Fixture
    foreach ($name in @('AGENTS.md', 'docs/PLAN.md')) { Write-TestFile (Join-Path $f.target $name) 'Mevcut' }
    $before = Get-Snapshot $f.target
    $run = Invoke-Script (Join-Path $f.source 'kur.ps1') @('-TargetDirectory', $f.target)
    Assert-Equal $run.exitCode 1 'Çoklu çakışma çıkışı'
    Assert-True ($run.output.Contains((Join-Path $f.target 'AGENTS.md')) -and $run.output.Contains((Join-Path $f.target 'docs/PLAN.md'))) 'İki çakışma birlikte bildirilmeli.'
    Assert-Equal (Get-Snapshot $f.target) $before 'Çoklu çakışmada değişiklik'
}

Test-Case 'Kaynak paket içine kurulum reddedilir' {
    $f = New-Fixture
    $before = Get-Snapshot $f.source
    $run = Invoke-Script (Join-Path $f.source 'kur.ps1') @('-TargetDirectory', (Join-Path $f.source 'alt'))
    Assert-Equal $run.exitCode 1 'Kaynak içine kurulum'
    Assert-Equal (Get-Snapshot $f.source) $before 'Kaynak pakette değişiklik'
}

Test-Case 'Geçici CODEX_HOME hedefi reddedilir; global dosya kullanılmaz' {
    $f = New-Fixture
    $configuredRoot = Join-Path $f.folder 'sahte-global'
    $run = Invoke-Script (Join-Path $f.source 'kur.ps1') @('-TargetDirectory', $configuredRoot) @{CODEX_HOME=$configuredRoot}
    Assert-Equal $run.exitCode 1 'Global yol koruması'
    Assert-True (-not (Test-Path -LiteralPath $configuredRoot)) 'Korunan örnek yol oluşturulamaz.'
}

Test-Case 'Eksik kontrol kaynağı yazmadan reddedilir' {
    $f = New-Fixture
    Remove-TestFile (Join-Path $f.source 'sablon/.ai-sablon/kontrol.ps1')
    $run = Invoke-Script (Join-Path $f.source 'kur.ps1') @('-TargetDirectory', $f.target)
    Assert-Equal $run.exitCode 1 'Eksik kontrol kaynağı'
    Assert-True (-not (Test-Path -LiteralPath $f.target)) 'Kaynak eksikse hedef oluşturulamaz.'
}

Test-Case 'Kısmi yazma hatasında oluşan dosya bildirilir' {
    $f = New-Fixture
    $path = Join-Path $f.source 'kur.ps1'
    $scriptText = [IO.File]::ReadAllText($path)
    $anchor = '    $stream = New-Object IO.FileStream'
    Assert-True ($scriptText.Contains($anchor)) 'Hata simülasyonu noktası bulunmalı.'
    $fault = "    if (" + '$Path.EndsWith(' + "'\docs\PLAN.md')) { throw (New-Object IO.IOException('Benzetilmiş yazma hatası')) }"
    Write-TestFile $path ($scriptText.Replace($anchor, $fault + [Environment]::NewLine + $anchor)) $true
    $run = Invoke-Script $path @('-TargetDirectory', $f.target)
    Assert-Equal $run.exitCode 1 'Kısmi hata çıkışı'
    Assert-True ($run.output.Contains('Tamamlanmamış işlem') -and $run.output.Contains((Join-Path $f.target 'AGENTS.md'))) 'Oluşan dosya bildirilmeli.'
    Assert-True (Test-Path -LiteralPath (Join-Path $f.target 'AGENTS.md')) 'Otomatik silme yapılamaz.'
    Assert-True (-not (Test-Path -LiteralPath (Join-Path $f.target '.ai-sablon/kurulum.json'))) 'Kısmi hata başarı kaydı oluşturamaz.'
}

Test-Case 'Temiz başlangıç örnek alanları gerçek kayıt sayılmaz' {
    $f = New-Fixture
    Install-Fixture $f
    $check = Invoke-Check $f -DefaultDirectory
    Assert-Equal $check.exitCode 2 'Geliştirme paketi uyarı çıkışı'
    Assert-Equal $check.data.errors 0 'Temiz başlangıç hatası'
    Assert-Equal $check.data.warnings 2 'Yalnız geliştirme/araç denemesi uyarıları'
    Assert-Code $check 'I_STARTUP'
    Assert-Code $check 'W_LOG_MISSING' $false
    Assert-Code $check 'W_LOG_FIELDS' $false
    Assert-Code $check 'W_DECISION_FIELDS' $false
}

Test-Case 'Denetim salt okunurdur ve Git deposu oluşturmaz' {
    $f = New-Fixture
    Install-Fixture $f
    $before = Get-Snapshot $f.target
    $check = Invoke-Check $f
    Assert-Equal $check.data.errors 0 'Salt okunur denetim'
    Assert-Equal (Get-Snapshot $f.target) $before 'Denetim dosya değiştirdi'
    Assert-True (-not (Test-Path -LiteralPath (Join-Path $f.target '.git'))) 'Denetim Git oluşturamaz.'
    Assert-Code $check 'I_LIMITS'
}

foreach ($relativePath in $outputFiles) {
    Test-Case ('Eksik zorunlu dosya bulunur: ' + $relativePath) {
        $f = New-Fixture
        Install-Fixture $f
        $checkerPath = Join-Path $f.source 'sablon/.ai-sablon/kontrol.ps1'
        Remove-TestFile (Join-Path $f.target $relativePath)
        $run = Invoke-Script $checkerPath @('-ProjectDirectory', $f.target, '-AsJson')
        $data = $run.stdout | ConvertFrom-Json
        Assert-Equal $run.exitCode 1 'Eksik dosya hata çıkışı'
        Assert-True (@($data.findings | Where-Object { $_.code -eq 'E_MISSING_FILE' }).Count -gt 0) 'Eksik dosya bulgusu gerekli.'
    }
}

Test-Case 'Bozuk kurulum JSON kaydı bulunur' {
    $f = New-Fixture; Install-Fixture $f
    Write-TestFile (Join-Path $f.target '.ai-sablon/kurulum.json') '{bozuk'
    $check = Invoke-Check $f
    Assert-Equal $check.exitCode 1 'Bozuk JSON çıkışı'
    Assert-Code $check 'E_METADATA'
}

Test-Case 'Sürüm alanı ve saat dilimsiz tarih reddedilir' {
    $f = New-Fixture; Install-Fixture $f
    Set-Record $f { param($r) $r.templateVersion = 'bilinmiyor' }
    $check = Invoke-Check $f; Assert-Code $check 'E_METADATA'
    Set-Record $f { param($r) $r.templateVersion = '0.1.0'; $r.installedAt = '2020-01-02' }
    $check = Invoke-Check $f; Assert-Code $check 'E_METADATA'
}

Test-Case 'Tekrarlı veya proje dışı metadata yolu reddedilir' {
    $f = New-Fixture; Install-Fixture $f
    Set-Record $f { param($r) $r.installedFiles[1].path = $r.installedFiles[0].path }
    $check = Invoke-Check $f; Assert-Code $check 'E_METADATA_FILES'
    Set-Record $f { param($r) $r.installedFiles[1].path = '../dışarı.md' }
    $check = Invoke-Check $f; Assert-Code $check 'E_METADATA_FILES'
}

Test-Case 'Bozuk kaynak SHA-256 alanı reddedilir' {
    $f = New-Fixture; Install-Fixture $f
    Set-Record $f { param($r) $r.sourceFiles[0].sha256 = 'yanlış' }
    $check = Invoke-Check $f
    Assert-Equal $check.exitCode 1 'Bozuk özet çıkışı'
    Assert-Code $check 'E_METADATA_FILES'
}

Test-Case 'Kaynak ve kopyalanan çıktının tarihsel özetleri eşleşmeli' {
    $f = New-Fixture; Install-Fixture $f
    Set-Record $f { param($r) $r.sourceFiles[0].sha256 = ('b' * 64) }
    $check = Invoke-Check $f
    Assert-Equal $check.exitCode 1 'Tutarsız tarihsel özet çıkışı'
    Assert-Code $check 'E_METADATA_HASH_PAIR'
}

Test-Case 'Kaydın kendisi installedFiles listesine eklenemez' {
    $f = New-Fixture; Install-Fixture $f
    Set-Record $f { param($r) $r.installedFiles += [pscustomobject]@{path='.ai-sablon/kurulum.json'; sha256=('a' * 64)} }
    $check = Invoke-Check $f; Assert-Code $check 'E_METADATA_FILES'
}

Test-Case 'Release kaydı bekleyen bileşen içeremez' {
    $f = New-Fixture; Install-Fixture $f
    Set-Record $f { param($r) $r.packageStatus = 'release' }
    $check = Invoke-Check $f
    Assert-Equal $check.exitCode 1 'Tutarsız release çıkışı'
    Assert-Code $check 'E_METADATA'
}

Test-Case 'Sentetik tamamlanmış paket kaydında temiz denetim çıkışı 0 olur' {
    $f = New-Fixture; Install-Fixture $f
    Set-Record $f { param($r) $r.packageStatus = 'release'; $r.pendingFeatures = @() }
    $check = Invoke-Check $f
    Assert-Equal $check.exitCode 0 'Sentetik PASS çıkışı'
    Assert-Equal $check.data.status 'PASS' 'Sentetik PASS durumu'
}

Test-Case 'Proje belgelerinin normal düzenlenmesi hash hatası olmaz' {
    $f = New-Fixture; Install-Fixture $f
    Set-Plan $f '7.12.3' 'Doğrulandı'; Set-Handoff $f '7.12.3'; Add-Log $f '7.12.3'
    Write-TestFile (Join-Path $f.target 'AGENTS.md') ([IO.File]::ReadAllText((Join-Path $f.target 'AGENTS.md')) + [Environment]::NewLine + 'Projeye özel açıklama.')
    $check = Invoke-Check $f
    Assert-Equal $check.data.errors 0 'Normal proje düzenlemesi'
    Assert-Equal $check.data.warnings 2 'Eksik kayıt uyarısı olmamalı'
    Assert-Code $check 'I_UPDATED_FILES'
    Assert-Code $check 'W_LOG_MISSING' $false
    Assert-Code $check 'W_LOG_FIELDS' $false
    Assert-Code $check 'W_HANDOFF_STEP' $false
}

Test-Case 'Planlanan adım için tamamlanmış çalışma kaydı istenmez' {
    $f = New-Fixture; Install-Fixture $f
    Set-Plan $f '5.14' 'Planlandı'; Set-Handoff $f '5.14'
    $check = Invoke-Check $f; Assert-Code $check 'W_LOG_MISSING' $false
}

Test-Case 'Doğrulanmış adımın eksik Günlük kaydı bulunur' {
    $f = New-Fixture; Install-Fixture $f
    Set-Plan $f; Set-Handoff $f
    $check = Invoke-Check $f
    Assert-Equal $check.exitCode 2 'Eksik kayıt uyarı çıkışı'
    Assert-Code $check 'W_LOG_MISSING'
}

Test-Case 'Yanlış adımın günlüğü eksik kaydı karşılamaz' {
    $f = New-Fixture; Install-Fixture $f
    Set-Plan $f; Set-Handoff $f; Add-Log $f '8.4'
    $check = Invoke-Check $f; Assert-Code $check 'W_LOG_MISSING'
}

Test-Case 'Genel planlama günlüğü sayısal alt adım olmadan geçerlidir' {
    $f = New-Fixture; Install-Fixture $f
    Add-Log $f 'Genel yol haritası; uygulama alt adımı seçilmedi.'
    $check = Invoke-Check $f
    Assert-Equal $check.data.errors 0 'Genel görüşme kaydı hata değildir'
    Assert-Equal $check.data.warnings 2 'Yalnız geliştirme ve araç denemesi uyarıları kalmalı'
    Assert-Code $check 'W_LOG_FIELDS' $false
}

Test-Case 'Genel planlama kaydında da eksik doğrulama alanı bulunur' {
    $f = New-Fixture; Install-Fixture $f
    Add-Log $f 'Genel yol haritası'
    $path = Join-Path $f.target 'docs/GUNLUK.md'
    Write-TestFile $path ([IO.File]::ReadAllText($path).Replace('- Doğrulama: örnek-komut;', '- Eksik alan: örnek-komut;'))
    $check = Invoke-Check $f
    Assert-Code $check 'W_LOG_FIELDS'
    $fieldFindings = @($check.data.findings | Where-Object { $_.code -eq 'W_LOG_FIELDS' })
    Assert-Equal $fieldFindings.Count 1 'Yalnız eksik doğrulama bildirilir'
    Assert-True ($fieldFindings[0].message.Contains('alan eksik: Doğrulama')) 'Doğrulama alanı doğru adla bildirilir'
}

Test-Case 'Genel görüşme kaydı tamamlanan alt adımın günlüğünü karşılamaz' {
    $f = New-Fixture; Install-Fixture $f
    Set-Plan $f; Set-Handoff $f; Add-Log $f 'Genel yol haritası'
    $check = Invoke-Check $f
    Assert-Code $check 'W_LOG_MISSING'
    Assert-Code $check 'W_LOG_FIELDS' $false
}

Test-Case 'Eksik çalışma birimi diğer dolu alanlarla geçerli sayılmaz' {
    $f = New-Fixture; Install-Fixture $f
    Add-Log $f 'Genel yol haritası'
    $path = Join-Path $f.target 'docs/GUNLUK.md'
    Write-TestFile $path ([IO.File]::ReadAllText($path).Replace('- Çalışma birimi: Genel yol haritası', '- Eksik birim: Genel yol haritası'))
    $check = Invoke-Check $f
    Assert-Code $check 'W_LOG_FIELDS'
}

Test-Case 'Gerçek kayıtta eksik doğrulama alanı bulunur' {
    $f = New-Fixture; Install-Fixture $f
    Set-Plan $f; Set-Handoff $f; Add-Log $f
    $path = Join-Path $f.target 'docs/GUNLUK.md'
    Write-TestFile $path ([IO.File]::ReadAllText($path).Replace('- Doğrulama: örnek-komut;', '- Eksik alan: örnek-komut;'))
    $check = Invoke-Check $f; Assert-Code $check 'W_LOG_FIELDS'
}

Test-Case 'Boş doğrulama alanı sonraki satırın içeriğiyle dolmuş sayılmaz' {
    $f = New-Fixture; Install-Fixture $f
    Set-Plan $f; Set-Handoff $f; Add-Log $f
    $path = Join-Path $f.target 'docs/GUNLUK.md'
    $text = [regex]::Replace([IO.File]::ReadAllText($path), '(?m)^- Doğrulama: örnek-komut;[^\r\n]*', '- Doğrulama:   ')
    Write-TestFile $path $text
    $check = Invoke-Check $f; Assert-Code $check 'W_LOG_FIELDS'
}

Test-Case 'Devirde yanlış adım ve eksik tarih bulunur' {
    $f = New-Fixture; Install-Fixture $f
    Set-Plan $f; Add-Log $f
    $check = Invoke-Check $f
    Assert-Code $check 'W_HANDOFF_STEP'
    Assert-Code $check 'W_HANDOFF_TIME'
}

Test-Case 'Eksik kabul ölçütü ve tekrarlı plan satırı bulunur' {
    $f = New-Fixture; Install-Fixture $f
    Set-Plan $f; Set-Handoff $f; Add-Log $f
    $path = Join-Path $f.target 'docs/PLAN.md'
    $text = [IO.File]::ReadAllText($path).Replace('| Sentetik kabul ölçütü |', '| |')
    $text = $text.Replace('|---|---|---|---|---|', '|---|---|---|---|---|' + [Environment]::NewLine + '| 1.1 | İş | Kabul | Kontrol | Planlandı |')
    Write-TestFile $path $text
    $check = Invoke-Check $f
    Assert-Code $check 'W_PLAN_FIELDS'
    Assert-Code $check 'W_PLAN_FORMAT'
}

Test-Case 'Gerçek kararda eksik gerekçe bulunur' {
    $f = New-Fixture; Install-Fixture $f
    $path = Join-Path $f.target 'docs/KARARLAR.md'
    $entry = @('', '## K-001 — Sentetik karar', '', '- Karar: Örnek yaklaşım.', '- Etki: Örnek adım.') -join [Environment]::NewLine
    Write-TestFile $path ([IO.File]::ReadAllText($path) + $entry)
    $check = Invoke-Check $f; Assert-Code $check 'W_DECISION_FIELDS'
}

Test-Case 'Bozuk yerel bağlantı hata verir; dış URL için ağ kullanılmaz' {
    $f = New-Fixture; Install-Fixture $f
    $path = Join-Path $f.target 'docs/PLAN.md'
    $extra = @('', '[Eksik](eksik.md)', '[Ağ yok](https://example.invalid/çalışmayan)', '') -join [Environment]::NewLine
    Write-TestFile $path ([IO.File]::ReadAllText($path) + $extra)
    $check = Invoke-Check $f
    Assert-Equal $check.data.errors 1 'Yalnız yerel bağlantı hata vermeli'
    Assert-Code $check 'E_BROKEN_LINK'
}

Test-Case 'Kod bloğundaki örnek bağlantı gerçek bağlantı sayılmaz' {
    $f = New-Fixture; Install-Fixture $f
    $path = Join-Path $f.target 'docs/PLAN.md'
    $fence = ([string][char]96) * 3
    $extra = @('', $fence + 'text', '[Örnek](yok.md)', $fence, '') -join [Environment]::NewLine
    Write-TestFile $path ([IO.File]::ReadAllText($path) + $extra)
    $check = Invoke-Check $f; Assert-Code $check 'E_BROKEN_LINK' $false
}

Test-Case 'Kod bloklarındaki örnek Günlük ve Kararlar gerçek kayıt sayılmaz' {
    $f = New-Fixture; Install-Fixture $f
    Set-Plan $f; Set-Handoff $f
    $fence = '~~~'
    $entry = @('', $fence, '## 2020-01-02 03:04 — Örnek', '- Çalışma birimi: 1.1', $fence, '') -join [Environment]::NewLine
    $path = Join-Path $f.target 'docs/GUNLUK.md'
    Write-TestFile $path ([IO.File]::ReadAllText($path) + $entry)
    $entry = @('', $fence, '## K-001 — Örnek', '- Karar: Örnek.', $fence, '') -join [Environment]::NewLine
    $path = Join-Path $f.target 'docs/KARARLAR.md'
    Write-TestFile $path ([IO.File]::ReadAllText($path) + $entry)
    $check = Invoke-Check $f
    Assert-Code $check 'W_LOG_MISSING'
    Assert-Code $check 'W_LOG_FIELDS' $false
    Assert-Code $check 'W_DECISION_FIELDS' $false
}

Test-Case 'Proje dışı göreli ve mutlak yerel bağlantı okunmadan uyarılır' {
    $f = New-Fixture; Install-Fixture $f
    $path = Join-Path $f.target 'docs/PLAN.md'
    $absolutePath = (Join-Path $f.folder 'dışarı.md').Replace('\', '/')
    $extra = @('', '[Dışarı](../../dışarı.md)', ('[Mutlak dışarı](<' + $absolutePath + '>)')) -join [Environment]::NewLine
    Write-TestFile $path ([IO.File]::ReadAllText($path) + $extra)
    $check = Invoke-Check $f
    Assert-Equal $check.data.errors 0 'Dışarıdaki dosya hata için aranamaz'
    Assert-Equal @($check.data.findings | Where-Object { $_.code -eq 'W_EXTERNAL_LINK' }).Count 2 'İki dış yerel bağlantı uyarısı'
}

Test-Case 'Proje içi mutlak yerel bağlantı doğru çözülür' {
    $f = New-Fixture; Install-Fixture $f
    $path = Join-Path $f.target 'docs/PLAN.md'
    $absolutePath = (Join-Path $f.target 'docs/DEVIR.md').Replace('\', '/')
    Write-TestFile $path ([IO.File]::ReadAllText($path) + [Environment]::NewLine + '[Devir](<' + $absolutePath + '>)')
    $check = Invoke-Check $f
    Assert-Equal $check.data.errors 0 'Proje içi mutlak bağlantı'
    Assert-Code $check 'W_EXTERNAL_LINK' $false
}

Test-Case 'CLAUDE içe aktarımı yanlışsa bulunur' {
    $f = New-Fixture; Install-Fixture $f
    Write-TestFile (Join-Path $f.target 'CLAUDE.md') '@YANLIS.md'
    $check = Invoke-Check $f; Assert-Code $check 'E_CLAUDE_IMPORT'
}

Test-Case 'Markdown BOM ve kontrol betiği BOM eksikliği bulunur' {
    $f = New-Fixture; Install-Fixture $f
    $path = Join-Path $f.target 'docs/PLAN.md'
    Write-TestFile $path ([IO.File]::ReadAllText($path)) $true
    $checker = Join-Path $f.target '.ai-sablon/kontrol.ps1'
    Write-TestFile $checker ([IO.File]::ReadAllText($checker)) $false
    $run = Invoke-Script (Join-Path $f.source 'sablon/.ai-sablon/kontrol.ps1') @('-ProjectDirectory', $f.target, '-AsJson')
    $data = $run.stdout | ConvertFrom-Json
    Assert-Equal $run.exitCode 1 'BOM hatası çıkışı'
    Assert-Equal @($data.findings | Where-Object { $_.code -eq 'E_FILE_READ' }).Count 2 'İki BOM hatası'
}

foreach ($parentEntry in @('docs', '.ai-sablon')) {
    Test-Case ('Üst klasör dosyaysa hiçbir şey yazılmaz: ' + $parentEntry) {
        $f = New-Fixture
        Write-TestFile (Join-Path $f.target $parentEntry) 'Kullanıcının dosyası'
        $before = Get-Snapshot $f.target
        $run = Invoke-Script (Join-Path $f.source 'kur.ps1') @('-TargetDirectory', $f.target)
        Assert-Equal $run.exitCode 1 'Üst klasör çakışması'
        Assert-Equal (Get-Snapshot $f.target) $before 'Üst klasör çakışmasında değişiklik'
    }
}

Test-Case 'Yönlendirilmiş hedef kurucu ve denetim tarafından izlenmez' {
    $f = New-Fixture
    $destination = Join-Path $f.folder 'örnek-gerçek-hedef'
    Write-TestFile (Join-Path $destination 'korunacak.txt') 'Örnek veri'
    New-TestJunction $f.target $destination
    $before = Get-Snapshot $destination
    $run = Invoke-Script (Join-Path $f.source 'kur.ps1') @('-TargetDirectory', $f.target)
    Assert-Equal $run.exitCode 1 'Yönlendirilmiş hedef kurulum çıkışı'
    $run = Invoke-Script (Join-Path $f.source 'sablon/.ai-sablon/kontrol.ps1') @('-ProjectDirectory', $f.target, '-AsJson')
    $data = $run.stdout | ConvertFrom-Json
    Assert-Equal $run.exitCode 1 'Yönlendirilmiş hedef denetim çıkışı'
    Assert-True (@($data.findings | Where-Object { $_.code -eq 'E_PROJECT' }).Count -gt 0) 'Yönlendirilmiş proje kökü reddedilmeli.'
    Assert-Equal (Get-Snapshot $destination) $before 'Yönlendirilmiş hedefte değişiklik'
}

Test-Case 'Yönlendirilmiş kaynak belgesi kurulumda izlenmez' {
    $f = New-Fixture
    $original = Join-Path $f.source 'sablon/docs'
    $moved = Join-Path $f.folder 'örnek-belgeler'
    Assert-True ($original.StartsWith($testRoot + '\') -and $moved.StartsWith($testRoot + '\')) 'Taşınan test klasörleri doğrulanmış geçici kökte kalır.'
    [IO.Directory]::Move($original, $moved)
    New-TestJunction $original $moved
    $before = Get-Snapshot $moved
    $run = Invoke-Script (Join-Path $f.source 'kur.ps1') @('-TargetDirectory', $f.target)
    Assert-Equal $run.exitCode 1 'Yönlendirilmiş kaynak çıkışı'
    Assert-True (-not (Test-Path -LiteralPath $f.target)) 'Yönlendirilmiş kaynakta hedef oluşturulamaz.'
    Assert-Equal (Get-Snapshot $moved) $before 'Yönlendirilmiş kaynakta değişiklik'
}

Test-Case 'Denetim yönlendirilmiş docs klasörünün belgelerini okumaz' {
    $f = New-Fixture; Install-Fixture $f
    $original = Join-Path $f.target 'docs'
    $moved = Join-Path $f.folder 'örnek-kayıtlar'
    Assert-True ($original.StartsWith($testRoot + '\') -and $moved.StartsWith($testRoot + '\')) 'Taşınan test klasörleri doğrulanmış geçici kökte kalır.'
    [IO.Directory]::Move($original, $moved)
    New-TestJunction $original $moved
    $before = Get-Snapshot $moved
    $check = Invoke-Check $f
    Assert-Equal $check.exitCode 1 'Yönlendirilmiş belge çıkışı'
    Assert-Code $check 'E_FILE_READ'
    Assert-Equal (Get-Snapshot $moved) $before 'Yönlendirilmiş belgede değişiklik'
}

foreach ($closing in @('uzun', 'yok')) {
    Test-Case ('Örnek kayıt uzun/kapanışsız kod çitinde gerçek sayılmaz: ' + $closing) {
        $f = New-Fixture; Install-Fixture $f
        Set-Plan $f; Set-Handoff $f
        $fence = ([string][char]96) * 3
        $lines = @('', $fence, '## 2020-01-02 03:04 — Örnek', '- Çalışma birimi: 1.1')
        if ($closing -eq 'uzun') { $lines += ($fence + [char]96) }
        $path = Join-Path $f.target 'docs/GUNLUK.md'
        Write-TestFile $path ([IO.File]::ReadAllText($path) + ($lines -join [Environment]::NewLine))
        $check = Invoke-Check $f
        Assert-Code $check 'W_LOG_MISSING'
        Assert-Code $check 'W_LOG_FIELDS' $false
    }
}

Test-Case 'HTML yorumundaki kod çiti sonraki gerçek kaydı gizlemez' {
    $f = New-Fixture; Install-Fixture $f
    Set-Plan $f; Set-Handoff $f; Add-Log $f
    $path = Join-Path $f.target 'docs/GUNLUK.md'
    $fence = ([string][char]96) * 3
    $header = '## 2020-01-02 03:04 — Sentetik çalışma kaydı'
    $prefix = @('<!--', ($fence + 'text'), '-->', $header) -join [Environment]::NewLine
    Write-TestFile $path ([IO.File]::ReadAllText($path).Replace($header, $prefix))
    $check = Invoke-Check $f
    Assert-Code $check 'W_LOG_MISSING' $false
    Assert-Code $check 'W_LOG_FIELDS' $false
}

Test-Case 'Kod bloğundaki HTML yorum açılışı sonraki gerçek kaydı gizlemez' {
    $f = New-Fixture; Install-Fixture $f
    Set-Plan $f; Set-Handoff $f; Add-Log $f
    $path = Join-Path $f.target 'docs/GUNLUK.md'
    $fence = ([string][char]96) * 3
    $header = '## 2020-01-02 03:04 — Sentetik çalışma kaydı'
    $prefix = @($fence, '<!--', $fence, $header) -join [Environment]::NewLine
    Write-TestFile $path ([IO.File]::ReadAllText($path).Replace($header, $prefix) + [Environment]::NewLine + '-->')
    $check = Invoke-Check $f
    Assert-Code $check 'W_LOG_MISSING' $false
    Assert-Code $check 'W_LOG_FIELDS' $false
}

$passed = @($results | Where-Object { $_.status -eq 'passed' }).Count
$failed = @($results | Where-Object { $_.status -eq 'failed' }).Count
$skipped = @($results | Where-Object { $_.status -eq 'skipped' }).Count
$summary = [ordered]@{powershellVersion=$PSVersionTable.PSVersion.ToString(); testRoot=$testRoot; total=$results.Count; passed=$passed; failed=$failed; skipped=$skipped; results=$results.ToArray()}
$resultPath = Join-Path $testRoot 'SONUCLAR.json'
[IO.File]::WriteAllText($resultPath, (ConvertTo-Json -InputObject $summary -Depth 6), $utf8)
Write-Output ('Toplam: ' + $results.Count + '; geçen: ' + $passed + '; başarısız: ' + $failed + '; atlanan: ' + $skipped)
Write-Output ('Geçici örnekler ve sonuç kaydı: ' + $resultPath)
Write-Output 'Global ayar/skill dosyaları değiştirilmedi. Test verileri otomatik silinmedi.'
if ($failed -gt 0) { exit 1 }
if ($skipped -gt 0) { exit 2 }
exit 0
