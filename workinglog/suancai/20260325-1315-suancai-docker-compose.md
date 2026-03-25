# 2026-03-25 13:15:00 - Docker Compose 配置任务

## 任务概述
- 任务：【PM 灌汤 — 原子任务 🟡 创建 docker-compose.yml】
- 执行人：酸菜
- 完成时间：2026-03-25 13:15

## 修改内容

### 1. 修复 Dockerfile.backend
- 将基础镜像从 `eclipse-temurin:21-jdk-alpine` 改为 `maven:3.9-eclipse-temurin-21-alpine`
- 删除多余步骤，改为 `COPY . .`

### 2. 创建 docker-compose.yml
- 配置 MySQL 8.0 服务，端口 3306，持久化 volume
- 配置 Redis 7.0-alpine 服务，端口 6379
- 配置 backend 服务，构建自 Dockerfile.backend，端口 8080
- 配置 frontend 占位服务，nginx:alpine，端口 80
- 定义 app-network 网络和 mysql-data、redis-data volumes

## 文件变更
- F:\openclaw\code\deploy\Dockerfile.backend (已编辑)
- F:\openclaw\code\deploy\docker-compose.yml (已创建)

## 依赖关系
- backend 服务依赖 mysql 和 redis 服务
- 配置了正确的环境变量连接数据库和 Redis