# Plan Validation Script
# Validates plan directories vs database every 5 minutes

$tasksDir = "F:\openclaw\agent\tasks\01-plans"
$reportFile = "F:\openclaw\agent\doc\05-progress\plan-validation-report.md"
$currentTime = Get-Date -Format "yyyy-MM-dd HH:mm"

Write-Host "Plan Validation - $currentTime"

# Scan plan directories
$planDirs = Get-ChildItem -Path $tasksDir -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "plan-*" }
$docPlanIds = @()
foreach ($dir in $planDirs) {
    if ($dir.Name -match "^(plan-\d+)") {
        $docPlanIds += $matches[1]
    }
}
Write-Host "Found $($docPlanIds.Count) plan directories"

# Query database
$dbPlanIds = @()
try {
    $result = mysql -h localhost -u root openclaw -N -e "SELECT plan_id FROM plan_progress;" 2>$null
    $dbPlanIds = $result -split "`n" | Where-Object { $_ -ne "" }
} catch {
    Write-Host "Database query failed"
}
Write-Host "Found $($dbPlanIds.Count) plans in database"

# Compare
$issues = @()
foreach ($planId in $docPlanIds) {
    if ($planId -notin $dbPlanIds) {
        $issues += "DOC_ONLY|$planId|Doc exists but DB missing"
    }
}
foreach ($planId in $dbPlanIds) {
    if ($planId -notin $docPlanIds) {
        $issues += "DB_ONLY|$planId|DB exists but doc missing"
    }
}

if ($issues.Count -eq 0) {
    Write-Host "All plans consistent - OK"
} else {
    Write-Host "Found $($issues.Count) issues:"
    foreach ($issue in $issues) {
        Write-Host "  $issue"
    }
}

# Generate report
$issueTable = ""
if ($issues.Count -gt 0) {
    $issueTable = "| Type | Plan ID | Issue | Status |`n|------|---------|-------|--------|"
    foreach ($issue in $issues) {
        $parts = $issue -split "\|"
        $issueTable += "`n| $($parts[0]) | $($parts[1]) | $($parts[2]) | PENDING |"
    }
} else {
    $issueTable = "No issues found."
}

$report = @"
<!-- Last Modified: $currentTime -->

# Plan Validation Report

**Time:** $currentTime
**Frequency:** Every 5 minutes

## Summary

| Item | Count |
|------|-------|
| Plan Directories | $($docPlanIds.Count) |
| Database Plans | $($dbPlanIds.Count) |
| Issues | $($issues.Count) |

## Issues

$issueTable

## Next Validation

$((Get-Date).AddMinutes(5)).ToString("yyyy-MM-dd HH:mm")

---
*Last Run: $currentTime*
"@

$report | Out-File -FilePath $reportFile -Encoding utf8
Write-Host "Report saved: $reportFile"

if ($issues.Count -gt 0) {
    Write-Host "ALERT: Issues found - check $reportFile"
}
