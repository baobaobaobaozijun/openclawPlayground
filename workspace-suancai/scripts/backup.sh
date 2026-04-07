#!/bin/bash

BACKUP_DIR="/opt/baozipu/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "=== 开始备份 ==="

# 备份数据库
mysqldump -u root -pBaozipu2026! baozipu > $BACKUP_DIR/db_$TIMESTAMP.sql

# 压缩备份
cd $BACKUP_DIR
tar -czf backup_$TIMESTAMP.tar.gz db_$TIMESTAMP.sql

# 清理 SQL 文件
rm db_$TIMESTAMP.sql

echo "✅ 备份完成：backup_$TIMESTAMP.tar.gz"