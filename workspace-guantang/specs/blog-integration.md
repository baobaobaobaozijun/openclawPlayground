<!-- Last Modified: 2026-03-08 -->
<!-- Last Modified (CN): 2026-03-08 -->

# 鍗氬绯荤粺闆嗘垚

## 姒傝堪

灏?Agent 宸ヤ綔鏃ュ織鑷姩鎻愪氦鍒颁釜浜哄崥瀹㈢郴缁燂紝瀹炵幇寮€鍙戣繃绋嬬殑閫忔槑鍖栧拰璁板綍銆?
## 闆嗘垚鏋舵瀯

```
Agent 宸ヤ綔 鈫?鏈湴鏃ュ織 鈫?鏍煎紡杞崲 鈫?鍗氬 API 鈫?鍙戝竷鏂囩珷
                                    鈫?                              鍗氬缃戠珯灞曠ず
```

## 闃舵鍒掑垎

### 闃舵 1: 鍗氬鎼缓鍓?
**鏃堕棿:** 椤圭洰寮€濮?~ 鏂囩珷妯″潡瀹屾垚

**宸ヤ綔鍐呭:**
- 鎵€鏈?Agent 鍦ㄦ湰鍦拌褰曞伐浣滄棩蹇?- 鏃ュ織鏍煎紡缁熶竴涓?Markdown
- 瀛樺偍鍦ㄦ寚瀹氱洰褰?
**鏃ュ織浣嶇疆:**
```
F:\openclaw\workspace\team\
鈹溾攢鈹€ guantang\logs\daily_YYYYMMDD.md
鈹溾攢鈹€ jiangrou\logs\daily_YYYYMMDD.md
鈹溾攢鈹€ dousha\logs\daily_YYYYMMDD.md
鈹斺攢鈹€ suancai\logs\daily_YYYYMMDD.md
```

**鏃ュ織妯℃澘:**

```markdown
# {Agent 鍚嶇О} - 宸ヤ綔鏃ュ織 {鏃ユ湡}

## 浠婃棩宸ヤ綔
- [x] 浠诲姟 1锛氬叿浣撴弿杩?- [x] 浠诲姟 2锛氬叿浣撴弿杩?- [ ] 浠诲姟 3锛氬叿浣撴弿杩帮紙鏈畬鎴愬師鍥狅級

## 浠ｇ爜鎻愪氦
- `鏂囦欢璺緞` - 淇敼璇存槑

## 閬囧埌鐨勯棶棰?- 闂鎻忚堪锛堝鏈夛級
- 瑙ｅ喅鏂规/闇€瑕佸府鍔?
## 鏄庢棩璁″垝
- 璁″垝浠诲姟 1
- 璁″垝浠诲姟 2

## 宸ヤ綔鏃堕暱
- 寮€濮嬫椂闂达細09:00
- 缁撴潫鏃堕棿锛?7:00
- 鎬昏锛? 灏忔椂
```

### 闃舵 2: 鏂囩珷妯″潡瀹屾垚鍚?
**瑙﹀彂鏉′欢:** 鍗氬鏂囩珷绠＄悊鍔熻兘涓婄嚎

**鑷姩鍖栨祦绋?**

#### 1. 鏃ュ織鎻愬彇鍜屾牸寮忓寲

```python
# blog_integration.py
import json
from datetime import datetime

class BlogIntegration:
    def __init__(self):
        self.blog_api = "http://yourblog.com/api"
        self.log_dir = "F:\\openclaw\\workspace\\team"
    
    def extract_daily_log(self, date, agent_name):
        """璇诲彇骞惰В鏋?Agent 鐨勬棩鏃ュ織"""
        log_path = f"{self.log_dir}/{agent_name}/logs/daily_{date}.md"
        
        with open(log_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        return self.parse_log(content, agent_name, date)
    
    def parse_log(self, content, agent_name, date):
        """瑙ｆ瀽鏃ュ織鍐呭锛岃浆鎹负鍗氬鏂囩珷鏍煎紡"""
        # 鎻愬彇鍏抽敭淇℃伅
        tasks_completed = self.extract_tasks(content, status='completed')
        issues = self.extract_issues(content)
        code_commits = self.extract_commits(content)
        
        # 鏍煎紡鍖栦负鍗氬鏂囩珷
        blog_post = {
            "title": f"椤圭洰寮€鍙戞棩蹇?- {agent_name} - {date}",
            "content": self.format_content(tasks_completed, issues, code_commits),
            "category": "寮€鍙戞棩蹇?,
            "tags": ["鏃ュ父", agent_name, date],
            "status": "draft"  # 鎴?published
        }
        
        return blog_post
    
    def format_content(self, tasks, issues, commits):
        """鏍煎紡鍖栦负鍗氬 HTML 鍐呭"""
        html = f"""
<h2>浠婃棩瀹屾垚</h2>
<ul>
{self.list_to_html(tasks)}
</ul>

<h2>浠ｇ爜鎻愪氦</h2>
<ul>
{self.list_to_html(commits)}
</ul>

<h2>閬囧埌鐨勯棶棰?/h2>
<ul>
{self.list_to_html(issues)}
</ul>
"""
        return html
    
    def submit_to_blog(self, blog_post):
        """璋冪敤鍗氬 API 鎻愪氦鏂囩珷"""
        response = requests.post(
            f"{self.blog_api}/articles",
            json=blog_post,
            headers={"Authorization": "Bearer YOUR_TOKEN"}
        )
        
        if response.status_code == 201:
            article_id = response.json()['id']
            print(f"鏂囩珷鎻愪氦鎴愬姛锛両D: {article_id}")
            return article_id
        else:
            print(f"鎻愪氦澶辫触锛歿response.text}")
            return None
```

