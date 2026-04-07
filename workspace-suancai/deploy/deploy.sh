#!/bin/bash
set -e

echo "=== 开始部署 ==="

# 后端打包
cd /opt/baozipu/backend
git pull
mvn clean package -DskipTests

# 前端打包
cd /opt/baozipu/frontend
git pull
npm install && npm run build

# 重启服务
systemctl restart baozipu

echo "=== 部署完成 ==="