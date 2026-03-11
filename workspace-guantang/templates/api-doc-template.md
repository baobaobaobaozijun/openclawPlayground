# 后端 API 接口文档规范（阿里风格）

**文档状态:** 模板  
**版本:** 1.0  
**创建日期:** 2026-03-12  
**参考:** 阿里巴巴后端 API 接口文档规范

---

## 📋 文档信息

| 项目 | 值 |
|------|-----|
| 文档名称 | {项目名称} API 接口文档 |
| 版本号 | v{版本号} |
| 创建人 | {作者姓名} |
| 创建日期 | YYYY-MM-DD |
| 最后更新 | YYYY-MM-DD |
| 联系方式 | {邮箱/钉钉} |
| 审批人 | {技术负责人} |

---

## 1. 文档修订记录

| 版本 | 日期 | 修订人 | 修订说明 | 审批人 |
|------|------|--------|----------|--------|
| v1.0 | YYYY-MM-DD | {姓名} | 初始版本 | {姓名} |
| v1.1 | YYYY-MM-DD | {姓名} | 新增 XX 接口 | {姓名} |

---

## 2. 接口概述

### 2.1 接口目的

> 简要描述本 API 文档的服务范围和业务背景

**示例:**
```
本文档描述博客系统的后端 API 接口，提供用户认证、文章管理、
分类标签管理等核心功能，供前端 Web 端和移动端调用。
```

### 2.2 接口类型

- **架构风格:** RESTful API
- **数据格式:** JSON (application/json)
- **通信协议:** HTTP/1.1 + HTTPS
- **字符编码:** UTF-8

### 2.3 基础 URL

| 环境 | URL |
|------|-----|
| 开发环境 | http://localhost:8080/api/v1 |
| 测试环境 | http://test-api.example.com/api/v1 |
| 生产环境 | https://api.example.com/api/v1 |

### 2.4 认证方式

**JWT Bearer Token 认证**

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**认证流程:**
```
1. 用户登录 → 获取 Token
2. 后续请求携带 Token
3. 服务端验证 Token 有效性
4. Token 过期 → 返回 401 → 前端跳转登录
```

---

## 3. 通用规范

### 3.1 请求规范

**请求头 (Request Headers):**
```http
Content-Type: application/json;charset=UTF-8
Authorization: Bearer {token}
X-Request-ID: {请求追踪 ID}
```

**请求参数位置:**
- **路径参数:** `/api/v1/articles/{id}`
- **查询参数:** `?page=1&pageSize=20`
- **请求体:** JSON 格式

### 3.2 响应规范

**成功响应格式:**
```json
{
  "code": 0,
  "message": "success",
  "data": {
    // 业务数据
  },
  "timestamp": "2026-03-12T10:30:00+08:00",
  "requestId": "req_123456789"
}
```

**错误响应格式:**
```json
{
  "code": 1001,
  "message": "参数验证失败",
  "data": null,
  "timestamp": "2026-03-12T10:30:00+08:00",
  "requestId": "req_123456789"
}
```

**HTTP 状态码:**
| 状态码 | 说明 |
|--------|------|
| 200 | 成功 |
| 201 | 创建成功 |
| 400 | 请求参数错误 |
| 401 | 未授权（Token 无效/过期） |
| 403 | 权限不足 |
| 404 | 资源不存在 |
| 500 | 服务器内部错误 |

### 3.3 分页规范

**请求参数:**
| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| page | integer | 否 | 1 | 页码（从 1 开始） |
| pageSize | integer | 否 | 20 | 每页数量（最大 100） |

