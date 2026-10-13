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
    param($Fixture, [string]$Id = '1.1', [string]$RelativePath = 'docs/GUNLUK.md', [string]$Title = 'Sentetik çalışma kaydı', [string]$Time = '2020-01-02 03:04')
    $lines = @(
        ('## ' + $Time + ' — ' + $Title),
        '',
        ('- Çalışma birimi: ' + $Id),
        '- Yapılan iş ve nedeni: Yalnız denetim testinin örnek verisi.',
        '- Değişen dosyalar: Örnek belge.',
        '- Doğrulama: örnek-komut; sentetik sonuç. Gerçek ürün testi çalıştırıldığı iddia edilmez.',
        '- Başarısız: yok.',
        '- Atlanan: yok.',
        '- Çalıştırılamayan: yok.'
    )
    $path = Join-Path $Fixture.target $RelativePath
    Write-TestFile $path ([IO.File]::ReadAllText($path) + [Environment]::NewLine + ($lines -join [Environment]::NewLine) + [Environment]::NewLine)
}

function Add-Archive {
    param($Fixture, [string]$Folder = '01-asama', [string]$Id = '1.1', [string]$Status = 'Doğrulandı')
    $relative = 'docs/arsiv/' + $Folder
    $planPath = Join-Path $Fixture.target ($relative + '/PLAN.md')
    $journalPath = Join-Path $Fixture.target ($relative + '/GUNLUK.md')
    $lines = @('# Sentetik aşama arşivi', '', '## Seçilen aşamanın ayrıntıları', '', '| Alt adım | Beklenen davranış ve kapsam | Kabul ölçütü | Doğrulama | Durum |', '|---|---|---|---|---|')
    if ($Id -ne '') { $lines += '| ' + $Id + ' | Sentetik iş | Sentetik kabul | Örnek kontrol | ' + $Status + ' |' }
    $lines += @('', '## Hazırlık ve aşama kapanışı', '', '[Kapanış](GUNLUK.md#2020-01-02-0305--kapanış)', '')
    Write-TestFile $planPath ($lines -join [Environment]::NewLine)
    Write-TestFile $journalPath '# Sentetik arşiv günlüğü'
    if ($Id -ne '') { Add-Log $Fixture $Id ($relative + '/GUNLUK.md') }
    Add-Log $Fixture ('Hazırlık veya ana aşama kapanışı / ' + $Folder) ($relative + '/GUNLUK.md') 'Kapanış' '2020-01-02 03:05'
    $activePlan = Join-Path $Fixture.target 'docs/PLAN.md'
    Write-TestFile $activePlan ([IO.File]::ReadAllText($activePlan) + [Environment]::NewLine + '[Arşiv](arsiv/' + $Folder + '/PLAN.md)' + [Environment]::NewLine)
    return [pscustomobject]@{relative=$relative; plan=$planPath; journal=$journalPath; decisions=(Join-Path $Fixture.target ($relative + '/KARARLAR.md'))}
}

function Add-Decision {
    param([string]$Path, [string]$Id = 'K-001')
    $prefix = ''
    if (Test-Path -LiteralPath $Path) { $prefix = [IO.File]::ReadAllText($Path) }
    $lines = @('', ('## ' + $Id + ' — Sentetik karar'), '', '- Karar: Sentetik tercih.', '- Gerekçe: Yalnız izole denetim örneği.', '- Etki: Sentetik aşama.', '')
    Write-TestFile $Path ($prefix + ($lines -join [Environment]::NewLine))
}

function Get-TestSection {
    param([string]$Text, [string]$Heading)
    $match = [regex]::Match($Text, '(?ms)^## ' + [regex]::Escape($Heading) + '[ \t]*\r?\n.*?(?=^## |\z)')
    Assert-True $match.Success ('Sentetik kaynak bölümü bulunmalı: ' + $Heading)
    return $match.Value
}

function New-ArchiveFlowFixture {
    $f = New-Fixture; Install-Fixture $f
    $planPath = Join-Path $f.target 'docs/PLAN.md'
    $core = '- Genel sözleşme: UTF-8 metin ve mevcut veri biçimi korunur.' + "`n" + '- Açık iş: İkinci aşamanın araştırması kullanıcı seçimini bekler.'
    $plan = [IO.File]::ReadAllText($planPath).Replace('## Proje özeti', '## Proje özeti' + "`n`n" + $core)
    $plan = $plan.Replace('|---|---|---|', "|---|---|---|`n| 1 | İlk aşama | Planlandı |`n| 2 | İkinci aşama | Planlandı |")
    Write-TestFile $planPath $plan
    Write-TestFile (Join-Path $f.target 'docs/GUNLUK.md') '# Yalnız sentetik akış günlüğü'
    Write-TestFile (Join-Path $f.target 'docs/KARARLAR.md') '# Yalnız sentetik akış kararları'
    Write-TestFile (Join-Path $f.target 'src/ornek.txt') 'Sentetik kaynak; arşivlenmez.'
    Write-TestFile (Join-Path $f.target 'data/ornek.json') '{"sample":true}'
    Add-Decision (Join-Path $f.target 'docs/KARARLAR.md')
    $protected = @{}
    foreach ($path in @('AGENTS.md','CLAUDE.md','.ai-sablon/kontrol.ps1','.ai-sablon/kurulum.json','src/ornek.txt','data/ornek.json')) { $protected[$path] = Get-Hash ([IO.File]::ReadAllBytes((Join-Path $f.target $path))) }
    $f | Add-Member NoteProperty Core $core
    $f | Add-Member NoteProperty Protected $protected
    $f | Add-Member NoteProperty GlobalDecision (Get-TestSection ([IO.File]::ReadAllText((Join-Path $f.target 'docs/KARARLAR.md'))) 'K-001 — Sentetik karar')
    $f | Add-Member NoteProperty Phase $null
    return $f
}

