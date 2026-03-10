# 📤 GitHub 上传指南

## 🎯 目标

将 4 个 Agent 的 workspace 上传到 GitHub：

1. **灌汤 PM** → `openclawPlayground` (主仓库)
2. **酱肉后端** → `openclaw-backend` (新建)
3. **豆沙前端** → `openclaw-frontend` (新建)
4. **酸菜运维** → `openclaw-devops` (新建)

---

## ✅ 已完成的工作

### 文件整理

- ✅ 所有 Agent 的核心文件已创建完成（IDENTITY.md, ROLE.md, SOUL.md）
- ✅ 每个 workspace 都有独立的 README.md
- ✅ 每个 workspace 都有 .gitignore 文件
- ✅ 文件结构清晰，无矛盾和多余内容

### Git 初始化状态

| Workspace | Git 状态 | 说明 |
|-----------|---------|------|
| workspace | ✅ 已提交 | 包含灌汤的所有文件 |
| workspace-jiangrou | ⏳ 待初始化 | 酱肉的独立 workspace |
| workspace-dousha | ⏳ 待初始化 | 豆沙的独立 workspace |
| workspace-suancai | ⏳ 待初始化 | 酸菜的独立 workspace |

---

## 🚀 手动上传步骤

由于 GitHub 需要认证，请按照以下步骤手动上传：

### 步骤 1: 创建 GitHub 仓库

在浏览器中打开 https://github.com/new 创建以下 4 个仓库：

#### 1. openclawPlayground (主仓库 - 灌汤)
- **Repository name:** `openclawPlayground`
- **Description:** OpenClaw Agent Team - PM Workspace (灌汤)
- **Public/Private:** Public ✅
- **Initialize with:** 不勾选任何选项（空仓库）

#### 2. openclaw-backend (酱肉 - 后端代码)
- **Repository name:** `openclaw-backend`
- **Description:** OpenClaw Backend Code (酱肉负责)
- **Public/Private:** Public ✅
- **Initialize with:** 不勾选

#### 3. openclaw-frontend (豆沙 - 前端代码)
- **Repository name:** `openclaw-frontend`
- **Description:** OpenClaw Frontend Code (豆沙负责)
- **Public/Private:** Public ✅
- **Initialize with:** 不勾选

#### 4. openclaw-devops (酸菜 - 运维脚本)
- **Repository name:** `openclaw-devops`
- **Description:** OpenClaw DevOps Scripts (酸菜负责)
- **Public/Private:** Public ✅
- **Initialize with:** 不勾选

---

### 步骤 2: 配置远程仓库并推送

#### 灌汤 workspace (openclawPlayground)

```bash
cd F:\openclaw\workspace

# 添加远程仓库（替换为你的 GitHub 用户名）
git remote add origin https://github.com/baobaobaobaozijun/openclawPlayground.git

# 推送到 GitHub
git branch -M main
git push -u origin main
```

#### 酱肉 workspace (openclaw-backend)

```bash
cd F:\openclaw\workspace-jiangrou

# 初始化 git
git init
git add .
git commit -m "feat: 初始化酱肉后端 workspace"

# 添加远程仓库
git remote add origin https://github.com/baobaobaobaozijun/openclaw-backend.git

# 推送
git branch -M main
git push -u origin main
```

#### 豆沙 workspace (openclaw-frontend)

```bash
cd F:\openclaw\workspace-dousha

# 初始化 git
git init
git add .
git commit -m "feat: 初始化豆沙前端 workspace"

# 添加远程仓库
git remote add origin https://github.com/baobaobaobaozijun/openclaw-frontend.git

# 推送
git branch -M main
git push -u origin main
```

#### 酸菜 workspace (openclaw-devops)

```bash
cd F:\openclaw\workspace-suancai

# 初始化 git
git init
git add .
git commit -m "feat: 初始化酸菜运维 workspace"

# 添加远程仓库
git remote add origin https://github.com/baobaobaobaozijun/openclaw-devops.git

# 推送
git branch -M main
git push -u origin main
```

