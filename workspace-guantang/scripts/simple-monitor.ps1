# Simple Agent Monitor
# 简化版 Agent 监控脚本 - 零成本、实用主义
# 执行频率：每 5 分钟

param(
    [int]$checkInterval = 300,  # 5 分钟
    [string]$baseLogPath = "F:\openclaw\agent\workspace-guantang\disasters"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  OpenClaw Agent 监控系统 (简化版)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 确保日志目录存在
if (-not (Test-Path $baseLogPath)) {
    New-Item-ItemType Directory -Force-Path $baseLogPath | Out-Null
}

$timestamp = Get-Date -Format"yyyy-MM-dd HH:mm:ss"
$logFile = Join-Path $baseLogPath"monitor-log.txt"
$disasterDir = Join-Path $baseLogPath "disaster-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

function Write-Log {
    param([string]$message, [string]$level = "INFO")
    $logEntry = "[$(Get-Date-Format 'yyyy-MM-dd HH:mm:ss')] [$level] $message"
    Write-Host $logEntry
    Add-Content-Path $logFile -Value $logEntry
}

function Check-GatewayHealth {
    Write-Log "检查 Gateway 健康状态..."
    $gatewayUrl = "http://localhost:18789"
    
    try {
        $response = Invoke-RestMethod -Uri "$gatewayUrl/api/v1/health" -TimeoutSec 5 -ErrorAction Stop
        Write-Log "✅ Gateway 在线 (响应时间：$($response.responseTime)ms)" -ForegroundColor Green
       return $true
    }
    catch {
        Write-Log "❌ Gateway 离线：$($_.Exception.Message)" -ForegroundColor Red
        Save-Disaster "Gateway 离线" "gateway_offline" $_.Exception.Message
       return $false
    }
}

function Check-DockerContainers {
    Write-Log "检查 Docker 容器状态..."
    $containers = @("openclaw-instance-1", "openclaw-instance-2", "openclaw-instance-3")
    $allHealthy = $true
    
    foreach ($container in $containers) {
        try {
            $status = docker inspect -f '{{.State.Health.Status}}' $container 2>$null
            
           if ($status -eq "healthy") {
                Write-Log "✅ $container 健康运行" -ForegroundColor Green
            }
            else {
                Write-Log "⚠️ $container 状态异常：$status" -ForegroundColor Yellow
                Save-Disaster "容器异常" "container_unhealthy" "Container: $container, Status: $status"
                $allHealthy = $false
            }
        }
        catch {
            Write-Log "❌ $container 无法访问：$($_.Exception.Message)" -ForegroundColor Red
            Save-Disaster "容器宕机" "container_down" "Container: $container`nError: $($_.Exception.Message)"
            $allHealthy = $false
        }
    }
    
   return $allHealthy
}

function Check-TokenUsage {
    Write-Log "检查 Token 使用情况..."
    
    # 检查工作日志中的 API 调用统计
    $statsPath = "F:\openclaw\agent\workinglog"
    $recentLogs = Get-ChildItem -Path $statsPath -Filter "*.md" | 
                  Where-Object { $_.LastWriteTime -gt (Get-Date).AddHours(-1) } |
                  Select-Object-First 10
    
    $apiCallCount = 0
    foreach ($log in $recentLogs) {
        $content = Get-Content $log.FullName -Raw
        $apiCallCount += ([regex]::Matches($content, "API 调用")).Count
    }
    
   if ($apiCallCount-gt 1800) {
        Write-Log "⚠️ Token 使用量接近限制 (当前：$apiCallCount/2000)" -ForegroundColor Yellow
        Save-Disaster "Token 告警" "token_warning" "过去 1 小时 API 调用：$apiCallCount 次"
    }
    else {
        Write-Log "✅ Token 使用正常 (当前：$apiCallCount/2000)" -ForegroundColor Green
    }
}

function Check-AgentMemories {
    Write-Log "检查 Agent memory.md 更新情况..."
    $agents = @("jiangrou", "dousha", "suancai")
    
    foreach ($agent in $agents) {
        $memoryPath = "F:\openclaw\agent\workspace-$agent\MEMORY.md"
        
       if (Test-Path $memoryPath) {
            $lastModified = (Get-Item $memoryPath).LastWriteTime
            $hoursAgo = (Get-Date) - $lastModified
            
           if ($hoursAgo.TotalHours -gt 24) {
                Write-Log "⚠️ $agent MEMORY.md 超过 24 小时未更新" -ForegroundColor Yellow
            }
            else {
                Write-Log "✅ $agent MEMORY.md 正常更新 (最后：$([math]::Round($hoursAgo.TotalMinutes, 0))分钟前)" -ForegroundColor Green
            }
        }
        else {
            Write-Log "❌ $agent MEMORY.md 不存在" -ForegroundColor Red
        }
    }
}

function Save-Disaster {
    param(
        [string]$title,
        [string]$type,
        [string]$details
    )
    
    Write-Log "🚨 保存灾难现场：$title" -ForegroundColor Red
    
    # 创建灾难目录
    $disasterPath = Join-Path $baseLogPath "disaster-$(Get-Date -Format 'yyyyMMdd-HHmmss')-$type"
    New-Item-ItemType Directory -Force-Path $disasterPath | Out-Null
    
    # 保存错误详情
    $errorReport = @"
# 灾难报告 - $title

**发生时间:** $(Get-Date-Format 'yyyy-MM-dd HH:mm:ss')
**类型:** $type
**严重程度:** $((@{'gateway_offline'='CRITICAL'; 'container_down'='HIGH'; 'container_unhealthy'='MEDIUM'; 'token_warning'='LOW'})[$type])

## 错误详情

$details

## 系统状态

### Docker 容器状态
$(docker ps --filter "name=openclaw-instance" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>$null | Out-String)

### Gateway 状态
$(try { Invoke-RestMethod "http://localhost:18789/api/v1/health" -TimeoutSec 3 2>$null | ConvertTo-Json -Depth 3 } catch { "Gateway 无法连接" })

### 网络配置
$(docker network inspect openclaw-network 2>$null | ConvertTo-Json -Depth 2)

## 已采取的措施

- [x] 自动保存错误日志
- [x] 保存 Docker 配置
- [ ] 等待管理员处理

## 恢复建议

"@

   if ($type -eq "gateway_offline") {
        $errorReport += @"
1. 尝试重启 Gateway 服务
2. 检查端口 18789 是否被占用
3. 查看 Gateway 日志定位问题
"@
    }
    elseif ($type -eq "container_down") {
        $errorReport += @"
1. 查看容器日志：docker logs <container_name>
2. 尝试重启容器：docker restart <container_name>
3. 检查 Docker 资源是否充足
"@
    }
    
    # 保存报告
    $errorReport | Out-File -FilePath "$disasterPath\DISASTER_REPORT.md" -Encoding UTF8
    
    # 保存相关日志
    try {
       docker logs openclaw-instance-1 > "$disasterPath\jiangrou.log" 2>&1
       docker logs openclaw-instance-2 > "$disasterPath\dousha.log" 2>&1
       docker logs openclaw-instance-3 > "$disasterPath\suancai.log" 2>&1
    }
    catch {}
    
    Write-Log "✅ 灾难现场已保存到：$disasterPath" -ForegroundColor Green
}

# 主循环
$iteration = 0
while ($true) {
    $iteration++
    Write-Log "========== 第 $iteration 次检查 =========="
    
    # 1. 检查 Gateway
    $gatewayOk = Check-GatewayHealth
    
    # 2. 检查 Docker 容器
    $containersOk = Check-DockerContainers
    
    # 3. 检查 Token 使用
   if ($gatewayOk) {
        Check-TokenUsage
    }
    
    # 4. 检查 Memory.md
    Check-AgentMemories
    
    # 总结
   if ($gatewayOk -and $containersOk) {
        Write-Log "✅ 所有系统正常" -ForegroundColor Green
    }
    else {
        Write-Log "⚠️ 发现异常，请查看灾难报告" -ForegroundColor Yellow
    }
    
    Write-Log ""
    Write-Log "下次检查时间：$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + $($checkInterval/ 60) 分钟"
    Write-Log ""
    
    # 等待下次检查
   Start-Sleep -Seconds $checkInterval
}
