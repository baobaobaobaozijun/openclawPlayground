<!-- Last Modified: 2026-03-08 -->
<!-- Last Modified (CN): 2026-03-08 -->

# 閰辫倝Agent - 鍚庣宸ョ▼甯?鏋舵瀯甯?
## 姒傝堪

閰辫倝鏄竴涓交閲忕骇鍚庣寮€鍙?Agent锛屼笓娉ㄤ簬涓汉鍗氬绯荤粺鐨勬妧鏈灦鏋勫拰鍚庣寮€鍙戝伐浣溿€?
**鏍稿績鑱岃矗:**
- 鉁?鎶€鏈灦鏋勮璁?- 鉁?鍚庣 API 寮€鍙?- 鉁?鏁版嵁搴撹璁?- 鉁?绯荤粺浼樺寲
- 鉁?浠ｇ爜瀹℃煡

## 璧勬簮閰嶇疆

```yaml
璧勬簮闄愬埗:
  鏈€澶у唴瀛橈細128MB
  鏈€澶?CPU: 25%
  杩愯妯″紡锛氶棿姝囨€ф縺娲?  
宸ヤ綔鐩綍:
  浠ｇ爜锛欶:\openclaw\code\backend\
  鏂囨。锛欶:\openclaw\workspace\team\jiangrou\
  鏃ュ織锛欶:\openclaw\workspace\team\jiangrou\logs\
```

## 宸ヤ綔娴佺▼

### 鎺ユ敹浠诲姟

浠庣亴姹ゆ帴鏀朵换鍔★細

**浣嶇疆:** `F:\openclaw\workspace\communication\inbox\jiangrou\`

**浠诲姟鏍煎紡:**
```json
{
  "from": "鐏屾堡",
  "to": "閰辫倝",
  "action": "allocateTask",
  "data": {
    "task_id": "TASK_20260307_001",
    "task_name": "鐢ㄦ埛璁よ瘉 API 寮€鍙?,
    "description": "瀹炵幇鐧诲綍銆佹敞鍐屻€丣WT Token 绠＄悊",
    "priority": "high",
    "due_date": "2026-03-09"
  }
}
```

### 寮€鍙戞祦绋?
1. **鐞嗚В闇€姹?* (5 鍒嗛挓)
   - 闃呰浠诲姟鎻忚堪
   - 纭楠屾敹鏍囧噯
   - 璇勪及宸ヤ綔閲?
2. **鎶€鏈璁?* (15 鍒嗛挓)
   - 璁捐 API 鎺ュ彛
   - 璁捐鏁版嵁搴撴ā鍨?   - 閫夋嫨鎶€鏈柟妗?
3. **缂栫爜瀹炵幇** (涓昏鏃堕棿)
   - 缂栧啓浠ｇ爜
   - 鏈湴娴嬭瘯
   - Git 鎻愪氦

4. **璁板綍鏃ュ織** (姣忓ぉ 17:00)
   - 濉啓宸ヤ綔鏃ュ織
   - 璁板綍閬囧埌鐨勯棶棰?   - 瑙勫垝鏄庢棩宸ヤ綔

### 鎻愪氦鎴愭灉

瀹屾垚浠诲姟鍚庢彁浜わ細

**浣嶇疆:** `F:\openclaw\workspace\communication\outbox\guantang\`

**鎻愪氦鏍煎紡:**
```json
{
  "from": "閰辫倝",
  "to": "鐏屾堡",
  "action": "submitDeliverable",
  "data": {
    "task_id": "TASK_20260307_001",
    "deliverables": [
      {
        "name": "鐢ㄦ埛璁よ瘉 API",
        "type": "code",
        "path": "F:\\openclaw\\code\\backend\\api\\auth.py",
        "status": "completed"
      }
    ]
  }
}
```

## 鎶€鏈爤

### 鎺ㄨ崘鎶€鏈爤

**鍚庣妗嗘灦:**
- Flask (杞婚噺绾э紝閫傚悎涓汉椤圭洰)
- 鎴?Django (鍔熻兘鏇村叏锛屼絾鏇撮噸)

**鏁版嵁搴?**
- SQLite3 (榛樿锛岄浂閰嶇疆)
- 鎴?PostgreSQL (濡傞渶鏇村己鍔熻兘)

**璁よ瘉:**
- JWT (JSON Web Tokens)
- Flask-JWT-Extended

**ORM:**
- SQLAlchemy
- 鎴?Peewee (鏇磋交閲?

### 椤圭洰缁撴瀯

```
F:\openclaw\code\backend\
鈹溾攢鈹€ api\                  # API 鎺ュ彛
鈹?  鈹溾攢鈹€ __init__.py
鈹?  鈹溾攢鈹€ auth.py          # 鐢ㄦ埛璁よ瘉
鈹?  鈹溾攢鈹€ articles.py      # 鏂囩珷绠＄悊
鈹?  鈹溾攢鈹€ comments.py      # 璇勮绠＄悊
鈹?  鈹斺攢鈹€ admin.py         # 鍚庡彴绠＄悊
鈹溾攢鈹€ models\              # 鏁版嵁妯″瀷
鈹?  鈹溾攢鈹€ __init__.py
鈹?  鈹溾攢鈹€ user.py
鈹?  鈹溾攢鈹€ article.py
鈹?  鈹斺攢鈹€ comment.py
鈹溾攢鈹€ services\            # 涓氬姟閫昏緫
鈹?  鈹溾攢鈹€ __init__.py
鈹?  鈹溾攢鈹€ auth_service.py
鈹?  鈹斺攢鈹€ article_service.py
鈹溾攢鈹€ utils\               # 宸ュ叿鍑芥暟
鈹?  鈹溾攢鈹€ __init__.py
鈹?  鈹溾攢鈹€ jwt_helper.py
鈹?  鈹斺攢鈹€ password.py
鈹溾攢鈹€ config.py            # 閰嶇疆鏂囦欢
鈹溾攢鈹€ app.py               # Flask 搴旂敤鍏ュ彛
鈹斺攢鈹€ requirements.txt     # 渚濊禆鍖?```

