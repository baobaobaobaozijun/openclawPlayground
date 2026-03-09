# Start-OpenClawCluster.ps1
# 启动 Docker Desktop 并等待其就绪，然后启动 OpenClaw Agent 集群

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  OpenClaw Agent 集群启动脚本" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$dockerComposePath = "F:\openclaw\agent\deployment-2026-03-08\docker-compose"
$maxWaitTime = 60  # 最多等待 60 秒
$checkInterval = 2  # 每 2 秒检查一次

# 步骤 1: 检查并启动 Docker Desktop
Write-Host "[1/4] 检查 Docker Desktop 状态..." -ForegroundColor Yellow

try {
    $dockerVersion = docker --version 2>&1
    Write-Host "✓ Docker 已安装：$dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker 未安装或无法访问" -ForegroundColor Red
    exit 1
}

# 检查 Docker 是否正在运行
Write-Host "`n[2/4] 等待 Docker Desktop 就绪..." -ForegroundColor Yellow

$elapsedTime = 0
$dockersReady = $false

while ($elapsedTime -lt $maxWaitTime -and -not $dockersReady) {
    try {
        $null = docker ps 2>&1
        $dockersReady = $true
        Write-Host "✓ Docker Desktop 已就绪 (耗时：${elapsedTime}秒)" -ForegroundColor Green
    } catch {
        $elapsedTime += $checkInterval
        Write-Host "⏳ 等待中... (${elapsedTime}/${maxWaitTime}秒)" -ForegroundColor Gray
        Start-Sleep -Seconds $checkInterval
    }
}

if (-not $dockersReady) {
    Write-Host "✗ Docker Desktop 未能在 ${maxWaitTime}秒内就绪" -ForegroundColor Red
    Write-Host "`n请手动启动 Docker Desktop 应用程序" -ForegroundColor Yellow
    exit 1
}

# 步骤 2: 验证 Docker Compose 配置
Write-Host "`n[3/4] 验证 Docker Compose 配置..." -ForegroundColor Yellow

Set-Location $dockerComposePath

try {
    $configCheck = docker-compose -f docker-compose-agents.yml config 2>&1
    Write-Host "✓ Docker Compose 配置验证通过" -ForegroundColor Green
    Write-Host "  配置：3 个 Agent 实例" -ForegroundColor Cyan
    Write-Host "  - jiangrou (端口：18791)" -ForegroundColor Gray
    Write-Host "  - dousha (端口：18792)" -ForegroundColor Gray
    Write-Host "  - suancai (端口：18793)" -ForegroundColor Gray
} catch {
    Write-Host "✗ Docker Compose 配置验证失败" -ForegroundColor Red
    exit 1
}

# 步骤 3: 启动集群
Write-Host "`n[4/4] 启动 OpenClaw Agent 集群..." -ForegroundColor Yellow

try {
    docker-compose -f docker-compose-agents.yml up -d
    
    Write-Host "`n✓ 集群启动成功!" -ForegroundColor Green
    
    # 等待几秒让容器初始化
    Start-Sleep -Seconds 3
    
    # 显示容器状态
    Write-Host "`n📊 容器状态:" -ForegroundColor Cyan
    docker-compose -f docker-compose-agents.yml ps
    
    Write-Host "`n🌐 访问地址:" -ForegroundColor Cyan
    Write-Host "  酱肉 (后端):   http://localhost:18791" -ForegroundColor White
    Write-Host "  豆沙 (前端):   http://localhost:18792" -ForegroundColor White
    Write-Host "  酸菜 (运维):   http://localhost:18793" -ForegroundColor White
    
    Write-Host "`n📝 查看日志:" -ForegroundColor Cyan
    Write-Host "  docker-compose -f docker-compose-agents.yml logs -f" -ForegroundColor Gray
    
    Write-Host "`n⏹️  停止集群:" -ForegroundColor Cyan
    Write-Host "  docker-compose -f docker-compose-agents.yml down" -ForegroundColor Gray
    
} catch {
    Write-Host "✗ 启动集群时出错" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Yellow
    exit 1
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "  启动完成!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green
