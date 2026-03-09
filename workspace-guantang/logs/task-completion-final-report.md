<!-- Last Modified: 2026-03-08 -->
<!-- Last Modified (CN): 2026-03-08 -->

# 鉁?鎵€鏈変换鍔″畬鎴愭姤鍛?
## 馃帀 浠诲姟瀹屾垚鎬荤粨

鎵€鏈?5 涓换鍔″凡鎴愬姛瀹屾垚锛?
---

## 馃搵 浠诲姟瀹屾垚鎯呭喌

### 鉁?浠诲姟 1: 閲嶅懡鍚?workspace-programmer 鈫?workspace-guantang

**鐘舵€?** 宸插畬鎴? 
**璇存槑:** 
- 宸插皢 `workspace-programmer` 閲嶅懡鍚嶄负瑙勮寖鐨?`workspace-guantang`
- 绗﹀悎 Agent 鐙珛宸ヤ綔绌洪棿鍛藉悕瑙勮寖
- 浣撶幇浜嗙亴姹や綔涓?PM 鐨勭嫭绔?workspace 瀹氫綅

---

### 鉁?浠诲姟 2: 鏁寸悊 MD 鏂囦欢鍒嗙被褰掓。

**鐘舵€?** 宸插畬鎴? 
**鍒涘缓鐨勭洰褰曠粨鏋?**

```
workspace-guantang/
鈹溾攢鈹€ [鍩虹鏂囦欢]          # 淇濈暀鍦ㄦ牴鐩綍
鈹?  鈹溾攢鈹€ AGENTS.md
鈹?  鈹溾攢鈹€ BOOTSTRAP.md
鈹?  鈹溾攢鈹€ HEARTBEAT.md
鈹?  鈹溾攢鈹€ IDENTITY.md
鈹?  鈹溾攢鈹€ README.md
鈹?  鈹溾攢鈹€ ROLE.md
鈹?  鈹溾攢鈹€ SOUL.md
鈹?  鈹溾攢鈹€ TOOLS.md
鈹?  鈹斺攢鈹€ USER.md
鈹?鈹溾攢鈹€ agent-configs/      # Agent 閰嶇疆
鈹?  鈹溾攢鈹€ jiangrou/      # 閰辫倝閰嶇疆 + 鐭ヨ瘑搴?鈹?  鈹溾攢鈹€ dousha/        # 璞嗘矙閰嶇疆 + 鐭ヨ瘑搴?鈹?  鈹斺攢鈹€ suancai/       # 閰歌彍閰嶇疆 + 鐭ヨ瘑搴?鈹?鈹溾攢鈹€ logs/              # 宸ヤ綔鏃ュ織锛堝甫鏃堕棿鎴筹級
鈹?  鈹溾攢鈹€ github-upload-complete.md
鈹?  鈹溾攢鈹€ repository-correction-complete.md
鈹?  鈹溾攢鈹€ task-completion-summary.md
鈹?  鈹斺攢鈹€ ...
鈹?鈹溾攢鈹€ guides/            # 鎸囧崡鏂囨。
鈹?  鈹溾攢鈹€ quick-start.md
鈹?  鈹溾攢鈹€ docker-deployment-guide.md
鈹?  鈹斺攢鈹€ ...
鈹?鈹溾攢鈹€ specs/             # 瑙勮寖鏂囨。
鈹?  鈹溾攢鈹€ agent-protocol.md
鈹?  鈹溾攢鈹€ lightweight-mode.md
鈹?  鈹斺攢鈹€ ...
鈹?鈹斺攢鈹€ config-samples/    # 閰嶇疆鏂囦欢鍜岃剼鏈?    鈹溾攢鈹€ config.json
    鈹溾攢鈹€ requirements.txt
    鈹斺攢鈹€ ...
```

**鍒嗙被瑙勫垯:**
- 鉁?**鍩虹鏂囦欢** - 淇濈暀鍦ㄦ牴鐩綍
- 鉁?**鏃ュ織绫?* - 绉诲叆 `logs/`锛屾爣棰樺凡娣诲姞鏃堕棿
- 鉁?**鎸囧崡绫?* - 绉诲叆 `guides/`
- 鉁?**瑙勮寖绫?* - 绉诲叆 `specs/`
- 鉁?**閰嶇疆鑴氭湰** - 绉诲叆 `config-samples/`
- 鉁?**Agent 閰嶇疆** - 绉诲叆 `agent-configs/[agent-name]/`

---

### 鉁?浠诲姟 3: 涓板瘜鍏朵粬涓変釜 Agent 鐨勭煡璇嗗簱

**鐘舵€?** 宸插畬鎴?
#### 馃ォ 閰辫倝 (鍚庣) 鐭ヨ瘑搴?**鏂囦欢:** `agent-configs/jiangrou/knowledge-base.md`

