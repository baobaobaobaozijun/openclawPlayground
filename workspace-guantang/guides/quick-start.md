<!-- Last Modified: 2026-03-08 -->
<!-- Last Modified (CN): 2026-03-08 -->

# 蹇€熷惎鍔ㄦ寚鍗?
## 馃殌 5 鍒嗛挓蹇€熷紑濮?
### 姝ラ 1: 纭閰嶇疆 (1 鍒嗛挓)

妫€鏌ユ偍鐨勭幆澧冩槸鍚︽弧瓒宠姹傦細

**鏈嶅姟鍣ㄨ姹?**
- 鉁?CPU: 2 鏍稿績鎴栨洿楂?- 鉁?鍐呭瓨锛?GB 鎴栨洿楂?- 鉁?瀛樺偍锛?0GB 鎴栨洿楂?- 鉁?Python 3.8+

**鏈湴寮€鍙戠幆澧?**
- 鉁?Windows/Linux/Mac
- 鉁?鍏呰冻鐨勫瓨鍌ㄧ┖闂?- 鉁?Git 宸插畨瑁?
### 姝ラ 2: 鍒涘缓鐩綍缁撴瀯 (1 鍒嗛挓)

鎵ц浠ヤ笅鍛戒护鍒涘缓蹇呰鐨勭洰褰曪細

```bash
# Windows PowerShell
$directories = @(
    "F:\openclaw\workspace\team\guantang\logs",
    "F:\openclaw\workspace\team\jiangrou\logs",
    "F:\openclaw\workspace\team\dousha\logs",
    "F:\openclaw\workspace\team\suancai\logs",
    "F:\openclaw\workspace\communication\inbox",
    "F:\openclaw\workspace\communication\outbox",
    "F:\openclaw\workspace\communication\archive",
    "F:\openclaw\workspace\logs",
    "F:\openclaw\workspace\projects",
    "F:\openclaw\workspace\backups"
)

foreach ($dir in $directories) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
    }
}

Write-Host "鐩綍缁撴瀯鍒涘缓瀹屾垚锛? -ForegroundColor Green
```

**Linux/Mac:**
```bash
mkdir -p /opt/openclaw/workspace/team/{guantang,jiangrou,dousha,suancai}/logs
mkdir -p /opt/openclaw/workspace/communication/{inbox,outbox,archive}
mkdir -p /opt/openclaw/workspace/{logs,projects,backups}
echo "鐩綍缁撴瀯鍒涘缓瀹屾垚锛?
```

### 姝ラ 3: 鍒濆鍖栭厤缃枃浠?(1 鍒嗛挓)

`config.json` 宸茬粡浼樺寲瀹屾垚锛屼綅浜庯細
```
f:\openclaw\workspace-programmer\config.json
```

**鍏抽敭閰嶇疆妫€鏌?**
```json
{
  "server_optimization": {
    "enabled": true,
    "limits": {
      "cpu_cores": 2,
      "memory_gb": 2
    }
  },
  "logging": {
    "log_type": "unified_markdown",
    "retention_days": 7
  },
  "integration": {
    "blog": {
      "enabled": false,
      "phase": 1
    }
  }
}
```

### 姝ラ 4: 瀹夎渚濊禆 (1 鍒嗛挓)

鍒涘缓 `requirements.txt`:

```txt
# 鏍稿績渚濊禆
requests==2.31.0
APScheduler==3.10.4
python-dotenv==1.0.0

# 鏁版嵁搴擄紙鍙€夛紝濡傛灉浣跨敤 SQLite 鍒欎笉闇€瑕侀澶栧畨瑁咃級
# sqlite3  # Python 鍐呯疆

# 鐩戞帶锛堝彲閫夛級
psutil==5.9.6

# 鍗氬闆嗘垚锛堥樁娈?2锛?# flask==3.0.0  # 濡傛灉闇€瑕佽繍琛屽崥瀹㈠悗绔?```

瀹夎锛?```bash
pip install -r requirements.txt
```

### 姝ラ 5: 鍒涘缓 Agent 鏃ュ織妯℃澘 (1 鍒嗛挓)

涓烘瘡涓?Agent 鍒涘缓浠婃棩鐨勫伐浣滄棩蹇楁枃浠讹細

