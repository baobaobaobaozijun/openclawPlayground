<!-- Last Modified: 2026-04-10 19:00 -->

# Plan-009: 鍓嶅悗绔仈璋?+ 閮ㄧ讲楠岃瘉

**鍒涘缓鏃堕棿:** 2026-04-10 19:00  
**浼樺厛绾?** P0 (鏈€楂?  
**鐘舵€?** processing  
**鎬昏疆鏁?** 3 杞? 
**鐩爣:** 瀹屾垚鍓嶅悗绔?API 鑱旇皟锛岄獙璇侀儴缃叉祦绋?
---

## 馃搵 璁″垝鐩爣

1. **鍚庣 API 鍙闂?* 鈥?鍚姩 Java 鏈嶅姟锛孉PI 鍙鍓嶇璋冪敤
2. **鍓嶇鑳借幏鍙栨暟鎹?* 鈥?HomeView/ArticleList 鑳芥樉绀虹湡瀹炴暟鎹?3. **鐧诲綍娴佺▼鎵撻€?* 鈥?LoginView 鈫?Auth API 鈫?Token 瀛樺偍
4. **閮ㄧ讲鑴氭湰楠岃瘉** 鈥?鑳藉湪鏈嶅姟鍣?鏈湴 Docker 閮ㄧ讲

---

## 馃幆 绗?1 杞换鍔?(19:00 娲惧彂)

### 馃崠 閰辫倝 (鍚庣)
**浠诲姟:** 鍚姩鍚庣鏈嶅姟 + 楠岃瘉 API 鍙闂?**浜や粯鐗?**
1. `F:\openclaw\code\backend\target\baozipu-backend.jar` (缂栬瘧浜х墿)
2. `F:\openclaw\agent\workspace-jiangrou\logs\api-verify.md` (API 楠岃瘉鏃ュ織)

**楠屾敹鏍囧噯:**
- [ ] mvn compile 閫氳繃
- [ ] Java 杩涚▼鐩戝惉 8081 绔彛
- [ ] GET /api/articles 杩斿洖 200
- [ ] Swagger UI 鍙闂?
**绂佹:**
- 涓嶈淇敼鐜版湁浠ｇ爜锛堜粎鍚姩楠岃瘉锛?- 涓嶈绛夊緟鍓嶇瀹屾垚

---

### 馃崱 璞嗘矙 (鍓嶇)
**浠诲姟:** 閰嶇疆 API  baseURL + 楠岃瘉 HomeView 鏁版嵁鑾峰彇
**浜や粯鐗?**
1. `F:\openclaw\code\frontend\src\utils\request.ts` (API 璇锋眰閰嶇疆)
2. `F:\openclaw\agent\workspace-dousha\logs\frontend-api-test.md` (鑱旇皟鏃ュ織)

**楠屾敹鏍囧噯:**
- [ ] baseURL 閰嶇疆涓?`http://localhost:8081`
- [ ] HomeView 鑳借皟鐢?/api/articles
- [ ] 鎺у埗鍙版棤 CORS 閿欒
- [ ] 椤甸潰鏄剧ず鏂囩珷鍒楄〃锛堟垨 mock 鏁版嵁锛?
**绂佹:**
- 涓嶈淇敼鍚庣浠ｇ爜
- 涓嶈绛夊緟鍚庣瀹屾垚锛堝厛鐢?mock 鏁版嵁锛?
---

### 馃ガ 閰歌彍 (杩愮淮)
**浠诲姟:** 楠岃瘉閮ㄧ讲鑴氭湰 + 鍑嗗閮ㄧ讲鏂囨。
**浜や粯鐗?**
1. `F:\openclaw\agent\workspace-suancai\deploy\deploy-checklist.md` (閮ㄧ讲妫€鏌ユ竻鍗?
2. `F:\openclaw\agent\workspace-suancai\logs\deploy-verify.md` (楠岃瘉鏃ュ織)

**楠屾敹鏍囧噯:**
- [ ] docker-compose.yml 璇硶姝ｇ‘
- [ ] 鏈嶅姟鍣?SSH 鍙繛鎺?- [ ] 閮ㄧ讲鐩綍 /opt/baozipu/ 瀛樺湪
- [ ] 澶囦唤鑴氭湰鍙墽琛?
**绂佹:**
- 涓嶈鎵ц瀹為檯閮ㄧ讲锛堜粎楠岃瘉锛?- 涓嶈淇敼 Docker 閰嶇疆

---

## 馃搮 棰勮鏃堕棿绾?
| 杞 | 寮€濮嬫椂闂?| 棰勮瀹屾垚 | 璐熻矗浜?|
|------|---------|---------|-------|
| Round 1 | 19:00 | 19:30 | 鍏ㄥ憳 |
| Round 2 | 19:30 | 20:00 | 鍏ㄥ憳 |
| Round 3 | 20:00 | 20:30 | 鍏ㄥ憳 |

---

## 馃摑 鎵ц璁板綍

### Round 1 (19:00 娲惧彂) 鉁?宸叉淳鍙?- [ ] 閰辫倝锛氬悗绔湇鍔″惎鍔?+ API 楠岃瘉 (浼氳瘽锛?7c95a3e)
- [ ] 璞嗘矙锛氬墠绔?API 閰嶇疆 + HomeView 鑱旇皟 (浼氳瘽锛?3cd04f3)
- [ ] 閰歌彍锛氶儴缃茶剼鏈獙璇?+ 妫€鏌ユ竻鍗?(浼氳瘽锛?0acbc7b)

**娲惧彂鏃堕棿:** 19:00  
**棰勮瀹屾垚:** 19:30  
**鏁版嵁搴?** pipeline_agent_tasks 宸叉彃鍏?3 鏉¤褰?
### Round 2 (寰呮淳鍙?
- [ ] 寰呭垎閰?
### Round 3 (寰呮淳鍙?
- [ ] 寰呭垎閰?
---

## 馃敆 鐩稿叧鏂囨。

- [绯荤粺鏋舵瀯](../../specs/01-architecture/system-architecture.md)
- [API 鏂囨。](../../specs/02-business-specs/blog-system-requirements.md)
- [閮ㄧ讲鏂规](../../specs/03-technical-specs/deployment-plan.md)

---

*鍒涘缓浜猴細鐏屾堡 (PM) 馃嵅*

