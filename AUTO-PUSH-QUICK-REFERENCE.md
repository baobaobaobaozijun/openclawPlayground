<!-- Last Modified: 2026-03-09 -->
<!-- Last Modified (CN): 2026-03-09 -->

# Auto Push Agent - 蹇€熷弬鑰?

## 馃殌 鎶€鑳藉凡灏辩华

鉁?**鎶€鑳芥枃浠?*: `.lingma/skills/auto-push-agent/SKILL.md`  
鉁?**Git 浠撳簱**: 宸插垵濮嬪寲  
鉁?**閰嶇疆鏂囦欢**: `.openclaw/auto-push-config.json`  
鉁?**蹇界暐瑙勫垯**: `.gitignore`  

## 馃搵 涓嬩竴姝ユ搷浣滐紙蹇呴』瀹屾垚锛?

### 1锔忊儯 閫夋嫨 Git 骞冲彴骞跺垱寤轰粨搴?

**GitHub** (鎺ㄨ崘):
- 璁块棶锛歨ttps://github.com/new
- 鍒涘缓鏂颁粨搴?
- 澶嶅埗浠撳簱鍦板潃锛歚https://github.com/{鐢ㄦ埛鍚峿/{浠撳簱鍚峿.git`

**Gitee** (鍥藉唴鎺ㄨ崘):
- 璁块棶锛歨ttps://gitee.com/new
- 鍒涘缓鏂颁粨搴?
- 澶嶅埗浠撳簱鍦板潃锛歚https://gitee.com/{鐢ㄦ埛鍚峿/{浠撳簱鍚峿.git`

**LabCode**:
- 璁块棶鐩稿簲骞冲彴鍒涘缓浠撳簱
- 澶嶅埗浠撳簱鍦板潃

### 2锔忊儯 閰嶇疆杩滅▼浠撳簱

```bash
# 鏇挎崲 <浠撳簱鍦板潃> 涓轰綘鍒氭墠澶嶅埗鐨勫湴鍧€
git remote add origin <浠撳簱鍦板潃>

# 楠岃瘉閰嶇疆
git remote -v
```

### 3锔忊儯 鎵ц棣栨鎻愪氦鍜屾帹閫?

```bash
# 娣诲姞鎵€鏈夋枃浠?
git add .

# 鎻愪氦
git commit -m "init: 椤圭洰鍒濆鍖?

# 鎺ㄩ€佸埌杩滅▼锛堝鏋滄槸 main 鍒嗘敮锛屾浛鎹?master 涓?main锛?
git push -u origin master
```

### 4锔忊儯 锛堟帹鑽愶級閰嶇疆 SSH Key

閬垮厤姣忔閮借緭鍏ョ敤鎴峰悕瀵嗙爜锛?

```bash
# 鐢熸垚 SSH key锛堜竴璺洖杞﹀嵆鍙級
ssh-keygen -t ed25519 -C "your_email@example.com"

# 鏌ョ湅鍏挜鍐呭
cat ~/.ssh/id_ed25519.pub

# 灏嗗叕閽ユ坊鍔犲埌 Git 骞冲彴鐨?SSH Keys 璁剧疆涓?
```

鐒跺悗浣跨敤 SSH 鍦板潃锛?
```bash
# GitHub
git remote set-url origin git@github.com:{鐢ㄦ埛鍚峿/{浠撳簱鍚峿.git

# Gitee
git remote set-url origin git@gitee.com:{鐢ㄦ埛鍚峿/{浠撳簱鍚峿.git
```

## 馃幆 鎶€鑳借嚜鍔ㄨЕ鍙戞潯浠?

姣忔淇敼 `agent/` 鐩綍涓嬬殑鏂囦欢鍚庯紝浼氳嚜鍔ㄦ墽琛岋細

1. 鉁?`git add agent/` - 娣诲姞鏇存敼
2. 鉁?`git commit -m "{瑙勮寖鐨勬彁浜や俊鎭瘆"` - 鎻愪氦鏇存敼
3. 鉁?`git pull --rebase` - 鎷夊彇鏈€鏂颁唬鐮?
4. 鉁?`git push` - 鎺ㄩ€佸埌杩滅▼
5. 鉁?鐢熸垚鏃ュ織鍒?`agent/workinglog/`

## 馃摑 鎻愪氦淇℃伅鏍煎紡

```
{绫诲瀷} ({鑼冨洿}): {绠€鐭弿杩皚

- 淇敼鏃堕棿锛歿yyyyMMdd-HHmmss}
- 娑夊強鏂囦欢锛?
  - 鏂囦欢 1
  - 鏂囦欢 2
- 鍙樻洿鎽樿锛歿绠€瑕佽鏄庝富瑕佸彉鏇磢
```

**甯哥敤绫诲瀷**:
- `feat`: 鏂板姛鑳?
- `fix`: 淇闂
- `docs`: 鏂囨。鏇存柊
- `refactor`: 閲嶆瀯
- `config`: 閰嶇疆鍙樻洿

**甯哥敤鑼冨洿**:
- `agent`: 閫氱敤 agent
- `workspace`: 宸ヤ綔绌洪棿
- `docker`: Docker 閰嶇疆
- `skill`: 鎶€鑳界浉鍏?

