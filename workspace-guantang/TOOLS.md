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

### 📋 计划文档管理体系

**计划文档路径:** `F:\openclaw\agent\tasks\`

**目录结构:**
```
tasks/
├── 00-master/
│   ├── master-plan-overview.md    # 总览文档（所有计划状态）
│   └── plan-template.md           # 计划模板
├── 01-plans/
│   ├── plan-001-p0-阻塞修复/
│   │   ├── 00-plan.md             # 计划详情
│   │   ├── 01-round-orders.md     # 轮次工单记录
│   │   ├── 02-verify-list.md      # PM 验收清单
│   │   ├── 03-review.md           # 复盘报告
│   │   └── 04-feishu-logs.md      # 飞书通知记录
│   ├── plan-002-p1-文章管理/
│   └── ...
├── 02-archives/
│   └── 2026-03/                   # 已完成的计划归档
└── 99-logs/
    └── plan-execution-log.md      # 计划执行日志
```

**文档命名规范:**
- 计划文件夹：`plan-{3 位编号}-{优先级}-{计划名称简写}\`
- 计划内文档：`{2 位序号}-{文档名称}.md`

---

### 🛠️ Plan Manager Skill

**Skill 路径:** `skills/plan-manager/`

**用途:** 创建、更新、完成计划，统一管理灌汤的多轮计划体系

**命令列表:**
| 命令 | 用途 | 示例 |
|------|------|------|
| `创建计划` | 创建新计划 | `npx plan-manager 创建计划 --编号 "006" --名称 "用户中心"` |
| `更新进度` | 更新轮次进度 | `npx plan-manager 更新进度 --计划编号 "006" --轮次 1 --状态 "completed"` |
| `完成计划` | 完成计划 + 复盘 + 通知 | `npx plan-manager 完成计划 --计划编号 "006" --状态 "success"` |
| `列出计划` | 查看所有计划 | `npx plan-manager 列出计划` |
| `查看计划` | 查看单个计划详情 | `npx plan-manager 查看计划 --计划编号 "006"` |

**使用场景:**
1. 收到新需求 → `创建计划`
2. 轮次完成 → `更新进度`
3. 计划完成 → `完成计划`
4. 查看进度 → `列出计划` 或 `查看计划`

**详细文档:** `skills/plan-manager/SKILL.md`  
**使用示例:** `skills/plan-manager/examples/usage-examples.md`

---

**PM 职责:**
- ✅ 创建计划文档（使用 plan-manager skill）
- ✅ 每轮更新进度（00-plan.md + 01-round-orders.md）
- ✅ 计划完成后验收（02-verify-list.md）
- ✅ 计划完成后复盘（03-review.md）
- ✅ 发送飞书通知并记录（04-feishu-logs.md）
- ✅ 更新总览文档（master-plan-overview.md）
- ✅ Git 提交并推送

**更新时机:**
- 轮次完成后 → 更新 01-round-orders.md + 00-plan.md
- 计划完成后 → 更新 02-verify-list.md + 03-review.md
- 飞书通知后 → 更新 04-feishu-logs.md
- 每日 18:00 → 更新 master-plan-overview.md（总进度）

---

## 🔧 常用命令

### PM 工具脚本（解决 PowerShell $_ 转义问题）

```bash
# 查看今日全员工作日志
powershell -ExecutionPolicy Bypass -File "F:\openclaw\agent\workspace-guantang\_tools.ps1" worklogs all

# 查看某个 agent 最近 3 条日志
powershell -ExecutionPolicy Bypass -File "F:\openclaw\agent\workspace-guantang\_tools.ps1" latest jiangrou 3

# 验证文件存在 + 包含关键词
powershell -ExecutionPolicy Bypass -File "F:\openclaw\agent\workspace-guantang\_tools.ps1" verify "文件路径" "关键词1,关键词2"

# 检查所有仓库 git 状态
powershell -ExecutionPolicy Bypass -File "F:\openclaw\agent\workspace-guantang\_tools.ps1" gitstatus
```

### ⚠️ PowerShell 注意事项

**禁止在 exec 命令中直接使用 `$_`、`$_.Name` 等变量**——会被吞掉导致错误。
所有含 `$_` 的逻辑一律写入 .ps1 脚本文件再执行。

### 其他

```bash
# GitHub 认证
gh auth login

# 手动推送
cd F:\openclaw\agent && git add . && git commit -m "message" && git push
```

---

*最后更新：2026-03-11 - 清理 Docker 通信协议，切换到本地单 Gateway 多 Agent 模式*
