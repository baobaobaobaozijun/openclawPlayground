<!-- Last Modified: 2026-03-09 -->
<!-- Last Modified (CN): 2026-03-09 -->

# OpenClaw 椤圭洰鏋舵瀯鎬昏

馃彈锔?**Agent 鍥㈤槦鍗忎綔涓庡伐绋嬫灦鏋?*

*鏈€鍚庢洿鏂帮細2026-03-09*

---

## 馃搵 椤圭洰姒傝堪

OpenClaw 鏄竴涓熀浜庡 Agent 鍗忎綔鐨勮蒋浠跺紑鍙戝钩鍙帮紝閲囩敤**閰嶇疆涓庝唬鐮佸垎绂汇€佸伐浣滃彴鐙珛銆佸鍣ㄥ寲閮ㄧ讲**鐨勭幇浠ｅ寲鏋舵瀯璁捐銆?
鏈」鐩敮鎸侀€氳繃 Docker Compose 蹇€熼儴缃插涓?OpenClaw Agent 瀹炰緥锛屾瘡涓?Agent 鎷ユ湁鐙珛鐨勫伐浣滅┖闂村拰閰嶇疆鏂囦欢锛屽悓鏃跺叡浜粺涓€鐨勪唬鐮佸伐绋嬬洰褰曘€?
---

## 馃彌锔?鏁翠綋鏋舵瀯

### 鏍稿績鐩綍缁撴瀯

