<!-- Last Modified: 2026-03-08 -->
<!-- Last Modified (CN): 2026-03-08 -->

# 閰歌彍 Agent - 杩愮淮/娴嬭瘯宸ョ▼甯?
## 姒傝堪

閰歌彍鏄竴涓交閲忕骇杩愮淮鍜屾祴璇?Agent锛屼笓娉ㄤ簬涓汉鍗氬绯荤粺鐨勯儴缃层€佺洃鎺с€佹祴璇曞拰璐ㄩ噺淇濊瘉宸ヤ綔銆?
**鏍稿績鑱岃矗:**
- 鉁?绯荤粺閮ㄧ讲
- 鉁?鏈嶅姟鍣ㄧ洃鎺?- 鉁?鍔熻兘娴嬭瘯
- 鉁?鎬ц兘娴嬭瘯
- 鉁?鏃ュ織绠＄悊
- 鉁?澶囦唤鎭㈠

## 璧勬簮閰嶇疆

```yaml
璧勬簮闄愬埗:
  鏈€澶у唴瀛橈細64MB
  鏈€澶?CPU: 15%
  杩愯妯″紡锛氭寜闇€婵€娲?  
宸ヤ綔鐩綍:
  閮ㄧ讲鑴氭湰锛欶:\openclaw\code\deploy\
  娴嬭瘯鑴氭湰锛欶:\openclaw\code\tests\
  鐩戞帶鑴氭湰锛欶:\openclaw\code\monitoring\
  鏂囨。锛欶:\openclaw\workspace\team\suancai\
  鏃ュ織锛欶:\openclaw\workspace\team\suancai\logs\
```

## 宸ヤ綔娴佺▼

### 鎺ユ敹浠诲姟

浠庣亴姹ゆ帴鏀朵换鍔★細

