USE baozipu;

-- Plan-001
INSERT INTO pipeline_plans (plan_id, plan_name, status, current_round, total_rounds, priority, completed_at)
VALUES ('plan-001', 'P0 Blocker Fix', 'completed', 5, 5, 'P0', '2026-03-26 08:27:00')
ON DUPLICATE KEY UPDATE status='completed', current_round=5, completed_at='2026-03-26 08:27:00';

-- Plan-002
INSERT INTO pipeline_plans (plan_id, plan_name, status, current_round, total_rounds, priority, completed_at)
VALUES ('plan-002', 'Article Management', 'completed', 5, 5, 'P1', '2026-03-26 08:34:00')
ON DUPLICATE KEY UPDATE status='completed', current_round=5, completed_at='2026-03-26 08:34:00';

-- Plan-003
INSERT INTO pipeline_plans (plan_id, plan_name, status, current_round, total_rounds, priority, completed_at)
VALUES ('plan-003', 'Feature Functions', 'completed', 5, 5, 'P1', '2026-03-26 08:41:00')
ON DUPLICATE KEY UPDATE status='completed', current_round=5, completed_at='2026-03-26 08:41:00';

-- Plan-004
INSERT INTO pipeline_plans (plan_id, plan_name, status, current_round, total_rounds, priority, completed_at)
VALUES ('plan-004', 'Category Tag', 'completed', 5, 5, 'P2', '2026-03-26 08:47:00')
ON DUPLICATE KEY UPDATE status='completed', current_round=5, completed_at='2026-03-26 08:47:00';

-- Plan-005
INSERT INTO pipeline_plans (plan_id, plan_name, status, current_round, total_rounds, priority, completed_at)
VALUES ('plan-005', 'Doc Sync Acceptance', 'completed', 5, 5, 'P2', '2026-03-26 08:50:00')
ON DUPLICATE KEY UPDATE status='completed', current_round=5, completed_at='2026-03-26 08:50:00';

-- Plan-001 rounds
INSERT INTO pipeline_rounds (plan_id, round_id, round_name, status, verified, completed_at) VALUES
('plan-001', 1, 'DB users table', 'completed', 1, '2026-03-26 08:26:00'),
('plan-001', 2, 'AuthController', 'completed', 1, '2026-03-26 08:27:00'),
('plan-001', 3, 'Frontend API path', 'completed', 1, '2026-03-26 08:28:00'),
('plan-001', 4, 'Token format', 'completed', 1, '2026-03-26 08:29:00'),
('plan-001', 5, 'Build verify', 'completed', 1, '2026-03-26 08:27:00')
ON DUPLICATE KEY UPDATE status='completed', verified=1;

-- Plan-002 rounds
INSERT INTO pipeline_rounds (plan_id, round_id, round_name, status, verified, completed_at) VALUES
('plan-002', 1, 'DB articles table', 'completed', 1, '2026-03-26 08:27:00'),
('plan-002', 2, 'Article Entity+Mapper', 'completed', 1, '2026-03-26 08:29:00'),
('plan-002', 3, 'ArticleService+Controller', 'completed', 1, '2026-03-26 08:30:00'),
('plan-002', 4, 'Frontend article pages', 'completed', 1, '2026-03-26 08:33:00'),
('plan-002', 5, 'Deploy script', 'completed', 1, '2026-03-26 08:34:00')
ON DUPLICATE KEY UPDATE status='completed', verified=1;

-- Plan-003 rounds
INSERT INTO pipeline_rounds (plan_id, round_id, round_name, status, verified, completed_at) VALUES
('plan-003', 1, 'Scheduler config', 'completed', 1, '2026-03-26 08:38:00'),
('plan-003', 2, 'LogParser service', 'completed', 1, '2026-03-26 08:39:00'),
('plan-003', 3, 'AutoSubmit scheduler', 'completed', 1, '2026-03-26 08:40:00'),
('plan-003', 4, 'Agent status API', 'completed', 1, '2026-03-26 08:41:00'),
('plan-003', 5, 'Frontend status component', 'completed', 1, '2026-03-26 08:41:00')
ON DUPLICATE KEY UPDATE status='completed', verified=1;

-- Plan-004 rounds
INSERT INTO pipeline_rounds (plan_id, round_id, round_name, status, verified, completed_at) VALUES
('plan-004', 1, 'UserInfo fields', 'completed', 1, '2026-03-26 08:43:00'),
('plan-004', 2, 'Category DB+Mapper', 'completed', 1, '2026-03-26 08:44:00'),
('plan-004', 3, 'Tag DB+Mapper', 'completed', 1, '2026-03-26 08:45:00'),
('plan-004', 4, 'Category/Tag Controller', 'completed', 1, '2026-03-26 08:46:00'),
('plan-004', 5, 'Frontend category/tag', 'completed', 1, '2026-03-26 08:47:00')
ON DUPLICATE KEY UPDATE status='completed', verified=1;

-- Plan-005 rounds
INSERT INTO pipeline_rounds (plan_id, round_id, round_name, status, verified, completed_at) VALUES
('plan-005', 1, 'Frontend component doc', 'completed', 1, '2026-03-26 08:48:00'),
('plan-005', 2, 'Router doc', 'completed', 1, '2026-03-26 08:48:30'),
('plan-005', 3, 'Database doc', 'completed', 1, '2026-03-26 08:49:00'),
('plan-005', 4, 'API doc', 'completed', 1, '2026-03-26 08:49:30'),
('plan-005', 5, 'Final acceptance', 'completed', 1, '2026-03-26 08:50:00')
ON DUPLICATE KEY UPDATE status='completed', verified=1;

SELECT 'Done' AS result;
