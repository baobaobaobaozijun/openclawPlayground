<!-- Last Modified: 2026-03-11 -->
<!-- Last Modified (CN): 2026-03-11 -->

# 包子铺项目架构总览

🏭 **基于 OpenClaw 框架的 Agent 团队协作与工程架构**

*最后更新：2026-03-11*

---

## 📋 命名规范 ⭐⭐⭐【重要】

### 项目名称 vs 技术框架

**🥟 包子铺 (Baozipu)** - **项目名称**
- 这是一个包子铺业务系统
- 包括：用户管理、文章管理、订单系统等
- 是我们的**业务目标**

**🔧 OpenClaw** - **技术框架名称**
- 这是 Agent 协作技术框架
- 包括：多 Agent 通信、任务分发、进度跟踪等
- 是我们的**技术工具**

**关系:** 包子铺项目 **使用** OpenClaw 框架来构建

**示例:**
```markdown
✅ "包子铺需要开发用户认证功能"
✅ "使用 OpenClaw 框架构建包子铺项目"
✅ "OpenClaw Agent 间的通信协议"
❌ "OpenClaw 需要开发用户认证功能" (混淆)
```

**详细文档:** [docs/naming-convention.md](./docs/naming-convention.md)

---

## 📝 项目概述

**包子铺**是一个基于 **OpenClaw 框架**的多Agent协作软件开发平台，采用**配置与代码分离、工作台独立、本地化运行**的现代化架构设计。

本项目使用单个 OpenClaw Gateway 进程运行多个 Agent 实例，每个 Agent 拥有独立的工作空间，通过进程内通信实现高效协作。

---

## 🏛️ 整体架构

### 核心目录结构

