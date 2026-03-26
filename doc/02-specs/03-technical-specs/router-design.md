# 路由设计（实际实现）

**路由模式:** Vue Router 4 + History Mode

## 路由表

| 路径 | 组件 | 名称 | 需要认证 | 说明 |
|------|------|------|---------|------|
| `/` | Home.vue | Home | ❌ | 首页（文章列表） |
| `/login` | Login.vue | Login | ❌ | 登录页 |
| `/register` | Register.vue | Register | ❌ | 注册页 |
| `/articles` | Articles.vue | Articles | ❌ | 文章列表页 |
| `/article/:id` | ArticleDetail.vue | ArticleDetail | ❌ | 文章详情页 |
| `/article/new` | ArticleCreate.vue | ArticleCreate | ✅ | 创建文章 |
| `/article/edit/:id` | ArticleEdit.vue | ArticleEdit | ✅ | 编辑文章 |
| `/:pathMatch(.*)*` | NotFound.vue | NotFound | ❌ | 页面未找到 |

## 路由守卫

```ts
router.beforeEach((to, from, next) => {
  const title = (to.meta.title as string) || 'OpenClaw Blog'
  document.title = title
  
  const token = localStorage.getItem('token')
  
  // 检查是否需要认证
  if (to.meta.requiresAuth && !token) {
    next('/login')
  } 
  // 已登录用户访问登录或注册页面，重定向到首页
  else if (token && (to.path === '/login' || to.path === '/register')) {
    next('/')
  }
  // 其他情况正常通行
  else {
    next()
  }
})
```

## 已移除路由
- ~~`/about`~~ - 关于页（未实现）
- ~~`/admin/*`~~ - 管理后台（未实现）
- ~~`/category/:id`~~ - 分类页（未实现）