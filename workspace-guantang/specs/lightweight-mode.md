<!-- Last Modified: 2026-03-08 -->
<!-- Last Modified (CN): 2026-03-08 -->

# 浣庨厤鏈嶅姟鍣ㄨ繍琛屾寚鍗?
## 鏈嶅姟鍣ㄩ厤缃?
### 鎮ㄧ殑璧勬簮

```yaml
鏈嶅姟鍣?
  CPU: 2 鏍稿績
  鍐呭瓨锛?GB
  瀛樺偍锛?0GB
  鎿嶄綔绯荤粺锛歀inux (鎺ㄨ崘 Ubuntu 20.04+)

鏈湴寮€鍙戠幆澧?
  CPU: 澶氭牳蹇?(寮哄ぇ)
  鍐呭瓨锛氬厖瓒?  瀛樺偍锛氬厖瓒?```

## 璧勬簮鍒嗛厤寤鸿

### 鏈嶅姟鍣ㄧ锛?GB 鍐呭瓨锛?
```yaml
鍐呭瓨鍒嗛厤:
  鎿嶄綔绯荤粺鍩虹锛?12MB
  鍗氬搴旂敤 (Flask/Django): 768MB
  鏁版嵁搴?(SQLite): 256MB
  Agent 杩愯鏃讹細512MB (涓ユ牸鎺у埗)
  
瀛樺偍绌洪棿:
  鎿嶄綔绯荤粺锛?GB
  鍗氬绋嬪簭锛?GB
  鏁版嵁搴擄細3GB
  鏃ュ織鏂囦欢锛?GB (涓婇檺)
  澶囦唤鏂囦欢锛?GB
  鍙敤绌洪棿锛?0GB
```

### 鏈湴宸ヤ綔鏍堬紙寮哄ぇ璧勬簮锛?
```yaml
涓昏宸ヤ綔浣嶇疆:
  - Agent 寮€鍙戝拰娴嬭瘯
  - 浠ｇ爜缂栧啓鍜岃皟璇?  - 鏃ュ織鐢熸垚鍜屽垵姝ュ鐞?  
鍚屾鍒版湇鍔″櫒:
  - 浠呴儴缃插繀瑕佺殑杩愯鏂囦欢
  - 鏃ュ織瀹氭湡涓婁紶锛堝帇缂╋級
  - 鏁版嵁搴撳畾鏃跺浠?```

## Agent 浼樺寲閰嶇疆

### 4 涓?Agent 鐨勮亴璐ｈ皟鏁?
#### 鐏屾堡 (PM/鍗忚皟鑰?
**宸ヤ綔鍐呭:**
- 闇€姹傜悊瑙ｅ拰浠诲姟鍒嗚В
- 鍗忚皟鍏朵粬 Agent 宸ヤ綔
- 杩涘害璺熻釜鍜屾姤鍛婄敓鎴?- 鍗氬鏃ュ織闆嗘垚

**璧勬簮鍗犵敤:** 浣? 
**杩愯妯″紡:** 闂存瓏鎬ф縺娲伙紙闇€瑕佹椂鍚姩锛?
#### 閰辫倝 (鍚庣寮€鍙?
**宸ヤ綔鍐呭:**
- 鍗氬鍚庣 API 寮€鍙?- 鏁版嵁搴撹璁?- 鐢ㄦ埛璁よ瘉绯荤粺
- 鏂囩珷绠＄悊绯荤粺

**璧勬簮鍗犵敤:** 涓? 
**杩愯妯″紡:** 寮€鍙戞湡娲昏穬锛屽畬鎴愬悗浼戠湢

#### 璞嗘矙 (鍓嶇寮€鍙?
**宸ヤ綔鍐呭:**
- 鍗氬鍓嶇椤甸潰璁捐
- CSS 鏍峰紡缂栧啓
- 鍝嶅簲寮忛€傞厤
- 鐢ㄦ埛浣撻獙浼樺寲

**璧勬簮鍗犵敤:** 涓? 
**杩愯妯″紡:** 寮€鍙戞湡娲昏穬锛屽畬鎴愬悗浼戠湢

#### 閰歌彍 (杩愮淮/娴嬭瘯)
**宸ヤ綔鍐呭:**
- 绠€鍖栦负鍏艰亴杩愮淮
- 绠€鍗曞姛鑳芥祴璇?- 鏈嶅姟鍣ㄧ洃鎺?- 鏃ュ織绠＄悊

