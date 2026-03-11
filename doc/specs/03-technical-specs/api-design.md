<!-- Last Modified: 2026-03-12 -->

# 包子铺博客系统 - API 接口设计文档

**文档类型:** 技术规范  
**版本:** v1.0  
**创建日期:** 2026-03-12  
**负责人:** 酱肉 (后端)  
**审核:** 灌汤 (PM)

---

## 📋 API 概览

**基础 URL:** `/api`  
**API 版本:** v1  
**数据格式:** JSON  
**字符编码:** UTF-8

---

## 🔐 认证机制

### JWT Token 认证

**请求头:**
```
Authorization: Bearer <token>
```

**Token 有效期:** 2 小时 (7200 秒)

**Token 刷新:** 登录时自动获取新 Token

---

## 📦 统一响应格式

### 成功响应

```json
{
  "code": 200,
  "message": "success",
  "data": { ... },
  "timestamp": 1710234567890
}
```

### 错误响应

```json
{
  "code": 400,
  "message": "参数错误",
  "errors": [
    {
      "field": "title",
      "message": "标题不能为空"
    }
  ],
  "timestamp": 1710234567890
}
```

### 分页响应

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "list": [ ... ],
    "pagination": {
      "page": 1,
      "size": 10,
      "total": 100,
      "totalPages": 10
    }
  },
  "timestamp": 1710234567890
}
```

---

## 🔢 错误码定义

| 错误码 | 说明 | HTTP 状态码 |
|--------|------|-------------|
| 200 | 成功 | 200 OK |
| 400 | 参数错误 | 400 Bad Request |
| 401 | 未认证 | 401 Unauthorized |
| 403 | 无权限 | 403 Forbidden |
| 404 | 资源不存在 | 404 Not Found |
| 500 | 服务器内部错误 | 500 Internal Server Error |

---

## 📚 API 接口详细设计

### 1. 用户认证模块

#### 1.1 手机号登录/注册

**接口:** `POST /api/auth/login`

**请求:**
```json
{
  "phone": "13800138000"
}
```

**响应 (成功):**
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": 7200,
    "user": {
      "id": 1,
      "username": "admin",
      "email": "admin@blog.com",
      "phone": "13800138000",
      "avatar": "https://...",
      "role": "ADMIN"
    }
  },
  "timestamp": 1710234567890
}
```

**响应 (失败 - 手机号格式错误):**
```json
{
  "code": 400,
  "message": "手机号格式错误",
  "errors": [
    {
      "field": "phone",
      "message": "请输入 11 位手机号"
    }
  ],
  "timestamp": 1710234567890
}
```

**业务逻辑:**
1. 验证手机号格式 `^1[3-9]\d{9}$`
2. 查询数据库是否存在该手机号
3. 已存在：生成 JWT Token，更新 last_login_at
4. 不存在：自动创建用户，生成 JWT Token

---

#### 1.2 获取当前用户信息

**接口:** `GET /api/auth/me`

**请求头:**
```
Authorization: Bearer <token>
```

**响应:**
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": 1,
    "username": "admin",
    "email": "admin@blog.com",
    "phone": "13800138000",
    "avatar": "https://...",
    "role": "ADMIN",
    "status": 1,
    "lastLoginAt": "2026-03-12T01:00:00Z",
    "createdAt": "2026-03-01T00:00:00Z"
  },
  "timestamp": 1710234567890
}
```

---

#### 1.3 退出登录

**接口:** `POST /api/auth/logout`

**请求头:**
```
Authorization: Bearer <token>
```

**响应:**
```json
{
  "code": 200,
  "message": "退出成功",
  "data": null,
  "timestamp": 1710234567890
}
```

---

### 2. 文章模块

#### 2.1 获取文章列表 (公开)

**接口:** `GET /api/articles`

**查询参数:**

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| page | int | ❌ | 1 | 页码 |
| size | int | ❌ | 10 | 每页数量 |
| categoryId | long | ❌ | - | 分类 ID 过滤 |
| tagId | long | ❌ | - | 标签 ID 过滤 |
| keyword | string | ❌ | - | 关键词搜索 |
| sortBy | string | ❌ | published_at | 排序字段 |
| sortOrder | string | ❌ | desc | 排序方式 (asc/desc) |

**请求示例:**
```
GET /api/articles?page=1&size=10&categoryId=1&sortBy=view_count&sortOrder=desc
```

**响应:**
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "list": [
      {
        "id": 1,
        "title": "Hello World",
        "slug": "hello-world",
        "summary": "这是我的第一篇文章",
        "coverImage": "https://...",
        "author": {
          "id": 1,
          "username": "admin",
          "avatar": "https://..."
        },
        "categories": [
          {
            "id": 1,
            "name": "技术文章",
            "slug": "tech"
          }
        ],
        "tags": [
          {
            "id": 1,
            "name": "Java",
            "slug": "java",
            "color": "#409EFF"
          }
        ],
        "viewCount": 100,
        "likeCount": 10,
        "commentCount": 5,
        "isTop": true,
        "isFeatured": true,
        "publishedAt": "2026-03-12T01:00:00Z",
        "createdAt": "2026-03-12T00:00:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "size": 10,
      "total": 100,
      "totalPages": 10
    }
  },
  "timestamp": 1710234567890
}
```

