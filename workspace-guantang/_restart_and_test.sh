#!/bin/bash
pkill -f backend-1.0.0-SNAPSHOT.jar 2>/dev/null
sleep 2
cd /opt/baozipu/backend
nohup java -jar backend-1.0.0-SNAPSHOT.jar > nohup.out 2>&1 &
echo $! > pid
echo "STARTED PID=$(cat pid)"
sleep 10
echo "=== TEST ==="
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
