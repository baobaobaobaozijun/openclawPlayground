<!-- Last Modified: 2026-03-26 16:00 -->

# Plan Manager v2 Skill - Pipeline v3.0 整合版

**版本:** v2.0  
**创建日期:** 2026-03-26  
**维护者:** 灌汤 (PM) 🍲  
**状态:** ✅ 生产中

---

## 🎯 核心改进

相比 v1 版本，v2 新增：

1. ✅ **数据库双写** - 文件 + MySQL 同步更新
2. ✅ **状态持久化** - 关机不丢失进度
3. ✅ **自动恢复** - 系统重启后续做
4. ✅ **实时查询** - 从数据库快速获取进度
5. ✅ **审计增强** - 所有变更写入 history 表

---

## 🚀 命令速查

| 命令 | 用途 | 数据库操作 |
|------|------|-----------|
| `创建计划` | 创建新计划 | INSERT pipeline_plans |
| `更新进度` | 更新轮次进度 | UPDATE pipeline_rounds |
| `完成计划` | 完成计划 | UPDATE + INSERT history |
| `查询计划` | 查看进度（新增） | SELECT 多表联查 |
| `列出计划` | 列出所有计划 | SELECT pipeline_plans |

---

## 📋 使用流程

### 场景 1: 创建计划

**命令:**
```powershell
npx plan-manager-v2 创建计划 `
  --id "007" `
  --name "文章管理" `
  --priority "P1" `
  --rounds 5 `
  --owner "酱肉"
```

**执行内容:**
1. ✅ 创建计划文件夹 + 5 个文档
2. ✅ 写入 `pipeline_plans` 表
3. ✅ 创建 `pipeline_rounds` 记录（N 轮）
4. ✅ 更新 master-plan-overview.md
5. ✅ 创建工作日志
6. ✅ Git 提交

**数据库写入:**
```sql
INSERT INTO pipeline_plans (plan_id, plan_name, status, current_round, total_rounds, priority, created_by, prd_doc_path)
VALUES ('plan-007', '文章管理', 'pending', 0, 5, 'P1', 'guantang', 'tasks/01-plans/plan-007-p1-文章管理/00-plan.md');

-- 创建 N 轮记录
INSERT INTO pipeline_rounds (plan_id, round_id, round_name, status)
VALUES 
('plan-007', 1, '第 1 轮', 'pending'),
('plan-007', 2, '第 2 轮', 'pending'),
...
```

---

### 场景 2: 更新进度

**命令:**
```powershell
npx plan-manager-v2 更新进度 `
  --plan-id "007" `
  --round 1 `
  --status "completed" `
  --actual-time "15m"
```

**执行内容:**
1. ✅ 更新 00-plan.md 进度表
2. ✅ 更新 01-round-orders.md
3. ✅ 更新 `pipeline_plans.current_round`
4. ✅ 更新 `pipeline_rounds.status`
5. ✅ 写入 `pipeline_state_history`
6. ✅ 创建工作日志
7. ✅ Git 提交

**数据库写入:**
```sql
UPDATE pipeline_plans 
SET current_round = 1, status = 'executing', updated_at = NOW()
WHERE plan_id = 'plan-007';

UPDATE pipeline_rounds 
SET status = 'completed', verified = TRUE, completed_at = NOW()
WHERE plan_id = 'plan-007' AND round_id = 1;

INSERT INTO pipeline_state_history (plan_id, round_id, old_status, new_status, change_reason)
VALUES ('plan-007', 1, 'pending', 'completed', 'plan_manager_v2_update');
```

---

### 场景 3: 完成计划

**命令:**
```powershell
npx plan-manager-v2 完成计划 `
  --plan-id "007" `
  --status "success" `
  --notify "feishu"
```

**执行内容:**
1. ✅ 生成 03-review.md 复盘报告
2. ✅ 更新 02-verify-list.md
3. ✅ 更新 `pipeline_plans.status = 'completed'`
4. ✅ 写入 `pipeline_state_history`
5. ✅ 发送飞书通知
6. ✅ 更新 04-feishu-logs.md
7. ✅ 创建工作日志
8. ✅ Git 提交 + 推送

**数据库写入:**
```sql
UPDATE pipeline_plans 
SET status = 'completed', completed_at = NOW()
WHERE plan_id = 'plan-007';

INSERT INTO pipeline_state_history (plan_id, old_status, new_status, change_reason)
VALUES ('plan-007', 'executing', 'completed', 'plan_manager_v2_complete');
```

---

### 场景 4: 查询计划（新增）

**命令:**
```powershell
# 查看单个计划详情
npx plan-manager-v2 查询计划 --plan-id "007"

# 查看所有进行中的计划
npx plan-manager-v2 列出计划 --status "executing"

# 查看今日完成的计划
npx plan-manager-v2 列出计划 --status "completed" --since "today"
```

**输出示例:**
```
计划编号：plan-007
计划名称：文章管理
优先级：P1
状态：🟢 执行中
当前轮次：2/5
创建时间：2026-03-26 16:00
更新时间：2026-03-26 16:30

轮次进度:
  第 1 轮：✅ 完成 (15m)
  第 2 轮：🟢 执行中
  第 3 轮：⏳ 待执行
  第 4 轮：⏳ 待执行
  第 5 轮：⏳ 待执行

数据库状态：✅ 已同步
```

---

## 🗄️ 数据库集成

### 表结构依赖

