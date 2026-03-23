# Agent 心跳与监控机制重构方案

**创建时间:** 2026-03-12  
**问题级别:** 🔴 P0 - 严重影响项目进度  
**状态:** 待实施

---

## 🔍 问题分析

### 当前配置的问题

#### 1. 被动心跳机制失效

**酱肉/豆沙/酸菜配置:**
```markdown
触发时机：每 10 分钟自动检查
必须执行：使用 sessions_send 主动向 PM (灌汤) 发送心跳消息
```

**实际情况:**
- ❌ 三个 Agent 都在等待"被检查"，而不是主动发送
- ❌ 灌汤没有配置如何接收和处理心跳消息
- ❌ 没有人发起心跳检查，全员沉默

#### 2. OpenClaw 心跳机制误解

**OpenClaw 官方文档说明:**
```markdown
Heartbeat: 被动响应式
- 当收到心跳检查时，读取 HEARTBEAT.md 并响应
- 如果没有检查，就保持沉默
- 适用于批量检查（inbox + calendar + notifications）

Cron: 主动定时触发
- 在指定时间自动执行任务
- 独立会话，不干扰主会话
- 适用于精确时间的任务
```

**我们的错误理解:**
- ❌ 以为 heartbeat 是主动定时发送的
- ❌ 混淆了 sessions_send 和 sessions_spawn 的使用场景
- ❌ 期待每 10 分钟自动检查，但没有配置触发机制

#### 3. 缺乏持续工作监控

**当前心跳只报告:**
- 任务 ID、名称、进度、状态
- 正在执行的任务
- 问题与风险

**缺少关键信息:**
- ❌ 任务完成后是否立即开始新任务？
- ❌ Agent 是否处于空闲状态？
- ❌ 今日计划完成情况如何？
- ❌ 是否需要新任务分配？

---

## 💡 解决方案

### 方案一：Cron 定时心跳（推荐）⭐

利用 OpenClaw 的 Cron 机制，实现真正的心跳监控。

#### 灌汤配置（PM）

**创建 Cron 任务：**
```yaml
# .openclaw/crons/guantang-heartbeat.yml
name: guantang-heartbeat-check
schedule: "*/10 * * * *"  # 每 10 分钟
model: qwen3-coder-plus
thinking_level: medium

prompt: |
  你是灌汤（PM），现在执行心跳检查：
  
  1. 检查各 Agent 的工作状态
     - 查看 workspace-jiangrou/tasks/inbox/ 是否有未处理任务
     - 查看 workspace-dousha/tasks/inbox/ 是否有未处理任务
     - 查看 workspace-suancai/tasks/inbox/ 是否有未处理任务
  
  2. 如果有空闲 Agent（inbox 为空）
     - 立即分配新任务
     - 或检查是否需要创建新任务
  
  3. 更新心跳看板
     - 文件位置：doc/progress/agent-heartbeat-dashboard.md
     - 记录每个 Agent 的最后活动时间
     - 标记空闲 Agent 为 🟡 注意
  
  4. 如果有 Agent 超过 30 分钟未活动
     - 主动询问：@Agent 请报告当前状态
     - 如果无响应，考虑重新分配任务
  
  5. 确保所有 Agent 都有明确的任务
     - 酱肉：后端 API 开发
     - 豆沙：前端组件开发
     - 酸菜：测试和部署
  
  如果一切正常，回复：HEARTBEAT_OK - 所有 Agent 正常工作
  如果有问题，详细说明并采取行动
```

#### 酱肉配置（后端）

