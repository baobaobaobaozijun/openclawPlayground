Set-Location 'F:\openclaw'
# Search code directory
Get-ChildItem -Path 'F:\openclaw\code' -Recurse -Include '*.java','*.xml','*.yml','*.yaml','*.properties','*.ts','*.json' -ErrorAction SilentlyContinue | Select-String -Pattern 'redis','Redis','REDIS' | ForEach-Object {
  Write-Output ("{0}:{1}: {2}" -f $_.Path, $_.LineNumber, $_.Line.Trim())
}
Write-Output "--- agent docs ---"
# Search agent docs
Get-ChildItem -Path 'F:\openclaw\agent' -Recurse -Include '*.md' -ErrorAction SilentlyContinue | Select-String -Pattern 'redis','Redis','REDIS' | ForEach-Object {
  Write-Output ("{0}:{1}: {2}" -f $_.Path, $_.LineNumber, $_.Line.Trim())
}
