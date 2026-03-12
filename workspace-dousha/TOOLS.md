<!-- Last Modified: 2026-03-12 -->

# TOOLS.md - 豆沙的工具箱

**角色:** 前端工程师 / UI/UX设计师  
**技术栈:** Vue 3 + TypeScript + Vite  
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

**工作空间:** `F:\openclaw\agent\workspace-dousha`

**说明:**
- ✅ 不再使用文件系统的 inbox/outbox 机制
- ✅ 所有沟通直接通过 Gateway 对话界面进行
- ✅ 任务分配、设计评审、协作讨论都在对话中完成
- ✅ 更自然、更可靠、更高效

## 🔧 核心接口

### 1. 接收设计任务 (allocateTask)

**来源:** 灌汤 → 豆沙

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

**来源:** 豆沙 → 酱肉

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

**来源:** 豆沙 → 灌汤

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
$gatewayUrl = "http://localhost:18790"
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

**知识库路径:** `F:\openclaw\agent\doc`

**知识库索引:** [../doc/README.md](../doc/README.md)

**常用文档:**
- [系统架构](../doc/specs/01-architecture/system-architecture.md)
- [前端组件设计](../doc/specs/03-technical-specs/frontend-components.md)
- [博客系统需求](../doc/specs/02-business-specs/blog-system-requirements.md)
- [轻量级模式](../doc/knowledge/02-best-practices/lightweight-mode.md)

---

## 📖 参考资料

**架构文档:** [../ARCHITECTURE.md](../ARCHITECTURE.md)
**轻量级架构:** [../doc/ARCHITECTURE-LITE.md](../doc/ARCHITECTURE-LITE.md)

---

**最后更新:** 2026-03-12  
**维护者:** 豆沙 (Dousha)
