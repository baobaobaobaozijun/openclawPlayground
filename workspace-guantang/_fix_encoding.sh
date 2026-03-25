#!/bin/bash
sed -i 's/characterEncoding=utf8mb4/characterEncoding=UTF-8/' /opt/baozipu/backend/application.yml
echo "Fixed encoding"
grep characterEncoding /opt/baozipu/backend/application.yml

pkill -f backend-1.0.0-SNAPSHOT.jar 2>/dev/null
sleep 2
cd /opt/baozipu/backend
nohup java -jar backend-1.0.0-SNAPSHOT.jar --spring.config.location=./application.yml > nohup.out 2>&1 &
echo $! > pid
echo "Started PID=$(cat pid)"

sleep 12

echo "=== SMOKE TEST ==="
curl -s -w "\nHTTP:%{http_code}" http://localhost:8081/api/categories
echo
curl -s -w "\nHTTP:%{http_code}" http://localhost:8081/api/tags
echo
curl -s -w "\nHTTP:%{http_code}" http://localhost:8081/api/articles
echo
curl -s -w "\nHTTP:%{http_code}" -X POST http://localhost:8081/api/auth/login -H "Content-Type: application/json" -d '{"username":"admin","password":"admin123"}'
echo
echo "=== NGINX ==="
curl -s -w "\nHTTP:%{http_code}" http://localhost/api/categories
echo
curl -s -o /dev/null -w "HOMEPAGE HTTP:%{http_code}" http://localhost/
echo
