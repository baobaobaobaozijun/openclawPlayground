# 心跳机制 v3.1 更新日志

**版本:** v3.1 (幂等版)  
**更新日期:** 2026-03-26 22:05  
**负责人:** 灌汤 (PM) 🍲

---

## 🎯 更新目标

解决 v3.0 机制的**幂等性问题**，确保：
1. 系统重启后不重复派发任务
2. 数据库是唯一真实状态来源
3. 所有状态变更可追溯

---

## 🔑 核心改进

### 1. 数据库唯一约束

```sql
ALTER TABLE pipeline_agent_tasks
ADD UNIQUE KEY uk_plan_round_agent (plan_id, round_id, agent_id);
```

**作用:** 防止同一任务被重复插入，确保幂等性。

### 2. 幂等检查脚本

**文件:** `_tools/check-idempotency.ps1`

**功能:**
- 派发前查询数据库任务状态
- 根据状态决定是否派发：
  - `completed` → 跳过（检查交付物）
  - `executing` → 检查超时（>60 分钟重做）
  - `failed` → 检查重试次数（≤2 次可重试）
  - `assigned` → 检查超时（>30 分钟重新派发）

### 3. 更新派发工具

**文件:** `_tools/update-db-task-assigned.ps1`

**改进:**
- 调用 `check-idempotency.ps1` 进行派发前检查
- 使用 `INSERT ... ON DUPLICATE KEY UPDATE` 确保幂等
- 支持重做 (redo)、重试 (retry)、重新派发 (redispatch)

### 4. 恢复脚本

**文件:** `_tools/restore-pipeline.ps1`

**功能:**
- 系统启动时自动执行
- 查询进行中的计划
- 检查交付物是否存在
- 更新任务状态（completed/failed）
- 记录系统事件到数据库

### 5. 心跳 Cron 更新

**文件:** `.openclaw/crons/agent-heartbeat.yml`

**改进:**
- 改用数据库查询判定失联/空闲
- 调用 `update-db-task-assigned.ps1` 派发（内置幂等检查）
- 记录详细文档说明

---

## 📊 数据库 Schema 变更

| 表 | 变更 | 说明 |
|----|------|------|
| `pipeline_agent_tasks` | 添加唯一键 `uk_plan_round_agent` | 幂等性核心保证 |
| `pipeline_rounds` | 已有唯一键 `uk_plan_round` | 无需变更 |

---

## 🛠️ 新增工具脚本

| 文件 | 用途 | 调用时机 |
|------|------|---------|
| `_tools/check-idempotency.ps1` | 幂等检查 | 派发前必须调用 |
| `_tools/restore-pipeline.ps1` | 系统恢复 | Gateway 启动时自动执行 |
| `_tools/verify-idempotency.ps1` | 验证幂等机制 | 手动测试用 |

---

## 📝 更新的文件

| 文件 | 变更内容 |
|------|---------|
| `HEARTBEAT.md` | 添加 v3.1 幂等机制说明 |
| `_tools/update-db-task-assigned.ps1` | 添加幂等检查 |
| `.openclaw/crons/agent-heartbeat.yml` | 改用数据库查询 |
| `.openclaw/crons/pipeline-recovery.yml` | 使用恢复脚本 |
| `openclaw.json` | 为所有 Agent 添加 plan-db-sync skill |
| 各 Agent `.env` | 添加数据库配置 |

---

## ✅ 验证结果

**唯一约束:**
```
✅ uk_plan_round_agent (plan_id, round_id, agent_id)
```

**计划状态:**
```
✅ plan-001 ~ plan-005: completed (5/5 轮)
⏳ plan-008: pending (0/3 轮)
```

**幂等测试:**
```
✅ 第一次插入：成功
✅ 第二次插入：触发 ON DUPLICATE KEY UPDATE
✅ 查询结果：仅 1 条记录
```

---

## 🎯 幂等性保证流程

```
派发任务流程:
1. 调用 check-idempotency.ps1
   ├─ 查询数据库
   ├─ 检查任务状态
   └─ 返回 CanDispatch (true/false)
2. CanDispatch = false → 跳过派发
3. CanDispatch = true → 调用 update-db-task-assigned.ps1
   ├─ INSERT ... ON DUPLICATE KEY UPDATE
   ├─ 更新 pipeline_state_history
   └─ sessions_spawn 派发

系统恢复流程:
1. Gateway 启动 → 触发 pipeline-recovery.yml
2. 执行 restore-pipeline.ps1
   ├─ 查询 executing 计划
   ├─ 检查交付物是否存在
   ├─ 更新任务状态
   └─ 记录系统事件
3. 恢复完成，等待 PM 确认
```

---

## 📋 后续工作

- [ ] 测试完整派发流程（含幂等检查）
- [ ] 测试系统重启恢复
- [ ] 更新计划文档（00-plan.md, 01-round-orders.md）
- [ ] 创建可视化监控仪表板

---

**维护者:** 灌汤 (PM) 🍲  
**文档位置:** `F:\openclaw\agent\doc\guides\heartbeat-v3.1-changelog.md`
