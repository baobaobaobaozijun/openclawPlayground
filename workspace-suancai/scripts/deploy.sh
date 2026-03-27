#!/bin/bash
set -e

echo "🚀 开始部署包子铺博客系统..."

# 1. 拉取最新代码
cd /opt/baozipu
git pull

# 2. 后端构建
cd backend
mvn clean package -DskipTests -q
echo "✅ 后端构建完成"

# 3. 前端构建
cd ../frontend
npm install
npm run build
echo "✅ 前端构建完成"

# 4. 停止旧服务
systemctl stop baozipu-backend || true

# 5. 部署新服务
cp target/baozipu-backend-0.1.0.jar /opt/baozipu/releases/
ln -sf /opt/baozipu/releases/baozipu-backend-0.1.0.jar /opt/baozipu/current.jar

# 6. 启动新服务
systemctl start baozipu-backend

# 7. 健康检查
sleep 5
curl -f http://localhost:8080/api/health || exit 1

echo "🎉 部署完成！"