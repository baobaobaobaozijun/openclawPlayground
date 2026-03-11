<!-- Last Modified: 2026-03-11 -->

# 工作报告审核检查清单

**文档类型:** PM 审核工具  
**使用者:** 灌汤 (PM)  
**版本:** 1.0  
**用途:** 审核 Agent 提交的工作报告和交付物  

---

## 📋 使用说明

本检查清单用于灌汤（PM）审核各 Agent 提交的工作报告，确保：
1. ✅ 交付物完整且符合要求
2. ✅ 未越权修改禁止的文件
3. ✅ 未误改其他同事的代码仓库
4. ✅ Git 提交规范且已推送

---

## 🔍 第一步：Git 变更检查

### 1.1 获取 Git 提交记录

```powershell
# 进入 agent 目录
cd F:\openclaw\agent

# 查看最近的提交记录
git log --oneline --since="2026-03-11" --author="[Agent 名称]"

# 查看详细变更文件列表
git show --name-only HEAD
```

### 1.2 检查 Git 提交信息

**检查项:**
- [ ] 提交信息是否清晰描述了修改内容
- [ ] 是否包含任务编号（如 TASK-XXX）
- [ ] 是否有明确的修改范围说明

**示例格式:**
```bash
✅ "feat(jiangrou): 实现用户登录 API - TASK-001"
✅ "docs(guantang): 更新架构文档 - TASK-002"
❌ "update files" (太模糊)
❌ "fix stuff" (不明确)
```

---

## 🎯 第二步：权限边界检查 ⭐⭐⭐【核心】

### 2.1 酱肉 (后端工程师) 权限检查

**允许修改的范围:**
```yaml
✅ 自己的代码空间:
   - code/backend/**/*           # 后端代码
   - code/tests/backend/**/*     # 后端测试

✅ 自己的配置:
   - agent/workspace-jiangrou/**/*  # 酱肉工作区

✅ 文档中心:
   - agent/doc/**/*              # 统一知识库（技术文档）

❌ 禁止修改:
   - code/frontend/**/*          # 前端代码（豆沙负责）
   - code/deploy/**/*            # 部署脚本（酸菜负责）
   - agent/workspace-guantang/**/*  # PM 工作区
   - agent/workspace-dousha/**/*    # 前端工作区
   - agent/workspace-suancai/**/*   # 运维工作区
   - .lingma/**/*                # 鲜肉工作区（禁止）
```

**检查命令:**
```powershell
# 查看酱肉的修改文件
cd F:\openclaw\agent
git diff HEAD~1 HEAD --name-only | Select-String "jiangrou|backend"

# 检查是否有越权修改
$modifiedFiles = git diff HEAD~1 HEAD --name-only
foreach ($file in $modifiedFiles) {
    if ($file -like "code/frontend/*") {
        Write-Warning "⚠️ 酱肉越权修改前端代码：$file"
    }
    if ($file -like "code/deploy/*") {
        Write-Warning "⚠️ 酱肉越权修改部署脚本：$file"
    }
    if ($file -like "workspace-dousha/*") {
        Write-Warning "⚠️ 酱肉越权修改豆沙工作区：$file"
    }
    if ($file -like "workspace-suancai/*") {
        Write-Warning "⚠️ 酱肉越权修改酸菜工作区：$file"
    }
}
```

---

### 2.2 豆沙 (前端工程师) 权限检查

**允许修改的范围:**
```yaml
✅ 自己的代码空间:
   - code/frontend/**/*          # 前端代码
   - code/tests/frontend/**/*    # 前端测试

✅ 自己的配置:
   - agent/workspace-dousha/**/*  # 豆沙工作区

✅ 文档中心:
   - agent/doc/**/*              # 统一知识库（技术文档）

❌ 禁止修改:
   - code/backend/**/*           # 后端代码（酱肉负责）
   - code/deploy/**/*            # 部署脚本（酸菜负责）
   - agent/workspace-guantang/**/*  # PM 工作区
   - agent/workspace-jiangrou/**/*  # 后端工作区
   - agent/workspace-suancai/**/*   # 运维工作区
   - .lingma/**/*                # 鲜肉工作区（禁止）
```

