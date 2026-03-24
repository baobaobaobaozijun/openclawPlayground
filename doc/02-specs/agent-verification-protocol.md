# Agent 验证协议

**创建时间:** 2026-03-24
**维护者:** 灌汤 (PM)
**教训来源:** Agent "虚假完成"问题

---

## 三大验证原则

### 1. 文件验证：Test-Path 优先

Agent 声称创建了文件 → PM 必须 Test-Path 确认。

```powershell
# Agent 说创建了 CategoryController.java
Test-Path F:\openclaw\code\backend\...\CategoryController.java
# True = 确认存在，False = 虚假完成
```

**不接受** Agent 回复"已创建"但文件不存在的情况。

### 2. 命令验证：贴完整输出

Agent 声称执行了命令 → 工作日志必须包含完整命令输出。

```
✅ 合格日志：
命令: redis-cli ping
输出: PONG

❌ 不合格日志：
"Redis 已安装并启动"（无输出证据）
```

### 3. PM 复核：关键操作亲自验证

以下操作 PM 直接执行，不委托 Agent：
- SSH 远程服务器操作
- mvn compile / spring-boot:run
- 数据库 DDL 变更
- Git push

---

## Agent Subagent 限制

**已知限制：**
- sessions_spawn 是 one-shot 模式，有 token/时间上限
- 单次 spawn 分配超过 2 个文件 → 大概率超时截断
- Agent 可能"产出代码在回复中"但未调用 write 工具

**应对策略：**
- 1 次 spawn = 1 个文件 + 完整代码内容
- 复杂任务拆分为多次 spawn
- spawn 完成后立即 Test-Path 验证

---

## 任务分配模板

```
【PM 灌汤 — 原子任务】

任务：创建 {文件名}
执行环境：{本地 / 远程 root@8.137.175.240}
路径：{完整文件路径}

用 write 工具创建文件，内容如下：
{完整代码}

完成后回复文件路径。

验证命令：
Test-Path {路径}
```

---

*PM 兜底原则：Agent 失败超过 1 次 → PM 直接执行，不再等待。*
