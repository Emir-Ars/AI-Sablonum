[CmdletBinding()]
param()

# Geçmişte yayımlanan ortak kısımlar kaybolmasın diye paket listesini tam Git geçmişiyle karşılaştırır.
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
$utf8 = New-Object Text.UTF8Encoding($false, $true)
$repoRoot = Split-Path -Parent $PSScriptRoot

function Get-BytesHash {
    param([byte[]]$Bytes)
    $hasher = [Security.Cryptography.SHA256]::Create()
    try { return ([BitConverter]::ToString($hasher.ComputeHash($Bytes))).Replace('-', '').ToLowerInvariant() }
    finally { $hasher.Dispose() }
}

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

function Get-GitBlob {
    # PowerShell 5.1 metin borusu baytları yeniden kodladığı için doğrudan çıktı akışı okunur.
    param([string]$Commit, [string]$Path)
    $startInfo = New-Object Diagnostics.ProcessStartInfo
    $startInfo.FileName = 'git'
    $startInfo.Arguments = 'cat-file blob ' + $Commit + ':' + $Path
    $startInfo.WorkingDirectory = $repoRoot
    $startInfo.UseShellExecute = $false
    $startInfo.CreateNoWindow = $true
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true
    $process = New-Object Diagnostics.Process
    $process.StartInfo = $startInfo
    $buffer = New-Object IO.MemoryStream
    try {
        $process.Start() | Out-Null
        $errorTask = $process.StandardError.ReadToEndAsync()
        $process.StandardOutput.BaseStream.CopyTo($buffer)
        $process.WaitForExit()
        $null = $errorTask.GetAwaiter().GetResult()
        if ($process.ExitCode -ne 0) { return $null }
        return ,($buffer.ToArray())
    } finally {
        $buffer.Dispose()
        $process.Dispose()
    }
}

try {
    if ($PSVersionTable.PSVersion -lt [version]'5.1') { throw 'Windows PowerShell 5.1 veya daha yenisi gerekir.' }
    $shallow = & git -C $repoRoot rev-parse --is-shallow-repository
    if ($LASTEXITCODE -ne 0) { throw 'Git depo bilgisi okunamadı.' }
    if ($shallow -eq 'true') { throw 'Bilinen hash denetimi için tam geçmiş gerekir; sığ klon desteklenmez.' }
    $commits = @(& git -C $repoRoot rev-list HEAD)
    if ($LASTEXITCODE -ne 0) { throw 'Git geçmişi okunamadı.' }

    $version = $utf8.GetString([IO.File]::ReadAllBytes((Join-Path $repoRoot 'surum.json'))) | ConvertFrom-Json
    $listed = @($version.knownAgentsCommonLfSha256 | Where-Object { $null -ne $_ })
    $currentSplit = Split-AgentsBytes ([IO.File]::ReadAllBytes((Join-Path $repoRoot 'genel/KURALLAR.md')))
    if ($null -eq $currentSplit) { throw 'Güncel ortak kısım başlığı tam bir kez bulunmalı.' }
    $currentHash = Get-LfHash $currentSplit.Common
    $historical = @{}
    foreach ($commit in $commits) {
        $versionBytes = Get-GitBlob $commit 'surum.json'
        if ($null -eq $versionBytes) { continue }
        $rulesBytes = Get-GitBlob $commit 'genel/KURALLAR.md'
        if ($null -eq $rulesBytes) { continue }
        $historicalVersion = $utf8.GetString($versionBytes) | ConvertFrom-Json
        if ($historicalVersion.schemaVersion -ne 2) { continue }
        $split = Split-AgentsBytes $rulesBytes
        if ($null -eq $split) { continue }
        $hash = Get-LfHash $split.Common
        if ($hash -ne $currentHash -and -not $historical.ContainsKey($hash)) {
            $historical[$hash] = $commit.Substring(0, 7)
        }
    }

    $missing = 0
    $extra = 0
    foreach ($hash in @($historical.Keys | Sort-Object)) {
        if ($listed -notcontains $hash) {
            Write-Output ('EKSİK: ' + $hash + ' (örnek commit ' + $historical[$hash] + ')')
            $missing++
        }
    }
    foreach ($hash in $listed) {
        if (-not $historical.ContainsKey($hash)) {
            Write-Output ('FAZLA: ' + $hash)
            $extra++
        }
    }
    Write-Output ('Toplam: EKSİK={0} FAZLA={1}; geçmiş ortak kısım={2}' -f $missing, $extra, $historical.Count)
    if ($missing -gt 0) { exit 1 }
    exit 0
} catch {
    [Console]::Error.WriteLine(('Bilinen hash denetimi başarısız: ' + $_.Exception.Message))
    exit 1
}
