<!-- Last Modified: 2026-03-26 22:25 -->

# Agent 全自动流水线机制 v3.1（幂等版）

**版本:** v3.1  
**创建日期:** 2026-03-26  
**最后更新:** 2026-03-26 22:25  
**负责人:** 灌汤 (PM) 🍲  
**状态:** ✅ 实施完成

---

## 🎯 设计目标

1. **任务派发自动化** — 回调驱动，零空窗派发
2. **状态持久化** — 数据库存储，关机不丢失
3. **幂等性保证** — 系统重启后不重复派发同一任务 ⭐ v3.1 核心改进
4. **自动恢复** — 开机/重启后自动续做或重做
5. **心跳监控** — 实时发现失联 Agent，快速响应
6. **质量保障** — 自动验证 + Git 关联 + 审计追溯

---

## 🏗️ 整体架构

```
┌─────────────────────────────────────────────────────────────────┐
│                    全自动流水线 v3.1 (幂等版)                    │
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │  计划生成   │ →  │  工单派发   │ →  │  自动验证   │         │
│  │  (PRD 解析)  │    │ (幂等检查)  │    │ (mvn/npm)   │         │
│  └─────────────┘    └─────────────┘    └─────────────┘         │
│         ↓                  ↓                  ↓                 │
│  写入 pipeline_plans  幂等检查 + 写库  写入 verifications     │
│                                                                 │
│  ┌──────────────────────────────────────────────────────┐      │
│  │              心跳监控层（独立运行）                    │      │
│  │  ┌──────────┐    ┌──────────┐    ┌──────────┐       │      │
│  │  │ Agent 心跳 │    │ PM 检查   │    │ 系统事件 │       │      │
│  │  │ (5min)   │    │ (10min)  │    │ (事件)   │       │      │
│  │  └──────────┘    └──────────┘    └──────────┘       │      │
│  │        ↓                ↓                ↓            │      │
│  │  更新 heartbeat   查询失联 Agent   触发恢复流程       │      │
│  └──────────────────────────────────────────────────────┘      │
│                            ↓                                    │
│               更新流水线状态（重试/重做/通知 PM）                │
│                            ↓                                    │
│  ┌──────────────────────────────────────────────────────┐      │
│  │         数据库状态机 (MySQL) + 唯一约束保证幂等         │      │
│  │  pipeline_plans | pipeline_rounds | agent_tasks      │      │
│  │  verifications | state_history | system_events       │      │
│  │  ⭐ uk_plan_round_agent (唯一键，防止重复派发)         │      │
│  └──────────────────────────────────────────────────────┘      │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🎓 设计思想

### 1. 数据库是唯一真实来源 ⭐

**原则:** 工作日志只是记录，数据库才是状态。

**理由:**
- 工作日志分散在多个目录，难以聚合查询
- 无法保证日志与实际情况一致
- 无法支持幂等性检查

**实现:**
```sql
-- 任务状态以数据库为准
SELECT status FROM pipeline_agent_tasks 
WHERE plan_id='plan-006' AND round_id=1 AND agent_id='jiangrou';
```

### 2. 幂等性保证 ⭐ v3.1 核心

**问题:** 系统重启后可能重复派发同一任务。

**解决方案:**
1. **数据库唯一约束** — `uk_plan_round_agent (plan_id, round_id, agent_id)`
2. **派发前检查** — `check-idempotency.ps1` 查询任务状态
3. **幂等插入** — `INSERT ... ON DUPLICATE KEY UPDATE`

**状态机:**
```
pending → assigned → executing → completed
                      ↓
                   failed (可重试，最多 2 次)
                      ↓
                   unknown (失联，可重做)
