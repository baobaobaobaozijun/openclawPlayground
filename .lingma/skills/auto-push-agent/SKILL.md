---
name: auto-push-agent
description: 自动提交并推送 agent 文件夹的更改到 Git 仓库。当修改 agent 目录下的文件后，自动执行 git add、commit 和 push 操作，确保代码安全备份，避免毁灭性改动丢失。支持初始化仓库、配置远程地址、错误恢复等功能。
---

# Agent 文件自动 Push 技能

## 触发时机

每当完成对 `agent/` 目录下文件的修改后（包括代码修改、文件创建/删除、配置更新等），必须执行本流程自动推送到 Git 仓库。

## 核心目标

1. **代码安全**：避免毁灭性改动导致代码丢失
2. **自动备份**：每次更改后自动推送到远程仓库
3. **版本追踪**：保留完整的修改历史
4. **快速恢复**：出现问题时能快速回滚到之前的版本

## 执行流程

### 步骤 1: 检查 Git 环境

```bash
# 检查是否在 git 仓库中
git status
```

**如果不在 git 仓库中**，执行初始化流程：
```bash
git init
git config user.name "Agent Auto-Commit"
git config user.email "agent@openclaw.local"
```

### 步骤 2: 检查 .gitignore

确保 `.gitignore` 文件包含以下内容：
```gitignore
# 日志文件
*.log
logs/

# 临时文件
.tmp/
temp/
*.tmp

# 敏感信息
*.env
secrets/
keys/

# IDE 配置
.vscode/
.idea/
*.swp
*.swo

# 系统文件
.DS_Store
Thumbs.db
```

### 步骤 3: 添加更改的文件

```bash
# 只添加 agent 目录下的更改
git add agent/
```

### 步骤 4: 生成提交信息

提交信息格式：
```
{类型} ({范围}): {简短描述}

- 修改时间：{yyyyMMdd-HHmmss}
- 涉及文件：
  - 文件 1
  - 文件 2
- 变更摘要：{简要说明主要变更}
```

**类型标识**：
- `feat`: 新功能
- `fix`: 修复问题
- `docs`: 文档更新
- `style`: 格式调整
- `refactor`: 重构
- `config`: 配置变更
- `chore`: 其他杂项

**范围标识**：
- `agent`: 通用 agent 相关
- `workspace`: 工作空间相关
- `docker`: Docker 配置相关
- `skill`: 技能相关
- `config`: 配置文件相关

### 步骤 5: 提交更改

```bash
git commit -m "{生成的提交信息}"
```

### 步骤 6: 检查远程仓库

```bash
git remote -v
```

**如果没有配置远程仓库**：
1. 提示用户配置远程仓库地址
2. 或询问是否使用 GitHub/Gitee/LabCode 等平台

配置示例：
```bash
# GitHub
git remote add origin https://github.com/{username}/{repo}.git

# Gitee
git remote add origin https://gitee.com/{username}/{repo}.git

# LabCode
git remote add origin https://labcode.example.com/{username}/{repo}.git
```

### 步骤 7: 拉取最新代码

```bash
git pull --rebase origin {branch}
```

如果有冲突：
1. 记录冲突文件
2. 提示用户手动解决
3. 暂停 push 操作

### 步骤 8: 推送更改

```bash
git push origin {branch}
```

### 步骤 9: 生成日志记录

在 `agent/workinglog/` 目录下创建 push 记录：
```markdown
# Auto Push 记录 - {yyyyMMdd-HHmmss}

## 基本信息
- **执行时间**: {开始时间} - {结束时间}
- **触发原因**: {修改的文件或功能}
- **提交哈希**: {git commit hash}
- **涉及文件**: 
  - 文件 1
  - 文件 2

## 变更统计
- 新增文件：X 个
- 修改文件：Y 个
- 删除文件：Z 个
- 新增行数：+A
- 删除行数：-B

## 提交信息
```
{完整的 commit message}
```

## Push 状态
- [x] Git 初始化 ✓
- [x] 文件暂存 ✓
- [x] 提交更改 ✓
- [x] 拉取最新 ✓
- [x] 推送远程 ✓

## 远程仓库
- 地址：{remote url}
- 分支：{branch name}
- 状态：成功/失败

## 备注
{其他需要说明的信息}
```

## 特殊场景处理

### 场景 1: 首次使用（无 Git 仓库）

**处理流程**：
1. 初始化 git 仓库：`git init`
2. 配置用户信息
3. 创建 `.gitignore` 文件
4. 提示用户配置远程仓库
5. 执行首次提交和推送

### 场景 2: 远程仓库未配置

**处理流程**：
1. 检测本地有 git 仓库但无远程配置
2. 提供远程仓库配置选项：
   - GitHub
   - Gitee
   - LabCode
   - 其他 Git 服务器
3. 引导用户完成配置
4. 执行推送

### 场景 3: Push 失败（网络问题）

**处理流程**：
1. 记录错误信息
2. 重试机制（最多 3 次）
3. 如果仍然失败：
   - 保存当前 commit
   - 提示用户网络问题
   - 建议稍后手动 push
4. 生成故障报告

### 场景 4: 合并冲突

**处理流程**：
1. 立即停止自动流程
2. 标记冲突文件
3. 生成冲突报告：
   ```markdown
   ## 冲突文件
   - file1.md: 本地 vs 远程
   - file2.json: 配置冲突
   
   ## 建议操作
   1. 手动解决冲突
   2. 运行：git add <resolved files>
   3. 运行：git commit
   4. 运行：git push
   ```
4. 等待用户手动干预

### 场景 5: 大文件警告

**处理流程**：
1. 检测超过 50MB 的文件
2. 发出警告
3. 建议使用 Git LFS
4. 询问是否继续推送

## 安全机制

### 1. 提交前检查清单
- [ ] 确认只包含 agent 目录的文件
- [ ] 没有敏感信息（密码、密钥等）
- [ ] 提交信息清晰准确
- [ ] 已通过基本的语法检查

### 2. 敏感信息过滤

自动检测以下模式，如果发现则警告：
```
password=
secret=
api_key=
token=
AWS_SECRET
PRIVATE_KEY
```

### 3. 回滚机制

每次 push 成功后记录：
- Commit hash
- 推送时间
- 文件列表

便于出现问题时快速回滚：
```bash
# 回滚到上一个版本
git revert HEAD
git push origin {branch}
```

## 配置选项

### 可选配置项

在 `.openclaw/auto-push-config.json` 中配置：

```json
{
  "autoPush": {
    "enabled": true,
    "remoteUrl": "https://github.com/username/repo.git",
    "branch": "main",
    "autoInit": true,
    "generateLogs": true,
    "logPath": "agent/workinglog/",
    "retryCount": 3,
    "excludePatterns": [
      "*.log",
      "*.tmp",
      "node_modules/"
    ],
    "notifyOnSuccess": true,
    "notifyOnFailure": true
  }
}
```

## 质量检查清单

执行 push 前确认：
- [ ] Git 环境正常
- [ ] 只包含 agent 目录的更改
- [ ] 提交信息符合规范
- [ ] 没有敏感信息
- [ ] 远程仓库已配置
- [ ] 网络连接正常
- [ ] 日志记录已准备

## 示例输出

### 示例 1: 正常 Push

**执行情况**:
```
✅ Agent 文件自动 Push 完成

📝 提交信息: feat(skill): 添加自动 push 技能
🔖 Commit Hash: a1b2c3d4e5f6
📂 涉及文件: 3 个
  - SKILL.md (新增)
  - config.json (修改)
  - README.md (修改)
📊 变更统计: +150 -20
🌐 远程仓库: github.com/username/repo
📍 分支: main
⏱️ 执行耗时: 8 秒
📄 日志位置: agent/workinglog/auto-push_20260309-213045.md
```

### 示例 2: 首次初始化

**执行情况**:
```
🔧 检测到未初始化 Git 仓库

正在执行初始化流程:
✓ Git 仓库初始化完成
✓ 用户信息配置完成
✓ .gitignore 创建完成

⚠️ 需要配置远程仓库

请选择远程仓库类型:
1. GitHub
2. Gitee
3. LabCode
4. 其他 Git 服务器
5. 跳过（仅本地提交）

远程仓库配置完成后将自动推送首次提交
```

### 示例 3: Push 失败

**执行情况**:
```
❌ Push 失败

错误信息：
network is unreachable

已重试 3 次，仍然失败

💡 建议操作:
1. 检查网络连接
2. 确认远程仓库地址正确
3. 稍后手动执行：git push

当前更改已保存到本地 commit:
Commit: a1b2c3d4e5f6
Message: feat(agent): 更新配置

可以稍后网络恢复后手动推送
```

## 命令参考

### 常用 Git 命令

```bash
# 初始化
git init
git config user.name "Agent Auto-Commit"
git config user.email "agent@openclaw.local"

# 查看状态
git status
git log --oneline -5

# 添加文件
git add agent/
git add agent/workspace-*
git add agent/deployment-*

# 提交
git commit -m "message"

# 远程管理
git remote -v
git remote add origin <url>
git remote set-url origin <new-url>

# 推送
git pull --rebase origin main
git push origin main

# 回滚
git revert HEAD
git reset --hard HEAD~1
```

## 注意事项

1. **权限确认**: 确保有远程仓库的推送权限
2. **网络稳定**: 推送过程保持网络连接稳定
3. **分支管理**: 统一推送到 main/master 分支
4. **提交频率**: 避免过于频繁的提交（建议间隔>30 秒）
5. **大文件**: 单个文件不超过 50MB
6. **敏感信息**: 严禁推送密码、密钥等敏感数据
7. **冲突处理**: 遇到冲突优先保护本地更改
8. **日志备份**: 定期备份 workinglog 目录

## 故障排查

### 问题 1: Git 未安装

**症状**: `git: command not found`

**解决**:
```bash
# Windows
winget install Git.Git

# 或使用安装包
下载地址：https://git-scm.com/download/win
```

### 问题 2: 权限被拒绝

**症状**: `Permission denied (publickey)`

**解决**:
```bash
# 配置 SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"
# 将公钥添加到 Git 平台
cat ~/.ssh/id_ed25519.pub
```

### 问题 3: 远程仓库不存在

**症状**: `repository not found`

**解决**:
1. 在 Git 平台创建新仓库
2. 复制正确的仓库地址
3. 更新远程配置：`git remote set-url origin <correct-url>`

## 相关文件

- `.lingma/skills/auto-push-agent/SKILL.md` - 技能定义文件
- `.openclaw/auto-push-config.json` - 配置文件（可选）
- `agent/workinglog/auto-push_*.md` - 执行日志
- `.gitignore` - Git 忽略规则
- `README.md` - 项目说明文档
