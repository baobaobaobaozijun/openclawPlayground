# OpenClaw Tests - 测试脚本

🥬 **酸菜的测试工作目录**

---

## 📁 目录结构

```
tests/
├── README.md              # 本文件
├── unit/                  # 单元测试
│   ├── backend/          # 后端单元测试
│   └── frontend/         # 前端单元测试
├── integration/           # 集成测试
│   ├── api/              # API 集成测试
│   └── database/         # 数据库集成测试
├── performance/           # 性能测试
│   ├── load/             # 负载测试
│   └── stress/           # 压力测试
├── e2e/                   # E2E 测试
│   └── scenarios/        # 测试场景
└── scripts/               # 测试脚本
    ├── run-tests.sh      # 运行测试脚本
    └── report.sh         # 生成报告
```

---

## 🚀 快速开始

### 运行所有测试

```bash
# 1. 进入目录
cd F:\openclaw\code\tests

# 2. 运行测试脚本
.\scripts\run-tests.ps1

# 或 Linux/Mac
./scripts/run-tests.sh
```

---

## 🧪 测试类型

### 单元测试 (Unit Tests)

**后端单元测试:**
```bash
cd backend
mvn test
```

**前端单元测试:**
```bash
cd frontend
npm run test:unit
```

### 集成测试 (Integration Tests)

**API 集成测试:**
```bash
cd integration/api
pytest test_articles.py -v
```

**数据库集成测试:**
```bash
cd integration/database
pytest test_database.py -v
```

### 性能测试 (Performance Tests)

**负载测试:**
```bash
cd performance/load
locust -f load_test.py --host=http://localhost:8080
```

**压力测试:**
```bash
cd performance/stress
jmeter -n -t stress_test.jmx
```

### E2E 测试 (End-to-End)

```bash
cd e2e
npm run test:e2e
```

---

## 📊 测试报告

### 生成覆盖率报告

**后端:**
```bash
cd backend
mvn jacoco:report
```

**前端:**
```bash
cd frontend
npm run test:unit -- --coverage
```

### 查看报告

- **后端覆盖率:** `backend/target/site/jacoco/index.html`
- **前端覆盖率:** `frontend/coverage/index.html`
- **性能报告:** `performance/reports/`
- **E2E 报告:** `e2e/reports/`

---

## 🎯 质量指标

### 覆盖率要求
- **行覆盖率:** ≥ 80%
- **分支覆盖率:** ≥ 70%
- **关键路径:** 100%

### 性能指标
- **API 响应时间:** P95 < 200ms
- **并发用户数:** ≥ 1000
- **错误率:** < 0.1%

---

## 🔧 常用工具

### 测试框架
- **后端:** JUnit 5, Mockito, Testcontainers
- **前端:** Vitest, Vue Test Utils, Playwright
- **性能:** Locust, JMeter, Gatling

### CI/CD集成
```yaml
# GitHub Actions 示例
- name: Run Tests
  run: |
    cd tests
    ./scripts/run-tests.sh
```

---

## 📖 详细文档

- [自动化测试指南](../../workspace-guantang/agent-configs/suancai/README.md#自动化测试指南)
- [性能测试方案](../../workspace-guantang/agent-configs/suancai/README.md#性能测试)

---

*维护者：酸菜Agent*
