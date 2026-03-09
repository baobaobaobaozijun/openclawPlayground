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

### 灌汤 (PM)
- **Workspace**: `F:\openclaw\agent\workspace-guantang`
- **Code**: `F:\openclaw\code` (共享)
- **Docker 挂载**: `/app/workspace`
- **职责**: 产品规划、需求分析、任务分配、进度跟踪

### 酱肉 (后端工程师) 🍖
- **Workspace**: `F:\openclaw\agent\workspace-jiangrou`
- **Code**: `F:\openclaw\code\backend`
- **Docker 挂载**: `/app/workspace` + `/app/backend`
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
- **Workspace**: `F:\openclaw\agent\workspace-dousha`
- **Code**: `F:\openclaw\code\frontend`
- **Docker 挂载**: `/app/workspace` + `/app/frontend`
- **职责**: Vue 3 开发、TypeScript、UI/UX设计

### 酸菜 (运维工程师) 🥬
- **Workspace**: `F:\openclaw\agent\workspace-suancai`
- **Code**: `F:\openclaw\code\deploy` + `F:\openclaw\code\tests`
- **Docker 挂载**: `/app/workspace` + `/app/deploy` + `/app/tests`
- **职责**: Docker 部署、CI/CD、监控告警、自动化测试

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

### 收件箱路径

| Agent | 收件箱 |
|-------|--------|
| 酱肉 | `F:\openclaw\agent\workspace-jiangrou\communication\inbox\jiangrou\` |
| 豆沙 | `F:\openclaw\agent\workspace-dousha\communication\inbox\dousha\` |
| 酸菜 | `F:\openclaw\agent\workspace-suancai\communication\inbox\suancai\` |

### 消息格式

```json
{
  "from": "guantang",
  "to": "{agent}",
  "action": "{action}",
  "data": {},
  "timestamp": "ISO8601"
}
```

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
