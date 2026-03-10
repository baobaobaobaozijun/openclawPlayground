# Specs 文档索引

**最后更新:** 2026-03-10  
**维护者:** 灌汤 (PM)

---

## 📂 文档目录

```
specs/
├── README.md                          # 本文档 (索引)
├── 01-project-management/             # 项目管理规范
│   ├── system-architecture.md         # 系统架构
│   ├── command-specification.md       # 命令规范
│   └── logging-audit.md               # 日志和审计
├── 02-blog-system/                    # 博客系统专项
│   ├── blog-system-requirements.md    # 需求文档 v2.0
│   ├── blog-system-database-design.md # 数据库设计 v1.0
│   └── archive/                       # 归档文档
│       └── blog-integration.md        # 旧版集成方案 (已废弃)
└── 03-technical-specs/                # 技术规范
    ├── agent-protocol.md              # Agent 通信协议
    └── lightweight-mode.md            # 低配服务器运行指南
```

---

## 📋 文档清单

### 01-项目管理规范 📋

| 文档 | 说明 | 版本 | 状态 |
|------|------|------|------|
| [system-architecture.md](./01-project-management/system-architecture.md) | 系统架构概览 (Agent 分工 + 数据流) | 1.0 | ✅ 有效 |
| [command-specification.md](./01-project-management/command-specification.md) | 命令规范 (项目/任务/日志管理命令) | 1.0 | ✅ 有效 |
| [logging-audit.md](./01-project-management/logging-audit.md) | 日志和审计系统 (工作日志 + 轮转策略) | 1.0 | ✅ 有效 |

---

### 02-博客系统专项 📝

| 文档 | 说明 | 版本 | 状态 |
|------|------|------|------|
| [blog-system-requirements.md](./02-blog-system/blog-system-requirements.md) | 博客系统需求文档 (含权限设计/技术选型/时间规划) | 2.0 | ✅ 有效 (最新) |
| [blog-system-database-design.md](./02-blog-system/blog-system-database-design.md) | 博客系统数据库设计 (6 张表 + 视图 + 索引) | 1.0 | ✅ 有效 (最新) |
| ~~blog-integration.md~~ | 旧版博客集成方案 (Python+Flask) | 1.0 | ❌ 已废弃 (归档) |

---

### 03-技术规范 🔧

| 文档 | 说明 | 版本 | 状态 |
|------|------|------|------|
| [agent-protocol.md](./03-technical-specs/agent-protocol.md) | Agent-to-Agent 通信协议 (轻量版 RPC) | 1.0 | ✅ 有效 |
| [lightweight-mode.md](./03-technical-specs/lightweight-mode.md) | 低配服务器运行指南 (2GB 内存优化) | 1.0 | ✅ 有效 |

---

## 🎯 快速查找

### 按场景查找

| 场景 | 推荐文档 |
|------|----------|
| 了解系统整体架构 | `01-project-management/system-architecture.md` |
| 查看博客需求 | `02-blog-system/blog-system-requirements.md` |
| 查看数据库设计 | `02-blog-system/blog-system-database-design.md` |
| Agent 通信规范 | `03-technical-specs/agent-protocol.md` |
| 低配服务器部署 | `03-technical-specs/lightweight-mode.md` |
| 任务管理命令 | `01-project-management/command-specification.md` |
| 日志规范 | `01-project-management/logging-audit.md` |

---

### 按角色查找

| 角色 | 必读文档 |
|------|----------|
| **灌汤 (PM)** | 全部文档 |
| **酱肉 (后端)** | `blog-system-requirements.md` + `blog-system-database-design.md` + `agent-protocol.md` |
| **豆沙 (前端)** | `blog-system-requirements.md` + `system-architecture.md` |
| **酸菜 (运维)** | `lightweight-mode.md` + `logging-audit.md` + `blog-system-database-design.md` |

---

## 📝 变更历史

| 日期 | 变更内容 | 变更人 |
|------|----------|--------|
| 2026-03-10 | 创建文档索引，完成文档归类 | 灌汤 |
| 2026-03-10 | 创建博客系统需求文档 v2.0 | 灌汤 |
| 2026-03-10 | 创建博客系统数据库设计 v1.0 | 灌汤 |

---

## 🔗 相关链接

- [项目代码目录](../../code/)
- [Agent 工作区](../)
- [GitHub 仓库](https://github.com/baobaobaobaozijun/openclawPlayground)

---

**文档维护规范:**
- 新增文档时更新本文档
- 废弃文档移动到 `archive/` 并标记状态
- 版本号格式：`v 主版本。次版本.修订号`