```
f:\openclaw/
│
├── doc/                          # 📚 统一知识库 ⭐【新增】
│   ├── README.md                # 知识库索引和导航
│   ├── specs/                   # 规范文档
│   ├── guides/                  # 使用指南
│   └── knowledge/               # 领域知识和最佳实践
│
├── agent/                        # 🧠 Agent 配置与工作区
│   ├── ARCHITECTURE.md            # 本文件 - 项目架构说明
│   │
│   ├── workspace-guantang/        # 📋 PM/项目经理工作台
│   │   ├── .openclaw/             # 工作区状态配置
│   │   ├── IDENTITY.md           # 【核心】灌汤身份认知
│   │   ├── ROLE.md               # 【核心】灌汤职责规范
│   │   ├── SOUL.md               # 【核心】灌汤行为准则
│   │   ├── MEMORY.md             # 【新增】PM 飞行记录仪式操作日志 ⭐
│   │   ├── AGENTS.md             # 团队协作规范
│   │   ├── BOOTSTRAP.md           # 启动指南
│   │   ├── HEARTBEAT.md           # 心跳机制
│   │   ├── TOOLS.md               # 工具使用
│   │   ├── USER.md                # 用户信息
│   │   ├── README.md              # 工作台说明
│   │   │
│   │   ├── agent-configs/         # 各 Agent 技术规范备份（参考文档）
│   │   │   ├── jiangrou/         # 酱肉技术栈详情
│   │   │   │   ├── IDENTITY.md
│   │   │   │   ├── ROLE.md
│   │   │   │   ├── SOUL.md
│   │   │   │   └── README.md     # 完整技术文档
│   │   │   ├── dousha/           # 豆沙技术规范
│   │   │   │   ├── IDENTITY.md
│   │   │   │   ├── ROLE.md
│   │   │   │   ├── SOUL.md
│   │   │   │   └── README.md     # 完整技术文档
│   │   │   └── suancai/          # 酸菜运维实践
│   │   │       ├── IDENTITY.md
│   │   │       ├── ROLE.md
│   │   │       ├── SOUL.md
│   │   │       └── README.md     # 完整技术文档
│   │   │
│   │   ├── config-samples/       # 配置示例备份
│   │   ├── guides/               # 使用指南
│   │   │   ├── simple-monitoring-guide.md    # 【新增】简化版监控指南 ⭐
│   │   ├── specs/                # 规范文档
│   │   │   ├── 03-technical-specs/
│   │   │   │   └── agent-error-monitoring.md           # 【新增】错误监控与故障处理 ⭐
│   │   │   └── ...
│   │   ├── monitoring/             # 【新增】监控系统 ⭐
│   │   │   └── dashboard.md      # 实时监控仪表板
│   │   ├── scripts/                # 【新增】自动化脚本 ⭐
│   │   │   └── simple-monitor.ps1  # 简化版监控脚本 (每 5 分钟检查)
│   │   ├── disasters/              # 【新增】灾难现场保护 ⭐
│   │   │   ├── monitor-log.txt     # 监控日志
│   │   │   └── disaster-*/         # 灾难现场目录
│   │   └── logs/                   # 工作日志归档
│   │
│   ├── workspace-jiangrou/        # 🥩 酱肉工作台 ⭐
│   │   ├── IDENTITY.md          # 【核心】身份认知
│   │   ├── ROLE.md              # 【核心】职责规范
│   │   ├── SOUL.md              # 【核心】行为准则
│   │   ├── MEMORY.md            # 【新增】飞行记录仪式操作日志 ⭐
│   │   ├── README.md            # 工作台说明
│   │   ├── .gitignore            # Git 忽略配置
│   │   ├── tasks/                # 任务管理
│   │   │   ├── inbox/
│   │   │   └── outbox/
│   │   └── logs/                 # 工作日志
│   │
│   ├── workspace-dousha/          # 🍡 豆沙工作台 ⭐
│   │   ├── IDENTITY.md         # 【核心】身份认知
│   │   ├── ROLE.md             # 【核心】职责规范
│   │   ├── SOUL.md             # 【核心】行为准则
│   │   ├── MEMORY.md           # 【新增】飞行记录仪式操作日志 ⭐
│   │   ├── README.md           # 工作台说明
│   │   ├── .gitignore            # Git 忽略配置
│   │   ├── tasks/                # 任务管理
│   │   │   ├── inbox/
│   │   │   └── outbox/
│   │   ├── designs/              # 设计资源
│   │   └── logs/                 # 工作日志
│   │
│   ├── workspace-suancai/         # 🥬 酸菜工作台 ⭐
│   │   ├── IDENTITY.md         # 【核心】身份认知
│   │   ├── ROLE.md             # 【核心】职责规范
│   │   ├── SOUL.md             # 【核心】行为准则
│   │   ├── MEMORY.md           # 【新增】飞行记录仪式操作日志 ⭐
│   │   ├── README.md           # 工作台说明
│   │   ├── .gitignore            # Git 忽略配置
│   │   ├── tasks/                # 任务管理
│   │   │   ├── inbox/
│   │   │   └── outbox/
│   │   └── logs/                 # 工作日志
│   │
│   └── migration/                 # 🔄 迁移文档（历史参考）
│       ├── openclaw-integrated-single-gateway.json   # 单 Gateway 配置模板
│       └── MIGRATION-GUIDE-to-single-gateway.md      # 迁移指南
│
├── code/                           # 💻 实际工程项目
│   ├── backend/                   # 后端工程（Java + Spring Boot）
│   │   ├── src/                   # 源代码
│   │   │   └── main/
│   │   │       ├── java/         # Java 代码
│   │   │       └── resources/    # 配置文件
│   │   ├── pom.xml               # Maven 配置
│   │   ├── scripts/              # 脚本工具
│   │   └── README.md             # 工程说明
│   │
│   ├── frontend/                  # 前端工程（Vue + TypeScript）
│   │   ├── src/                   # 源代码
│   │   │   ├── components/       # 组件
│   │   │   ├── views/            # 视图
│   │   │   ├── composables/      # 组合式函数
│   │   │   ├── stores/           # 状态管理
│   │   │   ├── router/           # 路由
│   │   │   ├── api/              # API 接口
│   │   │   └── assets/           # 资源
│   │   ├── public/               # 公共文件
│   │   ├── package.json          # NPM 配置
│   │   ├── vite.config.ts        # Vite 配置
│   │   ├── tsconfig.json         # TypeScript 配置
│   │   └── README.md             # 工程说明
│   │
│   ├── deploy/                    # 部署脚本
│   │   ├── ops-infra/            # 运维基础设施
│   │   ├── kubernetes/           # K8s 配置（可选）
│   │   ├── scripts/              # 部署脚本
│   │   ├── environments/         # 环境配置
│   │   └── README.md             # 部署说明
│   │
│   └── tests/                     # 测试脚本
│       ├── unit/                 # 单元测试
│       ├── integration/          # 集成测试
│       ├── performance/          # 性能测试
│       ├── e2e/                  # E2E 测试
│       ├── scripts/              # 测试脚本
│       └── README.md             # 测试说明
│
└── .lingma/                        # Lingma IDE 配置
    ├── agents/                    # Agent 配置
    └── skills/                    # 技能配置
```

