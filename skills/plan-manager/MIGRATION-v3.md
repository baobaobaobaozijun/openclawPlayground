<!-- Last Modified: 2026-03-26 15:50 -->

# Plan Manager → Pipeline v3.0 迁移指南

**版本:** v1.0  
**创建日期:** 2026-03-26  
**状态:** 📝 规划中

---

## 🎯 目标

将现有的 plan-manager skill（基于文件）与 Pipeline v3.0（基于数据库）整合，实现：

1. **双写机制** - 文件 + 数据库同步更新
2. **平滑过渡** - 不影响现有工作流
3. **增强能力** - 获得数据库的持久化和恢复能力

---

## 📊 当前状态对比

| 功能 | plan-manager | Pipeline v3.0 | 整合方案 |
|------|-------------|---------------|---------|
| 计划创建 | ✅ 文件系统 | ✅ 数据库 | 双写 |
| 进度更新 | ✅ 文件系统 | ✅ 数据库 | 双写 |
| 任务派发 | ✅ sessions_spawn | ✅ 数据库驱动 | 保留 sessions_spawn |
| 状态持久化 | ❌ 依赖文件 | ✅ 数据库 | 使用 v3 |
| 自动恢复 | ❌ 无 | ✅ 有 | 使用 v3 |
| 审计日志 | ✅ Markdown | ✅ 数据库表 | 保留两者 |
| Cron 触发 | ❌ 手动 | ✅ 自动 | 保留手动 + 增加自动 |

---

## 🔧 需要修改的脚本

### 1. create-plan.ps1

**修改位置:** 第 50 行（创建计划文件夹后）

**新增代码:**
```powershell
# 6. 同步写入数据库
$createPlanSql = @"
INSERT INTO pipeline_plans (plan_id, plan_name, status, current_round, total_rounds, priority, created_by, prd_doc_path)
VALUES ('plan-{0}', '{1}', 'pending', 0, {2}, '{3}', 'guantang', 'tasks/01-plans/{4}/00-plan.md');
"@ -f $编号，$名称，$轮次，$优先级，$planFolderName

mysql -h localhost -u root -proot123 baozipu -e $createPlanSql 2>$null
Write-Host "✓ 同步写入 pipeline_plans 表" -ForegroundColor Green
```

---

### 2. update-progress.ps1

**修改位置:** 第 60 行（更新 01-round-orders.md 后）

**新增代码:**
```powershell
# 4. 同步更新数据库
$actualTimeValue = if ($实际耗时) { $实际耗时 } else { "0m" }

$updatePlanSql = @"
UPDATE pipeline_plans 
SET current_round = {0}, status = 'executing' 
WHERE plan_id = 'plan-{1}';
"@ -f $轮次，$计划编号

$updateRoundSql = @"
UPDATE pipeline_rounds 
SET status = '{0}', completed_at = NOW(), verified = {1}
WHERE plan_id = 'plan-{2}' AND round_id = {3};
"@ -f $状态，(if ($状态 -eq "completed") { "TRUE" } else { "FALSE" }), $计划编号，$轮次

mysql -h localhost -u root -proot123 baozipu -e $updatePlanSql 2>$null
mysql -h localhost -u root -proot123 baozipu -e $updateRoundSql 2>$null
Write-Host "✓ 同步更新数据库" -ForegroundColor Green
```

---

### 3. complete-plan.ps1

**修改位置:** 第 40 行（生成复盘报告后）

**新增代码:**
```powershell
# 5. 同步更新数据库状态
$completeSql = @"
UPDATE pipeline_plans 
SET status = 'completed', completed_at = NOW() 
WHERE plan_id = 'plan-{0}';

INSERT INTO pipeline_state_history (plan_id, old_status, new_status, change_reason)
VALUES ('plan-{0}', 'executing', 'completed', 'plan_manager_complete');
"@ -f $计划编号

mysql -h localhost -u root -proot123 baozipu -e $completeSql 2>$null
Write-Host "✓ 同步更新数据库状态" -ForegroundColor Green
```

---

## 📋 实施步骤

### 阶段 1：双写机制（本周）

1. ✅ 修改 create-plan.ps1
2. ✅ 修改 update-progress.ps1
3. ✅ 修改 complete-plan.ps1
4. ✅ 测试双写一致性

**验收标准:**
- 创建计划后，pipeline_plans 表有对应记录
- 更新进度后，pipeline_rounds 表状态同步
- 完成计划后，pipeline_plans.status = 'completed'

---

### 阶段 2：查询增强（下周）

5. 创建 `query-plan.ps1` 命令
6. 支持从数据库查询计划进度
7. 生成可视化报表

**示例:**
```powershell
npx plan-manager 查询计划 --计划编号 "006" --输出 "table"
```

---

### 阶段 3：自动触发（下周）

8. Cron 每小时检查 pipeline_plans
9. 发现新计划自动派发第 1 轮
10. 轮次完成自动派发下一轮

**配置:**
```yaml
name: plan-auto-dispatch
schedule:
  kind: cron
  expr: "0 * * * *"  # 每小时
payload:
  kind: systemEvent
  text: "检查 pending 状态的计划，自动派发第 1 轮"
```

---

## ⚠️ 注意事项

### 数据一致性

**问题:** 文件更新成功但数据库写入失败

**解决:**
1. 使用事务包裹数据库操作
2. 数据库失败时回滚文件更改
3. 或标记"待同步"状态，下次重试

---

### 回滚方案

如整合后出现问题，可临时关闭数据库同步：

```powershell
# 在脚本开头添加开关
$ENABLE_DB_SYNC = $false  # 设为 false 禁用双写

if ($ENABLE_DB_SYNC) {
    # 执行数据库操作
}
```

---

### 性能影响

**预期:** 每次命令增加 ~200ms（数据库写入时间）

**优化:**
- 异步写入数据库
- 批量写入（如一次更新多轮）
- 连接池复用

---

## 📊 迁移后工作流

```
用户指令
  ↓
npx plan-manager 创建计划
  ↓
【文件系统】创建文件夹 + 文档
【数据库】INSERT pipeline_plans
  ↓
PM 派发第 1 轮任务 (sessions_spawn)
  ↓
【数据库】UPDATE pipeline_agent_tasks
  ↓
Agent 执行 → 完成回调
  ↓
npx plan-manager 更新进度
  ↓
【文件系统】更新 00-plan.md + 01-round-orders.md
【数据库】UPDATE pipeline_rounds
  ↓
重复直到所有轮次完成
  ↓
npx plan-manager 完成计划
  ↓
【文件系统】生成 03-review.md
【数据库】UPDATE pipeline_plans SET status='completed'
  ↓
✅ 完成
```

---

## 🎯 长期目标

### 完全自动化（P2）

- 计划创建后自动派发第 1 轮
- 轮次完成后自动验证 + 派发下一轮
- 异常情况自动通知 PM

### 可视化仪表板（P2）

- 基于数据库查询的进度看板
- 实时显示各 Agent 任务状态
- 历史数据分析（完成率、平均耗时）

---

## 📚 相关文档

| 文档 | 路径 |
|------|------|
| Pipeline v3.0 机制 | `doc/guides/agent-pipeline-mechanism-v3.md` |
| plan-manager Skill | `skills/plan-manager/SKILL.md` |
| 数据库 Schema | `doc/guides/init-pipeline-db.sql` |
| 测试报告 | `doc/progress/pipeline-v3-test-report.md` |

---

*维护者：灌汤 (PM) 🍲*  
*最后更新：2026-03-26 15:50*
