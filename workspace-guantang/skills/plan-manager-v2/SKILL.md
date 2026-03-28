<!-- Last Modified: 2026-03-28 00:48 -->

# Plan Manager v2 Skill - Pipeline v4.0 状态过滤版

**版本:** v2.1（2026-03-28 更新）  
**创建日期:** 2026-03-26  
**维护者:** 灌汤 (PM) 🍲  
**状态:** ✅ 生产中

---

## 🎯 核心改进

### v2.1 新增（2026-03-28）
1. ✅ **5 个计划状态** - `draft`, `waiting`, `processing`, `finished`, `delete`
2. ✅ **心跳检查过滤** - 只检查 `waiting` + `processing` 状态
3. ✅ **状态机完善** - 明确各状态转换规则
4. ✅ **SQL 查询优化** - 只查询活跃计划

### v2.0 已有
1. ✅ **数据库双写** - 文件 + MySQL 同步更新
2. ✅ **状态持久化** - 关机不丢失进度
3. ✅ **自动恢复** - 系统重启后续做
4. ✅ **实时查询** - 从数据库快速获取进度
5. ✅ **审计增强** - 所有变更写入 history 表

---

## 📊 计划状态（5 个阶段）

| 状态 | 英文 | 说明 | 心跳检查 | 可派发任务 |
|------|------|------|---------|-----------|
| 📝 草稿 | `draft` | 计划创建中，未就绪 | ❌ 不检查 | ❌ 否 |
| ⏳ 等待 | `waiting` | 计划已就绪，等待启动 | ✅ **检查** | ✅ 是 |
| 🔄 执行 | `processing` | 计划正在执行 | ✅ **检查** | ✅ 是 |
| ✅ 完成 | `finished` | 计划全部完成 | ❌ 不检查 | ❌ 否 |
| ❌ 作废 | `delete` | 计划已取消/作废 | ❌ 不检查 | ❌ 否 |

### 状态转换规则

```
创建 (draft)
    ↓
启动 (waiting)
    ↓
执行 (processing)
    ↓
完成 (finished)

任意状态 → 作废 (delete)
```

---

## 🚀 命令速查

| 命令 | 用途 | 数据库操作 |
|------|------|-----------|
| `创建计划` | 创建新计划（默认 draft） | INSERT pipeline_plans |
| `启动计划` | 改为 waiting/processing | UPDATE status |
| `更新进度` | 更新轮次进度 | UPDATE pipeline_rounds |
| `暂停计划` | 改为 waiting | UPDATE status |
| `完成计划` | 完成计划 + 复盘 | UPDATE status + INSERT history |
| `作废计划` | 改为 delete | UPDATE status + 记录原因 |
| `查询计划` | 查看进度 | SELECT 多表联查 |
| `列出计划` | 列出所有计划（可过滤状态） | SELECT pipeline_plans |

---

## 📋 使用流程

### 场景 1: 创建计划（草稿）

**命令:**
```powershell
npx plan-manager-v2 创建计划 `
  --id "007" `
  --name "重构优化" `
  --priority "P1" `
  --rounds 5 `
  --owner "酱肉" `
  --status "draft"
```

**执行内容:**
1. 创建计划文件夹 `tasks/01-plans/plan-007/`
2. 创建 `00-plan.md` 计划文档
3. 插入数据库 `pipeline_plans` 表
4. 状态：`draft`

---

### 场景 2: 启动计划

**命令:**
```powershell
npx plan-manager-v2 启动计划 --id "007" --status "waiting"
```

**执行内容:**
1. 更新 `00-plan.md` 状态
2. 更新数据库 `status = 'waiting'`
3. 记录到 `pipeline_state_history`

---

### 场景 3: 更新进度

**命令:**
```powershell
npx plan-manager-v2 更新进度 `
  --id "007" `
  --round 1 `
  --status "completed" `
  --verify "pass"
```

