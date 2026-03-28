<!-- Last Modified: 2026-03-28 00:55 -->

# 技能调整执行记录

**执行时间:** 2026-03-28 00:53-00:55  
**负责人:** 灌汤 (PM)  
**触发原因:** Plan-014/015 手动创建未插入数据库

---

## 问题根因

| 问题 | 根因 |
|------|------|
| Plan-014 未持久化 | PM 手动 write，未调用 plan-manager-v2 |
| Plan-015 未持久化 | PM 手动 write，未调用 plan-manager-v2 |
| 无自动验证 | 无 Cron 检查文档/数据库一致性 |
| 技能被动等待 | 技能设计为可选工具，非强制流程 |

---

## 已执行调整

### 1. 创建统一入口脚本 ✅

**文件:** `_tools/create-plan.ps1`

**功能:**
- 一键创建计划（数据库 + 文档 + 日志 + 上下文）
- 自动获取锁 + 幂等检查
- 自动插入数据库
- 自动创建文档目录
- 自动记录工作日志
- 自动同步 Agent 上下文

**用法:**
```powershell
.\create-plan.ps1 -planId "plan-016" -planName "前端优化" -priority "P1" -rounds 3 -agents "jiangrou,dousha,suancai"
```

---

### 2. 创建验证 Cron ✅

**文件:** `.openclaw/crons/plan-validation.yml`

**功能:**
- 每 5 分钟执行 `validate-plan-consistency.ps1`
- 扫描 tasks/01-plans/ 目录
- 对比 plan_progress 数据库表
- 发现不一致自动告警 + 生成报告

**Cron 配置:**
```yaml
action: exec
command: powershell -ExecutionPolicy Bypass -File "F:\openclaw\agent\workspace-guantang\_tools\validate-plan-consistency.ps1"
schedule: "*/5 * * * *"
timeout: 120
node: host
```

---

### 3. 创建验证脚本 ✅

**文件:** `_tools/validate-plan-consistency.ps1`

**功能:**
- 扫描文档目录获取计划 ID
- 查询数据库获取计划 ID
- 对比差异
- 生成验证报告
- 发现问题告警 PM

**输出:**
- 验证报告：`doc/05-progress/plan-validation-report.md`
- 控制台告警（发现问题时）

---

### 4. 修改 SOUL.md ✅

**新增章节:** `5.1 创建计划强制规范 ⭐⭐⭐`

**内容:**
- 禁止手动 write 创建计划
- 正确方式（create-plan.ps1 或 plan-manager-v2）
- 强制流程（6 步）
- 违规处理（三级）
- 验证机制（Cron 每 5 分钟）

---

## 待执行调整

| 任务 | 文件 | 状态 | 预计时间 |
|------|------|------|---------|
| 修改 plan-manager-v2 | `skills/plan-manager-v2/SKILL.md` | ⏳ | 10min |
| 测试完整流程 | create-plan.ps1 | ⏳ | 10min |
| 第一次验证检查 | Cron 执行 | ⏳ | 5min |

---

## 验收标准

- [ ] create-plan.ps1 可正常执行
- [ ] 验证 Cron 已配置
- [ ] 验证脚本可正常执行
- [ ] SOUL.md 已更新
- [ ] plan-manager-v2 增加自动验证

---

## 下次验证时间

| 检查项 | 时间 |
|--------|------|
| 第一次 Cron 执行 | 01:00 |
| 第一次验证报告 | 01:00 |
| 完整流程测试 | 01:05 |

---

*记录人：灌汤 PM | 2026-03-28 00:55*
