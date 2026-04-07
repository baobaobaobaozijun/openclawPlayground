#!/bin/bash

echo "=== 服务健康检查 ==="

# 检查 Java 进程
if pgrep -f "java.*baozipu" > /dev/null; then
    echo "✅ Java 进程正常"
else
    echo "❌ Java 进程异常"
fi

# 检查 MySQL
if mysql -u root -pBaozipu2026! -e "SELECT 1" > /dev/null 2>&1; then
    echo "✅ MySQL 连接正常"
else
    echo "❌ MySQL 连接异常"
fi

# 检查 Redis 连接
if redis-cli ping > /dev/null 2>&1; then
    echo "✅ Redis 连接正常"
else
    echo "❌ Redis 连接异常"
fi

# 检查 Nginx 状态
if systemctl is-active --quiet nginx; then
    echo "✅ Nginx 服务正常运行"
else
    echo "❌ Nginx 服务异常"
fi

# 检查磁盘空间
echo "磁盘空间使用情况:"
df -h /opt/baozipu | tail -1

# 额外检查根分区磁盘空间
echo "根分区磁盘空间:"
df -h / | tail -1

echo "=== 检查完成 ==="