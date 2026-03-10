# 酱肉 (后端) - 完整知识库

## 📚 知识库目录

- [身份认知](./IDENTITY.md)
- [职责规范](./ROLE.md)
- [行为准则](./SOUL.md)
- [后端开发最佳实践](./backend-best-practices.md)
- [API 设计规范](./api-design-guidelines.md)
- [数据库设计原则](./database-design-principles.md)
- [技术栈选型指南](./tech-stack-selection.md)
- [常见问题与解决方案](./common-issues-solutions.md)

---

## 🔧 后端开发最佳实践

### 1. RESTful API 设计规范

#### URL 命名规范
```
GET    /api/articles          # 获取文章列表
POST   /api/articles          # 创建文章
GET    /api/articles/{id}     # 获取单篇文章
PUT    /api/articles/{id}     # 更新文章
DELETE /api/articles/{id}     # 删除文章
```

#### 响应格式标准
```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "文章标题",
    "content": "文章内容"
  },
  "message": "操作成功",
  "timestamp": "2026-03-08T10:00:00Z"
}
```

#### 错误处理
```json
{
  "success": false,
  "error": {
    "code": "ARTICLE_NOT_FOUND",
    "message": "文章不存在",
    "details": "请求的文章 ID 为 1，但未找到对应记录"
  },
  "timestamp": "2026-03-08T10:00:00Z"
}
```

### 2. 数据库设计原则

#### 表命名规范
- ✅ 使用复数名词：`articles`, `users`, `comments`
- ✅ 统一小写，下划线分隔：`user_profiles`
- ❌ 避免单数：`article`, `user`
- ❌ 避免驼峰：`UserProfiles`

#### 字段设计
```sql
-- 标准字段
CREATE TABLE articles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    status ENUM('draft', 'published', 'archived') DEFAULT 'draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
);
```

### 3. 性能优化建议

#### 数据库查询优化
- 使用索引覆盖常用查询
- 避免 N+1 查询问题
- 合理使用缓存（Redis）
- 分页查询限制返回数量

#### 代码层面优化
```python
# ❌ 慢查询 - N+1 问题
articles = Article.query.all()
for article in articles:
    author = User.query.get(article.author_id)  # 每次都查询数据库

# ✅ 使用 JOIN 预加载
articles = Article.query.options(joinedload(Article.author)).all()
```

### 4. 安全最佳实践

#### SQL 注入防护
```python
# ❌ 危险写法
query = f"SELECT * FROM users WHERE username = '{username}'"

# ✅ 参数化查询
query = "SELECT * FROM users WHERE username = %s"
cursor.execute(query, (username,))
```

#### 认证与授权
- 使用 JWT 进行无状态认证
- 密码必须加盐哈希存储（bcrypt/argon2）
- 实现基于角色的访问控制（RBAC）
- API 限流防止暴力攻击

### 5. 日志与监控

#### 日志级别使用
```python
import logging

logging.debug("调试信息 - 详细的技术细节")
logging.info("信息 - 正常的运行日志")
logging.warning("警告 - 可能有问题但不影响运行")
logging.error("错误 - 某个操作失败")
logging.critical("严重错误 - 系统可能无法继续运行")
```

#### 关键指标监控
- API 响应时间（P95, P99）
- 数据库查询耗时
- 缓存命中率
- 错误率统计
- QPS（每秒查询数）

---

## 🛠️ 技术栈选型指南

### 推荐技术栈

#### Web 框架
- **FastAPI** (首选) - 现代、高性能、自动文档
- Flask - 轻量级、灵活
- Django - 全功能、成熟生态

#### 数据库
- **MySQL 8.0** - 关系型数据库
- PostgreSQL - 高级特性支持
- Redis - 缓存和会话存储

#### ORM
- **SQLAlchemy** - Python 最强大的 ORM
- Peewee - 轻量级 ORM

#### 认证
- **PyJWT** - JWT 实现
- python-jose - JWS/JWE 支持

#### 测试
- **pytest** - 现代化测试框架
- pytest-cov - 覆盖率统计
- httpx - API 测试客户端

---

## ⚠️ 常见错误与解决方案

### 错误 1: 数据库连接池耗尽

**现象:**
```
sqlalchemy.exc.TimeoutError: QueuePool limit of size X overflow Y reached
```

**解决方案:**
```python
# 调整连接池大小
engine = create_engine(
    DATABASE_URL,
    pool_size=20,        # 增加连接数
    max_overflow=40,     # 增加溢出量
    pool_recycle=3600    # 定期回收连接
)
```

### 错误 2: API 响应过慢

**排查步骤:**
1. 检查慢查询日志
2. 分析执行计划（EXPLAIN）
3. 添加缺失的索引
4. 考虑缓存热点数据

**解决方案:**
```python
from functools import lru_cache
from datetime import timedelta

@lru_cache(maxsize=128)
def get_article_by_id(article_id: int):
    return Article.query.get(article_id)

# 或使用 Redis 缓存
@cache.cached(timeout=timedelta(minutes=10))
def get_popular_articles():
    return Article.query.filter_by(status='published').limit(10).all()
```

### 错误 3: 内存泄漏

**常见原因:**
- 循环引用未释放
- 大量数据一次性加载
- 全局变量累积

**解决方案:**
```python
# ❌ 内存占用大
all_data = list(large_queryset)

# ✅ 使用生成器
def iter_queryset(queryset, chunk_size=100):
    for i in range(0, queryset.count(), chunk_size):
        yield from queryset[i:i+chunk_size]
```

---

## 📖 学习资源

### 官方文档
- [FastAPI 官方文档](https://fastapi.tiangolo.com/)
- [SQLAlchemy 文档](https://docs.sqlalchemy.org/)
- [MySQL 8.0 参考手册](https://dev.mysql.com/doc/refman/8.0/en/)

### 最佳实践
- [RESTful API 设计指南](https://restfulapi.net/)
- [12-Factor App](https://12factor.net/zh_cn/)
- [Python 编码规范](https://pep8.org/)

---

*最后更新：2026-03-08*  
*维护者：酱肉Agent*
