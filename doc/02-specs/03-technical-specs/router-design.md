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
| `/category/:id` | CategoryView.vue | Category | ❌ | 分类页（Plan-04 新增） |

## 路由守卫

```ts
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token')
  const requiresAuth = ['ArticleCreate', 'ArticleEdit'].includes(to.name as string)
  
  if (requiresAuth && !token) {
    next('/login')
  } else {
    next()
  }
})
```

## 未实现路由（已移除）
- ~~`/about`~~ - 关于页（暂未实现）
- ~~`/admin/*`~~ - 管理后台（暂未实现）