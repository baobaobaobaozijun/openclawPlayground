# 博客系统运维部署文档

**文档状态:** 正式  
**版本:** v1.0  
**创建日期:** 2026-03-12  
**负责人:** 酸菜 (运维工程师)  
**参考模板:** `templates/ops-deployment-template.md`

---

## 📋 文档信息

| 项目 | 值 |
|------|-----|
| 项目名称 | 博客系统 |
| 部署版本 | v1.0 |
| 技术栈 | Docker + MySQL + Redis + Spring Boot |
| 部署环境 | CentOS 7.9 / Ubuntu 20.04 |

---

## 1. 系统概述

### 1.1 系统架构

```
┌─────────────────────────────────────────────────┐
│                   Nginx                         │
│              (反向代理 + 负载均衡)               │
│                  Port 80/443                    │
└───────────────────┬─────────────────────────────┘
                    │
        ┌───────────┼───────────┐
        │           │           │
        ▼           ▼           ▼
   ┌─────────┐ ┌─────────┐ ┌─────────┐
   │ 前端    │ │ 后端    │ │ 后端    │
   │ 80      │ │ 8081    │ │ 8082    │
   └─────────┘ └────┬────┘ └────┬────┘
                    │           │
                    └─────┬─────┘
                          │
                ┌─────────┴─────────┐
                │                   │
                ▼                   ▼
           ┌─────────┐       ┌─────────┐
           │  MySQL  │       │  Redis  │
           │  3306   │       │  6379   │
           └─────────┘       └─────────┘
```

### 1.2 技术栈

| 组件 | 技术选型 | 版本 | 端口 |
|------|----------|------|------|
| Web 服务器 | Nginx | 1.24+ | 80/443 |
| 应用服务 | Spring Boot | 3.2+ | 8080 |
| 数据库 | MySQL | 8.0+ | 3306 |
| 缓存 | Redis | 7.0+ | 6379 |
| 容器 | Docker | Latest | - |
| 容器编排 | Docker Compose | 2.0+ | - |

### 1.3 部署环境

| 环境 | 域名 | IP | 用途 |
|------|------|----|----|
| 开发环境 | dev.example.com | 192.168.1.100 | 开发测试 |
| 测试环境 | test.example.com | 192.168.1.101 | 集成测试 |
| 生产环境 | api.example.com | 10.0.0.100 | 线上服务 |

---

## 2. 环境准备

### 2.1 系统要求

| 项目 | 要求 |
|------|------|
| 操作系统 | CentOS 7.9 / Ubuntu 20.04 |
| CPU | 2 核及以上 |
| 内存 | 4GB 及以上 |
| 磁盘 | 50GB 及以上 |
| Docker | 20.10+ |
| Docker Compose | 2.0+ |

### 2.2 安装 Docker

**CentOS:**
```bash
# 卸载旧版本
sudo yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine

# 安装 yum 工具包
sudo yum install -y yum-utils

# 添加 Docker 仓库
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# 安装 Docker
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 启动 Docker
sudo systemctl start docker
sudo systemctl enable docker

# 验证安装
docker --version
docker compose version
```

**Ubuntu:**
```bash
# 更新 apt 包索引
sudo apt-get update

# 安装依赖
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# 添加 Docker GPG 密钥
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 添加 Docker 仓库
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 安装 Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 验证安装
docker --version
docker compose version
```

### 2.3 配置 Docker 镜像加速

```bash
# 创建配置文件
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": [
    "https://docker.m.daocloud.io",
    "https://docker.1panel.live",
    "https://registry.cn-hangzhou.aliyuncs.com"
  ]
}
EOF

# 重启 Docker
sudo systemctl daemon-reload
sudo systemctl restart docker

# 验证
docker info | grep -A 10 "Registry Mirrors"
```

---

## 3. 部署流程

### 3.1 项目结构

```
/opt/blog-system/
├── docker-compose.yml         # Docker Compose 配置
├── .env                       # 环境变量
├── deploy.sh                  # 一键部署脚本
├── mysql/
│   ├── init/
│   │   └── 01-init.sql       # 数据库初始化脚本
│   └── data/                  # MySQL 数据目录
├── redis/
│   └── data/                  # Redis 数据目录
├── logs/
│   ├── backend/               # 后端日志
│   └── nginx/                 # Nginx 日志
└── nginx/
    ├── conf/                  # Nginx 配置
    └── ssl/                   # SSL 证书
```

