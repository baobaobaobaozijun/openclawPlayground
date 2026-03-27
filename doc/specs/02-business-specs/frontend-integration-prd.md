<!-- Last Modified: 2026-03-27 23:00 -->

# PRD — 前端功能整合方案

**版本:** 1.0  
**创建时间:** 2026-03-27 23:00  
**负责人:** 灌汤 (PM)  
**执行:** 豆沙 (前端)

---

## 📊 当前问题

**现状：** 7 个独立页面，缺乏统一导航和布局

- 页面分散，用户找不到功能入口
- 无统一 Layout 和 NavBar
- 登录/注册路由未配置
- 缺少评论区和计划创建模块

---

## 🎯 目标架构 — 5 大模块

```
博客系统
├── 1. 登录注册模块
│   ├── 登录页 /login
│   ├── 注册页 /register
│   └── 用户中心 /user-center
│
├── 2. 文章模块
│   ├── 首页（文章列表） /
│   ├── 文章详情 /article/:id
│   ├── 分类页 /categories
│   ├── 标签页 /tags
│   └── 文章编辑 /article/edit
│
├── 3. 评论区模块
│   └── 集成在文章详情页（组件）
│
├── 4. Agent 状态模块
│   ├── Agent 状态看板 /agents
│   └── 集成在首页侧边栏（组件）
│
└── 5. 计划创建模块
    ├── 计划列表 /plans
    ├── 计划创建 /plans/create
    └── 计划详情 /plans/:id
```

---

## 📐 页面结构

### 统一布局 (Layout)

```
+--------------------------------------------------+
|                    NavBar                         |
|  [Logo] [首页] [分类] [标签] [计划] [Agent] [用户]  |
+--------------------------------------------------+
|                                                  |
|  +--------------------------------------------+  |
|  |                                            |  |
|  |              Main Content                  |  |
|  |                                            |  |
|  +--------------------------------------------+  |
|                                                  |
+--------------------------------------------------+
|                    Footer                         |
+--------------------------------------------------+
```

---

## 📋 功能清单

### 1. 登录注册模块

| 页面 | 路由 | 组件 | 功能 |
|------|------|------|------|
| 登录 | `/login` | LoginView | 用户名/密码登录，JWT 存储 |
| 注册 | `/register` | RegisterView | 用户注册，邮箱验证 |
| 用户中心 | `/user-center` | UserCenter | 个人资料、我的文章、设置 |

**NavBar 集成：**
- 未登录：显示 [登录] [注册] 按钮
- 已登录：显示用户头像下拉菜单（个人中心/退出登录）

---

### 2. 文章模块

| 页面 | 路由 | 组件 | 功能 |
|------|------|------|------|
| 首页 | `/` | ArticlesView | 文章卡片列表，分页 |
| 详情 | `/article/:id` | ArticleDetail | 文章全文、评论、相关推荐 |
| 分类 | `/categories` | CategoryView | 分类浏览 |
| 标签 | `/tags` | TagView/TagCloud | 标签浏览 |
| 编辑 | `/article/edit/:id?` | ArticleEdit | 创建/编辑文章（Markdown 编辑器） |

**ArticleDetail 集成：**
- 文章正文（Markdown 渲染）
- 评论区（CommentList + CommentForm）
- 相关文章推荐

---

### 3. 评论区模块

**组件：** `src/components/CommentList.vue`, `src/components/CommentForm.vue`

**功能：**
- 评论列表（嵌套回复）
- 发表评论（登录后可用）
- 点赞/举报
- 时间显示（相对时间：2 小时前）

**API：**
- GET `/api/comments?articleId={id}` - 获取评论列表
- POST `/api/comments` - 发表评论
- DELETE `/api/comments/{id}` - 删除评论

---

### 4. Agent 状态模块

**页面：** `/agents` → AgentStatusView

**首页侧边栏集成：**
- 显示 4 个 Agent 状态（在线/离线/忙碌）
- 显示当前任务进度
- 点击跳转到 `/agents` 详情页

**组件：** `src/components/AgentStatusCard.vue`

---

### 5. 计划创建模块

| 页面 | 路由 | 组件 | 功能 |
|------|------|------|------|
| 计划列表 | `/plans` | PlanList | 查看所有计划，状态筛选 |
| 计划创建 | `/plans/create` | PlanCreate | 创建新计划（表单） |
| 计划详情 | `/plans/:id` | PlanDetail | 计划详情、轮次记录、复盘报告 |

