#!/usr/bin/env node

const { execSync } = require('child_process');
const path = require('path');

const args = process.argv.slice(2);
const command = args[0];
const scriptMap = {
    '创建计划': 'create-plan.ps1',
    '更新进度': 'update-progress.ps1',
    '完成计划': '../plan-manager/commands/complete-plan.ps1',
    '查询计划': 'query-plan.ps1',
    '列出计划': '../plan-manager/commands/list-plans.ps1',
};

if (!command || !scriptMap[command]) {
    console.log(`
Plan Manager v2 - Pipeline v3.0 整合版

用法：npx plan-manager-v2 <命令> [参数]

命令:
  创建计划     创建新计划（数据库双写）
  更新进度     更新轮次进度（数据库双写）
  完成计划     完成计划 + 复盘 + 通知
  查询计划     从数据库查询计划详情
  列出计划     列出所有计划

示例:
  npx plan-manager-v2 创建计划 --id "007" --name "文章管理" --priority "P1" --rounds 5
  npx plan-manager-v2 更新进度 --plan-id "007" --round 1 --status "completed"
  npx plan-manager-v2 查询计划 --plan-id "007"
  npx plan-manager-v2 列出计划 --status "executing"
`);
    process.exit(0);
}

const script = scriptMap[command];
const scriptPath = path.join(__dirname, '..', 'commands', script);

try {
    execSync(`powershell -ExecutionPolicy Bypass -File "${scriptPath}" ${args.slice(1).join(' ')}`, {
        stdio: 'inherit',
        cwd: __dirname
    });
} catch (error) {
    console.error(`执行失败：${error.message}`);
    process.exit(1);
}