**响应格式:**
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "list": [ ... ],
    "pagination": {
      "page": 1,
      "pageSize": 20,
      "total": 100,
      "totalPages": 5
    }
  }
}
```

---

## 4. 接口列表

### 4.1 接口总览

| 模块 | 接口名称 | 方法 | URL | 权限 | 描述 |
|------|----------|------|-----|------|------|
| 认证 | 手机号登录 | POST | /auth/login | 公开 | 用户登录 |
| 认证 | 获取当前用户 | GET | /auth/me | 已登录 | 获取用户信息 |
| 文章 | 获取文章列表 | GET | /articles | 公开 | 分页查询文章 |
| 文章 | 获取文章详情 | GET | /articles/{id} | 公开/受限 | 查看文章详情 |
| 文章 | 创建文章 | POST | /articles | author/admin | 发布文章 |
| 文章 | 更新文章 | PUT | /articles/{id} | author/admin | 编辑文章 |
| 文章 | 删除文章 | DELETE | /articles/{id} | author/admin | 删除文章 |

---

## 5. 接口详情

### 5.1 认证模块

#### 5.1.1 手机号登录

**接口说明:** 用户通过手机号登录，系统自动判断是否注册

**基本信息:**
| 项目 | 值 |
|------|-----|
| 接口路径 | `/api/v1/auth/login` |
| 请求方法 | POST |
| 权限要求 | 公开（无需登录） |
| 限流策略 | 10 次/分钟/IP |

**请求参数:**

| 参数 | 类型 | 必填 | 最大长度 | 说明 | 验证规则 |
|------|------|------|----------|------|----------|
| phone | string | 是 | 11 | 手机号 | `^1[3-9]\d{9}$` |

**请求示例:**
```http
POST /api/v1/auth/login HTTP/1.1
Host: api.example.com
Content-Type: application/json

{
  "phone": "13800138000"
}
```

**响应参数:**

| 参数 | 类型 | 说明 |
|------|------|------|
| token | string | JWT Token |
| expiresIn | integer | Token 有效期（秒） |
| user.id | long | 用户 ID |
| user.phone | string | 手机号 |
| user.nickname | string | 昵称 |
| user.avatar | string | 头像 URL |
| user.role | string | 角色：user/author/admin |
| user.accessLevel | integer | 访问级别：0/1/2 |

**响应示例:**
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": 7200,
    "user": {
      "id": 1,
      "phone": "13800138000",
      "nickname": "管理员",
      "avatar": "",
      "role": "admin",
      "accessLevel": 2
    }
  },
  "timestamp": "2026-03-12T10:30:00+08:00",
  "requestId": "req_123456789"
}
```

**错误码:**
| 错误码 | 说明 | HTTP 状态 |
|--------|------|----------|
| 1001 | 参数验证失败 | 400 |
| 1002 | 手机号格式错误 | 400 |

**测试用例:**
```java
// 单元测试
@Test
void testLogin_ValidPhone() {
    LoginResponse response = authService.login("13800138000");
    assertNotNull(response.getToken());
}

// 集成测试
@Test
void testLogin_API() throws Exception {
    mockMvc.perform(post("/api/v1/auth/login")
            .contentType(MediaType.APPLICATION_JSON)
            .content("{\"phone\":\"13800138000\"}"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.code").value(0));
}
```

---

#### 5.1.2 获取当前用户信息

**接口说明:** 获取当前登录用户的详细信息

**基本信息:**
| 项目 | 值 |
|------|-----|
| 接口路径 | `/api/v1/auth/me` |
| 请求方法 | GET |
| 权限要求 | 已登录用户 |

**请求头:**
```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**响应参数:**

| 参数 | 类型 | 说明 |
|------|------|------|
| id | long | 用户 ID |
| phone | string | 手机号 |
| nickname | string | 昵称 |
| avatar | string | 头像 URL |
| role | string | 角色 |
| accessLevel | integer | 访问级别 |
| createdAt | datetime | 创建时间 |
| lastLoginAt | datetime | 最后登录时间 |

**响应示例:**
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "id": 1,
    "phone": "13800138000",
    "nickname": "管理员",
    "avatar": "",
    "role": "admin",
    "accessLevel": 2,
    "createdAt": "2026-03-10T00:00:00+08:00",
    "lastLoginAt": "2026-03-12T10:30:00+08:00"
  }
}
```

**错误码:**
| 错误码 | 说明 | HTTP 状态 |
|--------|------|----------|
| 2000 | 未提供 Token | 401 |
| 2001 | Token 已过期 | 401 |
| 2002 | Token 无效 | 401 |

---

### 5.2 文章模块

#### 5.2.1 获取文章列表

**接口说明:** 分页查询文章列表，支持分类、标签、关键词过滤

