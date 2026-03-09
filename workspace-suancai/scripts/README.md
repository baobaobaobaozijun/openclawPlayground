# 酸菜工作台 - 脚本和工具

## 📁 目录结构

```
workspace-suancai/
├── scripts/          # PowerShell 和 Bash 脚本
│   ├── README.md
│   └── ...
└── guides/           # 使用指南和文档
    ├── README.md
    └── ...
```

---

## 🛠️ Scripts - 自动化脚本

### PowerShell 脚本

#### 1. Docker 环境管理
```powershell
.\scripts\docker-manager.ps1
```
功能：
- 容器启停管理
- 镜像清理
- 网络配置
- 卷管理

#### 2. CI/CD 流水线
```powershell
.\scripts\ci-cd-pipeline.ps1
```
功能：
- 自动化测试
- 构建部署
- 质量检查
- 发布管理

#### 3. 监控和告警
```powershell
.\scripts\monitoring-alerts.ps1
```
功能：
- Prometheus 配置
- Grafana 仪表板
- 告警规则设置
- 日志聚合

---

## 📚 Guides - 使用指南

### 快速入门
- [Docker 基础教程](./guides/docker-basics.md)
- [CI/CD 入门](./guides/cicd-intro.md)
- [监控系统搭建](./guides/monitoring-setup.md)

### 最佳实践
- [DevOps 实践指南](./guides/devops-guide.md)
- [自动化测试策略](./guides/testing-strategy.md)
- [安全加固方案](./guides/security-hardening.md)

### 故障排查
- [常见问题 FAQ](./guides/faq.md)
- [故障诊断流程](./guides/troubleshooting.md)
- [应急响应手册](./guides/incident-response.md)

---

## 🔧 运维工具

### 监控工具
- Prometheus
- Grafana
- ELK Stack

### 部署工具
- Ansible
- Terraform
- Kubernetes

### 测试工具
- Selenium
- JMeter
- SonarQube

---

## 📝 贡献指南

### 添加新脚本

1. 在 `scripts/` 目录创建 `.ps1` 或 `.sh` 文件
2. 添加详细的注释和使用说明
3. 包含错误处理和日志记录
4. 在根目录更新此 README

### 添加新指南

1. 在 `guides/` 目录创建 `.md` 文件
2. 遵循统一的文档格式
3. 提供实际操作步骤
4. 包含故障排查部分

---

## 🎯 脚本列表

| 脚本名称 | 用途 | 执行时间 |
|---------|------|----------|
| docker-manager.ps1 | Docker容器管理 | ~1 分钟 |
| ci-cd-pipeline.ps1 | CI/CD流水线 | ~10 分钟 |
| monitoring-alerts.ps1 | 监控告警配置 | ~5 分钟 |
| backup-database.ps1 | 数据库备份 | ~3 分钟 |
| health-check.ps1 | 健康检查 | ~2 分钟 |

---

*最后更新：2026-03-09*  
*维护者：酸菜 (Suancai)*
