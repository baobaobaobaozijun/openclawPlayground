<!-- Last Modified: 2026-03-26 09:43 -->

# 计划执行机制 v2.0 — MySQL 驱动方案

**文档类型:** 机制设计  
**版本:** v2.0  
**创建日期:** 2026-03-26 09:43  
**负责人:** 灌汤 (PM)  
**状态:** 待实施

---

## 📊 问题背景

### 当前问题（v1.0 文件锁机制）

| 问题 | 表现 | 严重度 |
|------|------|--------|
| **双会话状态分裂** | 心跳会话执行到 Plan-05，主会话认为在 Plan-01 | 🔴 严重 |
| **无统一状态源** | pipeline-state.json 不存在，各会话独立决策 | 🔴 严重 |
| **回调驱动失效** | 派发后不等待回调，导致空窗期 50+ 分钟 | 🟡 中等 |
| **文档不同步** | master-plan-overview.md 与 01-round-orders.md 更新不一致 | 🟡 中等 |
| **心跳越权派发** | Cron 心跳派发了 Plan-02~05，与主会话冲突 | 🔴 严重 |

### 根本原因

```
┌─────────────────────────────────────────────────────────┐
│                    实际架构（运行）                      │
│                                                         │
│   主会话 ──→ 派发任务 ──→ ❌ 不等待回调 ──→ 处理其他事    │
│                                                         │
│   Cron 心跳 ──→ 读取文档 ──→ ❌ 自动派发任务 ──→ 继续派发  │
│                                                         │
│   结果：两个会话独立决策，状态分裂                        │
└─────────────────────────────────────────────────────────┘
```

---

## 🎯 设计目标

| 目标 | 说明 | 优先级 |
|------|------|--------|
| **单一事实源** | 所有会话读写同一数据库状态 | P0 |
| **并发安全** | 多会话不会冲突，锁机制保证 | P0 |
| **回调驱动** | 派发后必须等待回调，消除空窗期 | P0 |
| **心跳降级** | 心跳仅监控失联，不派发任务 | P0 |
| **审计追溯** | 完整记录每次派发和完成 | P1 |
| **自动过期** | 锁超时自动释放，无需手动清理 | P1 |

---

## 🏗️ 整体架构

### 新架构（v2.0）

```
┌─────────────────────────────────────────────────────────────────┐
│                        MySQL 数据库                             │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │ plan_progress   │  │ step_execution  │  │ session_lock    │ │
│  │ (计划进度表)    │  │ (步骤执行表)    │  │ (会话锁表)      │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              ↑         ↑         ↑
                              │         │         │
        ┌─────────────────────┼─────────┼─────────┼─────────────┐
        │                     │         │         │             │
        │  ┌──────────────┐   │         │         │   ┌──────────────┐
        │  │  主会话      │───┘         │         └───│  心跳会话    │
        │  │  (PM 灌汤)   │ 获取锁      │  更新状态  监控  │  (Cron)     │
        │  └──────────────┘             │             └──────────────┘
        │                               │
        │  ┌──────────────┐             │
        │  │  Agent 会话   │←────────────┘
        │  │  (酱肉/豆沙/酸菜) │ 派发任务
        │  └──────────────┘
        │
        └──→ sessions_spawn 调用
```

### 核心原则

| 原则 | 说明 |
|------|------|
| **数据库是唯一事实源** | 所有进度、状态、锁信息以数据库为准 |
| **主会话独占派发权** | 只有主会话可以派发任务，心跳会话仅监控 |
| **锁机制防冲突** | 派发前必须获取锁，防止多会话同时派发 |
| **回调驱动下一轮** | 回调收到 → 验证 → 更新 → 派发下一轮，零空窗 |
| **心跳仅唤醒不派发** | 心跳发现失联 Agent → sessions_spawn 唤醒，不派发新任务 |

---

## 📊 数据库设计

### 数据库连接信息

| 配置项 | 值 |
|--------|-----|
| **主机** | localhost |
| **端口** | 3306 |
| **用户名** | root |
| **密码** | (空) |
| **数据库名** | openclaw（与后端共用） |
| **字符集** | utf8mb4 |

**配置文件参考：** `F:\openclaw\code\backend\src\main\resources\application.yml`

### 表 1：plan_progress（计划进度表）

