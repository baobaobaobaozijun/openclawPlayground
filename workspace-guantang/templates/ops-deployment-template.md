# 运维部署文档规范（阿里风格）

**文档状态:** 模板  
**版本:** 1.0  
**创建日期:** 2026-03-12  
**参考:** 阿里巴巴运维文档规范

---

## 📋 文档信息

| 项目 | 值 |
|------|-----|
| 文档名称 | {项目名称} 运维部署文档 |
| 版本号 | v{版本号} |
| 创建人 | {作者姓名} |
| 创建日期 | YYYY-MM-DD |
| 最后更新 | YYYY-MM-DD |
| 运维负责人 | {姓名} |
| 值班群 | {钉钉/飞书群} |

---

## 1. 文档修订记录

| 版本 | 日期 | 修订人 | 修订说明 | 审批人 |
|------|------|--------|----------|--------|
| v1.0 | YYYY-MM-DD | {姓名} | 初始版本 | {姓名} |
| v1.1 | YYYY-MM-DD | {姓名} | 新增监控配置 | {姓名} |

---

## 2. 系统概述

### 2.1 系统架构

```
┌─────────────────────────────────────────────────┐
│                   Nginx                         │
│              (反向代理 + 负载均衡)               │
└───────────────────┬─────────────────────────────┘
                    │
        ┌───────────┼───────────┐
        │           │           │
        ▼           ▼           ▼
   ┌─────────┐ ┌─────────┐ ┌─────────┐
   │ 应用 1   │ │ 应用 2   │ │ 应用 3   │
   │ 8081    │ │ 8082    │ │ 8083    │
   └────┬────┘ └────┬────┘ └────┬────┘
        │           │           │
        └───────────┼───────────┘
                    │
        ┌───────────┴───────────┐
        │                       │
        ▼                       ▼
   ┌─────────┐           ┌─────────┐
   │  MySQL  │           │  Redis  │
   │  3306   │           │  6379   │
   └─────────┘           └─────────┘
```

### 2.2 技术栈

| 组件 | 技术选型 | 版本 | 端口 |
|------|----------|------|------|
| Web 服务器 | Nginx | 1.24+ | 80/443 |
| 应用服务 | Spring Boot | 3.2+ | 8080 |
| 数据库 | MySQL | 8.0+ | 3306 |
| 缓存 | Redis | 7.0+ | 6379 |
| 容器 | Docker | Latest | - |

### 2.3 部署环境

| 环境 | 域名 | IP | 用途 |
|------|------|----|----|
| 开发环境 | dev.example.com | 192.168.1.100 | 开发测试 |
| 测试环境 | test.example.com | 192.168.1.101 | 集成测试 |
| 生产环境 | api.example.com | 10.0.0.100 | 线上服务 |

---

## 3. 部署流程

### 3.1 环境准备

#### 3.1.1 系统要求

| 项目 | 要求 |
|------|------|
| 操作系统 | CentOS 7.9 / Ubuntu 20.04 |
| CPU | 2 核及以上 |
| 内存 | 4GB 及以上 |
| 磁盘 | 50GB 及以上 |
| Docker | 20.10+ |
| Docker Compose | 2.0+ |

#### 3.1.2 安装 Docker

```bash
# CentOS
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker

# Ubuntu
curl -fsSL https://get.docker.com | bash -s docker
sudo systemctl start docker
sudo systemctl enable docker

# 验证安装
docker --version
docker compose version
```

#### 3.1.3 配置 Docker 镜像加速

```bash
# 创建配置文件
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://registry.cn-hangzhou.aliyuncs.com"
  ]
}
EOF

# 重启 Docker
sudo systemctl daemon-reload
sudo systemctl restart docker
```

---

### 3.2 数据库部署

#### 3.2.1 MySQL 部署

**docker-compose.yml:**
```yaml
version: '3.8'
services:
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
      - ./mysql/conf:/etc/mysql/conf.d
      - ./mysql/logs:/var/log/mysql
      - ./mysql/init:/docker-entrypoint-initdb.d
    networks:
      - blog-network
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 5

networks:
  blog-network:
    driver: bridge
```

**初始化脚本 (mysql/init/01-init.sql):**
```sql
-- 创建数据库
CREATE DATABASE IF NOT EXISTS blog_system 
DEFAULT CHARACTER SET utf8mb4 
DEFAULT COLLATE utf8mb4_unicode_ci;

USE blog_system;

-- 创建用户
CREATE USER 'blog_admin'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON blog_system.* TO 'blog_admin'@'%';
FLUSH PRIVILEGES;
```

**部署命令:**
```bash
# 设置环境变量
export MYSQL_ROOT_PASSWORD=your_root_password
export MYSQL_PASSWORD=your_password

# 启动 MySQL
docker compose up -d mysql

# 查看状态
docker compose ps mysql
docker compose logs -f mysql

# 连接测试
docker compose exec mysql mysql -ublog_admin -p blog_system
```

