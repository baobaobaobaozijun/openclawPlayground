Write-Output "=== JIANGROU TODAY ==="
Get-ChildItem 'F:\openclaw\agent\workinglog\jiangrou' -File | Where-Object { $_.Name -like '20260324*' } | Sort-Object LastWriteTime -Descending | ForEach-Object { Write-Output "$($_.Name) | $($_.LastWriteTime) | $($_.Length)B" }

Write-Output "=== DOUSHA TODAY ==="
Get-ChildItem 'F:\openclaw\agent\workinglog\dousha' -File | Where-Object { $_.Name -like '20260324*' } | Sort-Object LastWriteTime -Descending | ForEach-Object { Write-Output "$($_.Name) | $($_.LastWriteTime) | $($_.Length)B" }

Write-Output "=== SUANCAI TODAY ==="
Get-ChildItem 'F:\openclaw\agent\workinglog\suancai' -File | Where-Object { $_.Name -like '20260324*' } | Sort-Object LastWriteTime -Descending | ForEach-Object { Write-Output "$($_.Name) | $($_.LastWriteTime) | $($_.Length)B" }

Write-Output "=== BACKEND JAVA FILES ==="
Get-ChildItem 'F:\openclaw\code\backend\src\main\java\com\openclaw' -Recurse -File -Filter '*.java' | ForEach-Object { Write-Output "$($_.FullName) | $($_.Length)B" }

Write-Output "=== FRONTEND SRC FILES ==="
Get-ChildItem 'F:\openclaw\code\frontend\src' -Recurse -File | Where-Object { $_.Extension -in '.ts','.vue','.css' } | ForEach-Object { Write-Output "$($_.FullName) | $($_.Length)B" }

Write-Output "=== DEPLOY SCRIPTS ==="
if (Test-Path 'F:\openclaw\code\deploy\scripts') { Get-ChildItem 'F:\openclaw\code\deploy\scripts' -File | ForEach-Object { Write-Output "$($_.Name) | $($_.Length)B" } }
