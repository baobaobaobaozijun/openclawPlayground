# OpenClaw Agent 团队 - Docker 部署指南

## 架构说明

### 运行环境分布

```
┌─────────────────────────────────────────────┐
│  Windows Host (F:\openclaw)                 │
│  ┌─────────────────────────────────────┐   │
│  │ 灌汤 (PM)                            │   │
│  │ 运行：原生 Python/Node.js            │   │
│  │ 位置：f:\openclaw\workspace          │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │ Docker Desktop for Windows           │   │
│  │  ┌───────┐ ┌───────┐ ┌───────┐     │   │
│  │  │酱肉   │ │豆沙   │ │酸菜   │     │   │
│  │  │后端   │ │前端   │ │运维   │     │   │
│  │  │🥩    │ │🍡    │ │🥬    │     │   │
│  │  └───────┘ └───────┘ └───────┘     │   │
│  └─────────────────────────────────────┘   │
└─────────────────────────────────────────────┘
```

## Docker Compose 配置

### docker-compose.yml

```yaml
version: '3.8'

services:
  # 酱肉 - 后端工程师
  jiangrou:
    build:
      context: ./jiangrou
      dockerfile: Dockerfile
    container_name: openclaw-jiangrou
    volumes:
      # 工作日志
      - ../workspace/team/jiangrou/logs:/workspace/logs
      # 任务管理
      - ../workspace/team/jiangrou/tasks:/workspace/tasks
      # 通信目录
      - ../workspace/communication:/workspace/communication
      # 代码目录 (可选)
      - ../code/backend:/workspace/code
    environment:
      - AGENT_NAME=酱肉
      - AGENT_ROLE=backend
      - WORKSPACE=/workspace
      - TZ=Asia/Shanghai
    working_dir: /workspace
    command: ["python", "agent.py"]
    restart: unless-stopped
    networks:
      - openclaw-network
    # 资源限制
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 256M

  # 豆沙 - 前端工程师
  dousha:
    build:
      context: ./dousha
      dockerfile: Dockerfile
    container_name: openclaw-dousha
    volumes:
      # 工作日志
      - ../workspace/team/dousha/logs:/workspace/logs
      # 任务管理
      - ../workspace/team/dousha/tasks:/workspace/tasks
      # 设计稿
      - ../workspace/team/dousha/designs:/workspace/designs
      # 通信目录
      - ../workspace/communication:/workspace/communication
      # 前端代码 (可选)
      - ../code/frontend:/workspace/code
    environment:
      - AGENT_NAME=豆沙
      - AGENT_ROLE=frontend
      - WORKSPACE=/workspace
      - TZ=Asia/Shanghai
    working_dir: /workspace
    command: ["python", "agent.py"]
    restart: unless-stopped
    networks:
      - openclaw-network
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 256M

  # 酸菜 - 运维/测试工程师
  suancai:
    build:
      context: ./suancai
      dockerfile: Dockerfile
    container_name: openclaw-suancai
    volumes:
      # 工作日志
      - ../workspace/team/suancai/logs:/workspace/logs
      # 任务管理
      - ../workspace/team/suancai/tasks:/workspace/tasks
      # 测试脚本
      - ../workspace/team/suancai/tests:/workspace/tests
      # 测试报告
      - ../workspace/team/suancai/reports:/workspace/reports
      # 通信目录
      - ../workspace/communication:/workspace/communication
      # 测试代码
      - ../code/tests:/workspace/tests
    environment:
      - AGENT_NAME=酸菜
      - AGENT_ROLE=devops
      - WORKSPACE=/workspace
      - TZ=Asia/Shanghai
    working_dir: /workspace
    command: ["python", "agent.py"]
    restart: unless-stopped
    networks:
      - openclaw-network
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 128M

networks:
  openclaw-network:
    driver: bridge
```

## 各 Agent 的 Dockerfile

### 酱肉的 Dockerfile (jiangrou/Dockerfile)

```dockerfile
FROM python:3.9-slim

WORKDIR /workspace

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 安装 Python 依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制 Agent 代码
COPY agent.py .

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "print('OK')" || exit 1

CMD ["python", "agent.py"]
```

### 豆沙的 Dockerfile (dousha/Dockerfile)

```dockerfile
FROM node:18-alpine

WORKDIR /workspace

# 安装系统依赖
RUN apk add --no-cache \
    git \
    python3 \
    py3-pip

# 安装前端工具
RUN npm install -g npm latest

# 安装 Python 依赖 (用于 Agent 运行时)
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# 复制 Agent 代码
COPY agent.py .

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python3 -c "print('OK')" || exit 1

CMD ["python3", "agent.py"]
```

