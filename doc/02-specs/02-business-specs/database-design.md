# 数据库设计（实际实现）

**数据库:** MySQL 8.0+  
**字符集:** utf8mb4  
**迁移工具:** Flyway

## 已实现表

### 1. users (用户表) ✅
| 字段 | 类型 | 说明 |
|------|------|------|
| id | BIGINT | 主键 |
| username | VARCHAR(100) | 用户名（唯一） |
| email | VARCHAR(100) | 邮箱（唯一） |
| password_hash | VARCHAR(255) | 密码哈希 |
| phone | VARCHAR(20) | 手机号（Plan-04 新增） |
| avatar | VARCHAR(255) | 头像 URL（Plan-04 新增） |
| role | VARCHAR(20) | 角色（Plan-04 新增） |
| created_at | TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | 更新时间 |

### 2. articles (文章表) ✅
| 字段 | 类型 | 说明 |
|------|------|------|
| id | BIGINT | 主键 |
| title | VARCHAR(255) | 标题 |
| content | TEXT | 内容 |
| summary | VARCHAR(500) | 摘要 |
| author_id | BIGINT | 作者 ID |
| status | VARCHAR(20) | 状态（draft/published） |
| access_level | VARCHAR(20) | 访问级别 |
| view_count | INT | 阅读量 |
| published_at | TIMESTAMP | 发布时间 |
| created_at | TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | 更新时间 |

### 3. categories (分类表) ✅ Plan-04 新增
| 字段 | 类型 | 说明 |
|------|------|------|
| id | BIGINT | 主键 |
| name | VARCHAR(100) | 分类名称 |
| slug | VARCHAR(100) | 分类别名（唯一） |
| parent_id | BIGINT | 父分类 ID（支持多级） |
| description | TEXT | 分类描述 |
| sort_order | INT | 排序顺序 |
| created_at | TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | 更新时间 |

### 4. tags (标签表) ✅ Plan-04 新增
| 字段 | 类型 | 说明 |
|------|------|------|
| id | BIGINT | 主键 |
| name | VARCHAR(100) | 标签名称 |
| slug | VARCHAR(100) | 标签别名（唯一） |
| description | TEXT | 标签描述 |
| article_count | INT | 关联文章数量 |
| created_at | TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | 更新时间 |

## 迁移脚本

| 版本 | 脚本 | 说明 |
|------|------|------|
| V1 | V1__create_users_table.sql | 用户表 |
| V2 | V2__create_articles_table.sql | 文章表 |
| V3 | V3__create_categories_table.sql | 分类表 |
| V4 | V4__create_tags_table.sql | 标签表 |

## 未实现表（计划中）
- ~~comments (评论表)~~ - 阶段 3
- ~~favorites (收藏表)~~ - 阶段 3