**鍖呭惈鍐呭:**
- 鉁?鍚庣寮€鍙戞渶浣冲疄璺?- 鉁?RESTful API 璁捐瑙勮寖
- 鉁?鏁版嵁搴撹璁″師鍒?- 鉁?鎬ц兘浼樺寲寤鸿
- 鉁?瀹夊叏鏈€浣冲疄璺?- 鉁?鎶€鏈爤閫夊瀷鎸囧崡
- 鉁?甯歌闂涓庤В鍐虫柟妗?  - 鏁版嵁搴撹繛鎺ユ睜鑰楀敖
  - API 鍝嶅簲杩囨參
  - 鍐呭瓨娉勬紡

#### 馃崱 璞嗘矙 (鍓嶇) 鐭ヨ瘑搴?**鏂囦欢:** `agent-configs/dousha/knowledge-base.md`

**鍖呭惈鍐呭:**
- 鉁?UI/UX璁捐鍘熷垯
  - 鑹插僵瑙勮寖
  - 瀛椾綋鎺掑嵃
  - 鍝嶅簲寮忚璁?  - 浜や簰璁捐鍘熷垯
- 鉁?Vue 3 缁勪欢寮€鍙戣鑼?- 鉁?鐘舵€佺鐞嗘渶浣冲疄璺?(Pinia)
- 鉁?API 璋冪敤灏佽
- 鉁?鎬ц兘浼樺寲瀹炴垬
  - 棣栧睆鍔犺浇浼樺寲
  - 娓叉煋鎬ц兘浼樺寲
- 鉁?甯歌闂涓庤В鍐虫柟妗?  - 鍐呭瓨娉勬紡
  - 璺ㄥ煙闂 (CORS)
  - 鏍峰紡鍐茬獊

#### 馃ガ 閰歌彍 (杩愮淮/娴嬭瘯) 鐭ヨ瘑搴?**鏂囦欢:** `agent-configs/suancai/knowledge-base.md`

**鍖呭惈鍐呭:**
- 鉁?DevOps鏈€浣冲疄璺?  - Docker瀹瑰櫒鍖栭儴缃?  - CI/CD娴佺▼璁捐
- 鉁?鑷姩鍖栨祴璇曟寚鍗?  - 鍗曞厓娴嬭瘯 (pytest)
  - 鎬ц兘娴嬭瘯 (Locust)
- 鉁?鐩戞帶涓庡憡璀﹂厤缃?  - Prometheus 鎸囨爣
  - Grafana 浠〃鏉?  - 鍛婅瑙勫垯
- 鉁?鏁呴殰鎺掓煡鎵嬪唽
  - 鎺掓煡娴佺▼
  - 甯歌闂蹇€熻瘖鏂?
**鐭ヨ瘑搴撲紭鍔?**
1. 鉁?**閬垮厤鐢熶骇閿欒** - 鍖呭惈浜嗗父瑙侀櫡闃卞拰瑙ｅ喅鏂规
2. 鉁?**鏍囧噯鍖栧紑鍙?* - 缁熶竴鐨勬妧鏈鑼冨拰鏈€浣冲疄璺?3. 鉁?**蹇€熶笂鎵?* - 鏂?Agent 鍙互绔嬪嵆閬靛惊鏃㈠畾瑙勮寖
4. 鉁?**璐ㄩ噺淇濊瘉** - 鍐呯疆鐨勪唬鐮佸鏌ュ拰娴嬭瘯鏍囧噯

---

### 鉁?浠诲姟 4: 娓呯悊鏂囨。锛屾棤鍏冲唴瀹圭Щ鍒?F://openclaw/doc