**检查命令:**
```powershell
# 查看豆沙的修改文件
cd F:\openclaw\agent
git diff HEAD~1 HEAD --name-only | Select-String "dousha|frontend"

# 检查是否有越权修改
$modifiedFiles = git diff HEAD~1 HEAD --name-only
foreach ($file in $modifiedFiles) {
    if ($file -like "code/backend/*") {
        Write-Warning "⚠️ 豆沙越权修改后端代码：$file"
    }
    if ($file -like "code/deploy/*") {
        Write-Warning "⚠️ 豆沙越权修改部署脚本：$file"
    }
    if ($file -like "workspace-jiangrou/*") {
        Write-Warning "⚠️ 豆沙越权修改酱肉工作区：$file"
    }
    if ($file -like "workspace-suancai/*") {
        Write-Warning "⚠️ 豆沙越权修改酸菜工作区：$file"
    }
}
```

---

### 2.3 酸菜 (运维工程师) 权限检查

**允许修改的范围:**
```yaml
✅ 自己的代码空间:
   - code/deploy/**/*            # 部署脚本
   - code/tests/**/*             # 测试脚本（全部）

✅ 自己的配置:
   - agent/workspace-suancai/**/*  # 酸菜工作区

✅ 文档中心:
   - agent/doc/**/*              # 统一知识库（技术文档）

❌ 禁止修改:
   - code/backend/**/*           # 后端代码（酱肉负责）
   - code/frontend/**/*          # 前端代码（豆沙负责）
   - agent/workspace-guantang/**/*  # PM 工作区
   - agent/workspace-jiangrou/**/*  # 后端工作区
   - agent/workspace-dousha/**/*    # 前端工作区
   - .lingma/**/*                # 鲜肉工作区（禁止）
```

**检查命令:**
```powershell
# 查看酸菜的修改文件
cd F:\openclaw\agent
git diff HEAD~1 HEAD --name-only | Select-String "suancai|deploy|tests"

# 检查是否有越权修改
$modifiedFiles = git diff HEAD~1 HEAD --name-only
foreach ($file in $modifiedFiles) {
    if ($file -like "code/backend/*") {
        Write-Warning "⚠️ 酸菜越权修改后端代码：$file"
    }
    if ($file -like "code/frontend/*") {
        Write-Warning "⚠️ 酸菜越权修改前端代码：$file"
    }
    if ($file -like "workspace-jiangrou/*") {
        Write-Warning "⚠️ 酸菜越权修改酱肉工作区：$file"
    }
    if ($file -like "workspace-dousha/*") {
        Write-Warning "⚠️ 酸菜越权修改豆沙工作区：$file"
    }
}
```

---

### 2.4 灌汤 (PM) 权限检查

**允许修改的范围:**
```yaml
✅ 全局管理权限:
   - agent/**/*                  # 所有 Agent 配置和工作区
   - agent/doc/**/*              # 统一知识库
   - code/**/*                   # 代码目录（审核和整合）
   - workspace/**/*              # 临时工作文件

❌ 禁止修改:
   - C:\*                        # 系统盘（只读）
   - .lingma/**/*                # 鲜肉工作区（除非必要）
```

**注意:** 灌汤作为 PM，拥有最广泛的权限，但仍需遵守：
- 不随意修改 C 盘文件
- 尊重各 Agent 的专业领域
- 修改前通知相关 Agent

---

## 📦 第三步：交付物完整性检查

### 3.1 酱肉（后端）交付物检查

**标准交付清单:**
- [ ] **代码文件**
  - [ ] `code/backend/src/main/java/**/*.java` - Java 源代码
  - [ ] `code/backend/src/main/resources/**/*.yml` - 配置文件
  - [ ] `code/backend/pom.xml` - Maven 依赖（如有新增）

- [ ] **测试文件**
  - [ ] `code/tests/backend/**/*Test.java` - 单元测试
  - [ ] 测试覆盖率 ≥ 80%

- [ ] **文档文件**
  - [ ] `agent/doc/specs/03-technical-specs/api-*.md` - API 文档
  - [ ] `agent/workspace-jiangrou/logs/TASK-XXX-report.md` - 工作报告

- [ ] **质量要求**
  - [ ] 无编译错误
  - [ ] 通过 SonarQube 扫描（无 Blocker/Critical）
  - [ ] 方法复杂度 < 10
  - [ ] API 响应时间 < 200ms

---

### 3.2 豆沙（前端）交付物检查

**标准交付清单:**
- [ ] **代码文件**
  - [ ] `code/frontend/src/components/**/*.vue` - Vue 组件
  - [ ] `code/frontend/src/views/**/*.vue` - 页面视图
  - [ ] `code/frontend/src/composables/**/*.ts` - 组合式函数
  - [ ] `code/frontend/src/stores/**/*.ts` - 状态管理
  - [ ] `code/frontend/package.json` - NPM 依赖（如有新增）

