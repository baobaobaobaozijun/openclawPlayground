<!-- Last Modified: 2026-03-25 -->

# Auth API 接口文档

> 基于后端代码 AuthController.java 提取，PM 灌汤兜底编写
> 酱肉两次未交付，PM 直接执行

---

## 基础信息

- **Base URL:** `/auth`
- **Content-Type:** `application/json`
- **统一响应格式:** `Result<T>`

```json
{
  "code": 200,
  "message": "success",
  "data": { ... },
  "timestamp": 1711350000000
}
```

---

## 1. 用户注册

**POST** `/auth/register`

### 请求参数

| 字段 | 类型 | 必填 | 校验规则 | 说明 |
|------|------|------|---------|------|
| username | String | ✅ | 3-20 字符，不能为空 | 用户名 |
| email | String | ✅ | 邮箱格式，不能为空 | 邮箱地址 |
| password | String | ✅ | 6-32 字符，不能为空 | 密码 |

### 请求示例

```json
{
  "username": "testuser",
  "email": "test@example.com",
  "password": "123456"
}
```

### 成功响应

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": 1,
    "username": "testuser",
    "email": "test@example.com",
    "avatar": null,
    "token": "eyJhbGciOiJIUzI1NiJ9..."
  },
  "timestamp": 1711350000000
}
```

### 错误响应

| code | message | 说明 |
|------|---------|------|
| 400 | 用户名不能为空 | username 为空 |
| 400 | 用户名长度3-20 | username 长度不合规 |
| 400 | 邮箱不能为空 | email 为空 |
| 400 | 邮箱格式不正确 | email 格式错误 |
| 400 | 密码不能为空 | password 为空 |
| 400 | 密码长度6-32 | password 长度不合规 |
| 500 | 用户名已存在 | username 重复 |
| 500 | 邮箱已注册 | email 重复 |

---

## 2. 用户登录

**POST** `/auth/login`

### 请求参数

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| username | String | ✅ | 用户名 |
| password | String | ✅ | 密码 |

### 请求示例

```json
{
  "username": "testuser",
  "password": "123456"
}
```

### 成功响应

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": 1,
    "username": "testuser",
    "email": "test@example.com",
    "avatar": "https://...",
    "token": "eyJhbGciOiJIUzI1NiJ9..."
  },
  "timestamp": 1711350000000
}
```

### 错误响应

| code | message | 说明 |
|------|---------|------|
| 500 | 用户名或密码错误 | 认证失败 |
| 500 | 用户不存在 | 用户名未注册 |

---

## 3. Token 刷新

> ⚠️ **当前未实现。** AuthController 中暂无 refresh 接口。
> 后续酱肉需补充 `POST /auth/refresh` 接口。

---

## 4. 通用错误码

| code | 含义 |
|------|------|
| 200 | 成功 |
| 400 | 请求参数校验失败 |
| 401 | 未认证 / Token 过期 |
| 403 | 无权限 |
| 500 | 服务器内部错误 |

---

## 5. 数据模型

### UserDTO（登录/注册响应）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 用户 ID |
| username | String | 用户名 |
| email | String | 邮箱 |
| avatar | String | 头像 URL（可为 null） |
| token | String | JWT Token |

---

*文档来源：AuthController.java + LoginRequest.java + RegisterRequest.java + UserDTO.java + Result.java*
*编写者：灌汤 PM（兜底执行）| 2026-03-25*