#### 2. 瀹氭椂浠诲姟

```python
# scheduler.py
from apscheduler.schedulers.blocking import BlockingScheduler

def daily_submit_job():
    """姣忓ぉ 18:00 鑷姩鎻愪氦鏃ュ織鍒板崥瀹?""
    integration = BlogIntegration()
    today = datetime.now().strftime("%Y%m%d")
    
    agents = ['guantang', 'jiangrou', 'dousha', 'suancai']
    
    for agent in agents:
        try:
            # 璇诲彇鏃ュ織
            log_data = integration.extract_daily_log(today, agent)
            
            # 鎻愪氦鍒板崥瀹?            article_id = integration.submit_to_blog(log_data)
            
            # 鏍囪宸叉彁浜?            if article_id:
                integration.mark_as_submitted(agent, today, article_id)
                
        except Exception as e:
            print(f"{agent} 鏃ュ織鎻愪氦澶辫触锛歿e}")

# 鍒涘缓璋冨害鍣?scheduler = BlockingScheduler()
scheduler.add_job(daily_submit_job, 'cron', hour=18, minute=0)

print("鍗氬闆嗘垚璋冨害鍣ㄥ惎鍔?..")
scheduler.start()
```

#### 3. 鏈湴澶囦唤绛栫暐

```yaml
澶囦唤瑙勫垯:
  - 宸叉彁浜ょ殑鏃ュ織鍦ㄦ湰鍦颁繚鐣?7 澶?  - 7 澶╁悗绉诲姩鍒板綊妗ｇ洰褰?  - 褰掓。鏃ュ織鍘嬬缉淇濆瓨
  
鐩綍缁撴瀯:
F:\openclaw\workspace\team\{agent}\logs\
鈹溾攢鈹€ current\          # 褰撳墠鏃ュ織锛堟渶杩?7 澶╋級
鈹溾攢鈹€ archive\          # 褰掓。鏃ュ織锛堝帇缂╋級
鈹?  鈹溾攢鈹€ 2026\
鈹?  鈹?  鈹溾攢鈹€ 03\
鈹?  鈹?  鈹斺攢鈹€ ...
鈹?  鈹斺攢鈹€ ...
鈹斺攢鈹€ submitted.json    # 宸叉彁浜よ褰?```

## 鍗氬鏂囩珷妯″潡璁捐

### 鏁版嵁搴撹〃缁撴瀯

```sql
-- 鏂囩珷鍒嗙被琛?CREATE TABLE categories (
    id INTEGER PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    slug VARCHAR(50) UNIQUE,
    description TEXT
);

-- 鏂囩珷琛?CREATE TABLE articles (
    id INTEGER PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    slug VARCHAR(200) UNIQUE,
    content TEXT,
    summary TEXT,
    category_id INTEGER,
    author_id INTEGER,
    view_count INTEGER DEFAULT 0,
    status VARCHAR(20) DEFAULT 'draft',  -- draft, published, archived
    published_at DATETIME,
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- 鏂囩珷鏍囩琛?CREATE TABLE tags (
    id INTEGER PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    slug VARCHAR(50) UNIQUE
);

-- 鏂囩珷鏍囩鍏宠仈琛?CREATE TABLE article_tags (
    article_id INTEGER,
    tag_id INTEGER,
    PRIMARY KEY (article_id, tag_id),
    FOREIGN KEY (article_id) REFERENCES articles(id),
    FOREIGN KEY (tag_id) REFERENCES tags(id)
);
```

### API 鎺ュ彛

#### 鍒涘缓鏂囩珷

```http
POST /api/articles
Content-Type: application/json
Authorization: Bearer YOUR_TOKEN

{
  "title": "椤圭洰寮€鍙戞棩蹇?- 閰辫倝 - 2026-03-07",
  "content": "<h2>浠婃棩瀹屾垚</h2>...",
  "category": "寮€鍙戞棩蹇?,
  "tags": ["鏃ュ父", "閰辫倝", "2026-03-07"],
  "status": "draft"
}

Response:
{
  "id": 123,
  "slug": "project-log-jiangrou-2026-03-07",
  "url": "https://yourblog.com/posts/123"
}
```

