param(
    [string]$dbPath = "F:\openclaw\agent\workspace-guantang\_db\pipeline.db"
)

Add-Type -AssemblyName System.Data

$conn = New-Object System.Data.SQLite.SQLiteConnection "Data Source=$dbPath"
$conn.Open()

Write-Host "=== 活跃计划查询 ===" -ForegroundColor Cyan

# 查询 waiting 和 processing 状态的计划
$cmd = $conn.CreateCommand()
$cmd.CommandText = @"
SELECT plan_id, plan_name, status, current_round, total_rounds 
FROM pipeline_plans 
WHERE status IN ('waiting', 'processing')
ORDER BY 
  CASE status WHEN 'processing' THEN 0 WHEN 'waiting' THEN 1 END,
  plan_id
"@

$reader = $cmd.ExecuteReader()
$hasPlans = $false

while ($reader.Read()) {
    $hasPlans = $true
    $planId = $reader.GetString(0)
    $planName = $reader.GetString(1)
    $status = $reader.GetString(2)
    $currentRound = $reader.GetInt32(3)
    $totalRounds = $reader.GetInt32(4)
    
    $statusColor = if ($status -eq 'processing') { 'Yellow' } else { 'Green' }
    Write-Host "$planId | $planName | $status | R$currentRound/$totalRounds" -ForegroundColor $statusColor
}

if (-not $hasPlans) {
    Write-Host "无活跃计划" -ForegroundColor Gray
}

# 查询 Agent 活跃任务
Write-Host "`n=== Agent 活跃任务 ===" -ForegroundColor Cyan

$cmd.CommandText = @"
SELECT agent_id, COUNT(*) as active_tasks
FROM pipeline_agent_tasks
WHERE status IN ('assigned', 'executing')
GROUP BY agent_id
"@

$reader = $cmd.ExecuteReader()
$hasActiveTasks = $false

while ($reader.Read()) {
    $hasActiveTasks = $true
    $agentId = $reader.GetString(0)
    $activeTasks = $reader.GetInt32(1)
    Write-Host "$agentId : $activeTasks 个活跃任务" -ForegroundColor Yellow
}

if (-not $hasActiveTasks) {
    Write-Host "所有 Agent 均空闲" -ForegroundColor Green
}

$conn.Close()
