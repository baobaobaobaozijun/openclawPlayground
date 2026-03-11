# Git Push 序列号管理机制

**创建日期:** 2026-03-10  
**维护者:** 鲜肉 (Xianrou)  
**用途:** 管理和追踪所有 Git Push 操作的序列号

## 📋 序列号文件结构

### .push-sequence.json

**文件位置:** `agent/workinglog/.push-sequence.json`

**文件格式:**
```json
{
  "sequence": 0,
  "lastUpdated": "yyyyMMdd-HHmmss",
  "history": [
    {
      "sequence": 1,
      "timestamp": "yyyyMMdd-HHmmss",
      "commitHash": "abc123def456",
      "message": "feat(agent): 初始提交"
    },
    {
      "sequence": 2,
      "timestamp": "yyyyMMdd-HHmmss",
      "commitHash": "789xyz012abc",
      "message": "docs(readme): 更新文档"
    }
  ]
}
```

**字段说明:**
- `sequence`: 当前最新的序列号 (整数)
- `lastUpdated`: 最后更新时间戳
- `history`: 历史记录数组，包含每次 push 的详细信息

## 🔧 使用方法

### 1. 初始化序列号

如果是第一次使用，创建 `.push-sequence.json` 文件:

```json
{
  "sequence": 0,
  "lastUpdated": null,
  "history": []
}
```

### 2. 生成新序列号

每次执行 Git Push 时:

```javascript
// 伪代码示例
const fs = require('fs');
const path = require('path');

// 读取序列号文件
const sequenceFile = path.join(__dirname, '.push-sequence.json');
let data = JSON.parse(fs.readFileSync(sequenceFile, 'utf-8'));

// 递增序列号
data.sequence += 1;
const newSequence = data.sequence.toString().padStart(3, '0'); // 格式化为 #001, #002...

// 更新信息
data.lastUpdated = getCurrentTimestamp(); // yyyyMMdd-HHmmss
data.history.push({
  sequence: data.sequence,
  timestamp: data.lastUpdated,
  commitHash: getLatestCommitHash(),
  message: getLatestCommitMessage()
});

// 写回文件
fs.writeFileSync(sequenceFile, JSON.stringify(data, null, 2));

return `#${newSequence}`;
```

### 3. 在日志中使用

生成的 Git Push 日志文件名:
```
auto-push_20260310-213045_#001.md
auto-push_20260310-220130_#002.md
auto-push_20260310-225015_#003.md
```

日志内容中的基本信息:
```markdown
# Auto Push 记录 - 20260310-213045 - #001

## 基本信息
- **执行时间**: 2026-03-10 21:30:45 - 21:30:53
- **Git Push 序列号**: #001
- **触发原因**: 更新 Agent 配置文件
- **提交哈希**: a1b2c3d4e5f6
- **涉及文件**: 
  - IDENTITY.md
  - ROLE.md
```

## 📊 序列号的优势

### 1. 易于追踪
- 每个 push 操作都有唯一标识
- 可以通过序列号快速定位日志
- 便于引用和讨论特定的推送

### 2. 统计分析
- 统计每天/周/月的推送次数
- 分析推送频率和模式
- 识别活跃时间段

### 3. 版本管理
- 清晰的推送历史
- 便于回滚和恢复
- 支持审计和合规

### 4. 团队协作
- 团队成员可以引用相同的序列号
- 减少沟通成本
- 提高协作效率

## 🔄 与其他技能的集成

### execution-log 技能

在执行日志中也需要包含 Git Push 序列号:

```markdown
# 工作内容执行记录

## 基本信息
- **执行时间**: 2026-03-10 21:30:00-21:30:45
- **触发命令**: 请更新 Agent 配置文件
- **Git Push 序列号**: #001
- **涉及文件**: 
  - IDENTITY.md
  - ROLE.md
```

### auto-push-agent 技能

自动在 push 日志中包含序列号:

```markdown
# Auto Push 记录 - 20260310-213045 - #001

