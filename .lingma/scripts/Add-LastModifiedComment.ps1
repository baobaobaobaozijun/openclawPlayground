# Add-LastModifiedComment.ps1
# Add last modified date comments to all Markdown files in agent directory

$agentPath = "F:\openclaw\agent"

Write-Host "Starting processing..." -ForegroundColor Cyan

$modifiedCount = 0
$errorFiles = @()

# Get all Markdown files, excluding workinglog directory
$files = Get-ChildItem -Path $agentPath -Recurse -File -Include *.md | Where-Object { $_.FullName -notlike "*workinglog*" }

foreach ($file in $files) {
    $lastModified = $file.LastWriteTime.ToString("yyyy-MM-dd")
    
    try {
        # Read file content
        $content = Get-Content -Path $file.FullName -Raw
        
        # Add date comment at the beginning
        $newContent = "<!-- Last Modified: " + $lastModified + " -->`n<!-- Last Modified (CN): " + $lastModified + " -->`n`n" + $content
        
        # Write back to file
        Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8
        
        Write-Host "[OK] " $file.Name -ForegroundColor Green
        $modifiedCount++
    } catch {
        Write-Host "[ERROR] " $file.Name ": " $_.Exception.Message -ForegroundColor Red
        $errorFiles += $file.Name
    }
}

Write-Host "`nCompleted!" -ForegroundColor Green
Write-Host "Processed: $modifiedCount files" -ForegroundColor Cyan
if ($errorFiles.Count -gt 0) {
    Write-Host "Failed: $($errorFiles.Count) files" -ForegroundColor Yellow
}
