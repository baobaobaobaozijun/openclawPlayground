# Auth API 接口文档

## 1. 用户登录

### 接口信息
- **路径**: `/api/auth/login`
- **方法**: POST
- **描述**: 用户登录认证接口

### 请求参数
```json
{
  "username": "string",
  "password": "string"
}
```

| 参数名 | 类型 | 必填 | 描述 |
|--------|------|------|------|
| username | string | 是 | 用户名 |
| password | string | 是 | 密码 |

### 响应格式
```json
{
  "success": true,
  "data": {
    "token": "string",
    "refreshToken": "string",
    "expiresIn": 3600,
    "userInfo": {
      "id": "string",
      "username": "string",
      "email": "string"
    }
  },
  "message": "登录成功"
}
```

| 字段名 | 类型 | 描述 |
|--------|------|------|
| success | boolean | 请求是否成功 |
| data.token | string | 访问令牌 |
| data.refreshToken | string | 刷新令牌 |
| data.expiresIn | number | 令牌过期时间（秒） |
| data.userInfo | object | 用户信息 |
| message | string | 响应消息 |

---

## 2. 用户注册

### 接口信息
- **路径**: `/api/auth/register`
- **方法**: POST
- **描述**: 用户注册接口

### 请求参数
```json
{
  "username": "string",
  "password": "string",
  "email": "string",
  "confirmPassword": "string"
}
```

| 参数名 | 类型 | 必填 | 描述 |
|--------|------|------|------|
| username | string | 是 | 用户名 |
| password | string | 是 | 密码 |
| email | string | 是 | 邮箱 |
| confirmPassword | string | 是 | 确认密码 |

### 响应格式
```json
{
  "success": true,
  "data": {
    "id": "string",
    "username": "string",
    "email": "string"
  },
  "message": "注册成功"
}
```

---

## 3. Token 刷新

### 接口信息
- **路径**: `/api/auth/refresh`
- **方法**: POST
- **描述**: 刷新访问令牌接口

### 请求参数
```json
{
  "refreshToken": "string"
}
```

| 参数名 | 类型 | 必填 | 描述 |
|--------|------|------|------|
| refreshToken | string | 是 | 刷新令牌 |

### 响应格式
```json
{
  "success": true,
  "data": {
    "token": "string",
    "refreshToken": "string",
    "expiresIn": 3600
  },
  "message": "令牌刷新成功"
}
```

---

## 4. 用户登出

### 接口信息
- **路径**: `/api/auth/logout`
- **方法**: POST
- **描述**: 用户登出接口

### 请求参数
```json
{
  "token": "string"
}
```

| 参数名 | 类型 | 必填 | 描述 |
|--------|------|------|------|
| token | string | 是 | 当前访问令牌 |

### 响应格式
```json
{
  "success": true,
  "message": "登出成功"
}
```

---

## 5. 错误码说明

| 错误码 | HTTP 状态码 | 描述 | 说明 |
|--------|-------------|------|------|
| 40001 | 400 | 用户名或密码错误 | 登录时用户名不存在或密码错误 |
| 40002 | 400 | 用户名已存在 | 注册时用户名已被占用 |
| 40003 | 400 | 邮箱格式不正确 | 注册时邮箱格式无效 |
| 40004 | 400 | 密码强度不够 | 注册时密码不符合安全要求 |
| 40005 | 400 | 确认密码不一致 | 注册时两次输入的密码不匹配 |
| 40101 | 401 | 令牌无效或已过期 | 访问需要认证的接口时令牌无效 |
| 40102 | 401 | 刷新令牌无效 | 刷新令牌时提供的刷新令牌无效 |
| 40301 | 403 | 权限不足 | 访问受限资源时权限不足 |
| 50001 | 500 | 服务器内部错误 | 服务器发生未知错误 |
| 50002 | 500 | 数据库连接失败 | 无法连接到数据库 |

---

## 6. 认证说明

### 访问令牌 (Access Token)
- 类型：JWT
- 有效期：1小时
- 用于访问受保护的 API 资源

### 刷新令牌 (Refresh Token)
- 有效期：7天
- 用于刷新访问令牌
- 每次刷新后会生成新的刷新令牌

### 请求头
所有需要认证的接口都需要在请求头中添加：
```
Authorization: Bearer {access_token}
```