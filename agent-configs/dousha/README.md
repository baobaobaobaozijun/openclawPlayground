# OpenClaw Frontend - 前端应用

🍡 **由豆沙Agent 负责的前端业务代码仓库**

---

## 🏠 关于本项目

这是 OpenClaw 项目的**前端业务代码仓库**，包含所有用户界面代码。

**注意：** 如果你要找的是豆沙Agent 的配置文档，请访问：https://github.com/baobaobaobaozijun/openclawPlayground/tree/main/workspace-programmer/dousha

---

## 📁 项目结构

```
openclaw-frontend/
├── README.md              # 本文件
├── package.json           # Node.js 依赖
├── .gitignore            # Git 忽略配置
│
├── src/                  # 源代码目录（待创建）
│   ├── components/       # Vue/React组件
│   │   ├── common/
│   │   ├── layout/
│   │   └── business/
│   │
│   ├── pages/            # 页面
│   │   ├── Home.vue
│   │   ├── Article.vue
│   │   └── Login.vue
│   │
│   ├── styles/           # 样式文件
│   │   ├── variables.scss
│   │   ├── global.scss
│   │   └── components.scss
│   │
│   ├── router/           # 路由配置
│   │   └── index.js
│   │
│   ├── store/            # 状态管理
│   │   └── index.js
│   │
│   └── utils/            # 工具函数
│       ├── request.js
│       └── helpers.js
│
├── public/               # 静态资源
│   └── favicon.ico
│
└── docs/                 # 设计文档（待创建）
    ├── design-system.md
    └── guidelines.md
```

---

## 🚀 快速开始

### 1. 环境要求

- Node.js 18+
- npm 9+ / yarn 1.22+

### 2. 安装依赖

```bash
npm install
# 或
yarn install
```

### 3. 启动开发服务器

```bash
# 开发模式
npm run dev
# 或
yarn dev

# 访问 http://localhost:3000
```

### 4. 构建生产版本

```bash
npm run build
# 或
yarn build
```

---

## 👩‍💻 负责人

**主要开发者:** 🍡 豆沙Agent  
**角色:** UI/UX设计师 / 前端工程师

查看豆沙的配置文档：https://github.com/baobaobaobaozijun/openclawPlayground

---

## 🎨 技术栈

- **框架:** Vue 3 / React 18 (待定)
- **UI 库:** Element Plus / Ant Design
- **状态管理:** Pinia / Redux
- **路由:** Vue Router / React Router
- **样式:** SCSS / Tailwind CSS
- **构建工具:** Vite / Webpack

---

## 📊 开发进度

- [ ] 项目初始化
- [ ] 设计系统建立
- [ ] 基础组件开发
- [ ] 首页开发
- [ ] 登录/注册页面
- [ ] 文章列表页
- [ ] 文章详情页
- [ ] 响应式适配
- [ ] 性能优化
- [ ] 单元测试

---

## 🔗 相关仓库

| 仓库 | 用途 |
|------|------|
| [openclawPlayground](https://github.com/baobaobaobaozijun/openclawPlayground) | Agent 配置文档中心 |
| [openclaw-backend](https://github.com/baobaobaobaozijun/openclaw-backend) | 后端业务代码 |
| [openclaw-devops](https://github.com/baobaobaobaozijun/openclaw-devops) | 运维测试脚本 |

---

**开始创造美妙的用户体验吧！** ✨
