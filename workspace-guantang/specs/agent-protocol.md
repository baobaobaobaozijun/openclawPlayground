<!-- Last Modified: 2026-03-08 -->
<!-- Last Modified (CN): 2026-03-08 -->

# Agent-to-Agent 閫氫俊鍗忚锛堣交閲忕増锛?

## 鍗忚姒傝堪

閽堝涓汉鍗氬椤圭洰鐨勮交閲忕骇 Agent 鍗忎綔鍗忚銆傞噰鐢ㄧ畝鍖栫殑鍑芥暟璋冪敤鏂瑰紡锛岄伩鍏嶉噸閲忕骇鐨?JSON-RPC 2.0銆?

## 閫氫俊鏂瑰紡

### 浼犺緭灞?
- **鍗忚**: 绠€鍖?RPC锛堝熀浜庢枃浠剁郴缁燂級
- **浼犺緭**: 鏈湴鏂囦欢鍏变韩
- **璁よ瘉**: Agent 韬唤鏍囪瘑
- **鍔犲瘑**: 涓嶉渶瑕侊紙鏈湴閫氫俊锛?

### 娑堟伅鏍煎紡

```json
{
  "from": "鐏屾堡",
  "to": "閰辫倝",
  "action": "allocateTask",
  "data": {},
  "timestamp": "2026-03-07T10:30:00Z"
}
```

## 鏍稿績鎺ュ彛瀹氫箟

### 1. 浠诲姟鍒嗗彂鎺ュ彛

**鎺ュ彛鍚嶇О:** `allocateTask`

**鐢ㄩ€?** 鐏屾堡鍚戝叾浠?Agent 鍒嗛厤宸ヤ綔浠诲姟

**璇锋眰鏍煎紡:**

```json
{
  "from": "鐏屾堡",
  "to": "閰辫倝",
  "action": "allocateTask",
  "data": {
    "project_id": "BLOG_20260307_001",
    "task_id": "TASK_20260307_001",
    "task_name": "鍗氬鍚庣 API 寮€鍙?,
    "description": "瀹炵幇鐢ㄦ埛璁よ瘉鍜屾枃绔犵鐞?API",
    "priority": "high",
    "estimated_effort": "2 浜郝峰ぉ",
    "due_date": "2026-03-09",
    "deliverables": [
      {
        "name": "API 浠ｇ爜",
        "path": "F:\\openclaw\\code\\backend\\api\\"
      }
    ]
  },
  "timestamp": "2026-03-07T10:30:00Z"
}
```

**鍝嶅簲鏍煎紡:**

```json
{
  "from": "閰辫倝",
  "to": "鐏屾堡",
  "action": "acknowledgeTask",
  "data": {
    "task_id": "TASK_20260307_001",
    "status": "accepted",
    "estimated_start": "2026-03-07",
    "notes": "宸叉帴鏀朵换鍔★紝鎸夋椂寮€濮?
  },
  "timestamp": "2026-03-07T10:35:00Z"
}
```

### 2. 杩涘害鏌ヨ鎺ュ彛

**鎺ュ彛鍚嶇О:** `queryProgress`

**鐢ㄩ€?** 鐏屾堡鏌ヨ鍏朵粬 Agent 鐨勪换鍔¤繘搴?

**璇锋眰鏍煎紡:**

```json
{
  "from": "鐏屾堡",
  "to": "閰辫倝",
  "action": "queryProgress",
  "data": {
    "project_id": "BLOG_20260307_001",
    "task_ids": ["TASK_20260307_001"]
  },
  "timestamp": "2026-03-07T14:00:00Z"
}
```

**鍝嶅簲鏍煎紡:**

```json
{
  "from": "閰辫倝",
  "to": "鐏屾堡",
  "action": "progressReport",
  "data": {
    "task_id": "TASK_20260307_001",
    "current_status": "in_progress",
    "progress_percentage": 60,
    "completed_work": "瀹屾垚鐢ㄦ埛璁よ瘉妯″潡",
    "remaining_work": "鏂囩珷绠＄悊妯″潡寮€鍙戜腑",
    "blockers": [],
    "last_update": "2026-03-07T14:00:00Z"
  },
  "timestamp": "2026-03-07T14:05:00Z"
}
```

