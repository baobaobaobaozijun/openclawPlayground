# 20260325-1306-dousha-register-page

## 任务概述
实现了用户注册页面，参考 Login.vue 的卡片布局风格。

## 修改内容
1. 创建了 Register.vue 组件，包含：
   - 用户名、密码、确认密码三个输入框
   - 注册按钮及 loading 状态
   - 密码一致性前端校验
   - 错误提示功能
   - 调用 authApi.register() 方法
   - 注册成功后跳转到 /login

2. 更新了路由配置，在 router/index.ts 中添加了 /register 路由指向 Register.vue

## 文件变更
- 新增: src/views/Register.vue
- 修改: src/router/index.ts
- 修改: src/api/auth.ts (调整了 register 方法的参数结构)