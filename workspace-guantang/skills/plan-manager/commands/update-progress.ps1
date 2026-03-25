# Plan Manager - 更新进度
# 用法：.\update-progress.ps1 -计划编号 "006" -轮次 1 -状态 "completed" [-实际耗时 "10m"] [-备注 ""]

param(
    [Parameter(Mandatory=$true)]
    [string]$计划编号,
    
    [Parameter(Mandatory=$true)]
    [int]$轮次,
    
    [Parameter(Mandatory=$true)]
    [ValidateSet("pending", "in-progress", "completed", "timeout", "failed")]
    [string]$状态,
    
    [string]$实际耗时 = "",
    
    [string]$备注 = ""
)

$ErrorActionPreference = "Stop"
$basePath = "F:\openclaw\agent\tasks\01-plans"
$masterPlanPath = "F:\openclaw\agent\tasks\00-master\master-plan-overview.md"
$workinglogPath = "F:\openclaw\agent\workinglog\guantang"

# 查找计划文件夹
$planFolder = Get-ChildItem $basePath -Directory | Where-Object { $_.Name -like "*plan-{0:D3}-*" -f [int]$计划编号 }
if (-not $planFolder) {
    Write-Host "错误：未找到计划 Plan-$计划编号" -ForegroundColor Red
    exit 1
}

$planPath = $planFolder.FullName
$planFile = Join-Path $planPath "00-plan.md"
$roundsFile = Join-Path $planPath "01-round-orders.md"

if (-not (Test-Path $planFile)) {
    Write-Host "错误：计划文件不存在：$planFile" -ForegroundColor Red
    exit 1
}

Write-Host "正在更新进度：Plan-$计划编号 第$轮次 轮 - $状态" -ForegroundColor Cyan

# 1. 更新 00-plan.md 进度表
$content = Get-Content $planFile -Raw
$now = Get-Date -Format "yyyy-MM-dd HH:mm"
$actualTime = if ($实际耗时) { $实际耗时 } else { (Get-Date -Format "HH:mm") }

# 查找并更新对应轮次的行
$lines = $content -split "`n"
$newLines = @()
$updated = $false

foreach ($line in $lines) {
    if ($line -match "^\| $轮次 \| " -and -not $updated) {
        # 提取原有内容
        $parts = $line -split "\|"
        if ($parts.Count -ge 8) {
            $task = $parts[2].Trim()
            $owner = $parts[3].Trim()
            $newLine = "| {0} | {1} | {2} | {3} | {4} | {5} | {6} |" -f `
                $轮次, $task, $owner, 
                (if ($状态 -eq "completed") { "✅" } 
                 elseif ($状态 -eq "in-progress") { "🟢" } 
                 elseif ($状态 -eq "timeout") { "🔴" }
                 elseif ($状态 -eq "failed") { "❌" }
                 else { "⏳" }),
                $now, $actualTime, $actualTime
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

## 第$轮次 轮

**派发时间:** $now  
**完成时间:** $now  
**实际耗时:** $actualTime  
**状态:** $(if ($状态 -eq "completed") { "✅ 完成" } else { "⏳ 待执行" })

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

# 3. 更新 master-plan-overview.md
if (Test-Path $masterPlanPath) {
    # 简化处理：不更新具体进度，由 PM 手动更新
    Write-Host "ℹ  master-plan-overview.md 需手动更新进度" -ForegroundColor Yellow
}

# 4. 创建工作日志
$logFile = Join-Path $workinglogPath ("{0}-guantang-更新进度 -Plan{1}-轮次{2}.md" -f (Get-Date -Format "yyyyMMdd-HHmmss"), $计划编号, $轮次)
$logContent = @"
<!-- Last Modified: $(Get-Date -Format "yyyy-MM-dd HH:mm") -->

# 工作日志

## 修改信息
- **修改人:** 灌汤
- **修改时间:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
- **任务类型:** task

## 任务内容
使用 plan-manager skill 更新计划进度

**计划信息:**
- 计划编号：Plan-$计划编号
- 更新轮次：第$轮次 轮
- 状态：$状态
- 实际耗时：$actualTime
- 备注：$备注

## 修改的文件
- \`tasks/01-plans/plan-{0:D3}-*/00-plan.md\` - 更新进度表
- \`tasks/01-plans/plan-{0:D3}-*/01-round-orders.md\` - 添加轮次记录
"@ -f [int]$计划编号
Set-Content $logFile $logContent -NoNewline
Write-Host "✓ 创建工作日志" -ForegroundColor Green

Write-Host "`n✅ 进度更新完成！" -ForegroundColor Green
Write-Host "下一步：派发第$($轮次 + 1) 轮任务" -ForegroundColor Cyan
