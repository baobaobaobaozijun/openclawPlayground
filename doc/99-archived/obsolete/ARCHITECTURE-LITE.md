<!-- Last Modified: 2026-03-11 -->

# 包子铺博客系统架构

**项目类型:** 个人博客  
**服务器配置:** 2GB 内存 / 2 CPU / 40GB 磁盘  
**架构原则:** 轻量级、简单实用、够用就好  

*最后更新：2026-03-11*

---

## 📋 架构目标

### 核心需求
- ✅ 文章发布与管理
- ✅ 分类与标签
- ✅ 评论功能
- ✅ 简单的用户认证
- ✅ 响应式设计
- ✅ SEO 友好

### 技术约束
- **内存占用:** < 1.5GB（预留 500MB 给系统）
- **CPU 使用:** 日常 < 30%，峰值 < 70%
- **磁盘占用:** < 20GB（预留 20GB 给内容和备份）
- **部署复杂度:** 尽可能简单，无需容器化

---

## 🏛️ 整体架构

### 架构图

```
┌─────────────────────────────────────────┐
│           Nginx (反向代理)               │
│         端口：80, 443                    │
│       静态文件 + SSL 终止                  │
└─────────────┬───────────────────────────┘
              │
    ┌─────────┴──────────┐
    │                    │
┌───▼────────┐      ┌───▼────────┐
│ 前端应用    │      │ 后端 API    │
│ Vue 3 SPA  │      │ Spring Boot│
│ 端口：3000 │      │ 端口：8080  │
│ 内存：~50MB│      │ 内存：~800MB│
└────────────┘      └─────┬───────┘
                          │
                    ┌─────▼───────┐
                    │  MySQL 8.0  │
                    │  端口：3306  │
                    │  内存：~400MB│
                    └─────────────┘
```

---

## 💻 技术栈选择

### 前端技术栈（豆沙负责）

| 组件 | 技术 | 版本 | 用途 | 内存占用 |
|------|------|------|------|---------|
| **框架** | Vue.js | 3.4+ | 前端框架 | ~30MB |
| **语言** | TypeScript | 5.x | 类型安全 | - |
| **构建** | Vite | 5.x | 快速构建 | ~20MB |
| **路由** | Vue Router | 4.x | 路由管理 | ~5MB |
| **状态** | Pinia | 2.x | 状态管理 | ~5MB |
| **UI** | Element Plus | 2.x | UI 组件库 | ~10MB |
| **样式** | Tailwind CSS | 3.x | 原子化 CSS | ~5MB |
| **HTTP** | Axios | 1.x | API 请求 | ~2MB |

**前端总计:** ~77MB 内存

---

### 后端技术栈（酱肉负责）

| 组件 | 技术 | 版本 | 用途 | 内存占用 |
|------|------|------|------|---------|
| **语言** | Java | 21 (LTS) | 主要编程语言 | - |
| **框架** | Spring Boot | 3.2+ | Web 应用框架 | ~500MB |
| **安全** | Spring Security | 6.x | 认证授权 | ~100MB |
| **ORM** | MyBatis-Plus | 3.5+ | 对象关系映射 | ~50MB |
| **数据库** | MySQL | 8.0+ | 主数据库 | ~400MB |
| **连接池** | HikariCP | 5.x | 数据库连接池 | ~30MB |
| **缓存** | Caffeine | 3.x | 本地缓存（替代 Redis） | ~20MB |
| **构建** | Maven | 3.9+ | 项目构建 | ~50MB |

**后端总计:** ~1,150MB 内存

---

### 运维技术栈（酸菜负责）

| 组件 | 技术 | 用途 | 内存占用 |
|------|------|------|---------|
| **Web 服务器** | Nginx | 反向代理、静态文件 | ~10MB |
| **进程管理** | systemd | Spring Boot 进程管理 | ~5MB |
| **日志** | Journalctl + 文件日志 | 系统日志 | ~20MB |
| **监控** | Prometheus Node Exporter | 基础监控（可选） | ~30MB |
| **备份** | Shell 脚本 | 定时备份 | ~5MB |

**运维总计:** ~70MB 内存

---

### 总资源占用

| 组件 | 内存占用 | 占比 |
|------|---------|-----|
| **前端应用** | ~77MB | 5.1% |
| **后端 API** | ~1,150MB | 76.7% |
| **MySQL 数据库** | ~400MB | 26.7% |
| **Nginx + 运维** | ~70MB | 4.7% |
| **系统预留** | ~500MB | 33.3% |
| **总计** | ~1,697MB | 113% ✅ |

**说明:** 实际运行时，通过 JVM 调优和 MySQL 配置优化，可将总内存控制在 1.5GB 以内。