**业务逻辑:**
1. 只返回 `status=PUBLISHED` 且 `deleted_at IS NULL` 的文章
2. 根据 `access_level` 过滤 (0=公开，游客可看)
3. 支持多条件组合查询
4. 支持关联查询分类、标签、作者信息

---

#### 2.2 获取文章详情 (公开)

**接口:** `GET /api/articles/{id}`

**路径参数:**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| id | long | ✅ | 文章 ID |

**请求示例:**
```
GET /api/articles/1
```

**响应:**
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": 1,
    "title": "Hello World",
    "slug": "hello-world",
    "content": "# Hello World\n\n这是我的第一篇文章...",
    "contentHtml": "<h1>Hello World</h1><p>这是我的第一篇文章...</p>",
    "summary": "这是我的第一篇文章",
    "coverImage": "https://...",
    "author": {
      "id": 1,
      "username": "admin",
      "avatar": "https://...",
      "bio": "博客管理员"
    },
    "categories": [
      {
        "id": 1,
        "name": "技术文章",
        "slug": "tech"
      }
    ],
    "tags": [
      {
        "id": 1,
        "name": "Java",
        "slug": "java",
        "color": "#409EFF"
      }
    ],
    "viewCount": 101,
    "likeCount": 10,
    "commentCount": 5,
    "isTop": true,
    "isFeatured": true,
    "publishedAt": "2026-03-12T01:00:00Z",
    "createdAt": "2026-03-12T00:00:00Z",
    "updatedAt": "2026-03-12T01:00:00Z"
  },
  "timestamp": 1710234567890
}
```

**业务逻辑:**
1. 浏览量 +1 (异步更新，不影响响应时间)
2. 检查访问权限 (`access_level`)
3. 返回 HTML 渲染后的内容

---

#### 2.3 获取文章详情 (通过 Slug)

**接口:** `GET /api/articles/slug/{slug}`

**路径参数:**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| slug | string | ✅ | URL 友好别名 |

**请求示例:**
```
GET /api/articles/slug/hello-world
```

**响应:** 同 2.2

---

#### 2.4 创建文章 (需要认证)

**接口:** `POST /api/articles`

**请求头:**
```
Authorization: Bearer <token>
```

**请求体:**
```json
{
  "title": "Spring Boot 入门",
  "content": "# Spring Boot 入门\n\nSpring Boot 是一个...",
  "summary": "Spring Boot 入门教程",
  "coverImage": "https://...",
  "categoryIds": [1, 3],
  "tagIds": [1, 2],
  "accessLevel": 0,
  "isTop": false,
  "isFeatured": false
}
```

**响应:**
```json
{
  "code": 200,
  "message": "创建成功",
  "data": {
    "id": 2,
    "title": "Spring Boot 入门",
    "slug": "spring-boot-intro",
    "status": "DRAFT",
    "createdAt": "2026-03-12T02:00:00Z"
  },
  "timestamp": 1710234567890
}
```

**权限要求:**
- 需要登录 (`role=USER` 或 `role=ADMIN`)

**业务逻辑:**
1. 验证 Token
2. 自动生成 slug (基于 title)
3. 设置 `author_id` 为当前用户 ID
4. 设置 `status=DRAFT`
5. 关联分类和标签

---

#### 2.5 更新文章 (需要认证)

**接口:** `PUT /api/articles/{id}`

**请求头:**
```
Authorization: Bearer <token>
```

**请求体:**
```json
{
  "title": "Spring Boot 入门 (更新版)",
  "content": "# Spring Boot 入门\n\n更新后的内容...",
  "summary": "Spring Boot 入门教程 (更新版)",
  "coverImage": "https://...",
  "categoryIds": [1, 3],
  "tagIds": [1, 2],
  "accessLevel": 0,
  "isTop": false,
  "isFeatured": true,
  "status": "PUBLISHED"
}
```

**响应:**
```json
{
  "code": 200,
  "message": "更新成功",
  "data": {
    "id": 2,
    "title": "Spring Boot 入门 (更新版)",
    "updatedAt": "2026-03-12T03:00:00Z"
  },
  "timestamp": 1710234567890
}
```

**权限要求:**
- 需要登录
- 只能更新自己的文章 (或管理员)

**业务逻辑:**
1. 验证 Token
2. 检查权限 (作者或管理员)
3. 更新文章信息
4. 重新关联分类和标签 (先删除旧的，再插入新的)

---

#### 2.6 删除文章 (需要认证)

**接口:** `DELETE /api/articles/{id}`

**请求头:**
```
Authorization: Bearer <token>
```

**响应:**
```json
{
  "code": 200,
  "message": "删除成功",
  "data": null,
  "timestamp": 1710234567890
}
```

**权限要求:**
- 需要登录
- 只能删除自己的文章 (或管理员)

**业务逻辑:**
1. 验证 Token
2. 检查权限 (作者或管理员)
3. 软删除 (`deleted_at = NOW()`)

---

#### 2.7 发布文章 (需要认证)

**接口:** `POST /api/articles/{id}/publish`

**请求头:**
```
Authorization: Bearer <token>
```

**响应:**
```json
{
  "code": 200,
  "message": "发布成功",
  "data": {
    "id": 2,
    "status": "PUBLISHED",
    "publishedAt": "2026-03-12T04:00:00Z"
  },
  "timestamp": 1710234567890
}
```

**权限要求:**
- 需要登录
- 只能发布自己的文章 (或管理员)

**业务逻辑:**
1. 验证 Token
2. 检查权限
3. 设置 `status=PUBLISHED`
4. 设置 `published_at=NOW()`

---

### 3. 分类模块

#### 3.1 获取分类列表 (公开)

**接口:** `GET /api/categories`

**响应:**
```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "id": 1,
      "name": "技术文章",
      "slug": "tech",
      "description": "技术相关",
      "icon": "Folder",
      "parentId": null,
      "children": [
        {
          "id": 3,
          "name": "Java",
          "slug": "java",
          "description": "Java 技术",
          "icon": "Code",
          "parentId": 1,
          "children": []
        },
        {
          "id": 4,
          "name": "前端开发",
          "slug": "frontend",
          "description": "前端技术",
          "icon": "Monitor",
          "parentId": 1,
          "children": []
        }
      ],
      "articleCount": 10
    },
    {
      "id": 2,
      "name": "生活随笔",
      "slug": "life",
      "description": "生活感悟",
      "icon": "Document",
      "parentId": null,
      "children": [],
      "articleCount": 5
    }
  ],
  "timestamp": 1710234567890
}
```

**业务逻辑:**
1. 返回树形结构
2. 包含每个分类的文章数量

---

#### 3.2 创建分类 (需要认证 - 管理员)

**接口:** `POST /api/categories`

**请求头:**
```
Authorization: Bearer <token>
```

**请求体:**
```json
{
  "name": "Python",
  "slug": "python",
  "description": "Python 技术",
  "parentId": 1,
  "icon": "Code",
  "sortOrder": 3
}
```

**响应:**
```json
{
  "code": 200,
  "message": "创建成功",
  "data": {
    "id": 5,
    "name": "Python",
    "slug": "python"
  },
  "timestamp": 1710234567890
}
```

**权限要求:**
- 需要登录且 `role=ADMIN`

---

### 4. 标签模块

#### 4.1 获取标签列表 (公开)

**接口:** `GET /api/tags`

**响应:**
```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "id": 1,
      "name": "Java",
      "slug": "java",
      "color": "#409EFF",
      "articleCount": 10
    },
    {
      "id": 2,
      "name": "Spring Boot",
      "slug": "spring-boot",
      "color": "#67C23A",
      "articleCount": 5
    }
  ],
  "timestamp": 1710234567890
}
```

---

#### 4.2 创建标签 (需要认证 - 管理员)

**接口:** `POST /api/tags`

**请求头:**
```
Authorization: Bearer <token>
```

**请求体:**
```json
{
  "name": "TypeScript",
  "slug": "typescript",
  "color": "#3178C6"
}
```

**响应:**
```json
{
  "code": 200,
  "message": "创建成功",
  "data": {
    "id": 6,
    "name": "TypeScript",
    "slug": "typescript"
  },
  "timestamp": 1710234567890
}
```

**权限要求:**
- 需要登录且 `role=ADMIN`

---

### 5. 评论模块

#### 5.1 获取文章评论 (公开)

**接口:** `GET /api/articles/{articleId}/comments`

**路径参数:**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| articleId | long | ✅ | 文章 ID |

**查询参数:**

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| page | int | ❌ | 1 | 页码 |
| size | int | ❌ | 20 | 每页数量 |

**响应:**
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "list": [
      {
        "id": 1,
        "content": "写得很好！",
        "user": {
          "id": 2,
          "username": "user1",
          "avatar": "https://..."
        },
        "likeCount": 5,
        "replyCount": 1,
        "createdAt": "2026-03-12T02:00:00Z",
        "replies": [
          {
            "id": 2,
            "content": "谢谢支持！",
            "user": {
              "id": 1,
              "username": "admin",
              "avatar": "https://..."
            },
            "likeCount": 2,
            "createdAt": "2026-03-12T02:30:00Z"
          }
        ]
      }
    ],
    "pagination": {
      "page": 1,
      "size": 20,
      "total": 50,
      "totalPages": 3
    }
  },
  "timestamp": 1710234567890
}
```

