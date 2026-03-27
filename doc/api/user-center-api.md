# 用户中心 API 接口

## 1. 获取用户信息
GET /api/auth/profile
Header: Authorization: Bearer {token}
Response 200:
{
  "id": 1,
  "username": "admin",
  "email": "admin@example.com",
  "avatar": "https://...",
  "bio": "个人简介",
  "createTime": "2026-03-27T10:00:00"
}

## 2. 更新用户信息
PUT /api/auth/profile
Header: Authorization: Bearer {token}
Body:
{
  "email": "new@example.com",
  "avatar": "https://...",
  "bio": "新的个人简介"
}
Response 200: 更新后的用户信息

## 3. 获取用户文章列表
GET /api/articles?authorId={userId}&pageNum=1&pageSize=10
Response 200:
{
  "data": [...],
  "total": 10
}