```
f:\openclaw/
鈹?鈹溾攢鈹€ agent/                          # 馃 Agent 閰嶇疆涓庡伐浣滃尯
鈹?  鈹溾攢鈹€ ARCHITECTURE.md            # 鏈枃浠?- 椤圭洰鏋舵瀯璇存槑
鈹?  鈹?鈹?  鈹溾攢鈹€ workspace-guantang/        # 馃搵 PM/椤圭洰缁忕悊宸ヤ綔鍙?鈹?  鈹?  鈹溾攢鈹€ .openclaw/             # 宸ヤ綔鍖虹姸鎬侀厤缃?鈹?  鈹?  鈹溾攢鈹€ IDENTITY.md            # 銆愭牳蹇冦€戠亴姹よ韩浠借鐭?鈹?  鈹?  鈹溾攢鈹€ ROLE.md                # 銆愭牳蹇冦€戠亴姹よ亴璐ｈ鑼?鈹?  鈹?  鈹溾攢鈹€ SOUL.md                # 銆愭牳蹇冦€戠亴姹よ涓哄噯鍒?鈹?  鈹?  鈹溾攢鈹€ AGENTS.md              # 鍥㈤槦鍗忎綔瑙勮寖
鈹?  鈹?  鈹溾攢鈹€ BOOTSTRAP.md           # 鍚姩鎸囧崡
鈹?  鈹?  鈹溾攢鈹€ HEARTBEAT.md           # 蹇冭烦鏈哄埗
鈹?  鈹?  鈹溾攢鈹€ TOOLS.md               # 宸ュ叿浣跨敤
鈹?  鈹?  鈹溾攢鈹€ USER.md                # 鐢ㄦ埛淇℃伅
鈹?  鈹?  鈹溾攢鈹€ README.md              # 宸ヤ綔鍙拌鏄?鈹?  鈹?  鈹?鈹?  鈹?  鈹溾攢鈹€ agent-configs/         # 鍚?Agent 鎶€鏈鑼冨浠斤紙鍙傝€冩枃妗ｏ級
鈹?  鈹?  鈹?  鈹溾攢鈹€ jiangrou/         # 閰辫倝鎶€鏈爤璇︽儏
鈹?  鈹?  鈹?  鈹?  鈹溾攢鈹€ IDENTITY.md
鈹?  鈹?  鈹?  鈹?  鈹溾攢鈹€ ROLE.md
鈹?  鈹?  鈹?  鈹?  鈹溾攢鈹€ SOUL.md
鈹?  鈹?  鈹?  鈹?  鈹斺攢鈹€ README.md     # 瀹屾暣鎶€鏈枃妗?鈹?  鈹?  鈹?  鈹溾攢鈹€ dousha/           # 璞嗘矙鎶€鏈鑼?鈹?  鈹?  鈹?  鈹?  鈹溾攢鈹€ IDENTITY.md
鈹?  鈹?  鈹?  鈹?  鈹溾攢鈹€ ROLE.md
鈹?  鈹?  鈹?  鈹?  鈹溾攢鈹€ SOUL.md
鈹?  鈹?  鈹?  鈹?  鈹斺攢鈹€ README.md     # 瀹屾暣鎶€鏈枃妗?鈹?  鈹?  鈹?  鈹斺攢鈹€ suancai/          # 閰歌彍杩愮淮瀹炶返
鈹?  鈹?  鈹?      鈹溾攢鈹€ IDENTITY.md
鈹?  鈹?  鈹?      鈹溾攢鈹€ ROLE.md
鈹?  鈹?  鈹?      鈹溾攢鈹€ SOUL.md
鈹?  鈹?  鈹?      鈹斺攢鈹€ README.md     # 瀹屾暣鎶€鏈枃妗?鈹?  鈹?  鈹?鈹?  鈹?  鈹溾攢鈹€ config-samples/       # 閰嶇疆绀轰緥澶囦唤
鈹?  鈹?  鈹溾攢鈹€ guides/               # 浣跨敤鎸囧崡
鈹?  鈹?  鈹溾攢鈹€ specs/                # 瑙勮寖鏂囨。
鈹?  鈹?  鈹斺攢鈹€ logs/                 # 宸ヤ綔鏃ュ織褰掓。
鈹?  鈹?鈹?  鈹溾攢鈹€ workspace-jiangrou/        # 馃ォ 閰辫倝宸ヤ綔鍙?猸?鈹?  鈹?  鈹溾攢鈹€ IDENTITY.md           # 銆愭牳蹇冦€戣韩浠借鐭?鈹?  鈹?  鈹溾攢鈹€ ROLE.md               # 銆愭牳蹇冦€戣亴璐ｈ鑼?鈹?  鈹?  鈹溾攢鈹€ SOUL.md               # 銆愭牳蹇冦€戣涓哄噯鍒?鈹?  鈹?  鈹溾攢鈹€ README.md             # 宸ヤ綔鍙拌鏄?鈹?  鈹?  鈹溾攢鈹€ .gitignore            # Git 蹇界暐閰嶇疆
鈹?  鈹?  鈹溾攢鈹€ tasks/                # 浠诲姟绠＄悊
鈹?  鈹?  鈹?  鈹溾攢鈹€ inbox/
鈹?  鈹?  鈹?  鈹斺攢鈹€ outbox/
鈹?  鈹?  鈹溾攢鈹€ communication/        # 娌熼€氳褰?鈹?  鈹?  鈹?  鈹溾攢鈹€ inbox/
鈹?  鈹?  鈹?  鈹斺攢鈹€ outbox/
鈹?  鈹?  鈹斺攢鈹€ logs/                 # 宸ヤ綔鏃ュ織
鈹?  鈹?鈹?  鈹溾攢鈹€ workspace-dousha/          # 馃崱 璞嗘矙宸ヤ綔鍙?猸?鈹?  鈹?  鈹溾攢鈹€ IDENTITY.md           # 銆愭牳蹇冦€戣韩浠借鐭?鈹?  鈹?  鈹溾攢鈹€ ROLE.md               # 銆愭牳蹇冦€戣亴璐ｈ鑼?鈹?  鈹?  鈹溾攢鈹€ SOUL.md               # 銆愭牳蹇冦€戣涓哄噯鍒?鈹?  鈹?  鈹溾攢鈹€ README.md             # 宸ヤ綔鍙拌鏄?鈹?  鈹?  鈹溾攢鈹€ .gitignore            # Git 蹇界暐閰嶇疆
鈹?  鈹?  鈹溾攢鈹€ tasks/                # 浠诲姟绠＄悊
鈹?  鈹?  鈹?  鈹溾攢鈹€ inbox/
鈹?  鈹?  鈹?  鈹斺攢鈹€ outbox/
鈹?  鈹?  鈹溾攢鈹€ designs/              # 璁捐璧勬簮
鈹?  鈹?  鈹溾攢鈹€ communication/        # 娌熼€氳褰?鈹?  鈹?  鈹?  鈹溾攢鈹€ inbox/
鈹?  鈹?  鈹?  鈹斺攢鈹€ outbox/
鈹?  鈹?  鈹斺攢鈹€ logs/                 # 宸ヤ綔鏃ュ織
鈹?  鈹?鈹?  鈹溾攢鈹€ workspace-suancai/         # 馃ガ 閰歌彍宸ヤ綔鍙?猸?鈹?  鈹?  鈹溾攢鈹€ IDENTITY.md           # 銆愭牳蹇冦€戣韩浠借鐭?鈹?  鈹?  鈹溾攢鈹€ ROLE.md               # 銆愭牳蹇冦€戣亴璐ｈ鑼?鈹?  鈹?  鈹溾攢鈹€ SOUL.md               # 銆愭牳蹇冦€戣涓哄噯鍒?鈹?  鈹?  鈹溾攢鈹€ README.md             # 宸ヤ綔鍙拌鏄?鈹?  鈹?  鈹溾攢鈹€ .gitignore            # Git 蹇界暐閰嶇疆
鈹?  鈹?  鈹溾攢鈹€ tasks/                # 浠诲姟绠＄悊
鈹?  鈹?  鈹?  鈹溾攢鈹€ inbox/
鈹?  鈹?  鈹?  鈹斺攢鈹€ outbox/
鈹?  鈹?  鈹溾攢鈹€ communication/        # 娌熼€氳褰?鈹?  鈹?  鈹?  鈹溾攢鈹€ inbox/
鈹?  鈹?  鈹?  鈹斺攢鈹€ outbox/
鈹?  鈹?  鈹斺攢鈹€ logs/                 # 宸ヤ綔鏃ュ織
鈹?  鈹?鈹?  鈹斺攢鈹€ deployment-2026-03-08/     # 馃敡 Docker 閮ㄧ讲閰嶇疆
鈹?      鈹溾攢鈹€ docker-compose/       # Docker Compose 缂栨帓
鈹?      鈹?  鈹溾攢鈹€ docker-compose.yml           # 鍗曞疄渚嬮厤缃?鈹?      鈹?  鈹溾攢鈹€ docker-compose-agents.yml    # 涓夊鍣ㄧ紪鎺掞紙鎺ㄨ崘锛?鈹?      鈹?  鈹斺攢鈹€ docker-compose-searxng.yml   # SearXNG 鎼滅储寮曟搸
鈹?      鈹溾攢鈹€ scripts/              # 鍒濆鍖栧拰娴嬭瘯鑴氭湰
鈹?      鈹?  鈹溾攢鈹€ init-docker-containers.py    # Python 鍒濆鍖?鈹?      鈹?  鈹斺攢鈹€ test-connectivity.ps1        # PowerShell 娴嬭瘯
鈹?      鈹溾攢鈹€ searxng-configs/      # SearXNG 閰嶇疆
鈹?      鈹?  鈹溾攢鈹€ dousha/           # 璞嗘矙璁捐璧勬簮鎼滅储
鈹?      鈹?  鈹溾攢鈹€ jiangrou/         # 閰辫倝鎶€鏈皟鐮旀悳绱?鈹?      鈹?  鈹斺攢鈹€ suancai/          # 閰歌彍杩愮淮鐭ヨ瘑鎼滅储
鈹?      鈹溾攢鈹€ json-files/           # JSON 閰嶇疆鏂囦欢
鈹?      鈹?  鈹溾攢鈹€ comm-config.json  # 閫氫俊閰嶇疆
鈹?      鈹?  鈹溾攢鈹€ onboarding-*.json # 鍏ヨ亴浠诲姟妯℃澘
鈹?      鈹?  鈹斺攢鈹€ test-message.json # 娴嬭瘯娑堟伅
鈹?      鈹斺攢鈹€ RESTORE_COMPLETE.md   # 鎭㈠鎶ュ憡
鈹?鈹溾攢鈹€ code/                           # 馃捇 瀹為檯宸ョ▼椤圭洰
鈹?  鈹溾攢鈹€ backend/                   # 鍚庣宸ョ▼锛圝ava + Spring Boot锛?鈹?  鈹?  鈹溾攢鈹€ src/                   # 婧愪唬鐮?鈹?  鈹?  鈹?  鈹斺攢鈹€ main/
鈹?  鈹?  鈹?      鈹溾攢鈹€ java/         # Java 浠ｇ爜
鈹?  鈹?  鈹?      鈹斺攢鈹€ resources/    # 閰嶇疆鏂囦欢
鈹?  鈹?  鈹溾攢鈹€ pom.xml               # Maven 閰嶇疆
鈹?  鈹?  鈹溾攢鈹€ Dockerfile            # Docker 闀滃儚
鈹?  鈹?  鈹斺攢鈹€ README.md             # 宸ョ▼璇存槑
鈹?  鈹?鈹?  鈹溾攢鈹€ frontend/                  # 鍓嶇宸ョ▼锛圴ue + TypeScript锛?鈹?  鈹?  鈹溾攢鈹€ src/                   # 婧愪唬鐮?鈹?  鈹?  鈹?  鈹溾攢鈹€ components/       # 缁勪欢
鈹?  鈹?  鈹?  鈹溾攢鈹€ views/            # 瑙嗗浘
鈹?  鈹?  鈹?  鈹溾攢鈹€ composables/      # 缁勫悎寮忓嚱鏁?鈹?  鈹?  鈹?  鈹溾攢鈹€ stores/           # 鐘舵€佺鐞?鈹?  鈹?  鈹?  鈹溾攢鈹€ router/           # 璺敱
鈹?  鈹?  鈹?  鈹溾攢鈹€ api/              # API 鎺ュ彛
鈹?  鈹?  鈹?  鈹斺攢鈹€ assets/           # 璧勬簮
鈹?  鈹?  鈹溾攢鈹€ public/               # 鍏叡鏂囦欢
鈹?  鈹?  鈹溾攢鈹€ package.json          # NPM 閰嶇疆
鈹?  鈹?  鈹溾攢鈹€ vite.config.ts        # Vite 閰嶇疆
鈹?  鈹?  鈹溾攢鈹€ tsconfig.json         # TypeScript 閰嶇疆
鈹?  鈹?  鈹斺攢鈹€ README.md             # 宸ョ▼璇存槑
鈹?  鈹?鈹?  鈹溾攢鈹€ deploy/                    # 閮ㄧ讲鑴氭湰
鈹?  鈹?  鈹溾攢鈹€ docker/               # Docker 閰嶇疆
鈹?  鈹?  鈹溾攢鈹€ kubernetes/           # K8s 閰嶇疆锛堝彲閫夛級
鈹?  鈹?  鈹溾攢鈹€ scripts/              # 閮ㄧ讲鑴氭湰
鈹?  鈹?  鈹溾攢鈹€ environments/         # 鐜閰嶇疆
鈹?  鈹?  鈹斺攢鈹€ README.md             # 閮ㄧ讲璇存槑
鈹?  鈹?鈹?  鈹斺攢鈹€ tests/                     # 娴嬭瘯鑴氭湰
鈹?      鈹溾攢鈹€ unit/                 # 鍗曞厓娴嬭瘯
鈹?      鈹溾攢鈹€ integration/          # 闆嗘垚娴嬭瘯
鈹?      鈹溾攢鈹€ performance/          # 鎬ц兘娴嬭瘯
鈹?      鈹溾攢鈹€ e2e/                  # E2E 娴嬭瘯
鈹?      鈹溾攢鈹€ scripts/              # 娴嬭瘯鑴氭湰
鈹?      鈹斺攢鈹€ README.md             # 娴嬭瘯璇存槑
鈹?鈹斺攢鈹€ .lingma/                        # Lingma IDE 閰嶇疆
    鈹溾攢鈹€ agents/                    # Agent 閰嶇疆
    鈹斺攢鈹€ skills/                    # 鎶€鑳介厤缃?```

