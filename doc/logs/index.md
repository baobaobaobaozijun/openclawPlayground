# OpenClaw Agent 团队 - 完整配置指南

## 📚 文档导航

本目录包含完整的 Agent 团队协作配置，针对个人博客项目和低资源服务器环境进行了优化。

### 核心文档

| 文档 | 说明 | 适用对象 |
|------|------|---------|
| [README.md](./README.md) | 灌汤 Agent 主文档 | 所有人 |
| [config.json](./config.json) | 全局配置文件 | 系统配置 |
| [quick-start.md](./quick-start.md) | 5 分钟快速开始 | 新手 |
| [optimization-summary.md](./optimization-summary.md) | 优化总结 | 架构师 |

### Agent 专用文档

| 文档 | 职责 | 资源限制 |
|------|------|---------|
| [workspace-programmer.md](./README.md) | 产品经理/项目经理 | 128MB / 25% CPU |
| [workspace-jiangrou.md](./workspace-jiangrou.md) | 后端工程师/架构师 | 128MB / 25% CPU |
| [workspace-dousha.md](./workspace-dousha.md) | UI/UX/前端工程师 | 128MB / 25% CPU |
| [workspace-suancai.md](./workspace-suancai.md) | 运维/测试工程师 | 64MB / 15% CPU |

### 技术规范文档

| 文档 | 内容 | 重要性 |
|------|------|-------|
| [agent-protocol.md](./agent-protocol.md) | Agent 通信协议 | ⭐⭐⭐⭐⭐ |
| [logging-audit.md](./logging-audit.md) | 日志和审计规范 | ⭐⭐⭐⭐ |
| [progress-tracking.md](./progress-tracking.md) | 进度追踪方法 | ⭐⭐⭐⭐ |
| [command-specification.md](./command-specification.md) | 命令使用规范 | ⭐⭐⭐ |

### 高级主题

| 文档 | 内容 | 阶段 |
|------|------|------|
| [lightweight-mode.md](./lightweight-mode.md) | 低配服务器运行指南 | 阶段 1 |
| [blog-integration.md](./blog-integration.md) | 博客系统集成 | 阶段 2 |

---

## 🎯 快速选择你的角色

### 我是灌汤 (PM/项目经理)

**你需要阅读:**
1. [README.md](./README.md) - 了解你的核心职责
2. [agent-protocol.md](./agent-protocol.md) - 学习如何分配任务
3. [progress-tracking.md](./progress-tracking.md) - 掌握进度追踪方法
4. [blog-integration.md](./blog-integration.md) - 准备博客集成

**日常工作:**
- 接收用户需求
- 分解工作任务
- 分配给其他 Agent
- 跟踪整体进度
- 生成各类报告

### 我是酱肉 (后端工程师)

**你需要阅读:**
1. [workspace-jiangrou.md](./workspace-jiangrou.md) - 后端开发完整指南
2. [agent-protocol.md](./agent-protocol.md) - 理解任务接收流程
3. [logging-audit.md](./logging-audit.md) - 填写工作日志

**日常工作:**
- 设计技术架构
- 开发后端 API
- 编写数据库模型
- 性能优化
- 配合部署

### 我是豆沙 (前端工程师)

**你需要阅读:**
1. [workspace-dousha.md](./workspace-dousha.md) - 前端开发完整指南
2. [agent-protocol.md](./agent-protocol.md) - 理解协作流程
3. [logging-audit.md](./logging-audit.md) - 填写工作日志

**日常工作:**
- UI/UX 设计
- 前端页面开发
- 响应式适配
- 交互优化
- 性能调优

### 我是酸菜 (运维/测试工程师)

**你需要阅读:**
1. [workspace-suancai.md](./workspace-suancai.md) - 运维测试完整指南
2. [agent-protocol.md](./agent-protocol.md) - 理解协作流程
3. [logging-audit.md](./logging-audit.md) - 填写工作日志

**日常工作:**
- 系统部署
- 服务监控
- 功能测试
- 性能测试
- 日志管理
- 备份恢复

---

## 📋 完整工作流程示例

### 场景：开发"用户评论"功能

#### 第 1 天上午 09:00 - 需求分析

**灌汤的工作:**
```markdown
# 灌汤 - 工作日志 2026-03-07

## 今日计划
- [ ] 分析"用户评论"功能需求
- [ ] 拆分为具体任务
- [ ] 分配给酱肉和豆沙

## 任务分解
1. 酱肉：评论 API 开发（预计 2 天）
   - 评论表设计
   - 增删改查接口
   - 评论审核功能

2. 豆沙：评论界面设计（预计 2 天）
   - 评论列表展示
   - 评论输入框
   - 回复功能 UI

3. 酸菜：评论功能测试（预计 1 天）
   - 功能测试用例
   - 性能压力测试
```