**业务逻辑:**
1. 只返回 `status=APPROVED` 的评论
2. 嵌套回复 (最多 2 层)
3. 按创建时间倒序

---

#### 5.2 创建评论 (需要认证)

**接口:** `POST /api/articles/{articleId}/comments`

**请求头:**
```
Authorization: Bearer <token>
```

**请求体:**
```json
{
  "content": "写得很好！",
  "parentId": null
}
```

**响应:**
```json
{
  "code": 200,
  "message": "评论成功",
  "data": {
    "id": 3,
    "content": "写得很好！",
    "status": "PENDING",
    "createdAt": "2026-03-12T03:00:00Z"
  },
  "timestamp": 1710234567890
}
```

**权限要求:**
- 需要登录

**业务逻辑:**
1. 验证 Token
2. 设置 `user_id` 为当前用户 ID
3. 设置 `status=PENDING` (需要审核)
4. 如果是回复，设置 `parent_id`

---

#### 5.3 审核评论 (需要认证 - 管理员)

**接口:** `POST /api/comments/{id}/approve`

**请求头:**
```
Authorization: Bearer <token>
```

**响应:**
```json
{
  "code": 200,
  "message": "审核通过",
  "data": {
    "id": 3,
    "status": "APPROVED"
  },
  "timestamp": 1710234567890
}
```