- [ ] **测试文件**
  - [ ] `code/tests/frontend/**/*.spec.ts` - 组件测试
  - [ ] 测试覆盖率 ≥ 80%

- [ ] **文档文件**
  - [ ] `agent/doc/specs/03-technical-specs/ui-*.md` - UI 规范
  - [ ] `agent/workspace-dousha/logs/TASK-XXX-report.md` - 工作报告

- [ ] **质量要求**
  - [ ] 无 TypeScript 编译错误
  - [ ] ESLint 扫描通过
  - [ ] 页面加载时间 < 2 秒
  - [ ] 响应式设计适配

---

### 3.3 酸菜（运维）交付物检查

**标准交付清单:**
- [ ] **代码文件**
  - [ ] `code/deploy/**/*.ps1` - PowerShell 部署脚本
  - [ ] `code/deploy/**/*.sh` - Shell 脚本
  - [ ] `code/tests/**/*.test.*` - 自动化测试
  - [ ] `code/tests/**/*Test.java` - 集成测试

- [ ] **文档文件**
  - [ ] `agent/doc/guides/deployment-*.md` - 部署指南
  - [ ] `agent/doc/knowledge/03-devops/*.md` - 运维知识
  - [ ] `agent/workspace-suancai/logs/TASK-XXX-report.md` - 工作报告

- [ ] **质量要求**
  - [ ] 脚本可执行且无语法错误
  - [ ] 测试通过率 ≥ 95%
  - [ ] 部署时间 < 5 分钟
  - [ ] 监控告警配置完整

---

## 🔧 第四步：自动化检查脚本

### 4.1 完整检查脚本（PowerShell）

```powershell
# 工作报告审核自动化检查脚本
# 使用方法：.\check-work-report.ps1 -AgentName jiangrou -TaskId TASK-001

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('jiangrou', 'dousha', 'suancai')]
    [string]$AgentName,
    
    [Parameter(Mandatory=$true)]
    [string]$TaskId
)

$ErrorActionPreference = 'Stop'
$baseDir = "F:\openclaw\agent"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  工作报告审核检查 - $AgentName - $TaskId" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 切换到 agent 目录
Set-Location $baseDir

# 1. 获取最近一次提交
Write-Host "[1/4] 检查 Git 提交..." -ForegroundColor Yellow
$lastCommit = git log --oneline -1 --author="$AgentName"
if ($lastCommit) {
    Write-Host "✅ 找到提交记录：$lastCommit" -ForegroundColor Green
} else {
    Write-Host "❌ 未找到提交记录" -ForegroundColor Red
    exit 1
}

# 2. 获取修改的文件列表
Write-Host "`n[2/4] 分析修改的文件..." -ForegroundColor Yellow
$modifiedFiles = git diff HEAD~1 HEAD --name-only
Write-Host "修改了 $($modifiedFiles.Count) 个文件:" -ForegroundColor White
$modifiedFiles | ForEach-Object { Write-Host "  - $_" }

# 3. 权限边界检查
Write-Host "`n[3/4] 检查权限边界..." -ForegroundColor Yellow
$violations = @()

switch ($AgentName) {
    'jiangrou' {
        # 酱肉不应该修改的文件
        $forbidden = @('code/frontend', 'code/deploy', 'workspace-dousha', 'workspace-suancai')
    }
    'dousha' {
        # 豆沙不应该修改的文件
        $forbidden = @('code/backend', 'code/deploy', 'workspace-jiangrou', 'workspace-suancai')
    }
    'suancai' {
        # 酸菜不应该修改的文件
        $forbidden = @('code/backend', 'code/frontend', 'workspace-jiangrou', 'workspace-dousha')
    }
}

foreach ($file in $modifiedFiles) {
    foreach ($pattern in $forbidden) {
        if ($file -like "$pattern/*") {
            $violations += "⚠️ 越权修改：$file (属于 $pattern)"
        }
    }
}

if ($violations.Count -gt 0) {
    Write-Host "`n❌ 发现权限违规:" -ForegroundColor Red
    $violations | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
    exit 1
} else {
    Write-Host "✅ 未发现越权修改" -ForegroundColor Green
}

# 4. 交付物完整性检查
Write-Host "`n[4/4] 检查交付物完整性..." -ForegroundColor Yellow