**修改 HEARTBEAT.md：**
```markdown
# HEARTBEAT.md - 酱肉的心跳配置

**最后更新:** 2026-03-12  
**心跳频率:** 每次被询问时

---

## ❤️ 心跳响应机制

**触发时机:** 当灌汤发起心跳检查时

**必须执行:**
1. **报告当前任务状态**
   - 任务 ID 和名称
   - 当前进度（百分比）
   - 状态：🟢正常 / 🟡有风险 / 🔴阻塞

2. **报告工作内容**
   - 过去 10 分钟完成的工作
   - 接下来 10 分钟计划做的工作

3. **如果有阻塞**
   - 立即说明问题和需要的帮助
   - 提供已尝试的解决方案

4. **如果任务已完成**
   - 提交成果（代码/文档）
   - 请求新任务分配
   - 建议下一步工作方向

**心跳消息格式:**
```
【心跳响应】酱肉 - {YYYY-MM-DD HH:MM}

## 当前任务
- 任务 ID: {TASK-XXX}
- 任务名称：{描述}
- 进度：{XX}%
- 状态：🟢/🟡/🔴

## 过去 10 分钟
{已完成的具体工作}

## 接下来 10 分钟
{计划做的工作}

## 问题与需求
- [ ] 无阻塞
- [ ] {问题描述}
- [ ] 需要：{需要的帮助}

## 任务完成情况
- [ ] 任务进行中
- [ ] 任务已完成，已提交成果
- [ ] 任务已完成，等待新任务 ⚠️
```

**⚠️ 重要提醒:**
- 如果任务完成，**立即**请求新任务，不要等待
- 如果有阻塞，**立即**上报，不要自己死磕超过 30 分钟
- 保持工作连续性，完成任务后立即开始下一个
```

#### 豆沙配置（前端）

**参照酱肉配置，内容针对前端调整**

#### 酸菜配置（运维）

**参照酱肉配置，内容针对运维调整**

---

### 方案二：主动心跳（备选）

如果 Cron 不可用，使用文件系统 + 定期检查。

#### 灌汤职责

**创建检查脚本：**
```powershell
# scripts/check-agent-heartbeat.ps1

$agents = @("jiangrou", "dousha", "suancai")
$timeout = 30 # 分钟

Write-Host "=== Agent 心跳检查 ===" -ForegroundColor Cyan

foreach ($agent in $agents) {
    $workspace = "F:\openclaw\agent\workspace-$agent"
    $lastModified = Get-ChildItem -Path $workspace -Recurse -File | 
                    Sort-Object LastWriteTime -Descending | 
                    Select-Object -First 1
    
    if ($lastModified) {
        $minutesAgo = (New-TimeSpan -Start $lastModified.LastWriteTime -End (Get-Date)).TotalMinutes
        
        if ($minutesAgo -gt $timeout) {
            Write-Host "❌ $agent 已超过 $([math]::Round($minutesAgo)) 分钟未活动" -ForegroundColor Red
            # 主动询问
            Write-Host "   → 将在对话中 @$agent 请报告状态"
        } else {
            Write-Host "✅ $agent 正常活动 ($([math]::Round($minutesAgo)) 分钟前)" -ForegroundColor Green
        }
    }
}

Write-Host "`n检查完成"
```

---

### 方案三：混合模式（最佳实践）⭐⭐⭐

结合 Cron 和主动监控的优势。

#### 灌汤配置

**1. Cron 定时检查（每 10 分钟）**
```yaml
# .openclaw/crons/guantang-monitor.yml
name: agent-monitoring
schedule: "*/10 * * * *"
model: qwen3-coder-plus

prompt: |
  【Agent 监控检查】
  
  1. 检查各 Agent 工作目录
     - git status 查看是否有未提交更改
     - 查看 tasks/inbox/ 是否有待处理任务
     - 查看 logs/ 最新日志内容
  
  2. 识别空闲 Agent
     - 如果 inbox 为空且无正在进行任务 → 标记为空闲
     - 如果超过 20 分钟无活动 → 标记为注意
  
  3. 采取行动
     - 空闲 Agent → 分配新任务或询问计划
     - 注意 Agent → 主动询问是否遇到问题
  
  4. 更新看板
     - doc/progress/agent-heartbeat-dashboard.md
     - 记录检查结果和采取的行动
  
  5. 确保工作连续性
     - 所有 Agent 都应该有明确任务
     - 如有空闲，立即从 backlog 分配任务
