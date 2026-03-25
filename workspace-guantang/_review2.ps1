$dir = 'F:\openclaw\code\frontend\src\views'
$files = Get-ChildItem $dir -Filter '*.vue' -File
$routerContent = Get-Content 'F:\openclaw\code\frontend\src\router\index.ts' -Raw

Write-Host "=== Router import vs actual files ==="
# 提取 router 中 import 的文件名
$importMatches = [regex]::Matches($routerContent, "import\('@/views/([^']+)'\)")
foreach ($m in $importMatches) {
    $viewName = $m.Groups[1].Value
    $fullPath = "F:\openclaw\code\frontend\src\views\$viewName"
    $exists = Test-Path $fullPath
    $status = if ($exists) { 'OK' } else { 'MISSING' }
    Write-Host "  [$status] @/views/$viewName"
}

Write-Host ""
Write-Host "=== Duplicate views (potential conflicts) ==="
$names = $files | ForEach-Object { $_.BaseName }
$grouped = $names | Group-Object | Where-Object { $_.Count -gt 1 }
if ($grouped) {
    foreach ($g in $grouped) { Write-Host "  DUPLICATE: $($g.Name) ($($g.Count) files)" }
} else {
    Write-Host "  No duplicates"
}

Write-Host ""
Write-Host "=== All view files ==="
foreach ($f in ($files | Sort-Object Name)) { Write-Host "  $($f.Name)" }
