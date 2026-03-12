<!-- Last Modified: 2026-03-12 -->

# TOOLS.md - 酸菜的工具箱

**角色:** 运维工程师 / 测试专家  
**技术栈:** systemd + Nginx + MySQL + Shell  
**运行模式:** 本地化运行 (非 Docker)  
**更新日期:** 2026-03-12

---

## 📡 Gateway 通信配置 ⭐⭐⭐

### 对话式通信

**通信方式:** 直接通过 Gateway 对话界面

**Gateway 连接:**
- **URL:** `http://localhost:18790`
- **端口:** 18790
- **模式:** local (loopback)
- **认证:** token
- **Token:** `4aa59ed646303abc8fdeb18147ab277c8f17b2ddff626a39`

**配置文件:** `C:\Users\Administrator\.openclaw\openclaw.json`

**工作空间:** `F:\openclaw\agent\workspace-suancai`

**说明:**
- ✅ 不再使用文件系统的 inbox/outbox 机制
- ✅ 所有沟通直接通过 Gateway 对话界面进行
- ✅ 任务分配、测试报告、监控告警都在对话中完成
- ✅ 更自然、更可靠、更高效

## 🔧 核心接口

### 1. 接收部署任务 (allocateTask)

**来源:** 灌汤 → 酸菜

**示例消息:**
```json
{
  "action": "allocateTask",
  "data": {
   "task": {
     "id": "TASK_20260310_003",
     "title": "部署博客系统到生产环境",
     "description": "完成生产环境的 Nginx 配置和 systemd 服务配置"
   },
   "requirements": [
     "配置 Nginx 反向代理",
     "配置 systemd 服务管理 Spring Boot",
     "配置监控和告警"
   ]
  }
}
```

---

### 2. 发送测试报告 (submitTestReport)

**来源:** 酸菜 → 酱肉/豆沙

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

**来源:** 酸菜 → 所有人

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
$gatewayUrl = "http://localhost:18790"
$token = "4aa59ed646303abc8fdeb18147ab277c8f17b2ddff626a39"

try {
    $headers = @{
        'Authorization' = "Bearer $token"
        'Content-Type' = 'application/json'
    }
    
    $response = Invoke-RestMethod -Uri "$gatewayUrl/api/v1/health" -Headers $headers -Method Get
    
    Write-Host "✅ Gateway 在线" -ForegroundColor Green
    Write-Host "状态：$($response.status)"
}
catch {
    Write-Host "❌ Gateway 离线" -ForegroundColor Red
    Write-Host "错误：$($_.Exception.Message)"
}
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

## 📚 统一知识库 ⭐⭐⭐【新增】

**知识库路径:** `F:\openclaw\agent\doc`

**知识库索引:** [../doc/README.md](../doc/README.md)

**常用文档:**
- [系统架构](../doc/specs/01-architecture/system-architecture.md)
- [错误监控](../doc/specs/03-technical-specs/agent-error-monitoring.md)
- [博客系统需求](../doc/specs/02-business-specs/blog-system-requirements.md)
- [轻量级模式](../doc/knowledge/02-best-practices/lightweight-mode.md)

---

## 📖 参考资料

**架构文档:** [../ARCHITECTURE.md](../ARCHITECTURE.md)
**轻量级架构:** [../doc/ARCHITECTURE-LITE.md](../doc/ARCHITECTURE-LITE.md)

---

**最后更新:** 2026-03-12  
**维护者:** 酸菜 (Suancai)
