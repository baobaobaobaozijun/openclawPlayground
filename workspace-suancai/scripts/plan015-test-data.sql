-- Plan-015 R3 联调测试数据脚本

-- 1. 创建测试账号
INSERT INTO users (username, password_hash, email, role, access_level, created_at) VALUES
('test_admin', '$2a$10$vQDeMY.RP/Cs4cJZrNHqDuQHOnWSuLi6/hVWg0MUwKbIY9yB8SSy.', 'admin@test.com', 'ADMIN', 2, NOW()),
('test_vip', '$2a$10$HbPzUo8a7a7ZsL0YjA2O1OJq9.Xo3z6yqQr9.Xo3z6yqQr9.Xo3z6', 'vip@test.com', 'USER', 1, NOW()),
('test_user', '$2a$10$kzLFeJCOG7bND9e.OyB8CeHFW.b7G7z7kzLFeJCOG7bND9e.OyB8C', 'user@test.com', 'USER', 0, NOW());

-- 2. 创建测试文章
-- 公开文章 (access_level = 0)
INSERT INTO articles (title, content, author_id, access_level, status, created_at) VALUES
('公开文章 1', '这是第一篇公开文章，所有人都可以访问', 1, 0, 'PUBLISHED', NOW()),
('公开文章 2', '这是第二篇公开文章，所有人都可以访问', 1, 0, 'PUBLISHED', NOW()),
('公开文章 3', '这是第三篇公开文章，所有人都可以访问', 1, 0, 'PUBLISHED', NOW());

-- 登录文章 (access_level = 1)
INSERT INTO articles (title, content, author_id, access_level, status, created_at) VALUES
('登录后可见文章 1', '这篇文章需要登录后才能访问', 1, 1, 'PUBLISHED', NOW()),
('登录后可见文章 2', '这篇文章需要登录后才能访问', 1, 1, 'PUBLISHED', NOW());

-- VIP文章 (access_level = 2)
INSERT INTO articles (title, content, author_id, access_level, status, created_at) VALUES
('VIP专享文章 1', '这篇文章只有VIP用户才能访问', 1, 2, 'PUBLISHED', NOW()),
('VIP专享文章 2', '这篇文章只有VIP用户才能访问', 1, 2, 'PUBLISHED', NOW());

-- 3. 创建测试评论（包含回复）
INSERT INTO comments (article_id, user_id, content, parent_id, status, created_at) VALUES
-- 顶级评论
(1, 3, '这是第一条评论', NULL, 1, NOW()),
(1, 2, '这是第二条评论', NULL, 1, NOW()),
(2, 1, '这篇文章写得不错', NULL, 1, NOW()),
-- 评论的回复
(1, 2, '我同意楼上观点', 1, 1, NOW()),
(1, 1, '感谢大家的讨论', 2, 1, NOW());