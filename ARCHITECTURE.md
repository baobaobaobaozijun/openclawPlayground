<!-- Last Modified: 2026-03-26 -->

# 包子铺项目架构总览

**基于 OpenClaw 框架的 Agent 团队协作与工程架构**

*最后更新：2026-03-26*

---

## 命名规范

- **包子铺 (Baozipu)** - 项目名称（博客业务系统）
- **OpenClaw** - 技术框架名称（Agent 协作框架）
- 包子铺项目**使用** OpenClaw 框架来构建

---

## 项目概述

包子铺是一个基于 OpenClaw 框架的多 Agent 协作软件开发平台。单个 OpenClaw Gateway 进程运行多个 Agent 实例，每个 Agent 拥有独立的工作空间，通过进程内通信实现高效协作。

**当前阶段：** 阶段 2 - 核心功能开发  
**远程服务器：** 8.137.175.240（Java 21 / MySQL / Redis / Nginx 已就绪）

---

## 核心目录结构

### Agent 配置仓库 (F:\openclaw\agent\)

```
agent/
├── ARCHITECTURE.md                 # 本架构文档
├── doc/                            # 统一知识库
│   ├── 01-core/                    # 核心文档 (PRD/技术方案/执行清单)
│   ├── 02-specs/                   # 规范文档
│   ├── 03-guides/                  # 使用指南
│   ├── 05-progress/                # 进度跟踪 (心跳看板/项目仪表板)
│   ├── 06-templates/               # 文档模板
│   ├── 07-logs/                    # 日志索引
│   ├── 08-knowledge/               # 知识库
│   │   └── guides/                 # Agent 专属指南
│   └── meetings/                   # 站会纪要
├── workinglog/                     # 统一工作日志
│   ├── guantang/                   # PM 工作日志
│   ├── jiangrou/                   # 后端工作日志
│   ├── dousha/                     # 前端工作日志
│   └── suancai/                    # 运维工作日志
├── workspace-guantang/             # PM 工作空间
├── workspace-jiangrou/             # 后端工作空间
├── workspace-dousha/               # 前端工作空间
├── workspace-suancai/              # 运维工作空间
├── migration/                      # 迁移文档
├── status/                         # 状态文件
├── issues/                         # 问题追踪
└── _archived/                      # 归档目录
```

### 代码工程目录 (F:\openclaw\code\)

```
code/
├── backend/                        # Java 21 + Spring Boot 3.2+
├── frontend/                       # Vue 3 + TypeScript
├── deploy/                         # 部署脚本 (Docker/Nginx)
└── tests/                          # 测试脚本
```

---

## Agent 角色与职责

| Agent | 角色 | 工作空间 | 代码目录 | 模型 |
|-------|------|----------|----------|------|
| 灌汤 🍲 | PM | workspace-guantang | - | qwen3.5-plus |
| 酱肉 🍖 | 后端工程师 | workspace-jiangrou | code/backend/ | qwen3-coder-plus |
| 豆沙 🍡 | 前端工程师 | workspace-dousha | code/frontend/ | qwen3-coder-plus |
| 酸菜 🥬 | 运维工程师 | workspace-suancai | code/deploy/, code/tests/ | qwen3-coder-plus |

### 职责说明

**灌汤 (PM)：** 产品规划、需求分析、任务分配、进度跟踪、文档维护

**酱肉 (后端)：** RESTful API、数据库设计、JWT 认证、性能优化、单元测试

**豆沙 (前端)：** Vue 3 组件、TypeScript、UI/UX 设计、响应式适配

**酸菜 (运维)：** Docker 部署、CI/CD 配置、监控告警、自动化测试

---

## GitHub 仓库

| 目录 | 仓库 | URL |
|------|------|-----|
| agent/ | openclawPlayground | https://github.com/baobaobaobaozijun/openclawPlayground |
| code/backend | openclaw-backend | https://github.com/baobaobaobaozijun/openclaw-backend |
| code/frontend | openclaw-frontend | https://github.com/baobaobaobaozijun/openclaw-frontend |
| code/deploy | openclaw-devops | https://github.com/baobaobaobaozijun/openclaw-devops |
| code/tests | openclaw-test | https://github.com/baobaobaobaozijun/openclaw-test |

---

## 技术架构

### 后端技术栈

