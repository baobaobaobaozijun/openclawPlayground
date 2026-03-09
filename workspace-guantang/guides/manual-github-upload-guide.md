<!-- Last Modified: 2026-03-08 -->
<!-- Last Modified (CN): 2026-03-08 -->

# 馃摛 鎵嬪姩涓婁紶鍒?GitHub - 鎿嶄綔鎸囧崡

## 鈿狅笍 褰撳墠鐘舵€?
**缃戠粶妫€鏌?** 鏆傛椂鏃犳硶璁块棶 GitHub (鍙兘鏄綉缁滄垨 DNS 闂)

**瑙ｅ喅鏂规:** 璇锋寜鐓т互涓嬫楠ゆ墜鍔ㄥ湪鍛戒护琛屼腑鎵ц鍛戒护

---

## 馃殌 蹇€熶笂浼犳楠?
### 1锔忊儯 鐏屾堡 PM - openclawPlayground

鎵撳紑 PowerShell 鎴?CMD锛屼緷娆℃墽琛岋細

```powershell
# 杩涘叆鐩綍
cd F:\openclaw\workspace

# 纭杩滅▼浠撳簱
git remote -v

# 濡傛灉鐪嬩笉鍒?origin锛屾坊鍔犺繙绋嬩粨搴?git remote add origin https://github.com/baobaobaobaozijun/openclawPlayground.git

# 鎺ㄩ€佷唬鐮?git push -u origin main
```

