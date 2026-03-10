# 快速启动指南

## 🚀 5 分钟快速开始

### 步骤 1: 确认配置 (1 分钟)

检查您的环境是否满足要求：

**服务器要求:**
- ✅ CPU: 2 核心或更高
- ✅ 内存：2GB 或更高
- ✅ 存储：40GB 或更高
- ✅ Python 3.8+

**本地开发环境:**
- ✅ Windows/Linux/Mac
- ✅ 充足的存储空间
- ✅ Git 已安装

### 步骤 2: 创建目录结构 (1 分钟)

执行以下命令创建必要的目录：

```bash
# Windows PowerShell
$directories = @(
    "F:\openclaw\workspace\team\guantang\logs",
    "F:\openclaw\workspace\team\jiangrou\logs",
    "F:\openclaw\workspace\team\dousha\logs",
    "F:\openclaw\workspace\team\suancai\logs",
    "F:\openclaw\workspace\communication\inbox",
    "F:\openclaw\workspace\communication\outbox",
    "F:\openclaw\workspace\communication\archive",
    "F:\openclaw\workspace\logs",
    "F:\openclaw\workspace\projects",
    "F:\openclaw\workspace\backups"
)

foreach ($dir in $directories) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
    }
}

Write-Host "目录结构创建完成！" -ForegroundColor Green
```

**Linux/Mac:**
```bash
mkdir -p /opt/openclaw/workspace/team/{guantang,jiangrou,dousha,suancai}/logs
mkdir -p /opt/openclaw/workspace/communication/{inbox,outbox,archive}
mkdir -p /opt/openclaw/workspace/{logs,projects,backups}
echo "目录结构创建完成！"
```

### 步骤 3: 初始化配置文件 (1 分钟)

`config.json` 已经优化完成，位于：
```
f:\openclaw\workspace-programmer\config.json
```

**关键配置检查:**
```json
{
  "server_optimization": {
    "enabled": true,
    "limits": {
      "cpu_cores": 2,
      "memory_gb": 2
    }
  },
  "logging": {
    "log_type": "unified_markdown",
    "retention_days": 7
  },
  "integration": {
    "blog": {
      "enabled": false,
      "phase": 1
    }
  }
}
```

### 步骤 4: 安装依赖 (1 分钟)

创建 `requirements.txt`:

```txt
# 核心依赖
requests==2.31.0
APScheduler==3.10.4
python-dotenv==1.0.0

# 数据库（可选，如果使用 SQLite 则不需要额外安装）
# sqlite3  # Python 内置

# 监控（可选）
psutil==5.9.6

# 博客集成（阶段 2）
# flask==3.0.0  # 如果需要运行博客后端
```

安装：
```bash
pip install -r requirements.txt
```

### 步骤 5: 创建 Agent 日志模板 (1 分钟)

为每个 Agent 创建今日的工作日志文件：

**PowerShell:**
```powershell
$agents = @("guantang", "jiangrou", "dousha", "suancai")
$today = Get-Date -Format "yyyyMMdd"

foreach ($agent in $agents) {
    $logPath = "F:\openclaw\workspace\team\$agent\logs\daily_$today.md"
    
    $template = @"
# $($agent.ToUpper()) - 工作日志 $(Get-Date -Format "yyyy-MM-dd")

## 今日工作
- [ ] 任务 1
- [ ] 任务 2

## 代码提交
- \`文件路径\` - 修改说明

## 遇到的问题
- 

## 明日计划
- 

## 工作时长
- 开始时间：
- 结束时间：
- 总计：
"@
    
    $template | Out-File -FilePath $logPath -Encoding utf8
    Write-Host "已创建 $agent 的日志模板" -ForegroundColor Green
}
```

---

## 📋 第一个工作日流程

### 早上 9:00 - 启动 Agent

创建启动脚本 `start_agents.py`:

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
from datetime import datetime

