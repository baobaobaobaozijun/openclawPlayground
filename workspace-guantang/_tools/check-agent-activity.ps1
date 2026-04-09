param()
$agents = @('jiangrou','dousha','suancai')
$now = Get-Date
foreach ($agent in $agents) {
    $dir = "F:\openclaw\agent\workinglog\$agent"
    $latest = Get-ChildItem $dir -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($latest) {
        $mins = [math]::Round(($now - $latest.LastWriteTime).TotalMinutes)
        $hours = [math]::Round($mins / 60, 1)
        if ($mins -gt 1440) {
            $status = "LOST (>24h)"
        } elseif ($mins -gt 60) {
            $status = "LOST"
        } elseif ($mins -gt 30) {
            $status = "WARNING"
        } else {
            $status = "OK"
        }
        Write-Host "$agent | $status | ${mins}min (${hours}h) ago | $($latest.Name)"
    } else {
        Write-Host "$agent | NO_LOGS | N/A"
    }
}

# Also check today's log count per agent
Write-Host ""
Write-Host "=== Today's Log Count ==="
$today = $now.ToString('yyyyMMdd')
foreach ($agent in $agents) {
    $dir = "F:\openclaw\agent\workinglog\$agent"
    $todayLogs = Get-ChildItem $dir -Filter "${today}*" -ErrorAction SilentlyContinue
    $count = if ($todayLogs) { $todayLogs.Count } else { 0 }
    Write-Host "$agent | $count logs today"
}
