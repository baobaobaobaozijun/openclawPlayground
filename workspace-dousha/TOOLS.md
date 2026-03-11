<!-- Last Modified: 2026-03-10 -->

# TOOLS.md - 豆沙的工具箱

**角色:**前端工程师 / UI/UX设计师  
**技术栈:** Vue 3 + TypeScript + Vite  
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
  - OPENCLAW_API_KEY=sk-dc74719ea21348f183cbabb87f01999c
  - INSTANCE_NAME=dousha
  - INSTANCE_ROLE=frontend-engineer
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

**本地路径:** `F:\openclaw\agent\workspace-dousha\communication\inbox\`

**Docker 内路径:** `/app/workspace/communication/inbox/`

**说明:**
- 接收来自灌汤的设计任务
- 接收来自酱肉的 API 接口文档
- 接收来自酸菜的前端测试报告

### 发件箱 (Outbox)

**本地路径:** `F:\openclaw\agent\workspace-dousha\communication\outbox\`

**Docker 内路径:** `/app/workspace/communication/outbox/`

**说明:**
- 向灌汤提交设计成果
- 向酱肉请求 API 接口调整
- 向酸菜发送前端测试请求

---

## 🔧 核心接口

### 1. 接收设计任务 (allocateTask)

**来源:**灌汤 → 豆沙

**示例消息:**
```json
{
  "action": "allocateTask",
  "data": {
   "task": {
     "id": "TASK_20260310_002",
     "title": "博客首页 UI 设计",
     "description": "设计并实现博客首页，包含文章列表、分页、搜索功能"
   },
   "requirements": [
     "响应式设计，支持 PC 和移动端",
     "使用 Element Plus 组件库",
     "配色方案参考现代博客平台"
   ],
   "deliverables": [
     {
       "type": "design",
       "path": "workspace-dousha/designs/homepage-mockup.png"
     },
     {
       "type": "code",
       "path": "code/frontend/views/Home.vue"
     }
   ]
  }
}
```

---

### 2. API 接口请求 (requestAPIChange)

**来源:**豆沙 → 酱肉

**示例消息:**
```json
{
  "action": "requestAPIChange",
  "data": {
   "api_endpoint": "/api/articles",
   "current_issue": "返回的文章列表缺少作者信息",
   "requested_change": "在文章列表中增加 author 字段",
   "urgency": "medium"
  }
}
```

---

### 3. 提交设计成果 (submitDesign)

**来源:**豆沙 → 灌汤

**示例消息:**
```json
{
  "action": "submitDesign",
  "data": {
   "task_id": "TASK_20260310_002",
   "deliverables": [
     {
       "name": "博客首页设计稿",
       "type": "design",
       "path": "workspace-dousha/designs/homepage-mockup.png",
       "format": "PNG + Figma"
     },
     {
       "name": "首页组件代码",
       "type": "code",
       "path": "code/frontend/views/Home.vue",
       "status": "ready_for_review"
     }
   ]
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
}
catch {
    Write-Host "❌ Gateway 离线" -ForegroundColor Red
}
```

---

## 📊 错误处理

### 常见错误码

| 错误码 | 名称 | 说明 | 处理方式 |
|--------|------|------|---------|
| ERR_001 | AGENT_UNREACHABLE | Agent 不可达 | 重试 3 次，使用文件模式 |
| ERR_003 | AUTH_FAILED | 认证失败 | 检查 Token 配置 |
| ERR_004 | GATEWAY_OFFLINE | Gateway 离线 | 降级到文件系统 |

---

## 📚 统一知识库 ⭐⭐⭐【新增】

**知识库路径:** `/app/doc` (Docker 容器内)  
**本地路径:** `F:\openclaw\agent\doc`

**知识库索引:** [../../doc/README.md](../../doc/README.md)

**常用文档:**
- [系统架构](../../doc/specs/01-architecture/system-architecture.md)
- [Agent 通信协议 v2.0](../../doc/specs/03-technical-specs/agent-communication-protocol-v2.md)
- [博客系统需求](../../doc/specs/02-business-specs/blog-system-requirements.md)
- [前端开发指南](../../doc/guides/03-agent-guides/dousha-guide.md) (待创建)

---

## 📖 详细文档

**完整通信协议:** [agent-communication-protocol-v2.md](../workspace-guantang/specs/03-technical-specs/agent-communication-protocol-v2.md)

**架构说明:** [ARCHITECTURE.md](../ARCHITECTURE.md)

---

**最后更新:** 2026-03-10  
**维护者:**豆沙 (Dousha)
