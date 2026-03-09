# OpenClaw Agent 团队 - Docker 架构目录创建脚本
# 使用方法：在 PowerShell 中运行 .\setup-docker-directories.ps1

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "OpenClaw Agent 团队 - Docker 架构" -ForegroundColor Cyan
Write-Host "目录结构创建工具" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

$baseDir = "F:\openclaw\workspace"

# 定义需要创建的目录
$directories = @(
    # 酱肉 (后端) 目录
    "$baseDir\team\jiangrou\logs",
    "$baseDir\team\jiangrou\tasks\inbox",
    "$baseDir\team\jiangrou\tasks\outbox",
    
    # 豆沙 (前端) 目录
    "$baseDir\team\dousha\logs",
    "$baseDir\team\dousha\tasks\inbox",
    "$baseDir\team\dousha\tasks\outbox",
    "$baseDir\team\dousha\designs\wireframes",
    "$baseDir\team\dousha\designs\mockups",
    "$baseDir\team\dousha\designs\prototypes",
    
    # 酸菜 (运维/测试) 目录
    "$baseDir\team\suancai\logs",
    "$baseDir\team\suancai\tasks\inbox",
    "$baseDir\team\suancai\tasks\outbox",
    "$baseDir\team\suancai\tests\functional",
    "$baseDir\team\suancai\tests\performance",
    "$baseDir\team\suancai\reports\daily",
    "$baseDir\team\suancai\reports\weekly",
    
    # 共享通信目录
    "$baseDir\communication\inbox\jiangrou",
    "$baseDir\communication\inbox\dousha",
    "$baseDir\communication\inbox\suancai",
    "$baseDir\communication\outbox\guantang",
    "$baseDir\communication\outbox\jiangrou",
    "$baseDir\communication\outbox\dousha",
    "$baseDir\communication\outbox\suancai",
    "$baseDir\communication\archive"
)

# 创建目录
$createdCount = 0
$skippedCount = 0

foreach ($dir in $directories) {
    if (!(Test-Path $dir)) {
        try {
            New-Item -ItemType Directory -Path $dir | Out-Null
            Write-Host "✓ 已创建：$dir" -ForegroundColor Green
            $createdCount++
        }
        catch {
            Write-Host "✗ 创建失败：$dir - $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "⊘ 已存在：$dir" -ForegroundColor Yellow
        $skippedCount++
    }
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "目录创建完成！" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "新建目录数：$createdCount" -ForegroundColor Green
Write-Host "跳过目录数：$skippedCount" -ForegroundColor Yellow
Write-Host ""

# 创建初始日志文件模板
Write-Host "正在创建初始日志模板..." -ForegroundColor Cyan

$today = Get-Date -Format "yyyyMMdd"
$agents = @("jiangrou", "dousha", "suancai")
$agentNames = @{
    "jiangrou" = "酱肉"
    "dousha" = "豆沙"
    "suancai" = "酸菜"
}

foreach ($agent in $agents) {
    $logPath = "$baseDir\team\$agent\logs\daily_$today.md"
    
    $template = @"
# $($agent.ToUpper()) - 工作日志 $(Get-Date -Format "yyyy-MM-dd")

## 今日工作
- [ ] 任务 1
- [ ] 任务 2

## 代码提交
- \`文件路径\` - 修改说明

## 遇到的问题
- 

## 明日计划
- 

## 工作时长
- 开始时间：
- 结束时间：
- 总计：
"@
    
    try {
        $template | Out-File -FilePath $logPath -Encoding utf8
        Write-Host "✓ 已创建 $agent 的日志模板：daily_$today.md" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ 创建日志模板失败：$($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "下一步操作：" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. 阅读文档:" -ForegroundColor White
Write-Host "   - docker-deployment-guide.md (Docker 部署指南)" -ForegroundColor Gray
Write-Host "   - docker-architecture-summary.md (架构总结)" -ForegroundColor Gray
Write-Host ""
Write-Host "2. 准备 Docker:" -ForegroundColor White
Write-Host "   确保 Docker Desktop for Windows 已安装并运行" -ForegroundColor Gray
Write-Host ""
Write-Host "3. 构建和启动容器:" -ForegroundColor White
Write-Host "   cd f:\openclaw\workspace-programmer" -ForegroundColor Gray
Write-Host "   docker-compose build" -ForegroundColor Gray
Write-Host "   docker-compose up -d" -ForegroundColor Gray
Write-Host ""
Write-Host "4. 验证通信:" -ForegroundColor White
Write-Host "   查看 F:\openclaw\workspace\communication\ 目录" -ForegroundColor Gray
Write-Host ""
Write-Host "祝您使用愉快！🚀" -ForegroundColor Green
Write-Host ""
