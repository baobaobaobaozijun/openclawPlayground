# 定时任务/监控/心跳机制冲突排查报告

**排查时间:** 2026-03-16 15:59  
**排查人:** 灌汤 (PM)  
**触发原因:** 用户要求检查是否有互相矛盾的地方

---

## 📋 现有机制清单

### 1. simple-monitor.ps1 (旧监控脚本)

| 配置项 | 值 | 状态 |
|--------|-----|------|
| **位置** | `workspace-guantang/scripts/simple-monitor.ps1` | ⚠️ 已废弃 |
| **执行频率** | 每 5 分钟 | ⚠️ 过于频繁 |
| **监控对象** | Gateway + Docker 容器 | ⚠️ Docker 已废弃 |
| **触发方式** | 手动/后台运行 | ❌ 无自动触发 |
| **检查内容** | Gateway 健康、容器状态、Token 使用 | ⚠️ 部分过时 |

**问题:**
- ❌ 基于 Docker 架构（已切换到本地单 Gateway）
- ❌ 检查 Gateway 健康（`/api/v1/health` 接口不存在）
- ❌ 无自动触发机制
- ❌ 与心跳机制功能重叠但更复杂

---

### 2. agent-heartbeat-mechanism.md (新心跳机制)

| 配置项 | 值 | 状态 |
|--------|-----|------|
| **位置** | `doc/guides/agent-heartbeat-mechanism.md` | ✅ 有效 |
| **执行频率** | 每 10 分钟 | ✅ 合理 |
| **监控对象** | 酱肉/豆沙/酸菜 | ✅ 正确 |
| **触发方式** | Cron 定时任务 | ⚠️ Cron 未配置 |
| **检查内容** | workinglog 最后活动时间 | ✅ 准确 |
| **判定标准** | > 60 分钟 = 失联 | ✅ 合理 |
| **唤醒方式** | sessions_spawn 直接调用 | ✅ 已验证成功 |

**状态:**
- ✅ 文档完整
- ✅ 流程清晰
- ✅ 首次执行成功（100% 唤醒率）
- ⚠️ **Cron 配置未创建**

---

### 3. HEARTBEAT.md (PM 心跳配置)

| 配置项 | 值 | 状态 |
|--------|-----|------|
| **位置** | `workspace-guantang/HEARTBEAT.md` | ✅ 有效 |
| **执行频率** | 每 10 分钟 | ✅ 与心跳机制一致 |
| **触发方式** | Cron + subagent 唤醒 | ⚠️ Cron 未配置 |
| **检查内容** | tasks/inbox + workinglog + code | ✅ 全面 |
| **失联标准** | > 60 分钟 | ✅ 与心跳机制一致 |

**状态:**
- ✅ 已更新（15:06）
- ✅ 与心跳机制文档一致
- ⚠️ **依赖的 Cron 未配置**

---

### 4. Cron 定时任务配置