switch ($AgentName) {
    'jiangrou' {
        $expected = @('code/backend', 'code/tests/backend')
        $hasCode = $modifiedFiles | Where-Object { $_ -like 'code/backend/*' }
        $hasTest = $modifiedFiles | Where-Object { $_ -like 'code/tests/backend/*' }
        $hasDoc = $modifiedFiles | Where-Object { $_ -like 'agent/doc/*' -or $_ -like "workspace-jiangrou/logs/*" }
    }
    'dousha' {
        $expected = @('code/frontend', 'code/tests/frontend')
        $hasCode = $modifiedFiles | Where-Object { $_ -like 'code/frontend/*' }
        $hasTest = $modifiedFiles | Where-Object { $_ -like 'code/tests/frontend/*' }
        $hasDoc = $modifiedFiles | Where-Object { $_ -like 'agent/doc/*' -or $_ -like "workspace-dousha/logs/*" }
    }
    'suancai' {
        $expected = @('code/deploy', 'code/tests')
        $hasCode = $modifiedFiles | Where-Object { $_ -like 'code/deploy/*' -or $_ -like 'code/tests/*' }
        $hasTest = $hasCode  # 测试即交付物
        $hasDoc = $modifiedFiles | Where-Object { $_ -like 'agent/doc/*' -or $_ -like "workspace-suancai/logs/*" }
    }
}

$score = 0
$total = 3

if ($hasCode) { Write-Host "✅ 包含代码文件" -ForegroundColor Green; $score++ } 
else { Write-Host "❌ 缺少代码文件" -ForegroundColor Red }

if ($hasTest) { Write-Host "✅ 包含测试文件" -ForegroundColor Green; $score++ } 
else { Write-Host "❌ 缺少测试文件" -ForegroundColor Red }

if ($hasDoc) { Write-Host "✅ 包含文档/日志" -ForegroundColor Green; $score++ } 
else { Write-Host "❌ 缺少文档/日志" -ForegroundColor Red }

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  审核结果：$score / $total" -ForegroundColor $(if($score -eq $total){'Green'}else{'Yellow'})
Write-Host "========================================" -ForegroundColor Cyan

if ($score -eq $total) {
    Write-Host "✅ 通过审核！可以接受交付。" -ForegroundColor Green
    exit 0
} else {
    Write-Host "⚠️ 需要补充材料后重新提交。" -ForegroundColor Yellow
    exit 1
}
```

---

## 📝 第五步：人工复核要点

### 5.1 代码质量复核

**后端代码（酱肉）:**
- [ ] RESTful API 设计规范
- [ ] 数据库查询优化（索引、避免 N+1）
- [ ] 异常处理完善
- [ ] 日志记录完整
- [ ] 安全加固（SQL 注入、XSS 防护）

**前端代码（豆沙）:**
- [ ] 组件化设计合理
- [ ] 状态管理规范
- [ ] 错误处理友好
- [ ] 响应式布局正确
- [ ] 性能优化（懒加载、缓存）

**运维脚本（酸菜）:**
- [ ] 脚本幂等性
- [ ] 错误处理健壮
- [ ] 日志输出清晰
- [ ] 回滚方案完备
- [ ] 监控告警配置

---

### 5.2 文档质量复核

**API 文档检查:**
- [ ] 接口路径清晰
- [ ] 请求参数完整
- [ ] 响应示例准确
- [ ] 错误码说明详细

**技术文档检查:**
- [ ] 架构图清晰
- [ ] 流程图准确
- [ ] 专业术语规范
- [ ] 引用来源标注

**工作报告检查:**
- [ ] 任务目标明确
- [ ] 完成情况具体
- [ ] 遇到的问题及解决方案
- [ ] 下一步计划

---

## 🚨 第六步：问题处理流程

### 6.1 发现越权修改

**处理流程:**
1. **立即叫停** - 暂停接受该交付物
2. **通知作者** - 通过 Gateway 发送消息给对应 Agent
3. **说明问题** - 明确指出越权修改的文件
4. **指导修正** - 告知正确的修改范围
5. **重新提交** - Agent 修正后重新提交
6. **再次审核** - 重新执行本检查清单

**通知模板:**
```markdown
@{Agent 名称} 你好，

你的工作报告已收到，但在审核中发现以下问题：

**问题:** 越权修改了不属于你职责范围的文件
- 文件路径：{文件路径}
- 违反规则：{具体规则}

