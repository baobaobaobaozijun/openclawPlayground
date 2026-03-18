# API 接口文档

## 用户管理模块

### 1. 用户注册
- **接口地址**: `POST /api/v1/users/register`
- **请求参数**:
  ```json
  {
    "username": "string",
    "email": "string",
    "password": "string"
  }
  ```
- **响应格式**:
  ```json
  {
    "code": 200,
    "message": "success",
    "data": {
      "userId": "string",
      "username": "string",
      "email": "string",
      "createdAt": "timestamp"
    }
  }
  ```
- **错误码**:
  - 400: 参数错误
  - 409: 用户名或邮箱已存在
  - 500: 服务器内部错误

### 2. 用户登录
- **接口地址**: `POST /api/v1/users/login`
- **请求参数**:
  ```json
  {
    "username": "string",
    "password": "string"
  }
  ```
- **响应格式**:
  ```json
  {
    "code": 200,
    "message": "success",
    "data": {
      "token": "string",
      "userInfo": {
        "userId": "string",
        "username": "string",
        "email": "string"
      }
    }
  }
  ```
- **错误码**:
  - 400: 参数错误
  - 401: 用户名或密码错误
  - 500: 服务器内部错误

## 博客文章模块

### 3. 创建文章
- **接口地址**: `POST /api/v1/posts`
- **请求头**: `Authorization: Bearer {token}`
- **请求参数**:
  ```json
  {
    "title": "string",
    "content": "string",
    "summary": "string",
    "tags": ["string"],
    "category": "string",
    "published": "boolean"
  }
  ```
- **响应格式**:
  ```json
  {
    "code": 200,
    "message": "success",
    "data": {
      "postId": "string",
      "title": "string",
      "content": "string",
      "summary": "string",
      "tags": ["string"],
      "category": "string",
      "published": "boolean",
      "authorId": "string",
      "createdAt": "timestamp",
      "updatedAt": "timestamp"
    }
  }
  ```
- **错误码**:
  - 400: 参数错误
  - 401: 未授权访问
  - 403: 权限不足
  - 500: 服务器内部错误

### 4. 获取文章列表
- **接口地址**: `GET /api/v1/posts`
- **查询参数**:
  - page: 页码 (默认 1)
  - size: 每页数量 (默认 10)
  - category: 分类
  - tag: 标签
  - author: 作者ID
  - published: 是否已发布 (默认 true)
- **响应格式**:
  ```json
  {
    "code": 200,
    "message": "success",
    "data": {
      "total": "number",
      "page": "number",
      "size": "number",
      "posts": [
        {
          "postId": "string",
          "title": "string",
          "summary": "string",
          "tags": ["string"],
          "category": "string",
          "authorId": "string",
          "published": "boolean",
          "viewCount": "number",
          "likeCount": "number",
          "commentCount": "number",
          "createdAt": "timestamp",
          "updatedAt": "timestamp"
        }
      ]
    }
  }
  ```
- **错误码**:
  - 400: 参数错误
  - 500: 服务器内部错误

### 5. 获取单篇文章
- **接口地址**: `GET /api/v1/posts/{postId}`
- **路径参数**:
  - postId: 文章ID
- **响应格式**:
  ```json
  {
    "code": 200,
    "message": "success",
    "data": {
      "postId": "string",
      "title": "string",
      "content": "string",
      "summary": "string",
      "tags": ["string"],
      "category": "string",
      "authorId": "string",
      "published": "boolean",
      "viewCount": "number",
      "likeCount": "number",
      "commentCount": "number",
      "createdAt": "timestamp",
      "updatedAt": "timestamp"
    }
  }
  ```
- **错误码**:
  - 404: 文章不存在
  - 500: 服务器内部错误

### 6. 更新文章
- **接口地址**: `PUT /api/v1/posts/{postId}`
- **请求头**: `Authorization: Bearer {token}`
- **路径参数**:
  - postId: 文章ID
- **请求参数**:
  ```json
  {
    "title": "string",
    "content": "string",
    "summary": "string",
    "tags": ["string"],
    "category": "string",
    "published": "boolean"
  }
  ```
- **响应格式**:
  ```json
  {
    "code": 200,
    "message": "success",
    "data": {
      "postId": "string",
      "title": "string",
      "content": "string",
      "summary": "string",
      "tags": ["string"],
      "category": "string",
      "published": "boolean",
      "authorId": "string",
      "updatedAt": "timestamp"
    }
  }
  ```
- **错误码**:
  - 400: 参数错误
  - 401: 未授权访问
  - 403: 权限不足
  - 404: 文章不存在
  - 500: 服务器内部错误

### 7. 删除文章
- **接口地址**: `DELETE /api/v1/posts/{postId}`
- **请求头**: `Authorization: Bearer {token}`
- **路径参数**:
  - postId: 文章ID
- **响应格式**:
  ```json
  {
    "code": 200,
    "message": "success",
    "data": null
  }
  ```
- **错误码**:
  - 401: 未授权访问
  - 403: 权限不足
  - 404: 文章不存在
  - 500: 服务器内部错误

