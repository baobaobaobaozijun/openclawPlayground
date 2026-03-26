# 前端组件树（实际实现）

**技术栈:** Vue 3.3 + TypeScript + Vite 5 + Pinia + Vue Router 4

## 目录结构
```
src/
├── components/
│   ├── ArticleCard.vue      # 文章卡片组件
│   ├── TagCloud.vue         # 标签云组件（Plan-04 新增）
│   └── AgentStatus.vue      # Agent 状态组件（Plan-03 新增）
├── views/
│   ├── Home.vue             # 首页
│   ├── Login.vue            # 登录页
│   ├── Register.vue         # 注册页
│   ├── Articles.vue         # 文章列表页
│   ├── ArticleDetail.vue    # 文章详情页
│   ├── ArticleCreate.vue    # 创建文章页
│   ├── ArticleEdit.vue      # 编辑文章页
│   └── CategoryView.vue     # 分类页（Plan-04 新增）
├── stores/
│   ├── auth.ts              # 认证状态管理
│   └── article.ts           # 文章状态管理
├── api/
│   ├── auth.ts              # 认证 API
│   ├── article.ts           # 文章 API
│   └── agent.ts             # Agent 状态 API（Plan-03 新增）
├── router/
│   └── index.ts             # 路由配置
└── utils/
    └── request.ts           # Axios 封装
```

## 组件说明

### ArticleCard.vue
- **用途:** 文章列表项展示
- **Props:** article (id, title, summary, author, publishedAt)
- **依赖:** 无

### TagCloud.vue (Plan-04)
- **用途:** 标签云展示
- **API:** GET /api/tags
- **依赖:** request.ts

### AgentStatus.vue (Plan-03)
- **用途:** Agent 实时状态展示
- **API:** GET /api/agent/status (30s 轮询)
- **依赖:** request.ts

### CategoryView.vue (Plan-04)
- **用途:** 分类列表页面
- **API:** GET /api/categories
- **依赖:** request.ts, router