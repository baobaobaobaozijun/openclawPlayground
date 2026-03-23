<!-- Last Modified: 2026-03-23 -->

# 包子铺项目架构总览

**基于 OpenClaw 框架的 Agent 团队协作与工程架构**

*最后更新: 2026-03-23*

---

## 命名规范

- **包子铺 (Baozipu)** - 项目名称（博客业务系统）
- **OpenClaw** - 技术框架名称（Agent 协作框架）
- 包子铺项目 **使用** OpenClaw 框架来构建

---

## 项目概述

包子铺是一个基于 OpenClaw 框架的多 Agent 协作软件开发平台。单个 OpenClaw Gateway 进程运行多个 Agent 实例，每个 Agent 拥有独立的工作空间，通过进程内通信实现高效协作。

---

## 核心目录结构

### Agent 配置仓库 (`f:\openclaw\agent/`)

```
agent/                                # Git 仓库根目录
|
|-- ARCHITECTURE.md                   # 本文件
|
|-- doc/                              # 统一知识库
|   |-- README.md                     # 知识库索引
|   |-- 01-core/                      # 核心文档
|   |   |-- prd/                      # 博客系统-PRD.md
|   |   |-- tech/                     # 博客系统-技术方案.md
|   |   |-- design/                   # 博客系统-原型交互稿.md
|   |   |-- test/                     # 博客系统-测试用例.md
|   |   |-- deploy/                   # 博客系统-上线方案.md
|   |   +-- plan/                     # 项目计划与执行清单
|   |       |-- 博客系统-开发计划-v2.md
|   |       |-- 酱肉-执行清单-v2.md
|   |       |-- 豆沙-执行清单-v2.md
|   |       +-- 酸菜-执行清单-v2.md
|   |-- 02-specs/                     # 规范文档
|   |-- 03-guides/                    # 使用指南
|   |-- 05-progress/                  # 进度跟踪
|   |   |-- agent-heartbeat-dashboard.md
|   |   |-- agent-heartbeat-log.md
|   |   +-- project-dashboard.md
|   |-- 06-templates/                 # 文档模板
|   |-- 07-logs/                      # 日志索引
|   |-- 08-knowledge/                 # 知识库
|   |-- guides/                       # Agent 专属指南
|   +-- meetings/                     # 站会纪要
|
|-- workinglog/                       # 统一工作日志目录
|   |-- guantang/                     # 灌汤工作日志
|   |-- jiangrou/                     # 酱肉工作日志
|   |-- dousha/                       # 豆沙工作日志
|   +-- suancai/                      # 酸菜工作日志
|
|-- workspace-guantang/               # PM/项目经理工作台
|   |-- IDENTITY.md                   # 身份认知
|   |-- ROLE.md                       # 职责规范
|   |-- SOUL.md                       # 行为准则
|   |-- MEMORY.md                     # PM 工作记忆
|   |-- AGENTS.md                     # 团队协作规范
|   |-- HEARTBEAT.md                  # 心跳配置
|   |-- TOOLS.md                      # 工具笔记
|   |-- USER.md                       # 用户信息
|   |-- agent-configs/                # 各 Agent 技术规范备份
|   |   |-- jiangrou/README.md
|   |   |-- dousha/README.md
|   |   +-- suancai/README.md
|   |-- scripts/                      # 自动化脚本
|   +-- skills/                       # OpenClaw Skills
|
|-- workspace-jiangrou/               # 酱肉工作台（后端）
|   |-- IDENTITY.md / ROLE.md / SOUL.md / MEMORY.md
|   |-- TECHNICAL-DOCS.md / README.md
|   |-- inbox/                        # 任务收件箱
|   |-- tasks/ (inbox/ + outbox/)     # 任务管理
|   +-- logs/
|
|-- workspace-dousha/                 # 豆沙工作台（前端）
|   |-- IDENTITY.md / ROLE.md / SOUL.md / MEMORY.md
|   |-- TECHNICAL-DOCS.md / README.md
|   |-- inbox/                        # 任务收件箱
|   |-- tasks/ (inbox/ + outbox/)     # 任务管理
|   |-- designs/                      # 设计资源
|   +-- logs/
|
|-- workspace-suancai/                # 酸菜工作台（运维）
|   |-- IDENTITY.md / ROLE.md / SOUL.md / MEMORY.md
|   |-- TECHNICAL-DOCS.md / README.md
|   |-- inbox/                        # 任务收件箱
|   |-- tasks/ (inbox/ + outbox/)     # 任务管理
|   +-- logs/
|
|-- migration/                        # 迁移文档（历史参考）
|-- status/                           # Agent 状态文件
|-- issues/                           # 问题追踪
+-- _archived/                        # 归档目录
```

### 代码工程目录 (`f:\openclaw\code/`，独立 Git 仓库)

```
code/
|-- backend/                          # Java 21 + Spring Boot 3.2+（酱肉负责）
|   |-- src/main/java/com/openclaw/  # Java 源码
|   |   |-- controller/              # REST 控制器
|   |   |-- service/                 # 业务逻辑
|   |   |-- entity/                  # 实体类
|   |   |-- mapper/                  # 数据访问
|   |   |-- dto/                     # 数据传输对象
|   |   |-- security/               # JWT 安全
|   |   +-- config/                  # 配置
|   |-- src/main/resources/          # 配置文件
|   |-- scripts/                     # DDL 等脚本
|   |-- pom.xml
|   +-- README.md
|
|-- frontend/                         # Vue 3.4 + TypeScript 5.x（豆沙负责）
|   |-- src/
|   |   |-- views/                   # 页面组件
|   |   |-- components/              # 通用组件
|   |   |-- api/                     # API 调用
|   |   |-- stores/                  # Pinia 状态管理
|   |   +-- router/                  # 路由
|   |-- package.json
|   +-- README.md
|
|-- deploy/                           # 部署脚本（酸菜负责）
|   |-- nginx/                       # Nginx 配置
|   |-- scripts/                     # 部署脚本
|   +-- README.md
|
+-- tests/                            # 测试脚本（酸菜负责）
    +-- README.md
```