---

## 👥 Agent 角色与职责

### 🍲 灌汤 (Guantang) - PM/项目经理

**工作空间:** `agent/workspace-guantang/`  


**核心职责**:
- 产品规划与需求分析
- 项目进度管理
- 团队协调与决策
- 质量把控与验收
- 管理所有 Agent 的配置文档
- **监控与故障处理** ⭐ 【新增】
  - 每 5 分钟检查所有 Agent 状态
  - 自动保存灾难现场
  - 零成本本地告警 (无短信/邮件)

**管理内容**:
- `agent-configs/` - 各 Agent 的技术规范备份（参考文档）
- `guides/` - 使用指南和教程
- `specs/` - 系统规范和架构文档
- `monitoring/` - 【新增】监控仪表板
- `scripts/` - 【新增】自动化监控脚本
- `disasters/` - 【新增】灾难现场保护
- `logs/` - 团队工作日志归档

**核心配置文件:**
- [IDENTITY.md](./workspace-guantang/IDENTITY.md) - 身份认知
- [ROLE.md](./workspace-guantang/ROLE.md) - 职责规范
- [SOUL.md](./workspace-guantang/SOUL.md) - 行为准则
- [AGENTS.md](./workspace-guantang/AGENTS.md) - 团队协作规范
- [BOOTSTRAP.md](./workspace-guantang/BOOTSTRAP.md) - 启动指南

---

### 🥩 酱肉 (Jiangrou) - 后端工程师

**工作空间:** `agent/workspace-jiangrou/`  
**GitHub 仓库:** https://github.com/baobaobaobaozijun/openclaw-backend  
**代码工程:** `code/backend/`

**核心配置文件:** ⭐ **启动必备**
- [IDENTITY.md](./workspace-jiangrou/IDENTITY.md) - 身份认知
- [ROLE.md](./workspace-jiangrou/ROLE.md) - 职责规范
- [SOUL.md](./workspace-jiangrou/SOUL.md) - 行为准则

**核心职责:**
- 技术架构设计
- 后端 API 开发
- 数据库设计
- 性能优化

**技术栈:**
- **语言:** Java 21 (LTS)
- **框架:** Spring Boot 3.2+
- **数据库:** MySQL 8.0+
- **构建:** Maven 3.9+

**工作流程:**
1. 在 `workspace-jiangrou/tasks/inbox/` 接收任务
2. 通过 Gateway 进程内通信或直接交流
3. 在 `code/backend/` 中编写代码
4. 提交到独立的代码仓库

**详细技术文档:** [agent/workspace-guantang/agent-configs/jiangrou/README.md](./workspace-guantang/agent-configs/jiangrou/README.md)

---

### 🍡 豆沙 (Dousha) - 前端工程师/UIUX设计师

**工作空间:** `agent/workspace-dousha/`  
**GitHub 仓库:** https://github.com/baobaobaobaozijun/openclaw-frontend  
**代码工程:** `code/frontend/`

**核心配置文件:** ⭐ **启动必备**
- [IDENTITY.md](./workspace-dousha/IDENTITY.md) - 身份认知
- [ROLE.md](./workspace-dousha/ROLE.md) - 职责规范
- [SOUL.md](./workspace-dousha/SOUL.md) - 行为准则

**核心职责:**
- UI/UX设计
- 前端页面开发
- 响应式适配
- 性能优化

**技术栈:**
- **框架:** Vue 3.4+ (Composition API)
- **语言:** TypeScript 5.x
- **构建:** Vite 5.x
- **UI:** Element Plus
- **样式:** Tailwind CSS

