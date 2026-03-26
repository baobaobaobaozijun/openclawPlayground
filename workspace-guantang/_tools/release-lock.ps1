# 释放锁脚本
# 参数：$lockName, $sessionId

param(
    [string]$lockName = "plan_dispatch_lock",
    [string]$sessionId = $(throw "-sessionId is required")
)

# 数据库连接信息
$dbHost = "localhost"
$dbPort = "3306"
$dbUser = "root"
$dbPassword = ""
$dbName = "openclaw"

# 构建 MySQL 命令
$mysqlCmd = "mysql -h $dbHost -P $dbPort -u $dbUser"
if ($dbPassword) {
    $mysqlCmd += " -p$dbPassword"
}
$mysqlCmd += " $dbName -e"

# 释放锁的 SQL 语句
$releaseLockSql = @"
DELETE FROM session_lock 
WHERE lock_name = '$lockName' 
  AND locked_by = '$sessionId';
"@

try {
    # 执行释放锁的 SQL
    $result = Invoke-Expression "$mysqlCmd `"$releaseLockSql`""
    Write-Output "Lock released successfully"
    exit 0
}
catch {
    Write-Error "Error releasing lock: $($_.Exception.Message)"
    exit 1
}