**PowerShell:**
```powershell
$agents = @("guantang", "jiangrou", "dousha", "suancai")
$today = Get-Date -Format "yyyyMMdd"

foreach ($agent in $agents) {
    $logPath = "F:\openclaw\workspace\team\$agent\logs\daily_$today.md"
    
    $template = @"
# $($agent.ToUpper()) - 宸ヤ綔鏃ュ織 $(Get-Date -Format "yyyy-MM-dd")

## 浠婃棩宸ヤ綔
- [ ] 浠诲姟 1
- [ ] 浠诲姟 2

## 浠ｇ爜鎻愪氦
- \`鏂囦欢璺緞\` - 淇敼璇存槑

## 閬囧埌鐨勯棶棰?- 

## 鏄庢棩璁″垝
- 

## 宸ヤ綔鏃堕暱
- 寮€濮嬫椂闂达細
- 缁撴潫鏃堕棿锛?- 鎬昏锛?"@
    
    $template | Out-File -FilePath $logPath -Encoding utf8
    Write-Host "宸插垱寤?$agent 鐨勬棩蹇楁ā鏉? -ForegroundColor Green
}
```

---

## 馃搵 绗竴涓伐浣滄棩娴佺▼

### 鏃╀笂 9:00 - 鍚姩 Agent

鍒涘缓鍚姩鑴氭湰 `start_agents.py`:

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
from datetime import datetime

def start_agent(agent_name):
    """鍚姩鍗曚釜 Agent"""
    print(f"[{datetime.now()}] 鍚姩 {agent_name}...")
    
    # 杩欓噷灏嗘潵浼氬疄渚嬪寲 Agent
    # 鐩墠鍙槸鎵撳嵃鏃ュ織
    print(f"[{datetime.now()}] 鉁?{agent_name} 灏辩华")

