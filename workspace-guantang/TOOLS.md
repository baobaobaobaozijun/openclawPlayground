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

### 当前架构：单 Gateway 多 Agent（本地运行）

**架构模式:** 单机多 Agent，通过 Gateway 进程内通信  
**Gateway 端口:** 18789  
**通信方式:** 进程内函数调用（零延迟）

#### Gateway 配置

```json
{
  "gateway": {
    "port": 18789,
    "mode": "local",
    "bind": "loopback"
  },
  "agents": {
    "list": [
      {"id": "guantang", "workspace": "F:\\openclaw\\agent\\workspace-guantang"},
      {"id": "jiangrou", "workspace": "F:\\openclaw\\agent\\workspace-jiangrou"},
      {"id": "dousha", "workspace": "F:\\openclaw\\agent\\workspace-dousha"},
      {"id": "suancai", "workspace": "F:\\openclaw\\agent\\workspace-suancai"}
    ]
  },
  "tools": {
    "agentToAgent": {
      "enabled": true,
      "allow": ["guantang", "jiangrou", "dousha", "suancai"]
    }
  }
}
```

**配置文件位置:** `C:\Users\Administrator\.openclaw\openclaw.json`

#### 通信特点

✅ **零延迟**: 进程内内存调用，~2ms  
✅ **高可靠**: 无网络依赖，稳定性 99.9%+  
✅ **简配置**: 无需 Docker、网络、端口映射  
✅ **易维护**: 单个进程，日志集中

---

### 📚 统一知识库

**知识库路径:** `F:\openclaw\agent\doc`

**知识库索引:** [../doc/README.md](../doc/README.md)

**常用文档:**
- [系统架构](../doc/specs/01-architecture/system-architecture.md)
- [错误监控](../doc/specs/03-technical-specs/agent-error-monitoring.md)
- [博客系统需求](../doc/specs/02-business-specs/blog-system-requirements.md)

**管理职责:**
- ✅ 维护知识库整体结构
- ✅ 审核新增文档
- ✅ 定期检查文档完整性
- ✅ 通知 Agent 文档更新

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

*最后更新：2026-03-11 - 清理 Docker 通信协议，切换到本地单 Gateway 多 Agent 模式*
