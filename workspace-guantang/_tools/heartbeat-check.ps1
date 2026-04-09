# Heartbeat Check Script
$workinglogBase = "F:\openclaw\agent\workinglog"
$agents = @("jiangrou", "dousha", "suancai")
$currentTime = Get-Date
$threshold = 60

Write-Host "========================================"
Write-Host "  Heartbeat Check - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Host "========================================"
Write-Host ""

foreach ($agent in $agents) {
    $logPath = Join-Path $workinglogBase $agent
    if (Test-Path $logPath) {
        $latestLog = Get-ChildItem $logPath -File | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($latestLog) {
            $lastActivity = $latestLog.LastWriteTime
            $minutesAgo = [math]::Round((New-TimeSpan -Start $lastActivity -End $currentTime).TotalMinutes)
            
            $status = "OK"
            if ($minutesAgo -gt $threshold) {
                $status = "DISCONNECTED ($minutesAgo min)"
            } elseif ($minutesAgo -gt 30) {
                $status = "WARNING ($minutesAgo min)"
            }
            
            Write-Host "$agent : $status"
            Write-Host "  LastActivity: $($lastActivity.ToString('yyyy-MM-dd HH:mm:ss'))"
            Write-Host "  LatestLog: $($latestLog.Name)"
        } else {
            Write-Host "$agent : NO_LOG_FILES"
        }
    } else {
        Write-Host "$agent : LOG_DIR_NOT_FOUND"
    }
    Write-Host ""
}

Write-Host "========================================"
Write-Host "  HEARTBEAT_OK"
Write-Host "========================================"
