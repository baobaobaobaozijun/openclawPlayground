# API 设计（实际实现）

**基础路径:** `/api`  
**认证方式:** JWT Bearer Token  
**响应格式:** 统一包含 timestamp 字段

## 认证模块

### POST /auth/login
**请求:**
```json
{ "username": "string", "password": "string" }
```
**响应:**
```json
{
  "code": 200,
  "data": {
    "token": "string",
    "refreshToken": "string",
    "expiresIn": 7200,
    "user": {
      "id": 1,
      "username": "string",
      "email": "string",
      "phone": "string",
      "avatar": "string",
      "role": "string"
    }
  },
  "timestamp": 1711420800000
}
```

### POST /auth/register
**请求:**
```json
{ "username": "string", "email": "string", "password": "string" }
```

### POST /auth/refresh
**请求:**
```json
{ "refreshToken": "string" }
```

### POST /auth/logout

---

## 文章模块

### GET /api/articles
**参数:** page, size, categoryId, keyword

### GET /api/articles/:id

### POST /api/articles
**需要认证:** ✅

### PUT /api/articles/:id
**需要认证:** ✅

### DELETE /api/articles/:id
**需要认证:** ✅

---

## 分类模块 (Plan-04)

### GET /api/categories
**响应:** 分类列表（支持多级）

### GET /api/categories/:id

### POST /api/categories
**需要认证:** ✅

### PUT /api/categories/:id
**需要认证:** ✅

### DELETE /api/categories/:id
**需要认证:** ✅

---

## 标签模块 (Plan-04)

### GET /api/tags
**响应:** 标签列表

### GET /api/tags/:id

### POST /api/tags
**需要认证:** ✅

### PUT /api/tags/:id
**需要认证:** ✅

### DELETE /api/tags/:id
**需要认证:** ✅

---

## Agent 状态模块 (Plan-03)

### GET /api/agent/status
**响应:**
```json
[
  { "name": "灌汤", "status": "online", "lastActivity": "2026-03-26T08:00:00Z", "currentTask": "PM 调度中" },
  { "name": "酱肉", "status": "online", "lastActivity": "...", "currentTask": "开发中" },
  { "name": "豆沙", "status": "idle", ... },
  { "name": "酸菜", "status": "idle", ... }
]
```
**轮询:** 前端 30s 自动刷新