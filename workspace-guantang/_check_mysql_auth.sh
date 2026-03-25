#!/bin/bash
# Check MySQL auth for 'password'
echo "=== MySQL root no password ==="
mysql -u root -e "SELECT 1 as test" 2>&1

echo "=== MySQL root with 'password' ==="
mysql -u root -ppassword -e "SELECT 1 as test" 2>&1

echo "=== MySQL root with empty password ==="
mysql -u root -p'' -e "SELECT 1 as test" 2>&1

echo "=== Application.yml password ==="
grep password /opt/baozipu/backend/nohup.out 2>/dev/null | head -3 || echo "no password in log"

echo "=== Last 5 error lines ==="
grep -i "Access denied" /opt/baozipu/backend/nohup.out | tail -3