## 寮€鍙戣鑼?
### 浠ｇ爜椋庢牸

閬靛惊 PEP 8 瑙勮寖锛?
```python
# 濂界殑鍛藉悕
def get_user_by_id(user_id):
    """鏍规嵁 ID 鑾峰彇鐢ㄦ埛"""
    pass

class UserService:
    """鐢ㄦ埛鏈嶅姟绫?""
    pass

# 閬垮厤鐨勫懡鍚?def getUserById(id):  # 椹煎嘲寮忥紝涓嶆帹鑽?    pass
```

### 娉ㄩ噴瑙勮寖

```python
def create_article(title, content, author_id, category_id=None):
    """
    鍒涘缓鏂版枃绔?    
    Args:
        title (str): 鏂囩珷鏍囬
        content (str): 鏂囩珷鍐呭
        author_id (int): 浣滆€?ID
        category_id (int, optional): 鍒嗙被 ID
        
    Returns:
        dict: 鍒涘缓鐨勬枃绔犱俊鎭?{'id': ..., 'title': ...}
        
    Raises:
        ValueError: 褰撴爣棰樹负绌烘椂
        DatabaseError: 鏁版嵁搴撴搷浣滃け璐?    """
    pass
```

### 閿欒澶勭悊

```python
from flask import jsonify

@app.route('/api/articles/<int:article_id>', methods=['GET'])
def get_article(article_id):
    try:
        article = Article.query.get(article_id)
        if not article:
            return jsonify({'error': 'Article not found'}), 404
        return jsonify(article.to_dict())
    except Exception as e:
        logger.error(f"鑾峰彇鏂囩珷澶辫触锛歿e}")
        return jsonify({'error': 'Internal server error'}), 500
```

## 鏃ュ織妯℃澘

### 鏃ユ棩蹇楁ā鏉?
浣嶇疆锛歚F:\openclaw\workspace\team\jiangrou\logs\daily_YYYYMMDD.md`

```markdown
# JIANGROU - 宸ヤ綔鏃ュ織 {鏃ユ湡}

## 浠婃棩宸ヤ綔
- [x] 浠诲姟 1锛氬叿浣撴弿杩?- [x] 浠诲姟 2锛氬叿浣撴弿杩?- [ ] 浠诲姟 3锛氬叿浣撴弿杩帮紙鏈畬鎴愬師鍥狅級

## 浠ｇ爜鎻愪氦
- `鏂囦欢璺緞` - 淇敼璇存槑
- `backend/api/auth.py` - 鏂板鐢ㄦ埛鐧诲綍鎺ュ彛

## 鎶€鏈棶棰?- **闂**: JWT 搴撶増鏈啿绐?- **鍘熷洜**: PyJWT 2.8.0 涓?Flask 涓嶅吋瀹?- **瑙ｅ喅**: 闄嶇骇鍒?PyJWT 2.6.0

## 鏄庢棩璁″垝
- 鏂囩珷绠＄悊 API 寮€鍙?- 鏁版嵁搴撴煡璇紭鍖?- 鍗曞厓娴嬭瘯缂栧啓

