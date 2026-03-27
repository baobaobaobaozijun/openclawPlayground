# 数据库设计文档

## 新增表 (2026-03-27)

### categories - 文章分类表
| 字段 | 类型 | 说明 |
|------|------|------|
| id | BIGINT | 分类 ID |
| name | VARCHAR(50) | 分类名称 |
| slug | VARCHAR(50) | 别名 |
| description | VARCHAR(200) | 描述 |
| parent_id | BIGINT | 父分类 ID |
| sort_order | INT | 排序 |

### tags - 文章标签表
| 字段 | 类型 | 说明 |
|------|------|------|
| id | BIGINT | 标签 ID |
| name | VARCHAR(50) | 标签名称 |
| slug | VARCHAR(50) | 别名 |

### article_category - 文章分类关联表
| 字段 | 类型 | 说明 |
|------|------|------|
| article_id | BIGINT | 文章 ID |
| category_id | BIGINT | 分类 ID |

### article_tag - 文章标签关联表
| 字段 | 类型 | 说明 |
|------|------|------|
| article_id | BIGINT | 文章 ID |
| tag_id | BIGINT | 标签 ID |