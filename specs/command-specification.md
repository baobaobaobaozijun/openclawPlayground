# 命令规范（轻量版）

## 命令分类

### 1. 项目管理命令

#### 创建新项目

**COMMAND:** `CreateProject`  
**SYNTAX:** 
``bash
create_project --name "项目名称" --description "描述"
```

**参数说明:**
- `--name` 项目名称 (必需)
- `--description` 项目描述 (必需)
- `--start_date` 开始日期 (可选，默认今天)

**示例:**
```bash
create_project --name "个人博客系统" --description "基于 Python 的个人博客"
```

**输出:**
```
Project created successfully
Project ID: BLOG_20260307_001
Location: F:\openclaw\workspace\projects\BLOG_20260307_001\
```

#### 查看项目信息

**COMMAND:** `ViewProject`  
**SYNTAX:** 
```bash
view_project --project_id "PROJECT_ID"
```

**参数说明:**
- `--project_id` 项目 ID (必需)

**示例:**
```bash
view_project --project_id "BLOG_20260307_001"
```

**输出:**
```
项目名称：个人博客系统
项目 ID: BLOG_20260307_001
状态：Active
开始日期：2026-03-07
当前进度：32%
```

#### 列表项目

**COMMAND:** `ListProjects`  
**SYNTAX:** 
```bash
list_projects [--status "status"] [--limit number]
```

**参数说明:**
- `--status` 项目状态：active|completed (可选)
- `--limit` 最多显示数量 (可选，默认 10)

**示例:**
```bash
list_projects --status "active" --limit 5
```

**输出:**
```
Project List (1 projects):

BLOG_20260307_001 | 个人博客系统 | Active | 32%
```

### 2. 任务管理命令

#### 创建任务

**COMMAND:** `CreateTask`  
**SYNTAX:** 
```bash
create_task --project_id "PROJECT_ID" --task_name "名称" --assignee "Agent 名称"
```

**参数说明:**
- `--project_id` 项目 ID (必需)
- `--task_name` 任务名称 (必需)
- `--assignee` 分配给 (必需：酱肉 | 豆沙 | 酸菜)
- `--priority` 优先级 (可选：high|medium|low，默认 medium)
- `--due_date` 截止日期 (可选)

**示例:**
```bash
create_task --project_id "BLOG_20260307_001" \
            --task_name "用户认证 API" \
            --assignee "酱肉" \
            --priority "high" \
            --due_date "2026-03-09"
```

**输出:**
```
Task created successfully
Task ID: TASK_20260307_001
Assigned to: 酱肉
Status: pending_assignment
```

#### 更新任务状态

**COMMAND:** `UpdateTaskStatus`  
**SYNTAX:** 
```bash
update_task_status --task_id "TASK_ID" --status "new_status"
```

**参数说明:**
- `--task_id` 任务 ID (必需)
- `--status` 新状态 (必需：pending|in_progress|completed|blocked)

**示例:**
```bash
update_task_status --task_id "TASK_20260307_001" --status "in_progress"
```

**输出:**
```
Task status updated successfully
TASK_20260307_001: in_progress
Updated at: 2026-03-07T10:35:00Z
```

#### 查询任务进度

**COMMAND:** `QueryTaskProgress`  
**SYNTAX:** 
```bash
query_task_progress --project_id "PROJECT_ID" [--assignee "Agent 名称"]
```

**参数说明:**
- `--project_id` 项目 ID (必需)
- `--assignee` Agent 名称过滤 (可选)

**示例:**
```bash
query_task_progress --project_id "BLOG_20260307_001" --assignee "酱肉"
```

**输出:**
```
Task Progress Report:
Project: BLOG_20260307_001
Agent: 酱肉
Total Tasks: 4
Completed: 1
In Progress: 2
Blocked: 1
Progress: 50%
```

### 3. 日志和报告命令

#### 生成日报

**COMMAND:** `GenerateDailyReport`  
**SYNTAX:** 
```bash
generate_daily_report --project_id "PROJECT_ID" [--date "YYYY-MM-DD"]
```

**参数说明:**
- `--project_id` 项目 ID (必需)
- `--date` 报告日期 (可选，默认今天)

**示例:**
```bash
generate_daily_report --project_id "BLOG_20260307_001"
```

**输出:**
```
Daily Report Generated
File: F:\openclaw\workspace\projects\BLOG_20260307_001\progress\daily_reports\daily_20260307.md
```

#### 生成周报

**COMMAND:** `GenerateWeeklyReport`  
**SYNTAX:** 
```bash
generate_weekly_report --project_id "PROJECT_ID"
```

**参数说明:**
- `--project_id` 项目 ID (必需)

**示例:**
```bash
generate_weekly_report --project_id "BLOG_20260307_001"
```

**输出:**
```
Weekly Report Generated
File: F:\openclaw\workspace\projects\BLOG_20260307_001\progress\weekly_summaries\weekly_W10.md
```

### 4. Agent 通信命令

#### 调用 Agent

**COMMAND:** `InvokeAgent`  
**SYNTAX:** 
```bash
invoke_agent --agent_name "Agent 名称" --action "操作" --data "JSON 数据"
```

**参数说明:**
- `--agent_name` Agent 名称 (必需：酱肉 | 豆沙 | 酸菜)
- `--action` 操作类型 (必需：allocateTask|queryProgress|reportIssue 等)
- `--data` 操作数据 (JSON 格式，必需)

**示例:**
```bash
invoke_agent --agent_name "酱肉" --action "allocateTask" \
             --data '{"task_id":"TASK_001","priority":"high"}'
```

**输出:**
```
Agent invocation sent
Request ID: req_20260307_001
Status: pending
Timeout: 5 seconds
```

#### 查询 Agent 状态

**COMMAND:** `QueryAgentStatus`  
**SYNTAX:** 
```bash
query_agent_status --agent_name "Agent 名称"
```

**参数说明:**
- `--agent_name` Agent 名称 (必需)

**示例:**
```bash
query_agent_status --agent_name "酱肉"
```

**输出:**
```
Agent Status:
Name: 酱肉
Status: online
Last Activity: 2026-03-07T14:00:00Z
Active Tasks: 2
Load: 60%
```

### 5. 博客集成命令

#### 提交日志到博客

**COMMAND:** `SubmitLogToBlog`  
**SYNTAX:** 
```bash
submit_log_to_blog --date "YYYY-MM-DD" --status "draft|published"
```

**参数说明:**
- `--date` 日志日期 (必需)
- `--status` 发布状态 (可选，默认 draft)

**示例:**
```bash
submit_log_to_blog --date "2026-03-07" --status "published"
```

**输出:**
```
Log submitted to blog
Article ID: ART_20260307_001
URL: https://yourblog.com/posts/ART_20260307_001
Status: published
```

## 命令执行规范

### 执行流程

``yaml
输入命令:
  1. 验证命令语法
  2. 验证参数有效性
  3. 检查权限
  4. 执行操作
  5. 记录日志
  6. 返回结果
```

### 错误处理

**错误分类:**
- 语法错误：命令格式不正确
- 参数错误：参数无效或缺失
- 权限错误：无执行权限
- 执行错误：操作失败

**处理方式:**
- 语法错误 → 显示正确的命令格式
- 参数错误 → 提示正确的参数格式
- 权限错误 → 建议申请权限
- 执行错误 → 显示详细错误信息
