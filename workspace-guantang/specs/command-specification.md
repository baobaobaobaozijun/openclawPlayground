<!-- Last Modified: 2026-03-08 -->
<!-- Last Modified (CN): 2026-03-08 -->

# 鍛戒护瑙勮寖锛堣交閲忕増锛?

## 鍛戒护鍒嗙被

### 1. 椤圭洰绠＄悊鍛戒护

#### 鍒涘缓鏂伴」鐩?

**COMMAND:** `CreateProject`  
**SYNTAX:** 
``bash
create_project --name "椤圭洰鍚嶇О" --description "鎻忚堪"
```

**鍙傛暟璇存槑:**
- `--name` 椤圭洰鍚嶇О (蹇呴渶)
- `--description` 椤圭洰鎻忚堪 (蹇呴渶)
- `--start_date` 寮€濮嬫棩鏈?(鍙€夛紝榛樿浠婂ぉ)

**绀轰緥:**
```bash
create_project --name "涓汉鍗氬绯荤粺" --description "鍩轰簬 Python 鐨勪釜浜哄崥瀹?
```

**杈撳嚭:**
```
Project created successfully
Project ID: BLOG_20260307_001
Location: F:\openclaw\workspace\projects\BLOG_20260307_001\
```

#### 鏌ョ湅椤圭洰淇℃伅

**COMMAND:** `ViewProject`  
**SYNTAX:** 
```bash
view_project --project_id "PROJECT_ID"
```

**鍙傛暟璇存槑:**
- `--project_id` 椤圭洰 ID (蹇呴渶)

**绀轰緥:**
```bash
view_project --project_id "BLOG_20260307_001"
```

**杈撳嚭:**
```
椤圭洰鍚嶇О锛氫釜浜哄崥瀹㈢郴缁?
椤圭洰 ID: BLOG_20260307_001
鐘舵€侊細Active
寮€濮嬫棩鏈燂細2026-03-07
褰撳墠杩涘害锛?2%
```

#### 鍒楄〃椤圭洰

**COMMAND:** `ListProjects`  
**SYNTAX:** 
```bash
list_projects [--status "status"] [--limit number]
```

**鍙傛暟璇存槑:**
- `--status` 椤圭洰鐘舵€侊細active|completed (鍙€?
- `--limit` 鏈€澶氭樉绀烘暟閲?(鍙€夛紝榛樿 10)

**绀轰緥:**
```bash
list_projects --status "active" --limit 5
```

**杈撳嚭:**
```
Project List (1 projects):

BLOG_20260307_001 | 涓汉鍗氬绯荤粺 | Active | 32%
```

### 2. 浠诲姟绠＄悊鍛戒护

#### 鍒涘缓浠诲姟

**COMMAND:** `CreateTask`  
**SYNTAX:** 
```bash
create_task --project_id "PROJECT_ID" --task_name "鍚嶇О" --assignee "Agent 鍚嶇О"
```

**鍙傛暟璇存槑:**
- `--project_id` 椤圭洰 ID (蹇呴渶)
- `--task_name` 浠诲姟鍚嶇О (蹇呴渶)
- `--assignee` 鍒嗛厤缁?(蹇呴渶锛氶叡鑲?| 璞嗘矙 | 閰歌彍)
- `--priority` 浼樺厛绾?(鍙€夛細high|medium|low锛岄粯璁?medium)
- `--due_date` 鎴鏃ユ湡 (鍙€?

**绀轰緥:**
```bash
create_task --project_id "BLOG_20260307_001" \
            --task_name "鐢ㄦ埛璁よ瘉 API" \
            --assignee "閰辫倝" \
            --priority "high" \
            --due_date "2026-03-09"
