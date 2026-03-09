<!-- Last Modified: 2026-03-08 -->
<!-- Last Modified (CN): 2026-03-08 -->

# 馃帀 OpenClaw Agent 鍥㈤槦 - 瀹屾暣鐙珛 Workspace 鏋舵瀯

## 鉁?姝ｇ‘鐨勬枃浠剁粨鏋?
姣忎釜 Agent 鐜板湪閮芥湁鑷繁**瀹屽叏鐙珛**鐨?workspace鏂囦欢澶癸細

```
F:\openclaw\
鈹溾攢鈹€ workspace/                    # 鐏屾堡 (PM) 鐨勫伐浣滅┖闂?鈹?  鈹溾攢鈹€ IDENTITY.md
鈹?  鈹溾攢鈹€ ROLE.md
鈹?  鈹溾攢鈹€ SOUL.md
鈹?  鈹溾攢鈹€ AGENTS.md
鈹?  鈹斺攢鈹€ ... (鍏朵粬鏂囦欢)
鈹?鈹溾攢鈹€ workspace-jiangrou/           # 閰辫倝 (鍚庣) 鐨勭嫭绔嬪伐浣滅┖闂?鈫?鏂板
鈹?  鈹溾攢鈹€ IDENTITY.md
鈹?  鈹溾攢鈹€ ROLE.md
鈹?  鈹溾攢鈹€ SOUL.md
鈹?  鈹溾攢鈹€ logs/
鈹?  鈹溾攢鈹€ tasks/
鈹?  鈹溾攢鈹€ code/
鈹?  鈹溾攢鈹€ communication/
鈹?  鈹斺攢鈹€ docs/
鈹?鈹溾攢鈹€ workspace-dousha/             # 璞嗘矙 (鍓嶇) 鐨勭嫭绔嬪伐浣滅┖闂?鈫?鏂板
鈹?  鈹溾攢鈹€ IDENTITY.md
鈹?  鈹溾攢鈹€ ROLE.md
鈹?  鈹溾攢鈹€ SOUL.md
鈹?  鈹溾攢鈹€ logs/
鈹?  鈹溾攢鈹€ tasks/
鈹?  鈹溾攢鈹€ designs/
鈹?  鈹溾攢鈹€ code/
鈹?  鈹斺攢鈹€ communication/
鈹?鈹斺攢鈹€ workspace-suancai/            # 閰歌彍 (杩愮淮) 鐨勭嫭绔嬪伐浣滅┖闂?鈫?鏂板
    鈹溾攢鈹€ IDENTITY.md
    鈹溾攢鈹€ ROLE.md
    鈹溾攢鈹€ SOUL.md
    鈹溾攢鈹€ logs/
    鈹溾攢鈹€ tasks/
    鈹溾攢鈹€ tests/
    鈹溾攢鈹€ reports/
    鈹斺攢鈹€ communication/
```

## 馃搵 鍚?Agent 鐨勭嫭绔?Workspace

### 1. 閰辫倝 (鍚庣) - `F:\openclaw\workspace-jiangrou`

**瀹屾暣缁撴瀯:**
```
workspace-jiangrou/
鈹溾攢鈹€ IDENTITY.md          # 韬唤淇℃伅
鈹溾攢鈹€ ROLE.md              # 鑱岃矗璇存槑
鈹溾攢鈹€ SOUL.md              # 琛屼负鍑嗗垯
鈹溾攢鈹€ logs/                # 宸ヤ綔鏃ュ織
鈹?  鈹斺攢鈹€ daily_YYYYMMDD.md
鈹溾攢鈹€ tasks/               # 浠诲姟绠＄悊
鈹?  鈹溾攢鈹€ inbox/          # 鏀朵欢绠?鈹?  鈹斺攢鈹€ outbox/         # 鍙戜欢绠?鈹溾攢鈹€ code/                # 鍚庣浠ｇ爜
鈹?  鈹溾攢鈹€ api/
鈹?  鈹溾攢鈹€ models/
鈹?  鈹斺攢鈹€ utils/
鈹溾攢鈹€ communication/       # Agent 閫氫俊
鈹?  鈹溾攢鈹€ inbox/
鈹?  鈹斺攢鈹€ outbox/
鈹斺攢鈹€ docs/                # 鎶€鏈枃妗?    鈹溾攢鈹€ architecture/
    鈹溾攢鈹€ api-docs/
    鈹斺攢鈹€ adr/
```

