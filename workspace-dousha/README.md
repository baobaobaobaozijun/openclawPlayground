# 豆沙 (Dousha) - 工作空间配置

🍡 **前端工程师 / UI/UX设计师**

---

## 📋 你的职责

- UI/UX设计
- 前端页面开发
- 响应式适配
- 性能优化

---

## 📁 目录说明

```
workspace-dousha/
├── README.md              # 本文件 - 你的工作台
├── tasks/                 # 任务管理
│   ├── backlog/          # 待办任务
│   ├── in-progress/      # 进行中
│   └── completed/        # 已完成
├── design/                # 设计资源
│   ├── figma/            # Figma 链接
│   └── components/       # 组件规范
├── communication/         # 沟通记录
│   ├── with-guantang.md  # 与 PM 沟通
│   ├── with-jiangrou.md  # 与后端沟通
│   └── with-suancai.md   # 与运维沟通
└── logs/                 # 工作日志
    └── daily/           # 每日日志
```

**实际代码工程位置：** `F:\openclaw\code\frontend\`

---

## 🚀 快速开始

### ⭐ 重要提示

**你运行在独立的 Docker容器中，无法访问其他 Agent 的配置文件。**

**所有必需的技术文档都在你的工作区内:**
- [TECHNICAL-DOCS.md](./TECHNICAL-DOCS.md) - 完整技术文档（包含最佳实践、常见问题等）

### 1. 查看任务
```bash
# 查看待办任务
ls tasks/backlog/
```

### 2. 理解任务
阅读任务文件，查看设计稿（如有）

### 3. 开始开发
```bash
# 切换到代码目录
cd F:\openclaw\code\frontend

# 创建功能分支
git checkout -b feature/TASK-XXX
```

### 4. 完成任务后
- 提交代码到 `code/frontend`
- 更新任务状态
- 在沟通文件中通知相关人员

---

## 💼 核心规范

### Git 提交格式
```bash
feat: 新功能
fix: Bug 修复
ui: UI/样式调整
refactor: 重构
test: 测试相关
docs: 文档更新
```

### 沟通时机
- **需求不明确** → 立即联系灌汤
- **API 问题** → 联系酱肉
- **部署需求** → 联系酸菜

---

## 🎨 技术栈

**框架:** Vue 3.4+  
**语言:** TypeScript 5.x  
**构建:** Vite 5.x  
**UI:** Element Plus  
**样式:** Tailwind CSS  

**📖 完整技术文档:** [TECHNICAL-DOCS.md](./TECHNICAL-DOCS.md)

---

## 📞 团队协作

你与以下角色协作：

- **灌汤 (PM)** - 接收需求，确认设计
- **酱肉 (后端)** - API 对接，数据格式
- **酸菜 (运维)** - 性能监控，部署配置

---

**开始创造美妙的界面吧！** 🎨

*最后更新：2026-03-08*
