# User Quick Commands

Commands the user can say to PM Guantang:

## Status & Progress
| Command | Action |
|---------|--------|
| "Look at progress" / "Report" | Output live-status.md summary |
| "{Agent} status" | Check specific agent's latest log + subagent state |
| "Today summary" | Full day report: done/pending/issues/tomorrow plan |

## Control
| Command | Action |
|---------|--------|
| "Stop {Agent}" | Kill active subagent for that agent |
| "Stop all" | Kill all active subagents |
| "{Agent} do X first" | Spawn new task overriding current |
| "Re-plan" | Pause all, create new plan |

## Diagnosis
| Command | Action |
|---------|--------|
| "Why failed" | Read recent error logs, analyze and report |
| "What changed" | git diff summary |
| "{Agent} doing what" | Check latest log + active subagent |

## Delegation Rules
| Command | Action |
|---------|--------|
| "Continue" | PM resumes next pending tasks |
| "Execute" | PM starts executing current plan |
| "Think only" | PM analyzes without executing |
| "{Agent} fix" | Assign fix task to specific agent |
