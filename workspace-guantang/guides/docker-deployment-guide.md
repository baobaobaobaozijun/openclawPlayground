<!-- Last Modified: 2026-03-08 -->
<!-- Last Modified (CN): 2026-03-08 -->

# OpenClaw Agent 鍥㈤槦 - Docker 閮ㄧ讲鎸囧崡

## 鏋舵瀯璇存槑

### 杩愯鐜鍒嗗竷

```
鈹屸攢鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹?鈹? Windows Host (F:\openclaw)                 鈹?鈹? 鈹屸攢鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹?  鈹?鈹? 鈹?鐏屾堡 (PM)                            鈹?  鈹?鈹? 鈹?杩愯锛氬師鐢?Python/Node.js            鈹?  鈹?鈹? 鈹?浣嶇疆锛歠:\openclaw\workspace          鈹?  鈹?鈹? 鈹斺攢鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹?  鈹?鈹?                                            鈹?鈹? 鈹屸攢鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹?  鈹?鈹? 鈹?Docker Desktop for Windows           鈹?  鈹?鈹? 鈹? 鈹屸攢鈹€鈹€鈹€鈹€鈹€鈹€鈹?鈹屸攢鈹€鈹€鈹€鈹€鈹€鈹€鈹?鈹屸攢鈹€鈹€鈹€鈹€鈹€鈹€鈹?    鈹?  鈹?鈹? 鈹? 鈹傞叡鑲?  鈹?鈹傝眴娌?  鈹?鈹傞吀鑿?  鈹?    鈹?  鈹?鈹? 鈹? 鈹傚悗绔?  鈹?鈹傚墠绔?  鈹?鈹傝繍缁?  鈹?    鈹?  鈹?鈹? 鈹? 鈹傪煡?   鈹?鈹傪煃?   鈹?鈹傪煡?   鈹?    鈹?  鈹?鈹? 鈹? 鈹斺攢鈹€鈹€鈹€鈹€鈹€鈹€鈹?鈹斺攢鈹€鈹€鈹€鈹€鈹€鈹€鈹?鈹斺攢鈹€鈹€鈹€鈹€鈹€鈹€鈹?    鈹?  鈹?鈹? 鈹斺攢鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹?  鈹?鈹斺攢鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹?```

## Docker Compose 閰嶇疆

### docker-compose.yml

```yaml
version: '3.8'

services:
  # 閰辫倝 - 鍚庣宸ョ▼甯?  jiangrou:
    build:
      context: ./jiangrou
      dockerfile: Dockerfile
    container_name: openclaw-jiangrou
    volumes:
      # 宸ヤ綔鏃ュ織
      - ../workspace/team/jiangrou/logs:/workspace/logs
      # 浠诲姟绠＄悊
      - ../workspace/team/jiangrou/tasks:/workspace/tasks
      # 閫氫俊鐩綍
      - ../workspace/communication:/workspace/communication
      # 浠ｇ爜鐩綍 (鍙€?
      - ../code/backend:/workspace/code
    environment:
      - AGENT_NAME=閰辫倝
      - AGENT_ROLE=backend
      - WORKSPACE=/workspace
      - TZ=Asia/Shanghai
    working_dir: /workspace
    command: ["python", "agent.py"]
    restart: unless-stopped
    networks:
      - openclaw-network
    # 璧勬簮闄愬埗
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 256M

  # 璞嗘矙 - 鍓嶇宸ョ▼甯?  dousha:
    build:
      context: ./dousha
      dockerfile: Dockerfile
    container_name: openclaw-dousha
    volumes:
      # 宸ヤ綔鏃ュ織
      - ../workspace/team/dousha/logs:/workspace/logs
      # 浠诲姟绠＄悊
      - ../workspace/team/dousha/tasks:/workspace/tasks
      # 璁捐绋?      - ../workspace/team/dousha/designs:/workspace/designs
      # 閫氫俊鐩綍
      - ../workspace/communication:/workspace/communication
      # 鍓嶇浠ｇ爜 (鍙€?
      - ../code/frontend:/workspace/code
    environment:
      - AGENT_NAME=璞嗘矙
      - AGENT_ROLE=frontend
      - WORKSPACE=/workspace
      - TZ=Asia/Shanghai
    working_dir: /workspace
    command: ["python", "agent.py"]
    restart: unless-stopped
    networks:
      - openclaw-network
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 256M

  # 閰歌彍 - 杩愮淮/娴嬭瘯宸ョ▼甯?  suancai:
    build:
      context: ./suancai
      dockerfile: Dockerfile
    container_name: openclaw-suancai
    volumes:
      # 宸ヤ綔鏃ュ織
      - ../workspace/team/suancai/logs:/workspace/logs
      # 浠诲姟绠＄悊
      - ../workspace/team/suancai/tasks:/workspace/tasks
      # 娴嬭瘯鑴氭湰
      - ../workspace/team/suancai/tests:/workspace/tests
      # 娴嬭瘯鎶ュ憡
      - ../workspace/team/suancai/reports:/workspace/reports
      # 閫氫俊鐩綍
      - ../workspace/communication:/workspace/communication
      # 娴嬭瘯浠ｇ爜
      - ../code/tests:/workspace/tests
    environment:
      - AGENT_NAME=閰歌彍
      - AGENT_ROLE=devops
      - WORKSPACE=/workspace
      - TZ=Asia/Shanghai
    working_dir: /workspace
    command: ["python", "agent.py"]
    restart: unless-stopped
    networks:
      - openclaw-network
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 128M

networks:
  openclaw-network:
    driver: bridge
```

