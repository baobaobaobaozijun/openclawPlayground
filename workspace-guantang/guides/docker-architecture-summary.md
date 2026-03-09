<!-- Last Modified: 2026-03-08 -->
<!-- Last Modified (CN): 2026-03-08 -->

# 馃帀 OpenClaw Agent 鍥㈤槦 - Docker 鏋舵瀯瀹屾垚鎶ュ憡

## 鉁?鏋舵瀯鐞嗚В鏇存

### 涔嬪墠鐨勯敊璇悊瑙?鉂?
- 鎵€鏈?Agent 閮借繍琛屽湪 Windows 涓绘満涓?- 鍙渶瑕佺粺涓€鐨?workspace-programmer 鏂囦欢澶?- 娌℃湁瀹瑰櫒闅旂鐨勬蹇?
### 姝ｇ‘鐨勬灦鏋勭悊瑙?鉁?
```
鈹屸攢鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹?鈹? Windows Host                               鈹?鈹? 鈹屸攢鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹?                      鈹?鈹? 鈹?鐏屾堡 (PM)       鈹?鈫?鍘熺敓杩愯             鈹?鈹? 鈹?f:\openclaw\workspace                    鈹?鈹? 鈹斺攢鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹?                      鈹?鈹?                                            鈹?鈹? 鈹屸攢鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹?  鈹?鈹? 鈹?Docker Desktop for Windows           鈹?  鈹?鈹? 鈹? 鈹屸攢鈹€鈹€鈹€鈹€鈹€鈹€鈹?鈹屸攢鈹€鈹€鈹€鈹€鈹€鈹€鈹?鈹屸攢鈹€鈹€鈹€鈹€鈹€鈹€鈹?    鈹?  鈹?鈹? 鈹? 鈹傞叡鑲?  鈹?鈹傝眴娌?  鈹?鈹傞吀鑿?  鈹?    鈹?  鈹?鈹? 鈹? 鈹傚鍣?  鈹?鈹傚鍣?  鈹?鈹傚鍣?  鈹?    鈹?  鈹?鈹? 鈹? 鈹斺攢鈹€鈹€鈹€鈹€鈹€鈹€鈹?鈹斺攢鈹€鈹€鈹€鈹€鈹€鈹€鈹?鈹斺攢鈹€鈹€鈹€鈹€鈹€鈹€鈹?    鈹?  鈹?鈹? 鈹斺攢鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹?  鈹?鈹斺攢鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹€鈹?```

## 馃搧 宸插垱寤虹殑鏂囦欢缁撴瀯

### 1. 鐏屾堡 (PM) - Windows 鍘熺敓杩愯

**浣嶇疆:** `f:\openclaw\workspace`