#### 鏇存柊鏂囩珷

```http
PUT /api/articles/{id}
Content-Type: application/json

{
  "title": "...",
  "content": "...",
  "status": "published"  // 鍙戝竷
}
```

#### 鎵归噺鑾峰彇鏂囩珷

```http
GET /api/articles?category=寮€鍙戞棩蹇?status=published&page=1&limit=10
```

## 宸ヤ綔鐘舵€佸睍绀?
### Agent 鐘舵€侀〉闈?
鍦ㄥ崥瀹㈤椤垫垨涓撻棬椤甸潰灞曠ず 4 涓?Agent 鐨勫伐浣滅姸鎬侊細

```html
<!-- 鍓嶇缁勪欢绀轰緥 -->
<div class="agent-status">
  <h2>Agent 鍥㈤槦宸ヤ綔鐘舵€?/h2>
  
  <div class="agent-card">
    <h3>鐏屾堡 - PM</h3>
    <div class="status-badge online">鍦ㄧ嚎</div>
    <p>褰撳墠浠诲姟锛氬崗璋冨墠鍚庣鑱旇皟</p>
    <div class="progress-bar">
      <div class="progress" style="width: 80%"></div>
    </div>
    <span class="progress-text">80%</span>
  </div>
  
  <div class="agent-card">
    <h3>閰辫倝 - 鍚庣</h3>
    <div class="status-badge busy">宸ヤ綔涓?/div>
    <p>褰撳墠浠诲姟锛氭枃绔犵鐞?API 寮€鍙?/p>
    <div class="progress-bar">
      <div class="progress" style="width: 60%"></div>
    </div>
    <span class="progress-text">60%</span>
  </div>
  
  <div class="agent-card">
    <h3>璞嗘矙 - 鍓嶇</h3>
    <div class="status-badge online">鍦ㄧ嚎</div>
    <p>褰撳墠浠诲姟锛氱Щ鍔ㄧ閫傞厤</p>
    <div class="progress-bar">
      <div class="progress" style="width: 75%"></div>
    </div>
    <span class="progress-text">75%</span>
  </div>
  
  <div class="agent-card">
    <h3>閰歌彍 - 杩愮淮/娴嬭瘯</h3>
    <div class="status-badge idle">绌洪棽</div>
    <p>褰撳墠浠诲姟锛氱瓑寰呮祴璇?/p>
    <div class="progress-bar">
      <div class="progress" style="width: 40%"></div>
    </div>
    <span class="progress-text">40%</span>
  </div>
</div>
```

### 瀹炴椂鏁版嵁婧?
```python
# status_api.py
@app.route('/api/agent-status')
def get_agent_status():
    """鑾峰彇 Agent 瀹炴椂鐘舵€?""
    agents = {
        'guantang': {
            'name': '鐏屾堡',
            'role': 'PM',
            'status': 'online',  # online, busy, idle, offline
            'current_task': '鍗忚皟鍓嶅悗绔仈璋?,
            'progress': 80,
            'last_active': '2026-03-07T14:00:00Z'
        },
        'jiangrou': {
            'name': '閰辫倝',
            'role': '鍚庣寮€鍙?,
            'status': 'busy',
            'current_task': '鏂囩珷绠＄悊 API 寮€鍙?,
            'progress': 60,
            'last_active': '2026-03-07T14:05:00Z'
        },
        # ... 鍏朵粬 Agent
    }
    
    return jsonify(agents)
```

## 閰嶇疆瑕佹眰

### 鐜鍙橀噺

```bash
# .env 鏂囦欢
BLOG_API_URL=http://yourblog.com/api
BLOG_API_TOKEN=your_api_token_here
LOG_SUBMIT_TIME=18:00  # 姣忔棩鎻愪氦鏃堕棿
LOCAL_LOG_RETENTION_DAYS=7
AUTO_PUBLISH=false  # true=鑷姩鍙戝竷锛宖alse=鑽夌
```

### 渚濊禆瀹夎

```bash
pip install requests apscheduler python-dotenv
```

## 瀹夊叏鑰冭檻

### API 璁よ瘉

浣跨敤 Token 璁よ瘉鏂瑰紡锛?
```python
# 鐢熸垚 Token
import secrets
API_TOKEN = secrets.token_urlsafe(32)

# 楠岃瘉 Token
@app.before_request
def verify_token():
    if request.path.startswith('/api/'):
        token = request.headers.get('Authorization', '').replace('Bearer ', '')
        if token != API_TOKEN:
            return jsonify({'error': 'Unauthorized'}), 401
```

### 鏉冮檺鎺у埗

```python
# 鍙湁鐗瑰畾 Agent 鍙互鍙戝竷鏂囩珷
ALLOWED_AGENTS = ['guantang', 'jiangrou', 'dousha', 'suancai']

def check_agent_permission(agent_name):
    if agent_name not in ALLOWED_AGENTS:
        raise PermissionError(f"Agent {agent_name} 鏃犳潈闄?)
```

