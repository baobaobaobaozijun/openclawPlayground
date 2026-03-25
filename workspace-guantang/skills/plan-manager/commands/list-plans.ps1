# Plan Manager - List Plans
# Usage: .\list-plans.ps1 [-Status "in-progress"] [-Priority "P0"]

param(
    [ValidateSet("pending", "in-progress", "completed", "failed", "timeout")]
    [string]$Status = "",
    
    [ValidateSet("P0", "P1", "P2")]
    [string]$Priority = ""
)

$ErrorActionPreference = "Stop"
$basePath = "F:\openclaw\agent\tasks\01-plans"

Write-Host "`nPlan List" -ForegroundColor Cyan
Write-Host "=========`n" -ForegroundColor Cyan

# Get all plan folders
$plans = Get-ChildItem $basePath -Directory | Sort-Object Name

if ($plans.Count -eq 0) {
    Write-Host "No plans found" -ForegroundColor Yellow
    exit 0
}

# Output table header
$header = "{0,-10} | {1,-20} | {2,-8} | {3,-8} | {4,-10} | {5,-8}" -f `
    "Plan ID", "Name", "Priority", "Rounds", "Status", "Progress"
$separator = "{0,-10}-+-{1,-20}-+-{2,-8}-+-{3,-8}-+-{4,-10}-+-{5,-8}" -f `
    "----------", "--------------------", "--------", "--------", "----------", "--------"

Write-Host $header
Write-Host $separator

# Iterate all plans
foreach ($plan in $plans) {
    $planName = $plan.Name
    
    # Parse plan info
    if ($planName -match "plan-(\d{3})-p(\d)-(.+)") {
        $id = $matches[1]
        $priority = "P" + $matches[2]
        $name = $matches[3]
    } else {
        continue
    }
    
    # Filter conditions
    if ($Status -and $planName -notmatch $Status) { continue }
    if ($Priority -and $priority -ne $Priority) { continue }
    
    # Read plan file to get status
    $planFile = Join-Path $plan.FullName "00-plan.md"
    if (Test-Path $planFile) {
        $content = Get-Content $planFile -Raw
        
        # Extract total rounds
        $totalRounds = 5
        if ($content -match "总轮次:\s*(\d+)") {
            $totalRounds = [int]$matches[1]
        }
        
        # Count completed rounds
        $completedRounds = ([regex]::Matches($content, "✅")).Count
        
        # Extract status
        $planStatus = "Waiting"
        if ($content -match "状态:\s*(pending|in-progress|completed|failed|timeout)") {
            $statusMap = @{
                "pending" = "Waiting"
                "in-progress" = "Running"
                "completed" = "Done"
                "failed" = "Failed"
                "timeout" = "Timeout"
            }
            $planStatus = $statusMap[$matches[1]]
        }
        
        # Calculate progress
        $progress = "{0:P0}" -f ($completedRounds / $totalRounds)
    } else {
        $planStatus = "Waiting"
        $progress = "0%"
        $completedRounds = 0
    }
    
    # Output row
    $row = "{0,-10} | {1,-20} | {2,-8} | {3,-8} | {4,-10} | {5,-8}" -f `
        $id, $name, $priority, "$completedRounds/$totalRounds", $planStatus, $progress
    Write-Host $row
}

Write-Host "`nTip: Use -Status and -Priority parameters to filter results" -ForegroundColor Gray
Write-Host "Example: .\list-plans.ps1 -Status in-progress" -ForegroundColor Gray
