<!-- Last Modified: 2026-03-09 -->

# TOOLS.md - 本地笔记

## 📁 权限边界

**⚠️ 重要：写操作限制**

| 路径 | 权限 | 说明 |
|------|------|------|
| `F:\openclaw\agent\*` | ✅ 可写 | 我的工作空间 |
| `F:\openclaw\code\*` | ❌ 只读 | 代码目录 |
| `F:\openclaw\workspace\*` | ❌ 只读 | 其他工作区 |
| `C:\*` | ❌ 禁止 | 系统目录 |
| 其他所有路径 | ❌ 只读 | 外部数据 |

---

## 🏢 Agent 工作空间配置

**架构模式:** 单机多 Agent（非 Docker 集群）  
**Gateway:** 本地 Gateway (Port 18790)  
**通信方式:** Gateway 实时路由

### 灌汤 (PM) 🍲
- **Agent ID:** `guantang`
- **Workspace**: `F:\openclaw\agent\workspace-guantang`
- **Model:** `bailian/qwen3.5-plus`
- **职责**: 产品规划、需求分析、任务分配、进度跟踪

### 酱肉 (后端工程师) 🍖
- **Agent ID:** `jiangrou`
- **Workspace**: `F:\openclaw\agent\workspace-jiangrou`
- **Model:** `bailian/qwen3-coder-plus`
- **技术栈**: Java 21 + Spring Boot 3.2+ + MySQL 8.0+ + Redis 7.0+
- **核心职责**:
  - RESTful API 设计与实现
  - 数据库架构设计与优化
  - JWT 认证与权限管理（RBAC）
  - 性能优化（API < 200ms, DB < 50ms）
  - 安全加固（SQL 注入防护、XSS/CSRF 防范）
  - 单元测试覆盖率 ≥ 80%
- **交付标准**:
  - API 文档（OpenAPI/Swagger）
  - 数据库 ER 图和数据字典
  - 通过 SonarQube 扫描（无 Blocker/Critical 问题）
  - 方法复杂度 < 10

### 豆沙 (前端工程师) 🍡
- **Agent ID:** `dousha`
- **Workspace**: `F:\openclaw\agent\workspace-dousha`
- **Model:** `bailian/qwen3-coder-plus`
- **职责**: Vue 3 开发、TypeScript、UI/UX设计

### 酸菜 (运维工程师) 🥬
- **Agent ID:** `suancai`
- **Workspace**: `F:\openclaw\agent\workspace-suancai`
- **Model:** `bailian/qwen3-coder-plus`
- **职责**: 部署脚本、CI/CD 配置、监控告警、自动化测试

---

## 🛠️ 我的 Skills

### 1. working-logger 📝

**用途:** 记录对 `F:\openclaw\agent` 的所有修改

**日志位置:** `F:\openclaw\agent\workinglog\`

**文件名格式:** `YYYYMMDD-hhmmss-{修改人}-{修改内容}.md`

### 2. auto-github-push 🚀

**用途:** 自动推送代码到 GitHub

**仓库:** https://github.com/baobaobaobaozijun/openclawPlayground

**触发时机:** 每次修改完 agent 文件夹后

---

## 📡 Agent 通信

### ⭐ 重要：Gateway 连接配置

**统一 Gateway 配置:**
```json
{
  "gateway": {
   "port": 18790,
   "mode": "local",
   "bind": "loopback",
   "auth": {
     "mode": "token",
     "token": "4aa59ed646303abc8fdeb18147ab277c8f17b2ddff626a39"
   }
  }
}
```

**配置文件位置:** `C:\Users\Administrator\.openclaw\openclaw.json`

### Agent 间通信

**架构:** 单机多 Agent，通过 Gateway 实时路由  
**通信目录:** `F:\openclaw\agent\communication\`（可选，用于日志记录）

```
communication/
├── inbox/           # 接收的消息（日志）
│   ├── guantang/   # 灌汤的收件箱
│   ├── jiangrou/   # 酱肉的收件箱
│   ├── dousha/     # 豆沙的收件箱
│   └── suancai/    # 酸菜的收件箱
└── outbox/         # 发送的消息（日志）
   ├── guantang/   # 灌汤的发件箱
   ├── jiangrou/   # 酱肉的发件箱
   ├── dousha/     # 豆沙的发件箱
   └── suancai/    # 酸菜的发件箱
```

### 核心接口

#### 1. allocateTask - 任务分发

**灌汤 → 酱肉:**
```json
{
  "action": "allocateTask",
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

#### 2. queryProgress - 进度查询

**灌汤 → 酱肉:**
```json
{
  "action": "queryProgress",
  "data": {
   "task_ids": ["TASK_20260310_001"],
   "include_details": true
  }
}
```

#### 3. reportIssue - 问题报告

**酱肉 → 灌汤:**
```json
{
  "action": "reportIssue",
  "data": {
   "task_id": "TASK_20260310_001",
   "issue": {
     "type": "technical",
     "severity": "medium",
     "title": "JWT 库版本冲突",
     "description": "当前 JWT 库与 Spring Boot 版本不兼容"
   },
   "proposed_solution": "升级 Spring Boot 到 3.2.5"
  }
}
```

#### 4. submitDeliverable - 交付物提交

**酱肉 → 灌汤:**
```json
{
  "action": "submitDeliverable",
  "data": {
   "task_id": "TASK_20260310_001",
   "deliverables": [
     {
       "name": "用户认证 API",
       "type": "code",
       "path": "code/backend/api/auth/",
       "version": "1.0.0",
       "status": "ready_for_review"
     }
   ]
  }
}
```

### 📚 统一知识库 ⭐⭐⭐【新增】

**知识库路径:** `F:\openclaw\agent\doc`

**知识库索引:** [../doc/README.md](../doc/README.md)

**常用文档:**
- [系统架构](../doc/specs/01-architecture/system-architecture.md)
- [Agent 通信协议 v2.0](../doc/specs/03-technical-specs/agent-communication-protocol-v2.md)
- [错误监控](../doc/specs/03-technical-specs/agent-error-monitoring.md)
- [博客系统需求](../doc/specs/02-business-specs/blog-system-requirements.md)

**管理职责:**
- ✅ 维护知识库整体结构
- ✅ 审核新增文档
- ✅ 定期检查文档完整性
- ✅ 通知 Agent 文档更新

---

### 详细文档

查看完整的通信协议：[agent-communication-protocol-v2.md](./specs/03-technical-specs/agent-communication-protocol-v2.md)

---

## 🔧 常用命令

```bash
# GitHub 认证
gh auth login

# 检查 git 状态
cd F:\openclaw\agent && git status

# 手动推送
cd F:\openclaw\agent && git add . && git commit -m "message" && git push

# 安装 skill
cd F:\openclaw\agent\workspace-guantang
npx clawhub install <skill-name>
```

---

*最后更新：2026-03-09*