def start_agent(agent_name):
    """启动单个 Agent"""
    print(f"[{datetime.now()}] 启动 {agent_name}...")
    
    # 这里将来会实例化 Agent
    # 目前只是打印日志
    print(f"[{datetime.now()}] ✓ {agent_name} 就绪")

def main():
    agents = ['灌汤', '酱肉', '豆沙', '酸菜']
    
    print("=" * 50)
    print("OpenClaw Agent 团队 - 轻量级模式")
    print("=" * 50)
    
    for agent in agents:
        try:
            start_agent(agent)
        except Exception as e:
            print(f"[ERROR] {agent} 启动失败：{e}")
    
    print("\n所有 Agent 启动完成！")
    print("按 Ctrl+C 退出")
    
    try:
        while True:
            pass  # 保持运行
    except KeyboardInterrupt:
        print("\n正在关闭 Agent...")
        print("再见！")

if __name__ == "__main__":
    main()
```

运行：
```bash
python start_agents.py
```

### 上午工作 - 任务分发

**灌汤的工作:**

1. 读取项目需求
2. 分解任务
3. 创建任务文件

示例任务文件 `task_001.json`:
```json
{
  "task_id": "TASK_20260307_001",
  "project_id": "BLOG_20260307_001",
  "task_name": "博客后端 API 开发",
  "assignee": "酱肉",
  "priority": "high",
  "description": "实现用户认证和文章管理 API",
  "due_date": "2026-03-09",
  "deliverables": [
    {
      "name": "用户认证 API",
      "path": "backend/api/auth.py"
    }
  ]
}
```

将任务放到酱肉的收件箱：
```
F:\openclaw\workspace\communication\inbox\jiangrou\task_001.json
```

### 中午 12:00 - 进度检查

**灌汤检查各 Agent 进度:**

```python
def check_progress():
    """检查所有 Agent 的进度"""
    today = datetime.now().strftime("%Y%m%d")
    
    for agent in ['guantang', 'jiangrou', 'dousha', 'suancai']:
        log_path = f"F:\\openclaw\\workspace\\team\\{agent}\\logs\\daily_{today}.md"
        
        if os.path.exists(log_path):
            with open(log_path, 'r', encoding='utf-8') as f:
                content = f.read()
                # 简单分析完成情况
                completed = content.count('[x]')
                pending = content.count('[ ]')
                print(f"{agent}: 完成 {completed} 个任务，待完成 {pending} 个")
        else:
            print(f"{agent}: 今日日志不存在")
```

### 下午 17:00 - 填写日志

每个 Agent 更新自己的工作日志：

**酱肉的日志示例:**
```markdown
# JIANGROU - 工作日志 2026-03-07

## 今日工作
- [x] 用户认证 API 开发完成
- [x] 数据库模型设计
- [x] JWT Token 管理实现
- [ ] 性能优化（延期到明天）

## 代码提交
- `backend/api/auth.py` - 新增用户登录、注册接口
- `backend/models/user.py` - 用户数据模型
- `backend/config.py` - 配置文件

## 遇到的问题
- JWT 库版本与 Flask 不兼容
- **解决方案**: 降级 PyJWT 到 2.6.0

## 明日计划
- 文章管理 API 开发
- 数据库查询优化
- 单元测试编写

## 工作时长
- 开始时间：09:30
- 结束时间：17:30
- 总计：7 小时（午休 1 小时）
```

### 下午 18:00 - 生成日报

**灌汤自动生成项目日报:**

```python
def generate_daily_report():
    """生成项目日报"""
    today = datetime.now().strftime("%Y-%m-%d")
    
    report = f"""# 项目日报 - {today}

## 项目信息
- 项目：个人博客系统
- 项目 ID: BLOG_{datetime.now().strftime('%Y%m%d')}_001
- 日期：{today}
- 整体状态：✅ 正常进行

## 今日概览
"""
    
    # 收集各 Agent 数据
    agents_data = {}
    for agent in ['guantang', 'jiangrou', 'dousha', 'suancai']:
        # 读取并分析日志
        # ... 省略具体分析代码
        agents_data[agent] = {
            'completed': 3,
            'in_progress': 1,
            'issues': 0
        }
    
    # 生成表格
    report += "| Agent | 完成任务 | 进行中 | 遇到问题 |\n"
    report += "|-------|---------|--------|----------|\n"
    for agent, data in agents_data.items():
        report += f"| {agent} | {data['completed']} | {data['in_progress']} | {data['issues']} |\n"
    
    # 保存到文件
    report_path = f"F:\\openclaw\\workspace\\projects\\BLOG_{datetime.now().strftime('%Y%m%d')}_001\\progress\\daily_{today}.md"
    with open(report_path, 'w', encoding='utf-8') as f:
        f.write(report)
    
    print(f"日报已生成：{report_path}")
