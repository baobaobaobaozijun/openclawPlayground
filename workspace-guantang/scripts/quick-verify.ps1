# Quick Verify Script - Test Pipeline Recovery
# Location: F:\openclaw\agent\workspace-guantang\scripts\quick-verify.ps1

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Pipeline Mechanism v3.0 - Verify" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Check database connection
Write-Host "[1/5] Checking database connection..." -NoNewline
$result = & mysql -h localhost -P 3306 -u root -proot123 -N -e "SELECT 'OK';" 2>$null
if ($result -like "*OK*") {
    Write-Host " OK" -ForegroundColor Green
} else {
    Write-Host " FAILED" -ForegroundColor Red
    exit 1
}

# 2. Check table structure
Write-Host "[2/5] Checking table structure..." -NoNewline
$tables = & mysql -h localhost -P 3306 -u root -proot123 baozipu -N -e "SHOW TABLES LIKE 'pipeline_%';" 2>$null
if ($tables.Count -eq 6) {
    Write-Host " OK (6 tables)" -ForegroundColor Green
} else {
    Write-Host " FAILED (expected 6, got $($tables.Count))" -ForegroundColor Red
    exit 1
}

# 3. Check test data
Write-Host "[3/5] Checking test data..." -NoNewline
$planCount = & mysql -h localhost -P 3306 -u root -proot123 baozipu -N -e "SELECT COUNT(*) FROM pipeline_plans;" 2>$null
if ([int]$planCount -gt 0) {
    Write-Host " OK ($planCount plans)" -ForegroundColor Green
} else {
    Write-Host " WARNING (no test data)" -ForegroundColor Yellow
}

# 4. Check script files
Write-Host "[4/5] Checking script files..." -NoNewline
$scripts = @(
    "F:\openclaw\agent\workspace-guantang\scripts\restore-pipeline.ps1",
    "F:\openclaw\agent\workspace-guantang\scripts\heartbeat-check.ps1"
)
$allExist = $true
foreach ($script in $scripts) {
    if (-not (Test-Path $script)) {
        $allExist = $false
        break
    }
}
if ($allExist) {
    Write-Host " OK (2 scripts)" -ForegroundColor Green
} else {
    Write-Host " FAILED (scripts missing)" -ForegroundColor Red
    exit 1
}

# 5. Check Cron config
Write-Host "[5/5] Checking Cron config..." -NoNewline
$crons = @(
    "C:\Users\Administrator\.openclaw\crons\pipeline-recovery.yml",
    "C:\Users\Administrator\.openclaw\crons\agent-heartbeat-check.yml"
)
$allExist = $true
foreach ($cron in $crons) {
    if (-not (Test-Path $cron)) {
        $allExist = $false
        break
    }
}
if ($allExist) {
    Write-Host " OK (2 Crons)" -ForegroundColor Green
} else {
    Write-Host " WARNING (Cron config missing)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Verification Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Restart Gateway: openclaw gateway restart" -ForegroundColor White
Write-Host "2. Observe heartbeat checks and recovery flow" -ForegroundColor White
Write-Host ""