function Set-ArchiveFlowPhase {
    param($Fixture, [string]$Id, [string]$Day, [string]$Label, [string]$DecisionId, [string[]]$ExtraIds = @(), [string]$Previous = '', [string]$Status = 'Doğrulandı')
    $planPath = Join-Path $Fixture.target 'docs/PLAN.md'
    $plan = [IO.File]::ReadAllText($planPath)
    $ids = @($Id) + $ExtraIds | Where-Object { $_ -ne '' }
    $rows = @('## Seçilen aşamanın ayrıntıları', '', '| Alt adım | Beklenen davranış ve kapsam | Kabul ölçütü | Doğrulama | Durum |', '|---|---|---|---|---|')
    $heads = @()
    $minute = 0
    foreach ($step in $ids) {
        $rows += '| ' + $step + ' | Sentetik davranış | Beklenen sonuç korunur | Sentetik kontrol | ' + $Status + ' |'
        if ($Status -eq 'Doğrulandı') {
            $time = '2020-01-' + $Day + ' 03:' + $minute.ToString('00')
            $title = $Label + ' / ' + $step
            Add-Log $Fixture $step 'docs/GUNLUK.md' $title $time
            $heads += $time + ' — ' + $title
            $minute++
        }
    }
    if ($Id -eq '') {
        $time = '2020-01-' + $Day + ' 03:00'
        Add-Log $Fixture 'Hazırlık planlama' 'docs/GUNLUK.md' $Label $time
        $heads += $time + ' — ' + $Label
    }
    $rows += @('', '- Kabul: Kapanmış yerel geçmiş ve özgün hata metni korunur.', '[Geçerli sözleşme](KARARLAR.md#k-001--sentetik-karar)', '')
    $plan = $plan.Replace((Get-TestSection $plan 'Seçilen aşamanın ayrıntıları'), ($rows -join "`n"))
    $current = $Id
    if ($current -eq '') { $current = 'Henüz seçilmedi.' }
    $plan = [regex]::Replace($plan, '(?m)^- Güncel çalışma birimi:[^\r\n]*', ('- Güncel çalışma birimi: ' + $current))
    if ($Status -eq 'Doğrulandı') {
        $time = '2020-01-' + $Day + ' 03:10'
        $title = $Label + ' kapanışı'
        Add-Log $Fixture ($Label + ' kapanışı') 'docs/GUNLUK.md' $title $time
        $heads += $time + ' — ' + $title
        $anchor = ('2020-01-' + $Day + '-0310--' + $title.ToLowerInvariant().Replace(' ', '-'))
        $closing = "## Hazırlık ve aşama kapanışı`n`n[Kapanış](GUNLUK.md#" + $anchor + ")`n`n"
        $plan = $plan.Replace((Get-TestSection $plan 'Hazırlık ve aşama kapanışı'), $closing)
    }
    if ($Previous -ne '') { $plan += "`n## Yeniden açılma`n`n[Önceki kapanış](arsiv/" + $Previous + "/PLAN.md)`n" }
    Write-TestFile $planPath $plan
    $handoffPath = Join-Path $Fixture.target 'docs/DEVIR.md'
    $handoff = [regex]::Replace([IO.File]::ReadAllText($handoffPath), '(?m)^- Güncel çalışma birimi:[^\r\n]*', ('- Güncel çalışma birimi: ' + $current))
    $handoff = [regex]::Replace($handoff, '(?m)^- Kayıt zamanı:[^\r\n]*', ('- Kayıt zamanı: 2020-01-' + $Day + ' 03:10.'))
    Write-TestFile $handoffPath $handoff
    if ($DecisionId -ne '') { Add-Decision (Join-Path $Fixture.target 'docs/KARARLAR.md') $DecisionId }
    $journalPath = Join-Path $Fixture.target 'docs/GUNLUK.md'
    $journal = [IO.File]::ReadAllText($journalPath).Replace('Örnek belge.', '[Kaynak](../src/ornek.txt).').Replace('Yalnız denetim testinin örnek verisi.', 'Sentetik hata metni: E-ORNEK; yalnız akış verisi, gerçek hata değil.')
    Write-TestFile $journalPath $journal
    $Fixture.Phase = [pscustomobject]@{Heads=$heads;DecisionId=$DecisionId;Previous=$Previous}
}

function Get-ArchiveFlowPhoto {
    param($Fixture)
    $parts = @{}
    $hashes = @{}
    foreach ($name in @('PLAN','GUNLUK','KARARLAR')) { $hashes[$name] = Get-Hash ([IO.File]::ReadAllBytes((Join-Path $Fixture.target ('docs/' + $name + '.md')))) }
    $plan = [IO.File]::ReadAllText((Join-Path $Fixture.target 'docs/PLAN.md'))
    $parts['PLAN'] = (Get-TestSection $plan 'Seçilen aşamanın ayrıntıları') + (Get-TestSection $plan 'Hazırlık ve aşama kapanışı')
    if ($Fixture.Phase.Previous -ne '') { $parts['PLAN'] += Get-TestSection $plan 'Yeniden açılma' }
    $journal = [IO.File]::ReadAllText((Join-Path $Fixture.target 'docs/GUNLUK.md'))
    $parts['GUNLUK'] = (@($Fixture.Phase.Heads | ForEach-Object { Get-TestSection $journal $_ }) -join '')
    $parts['KARARLAR'] = Get-TestSection ([IO.File]::ReadAllText((Join-Path $Fixture.target 'docs/KARARLAR.md'))) ($Fixture.Phase.DecisionId + ' — Sentetik karar')
    return [pscustomobject]@{Parts=$parts;Hashes=$hashes;Heads=$Fixture.Phase.Heads;DecisionId=$Fixture.Phase.DecisionId;Previous=$Fixture.Phase.Previous}
}

function Get-ArchiveFlowText {
    param($Photo, [string]$Name, [string]$Folder)
    $up = '../' * (($Folder -split '/').Count + 2)
    $text = '# Sentetik arşiv belgesi' + "`n`n" + $Photo.Parts[$Name]
    $text = $text.Replace('../src/ornek.txt', $up + 'src/ornek.txt').Replace('KARARLAR.md#k-001--sentetik-karar', $up + 'docs/KARARLAR.md#k-001--sentetik-karar')
    if ($Photo.Previous -ne '') { $text = $text.Replace('arsiv/' + $Photo.Previous + '/PLAN.md', $up + 'docs/arsiv/' + $Photo.Previous + '/PLAN.md') }
    return $text
}

function Assert-ArchiveFlowCopy {
    param($Fixture, $Photo, [string]$Folder)
    foreach ($name in @('PLAN','GUNLUK','KARARLAR')) {
        $path = Join-Path $Fixture.target ('docs/arsiv/' + $Folder + '/' + $name + '.md')
        Assert-True (Test-Path -LiteralPath $path -PathType Leaf) ('Arşiv parçası eksik: ' + $name)
        Assert-Equal ([IO.File]::ReadAllText($path)) (Get-ArchiveFlowText $Photo $name $Folder) ('Özgün kapsam/kimlik/tarih/kanıt/hata metni: ' + $name)
    }
}

function Write-ArchiveFlowCopy {
    param($Fixture, $Photo, [string]$Folder)
    $path = Join-Path $Fixture.target ('docs/arsiv/' + $Folder)
    if (Test-Path -LiteralPath $path) { Assert-ArchiveFlowCopy $Fixture $Photo $Folder; return }
    foreach ($name in @('PLAN','GUNLUK','KARARLAR')) { Write-TestFile (Join-Path $path ($name + '.md')) (Get-ArchiveFlowText $Photo $name $Folder) }
    Assert-ArchiveFlowCopy $Fixture $Photo $Folder
}