```

---

## 📅 第一周总结

### 周五 17:00 - 生成周报

```python
def generate_weekly_report():
    """生成周报"""
    week_start = get_week_start_date()
    week_end = get_week_end_date()
    
    report = f"""# 周报 - {week_start} 至 {week_end}

## 本周统计
- 工作天数：5 天
- 总工作时长：XX 小时
- 完成任务：XX 个
- 遇到问题：XX 个

## 里程碑达成
✅ 项目启动
✅ 环境搭建
⏳ 后端开发中

## 下周计划
- 完成后端 API
- 开始前端开发
- 准备测试用例
"""
    
    # 保存报告
    # ...
```

---

## 🎯 阶段 2: 博客集成（未来）

当博客文章模块完成后：

### 配置博客 API

编辑 `.env` 文件：
```bash
BLOG_API_URL=https://yourblog.com/api
BLOG_API_TOKEN=your_secret_token_here
LOG_SUBMIT_TIME=18:00
AUTO_PUBLISH=false
```

### 启用自动提交

修改 `config.json`:
```json
{
  "integration": {
    "blog": {
      "enabled": true,
      "auto_submit": true,
      "submit_time": "18:00",
      "status": "draft"
    }
  }
}
```

### 运行定时任务

```python
from apscheduler.schedulers.blocking import BlockingScheduler
from blog_integration import submit_logs

scheduler = BlockingScheduler()
scheduler.add_job(submit_logs, 'cron', hour=18, minute=0)
scheduler.start()
```

---

## ❓ 常见问题

### Q1: Agent 没有响应怎么办？

**A:** 
1. 检查收件箱是否有未读消息
2. 查看日志文件定位错误
3. 重启对应 Agent
4. 检查资源使用是否超限

### Q2: 日志文件太大怎么办？

**A:**
1. 检查是否记录了过多调试信息
2. 确认轮转策略是否生效
3. 手动归档旧日志
4. 增加磁盘空间或清理无用文件

### Q3: 如何查看 Agent 的工作状态？

**A:**
1. 读取当日日志文件
2. 查看任务完成标记 `[x]` 数量
3. 检查工作时长记录
4. 阅读遇到的问题和明日计划

### Q4: 服务器内存不足怎么办？

**A:**
1. 停止非必要的服务
2. 减少 Agent 并发数
3. 使用 swap 空间（临时方案）
4. 考虑升级到本地开发

---

## 📚 下一步阅读

完成快速开始后，建议阅读：

1. **[轻量级模式指南](./lightweight-mode.md)** - 深入了解低配服务器优化
2. **[Agent 通信协议](./agent-protocol.md)** - 理解文件共享通信
3. **[日志规范](./logging-audit.md)** - 学习日志编写格式
4. **[博客集成](./blog-integration.md)** - 准备阶段 2 集成

---

## 🆘 获取帮助

如遇到问题：

1. 查看 [optimization-summary.md](./optimization-summary.md) 了解优化细节
2. 检查日志文件 `F:\openclaw\workspace\logs\`
3. 参考 GitHub Issues
4. 联系项目维护者

---

*祝您使用愉快！*  
*OpenClaw 团队 - 轻量版 v2.0.0*
