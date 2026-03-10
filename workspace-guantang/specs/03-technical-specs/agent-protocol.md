# Agent-to-Agent 通信协议（轻量版）

## 协议概述

针对个人博客项目的轻量级 Agent 协作协议。采用简化的函数调用方式，避免重量级的 JSON-RPC 2.0。

## 通信方式

### 传输层
- **协议**: 简化 RPC（基于文件系统）
- **传输**: 本地文件共享
- **认证**: Agent 身份标识
- **加密**: 不需要（本地通信）

### 消息格式

```json
{
  "from": "灌汤",
  "to": "酱肉",
  "action": "allocateTask",
  "data": {},
  "timestamp": "2026-03-07T10:30:00Z"
}
```

## 核心接口定义

### 1. 任务分发接口

**接口名称:** `allocateTask`

**用途:** 灌汤向其他 Agent 分配工作任务

**请求格式:**

```json
{
  "from": "灌汤",
  "to": "酱肉",
  "action": "allocateTask",
  "data": {
    "project_id": "BLOG_20260307_001",
    "task_id": "TASK_20260307_001",
    "task_name": "博客后端 API 开发",
    "description": "实现用户认证和文章管理 API",
    "priority": "high",
    "estimated_effort": "2 人·天",
    "due_date": "2026-03-09",
    "deliverables": [
      {
        "name": "API 代码",
        "path": "F:\\openclaw\\code\\backend\\api\\"
      }
    ]
  },
  "timestamp": "2026-03-07T10:30:00Z"
}
```

**响应格式:**

```json
{
  "from": "酱肉",
  "to": "灌汤",
  "action": "acknowledgeTask",
  "data": {
    "task_id": "TASK_20260307_001",
    "status": "accepted",
    "estimated_start": "2026-03-07",
    "notes": "已接收任务，按时开始"
  },
  "timestamp": "2026-03-07T10:35:00Z"
}
```

### 2. 进度查询接口

**接口名称:** `queryProgress`

**用途:** 灌汤查询其他 Agent 的任务进度

**请求格式:**

```json
{
  "from": "灌汤",
  "to": "酱肉",
  "action": "queryProgress",
  "data": {
    "project_id": "BLOG_20260307_001",
    "task_ids": ["TASK_20260307_001"]
  },
  "timestamp": "2026-03-07T14:00:00Z"
}
```

**响应格式:**

```json
{
  "from": "酱肉",
  "to": "灌汤",
  "action": "progressReport",
  "data": {
    "task_id": "TASK_20260307_001",
    "current_status": "in_progress",
    "progress_percentage": 60,
    "completed_work": "完成用户认证模块",
    "remaining_work": "文章管理模块开发中",
    "blockers": [],
    "last_update": "2026-03-07T14:00:00Z"
  },
  "timestamp": "2026-03-07T14:05:00Z"
}
```

### 3. 问题报告接口

**接口名称:** `reportIssue`

**用途:** 其他 Agent 向灌汤报告遇到的问题

**请求格式:**

```json
{
  "from": "酱肉",
  "to": "灌汤",
  "action": "reportIssue",
  "data": {
    "task_id": "TASK_20260307_001",
    "issue_type": "technical",
    "severity": "medium",
    "title": "第三方依赖冲突",
    "description": "JWT 库版本与现有框架不兼容",
    "proposed_solution": "降级 JWT 库或升级框架",
    "requires_action": true
  },
  "timestamp": "2026-03-07T15:00:00Z"
}
```

**响应格式:**

```json
{
  "from": "灌汤",
  "to": "酱肉",
  "action": "issueAcknowledged",
  "data": {
    "issue_id": "ISSUE_20260307_001",
    "action_plan": "已记录，明天讨论解决方案",
    "next_review": "2026-03-08T10:00:00Z"
  },
  "timestamp": "2026-03-07T15:10:00Z"
}
```

### 4. 交付物提交接口

**接口名称:** `submitDeliverable`

**用途:** 其他 Agent 向灌汤提交完成的交付物

**请求格式:**

```json
{
  "from": "酱肉",
  "to": "灌汤",
  "action": "submitDeliverable",
  "data": {
    "task_id": "TASK_20260307_001",
    "deliverables": [
      {
        "name": "用户认证 API",
        "type": "code",
        "path": "F:\\openclaw\\code\\backend\\api\\auth.py",
        "version": "1.0.0",
        "status": "ready_for_review"
      }
    ],
    "completion_status": "completed",
    "ready_for_testing": true
  },
  "timestamp": "2026-03-07T17:00:00Z"
}
```

**响应格式:**

```json
{
  "from": "灌汤",
  "to": "酱肉",
  "action": "deliverableReceived",
  "data": {
    "deliverable_id": "DEL_20260307_001",
    "status": "accepted",
    "next_step": "转交酸菜测试",
    "feedback": "代码质量良好"
  },
  "timestamp": "2026-03-07T17:10:00Z"
}
```

## 错误处理

| 错误码 | 说明 |
|--------|------|
| ERR_001 | Agent 不可用 |
| ERR_002 | 任务不存在 |
| ERR_003 | 权限不足 |
| ERR_004 | 资源不足 |
| ERR_005 | 文件格式错误 |

## 超时设置

- **任务分发请求超时:** 5 秒
- **进度查询请求超时:** 3 秒
- **问题报告请求超时:** 2 秒
- **交付物提交请求超时:** 5 秒

## 重试机制

如果 Agent 无响应：
- 第一次重试：5 秒后
- 第二次重试：10 秒后
- 第三次重试：30 秒后
- 如仍失败，记录日志并等待下次心跳
