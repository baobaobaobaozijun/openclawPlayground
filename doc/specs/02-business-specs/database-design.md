<!-- Last Modified: 2026-03-12 -->

# 包子铺博客系统 - 数据库设计文档

**文档类型:** 技术规范  
**版本:** v1.0  
**创建日期:** 2026-03-12  
**负责人:** 酱肉 (后端)  
**审核:** 灌汤 (PM)

---

## 📋 数据库概览

**数据库名:** `blog_system`  
**字符集:** `utf8mb4`  
**排序规则:** `utf8mb4_unicode_ci`  
**存储引擎:** InnoDB

---

## 🗄️ 表结构详细设计

### 1. users - 用户表

**用途:** 存储系统用户信息

```sql
CREATE TABLE `users` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户 ID',
  `username` VARCHAR(50) NOT NULL COMMENT '用户名',
  `password` VARCHAR(255) NOT NULL COMMENT '密码 (BCrypt 哈希)',
  `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
  `phone` VARCHAR(11) DEFAULT NULL COMMENT '手机号',
  `avatar` VARCHAR(255) DEFAULT NULL COMMENT '头像 URL',
  `role` VARCHAR(20) NOT NULL DEFAULT 'USER' COMMENT '角色：USER/ADMIN',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0=禁用，1=正常',
  `last_login_at` DATETIME DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` VARCHAR(50) DEFAULT NULL COMMENT '最后登录 IP',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_email` (`email`),
  UNIQUE KEY `uk_phone` (`phone`),
  KEY `idx_status` (`status`),
  KEY `idx_role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';
```

**字段说明:**

| 字段 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| id | BIGINT UNSIGNED | ✅ | AUTO | 主键 |
| username | VARCHAR(50) | ✅ | - | 用户名，唯一 |
| password | VARCHAR(255) | ✅ | - | BCrypt 哈希 |
| email | VARCHAR(100) | ❌ | NULL | 邮箱，唯一 |
| phone | VARCHAR(11) | ❌ | NULL | 手机号，唯一 |
| avatar | VARCHAR(255) | ❌ | NULL | 头像 URL |
| role | VARCHAR(20) | ✅ | USER | USER/ADMIN |
| status | TINYINT | ✅ | 1 | 0=禁用，1=正常 |
| last_login_at | DATETIME | ❌ | NULL | 最后登录时间 |
| last_login_ip | VARCHAR(50) | ❌ | NULL | 最后登录 IP |
| created_at | TIMESTAMP | ✅ | CURRENT | 创建时间 |
| updated_at | TIMESTAMP | ✅ | CURRENT | 更新时间 |

**索引设计:**
- `PRIMARY KEY`: id
- `UNIQUE KEY uk_username`: username (唯一索引)
- `UNIQUE KEY uk_email`: email (唯一索引)
- `UNIQUE KEY uk_phone`: phone (唯一索引)
- `KEY idx_status`: status (普通索引，用于状态查询)
- `KEY idx_role`: role (普通索引，用于角色查询)

**示例数据:**
```sql
INSERT INTO users (username, password, email, phone, role, status) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iKTm8I/vsZC5O1P2Q3R4S5T6U7V8', 'admin@blog.com', '13800138000', 'ADMIN', 1),
('user1', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iKTm8I/vsZC5O1P2Q3R4S5T6U7V8', 'user1@blog.com', '13800138001', 'USER', 1);
```

---

### 2. articles - 文章表

**用途:** 存储博客文章