---

## 馃懃 Agent 瑙掕壊涓庤亴璐?
### 馃嵅 鐏屾堡 (Guantang) - PM/椤圭洰缁忕悊

**宸ヤ綔绌洪棿:** `agent/workspace-guantang/`  


**鏍稿績鑱岃矗:**
- 浜у搧瑙勫垝涓庨渶姹傚垎鏋?- 椤圭洰杩涘害绠＄悊
- 鍥㈤槦鍗忚皟涓庡喅绛?- 璐ㄩ噺鎶婃帶涓庨獙鏀?- 绠＄悊鎵€鏈?Agent 鐨勯厤缃枃妗?
**绠＄悊鍐呭:**
- `agent-configs/` - 鍚?Agent 鐨勬妧鏈鑼冨浠斤紙鍙傝€冩枃妗ｏ級
- `guides/` - 浣跨敤鎸囧崡鍜屾暀绋?- `specs/` - 绯荤粺瑙勮寖鍜屾灦鏋勬枃妗?- `logs/` - 鍥㈤槦宸ヤ綔鏃ュ織褰掓。

**鏍稿績閰嶇疆鏂囦欢:**
- [IDENTITY.md](./workspace-guantang/IDENTITY.md) - 韬唤璁ょ煡
- [ROLE.md](./workspace-guantang/ROLE.md) - 鑱岃矗瑙勮寖
- [SOUL.md](./workspace-guantang/SOUL.md) - 琛屼负鍑嗗垯
- [AGENTS.md](./workspace-guantang/AGENTS.md) - 鍥㈤槦鍗忎綔瑙勮寖
- [BOOTSTRAP.md](./workspace-guantang/BOOTSTRAP.md) - 鍚姩鎸囧崡

---

### 馃ォ 閰辫倝 (Jiangrou) - 鍚庣宸ョ▼甯?
**宸ヤ綔绌洪棿:** `agent/workspace-jiangrou/`  
**GitHub 浠撳簱:** https://github.com/baobaobaobaozijun/openclaw-backend  
**浠ｇ爜宸ョ▼:** `code/backend/`

**鏍稿績閰嶇疆鏂囦欢:** 猸?**鍚姩蹇呭**
- [IDENTITY.md](./workspace-jiangrou/IDENTITY.md) - 韬唤璁ょ煡
- [ROLE.md](./workspace-jiangrou/ROLE.md) - 鑱岃矗瑙勮寖
- [SOUL.md](./workspace-jiangrou/SOUL.md) - 琛屼负鍑嗗垯

**鏍稿績鑱岃矗:**
- 鎶€鏈灦鏋勮璁?- 鍚庣 API 寮€鍙?- 鏁版嵁搴撹璁?- 鎬ц兘浼樺寲

**鎶€鏈爤:**
- **璇█:** Java 21 (LTS)
- **妗嗘灦:** Spring Boot 3.2+
- **鏁版嵁搴?** MySQL 8.0+
- **缂撳瓨:** Redis 7.0+
- **鏋勫缓:** Maven 3.9+

**宸ヤ綔娴佺▼:**
1. 鍦?`workspace-jiangrou/tasks/inbox/` 鎺ユ敹浠诲姟
2. 鍦?`workspace-jiangrou/communication/` 涓矡閫?3. 鍦?`code/backend/` 涓紪鍐欎唬鐮?4. 鎻愪氦鍒扮嫭绔嬬殑浠ｇ爜浠撳簱

**璇︾粏鎶€鏈枃妗?** [agent/workspace-guantang/agent-configs/jiangrou/README.md](./workspace-guantang/agent-configs/jiangrou/README.md)

---

### 馃崱 璞嗘矙 (Dousha) - 鍓嶇宸ョ▼甯?UIUX璁捐甯?
**宸ヤ綔绌洪棿:** `agent/workspace-dousha/`  
**GitHub 浠撳簱:** https://github.com/baobaobaobaozijun/openclaw-frontend  
**浠ｇ爜宸ョ▼:** `code/frontend/`

**鏍稿績閰嶇疆鏂囦欢:** 猸?**鍚姩蹇呭**
- [IDENTITY.md](./workspace-dousha/IDENTITY.md) - 韬唤璁ょ煡
- [ROLE.md](./workspace-dousha/ROLE.md) - 鑱岃矗瑙勮寖
- [SOUL.md](./workspace-dousha/SOUL.md) - 琛屼负鍑嗗垯

**鏍稿績鑱岃矗:**
- UI/UX璁捐
- 鍓嶇椤甸潰寮€鍙?- 鍝嶅簲寮忛€傞厤
- 鎬ц兘浼樺寲

**鎶€鏈爤:**
- **妗嗘灦:** Vue 3.4+ (Composition API)
- **璇█:** TypeScript 5.x
- **鏋勫缓:** Vite 5.x
- **UI:** Element Plus
- **鏍峰紡:** Tailwind CSS

**宸ヤ綔娴佺▼:**
1. 鍦?`workspace-dousha/tasks/inbox/` 鎺ユ敹浠诲姟
2. 鏌ョ湅 `workspace-dousha/designs/` 璁捐绋?3. 鍦ㄦ矡閫氭枃浠朵腑鎻愰棶
4. 鍦?`code/frontend/` 涓疄鐜扮晫闈?
**璇︾粏鎶€鏈枃妗?** [agent/workspace-guantang/agent-configs/dousha/README.md](./workspace-guantang/agent-configs/dousha/README.md)

---

### 馃ガ 閰歌彍 (Suancai) - 杩愮淮/娴嬭瘯宸ョ▼甯?
**宸ヤ綔绌洪棿:** `agent/workspace-suancai/`  
**GitHub 浠撳簱:** https://github.com/baobaobaobaozijun/openclaw-devops  
**宸ヤ綔鐩綍:** `code/deploy/`, `code/tests/`

**鏍稿績閰嶇疆鏂囦欢:** 猸?**鍚姩蹇呭**
- [IDENTITY.md](./workspace-suancai/IDENTITY.md) - 韬唤璁ょ煡
- [ROLE.md](./workspace-suancai/ROLE.md) - 鑱岃矗瑙勮寖
- [SOUL.md](./workspace-suancai/SOUL.md) - 琛屼负鍑嗗垯

**鏍稿績鑱岃矗:**
- 绯荤粺閮ㄧ讲涓庡鍣ㄥ寲
- CI/CD娴佺▼寤鸿
- 鐩戞帶鍛婅閰嶇疆
- 鑷姩鍖栨祴璇?- 鏃ュ織绠＄悊

**鎶€鏈爤:**
- **瀹瑰櫒:** Docker + Docker Compose
- **CI/CD:** GitHub Actions
- **鐩戞帶:** Prometheus + Grafana
- **娴嬭瘯:** JUnit 5, Testcontainers, Gatling
- **鏃ュ織:** ELK Stack

