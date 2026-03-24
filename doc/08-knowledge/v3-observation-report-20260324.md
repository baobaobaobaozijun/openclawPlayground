# v3 Observation Report — 2026-03-24

**Observation Period:** 18:00 ~ 21:00 (3 hours)
**Author:** Guantang (PM)
**Mechanism:** Agent Collaboration v3

---

## 1. live-status.md Update Status

**Result: FAIL — not kept updated**

- Last manual update: 17:55 (before observation period started)
- No updates during 18:00~21:00 observation window
- Heartbeat crons ran (18:00, 19:00, 20:07) but didn't update live-status.md
- Root cause: PM heartbeat flow doesn't include auto-update of live-status.md

**Fix needed:** Add live-status.md update to heartbeat cron workflow.

---

## 2. Task First-Pass Rate

| Task ID | Agent | First Pass? | Notes |
|---------|-------|-------------|-------|
| J-FIX-02 | Jiangrou | PARTIAL | blog dir deleted, but no mvn compile run, no log |
| D-FIX-01 | Dousha | PARTIAL | dist exists, but no log file created |
| S-SSH-01 | Suancai | PASS | SSH verify succeeded, log file created |

**First-pass rate: 1/3 (33%)**

Observations:
- Suancai (simplest task, 1 command) = PASS
- Jiangrou & Dousha completed core goal but missed DONE criteria (log + VERIFY + NEXT)
- v3 task cards prevented off-track behavior (0% off-track vs 100% in v2)

---

## 3. Off-Track Count (Unplanned File Changes)

**v3 period (17:50~21:00): 0 off-track incidents**

Compare with v2 period (10:00~16:00):
- Jiangrou: created 3 unplanned files in blog subpackage (off-track)
- Dousha: created CategoryView.vue instead of running npm build (off-track)
- Suancai: created backup.sh (19:17, minor — not harmful but unplanned)

**v3 NOT constraints are working.** Agents stopped creating unplanned files.

---

## 4. Fake Completion Count (Empty Logs)

| Agent | v2 Period | v3 Period |
|-------|-----------|-----------|
| Jiangrou | 1 (compile-fix: 1 line) | 0 (no fake, but no log at all) |
| Dousha | 0 | 0 |
| Suancai | 3 (7 placeholder logs) | 0 (SSH verify log was real) |

**v3 improvement:** No fake completions. But new problem: agents don't write log files at all (different failure mode).

---

## 5. User Intervention Count

During 18:00~21:00 period:
- User messages: 0 (user stopped actively monitoring after 17:49)
- PM proactive pushes: 0 (no critical failures pushed)

Compare with 10:00~17:49 period:
- User asked "report progress": 5 times
- User asked "continue": 4 times
- User gave corrections: 3 times

**Observation:** After v3 mechanism setup, user stepped back. This could mean trust improved, or user disengaged. Need more data.

---

## 6. PM Spawn Count

| Period | Spawns | Per Milestone |
|--------|--------|---------------|
| v2 (10:00~17:49) | ~25 | ~6 per milestone |
| v3 (17:50~21:00) | 2 (J-FIX-02 + D-FIX-01) | 1 per task |

**Improvement:** Fewer spawns with better-defined tasks.

---

## 7. PM Direct Intervention (Bailout)

| Time | What PM Did | Should PM Have Done This? |
|------|------------|--------------------------|
| 14:15 | Rewrote schema.sql + test-data.sql | YES — schema is cross-cutting |
| 14:00 | SSH remote: create DB + import data | NO — should be Suancai's job |
| 20:14 | Fixed ArticleServiceImplTest | NO — should be Jiangrou's job |

**PM bailout count: 3** (1 justified, 2 overreach)
After the v3 "no overreach" principle was set (17:49), PM still bailed out at 20:14. Old habits.

---

## 8. Summary Metrics

| Metric | v2 (pre-17:50) | v3 (post-17:50) | Change |
|--------|----------------|-----------------|--------|
| Off-track rate | 60% (3/5 tasks) | 0% (0/2 tasks) | improved |
| Fake completion | 4 incidents | 0 incidents | improved |
| First-pass rate | ~20% | 33% | slightly improved |
| Log compliance | ~30% | 0% (new problem) | worse |
| VERIFY compliance | N/A | 0% | not adopted yet |
| NEXT compliance | N/A | 0% | not adopted yet |
| User "report" requests | 5 in 7.8h | 0 in 3h | improved |
| PM bailout | 3 | 1 | improved |

---

## 9. Key Findings

### What Worked
1. **NOT constraints eliminated off-track behavior** — biggest win
2. **Task cards reduced ambiguity** — agents did the right thing (just missed ancillary steps)
3. **Suancai SSH fix worked** — TOOLS.md update was effective
4. **User stopped micro-managing** — trust or fatigue, TBD

### What Didn't Work
1. **DONE criteria (log files) ignored** — agents complete core task but skip documentation
2. **VERIFY self-check not executed** — agents don't run verification scripts
3. **NEXT (sessions_send) not executed** — agents don't trigger handoff to next agent
4. **live-status.md not auto-updated** — PM forgot to update during heartbeats
5. **PM still bailed out** — old habit (20:14 test fix)

### Root Causes
- **Log/VERIFY/NEXT ignored:** Subagent one-shot mode runs out of tokens after core task. Ancillary steps get truncated.
- **Solution idea:** Move VERIFY to PM side (PM runs verify script after spawn completes, not agent). Keep NEXT as PM responsibility too.

---

## 10. Improvement Recommendations

### Priority 1: PM-Side Auto-Verify (not Agent-Side)
```
Current: Agent should self-verify → agent skips it
Improved: PM auto-runs VERIFY script after spawn completes
```
Agent only needs to: complete core task + write log.
PM handles: verify + next task trigger + live-status update.

### Priority 2: Simplify DONE Criteria
```
Current: 4 criteria (compile pass + log exists + log contains output + no new files)
Simplified: 2 criteria (compile pass + no new files)
PM auto-creates log from subagent result.
```
Reduce agent burden. PM can generate logs from spawn results.

### Priority 3: Integrate live-status.md into Heartbeat
```
Every heartbeat cron → auto-update live-status.md
Not relying on PM manual update.
```

### Priority 4: PM Discipline — No Bailout Without Escalation
```
Agent fails → PM retries with clearer task card
Agent fails 2x → PM escalates to user
PM does NOT do the work directly (unless user explicitly authorizes)
```

### Priority 5: Longer Observation
```
3 hours was too short with only 2 v3 tasks completed.
Recommend: 1 full workday observation with 10+ v3 tasks.
```

---

*Report generated: 2026-03-24 21:00*
*Next review: 2026-03-25 morning standup*