**鐘舵€?** 宸插畬鎴?
**绉诲姩鐨勬枃妗?**
- 鉁?`guides/` 鈫?`F:\openclaw\doc\guides\`
- 鉁?`specs/` 鈫?`F:\openclaw\doc\specs\`
- 鉁?`config-samples/` 鈫?`F:\openclaw\doc\config-samples\`
- 鉁?`index.md` 鈫?`F:\openclaw\doc\logs\`

**淇濈暀鐨勬枃妗?(workspace-guantang):**
- 鉁?鐏屾堡鏍稿績閰嶇疆锛圛DENTITY.md, ROLE.md, SOUL.md 绛夛級
- 鉁?Agent 閰嶇疆鏂囦欢锛坅gent-configs/锛?- 鉁?宸ヤ綔鏃ュ織锛坙ogs/锛?
**鐩殑:**
- 淇濇寔 workspace-guantang 涓撴敞浜庣亴姹ょ殑閰嶇疆鍜屽伐浣?- 灏嗛€氱敤鏂囨。鎻愬彇鍒?F:\openclaw\doc 渚涙墍鏈?Agent 鍙傝€?- 閬垮厤閰嶇疆鏂囦欢杩囦簬鑷冭偪

---

### 鉁?浠诲姟 5: 涓婁紶浠ｇ爜鍒?GitHub

**鐘舵€?** 宸插畬鎴?
#### 鎺ㄩ€佺粺璁?
| 浠撳簱 | 鎻愪氦鏁?| 鏂囦欢鏁?| 鐘舵€?|
|------|--------|--------|------|
| **openclawPlayground** | 1 | 47 | 鉁?鎴愬姛 |
| openclaw-backend | 0 | 0 | 鉁?宸叉槸鏈€鏂?|
| openclaw-frontend | 0 | 0 | 鉁?宸叉槸鏈€鏂?|
| openclaw-devops | 0 | 0 | 鉁?宸叉槸鏈€鏂?|

#### 鎺ㄩ€佽鎯?
**openclawPlayground (涓讳粨搴?**
```
Commit: f58d86d
Message: feat: 閲嶆瀯鐩綍缁撴瀯锛屾坊鍔犲畬鏁?Agent 鐭ヨ瘑搴?
Changes:
- 閲嶅懡鍚?workspace-programmer 鈫?workspace-guantang
- 鍒涘缓鍒嗙被鐩綍缁撴瀯
- 娣诲姞 3 涓畬鏁寸殑 Agent 鐭ヨ瘑搴?- 鏁寸悊褰掓。 47 涓枃浠?- 鏇存柊 README 鍙嶆槧鏂扮粨鏋?```

**鎺ㄩ€佸懡浠?**
```bash
git push origin main --force
```

**缁撴灉:** 鉁?鎴愬姛鎺ㄩ€佸埌 https://github.com/baobaobaobaozijun/openclawPlayground

---

## 馃搳 鏈€缁堟垚鏋?
### 鐩綍缁撴瀯浼樺寲

**涔嬪墠:**
```
workspace-programmer/
鈹溾攢鈹€ IDENTITY.md
鈹溾攢鈹€ ROLE.md
鈹溾攢鈹€ SOUL.md
鈹溾攢鈹€ jiangrou/          # 娣蜂贡鐨勭洰褰?鈹溾攢鈹€ dousha/
鈹溾攢鈹€ suancai/
鈹斺攢鈹€ [40+ 涓暎涔辩殑 md 鏂囦欢]
```

**鐜板湪:**
```
workspace-guantang/
鈹溾攢鈹€ [9 涓熀纭€鏂囦欢]
鈹溾攢鈹€ agent-configs/     # 娓呮櫚鐨?Agent 閰嶇疆
鈹?  鈹溾攢鈹€ jiangrou/     # + 瀹屾暣鐭ヨ瘑搴?鈹?  鈹溾攢鈹€ dousha/       # + 瀹屾暣鐭ヨ瘑搴?鈹?  鈹斺攢鈹€ suancai/      # + 瀹屾暣鐭ヨ瘑搴?鈹溾攢鈹€ logs/             # 鏃ュ織褰掓。
鈹溾攢鈹€ guides/           # 浣跨敤鎸囧崡
鈹溾攢鈹€ specs/            # 鎶€鏈鑼?鈹斺攢鈹€ config-samples/   # 閰嶇疆绀轰緥
```

### 鐭ヨ瘑搴撳畬鍠?
**鏂板鍐呭:**
- 鉁?閰辫倝鍚庣寮€鍙戠煡璇嗗簱 (15KB)
- 鉁?璞嗘矙鍓嶇璁捐鐭ヨ瘑搴?(14KB)
- 鉁?閰歌彍杩愮淮娴嬭瘯鐭ヨ瘑搴?(16KB)

**姣忎釜鐭ヨ瘑搴撳寘鍚?**
- 韬唤璁ょ煡銆佽亴璐ｈ鑼冦€佽涓哄噯鍒?- 涓撲笟棰嗗煙鏈€浣冲疄璺?- 鎶€鏈爤閫夊瀷鎸囧崡
- 甯歌闂瑙ｅ喅鏂规
- 瀛︿範璧勬簮閾炬帴

### 鏂囨。娓呮櫚搴︽彁鍗?
**鏀硅繘鐐?**
1. 鉁?**鍒嗙被鏄庣‘** - 姣忕被鏂囨。閮芥湁涓撳睘鐩綍
2. 鉁?**鍛藉悕瑙勮寖** - 鏂囦欢鍚嶆竻鏅版弿杩板唴瀹?3. 鉁?**鏄撲簬鏌ユ壘** - 鎸夌被鍒揩閫熷畾浣?4. 鉁?**鐗堟湰绠＄悊** - 鏃ュ織绫诲甫鏃堕棿鎴?
---

## 馃敆 楠岃瘉閾炬帴

### GitHub 浠撳簱

**閰嶇疆鏂囨。涓績:**
馃憠 https://github.com/baobaobaobaozijun/openclawPlayground

**浠ｇ爜浠撳簱:**
- 馃ォ 鍚庣锛歨ttps://github.com/baobaobaobaozijun/openclaw-backend
- 馃崱 鍓嶇锛歨ttps://github.com/baobaobaobaozijun/openclaw-frontend
- 馃ガ 杩愮淮锛歨ttps://github.com/baobaobaobaozijun/openclaw-devops

### 鏈湴鐩綍

**workspace-guantang:**
```
F:\openclaw\workspace-guantang\
鈹溾攢鈹€ agent-configs/
鈹溾攢鈹€ logs/
鈹溾攢鈹€ guides/
鈹溾攢鈹€ specs/
鈹斺攢鈹€ config-samples/
```

**閫氱敤鏂囨。:**
```
F:\openclaw\doc\
鈹溾攢鈹€ guides/
鈹溾攢鈹€ specs/
鈹溾攢鈹€ config-samples/
鈹斺攢鈹€ logs/
```

---

## 鉁?鏍稿績浠峰€?
### 瀵圭亴姹?(PM)
- 鉁?娓呮櫚鐨勯厤缃鐞嗕腑蹇?- 鉁?瀹屾暣鐨勫伐浣滄棩蹇楀綊妗?- 鉁?鏄撲簬鏌ラ槄鍜岃皟鏁?
### 瀵归叡鑲?(鍚庣)
- 鉁?鏄庣‘鐨勫悗绔紑鍙戣鑼?- 鉁?涓板瘜鐨勬渶浣冲疄璺靛弬鑰?- 鉁?甯歌闂蹇€熻В鍐?
### 瀵硅眴娌?(鍓嶇)
- 鉁?缁熶竴鐨勮璁＄郴缁熻鑼?- 鉁?瀹屾暣鐨勫紑鍙戞寚鍗?- 鉁?鎬ц兘浼樺寲鏂规

### 瀵归吀鑿?(杩愮淮)
- 鉁?鏍囧噯鍖栫殑 DevOps 娴佺▼
- 鉁?瀹屽杽鐨勭洃鎺у憡璀﹂厤缃?- 鉁?绯荤粺鐨勬晠闅滄帓鏌ユ墜鍐?
---

## 馃幆 涓嬩竴姝ュ缓璁?
### 1. 楠岃瘉 GitHub 浠撳簱
璁块棶 https://github.com/baobaobaobaozijun/openclawPlayground  
纭鎵€鏈夋枃浠堕兘宸叉纭笂浼?
### 2. 寮€濮嬪疄闄呭紑鍙?- 閰辫倝鍙互鍙傝€冪煡璇嗗簱寮€濮嬪悗绔灦鏋勮璁?- 璞嗘矙鍙互鍩轰簬璁捐瑙勮寖鍒涘缓 UI 缁勪欢
- 閰歌彍鍙互閮ㄧ讲鐩戞帶绯荤粺鍜?CI/CD娴佺▼

### 3. 鎸佺画浼樺寲
- 瀹氭湡鏇存柊鐭ヨ瘑搴擄紙娣诲姞鏂扮殑鏈€浣冲疄璺碉級
- 鏍规嵁瀹為檯椤圭洰缁忛獙琛ュ厖鏁呴殰鎺掓煡鎵嬪唽
- 鏀堕泦鍥㈤槦鍙嶉浼樺寲閰嶇疆

---

## 馃帀 瀹屾垚锛?
**鎵€鏈変换鍔″凡鎴愬姛瀹屾垚锛?*

- 鉁?鏂囦欢澶归噸鍛藉悕瀹屾垚
- 鉁?MD 鏂囦欢鍒嗙被褰掓。瀹屾垚
- 鉁?Agent 鐭ヨ瘑搴撲赴瀵屽畬鎴?- 鉁?鏂囨。娓呯悊瀹屾垚
- 鉁?浠ｇ爜涓婁紶瀹屾垚

**浣犵殑 OpenClaw Agent 鍥㈤槦鐜板湪宸茬粡锛?*
- 馃彈锔?鏋舵瀯娓呮櫚瑙勮寖
- 馃摎 鐭ヨ瘑搴撳畬鏁?- 馃殌 闅忔椂鍙互鎶曞叆鐢熶骇

**寮€濮嬪垱閫犱紵澶х殑浜у搧鍚э紒** 馃挭

---

*瀹屾垚鏃堕棿锛?026-03-08*  
*鎵ц鑰咃細鐏屾堡 PM + 鍏ㄤ綋鍥㈤槦鎴愬憳*

