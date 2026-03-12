---
name: working-logger
description: "工作日志记录器。每次 F:\\openclaw 文件内容更改后强制编写工作日志到 workinglog 目录。"
metadata:
  openclaw:
    emoji: 📝
    requires:
      bins: []
---

# 工作日志记录器 (working-logger)

## 用途

**强制触发:** 每次 `F:\openclaw` 文件夹下的内容发生更改时，必须自动记录工作日志。

## 日志格式

**文件名:** `YYYYMMDD-hhmmss-{修改人}-{修改内容}.md`

**示例:**
```
20260309-224500-guantang-update-dousha-config.md
20260309-230000-guantang-add-new-feature.md
```

**存储位置:** `F:\openclaw\agent\workinglog\{agent}\`

## 日志内容模板

```markdown
<!-- Last Modified: {日期} -->

# 工作日志

## 修改信息
- **修改人:** {修改人}
- **修改时间:** {YYYY-MM-DD HH:mm:ss}
- **修改类型:** {config|code|docs|other}

## 修改内容
{详细描述修改了什么}

## 修改的文件
- `文件路径 1` - 修改说明
- `文件路径 2` - 修改说明

## 关联通知
- [ ] 已通知相关 Agent 更新配置
- [ ] 已推送到 GitHub

---

*日志自动生成*
```

## 使用方式

### 在修改前调用

```bash
# 记录即将进行的修改
npx working-logger start --modifier "guantang" --description "更新豆沙配置"
```

### 在修改后调用

```bash
# 完成修改，生成日志
npx working-logger complete --files "modified-file-1.md,modified-file-2.md"
```

## 工作流程

```
1. 检测到 F:\openclaw 文件更改
   ↓
2. 强制触发日志记录
   ↓
3. 生成工作日志文件
   ↓
4. 通知相关 Agent (如修改了对方配置)
   ↓
5. 触发 Git 提交和推送
```

## 注意事项

1. **强制记录**: 任何对 `F:\openclaw` 的修改都必须记录日志
2. **统一路径**: 日志必须保存到 `F:\openclaw\agent\workinglog\{agent}\`
3. **及时通知**: 修改其他 Agent 配置后必须通知对方
4. **格式统一**: 严格按照文件名格式生成
5. **内容清晰**: 日志内容要详细、可追溯

---

*帮助追踪所有变更 📝*
