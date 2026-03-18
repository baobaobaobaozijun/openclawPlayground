# 任务分配：API 联调支持

**任务 ID:** TASK-API  
**分配时间:** 2026-03-18 09:00  
**负责人:** 酱肉 (Jiangrou) 🍖  
**优先级:** 🔴 高  
**截止时间:** 2026-03-18 20:00 (11 小时)

---

## 📋 任务描述

配合前端豆沙完成登录注册页面的 API 联调测试

---

## 🎯 任务目标

### 联调内容
1. **Auth API 文档提供** (10:00 前)
   - 登录接口 `/api/auth/login`
   - 注册接口 `/api/auth/register`
   - 验证码接口 `/api/auth/sms-code`

2. **联调测试** (20:00 前)
   - 登录流程测试
   - 注册流程测试
   - 验证码发送测试

3. **性能要求**
   - API 响应时间 < 200ms
   - 并发支持 > 100 QPS

---

## 📐 API 接口详情

### 1. 用户登录
```http
POST /api/auth/login
Content-Type: application/json

{
  "phone": "13800138000",
  "code": "123456"
}

Response:
{
  "code": 200,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": 7200
  }
}
```

### 2. 用户注册
```http
POST /api/auth/register
Content-Type: application/json

{
  "phone": "13800138000",
  "code": "123456",
  "password": "Abc123456"
}

Response:
{
  "code": 200,
  "data": {
    "userId": "123456",
    "phone": "138****8000"
  }
}
```

### 3. 发送验证码
```http
POST /api/auth/sms-code
Content-Type: application/json

{
  "phone": "13800138000",
  "type": "login"
}

Response:
{
  "code": 200,
  "data": {
    "expireIn": 300
  }
}
```

---

## ✅ 验收标准

1. **文档交付:** Auth API 文档 10:00 前提供给豆沙
2. **联调完成:** 20:00 前完成所有接口联调
3. **性能达标:** 响应时间 < 200ms
4. **问题修复:** 联调发现问题 2 小时内修复
5. **工作日志:** 按标准模板记录

---

## 🤝 协作说明

**与豆沙协作:**
- 10:00 前提供 API 文档
- 14:00 开始联调测试
- 20:00 前完成所有联调

**联调方式:**
- 使用 Postman 测试集合
- 记录联调问题和解决方案
- 更新 API 文档

---

## 📝 工作日志要求

**必须记录到:** `F:\openclaw\agent\workinglog\jiangrou\`

**文件名格式:** `YYYYMMDD-HHMMSS-jiangrou-TASK-API-联调支持.md`

---

## 🔗 相关文档

- [站会纪要](../../doc/meetings/daily-standup-20260318-0900.md)
- [API 文档](../../doc/api/auth-api.md)

---

**确认收到请回复:**
1. 已阅读任务详情
2. 已知晓 API 接口
3. 预计完成时间

---
灌汤 | PM 🍲