## 鍚?Agent 鐨?Dockerfile

### 閰辫倝鐨?Dockerfile (jiangrou/Dockerfile)

```dockerfile
FROM python:3.9-slim

WORKDIR /workspace

# 瀹夎绯荤粺渚濊禆
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 瀹夎 Python 渚濊禆
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 澶嶅埗 Agent 浠ｇ爜
COPY agent.py .

# 鍋ュ悍妫€鏌?HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "print('OK')" || exit 1

CMD ["python", "agent.py"]
```

### 璞嗘矙鐨?Dockerfile (dousha/Dockerfile)

```dockerfile
FROM node:18-alpine

WORKDIR /workspace

# 瀹夎绯荤粺渚濊禆
RUN apk add --no-cache \
    git \
    python3 \
    py3-pip

# 瀹夎鍓嶇宸ュ叿
RUN npm install -g npm latest

# 瀹夎 Python 渚濊禆 (鐢ㄤ簬 Agent 杩愯鏃?
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# 澶嶅埗 Agent 浠ｇ爜
COPY agent.py .

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python3 -c "print('OK')" || exit 1

CMD ["python3", "agent.py"]
```

### 閰歌彍鐨?Dockerfile (suancai/Dockerfile)

```dockerfile
FROM python:3.9-alpine

WORKDIR /workspace

# 瀹夎绯荤粺渚濊禆
RUN apk add --no-cache \
    git \
    curl \
    bash

# 瀹夎娴嬭瘯宸ュ叿
RUN pip install --no-cache-dir \
    pytest \
    pytest-cov \
    locust \
    requests

# 瀹夎 Python 渚濊禆
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 澶嶅埗 Agent 浠ｇ爜
COPY agent.py .

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "print('OK')" || exit 1

CMD ["python", "agent.py"]
```

## 蹇€熷紑濮?
### 1. 鏋勫缓鎵€鏈夊鍣?
```bash
cd f:\openclaw\workspace-programmer

# 鏋勫缓鎵€鏈夋湇鍔?docker-compose build

# 鎴栧崟鐙瀯寤烘煇涓湇鍔?docker-compose build jiangrou
docker-compose build dousha
docker-compose build suancai
```

### 2. 鍚姩鎵€鏈夋湇鍔?
```bash
# 鍚庡彴杩愯
docker-compose up -d

# 鏌ョ湅鏃ュ織
docker-compose logs -f

# 鏌ョ湅鐗瑰畾鏈嶅姟鏃ュ織
docker-compose logs -f jiangrou
```

### 3. 鍋滄鏈嶅姟

```bash
# 鍋滄鎵€鏈?docker-compose stop

# 鍋滄鐗瑰畾鏈嶅姟
docker-compose stop jiangrou

# 鍒犻櫎瀹瑰櫒 (鏁版嵁涓嶄細涓㈠け锛屽洜涓轰娇鐢ㄤ簡鎸傝浇鍗?
docker-compose down
```

### 4. 閲嶅惎鏈嶅姟

```bash
# 閲嶅惎鎵€鏈?docker-compose restart

# 閲嶅惎鐗瑰畾鏈嶅姟
docker-compose restart dousha
```

## 鏃ュ父绠＄悊

### 鏌ョ湅瀹瑰櫒鐘舵€?
```bash
# 鏌ョ湅鎵€鏈夊鍣?docker-compose ps

# 鏌ョ湅璇︾粏淇℃伅
docker inspect openclaw-jiangrou
```

### 杩涘叆瀹瑰櫒

