# 豆沙工作日志 - NavBar 添加"写文章"入口 + Login 页面跳转注册链接

## 时间
2026-03-25 17:44

## 任务
【PM 灌汤 — 原子任务 🟡 NavBar 添加"写文章"入口 + Login 页面跳转注册链接】

## 完成内容

### 1. 修改 NavBar.vue
- 文件路径：`F:\openclaw\code\frontend\src\components\NavBar.vue`
- 修改内容：在已登录状态下，在用户名左边添加了一个"写文章"按钮
- 按钮样式：使用 nav-link 样式，路由到 `/article/new`
- 具体修改：在 `<template>` 的 navbar-user 区域，isLoggedIn 模板中添加了 `<router-link to="/article/new" class="nav-link write-article-btn">写文章</router-link>`

### 2. 修改 Login.vue
- 文件路径：`F:\openclaw\code\frontend\src\views\Login.vue`
- 修改内容：在登录表单底部添加了注册链接
- 链接样式：使用 login-footer 样式容器
- 具体修改：在 `<form>` 结束标签前添加了 `<div class="login-footer"><router-link to="/register">还没有账号？立即注册</router-link></div>`

## Git 提交
已提交到前端代码仓库：
- 仓库：https://github.com/baobaobaobaozijun/openclaw-frontend
- 提交信息：feat: 添加导航栏写文章入口和登录页面注册链接

## 通知
已通知 PM 灌汤进行验收