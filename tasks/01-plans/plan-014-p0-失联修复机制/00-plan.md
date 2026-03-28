# 强制进度汇报机制 — 执行计划

**创建时间:** 2026-03-28 00:20  
**负责人:** 灌汤 (PM)  
**状态:** 立即执行

---

## 阶段 1：强制进度汇报（立即执行）

### 行动项

| 序号 | 任务 | 交付物 | 状态 |
|------|------|--------|------|
| 1 | 创建进度汇报模板 | `doc/06-templates/progress-report-template.md` | ✅ 完成 |
| 2 | 通知全员新机制 | sessions_spawn 通知 | ⏳ 待执行 |
| 3 | 创建监控脚本 | `_tools/check-agent-status.ps1` | ✅ 完成 |

### 通知内容

```
【PM 灌汤 — 新机制通知 🔴 重要】

{Agent} 你好，

为解决失联问题，即日起执行强制进度汇报机制：

**汇报频率：**
- 执行中：每 30 分钟主动汇报
- 阻塞：立即汇报
- 完成：立即汇报
- 空闲：每 60 分钟汇报

**汇报格式：**
使用模板：doc/06-templates/progress-report-template.md

**违规处理：**
- 首次超时（>35 分钟）→ 自动提醒
- 二次超时 → PM 警告
- 三次超时 → 记录违规，调整任务分配

**立即生效。**
```

---

## 阶段 2：实时状态面板（今日完成）

### 行动项

| 序号 | 任务 | 交付物 | 状态 |
|------|------|--------|------|
| 1 | 创建状态文件目录 | `F:\openclaw\agent\status\` | ✅ 完成 |
| 2 | 创建状态更新脚本 | `_tools/update-agent-status.ps1` | ✅ 完成 |
| 3 | 创建状态检查脚本 | `_tools/check-agent-status.ps1` | ✅ 完成 |
| 4 | 创建状态面板文档 | `doc/05-progress/agent-status-dashboard.md` | ✅ 完成 |
| 5 | 设置 Cron 定时任务 | 每 5 分钟检查状态 | ⏳ 待执行 |

---

## 阶段 3：任务交付确认（明日执行）

### 行动项

| 序号 | 任务 | 交付物 | 状态 |
|------|------|--------|------|
| 1 | 创建任务交付模板 | `doc/06-templates/task-delivery-template.md` | ✅ 完成 |
| 2 | 通知全员交付流程 | sessions_spawn 通知 | ⏳ 待执行 |
| 3 | PM 验收流程培训 | - | ⏳ 待执行 |

---

## Cron 定时任务配置

### 状态检查（每 5 分钟）

```yaml
# .openclaw/crons/agent-status-check.yml
action: exec
command: powershell -ExecutionPolicy Bypass -File "F:\openclaw\agent\workspace-guantang\_tools\check-agent-status.ps1"
schedule: "*/5 * * * *"
timeout: 60
```

### 进度汇报提醒（每 30 分钟）

```yaml
# .openclaw/crons/progress-report-reminder.yml
action: exec
command: powershell -ExecutionPolicy Bypass -File "F:\openclaw\agent\workspace-guantang\_tools\notify-agent-lost.ps1"
schedule: "*/30 * * * *"
timeout: 60
```

---

## 执行时间线

```
2026-03-28 00:20 — 创建所有模板和脚本 ✅
2026-03-28 00:25 — 通知全员新机制 ⏳
2026-03-28 00:30 — 设置 Cron 定时任务 ⏳
2026-03-28 00:35 — 第一次状态检查 ⏳
2026-03-28 01:00 — 第一次进度汇报截止 ⏳
```

---

## 验收标准

- [ ] 全员收到新机制通知
- [ ] Cron 定时任务配置完成
- [ ] 状态面板每 5 分钟刷新
- [ ] 失联自动告警功能正常
- [ ] 首次进度汇报按时完成

---

*计划版本：v1.0 | 创建者：灌汤 PM | 2026-03-28 00:20*
