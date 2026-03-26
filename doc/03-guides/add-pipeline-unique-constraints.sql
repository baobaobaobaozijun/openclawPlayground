-- ============================================
-- 添加唯一约束，确保幂等性
-- 执行时间：2026-03-26 22:05
-- ============================================

USE baozipu;

-- 1. pipeline_rounds: 唯一键 (plan_id, round_id)
ALTER TABLE pipeline_rounds
ADD UNIQUE KEY uk_plan_round (plan_id, round_id);

-- 2. pipeline_agent_tasks: 唯一键 (plan_id, round_id, agent_id)
-- 这是幂等性的核心保证
ALTER TABLE pipeline_agent_tasks
ADD UNIQUE KEY uk_plan_round_agent (plan_id, round_id, agent_id);

-- 3. 验证约束已添加
SELECT 
    TABLE_NAME, 
    INDEX_NAME, 
    GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX) AS COLUMNS
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'baozipu'
  AND TABLE_NAME LIKE 'pipeline_%'
  AND INDEX_NAME LIKE 'uk_%'
GROUP BY TABLE_NAME, INDEX_NAME
ORDER BY TABLE_NAME, INDEX_NAME;

SELECT '✅ Unique constraints added successfully' AS result;