**璧勬簮鍗犵敤:** 浣? 
**杩愯妯″紡:** 鎸夐渶婵€娲?
## 杞婚噺绾ц繍琛屾ā寮?
### 鏂囦欢绯荤粺閫氫俊

閬垮厤閲嶉噺绾х殑娑堟伅闃熷垪锛岄噰鐢ㄦ枃浠跺叡浜柟寮忥細

```yaml
閫氫俊鐩綍锛欶:\openclaw\workspace\communication\
  鈹溾攢鈹€ inbox\           # 鎺ユ敹鐨勬秷鎭?  鈹溾攢鈹€ outbox\          # 鍙戦€佺殑娑堟伅
  鈹斺攢鈹€ archive\         # 鍘嗗彶娑堟伅褰掓。

娑堟伅鏂囦欢鏍煎紡 (.json):
{
  "from": "鐏屾堡",
  "to": "閰辫倝",
  "action": "allocateTask",
  "data": {...},
  "timestamp": "2026-03-07T10:30:00Z"
}
```

### 杞鏈哄埗

姣忎釜 Agent 瀹氭湡妫€鏌ヨ嚜宸辩殑鏀朵欢绠憋細

```python
# 浼唬鐮佺ず渚?def check_inbox():
    inbox_path = f"communication/inbox/{agent_name}/"
    messages = os.listdir(inbox_path)
    for msg in messages:
        process_message(msg)
        move_to_archive(msg)
    
    # 姣?5 鍒嗛挓妫€鏌ヤ竴娆?    schedule.every(5).minutes.do(check_inbox)
```

## 鏃ュ織浼樺寲

### 鏈湴鏃ュ織锛堜富瑕侊級

**浣嶇疆:** `F:\openclaw\workspace\logs\`

**绛栫暐:**
- 璇︾粏鏃ュ織淇濆瓨鍦ㄦ湰鍦?- 鎸夋棩鏈熺粍缁囷紝Markdown 鏍煎紡
- 淇濈暀鏈€杩?7 澶╄缁嗘棩蹇?- 鍛ㄦ眹鎬诲拰鏈堝綊妗ｉ暱鏈熶繚瀛?
### 鏈嶅姟鍣ㄦ棩蹇楋紙绮剧畝锛?
**浣嶇疆:** `/var/log/blog/`

**绛栫暐:**
```yaml
鏃ュ織绾у埆锛歐ARNING 浠ヤ笂
淇濈暀鏈燂細30 澶?杞浆锛氭瘡澶╀竴涓枃浠讹紝鏈€澶?10MB
鍘嬬缉锛氳秴杩?7 澶╃殑鏃ュ織鑷姩 gzip 鍘嬬缉
```

## 鏁版嵁搴撲紭鍖?
### 浣跨敤 SQLite

**鍘熷洜:**
- 闆堕厤缃?- 鍗曟枃浠?- 鍐呭瓨鍗犵敤灏?- 閫傚悎涓汉椤圭洰

**閰嶇疆:**
```ini
[database]
engine = sqlite3
name = F:\openclaw\code\blog.db
pool_size = 1  # 涓嶉渶瑕佽繛鎺ユ睜
```

### 琛ㄧ粨鏋勪紭鍖?
```sql
-- 鏂囩珷琛?CREATE TABLE articles (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT,
    category_id INTEGER,
    author_id INTEGER,
    view_count INTEGER DEFAULT 0,
    created_at DATETIME,
    updated_at DATETIME
);

-- 璁块棶闄愬埗锛氬彧淇濈暀蹇呰瀛楁
-- 閬垮厤鍐椾綑鏁版嵁鍗犵敤绌洪棿
```

## 閮ㄧ讲绛栫暐

### 鏈湴寮€鍙戯紝鏈嶅姟鍣ㄩ儴缃?
**宸ヤ綔娴佺▼:**
```
1. 鏈湴寮€鍙?   鈫?2. 鏈湴娴嬭瘯
   鈫?3. Git 鎻愪氦
   鈫?4. 鏈嶅姟鍣ㄦ媺鍙?   鈫?5. 閲嶅惎鏈嶅姟
```

### 鑷姩鍖栬剼鏈?
```bash
#!/bin/bash
# deploy.sh - 涓€閿儴缃茶剼鏈?
echo "寮€濮嬮儴缃?.."

# 1. 鎷夊彇鏈€鏂颁唬鐮?git pull origin main

# 2. 瀹夎渚濊禆
pip install -r requirements.txt

# 3. 鏁版嵁搴撹縼绉?python manage.py migrate

