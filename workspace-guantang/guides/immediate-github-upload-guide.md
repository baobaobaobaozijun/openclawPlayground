<!-- Last Modified: 2026-03-08 -->
<!-- Last Modified (CN): 2026-03-08 -->

# 馃殌 GitHub 浠ｇ爜涓婁紶 - 绔嬪嵆鎵ц鎸囧崡

## 鈿狅笍 褰撳墠鐘舵€?
- 鉁?**鎵€鏈?Git浠撳簱宸插垵濮嬪寲骞舵彁浜?*
- 鈿狅笍 **Token 鏉冮檺闂:** 褰撳墠 Token 娌℃湁鍐欏叆鏉冮檺锛?03 閿欒锛?- 馃搵 **瑙ｅ喅鏂规:** 闇€瑕佹墜鍔ㄦ墽琛屾帹閫佸懡浠?
---

## 馃攽 绗竴姝ワ細妫€鏌?Token 鏉冮檺

浣犵殑 Token `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` 浼间箮缂哄皯鍐欐潈闄愩€?
### 閫夐」 A: 浣跨敤鏈夋潈闄愮殑 Token

1. 璁块棶锛歨ttps://github.com/settings/tokens
2. 鎵惧埌杩欎釜 Token 鎴栧垱寤烘柊鐨?3. 纭繚鍕鹃€変簡浠ヤ笅鏉冮檺锛?   - 鉁?**repo** (Full control of private repositories)
   - 鉁?**workflow**
4. 澶嶅埗鏂?Token

### 閫夐」 B: 鐩存帴浣跨敤 GitHub Desktop锛堟帹鑽愶級

涓嬭浇锛歨ttps://desktop.github.com/
- 鐧诲綍 GitHub 璐﹀彿
- 娣诲姞鐜版湁浠撳簱
- 鐩存帴鎺ㄩ€侊紙鍙鍖栨搷浣滐紝鏇寸畝鍗曪級

---

## 馃摑 绗簩姝ワ細鎵嬪姩鎺ㄩ€佸懡浠?
### 鏂规硶 1: 浣跨敤 Git Credential Manager锛堟渶绠€鍗曪級

```powershell
# 1. 鐏屾堡 PM - openclawPlayground
cd F:\openclaw\workspace
git push origin main
# 娴忚鍣ㄤ細寮瑰嚭鐧诲綍绐楀彛锛岀櫥褰?GitHub 鍗冲彲

# 2. 閰辫倝鍚庣 - openclaw-backend
cd F:\openclaw\workspace-jiangrou
git remote add origin https://github.com/baobaobaobaozijun/openclaw-backend.git
git branch -M main
git push origin main

# 3. 璞嗘矙鍓嶇 - openclaw-frontend
cd F:\openclaw\workspace-dousha
git remote add origin https://github.com/baobaobaobaozijun/openclaw-frontend.git
git branch -M main
git push origin main

# 4. 閰歌彍杩愮淮 - openclaw-devops
cd F:\openclaw\workspace-suancai
git remote add origin https://github.com/baobaobaobaozijun/openclaw-devops.git
git branch -M main
git push origin main
```

---

### 鏂规硶 2: 鐩存帴鍦ㄥ懡浠よ杈撳叆 Token

```powershell
# 娓呴櫎鍙兘鍐茬獊鐨勫嚟璇?cmdkey /delete:git:https://github.com

# 鐒跺悗鎵ц鎺ㄩ€?cd F:\openclaw\workspace
git push origin main
```

褰撴彁绀鸿緭鍏ュ瘑鐮佹椂锛?- **Username:** `baobaobaobaozijun`
- **Password:** 绮樿创浣犵殑 Token锛坄github_pat_...`锛?
鈿狅笍 **娉ㄦ剰:** 绮樿创 Token 鏃朵笉浼氭樉绀轰换浣曞瓧绗︼紝杩欐槸姝ｅ父鐨勶紒

---

## 馃幆 蹇€熼獙璇佹竻鍗?
姣忔帹閫佷竴涓粨搴擄紝灏辨鏌ヤ竴椤癸細

### 鉁?openclawPlayground (鐏屾堡)
- [ ] 鎵ц锛歚cd F:\openclaw\workspace` 鈫?`git push origin main`
- [ ] 璁块棶锛歨ttps://github.com/baobaobaobaozijun/openclawPlayground
- [ ] 鑳界湅鍒版枃浠讹細IDENTITY.md, ROLE.md, SOUL.md, README.md

### 鉁?openclaw-backend (閰辫倝)
- [ ] 鎵ц锛歚cd F:\openclaw\workspace-jiangrou` 鈫?`git push origin main`
- [ ] 璁块棶锛歨ttps://github.com/baobaobaobaozijun/openclaw-backend
- [ ] 鑳界湅鍒版枃浠讹細IDENTITY.md, ROLE.md, SOUL.md, README.md

### 鉁?openclaw-frontend (璞嗘矙)
- [ ] 鎵ц锛歚cd F:\openclaw\workspace-dousha` 鈫?`git push origin main`
- [ ] 璁块棶锛歨ttps://github.com/baobaobaobaozijun/openclaw-frontend
- [ ] 鑳界湅鍒版枃浠讹細IDENTITY.md, ROLE.md, SOUL.md, README.md

