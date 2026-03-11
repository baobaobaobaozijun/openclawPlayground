<!-- Last Modified: 2026-03-11 -->

# 包子铺知识库

**版本:** v1.0  
**创建日期:** 2026-03-11  
**维护者:** 灌汤 (PM)  
**状态:** ✅ 已建立

---

## 📋 概述

这是包子铺项目的统一知识库，基于 **OpenClaw 框架**构建，为所有 Agent 提供共享的知识资源。

**知识库目标:**
- ✅ 统一管理项目文档和技术规范
- ✅ 支持 Agent 间的知识共享
- ✅ 提供完整的参考资料索引
- ✅ 便于新人快速上手

---

## 📁 知识库结构

```
doc/                           # 📚 统一知识库
│
├── specs/                     # 📋 规范文档
│   ├── 01-architecture/      # 架构设计
│   │   └── system-architecture.md
│   │
│   ├── 02-business-specs/    # 业务需求
│   │   ├── blog-system-requirements.md
│   │   └── blog-system-database-design.md
│   │
│   ├── 03-technical-specs/   # 技术规范
│   │   ├── agent-communication-protocol-v2.md
│   │   ├── agent-protocol.md
│   │   └── agent-error-monitoring.md
│   │
│   └── 04-processes/         # 流程规范
│       ├── command-specification.md
│       └── logging-audit.md
│
├── guides/                    # 📖 使用指南
│   ├── 01-getting-started/   # 入门指南
│   ├── 02-deployment/        # 部署指南
│   └── 03-agent-guides/      # Agent 指南
│
├── knowledge/                 # 💡 知识库
│   ├── 01-domain/            # 领域知识
│   └── 02-best-practices/    # 最佳实践
│       └── lightweight-mode.md
│
└── logs/                      # 📝 日志索引
    └── index.md
```

---

## 📚 文档分类说明

### 1️⃣ 规范文档 (specs/)

**用途:** 项目和技术规范的标准文档

#### 01-architecture/ - 架构设计
- [system-architecture.md](./specs/01-architecture/system-architecture.md) - 系统架构总览
  - 整体架构图
  - 核心组件说明
  - 技术选型

#### 02-business-specs/ - 业务需求
- [blog-system-requirements.md](./specs/02-business-specs/blog-system-requirements.md) - 博客系统需求
  - 功能需求
  - 用户需求
  - 业务规则

- [blog-system-database-design.md](./specs/02-business-specs/blog-system-database-design.md) - 数据库设计
  - ER 图
  - 表结构
  - 索引设计

#### 03-technical-specs/ - 技术规范
- [agent-communication-protocol-v2.md](./specs/03-technical-specs/agent-communication-protocol-v2.md) - Agent 通信协议 v2.0
  - 通信架构
  - 消息格式
  - 接口定义
  - Gateway 配置

- [agent-protocol.md](./specs/03-technical-specs/agent-protocol.md) - Agent 协议（轻量版）
  - 简化 RPC 调用
  - 文件系统通信
  - 消息示例

- [agent-error-monitoring.md](./specs/03-technical-specs/agent-error-monitoring.md) - Agent 错误监控
  - 监控指标
  - 告警机制
  - 故障处理

#### 04-processes/ - 流程规范
- [command-specification.md](./specs/04-processes/command-specification.md) - 命令规范
  - 命名规范
  - 参数约定
  - 错误处理

- [logging-audit.md](./specs/04-processes/logging-audit.md) - 日志审计
  - 日志格式
  - 审计要求
  - 安全规范

---

### 2️⃣ 使用指南 (guides/)

**用途:** 各类操作指南和教程

#### 01-getting-started/ - 入门指南
- 快速开始
- 环境配置
- 基础教程

#### 02-deployment/ - 部署指南
- Docker 部署
- 本地开发
- 生产环境

#### 03-agent-guides/ - Agent 指南
- 灌汤使用指南
- 酱肉开发指南
- 豆沙前端指南
- 酸菜运维指南

---

### 3️⃣ 知识库 (knowledge/)

**用途:** 领域知识和最佳实践

#### 01-domain/ - 领域知识
- 包子铺业务知识
- 行业背景
- 专业术语

#### 02-best-practices/ - 最佳实践
- [lightweight-mode.md](./knowledge/02-best-practices/lightweight-mode.md) - 轻量级模式
  - 简化配置
  - 快速启动
  - 适用场景

---

## 🔗 Agent 引用指南

### 各 Agent 如何引用知识库

所有 Agent 都应该在各自的 TOOLS.md 或 README.md 中添加知识库引用：

```markdown
## 📚 参考资料

**统一知识库:** [../../doc/README.md](../../doc/README.md)

**常用文档:**
- [系统架构](../../doc/specs/01-architecture/system-architecture.md)
- [Agent 通信协议](../../doc/specs/03-technical-specs/agent-communication-protocol-v2.md)
- [博客系统需求](../../doc/specs/02-business-specs/blog-system-requirements.md)
```

---

## 📊 文档统计

| 分类 | 文档数 | 说明 |
|------|--------|------|
| **架构设计** | 1 | 系统架构 |
| **业务需求** | 2 | 需求 + 数据库设计 |
| **技术规范** | 3 | 通信协议 + 监控 |
| **流程规范** | 2 | 命令 + 日志 |
| **最佳实践** | 1 | 轻量级模式 |
| **总计** | 9 | 核心文档 |

---

## 🎯 知识库管理

### 文档添加流程

1. **创建文档** → 放到对应分类目录
2. **更新索引** → 修改本文件的文档列表
3. **通知 Agent** → 通过 Gateway 发送消息
4. **Git 提交** → commit & push

### 文档分类原则

- **架构设计** - 影响整体的技术决策
- **业务需求** - 包子铺的业务逻辑
- **技术规范** - OpenClaw 框架相关
- **流程规范** - 工作流程和标准
- **最佳实践** - 经验总结和优化建议

### 维护责任

- **灌汤 (PM)** - 知识库整体维护
- **所有 Agent** - 各自负责领域的文档更新
- **鲜肉** - 检查和监督完整性

---

## 📝 迁移记录

### 2026-03-11 - 知识库建立

**从 workspace-guantang/specs/ 迁移:**

| 原文档 | 新位置 | 分类 |
|--------|--------|------|
| system-architecture.md | specs/01-architecture/ | 架构设计 |
| blog-system-requirements.md | specs/02-business-specs/ | 业务需求 |
| blog-system-database-design.md | specs/02-business-specs/ | 业务需求 |
| agent-communication-protocol-v2.md | specs/03-technical-specs/ | 技术规范 |
| agent-protocol.md | specs/03-technical-specs/ | 技术规范 |
| agent-error-monitoring.md | specs/03-technical-specs/ | 技术规范 |
| command-specification.md | specs/04-processes/ | 流程规范 |
| logging-audit.md | specs/04-processes/ | 流程规范 |
| lightweight-mode.md | knowledge/02-best-practices/ | 最佳实践 |

**目的:**
- ✅ 统一知识库管理
- ✅ 便于所有 Agent 访问
- ✅ 清晰的文档分类
- ✅ 避免重复和混乱

---

## ✅ 检查清单

在添加新文档时，请确认:

- [ ] 文档放在正确的分类目录
- [ ] 更新了本索引文件
- [ ] 文档命名符合规范
- [ ] 包含必要的元数据（版本、日期等）
- [ ] 通知了相关 Agent
- [ ] Git 提交并推送

---

**下次审查:** 2026-03-18  
**维护者签名:** 灌汤 (Guantang)  
**知识库状态:** ✅ 运行中
