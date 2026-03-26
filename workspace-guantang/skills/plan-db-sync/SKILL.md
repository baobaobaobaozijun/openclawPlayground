# plan-db-sync Skill - 计划数据库同步

**用途:** 在计划派发、完成、阶段结束时自动同步状态到 MySQL 数据库

**数据库:** baozipu  
**表:** pipeline_plans, pipeline_rounds, pipeline_agent_tasks, pipeline_state_history

---

## 命令列表

### 1. 派发任务时写入数据库

**触发时机:** 每次 `sessions_spawn` 派发任务前

**SQL 示例:**
```sql
-- 更新计划状态为 executing
UPDATE pipeline_plans 
SET status = 'executing', current_round = {round_number}
WHERE plan_id = '{plan_id}';

-- 更新/插入轮次状态为 executing
INSERT INTO pipeline_rounds (plan_id, round_id, round_name, status, started_at)
VALUES ('{plan_id}', {round_number}, '{round_name}', 'executing', NOW())
ON DUPLICATE KEY UPDATE status = 'executing', started_at = NOW();

-- 插入 Agent 任务
INSERT INTO pipeline_agent_tasks (plan_id, round_id, agent_id, task_name, task_description, status, assigned_at)
VALUES ('{plan_id}', {round_number}, '{agent_id}', '{task_name}', '{task_description}', 'assigned', NOW());

-- 记录状态变更历史
INSERT INTO pipeline_state_history (plan_id, round_id, old_status, new_status, change_reason, changed_by)
VALUES ('{plan_id}', {round_number}, 'pending', 'executing', 'Task dispatched', 'guantang');
```

---

### 2. 任务完成回调时更新数据库

**触发时机:** 收到 subagent task completion event 时

**SQL 示例:**
```sql
-- 更新 Agent 任务状态为 completed
UPDATE pipeline_agent_tasks 
SET status = 'completed', completed_at = NOW(), verified = 1, verified_at = NOW()
WHERE plan_id = '{plan_id}' AND round_id = {round_number} AND agent_id = '{agent_id}';

-- 更新轮次状态为 completed
UPDATE pipeline_rounds 
SET status = 'completed', completed_at = NOW(), verified = 1, verified_at = NOW()
WHERE plan_id = '{plan_id}' AND round_id = {round_number};

-- 记录状态变更历史
INSERT INTO pipeline_state_history (plan_id, round_id, agent_task_id, old_status, new_status, change_reason, changed_by)
VALUES ('{plan_id}', {round_number}, {task_id}, 'executing', 'completed', 'Task completed', 'system');
```

---

### 3. 计划完成时更新数据库

**触发时机:** 计划最后一轮完成时

**SQL 示例:**
```sql
-- 更新计划状态为 completed
UPDATE pipeline_plans 
SET status = 'completed', completed_at = NOW()
WHERE plan_id = '{plan_id}';

-- 记录状态变更历史
INSERT INTO pipeline_state_history (plan_id, old_status, new_status, change_reason, changed_by)
VALUES ('{plan_id}', 'executing', 'completed', 'All rounds completed', 'guantang');
```

---

### 4. 阶段结束时汇总

**触发时机:** 阶段所有计划完成后

**SQL 示例:**
```sql
-- 查询阶段完成情况
SELECT 
    phase,
    COUNT(*) as total_plans,
    SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed_plans,
    GROUP_CONCAT(plan_id) as plan_ids
FROM pipeline_plans
WHERE plan_id LIKE 'plan-{phase}-%'
GROUP BY phase;
```

---

## 使用方式

### 在 sessions_spawn 前调用
```powershell
# 派发任务前，先写入数据库
mysql -h localhost -u root baozipu -e "
INSERT INTO pipeline_agent_tasks (plan_id, round_id, agent_id, task_name, status, assigned_at)
VALUES ('plan-006', 1, 'jiangrou', 'Task Name', 'assigned', NOW());
"
```

### 在回调处理中调用
```powershell
# 收到完成回调后，更新数据库
mysql -h localhost -u root baozipu -e "
UPDATE pipeline_agent_tasks SET status = 'completed', completed_at = NOW()
WHERE plan_id = 'plan-006' AND round_id = 1 AND agent_id = 'jiangrou';

UPDATE pipeline_rounds SET status = 'completed', completed_at = NOW()
WHERE plan_id = 'plan-006' AND round_id = 1;
"
```

---

## 验证查询

### 查看所有计划状态
```sql
SELECT plan_id, plan_name, status, current_round, total_rounds, priority, completed_at
FROM pipeline_plans
ORDER BY plan_id;
```

### 查看某计划的所有轮次
```sql
SELECT round_id, round_name, status, verified, started_at, completed_at
FROM pipeline_rounds
WHERE plan_id = 'plan-006'
ORDER BY round_id;
```

### 查看某 Agent 的任务
```sql
SELECT plan_id, round_id, task_name, status, assigned_at, completed_at
FROM pipeline_agent_tasks
WHERE agent_id = 'jiangrou'
ORDER BY plan_id, round_id;
```

### 查看状态变更历史
```sql
SELECT plan_id, round_id, old_status, new_status, change_reason, changed_at, changed_by
FROM pipeline_state_history
ORDER BY changed_at DESC
LIMIT 20;
```

---

## 注意事项

1. **编码问题:** SQL 文件使用 UTF-8 无 BOM 编码，避免中文乱码
2. **事务:** 多表更新时使用事务保证一致性
3. **幂等:** 使用 `ON DUPLICATE KEY UPDATE` 确保重复执行安全
4. **审计:** 所有状态变更必须写入 `pipeline_state_history`

---

*版本：v1.0*  
*创建时间：2026-03-26 21:55*
