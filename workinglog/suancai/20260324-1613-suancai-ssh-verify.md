# SSH 验证结果
命令: ssh -o StrictHostKeyChecking=no root@8.137.175.240 "hostname && uptime && redis-cli ping && mysql -u root openclaw -e 'SELECT COUNT(*) FROM users'"
输出:
iZ2vci7l3tibmgrruitfshZ
 16:16:36 up 13 days,  6:20,  2 users,  load average: 0.02, 0.01, 0.00
PONG
COUNT(*)
3

状态: PASS