### 酸菜的 Dockerfile (suancai/Dockerfile)

```dockerfile
FROM python:3.9-alpine

WORKDIR /workspace

# 安装系统依赖
RUN apk add --no-cache \
    git \
    curl \
    bash

# 安装测试工具
RUN pip install --no-cache-dir \
    pytest \
    pytest-cov \
    locust \
    requests

# 安装 Python 依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制 Agent 代码
COPY agent.py .

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "print('OK')" || exit 1

CMD ["python", "agent.py"]
```

## 快速开始

### 1. 构建所有容器

```bash
cd f:\openclaw\workspace-programmer

# 构建所有服务
docker-compose build

# 或单独构建某个服务
docker-compose build jiangrou
docker-compose build dousha
docker-compose build suancai
```

### 2. 启动所有服务

```bash
# 后台运行
docker-compose up -d

# 查看日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs -f jiangrou
```

### 3. 停止服务

```bash
# 停止所有
docker-compose stop

# 停止特定服务
docker-compose stop jiangrou

# 删除容器 (数据不会丢失，因为使用了挂载卷)
docker-compose down
```

### 4. 重启服务

```bash
# 重启所有
docker-compose restart

# 重启特定服务
docker-compose restart dousha
```

## 日常管理

### 查看容器状态

```bash
# 查看所有容器
docker-compose ps

# 查看详细信息
docker inspect openclaw-jiangrou
```

### 进入容器

```bash
# 进入酱肉的容器
docker exec -it openclaw-jiangrou /bin/bash

# 进入豆沙的容器
docker exec -it openclaw-dousha /bin/sh

# 进入酸菜的容器
docker exec -it openclaw-suancai /bin/bash
```

### 资源监控

```bash
# 查看资源使用
docker stats

# 查看特定容器
docker stats openclaw-jiangrou
```

### 日志管理

```bash
# 查看所有日志
docker-compose logs

# 查看最近 100 行
docker-compose logs --tail=100

# 实时查看
docker-compose logs -f

# 查看特定服务
docker-compose logs jiangrou
```

## 数据持久化

### 挂载卷说明

所有重要数据都通过挂载卷保存在主机上:

**酱肉:**
- `F:\openclaw\workspace\team\jiangrou\logs` → `/workspace/logs`
- `F:\openclaw\workspace\team\jiangrou\tasks` → `/workspace/tasks`

**豆沙:**
- `F:\openclaw\workspace\team\dousha\logs` → `/workspace/logs`
- `F:\openclaw\workspace\team\dousha\designs` → `/workspace/designs`

**酸菜:**
- `F:\openclaw\workspace\team\suancai\logs` → `/workspace/logs`
- `F:\openclaw\workspace\team\suancai\tests` → `/workspace/tests`
- `F:\openclaw\workspace\team\suancai\reports` → `/workspace/reports`

### 备份策略

```bash
# 备份所有数据
tar -czf openclaw-backup-$(date +%Y%m%d).tar.gz \
    workspace/team/*/logs \
    workspace/team/*/tasks \
    workspace/team/dousha/designs \
    workspace/team/suancai/tests \
    workspace/team/suancai/reports
```

## 故障排除

### 容器无法启动

```bash
# 查看详细错误
docker-compose up jiangrou

# 检查 Dockerfile
cat jiangrou/Dockerfile

# 重新构建
docker-compose build --no-cache jianghou
```

### 容器间通信问题

```bash
# 检查网络
docker network ls

# 检查容器是否在同一网络
docker network inspect openclaw-network
```

### 挂载卷权限问题

**Windows 主机:**
```powershell
# 确保目录存在
New-Item -ItemType Directory -Path "F:\openclaw\workspace\team\jiangrou\logs" -Force

# 检查权限
Get-Acl "F:\openclaw\workspace\team\jiangrou\logs" | Format-List
```

### 资源不足

```bash
# 调整资源限制
# 编辑 docker-compose.yml，修改 deploy.resources.limits
```

## 性能优化

### 镜像大小优化

```dockerfile
# 使用多阶段构建
FROM python:3.9 as builder
# ... 构建步骤 ...

FROM python:3.9-slim
# 只复制必要文件
```

### 启动速度优化

```yaml
# 使用命名卷而不是绑定挂载
volumes:
  jiangrou_logs:
  
services:
  jiangrou:
    volumes:
      - jiangrou_logs:/workspace/logs
```

### 内存优化

```yaml
# 根据实际需要调整内存限制
deploy:
  resources:
    limits:
      memory: 128M  # 降低到实际需要
```

---

_Docker 让你的 Agent 团队在隔离、可移植的环境中运行。保持整洁，保持高效。_
