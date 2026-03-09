# Update-LastModified.ps1 - 更新指定文件的修改日期
param([string[]] $Files)
$today = (Get-Date).ToString('yyyy-MM-dd')
Write-Host "
更新日期：$today
"
if (-not $Files) { Write-Host "用法：.\Update-LastModified.ps1 file1.md,file2.md"; exit 1 }
foreach ($file in $Files) {
  if (Test-Path $file) {
       $content = Get-Content $file-Raw
     if ($content -match '<!-- Last Modified:') {
          $content = $content-replace '<!-- Last Modified: \d{4}-\d{2}-\d{2} -->', "<!-- Last Modified: $today -->"
          Set-Content $file $content-Encoding UTF8
         Write-Host "[UPDATED] $file" -Green
      } else {
          ("<!-- Last Modified: $today -->
$content") | Set-Content $file-Encoding UTF8
         Write-Host "[ADDED] $file" -Yellow
      }
   }
}