---

## Agent 角色与职责

### 灌汤 (Guantang) - PM/项目经理

**工作空间:** `workspace-guantang/`

**核心职责:**
- 产品规划与需求分析
- 项目进度管理与心跳监控
- 团队协调与决策
- 质量把控与验收
- 管理所有 Agent 的配置文档

**核心配置文件:**
- IDENTITY.md - 身份认知
- SOUL.md - 行为准则
- AGENTS.md - 团队协作规范
- HEARTBEAT.md - 心跳配置

---

### 酱肉 (Jiangrou) - 后端工程师

**工作空间:** `workspace-jiangrou/`
**代码工程:** `code/backend/`
**GitHub:** https://github.com/baobaobaobaozijun/openclaw-backend

**核心职责:**
- 技术架构设计、后端 API 开发
- 数据库设计、性能优化
- JWT 认证与权限管理

**技术栈:**
- Java 21 + Spring Boot 3.2+ + MySQL 8.0+ + Maven 3.9+
- MyBatis-Plus + Spring Security + JWT

**技术文档:**
- agent-configs/jiangrou/README.md - 完整技术规范
- doc/01-core/plan/酱肉-执行清单-v2.md - 文件级任务清单

---

### 豆沙 (Dousha) - 前端工程师/UI 设计

**工作空间:** `workspace-dousha/`
**代码工程:** `code/frontend/`
**GitHub:** https://github.com/baobaobaobaozijun/openclaw-frontend

**核心职责:**
- UI/UX 设计、前端页面开发
- 响应式适配、性能优化

**技术栈:**
- Vue 3.4+ (Composition API) + TypeScript 5.x + Vite 5.x
- Element Plus + Tailwind CSS + Pinia

**技术文档:**
- agent-configs/dousha/README.md - 完整技术规范
- doc/01-core/plan/豆沙-执行清单-v2.md - 文件级任务清单

---

### 酸菜 (Suancai) - 运维/测试工程师

**工作空间:** `workspace-suancai/`
**工作目录:** `code/deploy/`, `code/tests/`
**GitHub:** https://github.com/baobaobaobaozijun/openclaw-devops

**核心职责:**
- 系统部署与运维（Docker + Nginx）
- CI/CD 配置、监控告警
- 自动化测试

**技术栈:**
- Nginx + systemd + Docker
- JUnit 5 + Playwright

**技术文档:**
- agent-configs/suancai/README.md - 完整技术规范
- doc/01-core/plan/酸菜-执行清单-v2.md - 文件级任务清单

---

## 工作流程

### 1. 任务分发

```
灌汤 (PM) --> 创建任务文件 --> workspace-{agent}/inbox/
          --> sessions_spawn 通知 Agent
```

### 2. 任务执行

```
Agent 接收任务 --> 阅读执行清单 --> 在 code/ 目录开发
             --> 写工作日志到 workinglog/{agent}/
             --> Git commit
```

### 3. 验收

```
灌汤检查代码 --> 通过: 标记完成 --> 不通过: 返回修改
```

---

## 本地化运行模式

**运行方式:** 单个 OpenClaw Gateway 进程（端口 18789）
**Agent 数量:** 4 个（灌汤、酱肉、豆沙、酸菜）
**通信方式:** 进程内内存调用（约 2ms 延迟）
**配置文件:** `C:\Users\Administrator\.openclaw\openclaw.json`

---

## 监控机制（2026-03-23 优化后）

| 任务 | 频率 | 用途 |
|------|------|------|
| 心跳监控（三合一） | 每小时 | 检查 Agent 状态 + 日志 + 唤醒失联 |
| 每日站会 | 9:00 / 14:00 | 分配任务 + 纪要 |
| 架构文档维护 | 每天 3:00 | 链接检查 + 更新日期 |
| Cron 健康告警 | 每 3 小时 | 连续失败 >= 3 次通知用户 |

---

## GitHub 仓库

| 目录 | 用途 | URL | 分支 |
|------|------|-----|------|
| agent/ | Agent 配置 | https://github.com/baobaobaobaozijun/openclawPlayground | master |
| code/backend | 后端代码 | https://github.com/baobaobaobaozijun/openclaw-backend | master |
| code/frontend | 前端代码 | https://github.com/baobaobaobaozijun/openclaw-frontend | master |
| code/deploy | 运维脚本 | https://github.com/baobaobaobaozijun/openclaw-devops | master |
| code/tests | 测试脚本 | https://github.com/baobaobaobaozijun/openclaw-test | master |

---

## 维护注意事项

**禁止:**
- 删除任何 Agent 的 IDENTITY.md / ROLE.md / SOUL.md
- 移动核心配置文件到其他目录
- 删除 migration/ 目录

**推荐:**
- 定期备份 workspace-*/ 目录
- 在 agent-configs/ 中维护技术规范
- 使用 Git 管理所有变更
- 及时清理 tasks/inbox/ 和 tasks/outbox/ 中的已完成任务

---

*维护者: 灌汤 PM*
*更新日期: 2026-03-23*