```

**2. HEARTBEAT.md 配置**
```markdown
# HEARTBEAT.md

## 心跳检查清单

**每 10 分钟（Cron 触发）:**
- [ ] 检查各 Agent inbox
- [ ] 检查各 Agent 最后活动时间
- [ ] 识别空闲 Agent
- [ ] 分配新任务给空闲 Agent
- [ ] 更新心跳看板

**每小时:**
- [ ] 评审整体进度
- [ ] 调整任务优先级
- [ ] 协调跨 Agent 协作

**每日:**
- [ ] 晨会（09:00）- 分配当日任务
- [ ] 午会（14:00）- 检查上午进度
- [ ] 晚验收（18:00）- 验收当日成果
```

#### 各 Agent 配置

**HEARTBEAT.md 统一模板:**
```markdown
# HEARTBEAT.md

## 心跳响应

**当灌汤检查时，报告以下内容:**

1. **当前任务状态**
   - 任务 ID、名称、进度
   - 状态：🟢正常 / 🟡注意 / 🔴阻塞

2. **工作报告**
   - 过去 10 分钟：完成了什么
   - 接下来 10 分钟：计划做什么

3. **需求和阻塞**
   - 是否需要帮助？
   - 是否有技术难题？
   - 是否需要协调其他 Agent？

4. **任务连续性**
   - 如果任务完成 → 立即请求新任务
   - 如果遇到阻塞 → 立即上报，转去做其他任务
   - 如果一切正常 → 继续当前工作

**响应格式:**
```
【心跳】{Agent 名} - {时间}

📊 状态：🟢/🟡/🔴
📋 任务：{任务 ID} - {任务名称}
📈 进度：{XX}%

⏰ 过去 10 分钟:
{已完成工作}

⏰ 接下来 10 分钟:
{计划工作}

⚠️ 需求/阻塞:
- [ ] 无
- [ ] {具体问题}

🔄 连续性:
- [ ] 任务进行中
- [ ] 任务完成，已提交
- [ ] 任务完成，求新任务 ⚠️
```
```

---

## 🎯 实施步骤

### 第一阶段：紧急修复（立即执行）

**目标:** 让所有 Agent 立即恢复工作

**步骤:**
1. ✅ 灌汤立即检查各 Agent 状态
   - 查看 workspace-*/tasks/inbox/
   - 查看 workspace-*/logs/最新日志
   
2. ✅ 识别空闲 Agent
   - 酱肉：Service 层和 Controller 层开发是否完成？
   - 豆沙：前端设计是否完成？
   - 酸菜：测试环境是否搭建完成？

3. ✅ 分配新任务
   - 为空闲 Agent 分配明确的下一个任务
   - 设定交付时间和验收标准

4. ✅ 建立监控机制
   - 创建 Cron 任务（每 10 分钟）
   - 创建心跳看板

### 第二阶段：机制建设（今天完成）

**目标:** 建立可靠的心跳监控机制

**步骤:**
1. ✅ 配置灌汤的 Cron 监控任务
2. ✅ 修改各 Agent的 HEARTBEAT.md
3. ✅ 创建心跳看板文件
4. ✅ 测试心跳机制有效性

### 第三阶段：持续优化（本周完成）

**目标:** 优化工作流程，提高效率

**步骤:**
1. ✅ 收集心跳数据，分析问题模式
2. ✅ 优化任务分配策略
3. ✅ 建立自动化工具（如 PowerShell 脚本）
4. ✅ 完善文档和最佳实践

---

## 📊 心跳看板模板

**文件位置:** `doc/progress/agent-heartbeat-dashboard.md`

```markdown
# Agent 心跳监控看板

**更新时间:** {YYYY-MM-DD HH:MM}  
**检查周期:** 每 10 分钟

---

## 实时状态

