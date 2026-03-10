# 低配服务器运行指南

## 服务器配置

### 您的资源

```yaml
服务器:
  CPU: 2 核心
  内存：2GB
  存储：40GB
  操作系统：Linux (推荐 Ubuntu 20.04+)

本地开发环境:
  CPU: 多核心 (强大)
  内存：充足
  存储：充足
```

## 资源分配建议

### 服务器端（2GB 内存）

```yaml
内存分配:
  操作系统基础：512MB
  博客应用 (Flask/Django): 768MB
  数据库 (SQLite): 256MB
  Agent 运行时：512MB (严格控制)
  
存储空间:
  操作系统：5GB
  博客程序：2GB
  数据库：3GB
  日志文件：5GB (上限)
  备份文件：5GB
  可用空间：20GB
```

### 本地工作栈（强大资源）

```yaml
主要工作位置:
  - Agent 开发和测试
  - 代码编写和调试
  - 日志生成和初步处理
  
同步到服务器:
  - 仅部署必要的运行文件
  - 日志定期上传（压缩）
  - 数据库定时备份
```

## Agent 优化配置

### 4 个 Agent 的职责调整

#### 灌汤 (PM/协调者)
**工作内容:**
- 需求理解和任务分解
- 协调其他 Agent 工作
- 进度跟踪和报告生成
- 博客日志集成

**资源占用:** 低  
**运行模式:** 间歇性激活（需要时启动）

#### 酱肉 (后端开发)
**工作内容:**
- 博客后端 API 开发
- 数据库设计
- 用户认证系统
- 文章管理系统

**资源占用:** 中  
**运行模式:** 开发期活跃，完成后休眠

#### 豆沙 (前端开发)
**工作内容:**
- 博客前端页面设计
- CSS 样式编写
- 响应式适配
- 用户体验优化

**资源占用:** 中  
**运行模式:** 开发期活跃，完成后休眠

#### 酸菜 (运维/测试)
**工作内容:**
- 简化为兼职运维
- 简单功能测试
- 服务器监控
- 日志管理

**资源占用:** 低  
**运行模式:** 按需激活

## 轻量级运行模式

### 文件系统通信

避免重量级的消息队列，采用文件共享方式：

```yaml
通信目录：F:\openclaw\workspace\communication\
  ├── inbox\           # 接收的消息
  ├── outbox\          # 发送的消息
  └── archive\         # 历史消息归档

消息文件格式 (.json):
{
  "from": "灌汤",
  "to": "酱肉",
  "action": "allocateTask",
  "data": {...},
  "timestamp": "2026-03-07T10:30:00Z"
}
```

### 轮询机制

每个 Agent 定期检查自己的收件箱：

```python
# 伪代码示例
def check_inbox():
    inbox_path = f"communication/inbox/{agent_name}/"
    messages = os.listdir(inbox_path)
    for msg in messages:
        process_message(msg)
        move_to_archive(msg)
    
    # 每 5 分钟检查一次
    schedule.every(5).minutes.do(check_inbox)
```

## 日志优化

### 本地日志（主要）

**位置:** `F:\openclaw\workspace\logs\`

**策略:**
- 详细日志保存在本地
- 按日期组织，Markdown 格式
- 保留最近 7 天详细日志
- 周汇总和月归档长期保存

### 服务器日志（精简）

**位置:** `/var/log/blog/`

**策略:**
```yaml
日志级别：WARNING 以上
保留期：30 天
轮转：每天一个文件，最大 10MB
压缩：超过 7 天的日志自动 gzip 压缩
```

## 数据库优化

### 使用 SQLite

**原因:**
- 零配置
- 单文件
- 内存占用小
- 适合个人项目

**配置:**
```ini
[database]
engine = sqlite3
name = F:\openclaw\code\blog.db
pool_size = 1  # 不需要连接池
```

### 表结构优化

```sql
-- 文章表
CREATE TABLE articles (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT,
    category_id INTEGER,
    author_id INTEGER,
    view_count INTEGER DEFAULT 0,
    created_at DATETIME,
    updated_at DATETIME
);

-- 访问限制：只保留必要字段
-- 避免冗余数据占用空间
```

## 部署策略

### 本地开发，服务器部署

**工作流程:**
```
1. 本地开发
   ↓
2. 本地测试
   ↓
3. Git 提交
   ↓
4. 服务器拉取
   ↓
5. 重启服务
```

### 自动化脚本

```bash
#!/bin/bash
# deploy.sh - 一键部署脚本

echo "开始部署..."

# 1. 拉取最新代码
git pull origin main

# 2. 安装依赖
pip install -r requirements.txt

# 3. 数据库迁移
python manage.py migrate

# 4. 收集静态文件
python manage.py collectstatic --noinput

# 5. 重启服务
sudo systemctl restart blog.service

echo "部署完成！"
```

## 监控和告警

### 简单监控

**监控指标:**
- CPU 使用率 (>80% 告警)
- 内存使用率 (>90% 告警)
- 磁盘空间 (<5GB 告警)
- 服务状态

**实现方式:**
```python
# monitor.py - 简单监控脚本
import psutil

def check_resources():
    cpu = psutil.cpu_percent()
    memory = psutil.virtual_memory().percent
    disk = psutil.disk_usage('/').percent
    
    if cpu > 80:
        send_alert(f"CPU 使用率过高：{cpu}%")
    if memory > 90:
        send_alert(f"内存使用率过高：{memory}%")
    if disk > 90:
        send_alert(f"磁盘空间不足：{disk}%")
```

### 告警方式

- 邮件通知
- 博客后台消息
- 本地日志记录

## 性能优化技巧

### 代码层面

1. **懒加载**
   ```python
   # 仅在需要时加载大模块
   def heavy_operation():
       import heavy_module
       return heavy_module.process()
   ```

2. **缓存**
   ```python
   from functools import lru_cache
   
   @lru_cache(maxsize=128)
   def get_article(article_id):
       # 从数据库查询
       pass
   ```

3. **异步处理**
   ```python
   # 耗时操作异步执行
   async def send_email():
       await asyncio.sleep(1)
   ```

### 数据库层面

1. **索引优化**
   ```sql
   CREATE INDEX idx_article_category ON articles(category_id);
   CREATE INDEX idx_article_created ON articles(created_at);
   ```

2. **查询优化**
   ```python
   # 只查询需要的字段
   Article.objects.values('id', 'title').filter(status='published')
   ```

## 备份策略

### 本地备份

```yaml
频率：每天凌晨 3:00
内容:
  - 数据库完整备份
  - 上传的文件
  - 配置文件
保留：最近 30 次备份
```

### 服务器备份

```yaml
频率：每周日凌晨 2:00
内容:
  - 数据库备份
  - 日志归档
保留：最近 4 次备份
位置：/backup/
```

## 应急方案

### 内存不足处理

```bash
# 紧急释放内存脚本
#!/bin/bash

# 1. 清理缓存
sync && echo 3 > /proc/sys/vm/drop_caches

# 2. 停止非关键服务
sudo systemctl stop celery  # 如果有后台任务

# 3. 发送告警
send_alert "内存不足，已采取紧急措施"
```

### 磁盘空间不足

```bash
# 清理脚本
#!/bin/bash

# 1. 删除旧日志
find /var/log/blog/ -name "*.log" -mtime +7 -delete

# 2. 清理临时文件
rm -rf /tmp/*

# 3. 压缩大文件
find /backup/ -name "*.db" -mtime +30 -exec gzip {} \;
```
