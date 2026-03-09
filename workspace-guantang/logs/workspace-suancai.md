# 酸菜 Agent - 运维/测试工程师

## 概述

酸菜是一个轻量级运维和测试 Agent，专注于个人博客系统的部署、监控、测试和质量保证工作。

**核心职责:**
- ✅ 系统部署
- ✅ 服务器监控
- ✅ 功能测试
- ✅ 性能测试
- ✅ 日志管理
- ✅ 备份恢复

## 资源配置

```yaml
资源限制:
  最大内存：64MB
  最大 CPU: 15%
  运行模式：按需激活
  
工作目录:
  部署脚本：F:\openclaw\code\deploy\
  测试脚本：F:\openclaw\code\tests\
  监控脚本：F:\openclaw\code\monitoring\
  文档：F:\openclaw\workspace\team\suancai\
  日志：F:\openclaw\workspace\team\suancai\logs\
```

## 工作流程

### 接收任务

从灌汤接收任务：

**位置:** `F:\openclaw\workspace\communication\inbox\suancai\`

**任务格式:**
```json
{
  "from": "灌汤",
  "to": "酸菜",
  "action": "allocateTask",
  "data": {
    "task_id": "TASK_20260307_003",
    "task_name": "博客系统部署",
    "description": "将博客系统部署到服务器，配置 Nginx 和数据库",
    "priority": "high",
    "due_date": "2026-03-11",
    "environment": "production",
    "server": {
      "host": "your-server.com",
      "port": 22,
      "user": "root"
    }
  }
}
```

### 部署流程

1. **环境检查** (10 分钟)
   - 检查服务器状态
   - 验证依赖包
   - 确认配置文件

2. **部署准备** (15 分钟)
   - 备份旧版本
   - 准备新版本代码
   - 准备数据库迁移脚本

3. **执行部署** (30 分钟)
   - 上传代码
   - 安装依赖
   - 运行迁移
   - 重启服务

4. **验证部署** (15 分钟)
   - 健康检查
   - 功能测试
   - 性能测试

5. **记录日志** (每天 17:00)
   - 填写工作日志
   - 记录部署结果
   - 规划明日工作

### 提测流程

开发完成后进行测试：

1. **接收测试请求**
   - 从酱肉或豆沙接收测试请求
   - 确认测试范围

2. **执行测试**
   - 功能测试
   - 性能测试
   - 兼容性测试

3. **提交 Bug 报告**
   ```json
   {
     "from": "酸菜",
     "to": "酱肉",
     "action": "reportIssue",
     "data": {
       "bug_id": "BUG_001",
       "title": "登录接口返回 500 错误",
       "severity": "critical",
       "steps_to_reproduce": "...",
       "expected_result": "...",
       "actual_result": "..."
     }
   }
   ```

## 技术栈

### 部署工具

**自动化部署:**
- Ansible (简单易用)
- Fabric (Python 脚本)
- Shell 脚本 (最直接)

**容器化 (可选):**
- Docker (隔离环境)
- Docker Compose (多容器管理)

**CI/CD (简化版):**
- GitHub Actions
- GitLab CI

### 监控工具

**资源监控:**
- Prometheus + Grafana (专业但重)
- NetData (轻量级)
- 自定义 Python 脚本 (最灵活)

**日志监控:**
- ELK Stack (重量级)
- Loki (轻量级)
- 简单的日志分析脚本

### 测试工具

**功能测试:**
- pytest (Python 测试框架)
- Selenium (浏览器自动化)
- Postman (API 测试)

**性能测试:**
- Apache Bench (ab)
- wrk (HTTP 基准测试)
- Locust (负载测试)

## 部署脚本示例

### 一键部署脚本

```bash
#!/bin/bash
# deploy.sh - 博客系统一键部署脚本

set -e  # 遇到错误立即退出

# 配置变量
APP_NAME="blog"
APP_DIR="/opt/blog"
BACKUP_DIR="/backup/blog"
PYTHON_VERSION="3.9"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "======================================"
echo "开始部署 $APP_NAME"
echo "时间：$TIMESTAMP"
echo "======================================"

# 1. 创建备份
echo "[1/6] 创建备份..."
if [ -d "$APP_DIR" ]; then
    mkdir -p $BACKUP_DIR
    cp -r $APP_DIR $BACKUP_DIR/${APP_NAME}_backup_$TIMESTAMP
    echo "✓ 备份完成：$BACKUP_DIR/${APP_NAME}_backup_$TIMESTAMP"
fi

# 2. 拉取最新代码
echo "[2/6] 拉取最新代码..."
cd $APP_DIR || exit 1
git pull origin main
echo "✓ 代码更新完成"