**权限要求:**
- 需要登录且 `role=ADMIN`

---

## 📊 前后端联调方案

### 1. 开发环境配置

**前端代理配置 (vite.config.ts):**
```typescript
export default defineConfig({
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true
      }
    }
  }
})
```

**后端 CORS 配置:**
```java
@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOrigins("http://localhost:3000")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true)
                .maxAge(3600);
    }
}
```

### 2. 联调流程

```
1. 后端开发 API
   ↓
2. 使用 Postman 测试 API
   ↓
3. 更新 API 文档 (本文档)
   ↓
4. 前端根据文档开发
   ↓
5. 前后端联调 (本地)
   ↓
6. 部署到服务器
   ↓
7. 生产环境测试
```

### 3. 测试数据

**后端提供 Mock 数据接口:**
```
GET /api/mock/articles  - 返回 10 篇测试文章
GET /api/mock/categories - 返回测试分类
GET /api/mock/tags - 返回测试标签
```

**前端使用 Mock 数据开发:**
```typescript
// src/api/mock.ts
export const mockArticles = [
  {
    id: 1,
    title: '测试文章 1',
    content: '...',
    ...
  }
];
```

### 4. 接口变更管理

**变更流程:**
1. 后端更新 API 文档
2. 通知前端开发者
3. 前端调整代码
4. 重新联调测试

**版本控制:**
- API 版本包含在 URL 中：`/api/v1/...`
- 重大变更升级版本号

---

## 📝 附录

### A. JWT Token 生成示例

```java
public String generateToken(User user) {
    return Jwts.builder()
        .setSubject(String.valueOf(user.getId()))
        .claim("username", user.getUsername())
        .claim("role", user.getRole())
        .setIssuedAt(new Date())
        .setExpiration(new Date(System.currentTimeMillis() + 7200000))
        .signWith(SignatureAlgorithm.HS256, secretKey)
        .compact();
}
```

### B. 密码加密示例

```java
public String encodePassword(String password) {
    BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
    return encoder.encode(password);
}

public boolean matchesPassword(String raw, String encoded) {
    BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
    return encoder.matches(raw, encoded);
}
```

---

**维护者:** 酱肉 (后端工程师)  
**更新日期:** 2026-03-12  
**版本:** v1.0
