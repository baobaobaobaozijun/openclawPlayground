# 前端组件文档

## 现有组件

### App.vue - 应用根组件
- 路径：`/`
- 功能：应用布局、路由管理、全局状态管理
- API：无

### HomeView.vue - 首页
- 路径：`/`
- 功能：博客首页展示、最新文章列表
- API：GET /api/articles?limit=10

### ArticleList.vue - 文章列表组件
- 路径：组件（嵌入首页）
- 功能：文章列表展示、分页
- API：GET /api/articles

### ArticleDetail.vue - 文章详情页
- 路径：`/article/:id`
- 功能：文章详情展示、评论区
- API：GET /api/articles/:id

### LoginView.vue - 登录页
- 路径：`/login`
- 功能：用户登录、权限验证
- API：POST /api/auth/login

### RegisterView.vue - 注册页
- 路径：`/register`
- 功能：用户注册
- API：POST /api/users

## 新增组件 (2026-03-27)

### CategoryView.vue - 分类管理页
- 路径：`/categories`
- 功能：分类列表展示、编辑、删除
- API：GET/POST/PUT/DELETE /api/categories

### TagView.vue - 标签管理页
- 路径：`/tags`
- 功能：标签列表展示、删除
- API：GET/POST/DELETE /api/tags

### AgentStatus.vue - Agent 状态组件
- 路径：组件（嵌入首页）
- 功能：显示 4 个 Agent 实时状态
- API：GET /api/agent/status
- 轮询：30s 间隔