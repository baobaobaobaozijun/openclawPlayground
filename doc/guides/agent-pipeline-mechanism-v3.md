<!-- Last Modified: 2026-03-26 15:00 -->

# Agent 全自动流水线机制 v3.0

**版本:** v3.0 (数据库 + 回调驱动 + 心跳兜底)  
**创建日期:** 2026-03-26  
**负责人:** 灌汤 (PM)  
**状态:** ✅ 设计完成，待实施

---

## 🎯 机制目标

1. **任务派发自动化** — 回调驱动，零空窗派发
2. **状态持久化** — 数据库存储，关机不丢失
3. **自动恢复** — 开机/重启后自动续做或重做
4. **心跳监控** — 实时发现失联 Agent，快速响应
5. **质量保障** — 自动验证 + Git 关联 + 审计追溯

---

## 🏗️ 整体架构

```
┌─────────────────────────────────────────────────────────────────┐
│                        全自动流水线 v3.0                         │
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │  计划生成   │ →  │  工单派发   │ →  │  自动验证   │         │
│  │  (PRD 解析)  │    │ (sessions) │    │ (mvn/npm)   │         │
│  └─────────────┘    └─────────────┘    └─────────────┘         │
│         ↓                  ↓                  ↓                 │
│  写入 pipeline_plans  写入 agent_tasks  写入 verifications     │
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
│  │              数据库状态机 (MySQL)                      │      │
│  │  pipeline_plans | pipeline_rounds | agent_tasks      │      │
│  │  verifications | state_history | system_events       │      │
│  └──────────────────────────────────────────────────────┘      │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📊 数据库 Schema

### 1. 计划主表 (pipeline_plans)

```sql
CREATE TABLE pipeline_plans (
    id INT PRIMARY KEY AUTO_INCREMENT,
    plan_id VARCHAR(50) UNIQUE NOT NULL,      -- 'plan-003'
    plan_name VARCHAR(200) NOT NULL,          -- 'Auth 流程闭环'
    prd_doc_path VARCHAR(500),                -- PRD 文档路径
    status ENUM('pending', 'executing', 'blocked', 'completed', 'cancelled') DEFAULT 'pending',
    current_round INT DEFAULT 0,
    total_rounds INT DEFAULT 0,
    priority ENUM('P0', 'P1', 'P2') DEFAULT 'P1',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
    round_name VARCHAR(200),                  -- '第 1 轮 - 基础接口'
    status ENUM('pending', 'executing', 'verifying', 'completed', 'failed', 'interrupted') DEFAULT 'pending',
    verified BOOLEAN DEFAULT FALSE,
    verified_at TIMESTAMP NULL,
    started_at TIMESTAMP NULL,
    completed_at TIMESTAMP NULL,
    interrupted_at TIMESTAMP NULL,
    interrupt_reason VARCHAR(500),            -- 'system_shutdown', 'agent_timeout', 'compile_failed'
    
    FOREIGN KEY (plan_id) REFERENCES pipeline_plans(plan_id) ON DELETE CASCADE,
    UNIQUE KEY uk_plan_round (plan_id, round_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 3. Agent 任务表 (pipeline_agent_tasks)

```sql
CREATE TABLE pipeline_agent_tasks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    plan_id VARCHAR(50) NOT NULL,
    round_id INT NOT NULL,
    agent_id VARCHAR(50) NOT NULL,            -- 'jiangrou', 'dousha', 'suancai'
    task_name VARCHAR(200) NOT NULL,          -- 'AuthController', 'LoginView'
    task_description TEXT,                    -- 工单完整内容
    deliverable_path VARCHAR(500),            -- 交付文件路径
    status ENUM('pending', 'assigned', 'executing', 'completed', 'failed', 'unknown') DEFAULT 'pending',
    verified BOOLEAN DEFAULT FALSE,
    git_commit_hash VARCHAR(40),              -- 关联的 Git commit
    failure_reason TEXT,                      -- 失败原因
    retry_count INT DEFAULT 0,                -- 重做次数
    max_retries INT DEFAULT 2,                -- 最大重试次数
    assigned_at TIMESTAMP NULL,
    started_at TIMESTAMP NULL,
    completed_at TIMESTAMP NULL,
    verified_at TIMESTAMP NULL,
    last_heartbeat_at TIMESTAMP NULL,         -- Agent 最后心跳时间
    
    FOREIGN KEY (plan_id) REFERENCES pipeline_plans(plan_id) ON DELETE CASCADE,
    INDEX idx_agent_status (agent_id, status),
    INDEX idx_plan_round (plan_id, round_id)
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
    command_executed VARCHAR(500),            -- 执行的验证命令
    output_log TEXT,                          -- 验证输出日志
    error_message TEXT,                       -- 错误信息
    verified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    verified_by VARCHAR(50) DEFAULT 'system',
    
    FOREIGN KEY (plan_id) REFERENCES pipeline_plans(plan_id) ON DELETE CASCADE,
    INDEX idx_verification_type (verification_type)
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
    event_data JSON,                          -- 额外事件数据
    detected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    recovery_status ENUM('pending', 'recovering', 'recovered', 'failed') DEFAULT 'pending',
    recovery_log TEXT,
    
    INDEX idx_event_type (event_type),
    INDEX idx_detected_at (detected_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 🔄 核心工作流程

### 流程 1: 计划生成与工单派发

```
PM 创建计划
  ↓
写入 pipeline_plans (status='pending')
  ↓
PM 编写 PRD + 技术方案
  ↓
拆分为 N 轮工单（每轮 2-3 个 Agent 任务）
  ↓
写入 pipeline_rounds (status='pending')
  ↓
写入 pipeline_agent_tasks (status='pending')
  ↓
更新 pipeline_plans (status='executing', current_round=1)
  ↓
sessions_spawn 派发工单给 Agent
  ↓
INSERT INTO pipeline_state_history 记录变更
```

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
【步骤 6】立即派发下一轮任务（sessions_spawn × 3）
  ↓
UPDATE pipeline_rounds SET status='completed', verified=TRUE
  ↓
UPDATE pipeline_plans SET current_round+=1
  ↓
INSERT INTO pipeline_state_history 记录变更
```

### 流程 4: 心跳监控（PM 兜底）

```
Cron 每 10 分钟触发
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

### 流程 5: 系统重启恢复

```
系统开机/会话启动
  ↓
检测系统事件 → INSERT INTO pipeline_system_events (event_type='system_startup')
  ↓
查询 pipeline_plans WHERE status='executing'
  ↓
未找到 → HEARTBEAT_OK（无进行中计划）
  ↓
找到 → 查询最后一轮 pipeline_rounds
  ↓
round.status = 'interrupted'
  ↓
查询 pipeline_agent_tasks WHERE status IN ('unknown', 'executing')
  ↓
逐个检查：
  ├─ Test-Path 交付文件
  ├─ 检查工作日志（workinglog/{agent}/）
  ├─ 查询 pipeline_system_events（是否有 shutdown 记录）
  ↓
更新任务状态：
  ├─ 文件存在 → UPDATE status='completed', verified=FALSE
  ├─ 文件不存在 → UPDATE status='failed', retry_count+=1
  └─ 有活跃 subagent → sessions_spawn 询问进度
  ↓
INSERT INTO pipeline_state_history 记录变更
  ↓
根据恢复结果决定：续做 / 重做 / 通知 PM
```

---

## 🎯 Agent 能力适配策略

### 能力矩阵

| Agent | 擅长 | 不擅长 | 最佳任务模式 |
|-------|------|--------|-------------|
| 🍖 酱肉 | 写新代码文件 | 读取现有文件→edit 修改、多步骤推理 | **给完整代码 → write 创建** |
| 🍡 豆沙 | 页面组件开发、样式 | — | 给需求描述 + 参考样例，可自由发挥 |
| 🥬 酸菜 | 脚本/配置/文档 | 多步骤复杂命令 | **给完整内容 → write 创建** |

### 酱肉专项规则 🍖

**背景:** 2026-03-25 测试结果 — 酱肉 10 项任务中 4 项需 PM 兜底（40%），全部集中在"读取+edit"类任务。改为"给完整代码"后连续 4 轮零兜底。

**强制要求:**
1. ✅ **给完整代码让 write** — 成功率 >90%
2. ❌ **禁止"请先读取 xxx 文件再 edit"** — 失败率 >50%
3. ✅ **任务模板中固定 PowerShell 语法** — 用分号 `;` 不用 `&&`
4. ✅ **编译命令写死:** `cd F:\openclaw\code\backend; mvn compile -q`
5. ✅ **每个 spawn ≤4 步 tool call:** write + compile + 日志 + (可选 commit)

### 工单规模控制

| Agent | tool call 预算 | 产出文件数 | 验证命令 |
|-------|---------------|-----------|----------|
| 酱肉 | ≤4 步 | 1 个 Java 文件 | mvn compile -q |
| 豆沙 | ≤4 步 | 1 个 Vue 文件 | npm run build |
| 酸菜 | ≤3 步 | 1 个脚本/配置 | Test-Path + 语法检查 |

---

## 📋 结构化任务工单模板

**文件路径:** `doc/06-templates/task-order-template-v3.md`

```markdown
# 任务工单

**计划 ID:** {plan-003}  
**轮次:** 第 {3} 轮  
**Agent:** {jiangrou}  
**任务 ID:** {round-3-jiangrou}

---

## 📥 输入

{直接贴关键数据：代码片段/接口定义/参数}
{不要写"请先阅读 xxx 文件"}

---

## 📤 交付物

**精确文件路径:** {F:\openclaw\code\backend\src\main\java\...\AuthController.java}

---

## ✅ 验收标准

- [ ] 文件路径正确
- [ ] 编译通过（mvn compile -q）
- [ ] 工作日志已记录（workinglog/jiangrou/）
- [ ] Git commit 已提交

---

## ❌ 禁止事项

- 不要修改其他已完成的文件
- 不要读取现有文件进行 edit 修改
- 不要扩展任务范围（如"顺便优化 xxx"）
- 不要跳过工作日志

---

## ⏱️ 超时处理

**15 分钟无法完成 → 立即回复阻塞原因:**
1. 具体阻塞点
2. 需要什么支持
3. 预计还需要多久

---

## 📏 规模控制

**tool call 预算:** ≤4 步  
**建议流程:** write → Test-Path → exec(mvn compile) → 写日志

---

## ❤️ 心跳要求

- 开始执行时：更新数据库心跳
- 执行过程中：每 5 分钟更新一次心跳
- 完成任务时：更新状态为 completed + 最后心跳

---
```

---

## 🔧 重做/续做机制

### 状态判定

| 场景 | 判定条件 | 行动 |
|------|----------|------|
| **续做** | 文件存在 + 编译通过 + 日志有记录 | 跳过执行，直接进入验证 |
| **部分重做** | 文件不存在/编译失败，仅部分 Agent | 重做失败的 Agent，成功的保持不变 |
| **整轮重做** | 关键依赖失败（如后端 API 缺失导致前端无法联调） | 整轮回滚重做 |
| **计划重做** | 需求变更/技术方案调整 | 更新 plan.md，从第一轮重新开始 |

### 重做工单模板（新增字段）

```markdown
## 🔄 重做任务（第 X 次尝试）

**原任务 ID:** round-{N}-{agent}  
**失败原因:** {具体原因，如"编译失败：缺少 Token 刷新接口"}  
**前次交付物:** {文件路径，如存在}  
**本次调整:** {说明工单有何改进，如"简化任务范围，只做 Token 刷新"}

⚠️ **特别注意:**
- 不要修改其他已完成的文件
- 只聚焦于 {具体任务}
- 如遇阻碍，立即回复阻塞原因，不要自行扩展任务范围
```

### 重做策略

| 重做次数 | 行动 |
|----------|------|
| 第 1 次 | 调整工单（简化范围/提供更多上下文） |
| 第 2 次 | PM 介入分析根本原因 |
| 第 3 次 | 标记为"能力不匹配"，调整任务分配策略 |

---

## 📊 心跳监控机制

### 心跳三重角色

| 角色 | 触发频率 | 职责 | 数据库操作 |
|------|----------|------|-----------|
| **状态上报** | Agent 主动（每 5 分钟） | Agent 汇报进度，更新 last_heartbeat_at | `UPDATE pipeline_agent_tasks SET last_heartbeat_at=NOW()` |
| **失联检测** | PM 被动检查（每 10 分钟） | 发现 >60min 无心跳的 Agent | `SELECT * WHERE last_heartbeat_at < NOW()-INTERVAL 60 MINUTE` |
| **恢复触发** | 系统事件驱动 | 开机/重启后自动触发恢复流程 | `INSERT INTO pipeline_system_events` |

### 判定标准

| 心跳间隔 | 状态 | 行动 |
|----------|------|------|
| < 30 分钟 | 🟢 正常 | 不干预 |
| 30-60 分钟 | 🟡 警告 | 记录到看板，准备备选方案 |
| > 60 分钟 | 🔴 失联 | sessions_spawn 唤醒 → 更新状态为 unknown |

### 唤醒流程

```
心跳检查发现失联 Agent
  ↓
【步骤 1】创建 inbox 紧急通知（记录用途）
  ↓
【步骤 2】立即 sessions_spawn 强制唤醒 ⭐ 关键
  ↓
指定阅读 inbox 文件 + 执行具体任务
  ↓
等待响应（10 分钟）
  ↓
有回复 → 分配任务 → 持续监控
  ↓
无回复 → 第二次 sessions_spawn 唤醒 → 记录违规
```

---

## 🛠️ 自动化脚本

### 1. 流水线恢复脚本 (restore-pipeline.ps1)

**位置:** `F:\openclaw\agent\workspace-guantang\scripts\restore-pipeline.ps1`

```powershell
# 流水线状态恢复脚本
# 系统启动/会话启动时自动执行

$ErrorActionPreference = "Stop"

# 数据库配置
$dbHost = "localhost"
$dbPort = "3306"
$dbName = "baozipu"
$dbUser = "root"
$dbPass = "your_password"

# 查询进行中的计划
$query = @"
SELECT plan_id, plan_name, current_round, total_rounds
FROM pipeline_plans
WHERE status = 'executing'
LIMIT 1;
"@

# 执行查询
$result = Invoke-MySqlQuery -Host $dbHost -Port $dbPort -Database $dbName `
    -User $dbUser -Password $dbPass -Query $query

if ($null -eq $result) {
    Write-Host "✅ 无进行中的计划，HEARTBEAT_OK"
    exit 0
}

Write-Host "🔍 发现进行中的计划：$($result.plan_name) (第 $($result.current_round)/$($result.total_rounds) 轮)"

# 查询最后一轮状态
$roundQuery = @"
SELECT round_id, status, interrupt_reason
FROM pipeline_rounds
WHERE plan_id = '$($result.plan_id)'
ORDER BY round_id DESC
LIMIT 1;
"@

$roundResult = Invoke-MySqlQuery -Host $dbHost -Port $dbPort -Database $dbName `
    -User $dbUser -Password $dbPass -Query $roundQuery

if ($roundResult.status -eq 'interrupted') {
    Write-Host "⚠️ 最后一轮被中断：原因 = $($roundResult.interrupt_reason)"
    
    # 查询需要恢复检查的 Agent 任务
    $taskQuery = @"
    SELECT agent_id, task_name, deliverable_path, status
    FROM pipeline_agent_tasks
    WHERE plan_id = '$($result.plan_id)' AND round_id = $($roundResult.round_id)
      AND status IN ('unknown', 'executing');
    "@
    
    $tasks = Invoke-MySqlQuery -Host $dbHost -Port $dbPort -Database $dbName `
        -User $dbUser -Password $dbPass -Query $taskQuery
    
    foreach ($task in $tasks) {
        Write-Host "📋 检查 $($task.agent_id) 任务：$($task.task_name)"
        
        if (Test-Path $task.deliverable_path) {
            Write-Host "✅ 文件存在，标记为 completed"
            # 更新数据库状态
            $updateQuery = @"
            UPDATE pipeline_agent_tasks
            SET status = 'completed', verified = FALSE
            WHERE plan_id = '$($result.plan_id)' AND round_id = $($roundResult.round_id)
              AND agent_id = '$($task.agent_id)';
            "@
            Invoke-MySqlQuery -Host $dbHost -Port $dbPort -Database $dbName `
                -User $dbUser -Password $dbPass -Query $updateQuery
        } else {
            Write-Host "❌ 文件不存在，标记为 failed"
            # 更新数据库状态
            $updateQuery = @"
            UPDATE pipeline_agent_tasks
            SET status = 'failed', retry_count = retry_count + 1
            WHERE plan_id = '$($result.plan_id)' AND round_id = $($roundResult.round_id)
              AND agent_id = '$($task.agent_id)';
            "@
            Invoke-MySqlQuery -Host $dbHost -Port $dbPort -Database $dbName `
                -User $dbUser -Password $dbPass -Query $updateQuery
        }
    }
    
    # 记录系统事件
    $eventQuery = @"
    INSERT INTO pipeline_system_events (event_type, event_data, recovery_status)
    VALUES ('system_startup', '{"plan_id": "$($result.plan_id)", "round_id": $($roundResult.round_id)}', 'recovering');
    "@
    Invoke-MySqlQuery -Host $dbHost -Port $dbPort -Database $dbName `
        -User $dbUser -Password $dbPass -Query $eventQuery
    
    Write-Host "📝 恢复检查完成，准备派发任务"
} else {
    Write-Host "✅ 最后一轮状态正常：$($roundResult.status)"
}
```

### 2. 心跳检查脚本 (heartbeat-check.ps1)

**位置:** `F:\openclaw\agent\workspace-guantang\scripts\heartbeat-check.ps1`

```powershell
# Agent 心跳检查脚本
# 每 10 分钟执行一次

$ErrorActionPreference = "Stop"

# 数据库配置
$dbHost = "localhost"
$dbPort = "3306"
$dbName = "baozipu"
$dbUser = "root"
$dbPass = "your_password"

# 查询失联 Agent（>60 分钟无心跳）
$query = @"
SELECT 
    plan_id,
    round_id,
    agent_id,
    task_name,
    status,
    last_heartbeat_at,
    TIMESTAMPDIFF(MINUTE, last_heartbeat_at, NOW()) AS minutes_since_heartbeat
FROM pipeline_agent_tasks
WHERE status IN ('executing', 'assigned')
  AND last_heartbeat_at < NOW() - INTERVAL 60 MINUTE;
"@

$lostAgents = Invoke-MySqlQuery -Host $dbHost -Port $dbPort -Database $dbName `
    -User $dbUser -Password $dbPass -Query $query

if ($null -eq $lostAgents -or $lostAgents.Count -eq 0) {
    Write-Host "✅ 所有 Agent 心跳正常，HEARTBEAT_OK"
    exit 0
}

Write-Host "🔴 发现 $($lostAgents.Count) 个失联 Agent:"

foreach ($agent in $lostAgents) {
    Write-Host "  - $($agent.agent_id): $($agent.task_name) (失联 $($agent.minutes_since_heartbeat) 分钟)"
    
    # 更新状态为 unknown
    $updateQuery = @"
    UPDATE pipeline_agent_tasks
    SET status = 'unknown'
    WHERE plan_id = '$($agent.plan_id)' AND round_id = $($agent.round_id)
      AND agent_id = '$($agent.agent_id)';
    "@
    Invoke-MySqlQuery -Host $dbHost -Port $dbPort -Database $dbName `
        -User $dbUser -Password $dbPass -Query $updateQuery
    
    # 记录状态变更历史
    $historyQuery = @"
    INSERT INTO pipeline_state_history (plan_id, round_id, agent_task_id, old_status, new_status, change_reason)
    VALUES ('$($agent.plan_id)', $($agent.round_id), 
            (SELECT id FROM pipeline_agent_tasks WHERE plan_id='$($agent.plan_id)' AND round_id=$($agent.round_id) AND agent_id='$($agent.agent_id)'),
            '$($agent.status)', 'unknown', 'heartbeat_timeout');
    "@
    Invoke-MySqlQuery -Host $dbHost -Port $dbPort -Database $dbName `
        -User $dbUser -Password $dbPass -Query $historyQuery
    
    # sessions_spawn 唤醒（通过 OpenClaw 命令）
    Write-Host "📞 正在唤醒 $($agent.agent_id)..."
    # 此处调用 OpenClaw sessions_spawn API
}

Write-Host "📝 心跳检查完成"
```

---

## 📈 监控仪表板

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
```

### 仪表板文件

**位置:** `doc/05-progress/agent-pipeline-dashboard.md`

```markdown
# Agent 全自动流水线监控仪表板

**最后更新:** {时间}  
**数据源:** pipeline_* 数据库表

## 🚀 当前计划

| 计划 ID | 名称 | 进度 | 状态 | 运行时长 |
|--------|------|------|------|---------|
| plan-003 | Auth 流程闭环 | 3/3 | executing | 2.5h |

## 👥 Agent 今日表现

| Agent | 总任务 | 完成 | 失败 | 成功率 | 平均耗时 |
|-------|-------|------|------|--------|---------|
| 酱肉 | 5 | 5 | 0 | 100% | 8min |
| 豆沙 | 5 | 4 | 1 | 80% | 10min |
| 酸菜 | 3 | 3 | 0 | 100% | 5min |

## ⚠️ 异常告警

| 类型 | 描述 | 发生时间 | 处理状态 |
|------|------|---------|---------|
| 心跳超时 | 豆沙失联 75 分钟 | 14:30 | 已唤醒 |
| 编译失败 | backend: 缺少 Token 接口 | 13:45 | 重做中 |

## 📊 趋势图

（待实现：7 天任务成功率、平均耗时、心跳合格率）

---

*自动更新，下次检查：{时间 +10min}*
```

---

## 🎯 实施检查清单

### 阶段 1 (P0 - 本周)

- [ ] 创建数据库表结构（6 张表）
- [ ] 编写数据库初始化脚本 (init-pipeline-db.sql)
- [ ] 在工单派发时写入 pipeline_agent_tasks
- [ ] 在任务完成回调时更新状态
- [ ] 灌汤会话启动时查询恢复状态
- [ ] 创建 restore-pipeline.ps1 恢复脚本
- [ ] 配置 session_start 事件触发恢复检查

### 阶段 2 (P1 - 下周)

- [ ] Agent 主动心跳（每 5 分钟更新数据库）
- [ ] PM 心跳检查改为数据库查询
- [ ] 系统事件记录（开机/重启）
- [ ] 创建 heartbeat-check.ps1 脚本
- [ ] 配置 Cron 每 10 分钟执行心跳检查
- [ ] 创建监控仪表板文档

### 阶段 3 (P2 - 优化)

- [ ] 验证记录自动写入 pipeline_verifications
- [ ] Git commit 自动关联到任务
- [ ] 可视化仪表板（Web 界面或飞书卡片）
- [ ] 历史数据分析（Agent 效率、瓶颈识别）
- [ ] 自动部署集成（GitHub Actions → Docker）

---

## 📚 相关文档

| 文档 | 位置 | 说明 |
|------|------|------|
| 任务工单模板 | `doc/06-templates/task-order-template-v3.md` | 结构化工单格式 |
| 计划管理 Skill | `skills/plan-manager/SKILL.md` | 计划创建/更新/完成 |
| 心跳日志 | `doc/progress/agent-heartbeat-log.md` | 每次心跳检查记录 |
| 状态机设计 | 本文档 | 数据库 Schema + 流程 |

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

**文档位置:** `F:\openclaw\agent\doc\guides\agent-pipeline-mechanism-v3.md`  
**维护者:** 灌汤 (PM) 🍲  
**最后更新:** 2026-03-26 15:00  
**版本:** v3.0