### 3.2 Docker Compose 配置

**docker-compose.yml:**
```yaml
version: '3.8'

services:
  # MySQL 数据库
  mysql:
    image: mysql:8.0
    container_name: blog-mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: blog_system
      MYSQL_USER: blog_admin
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    ports:
      - "3306:3306"
    volumes:
      - ./mysql/data:/var/lib/mysql
      - ./mysql/init:/docker-entrypoint-initdb.d
    networks:
      - blog-network
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Redis 缓存
  redis:
    image: redis:7.0
    container_name: blog-redis
    restart: always
    command: redis-server --requirepass ${REDIS_PASSWORD}
    ports:
      - "6379:6379"
    volumes:
      - ./redis/data:/data
    networks:
      - blog-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  # 后端服务
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: blog-backend
    restart: always
    environment:
      SPRING_PROFILES_ACTIVE: prod
      DB_HOST: mysql
      DB_PORT: 3306
      DB_NAME: blog_system
      DB_USERNAME: blog_admin
      DB_PASSWORD: ${MYSQL_PASSWORD}
      REDIS_HOST: redis
      REDIS_PORT: 6379
      REDIS_PASSWORD: ${REDIS_PASSWORD}
      JWT_SECRET: ${JWT_SECRET}
    ports:
      - "8080:8080"
    depends_on:
      mysql:
        condition: service_healthy
      redis:
        condition: service_healthy
    networks:
      - blog-network
    volumes:
      - ./logs/backend:/app/logs
    healthcheck:
      test: ["CMD", "wget", "-q", "--spider", "http://localhost:8080/actuator/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  # 前端服务
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    container_name: blog-frontend
    restart: always
    networks:
      - blog-network

  # Nginx 反向代理
  nginx:
    image: nginx:1.24-alpine
    container_name: blog-nginx
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/conf:/etc/nginx/conf.d
      - ./nginx/ssl:/etc/nginx/ssl
      - ./logs/nginx:/var/log/nginx
    depends_on:
      - frontend
      - backend
    networks:
      - blog-network

networks:
  blog-network:
    driver: bridge
```

### 3.3 环境变量配置

**.env 文件:**
```bash
# MySQL 配置
MYSQL_ROOT_PASSWORD=YourRootPassword123!
MYSQL_PASSWORD=YourDbPassword123!

# Redis 配置
REDIS_PASSWORD=YourRedisPassword123!

# JWT 配置
JWT_SECRET=YourJwtSecretKey2026!

# 应用配置
SPRING_PROFILES_ACTIVE=prod
SERVER_PORT=8080
```

### 3.4 数据库初始化

**mysql/init/01-init.sql:**
```sql
-- 创建数据库
CREATE DATABASE IF NOT EXISTS blog_system 
DEFAULT CHARACTER SET utf8mb4 
DEFAULT COLLATE utf8mb4_unicode_ci;

USE blog_system;

-- 创建用户表
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

-- 创建分类表
CREATE TABLE categories (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '分类 ID',
    name VARCHAR(50) NOT NULL COMMENT '分类名',
    slug VARCHAR(50) DEFAULT NULL COMMENT 'URL 别名',
    description TEXT DEFAULT NULL COMMENT '描述',
    parent_id BIGINT DEFAULT NULL COMMENT '父分类 ID',
    sort_order INT DEFAULT 0 COMMENT '排序',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_slug (slug) COMMENT 'slug 唯一索引',
    INDEX idx_parent (parent_id) COMMENT '父分类索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分类表';

-- 创建标签表
CREATE TABLE tags (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '标签 ID',
    name VARCHAR(50) NOT NULL COMMENT '标签名',
    slug VARCHAR(50) DEFAULT NULL COMMENT 'URL 别名',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_slug (slug) COMMENT 'slug 唯一索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签表';

-- 创建文章表
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
    INDEX idx_published_at (published_at) COMMENT '发布时间索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章表';

-- 创建文章标签关联表
CREATE TABLE article_tags (
    article_id BIGINT NOT NULL COMMENT '文章 ID',
    tag_id BIGINT NOT NULL COMMENT '标签 ID',
    PRIMARY KEY (article_id, tag_id),
    INDEX idx_tag (tag_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文章标签关联表';

-- 创建日志提交记录表
CREATE TABLE log_submissions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '提交记录 ID',
    agent_name VARCHAR(50) NOT NULL COMMENT 'Agent 名称',
    log_date VARCHAR(8) NOT NULL COMMENT '日志日期 YYYYMMDD',
    article_id BIGINT NOT NULL COMMENT '文章 ID',
    status VARCHAR(20) DEFAULT 'success' COMMENT '状态：success/failed',
    error_message TEXT DEFAULT NULL COMMENT '错误信息',
    submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
    UNIQUE KEY uk_agent_date (agent_name, log_date) COMMENT 'Agent+ 日期唯一索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='日志提交记录表';

-- 插入初始化数据
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

### 3.5 一键部署脚本

**deploy.sh:**
```bash
#!/bin/bash

