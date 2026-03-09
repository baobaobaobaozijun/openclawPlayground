# OpenClaw 集群启动指南

## 🚀 快速启动

### 方法 1: 使用启动脚本（推荐）

```powershell
cd F:\openclaw\agent\scripts
.\Start-OpenClawCluster.ps1
```

脚本会自动：
1. ✅ 检查 Docker Desktop 状态
2. ⏳ 等待 Docker 就绪
3. 🔍 验证 Docker Compose 配置
4. 🎯 启动所有 Agent 实例

### 方法 2: 手动启动

```powershell
# 1. 启动 Docker Desktop
"Docker Desktop.exe"

# 2. 等待 Docker 就绪（约 30-60 秒）
docker ps

# 3. 进入配置目录
cd F:\openclaw\agent\deployment-2026-03-08\docker-compose

# 4. 启动集群
docker-compose -f docker-compose-agents.yml up -d
```

---

## 📊 集群配置

### Agent 实例

| 名称 | 角色 | 端口 | 技术栈 |
|------|------|------|--------|
| **jiangrou** | 后端工程师 | 18791 | Java + Spring Boot |
| **dousha** | 前端工程师 | 18792 | Vue + TypeScript |
| **suancai** | 运维工程师 | 18793 | DevOps + Testing |

### 挂载路径

每个 Agent 挂载：
- **Workspace**: `F:\openclaw\agent\workspace-{name}:/app/workspace`
- **Code**: `F:\openclaw\code\{type}:/app/{type}`
- **Data Volume**: Docker 卷管理

---

## 🔍 常用命令

### 查看状态

```bash
# 查看所有容器状态
docker-compose -f docker-compose-agents.yml ps

# 查看详细信息
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

### 查看日志

```bash
# 查看所有日志
docker-compose -f docker-compose-agents.yml logs -f

# 查看特定 Agent 日志
docker-compose -f docker-compose-agents.yml logs -f jiangrou
docker-compose -f docker-compose-agents.yml logs -f dousha
docker-compose -f docker-compose-agents.yml logs -f suancai
```

### 重启容器

```bash
# 重启单个容器
docker-compose -f docker-compose-agents.yml restart jiangrou

# 重启所有容器
docker-compose -f docker-compose-agents.yml restart
```

### 停止集群

```bash
# 停止所有容器
docker-compose -f docker-compose-agents.yml down

# 停止并删除数据卷
docker-compose -f docker-compose-agents.yml down -v
```

---

## ⚠️ 故障排查

### 问题 1: Docker Desktop 无法启动

**症状:**
```
error during connect: Get "http://%2F%2F.%2Fpipe%2FdockerDesktopLinuxEngine/v1.51/containers/json": 
open //./pipe/dockerDesktopLinuxEngine: The system cannot find the file specified.
```

**解决方案:**
1. 确保 Docker Desktop 已完全启动（等待 30-60 秒）
2. 检查系统托盘是否有 Docker 图标
3. 重启 Docker Desktop
4. 检查 Windows 功能中是否启用了 Hyper-V

### 问题 2: 镜像拉取失败

**症状:**
```
unable to get image 'ghcr.io/openclaw/openclaw:latest'
```

**解决方案:**
```bash
# 手动拉取镜像
docker pull ghcr.io/openclaw/openclaw:latest

# 如果拉取失败，检查网络连接
# 可能需要配置代理或使用国内镜像源
```

### 问题 3: 端口冲突

**症状:**
```
Error starting userland proxy: listen tcp4 0.0.0.0:18791: bind: address already in use
```

**解决方案:**
```bash
# 查找占用端口的进程
netstat -ano | findstr :18791

# 终止占用进程
taskkill /PID <进程 ID> /F

# 或者修改 docker-compose-agents.yml 中的端口映射
```

### 问题 4: 挂载路径不存在

**症状:**
```
invalid mount config for type "bind": bind source path does not exist
```

**解决方案:**
```bash
# 检查目录是否存在
Test-Path "F:\openclaw\agent\workspace-jiangrou"
Test-Path "F:\openclaw\code\backend"

# 如果目录不存在，创建它们
mkdir F:\openclaw\agent\workspace-jiangrou
mkdir F:\openclaw\code\backend
```

---

## 🎯 验证启动成功

### 1. 检查容器状态

```bash
docker-compose -f docker-compose-agents.yml ps
```

**预期输出:**
```
NAME                     STATUS         PORTS
openclaw-instance-1      Up (healthy)   0.0.0.0:18791->18789/tcp
openclaw-instance-2      Up (healthy)   0.0.0.0:18792->18789/tcp
openclaw-instance-3      Up (healthy)   0.0.0.0:18793->18789/tcp
```

### 2. 测试 API 端点

```bash
# 访问每个 Agent 的健康检查端点
curl http://localhost:18791/health
curl http://localhost:18792/health
curl http://localhost:18793/health
```

### 3. 查看 workspace 挂载

```bash
# 进入容器查看 workspace 文件
docker exec openclaw-instance-1 ls -la /app/workspace
docker exec openclaw-instance-2 ls -la /app/workspace
docker exec openclaw-instance-3 ls -la /app/workspace
```

应该能看到 IDENTITY.md, ROLE.md, SOUL.md 等文件。

---

## 📝 性能优化

### 1. 资源限制

在 `docker-compose-agents.yml` 中添加：

```yaml
services:
  jiangrou:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
        reservations:
          cpus: '1'
          memory: 1G
```

### 2. 日志轮转

添加日志配置防止磁盘占用过大：

```yaml
services:
  jiangrou:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

### 3. 健康检查

确保容器真正可用：

```yaml
services:
  jiangrou:
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:18789/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

---

## 🔐 安全建议

### 1. API 密钥管理

不要将 API 密钥硬编码在配置文件中：

```bash
# 使用环境变量
echo "OPENCLAW_API_KEY=your-key-here" >> .env
```

在 `docker-compose-agents.yml` 中引用：
```yaml
environment:
  OPENCLAW_API_KEY: ${OPENCLAW_API_KEY}
```

### 2. 网络隔离

如果不需要外部访问，可以限制网络：

```yaml
networks:
  openclaw-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
```

---

## 📞 需要帮助？

查看详细文档：
- [Docker 部署指南](../workspace-guantang/guides/docker-deployment-guide.md)
- [架构文档](../ARCHITECTURE.md)
- [工作空间说明](../workspace-guantang/README.md)

---

*最后更新：2026-03-09*  
*版本：1.0*
