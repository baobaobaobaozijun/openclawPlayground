$archFile = "F:\openclaw\agent\ARCHITECTURE.md"
$content = Get-Content $archFile -Raw
$matches = [regex]::Matches($content, '\]\(([^)]+)\)')
$links = $matches | ForEach-Object { $_.Groups[1].Value } | Where-Object { $_ -notmatch '^https?://' -and $_ -notmatch '^#' }

if ($links.Count -eq 0) {
    Write-Host "NO_RELATIVE_LINKS"
    exit 0
}

$broken = @()
$valid = @()

foreach ($link in $links) {
    # Remove any anchor
    $cleanLink = $link -replace '#.*$', ''
    if ([string]::IsNullOrWhiteSpace($cleanLink)) { continue }
    
    $fullPath = Join-Path "F:\openclaw\agent" $cleanLink
    if (Test-Path $fullPath) {
        $valid += $link
    } else {
        $broken += $link
    }
}

Write-Host "TOTAL: $($links.Count)"
Write-Host "VALID: $($valid.Count)"
Write-Host "BROKEN: $($broken.Count)"

if ($broken.Count -gt 0) {
    Write-Host "---BROKEN_LINKS---"
    foreach ($b in $broken) {
        Write-Host $b
    }
}