def main():
    agents = ['鐏屾堡', '閰辫倝', '璞嗘矙', '閰歌彍']
    
    print("=" * 50)
    print("OpenClaw Agent 鍥㈤槦 - 杞婚噺绾фā寮?)
    print("=" * 50)
    
    for agent in agents:
        try:
            start_agent(agent)
        except Exception as e:
            print(f"[ERROR] {agent} 鍚姩澶辫触锛歿e}")
    
    print("\n鎵€鏈?Agent 鍚姩瀹屾垚锛?)
    print("鎸?Ctrl+C 閫€鍑?)
    
    try:
        while True:
            pass  # 淇濇寔杩愯
    except KeyboardInterrupt:
        print("\n姝ｅ湪鍏抽棴 Agent...")
        print("鍐嶈锛?)

if __name__ == "__main__":
    main()
```

杩愯锛?```bash
python start_agents.py
```

### 涓婂崍宸ヤ綔 - 浠诲姟鍒嗗彂

**鐏屾堡鐨勫伐浣?**

1. 璇诲彇椤圭洰闇€姹?2. 鍒嗚В浠诲姟
3. 鍒涘缓浠诲姟鏂囦欢

绀轰緥浠诲姟鏂囦欢 `task_001.json`:
```json
{
  "task_id": "TASK_20260307_001",
  "project_id": "BLOG_20260307_001",
  "task_name": "鍗氬鍚庣 API 寮€鍙?,
  "assignee": "閰辫倝",
  "priority": "high",
  "description": "瀹炵幇鐢ㄦ埛璁よ瘉鍜屾枃绔犵鐞?API",
  "due_date": "2026-03-09",
  "deliverables": [
    {
      "name": "鐢ㄦ埛璁よ瘉 API",
      "path": "backend/api/auth.py"
    }
  ]
}
```

灏嗕换鍔℃斁鍒伴叡鑲夌殑鏀朵欢绠憋細
```
F:\openclaw\workspace\communication\inbox\jiangrou\task_001.json
```

### 涓崍 12:00 - 杩涘害妫€鏌?
**鐏屾堡妫€鏌ュ悇 Agent 杩涘害:**

```python
def check_progress():
    """妫€鏌ユ墍鏈?Agent 鐨勮繘搴?""
    today = datetime.now().strftime("%Y%m%d")
    
    for agent in ['guantang', 'jiangrou', 'dousha', 'suancai']:
        log_path = f"F:\\openclaw\\workspace\\team\\{agent}\\logs\\daily_{today}.md"
        
        if os.path.exists(log_path):
            with open(log_path, 'r', encoding='utf-8') as f:
                content = f.read()
                # 绠€鍗曞垎鏋愬畬鎴愭儏鍐?                completed = content.count('[x]')
                pending = content.count('[ ]')
                print(f"{agent}: 瀹屾垚 {completed} 涓换鍔★紝寰呭畬鎴?{pending} 涓?)
        else:
            print(f"{agent}: 浠婃棩鏃ュ織涓嶅瓨鍦?)
```

### 涓嬪崍 17:00 - 濉啓鏃ュ織

姣忎釜 Agent 鏇存柊鑷繁鐨勫伐浣滄棩蹇楋細

**閰辫倝鐨勬棩蹇楃ず渚?**
```markdown
# JIANGROU - 宸ヤ綔鏃ュ織 2026-03-07

## 浠婃棩宸ヤ綔
- [x] 鐢ㄦ埛璁よ瘉 API 寮€鍙戝畬鎴?- [x] 鏁版嵁搴撴ā鍨嬭璁?- [x] JWT Token 绠＄悊瀹炵幇
- [ ] 鎬ц兘浼樺寲锛堝欢鏈熷埌鏄庡ぉ锛?
## 浠ｇ爜鎻愪氦
- `backend/api/auth.py` - 鏂板鐢ㄦ埛鐧诲綍銆佹敞鍐屾帴鍙?- `backend/models/user.py` - 鐢ㄦ埛鏁版嵁妯″瀷
- `backend/config.py` - 閰嶇疆鏂囦欢

## 閬囧埌鐨勯棶棰?- JWT 搴撶増鏈笌 Flask 涓嶅吋瀹?- **瑙ｅ喅鏂规**: 闄嶇骇 PyJWT 鍒?2.6.0

## 鏄庢棩璁″垝
- 鏂囩珷绠＄悊 API 寮€鍙?- 鏁版嵁搴撴煡璇紭鍖?- 鍗曞厓娴嬭瘯缂栧啓

## 宸ヤ綔鏃堕暱
- 寮€濮嬫椂闂达細09:30
- 缁撴潫鏃堕棿锛?7:30
- 鎬昏锛? 灏忔椂锛堝崍浼?1 灏忔椂锛?```

### 涓嬪崍 18:00 - 鐢熸垚鏃ユ姤

**鐏屾堡鑷姩鐢熸垚椤圭洰鏃ユ姤:**

```python
def generate_daily_report():
    """鐢熸垚椤圭洰鏃ユ姤"""
    today = datetime.now().strftime("%Y-%m-%d")
    
    report = f"""# 椤圭洰鏃ユ姤 - {today}

## 椤圭洰淇℃伅
- 椤圭洰锛氫釜浜哄崥瀹㈢郴缁?- 椤圭洰 ID: BLOG_{datetime.now().strftime('%Y%m%d')}_001
- 鏃ユ湡锛歿today}
- 鏁翠綋鐘舵€侊細鉁?姝ｅ父杩涜

## 浠婃棩姒傝
"""
    
    # 鏀堕泦鍚?Agent 鏁版嵁
    agents_data = {}
    for agent in ['guantang', 'jiangrou', 'dousha', 'suancai']:
        # 璇诲彇骞跺垎鏋愭棩蹇?        # ... 鐪佺暐鍏蜂綋鍒嗘瀽浠ｇ爜
        agents_data[agent] = {
            'completed': 3,
            'in_progress': 1,
            'issues': 0
        }
    
    # 鐢熸垚琛ㄦ牸
    report += "| Agent | 瀹屾垚浠诲姟 | 杩涜涓?| 閬囧埌闂 |\n"
    report += "|-------|---------|--------|----------|\n"
    for agent, data in agents_data.items():
        report += f"| {agent} | {data['completed']} | {data['in_progress']} | {data['issues']} |\n"
    
    # 淇濆瓨鍒版枃浠?    report_path = f"F:\\openclaw\\workspace\\projects\\BLOG_{datetime.now().strftime('%Y%m%d')}_001\\progress\\daily_{today}.md"
    with open(report_path, 'w', encoding='utf-8') as f:
        f.write(report)
    
    print(f"鏃ユ姤宸茬敓鎴愶細{report_path}")
```

---

## 馃搮 绗竴鍛ㄦ€荤粨

### 鍛ㄤ簲 17:00 - 鐢熸垚鍛ㄦ姤

```python
def generate_weekly_report():
    """鐢熸垚鍛ㄦ姤"""
    week_start = get_week_start_date()
    week_end = get_week_end_date()
    
    report = f"""# 鍛ㄦ姤 - {week_start} 鑷?{week_end}

## 鏈懆缁熻
- 宸ヤ綔澶╂暟锛? 澶?- 鎬诲伐浣滄椂闀匡細XX 灏忔椂
- 瀹屾垚浠诲姟锛歑X 涓?- 閬囧埌闂锛歑X 涓?
## 閲岀▼纰戣揪鎴?鉁?椤圭洰鍚姩
鉁?鐜鎼缓
鈴?鍚庣寮€鍙戜腑

## 涓嬪懆璁″垝
- 瀹屾垚鍚庣 API
- 寮€濮嬪墠绔紑鍙?- 鍑嗗娴嬭瘯鐢ㄤ緥
"""
    
    # 淇濆瓨鎶ュ憡
    # ...
```

---

## 馃幆 闃舵 2: 鍗氬闆嗘垚锛堟湭鏉ワ級

褰撳崥瀹㈡枃绔犳ā鍧楀畬鎴愬悗锛?
### 閰嶇疆鍗氬 API

缂栬緫 `.env` 鏂囦欢锛?```bash
BLOG_API_URL=https://yourblog.com/api
BLOG_API_TOKEN=your_secret_token_here
LOG_SUBMIT_TIME=18:00
AUTO_PUBLISH=false
```

### 鍚敤鑷姩鎻愪氦

淇敼 `config.json`:
```json
{
  "integration": {
    "blog": {
      "enabled": true,
      "auto_submit": true,
      "submit_time": "18:00",
      "status": "draft"
    }
  }
}
```

### 杩愯瀹氭椂浠诲姟

```python
from apscheduler.schedulers.blocking import BlockingScheduler
from blog_integration import submit_logs

scheduler = BlockingScheduler()
scheduler.add_job(submit_logs, 'cron', hour=18, minute=0)
scheduler.start()
```

---

## 鉂?甯歌闂

### Q1: Agent 娌℃湁鍝嶅簲鎬庝箞鍔烇紵

**A:** 
1. 妫€鏌ユ敹浠剁鏄惁鏈夋湭璇绘秷鎭?2. 鏌ョ湅鏃ュ織鏂囦欢瀹氫綅閿欒
3. 閲嶅惎瀵瑰簲 Agent
4. 妫€鏌ヨ祫婧愪娇鐢ㄦ槸鍚﹁秴闄?
### Q2: 鏃ュ織鏂囦欢澶ぇ鎬庝箞鍔烇紵

**A:**
1. 妫€鏌ユ槸鍚﹁褰曚簡杩囧璋冭瘯淇℃伅
2. 纭杞浆绛栫暐鏄惁鐢熸晥
3. 鎵嬪姩褰掓。鏃ф棩蹇?4. 澧炲姞纾佺洏绌洪棿鎴栨竻鐞嗘棤鐢ㄦ枃浠?
### Q3: 濡備綍鏌ョ湅 Agent 鐨勫伐浣滅姸鎬侊紵

**A:**
1. 璇诲彇褰撴棩鏃ュ織鏂囦欢
2. 鏌ョ湅浠诲姟瀹屾垚鏍囪 `[x]` 鏁伴噺
3. 妫€鏌ュ伐浣滄椂闀胯褰?4. 闃呰閬囧埌鐨勯棶棰樺拰鏄庢棩璁″垝

### Q4: 鏈嶅姟鍣ㄥ唴瀛樹笉瓒虫€庝箞鍔烇紵

**A:**
1. 鍋滄闈炲繀瑕佺殑鏈嶅姟
2. 鍑忓皯 Agent 骞跺彂鏁?3. 浣跨敤 swap 绌洪棿锛堜复鏃舵柟妗堬級
4. 鑰冭檻鍗囩骇鍒版湰鍦板紑鍙?
---

## 馃摎 涓嬩竴姝ラ槄璇?
瀹屾垚蹇€熷紑濮嬪悗锛屽缓璁槄璇伙細

1. **[杞婚噺绾фā寮忔寚鍗梋(./lightweight-mode.md)** - 娣卞叆浜嗚В浣庨厤鏈嶅姟鍣ㄤ紭鍖?2. **[Agent 閫氫俊鍗忚](./agent-protocol.md)** - 鐞嗚В鏂囦欢鍏变韩閫氫俊
3. **[鏃ュ織瑙勮寖](./logging-audit.md)** - 瀛︿範鏃ュ織缂栧啓鏍煎紡
4. **[鍗氬闆嗘垚](./blog-integration.md)** - 鍑嗗闃舵 2 闆嗘垚

---

## 馃啒 鑾峰彇甯姪

濡傞亣鍒伴棶棰橈細

1. 鏌ョ湅 [optimization-summary.md](./optimization-summary.md) 浜嗚В浼樺寲缁嗚妭
2. 妫€鏌ユ棩蹇楁枃浠?`F:\openclaw\workspace\logs\`
3. 鍙傝€?GitHub Issues
4. 鑱旂郴椤圭洰缁存姢鑰?
---

*绁濇偍浣跨敤鎰夊揩锛?  
*OpenClaw 鍥㈤槦 - 杞婚噺鐗?v2.0.0*