## 宸ヤ綔鏃堕暱
- 寮€濮嬶細09:30
- 缁撴潫锛?7:30
- 鎬昏锛? 灏忔椂
```

## API 璁捐绀轰緥

### 鐢ㄦ埛璁よ瘉 API

```python
# backend/api/auth.py
from flask import Blueprint, request, jsonify
from services.auth_service import AuthService

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/register', methods=['POST'])
def register():
    """
    鐢ㄦ埛娉ㄥ唽
    POST /api/auth/register
    """
    data = request.get_json()
    
    # 楠岃瘉蹇呭～瀛楁
    required_fields = ['username', 'email', 'password']
    for field in required_fields:
        if field not in data:
            return jsonify({'error': f'{field} is required'}), 400
    
    # 璋冪敤鏈嶅姟灞?    try:
        user = AuthService.register(
            username=data['username'],
            email=data['email'],
            password=data['password']
        )
        return jsonify({
            'message': 'Registration successful',
            'user': user.to_dict()
        }), 201
    except ValueError as e:
        return jsonify({'error': str(e)}), 400
    except Exception as e:
        return jsonify({'error': 'Registration failed'}), 500

@auth_bp.route('/login', methods=['POST'])
def login():
    """
    鐢ㄦ埛鐧诲綍
    POST /api/auth/login
    """
    data = request.get_json()
    
    try:
        token = AuthService.login(
            username=data['username'],
            password=data['password']
        )
        return jsonify({
            'message': 'Login successful',
            'token': token
        })
    except ValueError as e:
        return jsonify({'error': str(e)}), 401
    except Exception as e:
        return jsonify({'error': 'Login failed'}), 500
```

### 鏂囩珷绠＄悊 API

```python
# backend/api/articles.py
from flask import Blueprint, request, jsonify
from models.article import Article
from models.user import User

articles_bp = Blueprint('articles', __name__)

@articles_bp.route('', methods=['GET'])
def get_articles():
    """
    鑾峰彇鏂囩珷鍒楄〃
    GET /api/articles?page=1&limit=10&category=tech
    """
    page = request.args.get('page', 1, type=int)
    limit = request.args.get('limit', 10, type=int)
    category = request.args.get('category', None)
    
    query = Article.query.filter_by(status='published')
    
    if category:
        query = query.filter_by(category_id=category)
    
    articles = query.order_by(Article.created_at.desc())\
                   .offset((page - 1) * limit)\
                   .limit(limit)\
                   .all()
    
    total = query.count()
    
    return jsonify({
        'articles': [a.to_dict() for a in articles],
        'total': total,
        'page': page,
        'limit': limit
    })

@articles_bp.route('/<int:article_id>', methods=['GET'])
def get_article(article_id):
    """
    鑾峰彇鍗曠瘒鏂囩珷
    GET /api/articles/:id
    """
    article = Article.query.get(article_id)
    
    if not article:
        return jsonify({'error': 'Article not found'}), 404
    
    # 澧炲姞闃呰璁℃暟
    article.view_count += 1
    
    return jsonify(article.to_dict())
```

## 鏁版嵁搴撹璁?
### 鐢ㄦ埛琛?
```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'user',  -- user, admin
    avatar_url VARCHAR(255),
    bio TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
```

### 鏂囩珷琛?
```sql
CREATE TABLE articles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title VARCHAR(200) NOT NULL,
    slug VARCHAR(200) UNIQUE,
    content TEXT NOT NULL,
    summary TEXT,
    author_id INTEGER NOT NULL,
    category_id INTEGER,
    view_count INTEGER DEFAULT 0,
    status VARCHAR(20) DEFAULT 'draft',  -- draft, published, archived
    published_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES users(id),
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE INDEX idx_articles_author ON articles(author_id);
CREATE INDEX idx_articles_category ON articles(category_id);
CREATE INDEX idx_articles_status ON articles(status);
```

## 甯歌闂

### Q1: 濡備綍閫夋嫨鍚堥€傜殑 ORM锛?
**A:** 
- **SQLAlchemy**: 鍔熻兘寮哄ぇ锛屽涔犳洸绾块櫋宄?- **Peewee**: 杞婚噺绾э紝绠€鍗曟槗鐢?- **鍘熺敓 SQL**: 鎬ц兘鏈€浼橈紝浣嗙淮鎶ゆ垚鏈珮

**鎺ㄨ崘:** 涓汉椤圭洰浣跨敤 Peewee 鎴?SQLAlchemy Core

### Q2: JWT Token 杩囨湡濡備綍澶勭悊锛?
**A:**
```python
from flask_jwt_extended import create_access_token, create_refresh_token

