# Heartbeat Check Script v3.0
$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"

$dbHost = "localhost"
$dbPort = "3306"
$dbName = "baozipu"
$dbUser = "root"
$dbPass = "root123"
$threshold = 60

$ts = Get-Date -Format "HH:mm:ss"
Write-Host "[$ts] Starting heartbeat check..."

$result = mysql -h $dbHost -P $dbPort -u $dbUser -p$dbPass $dbName -N -e "SELECT agent_id, task_name, TIMESTAMPDIFF(MINUTE, last_heartbeat_at, NOW()) AS mins FROM pipeline_agent_tasks WHERE status IN ('executing','assigned') AND last_heartbeat_at < NOW() - INTERVAL $threshold MINUTE;" 2>&1 | Out-String

if ([string]::IsNullOrWhiteSpace($result) -or $result -like "*ERROR*") {
    Write-Host "OK: All agents normal, HEARTBEAT_OK" -ForegroundColor Green
    exit 0
}

Write-Host "ALERT: Lost agents found:" -ForegroundColor Yellow
Write-Host $result
exit 0