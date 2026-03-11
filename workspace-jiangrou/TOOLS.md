<!-- Last Modified: 2026-03-10 -->

# TOOLS.md - 酱肉的工具箱

**角色:** 后端工程师  
**技术栈:** Java 21 + Spring Boot 3.2+  
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
  - OPENCLAW_API_KEY=sk-0101b7d3672245ac8cd15d454198b4db
  - INSTANCE_NAME=jiangrou
  - INSTANCE_ROLE=backend-engineer
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

**本地路径:** `F:\openclaw\agent\workspace-jiangrou\communication\inbox\`

**Docker 内路径:** `/app/workspace/communication/inbox/`

**说明:**
- 接收来自灌汤的任务分配
- 接收来自豆沙的 API 接口请求
- 接收来自酸菜的测试报告

### 发件箱 (Outbox)

**本地路径:** `F:\openclaw\agent\workspace-jiangrou\communication\outbox\`

**Docker 内路径:** `/app/workspace/communication/outbox/`

**说明:**
- 向灌汤提交任务成果
- 向豆沙提供 API 接口文档
- 向酸菜发送测试请求

---

## 🔧 核心接口

### 1. 接收任务 (allocateTask)

**来源:**灌汤 → 酱肉

**示例消息:**
```json
{
  "version": "2.0",
  "message_id": "MSG_20260310_001",
  "from": {
   "agent": "灌汤",
   "role": "pm"
  },
  "to": {
   "agent": "酱肉",
   "role": "backend-engineer"
  },
  "action": "allocateTask",
  "priority": "high",
  "data": {
   "task": {
     "id": "TASK_20260310_001",
     "title": "开发用户认证 API",
     "description": "实现登录、注册、JWT 认证功能"
   },
   "requirements": [
     "支持用户名密码登录",
     "JWT token 有效期 24 小时",
     "包含单元测试"
   ],
   "timeline": {
     "start_date": "2026-03-10",
     "due_date": "2026-03-12"
   }
  }
}
```

**响应格式:**
```json
{
  "action": "acknowledgeTask",
  "data": {
   "task_id": "TASK_20260310_001",
   "status": "accepted",
   "estimated_start": "2026-03-10T14:00:00Z",
   "notes": "已接收，按时开始"
  }
}
```

---

### 2. 发送进度 (progressReport)

**来源:**酱肉 → 灌汤

**示例消息:**
```json
{
  "action": "progressReport",
  "data": {
   "task_id": "TASK_20260310_001",
   "status": "in_progress",
   "progress_percentage": 60,
   "completed_work": "完成用户认证模块",
   "remaining_work": "文章管理模块开发中",
   "blockers": []
  }
}
```

---

### 3. 报告问题 (reportIssue)

**来源:**酱肉 → 灌汤

**示例消息:**
```json
{
  "action": "reportIssue",
  "priority": "high",
  "data": {
   "task_id": "TASK_20260310_001",
   "issue": {
     "type": "technical",
     "severity": "medium",
     "title": "JWT 库版本冲突",
     "description": "当前 JWT 库与 Spring Boot 版本不兼容"
   },
   "proposed_solution": "降级 JWT 库到 1.x 版本",
   "needs_decision": true
  }
}
```

---

### 4. 提交成果 (submitDeliverable)

**来源:**酱肉 → 灌汤

**示例消息:**
```json
{
  "action": "submitDeliverable",
  "data": {
   "task_id": "TASK_20260310_001",
   "deliverables": [
     {
       "name": "用户认证 API",
       "type": "code",
       "path": "code/backend/api/auth.py",
       "version": "1.0.0",
       "status": "ready_for_review",
       "test_coverage": 85
     }
   ],
   "completion_report": {
     "summary": "已完成所有要求的功能",
     "testing_status": "单元测试通过"
   }
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
    Write-Host "❌ Gateway 离线" -ForegroundColor Red
    Write-Host "错误：$($_.Exception.Message)"
}
```

### 测试宿主机连通性

**Bash (Docker 内):**
```bash
# Ping 宿主机
ping host.docker.internal

# 测试 Gateway 端口
curl -H "Authorization: Bearer 4aa59ed646303abc8fdeb18147ab277c8f17b2ddff626a39" \
     http://host.docker.internal:18789/api/v1/health
```

---

## 📊 错误处理

### 常见错误码

| 错误码 | 名称 | 说明 | 处理方式 |
|--------|------|------|---------|
| ERR_001 | AGENT_UNREACHABLE | 灌汤不可达 | 重试 3 次，使用文件模式 |
| ERR_003 | AUTH_FAILED | 认证失败 | 检查 Token 配置 |
| ERR_004 | GATEWAY_OFFLINE | Gateway 离线 | 降级到文件系统 |
| ERR_005 | TIMEOUT | 请求超时 | 增加超时时间 |

### 降级策略

```yaml
正常模式:
  Gateway 在线 → 使用 Gateway RPC 通信
  
降级模式:
  Gateway 离线 → 使用文件系统通信
  1. 消息写入 /app/workspace/communication/outbox/guantang/
  2. 定期轮询 /app/workspace/communication/inbox/jiangrou/
  3. Gateway 恢复后自动切换回来
```

---

## 📚 统一知识库 ⭐⭐⭐【新增】

**知识库路径:** `/app/doc` (Docker 容器内)  
**本地路径:** `F:\openclaw\agent\doc`

**知识库索引:** [../../doc/README.md](../../doc/README.md)

**常用文档:**
- [系统架构](../../doc/specs/01-architecture/system-architecture.md)
- [Agent 通信协议 v2.0](../../doc/specs/03-technical-specs/agent-communication-protocol-v2.md)
- [博客系统需求](../../doc/specs/02-business-specs/blog-system-requirements.md)
- [数据库设计](../../doc/specs/02-business-specs/blog-system-database-design.md)
- [错误监控](../../doc/specs/03-technical-specs/agent-error-monitoring.md)

**知识库分类:**
```
doc/
├── specs/           # 规范文档
│   ├── 01-architecture/    # 架构设计
│   ├── 02-business-specs/  # 业务需求
│   ├── 03-technical-specs/ # 技术规范
│   └── 04-processes/       # 流程规范
├── guides/          # 使用指南
└── knowledge/       # 知识库
```

---

## 📖 参考资料

**完整通信协议:** [agent-communication-protocol-v2.md](../workspace-guantang/specs/03-technical-specs/agent-communication-protocol-v2.md)

**架构说明:** [ARCHITECTURE.md](../ARCHITECTURE.md)

---

**最后更新:** 2026-03-10  
**维护者:**酱肉 (Jiangrou)
