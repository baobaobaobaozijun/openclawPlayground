# OpenClaw Agent API Key Configuration Script
# Configure API keys for three Agent containers

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
    Write-Host "[OK] $Text" -ForegroundColor Green
}

function Write-Fail {
    param([string]$Text)
    Write-Host "[FAIL] $Text" -ForegroundColor Red
}

function Configure-Agent {
    param(
        [string]$ContainerName,
        [string]$Model,
        [string]$ApiKey,
        [string]$BaseUrl
    )
    
    Write-Host "Configuring $ContainerName ..." -ForegroundColor Yellow
    
    try {
        # Create config directory
        docker exec $ContainerName mkdir -p /home/node/.openclaw/agents/main/agent | Out-Null
        
        # Create auth-profiles.json
        $configJson = @"
{"model":"$Model","provider":"bailian","apiKey":"$ApiKey","baseUrl":"$BaseUrl"}
"@
        
        # Use base64 encoding to avoid escape issues
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($configJson)
        $base64 = [Convert]::ToBase64String($bytes)
        
        docker exec $ContainerName bash -c "echo '$base64' | base64 -d > /home/node/.openclaw/agents/main/agent/auth-profiles.json" | Out-Null
        
        # Verify configuration
        $result = docker exec $ContainerName cat /home/node/.openclaw/agents/main/agent/auth-profiles.json
        if ($result -and $result -match $Model) {
            Write-Success "$ContainerName configured successfully"
            return $true
        } else {
            Write-Fail "$ContainerName configuration verification failed"
            return $false
        }
    } catch {
        Write-Fail "$ContainerName configuration failed: $_"
        return $false
    }
}

function Restart-Agent {
    param([string]$ContainerName)
    
    Write-Host "Restarting $ContainerName ..." -ForegroundColor Yellow
    try {
        docker restart $ContainerName | Out-Null
        Write-Success "$ContainerName restarted"
        return $true
    } catch {
        Write-Fail "$ContainerName restart failed: $_"
        return $false
    }
}

# Main
Write-Header "OpenClaw Agent API Key Configuration"

# Check if containers are running
Write-Host "Checking container status..." -ForegroundColor Cyan
$runningContainers = docker ps --format "{{.Names}}"

$allOk = $true
foreach ($agent in $Agents) {
    if ($runningContainers -notcontains $agent.Name) {
        Write-Fail "$($agent.Name) is not running. Please start containers first."
        $allOk = $false
    }
}

if (-not $allOk) {
    Write-Host "`nPlease run: docker-compose -f docker-compose-agents.yml up -d" -ForegroundColor Yellow
    exit 1
}

# Configure each Agent
Write-Header "Configure API Keys"

foreach ($agent in $Agents) {
    $result = Configure-Agent -ContainerName $agent.Name `
                              -Model $agent.Model `
                              -ApiKey $agent.ApiKey `
                              -BaseUrl $agent.BaseUrl
    
    if (-not $result) {
        $allOk = $false
    }
}

# Restart containers to apply configuration
Write-Header "Restart containers to apply configuration"

foreach ($agent in $Agents) {
    Restart-Agent -ContainerName $agent.Name | Out-Null
}

# Wait for containers to start
Write-Host "`nWaiting for containers to start..." -ForegroundColor Cyan
Start-Sleep -Seconds 15

# Verify configuration
Write-Header "Verify configuration"

foreach ($agent in $Agents) {
    Write-Host "Checking $($agent.Name) logs..." -ForegroundColor Cyan
    $logs = docker logs $agent.Name --tail 5 2>&1
    
    if ($logs -match $agent.Model) {
        Write-Success "$($agent.Name) using model: $($agent.Model)"
    } else {
        Write-Fail "$($agent.Name) configuration may not be effective"
        $allOk = $false
    }
}

# Summary
Write-Header "Configuration Complete"

if ($allOk) {
    Write-Success "All Agents configured successfully!"
    exit 0
} else {
    Write-Fail "Some Agents failed to configure. Please check logs."
    exit 1
}