set -e

echo "================================"
echo "  博客系统一键部署脚本"
echo "================================"

# 检查是否以 root 运行
if [ "$EUID" -ne 0 ]; then 
  echo "请使用 sudo 运行此脚本"
  exit 1
fi

# 加载环境变量
if [ ! -f .env ]; then
    echo "错误：.env 文件不存在"
    exit 1
fi
source .env

# 创建必要目录
echo "创建目录结构..."
mkdir -p mysql/data mysql/init
mkdir -p redis/data
mkdir -p logs/backend logs/nginx
mkdir -p nginx/conf nginx/ssl

# 停止旧容器
echo "停止旧容器..."
docker compose down || true

# 启动数据库和缓存
echo "启动 MySQL 和 Redis..."
docker compose up -d mysql redis

# 等待服务就绪
echo "等待服务启动 (30 秒)..."
sleep 30

# 检查 MySQL 是否就绪
echo "检查 MySQL 状态..."
for i in {1..30}; do
    if docker compose exec -T mysql mysqladmin ping -ublog_admin -p${MYSQL_PASSWORD} &>/dev/null; then
        echo "MySQL 已就绪"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "MySQL 启动超时"
        exit 1
    fi
    sleep 1
done

# 启动应用服务
echo "启动应用服务..."
docker compose up -d backend frontend nginx

# 等待后端就绪
echo "等待后端服务启动 (30 秒)..."
sleep 30

# 检查服务状态
echo ""
echo "================================"
echo "  服务状态"
echo "================================"
docker compose ps

echo ""
echo "================================"
echo "  部署完成！"
echo "================================"
echo "  访问地址：http://$(hostname -I | awk '{print $1}')"
echo "  管理后台：http://$(hostname -I | awk '{print $1}')/admin"
echo "  默认管理员：13800138000"
echo "================================"
```

**使用方式:**
```bash
# 赋予执行权限
chmod +x deploy.sh

# 执行部署
sudo ./deploy.sh
```

---

## 4. Nginx 配置

### 4.1 HTTP 配置

**nginx/conf/default.conf:**
```nginx
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;

    # Gzip 压缩
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml;
    gzip_min_length 1000;

    # 静态资源缓存
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # SPA 路由支持
    location / {
        try_files $uri $uri/ /index.html;
    }

    # API 反向代理
    location /api/ {
        proxy_pass http://backend:8080/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # 超时设置
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    # 日志
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
}
```

### 4.2 HTTPS 配置（可选）

**nginx/conf/ssl.conf:**
```nginx
server {
    listen 443 ssl http2;
    server_name api.example.com;
    root /usr/share/nginx/html;
    index index.html;

    # SSL 证书
    ssl_certificate /etc/nginx/ssl/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/privkey.pem;

    # SSL 优化
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    # HSTS
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    # Gzip 压缩
    gzip on;
    gzip_types text/plain text/css application/json application/javascript;

    # 静态资源缓存
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # SPA 路由支持
    location / {
        try_files $uri $uri/ /index.html;
    }

    # API 反向代理
    location /api/ {
        proxy_pass http://backend:8080/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # 日志
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
}

# HTTP 重定向到 HTTPS
server {
    listen 80;
    server_name api.example.com;
    return 301 https://$server_name$request_uri;
}
```

---

## 5. 监控与告警

### 5.1 健康检查脚本

**health-check.sh:**
```bash
#!/bin/bash

set -e

echo "================================"
echo "  博客系统健康检查"
echo "================================"

# 加载环境变量
source .env

# 后端健康检查
echo "检查后端服务..."
BACKEND_HEALTH=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/actuator/health)
if [ "$BACKEND_HEALTH" != "200" ]; then
    echo "❌ 后端服务异常！HTTP 状态码：$BACKEND_HEALTH"
    exit 1
