# Docker 与本地灌汤通讯问题诊断报告

**日期:** 2026-03-10  
**发现人:** 鲜肉 (Xianrou)  
**问题:** Docker Compose 启动后无法与本地灌汤进行通讯

---

## 🔍 问题诊断

### 检查的配置

#### 1. Docker Compose 配置

**文件:** `deployment-2026-03-08/docker-compose/docker-compose-agents.yml`

**发现的问题:**
```yaml
services:
  jiangrou:
   container_name: openclaw-instance-1
   ports:
      - "18791:18789"  # ← Docker 18791 → 容器 18789
   environment:
      - INSTANCE_NAME=jiangrou
      - INSTANCE_ROLE=backend-engineer
    # ❌ 缺少 Gateway 连接配置
    volumes:
      - F:\openclaw\agent\workspace-jiangrou:/app/workspace  # ← 酱肉 workspace
```

#### 2. 本地灌汤配置

**文件:** `C:\Users\Administrator\.openclaw\openclaw.json`

**关键配置:**
```json
{
  "gateway": {
    "port": 18789,        // ← 本地灌汤运行在 18789
    "mode": "local",
    "bind": "loopback",   // ← 只绑定本地回环
    "auth": {
      "mode": "token",
      "token": "4aa59ed646303abc8fdeb18147ab277c8f17b2ddff626a39"
    }
  },
  "agents": {
    "list": [
      {
        "id": "programmer",
        "workspace": "F:\\openclaw\\agent\\workspace-guantang",  // ← 灌汤 workspace
        "model": "bailian/qwen3.5-plus"
      }
    ]
  }
}
```

---

## ❌ 发现的三个关键问题

### 问题 1: Workspace 不匹配 🔴

| Agent | Workspace 路径 | 状态 |
|-------|--------------|------|
| **本地灌汤** | `F:\openclaw\agent\workspace-guantang` | ✅ 正在运行 |
| **Docker 酱肉** | `F:\openclaw\agent\workspace-jiangrou` | ✅ 挂载正确 |
| **问题** | ❌ 两者不在同一个 workspace | 🔴 无法通讯 |

**影响:**
- 本地灌汤在管理灌汤的配置
- Docker 酱肉在访问酱肉的配置
- **两者根本不在一个频道上!**

### 问题 2: Gateway 端口隔离 🟡

| 服务 | 端口 | 说明 |
|------|------|------|
| 本地灌汤 Gateway | **18789** | 监听 loopback |
| Docker 酱肉外部端口 | **18791** | 映射到容器 18789 |
| **问题** | ❌ 端口不同，无法直接通讯 | 🔴 需要配置连接 |

**影响:**
- Docker 容器不知道本地灌汤的存在
- 没有配置 Gateway URL 和认证 Token
- 即使想通讯也连不上

### 问题 3: 网络隔离 🔴

**Docker 默认行为:**
- 容器运行在独立的 bridge 网络中
- 无法直接访问宿主机网络
- 需要特殊配置才能访问 `host.docker.internal`

**现状:**
```yaml
networks:
  - openclaw-network:
      driver: bridge  # ← 隔离的网络
# ❌ 没有配置 extra_hosts 访问宿主机
```

---

## 💡 解决方案

### 方案 A: 让 Docker 容器主动连接本地灌汤 ⭐ 推荐

**优点:**
- ✅ 保持本地灌汤作为主 Gateway
- ✅ Docker 容器作为从属节点
- ✅ 符合现有架构设计

**实施步骤:**

#### 1. 修改 docker-compose-agents.yml

添加以下配置到酱肉的服务中:

```yaml
services:
  jiangrou:
    # ... 其他配置 ...
   environment:
      # ⭐ 关键：配置连接到本地灌汤 Gateway
      - OPENCLAW_GATEWAY_URL=http://host.docker.internal:18789
      - OPENCLAW_GATEWAY_TOKEN=4aa59ed646303abc8fdeb18147ab277c8f17b2ddff626a39
    extra_hosts:
      # ⭐ 关键：允许访问宿主机网络
      - "host.docker.internal:host-gateway"
```

#### 2. 修改本地 openclaw.json (可选)

如果需要允许远程连接，修改:

```json
{
  "gateway": {
    "port": 18789,
    "mode": "local",
    "bind": "all",  // ← 改为监听所有接口 (注意安全性)
    "auth": {
      "mode": "token",
      "token": "4aa59ed646303abc8fdeb18147ab277c8f17b2ddff626a39"
    }
  }
}
```

**⚠️ 安全警告:**
- `bind: "all"` 会暴露到局域网
- 仅在受信任的网络中使用
- 或者保持 `bind: "loopback"` 通过 Docker 的 host-gateway 访问

---

### 方案 B: 统一使用同一个 Workspace

**思路:** 让本地灌汤和 Docker 酱肉都使用同一个 workspace

**步骤:**

1. **修改本地 openclaw.json:**
```json
{
  "agents": {
    "list": [
      {
        "id": "programmer",
        "workspace": "F:\\openclaw\\agent\\workspace-jiangrou"  // ← 改为酱肉
      }
    ]
  }
}
```

2. **重启本地灌汤**