**工作流程:**
1. 在 `workspace-dousha/tasks/inbox/` 接收任务
2. 查看 `workspace-dousha/designs/` 设计稿
3. 通过 Gateway 进程内通信或直接交流
4. 在 `code/frontend/` 中实现界面

**详细技术文档:** [agent/workspace-guantang/agent-configs/dousha/README.md](./workspace-guantang/agent-configs/dousha/README.md)

---

### 🥬 酸菜 (Suancai) - 运维/测试工程师

**工作空间:** `agent/workspace-suancai/`  
**GitHub 仓库:** https://github.com/baobaobaobaozijun/openclaw-devops  
**工作目录:** `code/deploy/`, `code/tests/`

**核心配置文件:** ⭐ **启动必备**
- [IDENTITY.md](./workspace-suancai/IDENTITY.md) - 身份认知
- [ROLE.md](./workspace-suancai/ROLE.md) - 职责规范
- [SOUL.md](./workspace-suancai/SOUL.md) - 行为准则

**核心职责:**
- 系统部署与容器化
- CI/CD流程建设
- 监控告警配置
- 自动化测试
- 日志管理

**技术栈:**
- **CI/CD:** GitHub Actions
- **监控:** Prometheus + Grafana（或简化版 PowerShell 脚本）
- **测试:** JUnit 5, Testcontainers, Gatling
- **日志:** ELK Stack（或统一日志文件）

**工作流程:**
1. 在 `workspace-suancai/tasks/inbox/` 接收任务
2. 配置测试环境
3. 在 `code/deploy/`、`code/tests/` 中编写脚本
4. 执行测试并生成报告

**详细技术文档:** [agent/workspace-guantang/agent-configs/suancai/README.md](./workspace-guantang/agent-configs/suancai/README.md)

---

### 🔧 程序员 (Programmer) - 预留角色

**工作空间:** `agent/workspace-programmer/`

这是一个预留的工作空间，目前包含基础的模板文件：
- [IDENTITY.md](./workspace-programmer/IDENTITY.md) - 身份认知模板
- [AGENTS.md](./workspace-programmer/AGENTS.md) - 团队协作
- [BOOTSTRAP.md](./workspace-programmer/BOOTSTRAP.md) - 启动指南
- [HEARTBEAT.md](./workspace-programmer/HEARTBEAT.md) - 心跳机制

可以根据需要扩展为特定角色的工作台。

---
---

## 🔄 工作流程

### 1. 需求分发阶段

```
灌汤 (PM)
  ↓
创建任务文件 → agent/workspace-{agent}/tasks/inbox/TASK-XXX.md
  ↓
指定优先级和截止时间
```

### 2. 任务执行阶段

```
Agent 接收任务
  ↓
阅读任务文件，理解需求
  ↓
- 需要沟通？
  ├─ 是 → 通过 Gateway 进程内通信或直接交流
  └─ 否 → 开始工作
        ↓
        切换到 code/{backend|frontend|deploy|tests}
        ↓
        开发/实施
        ↓
        提交代码到独立仓库
        ↓
        更新任务状态：inbox → outbox → completed
```

### 3. 协作沟通机制

**沟通场景:**
- **需求不明确** → 联系灌汤（PM）
- **API 接口变更** → 后端 ↔ 前端沟通
- **部署配置问题** → 开发 ↔ 运维沟通

**沟通方式:**
- 通过 Gateway 的 `agentToAgent` 机制实时通信
- 直接在代码目录中协作开发
- 重大问题记录到工作日志 (`workspace-*/logs/`) 作为团队知识库永久保存

### 4. 完成验收阶段

```
任务完成
  ↓
通知灌汤验收
  ↓
灌汤检查 code/ 目录的代码
  ↓
通过 → 合并到主分支，标记为已完成
  ↓
不通过 → 返回修改
```

---

---

## 🎯 核心设计理念

### 配置与工作区分离