#### 第 1 天上午 09:30 - 任务分发

**灌汤创建任务文件:**

`F:\openclaw\workspace\communication\inbox\jiangrou\task_comment_api.json`
```json
{
  "from": "灌汤",
  "to": "酱肉",
  "action": "allocateTask",
  "data": {
    "task_id": "TASK_20260307_004",
    "task_name": "评论 API 开发",
    "description": "实现用户评论功能的后端 API",
    "priority": "high",
    "due_date": "2026-03-09",
    "deliverables": [
      {
        "name": "评论数据模型",
        "path": "backend/models/comment.py"
      },
      {
        "name": "评论 API 接口",
        "path": "backend/api/comments.py"
      }
    ],
    "acceptance_criteria": {
      "can_create_comment": true,
      "can_delete_comment": true,
      "supports_reply": true,
      "has_audit_flow": true
    }
  }
}
```

`F:\openclaw\workspace\communication\inbox\dousha\task_comment_ui.json`
```json
{
  "from": "灌汤",
  "to": "豆沙",
  "action": "allocateTask",
  "data": {
    "task_id": "TASK_20260307_005",
    "task_name": "评论界面开发",
    "description": "设计和实现用户评论的前端界面",
    "priority": "high",
    "due_date": "2026-03-09",
    "deliverables": [
      {
        "name": "评论组件",
        "path": "frontend/components/comments/"
      },
      {
        "name": "评论样式",
        "path": "frontend/css/comments.css"
      }
    ]
  }
}
```

#### 第 1 天上午 10:00 - 酱肉开始开发

**酱肉读取任务并响应:**

`F:\openclaw\workspace\communication\outbox\guantang\ack_task_004.json`
```json
{
  "from": "酱肉",
  "to": "灌汤",
  "action": "acknowledgeTask",
  "data": {
    "task_id": "TASK_20260307_004",
    "status": "accepted",
    "estimated_start": "2026-03-07T10:00:00Z",
    "notes": "已接收任务，开始设计评论表结构"
  }
}
```

**酱肉的日志记录:**

`F:\openclaw\workspace\team\jiangrou\logs\daily_20260307.md`
```markdown
# JIANGROU - 工作日志 2026-03-07

## 今日工作
- [x] 接收评论 API 开发任务
- [x] 设计评论数据模型
- [x] 实现基础 CRUD 接口
- [ ] 评论审核功能（明天完成）

## 代码提交
- `backend/models/comment.py` - 评论模型
  ```python
  class Comment(db.Model):
      id = db.Column(db.Integer, primary_key=True)
      content = db.Column(db.Text, nullable=False)
      author_id = db.Column(db.Integer, db.ForeignKey('users.id'))
      article_id = db.Column(db.Integer, db.ForeignKey('articles.id'))
      parent_id = db.Column(db.Integer, db.ForeignKey('comment.id'))
      status = db.Column(db.String(20), default='pending')
      created_at = db.Column(db.DateTime, default=datetime.utcnow)
  ```
- `backend/api/comments.py` - 评论 API（部分完成）

## 遇到的问题
- 无

## 明日计划
- 完成评论审核功能
- 添加评论通知
- 配合前端联调

## 工作时长
- 总计：6 小时
```

#### 第 1 天下午 15:00 - 豆沙设计界面

**豆沙的日志记录:**

`F:\openclaw\workspace\team\dousha\logs\daily_20260307.md`
```markdown
# DOUSHA - 工作日志 2026-03-07

## 今日工作
- [x] 接收评论界面任务
- [x] 设计评论组件原型
- [x] 实现评论列表样式
- [ ] 评论输入框交互（明天完成）

## 设计稿
![评论组件设计](../designs/comment_component.png)

## 代码提交
- `frontend/components/comments/comment-list.html` - 评论列表
- `frontend/css/comments.css` - 评论样式
  ```css
  .comment-item {
      padding: 16px;
      border-bottom: 1px solid #eee;
  }
  
  .comment-content {
      font-size: 14px;
      line-height: 1.6;
  }
  
  .comment-actions {
      display: flex;
      gap: 12px;
      margin-top: 8px;
  }
  
  .reply-btn {
      color: #3498db;
      cursor: pointer;
  }
  ```

## 明日计划
- 完成评论输入框
- 实现回复功能
- 添加动画效果

## 工作时长
- 总计：5 小时
```

#### 第 2 天上午 10:00 - 前后端联调

**酱肉与豆沙协作:**

双方约定 API 接口格式：