**Docker 鎸傝浇:**
```yaml
volumes:
  - ./workspace-jiangrou:/workspace
```

### 2. 璞嗘矙 (鍓嶇) - `F:\openclaw\workspace-dousha`

**瀹屾暣缁撴瀯:**
```
workspace-dousha/
鈹溾攢鈹€ IDENTITY.md          # 韬唤淇℃伅
鈹溾攢鈹€ ROLE.md              # 鑱岃矗璇存槑
鈹溾攢鈹€ SOUL.md              # 琛屼负鍑嗗垯
鈹溾攢鈹€ logs/                # 宸ヤ綔鏃ュ織
鈹?  鈹斺攢鈹€ daily_YYYYMMDD.md
鈹溾攢鈹€ tasks/               # 浠诲姟绠＄悊
鈹?  鈹溾攢鈹€ inbox/
鈹?  鈹斺攢鈹€ outbox/
鈹溾攢鈹€ designs/             # 璁捐绋?鈹?  鈹溾攢鈹€ wireframes/
鈹?  鈹溾攢鈹€ mockups/
鈹?  鈹斺攢鈹€ prototypes/
鈹溾攢鈹€ code/                # 鍓嶇浠ｇ爜
鈹?  鈹溾攢鈹€ components/
鈹?  鈹溾攢鈹€ pages/
鈹?  鈹斺攢鈹€ styles/
鈹溾攢鈹€ communication/       # Agent 閫氫俊
鈹?  鈹溾攢鈹€ inbox/
鈹?  鈹斺攢鈹€ outbox/
鈹斺攢鈹€ docs/                # 璁捐鏂囨。
    鈹溾攢鈹€ design-system/
    鈹斺攢鈹€ guidelines/
```

**Docker 鎸傝浇:**
```yaml
volumes:
  - ./workspace-dousha:/workspace
```

### 3. 閰歌彍 (杩愮淮/娴嬭瘯) - `F:\openclaw\workspace-suancai`

**瀹屾暣缁撴瀯:**
```
workspace-suancai/
鈹溾攢鈹€ IDENTITY.md          # 韬唤淇℃伅
鈹溾攢鈹€ ROLE.md              # 鑱岃矗璇存槑
鈹溾攢鈹€ SOUL.md              # 琛屼负鍑嗗垯
鈹溾攢鈹€ logs/                # 宸ヤ綔鏃ュ織
鈹?  鈹斺攢鈹€ daily_YYYYMMDD.md
鈹溾攢鈹€ tasks/               # 浠诲姟绠＄悊
鈹?  鈹溾攢鈹€ inbox/
鈹?  鈹斺攢鈹€ outbox/
鈹溾攢鈹€ tests/               # 娴嬭瘯鑴氭湰
鈹?  鈹溾攢鈹€ functional/
鈹?  鈹溾攢鈹€ performance/
鈹?  鈹斺攢鈹€ automation/
鈹溾攢鈹€ reports/             # 娴嬭瘯鎶ュ憡
鈹?  鈹溾攢鈹€ daily/
鈹?  鈹斺攢鈹€ weekly/
鈹溾攢鈹€ communication/       # Agent 閫氫俊
鈹?  鈹溾攢鈹€ inbox/
鈹?  鈹斺攢鈹€ outbox/
鈹斺攢鈹€ scripts/             # 杩愮淮鑴氭湰
    鈹溾攢鈹€ deploy/
    鈹斺攢鈹€ monitoring/
```

**Docker 鎸傝浇:**
```yaml
volumes:
  - ./workspace-suancai:/workspace
```

## 馃攧 璺?Workspace 閫氫俊

铏界劧姣忎釜 Agent 閮芥湁鐙珛鐨?workspace锛屼絾瀹冧滑閫氳繃**鏂囦欢绯荤粺**杩涜閫氫俊锛?
### 閫氫俊娴佺▼绀轰緥

**鍦烘櫙:** 鐏屾堡缁欓叡鑲夊垎閰嶄换鍔?
```
1. 鐏屾堡鍦?f:\openclaw\workspace\ 鍒涘缓浠诲姟鏂囦欢
   鈫?2. 浠诲姟鏂囦欢鍐呭鎸囧悜閰辫倝鐨?workspace
   {
     "from": "鐏屾堡",
     "to": "閰辫倝",
     "workspace": "F:\\openclaw\\workspace-jiangrou",
     "action": "allocateTask",
     "data": {...}
   }
   鈫?3. 閰辫倝鍦ㄨ嚜宸辩殑 workspace 涓鍙栦换鍔?   F:\openclaw\workspace-jiangrou\tasks\inbox\task_001.json
   鈫?4. 閰辫倝鎵ц浠诲姟骞舵彁浜ゆ垚鏋?   F:\openclaw\workspace-jiangrou\communication\outbox\submit_001.json
   鈫?5. 鐏屾堡璇诲彇鎴愭灉
```

