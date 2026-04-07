# 数据库验证日志

## 任务信息
- 任务ID: TASK-015-R3-01
- 执行时间: 2026-04-07 14:04
- 执行人: 酱肉

## 数据库验证步骤

### 1. 检查 users 表 access_level 字段
- 检查结果: 

### 2. 检查 comments 表是否存在
- 检查结果: 

## 执行操作记录
- 需要执行的SQL脚本:

```
ALTER TABLE users ADD COLUMN access_level INT DEFAULT 0 COMMENT '用户权限级别：0=普通，1=VIP，2=管理员';
```

```
CREATE TABLE IF NOT EXISTS comments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '评论 ID',
    article_id BIGINT NOT NULL COMMENT '文章 ID',
    user_id BIGINT NOT NULL COMMENT '用户 ID',
    content TEXT NOT NULL COMMENT '评论内容',
    parent_id BIGINT DEFAULT NULL COMMENT '父评论 ID (回复功能)',
    status TINYINT DEFAULT 1 COMMENT '状态：0=隐藏，1=显示，2=待审核',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_article_id (article_id),
    INDEX idx_user_id (user_id),
    INDEX idx_parent_id (parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论表';
```

## 结果
- 最终状态: