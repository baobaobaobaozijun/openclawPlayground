# Plan Manager v2 - Create Plan (with Database Sync)
# Usage: .\create-plan.ps1 -id "007" -name "Article" [-priority "P1"] [-rounds 5] [-owner "jiangrou"]

param(
    [Parameter(Mandatory=$true)]
    [string]$id,
    
    [Parameter(Mandatory=$true)]
    [string]$name,
    
    [string]$priority = "P1",
    
    [int]$rounds = 5,
    
    [string]$owner = "jiangrou"
)

$ErrorActionPreference = "Stop"

# Config
$basePath = "F:\openclaw\agent\tasks\01-plans"
$templatePath = "F:\openclaw\agent\workspace-guantang\skills\plan-manager\templates"
$workinglogPath = "F:\openclaw\agent\workinglog\guantang"
$dbConfig = "F:\openclaw\agent\.local\pipeline-db-config.ps1"

# Load DB config
if (Test-Path $dbConfig) {
    . $dbConfig
} else {
    Write-Host "[WARN] DB config not found, skipping DB write" -ForegroundColor Yellow
    $dbHost = $null
}

$planFolderName = "plan-{0:D3}-p{1}-{2}" -f [int]$id, $priority.ToLower(), $name
$planFolderPath = Join-Path $basePath $planFolderName

Write-Host "Creating Plan-$id : $name (v2 with DB sync)" -ForegroundColor Cyan

# 1. Create folder
if (Test-Path $planFolderPath) {
    Write-Host "ERROR: Folder exists: $planFolderPath" -ForegroundColor Red
    exit 1
}
New-Item -ItemType Directory -Path $planFolderPath -Force | Out-Null
Write-Host "[OK] Created folder" -ForegroundColor Green

# 2. Copy templates
$templates = @("00-plan-template.md", "01-round-orders-template.md", "02-verify-list-template.md", "03-review-template.md", "04-feishu-logs-template.md")
foreach ($t in $templates) {
    $src = Join-Path $templatePath $t
    $dst = Join-Path $planFolderPath ($t -replace "-template", "")
    if (Test-Path $src) {
        Copy-Item $src $dst -Force
        Write-Host "[OK] Created: $t" -ForegroundColor Green
    } else {
        Write-Host "[WARN] Template not found: $t" -ForegroundColor Yellow
    }
}

# 3. Fill metadata
$planFile = Join-Path $planFolderPath "00-plan.md"
$content = Get-Content $planFile -Raw
$content = $content -replace "{编号}", $id
$content = $content -replace "{计划名称}", "$priority-$name"
$content = $content -replace "{日期}", (Get-Date -Format "yyyy-MM-dd")
$content = $content -replace "{时间}", (Get-Date -Format "yyyy-MM-dd HH:mm")
$content = $content -replace "{N}", $rounds.ToString()
$content = $content -replace "{开始时间}", (Get-Date -Format "yyyy-MM-dd HH:mm")
Set-Content $planFile $content -NoNewline
Write-Host "[OK] Filled metadata" -ForegroundColor Green

# 4. Skip master-plan update (manual for now)
Write-Host "[INFO] master-plan-overview.md needs manual update" -ForegroundColor Yellow

# 5. Write to database
$dbSuccess = $true
if ($dbHost) {
    Write-Host "Writing to database..." -ForegroundColor Cyan
    
    $sql1 = "INSERT INTO pipeline_plans (plan_id, plan_name, status, current_round, total_rounds, priority, created_by, prd_doc_path) VALUES ('plan-$id', '$name', 'pending', 0, $rounds, '$priority', 'guantang', 'tasks/01-plans/$planFolderName/00-plan.md');"
    $r1 = mysql -h $dbHost -P $dbPort -u $dbUser -p$dbPass $dbName -e $sql1 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Inserted pipeline_plans" -ForegroundColor Green
    } else {
        Write-Host "[WARN] pipeline_plans insert failed" -ForegroundColor Yellow
        $dbSuccess = $false
    }
    
    for ($i = 1; $i -le $rounds; $i++) {
        $sql2 = "INSERT INTO pipeline_rounds (plan_id, round_id, round_name, status) VALUES ('plan-$id', $i, 'Round $i', 'pending');"
        $r2 = mysql -h $dbHost -P $dbPort -u $dbUser -p$dbPass $dbName -e $sql2 2>&1
    }
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Inserted pipeline_rounds ($rounds rounds)" -ForegroundColor Green
    }
    
    $sql3 = "INSERT INTO pipeline_state_history (plan_id, old_status, new_status, change_reason) VALUES ('plan-$id', null, 'pending', 'plan_manager_v2_create');"
    $r3 = mysql -h $dbHost -P $dbPort -u $dbUser -p$dbPass $dbName -e $sql3 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Inserted state_history" -ForegroundColor Green
    }
}

# 6. Create worklog
$logFile = Join-Path $workinglogPath ("{0}-guantang-create-plan-Plan{1}.md" -f (Get-Date -Format "yyyyMMdd-HHmmss"), $id)
$logContent = @"
<!-- Last Modified: $(Get-Date -Format "yyyy-MM-dd HH:mm") -->

# Work Log

## Info
- **By:** Guantang
- **At:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
- **Type:** task

## Task
Create plan with plan-manager-v2 (DB sync)

**Plan:**
- ID: Plan-$id
- Name: $priority-$name
- Priority: $priority
- Rounds: $rounds
- Owner: $owner

**Deliverables:**
- Folder: $planFolderName
- 5 docs created
- DB: $(if ($dbSuccess) { "Synced OK" } else { "Write FAILED, pending" })

## Files
- \`tasks/01-plans/$planFolderName/00-plan.md\`
- \`tasks/01-plans/$planFolderName/01-round-orders.md\`
- \`tasks/01-plans/$planFolderName/02-verify-list.md\`
- \`tasks/01-plans/$planFolderName/03-review.md\`
- \`tasks/01-plans/$planFolderName/04-feishu-logs.md\`

## Notify
- [ ] Notify $owner for Round 1
- [ ] Push to GitHub

---
*Auto-generated (plan-manager-v2)*
"@
Set-Content $logFile $logContent -NoNewline
Write-Host "[OK] Created worklog" -ForegroundColor Green

Write-Host "`n[OK] Plan created!" -ForegroundColor Green
Write-Host "Path: $planFolderPath" -ForegroundColor Cyan
Write-Host "DB Status: $(if ($dbSuccess) { "OK" } else { "FAILED" })" -ForegroundColor $(if ($dbSuccess) { "Green" } else { "Yellow" })
Write-Host "Next: Dispatch Round 1 to $owner" -ForegroundColor Cyan