### 3. 闂鎶ュ憡鎺ュ彛

**鎺ュ彛鍚嶇О:** `reportIssue`

**鐢ㄩ€?** 鍏朵粬 Agent 鍚戠亴姹ゆ姤鍛婇亣鍒扮殑闂

**璇锋眰鏍煎紡:**

```json
{
  "from": "閰辫倝",
  "to": "鐏屾堡",
  "action": "reportIssue",
  "data": {
    "task_id": "TASK_20260307_001",
    "issue_type": "technical",
    "severity": "medium",
    "title": "绗笁鏂逛緷璧栧啿绐?,
    "description": "JWT 搴撶増鏈笌鐜版湁妗嗘灦涓嶅吋瀹?,
    "proposed_solution": "闄嶇骇 JWT 搴撴垨鍗囩骇妗嗘灦",
    "requires_action": true
  },
  "timestamp": "2026-03-07T15:00:00Z"
}
```

**鍝嶅簲鏍煎紡:**

```json
{
  "from": "鐏屾堡",
  "to": "閰辫倝",
  "action": "issueAcknowledged",
  "data": {
    "issue_id": "ISSUE_20260307_001",
    "action_plan": "宸茶褰曪紝鏄庡ぉ璁ㄨ瑙ｅ喅鏂规",
    "next_review": "2026-03-08T10:00:00Z"
  },
  "timestamp": "2026-03-07T15:10:00Z"
}
```

### 4. 浜や粯鐗╂彁浜ゆ帴鍙?

**鎺ュ彛鍚嶇О:** `submitDeliverable`

**鐢ㄩ€?** 鍏朵粬 Agent 鍚戠亴姹ゆ彁浜ゅ畬鎴愮殑浜や粯鐗?

**璇锋眰鏍煎紡:**

```json
{
  "from": "閰辫倝",
  "to": "鐏屾堡",
  "action": "submitDeliverable",
  "data": {
    "task_id": "TASK_20260307_001",
    "deliverables": [
      {
        "name": "鐢ㄦ埛璁よ瘉 API",
        "type": "code",
        "path": "F:\\openclaw\\code\\backend\\api\\auth.py",
        "version": "1.0.0",
        "status": "ready_for_review"
      }
    ],
    "completion_status": "completed",
    "ready_for_testing": true
  },
  "timestamp": "2026-03-07T17:00:00Z"
}
```

**鍝嶅簲鏍煎紡:**

```json
{
  "from": "鐏屾堡",
  "to": "閰辫倝",
  "action": "deliverableReceived",
  "data": {
    "deliverable_id": "DEL_20260307_001",
    "status": "accepted",
    "next_step": "杞氦閰歌彍娴嬭瘯",
    "feedback": "浠ｇ爜璐ㄩ噺鑹ソ"
  },
  "timestamp": "2026-03-07T17:10:00Z"
}
```

## 閿欒澶勭悊

| 閿欒鐮?| 璇存槑 |
|--------|------|
| ERR_001 | Agent 涓嶅彲鐢?|
| ERR_002 | 浠诲姟涓嶅瓨鍦?|
| ERR_003 | 鏉冮檺涓嶈冻 |
| ERR_004 | 璧勬簮涓嶈冻 |
| ERR_005 | 鏂囦欢鏍煎紡閿欒 |

## 瓒呮椂璁剧疆

- **浠诲姟鍒嗗彂璇锋眰瓒呮椂:** 5 绉?
- **杩涘害鏌ヨ璇锋眰瓒呮椂:** 3 绉?
- **闂鎶ュ憡璇锋眰瓒呮椂:** 2 绉?
- **浜や粯鐗╂彁浜よ姹傝秴鏃?** 5 绉?

## 閲嶈瘯鏈哄埗

濡傛灉 Agent 鏃犲搷搴旓細
- 绗竴娆￠噸璇曪細5 绉掑悗
- 绗簩娆￠噸璇曪細10 绉掑悗
- 绗笁娆￠噸璇曪細30 绉掑悗
- 濡備粛澶辫触锛岃褰曟棩蹇楀苟绛夊緟涓嬫蹇冭烦

