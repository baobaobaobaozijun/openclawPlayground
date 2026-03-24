# Delivery Standards

## Three-Level Verification

### L1: Existence
- Test-Path → True
- File size > 100B
- Use for: File creation tasks

### L2: Content
- Contains required keywords (Select-String)
- Does NOT contain forbidden patterns (TODO, FIXME, placeholder)
- Use for: Code quality checks

### L3: Functional
- Command exit code = 0
- Output matches expected pattern
- Use for: Compile, build, deploy, API tests

## Per-Role Standards

### Jiangrou (Backend)
| Task Type | L1 | L2 | L3 |
|-----------|----|----|-----|
| Create Java file | Test-Path | @RestController / @Service | mvn compile pass |
| Fix compilation | N/A | N/A | mvn compile exit 0 + no new files |
| API development | Test-Path | @Operation annotation | curl returns expected JSON |

### Dousha (Frontend)
| Task Type | L1 | L2 | L3 |
|-----------|----|----|-----|
| Create Vue/TS file | Test-Path | <template> or export | npm run build pass |
| Fix build | N/A | N/A | npm run build exit 0 + no new files |
| Component dev | Test-Path | <script setup lang="ts"> | build pass |

### Suancai (DevOps)
| Task Type | L1 | L2 | L3 |
|-----------|----|----|-----|
| Remote operation | N/A | N/A | SSH command output matches expected |
| Config file | Test-Path | Contains expected directives | Service restart OK |
| Deploy | N/A | N/A | Remote curl returns 200 |

## Change Audit
After every task completion, PM checks:
```powershell
git diff --name-only              # What changed
git diff --name-only --diff-filter=A  # New files (should be empty for fix tasks)
git diff --stat                   # Change magnitude
```
Unplanned new files = RED FLAG
