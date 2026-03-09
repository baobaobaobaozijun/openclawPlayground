# OpenClaw 服务连接测试脚本
# 功能：测试所有 Docker 容器和 Web 服务的可访问性

$ErrorActionPreference = "Stop"

class Colors {
    static [string] $GREEN = "`e[92m"
    static [string] $YELLOW = "`e[93m"
    static [string] $RED = "`e[91m"
    static [string] $CYAN = "`e[96m"
    static [string] $RESET = "`e[0m"
}

function Write-Header {
    param([string]$Text)
    Write-Host "`n$([Colors]::CYAN)$('='*60)$([Colors]::RESET)"
    Write-Host "$([Colors]::CYAN)$Text.PadRight(60)$([Colors]::RESET)"
    Write-Host "$([Colors]::CYAN)$('='*60)$([Colors]::RESET)`n"
}

function Write-Success {
    param([string]$Text)
    Write-Host "$([Colors]::GREEN)✅ $Text$([Colors]::RESET)"
}

function Write-Warning-Custom {
    param([string]$Text)
    Write-Host "$([Colors]::YELLOW)⚠️  $Text$([Colors]::RESET)"
}

function Write-Error-Custom {
    param([string]$Text)
    Write-Host "$([Colors]::RED)❌ $Text$([Colors]::RESET)"
}

function Test-DockerContainer {
    param([string]$ContainerName)
    
    try {
        $result = docker ps --filter "name=$ContainerName" --format "{{.Status}}"
        if ($result -and $result -match "Up") {
            Write-Success "$ContainerName : $result"
            return $true
        } else {
            Write-Warning-Custom "$ContainerName : 未运行"
            return $false
        }
    } catch {
        Write-Error-Custom "检查 $ContainerName 失败：$_"
        return $false
    }
}

function Test-WebEndpoint {
    param(
        [string]$Url,
        [string]$Name,
        [int]$Timeout = 5
    )
    
    try {
        $response = Invoke-WebRequest -Uri $Url -TimeoutSec $Timeout -UseBasicParsing -ErrorAction Stop
        Write-Success "$Name ($Url): 状态码 $($response.StatusCode)"
        return $true
    } catch {
        Write-Warning-Custom "$Name ($Url): 无法访问或响应超时"
        return $false
    }
}

function Get-OpenClawToken {
    param([string]$ContainerName)
    
    try {
        $result = docker exec $ContainerName openclaw dashboard --no-open 2>&1
        if ($result) {
            Write-Success "$ContainerName Token 获取成功"
            return $result | Select-String "token="
        } else {
            Write-Warning-Custom "$ContainerName Token 获取失败"
            return $null
        }
    } catch {
        Write-Error-Custom "获取 $ContainerName Token 失败：$_"
        return $null
    }
}

# 主测试流程
Write-Header "OpenClaw 服务连接测试"

# 1. 检查 Docker 环境
Write-Host "检查 Docker 环境..." -ForegroundColor Cyan
try {
    $dockerVersion = docker --version
    Write-Success "Docker 已安装：$dockerVersion"
} catch {
    Write-Error-Custom "Docker 未安装或未运行"
    exit 1
}

try {
    $composeVersion = docker-compose --version
    Write-Success "Docker Compose 已安装：$composeVersion"
} catch {
    Write-Warning-Custom "Docker Compose 可能未正确安装"
}

# 2. 测试容器状态
Write-Header "测试 Docker 容器状态"

$containers = @(
    'openclaw-instance-1',
    'openclaw-instance-2',
    'openclaw-instance-3',
    'searxng-jiangrou',
    'searxng-dousha',
    'searxng-suancai'
)

$allContainersOk = $true
foreach ($container in $containers) {
    if (-not (Test-DockerContainer -ContainerName $container)) {
        $allContainersOk = $false
    }
}

# 3. 测试 Web 端点
Write-Header "测试 Web 服务可访问性"

$endpoints = @(
    @{Url="http://localhost:18791"; Name="酱肉 UI"},
    @{Url="http://localhost:18792"; Name="豆沙 UI"},
    @{Url="http://localhost:18793"; Name="酸菜 UI"},
    @{Url="http://localhost:8081"; Name="酱肉 SearXNG"},
    @{Url="http://localhost:8082"; Name="豆沙 SearXNG"},
    @{Url="http://localhost:8083"; Name="酸菜 SearXNG"}
)

$allEndpointsOk = $true
foreach ($endpoint in $endpoints) {
    if (-not (Test-WebEndpoint -Url $endpoint.Url -Name $endpoint.Name)) {
        $allEndpointsOk = $false
    }
}

# 4. 获取 Token（仅当容器运行时）
if ($allContainersOk) {
    Write-Header "获取 OpenClaw Token"
    
    $tokens = @()
    $tokens += Get-OpenClawToken -ContainerName "openclaw-instance-1"
    $tokens += Get-OpenClawToken -ContainerName "openclaw-instance-2"
    $tokens += Get-OpenClawToken -ContainerName "openclaw-instance-3"
    
    if ($tokens) {
        Write-Host "`nToken 列表:" -ForegroundColor Yellow
        $tokens | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
    }
}

# 5. 总结测试结果
Write-Header "测试结果总结"

$totalTests = 2
$passedTests = 0

if ($allContainersOk) { 
    $passedTests++ 
    Write-Success "容器状态测试：通过"
} else {
    Write-Warning-Custom "容器状态测试：失败"
}

if ($allEndpointsOk) { 
    $passedTests++ 
    Write-Success "Web 服务测试：通过"
} else {
    Write-Warning-Custom "Web 服务测试：失败"
}

Write-Host "`n总计：$passedTests/$totalTests 测试通过" -ForegroundColor $(if ($passedTests -eq $totalTests) { "Green" } else { "Yellow" })

if ($passedTests -eq $totalTests) {
    Write-Success "所有服务运行正常！"
    exit 0
} else {
    Write-Warning-Custom "部分服务异常，请检查日志"
    exit 1
}
