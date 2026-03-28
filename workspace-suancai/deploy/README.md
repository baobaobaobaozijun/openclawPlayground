# 部署说明文档

## 服务说明

### Backend 服务
- **容器名称**: backend-service
- **镜像**: openclaw/backend:latest
- **端口**: 8081
- **功能**: 后端 API 服务，连接 MySQL 和 Redis

### Frontend 服务
- **容器名称**: frontend-service
- **镜像**: openclaw/frontend:latest
- **端口**: 80
- **功能**: 前端服务，依赖后端服务

### MySQL 服务
- **容器名称**: mysql-db
- **镜像**: mysql:8.0
- **端口**: 3306
- **功能**: 数据库服务，使用 mysql_data 数据卷持久化数据

### Redis 服务
- **容器名称**: redis-cache
- **镜像**: redis:7-alpine
- **端口**: 6379
- **功能**: 缓存服务，使用 redis_data 数据卷持久化数据

## 启动命令

### 启动所有服务
```bash
docker-compose up -d
```

### 停止所有服务
```bash
docker-compose down
```

### 查看服务状态
```bash
docker-compose ps
```

### 查看服务日志
```bash
docker-compose logs -f
```

## 网络配置
- 所有服务位于 app-network 网桥网络中，可相互通信

## 数据持久化
- MySQL 数据存储在 mysql_data 数据卷
- Redis 数据存储在 redis_data 数据卷