# Live Status Update Script
# Run during heartbeat to auto-update live-status.md

$statusFile = "F:\openclaw\agent\doc\05-progress\live-status.md"
$now = Get-Date -Format "yyyy-MM-dd HH:mm"

# Check each agent's latest log
function Get-AgentStatus($agent) {
    $logDir = "F:\openclaw\agent\workinglog\$agent"
    $latest = Get-ChildItem $logDir -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($latest) {
        $minAgo = [math]::Round(((Get-Date) - $latest.LastWriteTime).TotalMinutes)
        $status = if ($minAgo -lt 30) { "active" } elseif ($minAgo -lt 60) { "idle" } else { "offline" }
        return @{ Name = $latest.Name; MinAgo = $minAgo; Status = $status; Time = $latest.LastWriteTime.ToString("HH:mm") }
    }
    return @{ Name = "none"; MinAgo = 999; Status = "offline"; Time = "N/A" }
}

$j = Get-AgentStatus "jiangrou"
$d = Get-AgentStatus "dousha"
$s = Get-AgentStatus "suancai"

$statusIcon = @{ "active" = "working"; "idle" = "idle"; "offline" = "OFFLINE" }

$content = @"
# Live Status

**Last Updated:** $now (auto)

## Team Status
| Agent | Status | Last Activity | Minutes Ago |
|-------|--------|--------------|-------------|
| Jiangrou | $($statusIcon[$j.Status]) | $($j.Time) | $($j.MinAgo)m |
| Dousha | $($statusIcon[$d.Status]) | $($d.Time) | $($d.MinAgo)m |
| Suancai | $($statusIcon[$s.Status]) | $($s.Time) | $($s.MinAgo)m |

## Latest Logs
- Jiangrou: $($j.Name)
- Dousha: $($d.Name)
- Suancai: $($s.Name)

## Key Checks
- Backend blog dir deleted: $(if(Test-Path 'F:\openclaw\code\backend\src\main\java\com\openclaw\blog'){'EXISTS (bad)'}else{'CLEAN'})
- Frontend dist exists: $(Test-Path 'F:\openclaw\code\frontend\dist\index.html')
- Remote Redis: (check on demand)
"@

Set-Content -Path $statusFile -Value $content -Encoding UTF8
Write-Output "live-status.md updated at $now"
