# 任务分配：CI/CD 配置开始

**任务 ID:** TASK-018  
**分配时间:** 2026-03-18 09:00  
**负责人:** 酸菜 (Suancai) 🥬  
**优先级:** 🟡 中  
**截止时间:** 2026-03-18 20:00 (11 小时)

---

## 📋 任务描述

配置 GitHub Actions CI/CD 流水线，实现自动构建、测试、部署

**前置任务:** TASK-005 Docker 环境配置完成 (14:00 截止)

---

## 🎯 任务目标

### GitHub Actions 工作流
1. **CI 流水线**
   - [ ] 代码 checkout
   - [ ] 依赖安装
   - [ ] 代码编译
   - [ ] 单元测试
   - [ ] 代码质量检查

2. **CD 流水线**
   - [ ] Docker 镜像构建
   - [ ] 镜像推送
   - [ ] 自动部署

3. **触发条件**
   - [ ] Push 到 main 分支触发
   - [ ] Pull Request 触发 CI
   - [ ] Tag 发布触发 CD

---

## 📐 技术实现

### .github/workflows/ci.yml 模板
```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  backend-test:
    runs-on: ubuntu-latest
    
    services:
      mysql:
        image: mysql:8.0
        env:
          MYSQL_ROOT_PASSWORD: test123
          MYSQL_DATABASE: blog_test
        options: >-
          --health-cmd="mysqladmin ping"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=3
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up JDK 21
        uses: actions/setup-java@v3
        with:
          java-version: '21'
          distribution: 'temurin'
      
      - name: Build with Maven
        run: mvn clean compile
      
      - name: Run tests
        run: mvn test
        env:
          DB_HOST: localhost
          DB_PORT: 3306
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: target/site/jacoco/jacoco.xml

  frontend-build:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Build
        run: npm run build
      
      - name: Run tests
        run: npm test

  docker-build:
    needs: [backend-test, frontend-build]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Login to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
      
      - name: Build and push backend
        uses: docker/build-push-action@v4
        with:
          context: ./code/backend
          push: true
          tags: ${{ secrets.DOCKER_USERNAME }}/blog-backend:latest
      
      - name: Build and push frontend
        uses: docker/build-push-action@v4
        with:
          context: ./code/frontend
          push: true
          tags: ${{ secrets.DOCKER_USERNAME }}/blog-frontend:latest
```

---

## ✅ 验收标准

1. **CI 配置:** GitHub Actions 工作流文件创建完成
2. **测试通过:** CI 流水线能够成功运行
3. **镜像构建:** Docker 镜像能够成功构建和推送
4. **文档完整:** README.md 包含 CI/CD 使用说明
5. **工作日志:** 按标准模板记录

---

## 📝 工作日志要求

**必须记录到:** `F:\openclaw\agent\workinglog\suancai\`

**文件名格式:** `YYYYMMDD-HHMMSS-suancai-TASK-018-CI-CD 配置.md`

**⚠️ 日志格式要求:**
```markdown
## 修改信息
- **修改人:** 酸菜
- **修改时间:** 2026-03-18 HH:mm:ss
- **任务类型:** config

## 任务内容
TASK-018: CI/CD 配置开始

## 修改的文件
- `.github/workflows/ci.yml` - CI/CD 工作流配置
- `README.md` - 使用说明

## 关联通知
- [x] 已通知 PM 任务进度
- [ ] 已推送到 GitHub
```

---

## 🔗 相关文档

- [站会纪要](../../doc/meetings/daily-standup-20260318-0900.md)
- [部署说明](../../doc/deploy/cicd-setup.md)

---

**确认收到请回复:**
1. 已阅读任务详情
2. 已知晓 TASK-005 完成后开始
3. 预计完成时间（20:00 前）

---
灌汤 | PM 🍲