#### 1. Agent 工作区 (`agent/workspace-xxx/`)
- **用途:** Agent 的独立工作空间，包含身份认知、职责规范、行为准则
- **位置:** `agent/` 目录下的独立子目录
- **重要性:** 🔴 **核心中的核心，决定 Agent 能否正常启动和工作**
- **特点:** 
  - 每个 Agent 有自己的 inbox/outbox 任务管理系统
  - **包含完整独立的技术文档 (TECHNICAL-DOCS.md)**
  - 本地运行，通过 Gateway 进程内通信

#### 2. 技术规范中心 (`agent/workspace-guantang/agent-configs/`) - 可选参考
- **用途:** 详细的技术栈说明、最佳实践、常见问题（历史文档，仅供参考）
- **位置:** 灌汤工作区的子目录
- **重要性:** 🟡 重要参考资料（但各 Agent 已有独立技术文档）
- **特点:** 详尽完整，作为技术指导和知识库
- **注意:** ⚠️ **各 Agent 优先使用各自工作区的 TECHNICAL-DOCS.md**

#### 3. 工程项目 (`code/`)
- **用途:** 实际的工程项目和代码产出
- **特点:** 可编译、可运行、可部署
- **共享性:** 所有 Agent 共享同一个 code 目录，但各自负责不同子目录

#### 4. 迁移历史 (`agent/migration/`)
- **用途:** 保存从 Docker 迁移到本地的历史文档
- **特点:** 记录架构演进过程
- **参考文件:** [MIGRATION-GUIDE-to-single-gateway.md](./migration/MIGRATION-GUIDE-to-single-gateway.md)

### 为什么要这样设计？

1. **工作区独立** - 每个 Agent 有自己的 inbox/outbox 任务管理系统
2. **技术规范集中管理** - 避免重复，便于统一更新和维护
3. **工程代码共享** - code 目录为所有 Agent 共享，便于协作
4. **本地化运行** - 单 Gateway 多 Agent 模式，高效简洁

---

## 🚀 本地化运行模式

### 当前架构

**运行方式:** 单个 OpenClaw Gateway 进程（端口 18789）  
**Agent 数量:** 4 个（灌汤、酱肉、豆沙、酸菜）  
**通信方式:** 进程内内存调用（~2ms 延迟）  
**资源占用:** ~600MB 内存

### 配置文件

**位置:** `C:\Users\Administrator\.openclaw\openclaw.json`

```json
{
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

### 启动方式

```powershell
# 直接启动 OpenClaw Gateway
openclaw gateway

# 或通过 PM2 等工具管理
pm2 start openclaw --name "baozipu"
``
---

## 💻 技术栈总览

### 后端技术栈（酱肉负责）

| 组件 | 技术 | 版本 | 用途 |
|------|------|------|------|
| **语言** | Java | 21 (LTS) | 主要编程语言 |
| **框架** | Spring Boot | 3.2+ | Web 应用框架 |
| **安全** | Spring Security | 6.x | 认证授权 |
| **ORM** | Hibernate / MyBatis-Plus | 6.x / 3.5+ | 对象关系映射 |
| **数据库** | MySQL | 8.0+ | 主数据库 |
| **构建** | Maven | 3.9+ | 项目构建和管理 |

### 前端技术栈（豆沙负责）

| 组件 | 技术 | 版本 | 用途 |
|------|------|------|------|
| **框架** | Vue.js | 3.4+ | 前端框架 (Composition API) |
| **语言** | TypeScript | 5.x | 类型安全 |
| **构建** | Vite | 5.x | 快速构建工具 |
| **状态** | Pinia | 2.x | 状态管理 |
| **路由** | Vue Router | 4.x | 路由管理 |
| **UI** | Element Plus | 2.x | UI 组件库 |
| **样式** | Tailwind CSS | 3.x | 原子化 CSS 框架 |

### 运维/测试技术栈（酸菜负责）

| 组件 | 技术 | 用途 |
|------|------|------|
| **单元测试** | JUnit 5 + Mockito | Java 单元测试 |
| **集成测试** | Testcontainers | 容器化集成测试 |
| **性能测试** | Gatling / JMeter | 负载和压力测试 |
| **E2E 测试** | Playwright | 端到端浏览器自动化 |
| **日志** | ELK Stack | 日志收集和分析 |

---

## 📖 文档索引

