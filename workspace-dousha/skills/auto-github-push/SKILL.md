---
name: auto-github-push
description: "自动推送代码到 GitHub。每次更新完 F:\\openclaw\\agent 文件夹内容后，自动 commit 并 push 到 GitHub 仓库。"
metadata:
  openclaw:
    emoji: 🚀
    requires:
      bins: ["gh", "git"]
---

# 自动 GitHub 推送 (auto-github-push)

## 用途

每次更新完 `F:\openclaw\agent` 文件夹内容后，自动 commit 并 push 到 GitHub 仓库。

## 仓库信息

- **远程仓库**: https://github.com/baobaobaobaozijun/openclawPlayground
- **分支**: master
- **本地路径**: `F:\openclaw\agent`

## 使用方式

### 自动触发

修改文件后自动调用：

```bash
npx auto-github-push --message "feat: 更新配置"
```

### 手动触发

```bash
# 推送所有待提交的更改
npx auto-github-push

# 指定提交信息
npx auto-github-push -m "feat: 添加新功能"

# 预览将要推送的内容
npx auto-github-push --dry-run
```

## 工作流程

```
1. 检查工作空间状态 (git status)
   ↓
2. 添加所有更改的文件 (git add .)
   ↓
3. 生成提交信息 (自动或手动指定)
   ↓
4. 提交更改 (git commit)
   ↓
5. 拉取最新代码 (git pull)
   ↓
6. 推送到 GitHub (git push)
   ↓
7. 记录推送日志
```

## 提交信息规范

### 类型前缀

| 前缀 | 用途 |
|------|------|
| `feat:` | 新功能 |
| `fix:` | 修复 bug |
| `docs:` | 文档更新 |
| `style:` | 代码格式 |
| `refactor:` | 重构 |
| `config:` | 配置变更 |
| `chore:` | 其他杂项 |

### 示例

```bash
feat: 创建登录页面组件
fix: 修复路由配置错误
docs: 更新前端开发文档
config: 更新 Vite 构建配置
```

## 前置条件

### 1. Git 已初始化

```bash
cd F:\openclaw\agent
git status  # 确认是 git 仓库
```

### 2. GitHub 已认证

```bash
gh auth status  # 检查认证状态
gh auth login   # 如果未认证，先登录
```

### 3. 远程仓库已配置

```bash
git remote -v  # 确认远程仓库地址
```

## 错误处理

### 常见问题

**问题 1: 未认证**
```
ERROR: GitHub authentication required
SOLUTION: 运行 gh auth login
```

**问题 2: 有未合并的更改**
```
ERROR: Your local changes would be overwritten
SOLUTION: 先 git pull 或 git stash
```

**问题 3: 没有更改**
```
INFO: Nothing to commit
SOLUTION: 无需推送
```

## 日志记录

每次推送后记录：

```markdown
## GitHub 推送日志
- 时间：2026-03-11 23:23:00
- 提交：abc1234 feat: 创建登录页面组件
- 状态：✅ 成功
```

---

*自动推送，保持同步 🚀*
