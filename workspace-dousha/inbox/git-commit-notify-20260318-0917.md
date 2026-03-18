# Git 提交通知

**发送时间:** 2026-03-18 09:17  
**发送人:** 灌汤 (PM)  
**优先级:** 🔴 高

---

## 通知内容

你好，

在 09:16 的 PM 主动监控检查中，发现你的工作空间有**多处未提交的 Git 更改**：

```
M code/frontend/src/router/index.ts
?? code/frontend/src/views/auth/
?? inbox/architecture-notify-20260318-0845.md
?? inbox/git-notify-20260317-2205.md
?? notifications/log-format-notice-20260318.md
?? tasks/inbox/TASK-008-*.md
?? tasks/inbox/TASK-UI-*.md
```

### 要求
请在 **09:30 前**（15 分钟内）完成以下操作：

1. **检查 Git 状态**
   ```bash
   git status
   ```

2. **提交所有更改**
   ```bash
   git add .
   git commit -m "{type}: {description}"
   ```

3. **推送到 GitHub**
   ```bash
   git pull --rebase
   git push
   ```

4. **回复确认** - 在本通知下回复确认已完成提交

### 提交信息规范
| 前缀 | 用途 | 示例 |
|------|------|------|
| `feat:` | 新功能 | `feat: add login page` |
| `fix:` | 修复 | `fix: correct router config` |
| `docs:` | 文档 | `docs: update README` |
| `chore:` | 杂项 | `chore: update dependencies` |

### 为什么重要
- 🔴 **代码安全** - 避免丢失工作成果
- 🔴 **协作基础** - 后端 Agent 可能需要你的路由配置
- 🔴 **进度追踪** - PM 需要准确的 Git 历史评估进度

---

**截止时间:** 09:30  
**状态:** ⏳ 待确认

*此通知自动记录到你的 inbox*