function Remove-ArchiveFlowSource {
    param($Fixture, $Photo, [string]$Folder)
    # Bu yordam yalnız test fixture'ını değiştirir; hedef projeye kurulmaz.
    Assert-ArchiveFlowCopy $Fixture $Photo $Folder
    $check = Invoke-Check $Fixture
    Assert-Equal $check.data.errors 0 'Arşiv bağlantıları doğrulanmadan geçmiş çıkarılmaz'
    foreach ($name in @('PLAN','GUNLUK','KARARLAR')) {
        Assert-Equal (Get-Hash ([IO.File]::ReadAllBytes((Join-Path $Fixture.target ('docs/' + $name + '.md'))))) $Photo.Hashes[$name] 'Aktif kaynak değişti; geçmiş çıkarılmadı'
    }
    $planPath = Join-Path $Fixture.target 'docs/PLAN.md'
    $plan = [IO.File]::ReadAllText($planPath)
    $plan = $plan.Replace((Get-TestSection $plan 'Seçilen aşamanın ayrıntıları'), "## Seçilen aşamanın ayrıntıları`n`n| Alt adım | Beklenen davranış ve kapsam | Kabul ölçütü | Doğrulama | Durum |`n|---|---|---|---|---|`n`n")
    $plan = $plan.Replace((Get-TestSection $plan 'Hazırlık ve aşama kapanışı'), "## Hazırlık ve aşama kapanışı`n`nKapanmış yerel geçmiş aşağıdaki arşiv bağlantısında.`n`n")
    if ($Photo.Previous -ne '') { $plan = $plan.Replace((Get-TestSection $plan 'Yeniden açılma'), '') }
    $plan = [regex]::Replace($plan, '(?m)^- Güncel çalışma birimi:[^\r\n]*', '- Güncel çalışma birimi: Henüz seçilmedi.')
    $plan += "`n[Arşiv](arsiv/" + $Folder + "/PLAN.md)`n"
    Write-TestFile $planPath $plan
    $journalPath = Join-Path $Fixture.target 'docs/GUNLUK.md'
    $journal = [IO.File]::ReadAllText($journalPath)
    foreach ($heading in $Photo.Heads) { $journal = $journal.Replace((Get-TestSection $journal $heading), '') }
    Write-TestFile $journalPath $journal
    $decisionPath = Join-Path $Fixture.target 'docs/KARARLAR.md'
    Write-TestFile $decisionPath ([IO.File]::ReadAllText($decisionPath).Replace($Photo.Parts['KARARLAR'], ''))
    $handoffPath = Join-Path $Fixture.target 'docs/DEVIR.md'
    Write-TestFile $handoffPath ([regex]::Replace([IO.File]::ReadAllText($handoffPath), '(?m)^- Güncel çalışma birimi:[^\r\n]*', '- Güncel çalışma birimi: Henüz seçilmedi.'))
}

function Assert-ArchiveFlowLiving {
    param($Fixture)
    $plan = [IO.File]::ReadAllText((Join-Path $Fixture.target 'docs/PLAN.md'))
    Assert-True $plan.Contains($Fixture.Core) 'Genel sözleşme ve açık iş aktif kalmalı.'
    Assert-True ($plan.Contains('| 1 | İlk aşama |') -and $plan.Contains('| 2 | İkinci aşama |')) 'Genel yol haritası korunmalı.'
    Assert-Equal (Get-TestSection ([IO.File]::ReadAllText((Join-Path $Fixture.target 'docs/KARARLAR.md'))) 'K-001 — Sentetik karar').TrimEnd() $Fixture.GlobalDecision.TrimEnd() 'Geçerli karar değiştirilmez'
    foreach ($path in $Fixture.Protected.Keys) { Assert-Equal (Get-Hash ([IO.File]::ReadAllBytes((Join-Path $Fixture.target $path)))) $Fixture.Protected[$path] ('Kod/veri/kurulum korunur: ' + $path) }
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

Test-Case 'Kararlar dosyası olmayan geçerli aşama arşivi denetlenir' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f
    $check = Invoke-Check $f
    Assert-Equal $check.data.errors 0 'Geçerli arşiv'
    Assert-Equal $check.data.warnings 2 'Yalnız geliştirme/IDE uyarıları'
    Assert-Code $check 'I_ARCHIVES'
    Assert-Code $check 'W_LOG_MISSING' $false
    Assert-Code $check 'W_ARCHIVE_CLOSURE' $false
    Assert-True (-not (Test-Path -LiteralPath $a.decisions)) 'Boş Kararlar zorunlu değildir.'
}

Test-Case 'Hazırlık arşivi numaralı alt adım olmadan kapanış kaydına bağlanır' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f '00-hazirlik' ''
    $check = Invoke-Check $f
    Assert-Equal $check.data.errors 0 'Hazırlık arşivi'
    Assert-Equal $check.data.warnings 2 'Numaralı hazırlık alt adımı dayatılmaz'
}

Test-Case 'Arşiv denetimi hiçbir dosyayı değiştirmez veya Git oluşturmaz' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f
    Add-Decision $a.decisions
    $before = Get-Snapshot $f.target
    $check = Invoke-Check $f
    Assert-Equal (Get-Snapshot $f.target) $before 'Arşivli denetim salt okunur'
    Assert-Equal $check.data.errors 0 'Salt okunur arşiv'
    Assert-True (-not (Test-Path -LiteralPath (Join-Path $f.target '.git'))) 'Git oluşturulmaz.'
}

Test-Case 'Yeni aktif işin kaydını eski arşiv karşılayamaz' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f
    Set-Plan $f; Set-Handoff $f
    $check = Invoke-Check $f
    Assert-Code $check 'W_LOG_MISSING'
    Assert-True (@($check.data.findings | Where-Object { $_.code -eq 'W_LOG_MISSING' -and $_.message.StartsWith('docs/PLAN.md:') }).Count -eq 1) 'Aktif eksik kanıt açık olmalı.'
}

Test-Case 'İlişkisiz Plan kimlik tekrarları inceleme uyarısıdır' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f
    Set-Plan $f; Set-Handoff $f; Add-Log $f '1.1' 'docs/GUNLUK.md' 'Yeni çalışma' '2020-01-03 04:05'
    $check = Invoke-Check $f
    Assert-Code $check 'W_STEP_DUPLICATE'
    Assert-Code $check 'W_LOG_MISSING' $false
}

Test-Case 'Açık önceki Plan bağlantısı ve yeni yerel kanıt yeniden açılmayı ayırır' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f
    Set-Plan $f; Set-Handoff $f; Add-Log $f '1.1' 'docs/GUNLUK.md' 'Yeniden açılan çalışma' '2020-01-03 04:05'
    $path = Join-Path $f.target 'docs/PLAN.md'
    Write-TestFile $path ([IO.File]::ReadAllText($path) + "`n## Yeniden açılma`n`n[Önceki kapanış](arsiv/01-asama/PLAN.md)`n")
    $check = Invoke-Check $f
    Assert-Equal $check.data.warnings 2 'İlişkili sürüm yanlış kimlik çakışması değildir'
    Assert-Code $check 'I_REOPEN_LINK'
    Assert-Code $check 'W_STEP_DUPLICATE' $false
}