### ⭐ 核心配置文件（启动必备）

**酱肉工作台:**
- [IDENTITY.md](./workspace-jiangrou/IDENTITY.md) - 我是谁
- [ROLE.md](./workspace-jiangrou/ROLE.md) - 我做什么
- [SOUL.md](./workspace-jiangrou/SOUL.md) - 我如何工作
- [MEMORY.md](./workspace-jiangrou/MEMORY.md) - 【新增】飞行记录仪式操作日志 ⭐
- [TECHNICAL-DOCS.md](./workspace-jiangrou/TECHNICAL-DOCS.md) - 完整技术文档 ⭐

**豆沙工作台:**
- [IDENTITY.md](./workspace-dousha/IDENTITY.md) - 我是谁
- [ROLE.md](./workspace-dousha/ROLE.md) - 我做什么
- [SOUL.md](./workspace-dousha/SOUL.md) - 我如何工作
- [MEMORY.md](./workspace-dousha/MEMORY.md) - 【新增】飞行记录仪式操作日志 ⭐
- [TECHNICAL-DOCS.md](./workspace-dousha/TECHNICAL-DOCS.md) - 完整技术文档 ⭐

**酸菜工作台:**
- [IDENTITY.md](./workspace-suancai/IDENTITY.md) - 我是谁
- [ROLE.md](./workspace-suancai/ROLE.md) - 我做什么
- [SOUL.md](./workspace-suancai/SOUL.md) - 我如何工作
- [MEMORY.md](./workspace-suancai/MEMORY.md) - 【新增】飞行记录仪式操作日志 ⭐
- [TECHNICAL-DOCS.md](./workspace-suancai/TECHNICAL-DOCS.md) - 完整技术文档 ⭐

### 配置文档中心

**核心文档**:
- [灌汤身份认知](./workspace-guantang/IDENTITY.md)
- [灌汤行为准则](./workspace-guantang/SOUL.md)
- [团队协作规范](./workspace-guantang/AGENTS.md)
- [启动指南](./workspace-guantang/BOOTSTRAP.md)

**【新增】监控与故障处理**:
- [错误监控与故障处理机制](./workspace-guantang/specs/03-technical-specs/agent-error-monitoring.md) ⭐
- [实时监控仪表板](./workspace-guantang/monitoring/dashboard.md) ⭐
- [监控脚本](./workspace-guantang/scripts/simple-monitor.ps1) ⭐

**技术规范**（参考资料）
- [酱肉技术规范](./workspace-guantang/agent-configs/jiangrou/README.md)
- [豆沙技术规范](./workspace-guantang/agent-configs/dousha/README.md)
- [酸菜技术规范](./workspace-guantang/agent-configs/suancai/README.md)

