<!-- Last Modified: 2026-03-25 -->

# 任务工单模板 v3.0

> 所有 sessions_spawn 任务必须使用此格式。禁止口头交代式任务。
> PM 在 spawn 前先判断：这个任务是否适合 Agent？（见 SOUL.md 能力匹配原则）

---

## 模板

```
# 任务工单 TASK-{编号}

**Agent:** {酱肉/豆沙/酸菜}
**优先级:** {P0/P1/P2}
**截止:** {具体时间}

---

## 📥 输入

> 直接贴关键数据。不要写"请先阅读xxx文件"。

{代码片段 / 接口定义 / 参数规格 / 配置内容}

---

## 📤 交付物

- 文件路径：`{精确到文件名}`
- 用 write 工具写入

---

## ✅ 验收标准（全部满足才算完成）

- [ ] 文件已用 write 写入（仅在对话中回复代码 ≠ 完成）
- [ ] Test-Path = True
- [ ] {具体内容检查点1，如"文件包含 xxx 函数"}
- [ ] {具体内容检查点2}
- [ ] 工作日志已写入 workinglog/{agent}/
- [ ] git add + commit 已执行
- [ ] **工作日志末尾添加回执行：`TASK-{编号} | PASS | {文件路径} | {commit hash}`**

---

## ❌ 禁止事项

- 不要做 {其他任务名}
- 不要修改 {其他文件路径}
- 不要使用 {错误的字段/参数/方法}

---

## ⏱️ 超时处理

- 如果 15 分钟内无法完成 → 立即回复 PM 说明阻塞原因
- 不要沉默消失

---

## 📏 规模控制

- 本次任务只产出 1 个文件
- tool call 预算：write + Test-Path + 日志 + commit = 4 步
- 不要额外读取其他文件（输入已在上方提供）
```

---

## 使用示例

### 示例 1：给酱肉写新 Service

```
# 任务工单 TASK-025

**Agent:** 酱肉
**优先级:** P1
**截止:** 14:00

## 📥 输入

需要实现的接口：
- findByCategory(Long categoryId): List<Article>
- findByTag(Long tagId): List<Article>

依赖的 Mapper 方法（已存在）：
- ArticleMapper.selectByCategoryId(Long categoryId)
- ArticleMapper.selectByTagId(Long tagId)

返回类型 Article 字段：id, title, content, categoryId, authorId, createdAt

## 📤 交付物

- 文件路径：`F:\openclaw\code\backend\src\main\java\com\openclaw\service\impl\ArticleQueryServiceImpl.java`

## ✅ 验收标准

- [ ] 文件已用 write 写入
- [ ] Test-Path = True
- [ ] 包含 findByCategory 和 findByTag 两个方法
- [ ] 使用 @Service 注解
- [ ] 工作日志 + git commit

## ❌ 禁止事项

- 不要修改 ArticleMapper.java
- 不要做 DDL/数据库相关任务
- 不要做 Auth 相关任务

## ⏱️ 超时处理

15 分钟未完成 → 回复阻塞原因

## 📏 规模控制

只产出 1 个文件，4 步 tool call
```

### 示例 2：给豆沙写 Vue 组件

```
# 任务工单 TASK-026

**Agent:** 豆沙
**优先级:** P1
**截止:** 14:00

## 📥 输入

需要调用的后端接口：
- POST /auth/login, body: { username: string, password: string }
- 成功响应: { code: 200, data: { id, username, email, avatar, token } }
- 失败响应: { code: 500, message: "用户名或密码错误" }

路由路径：/login
UI 要求：用户名输入框 + 密码输入框 + 登录按钮 + 跳转注册链接

## 📤 交付物

- 文件路径：`F:\openclaw\code\frontend\src\views\LoginView.vue`

## ✅ 验收标准

- [ ] 文件已用 write 写入
- [ ] Test-Path = True
- [ ] 使用 username 字段（不是 phone）
- [ ] 包含表单验证
- [ ] 工作日志 + git commit

## ❌ 禁止事项

- 不要使用 phone 字段（后端用 username）
- 不要修改 router 配置
- 不要修改 api/auth.ts

## ⏱️ 超时处理

15 分钟未完成 → 回复阻塞原因

## 📏 规模控制

只产出 1 个文件，4 步 tool call
```

---

## 工单回执规范

Agent 完成工单后，必须在工作日志末尾添加一行回执：

```
TASK-{编号} | {PASS/FAIL} | {文件路径} | {commit hash}
```

示例：
```
TASK-025 | PASS | F:\openclaw\code\backend\src\...\ArticleQueryServiceImpl.java | abc1234
```

PM 可用 `_tools.ps1 receipts all` 一次性扫描全部回执。

---

## PM 检查清单

spawn 前确认：
- [ ] 这个任务适合 Agent 做吗？（见 SOUL.md 能力匹配原则）
- [ ] 📥 输入是否内联了关键数据？（不要让 Agent 自己去读文件）
- [ ] ❌ 禁止事项是否列全？（Agent 会做你没禁止的事）
- [ ] 📏 tool call 步骤 ≤4？
- [ ] 超时机制是否明确？

spawn 后验证（一条命令搞定）：
```
powershell -ExecutionPolicy Bypass -File "_tools.ps1" batch-verify "tasks/verify-list.txt"
```

---

*维护者：灌汤 PM | 版本 3.0 | 2026-03-25*
