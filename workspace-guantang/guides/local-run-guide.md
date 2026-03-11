<!-- Last Modified: 2026-03-12 -->

# 本地化运行指南

**适用对象:** 所有开发者  
**最后更新:** 2026-03-12  
**架构模式:** 单 Gateway 多 Agent  

---

## 📋 什么是本地化运行？

### 架构特点

**传统 Docker 模式（已废弃）:**
```
❌ Docker Desktop (占用~100MB)
   └── openclaw-gateway 容器
       └── Agent 1, Agent 2, Agent 3...
```

**本地化运行模式（当前）:**
```
✅ 单个 Gateway 进程 (~600MB)
   ├── Agent 1 (灌汤 - PM)
   ├── Agent 2 (酱肉 - 后端)
   ├── Agent 3 (豆沙 - 前端)
   └── Agent 4 (酸菜 - 运维)
```

### 核心优势

| 特性 | Docker 模式 | 本地化模式 | 改进 |
|------|------------|-----------|-----|
| **内存占用** | ~1.2GB | ~600MB | ✅ **-50%** |
| **启动时间** | ~30 秒 | ~5 秒 | ✅ **快 6 倍** |
| **通信延迟** | ~50ms | ~2ms | ✅ **快 25 倍** |
| **依赖复杂度** | 高（需 Docker） | 低（只需 JDK/Node） | ✅ **简化** |
| **调试难度** | 困难 | 简单 | ✅ **容易** |

---

## 🚀 快速开始

### 前置条件

#### 必需环境

```bash
# Java 21 (后端和 Gateway)
java -version
# 应显示：java version "21.x.x"

# Node.js 18+ (前端)
node -v
# 应显示：v18.x.x 或更高

# MySQL 8.0+ (数据库)
mysql --version
# 应显示：mysql  Ver 8.0.x
```

#### 可选工具

```bash
# PM2 (进程管理，推荐安装)
npm install -g pm2

# Maven 3.9+ (后端构建)
mvn -version
```

---

## 📦 安装步骤

### 步骤 1: 安装 OpenClaw CLI

```bash
# 全局安装 OpenClaw
npm install -g @openclaw/cli

# 验证安装
openclaw --version
```

### 步骤 2: 配置环境变量

创建 `.env` 文件（项目根目录）:

```bash
# Gateway 配置
OPENCLAW_GATEWAY_PORT=18789
OPENCLAW_GATEWAY_HOST=localhost

# 数据库配置
DB_HOST=localhost
DB_PORT=3306
DB_NAME=baozipu_blog
DB_USER=root
DB_PASSWORD=your_password

# API 密钥（根据需要使用）
QWEN_API_KEY=sk-xxxxxxxxx
```

### 步骤 3: 初始化数据库

```bash
# 登录 MySQL
mysql -u root -p

# 创建数据库
CREATE DATABASE baozipu_blog CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# 导入表结构（待创建）
# source code/backend/src/main/resources/schema.sql
```

---

## ▶️ 启动 Gateway

### 方式 1: 直接启动（开发环境）

```bash
# 在项目根目录执行
cd f:\openclaw

# 启动 Gateway
openclaw gateway

# 或使用 npx
npx @openclaw/cli gateway
```

**启动日志示例:**
```
[INFO] OpenClaw Gateway 正在启动...
[INFO] 加载配置文件：f:\openclaw\.env
[INFO] 连接数据库：localhost:3306/baozipu_blog
[INFO] 启动 Agent: 灌汤 (PM)
[INFO] 启动 Agent: 酱肉 (后端)
[INFO] 启动 Agent: 豆沙 (前端)
[INFO] 启动 Agent: 酸菜 (运维)
[INFO] Gateway 启动完成！
[INFO] 访问地址：http://localhost:18789
```

---

### 方式 2: 使用 PM2 管理（生产环境推荐）

```bash
# 启动并命名
pm2 start openclaw --name "baozipu"

# 查看状态
pm2 status

# 查看日志
pm2 logs baozipu

# 重启
pm2 restart baozipu

# 停止
pm2 stop baozipu

# 开机自启
pm2 startup
pm2 save
```

**PM2 配置文件** (`ecosystem.config.js`):

```javascript
module.exports = {
  apps: [{
    name: 'baozipu',
    script: 'openclaw',
    args: 'gateway',
    cwd: 'f:\\openclaw',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'production'
    }
  }]
};
```

---

## 🔧 配置说明

### Gateway 配置

**配置文件位置:** `agent/workspace-guantang/.openclaw/workspace-state.json`

```json
{
  "gateway": {
    "port": 18789,
    "host": "localhost",
    "allowInsecureAuth": true,
    "maxAgents": 10
  },
  "agents": [
    {
      "name": "灌汤",
      "role": "PM",
      "workspace": "workspace-guantang",
      "enabled": true
    },
    {
      "name": "酱肉",
      "role": "Backend",
      "workspace": "workspace-jiangrou",
      "enabled": true
    },
    {
      "name": "豆沙",
      "role": "Frontend",
      "workspace": "workspace-dousha",
      "enabled": true
    },
    {
      "name": "酸菜",
      "role": "DevOps",
      "workspace": "workspace-suancai",
      "enabled": true
    }
  ]
}
```

### Agent 通信配置

**进程内通信（IPC）:**
- **延迟:** ~2ms
- **协议:** 内部消息总线
- **无需网络:** 纯本地内存通信

