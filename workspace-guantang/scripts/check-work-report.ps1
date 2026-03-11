# 工作报告审核自动化检查脚本
# 使用方法：.\check-work-report.ps1 -AgentName jiangrou -TaskId TASK-001
# 最后更新：2026-03-11

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('jiangrou', 'dousha', 'suancai')]
    [string]$AgentName,
    
    [Parameter(Mandatory=$true)]
    [string]$TaskId
)

$ErrorActionPreference = 'Stop'
$baseDir = "F:\openclaw\agent"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  工作报告审核检查 - $AgentName - $TaskId" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 切换到 agent 目录
Set-Location $baseDir

# 1. 获取最近一次提交
Write-Host "[1/4] 检查 Git 提交..." -ForegroundColor Yellow
$lastCommit = git log --oneline -1 --author="$AgentName"
if ($lastCommit) {
    Write-Host "✅ 找到提交记录：$lastCommit" -ForegroundColor Green
} else {
    Write-Host "❌ 未找到提交记录" -ForegroundColor Red
    exit 1
}

# 2. 获取修改的文件列表
Write-Host "`n[2/4] 分析修改的文件..." -ForegroundColor Yellow
$modifiedFiles = git diff HEAD~1 HEAD --name-only
Write-Host "修改了 $($modifiedFiles.Count) 个文件:" -ForegroundColor White
$modifiedFiles | ForEach-Object { Write-Host "  - $_" }

# 3. 权限边界检查
Write-Host "`n[3/4] 检查权限边界..." -ForegroundColor Yellow
$violations = @()

switch ($AgentName) {
    'jiangrou' {
        # 酱肉不应该修改的文件
        $forbidden = @('code/frontend', 'code/deploy', 'workspace-dousha', 'workspace-suancai')
    }
    'dousha' {
        # 豆沙不应该修改的文件
        $forbidden = @('code/backend', 'code/deploy', 'workspace-jiangrou', 'workspace-suancai')
    }
    'suancai' {
        # 酸菜不应该修改的文件
        $forbidden = @('code/backend', 'code/frontend', 'workspace-jiangrou', 'workspace-dousha')
    }
}

foreach ($file in $modifiedFiles) {
    foreach ($pattern in $forbidden) {
        if ($file -like "$pattern/*") {
            $violations += "⚠️ 越权修改：$file (属于 $pattern)"
        }
    }
}

if ($violations.Count -gt 0) {
    Write-Host "`n❌ 发现权限违规:" -ForegroundColor Red
    $violations | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
    exit 1
} else {
    Write-Host "✅ 未发现越权修改" -ForegroundColor Green
}

# 4. 交付物完整性检查
Write-Host "`n[4/4] 检查交付物完整性..." -ForegroundColor Yellow

switch ($AgentName) {
    'jiangrou' {
        $expected = @('code/backend', 'code/tests/backend')
        $hasCode = $modifiedFiles | Where-Object { $_ -like 'code/backend/*' }
        $hasTest = $modifiedFiles | Where-Object { $_ -like 'code/tests/backend/*' }
        $hasDoc = $modifiedFiles | Where-Object { $_ -like 'agent/doc/*' -or $_ -like "workspace-jiangrou/logs/*" }
    }
    'dousha' {
        $expected = @('code/frontend', 'code/tests/frontend')
        $hasCode = $modifiedFiles | Where-Object { $_ -like 'code/frontend/*' }
        $hasTest = $modifiedFiles | Where-Object { $_ -like 'code/tests/frontend/*' }
        $hasDoc = $modifiedFiles | Where-Object { $_ -like 'agent/doc/*' -or $_ -like "workspace-dousha/logs/*" }
    }
    'suancai' {
        $expected = @('code/deploy', 'code/tests')
        $hasCode = $modifiedFiles | Where-Object { $_ -like 'code/deploy/*' -or $_ -like 'code/tests/*' }
        $hasTest = $hasCode  # 测试即交付物
        $hasDoc = $modifiedFiles | Where-Object { $_ -like 'agent/doc/*' -or $_ -like "workspace-suancai/logs/*" }
    }
}

$score = 0
$total = 3

if ($hasCode) { Write-Host "✅ 包含代码文件" -ForegroundColor Green; $score++ } 
else { Write-Host "❌ 缺少代码文件" -ForegroundColor Red }

if ($hasTest) { Write-Host "✅ 包含测试文件" -ForegroundColor Green; $score++ } 
else { Write-Host "❌ 缺少测试文件" -ForegroundColor Red }

if ($hasDoc) { Write-Host "✅ 包含文档/日志" -ForegroundColor Green; $score++ } 
else { Write-Host "❌ 缺少文档/日志" -ForegroundColor Red }

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  审核结果：$score / $total" -ForegroundColor $(if($score -eq $total){'Green'}else{'Yellow'})
Write-Host "========================================" -ForegroundColor Cyan

if ($score -eq $total) {
    Write-Host "✅ 通过审核！可以接受交付。" -ForegroundColor Green
    exit 0
} else {
    Write-Host "⚠️ 需要补充材料后重新提交。" -ForegroundColor Yellow
    exit 1
}