**基本信息:**
| 项目 | 值 |
|------|-----|
| 接口路径 | `/api/v1/articles` |
| 请求方法 | GET |
| 权限要求 | 公开 |

**请求参数:**

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| page | integer | 否 | 1 | 页码 |
| pageSize | integer | 否 | 20 | 每页数量 |
| categoryId | long | 否 | - | 分类 ID |
| tagId | long | 否 | - | 标签 ID |
| keyword | string | 否 | - | 关键词 |
| sortBy | string | 否 | publishedAt | 排序字段 |
| sortOrder | string | 否 | desc | 排序方向 |

**请求示例:**
```http
GET /api/v1/articles?page=1&pageSize=20&categoryId=1&keyword=工作日志
```

**响应参数:**

| 参数 | 类型 | 说明 |
|------|------|------|
| list | array | 文章列表 |
| list[].id | long | 文章 ID |
| list[].title | string | 标题 |
| list[].summary | string | 摘要 |
| list[].authorName | string | 作者名 |
| list[].publishedAt | datetime | 发布时间 |
| pagination | object | 分页信息 |

**响应示例:**
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "list": [
      {
        "id": 1,
        "title": "灌汤的工作日志 - 2026-03-12",
        "summary": "今日完成需求分析...",
        "authorName": "灌汤",
        "publishedAt": "2026-03-12T18:00:00+08:00"
      }
    ],
    "pagination": {
      "page": 1,
      "pageSize": 20,
      "total": 100,
      "totalPages": 5
    }
  }
}
```

---

## 6. 错误码定义

### 6.1 全局错误码

| 错误码 | 说明 | HTTP 状态 | 处理建议 |
|--------|------|----------|----------|
| 0 | 成功 | 200 | - |
| 1001 | 参数验证失败 | 400 | 检查请求参数 |
| 1002 | 请求体格式错误 | 400 | 检查 JSON 格式 |
| 2000 | 未提供 Token | 401 | 添加 Authorization 头 |
| 2001 | Token 已过期 | 401 | 重新登录 |
| 2002 | Token 无效 | 401 | 重新登录 |
| 3003 | 权限不足 | 403 | 申请权限 |
| 3004 | 资源不存在 | 404 | 检查资源 ID |
| 5000 | 服务器内部错误 | 500 | 联系运维 |

### 6.2 业务错误码

| 错误码 | 模块 | 说明 | HTTP 状态 |
|--------|------|------|----------|
| 3001 | 文章 | 文章不存在 | 404 |
| 3002 | 文章 | 文章已被删除 | 404 |
| 3003 | 文章 | 无权访问该文章 | 403 |
| 4001 | 分类 | 分类不存在 | 404 |
| 5001 | 日志 | 该日期的日志已提交 | 400 |

---

## 7. 安全性

### 7.1 认证安全

- ✅ JWT Token 签名验证
- ✅ Token 有效期 2 小时
- ✅ 支持 Token 刷新机制

### 7.2 数据安全

- ✅ SQL 注入防护（参数化查询）
- ✅ XSS 防护（HTML 过滤）
- ✅ 敏感数据加密存储

### 7.3 限流策略

| 接口 | 限流规则 |
|------|----------|
| /auth/login | 10 次/分钟/IP |
| 其他接口 | 100 次/分钟/IP |

---

## 8. 版本控制

### 8.1 版本号规则

- **格式:** `v{主版本}.{次版本}.{修订版本}`
- **示例:** v1.0.0, v1.1.0, v2.0.0

### 8.2 版本兼容性

- **主版本变更:** 不兼容的 API 变更
- **次版本变更:** 向后兼容的功能新增
- **修订版本变更:** 向后兼容的问题修复

---

## 9. 附录

### 9.1 术语表

| 术语 | 说明 |
|------|------|
| JWT | JSON Web Token |
| REST | Representational State Transfer |
| API | Application Programming Interface |

### 9.2 参考资料

- [RESTful API 设计规范](https://restfulapi.net/)
- [OpenAPI Specification](https://swagger.io/specification/)
- [阿里巴巴 Java 开发手册](https://github.com/alibaba/p3c)

---

**文档结束**