**鏂囦欢:**
- 鉁?IDENTITY.md
- 鉁?ROLE.md  
- 鉁?SOUL.md
- 鉁?AGENTS.md (涓绘枃妗?
- 鉁?BOOTSTRAP.md
- 鉁?HEARTBEAT.md
- 鉁?USER.md
- 鉁?TOOLS.md

### 2. 閰辫倝 (鍚庣) - Docker 瀹瑰櫒

**浣嶇疆:** `f:\openclaw\workspace-programmer\jiangrou\`

**宸插垱寤烘枃浠?**
- 鉁?IDENTITY.md - 韬唤淇℃伅
- 鉁?ROLE.md - 鑱岃矗璇存槑
- 鉁?SOUL.md - 琛屼负鍑嗗垯

**闇€瑕佺殑涓绘満鐩綍:**
```
F:\openclaw\workspace\team\jiangrou\
鈹溾攢鈹€ logs/          # 宸ヤ綔鏃ュ織
鈹溾攢鈹€ tasks/         # 浠诲姟绠＄悊
鈹?  鈹溾攢鈹€ inbox/    # 鏀朵欢绠?鈹?  鈹斺攢鈹€ outbox/   # 鍙戜欢绠?鈹斺攢鈹€ designs/      # 璁捐绋?(鍙€?
```

### 3. 璞嗘矙 (鍓嶇) - Docker 瀹瑰櫒

**浣嶇疆:** `f:\openclaw\workspace-programmer\dousha\`

**宸插垱寤烘枃浠?**
- 鉁?IDENTITY.md
- 鉁?ROLE.md
- 鉁?SOUL.md

**闇€瑕佺殑涓绘満鐩綍:**
```
F:\openclaw\workspace\team\dousha\
鈹溾攢鈹€ logs/
鈹溾攢鈹€ tasks/
鈹?  鈹溾攢鈹€ inbox/
鈹?  鈹斺攢鈹€ outbox/
鈹斺攢鈹€ designs/      # 璁捐绋垮拰鍘熷瀷
```

### 4. 閰歌彍 (杩愮淮/娴嬭瘯) - Docker 瀹瑰櫒

**浣嶇疆:** `f:\openclaw\workspace-programmer\suancai\`

**宸插垱寤烘枃浠?**
- 鉁?IDENTITY.md
- 鉁?ROLE.md
- 鉁?SOUL.md

**闇€瑕佺殑涓绘満鐩綍:**
```
F:\openclaw\workspace\team\suancai\
鈹溾攢鈹€ logs/
鈹溾攢鈹€ tasks/
鈹?  鈹溾攢鈹€ inbox/
鈹?  鈹斺攢鈹€ outbox/
鈹溾攢鈹€ tests/        # 娴嬭瘯鑴氭湰
鈹斺攢鈹€ reports/      # 娴嬭瘯鎶ュ憡
```

### 5. 鍏变韩閫氫俊鐩綍

**浣嶇疆:** `F:\openclaw\workspace\communication\`

**缁撴瀯:**
```
communication/
鈹溾攢鈹€ inbox/
鈹?  鈹溾攢鈹€ jiangrou/    # 閰辫倝鐨勬敹浠剁
鈹?  鈹溾攢鈹€ dousha/      # 璞嗘矙鐨勬敹浠剁
鈹?  鈹斺攢鈹€ suancai/     # 閰歌彍鐨勬敹浠剁
鈹溾攢鈹€ outbox/
鈹?  鈹溾攢鈹€ guantang/    # 鍙戠粰鐏屾堡鐨?鈹?  鈹溾攢鈹€ jiangrou/    # 閰辫倝鍙戝嚭鐨?鈹?  鈹溾攢鈹€ dousha/      # 璞嗘矙鍙戝嚭鐨?鈹?  鈹斺攢鈹€ suancai/     # 閰歌彍鍙戝嚭鐨?鈹斺攢鈹€ archive/         # 鍘嗗彶娑堟伅褰掓。
```

## 馃搵 鏍稿績鏂囨。瀵规瘮

### workspace-programmer (鍘熸湁)

鍖呭惈瀹屾暣鐨勯厤缃紭鍖栨枃妗?
- 鉁?README.md (杞婚噺鐗?
- 鉁?agent-protocol.md
- 鉁?logging-audit.md
- 鉁?progress-tracking.md
- 鉁?command-specification.md
- 鉁?lightweight-mode.md
- 鉁?blog-integration.md
- 鉁?workspace-jiangrou.md (鍚庣鎸囧崡)
- 鉁?workspace-dousha.md (鍓嶇鎸囧崡)
- 鉁?workspace-suancai.md (杩愮淮鎸囧崡)
- 鉁?绛夌瓑...

### jiangrou/dousha/suancai (鏂板缓)

姣忎釜 Agent 鐙珛鐨?鐏甸瓊涓変欢濂?:
- 鉁?IDENTITY.md - "鎴戞槸璋?
- 鉁?ROLE.md - "鎴戝仛浠€涔?
- 鉁?SOUL.md - "鎴戞€庝箞鍋?

## 馃攧 閫氫俊娴佺▼

### 鐏屾堡 鈫?閰辫倝 (浠诲姟鍒嗗彂)

```
1. 鐏屾堡鍒涘缓浠诲姟鏂囦欢
   F:\openclaw\workspace\communication\inbox\jiangrou\task_001.json

2. 閰辫倝瀹瑰櫒璇诲彇鏂囦欢
   /workspace/communication/inbox/jiangrou/task_001.json

3. 閰辫倝鎵ц浠诲姟骞剁‘璁?   鍐欏叆锛?workspace/communication/outbox/guantang/ack_001.json

4. 鐏屾堡璇诲彇纭
   F:\openclaw\workspace\communication\outbox\jiangrou\ack_001.json
```

### 閰辫倝 鈫?鐏屾堡 (鎴愭灉鎻愪氦)

```
1. 閰辫倝瀹屾垚浠诲姟
   浠ｇ爜淇濆瓨鍦細/workspace/code/

2. 閰辫倝鍒涘缓鎻愪氦鏂囦欢
   /workspace/communication/outbox/guantang/submit_001.json

3. 鐏屾堡璇诲彇鎻愪氦
   F:\openclaw\workspace\communication\outbox\suancai\submit_001.json

4. 鐏屾堡楠屾敹骞跺叧闂换鍔?```

## 馃殌 蹇€熷惎鍔ㄦ祦绋?
### 姝ラ 1: 鍒涘缓鐩綍缁撴瀯

```powershell
# 鍦?PowerShell 涓繍琛?$directories = @(
    "F:\openclaw\workspace\team\jiangrou\logs",
    "F:\openclaw\workspace\team\jiangrou\tasks\inbox",
    "F:\openclaw\workspace\team\jiangrou\tasks\outbox",
    "F:\openclaw\workspace\team\dousha\logs",
    "F:\openclaw\workspace\team\dousha\tasks\inbox",
    "F:\openclaw\workspace\team\dousha\tasks\outbox",
    "F:\openclaw\workspace\team\dousha\designs",
    "F:\openclaw\workspace\team\suancai\logs",
    "F:\openclaw\workspace\team\suancai\tasks\inbox",
    "F:\openclaw\workspace\team\suancai\tasks\outbox",
    "F:\openclaw\workspace\team\suancai\tests",
    "F:\openclaw\workspace\team\suancai\reports",
    "F:\openclaw\workspace\communication\inbox\jiangrou",
    "F:\openclaw\workspace\communication\inbox\dousha",
    "F:\openclaw\workspace\communication\inbox\suancai",
    "F:\openclaw\workspace\communication\outbox\guantang",
    "F:\openclaw\workspace\communication\outbox\jiangrou",
    "F:\openclaw\workspace\communication\outbox\dousha",
    "F:\openclaw\workspace\communication\outbox\suancai",
    "F:\openclaw\workspace\communication\archive"
)

