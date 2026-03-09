# OpenClaw Agent Initialization Script
# Start containers and configure API keys

$ErrorActionPreference = "Stop"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "OpenClaw Agent Initialization" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# 1. Start containers
Write-Host "[1/4] Starting containers..." -ForegroundColor Yellow
docker-compose -f docker-compose-agents.yml up -d
Write-Host "[OK] Containers started`n" -ForegroundColor Green

# 2. Wait for containers
Write-Host "[2/4] Waiting for containers..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

# 3. Configure API keys
Write-Host "[3/4] Configuring API keys..." -ForegroundColor Yellow

$Agents = @(
    @{Name="openclaw-instance-1"; Model="bailian/qwen3-coder-plus"; ApiKey="sk-0101b7d3672245ac8cd15d454198b4db"; BaseUrl="https://dashscope.aliyuncs.com/compatible-mode/v1"},
    @{Name="openclaw-instance-2"; Model="bailian/qwen3-coder-plus"; ApiKey="sk-dc74719ea21348f183cbabb87f01999c"; BaseUrl="https://dashscope.aliyuncs.com/compatible-mode/v1"},
    @{Name="openclaw-instance-3"; Model="bailian/qwen3-coder-plus"; ApiKey="sk-1edeed01f7104f75b0c4c69237b7f577"; BaseUrl="https://dashscope.aliyuncs.com/compatible-mode/v1"}
)

foreach ($agent in $Agents) {
    Write-Host "  Configuring $($agent.Name) ..." -ForegroundColor Gray
    docker exec $agent.Name mkdir -p /home/node/.openclaw/agents/main/agent | Out-Null
    
    $configJson = '{"model":"' + $agent.Model + '","provider":"bailian","apiKey":"' + $agent.ApiKey + '","baseUrl":"' + $agent.BaseUrl + '"}'
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($configJson)
    $base64 = [Convert]::ToBase64String($bytes)
    
    docker exec $agent.Name bash -c "echo '$base64' | base64 -d > /home/node/.openclaw/agents/main/agent/auth-profiles.json" | Out-Null
    
    $result = docker exec $agent.Name cat /home/node/.openclaw/agents/main/agent/auth-profiles.json
    if ($result -match $agent.Model) {
        Write-Host "  [OK] $($agent.Name)" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] $($agent.Name)" -ForegroundColor Red
    }
}

Write-Host ""

# 4. Restart containers
Write-Host "[4/4] Restarting containers..." -ForegroundColor Yellow
docker restart openclaw-instance-1 openclaw-instance-2 openclaw-instance-3 | Out-Null

Write-Host "`nWaiting for restart..." -ForegroundColor Yellow
Start-Sleep -Seconds 20

# Verify
Write-Host "`nVerifying configuration..." -ForegroundColor Cyan

foreach ($agent in $Agents) {
    Write-Host "  Checking $($agent.Name) ..." -ForegroundColor Gray
    $logs = docker logs $agent.Name --tail 10 2>&1
    
    if ($logs -match $agent.Model) {
        Write-Host "  [OK] $($agent.Name): $($agent.Model)" -ForegroundColor Green
    } else {
        Write-Host "  [WARN] $($agent.Name): may not be effective" -ForegroundColor Yellow
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Complete!" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Container Status:" -ForegroundColor Yellow
docker ps --filter "name=openclaw-instance" --format "table {{.Names}}`t{{.Status}}`t{{.Ports}}"

Write-Host "`nAccess URLs:" -ForegroundColor Yellow
Write-Host "  Jiangrou: http://localhost:18791" -ForegroundColor Gray
Write-Host "  Dousha:   http://localhost:18792" -ForegroundColor Gray
Write-Host "  Suancai:  http://localhost:18793" -ForegroundColor Gray