fi
echo "✅ 后端服务正常"

# MySQL 健康检查
echo "检查 MySQL..."
MYSQL_HEALTH=$(docker compose exec -T mysql mysqladmin ping -ublog_admin -p${MYSQL_PASSWORD} 2>&1)
if [[ "$MYSQL_HEALTH" != *"mysqld is alive"* ]]; then
    echo "❌ MySQL 服务异常！"
    exit 1
fi
echo "✅ MySQL 正常"

# Redis 健康检查
echo "检查 Redis..."
REDIS_HEALTH=$(docker compose exec -T redis redis-cli -a ${REDIS_PASSWORD} ping 2>&1)
if [ "$REDIS_HEALTH" != "PONG" ]; then
    echo "❌ Redis 服务异常！"
    exit 1
fi
echo "✅ Redis 正常"

# Nginx 健康检查
echo "检查 Nginx..."
NGINX_HEALTH=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/)
if [ "$NGINX_HEALTH" != "200" ]; then
    echo "❌ Nginx 服务异常！HTTP 状态码：$NGINX_HEALTH"
    exit 1
fi
echo "✅ Nginx 正常"

echo ""
echo "================================"
echo "  所有服务健康！"
echo "================================"
exit 0
```

### 5.2 监控指标

| 指标 | 说明 | 告警阈值 |
|------|------|----------|
| CPU 使用率 | 应用 CPU 占用 | > 80% 持续 5 分钟 |
| 内存使用率 | 应用内存占用 | > 85% 持续 5 分钟 |
| 磁盘使用率 | 磁盘空间占用 | > 80% |
| API 响应时间 | P95 响应时间 | > 500ms |
| 错误率 | HTTP 5xx 比例 | > 1% |
| MySQL 连接数 | 活跃连接数 | > 80% 最大连接数 |

---

## 6. 备份与恢复

### 6.1 数据库备份

**backup-mysql.sh:**
```bash
#!/bin/bash

set -e

BACKUP_DIR="./backups/mysql"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/blog_system_${DATE}.sql"

# 加载环境变量
source .env

# 创建备份目录
mkdir -p ${BACKUP_DIR}

# 执行备份
echo "开始备份数据库..."
docker compose exec -T mysql mysqldump -ublog_admin -p${MYSQL_PASSWORD} \
    --single-transaction \
    --routines \
    --triggers \
    blog_system > ${BACKUP_FILE}

# 压缩备份
echo "压缩备份文件..."
gzip ${BACKUP_FILE}

# 删除 30 天前的备份
echo "清理旧备份..."
find ${BACKUP_DIR} -name "*.sql.gz" -mtime +30 -delete

echo "备份完成：${BACKUP_FILE}.gz"
```

**定时任务 (crontab):**
```bash
# 每天凌晨 2 点备份
0 2 * * * /opt/blog-system/backup-mysql.sh >> /var/log/backup-mysql.log 2>&1
```

### 6.2 数据库恢复

```bash
# 1. 解压备份文件
gunzip blog_system_20260312_020000.sql.gz

# 2. 恢复数据
docker compose exec -T mysql mysql -ublog_admin -p${MYSQL_PASSWORD} blog_system < blog_system_20260312_020000.sql
```

---

## 7. 故障处理

### 7.1 常见问题

#### 问题 1: 后端服务无法启动

**现象:**
```bash
docker compose ps backend
# 状态显示为 Exited
```

**排查步骤:**
```bash
# 1. 查看日志
docker compose logs backend

# 2. 检查数据库连接
docker compose exec backend ping mysql

# 3. 检查环境变量
docker compose exec backend env | grep DB

# 4. 重启服务
docker compose restart backend
```

**解决方案:**
```bash
# 重新构建镜像
docker compose build backend

# 清理并重启
docker compose down backend
docker compose up -d backend
```

#### 问题 2: MySQL 连接失败

**现象:**
```
com.mysql.cj.jdbc.exceptions.CommunicationsException: Communications link failure
```

**排查步骤:**
```bash
# 1. 检查 MySQL 容器状态
docker compose ps mysql

# 2. 查看 MySQL 日志
docker compose logs mysql

# 3. 测试连接
docker compose exec mysql mysqladmin ping -uroot -p
```

**解决方案:**
```bash
# 重启 MySQL
docker compose restart mysql

