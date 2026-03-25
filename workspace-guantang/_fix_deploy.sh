#!/bin/bash
# Create external application.yml on server to override JAR embedded config
cat > /opt/baozipu/backend/application.yml << 'EOF'
server:
  port: 8081
  servlet:
    context-path: /api

spring:
  datasource:
    url: jdbc:mysql://localhost:3306/openclaw?useUnicode=true&characterEncoding=utf8mb4&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true&useSSL=false
    username: root
    password:
    driver-class-name: com.mysql.cj.jdbc.Driver
  redis:
    host: localhost
    port: 6379

jwt:
  secret: BaoZiPu2026SecretKeyForJwtToken!
  expiration: 86400000

logging:
  level:
    com.openclaw: debug
EOF

echo "Config written"

# Restart backend with external config
pkill -f backend-1.0.0-SNAPSHOT.jar 2>/dev/null
sleep 2
cd /opt/baozipu/backend
nohup java -jar backend-1.0.0-SNAPSHOT.jar --spring.config.location=./application.yml > nohup.out 2>&1 &
echo $! > pid
echo "Started PID=$(cat pid)"

# Wait for startup
sleep 12

# Test
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
