$dir = 'F:\openclaw\code\frontend\src\views'
$files = Get-ChildItem $dir -Filter '*.vue' -File
foreach ($f in $files) {
    $content = Get-Content $f.FullName -Raw
    if ($content -match 'articleApi') {
        Write-Host "$($f.Name) uses articleApi"
    }
}

Write-Host ""
Write-Host "=== auth.ts export check ==="
$auth = Get-Content 'F:\openclaw\code\frontend\src\api\auth.ts' -Raw
if ($auth -match 'export const authApi') { Write-Host "auth.ts: named export authApi" }
if ($auth -match 'export function') { Write-Host "auth.ts: function exports" }
if ($auth -match 'export default') { Write-Host "auth.ts: default export" }

Write-Host ""
Write-Host "=== article.ts export check ==="
$article = Get-Content 'F:\openclaw\code\frontend\src\api\article.ts' -Raw
if ($article -match 'export const articleApi') { Write-Host "article.ts: named export articleApi" }
if ($article -match 'export function') { Write-Host "article.ts: function exports" }
if ($article -match 'export default') { Write-Host "article.ts: default export" }

Write-Host ""
Write-Host "=== Views importing articleApi ==="
foreach ($f in $files) {
    $content = Get-Content $f.FullName -Raw
    if ($content -match 'articleApi') {
        Write-Host "  $($f.Name) - imports articleApi (WILL FAIL: article.ts has no articleApi export)"
    }
    if ($content -match 'getArticleList|getArticle\b') {
        Write-Host "  $($f.Name) - imports individual functions (OK)"
    }
}
