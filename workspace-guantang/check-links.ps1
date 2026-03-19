Set-Location 'F:\openclaw\agent'
$links = @(
  'workspace-guantang/IDENTITY.md',
  'workspace-guantang/SOUL.md',
  'workspace-guantang/AGENTS.md',
  'workspace-guantang/BOOTSTRAP.md',
  'workspace-jiangrou/IDENTITY.md',
  'workspace-jiangrou/ROLE.md',
  'workspace-jiangrou/SOUL.md',
  'workspace-jiangrou/MEMORY.md',
  'workspace-jiangrou/TECHNICAL-DOCS.md',
  'workspace-jiangrou/README.md',
  'workspace-dousha/IDENTITY.md',
  'workspace-dousha/ROLE.md',
  'workspace-dousha/SOUL.md',
  'workspace-dousha/MEMORY.md',
  'workspace-dousha/TECHNICAL-DOCS.md',
  'workspace-dousha/README.md',
  'workspace-suancai/IDENTITY.md',
  'workspace-suancai/ROLE.md',
  'workspace-suancai/SOUL.md',
  'workspace-suancai/MEMORY.md',
  'workspace-suancai/TECHNICAL-DOCS.md',
  'workspace-suancai/README.md',
  'workspace-guantang/agent-configs/jiangrou/README.md',
  'workspace-guantang/agent-configs/dousha/README.md',
  'workspace-guantang/agent-configs/suancai/README.md',
  '../code/backend/README.md',
  '../code/frontend/README.md',
  '../code/deploy/README.md',
  '../code/tests/README.md',
  'workspace-guantang/ROLE.md',
  'workspace-guantang/README.md',
  'workspace-guantang/HEARTBEAT.md',
  'workspace-guantang/TOOLS.md',
  'workspace-guantang/USER.md',
  'workspace-guantang/specs/03-technical-specs/agent-error-monitoring.md',
  'workspace-guantang/monitoring/dashboard.md',
  'workspace-guantang/scripts/simple-monitor.ps1',
  'workspace-guantang/guides/quick-start.md',
  'workspace-guantang/guides/local-run-guide.md',
  'workspace-guantang/guides/github-upload-guide.md',
  'workspace-guantang/specs/agent-protocol.md',
  'workspace-guantang/specs/system-architecture.md',
  'workspace-guantang/specs/logging-audit.md',
  'migration/MIGRATION-GUIDE-to-single-gateway.md',
  'doc/README.md'
)
$ok = 0
$missing = 0
foreach ($link in $links) {
  $exists = Test-Path $link
  if ($exists) {
    Write-Output "OK $link"
    $ok++
  } else {
    Write-Output "MISSING $link"
    $missing++
  }
}
Write-Output "---"
Write-Output "Total: $($links.Count) | OK: $ok | MISSING: $missing"
