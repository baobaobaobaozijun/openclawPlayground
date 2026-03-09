# 酱肉工作台 - 脚本和工具

## 📁 目录结构

```
workspace-jiangrou/
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

#### 1. 开发环境初始化
```powershell
.\scripts\init-dev-environment.ps1
```
功能：
- 安装 Java 21 JDK
- 配置 Maven
- 设置环境变量
- 安装常用工具

#### 2. 数据库迁移
```powershell
.\scripts\database-migration.ps1
```
功能：
- Flyway/Liquibase 迁移
- 数据备份
- 版本回滚

#### 3. API 测试
```powershell
.\scripts\api-test.ps1
```
功能：
- 运行集成测试
- 生成测试报告
- 性能基准测试

---

## 📚 Guides - 使用指南

### 快速入门
- [开发环境搭建](./guides/dev-environment-setup.md)
- [第一个 Spring Boot 应用](./guides/first-spring-boot-app.md)
- [数据库设计原则](./guides/database-design.md)

### 最佳实践
- [RESTful API 设计规范](./guides/restful-api-guide.md)
- [代码重构技巧](./guides/refactoring-techniques.md)
- [性能优化实战](./guides/performance-optimization.md)

### 故障排查
- [常见问题 FAQ](./guides/faq.md)
- [调试技巧](./guides/debugging-tips.md)
- [生产问题处理](./guides/production-issues.md)

---

## 🔧 自定义脚本模板

### 创建新脚本的模板

```powershell
# Script-Name.ps1
# 描述：脚本功能说明

param(
    [Parameter(Mandatory=$true)]
    [string]$Param1,
    
    [Parameter(Mandatory=$false)]
    [int]$Param2 = 10
)

Write-Host "开始执行..." -ForegroundColor Cyan

try {
    # 主要逻辑
    Write-Host "处理中..." -ForegroundColor Green
} catch {
    Write-Host "发生错误：$_" -ForegroundColor Red
    exit 1
}

Write-Host "执行完成!" -ForegroundColor Green
```

---

## 📝 贡献指南

### 添加新脚本

1. 在 `scripts/` 目录创建 `.ps1` 或 `.sh` 文件
2. 添加详细的注释和使用说明
3. 在根目录更新此 README
4. 测试脚本功能

### 添加新指南

1. 在 `guides/` 目录创建 `.md` 文件
2. 遵循统一的文档格式
3. 提供实际可运行的示例
4. 包含故障排查部分

---

## 🎯 脚本列表

| 脚本名称 | 用途 | 执行时间 |
|---------|------|----------|
| init-dev-environment.ps1 | 初始化开发环境 | ~5 分钟 |
| database-migration.ps1 | 数据库迁移 | ~2 分钟 |
| api-test.ps1 | API 集成测试 | ~3 分钟 |
| build-docker-image.ps1 | 构建 Docker 镜像 | ~8 分钟 |
| deploy-local.ps1 | 本地部署 | ~3 分钟 |

---

*最后更新：2026-03-09*  
*维护者：酱肉 (Jiangrou)*
