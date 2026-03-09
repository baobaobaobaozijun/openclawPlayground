<!-- Last Modified: 2026-03-08 -->
<!-- Last Modified (CN): 2026-03-08 -->

# 閰歌彍 (杩愮淮/娴嬭瘯) - 瀹屾暣鐭ヨ瘑搴?
## 馃摎 鐭ヨ瘑搴撶洰褰?
- [韬唤璁ょ煡](./IDENTITY.md)
- [鑱岃矗瑙勮寖](./ROLE.md)
- [琛屼负鍑嗗垯](./SOUL.md)
- [DevOps鏈€浣冲疄璺礭(./devops-best-practices.md)
- [鑷姩鍖栨祴璇曟寚鍗梋(./automation-testing-guide.md)
- [鐩戞帶涓庡憡璀﹂厤缃甝(./monitoring-alerting.md)
- [CI/CD娴佺▼璁捐](./cicd-pipeline-design.md)
- [鏁呴殰鎺掓煡鎵嬪唽](./troubleshooting-handbook.md)

---

## 馃洜锔?DevOps鏈€浣冲疄璺?
### 1. Docker瀹瑰櫒鍖栭儴缃?
#### Dockerfile缂栧啓瑙勮寖
```dockerfile
# 浣跨敤澶氶樁娈垫瀯寤哄噺灏忛暅鍍忎綋绉?FROM python:3.9-slim as builder

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

#### Docker Compose閰嶇疆
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

### 2. 鎸佺画闆嗘垚/鎸佺画閮ㄧ讲 (CI/CD)

#### GitHub Actions宸ヤ綔娴?```yaml
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
        # 閮ㄧ讲鑴氭湰
        ssh user@server "cd /app && docker-compose pull && docker-compose up -d"
```

---

## 馃И 鑷姩鍖栨祴璇曟寚鍗?
### 1. 娴嬭瘯閲戝瓧濉?
```
        /\
       /  \
      / E2E \     鈫?绔埌绔祴璇?(10%)
     /______\
    /        \
   / Integration\  鈫?闆嗘垚娴嬭瘯 (20%)
  /______________\
 /                \
/__________________\
   Unit Tests        鈫?鍗曞厓娴嬭瘯 (70%)
```

### 2. 鍗曞厓娴嬭瘯鏈€浣冲疄璺?
#### pytest娴嬭瘯鐢ㄤ緥
```python
# tests/test_article_api.py
import pytest
from fastapi.testclient import TestClient
from src.main import app

client = TestClient(app)

class TestArticleAPI:
    
    def test_create_article_success(self):
        """娴嬭瘯鍒涘缓鏂囩珷鎴愬姛"""
        payload = {
            "title": "娴嬭瘯鏂囩珷",
            "content": "杩欐槸娴嬭瘯鍐呭"
        }
        
        response = client.post("/api/articles", json=payload)
        
        assert response.status_code == 201
        data = response.json()
        assert data["success"] is True
        assert data["data"]["title"] == "娴嬭瘯鏂囩珷"
        assert "id" in data["data"]
    
    def test_get_article_not_found(self):
        """娴嬭瘯鑾峰彇涓嶅瓨鍦ㄧ殑鏂囩珷"""
        response = client.get("/api/articles/99999")
        
        assert response.status_code == 404
        data = response.json()
        assert data["success"] is False
        assert data["error"]["code"] == "ARTICLE_NOT_FOUND"
    
    @pytest.mark.parametrize(
        "title,content,expected_status",
        [
            ("", "鍐呭", 422),  # 鏍囬涓虹┖
            ("鏍囬", "", 201),  # 鍐呭涓虹┖鍏佽
            ("A" * 201, "鍐呭", 422),  # 鏍囬瓒呴暱
        ]
    )
    def test_create_article_validation(self, title, content, expected_status):
        """娴嬭瘯鏂囩珷鍒涘缓鐨勮緭鍏ラ獙璇?""
        payload = {"title": title, "content": content}
        response = client.post("/api/articles", json=payload)
        assert response.status_code == expected_status
```

### 3. 鎬ц兘娴嬭瘯

#### Locust璐熻浇娴嬭瘯鑴氭湰
```python
# tests/performance/load_test.py
from locust import HttpUser, task, between
import random

class ArticleUser(HttpUser):
    wait_time = between(1, 3)
    
    def on_start(self):
        """鐢ㄦ埛寮€濮嬫椂鐨勭櫥褰?""
        response = self.client.post("/api/auth/login", json={
            "username": "testuser",
            "password": "testpass"
        })
        self.token = response.json()["data"]["token"]
        self.headers = {"Authorization": f"Bearer {self.token}"}
    
    @task(3)
    def get_articles(self):
        """鑾峰彇鏂囩珷鍒楄〃 - 楂橀鎿嶄綔"""
        self.client.get("/api/articles", headers=self.headers)
    
    @task(2)
    def get_article_detail(self):
        """鑾峰彇鏂囩珷璇︽儏"""
        article_id = random.randint(1, 100)
        self.client.get(f"/api/articles/{article_id}", headers=self.headers)
    
    @task(1)
    def create_article(self):
        """鍒涘缓鏂囩珷 - 浣庨鎿嶄綔"""
        self.client.post("/api/articles", json={
            "title": f"娴嬭瘯鏂囩珷{random.randint(1, 1000)}",
            "content": "杩欐槸娴嬭瘯鍐呭"
        }, headers=self.headers)
```

杩愯璐熻浇娴嬭瘯锛?```bash
locust -f tests/performance/load_test.py --host=http://localhost:8000
```

---

## 馃搳 鐩戞帶涓庡憡璀﹂厤缃?
### 1. Prometheus鐩戞帶鎸囨爣

#### 搴旂敤鎸囨爣鏆撮湶
```python
# src/metrics.py
from prometheus_client import Counter, Histogram, generate_latest
import time
from functools import wraps

# 瀹氫箟鎸囨爣
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

### 2. Grafana浠〃鏉块厤缃?
#### 鍏抽敭鐩戞帶闈㈡澘
- **绯荤粺璧勬簮**: CPU銆佸唴瀛樸€佺鐩樹娇鐢ㄧ巼
- **搴旂敤鎬ц兘**: QPS銆佸搷搴旀椂闂淬€侀敊璇巼
- **鏁版嵁搴?*: 鏌ヨ鑰楁椂銆佽繛鎺ユ暟銆佹參鏌ヨ
- **缂撳瓨**: 鍛戒腑鐜囥€佸唴瀛樹娇鐢ㄣ€侀敭鏁伴噺

### 3. 鍛婅瑙勫垯

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
      summary: "閿欒鐜囪繃楂?({{ $value | humanizePercentage }})"
      description: "杩囧幓 5 鍒嗛挓閿欒鐜囪秴杩?5%"
  
  - alert: SlowResponse
    expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 2
    for: 10m
    labels:
      severity: warning
    annotations:
      summary: "鍝嶅簲杩囨參 (P95: {{ $value }}s)"
      description: "95%鐨勮姹傚搷搴旀椂闂磋秴杩?2 绉?
```

---

## 馃攳 鏁呴殰鎺掓煡鎵嬪唽

### 鎺掓煡娴佺▼

```
1. 鐜拌薄纭
   鈫?2. 鏌ョ湅鐩戞帶鎸囨爣
   鈫?3. 妫€鏌ユ棩蹇?   鈫?4. 瀹氫綅闂
   鈫?5. 瀹炴柦淇
   鈫?6. 楠岃瘉缁撴灉
   鈫?7. 澶嶇洏鎬荤粨
```

### 甯歌闂鎺掓煡

#### 闂 1: API鍝嶅簲瓒呮椂

**鎺掓煡姝ラ:**
```bash
# 1. 妫€鏌ユ湇鍔＄姸鎬?docker-compose ps

# 2. 鏌ョ湅璧勬簮浣跨敤
docker stats

# 3. 鏌ョ湅鏃ュ織
docker-compose logs -f backend

# 4. 妫€鏌ユ暟鎹簱杩炴帴
docker-compose exec backend python -c "from sqlalchemy import create_engine; engine = create_engine('DATABASE_URL'); engine.connect()"

# 5. 鍒嗘瀽鎱㈡煡璇?docker-compose exec mysql mysql -u root -p -e "SHOW PROCESSLIST;"
```

#### 闂 2: 鍐呭瓨娉勬紡

**鎺掓煡鏂规硶:**
```bash
# 鐩戞帶瀹瑰櫒鍐呭瓨
docker stats --no-stream

# Python 杩涚▼鍐呭瓨鍒嗘瀽
import tracemalloc
tracemalloc.start()

# ... 杩愯浠ｇ爜 ...

snapshot = tracemalloc.take_snapshot()
top_stats = snapshot.statistics('lineno')

for stat in top_stats[:10]:
    print(stat)
```

#### 闂 3: 鏁版嵁搴撹繛鎺ュけ璐?
**蹇€熻瘖鏂?**
```bash
# 妫€鏌ユ暟鎹簱鏄惁杩愯
docker-compose exec db mysqladmin status -u root -p

# 妫€鏌ヨ繛鎺ユ暟
docker-compose exec db mysql -u root -p -e "SHOW STATUS LIKE 'Threads_connected';"

# 閲嶅惎鏁版嵁搴擄紙璋ㄦ厧浣跨敤锛?docker-compose restart db
```

---

## 馃摉 瀛︿範璧勬簮

### 瀹樻柟鏂囨。
- [Docker 鏂囨。](https://docs.docker.com/)
- [GitHub Actions 鏂囨。](https://docs.github.com/en/actions)
- [Prometheus 鏂囨。](https://prometheus.io/docs/)
- [pytest 鏂囨。](https://docs.pytest.org/)

### 鏈€浣冲疄璺?- [The Twelve-Factor App](https://12factor.net/)
- [Google SRE Handbook](https://sre.google/sre-book/table-of-contents/)
- [Site Reliability Engineering](https://landing.google.com/sre/books/)

---

*鏈€鍚庢洿鏂帮細2026-03-08*  
*缁存姢鑰咃細閰歌彍Agent*

