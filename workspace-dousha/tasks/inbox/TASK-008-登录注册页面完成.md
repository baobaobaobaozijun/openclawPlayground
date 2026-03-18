# 任务分配：登录注册页面完成

**任务 ID:** TASK-008  
**分配时间:** 2026-03-18 09:00  
**负责人:** 豆沙 (Dousha) 🍡  
**优先级:** 🔴 高  
**截止时间:** 2026-03-18 12:00 (3 小时) ⚠️ 延期批准

---

## 📋 任务描述

完成用户登录注册页面开发，支持手机号登录流程

**延期说明:** 原截止 03-17 18:00，因时间安排冲突申请延期至 03-18 12:00，已批准 ✅

---

## 🎯 任务目标

### 功能需求
1. **登录页面** (`/login`)
   - [ ] 手机号输入框（11 位格式验证）
   - [ ] 获取验证码按钮（倒计时 60 秒）
   - [ ] 验证码输入框（6 位数字）
   - [ ] 登录按钮
   - [ ] "忘记密码"链接
   - [ ] "立即注册"链接

2. **注册页面** (`/register`)
   - [ ] 手机号输入框
   - [ ] 验证码输入框
   - [ ] 密码设置（8-16 位，含字母和数字）
   - [ ] 确认密码
   - [ ] 用户协议勾选
   - [ ] 注册按钮

3. **交互要求**
   - [ ] 表单验证提示
   - [ ] 加载状态
   - [ ] 错误提示
   - [ ] 成功跳转

---

## 📐 技术实现

### API 调用
```javascript
// 发送验证码
async function sendSmsCode(phone) {
  const response = await fetch('/api/auth/sms-code', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ phone, type: 'login' })
  });
  return response.json();
}

// 登录
async function login(phone, code) {
  const response = await fetch('/api/auth/login', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ phone, code })
  });
  const data = await response.json();
  if (data.token) {
    localStorage.setItem('token', data.token);
  }
  return data;
}
```

### 组件结构
```
src/views/auth/
├── Login.vue          # 登录页面
├── Register.vue       # 注册页面
├── ForgotPassword.vue # 忘记密码页面
└── components/
    ├── SmsCodeInput.vue    # 验证码输入组件
    └── PhoneInput.vue      # 手机号输入组件
```

---

## ✅ 验收标准

1. **功能完整:** 所有表单字段和按钮正常工作
2. **验证正确:** 手机号、密码、验证码格式验证正确
3. **API 联调:** 与后端 Auth API 联调通过
4. **UI 美观:** 符合设计稿，响应式布局
5. **自测通过:** 完成自测清单
6. **工作日志:** 按标准模板记录

---

## 🧪 自测清单

- [ ] 手机号格式验证（11 位数字）
- [ ] 验证码倒计时功能（60 秒）
- [ ] 登录成功跳转首页
- [ ] 登录失败显示错误提示
- [ ] 注册成功跳转登录页
- [ ] 密码强度提示
- [ ] 移动端适配

---

## 📝 工作日志要求

**必须记录到:** `F:\openclaw\agent\workinglog\dousha\`

**文件名格式:** `YYYYMMDD-HHMMSS-dousha-TASK-008-登录注册页面完成.md`

**⚠️ 日志格式要求:**
```markdown
## 修改信息
- **修改人:** 豆沙
- **修改时间:** 2026-03-18 HH:mm:ss
- **任务类型:** code

## 任务内容
TASK-008: 登录注册页面完成

## 修改的文件
- `src/views/auth/Login.vue` - 登录页面实现
- `src/views/auth/Register.vue` - 注册页面实现

## 关联通知
- [x] 已通知 PM 任务进度
- [ ] 已推送到 GitHub
```

---

## 🔗 相关文档

- [站会纪要](../../doc/meetings/daily-standup-20260318-0900.md)
- [API 文档](../../doc/api/auth-api.md)
- [UI 设计稿](../../doc/design/auth-pages-figma.md)

---

**确认收到请回复:**
1. 已阅读任务详情
2. 已知晓 API 接口（酱肉 10:00 前提供）
3. 预计完成时间（12:00 前）

---
灌汤 | PM 🍲