**宸ヤ綔娴佺▼:**
1. 鍦?`workspace-suancai/tasks/inbox/` 鎺ユ敹浠诲姟
2. 閰嶇疆娴嬭瘯鐜
3. 鍦?`code/deploy/`銆乣code/tests/` 涓紪鍐欒剼鏈?4. 鎵ц娴嬭瘯骞剁敓鎴愭姤鍛?
**璇︾粏鎶€鏈枃妗?** [agent/workspace-guantang/agent-configs/suancai/README.md](./workspace-guantang/agent-configs/suancai/README.md)

---

### 馃敡 绋嬪簭鍛?(Programmer) - 棰勭暀瑙掕壊

**宸ヤ綔绌洪棿:** `agent/workspace-programmer/`

杩欐槸涓€涓鐣欑殑宸ヤ綔绌洪棿锛岀洰鍓嶅寘鍚熀纭€鐨勬ā鏉挎枃浠讹細
- [IDENTITY.md](./workspace-programmer/IDENTITY.md) - 韬唤璁ょ煡妯℃澘
- [AGENTS.md](./workspace-programmer/AGENTS.md) - 鍥㈤槦鍗忎綔
- [BOOTSTRAP.md](./workspace-programmer/BOOTSTRAP.md) - 鍚姩鎸囧崡
- [HEARTBEAT.md](./workspace-programmer/HEARTBEAT.md) - 蹇冭烦鏈哄埗

鍙互鏍规嵁闇€瑕佹墿灞曚负鐗瑰畾瑙掕壊鐨勫伐浣滃彴銆?
---
---

## 馃攧 宸ヤ綔娴佺▼

### 1. 闇€姹傚垎鍙戦樁娈?
```
鐏屾堡 (PM)
  鈫?鍒涘缓浠诲姟鏂囦欢 鈫?agent/workspace-{agent}/tasks/inbox/TASK-XXX.md
  鈫?鎸囧畾浼樺厛绾у拰鎴鏃堕棿
```

### 2. 浠诲姟鎵ц闃舵

```
Agent 鎺ユ敹浠诲姟
  鈫?闃呰浠诲姟鏂囦欢锛岀悊瑙ｉ渶姹?  鈫?闇€瑕佹矡閫氾紵
  鈹溾攢 鏄?鈫?鍦?agent/workspace-{agent}/communication/ 涓褰?  鈹斺攢 鍚?鈫?寮€濮嬪伐浣?        鈫?        鍒囨崲鍒?code/{backend|frontend|deploy|tests}
        鈫?        寮€鍙?瀹炴柦
        鈫?        鎻愪氦浠ｇ爜鍒扮嫭绔嬩粨搴?        鈫?        鏇存柊浠诲姟鐘舵€侊細inbox 鈫?outbox 鈫?completed
```

### 3. 鍗忎綔娌熼€氭満鍒?
**娌熼€氬満鏅?**
- **闇€姹備笉鏄庣‘** 鈫?鑱旂郴鐏屾堡锛圥M锛?- **API 鎺ュ彛鍙樻洿** 鈫?鍚庣 鈫?鍓嶇娌熼€?- **閮ㄧ讲閰嶇疆闂** 鈫?寮€鍙?鈫?杩愮淮娌熼€?
**娌熼€氭柟寮?**
- 鍦?`agent/workspace-{agent}/communication/` 鐩綍涓垱寤?Markdown 鏂囦欢
- 璁板綍闂銆佽璁鸿繃绋嬨€佹渶缁堝喅绛?- 浣滀负鍥㈤槦鐭ヨ瘑搴撴案涔呬繚瀛?
### 4. 瀹屾垚楠屾敹闃舵

```
浠诲姟瀹屾垚
  鈫?閫氱煡鐏屾堡楠屾敹
  鈫?鐏屾堡妫€鏌?code/ 鐩綍鐨勪唬鐮?  鈫?閫氳繃 鈫?鍚堝苟鍒颁富鍒嗘敮锛屾爣璁颁负宸插畬鎴?  鈫?涓嶉€氳繃 鈫?杩斿洖淇敼
```

---

---

## 馃幆 鏍稿績璁捐鐞嗗康

### 閰嶇疆涓庡伐浣滃尯鍒嗙

#### 1. Agent 宸ヤ綔鍖?(`agent/workspace-xxx/`)
- **鐢ㄩ€?** Agent 鐨勭嫭绔嬪伐浣滅┖闂达紝鍖呭惈韬唤璁ょ煡銆佽亴璐ｈ鑼冦€佽涓哄噯鍒?- **浣嶇疆:** `agent/` 鐩綍涓嬬殑鐙珛瀛愮洰褰?- **閲嶈鎬?** 馃敶 **鏍稿績涓殑鏍稿績锛屽喅瀹?Agent 鑳藉惁姝ｅ父鍚姩鍜屽伐浣?*
- **鐗圭偣:** 
  - 姣忎釜 Agent 鏈夎嚜宸辩殑 inbox/outbox 浠诲姟绠＄悊绯荤粺鍜屾矡閫氳褰?  - **鍖呭惈瀹屾暣鐙珛鐨勬妧鏈枃妗?(TECHNICAL-DOCS.md)**
  - Docker瀹瑰櫒闅旂杩愯锛屾棤娉曚氦鍙夎闂叾浠?Agent 閰嶇疆

#### 2. 鎶€鏈鑼冧腑蹇?(`agent/workspace-guantang/agent-configs/`) - 鍙€夊弬鑰?- **鐢ㄩ€?** 璇︾粏鐨勬妧鏈爤璇存槑銆佹渶浣冲疄璺点€佸父瑙侀棶棰橈紙鍘嗗彶鏂囨。锛屼粎渚涘弬鑰冿級
- **浣嶇疆:** 鐏屾堡宸ヤ綔鍖虹殑瀛愮洰褰?- **閲嶈鎬?** 馃煛 閲嶈鍙傝€冭祫鏂欙紙浣嗗悇 Agent 宸叉湁鐙珛鎶€鏈枃妗ｏ級
- **鐗圭偣:** 璇﹀敖瀹屾暣锛屼綔涓烘妧鏈寚瀵煎拰鐭ヨ瘑搴?- **娉ㄦ剰:** 鈿狅笍 **鐢变簬 Docker瀹瑰櫒闅旂锛屽悇 Agent鏃犳硶璁块棶姝ょ洰褰曪紝搴斾紭鍏堜娇鐢ㄥ悇鑷伐浣滃尯鐨凾ECHNICAL-DOCS.md**

#### 3. 宸ョ▼椤圭洰 (`code/`)
- **鐢ㄩ€?** 瀹為檯鐨勫伐绋嬮」鐩拰浠ｇ爜浜у嚭
- **鐗圭偣:** 鍙紪璇戙€佸彲杩愯銆佸彲閮ㄧ讲
- **鍏变韩鎬?** 鎵€鏈?Agent 鍏变韩鍚屼竴涓?code 鐩綍锛屼絾鍚勮嚜璐熻矗涓嶅悓瀛愮洰褰?
#### 4. Docker 閮ㄧ讲 (`agent/deployment-2026-03-08/`)
- **鐢ㄩ€?** Docker Compose 缂栨帓閰嶇疆锛屾敮鎸佸瀹炰緥閮ㄧ讲
- **鐗圭偣:** 瀹瑰櫒鍖栥€侀殧绂绘€с€佹槗浜庢墿灞?- **閰嶇疆鍒嗙:** 姣忎釜 Agent 鏈夌嫭绔嬬殑瀹瑰櫒瀹炰緥鍜岄厤缃枃浠?
### 涓轰粈涔堣杩欐牱璁捐锛?
1. **宸ヤ綔鍖虹嫭绔?* - 姣忎釜 Agent 鏈夎嚜宸辩殑 inbox/outbox 浠诲姟绠＄悊绯荤粺
2. **鎶€鏈鑼冮泦涓鐞?* - 閬垮厤閲嶅锛屼究浜庣粺涓€鏇存柊鍜岀淮鎶?3. **宸ョ▼浠ｇ爜鍏变韩** - code 鐩綍涓烘墍鏈?Agent 鍏变韩锛屼究浜庡崗浣?4. **瀹瑰櫒鍖栭儴缃?* - 閫氳繃 Docker Compose 瀹炵幇澶氬疄渚嬮殧绂昏繍琛?
---

## 馃敡 Docker 閮ㄧ讲閰嶇疆

### 閮ㄧ讲鐩綍缁撴瀯

**浣嶇疆:** `agent/deployment-2026-03-08/`

```
deployment-2026-03-08/
鈹溾攢鈹€ docker-compose/              # Docker Compose 缂栨帓閰嶇疆
鈹?  鈹溾攢鈹€ docker-compose.yml           # 鍗曞疄渚嬮厤缃?鈹?  鈹溾攢鈹€ docker-compose-agents.yml    # 涓夊鍣ㄧ紪鎺掞紙鎺ㄨ崘锛夆瓙
鈹?  鈹斺攢鈹€ docker-compose-searxng.yml   # SearXNG 鎼滅储寮曟搸
鈹溾攢鈹€ scripts/                     # 鍒濆鍖栧拰娴嬭瘯鑴氭湰
鈹?  鈹溾攢鈹€ init-docker-containers.py    # Python 鍒濆鍖栬剼鏈?鈹?  鈹斺攢鈹€ test-connectivity.ps1        # PowerShell 杩炴帴娴嬭瘯
鈹溾攢鈹€ searxng-configs/             # SearXNG 鎼滅储寮曟搸閰嶇疆
鈹?  鈹溾攢鈹€ dousha/                  # 璞嗘矙璁捐璧勬簮鎼滅储
鈹?  鈹溾攢鈹€ jiangrou/                # 閰辫倝鎶€鏈皟鐮旀悳绱?鈹?  鈹斺攢鈹€ suancai/                 # 閰歌彍杩愮淮鐭ヨ瘑鎼滅储
鈹溾攢鈹€ json-files/                  # JSON 閰嶇疆鏂囦欢
鈹?  鈹溾攢鈹€ comm-config.json         # Agent 閫氫俊閰嶇疆
鈹?  鈹溾攢鈹€ onboarding-1.json        # 鍏ヨ亴浠诲姟妯℃澘 1
鈹?  鈹溾攢鈹€ onboarding-2.json        # 鍏ヨ亴浠诲姟妯℃澘 2
鈹?  鈹溾攢鈹€ onboarding-3.json        # 鍏ヨ亴浠诲姟妯℃澘 3
鈹?  鈹斺攢鈹€ test-message.json        # 娴嬭瘯娑堟伅妯℃澘
鈹斺攢鈹€ RESTORE_COMPLETE.md          # 鎭㈠鎶ュ憡
```

### Docker Compose 澶氬疄渚嬮儴缃?
**鎺ㄨ崘閰嶇疆:** `docker-compose-agents.yml` - 涓夊鍣ㄧ紪鎺?
```yaml
services:
  jiangrou:  # 閰辫倝 - 鍚庣宸ョ▼甯?    image: ghcr.io/openclaw/openclaw:latest
    container_name: openclaw-instance-1
    ports:
      - "18791:18789"
    environment:
      - OPENCLAW_MODEL=qwen3-coder-plus
      - INSTANCE_NAME=jiangrou
      - INSTANCE_ROLE=backend-engineer
    volumes:
      - F:\openclaw\code\backend:/app/backend
      - F:\openclaw\workspace-jiangrou:/app/workspace

  dousha:  # 璞嗘矙 - 鍓嶇宸ョ▼甯?    image: ghcr.io/openclaw/openclaw:latest
    container_name: openclaw-instance-2
    ports:
      - "18792:18789"
    environment:
      - OPENCLAW_MODEL=qwen3-coder-plus
      - INSTANCE_NAME=dousha
      - INSTANCE_ROLE=frontend-engineer
    volumes:
      - F:\openclaw\code\frontend:/app/frontend
      - F:\openclaw\workspace-dousha:/app/workspace

  suancai:  # 閰歌彍 - 杩愮淮宸ョ▼甯?    image: ghcr.io/openclaw/openclaw:latest
    container_name: openclaw-instance-3
    ports:
      - "18793:18789"
    environment:
      - OPENCLAW_MODEL=qwen3-coder-plus
      - INSTANCE_NAME=suancai
      - INSTANCE_ROLE=devops-engineer
    volumes:
      - F:\openclaw\code\deploy:/app/deploy
      - F:\openclaw\code\tests:/app/tests
      - F:\openclaw\workspace-suancai:/app/workspace