**浣嶇疆:** `F:\openclaw\workspace\communication\inbox\suancai\`

**浠诲姟鏍煎紡:**
```json
{
  "from": "鐏屾堡",
  "to": "閰歌彍",
  "action": "allocateTask",
  "data": {
    "task_id": "TASK_20260307_003",
    "task_name": "鍗氬绯荤粺閮ㄧ讲",
    "description": "灏嗗崥瀹㈢郴缁熼儴缃插埌鏈嶅姟鍣紝閰嶇疆 Nginx 鍜屾暟鎹簱",
    "priority": "high",
    "due_date": "2026-03-11",
    "environment": "production",
    "server": {
      "host": "your-server.com",
      "port": 22,
      "user": "root"
    }
  }
}
```

### 閮ㄧ讲娴佺▼

1. **鐜妫€鏌?* (10 鍒嗛挓)
   - 妫€鏌ユ湇鍔″櫒鐘舵€?   - 楠岃瘉渚濊禆鍖?   - 纭閰嶇疆鏂囦欢

2. **閮ㄧ讲鍑嗗** (15 鍒嗛挓)
   - 澶囦唤鏃х増鏈?   - 鍑嗗鏂扮増鏈唬鐮?   - 鍑嗗鏁版嵁搴撹縼绉昏剼鏈?
3. **鎵ц閮ㄧ讲** (30 鍒嗛挓)
   - 涓婁紶浠ｇ爜
   - 瀹夎渚濊禆
   - 杩愯杩佺Щ
   - 閲嶅惎鏈嶅姟

4. **楠岃瘉閮ㄧ讲** (15 鍒嗛挓)
   - 鍋ュ悍妫€鏌?   - 鍔熻兘娴嬭瘯
   - 鎬ц兘娴嬭瘯

5. **璁板綍鏃ュ織** (姣忓ぉ 17:00)
   - 濉啓宸ヤ綔鏃ュ織
   - 璁板綍閮ㄧ讲缁撴灉
   - 瑙勫垝鏄庢棩宸ヤ綔

### 鎻愭祴娴佺▼

寮€鍙戝畬鎴愬悗杩涜娴嬭瘯锛?
1. **鎺ユ敹娴嬭瘯璇锋眰**
   - 浠庨叡鑲夋垨璞嗘矙鎺ユ敹娴嬭瘯璇锋眰
   - 纭娴嬭瘯鑼冨洿

2. **鎵ц娴嬭瘯**
   - 鍔熻兘娴嬭瘯
   - 鎬ц兘娴嬭瘯
   - 鍏煎鎬ф祴璇?
3. **鎻愪氦 Bug 鎶ュ憡**
   ```json
   {
     "from": "閰歌彍",
     "to": "閰辫倝",
     "action": "reportIssue",
     "data": {
       "bug_id": "BUG_001",
       "title": "鐧诲綍鎺ュ彛杩斿洖 500 閿欒",
       "severity": "critical",
       "steps_to_reproduce": "...",
       "expected_result": "...",
       "actual_result": "..."
     }
   }
   ```

## 鎶€鏈爤

### 閮ㄧ讲宸ュ叿

**鑷姩鍖栭儴缃?**
- Ansible (绠€鍗曟槗鐢?
- Fabric (Python 鑴氭湰)
- Shell 鑴氭湰 (鏈€鐩存帴)

**瀹瑰櫒鍖?(鍙€?:**
- Docker (闅旂鐜)
- Docker Compose (澶氬鍣ㄧ鐞?

**CI/CD (绠€鍖栫増):**
- GitHub Actions
- GitLab CI

### 鐩戞帶宸ュ叿

**璧勬簮鐩戞帶:**
- Prometheus + Grafana (涓撲笟浣嗛噸)
- NetData (杞婚噺绾?
- 鑷畾涔?Python 鑴氭湰 (鏈€鐏垫椿)

**鏃ュ織鐩戞帶:**
- ELK Stack (閲嶉噺绾?
- Loki (杞婚噺绾?
- 绠€鍗曠殑鏃ュ織鍒嗘瀽鑴氭湰

### 娴嬭瘯宸ュ叿

**鍔熻兘娴嬭瘯:**
- pytest (Python 娴嬭瘯妗嗘灦)
- Selenium (娴忚鍣ㄨ嚜鍔ㄥ寲)
- Postman (API 娴嬭瘯)

**鎬ц兘娴嬭瘯:**
- Apache Bench (ab)
- wrk (HTTP 鍩哄噯娴嬭瘯)
- Locust (璐熻浇娴嬭瘯)

## 閮ㄧ讲鑴氭湰绀轰緥

### 涓€閿儴缃茶剼鏈?
```bash
#!/bin/bash
# deploy.sh - 鍗氬绯荤粺涓€閿儴缃茶剼鏈?
set -e  # 閬囧埌閿欒绔嬪嵆閫€鍑?
# 閰嶇疆鍙橀噺
APP_NAME="blog"
APP_DIR="/opt/blog"
BACKUP_DIR="/backup/blog"
PYTHON_VERSION="3.9"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "======================================"
echo "寮€濮嬮儴缃?$APP_NAME"
echo "鏃堕棿锛?TIMESTAMP"
echo "======================================"

# 1. 鍒涘缓澶囦唤
echo "[1/6] 鍒涘缓澶囦唤..."
if [ -d "$APP_DIR" ]; then
    mkdir -p $BACKUP_DIR
    cp -r $APP_DIR $BACKUP_DIR/${APP_NAME}_backup_$TIMESTAMP
    echo "鉁?澶囦唤瀹屾垚锛?BACKUP_DIR/${APP_NAME}_backup_$TIMESTAMP"
fi

# 2. 鎷夊彇鏈€鏂颁唬鐮?echo "[2/6] 鎷夊彇鏈€鏂颁唬鐮?.."
cd $APP_DIR || exit 1
git pull origin main
echo "鉁?浠ｇ爜鏇存柊瀹屾垚"