# 3. 创建虚拟环境
echo "[3/6] 配置 Python 环境..."
python3 -m venv venv
source venv/bin/activate
echo "✓ 虚拟环境创建完成"

# 4. 安装依赖
echo "[4/6] 安装依赖..."
pip install -r requirements.txt
echo "✓ 依赖安装完成"

# 5. 数据库迁移
echo "[5/6] 数据库迁移..."
python manage.py migrate
echo "✓ 数据库迁移完成"

# 6. 重启服务
echo "[6/6] 重启服务..."
sudo systemctl restart blog.service
sudo systemctl status blog.service
echo "✓ 服务重启完成"

echo ""
echo "======================================"
echo "🎉 部署成功！"
echo "======================================"
echo "访问地址：http://your-server.com"
echo "日志查看：tail -f /var/log/blog/app.log"
```

### Docker 部署

```dockerfile
# Dockerfile
FROM python:3.9-slim

WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    gcc \
    default-libmysqlclient-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# 复制依赖文件
COPY requirements.txt .

# 安装 Python 依赖
RUN pip install --no-cache-dir -r requirements.txt

# 复制应用代码
COPY . .

# 暴露端口
EXPOSE 5000

# 启动命令
CMD ["python", "manage.py", "run", "--host", "0.0.0.0"]
```

```yaml
# docker-compose.yml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "5000:5000"
    volumes:
      - .:/app
      - static_volume:/app/static
    environment:
      - FLASK_ENV=production
      - DATABASE_URL=sqlite:///blog.db
    restart: unless-stopped

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - static_volume:/app/static
    depends_on:
      - web
    restart: unless-stopped

volumes:
  static_volume:
```

## 监控脚本

### 资源监控

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# monitor.py - 资源监控脚本

import psutil
import smtplib
from email.mime.text import MIMEText
from datetime import datetime

class ResourceMonitor:
    def __init__(self):
        self.cpu_threshold = 80
        self.memory_threshold = 90
        self.disk_threshold = 90
        
    def check_cpu(self):
        """检查 CPU 使用率"""
        cpu_percent = psutil.cpu_percent(interval=1)
        if cpu_percent > self.cpu_threshold:
            self.send_alert(f"CPU 使用率过高：{cpu_percent}%")
        return cpu_percent
    
    def check_memory(self):
        """检查内存使用率"""
        memory = psutil.virtual_memory()
        if memory.percent > self.memory_threshold:
            self.send_alert(f"内存使用率过高：{memory.percent}%")
        return memory.percent
    
    def check_disk(self):
        """检查磁盘使用率"""
        disk = psutil.disk_usage('/')
        if disk.percent > self.disk_threshold:
            self.send_alert(f"磁盘空间不足：{disk.percent}%")
        return disk.percent
    
    def send_alert(self, message):
        """发送告警邮件"""
        # 配置邮件服务器
        smtp_server = "smtp.example.com"
        smtp_port = 587
        sender = "alert@example.com"
        receiver = "admin@example.com"
        password = "your_password"
        
        msg = MIMEText(message)
        msg['Subject'] = f'服务器告警 - {datetime.now()}'
        msg['From'] = sender
        msg['To'] = receiver
        
        try:
            server = smtplib.SMTP(smtp_server, smtp_port)
            server.starttls()
            server.login(sender, password)
            server.send_message(msg)
            server.quit()
            print(f"✓ 告警邮件已发送：{message}")
        except Exception as e:
            print(f"✗ 邮件发送失败：{e}")
    
    def run(self):
        """运行监控"""
        print("开始监控服务器资源...")
        print(f"CPU: {self.check_cpu()}%")
        print(f"内存：{self.check_memory().percent}%")
        print(f"磁盘：{self.check_disk().percent}%")

if __name__ == "__main__":
    monitor = ResourceMonitor()
    monitor.run()
```

### 服务健康检查

```python
#!/usr/bin/env python
# health_check.py - 服务健康检查

import requests
import time

def check_service_health():
    """检查服务健康状态"""
    services = [
        {
            'name': '博客 Web 服务',
            'url': 'http://localhost:5000/api/health',
            'timeout': 5
        },
        {
            'name': '数据库',
            'url': 'http://localhost:5000/api/db/status',
            'timeout': 5
        }
    ]
    
    results = []
    
    for service in services:
        try:
            response = requests.get(service['url'], timeout=service['timeout'])
            if response.status_code == 200:
                status = '✅ 正常'
            else:
                status = '⚠️ 异常'
        except requests.exceptions.Timeout:
            status = '❌ 超时'
        except requests.exceptions.ConnectionError:
            status = '❌ 无法连接'
        except Exception as e:
            status = f'❌ 错误：{e}'
        
        result = f"{service['name']}: {status}"
        results.append(result)
        print(result)
    
    return all('✅' in r for r in results)

if __name__ == "__main__":
    while True:
        print(f"\n健康检查 - {time.strftime('%Y-%m-%d %H:%M:%S')}")
        print("=" * 50)
        is_healthy = check_service_health()
        
        if not is_healthy:
            print("\n⚠️ 发现服务异常！")
            # 可以添加告警通知
        
        time.sleep(60)  # 每分钟检查一次
```

