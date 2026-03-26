# 机制 v2.0 升级说明

**更新时间:** 2026-03-26 12:00  
**机制版本:** v2.0（数据库锁机制）  
**文档:** `F:\openclaw\agent\doc\01-core\plan-database-mechanism.md`

---

## 🔄 核心变更

### 1. 状态管理从文件 → 数据库

| 内容 | v1.0（文件） | v2.0（数据库） |
|------|-------------|---------------|
| 计划进度 | `pipeline-state.json` | `plan_progress` 表 |
| 步骤记录 | `01-round-orders.md` | `step_execution` 表 |
| 锁机制 | 无 | `session_lock` 表 + PowerShell 脚本 |

### 2. 新增 PowerShell 工具脚本

**位置:** `F:\openclaw\agent\workspace-guantang\_tools\`

| 脚本 | 用途 | 示例 |
|------|------|------|
| `acquire-lock.ps1` | 获取锁 | `.\acquire-lock.ps1 -sessionId "main-session-001"` |
| `release-lock.ps1` | 释放锁 | `.\release-lock.ps1 -sessionId "main-session-001"` |
| `update-plan-progress.ps1` | 更新进度（含事务） | `.\update-plan-progress.ps1 -planId Plan-002 -round 2 -agentId jiangrou -status completed` |

### 3. 心跳边界明确

**v1.0:** 心跳可派发任务  
**v2.0:** 心跳仅监控失联，不派发任务

**Cron 配置:** `C:\Users\Administrator\.openclaw\crons\agent-heartbeat.yml`

---

## 📋 plan-manager skill 使用调整

### 当前状态

plan-manager skill 基于文件系统，**机制 v2.0 后仍可继续使用**，但需要注意：

1. **创建计划** - 仍使用 plan-manager（创建文档结构）
2. **更新进度** - 同时更新数据库和文档（双写）
3. **完成计划** - 同时更新数据库和文档（双写）

### 推荐工作流

```
创建计划
  ↓
plan-manager 创建计划（文档）
  ↓
手动插入数据库（INSERT INTO plan_progress ...）
  ↓
派发任务
  ↓
acquire-lock.ps1 获取锁
  ↓
sessions_spawn 派发
  ↓
UPDATE step_execution SET status = 'dispatched'
  ↓
等待回调
  ↓
回调验证
  ↓
update-plan-progress.ps1 更新数据库（含事务）
  ↓
plan-manager 更新进度（文档）
  ↓
release-lock.ps1 释放锁
  ↓
派发下一轮
```

---

## 🔧 数据库操作示例

### 创建计划
```sql
INSERT INTO plan_progress (plan_id, plan_name, current_round, total_rounds, status)
VALUES ('Plan-006', '用户中心', 1, 5, 'pending');

INSERT INTO step_execution (plan_id, round, step_name, agent_id, status)
VALUES 
  ('Plan-006', 1, '需求分析', 'guantang', 'pending'),
  ('Plan-006', 2, '技术方案', 'jiangrou', 'pending'),
  ('Plan-006', 3, '后端开发', 'jiangrou', 'pending'),
  ('Plan-006', 4, '前端开发', 'dousha', 'pending'),
  ('Plan-006', 5, '测试验收', 'guantang', 'pending');
```

### 查询进度
```sql
-- 计划总览
SELECT plan_id, plan_name, current_round, total_rounds, status 
FROM plan_progress 
ORDER BY plan_id;

-- 某计划详情
SELECT round, step_name, agent_id, status, dispatched_at, completed_at 
FROM step_execution 
WHERE plan_id = 'Plan-006' 
ORDER BY round;
```

### 更新进度
```powershell
# 使用脚本（推荐，含事务）
.\update-plan-progress.ps1 -planId Plan-006 -round 1 -agentId guantang -status completed

# 或直接 SQL
UPDATE step_execution 
SET status = 'completed', completed_at = NOW(), verify_result = 'pass'
WHERE plan_id = 'Plan-006' AND round = 1 AND agent_id = 'guantang';

UPDATE plan_progress 
SET current_round = 2 
WHERE plan_id = 'Plan-006';
```

---

## ⚠️ 注意事项

1. **事务包裹** - update-plan-progress.ps1 已包含事务，不要手动包裹
2. **锁超时** - 默认 10 分钟，长任务需要续期
3. **双写一致** - 数据库和文档需要保持一致，建议先更新数据库
4. **备份** - 定期备份 openclaw 数据库（mysqldump）

---

## 📊 数据库备份脚本

```powershell
# backup-plan-database.ps1
$backupPath = "F:\openclaw\agent\backups\plan-$(Get-Date -Format 'yyyyMMdd-HHmmss').sql"
mysqldump -h localhost -P 3306 -u root openclaw > $backupPath
Write-Output "Database backed up to $backupPath"
```

---

*维护者：灌汤 PM | 最后更新：2026-03-26 12:00*