```sql
CREATE TABLE IF NOT EXISTS `plan_progress` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `plan_id` VARCHAR(50) NOT NULL UNIQUE,        -- 'Plan-001', 'Plan-002'
  `plan_name` VARCHAR(200) NOT NULL,             -- 'P0 阻塞问题修复'
  `current_round` INT NOT NULL DEFAULT 1,        -- 当前轮次
  `total_rounds` INT NOT NULL DEFAULT 5,         -- 总轮次
  `status` ENUM('pending', 'executing', 'completed', 'blocked') NOT NULL,
  `locked_by` VARCHAR(100),                      -- 'main-session-uuid'
  `locked_at` DATETIME,                          -- 锁获取时间
  `lock_expires_at` DATETIME,                    -- 锁过期时间
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_status (status),
  INDEX idx_locked (locked_by, lock_expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='计划进度表';
```

**字段说明：**

| 字段 | 说明 | 示例 |
|------|------|------|
| plan_id | 计划唯一标识 | 'Plan-001' |
| plan_name | 计划名称 | 'P0 阻塞问题修复' |
| current_round | 当前轮次（1-5） | 5 |
| total_rounds | 总轮次 | 5 |
| status | 状态 | pending/executing/completed/blocked |
| locked_by | 锁持有者会话 ID | 'main-session-abc123' |
| locked_at | 锁获取时间 | '2026-03-26 09:43:00' |
| lock_expires_at | 锁过期时间 | '2026-03-26 09:53:00' |

---

### 表 2：step_execution（步骤执行记录表）