---

## 📁 项目目录结构

### 简化后的目录布局

```
f:\openclaw/
│
├── doc/                          # 📚 统一知识库
│   ├── README.md                # 知识库索引
│   ├── ARCHITECTURE-LITE.md     # 本文件 - 轻量级架构
│   ├── guides/                  # 使用指南
│   └── specs/                   # 规范文档
│
├── agent/                        # 🧠 Agent 工作区
│   ├── workspace-guantang/      # PM 工作台
│   ├── workspace-jiangrou/      # 后端工作台
│   ├── workspace-dousha/        # 前端工作台
│   └── workspace-suancai/       # 运维工作台
│
├── code/                         # 💻 工程项目
│   ├── backend/                 # 后端工程
│   │   ├── src/                 # 源代码
│   │   ├── pom.xml              # Maven 配置
│   │   └── README.md            # 工程说明
│   │
│   ├── frontend/                # 前端工程
│   │   ├── src/                 # 源代码
│   │   ├── package.json         # NPM 配置
│   │   └── README.md            # 工程说明
│   │
│   └── deploy/                  # 部署脚本
│       ├── nginx/               # Nginx 配置
│       ├── scripts/             # 部署脚本
│       └── README.md            # 部署说明
│
└── .lingma/                      # Lingma IDE 配置
```

---

## 🚀 部署方案

### 方案一：单机部署（推荐）⭐

**适用场景:** 个人博客、小型项目

**部署方式:**
```bash
# 所有服务运行在同一台服务器
Nginx (80/443) → Spring Boot (8080) → MySQL (3306)
```

**优点:**
- ✅ 简单直接，无需容器化
- ✅ 资源利用率高
- ✅ 维护成本低
- ✅ 适合 2G 内存服务器

**部署步骤:**
1. 安装 JDK 21、MySQL 8.0、Nginx
2. 配置 MySQL 数据库
3. 打包 Spring Boot 为 JAR 文件
4. 使用 systemd 管理 Spring Boot 进程
5. 配置 Nginx 反向代理
6. 前端构建为静态文件，由 Nginx 托管

---

### 方案二：前后端分离部署

**适用场景:** 需要 CDN 加速

**部署方式:**
```bash
# 前端部署到 CDN 或对象存储
前端静态文件 → OSS/CDN

# 后端和数据库在服务器
Nginx → Spring Boot → MySQL
```

**优点:**
- ✅ 前端访问速度快
- ✅ 减轻服务器压力
- ✅ 支持 HTTPS

**缺点:**
- ⚠️ 需要额外配置 CDN
- ⚠️ 跨域问题

---

## 🔧 关键技术决策

### 1. 不使用 Docker

**理由:**
- ❌ Docker Daemon 占用 ~100MB 内存
- ❌ 容器化增加复杂性
- ❌ 对于单应用无明显收益
- ✅ 直接使用 systemd 更简单高效

**替代方案:**
```bash
# 使用 systemd 管理 Spring Boot 进程
sudo systemctl start blog-backend
sudo systemctl enable blog-backend
```

---

### 2. 不使用 Redis

**理由:**
- ❌ Redis 占用 ~50-100MB 内存
- ❌ 个人博客访问量小，无需分布式缓存
- ✅ 使用 Caffeine 本地缓存足够

**替代方案:**
```java
// 使用 Caffeine 本地缓存
@Configuration
public class CacheConfig {
    @Bean
    public Cache<Object, Object> cache() {
        return Caffeine.newBuilder()
            .maximumSize(1000)
            .expireAfterWrite(Duration.ofMinutes(10))
            .build();
    }
}
```

---

### 3. 不使用 K8s

**理由:**
- ❌ K8s 至少需要 4GB 内存
- ❌ 过度设计，杀鸡用牛刀
- ✅ systemd 足够管理单个应用

---

### 4. 使用 Nginx 作为反向代理

**理由:**
- ✅ 内存占用仅 ~10MB
- ✅ 性能优秀
- ✅ 配置简单
- ✅ 支持 SSL 终止

**配置示例:**
```nginx
server {
    listen 80;
    server_name your-blog.com;
    
    # 前端静态文件
    location / {
        root /var/www/blog-frontend;
        try_files $uri $uri/ /index.html;
    }
    
    # 后端 API 代理
    location /api/ {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

---

## 📊 数据库设计

### 核心表结构

**1. 用户表 (users)**
```sql
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100),
    role VARCHAR(20) DEFAULT 'USER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**2. 文章表 (articles)**
```sql
CREATE TABLE articles (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    summary VARCHAR(500),
    author_id BIGINT,
    status VARCHAR(20) DEFAULT 'DRAFT',
    view_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES users(id)
);
```