| Agent | 最后心跳 | 当前任务 | 进度 | 状态 | 备注 |
|-------|----------|----------|------|------|------|
| 酱肉 | {HH:MM} | {任务名称} | XX% | 🟢 | - |
| 豆沙 | {HH:MM} | {任务名称} | XX% | 🟢 | - |
| 酸菜 | {HH:MM} | {任务名称} | XX% | 🟡 | 等待部署 |

---

## 今日统计

| Agent | 总任务 | 已完成 | 进行中 | 阻塞 | 效率 |
|-------|--------|--------|--------|------|------|
| 酱肉 | 5 | 3 | 2 | 0 | 🟢 |
| 豆沙 | 4 | 2 | 2 | 0 | 🟢 |
| 酸菜 | 3 | 1 | 1 | 1 | 🟡 |

---

## 异常记录

### {YYYY-MM-DD HH:MM}
- **Agent:** 酱肉
- **问题:** 数据库连接超时
- **处理:** 已协助排查，配置正确
- **状态:** 已解决 ✅

---

## 行动项

- [ ] 为酱肉分配新的 API 开发任务
- [ ] 协调豆沙和酱肉的接口对接
- [ ] 跟进酸菜的测试进度
```

---

## 🔑 关键要点

### 1. 主动性原则

**灌汤（PM）必须主动:**
- ✅ 主动检查，不要等 Agent 报告
- ✅ 主动分配任务，不要让 Agent 等待
- ✅ 主动协调，不要等问题恶化

**Agent 必须主动:**
- ✅ 任务完成后立即请求新任务
- ✅ 遇到阻塞立即上报（不超过 30 分钟）
- ✅ 工作连续性，不要停下来等待

### 2. 透明度原则

**信息透明:**
- ✅ 所有任务在看板上可见
- ✅ 所有进度实时更新
- ✅ 所有问题公开讨论

**状态透明:**
- ✅ 每个人都知道其他人在做什么
- ✅ 瓶颈和阻塞立即可见
- ✅ 资源分配清晰明了

### 3. 连续性原则

**工作流不断档:**
- ✅ 任务 A 完成前，准备好任务 B
- ✅ 发现空闲，5 分钟内分配新任务
- ✅ 遇到阻塞，立即切换任务，不要等待

**监控不间断:**
- ✅ 每 10 分钟检查一次
- ✅ 工作时间持续监控
- ✅ 问题不过夜

---

## 📝 配置文件清单

### 需要创建的文件

1. ✅ `.openclaw/crons/guantang-monitor.yml` - 灌汤监控 Cron
2. ✅ `doc/progress/agent-heartbeat-dashboard.md` - 心跳看板
3. ✅ `scripts/check-agent-heartbeat.ps1` - 检查脚本（备选）

### 需要修改的文件

1. ✅ `workspace-guantang/HEARTBEAT.md` - 灌汤心跳配置
2. ✅ `workspace-jiangrou/HEARTBEAT.md` - 酱肉心跳配置
3. ✅ `workspace-dousha/HEARTBEAT.md` - 豆沙心跳配置
4. ✅ `workspace-suancai/HEARTBEAT.md` - 酸菜心跳配置

---

## 🎉 预期效果

### 实施前（当前状态）
- ❌ Agent 沉默，不知道在做什么
- ❌ 任务完成后停滞不前
- ❌ 问题隐藏，直到爆发
- ❌ PM 被动，等信息上门

### 实施后（目标状态）
- ✅ 每 10 分钟知道所有 Agent 状态
- ✅ 任务无缝衔接，持续工作
- ✅ 问题立即暴露，快速解决
- ✅ PM 主动，提前预防问题

---

**下一步行动:**
1. 立即执行第一阶段（紧急修复）
2. 今天完成第二阶段（机制建设）
3. 本周完成第三阶段（持续优化）

**责任人:** 灌汤（PM）  
**监督人:** 所有 Agent  
**生效时间:** 立即生效