### 鉁?openclaw-devops (閰歌彍)
- [ ] 鎵ц锛歚cd F:\openclaw\workspace-suancai` 鈫?`git push origin main`
- [ ] 璁块棶锛歨ttps://github.com/baobaobaobaozijun/openclaw-devops
- [ ] 鑳界湅鍒版枃浠讹細IDENTITY.md, ROLE.md, SOUL.md, README.md

---

## 馃洜锔?鏁呴殰鎺掗櫎

### 闂 1: "Write access not granted" (403)

**鍘熷洜:** Token 娌℃湁鍐欐潈闄?
**瑙ｅ喅:**
1. 浣跨敤 GitHub Desktop锛堟渶绠€鍗曪級
2. 鎴栭噸鏂板垱寤烘湁 `repo` 鏉冮檺鐨?Token
3. 鎴栧湪鎺ㄩ€佹椂璁╂祻瑙堝櫒寮瑰嚭鐧诲綍锛圙it Credential Manager锛?
### 闂 2: "Repository not found"

**鍘熷洜:** 浠撳簱杩樹笉瀛樺湪

**瑙ｅ喅:**
1. 鎵撳紑娴忚鍣?2. 璁块棶 https://github.com/new
3. 鍒涘缓瀵瑰簲鐨勭┖浠撳簱锛堜笉瑕佸垵濮嬪寲 README锛?4. 閲嶆柊鎺ㄩ€?
### 闂 3: 娴忚鍣ㄤ笉寮瑰嚭鐧诲綍绐楀彛

**瑙ｅ喅:**
```powershell
# 娓呴櫎鏃у嚟璇?git credential-manager erase
# 杈撳叆锛歨ost=github.com
#       protocol=https
#       path=/baobaobaobaozijun/浠撳簱鍚?git
# 鐒跺悗鎸?Ctrl+Z

# 閲嶆柊鎺ㄩ€佽Е鍙戠櫥褰?git push origin main
```

---

## 馃搳 鎺ㄨ崘鎿嶄綔娴佺▼锛堟渶鍙潬锛?
### 鏂规 A: GitHub Desktop锛堝浘褰㈢晫闈紝鎺ㄨ崘锛?
1. 涓嬭浇瀹夎锛歨ttps://desktop.github.com/
2. 鐧诲綍 GitHub 璐﹀彿
3. File 鈫?Add Local Repository 鈫?閫夋嫨姣忎釜 workspace鏂囦欢澶?4. 鐐瑰嚮 Push origin 鎸夐挳

### 鏂规 B: 鍛戒护琛?+ 娴忚鍣ㄧ櫥褰?
1. 鎵ц `git push origin main`
2. 娴忚鍣ㄨ嚜鍔ㄥ脊鍑?GitHub 鐧诲綍
3. 鐧诲綍鍚庤嚜鍔ㄥ畬鎴愭帹閫?4. 閲嶅 4 娆★紙姣忎釜浠撳簱涓€娆★級

### 鏂规 C: 绾懡浠よ + Token

1. `git push origin main`
2. 杈撳叆鐢ㄦ埛鍚嶏細`baobaobaobaozijun`
3. 杈撳叆瀵嗙爜锛氱矘璐?Token锛堜笉鏄剧ず锛?4. 閲嶅 4 娆?
---

## 鉁?瀹屾垚鍚庨獙璇?
鍏ㄩ儴鎺ㄩ€佹垚鍔熷悗锛岃闂繖浜涢摼鎺ョ‘璁わ細

- https://github.com/baobaobaobaozijun/openclawPlayground
- https://github.com/baobaobaobaozijun/openclaw-backend
- https://github.com/baobaobaobaozijun/openclaw-frontend
- https://github.com/baobaobaobaozijun/openclaw-devops

姣忎釜浠撳簱搴旇鏄剧ず锛?- 鉁?鏈€鏂扮殑鎻愪氦璁板綍
- 鉁?5 涓牳蹇冩枃浠讹紙IDENTITY.md, ROLE.md, SOUL.md, README.md, .gitignore锛?
---

## 馃帀 涓嬩竴姝?
涓婁紶鎴愬姛鍚庡憡璇夋垜锛屾垜浼氬府浣狅細
1. 鏇存柊鐩稿叧鏂囨。涓殑閾炬帴
2. 閰嶇疆鍒嗘敮淇濇姢瑙勫垯
3. 璁剧疆 GitHub Actions 鑷姩鍖?
---

**鐜板湪璇烽€夋嫨涓€绉嶆柟娉曞紑濮嬫帹閫佸惂锛?* 馃挭

鎺ㄨ崘浣跨敤 **GitHub Desktop** 鎴?**鍛戒护琛?+ 娴忚鍣ㄧ櫥褰?*锛岃繖涓ょ鏂规硶鏈€鍙潬锛?