**3. 分类表 (categories)**
```sql
CREATE TABLE categories (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    slug VARCHAR(50) UNIQUE NOT NULL,
    description VARCHAR(200)
);
```

**4. 标签表 (tags)**
```sql
CREATE TABLE tags (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    slug VARCHAR(50) UNIQUE NOT NULL
);
```

**5. 文章 - 标签关联表 (article_tags)**
```sql
CREATE TABLE article_tags (
    article_id BIGINT,
    tag_id BIGINT,
    PRIMARY KEY (article_id, tag_id),
    FOREIGN KEY (article_id) REFERENCES articles(id),
    FOREIGN KEY (tag_id) REFERENCES tags(id)
);
```

**6. 评论表 (comments)**
```sql
CREATE TABLE comments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    article_id BIGINT NOT NULL,
    user_id BIGINT,
    content TEXT NOT NULL,
    parent_id BIGINT,
    status VARCHAR(20) DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (parent_id) REFERENCES comments(id)
);
```

---

## 🎨 前端架构

### 页面结构

```
首页 (/)
├── 文章列表
├── 分页
└── 侧边栏（分类、标签、热门文章）

文章详情 (/article/:id)
├── 文章内容
├── 目录导航
├── 评论列表
└── 上一篇/下一篇

分类页 (/category/:slug)
└── 该分类下的文章列表

标签页 (/tag/:slug)
└── 该标签下的文章列表

关于我 (/about)
└── 个人介绍

后台管理 (/admin)
├── 文章管理
│   ├── 新建文章
│   └── 文章列表
├── 分类管理
├── 标签管理
└── 评论管理
```

---

### 组件设计

**核心组件:**
```
src/
├── components/
│   ├── common/
│   │   ├── Header.vue          # 页头
│   │   ├── Footer.vue          # 页脚
│   │   ├── Sidebar.vue         # 侧边栏
│   │   └── Pagination.vue      # 分页
│   ├── article/
│   │   ├── ArticleList.vue     # 文章列表
│   │   ├── ArticleCard.vue     # 文章卡片
│   │   └── ArticleContent.vue  # 文章内容
│   └── admin/
│       ├── ArticleEditor.vue   # 文章编辑器
│       └── Dashboard.vue       # 管理后台
├── views/
│   ├── Home.vue                # 首页
│   ├── ArticleDetail.vue       # 文章详情
│   ├── Category.vue            # 分类页
│   ├── Tag.vue                 # 标签页
│   └── About.vue               # 关于页
└── stores/
    ├── article.ts              # 文章状态
    ├── user.ts                 # 用户状态
    └── site.ts                 # 站点配置
```

---

## 🔐 安全设计

### 认证机制

**JWT Token 认证:**
```java
// 登录接口
POST /api/auth/login
{
  "username": "admin",
  "password": "password123"
}

// 返回
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresIn": 86400
}
```

**权限控制:**
- **游客:** 浏览文章、发表评论
- **注册用户:** 管理自己的评论
- **管理员:** 所有操作（文章 CRUD、分类标签管理、评论审核）

---

### 安全措施

1. **密码加密:** BCrypt 强哈希
2. **SQL 注入防护:** MyBatis 参数化查询
3. **XSS 防护:** 输入过滤 + 输出转义
4. **CSRF 防护:** Token 验证
5. **限流:** 单 IP 每分钟最多 60 次请求

---

## 📈 性能优化

### 后端优化

**1. JVM 调优**
```bash
# 限制堆内存为 600MB
JAVA_OPTS="-Xms600m -Xmx600m -XX:+UseG1GC"
```

**2. 数据库优化**
```ini
# my.cnf 配置
[mysqld]
innodb_buffer_pool_size = 256M
max_connections = 50
query_cache_size = 32M
```

**3. 缓存策略**
```java
// 热门文章缓存 10 分钟
@Cacheable(value = "hotArticles", ttl = 600)
public List<Article> getHotArticles() { ... }

// 文章详情缓存 1 小时
@Cacheable(value = "articleDetail", ttl = 3600)
public Article getArticleById(Long id) { ... }
```

---

### 前端优化

**1. 代码分割**
```javascript
// 路由懒加载
const routes = [
  {
    path: '/admin',
    component: () => import('@/views/admin/Dashboard.vue')
  }
];
```

**2. 图片优化**
```html
<!-- WebP 格式 + 懒加载 -->
<img src="cover.webp" loading="lazy" alt="封面">
```

**3. Gzip 压缩**
```nginx
gzip on;
gzip_types text/plain application/json application/javascript text/css;
```

---

