-- ============================================
-- 流水线机制测试数据
-- 用于验证数据库 Schema 和恢复流程
-- ============================================

USE baozipu;

-- 插入测试计划
INSERT INTO pipeline_plans (plan_id, plan_name, status, current_round, total_rounds, priority)
VALUES ('plan-test-001', '流水线机制测试', 'executing', 2, 3, 'P1');

-- 插入测试轮次
INSERT INTO pipeline_rounds (plan_id, round_id, round_name, status, verified)
VALUES 
('plan-test-001', 1, '第 1 轮 - 测试', 'completed', TRUE),
('plan-test-001', 2, '第 2 轮 - 测试', 'interrupted', FALSE);

-- 插入测试 Agent 任务
INSERT INTO pipeline_agent_tasks (plan_id, round_id, agent_id, task_name, task_description, deliverable_path, status, verified)
VALUES 
('plan-test-001', 1, 'jiangrou', 'TestController', '测试任务', 'F:\\openclaw\\test\\Test.java', 'completed', TRUE),
('plan-test-001', 2, 'jiangrou', 'TestService', '测试任务', 'F:\\openclaw\\test\\TestService.java', 'executing', FALSE),
('plan-test-001', 2, 'dousha', 'TestView', '测试任务', 'F:\\openclaw\\test\\TestView.vue', 'assigned', FALSE);

-- 验证查询
SELECT '=== 测试计划 ===' AS section;
SELECT * FROM pipeline_plans WHERE plan_id = 'plan-test-001';

SELECT '=== 测试轮次 ===' AS section;
SELECT * FROM pipeline_rounds WHERE plan_id = 'plan-test-001';

SELECT '=== 测试任务 ===' AS section;
SELECT * FROM pipeline_agent_tasks WHERE plan_id = 'plan-test-001';

SELECT '=== 数据库测试完成 ===' AS section;