foreach ($dir in $directories) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}
```

### 姝ラ 2: 鍑嗗 Docker 閰嶇疆

```bash
# 杩涘叆椤圭洰鐩綍
cd f:\openclaw\workspace-programmer

# 妫€鏌?Docker 鏄惁杩愯
docker --version
docker-compose --version
```

### 姝ラ 3: 鏋勫缓鍜屽惎鍔ㄥ鍣?
```bash
# 鏋勫缓鎵€鏈夐暅鍍?docker-compose build

# 鍚姩鎵€鏈夊鍣?docker-compose up -d

# 鏌ョ湅鐘舵€?docker-compose ps

# 鏌ョ湅鏃ュ織
docker-compose logs -f
```

### 姝ラ 4: 楠岃瘉閫氫俊

```bash
# 鍒涘缓娴嬭瘯浠诲姟鏂囦欢
echo '{"from":"鐏屾堡","to":"閰辫倝","action":"test","data":{},"timestamp":"2026-03-07T10:00:00Z"}' > \
F:\openclaw\workspace\communication\inbox\jiangrou\test.json

# 绛夊緟 30 绉掑悗妫€鏌ラ叡鑲夋槸鍚﹁鍙?# 鏌ョ湅閰辫倝瀹瑰櫒鏃ュ織
docker-compose logs jiangrou
```

## 馃搳 璧勬簮鍒嗛厤鎬荤粨

| Agent | 杩愯鐜 | CPU 闄愬埗 | 鍐呭瓨闄愬埗 | 瀛樺偍 |
|-------|---------|---------|---------|------|
| 鐏屾堡 | Windows 鍘熺敓 | 涓嶉檺 | ~256MB | ~1GB |
| 閰辫倝 | Docker | 1.0 鏍稿績 | 256MB | ~500MB |
| 璞嗘矙 | Docker | 1.0 鏍稿績 | 256MB | ~500MB |
| 閰歌彍 | Docker | 0.5 鏍稿績 | 128MB | ~300MB |
| **鎬昏** | - | **2.5 鏍稿績** | **~1GB** | **~2.3GB** |

## 馃幆 涓嬩竴姝ヨ鍔?
### 绔嬪嵆鍙互鍋氱殑

1. 鉁?闃呰 [docker-deployment-guide.md](./docker-deployment-guide.md)
2. 鉁?鍒涘缓蹇呰鐨勭洰褰曠粨鏋?3. 鉁?鍑嗗 Docker Compose 閰嶇疆
4. 鉁?娴嬭瘯瀹瑰櫒鍚姩

### 绗竴鍛ㄧ洰鏍?
- [ ] 鎵€鏈夊鍣ㄦ甯歌繍琛?- [ ] 鏂囦欢绯荤粺閫氫俊姝ｅ父
- [ ] 姣忎釜 Agent 鑳界嫭绔嬪～鍐欐棩蹇?- [ ] 鐏屾堡鑳藉垎鍙戜换鍔＄粰鍏朵粬 Agent
- [ ] 鍏朵粬 Agent 鑳芥彁浜ゆ垚鏋滅粰鐏屾堡

### 绗竴涓湀鐩爣

- [ ] 寤虹珛瀹屾暣鐨勫伐浣滄祦绋?- [ ] 浼樺寲璧勬簮閰嶇疆
- [ ] 瀹炴柦鍗氬闆嗘垚 (闃舵 2)
- [ ] 鎬荤粨缁忛獙鏁欒

---

**鎭枩锛佷綘鐜板湪鎷ユ湁浜嗕竴涓湡姝ｇ殑娣峰悎鏋舵瀯 Agent 鍥㈤槦:**
- **鐏屾堡**鍦?Windows 涓绘満涓婄粺绛瑰叏灞€
- **閰辫倝銆佽眴娌欍€侀吀鑿?*鍦?Docker 瀹瑰櫒涓悇鍙稿叾鑱?- **鏂囦欢绯荤粺**浣滀负妗ユ杩炴帴鎵€鏈?Agent

**寮€濮嬪姩鎵嬫惌寤哄惂锛?* 馃殌

