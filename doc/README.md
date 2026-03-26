# 📚 统一知识库文档索引

**最后更新:** 2026-03-26 22:40  
**维护者:** 灌汤 (PM)  
**版本:** v3.0（已整理归档）

---

## 🎯 快速导航

### 按角色查找
| 角色 | 必读文档 | 位置 |
|------|----------|------|
| **全员** | PRD、项目计划 | `01-core/prd/`, `01-core/plan/` |
| **后端** | 技术方案、API 文档 | `01-core/tech/`, `02-specs/03-technical-specs/` |
| **前端** | 原型交互稿、前端设计 | `01-core/design/`, `02-specs/03-technical-specs/frontend-components.md` |
| **运维** | 上线方案、部署指南 | `01-core/deploy/`, `03-guides/02-deployment/` |
| **测试** | 测试用例、PRD | `01-core/test/`, `01-core/prd/` |

### 按功能查找
| 功能 | 文档 | 位置 |
|------|------|------|
| **核心机制** | Pipeline v3/心跳机制/数据库 | `01-core/` |
| **规范文档** | 架构/业务/技术/流程 | `02-specs/` |
| **使用指南** | 新手/部署/Agent 指南 | `03-guides/` |
| **会议记录** | 站会/评审会 | `04-meetings/` |
| **进度跟踪** | 看板/心跳/报告 | `05-progress/` |
| **文档模板** | 任务/PRD/技术方案 | `06-templates/` |
| **日志记录** | 工作日志索引 | `07-logs/` |
| **知识库** | 领域知识/最佳实践 | `08-knowledge/` |
| **归档文档** | 过时/重复/乱码 | `99-archived/` |

---

## 📁 完整文档目录结构

```
F:\openclaw\agent\doc\
│
├── README.md                          # 本文档（索引）
│
├── 00-notifications/                  # 🔔 通知（自动推送）
│
├── 01-core/                           # 📋 核心机制
│   ├── prd/                           # 需求文档
│   ├── tech/                          # 技术方案
│   ├── design/                        # 设计稿
│   ├── test/                          # 测试文档
│   ├── deploy/                        # 部署文档
│   ├── plan/                          # 项目计划
│   ├── database/                      # 数据库 Schema/SQL 脚本
│   │   ├── init-pipeline-db.sql
│   │   ├── sync-plans-to-db.sql
│   │   ├── test-pipeline-data.sql
│   │   └── add-pipeline-unique-constraints.sql
│   ├── agent-pipeline-mechanism-v3.1.md    # Pipeline v3.1 机制
│   ├── agent-heartbeat-mechanism.md        # 心跳机制
│   ├── plan-database-mechanism.md          # 计划数据库机制
│   ├── delivery-standards.md               # 交付标准
│   ├── agent-verification-protocol.md      # Agent 验收协议
│   └── database-schema-management.md       # 数据库 Schema 管理
│
├── 02-specs/                          # 📖 规范文档
│   ├── 01-architecture/               # 架构规范
│   │   └── system-architecture.md
│   ├── 02-business-specs/             # 业务规范
│   │   ├── blog-system-requirements.md
│   │   ├── blog-system-database-design.md
│   │   └── database-design.md
│   ├── 03-technical-specs/            # 技术规范
│   │   ├── agent-error-monitoring.md
│   │   ├── api-design.md
│   │   ├── frontend-components.md
│   │   ├── router-design.md
│   │   ├── auth-api-spec.md
│   │   └── deploy-plan.md
│   └── 04-processes/                  # 流程规范
│       ├── command-specification.md
│       └── logging-audit.md
│
├── 03-guides/                         # 📘 使用指南
│   ├── 01-getting-started/            # 新手指南
│   │   └── phase1-plan.md
│   ├── 02-deployment/                 # 部署指南
│   ├── 03-agent-guides/               # Agent 指南
│   ├── 03-integration/                # 集成指南
│   │   └── frontend-backend-integration.md
│   ├── dousha/                        # 前端指南
│   ├── jiangrou/                      # 后端指南
│   └── suancai/                       # 运维指南
│
├── 04-meetings/                       # 📅 会议记录
│   ├── 2026-03-26-daily-standup.md
│   ├── 2026-03-25-standup-1400.md
│   ├── daily-standup-20260325-0944.md
│   └── ...（历史站会记录）
│
├── 05-progress/                       # 📊 进度跟踪
│   ├── agent-heartbeat-dashboard.md   # 心跳看板（实时）
│   ├── agent-heartbeat-log.md         # 心跳日志
│   ├── project-kanban.md              # 项目看板
│   ├── observation-v3-20260325.md     # v3 观察报告
│   ├── pipeline-v3-final-report.md    # Pipeline v3 最终报告
│   ├── pipeline-v3-implementation-report.md
│   ├── pipeline-v3-migration-complete.md
│   └── pipeline-v3-test-report.md
│
├── 06-templates/                      # 📝 文档模板
│   ├── task-order-template-v3.md      # 任务工单模板 v3 ⭐
│   ├── agent-task-template-v2.md      # Agent 任务模板
│   ├── task-card-template.md          # 任务卡模板
│   └── ...（其他模板）
│
├── 07-logs/                           # 📝 日志记录
│   └── index.md
│
├── 08-knowledge/                      # 🧠 知识库
│   ├── 01-domain/                     # 领域知识
│   └── 02-best-practices/             # 最佳实践
│
└── 99-archived/                       # 🗄️ 归档文档
    ├── doc-reorganization-20260326.md # 本次整理报告
    ├── encoding-issues/               # 乱码文件
    ├── duplicate-guides/              # 重复指南
    ├── duplicate-specs/               # 重复规范
    ├── duplicate-progress/            # 重复进度
    └── obsolete/                      # 过时文档
```

