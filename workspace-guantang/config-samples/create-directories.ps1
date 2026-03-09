# OpenClaw Agent 团队 - 目录结构创建脚本
# 使用方法：在 PowerShell 中运行 .\create-directories.ps1

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "OpenClaw Agent 团队 - 目录结构创建" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

$baseDir = "F:\openclaw\workspace"

# 定义需要创建的目录
$directories = @(
    # 团队目录 - 每个 Agent 的工作空间
    "$baseDir\team\guantang\logs",
    "$baseDir\team\guantang\tasks",
    "$baseDir\team\jiangrou\logs",
    "$baseDir\team\jiangrou\tasks",
    "$baseDir\team\dousha\logs",
    "$baseDir\team\dousha\tasks",
    "$baseDir\team\dousha\designs",
    "$baseDir\team\suancai\logs",
    "$baseDir\team\suancai\tasks",
    "$baseDir\team\suancai\tests",
    
    # 通信目录 - Agent 间文件共享
    "$baseDir\communication\inbox\guantang",
    "$baseDir\communication\inbox\jiangrou",
    "$baseDir\communication\inbox\dousha",
    "$baseDir\communication\inbox\suancai",
    "$baseDir\communication\outbox\guantang",
    "$baseDir\communication\outbox\jiangrou",
    "$baseDir\communication\outbox\dousha",
    "$baseDir\communication\outbox\suancai",
    "$baseDir\communication\archive",
    
    # 日志目录
    "$baseDir\logs\current",      # 当前日志（最近 7 天）
    "$baseDir\logs\weekly",       # 周汇总
    "$baseDir\logs\monthly",      # 月归档
    
    # 项目目录
    "$baseDir\projects",
    "$baseDir\projects\templates",
    
    # 备份目录
    "$baseDir\backups\logs",
    "$baseDir\backups\database",
    "$baseDir\backups\code",
    
    # 代码目录
    "F:\openclaw\code\backend",
    "F:\openclaw\code\frontend",
    "F:\openclaw\code\deploy",
    "F:\openclaw\code\tests",
    "F:\openclaw\code\monitoring"
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
$tomorrow = (Get-Date).AddDays(1) -Format "yyyyMMdd"
$agents = @("guantang", "jiangrou", "dousha", "suancai")

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
Write-Host "   - quick-start.md (5 分钟快速开始)" -ForegroundColor Gray
Write-Host "   - README.md (项目概述)" -ForegroundColor Gray
Write-Host ""
Write-Host "2. 安装依赖:" -ForegroundColor White
Write-Host "   pip install -r requirements.txt" -ForegroundColor Gray
Write-Host ""
Write-Host "3. 启动 Agent:" -ForegroundColor White
Write-Host "   python start_agents.py" -ForegroundColor Gray
Write-Host ""
Write-Host "祝您使用愉快！🚀" -ForegroundColor Green
Write-Host ""
