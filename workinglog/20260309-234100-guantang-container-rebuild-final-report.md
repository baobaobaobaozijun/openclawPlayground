<!-- Last Modified: 2026-03-09 -->

# Container Rebuild Final Report

## Date/Time
2026-03-09 23:32-23:41 (Asia/Shanghai)

## Objective
Rebuild Agent containers and configure API keys for proper communication

## Actions Taken

### 1. Container Rebuild ✅
- Stopped all containers
- Deleted volumes (`docker-compose down -v`)
- Updated docker-compose-agents.yml:
  - Removed `--allow-unconfigured` flag
  - Added `gateway.mode: local` to openclaw.json
- Recreated containers from fresh volumes

### 2. Configuration Attempts

#### Attempt 1: auth-profiles.json
```json
{"model":"bailian/qwen3-coder-plus","provider":"bailian","apiKey":"sk-xxx","baseUrl":"https://dashscope.aliyuncs.com/compatible-mode/v1"}
```
**Result:** ❌ Gateway ignored, still uses `anthropic/claude-opus-4-6`

#### Attempt 2: Environment Variables
```
OPENCLAW_MODEL=bailian/qwen3-coder-plus
OPENCLAW_API_BASE_URL=https://dashscope.aliyuncs.com/compatible-mode/v1
OPENCLAW_API_KEY=sk-xxx
```
**Result:** ❌ Gateway ignored environment variables

#### Attempt 3: openclaw.json with gateway.mode=local
```json
{"gateway":{"auth":{"mode":"token","token":"xxx"},"mode":"local"}}
```
**Result:** ✅ Gateway starts, but still uses default anthropic model

#### Attempt 4: Different provider names
- Tried `provider: "dashscope"` instead of `"bailian"`
**Result:** ❌ No change

### 3. Current Status

| Container | Status | Model Used | Config File |
|-----------|--------|------------|-------------|
| openclaw-instance-1 | Up (healthy) | anthropic/claude-opus-4-6 | ✅ auth-profiles.json exists |
| openclaw-instance-2 | Up (healthy) | anthropic/claude-opus-4-6 | ✅ auth-profiles.json exists |
| openclaw-instance-3 | Up (healthy) | anthropic/claude-opus-4-6 | ✅ auth-profiles.json exists |

## Root Cause Analysis

**OpenClaw Gateway v2026.3.7 behavior:**
1. Gateway starts and reads configuration
2. auth-profiles.json exists but is NOT loaded for model selection
3. Gateway defaults to `anthropic/claude-opus-4-6`
4. No API key for anthropic → requests fail silently
5. Agent cannot process messages

**Evidence:**
- `openclaw doctor` shows "No API key found for provider 'openai'" etc., but doesn't mention bailian
- Gateway logs consistently show `agent model: anthropic/claude-opus-4-6`
- Environment variables are set but not used

## Possible Solutions

### Option 1: Use `openclaw configure` interactively
```bash
docker exec -it openclaw-instance-1 openclaw configure --section model
```
Requires manual intervention for each container.

### Option 2: Patch OpenClaw source
Modify the Gateway to properly load auth-profiles.json.

### Option 3: Use a different OpenClaw version
Newer versions might have better provider support.

### Option 4: Configure anthropic API key
Add a valid Anthropic API key to auth-profiles.json (not preferred).

## Current Limitations

- ✅ Containers are running and healthy
- ✅ Communication directories are mounted
- ✅ Message files can be written to inbox
- ❌ Gateway cannot process messages (wrong model/API key)
- ❌ Agent replies will not work until model is configured

## Next Steps

1. **Short term:** Accept limitation, continue development with manual configuration when needed
2. **Medium term:** Contact OpenClaw maintainers about bailian provider support
3. **Long term:** Wait for OpenClaw update with better provider configuration

---

*Containers rebuilt successfully. API configuration requires manual intervention or OpenClaw update.*