---

## 📖 文档使用指南

### 产品经理 (PM) - 灌汤

**必读文档:**
| 文档 | 位置 | 用途 |
|------|------|------|
| PRD | `01-core/prd/` | 需求管理 |
| 项目计划 | `01-core/plan/` | 进度跟踪 |
| Pipeline 机制 | `01-core/agent-pipeline-mechanism-v3.1.md` | 任务派发 |
| 心跳机制 | `01-core/agent-heartbeat-mechanism.md` | Agent 监控 |
| 项目进度看板 | `05-progress/` | 状态监控 |

---

### 后端工程师 - 酱肉

**必读文档:**
| 文档 | 位置 | 用途 |
|------|------|------|
| PRD | `01-core/prd/` | 理解需求 |
| 技术方案 | `01-core/tech/` | 开发指导 |
| API 设计规范 | `02-specs/03-technical-specs/api-design.md` | API 设计 |
| Auth API 规范 | `02-specs/03-technical-specs/auth-api-spec.md` | 认证接口 |
| 后端指南 | `03-guides/jiangrou/` | 后端规范 |

---

### 前端工程师 - 豆沙

**必读文档:**
| 文档 | 位置 | 用途 |
|------|------|------|
| PRD | `01-core/prd/` | 理解需求 |
| 原型交互稿 | `01-core/design/` | 开发指导 |
| 前端组件规范 | `02-specs/03-technical-specs/frontend-components.md` | 组件设计 |
| 路由设计 | `02-specs/03-technical-specs/router-design.md` | 路由规划 |
| 前后端集成 | `03-guides/03-integration/frontend-backend-integration.md` | 联调指南 |

---

### 运维工程师 - 酸菜

**必读文档:**
| 文档 | 位置 | 用途 |
|------|------|------|
| 上线方案 | `01-core/deploy/` | 部署流程 |
| 部署计划 | `02-specs/03-technical-specs/deploy-plan.md` | 部署规划 |
| 部署指南 | `03-guides/02-deployment/` | 部署操作 |
| 运维指南 | `03-guides/suancai/` | 运维规范 |

---

### 测试工程师

**必读文档:**
| 文档 | 位置 | 用途 |
|------|------|------|
| PRD | `01-core/prd/` | 理解需求 |
| 测试用例 | `01-core/test/` | 测试执行 |
| 技术方案 | `01-core/tech/` | 测试设计 |
| 交付标准 | `01-core/delivery-standards.md` | 验收标准 |

---

## 📊 文档状态

| 文档类型 | 项目数 | 已完成 | 状态 |
|----------|--------|--------|------|
| PRD | 1 | 1 | ✅ |
| 技术方案 | 1 | 1 | ✅ |
| 原型交互稿 | 1 | 1 | ✅ |
| 测试用例 | 1 | 1 | ✅ |
| 上线方案 | 1 | 1 | ✅ |
| 项目计划 | 1 | 1 | ✅ |

**完成度:** 100%（6/6）✅

---

## 📝 文档维护说明

### 文档创建流程
```
1. 复制模板 → 06-templates/
2. 填写内容 → 01-core/对应目录
3. 组织评审 → 通知相关人员
4. 定稿归档 → 更新本文档
```

### 文档更新流程
```
1. 修改文档 → 更新修订历史
2. 通知相关人员 → sessions_spawn
3. 提交 Git → git commit + push
4. 更新索引 → 本文档
```

### 文档归档规则
- **过时文档** → 移至 `99-archived/obsolete/`
- **重复文档** → 移至 `99-archived/duplicate-*/`
- **乱码文件** → 移至 `99-archived/encoding-issues/`
- **会议记录** → 超过 30 天移至 `04-meetings/archive/`

---

## 🔄 整理历史

| 日期 | 操作 | 说明 |
|------|------|------|
| 2026-03-26 | v3.0 整理 | 合并重复目录、归档过时文档、清理乱码文件 |
| 2026-03-12 | v2.0 | 初始结构化整理 |

**本次整理详情:** `99-archived/doc-reorganization-20260326.md`

---

**文档位置:** `F:\openclaw\agent\doc\README.md`  
**维护:** 由 PM 负责维护和更新  
**更新频率:** 每次文档变更后