# 检查网络
docker network inspect blog-network
```

#### 问题 3: 磁盘空间不足

**现象:**
```
No space left on device
```

**排查步骤:**
```bash
# 1. 查看磁盘使用
df -h

# 2. 查看 Docker 磁盘使用
docker system df

# 3. 查看日志文件大小
du -sh ./logs/*
```

**解决方案:**
```bash
# 清理 Docker 资源
docker system prune -a

# 清理旧日志
find ./logs -name "*.log" -mtime +7 -delete

# 扩容磁盘（云环境）
```

---

### 7.2 应急预案

#### 预案 1: 服务完全不可用

**处理流程:**
```
1. 确认故障范围（单点/全部）
2. 查看监控告警信息
3. 检查服务器资源（CPU/内存/磁盘）
4. 重启故障服务
5. 如无法恢复，回滚到上一版本
6. 通知相关人员
```

**回滚命令:**
```bash
# 回滚到上一版本镜像
docker compose pull backend:previous
docker compose stop backend
docker compose rm -f backend
docker compose up -d backend
```

#### 预案 2: 数据库故障

**处理流程:**
```
1. 确认数据库状态
2. 尝试重启 MySQL
3. 如无法恢复，从备份恢复数据
4. 通知相关人员
```

**恢复命令:**
```bash
# 重启 MySQL
docker compose restart mysql

# 从备份恢复
gunzip backups/mysql/blog_system_20260312_020000.sql.gz
docker compose exec -T mysql mysql -ublog_admin -p${MYSQL_PASSWORD} blog_system < backups/mysql/blog_system_20260312_020000.sql
```

---

## 8. 性能优化

### 8.1 JVM 优化

**Dockerfile 配置:**
```dockerfile
ENV JAVA_OPTS="-Xms512m -Xmx512m \
  -XX:+UseG1GC \
  -XX:MaxGCPauseMillis=200 \
  -XX:+HeapDumpOnOutOfMemoryError \
  -XX:HeapDumpPath=/app/logs/heapdump.hprof"
```

### 8.2 MySQL 优化

**my.cnf 配置:**
```ini
[mysqld]
# 连接数
max_connections=500

# 缓冲池
innodb_buffer_pool_size=1G
innodb_log_file_size=256M

# 慢查询
slow_query_log=1
slow_query_log_file=/var/log/mysql/slow.log
long_query_time=2
```

### 8.3 Nginx 优化

```nginx
# 工作进程
worker_processes auto;
worker_rlimit_nofile 65535;

events {
    worker_connections 65535;
    use epoll;
    multi_accept on;
}

http {
    # 开启 sendfile
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;

    # Keepalive
    keepalive_timeout 65;
    keepalive_requests 100;

    # 缓冲
    proxy_buffering on;
    proxy_buffer_size 4k;
    proxy_buffers 8 4k;
}
```

---

## 9. 验收标准

### 9.1 部署验收

- [ ] Docker 安装成功
- [ ] MySQL 容器正常运行
- [ ] Redis 容器正常运行
- [ ] 后端服务正常运行
- [ ] 前端服务正常运行
- [ ] Nginx 反向代理正常
- [ ] 网站可以正常访问

### 9.2 功能验收

- [ ] 手机号登录功能正常
- [ ] 文章 CRUD 功能正常
- [ ] Markdown 渲染正常
- [ ] 权限控制正常

### 9.3 性能验收

- [ ] API 响应时间 P95 < 200ms
- [ ] 页面加载时间 < 2s
- [ ] 支持 100 并发用户

---

## 10. 附录

### 10.1 端口清单

| 服务 | 端口 | 协议 | 说明 |
|------|------|------|------|
| Nginx | 80/443 | HTTP/HTTPS | Web 入口 |
| 后端 | 8080 | HTTP | Spring Boot |
| MySQL | 3306 | TCP | 数据库 |
| Redis | 6379 | TCP | 缓存 |

### 10.2 目录结构

```
/opt/blog-system/
├── docker-compose.yml
├── .env
├── deploy.sh
├── health-check.sh
├── backup-mysql.sh
├── mysql/
│   ├── data/
│   └── init/
├── redis/
│   └── data/
├── logs/
│   ├── backend/
│   └── nginx/
├── backups/
│   └── mysql/
└── nginx/
    ├── conf/
    └── ssl/
```

---

**文档结束**
