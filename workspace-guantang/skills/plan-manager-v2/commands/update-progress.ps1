# Plan Manager v2 - 更新进度（数据库双写版）
# 用法：.\update-progress.ps1 -plan-id "007" -round 1 -status "completed" [-actual-time "10m"]

param(
    [Parameter(Mandatory=$true)]
    [string]$planId,
    
    [Parameter(Mandatory=$true)]
    [int]$round,
    
    [Parameter(Mandatory=$true)]
    [ValidateSet("pending", "in-progress", "completed", "timeout", "failed")]
    [string]$status,
    
    [string]$actualTime = ""
)

$ErrorActionPreference = "Stop"

# 配置
$basePath = "F:\openclaw\agent\tasks\01-plans"
$masterPlanPath = "F:\openclaw\agent\tasks\00-master\master-plan-overview.md"
$workinglogPath = "F:\openclaw\agent\workinglog\guantang"
$dbConfig = "F:\openclaw\agent\.local\pipeline-db-config.ps1"

# 加载数据库配置
if (Test-Path $dbConfig) {
    . $dbConfig
} else {
    Write-Host "⚠️ 数据库配置文件不存在，跳过数据库写入" -ForegroundColor Yellow
    $dbHost = $null
}

# 查找计划文件夹
$planFolder = Get-ChildItem $basePath -Directory | Where-Object { $_.Name -like "*plan-{0:D3}-*" -f [int]$planId }
if (-not $planFolder) {
    Write-Host "错误：未找到计划 Plan-$planId" -ForegroundColor Red
    exit 1
}

$planPath = $planFolder.FullName
$planFile = Join-Path $planPath "00-plan.md"
$roundsFile = Join-Path $planPath "01-round-orders.md"

if (-not (Test-Path $planFile)) {
    Write-Host "错误：计划文件不存在：$planFile" -ForegroundColor Red
    exit 1
}

Write-Host "正在更新进度：Plan-$planId 第$round 轮 - $status (v2 数据库双写版)" -ForegroundColor Cyan

# 1. 更新 00-plan.md 进度表
$content = Get-Content $planFile -Raw
$now = Get-Date -Format "yyyy-MM-dd HH:mm"
$actualTimeValue = if ($actualTime) { $actualTime } else { "0m" }

$lines = $content -split "`n"
$newLines = @()
$updated = $false