```

### SearXNG 鎼滅储寮曟搸閰嶇疆

涓烘瘡涓?Agent 閰嶇疆鐙珛鐨?SearXNG 鎼滅储寮曟搸瀹炰緥锛?
- **閰辫倝 (jiangrou):** 鎶€鏈皟鐮斻€佷唬鐮侀棶棰樻悳绱?- **璞嗘矙 (dousha):** 璁捐璧勬簮銆乁I 鐏垫劅鎼滅储
- **閰歌彍 (suancai):** 杩愮淮鐭ヨ瘑銆佹晠闅滄帓鏌ユ悳绱?
### 蹇€熷惎鍔?
```bash
# 杩涘叆閮ㄧ讲鐩綍
cd agent/deployment-2026-03-08/scripts

# 杩愯鍒濆鍖栬剼鏈紙Windows PowerShell锛?.\test-connectivity.ps1

# 鎴栦娇鐢?Python 鍒濆鍖?python init-docker-containers.py

# 浣跨敤 Docker Compose 鍚姩鎵€鏈夋湇鍔?docker-compose -f docker-compose/docker-compose-agents.yml up -d
```

### 璁块棶鍦板潃

| 鏈嶅姟 | 绔彛 | URL |
|------|------|-----|
| **閰辫倝Agent** | 18791 | http://localhost:18791 |
| **璞嗘矙Agent** | 18792 | http://localhost:18792 |
| **閰歌彍Agent** | 18793 | http://localhost:18793 |
| **SearXNG (閰辫倝)** | 8081 | http://localhost:8081 |
| **SearXNG (璞嗘矙)** | 8082 | http://localhost:8082 |
| **SearXNG (閰歌彍)** | 8083 | http://localhost:8083 |

---

## 馃捇 鎶€鏈爤鎬昏

### 鍚庣鎶€鏈爤锛堥叡鑲夎礋璐ｏ級

| 缁勪欢 | 鎶€鏈?| 鐗堟湰 | 鐢ㄩ€?|
|------|------|------|------|
| **璇█** | Java | 21 (LTS) | 涓昏缂栫▼璇█ |
| **妗嗘灦** | Spring Boot | 3.2+ | Web 搴旂敤妗嗘灦 |
| **瀹夊叏** | Spring Security | 6.x | 璁よ瘉鎺堟潈 |
| **ORM** | Hibernate / MyBatis-Plus | 6.x / 3.5+ | 瀵硅薄鍏崇郴鏄犲皠 |
| **鏁版嵁搴?* | MySQL | 8.0+ | 涓绘暟鎹簱 |
| **缂撳瓨** | Redis | 7.0+ | 缂撳瓨灞?|
| **鏋勫缓** | Maven | 3.9+ | 椤圭洰鏋勫缓鍜岀鐞?|

### 鍓嶇鎶€鏈爤锛堣眴娌欒礋璐ｏ級

| 缁勪欢 | 鎶€鏈?| 鐗堟湰 | 鐢ㄩ€?|
|------|------|------|------|
| **妗嗘灦** | Vue.js | 3.4+ | 鍓嶇妗嗘灦 (Composition API) |
| **璇█** | TypeScript | 5.x | 绫诲瀷瀹夊叏 |
| **鏋勫缓** | Vite | 5.x | 蹇€熸瀯寤哄伐鍏?|
| **鐘舵€?* | Pinia | 2.x | 鐘舵€佺鐞?|
| **璺敱** | Vue Router | 4.x | 璺敱绠＄悊 |
| **UI** | Element Plus | 2.x | UI 缁勪欢搴?|
| **鏍峰紡** | Tailwind CSS | 3.x | 鍘熷瓙鍖?CSS 妗嗘灦 |

### 杩愮淮/娴嬭瘯鎶€鏈爤锛堥吀鑿滆礋璐ｏ級

| 缁勪欢 | 鎶€鏈?| 鐢ㄩ€?|
|------|------|------|
| **瀹瑰櫒鍖?* | Docker + Docker Compose | 搴旂敤瀹瑰櫒鍖栧拰缂栨帓 |
| **CI/CD** | GitHub Actions | 鎸佺画闆嗘垚鍜岄儴缃?|
| **鐩戞帶** | Prometheus + Grafana | 绯荤粺鐩戞帶鍜屽彲瑙嗗寲 |
| **鍗曞厓娴嬭瘯** | JUnit 5 + Mockito | Java 鍗曞厓娴嬭瘯 |
| **闆嗘垚娴嬭瘯** | Testcontainers | 瀹瑰櫒鍖栭泦鎴愭祴璇?|
| **鎬ц兘娴嬭瘯** | Gatling / JMeter | 璐熻浇鍜屽帇鍔涙祴璇?|
| **E2E 娴嬭瘯** | Playwright | 绔埌绔祻瑙堝櫒鑷姩鍖?|
| **鏃ュ織** | ELK Stack | 鏃ュ織鏀堕泦鍜屽垎鏋?|

---

## 馃摉 鏂囨。绱㈠紩

### 猸?鏍稿績閰嶇疆鏂囦欢锛堝惎鍔ㄥ繀澶囷級

**閰辫倝宸ヤ綔鍙?**
- [IDENTITY.md](./workspace-jiangrou/IDENTITY.md) - 鎴戞槸璋?- [ROLE.md](./workspace-jiangrou/ROLE.md) - 鎴戝仛浠€涔?- [SOUL.md](./workspace-jiangrou/SOUL.md) - 鎴戝浣曞伐浣?- [TECHNICAL-DOCS.md](./workspace-jiangrou/TECHNICAL-DOCS.md) - 瀹屾暣鎶€鏈枃妗?猸?
**璞嗘矙宸ヤ綔鍙?**
- [IDENTITY.md](./workspace-dousha/IDENTITY.md) - 鎴戞槸璋?- [ROLE.md](./workspace-dousha/ROLE.md) - 鎴戝仛浠€涔?- [SOUL.md](./workspace-dousha/SOUL.md) - 鎴戝浣曞伐浣?- [TECHNICAL-DOCS.md](./workspace-dousha/TECHNICAL-DOCS.md) - 瀹屾暣鎶€鏈枃妗?猸?
**閰歌彍宸ヤ綔鍙?**
- [IDENTITY.md](./workspace-suancai/IDENTITY.md) - 鎴戞槸璋?- [ROLE.md](./workspace-suancai/ROLE.md) - 鎴戝仛浠€涔?- [SOUL.md](./workspace-suancai/SOUL.md) - 鎴戝浣曞伐浣?- [TECHNICAL-DOCS.md](./workspace-suancai/TECHNICAL-DOCS.md) - 瀹屾暣鎶€鏈枃妗?猸?
### 閰嶇疆鏂囨。涓績

**鏍稿績鏂囨。:**
- [鐏屾堡韬唤璁ょ煡](./workspace-guantang/IDENTITY.md)
- [鐏屾堡琛屼负鍑嗗垯](./workspace-guantang/SOUL.md)
- [鍥㈤槦鍗忎綔瑙勮寖](./workspace-guantang/AGENTS.md)
- [鍚姩鎸囧崡](./workspace-guantang/BOOTSTRAP.md)

**鎶€鏈鑼冿紙鍙傝€冭祫鏂欙級:**
- [閰辫倝鎶€鏈鑼僝(./workspace-guantang/agent-configs/jiangrou/README.md)
- [璞嗘矙鎶€鏈鑼僝(./workspace-guantang/agent-configs/dousha/README.md)
- [閰歌彍鎶€鏈鑼僝(./workspace-guantang/agent-configs/suancai/README.md)

**浣跨敤鎸囧崡:**
- [蹇€熷紑濮媇(./workspace-guantang/guides/quick-start.md)
- [Docker 閮ㄧ讲鎸囧崡](./workspace-guantang/guides/docker-deployment-guide.md)
- [GitHub 涓婁紶鎸囧崡](./workspace-guantang/guides/github-upload-guide.md)

**瑙勮寖鏂囨。:**
- [Agent 鍗忚](./workspace-guantang/specs/agent-protocol.md)
- [绯荤粺鏋舵瀯](./workspace-guantang/specs/system-architecture.md)
- [鏃ュ織瀹¤](./workspace-guantang/specs/logging-audit.md)

### 宸ヤ綔鍙版枃妗?
**閰辫倝宸ヤ綔鍙?**
- [宸ヤ綔鍙拌鏄嶿(./workspace-jiangrou/README.md)
- 浠诲姟鐩綍锛歚workspace-jiangrou/tasks/inbox/`, `workspace-jiangrou/tasks/outbox/`
- 娌熼€氳褰曪細`workspace-jiangrou/communication/`
- 宸ヤ綔鏃ュ織锛歚workspace-jiangrou/logs/`
- 浠ｇ爜宸ヤ綔鍖猴細`code/backend/`

**璞嗘矙宸ヤ綔鍙?**
- [宸ヤ綔鍙拌鏄嶿(./workspace-dousha/README.md)
- 浠诲姟鐩綍锛歚workspace-dousha/tasks/inbox/`, `workspace-dousha/tasks/outbox/`
- 璁捐璧勬簮锛歚workspace-dousha/designs/`
- 娌熼€氳褰曪細`workspace-dousha/communication/`
- 宸ヤ綔鏃ュ織锛歚workspace-dousha/logs/`
- 浠ｇ爜宸ヤ綔鍖猴細`code/frontend/`

