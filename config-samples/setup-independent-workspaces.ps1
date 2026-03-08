# OpenClaw Agent 团队 - 独立 Workspace 创建脚本
# 使用方法：在 PowerShell 中运行 .\setup-independent-workspaces.ps1

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "OpenClaw Agent 团队" -ForegroundColor Cyan
Write-Host "独立 Workspace 创建工具" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

$baseDir = "F:\openclaw"

# 定义三个独立的 workspace 目录结构
$workspaces = @{
    "workspace-jiangrou" = @(
        "logs",
        "tasks\inbox",
        "tasks\outbox",
        "code\api",
        "code\models",
        "code\utils",
        "code\tests",
        "communication\inbox\guantang",
        "communication\outbox\guantang",
        "docs\architecture",
        "docs\api-docs",
        "docs\adr",
        "backups\daily"
    )
    "workspace-dousha" = @(
        "logs",
        "tasks\inbox",
        "tasks\outbox",
        "designs\wireframes",
        "designs\mockups",
        "designs\prototypes",
        "designs\assets\icons",
        "designs\assets\images",
        "code\components",
        "code\pages",
        "code\styles",
        "communication\inbox\guantang",
        "communication\outbox\guantang",
        "docs\design-system",
        "docs\guidelines"
    )
    "workspace-suancai" = @(
        "logs",
        "tasks\inbox",
        "tasks\outbox",
        "tests\functional",
        "tests\performance",
        "tests\automation",
        "reports\daily",
        "reports\weekly",
        "scripts\deploy",
        "scripts\monitoring",
        "communication\inbox\guantang",
        "communication\outbox\guantang",
        "backups\configs"
    )
}

$totalCreated = 0
$totalSkipped = 0

foreach ($wsName in $workspaces.Keys) {
    Write-Host "`n======================================" -ForegroundColor Cyan
    Write-Host "正在创建 $wsName ..." -ForegroundColor White
    Write-Host "======================================" -ForegroundColor Cyan
    
    $wsPath = Join-Path $baseDir $wsName
    $created = 0
    $skipped = 0
    
    foreach ($subdir in $workspaces[$wsName]) {
        $fullPath = Join-Path $wsPath $subdir
        
        if (!(Test-Path $fullPath)) {
            try {
                New-Item -ItemType Directory -Path $fullPath | Out-Null
                Write-Host "  ✓ 已创建：$subdir" -ForegroundColor Green
                $created++
            }
            catch {
                Write-Host "  ✗ 创建失败：$subdir - $($_.Exception.Message)" -ForegroundColor Red
            }
        }
        else {
            Write-Host "  ⊘ 已存在：$subdir" -ForegroundColor Yellow
            $skipped++
        }
    }
    
    Write-Host "`n[$wsName] 完成:" -ForegroundColor Cyan
    Write-Host "  新建：$created 个目录" -ForegroundColor Green
    Write-Host "  跳过：$skipped 个目录" -ForegroundColor Yellow
    
    $totalCreated += $created
    $totalSkipped += $skipped
}

Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "所有 Workspace 创建完成！" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "总计：" -ForegroundColor White
Write-Host "  新建目录数：$totalCreated" -ForegroundColor Green
Write-Host "  跳过目录数：$totalSkipped" -ForegroundColor Yellow
Write-Host ""

# 为每个 Agent 创建初始日志文件模板
Write-Host "`n正在创建初始日志模板..." -ForegroundColor Cyan

$today = Get-Date -Format "yyyyMMdd"
$agents = @{
    "workspace-jiangrou" = "酱肉"
    "workspace-dousha" = "豆沙"
    "workspace-suancai" = "酸菜"
}

foreach ($wsName in $agents.Keys) {
    $agentName = $agents[$wsName]
    $logPath = Join-Path $baseDir "$wsName\logs\daily_$today.md"
    
    $template = @"
# $($agentName.ToUpper()) - 工作日志 $(Get-Date -Format "yyyy-MM-dd")

## 今日工作
- [ ] 任务 1
- [ ] 任务 2

## 代码提交/设计稿/测试报告
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
        Write-Host "  ✓ 已创建 $($agentName) 的日志模板" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ 创建日志模板失败：$($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "下一步操作：" -ForegroundColor White
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. 查看创建的 workspace:" -ForegroundColor White
Write-Host "   cd F:\openclaw\workspace-jiangrou" -ForegroundColor Gray
Write-Host "   dir" -ForegroundColor Gray
Write-Host ""
Write-Host "2. 阅读文档:" -ForegroundColor White
Write-Host "   - independent-workspaces.md (新架构说明)" -ForegroundColor Gray
Write-Host "   - docker-deployment-guide.md (Docker 部署指南)" -ForegroundColor Gray
Write-Host ""
Write-Host "3. 准备 Docker Compose:" -ForegroundColor White
Write-Host "   确保 Docker Desktop for Windows 已安装并运行" -ForegroundColor Gray
Write-Host ""
Write-Host "4. 构建和启动容器:" -ForegroundColor White
Write-Host "   cd F:\openclaw\workspace-programmer" -ForegroundColor Gray
Write-Host "   docker-compose build" -ForegroundColor Gray
Write-Host "   docker-compose up -d" -ForegroundColor Gray
Write-Host ""
Write-Host "祝您使用愉快！🚀" -ForegroundColor Green
Write-Host ""
