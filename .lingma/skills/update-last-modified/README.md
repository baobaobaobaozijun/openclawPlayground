# Update Last Modified Skill- 使用说明

## 📝 技能概述

**技能名称:** update-last-modified  
**用途:** 自动更新 agent 文件夹下所有 Markdown 文件的修改日期注释  
**触发时机:** 每次修改 agent/文件夹下的文件后

---

## 🎯 功能特性

### 1. 自动检测

- ✅ 检测文件是否已有 `<!-- Last Modified: YYYY-MM-DD -->` 注释
- ✅ 如果有则更新日期为当前日期
- ✅ 如果没有则添加新的日期注释

### 2. 支持格式

```markdown
<!-- Last Modified: 2026-03-09 -->
<!-- Last Modified (CN): 2026-03-09 -->
```

### 3. 处理范围

**目标目录:** `f:\openclaw\agent\` 及其所有子目录  
**目标文件:** 所有 `.md` 文件  
**排除目录:** 
- `node_modules/`
- `.git/`
- `workinglog/` (工作日志不需要)
- `logs/daily_*` (每日日志不需要)

---

## 🛠️ 使用方法

### 方法 1: 手动运行脚本

```bash
# Windows (Git Bash)
cd f:\openclaw\agent\scripts
./Update-LastModified.sh

# Linux/Mac
cd /path/to/openclaw/agent/scripts
./Update-LastModified.sh
```

### 方法 2: 集成到 auto-push-agent

在 `.lingma/skills/auto-push-agent/SKILL.md` 中添加：

```markdown
### Pre-Commit Checks

Before every commit, automatically:

1. **Update Last Modified Dates**
   - Run `scripts/Update-LastModified.sh`
   - This updates all Markdown files with current date
   -Ensures version tracking is accurate

2. **Stage Changes**
   ```bash
  git add agent/
   ```

3. **Verify Changes**
   - Check modified files
   -Ensure no sensitive data leaked
```

### 方法 3: Git Hook

创建 `.git/hooks/pre-commit` 文件：

```bash
#!/bin/bash

echo "Updating last modified dates..."
./scripts/Update-LastModified.sh

# Add updated files
git add agent/**/*.md
```

---

## 📊 示例输出

```bash
$ ./Update-LastModified.sh

========================================
  Update Last Modified Dates
========================================

Target: /f/openclaw/agent
Date: 2026-03-09

[UPDATED] README.md
[UPDATED] IDENTITY.md
[ADDED] NEW-FEATURE.md
[UPDATED] ROLE.md

========================================
  Complete!
========================================
Updated: 75 files
Added: 1 files
```

---

## 🔍 验证结果

### 检查文件格式

```bash
# 查看文件开头
head -n 5 README.md
```

**预期输出:**
```markdown
<!-- Last Modified: 2026-03-09 -->
<!-- Last Modified (CN): 2026-03-09 -->

# Title
```

### 统计更新数量

```bash
# 统计有多少文件包含 Last Modified 注释
grep -r "<!-- Last Modified:" agent --include="*.md" | wc -l
```

---

## ⚙️ 配置选项

### 排除目录

在脚本中修改排除规则：

```bash
if [[ "$file" == *"node_modules"* ]] || \
   [[ "$file" == *".git"* ]] || \
   [[ "$file" == *"workinglog"* ]] || \
   [[ "$file" == *"excluded-folder"* ]]; then
    continue
fi
```

### 自定义格式

可以修改日期格式或添加额外信息：

```bash
TODAY=$(date +"%Y-%m-%d %H:%M:%S")  # 包含时间
```

---

## ⚠️ 注意事项

1. **编码问题**
   - 脚本使用 UTF-8 编码保存文件
   - 避免破坏原有文件格式

2. **Git 跟踪**
   - 更新后的文件会被 Git 检测到变化
   - 确保在正确的时机运行脚本

3. **备份建议**
   - 首次运行前建议备份重要文件
   - 测试无误后再批量应用

4. **权限问题**
   - 确保脚本有执行权限：`chmod +x Update-LastModified.sh`
   - 如果遇到权限错误，使用 `sudo` 或检查文件权限

---

## 🎯 最佳实践

### 1. 作为 Git Hook

```bash
# .git/hooks/pre-commit
#!/bin/bash
echo "Running pre-commit checks..."

# 更新修改日期
./scripts/Update-LastModified.sh

# 添加更新的文件
git add agent/**/*.md

echo "Pre-commit checks complete."
exit 0
```

### 2. 集成到 CI/CD

在 GitHub Actions 中添加：

```yaml
- name: Update Last Modified Dates
  run: |
    ./scripts/Update-LastModified.sh
   git add agent/**/*.md
```

### 3. 定时任务

设置每天自动运行（crontab）：

```bash
# 每天早上 9 点自动运行
0 9 * * * /path/to/scripts/Update-LastModified.sh
```

---

## 📝 版本历史

| 版本 | 日期 | 更新内容 |
|------|------|----------|
| 1.0 | 2026-03-09 | 初始版本，支持基本的日期更新功能 |
| 1.1 | 2026-03-09 | 添加排除目录支持、错误处理 |

---

## 🔗 相关文件

- **Skill 文件:** `.lingma/skills/update-last-modified/SKILL.md`
- **脚本文件:** `agent/scripts/Update-LastModified.sh`
- **快速参考:** `agent/AUTO-PUSH-QUICK-REFERENCE.md`

---

*Created: 2026-03-09*  
*Version: 1.0*  
*Author: Guantang (PM)*