```sql
CREATE TABLE `articles` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '文章 ID',
  `title` VARCHAR(200) NOT NULL COMMENT '标题',
  `slug` VARCHAR(200) DEFAULT NULL COMMENT 'URL 友好别名',
  `content` LONGTEXT NOT NULL COMMENT '内容 (Markdown)',
  `content_html` LONGTEXT DEFAULT NULL COMMENT '内容 (HTML 渲染后)',
  `summary` VARCHAR(500) DEFAULT NULL COMMENT '摘要',
  `cover_image` VARCHAR(255) DEFAULT NULL COMMENT '封面图 URL',
  `author_id` BIGINT UNSIGNED NOT NULL COMMENT '作者 ID',
  `status` VARCHAR(20) NOT NULL DEFAULT 'DRAFT' COMMENT '状态：DRAFT/PUBLISHED/ARCHIVED',
  `access_level` TINYINT NOT NULL DEFAULT 0 COMMENT '访问级别：0=公开，1=登录，2=VIP',
  `view_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '浏览量',
  `like_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '点赞数',
  `comment_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '评论数',
  `is_top` TINYINT NOT NULL DEFAULT 0 COMMENT '是否置顶：0=否，1=是',
  `is_featured` TINYINT NOT NULL DEFAULT 0 COMMENT '是否推荐：0=否，1=是',
  `published_at` DATETIME DEFAULT NULL COMMENT '发布时间',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` TIMESTAMP NULL DEFAULT NULL COMMENT '删除时间 (软删除)',
  
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_slug` (`slug`),
  KEY `idx_author_id` (`author_id`),
  KEY `idx_status` (`status`),
  KEY `idx_access_level` (`access_level`),
  KEY `idx_published_at` (`published_at`),
  KEY `idx_view_count` (`view_count`),
  KEY `idx_is_top` (`is_top`),
  KEY `idx_deleted_at` (`deleted_at`),
  CONSTRAINT `fk_articles_author` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章表';
