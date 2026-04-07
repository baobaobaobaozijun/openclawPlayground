## 工作日志 - 酸菜

### 任务
创建部署脚本 deploy.sh

### 修改内容
1. 创建文件: F:\openclaw\agent\workspace-suancai\deploy\deploy.sh
2. 设置执行权限: icacls "F:\openclaw\agent\workspace-suancai\deploy\deploy.sh" /grant Users:F

### 部署脚本内容
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

### 验证
- 文件存在: ✓
- 执行权限: ✓ 
- 工作日志记录: ✓