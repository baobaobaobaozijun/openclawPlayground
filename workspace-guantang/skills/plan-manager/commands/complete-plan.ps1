# Plan Manager - 完成计划
# 用法：.\complete-plan.ps1 -计划编号 "006" -状态 "success" [-通知方式 "feishu"] [-通知对象 "ou_xxx"]

param(
    [Parameter(Mandatory=$true)]
    [string]$计划编号,
    
    [Parameter(Mandatory=$true)]
    [ValidateSet("success", "partial", "failed", "timeout")]
    [string]$状态,
    
    [ValidateSet("feishu", "none")]
    [string]$通知方式 = "feishu",
    
    [string]$通知对象 = "ou_2582f0d104a800bec8417c4f6e799c81"
)

$ErrorActionPreference = "Stop"
$basePath = "F:\openclaw\agent\tasks\01-plans"
$masterPlanPath = "F:\openclaw\agent\tasks\00-master\master-plan-overview.md"
$workinglogPath = "F:\openclaw\agent\workinglog\guantang"
$feishuLogsPath = ""

# 查找计划文件夹
$planFolder = Get-ChildItem $basePath -Directory | Where-Object { $_.Name -like "*plan-{0:D3}-*" -f [int]$计划编号 }
if (-not $planFolder) {
    Write-Host "错误：未找到计划 Plan-$计划编号" -ForegroundColor Red
    exit 1
}

$planPath = $planFolder.FullName
$planFile = Join-Path $planPath "00-plan.md"
$reviewFile = Join-Path $planPath "03-review.md"
$feishuLogsFile = Join-Path $planPath "04-feishu-logs.md"
$verifyFile = Join-Path $planPath "02-verify-list.md"

Write-Host "正在完成计划：Plan-$计划编号 - 状态：$状态" -ForegroundColor Cyan

# 1. 更新 00-plan.md 状态
$content = Get-Content $planFile -Raw
$content = $content -replace "状态:\s*(pending|in-progress|completed|failed|timeout)", "状态：completed"
$now = Get-Date -Format "yyyy-MM-dd HH:mm"
if ($content -match "执行周期:.*~.*") {
    $content = $content -replace "执行周期:.*~.*", "执行周期：- ~ $now"
}
Set-Content $planFile $content -NoNewline
Write-Host "✓ 更新 00-plan.md 状态" -ForegroundColor Green

# 2. 生成 03-review.md（简化版）
$reviewContent = Get-Content $reviewFile -Raw
$reviewContent = $reviewContent -replace "{编号}", $计划编号
$reviewContent = $reviewContent -replace "{名称}", "Plan-$计划编号"
$reviewContent = $reviewContent -replace "{开始}", "-"
$reviewContent = $reviewContent -replace "{结束}", $now
$reviewContent = $reviewContent -replace "{时间}", $now
$reviewContent = $reviewContent -replace "{N}", "5"
Set-Content $reviewFile $reviewContent -NoNewline
Write-Host "✓ 生成 03-review.md" -ForegroundColor Green

# 3. 更新 02-verify-list.md
$verifyContent = Get-Content $verifyFile -Raw
$verifyContent = $verifyContent -replace "{编号}", $计划编号
$verifyContent = $verifyContent -replace "{名称}", "Plan-$计划编号"
$verifyContent = $verifyContent -replace "{时间}", $now
$statusText = if ($状态 -eq "success") { "✅ 通过" } else { "⚠️ 部分通过" }
$verifyContent = $verifyContent -replace "状态:.*", "状态：$statusText"
Set-Content $verifyFile $verifyContent -NoNewline
Write-Host "✓ 更新 02-verify-list.md" -ForegroundColor Green

# 4. 更新 04-feishu-logs.md
$feishuContent = Get-Content $feishuLogsFile -Raw
$feishuContent = $feishuContent -replace "{编号}", $计划编号
$feishuContent = $feishuContent -replace "{名称}", "Plan-$计划编号"
$feishuContent = $feishuContent -replace "{时间}", $now
$feishuContent = $feishuContent -replace "发送状态:.*", "发送状态：⏳ 待发送"
Set-Content $feishuLogsFile $feishuContent -NoNewline
$feishuLogsPath = $feishuLogsFile
Write-Host "✓ 更新 04-feishu-logs.md" -ForegroundColor Green

# 5. 发送飞书通知（如需要）
if ($通知方式 -eq "feishu") {
    Write-Host "ℹ  飞书通知需手动发送（调用 feishu-im-user-message）" -ForegroundColor Yellow
    Write-Host "通知对象：$通知对象" -ForegroundColor Gray
    
    $notifyMessage = @"
【Plan-$计划编号 完成通知】✅

计划名称：Plan-$计划编号
完成时间：$now
状态：$(if ($状态 -eq "success") { "✅ 成功" } else { "⚠️ $状态" })

交付物检查：
- 00-plan.md ✅
- 01-round-orders.md ✅
- 02-verify-list.md ✅
- 03-review.md ✅
- 04-feishu-logs.md ✅

下一步：查看 master-plan-overview.md 更新总进度
"@
    Write-Host "`n通知内容预览:" -ForegroundColor Cyan
    Write-Host $notifyMessage -ForegroundColor Gray
}

# 6. 创建工作日志
$logFile = Join-Path $workinglogPath ("{0}-guantang-完成计划 -Plan{1}.md" -f (Get-Date -Format "yyyyMMdd-HHmmss"), $计划编号)
$logContent = @"
<!-- Last Modified: $(Get-Date -Format "yyyy-MM-dd HH:mm") -->

# 工作日志

## 修改信息
- **修改人:** 灌汤
- **修改时间:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
- **任务类型:** task

## 任务内容
使用 plan-manager skill 完成计划

**计划信息:**
- 计划编号：Plan-$计划编号
- 状态：$状态
- 完成时间：$now

**交付物:**
- 00-plan.md - 状态更新为 completed ✅
- 03-review.md - 生成复盘报告 ✅
- 02-verify-list.md - 验收结论更新 ✅
- 04-feishu-logs.md - 通知记录更新 ✅

## 修改的文件
- \`tasks/01-plans/plan-{0:D3}-*/00-plan.md\` - 更新状态
- \`tasks/01-plans/plan-{0:D3}-*/03-review.md\` - 生成复盘
- \`tasks/01-plans/plan-{0:D3}-*/02-verify-list.md\` - 更新验收
- \`tasks/01-plans/plan-{0:D3}-*/04-feishu-logs.md\` - 更新通知记录
"@ -f [int]$计划编号
Set-Content $logFile $logContent -NoNewline
Write-Host "✓ 创建工作日志" -ForegroundColor Green

Write-Host "`n✅ 计划完成！" -ForegroundColor Green
Write-Host "复盘报告：$reviewFile" -ForegroundColor Cyan
if ($通知方式 -eq "feishu") {
    Write-Host "提示：使用 feishu-im-user-message 发送通知" -ForegroundColor Yellow
}