**执行内容:**
1. 更新 `01-round-orders.md`
2. 更新数据库 `pipeline_rounds` 表
3. 插入 `pipeline_state_history`

---

### 场景 4: 完成计划

**命令:**
```powershell
npx plan-manager-v2 完成计划 `
  --id "007" `
  --status "finished" `
  --review "tasks/01-plans/plan-007/03-review.md"
```

**执行内容:**
1. 验证所有轮次完成
2. 更新 `00-plan.md` 状态
3. 更新数据库 `status = 'finished'`
4. 记录复盘报告路径

---

### 场景 5: 作废计划

**命令:**
```powershell
npx plan-manager-v2 作废计划 `
  --id "007" `
  --reason "需求变更，不再需要"
```

**执行内容:**
1. 更新 `00-plan.md` 状态
2. 更新数据库 `status = 'delete'`
3. 记录作废原因到 `delete_reason` 字段

---

### 场景 6: 查询计划

**命令:**
```powershell
npx plan-manager-v2 查询计划 --id "007"
```

**输出:**
```
Plan-007: 重构优化
状态：waiting
进度：2/5 轮次
负责人：酱肉
创建时间：2026-03-28 00:48
```

---

### 场景 7: 列出计划

**命令:**
```powershell
# 列出所有计划
npx plan-manager-v2 列出计划

# 只列出执行中的计划
npx plan-manager-v2 列出计划 --status "processing"

# 只列出等待的计划
npx plan-manager-v2 列出计划 --status "waiting"
```

---

## ❤️ 心跳检查机制（v4.1 自动启动）

### 检查范围

**只检查以下状态的计划:**
- ✅ `waiting` - 等待执行的计划（**自动启动**）
- ✅ `processing` - 执行中的计划（重点监控）

**不检查以下状态的计划:**
- ❌ `draft` - 草稿计划
- ❌ `finished` - 已完成的计划
- ❌ `delete` - 已作废的计划

### 心跳检查流程（v4.1 新增自动启动）

```
心跳检查（每 10 分钟）
    ↓
【步骤 1】查询 waiting 状态的计划
    ↓
【步骤 2】查询空闲 Agent（无活跃任务）
    ↓
【步骤 3】发现匹配 → 自动启动计划 ⭐
    ↓
【步骤 4】派发第 1 轮任务
    ↓
【步骤 5】更新计划状态：waiting → processing
    ↓
【步骤 6】监控 processing 计划的 Agent 活动
    ↓
发现失联 → sessions_spawn 唤醒
```

### SQL 查询示例

```sql
-- 查询 waiting 状态的计划（可启动）
SELECT plan_id, plan_name, status, current_round, total_rounds
FROM pipeline_plans
WHERE status = 'waiting';

-- 查询空闲 Agent（无活跃任务）
SELECT a.agent_id
FROM agents a
LEFT JOIN pipeline_agent_tasks t ON a.agent_id = t.agent_id 
  AND t.status IN ('assigned', 'executing')
WHERE t.agent_id IS NULL;

-- 查询 processing 计划的活跃任务
SELECT t.*, p.plan_name
FROM pipeline_agent_tasks t
JOIN pipeline_plans p ON t.plan_id = p.plan_id
WHERE p.status = 'processing'
  AND t.status IN ('assigned', 'executing')
  AND t.last_heartbeat_at < DATE_SUB(NOW(), INTERVAL 60 MINUTE);
