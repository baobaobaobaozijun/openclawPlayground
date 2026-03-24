# 任务卡片模板

---

## META
- ID: {J-01 / D-01 / S-01}
- Agent: {jiangrou / dousha / suancai}
- Priority: {P0-red / P1-yellow / P2-green}
- Env: {local / remote root@8.137.175.240}
- Depends: {none / J-01}
- Template: {TPL-COMPILE / TPL-BUILD / TPL-FILE / TPL-DEPLOY / TPL-API-TEST / TPL-CONFIG}

## WHAT (Goal)
{One sentence: what result to achieve, not how}

## HOW (Allowed)
- Y: {allowed operation 1}
- Y: {allowed operation 2}

## NOT (Forbidden)
- N: Create new files (unless WHAT explicitly requires)
- N: Modify other Agent's code
- N: Delete files without PM approval
- N: Modify Entity classes (jiangrou only, requires PM approval)

## DONE (All must pass)
1. {Verifiable condition 1}
2. {Verifiable condition 2}
3. Log file: workinglog/{agent}/{date}-{ID}.md
4. Log contains: {key output}

## STUCK (When blocked)
- Compile errors > 10 → STOP, report PM with full error
- Need to modify other module → STOP, report PM
- Need to create new files → STOP, report PM
- > 10 min no progress → STOP, report current state
- DEFAULT: Any unexpected situation → Do NOT decide alone, report PM first

## VERIFY (Agent self-check before reporting done)
```
{command 1}  # expect: {result}
{command 2}  # expect: {result}
```

## NEXT (After completion)
- {Notify who / trigger what task}

---

# Template Library

## TPL-COMPILE: Fix compilation
```
WHAT: mvn compile passes (exit code 0)
HOW: Modify annotations, imports, method signatures in existing files
NOT: Create new .java files; Delete files; Modify Entity classes
DONE: mvn compile exit 0 + git diff --diff-filter=A is empty
STUCK: Errors involve Entity fields → STOP report PM
VERIFY: mvn compile; git diff --name-only --diff-filter=A
```

## TPL-BUILD: Frontend build
```
WHAT: npm run build passes (exit code 0)
HOW: Fix imports, type errors, missing exports in existing files
NOT: Create new .vue/.ts files; Change router config
DONE: npm run build exit 0 + dist/index.html exists
STUCK: Errors involve missing components → STOP report PM
VERIFY: npm run build; Test-Path dist/index.html
```

## TPL-FILE: Create single file
```
WHAT: Create {filename} with specified content
HOW: Use write tool to create the file
NOT: Modify other files; Only reply with code without writing
DONE: Test-Path → True + file > 100B + contains {keyword}
STUCK: Unsure about implementation → STOP report PM
VERIFY: Test-Path {path}; (Get-Item {path}).Length
```

## TPL-DEPLOY: Remote deploy step
```
WHAT: {Deploy action} on remote server
HOW: exec("ssh -o StrictHostKeyChecking=no root@8.137.175.240 '{command}'")
NOT: Use Posh-SSH; Run on local; Skip verification
DONE: Remote verify command returns expected result
STUCK: SSH fails → STOP report PM; Command errors → STOP report PM
VERIFY: ssh root@... "{verify command}"
```

## TPL-API-TEST: Test API endpoint
```
WHAT: Verify {endpoint} returns expected response
HOW: curl command with full output recorded
NOT: Modify any code; Skip recording output
DONE: Status code matches + response contains expected fields
STUCK: Unexpected 500 → STOP report PM with response body
VERIFY: curl -s -w '\n%{http_code}' {url}
```

## TPL-CONFIG: Modify config
```
WHAT: Update {config file} with {changes}
HOW: Read current → write modified version
NOT: Change unrelated config items
DONE: File contains expected config + service restarts OK
STUCK: Config syntax error → STOP report PM
VERIFY: Select-String -Path {file} -Pattern '{expected}'
```