**正确做法:**
- 你应该只修改：{允许的范围}
- 如需修改其他文件，请先联系我协调

请修正后重新提交。

灌汤 (PM)
```

---

### 6.2 发现误改同事代码

**处理流程:**
1. **记录问题** - 详细记录误改的文件和影响
2. **通知双方** - 同时通知作者和被误改的同事
3. **评估影响** - 判断是否需要回滚
4. **协调修复** - 安排相关人员修复
5. **记录案例** - 作为团队知识库保存

**通知模板:**
```markdown
@{Agent 名称 A} 和 @{Agent 名称 B} 你们好，

发现一起代码误改事件：

**情况:**
- 误改者：{Agent A}
- 受影响者：{Agent B}
- 误改文件：{文件路径}
- 影响程度：{轻微/中等/严重}

**处理方案:**
1. {Agent A} 立即回滚误改
2. {Agent B} 确认回滚是否正确
3. 双方确认无误后继续工作

请知悉并配合。

灌汤 (PM)
```

---

## 📊 第七步：审核记录归档

### 7.1 审核报告模板

```markdown
<!-- Last Modified: {日期} -->

# 工作报告审核报告

**任务编号:** TASK-XXX  
**执行 Agent:** {Agent 名称}  
**审核人:** 灌汤  
**审核时间:** {日期时间}  

---

## 审核结果

**总体评分:** ⭐⭐⭐⭐⭐ (5/5)  
**审核状态:** ✅ 通过 / ⚠️ 有条件通过 / ❌ 驳回

---

## 检查项目

### 1. Git 提交检查
- [x] 提交信息清晰
- [x] 提交时间合理
- [x] 提交文件数量正常

### 2. 权限边界检查
- [x] 未越权修改禁止的文件
- [x] 未误改其他同事代码
- [x] 遵守职责分工

### 3. 交付物完整性
- [x] 代码文件完整
- [x] 测试文件完整
- [x] 文档文件完整

### 4. 代码质量
- [x] 符合编码规范
- [x] 测试覆盖率达标
- [x] 性能指标合格

---

## 发现问题

**问题数量:** 0 个

（如有问题，详细列出）

---

## 改进建议

（如有，提供改进建议）

---

## 结论

{总结性评价}

---

**下次审核重点:**
- {需要特别关注的方面}
```

---

### 7.2 归档位置

**审核报告保存路径:**
```
agent/workspace-guantang/logs/audit-reports/
├── TASK-001-jiangrou-audit-20260311.md
├── TASK-002-dousha-audit-20260311.md
└── TASK-003-suancai-audit-20260311.md
```

**归档要求:**
- 文件名格式：`TASK-XXX-{agent}-audit-YYYYMMDD.md`
- 每次审核后 24 小时内归档
- 永久保存，作为团队历史

---

## 🎯 快速参考卡片

### 权限速查表

| Agent | 可修改代码 | 可修改配置 | 可修改文档 | 禁止修改 |
|-------|-----------|-----------|-----------|---------|
| **酱肉** | backend, tests/backend | workspace-jiangrou | doc | frontend, deploy, 其他 workspace |
| **豆沙** | frontend, tests/frontend | workspace-dousha | doc | backend, deploy, 其他 workspace |
| **酸菜** | deploy, tests | workspace-suancai | doc | backend, frontend, 其他 workspace |
| **灌汤** | 全部（审核） | 全部 | 全部 | C 盘，.lingma（非必要） |

---

### 常见违规案例

**案例 1:** 酱肉修改了前端 CSS 样式
- ❌ 违规：`code/frontend/src/assets/css/style.css`
- ✅ 正确：应通知豆沙修改

**案例 2:** 豆沙修改了后端 API 路由
- ❌ 违规：`code/backend/src/main/java/controller/UserController.java`
- ✅ 正确：应通知酱肉修改

**案例 3:** 酸菜直接修改了业务代码
- ❌ 违规：`code/backend/src/main/java/service/UserService.java`
- ✅ 正确：应只修改部署脚本和测试

---

## 📞 联系方式

如有疑问，请通过以下方式联系灌汤（PM）：

- **Gateway 消息:** 直接在对话中提问
- **工作区留言:** `workspace-guantang/tasks/inbox/`
- **紧急事项:** 标记为高优先级

---

**最后更新:** 2026-03-11  
**维护者:** 灌汤 (PM)  
**版本:** 1.0