- **语言：** Java 21
- **框架：** Spring Boot 3.2+
- **数据库：** MySQL 8.0+
- **缓存：** Redis 7.0+
- **认证：** JWT Token
- **文档：** Swagger/OpenAPI

### 前端技术栈

- **框架：** Vue 3 + Vite
- **语言：** TypeScript 5+
- **UI：** 自定义组件
- **路由：** Vue Router 4
- **状态管理：** Pinia

### 运维技术栈

- **容器：** Docker + Docker Compose
- **Web 服务器：** Nginx
- **CI/CD：** GitHub Actions
- **监控：** 自定义健康检查

---

## 通信架构

```
┌─────────────────────────────────────────────────────────┐
│                  OpenClaw Gateway (Port 18789)          │
│                     进程内通信 (~2ms)                    │
├─────────────────┬─────────────────┬─────────────────────┤
│   灌汤 (PM)     │   酱肉 (后端)   │   豆沙 (前端)       │
│  workspace-     │  workspace-     │  workspace-         │
│  guantang       │  jiangrou       │  dousha             │
├─────────────────┴─────────────────┴─────────────────────┤
│                   酸菜 (运维)                            │
│                  workspace-suancai                       │
└─────────────────────────────────────────────────────────┘
```

**通信特点：**
- ✅ 零延迟：进程内内存调用
- ✅ 高可靠：无网络依赖
- ✅ 简配置：无需 Docker 网络
- ✅ 易维护：单进程日志集中

---

## 监控机制

| 任务 | 频率 | 说明 |
|------|------|------|
| 心跳监控 | 每 10 分钟 | Cron 兜底 + 回调驱动主力 |
| 每日站会 | 9:00 / 14:00 | 任务分配与进度同步 |
| 架构文档维护 | 每天 3:00 | 链接检查 + 日期更新 |
| Cron 健康告警 | 每 3 小时 | Gateway 状态检查 |
| Git 自动推送 | 18:00 | 当日代码归档 |

---

## 当前项目状态 (2026-03-26)

### 后端进度 🍖

- ✅ AuthController (login/register)
- ✅ ArticleQueryService
- ✅ TagServiceImpl
- ✅ CategoryMapper / TagMapper
- ✅ Swagger 配置
- ✅ Maven 编译通过 (38 源文件)
- ⚠️ 缺少：Token 刷新接口

### 前端进度 🍡

- ✅ HomeView / CategoryView
- ✅ LoginView / RegisterView
- ✅ Articles 组件 / Layout / NavBar
- ✅ auth.ts (已修复)
- ✅ ArticleCard 组件
- 🔄 进行中：响应式适配

### 运维进度 🥬

- ✅ Dockerfile
- ✅ docker-compose.yml
- ✅ 备份脚本
- ✅ SSH 验证 6/6 通过
- ✅ 部署目录 /opt/baozipu/ 已存在
- ⚠️ 待校正：backend 端口 (8080→8081)

---

## 待解决风险

1. **Auth Token 刷新接口** - 后端缺失，需补充
2. **docker-compose 端口** - 配置 8080 但 Java 监听 8081
3. **前后端联调** - 尚未开始
4. **Git 提交规范** - 各 Agent 不稳定，PM 代推送为主

---

## 工作机制

### 任务派发模式

**结构化任务工单制** - 模板：`doc/06-templates/task-order-template-v3.md`

**核心规则：**
- 每个 spawn 只产出 1 个文件
- tool call ≤ 4 步
- 关键数据内联在消息中
- 禁止事项显式列出
- 读代码→写文档 / 执行远程命令 / Git push → PM 执行

### 回调驱动机制

```
subagent 完成回调
    ↓
验证交付文件 (Test-Path)
    ↓
检查工作日志 (合规检查)
    ↓
同批次全部完成 → 批量验证 + git commit
    ↓
立即派发下一轮 (sessions_spawn)
    ↓
零空窗等待
```

### 失联唤醒机制

| 失联时长 | 行动 |
|---------|------|
| > 60 分钟 | sessions_spawn 唤醒 + 要求汇报 |
| > 70 分钟 | 第二次唤醒 + 警告 |
| > 90 分钟 | PM 直接执行 + 记录违规 |

---

*维护者：灌汤 PM | 更新日期：2026-03-26*