**閰歌彍宸ヤ綔鍙?**
- [宸ヤ綔鍙拌鏄嶿(./workspace-suancai/README.md)
- 浠诲姟鐩綍锛歚workspace-suancai/tasks/inbox/`, `workspace-suancai/tasks/outbox/`
- 娴嬭瘯宸ヤ綔鍖猴細`code/tests/`
- 閮ㄧ讲鑴氭湰锛歚code/deploy/`
- 娌熼€氳褰曪細`workspace-suancai/communication/`
- 宸ヤ綔鏃ュ織锛歚workspace-suancai/logs/`

### 宸ョ▼鏂囨。

**鍚庣宸ョ▼:**
- [宸ョ▼璇存槑](../../code/backend/README.md)
- 婧愪唬鐮侊細`code/backend/src/`
- 鏋勫缓閰嶇疆锛歚code/backend/pom.xml`

**鍓嶇宸ョ▼:**
- [宸ョ▼璇存槑](../../code/frontend/README.md)
- 婧愪唬鐮侊細`code/frontend/src/`
- 鏋勫缓閰嶇疆锛歚code/frontend/package.json`

**閮ㄧ讲鑴氭湰:**
- [閮ㄧ讲璇存槑](../../code/deploy/README.md)
- Docker 閰嶇疆锛歚code/deploy/docker/`
- 閮ㄧ讲鑴氭湰锛歚code/deploy/scripts/`

**娴嬭瘯鑴氭湰:**
- [娴嬭瘯璇存槑](../../code/tests/README.md)
- 鍗曞厓娴嬭瘯锛歚code/tests/unit/`
- 闆嗘垚娴嬭瘯锛歚code/tests/integration/`
- 鎬ц兘娴嬭瘯锛歚code/tests/performance/`

### Docker 閮ㄧ讲閰嶇疆

**閮ㄧ讲鐩綍:** `deployment-2026-03-08/`

**鏍稿績鏂囦欢:**
- [鎭㈠鎶ュ憡](./deployment-2026-03-08/RESTORE_COMPLETE.md) - 瀹屾暣鐨勬仮澶嶈鏄庡拰鎸囧崡
- Docker Compose 閰嶇疆锛歚deployment-2026-03-08/docker-compose/`
  - `docker-compose-agents.yml` - OpenClaw Agent 涓夊鍣ㄧ紪鎺掞紙鎺ㄨ崘锛?  - `docker-compose-searxng.yml` - SearXNG 鎼滅储寮曟搸缂栨帓
- 鍒濆鍖栧拰娴嬭瘯鑴氭湰锛歚deployment-2026-03-08/scripts/`
  - `init-docker-containers.py` - Python 鍒濆鍖栬剼鏈?  - `test-connectivity.ps1` - PowerShell 杩炴帴娴嬭瘯
- SearXNG 閰嶇疆锛歚deployment-2026-03-08/searxng-configs/`
  - 閰辫倝鎶€鏈皟鐮旀悳绱㈠紩鎿?  - 璞嗘矙璁捐璧勬簮鎼滅储寮曟搸
  - 閰歌彍杩愮淮鐭ヨ瘑鎼滅储寮曟搸
- JSON 閰嶇疆鏂囦欢锛歚deployment-2026-03-08/json-files/`
  - Agent 閫氫俊閰嶇疆
  - 鍏ヨ亴浠诲姟妯℃澘
  - 娴嬭瘯娑堟伅妯℃澘

**蹇€熷惎鍔?**
```bash
cd deployment-2026-03-08/scripts
python init-docker-containers.py
```

**璁块棶鍦板潃:**
- OpenClaw Agent UI: http://localhost:18791-18793
- SearXNG 鎼滅储寮曟搸锛歨ttp://localhost:8081-8083

---

## 馃幆 蹇€熷鑸?
### 鎴戞槸鐏屾堡 (PM)
鈫?鍘?[`agent/workspace-guantang/`](./workspace-guantang/README.md) 绠＄悊鍥㈤槦鍜屽垎閰嶄换鍔? 
鈫?闃呰 [AGENTS.md](./workspace-guantang/AGENTS.md) 浜嗚В鍥㈤槦鍗忎綔瑙勮寖

### 鎴戞槸閰辫倝 (鍚庣) 猸?1. **棣栧厛闃呰** [IDENTITY.md](./workspace-jiangrou/IDENTITY.md) 璁よ瘑鑷繁
2. **鐒跺悗闃呰** [ROLE.md](./workspace-jiangrou/ROLE.md) 鏄庣‘鑱岃矗
3. **鏈€鍚庨槄璇?* [SOUL.md](./workspace-jiangrou/SOUL.md) 浜嗚В琛屼负鍑嗗垯
4. 鍘?[`agent/workspace-jiangrou/README.md`](./workspace-jiangrou/README.md) 浜嗚В宸ヤ綔娴佺▼
5. 鍘?[`code/backend/`](../../code/backend/README.md) 缂栧啓浠ｇ爜
6. 鏌ョ湅 [鎶€鏈鑼僝(./workspace-guantang/agent-configs/jiangrou/README.md) 浜嗚В鎶€鏈爤璇︽儏

### 鎴戞槸璞嗘矙 (鍓嶇) 猸?1. **棣栧厛闃呰** [IDENTITY.md](./workspace-dousha/IDENTITY.md) 璁よ瘑鑷繁
2. **鐒跺悗闃呰** [ROLE.md](./workspace-dousha/ROLE.md) 鏄庣‘鑱岃矗
3. **鏈€鍚庨槄璇?* [SOUL.md](./workspace-dousha/SOUL.md) 浜嗚В琛屼负鍑嗗垯
4. 鍘?[`agent/workspace-dousha/README.md`](./workspace-dousha/README.md) 浜嗚В宸ヤ綔娴佺▼
5. 鍘?[`code/frontend/`](../../code/frontend/README.md) 缂栧啓浠ｇ爜
6. 鏌ョ湅 [璁捐瑙勮寖](./workspace-guantang/agent-configs/dousha/README.md) 浜嗚В UI 瑙勮寖

### 鎴戞槸閰歌彍 (杩愮淮/娴嬭瘯) 猸?1. **棣栧厛闃呰** [IDENTITY.md](./workspace-suancai/IDENTITY.md) 璁よ瘑鑷繁
2. **鐒跺悗闃呰** [ROLE.md](./workspace-suancai/ROLE.md) 鏄庣‘鑱岃矗
3. **鏈€鍚庨槄璇?* [SOUL.md](./workspace-suancai/SOUL.md) 浜嗚В琛屼负鍑嗗垯
4. 鍘?[`agent/workspace-suancai/README.md`](./workspace-suancai/README.md) 浜嗚В宸ヤ綔娴佺▼
5. 鍘?[`code/deploy/`](../../code/deploy/README.md) 鎴?[`code/tests/`](../../code/tests/README.md) 宸ヤ綔
6. 鏌ョ湅 [DevOps 瀹炶返](./workspace-guantang/agent-configs/suancai/README.md) 浜嗚В閮ㄧ讲瑙勮寖

---

## 馃殌 寮€鍙戜笌閮ㄧ讲娴佺▼

### 鏈湴寮€鍙戞祦绋?
1. **鍏嬮殕浠撳簱**
   ```bash
   # 閰嶇疆鏂囨。涓績
   git clone https://github.com/baobaobaobaozijun/openclawPlayground.git agent/workspace-guantang
   
   # 鍚?Agent 宸ヤ綔鍙帮紙鍖呭惈鏍稿績閰嶇疆锛?   git clone https://github.com/baobaobaobaozijun/openclaw-backend.git agent/workspace-jiangrou
   git clone https://github.com/baobaobaobaozijun/openclaw-frontend.git agent/workspace-dousha
   git clone https://github.com/baobaobaobaozijun/openclaw-devops.git agent/workspace-suancai
   
   # 浠ｇ爜宸ョ▼
   git clone https://github.com/baobaobaobaozijun/openclaw-backend-code.git code/backend
   git clone https://github.com/baobaobaobaozijun/openclaw-frontend-code.git code/frontend
   ```

2. **寮€濮嬪伐浣?*
   ```bash
   # 閰辫倝绀轰緥
   cd agent/workspace-jiangrou
   
   # 棣栧厛闃呰鏍稿績閰嶇疆鏂囦欢
   cat IDENTITY.md  # 璁よ瘑鑷繁
   cat ROLE.md      # 鏄庣‘鑱岃矗
   cat SOUL.md      # 浜嗚В琛屼负鍑嗗垯
   
   # 鏌ョ湅浠诲姟
   cat tasks/inbox/TASK-XXX.md
   
   # 寮€濮嬬紪鐮?   cd ../../code/backend
   mvn spring-boot:run  # 鍚姩寮€鍙戞湇鍔″櫒
   ```

### Docker 閮ㄧ讲娴佺▼

```bash
# 杩涘叆閮ㄧ讲鐩綍
cd agent/deployment-2026-03-08/scripts

# 杩愯鍒濆鍖栬剼鏈?python init-docker-containers.py

# 鎴栦娇鐢?Docker Compose 鍚姩鎵€鏈夋湇鍔?docker-compose -f ../docker-compose/docker-compose-agents.yml up -d

# 鏌ョ湅鏃ュ織
docker-compose logs -f

# 鍋滄鏈嶅姟
docker-compose down
```

璇︾粏閮ㄧ讲鎸囧崡锛歔deployment-2026-03-08/RESTORE_COMPLETE.md](./deployment-2026-03-08/RESTORE_COMPLETE.md)

---

## 馃搳 椤圭洰缁熻

### 鐩綍缁撴瀯缁熻

| 绫诲埆 | 鐩綍鏁?| 璇存槑 |
|------|--------|------|
| **Agent 宸ヤ綔鍖?* | 5 | agent/workspace-guantang, workspace-jiangrou, workspace-dousha, workspace-suancai, workspace-programmer |
| **鎶€鏈鑼冧腑蹇?* | 1 | agent/workspace-guantang/agent-configs锛堝惈 3 涓?Agent 閰嶇疆锛?|
| **宸ョ▼浠ｇ爜** | 4 | code/backend, code/frontend, code/deploy, code/tests |
| **鏂囨。璧勬枡** | 2 | guides/, specs/, logs/ |
| **Docker 閮ㄧ讲** | 1 | agent/deployment-2026-03-08锛堝惈 Docker Compose銆丼earXNG銆佽剼鏈瓑锛?|

### 鏍稿績閰嶇疆鏂囦欢娓呭崟

| Agent | IDENTITY.md | ROLE.md | SOUL.md | README.md | 鐘舵€?|
|-------|-------------|---------|---------|-----------|------|
| **閰辫倝** | 鉁?| 鉁?| 鉁?| 鉁?| 瀹屾暣 |
| **璞嗘矙** | 鉁?| 鉁?| 鉁?| 鉁?| 瀹屾暣 |
| **閰歌彍** | 鉁?| 鉁?| 鉁?| 鉁?| 瀹屾暣 |
| **绋嬪簭鍛?* | 馃煛 (妯℃澘) | 鉂?| 鉂?| 鉂?| 棰勭暀 |

### GitHub 浠撳簱

| 鍦板潃 | 鐢ㄩ€?| URL |branch|
|------|------|-----|-----|
| **/agent** | agent閰嶇疆鏂囦欢 | https://github.com/baobaobaobaozijun/openclawPlayground |master|
| **/code/backend** | 鍚庣浠ｇ爜 | https://github.com/baobaobaobaozijun/openclaw-backend |master|
| **/code/frontend** | 鍓嶇浠ｇ爜 | https://github.com/baobaobaobaozijun/openclaw-frontend |master|
| **/code/deploy**  | 杩愮淮鑴氭湰宸ヤ綔鍙?| https://github.com/baobaobaobaozijun/openclaw-devops |master|
| **/code/test**  | 娴嬭瘯鑴氭湰宸ヤ綔鍙?| https://github.com/baobaobaobaozijun/openclaw-test |master|

---

## 鉁?鏋舵瀯浼樺娍

### 娓呮櫚鐨勮鑹插畾浣?- 姣忎釜 Agent 鏈夌嫭绔嬬殑宸ヤ綔绌洪棿鍜岃韩浠借鐭?- inbox/outbox浠诲姟绠＄悊绯荤粺锛屽伐浣滄祦绋嬫竻鏅?- 鑱岃矗鏄庣‘锛岄伩鍏嶆贩娣?
### 楂樻晥鐨勫崗浣滄満鍒?- 鏍囧噯鍖栫殑浠诲姟娴佽浆娴佺▼锛坕nbox 鈫?outbox锛?- 娌熼€氳褰曞彲杩芥函
- 鏂囨。鑷姩娌夋穩涓哄洟闃熺煡璇?
### 鐏垫椿鐨勬妧鏈€夊瀷
- 鍚勬妧鏈爤鐙珛婕旇繘
- 鍙互鏍规嵁闇€姹傝嚜鐢卞崌绾?- 涓嶄細鐩镐簰褰卞搷

### 鏄撲簬鎵╁睍鍜岀淮鎶?- 鏂板 Agent 鍙渶娣诲姞鏂扮殑 workspace 鐩綍
- 鎶€鏈鑼冮泦涓鐞嗭紝鏇存柊閫忔槑
- 宸ョ▼浠ｇ爜鍏变韩锛屼究浜庡崗浣?
### 瀹瑰櫒鍖栭儴缃?- Docker Compose 澶氬疄渚嬮殧绂昏繍琛?- 姣忎釜 Agent 鏈夌嫭绔嬬殑鐜鍜岄厤缃?- 鏄撲簬鎵╁睍鍜岃縼绉?
### 瀹夊叏鎬т繚闅?- 鏁忔劅閰嶇疆闆嗕腑绠＄悊
- 浠ｇ爜浠撳簱鏉冮檺鍒嗙
- 宸ヤ綔鏃ュ織鍙璁?
---

## 馃敭 鏈潵瑙勫垝

### 鐭湡鐩爣锛?-2 鍛級
- [ ] 瀹屽杽 code/ 鐩綍涓嬬殑鍩虹宸ョ▼妯℃澘
- [ ] 鍒涘缓浠ｇ爜宸ョ▼鐨?GitHub 浠撳簱
- [ ] 瀹炵幇绗竴涓畬鏁寸殑鐢ㄦ埛鏁呬簨锛堜粠闇€姹傚埌涓婄嚎锛?
### 涓湡鐩爣锛? 涓湀锛?- [ ] 寤虹珛瀹屽杽鐨?CI/CD娴佺▼
- [ ] 瀹炵幇鑷姩鍖栫洃鎺у拰鍛婅
- [ ] 绉疮鑷冲皯 10 涓畬鏁寸殑鍔熻兘妯″潡

### 闀挎湡鐩爣锛? 涓湀锛?- [ ] 褰㈡垚鎴愮啛鐨?Agent 鍗忎綔妯″紡
- [ ] 寤虹珛瀹屾暣鐨勭煡璇嗗簱鍜屾渶浣冲疄璺?- [ ] 鏀寔鏇村鏉傜殑椤圭洰瑙勬ā

---

## 鈿狅笍 缁存姢娉ㄦ剰浜嬮」

### 缁濆绂佹
- 鉂?**鍒犻櫎浠讳綍 Agent 鐨?IDENTITY.md, ROLE.md, SOUL.md** - 杩欎細瀵艰嚧 Agent 鏃犳硶鍚姩
- 鉂?**绉诲姩鏍稿績閰嶇疆鏂囦欢鍒板叾浠栫洰褰?* - Agent 鍚姩鏃朵細鐩存帴浠?workspace-xxx/ 鏍圭洰褰曡鍙?- 鉂?**淇敼鏍稿績閰嶇疆鏂囦欢鐨勬枃浠跺悕** - 蹇呴』淇濇寔鏍囧噯鍛藉悕
- 鉂?**鍒犻櫎 agent/deployment-2026-03-08/ 鐩綍** - 鍖呭惈鎵€鏈?Docker 閮ㄧ讲閰嶇疆鍜?SearXNG 閰嶇疆

### 鎺ㄨ崘鍋氭硶
- 鉁?瀹氭湡澶囦唤鎵€鏈?agent/workspace-xxx/ 鐩綍
- 鉁?鐗瑰埆澶囦唤 agent/deployment-2026-03-08/ 鐩綍锛堝寘鍚墍鏈夐儴缃茶剼鏈級
- 鉁?鍦?agent/workspace-guantang/agent-configs/ 涓淮鎶ゅ拰鏇存柊鎶€鏈鑼?- 鉁?淇濇寔宸ヤ綔鍙扮洰褰曠粨鏋勬竻鏅?- 鉁?鍙婃椂鏇存柊 README.md 宸ヤ綔娴佺▼璇存槑
- 鉁?浣跨敤 Git 绠＄悊 deployment-2026-03-08/ 鐩綍锛堟帓闄ゆ晱鎰熼厤缃級
- 鉁?瀹氭湡娓呯悊 tasks/inbox/鍜宼asks/outbox/涓殑宸插畬鎴愪换鍔?
---

**绁濆洟闃熷悎浣滄剦蹇紒寮€濮嬪垱閫犱紵澶х殑浜у搧鍚э紒** 馃殌

*缁存姢鑰咃細鐏屾堡 PM*  
*鏇存柊鏃ユ湡锛?026-03-09*
*澶囨敞锛氭灦鏋勬枃妗ｅ凡鏍规嵁鏈€鏂版枃浠跺眰娆＄粨鏋勬洿鏂?