```

**字段说明:**

| 字段 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| id | BIGINT UNSIGNED | ✅ | AUTO | 主键 |
| title | VARCHAR(200) | ✅ | - | 标题 |
| slug | VARCHAR(200) | ❌ | NULL | URL 友好别名 |
| content | LONGTEXT | ✅ | - | Markdown 原文 |
| content_html | LONGTEXT | ❌ | NULL | HTML 渲染后 |
| summary | VARCHAR(500) | ❌ | NULL | 摘要 |
| cover_image | VARCHAR(255) | ❌ | NULL | 封面图 |
| author_id | BIGINT UNSIGNED | ✅ | - | 作者 ID (外键) |
| status | VARCHAR(20) | ✅ | DRAFT | DRAFT/PUBLISHED/ARCHIVED |
| access_level | TINYINT | ✅ | 0 | 0=公开，1=登录，2=VIP |
| view_count | INT UNSIGNED | ✅ | 0 | 浏览量 |
| like_count | INT UNSIGNED | ✅ | 0 | 点赞数 |
| comment_count | INT UNSIGNED | ✅ | 0 | 评论数 |
| is_top | TINYINT | ✅ | 0 | 是否置顶 |
| is_featured | TINYINT | ✅ | 0 | 是否推荐 |
| published_at | DATETIME | ❌ | NULL | 发布时间 |
| created_at | TIMESTAMP | ✅ | CURRENT | 创建时间 |
| updated_at | TIMESTAMP | ✅ | CURRENT | 更新时间 |
| deleted_at | TIMESTAMP | ❌ | NULL | 软删除标记 |

**索引设计:**
- `PRIMARY KEY`: id
- `UNIQUE KEY uk_slug`: slug (唯一索引，用于 SEO 友好 URL)
- `KEY idx_author_id`: author_id (外键索引)
- `KEY idx_status`: status (状态查询)
- `KEY idx_access_level`: access_level (权限过滤)
- `KEY idx_published_at`: published_at (时间排序)
- `KEY idx_view_count`: view_count (热门文章)
- `KEY idx_is_top`: is_top (置顶文章)
- `KEY idx_deleted_at`: deleted_at (软删除过滤)

**外键约束:**
- `fk_articles_author`: author_id → users(id), ON DELETE CASCADE

**示例数据:**
```sql
INSERT INTO articles (title, slug, content, summary, author_id, status, access_level, view_count, is_top, is_featured, published_at) VALUES
('Hello World', 'hello-world', '# Hello World\n\n这是我的第一篇文章...', '这是我的第一篇文章', 1, 'PUBLISHED', 0, 100, 1, 1, NOW()),
('Spring Boot 入门', 'spring-boot-intro', '# Spring Boot 入门\n\nSpring Boot 是一个...', 'Spring Boot 入门教程', 1, 'PUBLISHED', 0, 50, 0, 0, NOW());
```

---

### 3. categories - 分类表

**用途:** 文章分类 (支持多级)

```sql
CREATE TABLE `categories` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '分类 ID',
  `name` VARCHAR(50) NOT NULL COMMENT '分类名',
  `slug` VARCHAR(50) NOT NULL COMMENT 'URL 友好别名',
  `description` VARCHAR(200) DEFAULT NULL COMMENT '描述',
  `parent_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '父分类 ID',
  `sort_order` INT NOT NULL DEFAULT 0 COMMENT '排序顺序',
  `icon` VARCHAR(50) DEFAULT NULL COMMENT '图标',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_slug` (`slug`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_sort_order` (`sort_order`),
  CONSTRAINT `fk_categories_parent` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分类表';
```

**字段说明:**

| 字段 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| id | BIGINT UNSIGNED | ✅ | AUTO | 主键 |
| name | VARCHAR(50) | ✅ | - | 分类名 |
| slug | VARCHAR(50) | ✅ | - | URL 别名 |
| description | VARCHAR(200) | ❌ | NULL | 描述 |
| parent_id | BIGINT UNSIGNED | ❌ | NULL | 父分类 ID (自引用) |
| sort_order | INT | ✅ | 0 | 排序顺序 |
| icon | VARCHAR(50) | ❌ | NULL | 图标 (Element Plus 图标名) |
| created_at | TIMESTAMP | ✅ | CURRENT | 创建时间 |
| updated_at | TIMESTAMP | ✅ | CURRENT | 更新时间 |

**索引设计:**
- `PRIMARY KEY`: id
- `UNIQUE KEY uk_slug`: slug (唯一索引)
- `KEY idx_parent_id`: parent_id (自引用外键)
- `KEY idx_sort_order`: sort_order (排序查询)

**外键约束:**
- `fk_categories_parent`: parent_id → categories(id), ON DELETE SET NULL

**示例数据:**
```sql
INSERT INTO categories (name, slug, description, parent_id, sort_order, icon) VALUES
('技术文章', 'tech', '技术相关', NULL, 1, 'Folder'),
('生活随笔', 'life', '生活感悟', NULL, 2, 'Document'),
('Java', 'java', 'Java 技术', 1, 1, 'Code'),
('前端开发', 'frontend', '前端技术', 1, 2, 'Monitor');
```

---

### 4. tags - 标签表

**用途:** 文章标签 (扁平结构)

```sql
CREATE TABLE `tags` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '标签 ID',
  `name` VARCHAR(50) NOT NULL COMMENT '标签名',
  `slug` VARCHAR(50) NOT NULL COMMENT 'URL 友好别名',
  `color` VARCHAR(20) DEFAULT NULL COMMENT '标签颜色 (十六进制)',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_slug` (`slug`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签表';
```

**字段说明:**

| 字段 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| id | BIGINT UNSIGNED | ✅ | AUTO | 主键 |
| name | VARCHAR(50) | ✅ | - | 标签名 |
| slug | VARCHAR(50) | ✅ | - | URL 别名 |
| color | VARCHAR(20) | ❌ | NULL | 标签颜色 |
| created_at | TIMESTAMP | ✅ | CURRENT | 创建时间 |

**示例数据:**
```sql
INSERT INTO tags (name, slug, color) VALUES
('Java', 'java', '#409EFF'),
('Spring Boot', 'spring-boot', '#67C23A'),
('Vue', 'vue', '#35495E'),
('TypeScript', 'typescript', '#3178C6'),
('MySQL', 'mysql', '#00758F');
```

---

### 5. article_tags - 文章 - 标签关联表

**用途:** 多对多关联

```sql
CREATE TABLE `article_tags` (
  `article_id` BIGINT UNSIGNED NOT NULL COMMENT '文章 ID',
  `tag_id` BIGINT UNSIGNED NOT NULL COMMENT '标签 ID',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  
  PRIMARY KEY (`article_id`, `tag_id`),
  KEY `idx_tag_id` (`tag_id`),
  CONSTRAINT `fk_article_tags_article` FOREIGN KEY (`article_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_article_tags_tag` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章 - 标签关联表';
```

**示例数据:**
```sql
INSERT INTO article_tags (article_id, tag_id) VALUES
(1, 1),  -- Hello World -> Java
(1, 2),  -- Hello World -> Spring Boot
(2, 1),  -- Spring Boot 入门 -> Java
(2, 2);  -- Spring Boot 入门 -> Spring Boot
```

---

### 6. article_categories - 文章 - 分类关联表

**用途:** 多对多关联 (一篇文章可属于多个分类)

```sql
CREATE TABLE `article_categories` (
  `article_id` BIGINT UNSIGNED NOT NULL COMMENT '文章 ID',
  `category_id` BIGINT UNSIGNED NOT NULL COMMENT '分类 ID',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  
  PRIMARY KEY (`article_id`, `category_id`),
  KEY `idx_category_id` (`category_id`),
  CONSTRAINT `fk_article_categories_article` FOREIGN KEY (`article_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_article_categories_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章 - 分类关联表';
```

---

### 7. comments - 评论表

**用途:** 文章评论 (支持嵌套回复)

```sql
CREATE TABLE `comments` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '评论 ID',
  `article_id` BIGINT UNSIGNED NOT NULL COMMENT '文章 ID',
  `user_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '用户 ID',
  `parent_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '父评论 ID',
  `content` TEXT NOT NULL COMMENT '评论内容',
  `status` VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT '状态：PENDING/APPROVED/REJECTED',
  `like_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '点赞数',
  `ip_address` VARCHAR(50) DEFAULT NULL COMMENT '评论 IP',
  `user_agent` VARCHAR(255) DEFAULT NULL COMMENT 'User Agent',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` TIMESTAMP NULL DEFAULT NULL COMMENT '删除时间 (软删除)',
  
  PRIMARY KEY (`id`),
  KEY `idx_article_id` (`article_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_deleted_at` (`deleted_at`),
  CONSTRAINT `fk_comments_article` FOREIGN KEY (`article_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_comments_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_comments_parent` FOREIGN KEY (`parent_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='评论表';
```

**字段说明:**

| 字段 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| id | BIGINT UNSIGNED | ✅ | AUTO | 主键 |
| article_id | BIGINT UNSIGNED | ✅ | - | 文章 ID (外键) |
| user_id | BIGINT UNSIGNED | ❌ | NULL | 用户 ID (外键，可为 NULL 表示匿名) |
| parent_id | BIGINT UNSIGNED | ❌ | NULL | 父评论 ID (自引用，用于回复) |
| content | TEXT | ✅ | - | 评论内容 |
| status | VARCHAR(20) | ✅ | PENDING | PENDING/APPROVED/REJECTED |
| like_count | INT UNSIGNED | ✅ | 0 | 点赞数 |
| ip_address | VARCHAR(50) | ❌ | NULL | 评论 IP |
| user_agent | VARCHAR(255) | ❌ | NULL | User Agent |
| created_at | TIMESTAMP | ✅ | CURRENT | 创建时间 |
| updated_at | TIMESTAMP | ✅ | CURRENT | 更新时间 |
| deleted_at | TIMESTAMP | ❌ | NULL | 软删除标记 |

**索引设计:**
- `PRIMARY KEY`: id
- `KEY idx_article_id`: article_id (文章评论查询)
- `KEY idx_user_id`: user_id (用户评论查询)
- `KEY idx_parent_id`: parent_id (回复查询)
- `KEY idx_status`: status (状态过滤)
- `KEY idx_created_at`: created_at (时间排序)
- `KEY idx_deleted_at`: deleted_at (软删除过滤)

**外键约束:**
- `fk_comments_article`: article_id → articles(id), ON DELETE CASCADE
- `fk_comments_user`: user_id → users(id), ON DELETE SET NULL
- `fk_comments_parent`: parent_id → comments(id), ON DELETE CASCADE

**示例数据:**
```sql
INSERT INTO comments (article_id, user_id, parent_id, content, status, like_count) VALUES
(1, 2, NULL, '写得很好！', 'APPROVED', 5),
(1, 1, 1, '谢谢支持！', 'APPROVED', 2),
(2, 2, NULL, 'Spring Boot 确实好用', 'APPROVED', 3);
```

---

## 📊 ER 图

```
┌─────────────┐
│   users     │
│-------------│
│ id (PK)     │
│ username    │
│ password    │
│ email       │
│ phone       │
│ role        │
│ status      │
└──────┬──────┘
       │
       │ 1:N
       │
       ▼
┌─────────────┐     ┌──────────────────┐
│  articles   │────▶│ article_tags     │
│-------------│     │------------------│
│ id (PK)     │     │ article_id (FK)  │
│ title       │     │ tag_id (FK)      │
│ content     │     └──────────────────┘
│ author_id   │     
│ status      │     ┌──────────────────┐
│ access_level│     │ article_categories│
└──────┬──────┘     │------------------│
       │            │ article_id (FK)  │
       │ 1:N        │ category_id (FK) │
       │            └──────────────────┘
       ▼
┌─────────────┐     ┌─────────────┐
│  categories │     │    tags     │
│-------------│     │-------------│
│ id (PK)     │     │ id (PK)     │
│ name        │     │ name        │
│ parent_id   │     │ slug        │
└─────────────┘     │ color       │
                    └─────────────┘
                    
┌─────────────┐
│  comments   │
│-------------│
│ id (PK)     │
│ article_id  │
│ user_id     │
│ parent_id   │
│ content     │
│ status      │
└─────────────┘
```

---

## 🔐 权限设计

### 数据访问级别

| 表 | 游客 | 登录用户 | 管理员 |
|----|------|---------|--------|
| users | - | 查看自己 | 全部 CRUD |
| articles | 查看公开 | 查看公开 + 自己的 | 全部 CRUD |
| categories | 查看 | 查看 | 全部 CRUD |
| tags | 查看 | 查看 | 全部 CRUD |
| comments | 查看公开 | 查看 + 创建 | 全部 CRUD |

### 字段级权限

| 字段 | 表 | 可见性 |
|------|----|--------|
| password | users | 永不返回 |
| last_login_ip | users | 仅管理员 |
| deleted_at | 所有表 | 仅管理员可见 |

---

## 📈 性能优化

### 1. 索引策略

**已创建索引:**
- 所有主键 (PRIMARY KEY)
- 所有外键 (FOREIGN KEY)
- 唯一字段 (UNIQUE KEY)
- 常用查询字段 (KEY)

**复合索引 (按需添加):**
```sql
-- 热门文章查询 (status + view_count + published_at)
CREATE INDEX idx_hot_articles ON articles (status, view_count, published_at);

-- 用户文章查询 (author_id + status + created_at)
CREATE INDEX idx_user_articles ON articles (author_id, status, created_at);

-- 评论查询 (article_id + status + created_at)
CREATE INDEX idx_article_comments ON comments (article_id, status, created_at);
```

### 2. 软删除

使用 `deleted_at` 字段实现软删除：

```sql
-- 软删除文章
UPDATE articles SET deleted_at = NOW() WHERE id = 1;

-- 查询时过滤
SELECT * FROM articles WHERE deleted_at IS NULL;
```

### 3. 缓存策略

**需要缓存的数据:**
- 热门文章列表 (10 分钟)
- 分类列表 (1 小时)
- 标签列表 (1 小时)
- 文章详情 (1 小时)

**不需要缓存的数据:**
- 用户会话信息
- 评论列表 (实时性要求高)

---

## 📝 数据迁移

### 初始化脚本位置

`F:\openclaw\code\deploy\mysql\init.sql`

### 执行顺序

```bash
# 1. 创建数据库
mysql -u root -p < 01-create-database.sql

# 2. 创建表结构
mysql -u root -p blog_system < 02-create-tables.sql

# 3. 插入初始数据
mysql -u root -p blog_system < 03-insert-initial-data.sql
```

---

## 📞 维护说明

### 备份策略

```bash
# 每日备份 (cron)
0 2 * * * mysqldump -u root -p blog_system > /opt/blog-system/backup/blog-$(date +\%Y\%m\%d).sql
```

### 清理策略

```sql
-- 清理 30 天前的软删除数据
DELETE FROM articles WHERE deleted_at < DATE_SUB(NOW(), INTERVAL 30 DAY);
DELETE FROM comments WHERE deleted_at < DATE_SUB(NOW(), INTERVAL 30 DAY);
```

---

**维护者:** 酱肉 (后端工程师)  
**更新日期:** 2026-03-12  
**版本:** v1.0
