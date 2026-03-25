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
    Write-Host "Commands: worklogs, latest, verify, gitstatus"
    Write-Host "  _tools.ps1 worklogs [agent|all]"
    Write-Host "  _tools.ps1 latest <agent> [count]"
    Write-Host "  _tools.ps1 verify <filepath> <keyword1,keyword2>"
    Write-Host "  _tools.ps1 gitstatus"
}