## 🔄 部署流程

### 自动化部署脚本

**deploy.sh:**
```bash
#!/bin/bash

echo "🚀 开始部署..."

# 1. 拉取最新代码
cd /opt/blog-backend
git pull origin main

# 2. 编译打包
mvn clean package -DskipTests

# 3. 停止旧服务
sudo systemctl stop blog-backend

# 4. 替换 JAR 文件
sudo cp target/blog-*.jar /opt/blog-backend/blog.jar

# 5. 启动新服务
sudo systemctl start blog-backend

# 6. 检查服务状态
sleep 5
sudo systemctl status blog-backend

echo "✅ 部署完成！"
```

---

### 前端部署

**build-and-deploy.sh:**
```bash
#!/bin/bash

echo "🎨 开始构建前端..."

# 1. 安装依赖
npm install

# 2. 构建生产版本
npm run build

# 3. 复制到 Nginx 目录
sudo cp -r dist/* /var/www/blog-frontend/

echo "✅ 前端部署完成！"
```

---

## 📝 监控与日志

### 基础监控

**监控指标:**
- CPU 使用率
- 内存使用率
- 磁盘空间
- 网络流量
- MySQL 连接数
- Spring Boot 健康状态

**监控工具:**
- **Prometheus Node Exporter** (可选): 系统指标
- **Spring Boot Actuator**: 应用健康检查
- **自定义脚本:** 简单告警

---

### 日志管理

**日志级别:**
```properties
# production 环境
logging.level.root=WARN
logging.level.com.blog=INFO
logging.file.name=/var/log/blog/application.log
```

**日志轮转:**
```bash
# logrotate 配置
/var/log/blog/*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
}
```

---

## 🎯 开发建议

### 后端开发规范

**代码风格:**
- 遵循阿里巴巴 Java 开发手册
- 使用 Checkstyle + SonarQube 检查代码质量
- 单元测试覆盖率 ≥ 60%

**API 设计:**
```java
// RESTful 风格
GET    /api/articles          # 获取文章列表
POST   /api/articles          # 创建文章
GET    /api/articles/{id}     # 获取文章详情
PUT    /api/articles/{id}     # 更新文章
DELETE /api/articles/{id}     # 删除文章
```

---

### 前端开发规范

**代码风格:**
- 使用 ESLint + Prettier
- TypeScript 严格模式
- 组件大小适中（< 300 行）

**命名规范:**
```typescript
// 文件名：PascalCase
ArticleList.vue
ArticleCard.ts

// 变量名：camelCase
const articleTitle = 'Hello';

// 常量名：UPPER_SNAKE_CASE
const MAX_RETRY_COUNT = 3;
```

---

## 📞 故障排查

### 常见问题

**1. 内存不足**
```bash
# 检查内存使用
free -h

# 查看 Java 进程内存
ps aux | grep java

# 解决方案：调整 JVM 参数
-Xms400m -Xmx400m
```

**2. MySQL 连接过多**
```sql
-- 查看当前连接数
SHOW STATUS LIKE 'Threads_connected';

-- 解决方案：优化连接池
spring.datasource.hikari.maximum-pool-size=10
```

**3. 网站访问慢**
```bash
# 检查 Nginx 日志
tail -f /var/log/nginx/access.log

# 检查慢查询
mysql> SHOW PROCESSLIST;
```

---

## 📊 扩展性考虑

### 未来升级路径

**当访问量增长时:**

**阶段 1 (日 PV < 1000):**
- 保持当前架构
- 优化缓存策略
- 添加 CDN

**阶段 2 (日 PV 1000-5000):**
- 升级服务器到 4GB 内存
- 引入 Redis 缓存
- 数据库读写分离

**阶段 3 (日 PV > 5000):**
- 考虑微服务拆分
- 使用 Docker容器化
- 负载均衡

---

## ✅ 总结

### 架构优势

1. **轻量级:** 总内存占用 < 1.5GB
2. **简单:** 无需容器化，部署直接
3. **实用:** 满足个人博客所有需求
4. **经济:** 低配服务器即可运行
5. **易维护:** 技术栈成熟，资料丰富

### 适用场景

- ✅ 个人博客
- ✅ 技术文章分享
- ✅ 小型企业官网
- ✅ 产品文档站点

### 不适用场景

- ❌ 高并发电商（需微服务 + 缓存集群）
- ❌ 大数据处理（需分布式计算）
- ❌ 实时通信（需 WebSocket 集群）

---

**开始构建你的轻量级博客系统吧！** 🥟✨

---

**维护者:** 灌汤 PM  
**更新日期:** 2026-03-11  
**版本:** 1.0 (轻量级架构)
