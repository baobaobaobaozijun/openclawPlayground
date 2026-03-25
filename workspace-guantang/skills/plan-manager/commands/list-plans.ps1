# Plan Manager - 列出计划
# 用法：.\list-plans.ps1 [-状态 "in-progress"] [-优先级 "P0"]

param(
    [ValidateSet("pending", "in-progress", "completed", "failed", "timeout")]
    [string]$状态 = "",
    
    [ValidateSet("P0", "P1", "P2")]
    [string]$优先级 = ""
)

$ErrorActionPreference = "Stop"
$basePath = "F:\openclaw\agent\tasks\01-plans"

Write-Host "`n计划列表" -ForegroundColor Cyan
Write-Host "========`n" -ForegroundColor Cyan

# 获取所有计划文件夹
$plans = Get-ChildItem $basePath -Directory | Sort-Object Name

if ($plans.Count -eq 0) {
    Write-Host "暂无计划" -ForegroundColor Yellow
    exit 0
}

# 输出表格头部
$header = "{0,-10} | {1,-20} | {2,-8} | {3,-8} | {4,-10} | {5,-8}" -f `
    "计划 ID", "计划名称", "优先级", "轮次", "状态", "进度"
$separator = "{0,-10}-+-{1,-20}-+-{2,-8}-+-{3,-8}-+-{4,-10}-+-{5,-8}" -f `
    "----------", "--------------------", "--------", "--------", "----------", "--------"

Write-Host $header
Write-Host $separator

# 遍历所有计划
foreach ($plan in $plans) {
    $planName = $plan.Name
    
    # 解析计划信息
    if ($planName -match "plan-(\d{3})-p(\d)-(.+)") {
        $id = $matches[1]
        $priority = "P" + $matches[2]
        $name = $matches[3]
    } else {
        continue
    }
    
    # 过滤条件
    if ($状态 -and $planName -notmatch $状态) { continue }
    if ($优先级 -and $priority -ne $优先级) { continue }
    
    # 读取计划文件获取状态
    $planFile = Join-Path $plan.FullName "00-plan.md"
    if (Test-Path $planFile) {
        $content = Get-Content $planFile -Raw
        
        # 提取轮次信息
        $totalRounds = 5
        if ($content -match "总轮次:\s*(\d+)") {
            $totalRounds = [int]$matches[1]
        }
        
        # 计算完成轮次
        $completedRounds = ([regex]::Matches($content, "✅")).Count
        
        # 提取状态
        $planStatus = "⏳ 等待"
        if ($content -match "状态:\s*(pending|in-progress|completed|failed|timeout)") {
            $statusMap = @{
                "pending" = "⏳ 等待"
                "in-progress" = "🟢 进行中"
                "completed" = "✅ 完成"
                "failed" = "❌ 失败"
                "timeout" = "🔴 超时"
            }
            $planStatus = $statusMap[$matches[1]]
        }
        
        # 计算进度
        $progress = "{0:P0}" -f ($completedRounds / $totalRounds)
    } else {
        $planStatus = "⏳ 等待"
        $progress = "0%"
        $completedRounds = 0
    }
    
    # 输出行
    $row = "{0,-10} | {1,-20} | {2,-8} | {3,-8} | {4,-10} | {5,-8}" -f `
        $id, $name, $priority, "$completedRounds/$totalRounds", $planStatus, $progress
    Write-Host $row
}

Write-Host "`n提示：使用 --状态 和 --优先级 参数过滤结果" -ForegroundColor Gray
Write-Host "示例：npx plan-manager 列出计划 --状态 in-progress" -ForegroundColor Gray
