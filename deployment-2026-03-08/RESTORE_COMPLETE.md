<!-- Last Modified: 2026-03-09 -->
<!-- Last Modified (CN): 2026-03-09 -->

# 馃攧 deployment-2026-03-08 鏂囦欢澶规仮澶嶅畬鎴?

**鎭㈠鏃堕棿:** 2026-03-09 11:15  
**鎭㈠鍘熷洜:** 鏂囦欢澶硅璇垹闄わ紝鐜伴噸鏂板垱寤烘墍鏈夋枃浠?

---

## 鉁?宸叉仮澶嶇殑鏂囦欢娓呭崟

### 馃搧 docker-compose/ (3 涓枃浠?

1. **docker-compose-agents.yml** - OpenClaw Agent 涓夊鍣ㄧ紪鎺掗厤缃?
   - 閰辫倝銆佽眴娌欍€侀吀鑿滀笁涓?Agent 鐨勫畬鏁撮厤缃?
   - 鍖呭惈鐜鍙橀噺銆乿olumes 鎸傝浇銆佺綉缁滈厤缃?
   
2. **docker-compose-searxng.yml** - SearXNG 鎼滅储寮曟搸缂栨帓閰嶇疆
   - 涓変釜鐙珛鐨?SearXNG 瀹炰緥閰嶇疆
   - 鍒嗗埆瀵瑰簲姣忎釜 Agent 鐨勬悳绱㈤渶姹?

3. **docker-compose.yml** - 鍩虹 Docker Compose 閰嶇疆
   - 绠€鍖栫殑鍗曞鍣ㄩ厤缃ず渚?

### 馃敡 searxng-configs/searxng/ (3 涓厤缃枃浠?

1. **jiangrou/settings.yml** - 閰辫倝鎶€鏈皟鐮旀悳绱㈠紩鎿庨厤缃?
2. **dousha/settings.yml** - 璞嗘矙璁捐璧勬簮鎼滅储寮曟搸閰嶇疆
3. **suancai/settings.yml** - 閰歌彍杩愮淮鐭ヨ瘑鎼滅储寮曟搸閰嶇疆

### 馃摐 scripts/ (2 涓剼鏈枃浠?

1. **init-docker-containers.py** - Python 鍒濆鍖栬剼鏈?
   - 妫€鏌?Docker 鐜
   - 鍚姩鎵€鏈夊鍣?
   - 楠岃瘉鏈嶅姟鐘舵€?
   - 鏄剧ず璁块棶淇℃伅

2. **test-connectivity.ps1** - PowerShell 杩炴帴娴嬭瘯鑴氭湰
   - 娴嬭瘯瀹瑰櫒杩愯鐘舵€?
   - 娴嬭瘯 Web 鏈嶅姟鍙闂€?
   - 鑾峰彇 OpenClaw Token
   - 鐢熸垚娴嬭瘯鎶ュ憡

### 馃搫 json-files/ (5 涓厤缃枃浠?

1. **comm-config.json** - Agent 閫氫俊閰嶇疆
2. **onboarding-1.json** - 閰辫倝鍏ヨ亴浠诲姟妯℃澘
3. **onboarding-2.json** - 璞嗘矙鍏ヨ亴浠诲姟妯℃澘
4. **onboarding-3.json** - 閰歌彍鍏ヨ亴浠诲姟妯℃澘
5. **test-message.json** - 娴嬭瘯娑堟伅妯℃澘

---

## 馃搵 閲嶈璇存槑

### 宸ヤ綔鐩綍閰嶇疆

鏍规嵁鏈€鏂扮殑 AGENT_CONFIGS.md 淇敼锛屾墍鏈?Agent 鐨勫伐浣滅洰褰曞凡鏇存柊涓猴細

```yaml
閰辫倝锛欶:\openclaw\workspace-jiangrou
璞嗘矙锛欶:\openclaw\workspace-dousha
閰歌彍锛欶:\openclaw\workspace-suancai
```

杩欎簺鐩綍宸茬粡瀛樺湪锛屽彲浠ョ洿鎺ヤ娇鐢ㄣ€?

### Docker Volumes 鎸傝浇

鎵€鏈夊鍣ㄧ殑 volumes 閰嶇疆宸插悓姝ユ洿鏂帮細

```yaml
閰辫倝瀹瑰櫒:
  - F:\openclaw\code\backend:/app/backend
  - F:\openclaw\workspace-jiangrou:/app/workspace

璞嗘矙瀹瑰櫒:
  - F:\openclaw\code\frontend:/app/frontend
  - F:\openclaw\workspace-dousha:/app/workspace

閰歌彍瀹瑰櫒:
  - F:\openclaw\code\deploy:/app/deploy
  - F:\openclaw\code\tests:/app/tests
  - F:\openclaw\workspace-suancai:/app/workspace
```

