# PM Auto-Verify Script
# Run after each spawn completion to verify task results
# Usage: powershell -ExecutionPolicy Bypass -File _pm_verify.ps1 -TaskId "J-FIX-02" -Agent "jiangrou" -Checks "compile","no_new_files","log_exists"

param(
    [string]$TaskId,
    [string]$Agent,
    [string[]]$Checks,
    [string]$LogPath,
    [string]$CompileDir,
    [string]$BuildDir
)

$results = @()
$allPass = $true

foreach ($check in $Checks) {
    switch ($check) {
        "compile" {
            Write-Output "=== CHECK: mvn compile ==="
            $proc = Start-Process -FilePath "mvn" -ArgumentList "compile" -WorkingDirectory $CompileDir -NoNewWindow -Wait -PassThru -RedirectStandardOutput "$env:TEMP\mvn_out.txt" 2>&1
            $exitCode = $proc.ExitCode
            $pass = ($exitCode -eq 0)
            $results += "compile: $(if($pass){'PASS'}else{'FAIL'}) (exit=$exitCode)"
            if (-not $pass) { $allPass = $false }
        }
        "build" {
            Write-Output "=== CHECK: npm run build ==="
            $proc = Start-Process -FilePath "npm" -ArgumentList "run","build" -WorkingDirectory $BuildDir -NoNewWindow -Wait -PassThru 2>&1
            $exitCode = $proc.ExitCode
            $distExists = Test-Path "$BuildDir\dist\index.html"
            $pass = ($exitCode -eq 0) -and $distExists
            $results += "build: $(if($pass){'PASS'}else{'FAIL'}) (exit=$exitCode, dist=$distExists)"
            if (-not $pass) { $allPass = $false }
        }
        "no_new_files" {
            Write-Output "=== CHECK: no new files ==="
            $newFiles = git -C $CompileDir diff --name-only --diff-filter=A 2>&1
            $pass = [string]::IsNullOrWhiteSpace($newFiles)
            $results += "no_new_files: $(if($pass){'PASS'}else{"FAIL ($newFiles)"})"
            if (-not $pass) { $allPass = $false }
        }
        "log_exists" {
            Write-Output "=== CHECK: log file ==="
            $pass = Test-Path $LogPath
            $results += "log_exists: $(if($pass){'PASS'}else{'FAIL'})"
            if (-not $pass) { $allPass = $false }
        }
        "file_exists" {
            Write-Output "=== CHECK: file exists ==="
            $pass = Test-Path $LogPath
            $size = if ($pass) { (Get-Item $LogPath).Length } else { 0 }
            $pass = $pass -and ($size -gt 100)
            $results += "file_exists: $(if($pass){'PASS'}else{'FAIL'}) (size=$size)"
            if (-not $pass) { $allPass = $false }
        }
        "ssh_verify" {
            Write-Output "=== CHECK: SSH remote ==="
            $output = ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 root@8.137.175.240 "echo SSH_OK" 2>&1
            $pass = $output -match "SSH_OK"
            $results += "ssh_verify: $(if($pass){'PASS'}else{'FAIL'})"
            if (-not $pass) { $allPass = $false }
        }
    }
}

Write-Output ""
Write-Output "========== VERIFY REPORT =========="
Write-Output "Task: $TaskId"
Write-Output "Agent: $Agent"
Write-Output "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
foreach ($r in $results) { Write-Output "  $r" }
Write-Output "Overall: $(if($allPass){'ALL PASS'}else{'HAS FAILURES'})"
Write-Output "==================================="

if ($allPass) { exit 0 } else { exit 1 }
