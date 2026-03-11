<!-- Last Modified: 2026-03-10 -->

# Agent 通信协议标准

**版本:** v2.0  
**生效日期:** 2026-03-10  
**维护者:**灌汤 (PM)  
**状态:** ✅ 已发布

---

## 📋 目录

1. [协议概述](#协议概述)
2. [通信架构](#通信架构)
3. [消息格式](#消息格式)
4. [核心接口](#核心接口)
5. [Gateway 连接配置](#gateway-连接配置)
6. [Docker 环境通讯](#docker 环境通讯)
7. [错误处理](#错误处理)
8. [示例代码](#示例代码)

---

## 协议概述

### 设计目标

- ✅ **轻量级** - 基于文件系统，避免复杂的网络协议
- ✅ **可靠性** - 消息持久化，支持重试机制
- ✅ **可扩展** - 支持 Docker 容器和本地混合部署
- ✅ **易调试** - 消息可见，便于问题排查

### 适用场景

| 场景 | 通信方式 | 说明 |
|------|---------|------|
| 本地开发 | 文件系统共享 | 所有 Agent 运行在同一机器 |
| Docker 容器 | Gateway RPC | 容器间通过 Gateway 连接 |
| 混合部署 | Gateway + 文件 | 部分本地，部分容器 |

---

## 通信架构

### 架构图

```
┌─────────────────────────────────────────────────────┐
│              OpenClaw Agent 通信架构                │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ┌──────────┐      ┌──────────┐      ┌──────────┐ │
│  │  灌汤    │      │  酱肉    │      │  豆沙    │ │
│  │  (PM)    │      │ (后端)   │      │ (前端)   │ │
│  │ :18789   │      │ :18791   │      │ :18792   │ │
│  └────┬─────┘      └────┬─────┘      └────┬─────┘ │
│       │                 │                 │        │
│       └─────────────────┼─────────────────┘        │
│                         │                          │
│              ┌──────────▼──────────┐              │
│              │   Gateway Router    │              │
│              │   (消息路由中心)    │              │
│              └──────────┬──────────┘              │
│                         │                          │
│       ┌─────────────────┼─────────────────┐       │
│       │                 │                 │       │
│  ┌────▼─────┐      ┌────▼─────┐      ┌────▼─────┐│
│  │Inbox/Outbox│    │ Gateway  │      │ Gateway  ││
│  │文件系统   │    │ Token 认证│      │ URL 路由 ││
│  └──────────┘      └──────────┘      └──────────┘│
│                                                     │
└─────────────────────────────────────────────────────┘
```

### 核心组件

#### 1. Inbox/Outbox 文件系统

**路径:** `F:\openclaw\workspace\communication\`

```
communication/
├── inbox/           # 接收的消息
│   ├── guantang/   # 灌汤的收件箱
│   ├── jiangrou/   # 酱肉的收件箱
│   ├── dousha/     # 豆沙的收件箱
│   └── suancai/    # 酸菜的收件箱
└── outbox/         # 发送的消息
    ├── guantang/   # 灌汤的发件箱
    ├── jiangrou/   # 酱肉的发件箱
    ├── dousha/     # 豆沙的发件箱
    └── suancai/    # 酸菜的发件箱
```

#### 2. Gateway 消息路由

**功能:**
- 消息转发和路由
- Agent 身份认证
- 负载均衡（未来）
- 消息队列管理

**端口分配:**
| Agent | Gateway 端口 | 外部映射端口 |
|-------|------------|-------------|
| 灌汤 | 18789 | 18789 (本地) |
| 酱肉 | 18789 | 18791 (Docker) |
| 豆沙 | 18789 | 18792 (Docker) |
| 酸菜 | 18789 | 18793 (Docker) |

---

## 消息格式

### 标准消息结构

```json
{
  "version": "2.0",
  "message_id": "MSG_20260310_001",
  "from": {
    "agent": "灌汤",
    "role": "pm",
    "instance_id": "guantang-local",
    "gateway_url": "http://localhost:18789"
  },
  "to": {
    "agent": "酱肉",
    "role": "backend-engineer",
    "instance_id": "jiangrou-docker",
    "gateway_url": "http://host.docker.internal:18789"
  },
  "action": "allocateTask",
  "priority": "high",
  "data": {
    // 具体数据内容
  },
  "metadata": {
    "timestamp": "2026-03-10T10:30:00Z",
    "ttl": 3600,
    "requires_ack": true,
    "correlation_id": "CORR_20260310_001"
  }
}
```

### 字段说明

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| version | string | ✅ | 协议版本 |
| message_id | string | ✅ | 消息唯一标识 |
| from | object | ✅ | 发送方信息 |
| to | object | ✅ | 接收方信息 |
| action | string | ✅ | 操作类型 |
| priority | string | ⚠️ | 优先级：low/normal/high/critical |
| data | object | ✅ | 消息数据 |
| metadata | object | ⚠️ | 元数据 |

### 优先级定义

```yaml
low:      # 低优先级 - 可延迟处理
normal:   # 普通优先级 - 正常处理
high:     # 高优先级 - 优先处理
critical: # 紧急 - 立即处理
```

---

## 核心接口

### 1. allocateTask - 任务分发

**用途:** PM 向团队成员分配任务

**请求:**
```json
{
  "version": "2.0",
  "message_id": "MSG_20260310_001",
  "from": {
    "agent": "灌汤",
    "role": "pm"
  },
  "to": {
    "agent": "酱肉",
    "role": "backend-engineer"
  },
  "action": "allocateTask",
  "priority": "high",
  "data": {
    "task": {
      "id": "TASK_20260310_001",
      "title": "开发用户认证 API",
      "description": "实现登录、注册、JWT 认证功能",
      "type": "feature",
      "status": "pending"
    },
    "requirements": [
      "支持用户名密码登录",
      "JWT token 有效期 24 小时",
      "包含单元测试"
    ],
    "deliverables": [
      {
        "type": "code",
        "path": "code/backend/api/auth.py",
        "description": "认证 API 代码"
      }
    ],
    "timeline": {
      "start_date": "2026-03-10",
      "due_date": "2026-03-12",
      "estimated_hours": 8
    }
  },
  "metadata": {
    "timestamp": "2026-03-10T10:30:00Z",
    "requires_ack": true
  }
}
```

**响应:**
```json
{
  "version": "2.0",
  "message_id": "MSG_20260310_002",
  "from": {
    "agent": "酱肉",
    "role": "backend-engineer"
  },
  "to": {
    "agent": "灌汤",
    "role": "pm"
  },
  "action": "acknowledgeTask",
  "data": {
    "task_id": "TASK_20260310_001",
    "status": "accepted",
    "estimated_start": "2026-03-10T14:00:00Z",
    "notes": "已接收，按时开始"
  },
  "metadata": {
    "timestamp": "2026-03-10T10:35:00Z",
    "correlation_id": "CORR_20260310_001"
  }
}
```

---

### 2. queryProgress- 进度查询

**用途:** PM 查询任务执行进度

**请求:**
```json
{
  "action": "queryProgress",
  "data": {
    "task_ids": ["TASK_20260310_001"],
    "include_details": true
  }
}
```

**响应:**
```json
{
  "action": "progressReport",
  "data": {
    "task_id": "TASK_20260310_001",
    "status": "in_progress",
    "progress": {
      "percentage": 60,
      "completed_items": [
        "用户登录 API",
        "JWT 认证模块"
      ],
      "remaining_items": [
        "注册 API"
      ]
    },
    "blockers": [],
    "last_update": "2026-03-10T14:00:00Z"
  }
}
```

---

### 3. reportIssue - 问题报告

**用途:** 团队成员向 PM 报告问题

**请求:**
```json
{
  "action": "reportIssue",
  "priority": "high",
  "data": {
    "task_id": "TASK_20260310_001",
    "issue": {
      "type": "technical",
      "severity": "medium",
      "title": "JWT 库版本冲突",
      "description": "当前 JWT 库与 Flask 版本不兼容",
      "impact": "影响登录功能实现"
    },
    "proposed_solution": "降级 JWT 库到 1.x 版本",
    "needs_decision": true
  }
}
```

---

### 4. submitDeliverable- 交付物提交

**用途:** 完成任务并提交成果

**请求:**
```json
{
  "action": "submitDeliverable",
  "priority": "normal",
  "data": {
    "task_id": "TASK_20260310_001",
    "deliverables": [
      {
        "name": "用户认证 API",
        "type": "code",
        "path": "code/backend/api/auth.py",
        "version": "1.0.0",
        "status": "ready_for_review",
        "test_coverage": 85
      }
    ],
    "completion_report": {
      "summary": "已完成所有要求的功能",
      "testing_status": "单元测试通过",
      "documentation": "API 文档已更新"
    }
  }
}
```

---

## Gateway 连接配置

### 本地 Gateway 配置

**文件:** `C:\Users\Administrator\.openclaw\openclaw.json`

```json
{
  "gateway": {
    "port": 18789,
    "mode": "local",
    "bind": "loopback",
    "auth": {
      "mode": "token",
      "token": "4aa59ed646303abc8fdeb18147ab277c8f17b2ddff626a39"
    }
  }
}
```

### Docker Gateway 配置

**文件:** `deployment-2026-03-08/docker-compose/docker-compose-agents.yml`

```yaml
services:
  jiangrou:
   environment:
      # ⭐ Gateway 连接配置
      - OPENCLAW_GATEWAY_URL=http://host.docker.internal:18789
      - OPENCLAW_GATEWAY_TOKEN=4aa59ed646303abc8fdeb18147ab277c8f17b2ddff626a39
    extra_hosts:
      - "host.docker.internal:host-gateway"
```

### 配置检查清单

启动前检查:

- [ ] Gateway 端口是否被占用
- [ ] Token 是否正确配置
- [ ] Docker 容器能否访问宿主机
- [ ] communication 目录权限是否正确

---

## Docker 环境通讯

### 网络拓扑

```
┌─────────────────────────────────────┐
│         Host Machine                │
│  ┌─────────────────────────────┐   │
│  │  Local Guangtang            │   │
│  │  Port: 18789                │   │
│  └──────────┬──────────────────┘   │
│             │                        │
│  ┌──────────▼──────────────────┐   │
│  │  Docker Bridge Network      │   │
│  │                             │   │
│  │  ┌─────────────────────┐   │   │
│  │  │ Jiangrou Container  │   │   │
│  │  │ Port: 18791→18789   │   │   │
│  │  └─────────────────────┘   │   │
│  │                             │   │
│  │  ┌─────────────────────┐   │   │
│  │  │ Dousha Container    │   │   │
│  │  │ Port: 18792→18789   │   │   │
│  │  └─────────────────────┘   │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

### 通讯流程

#### 灌汤 → 酱肉 (本地 → Docker)

```
1. 灌汤在 F:\openclaw\workspace\communication\outbox\jiangrou\ 创建消息
   ↓
2. 本地 Gateway 检测到新消息
   ↓
3. Gateway 通过 http://host.docker.internal:18789 转发到 Docker
   ↓
4. 酱肉容器接收到消息
   ↓
5. 酱肉处理消息并回复
   ↓
6. 回复消息反向路由回灌汤
```

#### 酱肉 → 灌汤 (Docker → 本地)

```
1. 酱肉在容器内 /app/workspace/communication/outbox\guantang\ 创建消息
   ↓
2. 酱肉 Gateway 客户端通过 OPENCLAW_GATEWAY_URL 发送
   ↓
3. 本地 Gateway 接收并路由到灌汤
   ↓
4. 灌汤接收到消息
```

---

## 错误处理

### 错误码表

| 错误码 | 名称 | 说明 | 处理方式 |
|--------|------|------|---------|
| ERR_001 | AGENT_UNREACHABLE | Agent 不可达 | 重试 3 次后报告 PM |
| ERR_002 | INVALID_MESSAGE | 消息格式错误 | 返回错误详情 |
| ERR_003 | AUTH_FAILED | 认证失败 | 检查 Token 配置 |
| ERR_004 | GATEWAY_OFFLINE | Gateway 离线 | 切换到文件模式 |
| ERR_005 | TIMEOUT | 请求超时 | 增加超时时间或重试 |

### 重试机制

```python
def send_message_with_retry(message, max_retries=3):
    """带重试的消息发送"""
    
   retry_delays = [5, 10, 30]  # 秒
    
    for attempt in range(max_retries):
        try:
           response = gateway.send(message)
           return response
        except GatewayError as e:
            if attempt < max_retries - 1:
                delay = retry_delays[attempt]
                log.warning(f"发送失败，{delay}秒后重试 (第{attempt+1}次)")
                time.sleep(delay)
            else:
                log.error(f"重试{max_retries}次后仍然失败")
                raise MessageDeliveryFailed(message.message_id)
```

### 降级策略

```yaml
正常模式:
  Gateway 在线 → 使用 Gateway RPC 通信
  
降级模式:
  Gateway 离线 → 降级到文件系统通信
  1. 消息写入 F:\openclaw\workspace\communication\outbox\
  2. 定期轮询 inbox 目录
  3. Gateway 恢复后自动切换回来
```

---

## 示例代码

### Python 客户端示例

```python
import json
import requests
from datetime import datetime

class AgentClient:
    """Agent 通信客户端"""
    
    def __init__(self, agent_name, gateway_url, gateway_token):
        self.agent_name = agent_name
        self.gateway_url = gateway_url
        self.gateway_token = gateway_token
        self.headers = {
            'Authorization': f'Bearer {gateway_token}',
            'Content-Type': 'application/json'
        }
    
    def send_message(self, to_agent, action, data, priority='normal'):
        """发送消息"""
        
        message = {
            'version': '2.0',
            'message_id': f'MSG_{datetime.now().strftime("%Y%m%d_%H%M%S")}',
            'from': {'agent': self.agent_name},
            'to': {'agent': to_agent},
            'action': action,
            'priority': priority,
            'data': data,
            'metadata': {
                'timestamp': datetime.utcnow().isoformat() + 'Z',
                'requires_ack': True
            }
        }
        
       response = requests.post(
            f'{self.gateway_url}/api/v1/message',
            headers=self.headers,
            json=message
        )
        
       return response.json()
    
    def check_inbox(self):
        """检查收件箱"""
        
       response = requests.get(
            f'{self.gateway_url}/api/v1/inbox',
            headers=self.headers
        )
        
       return response.json().get('messages', [])

# 使用示例
if __name__ == '__main__':
    # 酱肉客户端
   jiangrou_client = AgentClient(
       agent_name='酱肉',
        gateway_url='http://host.docker.internal:18789',
        gateway_token='4aa59ed646303abc8fdeb18147ab277c8f17b2ddff626a39'
    )
    
    # 发送进度报告
   jiangrou_client.send_message(
        to_agent='灌汤',
        action='progressReport',
        data={
            'task_id': 'TASK_20260310_001',
            'status': 'in_progress',
            'progress_percentage': 60
        },
        priority='normal'
    )
```

### PowerShell 脚本示例

```powershell
# 检查 Gateway 连接
$gatewayUrl = "http://localhost:18789"
$token = "4aa59ed646303abc8fdeb18147ab277c8f17b2ddff626a39"

try {
    $headers = @{
        'Authorization' = "Bearer $token"
        'Content-Type' = 'application/json'
    }
    
    $response = Invoke-RestMethod -Uri "$gatewayUrl/api/v1/health" -Headers $headers -Method Get
    
    Write-Host "✅ Gateway 在线" -ForegroundColor Green
    Write-Host "状态：$($response.status)"
}
catch {
    Write-Host"❌ Gateway 离线" -ForegroundColor Red
    Write-Host "错误：$($_.Exception.Message)"
}
```

---

## 📊 最佳实践

### 1. 消息设计原则

- ✅ **简洁明了** - 消息体尽量精简
- ✅ **自包含** - 包含所有必要信息
- ✅ **幂等性** - 重复接收不会产生副作用
- ✅ **可追溯** - correlation_id 追踪完整流程

### 2. 错误处理建议

- ✅ 总是设置合理的超时时间
- ✅ 实现优雅的重试机制
- ✅ 记录详细的错误日志
- ✅ 提供降级方案

### 3. 性能优化

- ✅ 批量发送小消息
- ✅ 使用消息队列缓冲
- ✅ 异步处理非关键消息
- ✅ 定期清理已处理消息

---

## 🔗 相关文档

- [ARCHITECTURE.md](../../ARCHITECTURE.md) - 整体架构
- [lightweight-mode.md](./lightweight-mode.md) - 轻量模式说明
- [comm-config.json](../../../deployment-2026-03-08/json-files/comm-config.json) - 通信配置

---

**状态:** ✅ 已发布  
**版本:** v2.0  
**最后更新:** 2026-03-10