**杈撳叆鍑瘉:**
- Username: `baobaobaobaozijun`
- Password: [浣犵殑 GitHub Personal Access Token](https://github.com/settings/tokens)

---

### 2锔忊儯 閰辫倝鍚庣 - openclaw-backend

```powershell
cd F:\openclaw\workspace-jiangrou

# 鍒濆鍖栧苟鎺ㄩ€?git remote add origin https://github.com/baobaobaobaozijun/openclaw-backend.git
git branch -M main
git push -u origin main
```

---

### 3锔忊儯 璞嗘矙鍓嶇 - openclaw-frontend

```powershell
cd F:\openclaw\workspace-dousha

# 鍒濆鍖栧苟鎺ㄩ€?git remote add origin https://github.com/baobaobaobaozijun/openclaw-frontend.git
git branch -M main
git push -u origin main
```

---

### 4锔忊儯 閰歌彍杩愮淮 - openclaw-devops

```powershell
cd F:\openclaw\workspace-suancai

# 鍒濆鍖栧苟鎺ㄩ€?git remote add origin https://github.com/baobaobaobaozijun/openclaw-devops.git
git branch -M main
git push -u origin main
```

---

## 馃攼 鑾峰彇 Personal Access Token

濡傛灉杩樻病鏈?Token锛岃鎸変互涓嬫楠ゅ垱寤猴細

### 姝ラ 1: 璁块棶 Token 椤甸潰
鎵撳紑娴忚鍣紝璁块棶锛歨ttps://github.com/settings/tokens

### 姝ラ 2: 鐢熸垚鏂?Token
1. 鐐瑰嚮 **"Generate new token"** 鈫?**"Generate new token (classic)"**
2. 濉啓澶囨敞锛圢ote锛夛細渚嬪 "OpenClaw Upload"
3. 閫夋嫨杩囨湡鏃堕棿锛圗xpiration锛夛細寤鸿閫?**No expiration** 鎴?**90 days**
4. 鍕鹃€夋潈闄愶紙Scopes锛夛細
   - 鉁?`repo` (Full control of private repositories)
   - 鉁?`workflow` (Update GitHub Action workflows)

### 姝ラ 3: 澶嶅埗 Token
1. 鐐瑰嚮 **"Generate token"**
2. **绔嬪嵆澶嶅埗**鐢熸垚鐨?token锛堜互 `ghp_` 寮€澶达級
3. 鈿狅笍 **閲嶈:** Token 鍙細鏄剧ず涓€娆★紝绂诲紑椤甸潰鍚庢棤娉曞啀鏌ョ湅锛?
### 姝ラ 4: 浣跨敤 Token
鎺ㄩ€佷唬鐮佹椂锛?- Username: `baobaobaobaozijun`
- Password: 绮樿创浣犲鍒剁殑 Token锛堜笉浼氭樉绀哄瓧绗︼級

---

## 鉁?楠岃瘉涓婁紶鎴愬姛

涓婁紶瀹屾垚鍚庯紝鍦ㄦ祻瑙堝櫒涓闂互涓嬮摼鎺ユ鏌ワ細

1. **openclawPlayground**: https://github.com/baobaobaobaozijun/openclawPlayground
2. **openclaw-backend**: https://github.com/baobaobaobaozijun/openclaw-backend
3. **openclaw-frontend**: https://github.com/baobaobaobaozijun/openclaw-frontend
4. **openclaw-devops**: https://github.com/baobaobaobaozijun/openclaw-devops

姣忎釜浠撳簱搴旇鑳界湅鍒帮細
- 鉁?IDENTITY.md
- 鉁?ROLE.md
- 鉁?SOUL.md
- 鉁?README.md
- 鉁?.gitignore

---

## 馃啒 甯歌闂瑙ｅ喅

### 闂 1: "Could not resolve host: github.com"

**鍘熷洜:** DNS 瑙ｆ瀽澶辫触鎴栫綉缁滈棶棰?
**瑙ｅ喅鏂规硶:**

**鏂规硶 A: 淇敼 DNS**
```powershell
# 浠ョ鐞嗗憳韬唤杩愯 PowerShell
# 缃戠粶璁剧疆 鈫?鏇存敼閫傞厤鍣ㄩ€夐」 鈫?鍙抽敭褰撳墠缃戠粶 鈫?灞炴€?# 閫夋嫨 "Internet 鍗忚鐗堟湰 4 (TCP/IPv4)" 鈫?灞炴€?# 浣跨敤浠ヤ笅 DNS 鏈嶅姟鍣?
# 棣栭€夛細8.8.8.8
# 澶囩敤锛?.8.4.4
```

**鏂规硶 B: 鍒锋柊 DNS 缂撳瓨**
```powershell
ipconfig /flushdns
```

**鏂规硶 C: 妫€鏌ヤ唬鐞?*
```powershell
# 濡傛灉浣跨敤浠ｇ悊锛岀‘淇濅唬鐞嗘甯稿伐浣?# 鎴栦复鏃跺叧闂唬鐞?```

---

### 闂 2: "Authentication failed"

**鍘熷洜:** 瀵嗙爜閿欒鎴?Token 杩囨湡

**瑙ｅ喅鏂规硶:**

1. 娓呴櫎淇濆瓨鐨勫嚟璇侊細
```powershell
cmdkey /list
cmdkey /delete:git:https://github.com
```

2. 閲嶆柊鎺ㄩ€佸苟浣跨敤鏂?Token锛?```powershell
git push -u origin main
# 杈撳叆鐢ㄦ埛鍚嶅拰鏂扮殑 Token
```

---

### 闂 3: "Repository not found"

**鍘熷洜:** GitHub 涓婅繕娌℃湁鍒涘缓杩欎釜浠撳簱

**瑙ｅ喅鏂规硶:**

1. 鎵撳紑娴忚鍣ㄨ闂細https://github.com/new
2. 鍒涘缓瀵瑰簲鐨勭┖浠撳簱锛堜笉瑕佸嬀閫?Initialize with README锛?3. 閲嶆柊鎵ц鎺ㄩ€佸懡浠?
---

### 闂 4: "Permission denied"

**鍘熷洜:** 娌℃湁璇ヤ粨搴撶殑鍐欏叆鏉冮檺

**瑙ｅ喅鏂规硶:**

1. 纭浣犳槸浠撳簱鐨勬墍鏈夎€呮垨鍗忎綔鑰?2. 濡傛灉鏄粍缁囦粨搴擄紝妫€鏌ヤ綘鐨勬潈闄愮骇鍒?3. 浣跨敤姝ｇ‘鐨?SSH key 鎴?Token

---

## 馃搳 涓婁紶妫€鏌ユ竻鍗?
瀹屾垚姣忎釜浠撳簱鍚庯紝鍦ㄥ搴旀鎵撳嬀锛?
### openclawPlayground (鐏屾堡)
- [ ] 浠撳簱宸插垱寤?- [ ] 浠ｇ爜宸叉帹閫?- [ ] 鑳藉湪 GitHub 鐪嬪埌鏂囦欢
- [ ] 鍖呭惈鎵€鏈夋牳蹇冩枃浠?
### openclaw-backend (閰辫倝)
- [ ] 浠撳簱宸插垱寤?- [ ] 浠ｇ爜宸叉帹閫?- [ ] 鑳藉湪 GitHub 鐪嬪埌鏂囦欢
- [ ] 鍖呭惈鎵€鏈夋牳蹇冩枃浠?
### openclaw-frontend (璞嗘矙)
- [ ] 浠撳簱宸插垱寤?- [ ] 浠ｇ爜宸叉帹閫?- [ ] 鑳藉湪 GitHub 鐪嬪埌鏂囦欢
- [ ] 鍖呭惈鎵€鏈夋牳蹇冩枃浠?
### openclaw-devops (閰歌彍)
- [ ] 浠撳簱宸插垱寤?- [ ] 浠ｇ爜宸叉帹閫?- [ ] 鑳藉湪 GitHub 鐪嬪埌鏂囦欢
- [ ] 鍖呭惈鎵€鏈夋牳蹇冩枃浠?
---

## 馃帀 涓婁紶鎴愬姛鍚庣殑涓嬩竴姝?
1. **鏇存柊 README 涓殑閾炬帴**
   - 鍦ㄦ墍鏈夌浉鍏虫枃妗ｄ腑鏇存柊浠撳簱 URL
   
2. **閰嶇疆鍒嗘敮淇濇姢**
   - 鍦?GitHub 浠撳簱 Settings 鈫?Branches 鈫?Add rule
   - Branch name pattern: `main`
   - 鍕鹃€?"Require a pull request before merging"

3. **鍚敤 GitHub Actions (鍙€?**
   - 鐢ㄤ簬鑷姩鍖栨祴璇曞拰閮ㄧ讲

4. **閭€璇峰崗浣滆€?(鍙€?**
   - Settings 鈫?Collaborators 鈫?Add people

---

## 馃摓 闇€瑕佸府鍔╋紵

濡傛灉鍦ㄤ笂浼犺繃绋嬩腑閬囧埌闂锛?
1. 鎴浘閿欒淇℃伅
2. 鍛婅瘔鎴戝叿浣撶殑閿欒鍐呭
3. 鎴戜細甯綘鍒嗘瀽骞舵彁渚涜В鍐虫柟妗?
---

**鍑嗗濂藉悗锛屾寜鐓т笂闈㈢殑姝ラ寮€濮嬩笂浼犲惂锛?* 馃挭