## 馃殌 蹇€熷紑濮?
### 姝ラ 1: 鍒涘缓鎵€鏈夌嫭绔?workspace

杩愯 PowerShell 鑴氭湰锛?
```powershell
cd F:\openclaw\workspace-programmer
.\setup-independent-workspaces.ps1
```

杩欏皢鍒涘缓锛?- `F:\openclaw\workspace-jiangrou\`
- `F:\openclaw\workspace-dousha\`
- `F:\openclaw\workspace-suancai\`

浠ュ強鍚勮嚜鐨勫瓙鐩綍銆?
### 姝ラ 2: 鍒濆鍖栨瘡涓?workspace

姣忎釜 workspace 閮戒細鍖呭惈锛?- 鉁?IDENTITY.md (宸插垱寤?
- 鉁?ROLE.md (寰呭鍒?
- 鉁?SOUL.md (寰呭鍒?
- 鉁?瀹屾暣鐨勭洰褰曠粨鏋?
### 姝ラ 3: 閰嶇疆 Docker Compose

鏇存柊 docker-compose.yml锛?
```yaml
services:
  jiangrou:
    volumes:
      - ./workspace-jiangrou:/workspace
  
  dousha:
    volumes:
      - ./workspace-dousha:/workspace
  
  suancai:
    volumes:
      - ./workspace-suancai:/workspace
```

## 馃搳 浼樺娍瀵规瘮

### 涔嬪墠鐨勫叡浜粨鏋?鉂?
```
workspace/
鈹溾攢鈹€ team/
鈹?  鈹溾攢鈹€ jiangrou/  # 鍙槸瀛愮洰褰?鈹?  鈹溾攢鈹€ dousha/
鈹?  鈹斺攢鈹€ suancai/
```

**闂:**
- 涓嶆槸鐪熸鐙珛
- 渚濊禆鐖剁洰褰?- 鏉冮檺涓嶆竻鏅?- 闅句互鍗曠嫭澶囦唤

### 鐜板湪鐨勭嫭绔嬬粨鏋?鉁?
```
workspace-jiangrou/     # 瀹屽叏鐙珛
workspace-dousha/       # 瀹屽叏鐙珛
workspace-suancai/      # 瀹屽叏鐙珛
```

**浼樺娍:**
- 鉁?姣忎釜 Agent 鏈夎嚜宸辩殑"瀹?
- 鉁?鍙互鍗曠嫭鎸傝浇鍒?Docker
- 鉁?鏉冮檺娓呮櫚鏄庣‘
- 鉁?鏄撲簬澶囦唤鍜岃縼绉?- 鉁?绗﹀悎 Docker 鏈€浣冲疄璺?
## 馃幆 涓嬩竴姝ヨ鍔?
### 绔嬪嵆鎵ц

1. 鉁?闃呰姝ゆ枃妗ｇ悊瑙ｆ柊缁撴瀯
2. 鉁?杩愯 setup 鑴氭湰鍒涘缓鐙珛 workspace
3. 鉁?楠岃瘉姣忎釜 workspace 鐨勬枃浠跺畬鏁存€?4. 鉁?鏇存柊 Docker Compose 閰嶇疆

### 绗竴鍛ㄧ洰鏍?
- [ ] 鎵€鏈?Agent 鍦ㄧ嫭绔?workspace 涓甯歌繍琛?- [ ] 璺?workspace 閫氫俊姝ｅ父
- [ ] 姣忎釜 Agent 鑳界嫭绔嬪～鍐欐棩蹇?- [ ] 浠诲姟鍒嗗彂鍜屾彁浜ゆ祦绋嬮『鐣?
---

**鎭枩锛佷綘鐜板湪鎷ユ湁浜嗙湡姝ｇ嫭绔嬬殑 Agent Workspace 鏋舵瀯锛?* 馃帀

姣忎釜 Agent 閮芥槸 Docker 瀹瑰櫒涓殑鐙珛鍏皯锛屾嫢鏈夎嚜宸辩殑瀹跺拰宸ュ叿锛?
