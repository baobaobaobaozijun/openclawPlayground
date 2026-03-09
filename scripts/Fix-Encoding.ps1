# Fix-Encoding.ps1
# 修复 workspace-guantang 目录下的 UTF-8 编码乱码文件

$targetPath = "F:\openclaw\agent\workspace-guantang"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  修复 UTF-8 编码乱码文件" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$fixedCount = 0
$errorCount = 0

# 获取所有 Markdown 文件
Get-ChildItem -Path $targetPath -Recurse -File -Include *.md | 
    Where-Object { $_.FullName -notlike "*workinglog*" } |
    ForEach-Object {
        $file = $_
        
        try {
            # 读取文件内容（使用 GBK 编码读取乱码内容）
            $content = Get-Content -Path $file.FullName -Raw -Encoding Default
            
            # 检查是否有乱码特征字符
            if ($content -match '鈥？| 鐏？| 閰？| 璞？| 馃？') {
                Write-Host "[SKIP] $($file.Name) - 已经是正确编码" -ForegroundColor Yellow
            } else {
                # 重新以 UTF-8 无 BOM 格式保存
                Set-Content -Path $file.FullName -Value $content -Encoding UTF8
                Write-Host "[FIXED] $($file.Name)" -ForegroundColor Green
                $fixedCount++
            }
        } catch {
            Write-Host "[ERROR] $($file.Name): $($_.Exception.Message)" -ForegroundColor Red
            $errorCount++
        }
    }

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "  修复完成!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "已修复：$fixedCount 个文件" -ForegroundColor Cyan
if ($errorCount -gt 0) {
    Write-Host "失败：$errorCount 个文件" -ForegroundColor Yellow
}
