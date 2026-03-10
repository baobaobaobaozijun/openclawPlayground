# 博客系统集成

## 概述

将 Agent 工作日志自动提交到个人博客系统，实现开发过程的透明化和记录。

## 集成架构

```
Agent 工作 → 本地日志 → 格式转换 → 博客 API → 发布文章
                                    ↓
                              博客网站展示
```

## 阶段划分

### 阶段 1: 博客搭建前

**时间:** 项目开始 ~ 文章模块完成

**工作内容:**
- 所有 Agent 在本地记录工作日志
- 日志格式统一为 Markdown
- 存储在指定目录

**日志位置:**
```
F:\openclaw\workspace\team\
├── guantang\logs\daily_YYYYMMDD.md
├── jiangrou\logs\daily_YYYYMMDD.md
├── dousha\logs\daily_YYYYMMDD.md
└── suancai\logs\daily_YYYYMMDD.md
```

**日志模板:**

```markdown
# {Agent 名称} - 工作日志 {日期}

## 今日工作
- [x] 任务 1：具体描述
- [x] 任务 2：具体描述
- [ ] 任务 3：具体描述（未完成原因）

## 代码提交
- `文件路径` - 修改说明

## 遇到的问题
- 问题描述（如有）
- 解决方案/需要帮助

## 明日计划
- 计划任务 1
- 计划任务 2

## 工作时长
- 开始时间：09:00
- 结束时间：17:00
- 总计：8 小时
```

### 阶段 2: 文章模块完成后

**触发条件:** 博客文章管理功能上线

**自动化流程:**

#### 1. 日志提取和格式化

```python
# blog_integration.py
import json
from datetime import datetime

class BlogIntegration:
    def __init__(self):
        self.blog_api = "http://yourblog.com/api"
        self.log_dir = "F:\\openclaw\\workspace\\team"
    
    def extract_daily_log(self, date, agent_name):
        """读取并解析 Agent 的日日志"""
        log_path = f"{self.log_dir}/{agent_name}/logs/daily_{date}.md"
        
        with open(log_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        return self.parse_log(content, agent_name, date)
    
    def parse_log(self, content, agent_name, date):
        """解析日志内容，转换为博客文章格式"""
        # 提取关键信息
        tasks_completed = self.extract_tasks(content, status='completed')
        issues = self.extract_issues(content)
        code_commits = self.extract_commits(content)
        
        # 格式化为博客文章
        blog_post = {
            "title": f"项目开发日志 - {agent_name} - {date}",
            "content": self.format_content(tasks_completed, issues, code_commits),
            "category": "开发日志",
            "tags": ["日常", agent_name, date],
            "status": "draft"  # 或 published
        }
        
        return blog_post
    
    def format_content(self, tasks, issues, commits):
        """格式化为博客 HTML 内容"""
        html = f"""
<h2>今日完成</h2>
<ul>
{self.list_to_html(tasks)}
</ul>

<h2>代码提交</h2>
<ul>
{self.list_to_html(commits)}
</ul>

<h2>遇到的问题</h2>
<ul>
{self.list_to_html(issues)}
</ul>
"""
        return html
    
    def submit_to_blog(self, blog_post):
        """调用博客 API 提交文章"""
        response = requests.post(
            f"{self.blog_api}/articles",
            json=blog_post,
            headers={"Authorization": "Bearer YOUR_TOKEN"}
        )
        
        if response.status_code == 201:
            article_id = response.json()['id']
            print(f"文章提交成功！ID: {article_id}")
            return article_id
        else:
            print(f"提交失败：{response.text}")
            return None
```

#### 2. 定时任务

```python
# scheduler.py
from apscheduler.schedulers.blocking import BlockingScheduler

def daily_submit_job():
    """每天 18:00 自动提交日志到博客"""
    integration = BlogIntegration()
    today = datetime.now().strftime("%Y%m%d")
    
    agents = ['guantang', 'jiangrou', 'dousha', 'suancai']
    
    for agent in agents:
        try:
            # 读取日志
            log_data = integration.extract_daily_log(today, agent)
            
            # 提交到博客
            article_id = integration.submit_to_blog(log_data)
            
            # 标记已提交
            if article_id:
                integration.mark_as_submitted(agent, today, article_id)
                
        except Exception as e:
            print(f"{agent} 日志提交失败：{e}")

# 创建调度器
scheduler = BlockingScheduler()
scheduler.add_job(daily_submit_job, 'cron', hour=18, minute=0)

print("博客集成调度器启动...")
scheduler.start()
```

#### 3. 本地备份策略

```yaml
备份规则:
  - 已提交的日志在本地保留 7 天
  - 7 天后移动到归档目录
  - 归档日志压缩保存
  
目录结构:
F:\openclaw\workspace\team\{agent}\logs\
├── current\          # 当前日志（最近 7 天）
├── archive\          # 归档日志（压缩）
│   ├── 2026\
│   │   ├── 03\
│   │   └── ...
│   └── ...
└── submitted.json    # 已提交记录
```