| 表名 | 用途 | 写入时机 |
|------|------|---------|
| pipeline_plans | 计划主表 | 创建计划 |
| pipeline_rounds | 轮次表 | 创建计划 |
| pipeline_agent_tasks | Agent 任务表 | 派发任务时 |
| pipeline_state_history | 状态历史表 | 更新/完成 |

### 数据库配置

**位置:** `F:\openclaw\agent\.local\pipeline-db-config.ps1`

```powershell
$dbHost = "localhost"
$dbPort = "3306"
$dbName = "baozipu"
$dbUser = "root"
$dbPass = "root123"
```

### 错误处理

**数据库写入失败时的策略:**

1. **警告不中断** - 继续完成文件操作
2. **记录错误日志** - 写入 `skills/plan-manager-v2/logs/db-errors.md`
3. **标记待同步** - 在计划文件夹创建 `.pending-sync` 标记
4. **下次重试** - 下次更新时尝试补写

---

## 🔧 技术实现

### 脚本结构

```
skills/plan-manager-v2/
├── SKILL.md                 # 本文档
├── package.json             # npm 入口配置
├── bin/
│   └── plan-manager-v2.js   # CLI 入口
├── commands/
│   ├── create-plan.ps1      # 创建计划（含 DB 写入）
│   ├── update-progress.ps1  # 更新进度（含 DB 写入）
│   ├── complete-plan.ps1    # 完成计划（含 DB 写入）
│   ├── query-plan.ps1       # 查询计划（新增）
│   └── list-plans.ps1       # 列出计划
├── templates/               # 5 个模板文件
└── logs/
    └── db-errors.md         # 数据库错误日志
```

### 公共函数库

**位置:** `commands/common.ps1`

```powershell
function Write-Database {
    param($query)
    try {
        mysql -h $dbHost -P $dbPort -u $dbUser -p$dbPass $dbName -e $query 2>$null
        return $true
    } catch {
        # 记录错误日志
        $errorMsg = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - DB Write Failed: $query`nError: $_`n"
        Add-Content -Path "skills/plan-manager-v2/logs/db-errors.md" -Value $errorMsg
        return $false
    }
}

function Test-DatabaseSync {
    param($planId)
    # 检查数据库是否有对应记录
    $result = mysql -h $dbHost ... -N -e "SELECT COUNT(*) FROM pipeline_plans WHERE plan_id = 'plan-$planId';"
    return [int]$result -gt 0
}
```

---

## 📊 与 v1 的兼容性

### 向后兼容

- ✅ v1 创建的计划可在 v2 中更新
- ✅ 文件夹结构完全相同
- ✅ 模板文件格式相同
- ✅ 命令参数兼容（支持中文参数名）

### 升级步骤

1. 备份现有计划文件夹
2. 安装 v2 skill
3. 测试单个计划更新
4. 确认数据库同步正常
5. 全面切换到 v2

---

## ⚠️ 故障排查

### 问题 1: 数据库写入失败

**症状:** 命令执行成功，但数据库无记录

**检查:**
```powershell
# 1. 检查数据库连接
mysql -h localhost -u root -proot123 -e "SELECT 1;"

# 2. 检查表是否存在
mysql -h localhost -u root -proot123 baozipu -e "SHOW TABLES LIKE 'pipeline_%';"

# 3. 检查错误日志
Get-Content skills/plan-manager-v2/logs/db-errors.md -Tail 20
```

**解决:**
1. 确认 MySQL 服务运行
2. 确认数据库配置正确
3. 手动补写数据库

---

### 问题 2: 文件与数据库不一致

**症状:** 文件显示 completed，数据库显示 executing

**解决:**
```powershell
# 运行同步检查
npx plan-manager-v2 同步检查 --plan-id "007"

# 或手动修复
mysql -h localhost -u root -proot123 baozipu -e "
UPDATE pipeline_plans SET status = 'completed' WHERE plan_id = 'plan-007';"
```

---

### 问题 3: 中文参数乱码

**症状:** PowerShell 提示编码错误

**解决:**
```powershell
# 使用英文参数名
npx plan-manager-v2 创建计划 --id "007" --name "Test" ...

# 或设置 PowerShell 编码
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
```

---

## 📝 最佳实践

1. **每次更新后验证数据库**
   ```powershell
   npx plan-manager-v2 查询计划 --plan-id "007"
   ```

2. **定期检查同步状态**
   ```powershell
   npx plan-manager-v2 同步检查 --all
   ```

3. **数据库错误及时处理**
   - 每天检查 db-errors.md
   - 发现错误手动补写

4. **Git 提交包含数据库变更**
   - 在日志中记录数据库操作
   - 便于追溯和审计

---

## 📚 相关文档

| 文档 | 路径 |
|------|------|
| Pipeline v3.0 机制 | `doc/guides/agent-pipeline-mechanism-v3.md` |
| 数据库 Schema | `doc/guides/init-pipeline-db.sql` |
| 迁移指南 | `skills/plan-manager/MIGRATION-v3.md` |
| v1 Skill | `skills/plan-manager/SKILL.md` |

---

## 📊 版本历史

| 版本 | 日期 | 变更内容 |
|------|------|---------|
| v2.0 | 2026-03-26 | 新增数据库双写、查询命令、错误处理 |
| v1.0 | 2026-03-25 | 初始版本（文件系统） |

---

*维护者：灌汤 (PM) 🍲*  
*最后更新：2026-03-26 16:00*
