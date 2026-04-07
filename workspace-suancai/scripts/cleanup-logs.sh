#!/bin/bash

LOG_DIR="/opt/baozipu/logs"
BACKUP_DIR="/opt/baozipu/backups"

echo "=== 开始清理日志 ==="

# 删除 7 天前的日志
find $LOG_DIR -name "*.log" -mtime +7 -delete
echo "✅ 已删除 7 天前的日志"

# 删除 30 天前的备份，保留最近 5 个
cd $BACKUP_DIR
ls -t *.tar.gz | tail -n +6 | xargs -r rm -f
echo "✅ 已清理旧备份 (保留最近 5 个)"

echo "=== 清理完成 ==="