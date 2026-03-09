<!-- Last Modified: 2026-03-09 -->
<!-- Last Modified (CN): 2026-03-09 -->

# TOOLS.md - 本地笔记

## 📁 权限边界

**⚠️ 重要：写操作限制**

| 路径 | 权限 | 说明 |
|------|------|------|
| `F:\openclaw\agent\workspace-suancai\*` | ✅ 可写 | 我的工作空间 |
| `F:\openclaw\code\deploy\*` | ✅ 可写 | 部署配置目录 |
| `F:\openclaw\code\tests\*` | ✅ 可写 | 测试代码目录 |
| `F:\openclaw\agent\workspace-*\*` | ⚠️ 只读 | 其他 Agent 工作空间 |
| `F:\openclaw\code\backend\*` | ❌ 只读 | 后端代码 |
| `F:\openclaw\code\frontend\*` | ❌ 只读 | 前端代码 |
| `C:\*` | ❌ 禁止 | 系统目录 |
| 其他所有路径 | ❌ 只读 | 外部数据 |

---

## 🏢 Agent 工作空间配置

### 酸菜 (运维工程师) 🥬
- **Workspace**: `F:\openclaw\agent\workspace-suancai`
- **Code**: `F:\openclaw\code\deploy` + `F:\openclaw\code\tests`
- **Docker 挂载**: `/app/workspace` + `/app/deploy` + `/app/tests`
- **端口**: `18793` (容器映射)
- **职责**: 
  - Docker 容器化部署和管理
  - CI/CD 流水线设计和维护
  - 系统监控和告警
  - 自动化测试（单元、集成、E2E、性能）
  - 基础设施即代码 (IaC)

### 技术栈详情

**DevOps 工具链:**
- Docker & Docker Compose
- Kubernetes (可选)
- Jenkins / GitHub Actions
- Prometheus + Grafana
- ELK Stack

**测试框架:**
- JUnit 5 (Java 单元测试)
- Testcontainers (集成测试)
- Mockito (Mock 框架)
- Gatling (性能测试)
- Playwright (E2E 测试)

**监控与日志:**
- Prometheus 2.x (指标监控)
- Grafana 10.x (可视化)
- ELK Stack 8.x (日志分析)
- Alertmanager (告警管理)

### 酱肉 (后端工程师) 🍖
- **Workspace**: `F:\openclaw\agent\workspace-jiangrou`
- **Code**: `F:\openclaw\code\backend`
- **技术栈**: Java 21 + Spring Boot 3.2+ + MySQL 8.0+ + Redis 7.0+

### 豆沙 (前端工程师) 🍡
- **Workspace**: `F:\openclaw\agent\workspace-dousha`
- **Code**: `F:\openclaw\code\frontend`
- **技术栈**: Vue 3 + TypeScript + Vite

### 灌汤 (产品经理) 🍲
- **Workspace**: `F:\openclaw\agent\workspace-guantang`
- **职责**: 产品规划、需求分析、任务分配、进度跟踪

---

## 🛠️ 我的 Skills

### 1. working-logger 📝

**用途:** 记录对 `F:\openclaw\agent\workspace-suancai` 的所有修改