foreach ($line in $lines) {
    if ($line -match "^\| $round \| " -and -not $updated) {
        $parts = $line -split "\|"
        if ($parts.Count -ge 8) {
            $task = $parts[2].Trim()
            $owner = $parts[3].Trim()
            $statusIcon = switch ($status) {
                "completed" { "✅" }
                "in-progress" { "🟢" }
                "timeout" { "🔴" }
                "failed" { "❌" }
                default { "⏳" }
            }
            $newLine = "| {0} | {1} | {2} | {3} | {4} | {5} | {6} |" -f `
                $round, $task, $owner, $statusIcon, $now, $actualTimeValue, $actualTimeValue
            $newLines += $newLine
            $updated = $true
            continue
        }
    }
    $newLines += $line
}

Set-Content $planFile ($newLines -join "`n") -NoNewline
Write-Host "✓ 更新 00-plan.md 进度表" -ForegroundColor Green

# 2. 更新 01-round-orders.md
$roundsContent = Get-Content $roundsFile -Raw
$roundEntry = @"

## 第$round 轮

**派发时间:** $now  
**完成时间:** $now  
**实际耗时:** $actualTimeValue  
**状态:** $(if ($status -eq "completed") { "✅ 完成" } else { "⏳ 待执行" })

**PM 验证:**
- [ ] 验证项 1: 待验证
- [ ] 验证项 2: 待验证

**验证时间:** $now  
**验证人:** 灌汤

---
"@

$roundsContent += $roundEntry
Set-Content $roundsFile $roundsContent -NoNewline
Write-Host "✓ 更新 01-round-orders.md" -ForegroundColor Green

# 3. 【v2 新增】更新数据库
$dbSuccess = $true
if ($dbHost) {
    Write-Host "正在更新数据库..." -ForegroundColor Cyan
    
    try {
        # 更新 pipeline_plans
        $updatePlanSql = @"
UPDATE pipeline_plans 
SET current_round = $round, status = 'executing', updated_at = NOW()
WHERE plan_id = 'plan-$planId';
"@
        mysql -h $dbHost -P $dbPort -u $dbUser -p$dbPass $dbName -e $updatePlanSql 2>$null
        Write-Host "✓ 更新 pipeline_plans 表" -ForegroundColor Green
        
        # 更新 pipeline_rounds
        $verified = if ($status -eq "completed") { "TRUE" } else { "FALSE" }
        $updateRoundSql = @"
UPDATE pipeline_rounds 
SET status = '$status', verified = $verified, completed_at = NOW()
WHERE plan_id = 'plan-$planId' AND round_id = $round;
"@
        mysql -h $dbHost -P $dbPort -u $dbUser -p$dbPass $dbName -e $updateRoundSql 2>$null
        Write-Host "✓ 更新 pipeline_rounds 表" -ForegroundColor Green
        
        # 写入状态历史
        $insertHistorySql = @"
INSERT INTO pipeline_state_history (plan_id, round_id, old_status, new_status, change_reason)
VALUES ('plan-$planId', $round, 'pending', '$status', 'plan_manager_v2_update');
"@
        mysql -h $dbHost -P $dbPort -u $dbUser -p$dbPass $dbName -e $insertHistorySql 2>$null
        Write-Host "✓ 写入 pipeline_state_history 表" -ForegroundColor Green
        
    } catch {
        Write-Host "⚠️ 数据库更新失败：$_" -ForegroundColor Yellow
        $dbSuccess = $false
        
        # 记录错误日志
        $errorLog = "skills/plan-manager-v2/logs/db-errors.md"
        if (-not (Test-Path $errorLog)) {
            "# 数据库错误日志`n`n" | Out-File -FilePath $errorLog -Encoding utf8
        }
        $errorMsg = "## $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - 更新进度失败`n`n计划：Plan-$planId, 轮次：$round`n错误：$_`n`n"
        Add-Content -Path $errorLog -Value $errorMsg
    }
}

# 4. 创建工作日志
$logFile = Join-Path $workinglogPath ("{0}-guantang-更新进度 -Plan{1}-R{2}.md" -f (Get-Date -Format "yyyyMMdd-HHmmss"), $planId, $round)
$logContent = @"
<!-- Last Modified: $(Get-Date -Format "yyyy-MM-dd HH:mm") -->

# 工作日志

## 修改信息
- **修改人:** 灌汤
- **修改时间:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
- **任务类型:** task

## 任务内容
使用 plan-manager-v2 skill 更新计划进度（数据库双写）

**计划信息:**
- 计划编号：Plan-$planId
- 更新轮次：第$round 轮
- 状态：$status
- 实际耗时：$actualTimeValue

**数据库状态:** $(if ($dbSuccess) { "✅ 已同步" } else { "⚠️ 写入失败，待补写" })

## 修改的文件
- \`tasks/01-plans/plan-{0:D3}-*/00-plan.md\` - 更新进度表
- \`tasks/01-plans/plan-{0:D3}-*/01-round-orders.md\` - 添加轮次记录
"@ -f [int]$planId
Set-Content $logFile $logContent -NoNewline
Write-Host "✓ 创建工作日志" -ForegroundColor Green

Write-Host "`n✅ 进度更新完成！" -ForegroundColor Green
if ($dbSuccess) {
    Write-Host "数据库状态：✅ 已同步" -ForegroundColor Green
} else {
    Write-Host "数据库状态：⚠️ 写入失败，请手动补写" -ForegroundColor Yellow
}
Write-Host "下一步：派发第$($round + 1) 轮任务" -ForegroundColor Cyan
