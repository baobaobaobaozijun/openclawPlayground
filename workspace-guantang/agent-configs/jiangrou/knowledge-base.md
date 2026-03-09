<!-- Last Modified: 2026-03-08 -->
<!-- Last Modified (CN): 2026-03-08 -->

# 閰辫倝 (鍚庣) - 瀹屾暣鐭ヨ瘑搴?
## 馃摎 鐭ヨ瘑搴撶洰褰?
- [韬唤璁ょ煡](./IDENTITY.md)
- [鑱岃矗瑙勮寖](./ROLE.md)
- [琛屼负鍑嗗垯](./SOUL.md)
- [鍚庣寮€鍙戞渶浣冲疄璺礭(./backend-best-practices.md)
- [API 璁捐瑙勮寖](./api-design-guidelines.md)
- [鏁版嵁搴撹璁″師鍒橾(./database-design-principles.md)
- [鎶€鏈爤閫夊瀷鎸囧崡](./tech-stack-selection.md)
- [甯歌闂涓庤В鍐虫柟妗圿(./common-issues-solutions.md)

---

## 馃敡 鍚庣寮€鍙戞渶浣冲疄璺?
### 1. RESTful API 璁捐瑙勮寖

#### URL 鍛藉悕瑙勮寖
```
GET    /api/articles          # 鑾峰彇鏂囩珷鍒楄〃
POST   /api/articles          # 鍒涘缓鏂囩珷
GET    /api/articles/{id}     # 鑾峰彇鍗曠瘒鏂囩珷
PUT    /api/articles/{id}     # 鏇存柊鏂囩珷
DELETE /api/articles/{id}     # 鍒犻櫎鏂囩珷
```

#### 鍝嶅簲鏍煎紡鏍囧噯
```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "鏂囩珷鏍囬",
    "content": "鏂囩珷鍐呭"
  },
  "message": "鎿嶄綔鎴愬姛",
  "timestamp": "2026-03-08T10:00:00Z"
}
```

#### 閿欒澶勭悊
```json
{
  "success": false,
  "error": {
    "code": "ARTICLE_NOT_FOUND",
    "message": "鏂囩珷涓嶅瓨鍦?,
    "details": "璇锋眰鐨勬枃绔?ID 涓?1锛屼絾鏈壘鍒板搴旇褰?
  },
  "timestamp": "2026-03-08T10:00:00Z"
}
```

### 2. 鏁版嵁搴撹璁″師鍒?
#### 琛ㄥ懡鍚嶈鑼?- 鉁?浣跨敤澶嶆暟鍚嶈瘝锛歚articles`, `users`, `comments`
- 鉁?缁熶竴灏忓啓锛屼笅鍒掔嚎鍒嗛殧锛歚user_profiles`
- 鉂?閬垮厤鍗曟暟锛歚article`, `user`
- 鉂?閬垮厤椹煎嘲锛歚UserProfiles`

#### 瀛楁璁捐
```sql
-- 鏍囧噯瀛楁
CREATE TABLE articles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    status ENUM('draft', 'published', 'archived') DEFAULT 'draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
);
```

### 3. 鎬ц兘浼樺寲寤鸿

#### 鏁版嵁搴撴煡璇紭鍖?- 浣跨敤绱㈠紩瑕嗙洊甯哥敤鏌ヨ
- 閬垮厤 N+1 鏌ヨ闂
- 鍚堢悊浣跨敤缂撳瓨锛圧edis锛?- 鍒嗛〉鏌ヨ闄愬埗杩斿洖鏁伴噺

#### 浠ｇ爜灞傞潰浼樺寲
```python
# 鉂?鎱㈡煡璇?- N+1 闂
articles = Article.query.all()
for article in articles:
    author = User.query.get(article.author_id)  # 姣忔閮芥煡璇㈡暟鎹簱

# 鉁?浣跨敤 JOIN 棰勫姞杞?articles = Article.query.options(joinedload(Article.author)).all()
```

### 4. 瀹夊叏鏈€浣冲疄璺?
#### SQL 娉ㄥ叆闃叉姢
```python
# 鉂?鍗遍櫓鍐欐硶
query = f"SELECT * FROM users WHERE username = '{username}'"

# 鉁?鍙傛暟鍖栨煡璇?query = "SELECT * FROM users WHERE username = %s"
cursor.execute(query, (username,))
```

#### 璁よ瘉涓庢巿鏉?- 浣跨敤 JWT 杩涜鏃犵姸鎬佽璇?- 瀵嗙爜蹇呴』鍔犵洂鍝堝笇瀛樺偍锛坆crypt/argon2锛?- 瀹炵幇鍩轰簬瑙掕壊鐨勮闂帶鍒讹紙RBAC锛?- API 闄愭祦闃叉鏆村姏鏀诲嚮

### 5. 鏃ュ織涓庣洃鎺?
#### 鏃ュ織绾у埆浣跨敤
```python
import logging

logging.debug("璋冭瘯淇℃伅 - 璇︾粏鐨勬妧鏈粏鑺?)
logging.info("淇℃伅 - 姝ｅ父鐨勮繍琛屾棩蹇?)
logging.warning("璀﹀憡 - 鍙兘鏈夐棶棰樹絾涓嶅奖鍝嶈繍琛?)
logging.error("閿欒 - 鏌愪釜鎿嶄綔澶辫触")
logging.critical("涓ラ噸閿欒 - 绯荤粺鍙兘鏃犳硶缁х画杩愯")
```

#### 鍏抽敭鎸囨爣鐩戞帶
- API 鍝嶅簲鏃堕棿锛圥95, P99锛?- 鏁版嵁搴撴煡璇㈣€楁椂
- 缂撳瓨鍛戒腑鐜?- 閿欒鐜囩粺璁?- QPS锛堟瘡绉掓煡璇㈡暟锛?
---

## 馃洜锔?鎶€鏈爤閫夊瀷鎸囧崡

### 鎺ㄨ崘鎶€鏈爤

#### Web 妗嗘灦
- **FastAPI** (棣栭€? - 鐜颁唬銆侀珮鎬ц兘銆佽嚜鍔ㄦ枃妗?- Flask - 杞婚噺绾с€佺伒娲?- Django - 鍏ㄥ姛鑳姐€佹垚鐔熺敓鎬?
#### 鏁版嵁搴?- **MySQL 8.0** - 鍏崇郴鍨嬫暟鎹簱
- PostgreSQL - 楂樼骇鐗规€ф敮鎸?- Redis - 缂撳瓨鍜屼細璇濆瓨鍌?
#### ORM
- **SQLAlchemy** - Python 鏈€寮哄ぇ鐨?ORM
- Peewee - 杞婚噺绾?ORM

#### 璁よ瘉
- **PyJWT** - JWT 瀹炵幇
- python-jose - JWS/JWE 鏀寔

#### 娴嬭瘯
- **pytest** - 鐜颁唬鍖栨祴璇曟鏋?- pytest-cov - 瑕嗙洊鐜囩粺璁?- httpx - API 娴嬭瘯瀹㈡埛绔?
---

## 鈿狅笍 甯歌閿欒涓庤В鍐虫柟妗?
### 閿欒 1: 鏁版嵁搴撹繛鎺ユ睜鑰楀敖

**鐜拌薄:**
```
sqlalchemy.exc.TimeoutError: QueuePool limit of size X overflow Y reached
```

**瑙ｅ喅鏂规:**
```python
# 璋冩暣杩炴帴姹犲ぇ灏?engine = create_engine(
    DATABASE_URL,
    pool_size=20,        # 澧炲姞杩炴帴鏁?    max_overflow=40,     # 澧炲姞婧㈠嚭閲?    pool_recycle=3600    # 瀹氭湡鍥炴敹杩炴帴
)
```

### 閿欒 2: API 鍝嶅簲杩囨參

**鎺掓煡姝ラ:**
1. 妫€鏌ユ參鏌ヨ鏃ュ織
2. 鍒嗘瀽鎵ц璁″垝锛圗XPLAIN锛?3. 娣诲姞缂哄け鐨勭储寮?4. 鑰冭檻缂撳瓨鐑偣鏁版嵁

**瑙ｅ喅鏂规:**
```python
from functools import lru_cache
from datetime import timedelta

@lru_cache(maxsize=128)
def get_article_by_id(article_id: int):
    return Article.query.get(article_id)

# 鎴栦娇鐢?Redis 缂撳瓨
@cache.cached(timeout=timedelta(minutes=10))
def get_popular_articles():
    return Article.query.filter_by(status='published').limit(10).all()
```

### 閿欒 3: 鍐呭瓨娉勬紡

**甯歌鍘熷洜:**
- 寰幆寮曠敤鏈噴鏀?- 澶ч噺鏁版嵁涓€娆℃€у姞杞?- 鍏ㄥ眬鍙橀噺绱Н

**瑙ｅ喅鏂规:**
```python
# 鉂?鍐呭瓨鍗犵敤澶?all_data = list(large_queryset)

# 鉁?浣跨敤鐢熸垚鍣?def iter_queryset(queryset, chunk_size=100):
    for i in range(0, queryset.count(), chunk_size):
        yield from queryset[i:i+chunk_size]
```

---

## 馃摉 瀛︿範璧勬簮

### 瀹樻柟鏂囨。
- [FastAPI 瀹樻柟鏂囨。](https://fastapi.tiangolo.com/)
- [SQLAlchemy 鏂囨。](https://docs.sqlalchemy.org/)
- [MySQL 8.0 鍙傝€冩墜鍐宂(https://dev.mysql.com/doc/refman/8.0/en/)

### 鏈€浣冲疄璺?- [RESTful API 璁捐鎸囧崡](https://restfulapi.net/)
- [12-Factor App](https://12factor.net/zh_cn/)
- [Python 缂栫爜瑙勮寖](https://pep8.org/)

---

*鏈€鍚庢洿鏂帮細2026-03-08*  
*缁存姢鑰咃細閰辫倝Agent*