```

### 3. 回调驱动 + 心跳兜底

**主力:** 收到 subagent 完成回调 → 立即验证 → 立即派发下一轮

**兜底:** Cron 每 10 分钟检查 → 发现失联/空闲 → 唤醒/派发

**优势:**
- 消除空窗期（从 20-60min 降到 <2min）
- 日产出提升（从 10 轮/天提升到 15-20 轮/天）
- 心跳检查变轻量（仅失联检测）

### 4. Agent 能力适配

**不同 Agent 适合不同类型的任务:**

| Agent | 擅长 ✅ | 不擅长 ❌ | 最佳任务模式 |
|-------|--------|----------|-------------|
| 🍖 酱肉 | 写新单文件、SQL 脚本、配置文件 | 参考模仿、多文件、read+edit | **直接给完整代码 → write 单文件** |
| 🍡 豆沙 | 页面组件、样式、响应式 | — | 给需求 + 参考样例，可自由发挥 |
| 🥬 酸菜 | 脚本/配置/文档 | 多步骤复杂命令 | **给完整内容 → write 创建** |

---

## 📊 数据库 Schema

### 1. 计划主表 (pipeline_plans)

```sql
CREATE TABLE pipeline_plans (
    id INT PRIMARY KEY AUTO_INCREMENT,
    plan_id VARCHAR(50) UNIQUE NOT NULL,      -- 'plan-003'
    plan_name VARCHAR(200) NOT NULL,          -- 'Auth 流程闭环'
    status ENUM('pending', 'executing', 'blocked', 'completed', 'cancelled') DEFAULT 'pending',
    current_round INT DEFAULT 0,
    total_rounds INT DEFAULT 0,
    priority ENUM('P0', 'P1', 'P2') DEFAULT 'P1',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    created_by VARCHAR(50) DEFAULT 'guantang',
    
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 2. 轮次表 (pipeline_rounds)

```sql
CREATE TABLE pipeline_rounds (
    id INT PRIMARY KEY AUTO_INCREMENT,
    plan_id VARCHAR(50) NOT NULL,
    round_id INT NOT NULL,                    -- 1, 2, 3...
    round_name VARCHAR(200),
    status ENUM('pending', 'executing', 'verifying', 'completed', 'failed', 'interrupted') DEFAULT 'pending',
    verified BOOLEAN DEFAULT FALSE,
    started_at TIMESTAMP NULL,
    completed_at TIMESTAMP NULL,
    interrupted_at TIMESTAMP NULL,
    interrupt_reason VARCHAR(500),
    
    FOREIGN KEY (plan_id) REFERENCES pipeline_plans(plan_id) ON DELETE CASCADE,
    UNIQUE KEY uk_plan_round (plan_id, round_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 3. Agent 任务表 (pipeline_agent_tasks) ⭐ 幂等性核心

```sql
CREATE TABLE pipeline_agent_tasks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    plan_id VARCHAR(50) NOT NULL,
    round_id INT NOT NULL,
    agent_id VARCHAR(50) NOT NULL,            -- 'jiangrou', 'dousha', 'suancai'
    task_name VARCHAR(200) NOT NULL,
    task_description TEXT,
    deliverable_path VARCHAR(500),
    status ENUM('pending', 'assigned', 'executing', 'completed', 'failed', 'unknown') DEFAULT 'pending',
    verified BOOLEAN DEFAULT FALSE,
    git_commit_hash VARCHAR(40),
    failure_reason TEXT,
    retry_count INT DEFAULT 0,
    max_retries INT DEFAULT 2,
    assigned_at TIMESTAMP NULL,
    started_at TIMESTAMP NULL,
    completed_at TIMESTAMP NULL,
    verified_at TIMESTAMP NULL,
    last_heartbeat_at TIMESTAMP NULL,
    
    FOREIGN KEY (plan_id) REFERENCES pipeline_plans(plan_id) ON DELETE CASCADE,
    UNIQUE KEY uk_plan_round_agent (plan_id, round_id, agent_id),  -- ⭐ 幂等性保证
    INDEX idx_agent_status (agent_id, status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 4. 验证记录表 (pipeline_verifications)

```sql
CREATE TABLE pipeline_verifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    plan_id VARCHAR(50) NOT NULL,
    round_id INT NOT NULL,
    verification_type ENUM('compile_backend', 'build_frontend', 'api_contract', 'integration_test') NOT NULL,
    status ENUM('pending', 'passed', 'failed', 'skipped') DEFAULT 'pending',
    command_executed VARCHAR(500),
    output_log TEXT,
    error_message TEXT,
    verified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    verified_by VARCHAR(50) DEFAULT 'system',
    
    FOREIGN KEY (plan_id) REFERENCES pipeline_plans(plan_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 5. 状态变更历史表 (pipeline_state_history)

```sql
CREATE TABLE pipeline_state_history (
    id INT PRIMARY KEY AUTO_INCREMENT,
    plan_id VARCHAR(50) NOT NULL,
    round_id INT NULL,
    agent_task_id INT NULL,
    old_status VARCHAR(50),
    new_status VARCHAR(50) NOT NULL,
    change_reason VARCHAR(500),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by VARCHAR(50) DEFAULT 'system',
    
    FOREIGN KEY (plan_id) REFERENCES pipeline_plans(plan_id) ON DELETE CASCADE,
    INDEX idx_changed_at (changed_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 6. 系统事件表 (pipeline_system_events)

```sql
CREATE TABLE pipeline_system_events (
    id INT PRIMARY KEY AUTO_INCREMENT,
    event_type ENUM('system_shutdown', 'system_startup', 'gateway_restart', 'network_loss') NOT NULL,
    event_data JSON,
    detected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    recovery_status ENUM('pending', 'recovering', 'recovered', 'failed') DEFAULT 'pending',
    recovery_log TEXT,
    
    INDEX idx_event_type (event_type),
    INDEX idx_detected_at (detected_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 🔄 核心工作流程

### 流程 1: 任务派发（带幂等检查）⭐

```
PM 决定派发任务
  ↓
调用 update-db-task-assigned.ps1
  ↓
【步骤 1】check-idempotency.ps1 幂等检查
  ├─ 查询 pipeline_agent_tasks
  ├─ 检查任务状态
  │   ├─ completed → 跳过（检查交付物）
  │   ├─ executing → 检查超时（>60min 重做）
  │   ├─ failed → 检查重试次数（≤2 次可重试）
  │   └─ assigned → 检查超时（>30min 重新派发）
  └─ 返回 CanDispatch (true/false)
  ↓
CanDispatch = false → 跳过派发
CanDispatch = true → 继续
  ↓
【步骤 2】INSERT ... ON DUPLICATE KEY UPDATE
  ├─ 新任务 → INSERT
  └─ 重做/重试 → UPDATE (retry_count+1)
  ↓
【步骤 3】记录状态变更历史
  ↓
【步骤 4】sessions_spawn 派发任务给 Agent
  ↓
完成
```

**脚本路径:**
- `_tools/update-db-task-assigned.ps1` - 主入口
- `_tools/check-idempotency.ps1` - 幂等检查

---

### 流程 2: Agent 执行与心跳上报

```
Agent 收到工单
  ↓
UPDATE pipeline_agent_tasks SET status='executing', started_at=NOW()
  ↓
开始执行任务（write 文件）
  ↓
每 5 分钟更新心跳:
  UPDATE pipeline_agent_tasks SET last_heartbeat_at=NOW()
  ↓
任务完成
  ↓
写入工作日志 (workinglog/{agent}/)
  ↓
UPDATE pipeline_agent_tasks SET status='completed', completed_at=NOW()
  ↓
回调通知 PM（subagent completion event）
```

---

### 流程 3: PM 回调验证与下一轮派发

```
收到 Agent 完成回调
  ↓
【步骤 1】Test-Path 验证交付文件是否存在
  ↓
【步骤 2】Test-Path 检查工作日志是否存在
  ↓
日志缺失 → 标记异常，下轮任务强制要求先补录
  ↓
【步骤 3】如同批次还有其他 Agent 未完成 → NO_REPLY 等待
  ↓
【步骤 4】同批次全部完成 → 执行验证脚本
  ├─ backend: mvn compile -q
  └─ frontend: npm run build
  ↓
【步骤 5】验证通过 → git commit + push
  ↓
【步骤 6】立即派发下一轮任务
  ├─ 调用 update-db-task-assigned.ps1 (自动幂等检查)
  └─ sessions_spawn × N (N=本轮 Agent 数量)
  ↓
UPDATE pipeline_rounds SET status='completed', verified=TRUE
  ↓
UPDATE pipeline_plans SET current_round+=1
  ↓
INSERT INTO pipeline_state_history 记录变更
```

---

### 流程 4: 心跳监控（PM 兜底）

```
Cron 每 10 分钟触发 (agent-heartbeat.yml)
  ↓
查询 pipeline_agent_tasks:
  WHERE status IN ('executing', 'assigned')
    AND last_heartbeat_at < NOW() - INTERVAL 60 MINUTE
  ↓
未找到 → HEARTBEAT_OK
  ↓
找到 → 失联 Agent 列表
  ↓
sessions_spawn 唤醒:
  "【心跳检查 - 立即汇报】🔴
   灌汤 PM 心跳检查发现你已失联超过 X 小时。
   请立即汇报：当前任务、进度、阻碍、下次汇报时间。
   限时 10 分钟内回复。"
  ↓
等待回复（10 分钟）
  ↓
有回复 → 检查工作日志 → 分配任务
  ↓
无回复 → 第二次唤醒 → 记录风险 → 人工介入
  ↓
UPDATE pipeline_agent_tasks SET status='unknown'
  ↓
INSERT INTO pipeline_state_history 记录变更
```

**Cron 配置:** `.openclaw/crons/agent-heartbeat.yml`

---

### 流程 5: 系统重启恢复 ⭐ v3.1 改进

```
系统开机/会话启动
  ↓
触发 pipeline-recovery.yml
  ↓
执行 restore-pipeline.ps1
  ↓
【步骤 1】记录系统启动事件
  INSERT INTO pipeline_system_events (event_type='system_startup')
  ↓
【步骤 2】查询进行中的计划
  SELECT * FROM pipeline_plans WHERE status='executing'
  ↓
未找到 → HEARTBEAT_OK（无进行中计划）
  ↓
找到 → 查询最后一轮 pipeline_rounds
  ↓
【步骤 3】查询需要恢复检查的 Agent 任务
  SELECT * FROM pipeline_agent_tasks 
  WHERE status IN ('unknown', 'executing', 'assigned')
  ↓
【步骤 4】逐个检查交付物:
  ├─ Test-Path 交付文件
  ├─ 文件存在 → UPDATE status='completed'
  └─ 文件不存在 → UPDATE status='failed' (可重试)
  ↓
【步骤 5】记录恢复结果
  UPDATE pipeline_system_events SET recovery_status='recovered'
  ↓
【步骤 6】等待 PM 确认（不自动派发）
```

**脚本路径:** `_tools/restore-pipeline.ps1`  
**Cron 配置:** `.openclaw/crons/pipeline-recovery.yml`

---

## 🛠️ 工具脚本清单

### 派发相关

| 脚本 | 路径 | 用途 | 调用时机 |
|------|------|------|---------|
| `check-idempotency.ps1` | `_tools/check-idempotency.ps1` | 幂等检查 | 派发前必须调用 |
| `update-db-task-assigned.ps1` | `_tools/update-db-task-assigned.ps1` | 派发任务（内置幂等检查） | sessions_spawn 前 |
| `update-db-task-completed.ps1` | `_tools/update-db-task-completed.ps1` | 完成任务回调 | 收到完成回调后 |
| `update-db-plan-completed.ps1` | `_tools/update-db-plan-completed.ps1` | 完成计划 | 计划最后一轮完成 |

### 恢复与验证

| 脚本 | 路径 | 用途 | 调用时机 |
|------|------|------|---------|
| `restore-pipeline.ps1` | `_tools/restore-pipeline.ps1` | 系统启动恢复 | Gateway 启动时自动执行 |
| `verify-idempotency.ps1` | `_tools/verify-idempotency.ps1` | 验证幂等机制 | 手动测试用 |
| `verify-agent-config.ps1` | `_tools/verify-agent-config.ps1` | 验证 Agent 配置 | 配置更新后 |

### 数据库

| 脚本 | 路径 | 用途 |
|------|------|------|
| `init-pipeline-db.sql` | `doc/guides/init-pipeline-db.sql` | 初始化数据库（6 张表） |
| `sync-plans-to-db.sql` | `doc/guides/sync-plans-to-db.sql` | 同步历史计划到数据库 |
| `add-pipeline-unique-constraints.sql` | `doc/guides/add-pipeline-unique-constraints.sql` | 添加唯一约束 |

---

## 📋 配置文件清单

### Cron 配置

| 文件 | 路径 | 用途 | 频率 |
|------|------|------|------|
| `agent-heartbeat.yml` | `.openclaw/crons/agent-heartbeat.yml` | 心跳监控 | 每 10 分钟 |
| `pipeline-recovery.yml` | `.openclaw/crons/pipeline-recovery.yml` | 系统恢复 | Gateway 启动时 |

### Agent 配置

| 文件 | 路径 | 用途 |
|------|------|------|
| `openclaw.json` | `C:\Users\Administrator\.openclaw\openclaw.json` | Agent 主配置（含 skill 配置） |
| `.env` | `workspace-{agent}/.env` | Agent 环境变量（数据库配置） |

---

## 🎯 幂等性保证详解 ⭐

### 1. 数据库唯一约束

```sql
ALTER TABLE pipeline_agent_tasks
ADD UNIQUE KEY uk_plan_round_agent (plan_id, round_id, agent_id);
```

**作用:** 防止同一任务被重复插入。

**验证:**
```sql
SHOW INDEX FROM pipeline_agent_tasks WHERE Key_name = 'uk_plan_round_agent';
```

### 2. 派发前检查

**脚本:** `_tools/check-idempotency.ps1`

**检查逻辑:**
```powershell
# 查询任务状态
SELECT status, deliverable_path, retry_count, assigned_at
FROM pipeline_agent_tasks
WHERE plan_id='$planId' AND round_id=$roundId AND agent_id='$agentId';

# 根据状态决定：
switch ($status) {
    'completed' {
        # 检查交付物是否存在
        if (Test-Path $deliverablePath) {
            return @{ CanDispatch = $false }  # 跳过
        } else {
            return @{ CanDispatch = $true; Action = "redo" }  # 重做
        }
    }
    'executing' {
        # 检查超时
        $minutes = TIMESTAMPDIFF(MINUTE, assigned_at, NOW())
        if ($minutes -gt 60) {
            return @{ CanDispatch = $true; Action = "redo" }  # 重做
        } else {
            return @{ CanDispatch = $false }  # 等待
        }
    }
    'failed' {
        # 检查重试次数
        if ($retryCount -ge 2) {
            return @{ CanDispatch = $false }  # 需要 PM 介入
        } else {
            return @{ CanDispatch = $true; Action = "retry" }  # 重试
        }
    }
    # ... 其他状态
}
```

### 3. 幂等插入

**SQL 模式:**
```sql
INSERT INTO pipeline_agent_tasks (plan_id, round_id, agent_id, task_name, status, assigned_at)
VALUES ('plan-006', 1, 'jiangrou', 'Task Name', 'assigned', NOW())
ON DUPLICATE KEY UPDATE 
    status = 'assigned',
    assigned_at = NOW(),
    retry_count = retry_count + 1;
```

**效果:**
- 第一次执行 → INSERT 新记录
- 第二次执行 → UPDATE 已有记录（不会创建重复）

---

## 📊 监控与审计

### 实时状态查询

```sql
-- 当前进行中的计划
SELECT plan_id, plan_name, status, current_round, total_rounds,
       TIMESTAMPDIFF(HOUR, created_at, NOW()) AS running_hours
FROM pipeline_plans
WHERE status = 'executing';

-- 各 Agent 今日任务完成率
SELECT 
    agent_id,
    COUNT(*) AS total_tasks,
    SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS completed,
    SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END) AS failed,
    ROUND(SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS success_rate
FROM pipeline_agent_tasks
WHERE DATE(assigned_at) = CURDATE()
GROUP BY agent_id;

-- 今日验证失败记录
SELECT verification_type, error_message, verified_at
FROM pipeline_verifications
WHERE status = 'failed' AND DATE(verified_at) = CURDATE()
ORDER BY verified_at DESC;

-- 状态变更历史（最近 20 条）
SELECT plan_id, round_id, old_status, new_status, change_reason, changed_at, changed_by
FROM pipeline_state_history
ORDER BY changed_at DESC
LIMIT 20;
```

### 监控仪表板

**文件:** `doc/05-progress/agent-pipeline-dashboard.md`

**内容:**
- 当前进行中的计划
- Agent 今日表现（完成率、平均耗时）
- 异常告警（心跳超时、编译失败）
- 趋势图（7 天任务成功率）

---

## 🔒 安全与合规

### 数据备份

- **备份频率:** 每日 02:00 自动备份 MySQL 数据库
- **备份保留:** 最近 7 天
- **备份位置:** `F:\openclaw\backups\pipeline\`

### 敏感信息

- ❌ 禁止上传到 Git：数据库密码、服务器 IP、SSH 密钥
- ✅ 敏感信息存放：`.local/` 目录（已加入 .gitignore）
- ✅ 分配任务时：在 sessions_spawn 消息中直接提供连接信息

### 审计追溯

- 所有状态变更写入 `pipeline_state_history`
- 所有系统事件写入 `pipeline_system_events`
- 所有验证记录写入 `pipeline_verifications`
- 保留期限：永久（除非手动清理）

---

## 📚 相关文档

| 文档 | 路径 | 说明 |
|------|------|------|
| 心跳配置 | `workspace-guantang/HEARTBEAT.md` | 心跳机制详细说明 |
| 更新日志 | `doc/guides/heartbeat-v3.1-changelog.md` | v3.1 更新详情 |
| 任务工单模板 | `doc/06-templates/task-order-template-v3.md` | 结构化工单格式 |
| 计划管理 Skill | `workspace-guantang/skills/plan-db-sync/SKILL.md` | 数据库同步技能 |
| 监控仪表板 | `doc/05-progress/agent-pipeline-dashboard.md` | 实时监控面板 |

---

## 🎯 实施检查清单

### 已完成 ✅

- [x] 创建数据库表结构（6 张表）
- [x] 添加唯一约束（uk_plan_round_agent）
- [x] 编写幂等检查脚本（check-idempotency.ps1）
- [x] 编写恢复脚本（restore-pipeline.ps1）
- [x] 更新派发工具（update-db-task-assigned.ps1）
- [x] 更新心跳 Cron（agent-heartbeat.yml）
- [x] 更新恢复 Cron（pipeline-recovery.yml）
- [x] 同步历史计划到数据库
- [x] 为所有 Agent 添加 plan-db-sync skill
- [x] 创建各 Agent .env 配置文件
- [x] 更新 HEARTBEAT.md 文档
- [x] Git 提交并推送

### 待实施 ⏳

- [ ] Agent 主动心跳（每 5 分钟更新数据库）
- [ ] 可视化监控仪表板（Web 界面）
- [ ] 自动部署集成（GitHub Actions → Docker）

---

**文档位置:** `F:\openclaw\agent\doc\guides\agent-pipeline-mechanism-v3.1.md`  
**维护者:** 灌汤 (PM) 🍲  
**最后更新:** 2026-03-26 22:25  
**版本:** v3.1 (幂等版)