3. **Docker 保持不变**

**问题:**
- ❌ 灌汤和酱肉混用同一个 workspace
- ❌ 配置文件会混乱
- ❌ 不推荐这样做

---

### 方案 C: 完全迁移到 Docker

**思路:** 把所有 Agent 都放到 Docker 中运行

**步骤:**

1. **停止本地灌汤**

2. **修改 docker-compose-agents.yml 添加灌汤:**
```yaml
services:
  guantang:
    image: ghcr.io/openclaw/openclaw:latest
   container_name: openclaw-instance-pm
   ports:
      - "18790:18789"
   environment:
      - OPENCLAW_MODEL=bailian/qwen3.5-plus
      - INSTANCE_NAME=guantang
      - INSTANCE_ROLE=pm
    volumes:
      - F:\openclaw\agent\workspace-guantang:/app/workspace
  
  jiangrou:
    # ... 保持不变 ...
```

3. **启动所有容器:**
```bash
docker-compose -f docker-compose-agents.yml up -d
```

**优点:**
- ✅ 环境统一，易于管理
- ✅ 不依赖本地环境
- ✅ 易于扩展

**缺点:**
- ❌ 需要重新配置所有 Agent
- ❌ 失去了本地调试的便利性

---

## 🎯 推荐方案：方案 A

### 完整配置示例

**修改后的 docker-compose-agents.yml:**

```yaml
services:
  jiangrou:
    image: ghcr.io/openclaw/openclaw:latest
   container_name: openclaw-instance-1
   ports:
      - "18791:18789"
   environment:
      - OPENCLAW_MODEL=bailian/qwen3-coder-plus
      - OPENCLAW_API_BASE_URL=https://dashscope.aliyuncs.com/compatible-mode/v1
      - OPENCLAW_API_KEY=sk-0101b7d3672245ac8cd15d454198b4db
      - INSTANCE_NAME=jiangrou
      - INSTANCE_ROLE=backend-engineer
      # ⭐ 连接本地灌汤 Gateway
      - OPENCLAW_GATEWAY_URL=http://host.docker.internal:18789
      - OPENCLAW_GATEWAY_TOKEN=4aa59ed646303abc8fdeb18147ab277c8f17b2ddff626a39
    volumes:
      - openclaw-data-1:/home/node
      - F:\openclaw\code\backend:/app/backend
      - F:\openclaw\agent\workspace-jiangrou:/app/workspace
      - F:\openclaw\workspace\communication:/app/communication
   restart: unless-stopped
   networks:
      - openclaw-network
    extra_hosts:
      # ⭐ 允许访问宿主机
      - "host.docker.internal:host-gateway"
   command: openclaw gateway run
```

### 验证步骤

1. **确保本地灌汤已启动:**
```bash
# 检查灌汤是否在运行
netstat -ano | findstr :18789
```

2. **重启 Docker 容器:**
```bash
cd f:\openclaw\agent\deployment-2026-03-08\docker-compose
docker-compose -f docker-compose-agents.yml down
docker-compose-f docker-compose-agents.yml up -d
```

3. **测试连接:**
```bash
# 从容器内测试能否访问宿主机
docker exec -it openclaw-instance-1 ping host.docker.internal
```

4. **检查日志:**
```bash
docker logs -f openclaw-instance-1
```

---

## 📊 配置对比表

| 配置项 | 本地灌汤 | Docker 酱肉 (修复前) | Docker 酱肉 (修复后) |
|--------|---------|------------------|------------------|
| Workspace | `workspace-guantang` | `workspace-jiangrou` | `workspace-jiangrou` |
| Gateway Port | 18789 | 未配置 | 18789 (通过 URL) |
| Gateway Token | 有 | 未配置 | 有 |
| 网络连接 | Loopback | 隔离 | host-gateway |
| 能否通讯 | - | ❌ 不能 | ✅ 能 |

---

## 🔧 故障排查

### 如果仍然无法通讯:

1. **检查防火墙:**
```powershell
# Windows 防火墙可能阻止了 Docker
Get-NetFirewallRule | Where-Object {$_.DisplayName -like "*Docker*"}
```

2. **检查 Docker 网络:**
```bash
docker network inspect openclaw-network
```

3. **测试宿主机连通性:**
```bash
# 在宿主机上测试
telnet localhost 18789
```

4. **检查 Token 是否正确:**
```bash
# 从 openclaw.json 中确认 token
cat /c/Users/Administrator/.openclaw/openclaw.json | jq '.gateway.auth.token'
```

---

## 📝 后续优化建议

### 短期 (本周)
- [x] 发现问题并诊断
- [ ] 应用方案 A 修复
- [ ] 验证连接成功
- [ ] 记录到工作日志

### 中期 (本月)
- [ ] 编写自动化脚本检测配置
- [ ] 建立配置检查清单
- [ ] 培训所有 Agent 遵守规范

### 长期 (持续)
- [ ] 考虑完全容器化部署
- [ ] 建立监控和告警
- [ ] 定期演练故障恢复

---

**状态:** 🔴 问题已诊断，等待修复  
**优先级:** 🔴 高优先级  
**负责人:** 待分配  
**预计修复时间:** 10-15 分钟