# 4. 鏀堕泦闈欐€佹枃浠?python manage.py collectstatic --noinput

# 5. 閲嶅惎鏈嶅姟
sudo systemctl restart blog.service

echo "閮ㄧ讲瀹屾垚锛?
```

## 鐩戞帶鍜屽憡璀?
### 绠€鍗曠洃鎺?
**鐩戞帶鎸囨爣:**
- CPU 浣跨敤鐜?(>80% 鍛婅)
- 鍐呭瓨浣跨敤鐜?(>90% 鍛婅)
- 纾佺洏绌洪棿 (<5GB 鍛婅)
- 鏈嶅姟鐘舵€?
**瀹炵幇鏂瑰紡:**
```python
# monitor.py - 绠€鍗曠洃鎺ц剼鏈?import psutil

def check_resources():
    cpu = psutil.cpu_percent()
    memory = psutil.virtual_memory().percent
    disk = psutil.disk_usage('/').percent
    
    if cpu > 80:
        send_alert(f"CPU 浣跨敤鐜囪繃楂橈細{cpu}%")
    if memory > 90:
        send_alert(f"鍐呭瓨浣跨敤鐜囪繃楂橈細{memory}%")
    if disk > 90:
        send_alert(f"纾佺洏绌洪棿涓嶈冻锛歿disk}%")
```

### 鍛婅鏂瑰紡

- 閭欢閫氱煡
- 鍗氬鍚庡彴娑堟伅
- 鏈湴鏃ュ織璁板綍

## 鎬ц兘浼樺寲鎶€宸?
### 浠ｇ爜灞傞潰

1. **鎳掑姞杞?*
   ```python
   # 浠呭湪闇€瑕佹椂鍔犺浇澶фā鍧?   def heavy_operation():
       import heavy_module
       return heavy_module.process()
   ```

2. **缂撳瓨**
   ```python
   from functools import lru_cache
   
   @lru_cache(maxsize=128)
   def get_article(article_id):
       # 浠庢暟鎹簱鏌ヨ
       pass
   ```

3. **寮傛澶勭悊**
   ```python
   # 鑰楁椂鎿嶄綔寮傛鎵ц
   async def send_email():
       await asyncio.sleep(1)
   ```

### 鏁版嵁搴撳眰闈?
1. **绱㈠紩浼樺寲**
   ```sql
   CREATE INDEX idx_article_category ON articles(category_id);
   CREATE INDEX idx_article_created ON articles(created_at);
   ```

2. **鏌ヨ浼樺寲**
   ```python
   # 鍙煡璇㈤渶瑕佺殑瀛楁
   Article.objects.values('id', 'title').filter(status='published')
   ```

## 澶囦唤绛栫暐

### 鏈湴澶囦唤

```yaml
棰戠巼锛氭瘡澶╁噷鏅?3:00
鍐呭:
  - 鏁版嵁搴撳畬鏁村浠?  - 涓婁紶鐨勬枃浠?  - 閰嶇疆鏂囦欢
淇濈暀锛氭渶杩?30 娆″浠?```

### 鏈嶅姟鍣ㄥ浠?
```yaml
棰戠巼锛氭瘡鍛ㄦ棩鍑屾櫒 2:00
鍐呭:
  - 鏁版嵁搴撳浠?  - 鏃ュ織褰掓。
淇濈暀锛氭渶杩?4 娆″浠?浣嶇疆锛?backup/
```

## 搴旀€ユ柟妗?
### 鍐呭瓨涓嶈冻澶勭悊

```bash
# 绱ф€ラ噴鏀惧唴瀛樿剼鏈?#!/bin/bash

# 1. 娓呯悊缂撳瓨
sync && echo 3 > /proc/sys/vm/drop_caches

# 2. 鍋滄闈炲叧閿湇鍔?sudo systemctl stop celery  # 濡傛灉鏈夊悗鍙颁换鍔?
# 3. 鍙戦€佸憡璀?send_alert "鍐呭瓨涓嶈冻锛屽凡閲囧彇绱ф€ユ帾鏂?
```

### 纾佺洏绌洪棿涓嶈冻

```bash
# 娓呯悊鑴氭湰
#!/bin/bash

# 1. 鍒犻櫎鏃ф棩蹇?find /var/log/blog/ -name "*.log" -mtime +7 -delete

# 2. 娓呯悊涓存椂鏂囦欢
rm -rf /tmp/*

# 3. 鍘嬬缉澶ф枃浠?find /backup/ -name "*.db" -mtime +30 -exec gzip {} \;
```

