# 酸菜 (运维/测试) - 完整知识库

## 📚 知识库目录

- [身份认知](./IDENTITY.md)
- [职责规范](./ROLE.md)
- [行为准则](./SOUL.md)
- [DevOps最佳实践](./devops-best-practices.md)
- [自动化测试指南](./automation-testing-guide.md)
- [监控与告警配置](./monitoring-alerting.md)
- [CI/CD流程设计](./cicd-pipeline-design.md)
- [故障排查手册](./troubleshooting-handbook.md)

---

## 🛠️ DevOps最佳实践

### 1. Docker容器化部署

#### Dockerfile编写规范
```dockerfile
# 使用多阶段构建减小镜像体积
FROM python:3.9-slim as builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

FROM python:3.9-slim
WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY . .

ENV PATH=/root/.local/bin:$PATH
EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD python -c "import requests; requests.get('http://localhost:8000/health')" || exit 1

CMD ["python", "main.py"]
```

#### Docker Compose配置
```yaml
version: '3.8'

services:
  backend:
    build: ./backend
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=mysql://user:pass@db:3306/openclaw
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis
    volumes:
      - ./logs:/app/logs
    restart: unless-stopped

  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: secure_password
      MYSQL_DATABASE: openclaw
    volumes:
      - mysql_data:/var/lib/mysql
    ports:
      - "3306:3306"

  redis:
    image: redis:6-alpine
    volumes:
      - redis_data:/data
    ports:
      - "6379:6379"

volumes:
  mysql_data:
  redis_data:
```

### 2. 持续集成/持续部署 (CI/CD)

#### GitHub Actions工作流
```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      mysql:
        image: mysql:8.0
        env:
          MYSQL_ROOT_PASSWORD: test_password
          MYSQL_DATABASE: test_db
        options: --health-cmd="mysqladmin ping" --health-interval=10s --health-timeout=5s --health-retries=3
        ports:
          - 3306:3306
      
      redis:
        image: redis:6-alpine
        options: --health-cmd="redis-cli ping" --health-interval=10s --health-timeout=5s --health-retries=3
        ports:
          - 6379:6379

    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.9'
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
        pip install pytest pytest-cov
    
    - name: Run tests
      run: |
        pytest tests/ --cov=src --cov-report=xml
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage.xml

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Deploy to server
      run: |
        # 部署脚本
        ssh user@server "cd /app && docker-compose pull && docker-compose up -d"
```

---

## 🧪 自动化测试指南

### 1. 测试金字塔

```
        /\
       /  \
      / E2E \     ← 端到端测试 (10%)
     /______\
    /        \
   / Integration\  ← 集成测试 (20%)
  /______________\
 /                \
/__________________\
   Unit Tests        ← 单元测试 (70%)
```

### 2. 单元测试最佳实践

#### pytest测试用例
```python
# tests/test_article_api.py
import pytest
from fastapi.testclient import TestClient
from src.main import app

client = TestClient(app)

class TestArticleAPI:
    
    def test_create_article_success(self):
        """测试创建文章成功"""
        payload = {
            "title": "测试文章",
            "content": "这是测试内容"
        }
        
        response = client.post("/api/articles", json=payload)
        
        assert response.status_code == 201
        data = response.json()
        assert data["success"] is True
        assert data["data"]["title"] == "测试文章"
        assert "id" in data["data"]
    
    def test_get_article_not_found(self):
        """测试获取不存在的文章"""
        response = client.get("/api/articles/99999")
        
        assert response.status_code == 404
        data = response.json()
        assert data["success"] is False
        assert data["error"]["code"] == "ARTICLE_NOT_FOUND"
    
    @pytest.mark.parametrize(
        "title,content,expected_status",
        [
            ("", "内容", 422),  # 标题为空
            ("标题", "", 201),  # 内容为空允许
            ("A" * 201, "内容", 422),  # 标题超长
        ]
    )
    def test_create_article_validation(self, title, content, expected_status):
        """测试文章创建的输入验证"""
        payload = {"title": title, "content": content}
        response = client.post("/api/articles", json=payload)
        assert response.status_code == expected_status
```

### 3. 性能测试

#### Locust负载测试脚本
```python
# tests/performance/load_test.py
from locust import HttpUser, task, between
import random

class ArticleUser(HttpUser):
    wait_time = between(1, 3)
    
    def on_start(self):
        """用户开始时的登录"""
        response = self.client.post("/api/auth/login", json={
            "username": "testuser",
            "password": "testpass"
        })
        self.token = response.json()["data"]["token"]
        self.headers = {"Authorization": f"Bearer {self.token}"}
    
    @task(3)
    def get_articles(self):
        """获取文章列表 - 高频操作"""
        self.client.get("/api/articles", headers=self.headers)
    
    @task(2)
    def get_article_detail(self):
        """获取文章详情"""
        article_id = random.randint(1, 100)
        self.client.get(f"/api/articles/{article_id}", headers=self.headers)
    
    @task(1)
    def create_article(self):
        """创建文章 - 低频操作"""
        self.client.post("/api/articles", json={
            "title": f"测试文章{random.randint(1, 1000)}",
            "content": "这是测试内容"
        }, headers=self.headers)
```