**检查结果:**
- ❌ `C:\Users\Administrator\.openclaw\crons\` 目录 **不存在**
- ❌ 无任何 `.yml` 配置文件
- ❌ 心跳机制依赖的 Cron 未创建

**影响:**
- ⚠️ 心跳机制文档完善但 **无自动触发**
- ⚠️ 目前仍依赖 PM 手动执行 sessions_spawn

---

## 🔍 冲突与矛盾分析

### 冲突 1: 监控频率不一致

| 机制 | 频率 | 问题 |
|------|------|------|
| simple-monitor.ps1 | 每 5 分钟 | ⚠️ 过于频繁，浪费资源 |
| agent-heartbeat-mechanism.md | 每 10 分钟 | ✅ 合理 |
| HEARTBEAT.md | 每 10 分钟 | ✅ 合理 |

**建议:** 废弃 simple-monitor.ps1，统一使用 10 分钟频率

---

### 冲突 2: 失联判定标准不一致

| 机制 | 判定标准 | 问题 |
|------|---------|------|
| simple-monitor.ps1 | Gateway 离线/容器异常 | ⚠️ 基于 Docker 架构（已废弃） |
| agent-heartbeat-mechanism.md | workinglog > 60 分钟无更新 | ✅ 准确 |
| HEARTBEAT.md | workinglog > 60 分钟无更新 | ✅ 一致 |

**建议:** 废弃 simple-monitor.ps1 的判定逻辑

---

### 冲突 3: 唤醒方式不同

| 机制 | 唤醒方式 | 问题 |
|------|---------|------|
| simple-monitor.ps1 | 保存灾难现场，等待人工介入 | ❌ 被动，无法自动恢复 |
| agent-heartbeat-mechanism.md | sessions_spawn 直接调用 | ✅ 主动，已验证成功 |
| HEARTBEAT.md | sessions_spawn 直接调用 | ✅ 一致 |

**建议:** 废弃 simple-monitor.ps1 的被动告警方式

---

### 冲突 4: 架构假设冲突

| 机制 | 架构假设 | 状态 |
|------|---------|------|
| simple-monitor.ps1 | Docker 多容器 + Gateway | ❌ 已废弃（2026-03-11 切换） |
| agent-heartbeat-mechanism.md | 本地单 Gateway 多 Agent | ✅ 当前架构 |
| HEARTBEAT.md | 本地单 Gateway 多 Agent | ✅ 当前架构 |

**建议:** 删除或更新 simple-monitor.ps1

---

### 冲突 5: Cron 配置缺失

**问题:**
- ✅ 心跳机制文档完善
- ✅ HEARTBEAT.md 配置清晰
- ❌ **但 Cron 目录不存在，无自动触发**

**影响:**
- 心跳机制目前仍依赖 PM 手动执行
- 无法保证每 10 分钟自动检查
- 如 PM 忘记执行，Agent 可能再次失联

---

## 📊 机制对比表

| 特性 | simple-monitor.ps1 | agent-heartbeat-mechanism | HEARTBEAT.md |
|------|-------------------|--------------------------|--------------|
| **架构** | Docker（废弃） | 本地单 Gateway | 本地单 Gateway |
| **频率** | 5 分钟 | 10 分钟 | 10 分钟 |
| **触发** | 手动/后台 | Cron（未配置） | Cron（未配置） |
| **判定** | Gateway/容器 | workinglog > 60 分钟 | workinglog > 60 分钟 |
| **唤醒** | 被动告警 | sessions_spawn | sessions_spawn |
| **状态** | ⚠️ 应废弃 | ✅ 有效 | ✅ 有效 |

---

## ✅ 解决方案

### 方案 A: 统一使用心跳机制（推荐）⭐

**步骤:**
1. ✅ 保留 `agent-heartbeat-mechanism.md` 和 `HEARTBEAT.md`
2. ❌ 废弃 `simple-monitor.ps1`（删除或标记为 deprecated）
3. 🔧 创建 Cron 配置文件，实现自动触发
4. 📝 更新文档，明确说明 Cron 配置位置

**优点:**
- 架构一致（本地单 Gateway）
- 频率合理（10 分钟）
- 唤醒方式主动有效（已验证）
- 文档完整清晰

---

### 方案 B: 整合两种机制

**步骤:**
1. 保留 simple-monitor.ps1 的 Gateway 健康检查
2. 整合心跳机制的 Agent 状态检查
3. 创建统一的监控脚本
4. 配置 Cron 定时任务

**缺点:**
- 增加复杂度
- simple-monitor.ps1 基于 Docker 架构，需要大量修改
- 必要性低（心跳机制已足够）

---

## 🎯 建议行动

### 立即执行（16:00 前）
- [ ] **删除或标记 simple-monitor.ps1 为废弃**
- [ ] **创建 Cron 配置文件**（`.openclaw/crons/agent-heartbeat.yml`）
- [ ] **测试 Cron 触发效果**

### 今日完成（18:00 前）
- [ ] 验证每 10 分钟自动检查
- [ ] 测试失联自动唤醒流程
- [ ] 更新相关文档

---

## 📋 Cron 配置模板

**文件:** `C:\Users\Administrator\.openclaw\crons\agent-heartbeat.yml`

```yaml
name: Agent 心跳检查
schedule:
  kind: every
  everyMs: 600000  # 每 10 分钟
payload:
  kind: agentTurn
  agentId: guantang
  message: "执行心跳检查，检查各 Agent workinglog 最后活动时间，发现失联立即 sessions_spawn 唤醒"
sessionTarget: isolated
delivery:
  mode: announce
```

**创建步骤:**
```powershell
# 1. 创建 crons 目录
New-Item -ItemType Directory -Force -Path "C:\Users\Administrator\.openclaw\crons"

# 2. 创建配置文件
# (使用上述 YAML 模板)

# 3. 重启 Gateway
openclaw gateway restart
```

---

## 📊 结论

### 发现的冲突

| 冲突 ID | 描述 | 严重程度 | 状态 |
|---------|------|----------|------|
| CONFLICT-001 | simple-monitor.ps1 基于废弃的 Docker 架构 | 🔴 高 | 待解决 |
| CONFLICT-002 | 监控频率不一致（5 分钟 vs 10 分钟） | 🟡 中 | 待解决 |
| CONFLICT-003 | Cron 配置缺失，心跳机制无法自动触发 | 🔴 高 | 待解决 |
| CONFLICT-004 | 唤醒方式不同（被动 vs 主动） | 🟡 中 | 待解决 |

### 推荐方案

**统一使用心跳机制（agent-heartbeat-mechanism.md + HEARTBEAT.md）**

**行动:**
1. 废弃 simple-monitor.ps1
2. 创建 Cron 配置
3. 验证自动触发

---

**排查人:** 灌汤 (PM) 🍲  
**排查时间:** 2026-03-16 15:59  
**下次检查:** 16:00（创建 Cron 配置后验证）