#### 3.2.2 Redis 部署

**docker-compose.yml:**
```yaml
version: '3.8'
services:
  redis:
    image: redis:7.0
    container_name: blog-redis
    restart: always
    command: redis-server --requirepass ${REDIS_PASSWORD}
    ports:
      - "6379:6379"
    volumes:
      - ./redis/data:/data
      - ./redis/conf:/usr/local/etc/redis
    networks:
      - blog-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5
```

**部署命令:**
```bash
# 设置环境变量
export REDIS_PASSWORD=your_redis_password

# 启动 Redis
docker compose up -d redis

# 连接测试
docker compose exec redis redis-cli -a ${REDIS_PASSWORD}
```

---

### 3.3 应用部署

#### 3.3.1 后端部署

**Dockerfile:**
```dockerfile
FROM eclipse-temurin:21-jre-alpine

LABEL maintainer="your-email@example.com"

WORKDIR /app

# 复制 JAR 包
COPY target/blog-system-1.0.0.jar app.jar

# 设置时区
ENV TZ=Asia/Shanghai

# 暴露端口
EXPOSE 8080

# JVM 参数
ENV JAVA_OPTS="-Xms512m -Xmx512m -XX:+UseG1GC"

# 启动命令
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
```

**docker-compose.yml:**
```yaml
version: '3.8'
services:
  backend:
    build:
      context: ../backend
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
      - ./logs:/app/logs
    healthcheck:
      test: ["CMD", "wget", "-q", "--spider", "http://localhost:8080/actuator/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

**部署命令:**
```bash
# 构建镜像
docker compose build backend

# 启动服务
docker compose up -d backend

# 查看日志
docker compose logs -f backend

# 健康检查
curl http://localhost:8080/actuator/health
```

#### 3.3.2 前端部署

**Dockerfile:**
```dockerfile
# 构建阶段
FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --registry=https://registry.npmmirror.com
COPY . .
RUN npm run build

# 生产阶段
FROM nginx:1.24-alpine

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

**nginx.conf:**
```nginx
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

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
    }
}
```

**部署命令:**
```bash
# 构建镜像
docker compose build frontend

# 启动服务
docker compose up -d frontend

# 查看日志
docker compose logs -f frontend
```

---

### 3.4 完整部署

**docker-compose.yml (完整版):**
```yaml
version: '3.8'

services:
  mysql:
    # ... MySQL 配置

  redis:
    # ... Redis 配置

  backend:
    # ... 后端配置

  frontend:
    # ... 前端配置

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
    depends_on:
      - frontend
      - backend
    networks:
      - blog-network
```

**一键部署脚本 (deploy.sh):**
```bash
#!/bin/bash

set -e

echo "================================"
echo "  博客系统一键部署脚本"
echo "================================"

# 加载环境变量
source .env

# 创建必要目录
mkdir -p mysql/data mysql/conf mysql/logs mysql/init
mkdir -p redis/data redis/conf
mkdir -p logs nginx/conf nginx/ssl

# 启动数据库和缓存
echo "启动 MySQL 和 Redis..."
docker compose up -d mysql redis

# 等待服务就绪
echo "等待服务启动..."
sleep 30

# 初始化数据库
echo "初始化数据库..."
docker compose exec -T mysql mysql -uroot -p${MYSQL_ROOT_PASSWORD} < mysql/init/01-init.sql

# 启动应用服务
echo "启动应用服务..."
docker compose up -d backend frontend nginx

# 检查服务状态
echo "检查服务状态..."
docker compose ps

echo "================================"
echo "  部署完成！"
echo "  访问地址：http://$(hostname -I | awk '{print $1}')"
echo "================================"
```

**使用方式:**
```bash
# 赋予执行权限
chmod +x deploy.sh

# 执行部署
./deploy.sh
```

---

## 4. 配置管理

### 4.1 环境变量

**.env 文件:**
```bash
# MySQL
MYSQL_ROOT_PASSWORD=your_root_password
MYSQL_PASSWORD=your_password

# Redis
REDIS_PASSWORD=your_redis_password

# JWT
JWT_SECRET=your_jwt_secret_key

# 应用配置
SPRING_PROFILES_ACTIVE=prod
SERVER_PORT=8080
```

### 4.2 配置文件

**application-prod.yml:**
```yaml
spring:
  datasource:
    url: jdbc:mysql://${DB_HOST:localhost}:${DB_PORT:3306}/${DB_NAME:blog_system}?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai
    username: ${DB_USERNAME:blog_admin}
    password: ${DB_PASSWORD}
    driver-class-name: com.mysql.cj.jdbc.Driver
  redis:
    host: ${REDIS_HOST:localhost}
    port: ${REDIS_PORT:6379}
    password: ${REDIS_PASSWORD}
    database: 0

server:
  port: ${SERVER_PORT:8080}

jwt:
  secret: ${JWT_SECRET}
  expiration: 7200000

logging:
  file:
    name: /app/logs/application.log
  level:
    root: INFO
    com.example.blog: INFO
```

