param(
    [Parameter(Position=0)]
    [string]$Command,
    [Parameter(Position=1)]
    [string]$Arg1,
    [Parameter(Position=2)]
    [string]$Arg2
)

$base = 'F:\openclaw\agent'

if ($Command -eq 'worklogs') {
    $agent = $Arg1
    if (-not $agent) { $agent = 'all' }
    $agents = if ($agent -eq 'all') { @('jiangrou','dousha','suancai','guantang') } else { @($agent) }
    foreach ($a in $agents) {
        $dir = "$base\workinglog\$a"
        Write-Host "=== $a ==="
        $today = (Get-Date).ToString('yyyyMMdd')
        $files = Get-ChildItem $dir -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "$today*" } | Sort-Object Name
        $count = ($files | Measure-Object).Count
        Write-Host "  Today: $count files"
        foreach ($f in $files) { Write-Host "  $($f.Name)  ($($f.LastWriteTime))" }
        Write-Host ""
    }
}
elseif ($Command -eq 'latest') {
    $agent = $Arg1
    $n = if ($Arg2) { [int]$Arg2 } else { 3 }
    $dir = "$base\workinglog\$agent"
    Get-ChildItem $dir -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First $n | ForEach-Object {
        Write-Host "$($_.Name)  ($($_.LastWriteTime))"
    }
}
elseif ($Command -eq 'verify') {
    $filepath = $Arg1
    $keywords = if ($Arg2) { $Arg2 -split ',' } else { @() }
    $exists = Test-Path $filepath
    Write-Host "File: $filepath"
    Write-Host "Exists: $exists"
    if ($exists -and $keywords.Count -gt 0) {
        $content = Get-Content $filepath -Raw
        foreach ($kw in $keywords) {
            $found = $content -match [regex]::Escape($kw.Trim())
            $status = if ($found) { 'PASS' } else { 'FAIL' }
            Write-Host "  [$status] Contains: $($kw.Trim())"
        }
    }
}
elseif ($Command -eq 'batch-verify') {
    # 批量验证多个工单交付物
    # 用法: _tools.ps1 batch-verify "工单清单文件路径"
    # 清单格式每行: TASK-ID|文件路径|关键词1,关键词2
    $listFile = $Arg1
    if (-not $listFile -or -not (Test-Path $listFile)) {
        Write-Host "Usage: _tools.ps1 batch-verify <task-list-file>"
        Write-Host "File format (one per line): TASK-ID|filepath|keyword1,keyword2"
        exit 1
    }
    $lines = Get-Content $listFile | Where-Object { $_.Trim() -and -not $_.StartsWith('#') }
    $pass = 0; $fail = 0; $total = $lines.Count
    foreach ($line in $lines) {
        $parts = $line -split '\|'
        $taskId = $parts[0].Trim()
        $filepath = $parts[1].Trim()
        $keywords = if ($parts.Count -gt 2 -and $parts[2].Trim()) { $parts[2].Trim() -split ',' } else { @() }

        $exists = Test-Path $filepath
        $allPass = $true
        $details = @()

        if (-not $exists) {
            $allPass = $false
            $details += "FILE MISSING"
        }
        elseif ($keywords.Count -gt 0) {
            $content = Get-Content $filepath -Raw
            foreach ($kw in $keywords) {
                $found = $content -match [regex]::Escape($kw.Trim())
                if (-not $found) {
                    $allPass = $false
                    $details += "MISSING: $($kw.Trim())"
                }
            }
        }

        $status = if ($allPass) { 'PASS' } else { 'FAIL' }
        if ($allPass) { $pass++ } else { $fail++ }
        $detailStr = if ($details.Count -gt 0) { " ($($details -join ', '))" } else { '' }
        Write-Host "[$status] $taskId | $filepath$detailStr"
    }
    Write-Host ""
    Write-Host "=== Summary: $pass/$total PASS, $fail FAIL ==="
}
elseif ($Command -eq 'receipts') {
    # 扫描今日工作日志中的工单回执
    # 用法: _tools.ps1 receipts [agent|all]
    $agent = $Arg1
    if (-not $agent) { $agent = 'all' }
    $agents = if ($agent -eq 'all') { @('jiangrou','dousha','suancai') } else { @($agent) }
    $today = (Get-Date).ToString('yyyyMMdd')

    foreach ($a in $agents) {
        $dir = "$base\workinglog\$a"
        $files = Get-ChildItem $dir -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "$today*" } | Sort-Object Name
        foreach ($f in $files) {
            $content = Get-Content $f.FullName -Raw -ErrorAction SilentlyContinue
            # 查找 RECEIPT 行: TASK-xxx | PASS/FAIL | filepath | commit
            $receiptLines = ($content -split "`n") | Where-Object { $_ -match '^TASK-' }
            foreach ($r in $receiptLines) {
                Write-Host "[$a] $r"
            }
        }
    }
}
elseif ($Command -eq 'gitstatus') {
    $repos = @(
        @{Name='agent'; Path=$base},
        @{Name='backend'; Path='F:\openclaw\code\backend'},
        @{Name='frontend'; Path='F:\openclaw\code\frontend'}
    )
    foreach ($r in $repos) {
        Write-Host "=== $($r.Name) ==="
        Set-Location $r.Path
        $dirty = git status --short 2>$null
        if (-not $dirty) { Write-Host "  Clean" } else { Write-Host "  Dirty: $($dirty.Count) files" }
        Write-Host "  Last: $(git log --oneline -1 2>$null)"
        Write-Host ""
    }
}
else {
    Write-Host "Commands: worklogs, latest, verify, batch-verify, receipts, gitstatus"
    Write-Host "  _tools.ps1 worklogs [agent|all]       - Today's worklogs"
    Write-Host "  _tools.ps1 latest <agent> [count]     - Recent N logs"
    Write-Host "  _tools.ps1 verify <file> <kw1,kw2>    - Verify single file"
    Write-Host "  _tools.ps1 batch-verify <list-file>   - Batch verify tasks"
    Write-Host "  _tools.ps1 receipts [agent|all]       - Scan task receipts"
    Write-Host "  _tools.ps1 gitstatus                  - All repos git status"
}
