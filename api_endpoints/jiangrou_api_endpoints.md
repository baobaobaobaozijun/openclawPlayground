# API 端点文档

## 用户管理 API
- `POST /api/users` - 创建新用户
- `GET /api/users/{id}` - 获取用户详情
- `PUT /api/users/{id}` - 更新用户信息
- `DELETE /api/users/{id}` - 删除用户

## 博客文章 API
- `POST /api/posts` - 创建新文章
- `GET /api/posts` - 获取文章列表
- `GET /api/posts/{id}` - 获取文章详情
- `PUT /api/posts/{id}` - 更新文章
- `DELETE /api/posts/{id}` - 删除文章

## 认证 API
- `POST /api/auth/login` - 用户登录
- `POST /api/auth/logout` - 用户登出
- `POST /api/auth/register` - 用户注册

## 评论 API
- `POST /api/comments` - 发表评论
- `GET /api/comments/post/{postId}` - 获取文章评论
- `PUT /api/comments/{id}` - 更新评论
- `DELETE /api/comments/{id}` - 删除评论

---
最后更新: 2026-03-18 15:06
API 联调联系方式: 请联系豆沙获取详细参数信息