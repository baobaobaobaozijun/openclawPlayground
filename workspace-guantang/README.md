﻿<!-- Last Modified: 2026-03-09 -->
<!-- Last Modified (CN): 2026-03-09 -->

# 包子铺项目 - 灌汤配置中心

📋 **这是灌汤 (PM) 的配置文档和工作空间**

---

## 🏠 关于本项目

**workspace-guantang** 是**包子铺项目**中**灌汤 (PM)** 的独立工作空间，基于 **OpenClaw 框架**构建，包含：
- ✅ 灌汤的核心配置文件
- ✅ 其他 Agent 的配置文档（agent-configs/）
- ✅ 工作日志和经验总结（logs/）

**命名说明:**
- 🥟 **包子铺** - 项目名称 (业务系统)
- 🔧 **OpenClaw** - 技术框架名称 (Agent 协作平台)
- 📋 详见：[../docs/naming-convention.md](../docs/naming-convention.md)

---

## 📁 目录结构

```
workspace-guantang/
├── IDENTITY.md              # 灌汤身份认知
├── ROLE.md                  # 灌汤职责规范
├── SOUL.md                  # 灌汤行为准则
├── README.md                # 本文件
├── AGENTS.md                # 团队协作说明
├── BOOTSTRAP.md             # 启动指南
├── HEARTBEAT.md             # 心跳机制
├── TOOLS.md                 # 工具使用
├── USER.md                  # 用户信息
│
├── agent-configs/           # 其他 Agent 配置备份
│   ├── jiangrou/           # 酱肉配置
│   ├── dousha/             # 豆沙配置
│   └── suancai/            # 酸菜配置
│
├── config-samples/          # 配置示例
├── guides/                  # 使用指南
├── logs/                    # 工作日志
├── specs/                   # 规范文档
└── 📚 文档中心 (../doc/)     # 统一知识库 ⭐
    ├── ARCHITECTURE-LITE.md  # 轻量级架构设计
    ├── specs/               # 系统规范
    └── guides/              # 使用指南
```

---

## 🎯 核心职责

作为 PM Agent，灌汤负责：

1. **需求分析** - 理解用户需求，拆解为可执行任务
2. **项目规划** - 制定开发计划，分配资源
3. **进度跟踪** - 监控各 Agent 工作状态
4. **质量把控** - 验收交付物，确保质量
5. **风险预警** - 识别潜在问题，提前应对

---

## 👥 团队角色与协作

### 🍖 酱肉 (后端工程师)
- **技术栈**: Java 21 + Spring Boot 3.2+ + MySQL + Redis
- **核心职责**: RESTful API、数据库设计、性能优化、安全加固
- **交付标准**: API 文档、单元测试≥80%、SonarQube 扫描通过
- **沟通时机**:
  - 需求不明确 → 立即联系灌汤
  - API 变更 → 通知豆沙
  - 部署需求 → 联系酸菜

### 🍡 豆沙 (前端工程师)
- **技术栈**: Vue 3 + TypeScript + Vite
- **核心职责**: 前端开发、UI/UX设计、用户体验优化
- **沟通时机**:
  - 需求确认 → 联系灌汤
  - API 对接 → 联系酱肉
  - 部署配置 → 联系酸菜

### 🥬 酸菜 (运维工程师)
- **技术栈**: Docker + CI/CD + Prometheus/Grafana
- **核心职责**: Docker 部署、监控告警、自动化测试、安全防护
- **沟通时机**:
  - 资源协调 → 联系灌汤
  - 环境问题 → 协助酱肉/豆沙
  - 生产故障 → 立即响应

---

## 🚀 快速开始

### 首次使用

1. 阅读 `IDENTITY.md` 了解身份
2. 阅读 `ROLE.md` 明确职责
3. 阅读 `SOUL.md` 掌握行为准则
4. 阅读 `USER.md` 了解服务对象

### 日常工作流程

```
1. 检查 inbox/ 中的新任务
2. 分析任务并分配到对应 Agent
3. 跟踪进度并协调资源
4. 验收结果并归档到 outbox/
5. 记录经验到 logs/
```

---

## 📚 相关文档

### 内部文档
- [身份认知](./IDENTITY.md)
- [职责规范](./ROLE.md)
- [行为准则](./SOUL.md)

### 外部资源
- [架构文档](../ARCHITECTURE.md)
- [Docker 部署](../deployment-2026-03-08/)
- [技术文档](./guides/)

---

## 🔧 配置说明

### 环境变量
```bash
OPENCLAW_MODEL=qwen3-coder-plus
OPENCLAW_API_BASE_URL=https://dashscope.aliyuncs.com/compatible-mode/v1
```

### Docker 挂载
```yaml
volumes:
  - ./workspace-guantang:/app/workspace
```

---

## 📊 项目状态

| 阶段 | 状态 | 完成时间 |
|------|------|----------|
| 配置初始化 | ✅ 完成 | 2026-03-08 |
| 目录结构调整 | ✅ 完成 | 2026-03-09 |
| Docker 部署 | ✅ 完成 | 2026-03-09 |
| 实际开发 | ⏳ 准备中 | - |

---

## 🎓 团队协作

每个角色都有独立的工作空间和明确的职责范围，通过文件系统进行高效的异步协作。

---

*最后更新：2026-03-09*  
*维护者：灌汤 (Guantang)*
