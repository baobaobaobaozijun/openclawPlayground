# 博客系统数据库设计文档 v1.0

**文档状态:** 已批准  
**创建日期:** 2026-03-10  
**最后更新:** 2026-03-10  
**负责人:** 酱肉 (后端)  
**版本:** 1.0

---

## 📋 目录

1. [数据库概述](#数据库概述)
2. [ER 图](#er 图)
3. [表结构设计](#表结构设计)
4. [索引设计](#索引设计)
5. [视图设计](#视图设计)
6. [数据字典](#数据字典)
7. [初始化数据](#初始化数据)
8. [SQL 脚本](#sql 脚本)

---

## 数据库概述

### 数据库信息

| 项目 | 值 |
|------|-----|
| 数据库名 | `blog_system` |
| 数据库类型 | MySQL |
| 版本要求 | 8.0+ |
| 字符集 | `utf8mb4` |
| 排序规则 | `utf8mb4_unicode_ci` |
| 存储引擎 | InnoDB |

---

### 连接配置

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/blog_system?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai
    username: blog_admin
    password: ${DB_PASSWORD}
    driver-class-name: com.mysql.cj.jdbc.Driver
  hikaricp:
    maximum-pool-size: 10
    minimum-idle: 5
    connection-timeout: 30000
    idle-timeout: 600000
    max-lifetime: 1800000
```

---

## ER 图

```
┌─────────────────┐       ┌─────────────────┐
│     users       │       │   categories    │
├─────────────────┤       ├─────────────────┤
│ id (PK)         │       │ id (PK)         │
│ phone           │       │ name            │
│ nickname        │       │ slug            │
│ avatar          │       │ description     │
│ role            │       │ parent_id (FK)  │
│ access_level    │       │ sort_order      │
│ created_at      │       │ created_at      │
│ updated_at      │       └────────┬────────┘
│ last_login_at   │                │
└────────┬────────┘                │
         │                         │
         │ 1                       │ 1
         │                         │
         │ N                       │ N
         ▼                         ▼
┌─────────────────┐       ┌─────────────────┐
│    articles     │       │   article_tags  │
├─────────────────┤       ├─────────────────┤
│ id (PK)         │       │ article_id (FK) │
│ title           │       │ tag_id (FK)     │
│ slug            │       └─────────────────┘
│ content_md      │                ▲
│ content_html    │                │
│ summary         │                │ N
│ cover_image     │                │
│ category_id(FK) │       ┌────────┴────────┐
│ author_id (FK)  │       │     tags        │
│ access_level    │       ├─────────────────┤
│ view_count      │       │ id (PK)         │
│ like_count      │       │ name            │
│ status          │       │ slug            │
│ published_at    │       │ created_at      │
│ created_at      │       └─────────────────┘
│ updated_at      │
└────────┬────────┘
         │
         │ 1
         │
         │ N
         ▼
┌─────────────────┐
│ log_submissions │
├─────────────────┤
│ id (PK)         │
│ agent_name      │
│ log_date        │
│ article_id (FK) │
│ status          │
│ error_message   │
│ submitted_at    │
└─────────────────┘
```

---

## 表结构设计

### 1. users - 用户表

| 字段名 | 数据类型 | 长度 | 允许 NULL | 默认值 | 说明 |
|--------|----------|------|-----------|--------|------|
| id | BIGINT | - | ❌ | AUTO_INCREMENT | 主键 |
| phone | VARCHAR | 11 | ❌ | - | 手机号 (唯一) |
| nickname | VARCHAR | 50 | ✅ | '匿名用户' | 昵称 |
| avatar | VARCHAR | 255 | ✅ | '' | 头像 URL |
| role | VARCHAR | 20 | ✅ | 'user' | 角色：user/author/admin |
| access_level | TINYINT | 1 | ✅ | 0 | 访问级别：0-普通 1-VIP 2-管理员 |
| created_at | DATETIME | - | ✅ | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | - | ✅ | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |
| last_login_at | DATETIME | - | ✅ | NULL | 最后登录时间 |

**索引:**
- PRIMARY KEY (id)
- UNIQUE KEY uk_phone (phone)
- INDEX idx_role (role)

**建表语句:**
```sql
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户 ID',
    phone VARCHAR(11) NOT NULL COMMENT '手机号',
    nickname VARCHAR(50) DEFAULT '匿名用户' COMMENT '昵称',
    avatar VARCHAR(255) DEFAULT '' COMMENT '头像 URL',
    role VARCHAR(20) DEFAULT 'user' COMMENT '角色：user/author/admin',
    access_level TINYINT DEFAULT 0 COMMENT '访问级别：0-普通 1-VIP 2-管理员',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    last_login_at DATETIME DEFAULT NULL COMMENT '最后登录时间',
    UNIQUE KEY uk_phone (phone) COMMENT '手机号唯一索引',
    INDEX idx_role (role) COMMENT '角色索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';
```

---

### 2. articles - 文章表

| 字段名 | 数据类型 | 长度 | 允许 NULL | 默认值 | 说明 |
|--------|----------|------|-----------|--------|------|
| id | BIGINT | - | ❌ | AUTO_INCREMENT | 主键 |
| title | VARCHAR | 200 | ❌ | - | 标题 |
| slug | VARCHAR | 200 | ✅ | NULL | URL 别名 (唯一) |
| content_md | TEXT | - | ✅ | NULL | Markdown 原文 |
| content_html | TEXT | - | ✅ | NULL | 渲染后的 HTML |
| summary | VARCHAR | 500 | ✅ | NULL | 摘要 |
| cover_image | VARCHAR | 255 | ✅ | NULL | 封面图 URL |
| category_id | BIGINT | - | ✅ | NULL | 分类 ID (外键) |
| author_id | BIGINT | - | ❌ | - | 作者 ID (外键) |
| access_level | TINYINT | 1 | ✅ | 0 | 访问级别：0-公开 1-登录 2-VIP |
| view_count | INT | - | ✅ | 0 | 浏览量 |
| like_count | INT | - | ✅ | 0 | 点赞数 |
| status | VARCHAR | 20 | ✅ | 'draft' | 状态：draft/published/archived |
| published_at | DATETIME | - | ✅ | NULL | 发布时间 |
| created_at | DATETIME | - | ✅ | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | - | ✅ | CURRENT_TIMESTAMP ON UPDATE | 更新时间 |

**索引:**
- PRIMARY KEY (id)
- UNIQUE KEY uk_slug (slug)
- INDEX idx_category (category_id)
- INDEX idx_author (author_id)
- INDEX idx_access_level (access_level)
- INDEX idx_status (status)
- INDEX idx_published_at (published_at)

**外键约束:**
- FOREIGN KEY (category_id) REFERENCES categories(id)
- FOREIGN KEY (author_id) REFERENCES users(id)

**建表语句:**
```sql
CREATE TABLE articles (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '文章 ID',
    title VARCHAR(200) NOT NULL COMMENT '标题',
    slug VARCHAR(200) DEFAULT NULL COMMENT 'URL 别名',
    content_md TEXT DEFAULT NULL COMMENT 'Markdown 原文',
    content_html TEXT DEFAULT NULL COMMENT '渲染后的 HTML',
    summary VARCHAR(500) DEFAULT NULL COMMENT '摘要',
    cover_image VARCHAR(255) DEFAULT NULL COMMENT '封面图 URL',
    category_id BIGINT DEFAULT NULL COMMENT '分类 ID',
    author_id BIGINT NOT NULL COMMENT '作者 ID',
    access_level TINYINT DEFAULT 0 COMMENT '访问级别：0-公开 1-登录 2-VIP',
    view_count INT DEFAULT 0 COMMENT '浏览量',
    like_count INT DEFAULT 0 COMMENT '点赞数',
    status VARCHAR(20) DEFAULT 'draft' COMMENT '状态：draft/published/archived',
    published_at DATETIME DEFAULT NULL COMMENT '发布时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY uk_slug (slug) COMMENT 'slug 唯一索引',
    INDEX idx_category (category_id) COMMENT '分类索引',
    INDEX idx_author (author_id) COMMENT '作者索引',
    INDEX idx_access_level (access_level) COMMENT '访问级别索引',
    INDEX idx_status (status) COMMENT '状态索引',
    INDEX idx_published_at (published_at) COMMENT '发布时间索引',
    CONSTRAINT fk_articles_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    CONSTRAINT fk_articles_author FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章表';
```

---

### 3. categories - 分类表

| 字段名 | 数据类型 | 长度 | 允许 NULL | 默认值 | 说明 |
|--------|----------|------|-----------|--------|------|
| id | BIGINT | - | ❌ | AUTO_INCREMENT | 主键 |
| name | VARCHAR | 50 | ❌ | - | 分类名 |
| slug | VARCHAR | 50 | ✅ | NULL | URL 别名 (唯一) |
| description | TEXT | - | ✅ | NULL | 描述 |
| parent_id | BIGINT | - | ✅ | NULL | 父分类 ID (自引用) |
| sort_order | INT | - | ✅ | 0 | 排序 |
| created_at | DATETIME | - | ✅ | CURRENT_TIMESTAMP | 创建时间 |

**索引:**
- PRIMARY KEY (id)
- UNIQUE KEY uk_slug (slug)
- INDEX idx_parent (parent_id)

**外键约束:**
- FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL

**建表语句:**
```sql
CREATE TABLE categories (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '分类 ID',
    name VARCHAR(50) NOT NULL COMMENT '分类名',
    slug VARCHAR(50) DEFAULT NULL COMMENT 'URL 别名',
    description TEXT DEFAULT NULL COMMENT '描述',
    parent_id BIGINT DEFAULT NULL COMMENT '父分类 ID',
    sort_order INT DEFAULT 0 COMMENT '排序',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_slug (slug) COMMENT 'slug 唯一索引',
    INDEX idx_parent (parent_id) COMMENT '父分类索引',
    CONSTRAINT fk_categories_parent FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分类表';
```

---

### 4. tags - 标签表

| 字段名 | 数据类型 | 长度 | 允许 NULL | 默认值 | 说明 |
|--------|----------|------|-----------|--------|------|
| id | BIGINT | - | ❌ | AUTO_INCREMENT | 主键 |
| name | VARCHAR | 50 | ❌ | - | 标签名 |
| slug | VARCHAR | 50 | ✅ | NULL | URL 别名 (唯一) |
| created_at | DATETIME | - | ✅ | CURRENT_TIMESTAMP | 创建时间 |

**索引:**
- PRIMARY KEY (id)
- UNIQUE KEY uk_slug (slug)

**建表语句:**
```sql
CREATE TABLE tags (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '标签 ID',
    name VARCHAR(50) NOT NULL COMMENT '标签名',
    slug VARCHAR(50) DEFAULT NULL COMMENT 'URL 别名',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_slug (slug) COMMENT 'slug 唯一索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签表';
```

---

### 5. article_tags - 文章标签关联表

| 字段名 | 数据类型 | 长度 | 允许 NULL | 默认值 | 说明 |
|--------|----------|------|-----------|--------|------|
| article_id | BIGINT | - | ❌ | - | 文章 ID (外键) |
| tag_id | BIGINT | - | ❌ | - | 标签 ID (外键) |

**索引:**
- PRIMARY KEY (article_id, tag_id)
- INDEX idx_tag (tag_id)

**外键约束:**
- FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE
- FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE

**建表语句:**
```sql
CREATE TABLE article_tags (
    article_id BIGINT NOT NULL COMMENT '文章 ID',
    tag_id BIGINT NOT NULL COMMENT '标签 ID',
    PRIMARY KEY (article_id, tag_id) COMMENT '联合主键',
    INDEX idx_tag (tag_id) COMMENT '标签索引',
    CONSTRAINT fk_article_tags_article FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    CONSTRAINT fk_article_tags_tag FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章标签关联表';
```

---

### 6. log_submissions - 日志提交记录表

| 字段名 | 数据类型 | 长度 | 允许 NULL | 默认值 | 说明 |
|--------|----------|------|-----------|--------|------|
| id | BIGINT | - | ❌ | AUTO_INCREMENT | 主键 |
| agent_name | VARCHAR | 50 | ❌ | - | Agent 名称 |
| log_date | VARCHAR | 8 | ❌ | - | 日志日期 (YYYYMMDD) |
| article_id | BIGINT | - | ❌ | - | 生成的文章 ID |
| status | VARCHAR | 20 | ✅ | 'success' | 状态：success/failed |
| error_message | TEXT | - | ✅ | NULL | 错误信息 |
| submitted_at | DATETIME | - | ✅ | CURRENT_TIMESTAMP | 提交时间 |

**索引:**
- PRIMARY KEY (id)
- UNIQUE KEY uk_agent_date (agent_name, log_date)
- INDEX idx_article (article_id)

**外键约束:**
- FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE

**建表语句:**
```sql
CREATE TABLE log_submissions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '提交记录 ID',
    agent_name VARCHAR(50) NOT NULL COMMENT 'Agent 名称',
    log_date VARCHAR(8) NOT NULL COMMENT '日志日期 YYYYMMDD',
    article_id BIGINT NOT NULL COMMENT '文章 ID',
    status VARCHAR(20) DEFAULT 'success' COMMENT '状态：success/failed',
    error_message TEXT DEFAULT NULL COMMENT '错误信息',
    submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
    UNIQUE KEY uk_agent_date (agent_name, log_date) COMMENT 'Agent+ 日期唯一索引',
    INDEX idx_article (article_id) COMMENT '文章索引',
    CONSTRAINT fk_log_submissions_article FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='日志提交记录表';
```

---

## 索引设计

### 索引优化原则

1. **主键索引** - 所有表必须有主键
2. **唯一索引** - phone、slug 等唯一字段
3. **外键索引** - 所有外键字段必须建立索引
4. **查询索引** - 高频查询字段 (access_level、status、published_at)
5. **避免过度索引** - 单表索引不超过 5 个

### 索引清单

| 表名 | 索引名 | 字段 | 类型 | 说明 |
|------|--------|------|------|------|
| users | PRIMARY | id | PRIMARY | 主键 |
| users | uk_phone | phone | UNIQUE | 手机号唯一 |
| users | idx_role | role | NORMAL | 角色查询 |
| articles | PRIMARY | id | PRIMARY | 主键 |
| articles | uk_slug | slug | UNIQUE | slug 唯一 |
| articles | idx_category | category_id | NORMAL | 分类查询 |
| articles | idx_author | author_id | NORMAL | 作者查询 |
| articles | idx_access_level | access_level | NORMAL | 权限过滤 |
| articles | idx_status | status | NORMAL | 状态过滤 |
| articles | idx_published_at | published_at | NORMAL | 时间排序 |
| categories | PRIMARY | id | PRIMARY | 主键 |
| categories | uk_slug | slug | UNIQUE | slug 唯一 |
| categories | idx_parent | parent_id | NORMAL | 父子查询 |
| tags | PRIMARY | id | PRIMARY | 主键 |
| tags | uk_slug | slug | UNIQUE | slug 唯一 |
| article_tags | PRIMARY | article_id, tag_id | PRIMARY | 联合主键 |
| article_tags | idx_tag | tag_id | NORMAL | 标签查询 |
| log_submissions | PRIMARY | id | PRIMARY | 主键 |
| log_submissions | uk_agent_date | agent_name, log_date | UNIQUE | 防止重复提交 |
| log_submissions | idx_article | article_id | NORMAL | 文章查询 |

---

## 视图设计

### v_public_articles - 公开文章视图

```sql
CREATE OR REPLACE VIEW v_public_articles AS
SELECT 
    a.id,
    a.title,
    a.slug,
    a.summary,
    a.cover_image,
    a.content_html,
    a.view_count,
    a.like_count,
    a.published_at,
    a.created_at,
    c.name AS category_name,
    c.slug AS category_slug,
    u.nickname AS author_name,
    u.avatar AS author_avatar
FROM articles a
LEFT JOIN categories c ON a.category_id = c.id
LEFT JOIN users u ON a.author_id = u.id
WHERE a.status = 'published'
  AND a.access_level = 0
  AND a.published_at <= NOW();
```

**用途:** 前端首页文章列表查询 (无需登录)

---

### v_article_with_tags - 带标签的文章视图

```sql
CREATE OR REPLACE VIEW v_article_with_tags AS
SELECT 
    a.id,
    a.title,
    a.slug,
    a.content_html,
    a.published_at,
    GROUP_CONCAT(t.name SEPARATOR ', ') AS tags
FROM articles a
LEFT JOIN article_tags at ON a.id = at.article_id
LEFT JOIN tags t ON at.tag_id = t.id
WHERE a.status = 'published'
GROUP BY a.id;
```

**用途:** 文章详情页查询 (带标签信息)

---

### v_agent_status - Agent 状态视图

```sql
CREATE OR REPLACE VIEW v_agent_status AS
SELECT 
    u.id,
    u.phone,
    u.nickname,
    u.role,
    u.access_level,
    u.last_login_at,
    COUNT(a.id) AS article_count,
    MAX(a.published_at) AS last_article_at
FROM users u
LEFT JOIN articles a ON u.id = a.author_id
WHERE u.role IN ('admin', 'author')
GROUP BY u.id;
```

**用途:** Agent 工作状态展示

---

## 数据字典

### 枚举值定义

#### users.role

| 值 | 说明 |
|----|------|
| user | 普通用户 |
| author | 作者 (可发布文章) |
| admin | 管理员 (全部权限) |

#### users.access_level

| 值 | 说明 |
|----|------|
| 0 | 普通用户 |
| 1 | VIP 用户 |
| 2 | 管理员 |

#### articles.access_level

| 值 | 说明 |
|----|------|
| 0 | 公开 (所有人可见) |
| 1 | 登录可见 |
| 2 | VIP/管理员可见 |

#### articles.status

| 值 | 说明 |
|----|------|
| draft | 草稿 |
| published | 已发布 |
| archived | 已归档 |

#### log_submissions.status

| 值 | 说明 |
|----|------|
| success | 提交成功 |
| failed | 提交失败 |

---

## 初始化数据

### 默认管理员账号

```sql
-- 创建默认管理员 (手机号：13800138000)
INSERT INTO users (phone, nickname, role, access_level)
VALUES ('13800138000', '管理员', 'admin', 2);
```

### 默认分类

```sql
-- 创建默认分类
INSERT INTO categories (name, slug, description, sort_order) VALUES
('技术文章', 'tech', '技术相关的文章', 1),
('工作日志', 'logs', 'Agent 团队工作日志', 2),
('项目文档', 'docs', '项目相关文档', 3),
('其他', 'other', '其他内容', 99);
```

### 默认标签

```sql
-- 创建默认标签
INSERT INTO tags (name, slug) VALUES
('Java', 'java'),
('Vue', 'vue'),
('Docker', 'docker'),
('OpenClaw', 'openclaw'),
('日常', 'daily'),
('灌汤', 'guantang'),
('酱肉', 'jiangrou'),
('豆沙', 'dousha'),
('酸菜', 'suancai');
```

### Agent 账号

```sql
-- 创建 4 个 Agent 账号
INSERT INTO users (phone, nickname, role, access_level) VALUES
('13800000001', '灌汤', 'admin', 2),
('13800000002', '酱肉', 'author', 1),
('13800000003', '豆沙', 'author', 1),
('13800000004', '酸菜', 'author', 1);
```

---

## SQL 脚本

### 完整建库脚本

位置：`F:\openclaw\code\backend\src\main\resources\db\migration\V1__init_schema.sql`

```sql
-- 创建数据库
CREATE DATABASE IF NOT EXISTS blog_system 
DEFAULT CHARACTER SET utf8mb4 
DEFAULT COLLATE utf8mb4_unicode_ci;

USE blog_system;

-- 1. 创建用户表
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户 ID',
    phone VARCHAR(11) NOT NULL COMMENT '手机号',
    nickname VARCHAR(50) DEFAULT '匿名用户' COMMENT '昵称',
    avatar VARCHAR(255) DEFAULT '' COMMENT '头像 URL',
    role VARCHAR(20) DEFAULT 'user' COMMENT '角色：user/author/admin',
    access_level TINYINT DEFAULT 0 COMMENT '访问级别：0-普通 1-VIP 2-管理员',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    last_login_at DATETIME DEFAULT NULL COMMENT '最后登录时间',
    UNIQUE KEY uk_phone (phone),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 2. 创建分类表
CREATE TABLE categories (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '分类 ID',
    name VARCHAR(50) NOT NULL COMMENT '分类名',
    slug VARCHAR(50) DEFAULT NULL COMMENT 'URL 别名',
    description TEXT DEFAULT NULL COMMENT '描述',
    parent_id BIGINT DEFAULT NULL COMMENT '父分类 ID',
    sort_order INT DEFAULT 0 COMMENT '排序',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_slug (slug),
    INDEX idx_parent (parent_id),
    CONSTRAINT fk_categories_parent FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分类表';

-- 3. 创建标签表
CREATE TABLE tags (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '标签 ID',
    name VARCHAR(50) NOT NULL COMMENT '标签名',
    slug VARCHAR(50) DEFAULT NULL COMMENT 'URL 别名',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签表';

-- 4. 创建文章表
CREATE TABLE articles (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '文章 ID',
    title VARCHAR(200) NOT NULL COMMENT '标题',
    slug VARCHAR(200) DEFAULT NULL COMMENT 'URL 别名',
    content_md TEXT DEFAULT NULL COMMENT 'Markdown 原文',
    content_html TEXT DEFAULT NULL COMMENT '渲染后的 HTML',
    summary VARCHAR(500) DEFAULT NULL COMMENT '摘要',
    cover_image VARCHAR(255) DEFAULT NULL COMMENT '封面图 URL',
    category_id BIGINT DEFAULT NULL COMMENT '分类 ID',
    author_id BIGINT NOT NULL COMMENT '作者 ID',
    access_level TINYINT DEFAULT 0 COMMENT '访问级别：0-公开 1-登录 2-VIP',
    view_count INT DEFAULT 0 COMMENT '浏览量',
    like_count INT DEFAULT 0 COMMENT '点赞数',
    status VARCHAR(20) DEFAULT 'draft' COMMENT '状态：draft/published/archived',
    published_at DATETIME DEFAULT NULL COMMENT '发布时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY uk_slug (slug),
    INDEX idx_category (category_id),
    INDEX idx_author (author_id),
    INDEX idx_access_level (access_level),
    INDEX idx_status (status),
    INDEX idx_published_at (published_at),
    CONSTRAINT fk_articles_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    CONSTRAINT fk_articles_author FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章表';

-- 5. 创建文章标签关联表
CREATE TABLE article_tags (
    article_id BIGINT NOT NULL COMMENT '文章 ID',
    tag_id BIGINT NOT NULL COMMENT '标签 ID',
    PRIMARY KEY (article_id, tag_id),
    INDEX idx_tag (tag_id),
    CONSTRAINT fk_article_tags_article FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    CONSTRAINT fk_article_tags_tag FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章标签关联表';

-- 6. 创建日志提交记录表
CREATE TABLE log_submissions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '提交记录 ID',
    agent_name VARCHAR(50) NOT NULL COMMENT 'Agent 名称',
    log_date VARCHAR(8) NOT NULL COMMENT '日志日期 YYYYMMDD',
    article_id BIGINT NOT NULL COMMENT '文章 ID',
    status VARCHAR(20) DEFAULT 'success' COMMENT '状态：success/failed',
    error_message TEXT DEFAULT NULL COMMENT '错误信息',
    submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
    UNIQUE KEY uk_agent_date (agent_name, log_date),
    INDEX idx_article (article_id),
    CONSTRAINT fk_log_submissions_article FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='日志提交记录表';

-- 7. 创建视图
CREATE OR REPLACE VIEW v_public_articles AS
SELECT 
    a.id, a.title, a.slug, a.summary, a.cover_image, a.content_html,
    a.view_count, a.like_count, a.published_at, a.created_at,
    c.name AS category_name, c.slug AS category_slug,
    u.nickname AS author_name, u.avatar AS author_avatar
FROM articles a
LEFT JOIN categories c ON a.category_id = c.id
LEFT JOIN users u ON a.author_id = u.id
WHERE a.status = 'published' AND a.access_level = 0 AND a.published_at <= NOW();

-- 8. 插入初始化数据
-- 默认管理员
INSERT INTO users (phone, nickname, role, access_level) VALUES
('13800138000', '管理员', 'admin', 2);

-- Agent 账号
INSERT INTO users (phone, nickname, role, access_level) VALUES
('13800000001', '灌汤', 'admin', 2),
('13800000002', '酱肉', 'author', 1),
('13800000003', '豆沙', 'author', 1),
('13800000004', '酸菜', 'author', 1);

-- 默认分类
INSERT INTO categories (name, slug, description, sort_order) VALUES
('技术文章', 'tech', '技术相关的文章', 1),
('工作日志', 'logs', 'Agent 团队工作日志', 2),
('项目文档', 'docs', '项目相关文档', 3),
('其他', 'other', '其他内容', 99);

-- 默认标签
INSERT INTO tags (name, slug) VALUES
('Java', 'java'), ('Vue', 'vue'), ('Docker', 'docker'),
('OpenClaw', 'openclaw'), ('日常', 'daily'),
('灌汤', 'guantang'), ('酱肉', 'jiangrou'),
('豆沙', 'dousha'), ('酸菜', 'suancai');
```

---

## 变更历史

| 版本 | 日期 | 变更人 | 变更说明 |
|------|------|--------|----------|
| 1.0 | 2026-03-10 | 酱肉 | 初始版本 |

---

**文档审批:**

| 角色 | 姓名 | 签字 | 日期 |
|------|------|------|------|
| PM | 灌汤 | - | 2026-03-10 |
| 后端 | 酱肉 | - | 2026-03-10 |