## 评论模块

### 8. 创建评论
- **接口地址**: `POST /api/v1/comments`
- **请求头**: `Authorization: Bearer {token}`
- **请求参数**:
  ```json
  {
    "postId": "string",
    "content": "string",
    "parentId": "string"  // 可选，用于回复评论
  }
  ```
- **响应格式**:
  ```json
  {
    "code": 200,
    "message": "success",
    "data": {
      "commentId": "string",
      "postId": "string",
      "content": "string",
      "parentId": "string",
      "authorId": "string",
      "createdAt": "timestamp",
      "updatedAt": "timestamp"
    }
  }
  ```
- **错误码**:
  - 400: 参数错误
  - 401: 未授权访问
  - 404: 文章或父评论不存在
  - 500: 服务器内部错误

### 9. 获取文章评论列表
- **接口地址**: `GET /api/v1/comments/post/{postId}`
- **路径参数**:
  - postId: 文章ID
- **查询参数**:
  - page: 页码 (默认 1)
  - size: 每页数量 (默认 10)
  - sort: 排序方式 (created_at_asc, created_at_desc, likes_desc)
- **响应格式**:
  ```json
  {
    "code": 200,
    "message": "success",
    "data": {
      "total": "number",
      "page": "number",
      "size": "number",
      "comments": [
        {
          "commentId": "string",
          "postId": "string",
          "content": "string",
          "parentId": "string",
          "authorId": "string",
          "likeCount": "number",
          "replyCount": "number",
          "createdAt": "timestamp",
          "updatedAt": "timestamp"
        }
      ]
    }
  }
  ```
- **错误码**:
  - 400: 参数错误
  - 404: 文章不存在
  - 500: 服务器内部错误

## 点赞模块

### 10. 点赞/取消点赞文章
- **接口地址**: `POST /api/v1/likes/post/{postId}`
- **请求头**: `Authorization: Bearer {token}`
- **路径参数**:
  - postId: 文章ID
- **请求参数**:
  ```json
  {
    "action": "like"  // "like" 或 "unlike"
  }
  ```
- **响应格式**:
  ```json
  {
    "code": 200,
    "message": "success",
    "data": {
      "postId": "string",
      "liked": "boolean",
      "likeCount": "number"
    }
  }
  ```
- **错误码**:
  - 400: 参数错误
  - 401: 未授权访问
  - 404: 文章不存在
  - 500: 服务器内部错误

## 标签模块

### 11. 获取热门标签
- **接口地址**: `GET /api/v1/tags/hot`
- **查询参数**:
  - limit: 返回数量限制 (默认 10)
- **响应格式**:
  ```json
  {
    "code": 200,
    "message": "success",
    "data": [
      {
        "tagName": "string",
        "usageCount": "number"
      }
    ]
  }
  ```
- **错误码**:
  - 400: 参数错误
  - 500: 服务器内部错误

### 12. 创建标签
- **接口地址**: `POST /api/v1/tags`
- **请求头**: `Authorization: Bearer {token}`
- **请求参数**:
  ```json
  {
    "tagName": "string"
  }
  ```
- **响应格式**:
  ```json
  {
    "code": 200,
    "message": "success",
    "data": {
      "tagId": "string",
      "tagName": "string",
      "createdAt": "timestamp"
    }
  }
  ```
- **错误码**:
  - 400: 参数错误
  - 401: 未授权访问
  - 403: 权限不足
  - 409: 标签已存在
  - 500: 服务器内部错误

## 分类模块

### 13. 获取所有分类
- **接口地址**: `GET /api/v1/categories`
- **响应格式**:
  ```json
  {
    "code": 200,
    "message": "success",
    "data": [
      {
        "categoryId": "string",
        "categoryName": "string",
        "description": "string",
        "postCount": "number",
        "createdAt": "timestamp"
      }
    ]
  }
  ```
- **错误码**:
  - 500: 服务器内部错误

### 14. 创建分类
- **接口地址**: `POST /api/v1/categories`
- **请求头**: `Authorization: Bearer {token}`
- **请求参数**:
  ```json
  {
    "categoryName": "string",
    "description": "string"
  }
  ```
- **响应格式**:
  ```json
  {
    "code": 200,
    "message": "success",
    "data": {
      "categoryId": "string",
      "categoryName": "string",
      "description": "string",
      "createdAt": "timestamp"
    }
  }
  ```
- **错误码**:
  - 400: 参数错误
  - 401: 未授权访问
  - 403: 权限不足
  - 409: 分类已存在
  - 500: 服务器内部错误

## 全局错误码

| 错误码 | 描述 |
|--------|------|
| 200 | 成功 |
| 400 | 请求参数错误 |
| 401 | 未授权访问 |
| 403 | 权限不足 |
| 404 | 资源不存在 |
| 409 | 资源冲突（如用户名已存在） |
| 500 | 服务器内部错误 |

## 认证说明

大部分接口需要认证，请求头中需要添加：
```
Authorization: Bearer {access_token}
```

登录成功后会返回 access_token，有效期为 2 小时。