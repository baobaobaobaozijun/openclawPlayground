---
name: kanban-updater
description: "项目看板自动更新器。当用户询问进度/汇报/心跳检查时，自动扫描文件系统验证任务完成状态并更新看板。"
metadata:
  openclaw:
    emoji: "📊"
    requires:
      bins: ["git"]
---

# 项目看板自动更新器 (kanban-updater)

## 触发条件

**以下场景必须执行看板更新：**
1. 用户询问"进度"、"汇报"、"状态"、"看板"
2. 心跳检查（Cron 定时任务）
3. Agent 完成任务汇报后
4. PM 主动检查

## 看板位置

`F:\openclaw\agent\doc\05-progress\project-kanban.md`

## 更新流程

### 步骤 1: 文件验证扫描

**执行以下 PowerShell 脚本验证任务完成状态：**

```powershell
# 后端文件检查
$backendChecks = @{
  "backend-jar" = "F:\openclaw\code\backend\target\backend-1.0.0-SNAPSHOT.jar"
  "backend-schema" = "F:\openclaw\code\backend\scripts\schema.sql"
  "backend-CategoryController" = "F:\openclaw\code\backend\src\main\java\com\openclaw\controller\CategoryController.java"
  "backend-TagController" = "F:\openclaw\code\backend\src\main\java\com\openclaw\controller\TagController.java"
  "backend-CategoryService" = "F:\openclaw\code\backend\src\main\java\com\openclaw\service\CategoryService.java"
  "backend-TagService" = "F:\openclaw\code\backend\src\main\java\com\openclaw\service\TagService.java"
}

# 前端文件检查
$frontendChecks = @{
  "frontend-dist" = "F:\openclaw\code\frontend\dist\index.html"
  "frontend-ArticleCard" = "F:\openclaw\code\frontend\src\components\ArticleCard.vue"
  "frontend-breakpoints" = "F:\openclaw\code\frontend\src\assets\styles\breakpoints.css"
  "frontend-apiArticle" = "F:\openclaw\code\frontend\src\api\article.ts"
  "frontend-storeArticle" = "F:\openclaw\code\frontend\src\stores\article.ts"
  "frontend-authLoginDup" = "F:\openclaw\code\frontend\src\views\auth\LoginView.vue"
}

# 逐项检查
$all = $backendChecks + $frontendChecks
foreach ($k in $all.Keys | Sort-Object) {
  $e = Test-Path $all[$k]
  $s = if ($e) { "EXISTS" } else { "MISSING" }
  Write-Output "$s | $k"
}
```

### 步骤 2: Git 状态检查

```powershell
# 各仓库最新提交和未提交文件数
@("F:\openclaw\code\backend", "F:\openclaw\code\frontend", "F:\openclaw\code\deploy", "F:\openclaw\agent") | ForEach-Object {
  Set-Location $_
  $last = git log --oneline -1 2>$null
  $dirty = (git status --short 2>$null | Measure-Object).Count
  Write-Output "$_ | $last | dirty: $dirty"
}
```

### 步骤 3: 工作日志活跃度检查

```powershell
Set-Location F:\openclaw\agent
@("jiangrou","dousha","suancai") | ForEach-Object {
  $latest = Get-ChildItem "workinglog\$_" -Name | Sort-Object -Descending | Select-Object -First 1
  Write-Output "$_ | latest: $latest"
}
```

### 步骤 4: 更新看板文件

根据扫描结果，更新 `doc/05-progress/project-kanban.md` 中每个任务的状态：
- `done` = 文件 EXISTS 且已 push
- `todo` = 文件 MISSING
- `blocked` = 有依赖未满足
- `in-progress` = 有工作日志但文件未完成

**更新看板头部时间戳：**
```
**最后更新:** {当前时间}
```

### 步骤 5: 提交看板更新

```powershell
cd F:\openclaw\agent
git add doc/05-progress/project-kanban.md
git commit -m "docs: 更新项目看板 {时间}"
git push
```

## 看板格式规范

### 任务状态标记

| 标记 | 含义 | 说明 |
|------|------|------|
| `done` | 已完成 | 文件存在且已提交 |
| `in-progress` | 进行中 | 有工作日志但未完成 |
| `todo` | 待办 | 未开始 |
| `blocked` | 阻塞 | 有依赖未满足 |

### 进度计算

```
阶段进度 = 该阶段 done 任务数 / 该阶段总任务数 * 100%
总体进度 = 所有 done 任务数 / 所有任务总数 * 100%
```

## 注意事项

1. **不要依赖 Agent 自己说完成了** — 必须通过文件系统验证
2. **每次更新都要 git commit** — 看板历史可追溯
3. **阻塞问题要标注** — 谁阻塞了谁，便于协调
4. **Git 仓库状态要检查** — 确保代码已推送

---

*看板是项目的单一事实来源 📊*