**组件：**
- `src/views/plans/PlanList.vue`
- `src/views/plans/PlanCreate.vue`
- `src/views/plans/PlanDetail.vue`

**API：**
- GET `/api/plans` - 获取计划列表
- POST `/api/plans` - 创建计划
- GET `/api/plans/{id}` - 获取计划详情

---

## 🔧 技术实现

### 1. 统一 Layout

**文件：** `src/layouts/MainLayout.vue`

```vue
<template>
  <div class="main-layout">
    <NavBar />
    <main class="content">
      <router-view />
    </main>
    <Footer />
  </div>
</template>
```

### 2. 路由配置

**文件：** `src/router/index.ts`

```typescript
const routes = [
  // 登录注册
  { path: '/login', name: 'Login', component: LoginView },
  { path: '/register', name: 'Register', component: RegisterView },
  
  // 文章
  { path: '/', name: 'Home', component: ArticlesView },
  { path: '/article/:id', name: 'ArticleDetail', component: ArticleDetail },
  { path: '/categories', name: 'Categories', component: CategoryView },
  { path: '/tags', name: 'Tags', component: TagView },
  { path: '/article/edit/:id?', name: 'ArticleEdit', component: ArticleEdit },
  
  // 用户中心
  { path: '/user-center', name: 'UserCenter', component: UserCenter },
  
  // Agent 状态
  { path: '/agents', name: 'AgentStatus', component: AgentStatusView },
  
  // 计划
  { path: '/plans', name: 'PlanList', component: PlanList },
  { path: '/plans/create', name: 'PlanCreate', component: PlanCreate },
  { path: '/plans/:id', name: 'PlanDetail', component: PlanDetail },
]
```

### 3. 导航守卫

**文件：** `src/router/index.ts`

```typescript
// 需要登录的页面
const authRequired = ['/user-center', '/article/edit', '/plans/create']

router.beforeEach((to, from, next) => {
  const isAuthenticated = localStorage.getItem('token')
  if (authRequired.includes(to.path) && !isAuthenticated) {
    next('/login')
  } else {
    next()
  }
})
```

---

## ✅ 验收标准

### 布局与导航
- [ ] 统一 Layout 应用到所有页面
- [ ] NavBar 显示正确（Logo + 导航菜单 + 用户菜单）
- [ ] 响应式布局（移动端汉堡菜单）

### 路由配置
- [ ] 所有页面对应正确路由
- [ ] 登录/注册路由可访问
- [ ] 需要登录的页面有导航守卫

### 模块功能
- [ ] 文章详情页集成评论区
- [ ] 首页侧边栏显示 Agent 状态
- [ ] 计划列表/创建/详情页面完成

### 用户体验
- [ ] 页面加载有 Loading 状态
- [ ] 错误有友好提示（404/500）
- [ ] 移动端适配正常

---

## 📦 交付物清单

| 类型 | 文件 | 说明 |
|------|------|------|
| Layout | `src/layouts/MainLayout.vue` | 统一布局 |
| 组件 | `src/components/NavBar.vue` | 导航栏 |
| 组件 | `src/components/Footer.vue` | 页脚 |
| 组件 | `src/components/CommentList.vue` | 评论列表 |
| 组件 | `src/components/CommentForm.vue` | 评论表单 |
| 组件 | `src/components/AgentStatusCard.vue` | Agent 状态卡片 |
| 页面 | `src/views/plans/PlanList.vue` | 计划列表 |
| 页面 | `src/views/plans/PlanCreate.vue` | 计划创建 |
| 页面 | `src/views/plans/PlanDetail.vue` | 计划详情 |
| 配置 | `src/router/index.ts` | 路由配置更新 |

---

## ⏱️ 时间规划

| 阶段 | 内容 | 预计时间 |
|------|------|---------|
| 阶段 1 | Layout + NavBar + 路由配置 | 2 小时 |
| 阶段 2 | 评论区模块 | 2 小时 |
| 阶段 3 | Agent 状态侧边栏 | 1 小时 |
| 阶段 4 | 计划管理模块 | 3 小时 |
| 阶段 5 | 联调测试 + 优化 | 2 小时 |

**总计：** 10 小时

---

*PRD v1.0 | 包子铺博客系统 | 灌汤 PM*
