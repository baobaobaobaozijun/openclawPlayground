# 前端组件树（实际实现）

**技术栈:** Vue 3.4 + TypeScript 5.x + Vite 5.x + Pinia + Vue Router 4

## 目录结构
```
F:\openclaw\code\frontend\src\
├── components/
│   ├── ArticleList.vue      # 文章列表组件
│   ├── ArticleDetail.vue    # 文章详情组件
│   ├── ArticleEdit.vue      # 文章编辑组件
│   └── AgentStatus.vue      # Agent 状态组件（待创建）
├── views/
│   ├── Home.vue             # 首页
│   ├── Login.vue            # 登录页
│   ├── Register.vue         # 注册页
│   └── CategoryView.vue     # 分类页（待创建）
├── api/
│   ├── auth.ts              # 认证 API
│   ├── article.ts           # 文章 API
│   └── request.ts           # Axios 封装
└── router/
    └── index.ts             # 路由配置
```

## 组件说明

### ArticleList.vue
- **用途:** 文章列表展示
- **Props:** 无
- **API:** GET /api/articles
- **依赖:** request.ts, router

### ArticleDetail.vue
- **用途:** 文章详情展示
- **Props:** articleId
- **API:** GET /api/article/{id}
- **依赖:** request.ts, router

### ArticleEdit.vue
- **用途:** 文章编辑组件
- **Props:** articleId
- **API:** PUT /api/article/{id}
- **依赖:** request.ts, router

### AgentStatus.vue (待创建)
- **用途:** Agent 状态展示
- **Props:** 无
- **API:** GET /api/agent/status
- **依赖:** request.ts

### CategoryView.vue (待创建)
- **用途:** 分类视图页面
- **Props:** categoryId
- **API:** GET /api/categories/{id}
- **依赖:** request.ts, router

## 路由配置 (基于 src/router/index.ts)
- `/` → Home.vue
- `/login` → Login.vue
- `/register` → Register.vue
- `/articles` → Articles.vue
- `/article/:id` → ArticleDetail.vue
- `/article/new` → ArticleCreate.vue (requiresAuth: true)
- `/article/edit/:id` → ArticleEdit.vue (requiresAuth: true)
- `/:pathMatch(.*)*` → NotFound.vue