```javascript
// 前端调用示例
async function submitComment(articleId, content, parentId = null) {
  const response = await fetch(`/api/articles/${articleId}/comments`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`
    },
    body: JSON.stringify({
      content,
      parent_id: parentId
    })
  });
  
  const data = await response.json();
  
  if (response.ok) {
    // 成功：添加到评论列表
    addCommentToDOM(data.comment);
  } else {
    // 失败：显示错误信息
    showError(data.error);
  }
}
```

#### 第 2 天下午 16:00 - 酸菜进行测试

**酸菜的测试报告:**

`F:\openclaw\workspace\team\suancai\logs\daily_20260308.md`
```markdown
# SUANCAI - 工作日志 2026-03-08

## 今日工作
- [x] 接收评论功能测试任务
- [x] 编写功能测试用例
- [x] 执行功能测试
- [x] 性能压力测试

## 测试结果

### 功能测试
- ✅ 创建评论 - 通过
- ✅ 删除评论 - 通过
- ✅ 回复评论 - 通过
- ✅ 评论审核 - 通过
- ⚠️ 评论分页 - 发现 Bug（已报告）

### 性能测试
- 并发 100 用户评论 - 平均响应 150ms
- 并发 500 用户评论 - 平均响应 380ms
- 数据库查询优化建议：添加索引

## Bug 报告
已提交 BUG_001：
- **问题**: 评论分页参数错误时返回 500
- **严重程度**: medium
- **接收人**: 酱肉

## 明日计划
- 验证 Bug 修复
- 准备上线部署

## 工作时长
- 总计：6 小时
```

#### 第 3 天上午 09:00 - 完成任务

**酱肉修复 Bug 后提交:**

`F:\openclaw\workspace\communication\outbox\guantang\submit_comment_feature.json`
```json
{
  "from": "酱肉",
  "to": "灌汤",
  "action": "submitDeliverable",
  "data": {
    "task_id": "TASK_20260307_004",
    "deliverables": [
      {
        "name": "评论功能完整实现",
        "type": "feature",
        "paths": [
          "backend/models/comment.py",
          "backend/api/comments.py",
          "backend/services/comment_service.py"
        ],
        "status": "completed",
        "test_passed": true
      }
    ],
    "completion_status": "completed",
    "ready_for_deployment": true
  }
}
```

**灌汤汇总并生成报告:**

`F:\openclaw\workspace\projects\BLOG_20260307_001\progress\daily_20260308.md`
```markdown
# 项目日报 - 2026-03-08

## 重点成果
✅ 评论功能开发完成（酱肉）
✅ 评论界面实现完成（豆沙）
✅ 功能测试通过（酸菜）

## 整体进度
- 评论功能：100% 完成
- 计划偏差：提前 0.5 天
- 质量评估：良好

## 明日计划
- 部署评论功能到生产环境
- 开始下一个功能：标签系统
```

---

## 📊 资源配置总览

### 内存分配

```yaml
总可用内存：2GB (2048MB)

分配方案:
  灌汤 (PM):     128MB  (6.25%)
  酱肉 (后端):   128MB  (6.25%)
  豆沙 (前端):   128MB  (6.25%)
  酸菜 (运维):    64MB  (3.125%)
  ───────────────────────
  Agent 总计：   448MB  (21.875%)
  
  剩余可用：   1600MB  (78.125%)
  用于：
    - 操作系统：~512MB
    - 博客应用：~768MB
    - 数据库：~256MB
    - 缓冲空间：~64MB
```

### CPU 分配

```yaml
总 CPU 核心：2 核心

分配方案:
  灌汤：25% (0.5 核心)
  酱肉：25% (0.5 核心)
  豆沙：25% (0.5 核心)
  酸菜：15% (0.3 核心)
  ─────────────────
  Agent 总计：90% (1.8 核心)
  
  系统预留：10% (0.2 核心)
```

### 存储空间

```yaml
总存储：40GB

分配方案:
  操作系统：5GB
  博客程序：2GB
  数据库：3GB
  代码仓库：2GB
  日志文件：5GB (上限)
  备份文件：5GB
  ─────────────────
  已分配：22GB
  
  可用空间：18GB
```

---

## 🔄 两阶段实施计划

### 阶段 1: 本地开发和日志记录

**时间:** 项目开始 ~ 博客文章模块完成

**特点:**
- 所有 Agent 在本地工作
- 日志保存在本地 Markdown 文件
- 通过文件系统通信
- 手动或半自动化部署

**每日流程:**
```
09:00 - Agent 启动，检查收件箱
09:30 - 开始当日工作
12:00 - 午休
13:00 - 继续工作
17:00 - 填写工作日志
17:30 - 灌汤生成日报
18:00 - 结束当日工作
```

### 阶段 2: 博客集成和自动化

**触发条件:** 博客文章模块开发完成

**新增功能:**
- 自动将工作日志提交到博客
- 实时展示 Agent 工作状态
- 定时任务调度
- 完全自动化部署

**配置变更:**
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

---

## 🛠️ 工具和环境

### 必需工具

```yaml
版本控制:
  - Git
  - GitHub/GitLab