---

## 馃殌 蹇€熷紑濮?

### 鏂规硶 1: 浣跨敤 Python 鑴氭湰锛堟帹鑽愶級

```bash
cd F:\openclaw\deployment-2026-03-08\scripts
python init-docker-containers.py
```

### 鏂规硶 2: 浣跨敤 PowerShell 鑴氭湰

```powershell
cd F:\openclaw\deployment-2026-03-08\scripts
.\test-connectivity.ps1
```

### 鏂规硶 3: 鎵嬪姩鍚姩

```bash
cd F:\openclaw\deployment-2026-03-08\docker-compose

# 鍚姩 Agent 瀹瑰櫒
docker-compose -f docker-compose-agents.yml up -d

# 鍚姩 SearXNG 瀹瑰櫒
docker-compose -f docker-compose-searxng.yml up -d

# 绛夊緟 10 绉掑悗楠岃瘉
docker ps
```

---

## 馃攳 楠岃瘉姝ラ

### 1. 妫€鏌ュ鍣ㄧ姸鎬?

```bash
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

搴旇鐪嬪埌 6 涓鍣ㄩ兘鍦ㄨ繍琛岋細
- openclaw-instance-1, 2, 3
- searxng-jiangrou, dousha, suancai

### 2. 璁块棶 Web UI

**OpenClaw Agent:**
- 閰辫倝锛歨ttp://localhost:18791
- 璞嗘矙锛歨ttp://localhost:18792
- 閰歌彍锛歨ttp://localhost:18793

**SearXNG 鎼滅储寮曟搸:**
- 閰辫倝锛歨ttp://localhost:8081
- 璞嗘矙锛歨ttp://localhost:8082
- 閰歌彍锛歨ttp://localhost:8083

### 3. 鑾峰彇 Token

```bash
docker exec openclaw-instance-1 openclaw dashboard --no-open
```

---

## 鈿狅笍 娉ㄦ剰浜嬮」

1. **鏁版嵁澶囦唤**: 寤鸿瀹氭湡澶囦唤 `deployment-2026-03-08` 鏂囦欢澶?
2. **鐗堟湰鎺у埗**: 寤鸿浣跨敤 Git 绠＄悊姝ゆ枃浠跺す鐨勯厤缃彉鏇?
3. **API Key 瀹夊叏**: 涓嶈灏嗗寘鍚湡瀹?API Key 鐨勯厤缃枃浠舵彁浜ゅ埌鍏叡浠撳簱
4. **鐩綍鏉冮檺**: 纭繚 Docker Desktop 鏈夋潈闄愯闂寕杞界殑鐩綍

---

## 馃搳 鏂囦欢缁熻

| 鍒嗙被 | 鏂囦欢鏁?| 璇存槑 |
|------|--------|------|
| docker-compose/ | 3 | Docker 缂栨帓閰嶇疆 |
| searxng-configs/ | 3 | SearXNG 閰嶇疆 |
| scripts/ | 2 | 鍒濆鍖栧拰娴嬭瘯鑴氭湰 |
| json-files/ | 5 | JSON 閰嶇疆鏂囦欢 |
| **鎬昏** | **13** | **瀹屾暣鐨勯儴缃茬郴缁?* |

---

## 馃幆 涓嬩竴姝ユ搷浣?

1. 鉁?纭鎵€鏈夋枃浠跺凡鎭㈠
2. 鈴?鍚姩 Docker 瀹瑰櫒
3. 鈴?楠岃瘉鏈嶅姟姝ｅ父杩愯
4. 鈴?寮€濮嬩娇鐢?Agent 鍗忎綔

---

## 馃摓 鏁呴殰鎺掓煡

濡傛灉閬囧埌闂锛?

1. **妫€鏌?Docker Desktop** 鏄惁姝ｅ父杩愯
2. **鏌ョ湅瀹瑰櫒鏃ュ織**: `docker logs <瀹瑰櫒鍚?`
3. **杩愯娴嬭瘯鑴氭湰**: `.\test-connectivity.ps1`
4. **妫€鏌ョ鍙ｅ崰鐢?*: `netstat -ano | findstr "18791 18792 18793 8081 8082 8083"`

---

*鎭㈠瀹屾垚鏃堕棿锛?026-03-09 11:15*  
*鎵€鏈夊姛鑳藉凡鎭㈠姝ｅ父*