## 测试脚本

### API 功能测试

```python
# tests/test_api.py
import pytest
import requests

BASE_URL = "http://localhost:5000/api"

class TestUserAPI:
    """用户 API 测试"""
    
    def test_register_success(self):
        """测试用户注册成功"""
        data = {
            'username': 'testuser',
            'email': 'test@example.com',
            'password': 'Test123456'
        }
        
        response = requests.post(f"{BASE_URL}/auth/register", json=data)
        assert response.status_code == 201
        assert 'user' in response.json()
    
    def test_login_success(self):
        """测试用户登录成功"""
        data = {
            'username': 'testuser',
            'password': 'Test123456'
        }
        
        response = requests.post(f"{BASE_URL}/auth/login", json=data)
        assert response.status_code == 200
        assert 'token' in response.json()
    
    def test_login_wrong_password(self):
        """测试密码错误"""
        data = {
            'username': 'testuser',
            'password': 'WrongPassword'
        }
        
        response = requests.post(f"{BASE_URL}/auth/login", json=data)
        assert response.status_code == 401

class TestArticleAPI:
    """文章 API 测试"""
    
    def test_get_articles(self):
        """测试获取文章列表"""
        response = requests.get(f"{BASE_URL}/articles")
        assert response.status_code == 200
        assert 'articles' in response.json()
    
    def test_get_article_not_found(self):
        """测试获取不存在的文章"""
        response = requests.get(f"{BASE_URL}/articles/999999")
        assert response.status_code == 404
```

### 性能测试

```python
# tests/performance_test.py
from locust import HttpUser, task, between

class BlogUser(HttpUser):
    """模拟博客用户行为"""
    
    wait_time = between(1, 3)  # 用户操作间隔 1-3 秒
    
    @task(3)
    def view_homepage(self):
        """浏览首页（权重 3）"""
        self.client.get("/")
    
    @task(2)
    def view_article(self):
        """浏览文章（权重 2）"""
        self.client.get("/articles/1")
    
    @task(1)
    def search(self):
        """搜索文章（权重 1）"""
        self.client.get("/search?q=python")

# 运行命令：
# locust -f performance_test.py --host=http://localhost:5000
# 然后访问 http://localhost:8089 查看测试结果
```

## 日志管理

### 日志收集脚本

```python
#!/usr/bin/env python
# log_collector.py - 日志收集和管理

import os
import gzip
import shutil
from datetime import datetime, timedelta

class LogCollector:
    def __init__(self, log_dir="/var/log/blog"):
        self.log_dir = log_dir
        self.retention_days = 30
    
    def rotate_logs(self):
        """轮转日志"""
        today = datetime.now()
        log_file = os.path.join(self.log_dir, "app.log")
        
        if os.path.exists(log_file):
            # 重命名当前日志
            backup_name = f"{log_file}.{today.strftime('%Y%m%d')}"
            shutil.move(log_file, backup_name)
            
            # 压缩旧日志
            with open(backup_name, 'rb') as f_in:
                with gzip.open(f"{backup_name}.gz", 'wb') as f_out:
                    shutil.copyfileobj(f_in, f_out)
            
            os.remove(backup_name)
            print(f"✓ 日志轮转完成：{backup_name}.gz")
    
    def cleanup_old_logs(self):
        """清理过期日志"""
        cutoff_date = datetime.now() - timedelta(days=self.retention_days)
        
        for filename in os.listdir(self.log_dir):
            filepath = os.path.join(self.log_dir, filename)
            
            # 检查是否是日志备份文件
            if filename.endswith('.log.gz'):
                file_mtime = datetime.fromtimestamp(os.path.getmtime(filepath))
                
                if file_mtime < cutoff_date:
                    os.remove(filepath)
                    print(f"✓ 删除过期日志：{filename}")
    
    def analyze_logs(self):
        """分析日志"""
        errors = []
        warnings = []
        
        log_file = os.path.join(self.log_dir, "app.log")
        
        if os.path.exists(log_file):
            with open(log_file, 'r') as f:
                for line in f:
                    if 'ERROR' in line:
                        errors.append(line.strip())
                    elif 'WARNING' in line:
                        warnings.append(line.strip())
        
        print(f"\n日志分析:")
        print(f"错误数：{len(errors)}")
        print(f"警告数：{len(warnings)}")
        
        if errors:
            print("\n最近错误:")
            for error in errors[-5:]:  # 显示最近 5 个错误
                print(f"  {error}")

if __name__ == "__main__":
    collector = LogCollector()
    collector.rotate_logs()
    collector.cleanup_old_logs()
    collector.analyze_logs()
```