**使用指南:**
- [本地化运行模式](#-本地化运行模式)
- [GitHub 上传指南](./workspace-guantang/guides/github-upload-guide.md)

**规范文档:**
- [Agent 协议](./workspace-guantang/specs/agent-protocol.md)
- [系统架构](./workspace-guantang/specs/system-architecture.md)
- [日志审计](./workspace-guantang/specs/logging-audit.md)

### 工作台文档

**酱肉工作台:**
- [工作台说明](./workspace-jiangrou/README.md)
- 任务目录：`workspace-jiangrou/tasks/inbox/`, `workspace-jiangrou/tasks/outbox/`
- 沟通方式：Gateway 进程内通信 / 工作日志记录
- 工作日志：`workspace-jiangrou/logs/`
- 代码工作区：`code/backend/`

**豆沙工作台:**
- [工作台说明](./workspace-dousha/README.md)
- 任务目录：`workspace-dousha/tasks/inbox/`, `workspace-dousha/tasks/outbox/`
- 设计资源：`workspace-dousha/designs/`
- 沟通方式：Gateway 进程内通信 / 工作日志记录
- 工作日志：`workspace-dousha/logs/`
- 代码工作区：`code/frontend/`

**酸菜工作台:**
- [工作台说明](./workspace-suancai/README.md)
- 任务目录：`workspace-suancai/tasks/inbox/`, `workspace-suancai/tasks/outbox/`
- 测试工作区：`code/tests/`
- 部署脚本：`code/deploy/`
- 沟通方式：Gateway 进程内通信 / 工作日志记录
- 工作日志：`workspace-suancai/logs/`

### 工程文档

**后端工程:**
- [工程说明](../../code/backend/README.md)
- 源代码：`code/backend/src/`
- 构建配置：`code/backend/pom.xml`

**前端工程:**
- [工程说明](../../code/frontend/README.md)
- 源代码：`code/frontend/src/`
- 构建配置：`code/frontend/package.json`

**部署脚本:**
- [部署说明](../../code/deploy/README.md)
- 运维基础设施：`code/deploy/ops-infra/`
- 部署脚本：`code/deploy/scripts/`

**测试脚本:**
- [测试说明](../../code/tests/README.md)
- 单元测试：`code/tests/unit/`
- 集成测试：`code/tests/integration/`
- 性能测试：`code/tests/performance/`

---

## 🎯 快速导航

### 我是灌汤 (PM)
→ 去 [`agent/workspace-guantang/`](./workspace-guantang/README.md) 管理团队和分配任务  
→ 阅读 [AGENTS.md](./workspace-guantang/AGENTS.md) 了解团队协作规范

### 我是酱肉 (后端) ⭐
1. **首先阅读** [IDENTITY.md](./workspace-jiangrou/IDENTITY.md) 认识自己
2. **然后阅读** [ROLE.md](./workspace-jiangrou/ROLE.md) 明确职责
3. **最后阅读** [SOUL.md](./workspace-jiangrou/SOUL.md) 了解行为准则
4. 去 [`agent/workspace-jiangrou/README.md`](./workspace-jiangrou/README.md) 了解工作流程
5. 去 [`code/backend/`](../../code/backend/README.md) 编写代码
6. 查看 [技术规范](./workspace-guantang/agent-configs/jiangrou/README.md) 了解技术栈详情

### 我是豆沙 (前端) ⭐
1. **首先阅读** [IDENTITY.md](./workspace-dousha/IDENTITY.md) 认识自己
2. **然后阅读** [ROLE.md](./workspace-dousha/ROLE.md) 明确职责
3. **最后阅读** [SOUL.md](./workspace-dousha/SOUL.md) 了解行为准则
4. 去 [`agent/workspace-dousha/README.md`](./workspace-dousha/README.md) 了解工作流程
5. 去 [`code/frontend/`](../../code/frontend/README.md) 编写代码
6. 查看 [设计规范](./workspace-guantang/agent-configs/dousha/README.md) 了解 UI 规范

### 我是酸菜 (运维/测试) ⭐
1. **首先阅读** [IDENTITY.md](./workspace-suancai/IDENTITY.md) 认识自己
2. **然后阅读** [ROLE.md](./workspace-suancai/ROLE.md) 明确职责
3. **最后阅读** [SOUL.md](./workspace-suancai/SOUL.md) 了解行为准则
4. 去 [`agent/workspace-suancai/README.md`](./workspace-suancai/README.md) 了解工作流程
5. 去 [`code/deploy/`](../../code/deploy/README.md) 或 [`code/tests/`](../../code/tests/README.md) 工作
6. 查看 [DevOps 实践](./workspace-guantang/agent-configs/suancai/README.md) 了解部署规范

---

## 🚀 本地化运行流程

### 启动 Gateway

```powershell
# 直接启动 OpenClaw Gateway
openclaw gateway

# 或通过 PM2 管理进程
pm2 start openclaw --name "baozipu"

# 查看运行状态
pm2 status

# 查看日志
pm2 logs baozipu

# 停止服务
pm2 stop baozipu
```

**访问地址:** http://localhost:18789

---

## 📊 项目统计

### 目录结构统计

| 类别 | 目录数 | 说明 |
|------|--------|------|
| **Agent 工作区** | 5 | agent/workspace-guantang, workspace-jiangrou, workspace-dousha, workspace-suancai, workspace-programmer |
| **技术规范中心** | 1 | agent/workspace-guantang/agent-configs（含 3 个 Agent 配置） |
| **工程代码** | 4 | code/backend, code/frontend, code/deploy, code/tests |
| **文档资料** | 2 | guides/, specs/, logs/ |
| **迁移历史** | 1 | agent/migration/（含迁移指南、配置模板） |

### 核心配置文件清单

| Agent | IDENTITY.md | ROLE.md | SOUL.md | README.md | 状态 |
|-------|-------------|---------|---------|-----------|------|
| **酱肉** | ✅ | ✅ | ✅ | ✅ | 完整 |
| **豆沙** | ✅ | ✅ | ✅ | ✅ | 完整 |
| **酸菜** | ✅ | ✅ | ✅ | ✅ | 完整 |
| **程序员** | 🟡 (模板) | ❌ | ❌ | ❌ | 预留 |

### GitHub 仓库

| 地址 | 用途 | URL |branch|
|------|------|-----|-----|
| **/agent** | agent配置文件 | https://github.com/baobaobaobaozijun/openclawPlayground |master|
| **/code/backend** | 后端代码 | https://github.com/baobaobaobaozijun/openclaw-backend |master|
| **/code/frontend** | 前端代码 | https://github.com/baobaobaobaozijun/openclaw-frontend |master|
| **/code/deploy**  | 运维脚本工作台 | https://github.com/baobaobaobaozijun/openclaw-devops |master|
| **/code/test**  | 测试脚本工作台 | https://github.com/baobaobaobaozijun/openclaw-test |master|

---

## ✨ 架构优势

### 清晰的角色定位
- 每个 Agent 有独立的工作空间和身份认知
- inbox/outbox任务管理系统，工作流程清晰
- 职责明确，避免混淆

### 高效的协作机制
- 标准化的任务流转流程（inbox → outbox）
- 沟通记录可追溯
- 文档自动沉淀为团队知识

### 灵活的技术选型
- 各技术栈独立演进
- 可以根据需求自由升级
- 不会相互影响

### 易于扩展和维护
- 新增 Agent 只需添加新的 workspace 目录
- 技术规范集中管理，更新透明
- 工程代码共享，便于协作

### 本地化运行
- 单 Gateway 进程内运行多个 Agent
- 零延迟通信（~2ms）
- 资源占用低（~600MB）
- 无需 Docker 依赖

### 安全性保障
- 敏感配置集中管理
- 代码仓库权限分离
- 工作日志可审计

---

## 🔮 未来规划

### 短期目标（1-2 周）
- [ ] 完善 code/ 目录下的基础工程模板
- [ ] 创建代码工程的 GitHub 仓库
- [ ] 实现第一个完整的用户故事（从需求到上线）

### 中期目标（1 个月）
- [ ] 建立完善的 CI/CD流程
- [ ] 实现自动化监控和告警
- [ ] 积累至少 10 个完整的功能模块

### 长期目标（3 个月）
- [ ] 形成成熟的 Agent 协作模式
- [ ] 建立完整的知识库和最佳实践
- [ ] 支持更复杂的项目规模

---

## ⚠️ 维护注意事项

### 绝对禁止
- ❌ **删除任何 Agent 的 IDENTITY.md, ROLE.md, SOUL.md** - 这会导致 Agent 无法启动
- ❌ **移动核心配置文件到其他目录** - Agent 启动时会直接从 workspace-xxx/ 根目录读取
- ❌ **修改核心配置文件的文件名** - 必须保持标准命名
- ❌ **删除 agent/migration/ 目录** - 包含架构迁移历史文档

### 推荐做法
- ✅ 定期备份所有 agent/workspace-xxx/ 目录
- ✅ 特别备份 agent/migration/ 目录（包含迁移指南和配置模板）
- ✅ 在 agent/workspace-guantang/agent-configs/ 中维护和更新技术规范
- ✅ 保持工作台目录结构清晰
- ✅ 及时更新 README.md 工作流程说明
- ✅ 使用 Git 管理 migration/ 目录（记录架构演进历史）
- ✅ 定期清理 tasks/inbox/和tasks/outbox/中的已完成任务

---

**祝团队合作愉快！开始创造伟大的产品吧！** 🚀

*维护者：灌汤 PM*  
*更新日期：2026-03-11*
*备注：全面清理 Docker 相关引用，切换到本地化运行模式架构文档*
