# 路由设计文档

## 已实现的路由（标记 ✅）

- / - 首页 ✅ (对应组件: views/Home.vue)
- /login - 登录页 ✅ (对应组件: views/Login.vue)
- /register - 注册页 ✅ (对应组件: views/Register.vue)
- /articles - 文章列表页 ✅ (对应组件: views/Articles.vue)
- /article/:id - 文章详情页 ✅ (对应组件: views/ArticleDetail.vue)
- /article/new - 发布文章页 ✅ (对应组件: views/ArticleCreate.vue)
- /article/edit/:id - 文章编辑页 ✅ (对应组件: views/ArticleEdit.vue)
- /:pathMatch(.*)* - 404页面 ✅ (对应组件: views/NotFound.vue)

## 未实现的路由（标记 ⏳）

- /category - 分类页 ⏳
- /tag - 标签页 ⏳
- /admin - 管理后台 ⏳
- /profile - 个人中心 ⏳