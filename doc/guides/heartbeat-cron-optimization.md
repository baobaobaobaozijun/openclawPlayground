# 心跳/Cron 机制优化方案

**文档版本:** v1.0  
**创建时间:** 2026-03-26 21:35  
**负责人:** 灌汤 (PM)  
**优先级:** P0 - 高

---

## 📊 现状分析

### 当前 Cron 配置

| Cron 文件 | 频率 | 目标会话 | 功能 | 状态 |
|----------|------|---------|------|------|
| `agent-heartbeat.yml` | 每 10 分钟 | isolated | 数据库查询 + 失联唤醒 | ✅ |
| `agent-heartbeat-check.yml` | 每 10 分钟 | main | 系统事件触发 | ⚠️ 冗余 |
| `pipeline-recovery.yml` | Gateway 启动 | main | 流水线恢复 | ✅ |

### 今日问题暴露

| 问题 | 表现 | 影响 |
|------|------|------|
| **Session 锁超时** | 17:23/17:31 两次错误 | 主会话无法响应 |
| **心跳检查失效** | 酸菜失联 3 小时才发现 | 应 60 分钟发现 |
| **回调驱动未生效** | 酱肉/豆沙空闲 5 小时 | 产能浪费 |
| **固定频率低效** | 全员正常时仍 10 分钟检查 | token 浪费 |

---

## 🎯 优化目标

| 指标 | 当前 | 目标 | 改善 |
|------|------|------|------|
| 空窗期 | 5 小时+ | <30 分钟 | 90%↓ |
| Session 错误 | 2 次/天 | <1 次/周 | 85%↓ |
| 心跳成本 | 72k tokens/天 | 30k tokens/天 | 60%↓ |
| PM 介入 | 每轮手动 | 仅异常处理 | 70%↓ |

---

## 📋 优化方案

### 阶段 1：立即执行（今晚）

#### 1.1 删除冗余 Cron

**操作:**
```bash
# 删除功能重叠的 Cron
Remove-Item "C:\Users\Administrator\.openclaw\crons\agent-heartbeat-check.yml"
```

**理由:**
- `agent-heartbeat.yml` (isolated) 已覆盖全部功能
- `agent-heartbeat-check.yml` (main) 增加并发冲突风险
- 减少 50% Session 锁竞争

---

#### 1.2 心跳前置清锁

**修改:** `agent-heartbeat.yml`

```yaml
name: Agent 心跳监控
schedule:
  kind: every
  everyMs: 600000  # 每 10 分钟
sessionTarget: isolated
payload:
  kind: systemEvent
  text: |
    ❤️ 心跳检查（v3.0 优化版）
    
    ## 前置步骤（必须先执行）
    1. 清理残留锁文件
       Remove-Item "C:\Users\Administrator\.openclaw\agents\*\sessions\*.lock" -Force
    
    ## 核心检查
    2. 检查各 Agent 最后活动时间（workinglog LastWriteTime）
    3. >60 分钟失联 → sessions_spawn 唤醒
    4. >120 分钟空闲 → 自动派发新任务
    
    ## 输出
    5. 更新 doc/05-progress/agent-heartbeat-dashboard.md
    6. 正常 → HEARTBEAT_OK，异常 → 详细报告
```

---

#### 1.3 空闲自动派发

**逻辑:**
```
if Agent 空闲 > 120 分钟:
    检查 inbox 是否有待处理任务
    if 有任务:
        sessions_spawn 唤醒并分配
    else:
        从 Plan 文档读取下一轮工单
        sessions_spawn 派发新任务
```

**实现:** 在心跳 Cron 的 payload 中添加上述逻辑

---

### 阶段 2：本周内

#### 2.1 动态频率调整

**逻辑:**
```python
if 全员正常持续 > 24 小时:
    频率 = 30 分钟  # 节省 token
elif 有人空闲 (30-60 分钟):
    频率 = 10 分钟  # 标准
elif 有人失联 (>60 分钟):
    频率 = 5 分钟   # 紧急
```

**实现:** 心跳检查后动态修改 `everyMs` 值（需 Cron 支持）

**备选:** 创建多个 Cron，不同频率，根据状态启用/禁用

---

#### 2.2 数据库心跳表

**Schema:**
```sql
CREATE TABLE agent_heartbeat (
    agent_id VARCHAR(50) PRIMARY KEY,
    last_seen_at DATETIME NOT NULL,
    status ENUM('normal', 'idle', 'offline') NOT NULL,
    current_task VARCHAR(200),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

**Agent 职责:** 每 5 分钟主动写入一次心跳

**心跳检查:** 查询数据库而非文件系统（更快、更准确）

---

#### 2.3 回调自动化

**当前:** subagent 完成 → PM 手动派发下一轮

**目标:** subagent 完成 → 自动触发下一轮

**实现方案:**
```yaml
# 新增 Cron：回调监听
name: subagent-callback-handler
schedule:
  kind: event
  event: subagent_completed
payload:
  kind: systemEvent
  text: |
    🚀 回调驱动执行
    
    1. Test-Path 验证交付文件
    2. Test-Path 检查工作日志
    3. 同批次全部完成 → git commit
    4. 立即派发下一轮（sessions_spawn × N）
```

---

### 阶段 3：长期（下周+）

#### 3.1 独立监控服务

**架构:**
```
┌─────────────────┐
│  Node.js 监控服务 │ ← 独立进程，不依赖 Gateway
├─────────────────┤
│ - 每 5 分钟检查    │
│ - 直接读写数据库  │
│ - 调用 Gateway API │
│ - 无 Session 锁   │
└─────────────────┘
```

**优势:**
- 彻底解决 Session 锁冲突
- 更低的资源占用
- 可独立部署/重启

---

#### 3.2 事件驱动架构

**当前:** 轮询（每 10 分钟检查）

**目标:** 事件驱动（状态变更→触发检查）

**事件类型:**
- `agent.completed` - Agent 完成任务
- `agent.idle` - Agent 空闲超时
- `agent.offline` - Agent 失联
- `task.dispatched` - 任务派发

---

## 📝 实施清单

### 阶段 1（今晚）
- [ ] 删除 `agent-heartbeat-check.yml`
- [ ] 修改 `agent-heartbeat.yml` 添加清锁步骤
- [ ] 添加空闲>120 分钟自动派发逻辑
- [ ] 测试验证

### 阶段 2（本周）
- [ ] 实现动态频率调整
- [ ] 创建 agent_heartbeat 数据库表
- [ ] 添加 Agent 心跳上报逻辑
- [ ] 实现回调自动化 Cron

### 阶段 3（下周）
- [ ] 评估独立监控服务必要性
- [ ] 如需要，开发 Node.js 监控服务
- [ ] 事件驱动架构设计

---

## 🎯 验收标准

| 验收项 | 标准 | 验证方法 |
|--------|------|---------|
| Session 锁错误 | <1 次/周 | 查看错误日志 |
| 失联发现时间 | <60 分钟 | 模拟失联测试 |
| 空窗期 | <30 分钟 | 检查 Agent 空闲时长 |
| 心跳成本 | <30k tokens/天 | 查看 token 统计 |

---

## 📌 注意事项

1. **删除 Cron 前备份** - 复制配置文件到临时目录
2. **修改后重启 Gateway** - 确保新配置生效
3. **监控 24 小时** - 验证优化效果
4. **保留回滚方案** - 如出现问题可快速恢复

---

*文档创建完成 | 下一步：执行阶段 1 优化*