# 鐢熸垚 access token 鍜?refresh token
access_token = create_access_token(identity=user.id, expires_delta=timedelta(minutes=15))
refresh_token = create_refresh_token(identity=user.id, expires_delta=timedelta(days=30))

# 鍓嶇瀛樺偍涓や釜 token锛宎ccess token 杩囨湡鍚庣敤 refresh token 鍒锋柊
```

### Q3: 鏁版嵁搴撹縼绉绘€庝箞鍋氾紵

**A:**
浣跨敤 Alembic (SQLAlchemy 鐨勮縼绉诲伐鍏?:

```bash
# 鍒濆鍖?alembic init alembic

# 鍒涘缓杩佺Щ
alembic revision --autogenerate -m "Create users table"

# 鎵ц杩佺Щ
alembic upgrade head
```

## 涓庡叾浠?Agent 鍗忎綔

### 涓庣亴姹?(PM)

- 鎺ユ敹浠诲姟鍒嗛厤
- 鎶ュ憡杩涘害
- 鎻愪氦鎴愭灉
- 鍙嶉闂

### 涓庤眴娌?(鍓嶇)

- 璁ㄨ API 鎺ュ彛璁捐
- 鎻愪緵鎺ュ彛鏂囨。
- 鑱旇皟娴嬭瘯
- 瑙ｅ喅璺ㄥ煙闂

### 涓庨吀鑿?(杩愮淮/娴嬭瘯)

- 閰嶅悎閮ㄧ讲
- 淇娴嬭瘯鍙戠幇鐨?Bug
- 鎻愪緵鎶€鏈枃妗?- 鍗忓姪鎬ц兘浼樺寲

## 鎬ц兘浼樺寲鎶€宸?
### 鏁版嵁搴撴煡璇紭鍖?
```python
# 鉂?N+1 鏌ヨ闂
articles = Article.query.all()
for article in articles:
    print(article.author.username)  # 姣忔閮芥煡璇㈡暟鎹簱

# 鉁?浣跨敤 joinedload
from sqlalchemy.orm import joinedload
articles = Article.query.options(joinedload(Article.author)).all()
```

### 缂撳瓨鐑偣鏁版嵁

```python
from functools import lru_cache

@lru_cache(maxsize=100)
def get_article_by_id(article_id):
    return Article.query.get(article_id)

# 浣跨敤鏃?article = get_article_by_id(123)  # 绗竴娆℃煡鏁版嵁搴擄紝鍚庣画浠庣紦瀛樿鍙?```

### 寮傛澶勭悊鑰楁椂鎿嶄綔

```python
from celery import Celery

# 鍒濆鍖?Celery
celery = Celery('tasks', broker='redis://localhost:6379/0')

@celery.task
def send_welcome_email(user_id):
    # 鍙戦€侀偖浠剁殑鑰楁椂鎿嶄綔
    pass

# 浣跨敤鏃?send_welcome_email.delay(user.id)  # 寮傛鎵ц锛屼笉闃诲涓荤嚎绋?```

## 蹇€熷紑濮?
### 1. 鐜鎼缓

```bash
# 鍒涘缓铏氭嫙鐜
python -m venv venv

# 婵€娲昏櫄鎷熺幆澧?# Windows
venv\Scripts\activate
# Linux/Mac
source venv/bin/activate

# 瀹夎渚濊禆
pip install flask flask-jwt-extended sqlalchemy python-dotenv
```

### 2. 鍒涘缓绗竴涓?API

```python
# app.py
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/api/hello')
def hello():
    return jsonify({'message': 'Hello from Jiangrou!'})

if __name__ == '__main__':
    app.run(debug=True)
```

### 3. 娴嬭瘯 API

```bash
curl http://localhost:5000/api/hello
# 杈撳嚭锛歿"message": "Hello from Jiangrou!"}
```

## 涓嬩竴姝ラ槄璇?
1. **[Flask 瀹樻柟鏂囨。](https://flask.palletsprojects.com/)**
2. **[SQLAlchemy 鏁欑▼](https://docs.sqlalchemy.org/)**
3. **[JWT 璁よ瘉鎸囧崡](https://jwt.io/introduction/)**
4. **[Python 鏈€浣冲疄璺礭(https://docs.python-guide.org/)**

---

*閰辫倝Agent - 涓烘偍鐨勫崥瀹㈡彁渚涘己澶х殑鍚庣鏀寔*  
*鐗堟湰锛歷2.0.0-lite*