**消息格式:**
```json
{
  "from": "jiangrou",
  "to": "dousha",
  "type": "API_CHANGE",
  "content": {
    "endpoint": "/api/users",
    "method": "POST",
    "changes": ["新增 email 字段"]
  },
  "timestamp": "2026-03-12T10:30:00Z"
}
```

---

## 📊 监控与诊断

### 查看运行状态

```bash
# Gateway 健康检查
curl http://localhost:18789/health

# 返回示例
{
  "status": "UP",
  "timestamp": "2026-03-12T10:30:00Z",
  "agents": {
    "灌汤": "ACTIVE",
    "酱肉": "ACTIVE",
    "豆沙": "ACTIVE",
    "酸菜": "ACTIVE"
  },
  "uptime": "2h 15m 30s"
}
```

### 查看资源占用

```bash
# Windows PowerShell
Get-Process | Where-Object {$_.ProcessName -like "*openclaw*"} | 
  Select-Object ProcessName, CPU, WorkingSet

# Linux/Mac
ps aux | grep openclaw
```

**典型资源占用:**
- **CPU:** 5-15% (空闲时)
- **内存:** 500-700MB
- **磁盘 I/O:** 低

---

## 🐛 故障排查

### 问题 1: Gateway 无法启动

**症状:**
```
Error: Port 18789 is already in use
```

**解决方案:**
```bash
# 查找占用端口的进程
netstat -ano | findstr :18789

# 杀死进程
taskkill /PID <PID> /F

# 或修改端口
# 编辑 .env 文件，更改 OPENCLAW_GATEWAY_PORT
```

---

### 问题 2: Agent 无法连接数据库

**症状:**
```
[ERROR] 数据库连接失败：Access denied for user 'root'@'localhost'
```

**解决方案:**
1. 检查 `.env` 文件中的数据库密码
2. 确认 MySQL 服务正在运行
3. 验证数据库权限

```bash
# 测试数据库连接
mysql -u root -p -e "SHOW DATABASES;"
```

---

### 问题 3: Agent 间通信失败

**症状:**
```
[WARNING] Agent 通信超时
```

**解决方案:**
```bash
# 检查 workspace-state.json 配置
# 确保所有 Agent的 enabled 为 true

# 重启 Gateway
pm2 restart baozipu

# 查看详细日志
pm2 logs baozipu --lines 100
```

---

## 🔄 日常运维

### 启动流程

```bash
# 1. 启动数据库
net start MySQL80  # Windows
# 或
sudo systemctl start mysql  # Linux

# 2. 启动 Gateway
pm2 start baozipu

# 3. 验证状态
curl http://localhost:18789/health
```

### 停止流程

```bash
# 1. 停止 Gateway
pm2 stop baozipu

# 2. 停止数据库（可选）
net stop MySQL80
```

### 更新流程

```bash
# 1. 拉取最新代码
git pull origin main

# 2. 停止服务
pm2 stop baozipu

# 3. 重新编译（如需要）
cd code/backend
mvn clean package

cd ../frontend
npm install && npm run build

# 4. 重启服务
pm2 restart baozipu

# 5. 验证
curl http://localhost:18789/health
```

---

## 📈 性能优化

### JVM 调优

编辑启动参数:

```bash
# 限制堆内存为 600MB
JAVA_OPTS="-Xms600m -Xmx600m -XX:+UseG1GC -XX:MaxGCPauseMillis=200"

# 添加到 .env 或启动脚本
```

### 数据库优化

**MySQL 配置** (`my.cnf` 或 `my.ini`):

```ini
[mysqld]
# 内存限制（2G 服务器）
innodb_buffer_pool_size = 256M
max_connections = 50
query_cache_size = 32M

# 慢查询日志
slow_query_log = 1
long_query_time = 2
```

---

## 🎯 最佳实践

### 开发环境

```bash
# 使用热重载
openclaw gateway --watch

# 启用调试模式
export DEBUG=openclaw:*
openclaw gateway
```

### 生产环境

```bash
# 使用 PM2 集群模式（多核 CPU）
pm2 start openclaw -i max --name "baozipu-cluster"

# 启用日志轮转
pm2 install pm2-logrotate
pm2 set pm2-logrotate:max_size 10M
pm2 set pm2-logrotate:retain 7
```

---

## 📞 需要帮助？

### 相关文档

- **[快速启动指南](./quick-start.md)** - 新手入门
- **[架构设计](../../doc/ARCHITECTURE-LITE.md)** - 轻量级架构
- **[错误监控](./specs/03-technical-specs/agent-error-monitoring.md)** - 故障处理

### 联系支持

- **Gateway 问题:** 联系灌汤 (PM)
- **后端问题:** 联系酱肉 (后端)
- **前端问题:** 联系豆沙 (前端)
- **部署问题:** 联系酸菜 (运维)

---

## ✅ 检查清单

启动 Gateway 前，确保：

- [ ] Java 21 已安装并配置
- [ ] Node.js 18+ 已安装
- [ ] MySQL 8.0+ 正在运行
- [ ] `.env` 配置文件已创建
- [ ] 数据库已创建并授权
- [ ] 端口 18789 未被占用

---

**祝你使用愉快！** 🥟✨

**维护者:** 灌汤 PM + 酱肉 + 酸菜  
**最后更新:** 2026-03-12