## 博客文章模块设计

### 数据库表结构

```sql
-- 文章分类表
CREATE TABLE categories (
    id INTEGER PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    slug VARCHAR(50) UNIQUE,
    description TEXT
);

-- 文章表
CREATE TABLE articles (
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

-- 文章标签表
CREATE TABLE tags (
    id INTEGER PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    slug VARCHAR(50) UNIQUE
);

-- 文章标签关联表
CREATE TABLE article_tags (
    article_id INTEGER,
    tag_id INTEGER,
    PRIMARY KEY (article_id, tag_id),
    FOREIGN KEY (article_id) REFERENCES articles(id),
    FOREIGN KEY (tag_id) REFERENCES tags(id)
);
```

### API 接口

#### 创建文章

```http
POST /api/articles
Content-Type: application/json
Authorization: Bearer YOUR_TOKEN

{
  "title": "项目开发日志 - 酱肉 - 2026-03-07",
  "content": "<h2>今日完成</h2>...",
  "category": "开发日志",
  "tags": ["日常", "酱肉", "2026-03-07"],
  "status": "draft"
}

Response:
{
  "id": 123,
  "slug": "project-log-jiangrou-2026-03-07",
  "url": "https://yourblog.com/posts/123"
}
```

#### 更新文章

```http
PUT /api/articles/{id}
Content-Type: application/json

{
  "title": "...",
  "content": "...",
  "status": "published"  // 发布
}
```

#### 批量获取文章

```http
GET /api/articles?category=开发日志&status=published&page=1&limit=10
```

## 工作状态展示

### Agent 状态页面

在博客首页或专门页面展示 4 个 Agent 的工作状态：

```html
<!-- 前端组件示例 -->
<div class="agent-status">
  <h2>Agent 团队工作状态</h2>
  
  <div class="agent-card">
    <h3>灌汤 - PM</h3>
    <div class="status-badge online">在线</div>
    <p>当前任务：协调前后端联调</p>
    <div class="progress-bar">
      <div class="progress" style="width: 80%"></div>
    </div>
    <span class="progress-text">80%</span>
  </div>
  
  <div class="agent-card">
    <h3>酱肉 - 后端</h3>
    <div class="status-badge busy">工作中</div>
    <p>当前任务：文章管理 API 开发</p>
    <div class="progress-bar">
      <div class="progress" style="width: 60%"></div>
    </div>
    <span class="progress-text">60%</span>
  </div>
  
  <div class="agent-card">
    <h3>豆沙 - 前端</h3>
    <div class="status-badge online">在线</div>
    <p>当前任务：移动端适配</p>
    <div class="progress-bar">
      <div class="progress" style="width: 75%"></div>
    </div>
    <span class="progress-text">75%</span>
  </div>
  
  <div class="agent-card">
    <h3>酸菜 - 运维/测试</h3>
    <div class="status-badge idle">空闲</div>
    <p>当前任务：等待测试</p>
    <div class="progress-bar">
      <div class="progress" style="width: 40%"></div>
    </div>
    <span class="progress-text">40%</span>
  </div>
</div>
```

### 实时数据源

```python
# status_api.py
@app.route('/api/agent-status')
def get_agent_status():
    """获取 Agent 实时状态"""
    agents = {
        'guantang': {
            'name': '灌汤',
            'role': 'PM',
            'status': 'online',  # online, busy, idle, offline
            'current_task': '协调前后端联调',
            'progress': 80,
            'last_active': '2026-03-07T14:00:00Z'
        },
        'jiangrou': {
            'name': '酱肉',
            'role': '后端开发',
            'status': 'busy',
            'current_task': '文章管理 API 开发',
            'progress': 60,
            'last_active': '2026-03-07T14:05:00Z'
        },
        # ... 其他 Agent
    }
    
    return jsonify(agents)
```

## 配置要求

### 环境变量

```bash
# .env 文件
BLOG_API_URL=http://yourblog.com/api
BLOG_API_TOKEN=your_api_token_here
LOG_SUBMIT_TIME=18:00  # 每日提交时间
LOCAL_LOG_RETENTION_DAYS=7
AUTO_PUBLISH=false  # true=自动发布，false=草稿
```

### 依赖安装

```bash
pip install requests apscheduler python-dotenv
```

## 安全考虑

### API 认证

使用 Token 认证方式：

```python
# 生成 Token
import secrets
API_TOKEN = secrets.token_urlsafe(32)

# 验证 Token
@app.before_request
def verify_token():
    if request.path.startswith('/api/'):
        token = request.headers.get('Authorization', '').replace('Bearer ', '')
        if token != API_TOKEN:
            return jsonify({'error': 'Unauthorized'}), 401
```

### 权限控制

```python
# 只有特定 Agent 可以发布文章
ALLOWED_AGENTS = ['guantang', 'jiangrou', 'dousha', 'suancai']

def check_agent_permission(agent_name):
    if agent_name not in ALLOWED_AGENTS:
        raise PermissionError(f"Agent {agent_name} 无权限")
```
