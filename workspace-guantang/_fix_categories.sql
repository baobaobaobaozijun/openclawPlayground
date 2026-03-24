INSERT IGNORE INTO categories (name, description, parent_id, level, sort_order, status) VALUES
('技术', '技术相关文章', 0, 1, 1, 1),
('生活', '生活随笔记录', 0, 1, 2, 1),
('随笔', '个人随想感悟', 0, 1, 3, 1),
('教程', '教学类文章', 0, 1, 4, 1),
('公告', '系统公告通知', 0, 1, 5, 1);
INSERT IGNORE INTO articles (title, slug, summary, content, author_id, category_id, view_count, like_count, comment_count, status, is_top, published_at) VALUES
('Docker 容器化部署最佳实践', 'docker-best-practices', '如何优雅地使用 Docker 部署应用', '# Docker\n\nMulti-stage build...', 1, 4, 89, 18, 3, 2, 0, NOW()),
('已归档：旧版部署文档', 'archived-deploy-doc', '旧版部署文档已归档', '此文档已归档', 1, 5, 12, 0, 0, 3, 0, NOW());
