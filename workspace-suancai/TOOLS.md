<!-- Last Modified: 2026-03-10 -->

# TOOLS.md - 酸菜的工具箱

**角色:**运维工程师 / 测试专家  
**技术栈:**Docker + K8s + Jenkins + JUnit  
**更新日期:** 2026-03-10

---

## 📡 Gateway 通信配置 ⭐⭐⭐

### Docker 容器内配置

**环境变量:**
```yaml
environment:
  # ⭐ Gateway 连接配置 (必须)
  - OPENCLAW_GATEWAY_URL=http://host.docker.internal:18789
  - OPENCLAW_GATEWAY_TOKEN=4aa59ed646303abc8fdeb18147ab277c8f17b2ddff626a39
  
  # 其他配置
  - OPENCLAW_MODEL=bailian/qwen3-coder-plus
  - OPENCLAW_API_BASE_URL=https://dashscope.aliyuncs.com/compatible-mode/v1
  - OPENCLAW_API_KEY=sk-1edeed01f7104f75b0c4c69237b7f577
  - INSTANCE_NAME=suancai
  - INSTANCE_ROLE=devops-engineer
```

**Docker 网络配置:**
```yaml
extra_hosts:
  # ⭐ 允许访问宿主机网络 (必须)
  - "host.docker.internal:host-gateway"
```

### 本地 Gateway 信息

**灌汤 Gateway:**
- **URL:** `http://localhost:18789`
- **端口:** 18789
- **模式:** local (loopback)
- **认证:** token
- **Token:** `4aa59ed646303abc8fdeb18147ab277c8f17b2ddff626a39`

**配置文件:** `C:\Users\Administrator\.openclaw\openclaw.json`

---

## 📨 通信目录

### 收件箱 (Inbox)

**本地路径:** `F:\openclaw\agent\workspace-suancai\communication\inbox\`

**Docker 内路径:** `/app/workspace/communication/inbox/`

**说明:**
- 接收来自灌汤的部署任务
- 接收来自酱肉的测试请求
- 接收来自豆沙的前端测试请求

### 发件箱 (Outbox)

**本地路径:** `F:\openclaw\agent\workspace-suancai\communication\outbox\`

**Docker 内路径:** `/app/workspace/communication/outbox/`

**说明:**
- 向灌汤报告部署状态
- 向酱肉/豆沙发送测试报告
- 向所有人发送监控告警

---

## 🔧 核心接口

### 1. 接收部署任务 (allocateTask)

**来源:**灌汤 → 酸菜

**示例消息:**
```json
{
  "action": "allocateTask",
  "data": {
   "task": {
     "id": "TASK_20260310_003",
     "title": "部署博客系统到生产环境",
     "description": "完成生产环境的 Docker 部署和 CI/CD 配置"
   },
   "requirements": [
     "配置 Docker Compose 生产环境",
    设置 CI/CD Pipeline",
     "配置监控和告警"
   ]
  }
}
```

---

### 2. 发送测试报告 (submitTestReport)

**来源:**酸菜 → 酱肉/豆沙

**示例消息:**
```json
{
  "action": "submitTestReport",
  "data": {
   "task_id": "TASK_20260310_001",
   "test_type": "integration",
   "result": "passed",
   "statistics": {
     "total_tests": 45,
     "passed": 45,
     "failed": 0,
     "coverage": 87
   },
   "issues": [],
   "ready_for_deployment": true
  }
}
```

---

### 3. 发送监控告警 (sendAlert)

**来源:**酸菜 → 所有人

**示例消息:**
```json
{
  "action": "sendAlert",
  "priority": "critical",
  "data": {
   "alert_type": "system",
   "severity": "high",
   "title": "CPU 使用率超过阈值",
   "description": "后端服务器 CPU 使用率达到 95%",
   "affected_services": ["backend-api"],
   "recommended_action": "检查慢查询和性能瓶颈"
  }
}
```

---

## 🛠️ 常用命令

### 检查 Gateway 连接

**PowerShell:**
```powershell
$gatewayUrl = "http://host.docker.internal:18789"
$token = "4aa59ed646303abc8fdeb18147ab277c8f17b2ddff626a39"

try {
    $headers = @{
        'Authorization' = "Bearer $token"
        'Content-Type' = 'application/json'
    }
    
    $response = Invoke-RestMethod -Uri "$gatewayUrl/api/v1/health" -Headers $headers -Method Get
    
    Write-Host "✅ Gateway 在线" -ForegroundColor Green
    Write-Host"状态：$($response.status)"
}
catch {
    Write-Host"❌ Gateway 离线" -ForegroundColor Red
    Write-Host "错误：$($_.Exception.Message)"
}
```

### 测试所有 Agent 连通性

**Bash:**
```bash
#!/bin/bash

GATEWAY_URL="http://host.docker.internal:18789"
TOKEN="4aa59ed646303abc8fdeb18147ab277c8f17b2ddff626a39"

echo "检查 Gateway 健康状态..."
curl -H "Authorization: Bearer $TOKEN" $GATEWAY_URL/api/v1/health

echo -e "\n检查各 Agent 状态..."
for agent in guantang jiangrou dousha suancai; do
    echo "检查 $agent..."
    curl -H "Authorization: Bearer $TOKEN" \
         "$GATEWAY_URL/api/v1/agents/$agent/status"
    echo ""
done
```

---

## 📊 错误处理

### 常见错误码

| 错误码 | 名称 | 说明 | 处理方式 |
|--------|------|------|---------|
| ERR_001 | AGENT_UNREACHABLE | Agent 不可达 | 重试 3 次，发送告警 |
| ERR_003 | AUTH_FAILED | 认证失败 | 检查 Token 配置 |
| ERR_004 | GATEWAY_OFFLINE | Gateway 离线 | 降级到文件系统 |
| ERR_005 | TIMEOUT | 请求超时 | 增加超时时间 |

### 监控策略

```yaml
监控指标:
  - Gateway 可用性
  - Agent 响应时间
  - 消息队列长度
  - 错误率

告警阈值:
  - Gateway 不可用 > 1 分钟 → P0 告警
  - Agent 无响应 > 5 分钟 → P1 告警
  - 错误率 > 5% → P2 告警
```

---

**最后更新:** 2026-03-10  
**维护者:**酸菜 (Suancai)