```

### 失联判定

| 计划状态 | 失联阈值 | 行动 |
|---------|---------|------|
| `processing` | >60 分钟无日志 | sessions_spawn 唤醒 |

### 自动启动规则

| 条件 | 行动 |
|------|------|
| 存在 waiting 计划 + 有空闲 Agent | **自动启动**，派发第 1 轮任务 |
| 存在 waiting 计划 + 无空闲 Agent | 等待，下次心跳再检查 |
| 无 waiting 计划 | 只监控 processing 计划 |

---

## 📁 文件结构

```
tasks/
├── 00-master/
│   ├── master-plan-overview.md    # 总览文档（所有计划状态）
│   └── plan-template.md           # 计划模板
├── 01-plans/
│   ├── plan-001-p0-阻塞修复/
│   │   ├── 00-plan.md             # 计划详情（含状态）
│   │   ├── 01-round-orders.md     # 轮次工单记录
│   │   ├── 02-verify-list.md      # PM 验收清单
│   │   ├── 03-review.md           # 复盘报告
│   │   └── 04-feishu-logs.md      # 飞书通知记录
│   └── ...
├── 02-archives/                   # 已完成的计划归档（finished）
└── 99-logs/
    └── plan-execution-log.md      # 计划执行日志
```

---

## 🗄️ 数据库 Schema

```sql
-- 计划表
CREATE TABLE pipeline_plans (
  plan_id VARCHAR(50) PRIMARY KEY,
  plan_name VARCHAR(200) NOT NULL,
  status ENUM('draft','waiting','processing','finished','delete') DEFAULT 'draft',
  current_round INT DEFAULT 0,
  total_rounds INT NOT NULL,
  priority ENUM('P0','P1','P2') DEFAULT 'P1',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  started_at TIMESTAMP NULL,
  finished_at TIMESTAMP NULL,
  delete_reason TEXT NULL,
  created_by VARCHAR(50) DEFAULT 'guantang'
);

-- 轮次表
CREATE TABLE pipeline_rounds (
  id INT AUTO_INCREMENT PRIMARY KEY,
  plan_id VARCHAR(50) NOT NULL,
  round_id INT NOT NULL,
  status ENUM('pending','assigned','executing','completed','failed') DEFAULT 'pending',
  assigned_at TIMESTAMP NULL,
  completed_at TIMESTAMP NULL,
  verify_result ENUM('pass','fail','pending') DEFAULT 'pending',
  FOREIGN KEY (plan_id) REFERENCES pipeline_plans(plan_id),
  UNIQUE KEY uk_plan_round (plan_id, round_id)
);

-- 任务表
CREATE TABLE pipeline_agent_tasks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  plan_id VARCHAR(50) NOT NULL,
  round_id INT NOT NULL,
  agent_id VARCHAR(50) NOT NULL,
  task_name VARCHAR(200) NOT NULL,
  deliverable_path VARCHAR(500),
  status ENUM('pending','assigned','executing','completed','failed','unknown') DEFAULT 'pending',
  assigned_at TIMESTAMP NULL,
  completed_at TIMESTAMP NULL,
  last_heartbeat_at TIMESTAMP NULL,
  FOREIGN KEY (plan_id) REFERENCES pipeline_plans(plan_id)
);

-- 状态历史表
CREATE TABLE pipeline_state_history (
  id INT AUTO_INCREMENT PRIMARY KEY,
  plan_id VARCHAR(50) NOT NULL,
  old_status VARCHAR(20),
  new_status VARCHAR(20),
  changed_by VARCHAR(50),
  changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  reason TEXT,
  FOREIGN KEY (plan_id) REFERENCES pipeline_plans(plan_id)
);
```

---

## 🎯 最佳实践

1. **计划创建** - 先创建为 `draft`，完善细节后再启动
2. **计划启动** - 确保资源就绪后再改为 `waiting` 或 `processing`
3. **计划执行** - 每轮完成后立即更新进度
4. **计划完成** - 必须创建复盘报告才能完成
5. **计划作废** - 明确记录作废原因，便于后续追溯
6. **心跳检查** - 只关注 `waiting` + `processing` 状态，减少噪音

---

## 📊 状态统计命令

```powershell
# 查看各状态计划数量
npx plan-manager-v2 统计 --group-by status

# 查看执行中的计划
npx plan-manager-v2 统计 --status "processing"

# 查看待启动的计划
npx plan-manager-v2 统计 --status "waiting"
```

---

*最后更新：2026-03-28 00:48*  
*维护者：灌汤 (Guantang) 🍲*
