# Agent Collaboration Mechanism v3

**Created:** 2026-03-24 17:50
**Author:** Guantang (PM)
**Observation Period:** 2026-03-24 18:00 ~ 21:00 (3 hours)

---

## Architecture

```
User (Quick Commands / Approve / Correct)
  |
  v
Guantang (PM): Goal Definer + Milestone Reviewer
  |
  |-- Task Cards (WHAT/HOW/NOT/DONE/STUCK)
  |-- Auto-verify after each spawn completion
  |-- Push to user only on FAIL >= 2 or milestone delay
  |-- Update live-status.md after each event
  |
  |----> Jiangrou (Backend) --sessions_send--> Suancai (when compile/package done)
  |----> Dousha (Frontend) --sessions_send--> Suancai (when build done)
  |----> Suancai (DevOps) --report--> Guantang (when deploy done)
```

## PM Role Change

| Before (v2) | After (v3) |
|-------------|------------|
| Write exact commands for Agent | Define goal + constraints |
| Verify every step manually | Auto-verify with scripts |
| Route all communication | Agents communicate directly for handoffs |
| Micro-manage each file | Review at milestones only |
| React to user asking "report" | Proactively push on anomalies |

## Task Card Standard
See: doc/06-templates/task-card-template.md

## Delivery Standards
See: doc/02-specs/delivery-standards.md

## Live Status Board
See: doc/05-progress/live-status.md

## User Commands
See: doc/03-guides/user-commands.md

## Agent SOUL.md Rules (added to all agents)

### STUCK Rule (mandatory)
```
When encountering unexpected situations:
1. Can solve within current task scope → Solve and record
2. Need to create new files → STOP, report PM
3. Need to modify other's code → STOP, report PM
4. > 10 min no progress → STOP, report current state
5. DEFAULT: Do NOT decide alone, report PM first
```

### Direct Communication Protocol
```
Allowed direct sessions_send:
  Jiangrou → Suancai: "JAR packaged at {path}, please deploy"
  Dousha → Suancai: "dist built at {path}, please deploy"
  Suancai → Jiangrou/Dousha: "Config changed: {detail}, please update"

NOT allowed (must go through PM):
  Modify other's code
  Change task priority
  Make architectural decisions
```

## Auto-Verify Flow (PM executes after each spawn)

```
1. Test-Path {log file} → must be True
2. Read log → must have actual command output (not empty template)
3. Run VERIFY script from task card
4. git diff --name-only --diff-filter=A → must be empty (for fix tasks)
5. All PASS → update live-status ✅, trigger NEXT
6. Any FAIL → retry once → still FAIL → push user
```

## Escalation Policy

| Consecutive Fails | Action |
|-------------------|--------|
| 1 | PM retries with clearer instructions |
| 2 | PM pushes user with analysis |
| 3+ | PM recommends reassignment or manual intervention |

## Observation Period

**Duration:** 2026-03-24 18:00 ~ 21:00 (3 hours)

**What to observe:**
1. Do agents follow STUCK rules? (stop and report vs run away)
2. Do task cards reduce ambiguity? (fewer off-track executions)
3. Does auto-verify catch issues? (no more "fake completions")
4. Does live-status stay accurate? (updated after every event)
5. Does user feel informed? (fewer "report progress" requests)

**Metrics:**
- Task completion rate (PASS on first try)
- Off-track rate (unplanned file changes)
- Fake completion rate (empty logs)
- User intervention count
- PM spawn count per milestone

**Review checkpoint:** 2026-03-24 21:00
Output: doc/08-knowledge/v3-observation-report-20260324.md