Test-Case 'Yeniden açılma bağlantısı yeni yerel kanıt eksikliğini gizlemez' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f
    Set-Plan $f; Set-Handoff $f
    $path = Join-Path $f.target 'docs/PLAN.md'
    Write-TestFile $path ([IO.File]::ReadAllText($path) + "`n## Yeniden açılma`n`n[Önceki kapanış](arsiv/01-asama/PLAN.md)`n")
    $check = Invoke-Check $f
    Assert-Code $check 'W_LOG_MISSING'
    Assert-Code $check 'W_STEP_DUPLICATE'
    Assert-Code $check 'I_REOPEN_LINK' $false
}

Test-Case 'Genel yönergedeki yeniden açılma sözcüğü ilişki sayılmaz' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f
    Set-Plan $f; Set-Handoff $f; Add-Log $f '1.1' 'docs/GUNLUK.md' 'Yeni çalışma' '2020-01-03 04:05'
    $check = Invoke-Check $f
    Assert-Code $check 'W_STEP_DUPLICATE'
    Assert-Code $check 'I_REOPEN_LINK' $false
}

Test-Case 'Aktif ve arşiv karar kimliği tekrarları görünür' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f
    Add-Decision $a.decisions
    Add-Decision (Join-Path $f.target 'docs/KARARLAR.md')
    $check = Invoke-Check $f
    Assert-Code $check 'W_DECISION_DUPLICATE'
}

Test-Case 'Arşiv kararındaki eksik alan denetlenir' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f
    Add-Decision $a.decisions
    Write-TestFile $a.decisions ([IO.File]::ReadAllText($a.decisions).Replace('- Gerekçe:', '- Eksik alan:'))
    $check = Invoke-Check $f
    Assert-Code $check 'W_DECISION_FIELDS'
}

Test-Case 'Aynı işin farklı tarihli günlüğü meşru birden çok kayıttır' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f
    Add-Log $f '1.1' ($a.relative + '/GUNLUK.md') 'Sonraki inceleme' '2020-01-03 04:05'
    $check = Invoke-Check $f
    Assert-Equal $check.data.warnings 2 'Farklı tarihli kayıtlar tekrar değildir'
    Assert-Code $check 'W_LOG_DUPLICATE' $false
}

Test-Case 'Göreli bağlantısı düzeltilmiş yarım Günlük kopyası görünür' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f
    Write-TestFile (Join-Path $f.target 'src/Ornek.ps1') '# Sentetik dosya'
    Write-TestFile $a.journal ([IO.File]::ReadAllText($a.journal).Replace('Örnek belge.', '[Örnek](../../../src/Ornek.ps1).'))
    Add-Log $f
    $path = Join-Path $f.target 'docs/GUNLUK.md'
    Write-TestFile $path ([IO.File]::ReadAllText($path).Replace('Örnek belge.', '[Örnek](../src/Ornek.ps1).'))
    $check = Invoke-Check $f
    Assert-Code $check 'W_LOG_DUPLICATE'
    Assert-Code $check 'E_BROKEN_LINK' $false
    Assert-Code $check 'E_LINK_PATH' $false
}

Test-Case 'Arşivden kod ve aktif kararlara proje içi bağlantı geçerlidir' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f
    Write-TestFile (Join-Path $f.target 'src/Ornek.ps1') '# Sentetik dosya'
    Add-Decision (Join-Path $f.target 'docs/KARARLAR.md')
    Write-TestFile $a.journal ([IO.File]::ReadAllText($a.journal) + "`n[Kaynak](../../../src/Ornek.ps1)`n[Geçerli karar](../../KARARLAR.md#k-001--sentetik-karar)`n")
    $check = Invoke-Check $f
    Assert-Equal $check.data.errors 0 'Arşiv dışı proje içi hedefler geçerli'
    Assert-Equal $check.data.warnings 2 'Proje içi bağlantı dış kaynak değildir'
}

Test-Case 'Arşivden proje dışındaki Markdown dosyası okunmaz' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f
    $outside = Join-Path $f.folder 'disarida.md'
    Assert-True ($outside.StartsWith($testRoot + '\')) 'Dış örnek test kökünde kalmalı.'
    [IO.File]::WriteAllBytes($outside, [byte[]]@(255, 255))
    Write-TestFile $a.journal ([IO.File]::ReadAllText($a.journal) + "`n[Dışarı](<$outside#baslik>)`n")
    $check = Invoke-Check $f
    Assert-Code $check 'W_EXTERNAL_LINK'
    Assert-Code $check 'E_FILE_READ' $false
}

Test-Case 'Arşivde kırık dosya bağlantısı bulunur' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f
    Write-TestFile $a.journal ([IO.File]::ReadAllText($a.journal) + "`n[Eksik](eksik.md)`n")
    $check = Invoke-Check $f
    Assert-Code $check 'E_BROKEN_LINK'
    Assert-Equal $check.exitCode 1 'Kırık dosya hata çıkışı'
}

Test-Case 'Dosya bulunsa da yanlış başlık bağlantısı hata verir' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f
    Write-TestFile $a.plan ([IO.File]::ReadAllText($a.plan).Replace('#2020-01-02-0305--kapanış', '#olmayan-kapanis'))
    $check = Invoke-Check $f
    Assert-Code $check 'E_BROKEN_ANCHOR'
    Assert-Code $check 'W_ARCHIVE_CLOSURE'
}

Test-Case 'Kapanış yalnız dosya bağlantısıyla veya başka paket kaydıyla karşılanmaz' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f
    $b = Add-Archive $f '02-asama' '2.1'
    Write-TestFile $a.plan ([IO.File]::ReadAllText($a.plan).Replace('GUNLUK.md#2020-01-02-0305--kapanış', '../02-asama/GUNLUK.md#2020-01-02-0305--kapanış'))
    $check = Invoke-Check $f
    Assert-Code $check 'W_ARCHIVE_CLOSURE'
    Assert-Code $check 'E_BROKEN_ANCHOR' $false
    Write-TestFile $a.plan ([IO.File]::ReadAllText($a.plan).Replace('../02-asama/GUNLUK.md#2020-01-02-0305--kapanış', 'GUNLUK.md'))
    Assert-Code (Invoke-Check $f) 'W_ARCHIVE_CLOSURE'
}