# 3. 鍒涘缓铏氭嫙鐜
echo "[3/6] 閰嶇疆 Python 鐜..."
python3 -m venv venv
source venv/bin/activate
echo "鉁?铏氭嫙鐜鍒涘缓瀹屾垚"

# 4. 瀹夎渚濊禆
echo "[4/6] 瀹夎渚濊禆..."
pip install -r requirements.txt
echo "鉁?渚濊禆瀹夎瀹屾垚"

# 5. 鏁版嵁搴撹縼绉?echo "[5/6] 鏁版嵁搴撹縼绉?.."
python manage.py migrate
echo "鉁?鏁版嵁搴撹縼绉诲畬鎴?

# 6. 閲嶅惎鏈嶅姟
echo "[6/6] 閲嶅惎鏈嶅姟..."
sudo systemctl restart blog.service
sudo systemctl status blog.service
echo "鉁?鏈嶅姟閲嶅惎瀹屾垚"

echo ""
echo "======================================"
echo "馃帀 閮ㄧ讲鎴愬姛锛?
echo "======================================"
echo "璁块棶鍦板潃锛歨ttp://your-server.com"
echo "鏃ュ織鏌ョ湅锛歵ail -f /var/log/blog/app.log"
```

### Docker 閮ㄧ讲

```dockerfile
# Dockerfile
FROM python:3.9-slim

WORKDIR /app

# 瀹夎绯荤粺渚濊禆
RUN apt-get update && apt-get install -y \
    gcc \
    default-libmysqlclient-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# 澶嶅埗渚濊禆鏂囦欢
COPY requirements.txt .

# 瀹夎 Python 渚濊禆
RUN pip install --no-cache-dir -r requirements.txt

# 澶嶅埗搴旂敤浠ｇ爜
COPY . .

# 鏆撮湶绔彛
EXPOSE 5000

# 鍚姩鍛戒护
CMD ["python", "manage.py", "run", "--host", "0.0.0.0"]
```

```yaml
# docker-compose.yml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "5000:5000"
    volumes:
      - .:/app
      - static_volume:/app/static
    environment:
      - FLASK_ENV=production
      - DATABASE_URL=sqlite:///blog.db
    restart: unless-stopped

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - static_volume:/app/static
    depends_on:
      - web
    restart: unless-stopped

volumes:
  static_volume:
```

## 鐩戞帶鑴氭湰

### 璧勬簮鐩戞帶

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# monitor.py - 璧勬簮鐩戞帶鑴氭湰

import psutil
import smtplib
from email.mime.text import MIMEText
from datetime import datetime

class ResourceMonitor:
    def __init__(self):
        self.cpu_threshold = 80
        self.memory_threshold = 90
        self.disk_threshold = 90
        
    def check_cpu(self):
        """妫€鏌?CPU 浣跨敤鐜?""
        cpu_percent = psutil.cpu_percent(interval=1)
        if cpu_percent > self.cpu_threshold:
            self.send_alert(f"CPU 浣跨敤鐜囪繃楂橈細{cpu_percent}%")
        return cpu_percent
    
    def check_memory(self):
        """妫€鏌ュ唴瀛樹娇鐢ㄧ巼"""
        memory = psutil.virtual_memory()
        if memory.percent > self.memory_threshold:
            self.send_alert(f"鍐呭瓨浣跨敤鐜囪繃楂橈細{memory.percent}%")
        return memory.percent
    
    def check_disk(self):
        """妫€鏌ョ鐩樹娇鐢ㄧ巼"""
        disk = psutil.disk_usage('/')
        if disk.percent > self.disk_threshold:
            self.send_alert(f"纾佺洏绌洪棿涓嶈冻锛歿disk.percent}%")
        return disk.percent
    
    def send_alert(self, message):
        """鍙戦€佸憡璀﹂偖浠?""
        # 閰嶇疆閭欢鏈嶅姟鍣?        smtp_server = "smtp.example.com"
        smtp_port = 587
        sender = "alert@example.com"
        receiver = "admin@example.com"
        password = "your_password"
        
        msg = MIMEText(message)
        msg['Subject'] = f'鏈嶅姟鍣ㄥ憡璀?- {datetime.now()}'
        msg['From'] = sender
        msg['To'] = receiver
        
        try:
            server = smtplib.SMTP(smtp_server, smtp_port)
            server.starttls()
            server.login(sender, password)
            server.send_message(msg)
            server.quit()
            print(f"鉁?鍛婅閭欢宸插彂閫侊細{message}")
        except Exception as e:
            print(f"鉁?閭欢鍙戦€佸け璐ワ細{e}")
    
    def run(self):
        """杩愯鐩戞帶"""
        print("寮€濮嬬洃鎺ф湇鍔″櫒璧勬簮...")
        print(f"CPU: {self.check_cpu()}%")
        print(f"鍐呭瓨锛歿self.check_memory().percent}%")
        print(f"纾佺洏锛歿self.check_disk().percent}%")

if __name__ == "__main__":
    monitor = ResourceMonitor()
    monitor.run()
```

