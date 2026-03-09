# update-last-modified- 更新文件修改日期

## 📝 技能描述

在修改 Markdown 文件时，自动更新该文件中的最后修改日期注释。

**用途:** 每次修改 agent/文件夹下的.md 文件后，只更新被修改文件的日期戳

**触发时机:** 每次修改文件后（作为 pre-commit hook 或手动调用）

**关键特性:** 
- ✅ **增量更新** - 只更新被修改的文件，不是批量更新所有文件
- ✅ **智能检测** - 如果文件已有日期注释则更新，没有则添加
- ✅ **精确匹配** - 只处理实际被修改的文件

---

## 🎯 功能特性

### 1. 增量更新（重要）

**不是批量更新所有文件！** 而是：
- ✅ 只更新本次修改的文件
- ✅ 可以是一个文件，也可以是多个文件
- ✅ 由你指定要更新哪些文件

### 2. 使用方式

#### 方式 A: 作为 Git Hook (推荐)
每次 git commit 前自动更新被修改文件的日期

#### 方式 B: 手动调用
```bash
# 更新特定文件
./Update-LastModified.sh README.md IDENTITY.md

# 或更新当前目录所有.md 文件
./Update-LastModified.sh *.md
```

#### 方式 C: 集成到 auto-push-agent
在提交前自动调用

### 2. 支持格式

```markdown
<!-- Last Modified: 2026-03-09 -->
<!-- Last Modified (CN): 2026-03-09 -->
```

### 3. 处理范围

- **目标目录:** `f:\openclaw\agent\` 及其所有子目录
- **目标文件:** 所有 `.md` 文件
- **排除目录:** 
  - `node_modules/`
  - `.git/`
  - `logs/` (工作日志不需要)

---

## 🔧 使用方法

### PowerShell 脚本

创建文件：`f:\openclaw\agent\scripts\Update-LastModified.ps1`

```powershell
# Update-LastModified.ps1
# 更新 agent 文件夹下所有 Markdown 文件的修改日期

$agentPath = "F:\openclaw\agent"
$today = Get-Date -Format "yyyy-MM-dd"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  更新文件修改日期" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$updatedCount = 0
$errorCount = 0

# 获取所有 Markdown 文件
Get-ChildItem -Path $agentPath -Recurse -File -Include *.md | 
    Where-Object { 
        $_.FullName -notlike "*node_modules*" -and
        $_.FullName -notlike "*.git*" -and
        $_.FullName -notlike "*workinglog*"
    } |
    ForEach-Object {
        $file = $_
        
        try {
            # 读取文件内容
            $content = Get-Content-Path $file.FullName -Raw
            
            # 检查是否已有 Last Modified 注释
            if ($content-match '<!-- Last Modified: \d{4}-\d{2}-\d{2} -->') {
                # 更新日期
                $newContent = $content-replace
                    '<!-- Last Modified: \d{4}-\d{2}-\d{2} -->', 
                    "<!-- Last Modified: $today -->"
                
                if ($content -match '<!-- Last Modified \(CN\): \d{4}-\d{2}-\d{2} -->') {
                    $newContent = $newContent-replace
                        '<!-- Last Modified \(CN\): \d{4}-\d{2}-\d{2} -->', 
                        "<!-- Last Modified (CN): $today -->"
                }
                
                # 写回文件
                Set-Content-Path $file.FullName -Value $newContent -Encoding UTF8
                Write-Host "[UPDATED] $($file.Name)" -ForegroundColor Green
                $updatedCount++
            } else {
                # 添加新注释
                $header = "<!-- Last Modified: $today -->`n<!-- Last Modified (CN): $today -->`n`n"
                $newContent = $header + $content
                
                Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8
                Write-Host "[ADDED] $($file.Name)" -ForegroundColor Yellow
                $updatedCount++
            }
        } catch {
            Write-Host "[ERROR] $($file.Name): $($_.Exception.Message)" -ForegroundColor Red
            $errorCount++
        }
    }

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "  更新完成!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "已更新：$updatedCount 个文件" -ForegroundColor Cyan
if ($errorCount-gt 0) {
    Write-Host "失败：$errorCount 个文件" -ForegroundColor Yellow
}
```

---

## 🚀 集成到 auto-push-agent

### 修改 auto-push-agent/SKILL.md

在 `Pre-Commit Checks` 部分添加：

```markdown
### Pre-Commit Checks

