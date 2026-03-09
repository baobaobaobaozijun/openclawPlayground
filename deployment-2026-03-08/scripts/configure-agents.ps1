# OpenClaw Agent API 密钥配置脚本
# 功能：为三个 Agent 容器配置阿里云 API 密钥

$ErrorActionPreference = "Stop"

$Agents = @(
    @{
        Name = "openclaw-instance-1"
        Model = "bailian/qwen3-coder-plus"
        ApiKey = "sk-0101b7d3672245ac8cd15d454198b4db"
        BaseUrl = "https://dashscope.aliyuncs.com/compatible-mode/v1"
    },
    @{
        Name = "openclaw-instance-2"
        Model = "bailian/qwen3-coder-plus"
        ApiKey = "sk-dc74719ea21348f183cbabb87f01999c"
        BaseUrl = "https://dashscope.aliyuncs.com/compatible-mode/v1"
    },
    @{
        Name = "openclaw-instance-3"
        Model = "bailian/qwen3-coder-plus"
        ApiKey = "sk-1edeed01f7104f75b0c4c69237b7f577"
        BaseUrl = "https://dashscope.aliyuncs.com/compatible-mode/v1"
    }
)

function Write-Header {
    param([string]$Text)
    Write-Host "`n$('='*60)"
    Write-Host $Text
    Write-Host $('='*60)`n -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Text)
    Write-Host "✅ $Text" -ForegroundColor Green
}

function Write-Error-Custom {
    param([string]$Text)
    Write-Host "❌ $Text" -ForegroundColor Red
}

function Configure-Agent {
    param(
        [string]$ContainerName,
        [string]$Model,
        [string]$ApiKey,
        [string]$BaseUrl
    )
    
    Write-Host "配置 $ContainerName ..." -ForegroundColor Yellow
    
    try {
        # 创建配置目录
        docker exec $ContainerName mkdir -p /home/node/.openclaw/agents/main/agent | Out-Null
        
        # 创建 auth-profiles.json
        $configJson = @"
{
  "model": "$Model",
  "provider": "bailian",
  "apiKey": "$ApiKey",
  "baseUrl": "$BaseUrl"
}
"@
        
        # 使用 base64 编码避免转义问题
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($configJson)
        $base64 = [Convert]::ToBase64String($bytes)
        
        docker exec $ContainerName bash -c "echo '$base64' | base64 -d > /home/node/.openclaw/agents/main/agent/auth-profiles.json" | Out-Null
        
        # 验证配置
        $result = docker exec $ContainerName cat /home/node/.openclaw/agents/main/agent/auth-profiles.json
        if ($result -and $result -match $Model) {
            Write-Success "$ContainerName 配置成功"
            return $true
        } else {
            Write-Error-Custom "$ContainerName 配置验证失败"
            return $false
        }
    } catch {
        Write-Error-Custom "$ContainerName 配置失败：$_"
        return $false
    }
}

function Restart-Agent {
    param([string]$ContainerName)
    
    Write-Host "重启 $ContainerName ..." -ForegroundColor Yellow
    try {
        docker restart $ContainerName | Out-Null
        Write-Success "$ContainerName 重启成功"
        return $true
    } catch {
        Write-Error-Custom "$ContainerName 重启失败：$_"
        return $false
    }
}

# 主流程
Write-Header "OpenClaw Agent API 密钥配置"

# 检查容器是否运行
Write-Host "检查容器状态..." -ForegroundColor Cyan
$runningContainers = docker ps --format "{{.Names}}"

$allOk = $true
foreach ($agent in $Agents) {
    if ($runningContainers -notcontains $agent.Name) {
        Write-Error-Custom "$($agent.Name) 未运行，请先启动容器"
        $allOk = $false
    }
}

if (-not $allOk) {
    Write-Host "`n请先运行：docker-compose -f docker-compose-agents.yml up -d" -ForegroundColor Yellow
    exit 1
}

# 配置每个 Agent
Write-Header "配置 API 密钥"

foreach ($agent in $Agents) {
    $result = Configure-Agent -ContainerName $agent.Name `
                              -Model $agent.Model `
                              -ApiKey $agent.ApiKey `
                              -BaseUrl $agent.BaseUrl
    
    if (-not $result) {
        $allOk = $false
    }
}

# 重启容器使配置生效
Write-Header "重启容器使配置生效"

foreach ($agent in $Agents) {
    Restart-Agent -ContainerName $agent.Name | Out-Null
}

# 等待容器启动
Write-Host "`n等待容器启动..." -ForegroundColor Cyan
Start-Sleep -Seconds 15

# 验证配置
Write-Header "验证配置"

foreach ($agent in $Agents) {
    Write-Host "检查 $($agent.Name) 日志..." -ForegroundColor Cyan
    $logs = docker logs $agent.Name --tail 5 2>&1
    
    if ($logs -match $agent.Model) {
        Write-Success "$($agent.Name) 使用模型：$($agent.Model)"
    } else {
        Write-Error-Custom "$($agent.Name) 配置可能未生效"
        $allOk = $false
    }
}

# 总结
Write-Header "配置完成"

if ($allOk) {
    Write-Success "所有 Agent 配置成功！"
    exit 0
} else {
    Write-Error-Custom "部分 Agent 配置失败，请检查日志"
    exit 1
}
