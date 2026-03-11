<!-- Last Modified: 2026-03-12 -->

# 快速启动指南 ⭐

**适用对象:** 新加入项目的开发者  
**预计耗时:** 5-10 分钟  
**最后更新:** 2026-03-12  

---

## 📋 前置条件

### 必需环境

- ✅ **Node.js 18+** (前端开发)
- ✅ **Java 21** (后端开发)
- ✅ **MySQL 8.0+** (数据库)
- ✅ **Git** (版本控制)

### 可选工具

- 🟡 **VS Code** 或其他 IDE
- 🟡 **Postman** (API 测试)
- 🟡 **Navicat** 或 **DBeaver** (数据库管理)

---

## 🚀 快速开始

### 步骤 1: 克隆项目

```bash
# 克隆项目到本地
git clone https://github.com/baobaobaobaozijun/openclaw.git
cd openclaw
```

### 步骤 2: 了解项目结构

```
f:\openclaw/
├── agent/                    # Agent 工作区
│   ├── workspace-guantang/   # PM 工作台
│   ├── workspace-jiangrou/   # 后端工作台
│   ├── workspace-dousha/     # 前端工作台
│   └── workspace-suancai/    # 运维工作台
├── code/                     # 工程项目
│   ├── backend/              # 后端代码
│   ├── frontend/             # 前端代码
│   ├── deploy/               # 部署脚本
│   └── tests/                # 测试脚本
└── doc/                      # 统一知识库
```

### 步骤 3: 选择你的角色

#### 📋 如果你是 PM（灌汤）

```bash
# 阅读 PM 核心文档
cd agent/workspace-guantang

# 必读文件
- IDENTITY.md    # 身份认知
- ROLE.md        # 职责规范
- SOUL.md        # 行为准则
- README.md      # 工作台说明
```

**主要职责:**
- 创建和管理任务
- 分配优先级
- 验收完成的工作
- 协调团队协作

---

#### 🍖 如果你是后端工程师（酱肉）

```bash
# 阅读后端核心文档
cd agent/workspace-jiangrou

# 必读文件
- IDENTITY.md    # 技术栈说明
- ROLE.md        # 职责规范
- SOUL.md        # 行为准则
- TECHNICAL-DOCS.md  # 技术文档
```

**启动后端项目:**
```bash
cd code/backend

# 使用 Maven 构建
mvn clean package

# 运行 Spring Boot 应用
java -jar target/blog-*.jar

# 访问地址：http://localhost:8080
```

**主要职责:**
- RESTful API 设计
- 数据库架构
- 业务逻辑实现
- 性能优化

---

#### 🍡 如果你是前端工程师（豆沙）

```bash
# 阅读前端核心文档
cd agent/workspace-dousha

# 必读文件
- IDENTITY.md    # 技术栈说明
- ROLE.md        # 职责规范
- SOUL.md        # 行为准则
- TECHNICAL-DOCS.md  # 技术文档
```

**启动前端项目:**
```bash
cd code/frontend

# 安装依赖
npm install

# 启动开发服务器
npm run dev

# 访问地址：http://localhost:3000
```

**主要职责:**
- UI/UX设计
- 页面开发
- 响应式适配
- 性能优化

---

#### 🥬 如果你是运维工程师（酸菜）

```bash
# 阅读运维核心文档
cd agent/workspace-suancai

# 必读文件
- IDENTITY.md    # 职责说明
- ROLE.md        # 职责规范
- SOUL.md        # 行为准则
- TECHNICAL-DOCS.md  # 技术文档
```

**主要职责:**
- 系统部署
- 监控配置
- 自动化测试
- 日志管理

---

## 📚 下一步学习

### 核心文档

1. **[ARCHITECTURE.md](../ARCHITECTURE.md)** - 项目架构总览
2. **[ARCHITECTURE-LITE.md](./doc/ARCHITECTURE-LITE.md)** - 轻量级架构设计
3. **[Agent 协议](./workspace-guantang/specs/agent-protocol.md)** - Agent 通信规范

### 技术规范

- **后端:** [酱肉技术规范](./workspace-guantang/agent-configs/jiangrou/README.md)
- **前端:** [豆沙技术规范](./workspace-guantang/agent-configs/dousha/README.md)
- **运维:** [酸菜技术规范](./workspace-guantang/agent-configs/suancai/README.md)

---

## 🛠️ 常见问题

### Q1: 如何接收任务？

**A:** 查看对应工作区的 `tasks/inbox/` 目录

```bash
# 示例：酱肉查看待办任务
cd agent/workspace-jiangrou/tasks/inbox/
ls
```

---

### Q2: 如何提交任务？

**A:** 
1. 完成任务后，将任务文件移动到 `outbox/`
2. 提交代码到 Git
3. 通知 PM 验收

```bash
# 移动任务文件
mv tasks/inbox/TASK-001.md tasks/outbox/

# Git 提交
git add .
git commit -m "feat: 完成用户登录功能"
git push
```

---

### Q3: 如何与其他 Agent 沟通？

**A:** 
- **方式 1:** 通过 Gateway 进程内通信（实时）
- **方式 2:** 在工作日志中记录 (`workspace-*/logs/`)
- **方式 3:** 直接在代码目录协作开发

---

### Q4: 项目运行在哪里？

**A:** 
- **后端:** http://localhost:8080
- **前端:** http://localhost:3000
- **OpenClaw Gateway:** http://localhost:18789

---

## 📞 需要帮助？

### 联系渠道

1. **直接询问:** 通过 Gateway 向其他 Agent 提问
2. **查看文档:** [doc/](./doc/) 统一知识库
3. **检查工作日志:** `workspace-*/logs/`

---

## ✅ 检查清单

在开始工作前，确保你已：

- [ ] 阅读了本角色的核心文档（IDENTITY/ROLE/SOUL）
- [ ] 了解了项目整体架构
- [ ] 安装了所需工具和依赖
- [ ] 知道如何接收和提交任务
- [ ] 了解沟通协作方式

---

**祝你工作顺利！** 🥟✨

**维护者:** 灌汤 PM  
**最后更新:** 2026-03-12