Test-Case 'Dolu olmayan kapanış doğrulaması kanıt sayılmaz' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f
    Write-TestFile $a.journal ([IO.File]::ReadAllText($a.journal).Replace('- Doğrulama: örnek-komut; sentetik sonuç. Gerçek ürün testi çalıştırıldığı iddia edilmez.', '- Doğrulama: Henüz çalıştırılmadı.'))
    $check = Invoke-Check $f
    Assert-Code $check 'W_LOG_FIELDS'
    Assert-Code $check 'W_LOG_MISSING'
    Assert-Code $check 'W_ARCHIVE_CLOSURE'
}

Test-Case 'Arşiv Plan eksik Günlük kaydını kendi dizininde arar' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f
    Remove-TestFile $a.journal
    Add-Log $f
    $check = Invoke-Check $f
    Assert-Code $check 'W_LOG_MISSING'
    Assert-Code $check 'W_ARCHIVE_CLOSURE'
    Assert-Code $check 'E_BROKEN_LINK'
}

Test-Case 'Plan olmadan kalmış arşiv Günlüğü kısmi kapsamı bildirir' {
    $f = New-Fixture; Install-Fixture $f
    Write-TestFile (Join-Path $f.target 'docs/arsiv/01-asama/GUNLUK.md') '# Sentetik günlük'
    $check = Invoke-Check $f
    Assert-Code $check 'W_ARCHIVE_PLAN'
}

Test-Case 'Aktif Plan arşive ulaşamıyorsa geçmiş bağlantısı uyarılır' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f
    $path = Join-Path $f.target 'docs/PLAN.md'
    Write-TestFile $path ([IO.File]::ReadAllText($path).Replace('[Arşiv](arsiv/01-asama/PLAN.md)', 'Arşiv bağlantısı çıkarılmış sentetik örnek.'))
    $check = Invoke-Check $f
    Assert-Code $check 'W_ARCHIVE_REFERENCE'
}

Test-Case 'Arşivde örnek kod ve yorumlar gerçek kayıt veya bağlantı sayılmaz' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f
    $tick = [string][char]96
    $example = @('', ($tick * 3), '## K-001 — Gerçek olmayan karar', '[Sahte](eksik.md#baslik)', ($tick * 3), '<!-- [Sahte](eksik.md) -->', '') -join [Environment]::NewLine
    Write-TestFile $a.decisions $example
    $check = Invoke-Check $f
    Assert-Equal $check.data.warnings 2 'Örnekler gerçek kayıt değildir'
    Assert-Equal $check.data.errors 0 'Örnek bağlantı okunmaz'
}

Test-Case 'Arşiv Markdown BOM ve bozuk UTF-8 görünür' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f
    Write-TestFile $a.journal ([IO.File]::ReadAllText($a.journal)) $true
    Assert-Code (Invoke-Check $f) 'E_FILE_READ'
    $path = Join-Path $f.target 'docs/arsiv/01-asama/bozuk.md'
    Assert-True ($path.StartsWith($testRoot + '\')) 'Bozuk örnek test kökünde kalmalı.'
    [IO.File]::WriteAllBytes($path, [byte[]]@(255, 255))
    $check = Invoke-Check $f
    Assert-True (@($check.data.findings | Where-Object { $_.code -eq 'E_FILE_READ' -and $_.message.StartsWith('docs/arsiv/01-asama/bozuk.md:') }).Count -gt 0) 'Bozuk UTF-8 dosyası adlandırılmalı.'
}

foreach ($location in @('docs/arsiv', 'docs/arsiv/01-asama/yonlendirme')) {
    Test-Case ('Arşiv keşfi yönlendirilmiş klasöre girmez: ' + $location) {
        $f = New-Fixture; Install-Fixture $f
        $outside = Join-Path $f.folder 'baglanti-hedefi'
        Write-TestFile (Join-Path $outside 'gizli-ornek.md') '# Yalnız izole bağlantı hedefi'
        $link = Join-Path $f.target $location
        [IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($link)) | Out-Null
        New-TestJunction $link $outside
        $before = [IO.File]::ReadAllBytes((Join-Path $outside 'gizli-ornek.md'))
        $check = Invoke-Check $f
        Assert-Code $check 'E_ARCHIVE_PATH'
        Assert-Code $check 'I_ARCHIVES' $false
        Assert-Equal (Get-Hash ([IO.File]::ReadAllBytes((Join-Path $outside 'gizli-ornek.md')))) (Get-Hash $before) 'Yönlendirme hedefi değişmez'
    }
}

Test-Case 'Başlık bağlantıları Türkçe, biçim ve tekrar ekini destekler' {
    $f = New-Fixture; Install-Fixture $f
    $path = Join-Path $f.target 'README.md'
    $tick = [string][char]96
    $lines = @('# Örnek', '', '## Kapanış', '## Kapanış', ('## **Doğrulama** ' + $tick + 'test' + $tick), '[İlk](#kapanış)', '[İkinci](#kapanış-1)', '[Biçim](#doğrulama-test)', '')
    Write-TestFile $path ($lines -join [Environment]::NewLine)
    $check = Invoke-Check $f
    Assert-Equal $check.data.errors 0 'Desteklenen başlık bağlantıları'
}

foreach ($scenario in @('farklı-kimlik', 'eksik-kanıt', 'dolu-zincir', 'döngü')) {
    Test-Case ('Yeniden açılma zinciri aynı işin yerel kanıtlarına bağlıdır: ' + $scenario) {
        $f = New-Fixture; Install-Fixture $f
        $middleId = '1.1'
        if ($scenario -eq 'farklı-kimlik') { $middleId = '2.1' }
        $b = Add-Archive $f '01-asama/yeniden-acilma' $middleId
        $c = Add-Archive $f '01-asama/ilk-kapanis'
        Write-TestFile $b.journal ([IO.File]::ReadAllText($b.journal).Replace('Sentetik çalışma kaydı', 'Ara sürümün çalışması'))
        Write-TestFile $c.journal ([IO.File]::ReadAllText($c.journal).Replace('Sentetik çalışma kaydı', 'İlk sürümün çalışması'))
        Write-TestFile $b.plan ([IO.File]::ReadAllText($b.plan) + "`n## Yeniden açılma`n`n[Önceki Plan](../ilk-kapanis/PLAN.md)`n")
        if ($scenario -eq 'döngü') {
            Write-TestFile $c.plan ([IO.File]::ReadAllText($c.plan) + "`n## Yeniden açılma`n`n[Döngü](../yeniden-acilma/PLAN.md)`n")
        } else {
            Set-Plan $f; Set-Handoff $f; Add-Log $f '1.1' 'docs/GUNLUK.md' 'Aktif yeni çalışma' '2020-01-03 04:05'
            $path = Join-Path $f.target 'docs/PLAN.md'
            Write-TestFile $path ([IO.File]::ReadAllText($path) + "`n## Yeniden açılma`n`n[Önceki Plan](arsiv/01-asama/yeniden-acilma/PLAN.md)`n")
        }
        if ($scenario -eq 'eksik-kanıt') {
            Write-TestFile $b.journal ([IO.File]::ReadAllText($b.journal).Replace('- Doğrulama: örnek-komut; sentetik sonuç. Gerçek ürün testi çalıştırıldığı iddia edilmez.', '- Doğrulama: Henüz çalıştırılmadı.'))
        }
        $check = Invoke-Check $f
        Assert-Equal $check.data.errors 0 'Zincir dosya/başlık bağlantıları'
        if ($scenario -eq 'dolu-zincir') {
            Assert-Equal $check.data.warnings 2 'Geçerli iç içe tarihsel zincir'
            Assert-Code $check 'I_REOPEN_LINK'
            Assert-Code $check 'W_STEP_DUPLICATE' $false
        } else {
            Assert-Code $check 'W_STEP_DUPLICATE'
            Assert-Code $check 'I_REOPEN_LINK' $false
        }
        if ($scenario -eq 'eksik-kanıt') { Assert-Code $check 'W_LOG_MISSING' }
    }
}

Test-Case 'Aynı başlıklı başka dolu kayıt eksik kapanış hedefinin yerine geçmez' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f '00-hazirlik' ''
    Write-TestFile $a.journal ([IO.File]::ReadAllText($a.journal).Replace('- Doğrulama: örnek-komut; sentetik sonuç. Gerçek ürün testi çalıştırıldığı iddia edilmez.', '- Doğrulama: Henüz çalıştırılmadı.'))
    Add-Log $f 'Başka dolu kayıt' ($a.relative + '/GUNLUK.md') 'Kapanış' '2020-01-02 03:05'
    $check = Invoke-Check $f
    Assert-Code $check 'W_LOG_FIELDS'
    Assert-Code $check 'W_ARCHIVE_CLOSURE'
    Write-TestFile $a.plan ([IO.File]::ReadAllText($a.plan).Replace('#2020-01-02-0305--kapanış', '#2020-01-02-0305--kapanış-1'))
    $second = Invoke-Check $f
    Assert-Code $second 'W_ARCHIVE_CLOSURE' $false
    Assert-Code $second 'W_LOG_FIELDS'
}