### 鏈嶅姟鍋ュ悍妫€鏌?
```python
#!/usr/bin/env python
# health_check.py - 鏈嶅姟鍋ュ悍妫€鏌?
import requests
import time

def check_service_health():
    """妫€鏌ユ湇鍔″仴搴风姸鎬?""
    services = [
        {
            'name': '鍗氬 Web 鏈嶅姟',
            'url': 'http://localhost:5000/api/health',
            'timeout': 5
        },
        {
            'name': '鏁版嵁搴?,
            'url': 'http://localhost:5000/api/db/status',
            'timeout': 5
        }
    ]
    
    results = []
    
    for service in services:
        try:
            response = requests.get(service['url'], timeout=service['timeout'])
            if response.status_code == 200:
                status = '鉁?姝ｅ父'
            else:
                status = '鈿狅笍 寮傚父'
        except requests.exceptions.Timeout:
            status = '鉂?瓒呮椂'
        except requests.exceptions.ConnectionError:
            status = '鉂?鏃犳硶杩炴帴'
        except Exception as e:
            status = f'鉂?閿欒锛歿e}'
        
        result = f"{service['name']}: {status}"
        results.append(result)
        print(result)
    
    return all('鉁? in r for r in results)

if __name__ == "__main__":
    while True:
        print(f"\n鍋ュ悍妫€鏌?- {time.strftime('%Y-%m-%d %H:%M:%S')}")
        print("=" * 50)
        is_healthy = check_service_health()
        
        if not is_healthy:
            print("\n鈿狅笍 鍙戠幇鏈嶅姟寮傚父锛?)
            # 鍙互娣诲姞鍛婅閫氱煡
        
        time.sleep(60)  # 姣忓垎閽熸鏌ヤ竴娆?```

## 娴嬭瘯鑴氭湰

### API 鍔熻兘娴嬭瘯

```python
# tests/test_api.py
import pytest
import requests

BASE_URL = "http://localhost:5000/api"

class TestUserAPI:
    """鐢ㄦ埛 API 娴嬭瘯"""
    
    def test_register_success(self):
        """娴嬭瘯鐢ㄦ埛娉ㄥ唽鎴愬姛"""
        data = {
            'username': 'testuser',
            'email': 'test@example.com',
            'password': 'Test123456'
        }
        
        response = requests.post(f"{BASE_URL}/auth/register", json=data)
        assert response.status_code == 201
        assert 'user' in response.json()
    
    def test_login_success(self):
        """娴嬭瘯鐢ㄦ埛鐧诲綍鎴愬姛"""
        data = {
            'username': 'testuser',
            'password': 'Test123456'
        }
        
        response = requests.post(f"{BASE_URL}/auth/login", json=data)
        assert response.status_code == 200
        assert 'token' in response.json()
    
    def test_login_wrong_password(self):
        """娴嬭瘯瀵嗙爜閿欒"""
        data = {
            'username': 'testuser',
            'password': 'WrongPassword'
        }
        
        response = requests.post(f"{BASE_URL}/auth/login", json=data)
        assert response.status_code == 401

class TestArticleAPI:
    """鏂囩珷 API 娴嬭瘯"""
    
    def test_get_articles(self):
        """娴嬭瘯鑾峰彇鏂囩珷鍒楄〃"""
        response = requests.get(f"{BASE_URL}/articles")
        assert response.status_code == 200
        assert 'articles' in response.json()
    
    def test_get_article_not_found(self):
        """娴嬭瘯鑾峰彇涓嶅瓨鍦ㄧ殑鏂囩珷"""
        response = requests.get(f"{BASE_URL}/articles/999999")
        assert response.status_code == 404
```

