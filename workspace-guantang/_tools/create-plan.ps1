# 创建计划统一入口脚本
# 用途：一键创建计划（数据库 + 文档 + 日志 + 上下文同步）
# 用法：.\create-plan.ps1 -planId "plan-016" -planName "名称" -priority "P0" -rounds 3 -agents "jiangrou,dousha,suancai"

param(
    [string]$planId,
    [string]$planName,
    [string]$priority = "P1",
    [int]$rounds = 3,
    [string]$agents = "jiangrou,dousha,suancai",
    [string]$owner = "guantang"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  创建计划：$planId - $planName" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 1. 获取锁
Write-Host "`n[1/6] 获取锁..." -ForegroundColor Yellow
$lockResult = powershell -ExecutionPolicy Bypass -File "F:\openclaw\agent\workspace-guantang\_tools\acquire-lock.ps1" -sessionId "create-plan-$planId" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 获取锁失败：$lockResult" -ForegroundColor Red
    exit 1
}
Write-Host "✅ 锁已获取" -ForegroundColor Green

# 2. 检查幂等
Write-Host "`n[2/6] 检查幂等..." -ForegroundColor Yellow
$existingPlan = mysql -h localhost -u root openclaw -N -e "SELECT plan_id FROM plan_progress WHERE plan_id='$planId';" 2>$null
if ($existingPlan) {
    Write-Host "⚠️  计划已存在：$planId" -ForegroundColor Yellow
    powershell -ExecutionPolicy Bypass -File "F:\openclaw\agent\workspace-guantang\_tools\release-lock.ps1" -sessionId "create-plan-$planId" 2>$null
    exit 0
}
Write-Host "✅ 幂等检查通过" -ForegroundColor Green

# 3. 插入数据库
Write-Host "`n[3/6] 插入数据库..." -ForegroundColor Yellow
mysql -h localhost -u root openclaw -e "INSERT INTO plan_progress (plan_id, plan_name, current_round, total_rounds, status, locked_by) VALUES ('$planId', '$planName', 1, $rounds, 'pending', '$owner');" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 数据库插入失败" -ForegroundColor Red
    powershell -ExecutionPolicy Bypass -File "F:\openclaw\agent\workspace-guantang\_tools\release-lock.ps1" -sessionId "create-plan-$planId" 2>$null
    exit 1
}

# 插入 Agent 任务
$agentList = $agents.Split(",")
foreach ($agent in $agentList) {
    $agent = $agent.Trim()
    mysql -h localhost -u root openclaw -e "INSERT INTO step_execution (plan_id, round, step_name, agent_id, status) VALUES ('$planId', 1, '计划任务', '$agent', 'pending');" 2>$null
}
Write-Host "✅ 数据库插入完成" -ForegroundColor Green

# 4. 创建文档目录
Write-Host "`n[4/6] 创建文档目录..." -ForegroundColor Yellow
$planDir = "F:\openclaw\agent\tasks\01-plans\$planId-p$priority-$planName"
$planDir = $planDir -replace '\s+', '-'
New-Item -ItemType Directory -Force -Path $planDir | Out-Null

$planDoc = @"
<!-- Last Modified: $(Get-Date -Format "yyyy-MM-dd HH:mm") -->

# $planId — $planName

**优先级:** $priority  
**创建时间:** $(Get-Date -Format "yyyy-MM-dd HH:mm")  
**负责人:** $owner  
**状态:** pending

---

## 📋 计划目标

{填写计划目标}

---

## 🔄 轮次规划

| 轮次 | Agent | 任务 | 状态 | 预计时间 |
|------|-------|------|------|---------|
| R1 | - | - | pending | - |
| R2 | - | - | pending | - |
| R3 | - | - | pending | - |

---

## 📄 相关文档

- [整合改造方案](../../doc/02-specs/02-business-specs/)

---

*$planId | $planName | $owner | $(Get-Date -Format "yyyy-MM-dd HH:mm")*
"@

$planDoc | Out-File -FilePath "$planDir\00-plan.md" -Encoding utf8

$roundDoc = @"
<!-- Last Modified: $(Get-Date -Format "yyyy-MM-dd HH:mm") -->

# $planId 轮次工单记录

---

## R1: 待定

**状态:** pending

| 任务 | 交付物 | 状态 | 完成时间 |
|------|--------|------|---------|
| - | - | ⏳ pending | - |

---

*$planId | $planName | $owner | $(Get-Date -Format "yyyy-MM-dd HH:mm")*
"@

$roundDoc | Out-File -FilePath "$planDir\01-round-orders.md" -Encoding utf8

Write-Host "✅ 文档目录创建完成：$planDir" -ForegroundColor Green

# 5. 记录工作日志
Write-Host "`n[5/6] 记录工作日志..." -ForegroundColor Yellow
$logDir = "F:\openclaw\agent\workinglog\guantang"
if (!(Test-Path $logDir)) {
    New-Item -ItemType Directory -Force -Path $logDir | Out-Null
}
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$logFile = "$logDir\$timestamp-guantang-create-$planId.md"
$logContent = @"
<!-- Last Modified: $(Get-Date -Format "yyyy-MM-dd HH:mm") -->

# 工作日志

## 修改信息
- **修改人:** 灌汤
- **修改时间:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
- **任务类型:** plan

## 任务内容
创建计划：$planId - $planName

## 修改的文件
- \`tasks\01-plans\$planId\00-plan.md\` - 计划文档
- \`tasks\01-plans\$planId\01-round-orders.md\` - 轮次工单

## 数据库操作
- INSERT plan_progress ($planId)
- INSERT step_execution (Agent 任务)

## 关联通知
- [x] 已插入数据库
- [x] 已创建文档目录
- [ ] 待同步 Agent 上下文

---

*日志自动生成*
"@
$logContent | Out-File -FilePath $logFile -Encoding utf8
Write-Host "✅ 工作日志已记录：$logFile" -ForegroundColor Green

# 6. 同步 Agent 上下文
Write-Host "`n[6/6] 同步 Agent 上下文..." -ForegroundColor Yellow
powershell -ExecutionPolicy Bypass -File "F:\openclaw\agent\workspace-guantang\_tools\sync-agent-context.ps1" 2>$null
Write-Host "✅ Agent 上下文已同步" -ForegroundColor Green

# 释放锁
powershell -ExecutionPolicy Bypass -File "F:\openclaw\agent\workspace-guantang\_tools\release-lock.ps1" -sessionId "create-plan-$planId" 2>$null

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  ✅ 计划创建完成：$planId" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "`n下一步：" -ForegroundColor Yellow
Write-Host "1. 编辑 $planDir\00-plan.md 完善计划详情" -ForegroundColor White
Write-Host "2. 编辑 $planDir\01-round-orders.md 添加工单" -ForegroundColor White
Write-Host "3. 使用 npx plan-manager-v2 启动计划" -ForegroundColor White