Test-Case 'Kapanış başlığının isteğe bağlı ATX son belirteci geçerlidir' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f
    Write-TestFile $a.journal ([IO.File]::ReadAllText($a.journal).Replace('— Kapanış', '— Kapanış ##'))
    $check = Invoke-Check $f
    Assert-Equal $check.data.errors 0 'Son belirteçli başlık bağlantısı'
    Assert-Code $check 'W_ARCHIVE_CLOSURE' $false
}

Test-Case 'Geçersiz takvim tarihi dolu çalışma kaydı sayılmaz' {
    $f = New-Fixture; Install-Fixture $f
    Set-Plan $f; Set-Handoff $f; Add-Log $f '1.1' 'docs/GUNLUK.md' 'Geçersiz tarih' '2020-02-30 03:04'
    $check = Invoke-Check $f
    Assert-Code $check 'W_LOG_TIME'
    Assert-Code $check 'W_LOG_MISSING'
}

Test-Case 'Altı çizgili başlık ve özel HTML bağlantı hedefi yanlış kırık sayılmaz' {
    $f = New-Fixture; Install-Fixture $f
    $path = Join-Path $f.target 'README.md'
    $lines = @('# Örnek', '', 'Altı çizgili başlık', '------------------', '', '<a name="ozel-hedef"></a>', '## Başlık <em>deneme</em>', '[Başlık](#altı-çizgili-başlık)', '[Özel](#ozel-hedef)', '[Biçim](#başlık-deneme)', '')
    Write-TestFile $path ($lines -join [Environment]::NewLine)
    $check = Invoke-Check $f
    Assert-Equal $check.data.errors 0 'Desteklenen ek bağlantı hedefleri'
}

Test-Case 'Eksik Plan kabul ölçütü yeniden açılma ilişkisini geçerli göstermez' {
    $f = New-Fixture; Install-Fixture $f
    $a = Add-Archive $f
    Set-Plan $f; Set-Handoff $f; Add-Log $f '1.1' 'docs/GUNLUK.md' 'Aktif çalışma' '2020-01-03 04:05'
    $path = Join-Path $f.target 'docs/PLAN.md'
    Write-TestFile $path ([IO.File]::ReadAllText($path).Replace('Sentetik kabul ölçütü', '') + "`n## Yeniden açılma`n`n[Önceki Plan](arsiv/01-asama/PLAN.md)`n")
    $check = Invoke-Check $f
    Assert-Code $check 'W_PLAN_FIELDS'
    Assert-Code $check 'W_STEP_DUPLICATE'
    Assert-Code $check 'I_REOPEN_LINK' $false
}

foreach ($length in @(1, 2)) {
    Test-Case ('Inline kod içindeki kapanış bağlantısı gerçek kanıt sayılmaz: ' + $length) {
        $f = New-Fixture; Install-Fixture $f
        $a = Add-Archive $f
        $fence = ([string][char]96) * $length
        $link = '[Kapanış](GUNLUK.md#2020-01-02-0305--kapanış)'
        Write-TestFile $a.plan ([IO.File]::ReadAllText($a.plan).Replace($link, $fence + $link + $fence))
        $check = Invoke-Check $f
        Assert-Code $check 'W_ARCHIVE_CLOSURE'
        Assert-Code $check 'W_LOG_MISSING' $false
        Assert-Equal $check.data.errors 0 'Örnek bağlantı gerçek hedef olarak denetlenmez'
    }
    Test-Case ('Inline kod içindeki yeniden açılma bağlantısı ilişki sayılmaz: ' + $length) {
        $f = New-Fixture; Install-Fixture $f
        $a = Add-Archive $f
        Set-Plan $f; Set-Handoff $f; Add-Log $f '1.1' 'docs/GUNLUK.md' 'Aktif çalışma' '2020-01-03 04:05'
        $fence = ([string][char]96) * $length
        $path = Join-Path $f.target 'docs/PLAN.md'
        $link = $fence + '[Önceki Plan](arsiv/01-asama/PLAN.md)' + $fence
        Write-TestFile $path ([IO.File]::ReadAllText($path) + "`n## Yeniden açılma`n`n" + $link + "`n")
        $check = Invoke-Check $f
        Assert-Code $check 'W_STEP_DUPLICATE'
        Assert-Code $check 'I_REOPEN_LINK' $false
        Assert-Code $check 'W_LOG_MISSING' $false
    }
    Test-Case ('Inline kod içindeki HTML başlık metni olarak korunur: ' + $length) {
        $f = New-Fixture; Install-Fixture $f
        $fence = ([string][char]96) * $length
        $lines = @('# Örnek', '', ('## ' + $fence + '<dosya>' + $fence + ' kullanımı'), '[Başlık](#dosya-kullanımı)', '')
        Write-TestFile (Join-Path $f.target 'README.md') ($lines -join [Environment]::NewLine)
        $check = Invoke-Check $f
        Assert-Equal $check.data.errors 0 'Kod metni gerçek HTML değildir'
    }
    Test-Case ('Inline kod içindeki HTML sahte bağlantı hedefi oluşturmaz: ' + $length) {
        $f = New-Fixture; Install-Fixture $f
        $fence = ([string][char]96) * $length
        $lines = @('# Örnek', '', ($fence + '<a id="sahte"></a>' + $fence), '<a id="gercek"></a>', '[Sahte](#sahte)', '[Gerçek](#gercek)', '')
        Write-TestFile (Join-Path $f.target 'README.md') ($lines -join [Environment]::NewLine)
        $check = Invoke-Check $f
        Assert-Equal $check.data.errors 1 'Yalnız gerçek hedef geçerli'
        Assert-Code $check 'E_BROKEN_ANCHOR'
        Assert-True (@($check.data.findings | Where-Object { $_.code -eq 'E_BROKEN_ANCHOR' -and $_.message.EndsWith('#sahte') }).Count -eq 1) 'Sahte hedef adlandırılmalı.'
    }
}

Test-Case 'Arşiv keşfi yönlendirilmiş Markdown dosyasını okumaz' {
    $f = New-Fixture; Install-Fixture $f
    $outside = Join-Path $f.folder 'baglanti-hedefi.md'
    Write-TestFile $outside 'Yalnız izole bağlantı hedefi'
    [IO.File]::WriteAllBytes($outside, [byte[]]@(255, 255))
    $link = Join-Path $f.target 'docs/arsiv/01-asama/GUNLUK.md'
    Assert-True ([IO.Path]::GetFullPath($link).StartsWith($testRoot + '\', [StringComparison]::OrdinalIgnoreCase)) 'Bağlantı test kökünde kalmalı.'
    [IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($link)) | Out-Null
    try { New-Item -ItemType SymbolicLink -Path $link -Target $outside -ErrorAction Stop | Out-Null }
    catch { throw ('ATLANDI: Ortamda örnek dosya bağlantısı oluşturulamadı: ' + $_.Exception.Message) }
    $before = Get-Hash ([IO.File]::ReadAllBytes($outside))
    $check = Invoke-Check $f
    Assert-Code $check 'E_ARCHIVE_PATH'
    Assert-Code $check 'E_FILE_READ' $false
    Assert-Code $check 'I_ARCHIVES' $false
    Assert-Equal (Get-Hash ([IO.File]::ReadAllBytes($outside))) $before 'Dosya bağlantısı hedefi değişmez'
}

Test-Case 'Arşiv akışı: hazırlık ve aşama 1 geçmişi ayrılır, aynı Plan aşama 2 ile sürer' {
    $f = New-ArchiveFlowFixture
    Set-ArchiveFlowPhase $f '' '02' 'Hazırlık' 'K-002'
    $prep = Get-ArchiveFlowPhoto $f
    Write-ArchiveFlowCopy $f $prep '00-hazirlik'
    Remove-ArchiveFlowSource $f $prep '00-hazirlik'
    Assert-ArchiveFlowLiving $f
    Set-ArchiveFlowPhase $f '1.1' '03' 'Aşama 1' 'K-003' @('1.2')
    $first = Get-ArchiveFlowPhoto $f
    Write-ArchiveFlowCopy $f $first '01-ilk'
    Remove-ArchiveFlowSource $f $first '01-ilk'
    $planPath = Join-Path $f.target 'docs/PLAN.md'
    $plan = [IO.File]::ReadAllText($planPath).Replace('| 1 | İlk aşama | Planlandı |', '| 1 | İlk aşama | Doğrulandı |')
    Write-TestFile $planPath $plan
    Set-ArchiveFlowPhase $f '2.1' '04' 'Aşama 2' '' -Status 'Planlandı'
    Assert-ArchiveFlowLiving $f
    Assert-ArchiveFlowCopy $f $prep '00-hazirlik'
    Assert-ArchiveFlowCopy $f $first '01-ilk'
    Assert-True ([IO.File]::ReadAllText($planPath).Contains('| 2.1 |')) 'Aynı aktif Plan yeni seçilen ayrıntıyı taşımalı.'
    Assert-True (-not [IO.File]::ReadAllText($planPath).Contains('| 1.1 |')) 'Kapanmış yerel ayrıntı aktif tabloda birikmez.'
    Assert-True (-not [IO.File]::ReadAllText((Join-Path $f.target 'docs/GUNLUK.md')).Contains('2020-01-03')) 'Eski tarihli günlük tek asıl kaynakta.'
    Assert-True (-not [IO.File]::ReadAllText((Join-Path $f.target 'docs/KARARLAR.md')).Contains('## K-003')) 'Yerel karar aktif dosyadan ayrılmış olmalı.'
    $archiveSource = [IO.Path]::GetFullPath((Join-Path (Join-Path $f.target 'docs/arsiv/01-ilk') '../../../src/ornek.txt'))
    Assert-Equal $archiveSource (Join-Path $f.target 'src/ornek.txt') 'Düzeltilmiş bağlantı özgün somut dosyaya gider'
    $check = Invoke-Check $f
    Assert-Equal $check.data.errors 0 'İki yönlü kaynak/karar/arşiv başlık bağlantıları'
    Assert-Equal $check.data.warnings 2 'Yalnız geliştirme/IDE uyarıları'
}

Test-Case 'Arşiv akışı: kopya sonrası kesinti ve eşit içerikle tekrar eski arşivi ezmez' {
    $f = New-ArchiveFlowFixture
    Set-ArchiveFlowPhase $f '1.1' '03' 'Aşama 1' 'K-003'
    $photo = Get-ArchiveFlowPhoto $f
    Write-ArchiveFlowCopy $f $photo '01-ilk'
    $directory = Join-Path $f.target 'docs/arsiv/01-ilk'
    $before = Get-Snapshot $directory
    $interrupted = Invoke-Check $f
    Assert-Code $interrupted 'W_LOG_DUPLICATE'
    Assert-Code $interrupted 'W_STEP_DUPLICATE'
    Assert-Code $interrupted 'W_DECISION_DUPLICATE'
    Write-ArchiveFlowCopy $f $photo '01-ilk'
    Assert-Equal (Get-Snapshot $directory) $before 'Yeniden deneme mevcut arşivi yazmaz'
    Remove-ArchiveFlowSource $f $photo '01-ilk'
    Assert-ArchiveFlowLiving $f
    $final = Invoke-Check $f
    Assert-Equal $final.data.errors 0 'Toparlanmış akış'
    Assert-Equal $final.data.warnings 2 'Yarım kopya çakışmaları kapanmalı'
}

foreach ($fault in @('kaynak-degisti','arsiv-farkli','kismi-cikarim','eksik-kopya')) {
    Test-Case ('Arşiv akışı: belirsiz aktarım tamamlandı sayılmaz: ' + $fault) {
        $f = New-ArchiveFlowFixture
        Set-ArchiveFlowPhase $f '1.1' '03' 'Aşama 1' 'K-003'
        $photo = Get-ArchiveFlowPhoto $f
        Write-ArchiveFlowCopy $f $photo '01-ilk'
        $archivePath = Join-Path $f.target 'docs/arsiv/01-ilk'
        $journalPath = Join-Path $f.target 'docs/GUNLUK.md'
        if ($fault -eq 'kaynak-degisti') { Write-TestFile $journalPath ([IO.File]::ReadAllText($journalPath) + "`nKaynakta sonradan eklenen sentetik bilgi.`n") }
        elseif ($fault -eq 'arsiv-farkli') {
            $path = Join-Path $archivePath 'GUNLUK.md'
            Write-TestFile $path ([IO.File]::ReadAllText($path).Replace('E-ORNEK', 'DEGISTIRILMIS'))
        } elseif ($fault -eq 'kismi-cikarim') { Write-TestFile $journalPath ([IO.File]::ReadAllText($journalPath).Replace((Get-TestSection ([IO.File]::ReadAllText($journalPath)) $photo.Heads[0]), '')) }
        else { Remove-TestFile (Join-Path $archivePath 'KARARLAR.md') }
        $sourceBefore = @{}
        foreach ($name in @('PLAN','GUNLUK','KARARLAR')) { $sourceBefore[$name] = Get-Hash ([IO.File]::ReadAllBytes((Join-Path $f.target ('docs/' + $name + '.md')))) }
        $archiveBefore = Get-Snapshot $archivePath
        $stopped = $false
        try { Remove-ArchiveFlowSource $f $photo '01-ilk' } catch { $stopped = $true }
        Assert-True $stopped 'Farklı/eksik kaynak veya arşivde çıkarım durmalı.'
        foreach ($name in $sourceBefore.Keys) { Assert-Equal (Get-Hash ([IO.File]::ReadAllBytes((Join-Path $f.target ('docs/' + $name + '.md'))))) $sourceBefore[$name] 'Kalan aktif kayıtlar korunur' }
        Assert-Equal (Get-Snapshot $archivePath) $archiveBefore 'Var olan arşiv ezilmez'
        if ($fault -in @('arsiv-farkli','eksik-kopya')) {
            $stopped = $false
            try { Write-ArchiveFlowCopy $f $photo '01-ilk' } catch { $stopped = $true }
            Assert-True $stopped 'Yeniden deneme farklı/eksik arşivi kör tamamlamaz.'
            Assert-Equal (Get-Snapshot $archivePath) $archiveBefore 'Tekrar mevcut arşivi değiştirmez'
        }
        foreach ($path in @('docs/PLAN.md','docs/DEVIR.md')) { $absolute = Join-Path $f.target $path; Write-TestFile $absolute ([IO.File]::ReadAllText($absolute) + "`nAktarım yarım; eksiksizlik ve kaynak karşılaştırması açık.`n") }
        Assert-True ([IO.File]::ReadAllText((Join-Path $f.target 'docs/DEVIR.md')).Contains('Aktarım yarım')) 'Yarım durum devirde açık olmalı.'
        Assert-ArchiveFlowLiving $f
    }
}

Test-Case 'Arşiv akışı: aynı iş yeniden açılıp ayrı kapanır, eski kapanış değişmez' {
    $f = New-ArchiveFlowFixture
    Set-ArchiveFlowPhase $f '1.1' '03' 'Aşama 1' 'K-003'
    $old = Get-ArchiveFlowPhoto $f
    Write-ArchiveFlowCopy $f $old '01-ilk'
    Remove-ArchiveFlowSource $f $old '01-ilk'
    $oldHashes = @{}
    foreach ($name in @('PLAN','GUNLUK','KARARLAR')) { $oldHashes[$name] = Get-Hash ([IO.File]::ReadAllBytes((Join-Path $f.target ('docs/arsiv/01-ilk/' + $name + '.md')))) }
    Set-ArchiveFlowPhase $f '1.1' '04' 'Aşama 1 yeniden' 'K-004' @() '01-ilk'
    $opened = Invoke-Check $f
    Assert-Equal $opened.data.errors 0 'Açık tarihsel ilişki'
    Assert-Equal $opened.data.warnings 2 'Yeni kanıt eski kapanışla çakışmaz'
    Assert-Code $opened 'I_REOPEN_LINK'
    $fresh = Get-ArchiveFlowPhoto $f
    Write-ArchiveFlowCopy $f $fresh '01-ilk/yeniden-1'
    Remove-ArchiveFlowSource $f $fresh '01-ilk/yeniden-1'
    foreach ($name in $oldHashes.Keys) { Assert-Equal (Get-Hash ([IO.File]::ReadAllBytes((Join-Path $f.target ('docs/arsiv/01-ilk/' + $name + '.md'))))) $oldHashes[$name] 'Eski kapanış byte özeti korunur' }
    Assert-ArchiveFlowCopy $f $fresh '01-ilk/yeniden-1'
    Assert-ArchiveFlowLiving $f
    $closed = Invoke-Check $f
    Assert-Equal $closed.data.errors 0 'Ayrı tekrar kapanışı bağlantıları'
    Assert-Equal $closed.data.warnings 2 'İki ilişkili tarihsel sürüm'
    Assert-Code $closed 'I_REOPEN_LINK'
}

Test-Case 'Arşiv akışı: ortak dönüşüm bozuk bağlantı üretirse aktif geçmiş çıkarılmaz' {
    $f = New-ArchiveFlowFixture
    Set-ArchiveFlowPhase $f '1.1' '03' 'Aşama 1' 'K-003'
    $photo = Get-ArchiveFlowPhoto $f
    # Yazım ve beklenen metin aynı hatayı paylaşsa bile bağlantı ayrıca sınanmalı.
    $photo.Parts['GUNLUK'] = $photo.Parts['GUNLUK'].Replace('../src/ornek.txt', '../src/olmayan.txt')
    Write-ArchiveFlowCopy $f $photo '01-ilk'
    $before = Get-Snapshot $f.target
    $stopped = $false
    try { Remove-ArchiveFlowSource $f $photo '01-ilk' } catch { $stopped = $true }
    Assert-True $stopped 'Bozuk bağlantıda aktif geçmiş çıkarılmamalı.'
    Assert-Equal (Get-Snapshot $f.target) $before 'Kırık bağlantıda kaynak ve arşiv korunur'
    Assert-Code (Invoke-Check $f) 'E_BROKEN_LINK'
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
