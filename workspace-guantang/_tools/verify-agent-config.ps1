# ============================================
# 验证 Agent 配置
# ============================================

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Agent 配置验证报告" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$openclawConfig = "C:\Users\Administrator\.openclaw\openclaw.json"
$agents = @("guantang", "jiangrou", "dousha", "suancai")

# 1. 检查 openclaw.json 是否存在
Write-Host "1. 检查 openclaw.json..." -ForegroundColor Yellow
if (Test-Path $openclawConfig) {
    Write-Host "   ✅ openclaw.json 存在" -ForegroundColor Green
    $config = Get-Content $openclawConfig -Raw | ConvertFrom-Json
} else {
    Write-Host "   ❌ openclaw.json 不存在" -ForegroundColor Red
    exit 1
}

# 2. 检查各 Agent 配置
Write-Host "`n2. 检查各 Agent 配置..." -ForegroundColor Yellow
foreach ($agentId in $agents) {
    $agent = $config.agents.list | Where-Object { $_.id -eq $agentId }
    if ($agent) {
        Write-Host "   ✅ $agentId 配置存在" -ForegroundColor Green
        Write-Host "      - Workspace: $($agent.workspace)" -ForegroundColor Gray
        Write-Host "      - Model: $($agent.model)" -ForegroundColor Gray
        
        # 检查 skill 配置
        if ($agent.skills.entries.'plan-db-sync') {
            Write-Host "      - plan-db-sync skill: ✅ 已启用" -ForegroundColor Green
        } else {
            Write-Host "      - plan-db-sync skill: ❌ 未配置" -ForegroundColor Red
        }
    } else {
        Write-Host "   ❌ $agentId 配置不存在" -ForegroundColor Red
    }
}

# 3. 检查 .env 文件
Write-Host "`n3. 检查 .env 文件..." -ForegroundColor Yellow
foreach ($agentId in $agents) {
    $envPath = "F:\openclaw\agent\workspace-$agentId\.env"
    if (Test-Path $envPath) {
        Write-Host "   ✅ $agentId\.env 存在" -ForegroundColor Green
        $envContent = Get-Content $envPath -Raw
        if ($envContent -match "PLAN_DB_SYNC_ENABLED=true") {
            Write-Host "      - PLAN_DB_SYNC_ENABLED: ✅ 已启用" -ForegroundColor Green
        } else {
            Write-Host "      - PLAN_DB_SYNC_ENABLED: ❌ 未启用" -ForegroundColor Red
        }
    } else {
        Write-Host "   ❌ $agentId\.env 不存在" -ForegroundColor Red
    }
}

# 4. 检查工具脚本
Write-Host "`n4. 检查工具脚本..." -ForegroundColor Yellow
$tools = @(
    "update-db-task-assigned.ps1",
    "update-db-task-completed.ps1",
    "update-db-plan-completed.ps1"
)
$toolsDir = "F:\openclaw\agent\workspace-guantang\_tools"
foreach ($tool in $tools) {
    $toolPath = Join-Path $toolsDir $tool
    if (Test-Path $toolPath) {
        Write-Host "   ✅ $tool 存在" -ForegroundColor Green
    } else {
        Write-Host "   ❌ $tool 不存在" -ForegroundColor Red
    }
}

# 5. 检查 skill 目录
Write-Host "`n5. 检查 plan-db-sync skill..." -ForegroundColor Yellow
$skillPath = "F:\openclaw\agent\workspace-guantang\skills\plan-db-sync\SKILL.md"
if (Test-Path $skillPath) {
    Write-Host "   ✅ plan-db-sync skill 存在" -ForegroundColor Green
} else {
    Write-Host "   ❌ plan-db-sync skill 不存在" -ForegroundColor Red
}

# 6. 检查数据库连接
Write-Host "`n6. 检查数据库连接..." -ForegroundColor Yellow
try {
    $result = mysql -h localhost -u root -e "USE baozipu; SELECT 'connected' AS status;" 2>&1
    if ($result -match "connected") {
        Write-Host "   ✅ 数据库连接成功 (baozipu)" -ForegroundColor Green
        
        # 检查 pipeline 表
        $tables = mysql -h localhost -u root -e "USE baozipu; SHOW TABLES LIKE 'pipeline_%';" 2>&1
        $tableCount = ($tables | Measure-Object -Line).Lines
        Write-Host "   ✅ pipeline 表数量：$tableCount" -ForegroundColor Green
    } else {
        Write-Host "   ❌ 数据库连接失败" -ForegroundColor Red
    }
} catch {
    Write-Host "   ❌ 数据库连接错误：$_" -ForegroundColor Red
}

# 7. 检查数据库中的计划数据
Write-Host "`n7. 检查数据库中的计划数据..." -ForegroundColor Yellow
try {
    $plans = mysql -h localhost -u root -e "USE baozipu; SELECT plan_id, status FROM pipeline_plans ORDER BY plan_id;" 2>&1
    $completedCount = ($plans | Select-String "completed").Count
    $totalCount = ($plans | Measure-Object -Line).Lines - 1  # 减去标题行
    Write-Host "   ✅ 计划总数：$totalCount, 已完成：$completedCount" -ForegroundColor Green
} catch {
    Write-Host "   ❌ 查询计划数据失败：$_" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  配置验证完成" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan
