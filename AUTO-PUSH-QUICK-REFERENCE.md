# Auto Push Agent - 快速参考

## 🚀 技能已就绪

✅ **技能文件**: `.lingma/skills/auto-push-agent/SKILL.md`  
✅ **Git 仓库**: 已初始化  
✅ **配置文件**: `.openclaw/auto-push-config.json`  
✅ **忽略规则**: `.gitignore`  

## 📋 下一步操作（必须完成）

### 1️⃣ 选择 Git 平台并创建仓库

**GitHub** (推荐):
- 访问：https://github.com/new
- 创建新仓库
- 复制仓库地址：`https://github.com/{用户名}/{仓库名}.git`

**Gitee** (国内推荐):
- 访问：https://gitee.com/new
- 创建新仓库
- 复制仓库地址：`https://gitee.com/{用户名}/{仓库名}.git`

**LabCode**:
- 访问相应平台创建仓库
- 复制仓库地址

### 2️⃣ 配置远程仓库

```bash
# 替换 <仓库地址> 为你刚才复制的地址
git remote add origin <仓库地址>

# 验证配置
git remote -v
```

### 3️⃣ 执行首次提交和推送

```bash
# 添加所有文件
git add .

# 提交
git commit -m "init: 项目初始化"

# 推送到远程（如果是 main 分支，替换 master 为 main）
git push -u origin master
```

### 4️⃣ （推荐）配置 SSH Key

避免每次都输入用户名密码：

```bash
# 生成 SSH key（一路回车即可）
ssh-keygen -t ed25519 -C "your_email@example.com"

# 查看公钥内容
cat ~/.ssh/id_ed25519.pub

# 将公钥添加到 Git 平台的 SSH Keys 设置中
```

然后使用 SSH 地址：
```bash
# GitHub
git remote set-url origin git@github.com:{用户名}/{仓库名}.git

# Gitee
git remote set-url origin git@gitee.com:{用户名}/{仓库名}.git
```

## 🎯 技能自动触发条件

每次修改 `agent/` 目录下的文件后，会自动执行：

1. ✅ `git add agent/` - 添加更改
2. ✅ `git commit -m "{规范的提交信息}"` - 提交更改
3. ✅ `git pull --rebase` - 拉取最新代码
4. ✅ `git push` - 推送到远程
5. ✅ 生成日志到 `agent/workinglog/`

## 📝 提交信息格式

```
{类型} ({范围}): {简短描述}

- 修改时间：{yyyyMMdd-HHmmss}
- 涉及文件：
  - 文件 1
  - 文件 2
- 变更摘要：{简要说明主要变更}
```

**常用类型**:
- `feat`: 新功能
- `fix`: 修复问题
- `docs`: 文档更新
- `refactor`: 重构
- `config`: 配置变更

**常用范围**:
- `agent`: 通用 agent
- `workspace`: 工作空间
- `docker`: Docker 配置
- `skill`: 技能相关

## 🔧 配置文件说明

`.openclaw/auto-push-config.json`:

```json
{
  "autoPush": {
    "enabled": true,              // 是否启用
    "remoteUrl": "",              // 远程仓库地址（可留空手动配置）
    "branch": "main",             // 分支名称
    "autoInit": true,             // 自动初始化
    "generateLogs": true,         // 生成日志
    "logPath": "agent/workinglog/", // 日志路径
    "retryCount": 3               // 失败重试次数
  }
}
```

## 🛡️ 安全特性

- ✅ **敏感信息检测**: 自动检测 password=, secret=, api_key= 等
- ✅ **提交前检查**: 确保只包含 agent 目录的文件
- ✅ **回滚机制**: 记录每个 commit hash，支持快速回滚
- ✅ **冲突处理**: 遇到冲突立即停止并生成报告
- ✅ **大文件警告**: 超过 50MB 的文件会发出警告

## ⚠️ 注意事项

1. **首次使用前必须先推送**: 配置好远程仓库后，先手动执行一次 `git push`
2. **保持网络畅通**: 推送过程需要网络连接
3. **定期检查**: 偶尔检查一下远程仓库，确保推送正常
4. **敏感数据**: 不要在 agent 目录存放密码、密钥等敏感信息
5. **大文件**: 单个文件不要超过 50MB

## 🐛 常见问题

### Q1: 提示 "Permission denied"
**解决**: 配置 SSH key 或使用 HTTPS + 用户名密码

### Q2: 提示 "repository not found"
**解决**: 检查远程仓库地址是否正确，确认仓库已创建

### Q3: Push 失败，网络错误
**解决**: 
- 检查网络连接
- 技能会自动重试 3 次
- 稍后手动执行 `git push`

### Q4: 有冲突
**解决**:
- 技能会停止自动流程
- 手动解决冲突
- 执行 `git add .; git commit; git push`

## 📊 日志位置

所有自动推送的日志都保存在：
```
agent/workinglog/auto-push_{yyyyMMdd-HHmmss}.md
```

每篇日志包含：
- 执行时间和触发原因
- Commit hash
- 涉及文件列表
- 变更统计
- Push 状态
- 远程仓库信息

## 💡 测试技能

修改 agent 目录下的任意文件，例如：

```bash
# 修改某个文件
notepad agent\README.md

# 保存后，技能会自动触发
# 观察终端输出
# 检查 agent\workinglog\ 目录下是否生成新日志
```

## 📞 需要帮助？

查看详细技能文档：`.lingma/skills/auto-push-agent/SKILL.md`

---

**最后更新**: 2026-03-09 21:30  
**技能版本**: 1.0  
**Git 状态**: ✅ 已初始化，待配置远程
