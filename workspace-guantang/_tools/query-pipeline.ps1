$dbPath = "F:\openclaw\agent\workspace-guantang\_db\pipeline.db"

if (-not (Test-Path $dbPath)) {
    Write-Host "Database not found: $dbPath"
    exit 1
}

Add-Type -AssemblyName System.Data

$conn = New-Object System.Data.SQLite.SQLiteConnection "Data Source=$dbPath"
$conn.Open()

Write-Host "=== Active Plans ===" -ForegroundColor Cyan

$cmd = $conn.CreateCommand()
$cmd.CommandText = "SELECT plan_id, plan_name, status, current_round, total_rounds FROM pipeline_plans WHERE status IN ('waiting', 'processing')"

$reader = $cmd.ExecuteReader()
$found = $false

while ($reader.Read()) {
    $found = $true
    $line = "{0} | {1} | {2} | R{3}/{4}" -f $reader.GetString(0), $reader.GetString(1), $reader.GetString(2), $reader.GetInt32(3), $reader.GetInt32(4)
    Write-Host $line
}

if (-not $found) {
    Write-Host "No active plans" -ForegroundColor Gray
}

Write-Host "`n=== Agent Active Tasks ===" -ForegroundColor Cyan

$cmd.CommandText = "SELECT agent_id, COUNT(*) as cnt FROM pipeline_agent_tasks WHERE status IN ('assigned', 'executing') GROUP BY agent_id"
$reader = $cmd.ExecuteReader()
$hasTasks = $false

while ($reader.Read()) {
    $hasTasks = $true
    $line = "{0} : {1} active tasks" -f $reader.GetString(0), $reader.GetInt32(1)
    Write-Host $line -ForegroundColor Yellow
}

if (-not $hasTasks) {
    Write-Host "All agents idle" -ForegroundColor Green
}

$conn.Close()