---

## 🔐 GitHub 认证方法

### 方法 1: Personal Access Token (推荐)

1. 访问 https://github.com/settings/tokens
2. 点击 "Generate new token (classic)"
3. 选择 scopes: `repo`, `workflow`
4. 生成 token 并复制
5. 推送时使用 token 代替密码

```bash
git push https://<YOUR_USERNAME>:<YOUR_TOKEN>@github.com/baobaobaobaozijun/openclawPlayground.git
```

### 方法 2: SSH Key

```bash
# 生成 SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"

# 添加到 GitHub
# 访问 https://github.com/settings/ssh-keys
# 点击 New SSH Key，粘贴 ~/.ssh/id_ed25519.pub 的内容

# 使用 SSH URL
git remote set-url origin git@github.com:baobaobaobaozijun/openclawPlayground.git
git push -u origin main
```

### 方法 3: GitHub CLI

```bash
# 安装 GitHub CLI
winget install GitHub.cli

# 登录
gh auth login

# 推送
git push -u origin main
```

---

## 📊 上传检查清单

### 灌汤 (openclawPlayground)
- [ ] IDENTITY.md
- [ ] ROLE.md ✅ 新增
- [ ] SOUL.md
- [ ] README.md ✅ 新增
- [ ] AGENTS.md
- [ ] 其他必要文件
- [ ] .gitignore ✅ 新增

### 酱肉 (openclaw-backend)
- [ ] IDENTITY.md
- [ ] ROLE.md
- [ ] SOUL.md
- [ ] README.md ✅ 新增
- [ ] .gitignore ✅ 新增

### 豆沙 (openclaw-frontend)
- [ ] IDENTITY.md
- [ ] ROLE.md
- [ ] SOUL.md
- [ ] README.md ✅ 新增
- [ ] .gitignore ✅ 新增

### 酸菜 (openclaw-devops)
- [ ] IDENTITY.md
- [ ] ROLE.md
- [ ] SOUL.md
- [ ] README.md ✅ 新增
- [ ] .gitignore ✅ 新增

---

## 🎉 上传后的验证

上传完成后，在 GitHub 上检查以下内容：

### 1. 文件完整性
- 所有核心文件都已上传
- README.md 显示正常
- 目录结构正确

### 2. 仓库链接
- openclawPlayground: https://github.com/baobaobaobaozijun/openclawPlayground
- openclaw-backend: https://github.com/baobaobaobaozijun/openclaw-backend
- openclaw-frontend: https://github.com/baobaobaobaozijun/openclaw-frontend
- openclaw-devops: https://github.com/baobaobaobaozijun/openclaw-devops

### 3. 更新引用链接

在所有 README.md 中更新仓库链接（如需要）。

---

## 📝 注意事项

1. **不要上传的内容:**
   - logs/ 目录（工作日志）
   - tasks/ 目录（任务文件）
   - communication/ 目录（通信记录）
   - 敏感信息（API Key、密码等）

2. **建议上传的内容:**
   - 核心配置文件（IDENTITY.md, ROLE.md, SOUL.md）
   - README.md
   - .gitignore
   - Docker 配置文件（如需要）

3. **后续同步:**
   - 定期 commit 和 push
   - 保持本地和远程同步
   - 使用 git pull 获取更新

---

## 🆘 故障排除

### 问题 1: 认证失败
```
remote: Support for password authentication was removed on August 13, 2021.
```
**解决:** 使用 Personal Access Token 或 SSH Key

### 问题 2: 仓库不存在
```
remote: Repository not found.
```
**解决:** 先在 GitHub 上创建空仓库

### 问题 3: 权限不足
```
ERROR: Permission to baobaobaobaozijun/repo.git denied to user.
```
**解决:** 检查 SSH key 是否已添加到 GitHub

---

**按照以上步骤操作，即可成功将所有 Agent workspace 上传到 GitHub！** 🚀