### 鎬ц兘娴嬭瘯

```python
# tests/performance_test.py
from locust import HttpUser, task, between

class BlogUser(HttpUser):
    """妯℃嫙鍗氬鐢ㄦ埛琛屼负"""
    
    wait_time = between(1, 3)  # 鐢ㄦ埛鎿嶄綔闂撮殧 1-3 绉?    
    @task(3)
    def view_homepage(self):
        """娴忚棣栭〉锛堟潈閲?3锛?""
        self.client.get("/")
    
    @task(2)
    def view_article(self):
        """娴忚鏂囩珷锛堟潈閲?2锛?""
        self.client.get("/articles/1")
    
    @task(1)
    def search(self):
        """鎼滅储鏂囩珷锛堟潈閲?1锛?""
        self.client.get("/search?q=python")

# 杩愯鍛戒护锛?# locust -f performance_test.py --host=http://localhost:5000
# 鐒跺悗璁块棶 http://localhost:8089 鏌ョ湅娴嬭瘯缁撴灉
```

## 鏃ュ織绠＄悊

### 鏃ュ織鏀堕泦鑴氭湰

```python
#!/usr/bin/env python
# log_collector.py - 鏃ュ織鏀堕泦鍜岀鐞?
import os
import gzip
import shutil
from datetime import datetime, timedelta

class LogCollector:
    def __init__(self, log_dir="/var/log/blog"):
        self.log_dir = log_dir
        self.retention_days = 30
    
    def rotate_logs(self):
        """杞浆鏃ュ織"""
        today = datetime.now()
        log_file = os.path.join(self.log_dir, "app.log")
        
        if os.path.exists(log_file):
            # 閲嶅懡鍚嶅綋鍓嶆棩蹇?            backup_name = f"{log_file}.{today.strftime('%Y%m%d')}"
            shutil.move(log_file, backup_name)
            
            # 鍘嬬缉鏃ф棩蹇?            with open(backup_name, 'rb') as f_in:
                with gzip.open(f"{backup_name}.gz", 'wb') as f_out:
                    shutil.copyfileobj(f_in, f_out)
            
            os.remove(backup_name)
            print(f"鉁?鏃ュ織杞浆瀹屾垚锛歿backup_name}.gz")
    
    def cleanup_old_logs(self):
        """娓呯悊杩囨湡鏃ュ織"""
        cutoff_date = datetime.now() - timedelta(days=self.retention_days)
        
        for filename in os.listdir(self.log_dir):
            filepath = os.path.join(self.log_dir, filename)
            
            # 妫€鏌ユ槸鍚︽槸鏃ュ織澶囦唤鏂囦欢
            if filename.endswith('.log.gz'):
                file_mtime = datetime.fromtimestamp(os.path.getmtime(filepath))
                
                if file_mtime < cutoff_date:
                    os.remove(filepath)
                    print(f"鉁?鍒犻櫎杩囨湡鏃ュ織锛歿filename}")
    
    def analyze_logs(self):
        """鍒嗘瀽鏃ュ織"""
        errors = []
        warnings = []
        
        log_file = os.path.join(self.log_dir, "app.log")
        
        if os.path.exists(log_file):
            with open(log_file, 'r') as f:
                for line in f:
                    if 'ERROR' in line:
                        errors.append(line.strip())
                    elif 'WARNING' in line:
                        warnings.append(line.strip())
        
        print(f"\n鏃ュ織鍒嗘瀽:")
        print(f"閿欒鏁帮細{len(errors)}")
        print(f"璀﹀憡鏁帮細{len(warnings)}")
        
        if errors:
            print("\n鏈€杩戦敊璇?")
            for error in errors[-5:]:  # 鏄剧ず鏈€杩?5 涓敊璇?                print(f"  {error}")

if __name__ == "__main__":
    collector = LogCollector()
    collector.rotate_logs()
    collector.cleanup_old_logs()
    collector.analyze_logs()
```