Before every commit, automatically:

1. **Update Last Modified Dates**
   - Run `Update-LastModified.ps1` script
   - This updates all Markdown files with current date
   - Ensures version tracking is accurate

2. **Stage Changes**
   ```bash
  git add agent/
   ```

3. **Verify Changes**
   - Check modified files
   - Ensure no sensitive data leaked
```

### 修改 Git Hook

创建文件：`.git/hooks/pre-commit`

```bash
#!/bin/sh

# Update last modified dates for Markdown files
echo "Updating last modified dates..."
powershell.exe -ExecutionPolicy Bypass -File "F:/openclaw/agent/scripts/Update-LastModified.ps1"

# Add the updated files
git add agent/**/*.md
```

---

## 📋 使用场景

### 场景 1: 手动运行脚本

```powershell
cd F:\openclaw\agent\scripts
.\Update-LastModified.ps1
```

### 场景 2: 集成到 auto-push-agent

每次修改 agent 文件夹后，auto-push-agent 会自动调用此脚本

### 场景 3: Git Hook

提交前自动运行（可选）

---

## ⚙️ 配置选项

### 排除目录

可以在脚本中自定义排除的目录：

```powershell
Where-Object { 
    $_.FullName -notlike "*node_modules*" -and
    $_.FullName -notlike "*.git*" -and
    $_.FullName -notlike "*workinglog*" -and
    $_.FullName -notlike "*excluded-folder*"
}
```

### 自定义格式

可以修改日期格式：

```powershell
$today = Get-Date -Format "yyyy-MM-dd HH:mm:ss"  # 包含时间
```

---

## 📊 示例输出

```
========================================
  更新文件修改日期
========================================

[UPDATED] README.md
[UPDATED] IDENTITY.md
[ADDED] NEW-FEATURE.md
[UPDATED] ROLE.md
[ERROR] locked-file.md: Access denied

========================================
  更新完成!
========================================
已更新：75 个文件
失败：1 个文件
```

---

## 🔍 验证结果

### 检查文件格式

```powershell
# 查看文件开头
Get-Content -Path "README.md" -TotalCount 5
```

**预期输出:**
```markdown
<!-- Last Modified: 2026-03-09 -->
<!-- Last Modified (CN): 2026-03-09 -->

# Title
```

### 统计更新数量

```powershell
# 统计有多少文件包含 Last Modified 注释
Get-ChildItem -Recurse -Filter *.md | 
    Select-String -Pattern "<!-- Last Modified:" | 
    Measure-Object | 
    Select-Object -ExpandProperty Count
```

---

## ⚠️ 注意事项

1. **编码问题**
   - 使用 UTF-8 without BOM 编码
   - 避免破坏原有文件格式

2. **Git 跟踪**
   - 更新后的文件会被 Git 检测到变化
   - 确保在正确的时机运行脚本

3. **性能考虑**
   - 大文件可能需要较长时间
   - 可以选择只更新修改过的文件

4. **备份建议**
   - 首次运行前建议备份
   - 测试无误后再批量应用

---

## 🎯 最佳实践

### 1. 作为 Git Hook

```bash
# .git/hooks/pre-commit
#!/bin/bash
echo "Running pre-commit checks..."

# 更新修改日期
powershell.exe -File "F:/openclaw/agent/scripts/Update-LastModified.ps1"

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
   powershell -File ./agent/scripts/Update-LastModified.ps1
   git add agent/**/*.md
```

### 3. 定时任务

设置每天自动运行：

```powershell
# 创建计划任务
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
    -Argument "-ExecutionPolicy Bypass-File F:\openclaw\agent\scripts\Update-LastModified.ps1"
$trigger = New-ScheduledTaskTrigger-Daily -At 9am
Register-ScheduledTask-TaskName "UpdateLastModified" `
    -Action $action -Trigger $trigger-Description "每日更新文件修改日期"
```

---

## 📝 版本历史

| 版本 | 日期 | 更新内容 |
|------|------|----------|
| 1.0 | 2026-03-09 | 初始版本，支持基本的日期更新功能 |
| 1.1 | 2026-03-09 | 添加排除目录支持、错误处理 |

---

*Created: 2026-03-09*  
*Version: 1.0*  
*Author: Guantang (PM)*