## 馃敡 閰嶇疆鏂囦欢璇存槑

`.openclaw/auto-push-config.json`:

```json
{
  "autoPush": {
    "enabled": true,              // 鏄惁鍚敤
    "remoteUrl": "",              // 杩滅▼浠撳簱鍦板潃锛堝彲鐣欑┖鎵嬪姩閰嶇疆锛?
    "branch": "main",             // 鍒嗘敮鍚嶇О
    "autoInit": true,             // 鑷姩鍒濆鍖?
    "generateLogs": true,         // 鐢熸垚鏃ュ織
    "logPath": "agent/workinglog/", // 鏃ュ織璺緞
    "retryCount": 3               // 澶辫触閲嶈瘯娆℃暟
  }
}
```

## 馃洝锔?瀹夊叏鐗规€?

- 鉁?**鏁忔劅淇℃伅妫€娴?*: 鑷姩妫€娴?password=, secret=, api_key= 绛?
- 鉁?**鎻愪氦鍓嶆鏌?*: 纭繚鍙寘鍚?agent 鐩綍鐨勬枃浠?
- 鉁?**鍥炴粴鏈哄埗**: 璁板綍姣忎釜 commit hash锛屾敮鎸佸揩閫熷洖婊?
- 鉁?**鍐茬獊澶勭悊**: 閬囧埌鍐茬獊绔嬪嵆鍋滄骞剁敓鎴愭姤鍛?
- 鉁?**澶ф枃浠惰鍛?*: 瓒呰繃 50MB 鐨勬枃浠朵細鍙戝嚭璀﹀憡

## 鈿狅笍 娉ㄦ剰浜嬮」

1. **棣栨浣跨敤鍓嶅繀椤诲厛鎺ㄩ€?*: 閰嶇疆濂借繙绋嬩粨搴撳悗锛屽厛鎵嬪姩鎵ц涓€娆?`git push`
2. **淇濇寔缃戠粶鐣呴€?*: 鎺ㄩ€佽繃绋嬮渶瑕佺綉缁滆繛鎺?
3. **瀹氭湡妫€鏌?*: 鍋跺皵妫€鏌ヤ竴涓嬭繙绋嬩粨搴擄紝纭繚鎺ㄩ€佹甯?
4. **鏁忔劅鏁版嵁**: 涓嶈鍦?agent 鐩綍瀛樻斁瀵嗙爜銆佸瘑閽ョ瓑鏁忔劅淇℃伅
5. **澶ф枃浠?*: 鍗曚釜鏂囦欢涓嶈瓒呰繃 50MB

## 馃悰 甯歌闂

### Q1: 鎻愮ず "Permission denied"
**瑙ｅ喅**: 閰嶇疆 SSH key 鎴栦娇鐢?HTTPS + 鐢ㄦ埛鍚嶅瘑鐮?

### Q2: 鎻愮ず "repository not found"
**瑙ｅ喅**: 妫€鏌ヨ繙绋嬩粨搴撳湴鍧€鏄惁姝ｇ‘锛岀‘璁や粨搴撳凡鍒涘缓

### Q3: Push 澶辫触锛岀綉缁滈敊璇?
**瑙ｅ喅**: 
- 妫€鏌ョ綉缁滆繛鎺?
- 鎶€鑳戒細鑷姩閲嶈瘯 3 娆?
- 绋嶅悗鎵嬪姩鎵ц `git push`

### Q4: 鏈夊啿绐?
**瑙ｅ喅**:
- 鎶€鑳戒細鍋滄鑷姩娴佺▼
- 鎵嬪姩瑙ｅ喅鍐茬獊
- 鎵ц `git add .; git commit; git push`

## 馃搳 鏃ュ織浣嶇疆

鎵€鏈夎嚜鍔ㄦ帹閫佺殑鏃ュ織閮戒繚瀛樺湪锛?
```
agent/workinglog/auto-push_{yyyyMMdd-HHmmss}.md
```

姣忕瘒鏃ュ織鍖呭惈锛?
- 鎵ц鏃堕棿鍜岃Е鍙戝師鍥?
- Commit hash
- 娑夊強鏂囦欢鍒楄〃
- 鍙樻洿缁熻
- Push 鐘舵€?
- 杩滅▼浠撳簱淇℃伅

## 馃挕 娴嬭瘯鎶€鑳?

淇敼 agent 鐩綍涓嬬殑浠绘剰鏂囦欢锛屼緥濡傦細

```bash
# 淇敼鏌愪釜鏂囦欢
notepad agent\README.md

# 淇濆瓨鍚庯紝鎶€鑳戒細鑷姩瑙﹀彂
# 瑙傚療缁堢杈撳嚭
# 妫€鏌?agent\workinglog\ 鐩綍涓嬫槸鍚︾敓鎴愭柊鏃ュ織
```

## 馃摓 闇€瑕佸府鍔╋紵

鏌ョ湅璇︾粏鎶€鑳芥枃妗ｏ細`.lingma/skills/auto-push-agent/SKILL.md`

---

**鏈€鍚庢洿鏂?*: 2026-03-09 21:30  
**鎶€鑳界増鏈?*: 1.0  
**Git 鐘舵€?*: 鉁?宸插垵濮嬪寲锛屽緟閰嶇疆杩滅▼