**日志位置:** `F:\openclaw\agent\workspace-suancai\logs\`

**文件名格式:** `daily_YYYYMMDD.md`

### 2. auto-github-push 🚀

**用途:** 自动推送代码到 GitHub

**仓库:** https://github.com/baobaobaobaozijun/openclawPlayground

**触发时机:** 每次修改完 workspace-suancai 文件夹后

---

## 📡 Agent 通信

### 收件箱路径

| Agent | 收件箱 |
|-------|--------|
| 酸菜 | `F:\openclaw\agent\workspace-suancai\communication\inbox\suancai\` |
| 酱肉 | `F:\openclaw\agent\workspace-jiangrou\communication\inbox\jiangrou\` |
| 豆沙 | `F:\openclaw\agent\workspace-dousha\communication\inbox\dousha\` |
| 灌汤 | `F:\openclaw\agent\workspace-guantang\communication\inbox\guantang\` |

### 消息格式

```json
{
  "from": "suancai",
  "to": "{agent}",
  "action": "{action}",
  "data": {},
  "timestamp": "ISO8601"
}
```

### 常见通信场景

**与酱肉协作:**
- API 性能监控和调优建议
- 数据库慢查询分析和优化
- 应用日志收集和排查
- 健康检查端点配置

**与豆沙协作:**
- 前端性能监控（FCP、LCP 等）
- 错误追踪和告警配置
- CDN 和缓存策略
- Source Map 管理

**与灌汤协作:**
- 项目进度报告
- 资源需求和容量规划
- 风险评估和应对方案
- 上线计划和回滚方案

---

## 🔧 常用命令

```bash
# Docker 相关
docker ps                    # 查看运行中的容器
docker images                # 查看镜像
docker-compose up -d         # 启动所有服务
docker-compose down          # 停止所有服务
docker-compose logs -f       # 查看日志

# Kubernetes 相关
kubectl get pods             # 查看 Pod 状态
kubectl get services         # 查看服务
kubectl describe pod <name>  # 查看 Pod 详情
kubectl logs <pod-name>      # 查看日志

# 测试相关
cd F:\openclaw\code\tests
mvn test                     # 运行 Maven 测试
npm run test                 # 运行前端测试

# 监控相关
curl http://localhost:9090/metrics    # Prometheus 指标
curl http://localhost:3000/api/health # Grafana 健康检查

# GitHub 认证
gh auth login

# 检查 git 状态
cd F:\openclaw\agent\workspace-suancai && git status

# 手动推送
cd F:\openclaw\agent\workspace-suancai && git add . && git commit-m "message" && git push

# 安装 skill
cd F:\openclaw\agent\workspace-suancai
npx clawhub install <skill-name>
```

---

## 📊 系统监控指标

### 关键指标

**应用层面:**
- API 响应时间 (P95 < 200ms)
- API 错误率 (< 0.1%)
- JVM 内存使用率 (< 80%)
- GC 暂停时间 (< 100ms)

**数据库层面:**
- MySQL 连接池使用率 (< 80%)
- 慢查询数量 (< 10/分钟)
- 主从延迟 (< 1 秒)
- 锁等待时间

**缓存层面:**
- Redis 内存使用率 (< 75%)
- 缓存命中率 (> 90%)
- Key 过期数量
- 连接数使用

**系统层面:**
- CPU 使用率 (< 70%)
- 内存使用率 (< 80%)
- 磁盘使用率 (< 85%)
- 网络带宽使用

### 告警阈值

| 指标 | 警告 | 严重 |
|------|------|------|
| CPU 使用率 | > 70% | > 90% |
| 内存使用率 | > 80% | > 95% |
| 磁盘使用率 | > 85% | > 95% |
| API 错误率 | > 1% | > 5% |
| API 响应时间 P95 | > 300ms | > 1000ms |

---

## 🎯 CI/CD 流水线

### 构建阶段

1. **代码 checkout**
2. **依赖安装** - Maven/npm install
3. **代码编译** - Maven/npm build
4. **单元测试** - JUnit/Jest
5. **代码质量扫描** - SonarQube
6. **构建 Docker 镜像**
7. **推送镜像到 Registry**

### 部署阶段

1. **拉取最新镜像**
2. **执行数据库迁移** - Flyway
3. **滚动更新容器**
4. **健康检查**
5. **流量切换**
6. **旧版本保留（用于回滚）**

### 回滚机制

- 保留最近 3 个版本
- 一键回滚脚本
- 数据库向下兼容
- 快速失败和自动回滚

---

*最后更新：2026-03-09*  
*维护者：酸菜 (Suancai)*
