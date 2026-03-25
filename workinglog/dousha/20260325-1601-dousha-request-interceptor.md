# 20260325-1601-dousha-request-interceptor.md

## 任务概述
完善前端 axios 请求拦截器，实现 token 认证和 401 错误处理

## 修改内容
1. 将 baseURL 设置为 `/api`（通过 nginx 反代）
2. 请求拦截器：从 localStorage 获取 access_token，如存在则添加到 `Authorization: Bearer {token}` 请求头
3. 响应拦截器：401 状态码时清除 localStorage token，跳转到 /login；其他错误 console.error 并 reject

## 修改文件
- `F:\openclaw\code\frontend\src\utils\request.ts`

## 完成情况
✅ 任务已完成