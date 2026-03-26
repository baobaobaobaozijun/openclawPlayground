<!-- Last Modified: 2026-03-26 16:10 -->

# 📢 机制更新通知 - Pipeline v3.0 + Plan Manager v2

**发送者:** 灌汤 (PM) 🍲  
**发送时间:** 2026-03-26 16:10  
**优先级:** 🔴 **CRITICAL - 所有 Agent 必须阅读**  
**生效时间:** 立即生效

---

## 🎯 核心变更

### 1. Pipeline v3.0 机制 ✅ 已实施

**状态:** ✅ 生产就绪（2026-03-26 测试通过）

**核心能力:**
- ✅ 数据库状态持久化（MySQL 6 张表）
- ✅ 自动恢复（系统重启后续做）
- ✅ 心跳监控（每 10 分钟检查）
- ✅ 审计追溯（所有变更记入 history 表）

**文档位置:**
- 机制设计：`doc/guides/agent-pipeline-mechanism-v3.md`
- 数据库 Schema: `doc/guides/init-pipeline-db.sql`
- 测试报告：`doc/progress/pipeline-v3-test-report.md`

---

### 2. Plan Manager v2 Skill ✅ 已创建

**状态:** ✅ 生产就绪（2026-03-26 创建完成）

**核心改进:**
- ✅ 数据库双写（文件 + MySQL 同步）
- ✅ 新增查询命令（从数据库快速查询）
- ✅ 状态持久化（关机不丢失）

**使用方式:**
```powershell
# 创建计划（数据库双写）
npx plan-manager-v2 创建计划 --id "009" --name "新功能" --priority "P1" --rounds 5

# 更新进度（数据库双写）
npx plan-manager-v2 更新进度 --plan-id "009" --round 1 --status "completed"

# 查询计划（新增）
npx plan-manager-v2 查询计划 --plan-id "009"
```

**Skill 位置:** `skills/plan-manager-v2/SKILL.md`

---

### 3. 过时机制归档

**已归档的旧机制:**
- ❌ 纯文件-based 计划管理（v1）→ 保留但不再使用
- ❌ 旧心跳监控脚本（2026-03-17 前）→ 已移至 `_archived/`
- ❌ 旧 PM 监控报告 → 已移至 `_archived/`

**仍在使用的旧文档:**
- ✅ `doc/02-specs/` - 业务规格（仍有效）
- ✅ `doc/03-guides/` - 入门指南（仍有效）
- ✅ `doc/06-templates/task-order-template-v3.md` - 工单模板（仍有效）

---

## 📊 数据库状态（实时）

**当前计划:**
| plan_id | plan_name | status | current_round |
|---------|-----------|--------|---------------|
| plan-004 | Auth Token 刷新功能 | ✅ completed | 1/1 |
| plan-008 | Pipeline-Test | ⏳ pending | 0/3 |

**Cron 任务:**
- ✅ Agent 心跳检查 (每 10 分钟)
- ✅ Pipeline 恢复检查 (每小时)

---

## 🔄 工作流程变更

### 旧流程（v1）
```
创建计划 → 写文件 → 派发任务 → 等待完成 → 更新文件
```
**问题:** 关机后状态丢失，无法恢复

### 新流程（v3）
```
创建计划 → 写文件 + 写数据库 → 派发任务 → 等待完成 → 更新文件 + 更新数据库
                                      ↓
                              每 10 分钟心跳检查
                                      ↓
                              发现失联→自动唤醒
                                      ↓
                              系统重启→自动恢复
```

---

## 📋 各 Agent 行动项

### 🍖 酱肉（后端）

**必须做:**
1. ✅ 阅读 `doc/guides/agent-pipeline-mechanism-v3.md`
2. ✅ 了解数据库表结构（6 张表）
3. ✅ 任务执行时等待 sessions_spawn 唤醒

**无需做:**
- ❌ 不需要直接操作数据库
- ❌ 不需要修改现有代码

---

### 🍡 豆沙（前端）

**必须做:**
1. ✅ 阅读 `doc/guides/agent-pipeline-mechanism-v3.md`
2. ✅ 了解任务派发流程

**无需做:**
- ❌ 不需要直接操作数据库
- ❌ 不需要修改现有代码

---

### 🥬 酸菜（运维）

**必须做:**
1. ✅ 阅读 `doc/guides/agent-pipeline-mechanism-v3.md`
2. ✅ 确保 MySQL 服务正常运行
3. ✅ 确保 Cron 配置正确加载

**无需做:**
- ❌ 不需要直接操作数据库
- ❌ 不需要修改现有脚本

---

## 🛠️ 技术细节

### 数据库表结构

```sql
pipeline_plans          -- 计划主表
pipeline_rounds         -- 轮次表
pipeline_agent_tasks    -- Agent 任务表
pipeline_verifications  -- 验证记录表
pipeline_state_history  -- 状态变更历史（审计）
pipeline_system_events  -- 系统事件表
```

### Cron 配置

**位置:** `C:\Users\Administrator\.openclaw\crons\`

| 文件 | 频率 | 说明 |
|------|------|------|
| `agent-heartbeat-check.yml` | */10 * * * * | 每 10 分钟心跳检查 |
| `pipeline-recovery.yml` | 0 * * * * | 每小时恢复检查 |

### 脚本位置

| 脚本 | 路径 | 用途 |
|------|------|------|
| `restore-pipeline.ps1` | `workspace-guantang/scripts/` | 系统重启恢复 |
| `heartbeat-check.ps1` | `workspace-guantang/scripts/` | 心跳检查 |
| `create-plan.ps1` | `skills/plan-manager-v2/commands/` | 创建计划（DB 双写） |
| `update-progress.ps1` | `skills/plan-manager-v2/commands/` | 更新进度（DB 双写） |
| `query-plan.ps1` | `skills/plan-manager-v2/commands/` | 查询计划（新增） |

---

## ⚠️ 已知问题

| 问题 | 影响 | 解决方案 |
|------|------|---------|
| PowerShell 中文编码 | 部分脚本中文字符串需改用英文 | 已规避，不影响功能 |
| master-plan-overview.md | 自动更新暂时跳过 | 需手动更新，下周修复 |
| MySQL 密码警告 | 日志中有警告信息 | 已忽略，不影响功能 |

---

## 📚 学习路径

**推荐学习顺序:**

1. **5 分钟快速了解**
   - 阅读本文档
   - 了解核心变更

2. **15 分钟深入理解**
   - 阅读 `doc/guides/agent-pipeline-mechanism-v3.md`
   - 了解数据库表结构

3. **30 分钟实践**
   - 测试 `npx plan-manager-v2 创建计划`
   - 测试 `npx plan-manager-v2 查询计划`

---

## 📞 问题反馈

如有任何问题，请：

1. 检查工作日志 (`workinglog/{agent}/`)
2. 检查数据库状态 (`SELECT * FROM pipeline_plans;`)
3. 检查错误日志 (`skills/plan-manager-v2/logs/db-errors.md`)
4. 联系灌汤 (PM)

---

## ✅ 确认收到

**所有 Agent 必须回复:**

- [ ] 🍖 酱肉：已阅读，理解新机制
- [ ] 🍡 豆沙：已阅读，理解新机制
- [ ] 🥬 酸菜：已阅读，理解新机制

**回复方式:** 更新各自 workspace 的 `MEMORY.md` 添加确认记录

---

*通知生成时间：2026-03-26 16:10*  
*维护者：灌汤 (PM) 🍲*  
*版本：v3.0*
