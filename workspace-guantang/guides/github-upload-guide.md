<!-- Last Modified: 2026-03-08 -->
<!-- Last Modified (CN): 2026-03-08 -->

# 馃摛 GitHub 涓婁紶鎸囧崡

## 馃幆 鐩爣

灏?4 涓?Agent 鐨?workspace 涓婁紶鍒?GitHub锛?
1. **鐏屾堡 PM** 鈫?`openclawPlayground` (涓讳粨搴?
2. **閰辫倝鍚庣** 鈫?`openclaw-backend` (鏂板缓)
3. **璞嗘矙鍓嶇** 鈫?`openclaw-frontend` (鏂板缓)
4. **閰歌彍杩愮淮** 鈫?`openclaw-devops` (鏂板缓)

---

## 鉁?宸插畬鎴愮殑宸ヤ綔

### 鏂囦欢鏁寸悊

- 鉁?鎵€鏈?Agent 鐨勬牳蹇冩枃浠跺凡鍒涘缓瀹屾垚锛圛DENTITY.md, ROLE.md, SOUL.md锛?- 鉁?姣忎釜 workspace 閮芥湁鐙珛鐨?README.md
- 鉁?姣忎釜 workspace 閮芥湁 .gitignore 鏂囦欢
- 鉁?鏂囦欢缁撴瀯娓呮櫚锛屾棤鐭涚浘鍜屽浣欏唴瀹?
### Git 鍒濆鍖栫姸鎬?
| Workspace | Git 鐘舵€?| 璇存槑 |
|-----------|---------|------|
| workspace | 鉁?宸叉彁浜?| 鍖呭惈鐏屾堡鐨勬墍鏈夋枃浠?|
| workspace-jiangrou | 鈴?寰呭垵濮嬪寲 | 閰辫倝鐨勭嫭绔?workspace |
| workspace-dousha | 鈴?寰呭垵濮嬪寲 | 璞嗘矙鐨勭嫭绔?workspace |
| workspace-suancai | 鈴?寰呭垵濮嬪寲 | 閰歌彍鐨勭嫭绔?workspace |

---

## 馃殌 鎵嬪姩涓婁紶姝ラ

鐢变簬 GitHub 闇€瑕佽璇侊紝璇锋寜鐓т互涓嬫楠ゆ墜鍔ㄤ笂浼狅細

### 姝ラ 1: 鍒涘缓 GitHub 浠撳簱

鍦ㄦ祻瑙堝櫒涓墦寮€ https://github.com/new 鍒涘缓浠ヤ笅 4 涓粨搴擄細

#### 1. openclawPlayground (涓讳粨搴?- 鐏屾堡)
- **Repository name:** `openclawPlayground`
- **Description:** OpenClaw Agent Team - PM Workspace (鐏屾堡)
- **Public/Private:** Public 鉁?- **Initialize with:** 涓嶅嬀閫変换浣曢€夐」锛堢┖浠撳簱锛?
#### 2. openclaw-backend (閰辫倝 - 鍚庣浠ｇ爜)
- **Repository name:** `openclaw-backend`
- **Description:** OpenClaw Backend Code (閰辫倝璐熻矗)
- **Public/Private:** Public 鉁?- **Initialize with:** 涓嶅嬀閫?
#### 3. openclaw-frontend (璞嗘矙 - 鍓嶇浠ｇ爜)
- **Repository name:** `openclaw-frontend`
- **Description:** OpenClaw Frontend Code (璞嗘矙璐熻矗)
- **Public/Private:** Public 鉁?- **Initialize with:** 涓嶅嬀閫?
#### 4. openclaw-devops (閰歌彍 - 杩愮淮鑴氭湰)
- **Repository name:** `openclaw-devops`
- **Description:** OpenClaw DevOps Scripts (閰歌彍璐熻矗)
- **Public/Private:** Public 鉁?- **Initialize with:** 涓嶅嬀閫?
---

### 姝ラ 2: 閰嶇疆杩滅▼浠撳簱骞舵帹閫?
#### 鐏屾堡 workspace (openclawPlayground)

```bash
cd F:\openclaw\workspace

# 娣诲姞杩滅▼浠撳簱锛堟浛鎹负浣犵殑 GitHub 鐢ㄦ埛鍚嶏級
git remote add origin https://github.com/baobaobaobaozijun/openclawPlayground.git

# 鎺ㄩ€佸埌 GitHub
git branch -M main
git push -u origin main
```

#### 閰辫倝 workspace (openclaw-backend)

```bash
cd F:\openclaw\workspace-jiangrou

# 鍒濆鍖?git
git init
git add .
git commit -m "feat: 鍒濆鍖栭叡鑲夊悗绔?workspace"

# 娣诲姞杩滅▼浠撳簱
git remote add origin https://github.com/baobaobaobaozijun/openclaw-backend.git

# 鎺ㄩ€?git branch -M main
git push -u origin main
```

#### 璞嗘矙 workspace (openclaw-frontend)

```bash
cd F:\openclaw\workspace-dousha

# 鍒濆鍖?git
git init
git add .
git commit -m "feat: 鍒濆鍖栬眴娌欏墠绔?workspace"

# 娣诲姞杩滅▼浠撳簱
git remote add origin https://github.com/baobaobaobaozijun/openclaw-frontend.git

# 鎺ㄩ€?git branch -M main
git push -u origin main
```

#### 閰歌彍 workspace (openclaw-devops)

```bash
cd F:\openclaw\workspace-suancai

# 鍒濆鍖?git
git init
git add .
git commit -m "feat: 鍒濆鍖栭吀鑿滆繍缁?workspace"

# 娣诲姞杩滅▼浠撳簱
git remote add origin https://github.com/baobaobaobaozijun/openclaw-devops.git

# 鎺ㄩ€?git branch -M main
git push -u origin main
```

---

## 馃攼 GitHub 璁よ瘉鏂规硶

### 鏂规硶 1: Personal Access Token (鎺ㄨ崘)

1. 璁块棶 https://github.com/settings/tokens
2. 鐐瑰嚮 "Generate new token (classic)"
3. 閫夋嫨 scopes: `repo`, `workflow`
4. 鐢熸垚 token 骞跺鍒?5. 鎺ㄩ€佹椂浣跨敤 token 浠ｆ浛瀵嗙爜

```bash
git push https://<YOUR_USERNAME>:<YOUR_TOKEN>@github.com/baobaobaobaozijun/openclawPlayground.git
```

### 鏂规硶 2: SSH Key

```bash
# 鐢熸垚 SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"

# 娣诲姞鍒?GitHub
# 璁块棶 https://github.com/settings/ssh-keys
# 鐐瑰嚮 New SSH Key锛岀矘璐?~/.ssh/id_ed25519.pub 鐨勫唴瀹?
# 浣跨敤 SSH URL
git remote set-url origin git@github.com:baobaobaobaozijun/openclawPlayground.git
git push -u origin main
```

### 鏂规硶 3: GitHub CLI

```bash
# 瀹夎 GitHub CLI
winget install GitHub.cli

# 鐧诲綍
gh auth login

# 鎺ㄩ€?git push -u origin main
```

---

## 馃搳 涓婁紶妫€鏌ユ竻鍗?
### 鐏屾堡 (openclawPlayground)
- [ ] IDENTITY.md
- [ ] ROLE.md 鉁?鏂板
- [ ] SOUL.md
- [ ] README.md 鉁?鏂板
- [ ] AGENTS.md
- [ ] 鍏朵粬蹇呰鏂囦欢
- [ ] .gitignore 鉁?鏂板

### 閰辫倝 (openclaw-backend)
- [ ] IDENTITY.md
- [ ] ROLE.md
- [ ] SOUL.md
- [ ] README.md 鉁?鏂板
- [ ] .gitignore 鉁?鏂板

### 璞嗘矙 (openclaw-frontend)
- [ ] IDENTITY.md
- [ ] ROLE.md
- [ ] SOUL.md
- [ ] README.md 鉁?鏂板
- [ ] .gitignore 鉁?鏂板

### 閰歌彍 (openclaw-devops)
- [ ] IDENTITY.md
- [ ] ROLE.md
- [ ] SOUL.md
- [ ] README.md 鉁?鏂板
- [ ] .gitignore 鉁?鏂板

---

## 馃帀 涓婁紶鍚庣殑楠岃瘉

涓婁紶瀹屾垚鍚庯紝鍦?GitHub 涓婃鏌ヤ互涓嬪唴瀹癸細

### 1. 鏂囦欢瀹屾暣鎬?- 鎵€鏈夋牳蹇冩枃浠堕兘宸蹭笂浼?- README.md 鏄剧ず姝ｅ父
- 鐩綍缁撴瀯姝ｇ‘

### 2. 浠撳簱閾炬帴
- openclawPlayground: https://github.com/baobaobaobaozijun/openclawPlayground
- openclaw-backend: https://github.com/baobaobaobaozijun/openclaw-backend
- openclaw-frontend: https://github.com/baobaobaobaozijun/openclaw-frontend
- openclaw-devops: https://github.com/baobaobaobaozijun/openclaw-devops

### 3. 鏇存柊寮曠敤閾炬帴

鍦ㄦ墍鏈?README.md 涓洿鏂颁粨搴撻摼鎺ワ紙濡傞渶瑕侊級銆?
---

## 馃摑 娉ㄦ剰浜嬮」

1. **涓嶈涓婁紶鐨勫唴瀹?**
   - logs/ 鐩綍锛堝伐浣滄棩蹇楋級
   - tasks/ 鐩綍锛堜换鍔℃枃浠讹級
   - communication/ 鐩綍锛堥€氫俊璁板綍锛?   - 鏁忔劅淇℃伅锛圓PI Key銆佸瘑鐮佺瓑锛?
2. **寤鸿涓婁紶鐨勫唴瀹?**
   - 鏍稿績閰嶇疆鏂囦欢锛圛DENTITY.md, ROLE.md, SOUL.md锛?   - README.md
   - .gitignore
   - Docker 閰嶇疆鏂囦欢锛堝闇€瑕侊級

3. **鍚庣画鍚屾:**
   - 瀹氭湡 commit 鍜?push
   - 淇濇寔鏈湴鍜岃繙绋嬪悓姝?   - 浣跨敤 git pull 鑾峰彇鏇存柊

---

## 馃啒 鏁呴殰鎺掗櫎

### 闂 1: 璁よ瘉澶辫触
```
remote: Support for password authentication was removed on August 13, 2021.
```
**瑙ｅ喅:** 浣跨敤 Personal Access Token 鎴?SSH Key

### 闂 2: 浠撳簱涓嶅瓨鍦?```
remote: Repository not found.
```
**瑙ｅ喅:** 鍏堝湪 GitHub 涓婂垱寤虹┖浠撳簱

### 闂 3: 鏉冮檺涓嶈冻
```
ERROR: Permission to baobaobaobaozijun/repo.git denied to user.
```
**瑙ｅ喅:** 妫€鏌?SSH key 鏄惁宸叉坊鍔犲埌 GitHub

---

**鎸夌収浠ヤ笂姝ラ鎿嶄綔锛屽嵆鍙垚鍔熷皢鎵€鏈?Agent workspace 涓婁紶鍒?GitHub锛?* 馃殌