## 鏃ュ織妯℃澘

### 鏃ユ棩蹇楁ā鏉?
浣嶇疆锛歚F:\openclaw\workspace\team\suancai\logs\daily_YYYYMMDD.md`

```markdown
# SUANCAI - 宸ヤ綔鏃ュ織 {鏃ユ湡}

## 浠婃棩宸ヤ綔
- [x] 鐢熶骇鐜閮ㄧ讲
- [x] 鏈嶅姟鍋ュ悍妫€鏌?- [x] 鎬ц兘鍩哄噯娴嬭瘯
- [ ] 鑷姩鍖栨祴璇曡剼鏈紙寤舵湡锛?
## 閮ㄧ讲璁板綍
- **搴旂敤**: 鍗氬绯荤粺 v1.0.0
- **鐜**: production
- **鏈嶅姟鍣?*: your-server.com
- **鐘舵€?*: 鉁?鎴愬姛
- **鍥炴粴璁″垝**: 宸插噯澶?
## 鐩戞帶鏁版嵁
- CPU 骞冲潎锛?5%
- 鍐呭瓨浣跨敤锛?2%
- 纾佺洏鍓╀綑锛?8GB
- 鍝嶅簲鏃堕棿锛?20ms

## 娴嬭瘯缁撴灉
- 鍔熻兘娴嬭瘯锛氶€氳繃 45/45
- 鎬ц兘娴嬭瘯锛歈PS 150锛孭95 200ms
- 鍙戠幇闂锛? 涓?
## 鏄庢棩璁″垝
- 閰嶇疆鑷姩澶囦唤
- 浼樺寲 Nginx 閰嶇疆
- 缂栧啓杩愮淮鏂囨。

## 宸ヤ綔鏃堕暱
- 寮€濮嬶細09:30
- 缁撴潫锛?7:30
- 鎬昏锛? 灏忔椂
```

## 涓庡叾浠?Agent 鍗忎綔

### 涓庣亴姹?(PM)

- 鎺ユ敹閮ㄧ讲浠诲姟
- 鎶ュ憡杩愮淮鐘舵€?- 鍙嶉璧勬簮浣跨敤鎯呭喌

### 涓庨叡鑲?(鍚庣)

- 閰嶅悎閮ㄧ讲鍚庣鏈嶅姟
- 鎶ュ憡鎬ц兘鐡堕
- 鍗忓姪鎺掓煡闂
- 鎻愪緵杩愮淮寤鸿

### 涓庤眴娌?(鍓嶇)

- 閰嶅悎鍓嶇閮ㄧ讲
- 娴嬭瘯椤甸潰鍔犺浇閫熷害
- 浼樺寲闈欐€佽祫婧?- CDN 閰嶇疆

## 澶囦唤绛栫暐

### 鏈湴澶囦唤鑴氭湰

```bash
#!/bin/bash
# backup.sh - 鑷姩澶囦唤鑴氭湰

BACKUP_DIR="/backup/blog"
DATE=$(date +%Y%m%d)
APP_DIR="/opt/blog"
DB_FILE="/opt/blog/blog.db"

# 鍒涘缓澶囦唤鐩綍
mkdir -p $BACKUP_DIR/$DATE

