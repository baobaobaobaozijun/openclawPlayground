# Update-LastModified 技能使用说明

## 🎯 核心功能

**增量更新** - 只更新你指定的文件，不是一次性更新所有文件！

---

## 📝 使用方式

### 方式 1: 手动调用（推荐）

```powershell
# 更新单个文件
cd f:\openclaw\agent\scripts
.\Update-LastModified.ps1 README.md

# 更新多个文件（用逗号分隔）
.\Update-LastModified.ps1 README.md,IDENTITY.md,ROLE.md

# 或使用通配符
.\Update-LastModified.ps1 *.md
```

### 方式 2: Git Hook 自动触发

创建 `.git/hooks/pre-commit` 文件：

```bash
#!/bin/bash

# 获取本次 commit 修改的 Markdown 文件
MODIFIED=$(git diff --cached --name-only | grep '\.md$')

if [ -n "$MODIFIED" ]; then
  echo "Updating last modified dates..."
  
  # 转换为 PowerShell 数组格式
  $FILES = $MODIFIED -replace ' ', ','
  
  # 调用 PowerShell 脚本
  powershell.exe -ExecutionPolicy Bypass-File "./scripts/Update-LastModified.ps1" $FILES
  
  # 重新添加到暂存区
  git add $MODIFIED
fi
```

### 方式 3: 集成到 auto-push-agent

修改 `.lingma/skills/auto-push-agent/SKILL.md`:

```markdown
### Pre-Commit Checks

Before every commit:

1. **Update Modified Files' Dates**
   ```powershell
   # Get modified markdown files
   $files = git diff --cached --name-only | Where-Object { $_ -match '\.md$' }
   
  if ($files) {
      .\scripts\Update-LastModified.ps1 $files
    git add $files
   }
   ```
```

---

## ✅ 示例输出

```powershell
PS> .\Update-LastModified.ps1 README.md,IDENTITY.md

========================================
  Update Last Modified Dates
========================================

Date: 2026-03-09

[UPDATED] README.md
[ADDED] IDENTITY.md

========================================
  Complete!
========================================
Updated: 1 files
Added: 1 files
```

---

## ⚠️ 注意事项

1. **只更新指定文件** - 不会批量更新所有文件
2. **需要明确指定文件名** - 可以是一个或多个
3. **排除目录** - workinglog 和 logs/daily_* 会自动跳过

---

*最后更新：2026-03-09*
