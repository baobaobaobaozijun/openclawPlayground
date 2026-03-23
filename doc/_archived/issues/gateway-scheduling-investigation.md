# Gateway Agent 调度问题排查报告

**排查时间:** 2026-03-16 15:28  
**排查人:** 灌汤 (PM)  
**问题描述:** 酱肉/豆沙/酸菜从 03-12 至 03-16 失联 4 天，Agent 未被调度激活

---

## ✅ 配置检查结果

### 1. Gateway 配置 (`C:\Users\Administrator\.openclaw\openclaw.json`)

| 检查项 | 配置值 | 状态 |
|--------|--------|------|
| Gateway 端口 | 18790 | ✅ 正常 |
| Gateway 模式 | local (本地运行) | ✅ 正常 |
| Agent 间通信 | enabled: true | ✅ 正常 |
| 允许列表 | [guantang, jiangrou, dousha, suancai] | ✅ 正常 |

### 2. Agent 注册列表

| Agent ID | 工作空间 | 模型 | 状态 |
|----------|---------|------|------|
| guantang | F:\openclaw\agent\workspace-guantang | qwen3.5-plus | ✅ 已注册 |
| jiangrou | F:\openclaw\agent\workspace-jiangrou | qwen3-coder-plus | ✅ 已注册 |
| dousha | F:\openclaw\agent\workspace-dousha | qwen3-coder-plus | ✅ 已注册 |
| suancai | F:\openclaw\agent\workspace-suancai | qwen3-coder-plus | ✅ 已注册 |

### 3. 工具权限配置

**所有 Agent 工具权限:** `profile: full` (除部分飞书工具被 deny)  
**subagents 配置:** `maxConcurrent: 8, maxSpawnDepth: 2` ✅ 正常

---

## 🔍 问题根因分析

### 可能原因

1. **⚠️ 无自动唤醒机制** (主要问题)
   - Gateway 配置中无定时任务或心跳检查
   - Agent 仅在收到消息时被动激活
   - 无消息 → 无激活 → 长期失联

2. **⚠️ 无 inbox 轮询机制**
   - workspace-{agent}/inbox/ 目录无自动监控
   - 任务文件创建后无法触发 Agent 激活

3. **⚠️ 无 Cron 调度配置**
   - `.openclaw/crons/` 目录可能为空
   - 无定时任务唤醒 Agent

### 已验证的正常配置

- ✅ Gateway 进程正常运行 (port 18790)
- ✅ 4 个 Agent 全部注册
- ✅ agentToAgent 通信已启用
- ✅ 工具权限配置正确
- ✅ subagent 功能正常 (本次唤醒测试成功)

---

## 💡 解决方案

### 方案 1: 心跳 Cron 定时任务 (推荐) ⭐

**实现方式:**
```yaml
# .openclaw/crons/agent-heartbeat.yml
name: Agent 心跳检查
schedule:
  kind: every
  everyMs: 600000  # 每 10 分钟
payload:
  kind: agentTurn
  agentId: guantang
  message: "执行心跳检查，唤醒失联 Agent"
```

**优点:**
- 自动触发，无需人工干预
- 灌汤 PM 每 10 分钟主动检查各 Agent 状态
- 发现失联立即 subagent 唤醒

### 方案 2: inbox 目录监控 (增强)

**实现方式:**
- 修改 Gateway 配置，添加 inbox 目录监控
- 当 workspace-{agent}/inbox/ 有新文件时触发激活

**优点:**
- 任务分配即可触发 Agent 激活
- 无需等待定时任务

### 方案 3: 手动唤醒流程 (临时)

**实现方式:**
- PM 发现失联 → sessions_spawn 直接调用
- 本次已成功验证

**缺点:**
- 需人工介入
- 无法保证及时发现

---

## 📋 行动计划

### 立即执行 (15:30 前)
- [x] ✅ 排查 Gateway 配置
- [x] ✅ 确认 Agent 注册状态
- [ ] 创建 Cron 定时任务配置
- [ ] 测试 Cron 触发效果

### 今日完成 (18:00 前)
- [ ] 部署心跳 Cron 任务
- [ ] 验证每 10 分钟自动检查
- [ ] 测试失联自动唤醒流程

### 持续改进
- [ ] 添加 inbox 目录监控 (可选)
- [ ] 建立告警升级机制 (失联>2 小时)
- [ ] 完善心跳监控仪表板

---

## 🎯 结论

**问题根因:** Gateway 无自动唤醒机制，Agent 被动等待消息激活

**解决方案:** 部署 Cron 定时任务，每 10 分钟触发灌汤 PM 执行心跳检查

**临时措施:** 使用 sessions_spawn 手动唤醒 (本次已成功验证)

**长期机制:** 心跳 Cron + inbox 监控 + 告警升级

---

**排查人:** 灌汤 (PM) 🍲  
**排查时间:** 2026-03-16 15:28  
**下次检查:** 15:30 (部署 Cron 任务)
