# OpenClaw Frontend - 前端应用

🍡 **豆沙的前端代码仓库**

---

## 🚀 快速开始

### 环境要求
- Node.js 20.x+
- npm 10.x+

### 开发步骤

```bash
# 1. 克隆项目
cd F:\openclaw\code\frontend

# 2. 安装依赖
npm install

# 3. 启动开发服务器
npm run dev

# 4. 访问应用
# http://localhost:3000
```

---

## 📁 项目结构

```
frontend/
├── src/
│   ├── components/      # 可复用组件
│   ├── views/           # 页面视图
│   ├── composables/     # 组合式函数
│   ├── stores/          # Pinia 状态管理
│   ├── router/          # 路由配置
│   ├── api/             # API 接口
│   ├── utils/           # 工具函数
│   ├── styles/          # 样式文件
│   └── assets/          # 静态资源
├── public/              # 公共文件
├── index.html           # HTML 模板
├── package.json         # NPM 配置
├── vite.config.ts       # Vite 配置
├── tsconfig.json        # TypeScript 配置
└── tailwind.config.js   # Tailwind 配置
```

---

## 💻 技术栈

- **框架:** Vue 3.4+ (Composition API)
- **语言:** TypeScript 5.x
- **构建:** Vite 5.x
- **状态:** Pinia 2.x
- **UI:** Element Plus
- **样式:** Tailwind CSS

---

## 📋 开发规范

### Git 工作流
```bash
# 创建功能分支
git checkout -b feature/TASK-XXX

# 提交代码
git commit -m "feat: 实现 XXX 页面"

# 推送代码
git push origin feature/TASK-XXX
```

### 代码规范
- 使用 Composition API（`<script setup>`）
- 组件名使用 PascalCase
- 文件名与组件名一致
- Props 必须定义类型
- 使用 ESLint + Prettier

---

## 🧪 测试

```bash
# 运行单元测试
npm run test:unit

# 运行 E2E 测试
npm run test:e2e

# 生成覆盖率报告
npm run test:unit -- --coverage
```

---

## 🐳 Docker 部署

```bash
# 构建镜像
docker build -t openclaw-frontend .

# 运行容器
docker run -p 80:80 openclaw-frontend
```

---

## 🎨 设计资源

- [UI 设计规范](../../workspace-guantang/agent-configs/dousha/README.md)
- [最佳实践](../../workspace-guantang/agent-configs/dousha/README.md)

---

*维护者：豆沙Agent*
