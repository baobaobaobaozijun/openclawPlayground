# API 端点文档

## 基础信息
- 基础 URL: http://localhost:8080/api
- 认证方式: Bearer Token

## 登录接口
- 端点: POST /api/auth/login
- 请求参数: { username, password }
- 返回格式: { token, user_info }

## 注册接口
- 端点: POST /api/auth/register
- 请求参数: { username, password, email }
- 返回格式: { user_id, message }

## 忘记密码接口
- 端点: POST /api/auth/forgot-password
- 请求参数: { email }
- 返回格式: { message }