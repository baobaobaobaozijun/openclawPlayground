# OpenClaw Agent Team - 灌汤配置中心

📋 **这是灌汤 (PM) 的配置文档和工作空间**

---

## 🏠 关于本项目

**workspace-guantang** 是 OpenClaw Agent 团队中**灌汤 (PM)** 的独立工作空间，包含：
- ✅ 灌汤的核心配置文件
- ✅ 其他 Agent 的配置文档（agent-configs/）
- ✅ 工作日志和经验总结（logs/）

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
└── USER.md                  # 用户信息
│
├── agent-configs/           # 其他 Agent 配置
│   ├── jiangrou/           # 酱肉 (后端) 配置
│   │   ├── IDENTITY.md
│   │   ├── ROLE.md
│   │   ├── SOUL.md
│   │   └── knowledge-base.md  # 后端开发知识库
│   ├── dousha/             # 豆沙 (前端) 配置
│   │   ├── IDENTITY.md
│   │   ├── ROLE.md
│   │   ├── SOUL.md
│   │   └── knowledge-base.md  # 前端设计知识库
│   └── suancai/            # 酸菜 (运维) 配置
│       ├── IDENTITY.md
│       ├── ROLE.md
│       ├── SOUL.md
│       └── knowledge-base.md  # 运维测试知识库
│
└── logs/                    # 工作日志与总结
    ├── github-upload-complete.md
    ├── repository-correction-complete.md
    └── ...
```

---

## 👥 Agent 团队成员

### 🍲 灌汤 (PM/项目经理)
**核心文件:** [IDENTITY.md](./IDENTITY.md), [ROLE.md](./ROLE.md), [SOUL.md](./SOUL.md)

**主要职责:**
- 产品规划与需求分析
- 项目进度管理
- 团队协调与决策
- 质量把控与验收

### 🥩 酱肉 (后端工程师)
**配置文件:** [agent-configs/jiangrou/](./agent-configs/jiangrou/)
**知识库:** [knowledge-base.md](./agent-configs/jiangrou/knowledge-base.md)

**主要职责:**
- 后端 API 设计与实现
- 数据库设计与优化
- 系统架构设计

### 🍡 豆沙 (前端工程师/UIUX设计师)
**配置文件:** [agent-configs/dousha/](./agent-configs/dousha/)
**知识库:** [knowledge-base.md](./agent-configs/dousha/knowledge-base.md)

**主要职责:**
- UI/UX设计与实现
- 前端页面开发
- 交互效果优化

### 🥬 酸菜 (运维/测试工程师)
**配置文件:** [agent-configs/suancai/](./agent-configs/suancai/)
**知识库:** [knowledge-base.md](./agent-configs/suancai/knowledge-base.md)

**主要职责:**
- 系统部署与运维
- 功能测试与性能测试
- 质量管理与监控

---

## 🔗 相关仓库

| 仓库 | 用途 |
|------|------|
| **[openclawPlayground](https://github.com/baobaobaobaozijun/openclawPlayground)** | 配置文档中心（本仓库） |
| **[openclaw-backend](https://github.com/baobaobaobaozijun/openclaw-backend)** | 后端业务代码（酱肉负责） |
| **[openclaw-frontend](https://github.com/baobaobaobaozijun/openclaw-frontend)** | 前端业务代码（豆沙负责） |
| **[openclaw-devops](https://github.com/baobaobaobaozijun/openclaw-devops)** | 运维测试脚本（酸菜负责） |

---

## ✏️ 如何修改 Agent 配置

### 步骤 1: 找到对应文件

- 修改灌汤 → 根目录下的 `.md` 文件
- 修改酱肉 → `agent-configs/jiangrou/` 目录
- 修改豆沙 → `agent-configs/dousha/` 目录
- 修改酸菜 → `agent-configs/suancai/` 目录

### 步骤 2: 编辑并提交

```bash
git add .
git commit -m "update: 调整酱肉的 API 开发规范"
git push origin main
```

---

**开始管理和优化你的 Agent 团队吧！** 🚀

*最后更新：2025-05-13*