Python 环境:
  - Python 3.8+
  - pip
  - venv (虚拟环境)

编辑器:
  - VS Code (推荐)
  - PyCharm
  - Sublime Text
```

### 可选工具

```yaml
API 测试:
  - Postman
  - curl

性能测试:
  - Apache Bench (ab)
  - wrk
  - Locust

监控:
  - NetData
  - 自定义脚本
```

---

## 📞 沟通与协作

### Agent 间通信

**方式:** 基于文件系统的简化 RPC

**目录结构:**
```
F:\openclaw\workspace\communication\
├── inbox\           # 收件箱
│   ├── guantang\
│   ├── jiangrou\
│   ├── dousha\
│   └── suancai\
├── outbox\          # 发件箱
│   └── ...
└── archive\         # 归档
    └── ...
```

### 消息格式

```json
{
  "from": "发送者 Agent",
  "to": "接收者 Agent",
  "action": "操作类型",
  "data": {
    "具体数据": "..."
  },
  "timestamp": "ISO8601 时间戳"
}
```

### 常用操作

| Action | 说明 | 发送者 | 接收者 |
|--------|------|--------|--------|
| allocateTask | 分配任务 | 灌汤 | 其他 Agent |
| acknowledgeTask | 确认任务 | 其他 Agent | 灌汤 |
| queryProgress | 查询进度 | 灌汤 | 其他 Agent |
| reportIssue | 报告问题 | 任何 Agent | 灌汤 |
| submitDeliverable | 提交成果 | 其他 Agent | 灌汤 |

---

## 🎓 学习路径

### 新手入门

1. 阅读 [quick-start.md](./quick-start.md)
2. 选择一个 Agent 角色
3. 阅读对应的 workspace 文档
4. 创建第一个任务
5. 完成第一个工作流程

### 进阶提升

1. 深入理解 [agent-protocol.md](./agent-protocol.md)
2. 优化资源配置
3. 实施博客集成
4. 建立自动化流程

### 专家级

1. 定制通信协议
2. 扩展 Agent 能力
3. 集成外部工具
4. 性能调优

---

## 🔧 故障排除

### 常见问题速查

| 问题 | 可能原因 | 解决方案 |
|------|---------|---------|
| Agent 无响应 | 收件箱为空/进程挂起 | 检查进程状态，重启 Agent |
| 日志文件过大 | 记录过多调试信息 | 调整日志级别，启用轮转 |
| 部署失败 | 依赖缺失/配置错误 | 检查 requirements.txt，验证配置 |
| 测试失败 | 环境问题/代码 Bug | 查看测试报告，定位具体原因 |
| 内存不足 | 资源超限 | 减少并发，优化代码 |

### 获取帮助

1. 查看对应 Agent 的 workspace 文档
2. 检查日志文件
3. 搜索 GitHub Issues
4. 联系项目维护者

---

## 📈 持续改进

### 定期回顾

**每周回顾:**
- 本周完成了哪些功能？
- 遇到了哪些问题？
- 如何改进工作流程？

**每月回顾:**
- 整体进度是否符合预期？
- 资源配置是否合理？
- 需要调整哪些策略？

### 反馈循环

```
收集反馈 → 分析问题 → 制定改进方案 → 实施 → 验证效果 → 再次收集反馈
```

---

## 🌟 最佳实践

### 代码层面

1. **遵循编码规范** - PEP 8、语义化 HTML、模块化 CSS
2. **编写注释** - 函数 docstring、关键逻辑注释
3. **单元测试** - 核心功能必须有测试覆盖
4. **版本控制** - 频繁提交，有意义的 commit message

### 协作层面

1. **及时沟通** - 发现问题立即报告
2. **文档化** - 所有决策和讨论记录下来
3. **互相 review** - 代码提交前互相审查
4. **知识共享** - 遇到的问题和解决方案团队共享

### 运维层面

1. **自动化** - 能自动化的绝不手动
2. **监控预警** - 关键指标设置告警
3. **备份策略** - 重要数据多重备份
4. **应急预案** - 准备好回滚方案

---

*OpenClaw Agent 团队配置指南*  
*版本：v2.0.0-lite*  
*最后更新：2026-03-07*
