---
name: working-logger
description: "工作日志记录器。每次修改 F:\\openclaw\\agent 文件夹内容时自动记录工作日志到 workinglog 目录。"
metadata:
  openclaw:
    emoji: 📝
    requires:
      bins: []
---

# 工作日志记录器 (working-logger)

## 用途

每次修改 `F:\openclaw\agent` 文件夹下的内容时，自动记录工作日志。

## 日志格式

**文件名:** `YYYYMMDD-hhmmss-{修改人}-{修改内容}.md`

**示例:**
```
20260311-232300-suancai-deploy-docker-compose.md
20260311-233000-suancai-setup-monitoring.md
```

**存储位置:** `F:\openclaw\agent\workinglog\`

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
npx working-logger start --modifier "suancai" --description "配置 Docker Compose"
```

### 在修改后调用

```bash
# 完成修改，生成日志
npx working-logger complete --files "code/deploy/docker-compose.yml,code/deploy/nginx/nginx.conf"
```

## 工作流程

```
1. 用户发起修改请求
   ↓
2. 记录修改前的状态
   ↓
3. 执行修改操作
   ↓
4. 生成工作日志文件
   ↓
5. 通知相关 Agent (如修改了对方配置)
   ↓
6. 触发 GitHub push
```

## 注意事项

1. **必须记录**: 任何对 `F:\openclaw\agent` 的修改都要记录
2. **及时通知**: 修改其他 Agent 配置后必须通知对方
3. **格式统一**: 严格按照文件名格式生成
4. **内容清晰**: 日志内容要详细、可追溯

---

*帮助追踪所有变更 📝*
