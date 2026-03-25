# Plan Manager - 创建计划
# 用法：.\create-plan.ps1 -编号 "006" -名称 "用户中心" [-优先级 "P1"] [-轮次 5] [-负责人 "酱肉"] [-预计耗时 "2h"]

param(
    [Parameter(Mandatory=$true)]
    [string]$编号,
    
    [Parameter(Mandatory=$true)]
    [string]$名称,
    
    [string]$优先级 = "P1",
    
    [int]$轮次 = 5,
    
    [string]$负责人 = "酱肉",
    
    [string]$预计耗时 = "2h"
)

$ErrorActionPreference = "Stop"
$basePath = "F:\openclaw\agent\tasks\01-plans"
$templatePath = "F:\openclaw\agent\workspace-guantang\skills\plan-manager\templates"
$masterPlanPath = "F:\openclaw\agent\tasks\00-master\master-plan-overview.md"
$workinglogPath = "F:\openclaw\agent\workinglog\guantang"

# 生成计划文件夹名
$planFolderName = "plan-{0:D3}-p{1}-{2}" -f [int]$编号, $优先级.ToLower(), $名称
$planFolderPath = Join-Path $basePath $planFolderName

Write-Host "正在创建计划：Plan-$编号 - $名称" -ForegroundColor Cyan

# 1. 创建计划文件夹
if (Test-Path $planFolderPath) {
    Write-Host "错误：计划文件夹已存在：$planFolderPath" -ForegroundColor Red
    exit 1
}
New-Item -ItemType Directory -Path $planFolderPath -Force | Out-Null
Write-Host "✓ 创建计划文件夹：$planFolderName" -ForegroundColor Green

# 2. 复制模板文件
$templates = @(
    "00-plan-template.md",
    "01-round-orders-template.md",
    "02-verify-list-template.md",
    "03-review-template.md",
    "04-feishu-logs-template.md"
)

foreach ($template in $templates) {
    $sourcePath = Join-Path $templatePath $template
    $destName = $template -replace "-template", ""
    $destPath = Join-Path $planFolderPath $destName
    
    if (Test-Path $sourcePath) {
        Copy-Item $sourcePath $destPath -Force
        Write-Host "✓ 创建文档：$destName" -ForegroundColor Green
    } else {
        Write-Host "⚠ 模板不存在：$template" -ForegroundColor Yellow
    }
}

# 3. 填充 00-plan.md 元数据
$planFile = Join-Path $planFolderPath "00-plan.md"
$content = Get-Content $planFile -Raw
$content = $content -replace "{编号}", $编号
$content = $content -replace "{计划名称}", "$优先级-$名称"
$content = $content -replace "{日期}", (Get-Date -Format "yyyy-MM-dd")
$content = $content -replace "{时间}", (Get-Date -Format "yyyy-MM-dd HH:mm")
$content = $content -replace "{N}", $轮次.ToString()
$content = $content -replace "{开始时间}", (Get-Date -Format "yyyy-MM-dd HH:mm")
Set-Content $planFile $content -NoNewline
Write-Host "✓ 填充计划元数据" -ForegroundColor Green

# 4. 更新 master-plan-overview.md
if (Test-Path $masterPlanPath) {
    $masterContent = Get-Content $masterPlanPath -Raw
    $newRow = "| Plan-{0:D3} | {1}-{2} | {1} | {3} 轮 | {4} | ⏳ 等待 | - |" -f `
        [int]$编号, $优先级, $名称, $轮次, (Get-Date -Format "yyyy-MM-dd HH:mm")
    
    # 在表格头部后插入新行（查找表头分隔符）
    $lines = $masterContent -split "`n"
    $newLines = @()
    $inserted = $false
    
    foreach ($line in $lines) {
        $newLines += $line
        if ($line -match "^\|.*计划 ID.*\|.*计划名称.*\|" -and -not $inserted) {
            # 跳过表头分隔符行
            continue
        } elseif ($line -match "^\| Plan-\d+ \| " -and -not $inserted) {
            # 在第一行数据前插入
            $newRows = $newLines
            $newLines = @()
            foreach ($l in $newRows) {
                $newLines += $l
            }
            $newLines += $newRow
            $inserted = $true
        }
    }
    
    if (-not $inserted) {
        $newLines += $newRow
    }
    
    Set-Content $masterPlanPath ($newLines -join "`n") -NoNewline
    Write-Host "✓ 更新 master-plan-overview.md" -ForegroundColor Green
}

# 5. 创建工作日志
$logFile = Join-Path $workinglogPath ("{0}-guantang-创建计划-{1}.md" -f (Get-Date -Format "yyyyMMdd-HHmmss"), $名称)
$logContent = @"
<!-- Last Modified: $(Get-Date -Format "yyyy-MM-dd HH:mm") -->

# 工作日志

## 修改信息
- **修改人:** 灌汤
- **修改时间:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
- **任务类型:** task

## 任务内容
使用 plan-manager skill 创建新计划

**计划信息:**
- 计划编号：Plan-$编号
- 计划名称：$优先级-$名称
- 优先级：$优先级
- 轮次：$轮次
- 负责人：$负责人
- 预计耗时：$预计耗时

**交付物:**
- 计划文件夹：$planFolderName
- 5 个配套文档已创建

## 修改的文件
- \`tasks/01-plans/$planFolderName/00-plan.md\` - 新建
- \`tasks/01-plans/$planFolderName/01-round-orders.md\` - 新建
- \`tasks/01-plans/$planFolderName/02-verify-list.md\` - 新建
- \`tasks/01-plans/$planFolderName/03-review.md\` - 新建
- \`tasks/01-plans/$planFolderName/04-feishu-logs.md\` - 新建

## 关联通知
- [ ] 已通知$负责人准备第 1 轮任务
- [ ] 已推送到 GitHub

---

*日志自动生成*
"@
Set-Content $logFile $logContent -NoNewline
Write-Host "✓ 创建工作日志" -ForegroundColor Green

Write-Host "`n✅ 计划创建完成！" -ForegroundColor Green
Write-Host "计划路径：$planFolderPath" -ForegroundColor Cyan
Write-Host "下一步：派发第 1 轮任务给$负责人" -ForegroundColor Cyan
