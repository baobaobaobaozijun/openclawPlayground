# Plan Manager - 查看计划
# 用法：.\view-plan.ps1 -计划编号 "006"

param(
    [Parameter(Mandatory=$true)]
    [string]$计划编号
)

$ErrorActionPreference = "Stop"
$basePath = "F:\openclaw\agent\tasks\01-plans"

# 查找计划文件夹
$planFolder = Get-ChildItem $basePath -Directory | Where-Object { $_.Name -like "*plan-{0:D3}-*" -f [int]$计划编号 }
if (-not $planFolder) {
    Write-Host "错误：未找到计划 Plan-$计划编号" -ForegroundColor Red
    exit 1
}

$planPath = $planFolder.FullName
$planFile = Join-Path $planPath "00-plan.md"

if (-not (Test-Path $planFile)) {
    Write-Host "错误：计划文件不存在：$planFile" -ForegroundColor Red
    exit 1
}

Write-Host "`n计划详情：Plan-$计划编号" -ForegroundColor Cyan
Write-Host "=========================`n" -ForegroundColor Cyan

# 读取并解析计划文件
$content = Get-Content $planFile -Raw

# 提取基本信息
if ($content -match "# Plan-(\d+):\s*(.+)") {
    Write-Host "计划编号：$($matches[1])" -ForegroundColor White
    Write-Host "计划名称：$($matches[2])" -ForegroundColor White
}

if ($content -match "状态:\s*(pending|in-progress|completed|failed|timeout)") {
    $statusMap = @{
        "pending" = "⏳ 等待"
        "in-progress" = "🟢 进行中"
        "completed" = "✅ 完成"
        "failed" = "❌ 失败"
        "timeout" = "🔴 超时"
    }
    Write-Host "状态：$($statusMap[$matches[1]])" -ForegroundColor White
}

if ($content -match "创建日期:\s*(.+)") {
    Write-Host "创建日期：$($matches[1])" -ForegroundColor White
}

if ($content -match "总轮次:\s*(\d+)") {
    Write-Host "总轮次：$($matches[1])" -ForegroundColor White
}

# 计算完成轮次
$completedRounds = ([regex]::Matches($content, "✅")).Count
Write-Host "已完成：$completedRounds 轮" -ForegroundColor White

# 输出轮次详情
Write-Host "`n轮次详情:" -ForegroundColor Cyan
Write-Host "--------`n" -ForegroundColor Cyan

$lines = $content -split "`n"
$inTable = $false

foreach ($line in $lines) {
    if ($line -match "^\| 轮次 \| 任务 \|") {
        $inTable = $true
        continue
    }
    if ($inTable -and $line -match "^\|") {
        if ($line -match "^\|-+") {
            continue
        }
        # 解析表格行
        $parts = $line -split "\|" | Where-Object { $_.Trim() }
        if ($parts.Count -ge 6) {
            $roundNum = $parts[0].Trim()
            $task = $parts[1].Trim()
            $owner = $parts[2].Trim()
            $status = $parts[3].Trim()
            
            if ($roundNum -match "^\d+$") {
                $statusIcon = switch ($status) {
                    "✅" { "✅" }
                    "🟢" { "🟢" }
                    "⏳" { "⏳" }
                    "🔴" { "🔴" }
                    "❌" { "❌" }
                    default { "⏳" }
                }
                Write-Host "  第$roundNum 轮：$task ($owner) $statusIcon" -ForegroundColor Gray
            }
        }
    }
    if ($inTable -and $line -notmatch "^\|") {
        break
    }
}

Write-Host "`n计划路径：$planPath" -ForegroundColor Cyan
Write-Host "提示：使用 npx plan-manager 列出计划 查看所有计划" -ForegroundColor Gray