```

**杈撳嚭:**
```
Task created successfully
Task ID: TASK_20260307_001
Assigned to: 閰辫倝
Status: pending_assignment
```

#### 鏇存柊浠诲姟鐘舵€?

**COMMAND:** `UpdateTaskStatus`  
**SYNTAX:** 
```bash
update_task_status --task_id "TASK_ID" --status "new_status"
```

**鍙傛暟璇存槑:**
- `--task_id` 浠诲姟 ID (蹇呴渶)
- `--status` 鏂扮姸鎬?(蹇呴渶锛歱ending|in_progress|completed|blocked)

**绀轰緥:**
```bash
update_task_status --task_id "TASK_20260307_001" --status "in_progress"
```

**杈撳嚭:**
```
Task status updated successfully
TASK_20260307_001: in_progress
Updated at: 2026-03-07T10:35:00Z
```

#### 鏌ヨ浠诲姟杩涘害

**COMMAND:** `QueryTaskProgress`  
**SYNTAX:** 
```bash
query_task_progress --project_id "PROJECT_ID" [--assignee "Agent 鍚嶇О"]
```

**鍙傛暟璇存槑:**
- `--project_id` 椤圭洰 ID (蹇呴渶)
- `--assignee` Agent 鍚嶇О杩囨护 (鍙€?

**绀轰緥:**
```bash
query_task_progress --project_id "BLOG_20260307_001" --assignee "閰辫倝"
```

**杈撳嚭:**
```
Task Progress Report:
Project: BLOG_20260307_001
Agent: 閰辫倝
Total Tasks: 4
Completed: 1
In Progress: 2
Blocked: 1
Progress: 50%
```

### 3. 鏃ュ織鍜屾姤鍛婂懡浠?

#### 鐢熸垚鏃ユ姤

**COMMAND:** `GenerateDailyReport`  
**SYNTAX:** 
```bash
generate_daily_report --project_id "PROJECT_ID" [--date "YYYY-MM-DD"]
```

**鍙傛暟璇存槑:**
- `--project_id` 椤圭洰 ID (蹇呴渶)
- `--date` 鎶ュ憡鏃ユ湡 (鍙€夛紝榛樿浠婂ぉ)

**绀轰緥:**
```bash
generate_daily_report --project_id "BLOG_20260307_001"
```

**杈撳嚭:**
```
Daily Report Generated
File: F:\openclaw\workspace\projects\BLOG_20260307_001\progress\daily_reports\daily_20260307.md
```

#### 鐢熸垚鍛ㄦ姤

**COMMAND:** `GenerateWeeklyReport`  
**SYNTAX:** 
```bash
generate_weekly_report --project_id "PROJECT_ID"
```

**鍙傛暟璇存槑:**
- `--project_id` 椤圭洰 ID (蹇呴渶)

**绀轰緥:**
```bash
generate_weekly_report --project_id "BLOG_20260307_001"
```

**杈撳嚭:**
```
Weekly Report Generated
File: F:\openclaw\workspace\projects\BLOG_20260307_001\progress\weekly_summaries\weekly_W10.md
```

### 4. Agent 閫氫俊鍛戒护

#### 璋冪敤 Agent

**COMMAND:** `InvokeAgent`  
**SYNTAX:** 
```bash
invoke_agent --agent_name "Agent 鍚嶇О" --action "鎿嶄綔" --data "JSON 鏁版嵁"
```

**鍙傛暟璇存槑:**
- `--agent_name` Agent 鍚嶇О (蹇呴渶锛氶叡鑲?| 璞嗘矙 | 閰歌彍)
- `--action` 鎿嶄綔绫诲瀷 (蹇呴渶锛歛llocateTask|queryProgress|reportIssue 绛?
- `--data` 鎿嶄綔鏁版嵁 (JSON 鏍煎紡锛屽繀闇€)

**绀轰緥:**
```bash
invoke_agent --agent_name "閰辫倝" --action "allocateTask" \
             --data '{"task_id":"TASK_001","priority":"high"}'
```

**杈撳嚭:**
```
Agent invocation sent
Request ID: req_20260307_001
Status: pending
Timeout: 5 seconds
```

#### 鏌ヨ Agent 鐘舵€?

**COMMAND:** `QueryAgentStatus`  
**SYNTAX:** 
```bash
query_agent_status --agent_name "Agent 鍚嶇О"
```

**鍙傛暟璇存槑:**
- `--agent_name` Agent 鍚嶇О (蹇呴渶)

**绀轰緥:**
```bash
query_agent_status --agent_name "閰辫倝"
```

**杈撳嚭:**
```
Agent Status:
Name: 閰辫倝
Status: online
Last Activity: 2026-03-07T14:00:00Z
Active Tasks: 2
Load: 60%
```

### 5. 鍗氬闆嗘垚鍛戒护

#### 鎻愪氦鏃ュ織鍒板崥瀹?

**COMMAND:** `SubmitLogToBlog`  
**SYNTAX:** 
```bash
submit_log_to_blog --date "YYYY-MM-DD" --status "draft|published"
```

**鍙傛暟璇存槑:**
- `--date` 鏃ュ織鏃ユ湡 (蹇呴渶)
- `--status` 鍙戝竷鐘舵€?(鍙€夛紝榛樿 draft)

**绀轰緥:**
```bash
submit_log_to_blog --date "2026-03-07" --status "published"
```

**杈撳嚭:**
```
Log submitted to blog
Article ID: ART_20260307_001
URL: https://yourblog.com/posts/ART_20260307_001
Status: published
```

## 鍛戒护鎵ц瑙勮寖

### 鎵ц娴佺▼

``yaml
杈撳叆鍛戒护:
  1. 楠岃瘉鍛戒护璇硶
  2. 楠岃瘉鍙傛暟鏈夋晥鎬?
  3. 妫€鏌ユ潈闄?
  4. 鎵ц鎿嶄綔
  5. 璁板綍鏃ュ織
  6. 杩斿洖缁撴灉
```

### 閿欒澶勭悊

**閿欒鍒嗙被:**
- 璇硶閿欒锛氬懡浠ゆ牸寮忎笉姝ｇ‘
- 鍙傛暟閿欒锛氬弬鏁版棤鏁堟垨缂哄け
- 鏉冮檺閿欒锛氭棤鎵ц鏉冮檺
- 鎵ц閿欒锛氭搷浣滃け璐?

**澶勭悊鏂瑰紡:**
- 璇硶閿欒 鈫?鏄剧ず姝ｇ‘鐨勫懡浠ゆ牸寮?
- 鍙傛暟閿欒 鈫?鎻愮ず姝ｇ‘鐨勫弬鏁版牸寮?
- 鏉冮檺閿欒 鈫?寤鸿鐢宠鏉冮檺
- 鎵ц閿欒 鈫?鏄剧ず璇︾粏閿欒淇℃伅

