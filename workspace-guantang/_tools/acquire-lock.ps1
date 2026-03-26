# 获取锁脚本
# 参数: $lockName, $sessionId

param(
    [string]$lockName = "plan_dispatch_lock",
    [string]$sessionId = $(throw "-sessionId is required"),
    [int]$lockTimeoutMinutes = 10
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

# 获取锁的 SQL 语句
$acquireLockSql = @"
INSERT INTO session_lock (lock_name, locked_by, locked_at, expires_at, heartbeat)
VALUES (
  '$lockName',
  '$sessionId',
  NOW(),
  DATE_ADD(NOW(), INTERVAL $lockTimeoutMinutes MINUTE),
  NOW()
)
ON DUPLICATE KEY UPDATE
  locked_by = IF(expires_at < NOW(), VALUES(locked_by), locked_by),
  locked_at = IF(expires_at < NOW(), NOW(), locked_at),
  expires_at = IF(expires_at < NOW(), DATE_ADD(NOW(), INTERVAL $lockTimeoutMinutes MINUTE), expires_at),
  heartbeat = IF(expires_at < NOW(), NOW(), heartbeat);
"@

# 检查是否成功获取锁的 SQL 语句
$checkLockSql = @"
SELECT * FROM session_lock 
WHERE lock_name = '$lockName' 
  AND locked_by = '$sessionId'
  AND expires_at > NOW();
"@

try {
    # 执行获取锁的 SQL
    $result = Invoke-Expression "$mysqlCmd `"$acquireLockSql`""
    
    # 检查是否成功获取锁
    $checkResult = Invoke-Expression "$mysqlCmd `"$checkLockSql`""
    
    if ($checkResult.Count -gt 1) {  # 有结果返回，表示获取锁成功
        Write-Output "Lock acquired successfully"
        exit 0
    } else {
        Write-Output "Failed to acquire lock"
        exit 1
    }
}
catch {
    Write-Error "Error acquiring lock: $($_.Exception.Message)"
    exit 1
}