```bash
# 杩涘叆閰辫倝鐨勫鍣?docker exec -it openclaw-jiangrou /bin/bash

# 杩涘叆璞嗘矙鐨勫鍣?docker exec -it openclaw-dousha /bin/sh

# 杩涘叆閰歌彍鐨勫鍣?docker exec -it openclaw-suancai /bin/bash
```

### 璧勬簮鐩戞帶

```bash
# 鏌ョ湅璧勬簮浣跨敤
docker stats

# 鏌ョ湅鐗瑰畾瀹瑰櫒
docker stats openclaw-jiangrou
```

### 鏃ュ織绠＄悊

```bash
# 鏌ョ湅鎵€鏈夋棩蹇?docker-compose logs

# 鏌ョ湅鏈€杩?100 琛?docker-compose logs --tail=100

# 瀹炴椂鏌ョ湅
docker-compose logs -f

# 鏌ョ湅鐗瑰畾鏈嶅姟
docker-compose logs jiangrou
```

## 鏁版嵁鎸佷箙鍖?
### 鎸傝浇鍗疯鏄?
鎵€鏈夐噸瑕佹暟鎹兘閫氳繃鎸傝浇鍗蜂繚瀛樺湪涓绘満涓?

**閰辫倝:**
- `F:\openclaw\workspace\team\jiangrou\logs` 鈫?`/workspace/logs`
- `F:\openclaw\workspace\team\jiangrou\tasks` 鈫?`/workspace/tasks`

**璞嗘矙:**
- `F:\openclaw\workspace\team\dousha\logs` 鈫?`/workspace/logs`
- `F:\openclaw\workspace\team\dousha\designs` 鈫?`/workspace/designs`

**閰歌彍:**
- `F:\openclaw\workspace\team\suancai\logs` 鈫?`/workspace/logs`
- `F:\openclaw\workspace\team\suancai\tests` 鈫?`/workspace/tests`
- `F:\openclaw\workspace\team\suancai\reports` 鈫?`/workspace/reports`

### 澶囦唤绛栫暐

```bash
# 澶囦唤鎵€鏈夋暟鎹?tar -czf openclaw-backup-$(date +%Y%m%d).tar.gz \
    workspace/team/*/logs \
    workspace/team/*/tasks \
    workspace/team/dousha/designs \
    workspace/team/suancai/tests \
    workspace/team/suancai/reports
```

## 鏁呴殰鎺掗櫎

### 瀹瑰櫒鏃犳硶鍚姩

```bash
# 鏌ョ湅璇︾粏閿欒
docker-compose up jiangrou

# 妫€鏌?Dockerfile
cat jiangrou/Dockerfile

# 閲嶆柊鏋勫缓
docker-compose build --no-cache jianghou
```

### 瀹瑰櫒闂撮€氫俊闂

```bash
# 妫€鏌ョ綉缁?docker network ls

# 妫€鏌ュ鍣ㄦ槸鍚﹀湪鍚屼竴缃戠粶
docker network inspect openclaw-network
```

### 鎸傝浇鍗锋潈闄愰棶棰?
**Windows 涓绘満:**
```powershell
# 纭繚鐩綍瀛樺湪
New-Item -ItemType Directory -Path "F:\openclaw\workspace\team\jiangrou\logs" -Force

# 妫€鏌ユ潈闄?Get-Acl "F:\openclaw\workspace\team\jiangrou\logs" | Format-List
```

### 璧勬簮涓嶈冻

```bash
# 璋冩暣璧勬簮闄愬埗
# 缂栬緫 docker-compose.yml锛屼慨鏀?deploy.resources.limits
```

## 鎬ц兘浼樺寲

### 闀滃儚澶у皬浼樺寲

```dockerfile
# 浣跨敤澶氶樁娈垫瀯寤?FROM python:3.9 as builder
# ... 鏋勫缓姝ラ ...

FROM python:3.9-slim
# 鍙鍒跺繀瑕佹枃浠?```

### 鍚姩閫熷害浼樺寲

```yaml
# 浣跨敤鍛藉悕鍗疯€屼笉鏄粦瀹氭寕杞?volumes:
  jiangrou_logs:
  
services:
  jiangrou:
    volumes:
      - jiangrou_logs:/workspace/logs
```

### 鍐呭瓨浼樺寲

```yaml
# 鏍规嵁瀹為檯闇€瑕佽皟鏁村唴瀛橀檺鍒?deploy:
  resources:
    limits:
      memory: 128M  # 闄嶄綆鍒板疄闄呴渶瑕?```

---

_Docker 璁╀綘鐨?Agent 鍥㈤槦鍦ㄩ殧绂汇€佸彲绉绘鐨勭幆澧冧腑杩愯銆備繚鎸佹暣娲侊紝淇濇寔楂樻晥銆俖