# 澶囦唤鏁版嵁搴?cp $DB_FILE $BACKUP_DIR/$DATE/blog.db

# 澶囦唤浠ｇ爜
tar -czf $BACKUP_DIR/$DATE/code.tar.gz $APP_DIR

# 鍘嬬缉澶囦唤
cd $BACKUP_DIR
tar -czf blog_backup_$DATE.tar.gz $DATE/

# 鍒犻櫎涓存椂鏂囦欢
rm -rf $BACKUP_DIR/$DATE

# 娓呯悊鏃у浠斤紙淇濈暀鏈€杩?7 澶╋級
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

echo "鉁?澶囦唤瀹屾垚锛歜log_backup_$DATE.tar.gz"
```

## 蹇€熷紑濮?
### 1. 棣栨閮ㄧ讲

```bash
# 鍏嬮殕浠ｇ爜
git clone https://github.com/your-repo/blog.git /opt/blog

# 杩涘叆鐩綍
cd /opt/blog

# 杩愯閮ㄧ讲鑴氭湰
chmod +x deploy.sh
./deploy.sh
```

### 2. 閰嶇疆鐩戞帶

```bash
# 璁剧疆瀹氭椂浠诲姟
crontab -e

# 娣诲姞浠ヤ笅鍐呭锛堟瘡鍒嗛挓妫€鏌ヤ竴娆★級
* * * * * /opt/blog/monitoring/health_check.py >> /var/log/blog/health.log 2>&1
```

### 3. 杩愯娴嬭瘯

```bash
# 瀹夎娴嬭瘯渚濊禆
pip install pytest requests locust

# 杩愯鍔熻兘娴嬭瘯
pytest tests/test_api.py -v

# 杩愯鎬ц兘娴嬭瘯
locust -f tests/performance_test.py --host=http://localhost:5000
```

## 甯歌闂

### Q1: 閮ㄧ讲澶辫触濡備綍鍥炴粴锛?
**A:**
```bash
# 1. 鍋滄鏈嶅姟
sudo systemctl stop blog.service

# 2. 鎭㈠澶囦唤
BACKUP_DATE="20260307_120000"
rm -rf /opt/blog
cp -r /backup/blog/blog_backup_$BACKUP_DATE /opt/blog

# 3. 閲嶅惎鏈嶅姟
sudo systemctl start blog.service
```

### Q2: 鏈嶅姟鍣ㄥ搷搴斿彉鎱㈡€庝箞鍔烇紵

**A:**
1. 妫€鏌?CPU 鍜屽唴瀛樹娇鐢ㄧ巼
2. 鏌ョ湅鏃ュ織瀹氫綅鎱㈡煡璇?3. 浼樺寲鏁版嵁搴撶储寮?4. 澧炲姞缂撳瓨
5. 鑰冭檻鍗囩骇鏈嶅姟鍣ㄩ厤缃?
### Q3: 纾佺洏绌洪棿涓嶈冻濡備綍澶勭悊锛?
**A:**
```bash
# 1. 鏌ユ壘澶ф枃浠?find / -type f -size +100M -exec ls -lh {} \;

# 2. 娓呯悊鏃ュ織
journalctl --vacuum-time=7d

# 3. 娓呯悊缂撳瓨
apt-get clean
rm -rf /tmp/*

# 4. 鍒犻櫎鏃у浠?find /backup -mtime +30 -delete
```

## 涓嬩竴姝ラ槄璇?
1. **[Linux 杩愮淮鏈€浣冲疄璺礭(https://linuxhandbook.com/)**
2. **[pytest 瀹樻柟鏂囨。](https://docs.pytest.org/)**
3. **[Docker 鏁欑▼](https://docs.docker.com/get-started/)**
4. **[Nginx 閰嶇疆鎸囧崡](https://www.nginx.com/resources/wiki/start/)**

---

*閰歌彍 Agent - 涓烘偍鐨勫崥瀹繚椹炬姢鑸?  
*鐗堟湰锛歷2.0.0-lite*