```sql
CREATE TABLE IF NOT EXISTS `step_execution` (
  `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
  `plan_id` VARCHAR(50) NOT NULL,                -- 关联 plan_progress
  `round` INT NOT NULL,                          -- 轮次号
  `step_name` VARCHAR(200) NOT NULL,             -- '数据库建表', 'AuthController'
  `agent_id` VARCHAR(50) NOT NULL,               -- 'jiangrou', 'dousha', 'suancai'
  `status` ENUM('pending', 'dispatched', 'completed', 'failed', 'blocked') NOT NULL,
  `dispatched_at` DATETIME,                      -- 派发时间
  `completed_at` DATETIME,                       -- 完成时间
  `delivery_path` VARCHAR(500),                  -- 交付物文件路径
  `verify_result` ENUM('pending', 'pass', 'fail'),
  `error_message` TEXT,                          -- 失败原因
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_plan_round (plan_id, round),
  INDEX idx_agent_status (agent_id, status),
  INDEX idx_dispatched (dispatched_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='步骤执行记录表';
```

**字段说明：**

| 字段 | 说明 | 示例 |
|------|------|------|
| plan_id | 所属计划 ID | 'Plan-001' |
| round | 轮次号 | 1-5 |
| step_name | 步骤名称 | '数据库建表 (users)' |
| agent_id | 执行 Agent | 'jiangrou' |
| status | 状态 | pending/dispatched/completed/failed/blocked |
| dispatched_at | 派发时间 | '2026-03-26 08:22:00' |
| completed_at | 完成时间 | '2026-03-26 08:25:00' |
| delivery_path | 交付物路径 | 'F:\openclaw\code\backend\...\AuthController.java' |
| verify_result | 验收结果 | pending/pass/fail |
| error_message | 失败原因 | 'Maven 编译失败：缺少依赖' |

---

### 表 3：session_lock（会话锁表）

```sql
CREATE TABLE IF NOT EXISTS `session_lock` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `lock_name` VARCHAR(100) NOT NULL UNIQUE,      -- 'plan_dispatch_lock'
  `locked_by` VARCHAR(100) NOT NULL,             -- 'main-session-uuid'
  `locked_at` DATETIME NOT NULL,
  `expires_at` DATETIME NOT NULL,
  `heartbeat` DATETIME NOT NULL,                 -- 心跳续期时间
  INDEX idx_expires (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会话锁表';
```

**字段说明：**

| 字段 | 说明 | 示例 |
|------|------|------|
| lock_name | 锁名称 | 'plan_dispatch_lock' |
| locked_by | 锁持有者会话 ID | 'main-session-abc123' |
| locked_at | 锁获取时间 | '2026-03-26 09:43:00' |
| expires_at | 锁过期时间 | '2026-03-26 09:53:00' |
| heartbeat | 心跳续期时间 | '2026-03-26 09:48:00' |

**锁机制说明：**
- 锁有效期：10 分钟（可配置）
- 心跳续期：每 5 分钟更新 heartbeat 和 expires_at
- 自动过期：expires_at < NOW() 时，其他会话可抢占

---

## 🔐 锁机制设计

### 获取锁（派发任务前）

**SQL 语句：**
```sql
-- 尝试获取锁（原子操作）
INSERT INTO session_lock (lock_name, locked_by, locked_at, expires_at, heartbeat)
VALUES (
  'plan_dispatch_lock',
  'main-session-xxx',
  NOW(),
  DATE_ADD(NOW(), INTERVAL 10 MINUTE),
  NOW()
)
ON DUPLICATE KEY UPDATE
  locked_by = IF(expires_at < NOW(), VALUES(locked_by), locked_by),
  locked_at = IF(expires_at < NOW(), NOW(), locked_at),
  expires_at = IF(expires_at < NOW(), DATE_ADD(NOW(), INTERVAL 10 MINUTE), expires_at),
  heartbeat = IF(expires_at < NOW(), NOW(), heartbeat);

-- 检查是否成功获取
SELECT * FROM session_lock 
WHERE lock_name = 'plan_dispatch_lock' 
  AND locked_by = 'main-session-xxx'
  AND expires_at > NOW();
```

**判断逻辑：**
- 返回行数 > 0 → 获取锁成功，可以派发
- 返回行数 = 0 → 锁被其他会话持有，放弃派发

---

### 释放锁（回调完成后）

**方式 1：主动释放**
```sql
DELETE FROM session_lock 
WHERE lock_name = 'plan_dispatch_lock' 
  AND locked_by = 'main-session-xxx';
```

**方式 2：续期（长任务）**
```sql
UPDATE session_lock 
SET heartbeat = NOW(), 
    expires_at = DATE_ADD(NOW(), INTERVAL 10 MINUTE)
WHERE lock_name = 'plan_dispatch_lock' 
  AND locked_by = 'main-session-xxx';
```

---

### 锁状态查询

**查看当前锁持有者：**
```sql
SELECT lock_name, locked_by, locked_at, expires_at,
       TIMESTAMPDIFF(MINUTE, NOW(), expires_at) as remaining_minutes,
       CASE 
         WHEN expires_at < NOW() THEN 'expired'
         WHEN TIMESTAMPDIFF(MINUTE, NOW(), expires_at) < 3 THEN 'expiring_soon'
         ELSE 'active'
       END as lock_status
FROM session_lock
WHERE lock_name = 'plan_dispatch_lock';
```

---

## 🔄 完整流程

### 主会话派发流程

```
┌─────────────────────────────────────────────────────────────────┐
│                     主会话派发流程                               │
└─────────────────────────────────────────────────────────────────┘

1. 生成 session_id (UUID)
   ↓
2. 尝试获取锁 (INSERT ... ON DUPLICATE KEY UPDATE)
   ↓
3. 检查锁是否获取成功 (SELECT)
   ├─ 成功 → 继续
   └─ 失败 → 放弃派发 (其他会话正在执行)
   ↓
4. 查询当前进度 (SELECT current_round FROM plan_progress WHERE plan_id = 'Plan-001')
   ↓
5. 查询本轮步骤信息 (SELECT * FROM step_execution WHERE plan_id = 'Plan-001' AND round = ?)
   ↓
6. 派发任务 (sessions_spawn)
   ↓
7. 更新 step_execution 状态为 'dispatched' + dispatched_at
   ↓
8. 等待回调 (NO_REPLY，不处理其他请求)
   ↓
9. 回调收到 → 验证交付物 (Test-Path)
   ├─ 验证失败 → 更新状态为 'failed' + error_message → 通知 PM
   └─ 验证成功 → 继续
   ↓
10. 更新 step_execution 状态为 'completed' + completed_at + verify_result = 'pass'
    ↓
11. 更新 plan_progress (current_round + 1)
    ↓
12. 检查是否完成 (current_round >= total_rounds)
    ├─ 是 → 更新 status = 'completed' → 生成复盘报告 → 通知 PM
    └─ 否 → 继续
    ↓
13. 插入下一轮 step 记录 (INSERT INTO step_execution ...)
    ↓
14. 释放锁 (DELETE FROM session_lock)
    ↓
15. 返回步骤 4，继续派发下一轮
```

---

### 心跳会话监控流程

```
┌─────────────────────────────────────────────────────────────────┐
│                     心跳会话监控流程                             │
└─────────────────────────────────────────────────────────────────┘

1. 尝试获取锁 (同主会话)
   ↓
2. 获取失败 → 正常 (主会话正在工作) → HEARTBEAT_OK
   ↓
3. 获取成功 → 检查 plan_progress
   ↓
4. 查询所有 agent 最后活动时间
   (SELECT agent_id, MAX(dispatched_at) as last_activity 
    FROM step_execution WHERE status = 'dispatched' GROUP BY agent_id)
   ↓
5. 计算 idle_minutes = TIMESTAMPDIFF(MINUTE, last_activity, NOW())
   ↓
6. 发现 idle_minutes > 60 → sessions_spawn 唤醒
   ↓
7. 更新 step_execution 记录 (添加 error_message 备注)
   ↓
8. 释放锁 (DELETE FROM session_lock)
   ↓
9. HEARTBEAT_OK
```

**关键规则：**
- 心跳会话即使获取锁，也**只唤醒不派发**
- 派发权始终在主会话
- 心跳发现失联 → 唤醒 → 通知主会话（通过共享状态）

---

### Agent 回调处理流程

```
┌─────────────────────────────────────────────────────────────────┐
│                     Agent 回调处理流程                           │
└─────────────────────────────────────────────────────────────────┘

1. 收到 subagent task completion event
   ↓
2. 提取任务信息 (plan_id, round, agent_id, delivery_path)
   ↓
3. 验证交付物 (Test-Path delivery_path)
   ├─ 文件不存在 → 标记验证失败 → 通知 Agent 补正
   └─ 文件存在 → 继续
   ↓
4. 检查工作日志 (Test-Path workinglog/{agent_id}/...)
   ├─ 日志不存在 → 标记异常 → 下轮任务强制要求补录
   └─ 日志存在 → 继续
   ↓
5. 开启数据库事务 (START TRANSACTION)
   ↓
6. 更新 step_execution
   UPDATE step_execution 
   SET status = 'completed', completed_at = NOW(), verify_result = 'pass',
       delivery_path = '...'
   WHERE plan_id = ? AND round = ? AND agent_id = ?
   ↓
7. 更新 plan_progress
   UPDATE plan_progress 
   SET current_round = current_round + 1,
       status = CASE WHEN current_round >= total_rounds THEN 'completed' ELSE 'executing' END
   WHERE plan_id = ?
   ↓
8. 插入下一轮 step 记录
   INSERT INTO step_execution (plan_id, round, step_name, agent_id, status)
   VALUES (?, ?, ?, ?, 'pending')
   ↓
9. 提交事务 (COMMIT)
   ↓
10. 释放锁 (DELETE FROM session_lock)
    ↓
11. 立即派发下一轮 (sessions_spawn)
    ↓
12. 更新新 step 为 'dispatched'
```

---

## 📋 初始化数据

### 数据库创建脚本

```sql
-- 创建数据库
CREATE DATABASE IF NOT EXISTS baozipu_plan DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

USE baozipu_plan;

-- 创建表（见上文 DDL）
```

### 计划初始化数据

```sql
-- 初始化 5 个计划
INSERT INTO plan_progress (plan_id, plan_name, current_round, total_rounds, status)
VALUES 
  ('Plan-001', 'P0 阻塞问题修复', 5, 5, 'executing'),
  ('Plan-002', '文章管理模块', 1, 5, 'pending'),
  ('Plan-003', '特色功能实现', 1, 5, 'pending'),
  ('Plan-004', '分类标签与完善', 1, 5, 'pending'),
  ('Plan-005', '文档同步与验收', 1, 5, 'pending');
```

### Plan-001 步骤初始化

```sql
-- 初始化 Plan-001 的步骤记录（根据实际进度）
INSERT INTO step_execution (plan_id, round, step_name, agent_id, status, dispatched_at, completed_at, verify_result)
VALUES
  ('Plan-001', 1, '数据库建表 (users)', 'jiangrou', 'completed', '2026-03-25 23:21:00', '2026-03-25 23:26:00', 'pass'),
  ('Plan-001', 2, 'AuthController 创建', 'jiangrou', 'completed', '2026-03-25 23:27:00', '2026-03-25 23:30:00', 'pass'),
  ('Plan-001', 3, '前端 API 路径修正', 'dousha', 'completed', '2026-03-26 08:21:00', '2026-03-26 08:21:57', 'pass'),
  ('Plan-001', 4, 'Result.java 添加 timestamp', 'jiangrou', 'completed', '2026-03-25 23:45:00', '2026-03-25 23:47:00', 'pass'),
  ('Plan-001', 5, '编译验证 + 复盘', 'suancai', 'dispatched', '2026-03-26 08:22:00', NULL, 'pending');
```

---

## 🔧 实施步骤

### 阶段 1：数据库准备（今天，30 分钟）

| 步骤 | 操作 | 预计耗时 |
|------|------|---------|
| 1.1 | 创建数据库 baozipu_plan | 2 分钟 |
| 1.2 | 创建 3 张表（plan_progress, step_execution, session_lock） | 5 分钟 |
| 1.3 | 初始化 5 个计划数据 | 5 分钟 |
| 1.4 | 同步 Plan-001 当前进度到数据库 | 10 分钟 |
| 1.5 | 验证数据库连接和查询 | 5 分钟 |

**验收标准：**
- [ ] 数据库创建成功
- [ ] 3 张表结构正确
- [ ] Plan-001~005 数据已插入
- [ ] Plan-001 步骤记录与实际进度一致
- [ ] 可执行 SELECT 查询

---

### 阶段 2：主会话改造（今天，2 小时）

| 步骤 | 操作 | 预计耗时 |
|------|------|---------|
| 2.1 | 添加 MySQL 连接能力（exec 调用 mysql 命令） | 20 分钟 |
| 2.2 | 实现获取锁函数 | 20 分钟 |
| 2.3 | 实现释放锁函数 | 10 分钟 |
| 2.4 | 修改派发逻辑（获取锁 → 派发 → 更新） | 30 分钟 |
| 2.5 | 修改回调处理（验证 → 更新状态 → 下一轮） | 30 分钟 |
| 2.6 | 测试完整流程（Plan-001 第 5 轮） | 30 分钟 |

**验收标准：**
- [ ] 可成功获取锁
- [ ] 派发任务后数据库状态正确更新
- [ ] 回调后自动派发下一轮
- [ ] 锁释放正常
- [ ] 无空窗期

---

### 阶段 3：心跳会话改造（明天，1 小时）

| 步骤 | 操作 | 预计耗时 |
|------|------|---------|
| 3.1 | 移除派发任务逻辑 | 10 分钟 |
| 3.2 | 添加监控逻辑（读取数据库 → 检查失联） | 20 分钟 |
| 3.3 | 实现唤醒逻辑（sessions_spawn） | 15 分钟 |
| 3.4 | 测试边界情况（锁冲突、失联检测） | 15 分钟 |

**验收标准：**
- [ ] 心跳不派发任务
- [ ] 发现失联 Agent 可唤醒
- [ ] 与主会话无冲突

---

### 阶段 4：文档清理（明天，30 分钟）

| 步骤 | 操作 | 预计耗时 |
|------|------|---------|
| 4.1 | 删除 master-plan-overview.md（冗余） | 5 分钟 |
| 4.2 | 保留 01-round-orders.md 作为人类可读备份 | 5 分钟 |
| 4.3 | 更新 SOUL.md（添加数据库机制说明） | 10 分钟 |
| 4.4 | 更新 HEARTBEAT.md（明确心跳边界） | 10 分钟 |

**验收标准：**
- [ ] 冗余文档已删除
- [ ] SOUL.md / HEARTBEAT.md 已更新
- [ ] Git 提交完成

---

## 📊 查询示例

### 查看当前进度
```sql
SELECT plan_id, plan_name, current_round, total_rounds, status, locked_by,
       TIMESTAMPDIFF(MINUTE, locked_at, NOW()) as locked_minutes
FROM plan_progress
ORDER BY plan_id;
```

### 查看某计划的所有步骤
```sql
SELECT round, step_name, agent_id, status, dispatched_at, completed_at, 
       verify_result, delivery_path,
       TIMESTAMPDIFF(MINUTE, dispatched_at, completed_at) as duration_minutes
FROM step_execution
WHERE plan_id = 'Plan-001'
ORDER BY round;
```

### 查看失联 Agent
```sql
SELECT agent_id, MAX(dispatched_at) as last_activity,
       TIMESTAMPDIFF(MINUTE, MAX(dispatched_at), NOW()) as idle_minutes,
       COUNT(*) as pending_tasks
FROM step_execution
WHERE status IN ('dispatched', 'pending')
GROUP BY agent_id
HAVING idle_minutes > 60;
```

### 查看锁状态
```sql
SELECT lock_name, locked_by, locked_at, expires_at,
       TIMESTAMPDIFF(MINUTE, NOW(), expires_at) as remaining_minutes,
       CASE 
         WHEN expires_at < NOW() THEN 'expired'
         WHEN TIMESTAMPDIFF(MINUTE, NOW(), expires_at) < 3 THEN 'expiring_soon'
         ELSE 'active'
       END as lock_status
FROM session_lock;
```

### 查看今日完成情况
```sql
SELECT DATE(completed_at) as date, agent_id, COUNT(*) as completed_steps,
       AVG(TIMESTAMPDIFF(MINUTE, dispatched_at, completed_at)) as avg_duration
FROM step_execution
WHERE completed_at >= CURDATE()
GROUP BY DATE(completed_at), agent_id
ORDER BY date DESC, agent_id;
```

---

## ⚠️ 风险管理

| 风险 | 概率 | 影响 | 缓解措施 |
|------|------|------|---------|
| 数据库连接失败 | 中 | 高 | 降级为文件锁模式，记录错误日志 |
| 锁超时设置过短 | 中 | 中 | 初始 10 分钟，根据实际调整 |
| 会话异常退出 | 低 | 高 | 依赖锁自动过期（expires_at） |
| 事务死锁 | 低 | 中 | 设置超时，重试机制 |
| 历史数据迁移错误 | 中 | 中 | 人工核对，保留原文档备份 |

---

## 📈 预期效果

| 指标 | v1.0（文件锁） | v2.0（数据库） | 提升 |
|------|---------------|---------------|------|
| 状态一致性 | ❌ 双会话分裂 | ✅ 单一事实源 | 100% |
| 空窗期 | 50+ 分钟 | <2 分钟 | 96%↓ |
| 并发安全 | ❌ 可能冲突 | ✅ 锁机制保证 | 100% |
| 审计追溯 | ❌ 手动记录 | ✅ 自动记录 | 100% |
| 查询效率 | ❌ 文件解析 | ✅ SQL 查询 | 10x+ |

---

## 📝 维护说明

### 日常维护

| 任务 | 频率 | 说明 |
|------|------|------|
| 数据库备份 | 每日 | mysqldump 导出 |
| 锁状态检查 | 每周 | 检查是否有过期锁未清理 |
| 进度核对 | 每周 | 数据库 vs 实际文件交付物 |
| 性能监控 | 每周 | 查询执行时间 |

### 故障恢复

**场景 1：数据库连接失败**
```
1. 检查 MySQL 服务状态
2. 检查连接配置（host/port/user/password）
3. 降级为文件锁模式（临时）
4. 修复后同步数据
```

**场景 2：锁未释放**
```
1. 查询 session_lock 表
2. 检查 expires_at 是否过期
3. 如过期 → DELETE 清理
4. 如未过期 → 联系锁持有者会话
```

**场景 3：进度不一致**
```
1. 查询 step_execution 表
2. 核对实际交付物文件
3. 手动更新状态（UPDATE）
4. 记录差异原因
```

---

## 🔗 相关文档

| 文档 | 路径 | 说明 |
|------|------|------|
| SOUL.md | `F:\openclaw\agent\workspace-guantang\SOUL.md` | PM 行为准则（待更新） |
| HEARTBEAT.md | `F:\openclaw\agent\workspace-guantang\HEARTBEAT.md` | 心跳机制（待更新） |
| master-plan-overview.md | `F:\openclaw\agent\tasks\00-master\master-plan-overview.md` | 计划总览（待删除） |
| 01-round-orders.md | `F:\openclaw\agent\tasks\01-plans\plan-001\01-round-orders.md` | 轮次记录（保留） |

---

## ✅ 验收清单

### 阶段 1 验收
- [ ] 数据库创建成功
- [ ] 3 张表结构正确
- [ ] 5 个计划数据已插入
- [ ] Plan-001 步骤记录与实际进度一致
- [ ] 可执行 SELECT 查询

### 阶段 2 验收
- [ ] 可成功获取锁
- [ ] 派发任务后数据库状态正确更新
- [ ] 回调后自动派发下一轮
- [ ] 锁释放正常
- [ ] 无空窗期（<2 分钟）

### 阶段 3 验收
- [ ] 心跳不派发任务
- [ ] 发现失联 Agent 可唤醒
- [ ] 与主会话无冲突

### 阶段 4 验收
- [ ] master-plan-overview.md 已删除
- [ ] SOUL.md / HEARTBEAT.md 已更新
- [ ] Git 提交完成

---

*创建时间：2026-03-26 09:43*  
*下次更新：实施完成后*  
*维护者：灌汤 PM*