运行负载测试：
```bash
locust -f tests/performance/load_test.py --host=http://localhost:8000
```

---

## 📊 监控与告警配置

### 1. Prometheus监控指标

#### 应用指标暴露
```python
# src/metrics.py
from prometheus_client import Counter, Histogram, generate_latest
import time
from functools import wraps

# 定义指标
REQUEST_COUNT = Counter(
    'http_requests_total',
    'Total HTTP requests',
    ['method', 'endpoint', 'status']
)

REQUEST_LATENCY = Histogram(
    'http_request_duration_seconds',
    'HTTP request latency',
    ['method', 'endpoint']
)

def monitor_metrics(method, endpoint):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            start_time = time.time()
            try:
                result = func(*args, **kwargs)
                status = result.status_code if hasattr(result, 'status_code') else 200
                REQUEST_COUNT.labels(method, endpoint, status).inc()
                return result
            except Exception as e:
                REQUEST_COUNT.labels(method, endpoint, 500).inc()
                raise
            finally:
                latency = time.time() - start_time
                REQUEST_LATENCY.labels(method, endpoint).observe(latency)
        return wrapper
    return decorator

@app.get('/metrics')
def metrics():
    return Response(generate_latest(), media_type="text/plain")
```

### 2. Grafana仪表板配置

#### 关键监控面板
- **系统资源**: CPU、内存、磁盘使用率
- **应用性能**: QPS、响应时间、错误率
- **数据库**: 查询耗时、连接数、慢查询
- **缓存**: 命中率、内存使用、键数量

### 3. 告警规则

```yaml
# prometheus/alerts.yml
groups:
- name: application_alerts
  rules:
  - alert: HighErrorRate
    expr: sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m])) > 0.05
    for: 5m
    labels:
      severity: critical
    annotations:
      summary: "错误率过高 ({{ $value | humanizePercentage }})"
      description: "过去 5 分钟错误率超过 5%"
  
  - alert: SlowResponse
    expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 2
    for: 10m
    labels:
      severity: warning
    annotations:
      summary: "响应过慢 (P95: {{ $value }}s)"
      description: "95%的请求响应时间超过 2 秒"
```

---

## 🔍 故障排查手册

### 排查流程

```
1. 现象确认
   ↓
2. 查看监控指标
   ↓
3. 检查日志
   ↓
4. 定位问题
   ↓
5. 实施修复
   ↓
6. 验证结果
   ↓
7. 复盘总结
```

### 常见问题排查

#### 问题 1: API响应超时

**排查步骤:**
```bash
# 1. 检查服务状态
docker-compose ps

# 2. 查看资源使用
docker stats

# 3. 查看日志
docker-compose logs -f backend

# 4. 检查数据库连接
docker-compose exec backend python -c "from sqlalchemy import create_engine; engine = create_engine('DATABASE_URL'); engine.connect()"

# 5. 分析慢查询
docker-compose exec mysql mysql -u root -p -e "SHOW PROCESSLIST;"
```

#### 问题 2: 内存泄漏

**排查方法:**
```bash
# 监控容器内存
docker stats --no-stream

# Python 进程内存分析
import tracemalloc
tracemalloc.start()

# ... 运行代码 ...

snapshot = tracemalloc.take_snapshot()
top_stats = snapshot.statistics('lineno')

for stat in top_stats[:10]:
    print(stat)
```

#### 问题 3: 数据库连接失败

**快速诊断:**
```bash
# 检查数据库是否运行
docker-compose exec db mysqladmin status -u root -p

# 检查连接数
docker-compose exec db mysql -u root -p -e "SHOW STATUS LIKE 'Threads_connected';"

# 重启数据库（谨慎使用）
docker-compose restart db
```

---

## 📖 学习资源

### 官方文档
- [Docker 文档](https://docs.docker.com/)
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [Prometheus 文档](https://prometheus.io/docs/)
- [pytest 文档](https://docs.pytest.org/)

### 最佳实践
- [The Twelve-Factor App](https://12factor.net/)
- [Google SRE Handbook](https://sre.google/sre-book/table-of-contents/)
- [Site Reliability Engineering](https://landing.google.com/sre/books/)

---

*最后更新：2026-03-08*  
*维护者：酸菜Agent*
