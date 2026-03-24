<!-- Last Modified: 2026-03-24 -->

# 包子铺项目架构总览

**基于 OpenClaw 框架的 Agent 团队协作与工程架构**

*最后更新：2026-03-24*

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

### Agent 配置仓库 (f:\openclaw\agent/)

```
agent/
├── ARCHITECTURE.md
├── doc/                          # 统一知识库
│   ├── 01-core/                  # 核心文档 (PRD/技术方案/执行清单)
│   ├── 02-specs/                 # 规范文档
│   ├── 03-guides/                # 使用指南
│   ├── 05-progress/              # 进度跟踪 (心跳看板/项目仪表板)
│   ├── 06-templates/             # 文档模板
│   ├── 07-logs/                  # 日志索引
│   ├── 08-knowledge/             # 知识库
│   ├── guides/                   # Agent 专属指南
│   └── meetings/                 # 站会纪要
├── workinglog/                   # 统一工作日志
│   ├── guantang/
│   ├── jiangrou/
│   ├── dousha/
│   └── suancai/
├── workspace-guantang/           # PM 工作台
├── workspace-jiangrou/           # 后端工作台
├── workspace-dousha/             # 前端工作台
├── workspace-suancai/            # 运维工作台
├── migration/                    # 迁移文档
├── status/                       # 状态文件
├── issues/                       # 问题追踪
└── _archived/                    # 归档目录
```

### 代码工程目录 (f:\openclaw\code/)

```
code/
├── backend/                      # Java 21 + Spring Boot
├── frontend/                     # Vue 3 + TypeScript
├── deploy/                       # 部署脚本
└── tests/                        # 测试脚本
```

---

## Agent 角色

| Agent | 角色 | 工作空间 | 代码目录 |
|-------|------|----------|----------|
| 灌汤 | PM | workspace-guantang | - |
| 酱肉 | 后端 | workspace-jiangrou | code/backend/ |
| 豆沙 | 前端 | workspace-dousha | code/frontend/ |
| 酸菜 | 运维 | workspace-suancai | code/deploy/, code/tests/ |

---

## GitHub 仓库

| 目录 | URL |
|------|-----|
| agent/ | https://github.com/baobaobaobaozijun/openclawPlayground |
| code/backend | https://github.com/baobaobaobaozijun/openclaw-backend |
| code/frontend | https://github.com/baobaobaobaozijun/openclaw-frontend |
| code/deploy | https://github.com/baobaobaobaozijun/openclaw-devops |
| code/tests | https://github.com/baobaobaobaozijun/openclaw-test |

---

## 监控机制

| 任务 | 频率 |
|------|------|
| 心跳监控 | 每小时 |
| 每日站会 | 9:00 / 14:00 |
| 架构文档维护 | 每天 3:00 |
| Cron 健康告警 | 每 3 小时 |

---

*维护者：灌汤 PM | 更新日期：2026-03-24*