---

## 5. 监控与告警

### 5.1 健康检查

**Spring Boot Actuator 配置:**
```yaml
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
  endpoint:
    health:
      show-details: always
  health:
    db:
      enabled: true
    redis:
      enabled: true
```

**健康检查脚本 (health-check.sh):**
```bash
#!/bin/bash

# 后端健康检查
BACKEND_HEALTH=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/actuator/health)
if [ "$BACKEND_HEALTH" != "200" ]; then
    echo "后端服务异常！HTTP 状态码：$BACKEND_HEALTH"
    exit 1
fi

# MySQL 健康检查
MYSQL_HEALTH=$(docker compose exec -T mysql mysqladmin ping -ublog_admin -p${MYSQL_PASSWORD} 2>&1)
if [[ "$MYSQL_HEALTH" != *"mysqld is alive"* ]]; then
    echo "MySQL 服务异常！"
    exit 1
fi

# Redis 健康检查
REDIS_HEALTH=$(docker compose exec -T redis redis-cli -a ${REDIS_PASSWORD} ping 2>&1)
if [ "$REDIS_HEALTH" != "PONG" ]; then
    echo "Redis 服务异常！"
    exit 1
fi

echo "所有服务健康！"
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

### 5.3 日志收集

**Logback 配置 (logback-spring.xml):**
```xml
<configuration>
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>logs/application.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>logs/application.%d{yyyy-MM-dd}.log</fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>

    <root level="INFO">
        <appender-ref ref="FILE" />
    </root>
</configuration>
```

---

## 6. 备份与恢复

### 6.1 数据库备份

**备份脚本 (backup-mysql.sh):**
```bash
#!/bin/bash

BACKUP_DIR="./backups/mysql"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/blog_system_${DATE}.sql"

# 创建备份目录
mkdir -p ${BACKUP_DIR}

# 执行备份
docker compose exec -T mysql mysqldump -ublog_admin -p${MYSQL_PASSWORD} \
    --single-transaction \
    --routines \
    --triggers \
    blog_system > ${BACKUP_FILE}

# 压缩备份
gzip ${BACKUP_FILE}

# 删除 30 天前的备份
find ${BACKUP_DIR} -name "*.sql.gz" -mtime +30 -delete

echo "备份完成：${BACKUP_FILE}.gz"
```

**定时任务 (crontab):**
```bash
# 每天凌晨 2 点备份
0 2 * * * /path/to/backup-mysql.sh >> /var/log/backup-mysql.log 2>&1
```

### 6.2 数据库恢复

**恢复命令:**
```bash
# 解压备份文件
gunzip blog_system_20260312_020000.sql.gz

# 恢复数据
docker compose exec -T mysql mysql -ublog_admin -p${MYSQL_PASSWORD} blog_system < blog_system_20260312_020000.sql
```

---

## 7. 故障处理

### 7.1 常见问题

#### 问题 1: 后端服务无法启动

**现象:**
```
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
3. 如无法恢复，切换到从库
4. 从备份恢复数据
5. 通知相关人员
```

**主从切换:**
```bash
# 提升从库为主库
docker compose exec mysql-slave mysql -e "STOP SLAVE; RESET SLAVE ALL;"
```

---

## 8. 性能优化

### 8.1 JVM 优化

```bash
# JVM 参数
JAVA_OPTS="-Xms512m -Xmx512m \
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

# 查询缓存
query_cache_size=64M
query_cache_type=1

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

## 9. 安全策略

### 9.1 网络安全

- ✅ 仅暴露必要端口（80/443）
- ✅ 数据库不暴露外网
- ✅ 使用 Docker 网络隔离
- ✅ 配置防火墙规则

### 9.2 数据安全

- ✅ 数据库密码加密存储
- ✅ JWT Token 签名验证
- ✅ HTTPS 加密传输
- ✅ 定期备份数据

### 9.3 访问控制

- ✅ SSH 密钥登录
- ✅ sudo 权限控制
- ✅ 数据库权限最小化
- ✅ API 接口权限验证

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
├── mysql/
│   ├── data/
│   ├── conf/
│   ├── logs/
│   └── init/
├── redis/
│   ├── data/
│   └── conf/
├── logs/
├── backups/
└── nginx/
    ├── conf/
    └── ssl/
```

### 10.3 联系方式

| 角色 | 姓名 | 电话 | 钉钉/飞书 |
|------|------|------|----------|
| 运维负责人 | {姓名} | 138xxxx | xxx |
| 开发负责人 | {姓名} | 139xxxx | xxx |
| 产品负责人 | {姓名} | 137xxxx | xxx |

---

**文档结束**
