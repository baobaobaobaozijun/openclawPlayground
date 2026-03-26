-- ============================================
-- Agent 全自动流水线数据库初始化脚本
-- 版本：v3.0
-- 创建日期：2026-03-26
-- 数据库：baozipu (博客系统数据库)
-- ============================================

-- 使用数据库
USE baozipu;

-- ============================================
-- 1. 计划主表 (pipeline_plans)
-- ============================================
DROP TABLE IF EXISTS pipeline_plans;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流水线计划主表';

-- ============================================
-- 2. 轮次表 (pipeline_rounds)
-- ============================================
DROP TABLE IF EXISTS pipeline_rounds;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流水线轮次表';

-- ============================================
-- 3. Agent 任务表 (pipeline_agent_tasks)
-- ============================================
DROP TABLE IF EXISTS pipeline_agent_tasks;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Agent 任务表';

-- ============================================
-- 4. 验证记录表 (pipeline_verifications)
-- ============================================
DROP TABLE IF EXISTS pipeline_verifications;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='验证记录表';

-- ============================================
-- 5. 状态变更历史表 (pipeline_state_history)
-- ============================================
DROP TABLE IF EXISTS pipeline_state_history;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='状态变更历史表（审计日志）';

-- ============================================
-- 6. 系统事件表 (pipeline_system_events)
-- ============================================
DROP TABLE IF EXISTS pipeline_system_events;
CREATE TABLE pipeline_system_events (
    id INT PRIMARY KEY AUTO_INCREMENT,
    event_type ENUM('system_shutdown', 'system_startup', 'gateway_restart', 'network_loss') NOT NULL,
    event_data JSON,                          -- 额外事件数据
    detected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    recovery_status ENUM('pending', 'recovering', 'recovered', 'failed') DEFAULT 'pending',
    recovery_log TEXT,
    
    INDEX idx_event_type (event_type),
    INDEX idx_detected_at (detected_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统事件表';

-- ============================================
-- 初始化数据（可选）
-- ============================================

-- 插入一个测试计划（用于验证）
-- INSERT INTO pipeline_plans (plan_id, plan_name, status, current_round, total_rounds, priority)
-- VALUES ('plan-001', 'Auth 流程闭环', 'pending', 0, 3, 'P1');

-- ============================================
-- 验证查询
-- ============================================

-- 检查表是否创建成功
SELECT 
    TABLE_NAME, 
    TABLE_COMMENT, 
    CREATE_TIME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'baozipu' 
  AND TABLE_NAME LIKE 'pipeline_%'
ORDER BY TABLE_NAME;

-- ============================================
-- 完成提示
-- ============================================
SELECT '✅ 流水线数据库初始化完成！共创建 6 张表：
  - pipeline_plans (计划主表)
  - pipeline_rounds (轮次表)
  - pipeline_agent_tasks (Agent 任务表)
  - pipeline_verifications (验证记录表)
  - pipeline_state_history (状态变更历史)
  - pipeline_system_events (系统事件表)
' AS message;