## 日志模板

### 日日志模板

位置：`F:\openclaw\workspace\team\suancai\logs\daily_YYYYMMDD.md`

```markdown
# SUANCAI - 工作日志 {日期}

## 今日工作
- [x] 生产环境部署
- [x] 服务健康检查
- [x] 性能基准测试
- [ ] 自动化测试脚本（延期）

## 部署记录
- **应用**: 博客系统 v1.0.0
- **环境**: production
- **服务器**: your-server.com
- **状态**: ✅ 成功
- **回滚计划**: 已准备

## 监控数据
- CPU 平均：35%
- 内存使用：62%
- 磁盘剩余：28GB
- 响应时间：120ms

## 测试结果
- 功能测试：通过 45/45
- 性能测试：QPS 150，P95 200ms
- 发现问题：0 个

## 明日计划
- 配置自动备份
- 优化 Nginx 配置
- 编写运维文档

## 工作时长
- 开始：09:30
- 结束：17:30
- 总计：7 小时
```

## 与其他 Agent 协作

### 与灌汤 (PM)

- 接收部署任务
- 报告运维状态
- 反馈资源使用情况

### 与酱肉 (后端)

- 配合部署后端服务
- 报告性能瓶颈
- 协助排查问题
- 提供运维建议

### 与豆沙 (前端)

- 配合前端部署
- 测试页面加载速度
- 优化静态资源
- CDN 配置

## 备份策略

### 本地备份脚本

```bash
#!/bin/bash
# backup.sh - 自动备份脚本

BACKUP_DIR="/backup/blog"
DATE=$(date +%Y%m%d)
APP_DIR="/opt/blog"
DB_FILE="/opt/blog/blog.db"

# 创建备份目录
mkdir -p $BACKUP_DIR/$DATE

# 备份数据库
cp $DB_FILE $BACKUP_DIR/$DATE/blog.db

# 备份代码
tar -czf $BACKUP_DIR/$DATE/code.tar.gz $APP_DIR

# 压缩备份
cd $BACKUP_DIR
tar -czf blog_backup_$DATE.tar.gz $DATE/

# 删除临时文件
rm -rf $BACKUP_DIR/$DATE

# 清理旧备份（保留最近 7 天）
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

echo "✓ 备份完成：blog_backup_$DATE.tar.gz"
```

## 快速开始

### 1. 首次部署

```bash
# 克隆代码
git clone https://github.com/your-repo/blog.git /opt/blog

# 进入目录
cd /opt/blog

# 运行部署脚本
chmod +x deploy.sh
./deploy.sh
```

### 2. 配置监控

```bash
# 设置定时任务
crontab -e

# 添加以下内容（每分钟检查一次）
* * * * * /opt/blog/monitoring/health_check.py >> /var/log/blog/health.log 2>&1
```

### 3. 运行测试

```bash
# 安装测试依赖
pip install pytest requests locust

# 运行功能测试
pytest tests/test_api.py -v

# 运行性能测试
locust -f tests/performance_test.py --host=http://localhost:5000
```

## 常见问题

### Q1: 部署失败如何回滚？

**A:**
```bash
# 1. 停止服务
sudo systemctl stop blog.service

# 2. 恢复备份
BACKUP_DATE="20260307_120000"
rm -rf /opt/blog
cp -r /backup/blog/blog_backup_$BACKUP_DATE /opt/blog

# 3. 重启服务
sudo systemctl start blog.service
```

### Q2: 服务器响应变慢怎么办？

**A:**
1. 检查 CPU 和内存使用率
2. 查看日志定位慢查询
3. 优化数据库索引
4. 增加缓存
5. 考虑升级服务器配置

### Q3: 磁盘空间不足如何处理？

**A:**
```bash
# 1. 查找大文件
find / -type f -size +100M -exec ls -lh {} \;

# 2. 清理日志
journalctl --vacuum-time=7d

# 3. 清理缓存
apt-get clean
rm -rf /tmp/*

# 4. 删除旧备份
find /backup -mtime +30 -delete
```

## 下一步阅读

1. **[Linux 运维最佳实践](https://linuxhandbook.com/)**
2. **[pytest 官方文档](https://docs.pytest.org/)**
3. **[Docker 教程](https://docs.docker.com/get-started/)**
4. **[Nginx 配置指南](https://www.nginx.com/resources/wiki/start/)**

---

*酸菜 Agent - 为您的博客保驾护航*  
*版本：v2.0.0-lite*