## 基本信息
- **Git Push 序列号**: #001
```

## ⚙️ 配置选项

### 序列号格式化

可以在配置文件中自定义格式:

```json
{
  "sequenceFormat": "#{number}",
  "paddingLength": 3,
  "paddingChar": "0",
  "prefix": "#",
  "resetPolicy": "never"
}
```

**可选的重置策略:**
- `never`: 从不重置 (默认)
- `daily`: 每天重置
- `weekly`: 每周重置 (周一)
- `monthly`: 每月重置 (1 号)

### 历史记录保留

配置保留多少条历史记录:

```json
{
  "maxHistorySize": 1000,
  "archiveOldRecords": true,
  "archivePath": "agent/workinglog/sequence-archive/"
}
```

## 📝 示例脚本

### PowerShell 脚本 (Windows)

```powershell
# update-push-sequence.ps1
$sequenceFile = "agent\workinglog\.push-sequence.json"

# 读取或创建序列号文件
if (Test-Path $sequenceFile) {
    $data = Get-Content $sequenceFile -Raw | ConvertFrom-Json
} else {
    $data = @{
        sequence = 0
        lastUpdated = $null
        history = @()
    }
}

# 递增序列号
$data.sequence += 1
$newSequence = "{0:D3}" -f $data.sequence

# 获取当前时间戳
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

# 获取最新的 commit 信息
$commitHash = git rev-parse --short HEAD
$commitMessage = git log -1 --pretty=%s

# 更新数据
$data.lastUpdated = $timestamp
$data.history += @{
    sequence = $data.sequence
    timestamp = $timestamp
    commitHash = $commitHash
    message = $commitMessage
}

# 写回文件
$data | ConvertTo-Json -Depth 10 | Set-Content $sequenceFile -Encoding UTF8

Write-Host "Git Push 序列号：#$newSequence"
```

### Bash 脚本 (Linux/Mac)

```bash
#!/bin/bash
# update-push-sequence.sh

SEQUENCE_FILE="agent/workinglog/.push-sequence.json"

# 读取或创建序列号文件
if [ -f "$SEQUENCE_FILE" ]; then
    sequence=$(jq -r '.sequence' "$SEQUENCE_FILE")
else
    sequence=0
fi

# 递增序列号
new_sequence=$((sequence + 1))
formatted_sequence=$(printf "#%03d" $new_sequence)

# 获取当前时间戳
timestamp=$(date +"%Y%m%d-%H%M%S")

# 获取最新的 commit 信息
commit_hash=$(git rev-parse --short HEAD 2>/dev/null || echo "N/A")
commit_message=$(git log -1 --pretty=%s 2>/dev/null || echo "N/A")

# 创建新的历史记录
new_history=$(jq -n \
  --arg seq "$new_sequence" \
  --arg ts "$timestamp" \
  --arg hash "$commit_hash" \
  --arg msg "$commit_message" \
  '{sequence: ($seq | tonumber), timestamp: $ts, commitHash: $hash, message: $msg}')

# 更新文件
jq ".sequence = $new_sequence | .lastUpdated = \"$timestamp\" | .history += [$new_history]" \
  "$SEQUENCE_FILE" > "${SEQUENCE_FILE}.tmp" && mv "${SEQUENCE_FILE}.tmp" "$SEQUENCE_FILE"

echo "Git Push 序列号：$formatted_sequence"
```

## 🎯 最佳实践

### 1. 保持一致性
- 每次都更新序列号，不要跳过
- 确保序列号和实际 push 一一对应
- 手动 push 也要记录序列号

### 2. 定期备份
- 定期备份 `.push-sequence.json` 文件
- 可以将历史记录归档到单独的文件
- 避免文件过大影响性能

### 3. 监控异常
- 如果发现序列号跳跃，检查是否有遗漏的记录
- 定期检查历史记录的完整性
- 发现问题及时修复

### 4. 文档化
- 在团队内部文档中说明序列号的使用方法
- 培训新成员了解和使用序列号
- 在日志模板中包含序列号字段

## 🔍 常见问题

### Q1: 序列号文件丢失了怎么办？

**A:** 重新创建文件并从 git log 中恢复历史记录:

```bash
# 从 git 历史中重建
git log --oneline | tail -n 100 | while read hash msg; do
  # 提取信息并重建历史记录
done
```

### Q2: 可以修改已有的序列号吗？

**A:** 不建议修改。序列号应该是不可变的，如果需要修正，添加新的记录而不是修改旧的。

### Q3: 序列号应该多大开始？

**A:** 从 1 开始。如果是中途引入这个机制，可以从当前的 push 数量开始。

---

**状态:** ✅ 已实施  
**版本:** 1.0  
**最后更新:** 2026-03-10
