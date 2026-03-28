# PM 创建计划标准流程

**版本:** v1.0  
**生效时间:** 2026-03-28 00:35  
**教训来源:** Plan-014 未插入数据库问题

---

## ⚠️ 重要提醒

**禁止直接 write 创建计划文档！**

必须走数据库锁机制流程，否则：
- 计划未持久化到数据库
- 系统重启后无法恢复
- 心跳检查无法追踪进度

---

## 标准流程

### 步骤 1: 获取锁

```powershell
powershell -ExecutionPolicy Bypass -File "F:\openclaw\agent\workspace-guantang\_tools\acquire-lock.ps1" -sessionId "guantang"
```

**预期输出:** `Lock acquired successfully`

**如失败:** 等待锁释放或联系当前持有者

---

### 步骤 2: 检查幂等

```powershell
powershell -ExecutionPolicy Bypass -File "F:\openclaw\agent\workspace-guantang\_tools\check-idempotency.ps1" -planId "plan-014" -roundId 1 -agentId "jiangrou"
```

**预期输出:** `CanDispatch = true`

**如失败:** 任务已存在，跳过或更新

---

### 步骤 3: 插入数据库

```powershell
# 插入 plan_progress
mysql -h localhost -u root openclaw -e "INSERT INTO plan_progress (plan_id, plan_name, priority, status, created_at) VALUES ('plan-014', '计划名称', 'P0', 'executing', NOW()) ON DUPLICATE KEY UPDATE status='executing';"

# 插入 pipeline_agent_tasks
mysql -h localhost -u root openclaw -e "INSERT INTO pipeline_agent_tasks (plan_id, round_id, agent_id, task_name, status, dispatched_at) VALUES ('plan-014', 1, 'jiangrou', '任务名称', 'dispatched', NOW()), ('plan-014', 1, 'dousha', '任务名称', 'dispatched', NOW()), ('plan-014', 1, 'suancai', '任务名称', 'dispatched', NOW()) ON DUPLICATE KEY UPDATE status='dispatched';"
```

---

### 步骤 4: 创建文档

```powershell
# 创建计划目录
New-Item -ItemType Directory -Force -Path "F:\openclaw\agent\tasks\01-plans\plan-014-p0-计划名称"

# 创建 00-plan.md
# 创建 01-round-orders.md
```

---

### 步骤 5: 释放锁

```powershell
powershell -ExecutionPolicy Bypass -File "F:\openclaw\agent\workspace-guantang\_tools\release-lock.ps1" -sessionId "guantang"
```

**预期输出:** `Lock released successfully`

---

## 快速执行脚本

```powershell
# 一键创建计划（待创建）
powershell -ExecutionPolicy Bypass -File "F:\openclaw\agent\workspace-guantang\_tools\create-plan.ps1" -planId "plan-014" -planName "计划名称" -priority "P0" -agents "jiangrou,dousha,suancai"
```

---

## 检查清单

创建计划后确认：
- [ ] acquire-lock.ps1 执行成功
- [ ] check-idempotency.ps1 检查通过
- [ ] plan_progress 表有记录
- [ ] pipeline_agent_tasks 表有记录
- [ ] 00-plan.md 已创建
- [ ] 01-round-orders.md 已创建
- [ ] release-lock.ps1 执行成功

---

*文档版本：v1.0 | 创建者：灌汤 PM | 2026-03-28 00:35*
