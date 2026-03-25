# 部署方案草稿

## 概述

本文档描述了博客系统的完整部署方案，包括后端服务、前端页面、数据库初始化以及反向代理配置。

## 环境验证结果

- Java 21 ✅ 
- MySQL ✅
- Redis ✅
- Nginx ✅
- 部署目录 ✅
- Java 服务监听端口：8081

## 部署流程

### 1. 后端部署流程

#### 1.1 JAR打包
```bash
# 在后端项目根目录执行
mvn clean package -DskipTests
```

#### 1.2 上传JAR文件
```bash
# 将生成的JAR文件上传到服务器的部署目录
scp target/backend-1.0.0-SNAPSHOT.jar root@{SERVER_IP}:/opt/baozipu/backend/
```

#### 1.3 创建启动脚本
在 `/opt/baozipu/backend/` 目录下创建 `start.sh`：

```bash
#!/bin/bash
export JAVA_OPTS="-Xmx1g -Xms512m"
cd /opt/baozipu/backend
nohup java $JAVA_OPTS -jar backend-1.0.0-SNAPSHOT.jar > app.log 2>&1 &
echo $! > app.pid
```

#### 1.4 设置权限并启动服务
```bash
chmod +x /opt/baozipu/backend/start.sh
/opt/baozipu/backend/start.sh
```

### 2. 前端部署流程

#### 2.1 构建前端项目
```bash
# 在前端项目根目录执行
npm run build
```

#### 2.2 上传构建文件
```bash
# 将dist目录下的所有文件上传到服务器
scp -r dist/* root@{SERVER_IP}:/opt/baozipu/frontend/dist/
```

#### 2.3 Nginx配置
创建Nginx配置文件 `/etc/nginx/sites-available/baozipu-blog`：

```nginx
server {
    listen 80;
    server_name _;

    # 前端静态文件
    location / {
        alias /opt/baozipu/frontend/dist/;
        try_files $uri $uri/ /index.html;
        
        # 静态资源缓存
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }

    # API反向代理到后端服务
    location /api {
        proxy_pass http://localhost:8081;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_redirect off;
    }
    
    # 健康检查端点
    location /health {
        proxy_pass http://localhost:8081/health;
    }
}

# 为API服务创建单独的server块（可选）
server {
    listen 8081;
    server_name _;
    
    # 防止直接访问8081端口（内部使用）
    location / {
        proxy_pass http://localhost:8081;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

启用站点配置：
```bash
ln -s /etc/nginx/sites-available/baozipu-blog /etc/nginx/sites-enabled/
nginx -t
systemctl reload nginx
```

### 3. 数据库初始化流程

#### 3.1 执行schema.sql
```bash
# 假设schema.sql位于部署包中
mysql -u root -p openclaw < /opt/baozipu/database/schema.sql
```

#### 3.2 初始化数据
```bash
# 如有初始数据脚本
mysql -u root -p openclaw < /opt/baozipu/database/init-data.sql
```

### 4. 服务管理脚本

#### 4.1 后端服务管理脚本 `/opt/baozipu/backend/service.sh`
```bash
#!/bin/bash

SERVICE_NAME="baozipu-backend"
JAR_PATH="/opt/baozipu/backend/backend-1.0.0-SNAPSHOT.jar"
PID_FILE="/opt/baozipu/backend/app.pid"
LOG_FILE="/opt/baozipu/backend/app.log"
JAVA_OPTS="-Xmx1g -Xms512m"

case $1 in
  start)
    if [ -f $PID_FILE ]; then
      PID=$(cat $PID_FILE)
      if ps -p $PID > /dev/null; then
        echo "$SERVICE_NAME is already running (PID $PID)"
        exit 1
      fi
    fi
    
    echo "Starting $SERVICE_NAME..."
    cd /opt/baozipu/backend
    nohup java $JAVA_OPTS -jar $JAR_PATH > $LOG_FILE 2>&1 &
    echo $! > $PID_FILE
    echo "$SERVICE_NAME started (PID $(cat $PID_FILE))"
    ;;
    
  stop)
    if [ ! -f $PID_FILE ]; then
      echo "$SERVICE_NAME is not running"
      exit 1
    fi
    
    PID=$(cat $PID_FILE)
    echo "Stopping $SERVICE_NAME (PID $PID)..."
    kill $PID
    rm $PID_FILE
    echo "$SERVICE_NAME stopped"
    ;;
    
  restart)
    $0 stop
    sleep 2
    $0 start
    ;;
    
  status)
    if [ ! -f $PID_FILE ]; then
      echo "$SERVICE_NAME is not running"
      exit 1
    fi
    
    PID=$(cat $PID_FILE)
    if ps -p $PID > /dev/null; then
      echo "$SERVICE_NAME is running (PID $PID)"
    else
      echo "$SERVICE_NAME is not running (PID file exists but process not found)"
      exit 1
    fi
    ;;
    
  *)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
    ;;
esac
```

### 5. 回滚方案

#### 5.1 后端回滚
```bash
# 回滚到上一个版本
# 1. 停止当前服务
/opt/baozipu/backend/service.sh stop

# 2. 恢复旧版本JAR文件
cp /opt/baozipu/backend/backup/backend-previous.jar /opt/baozipu/backend/backend-1.0.0-SNAPSHOT.jar

# 3. 重新启动服务
/opt/baozipu/backend/service.sh start
```

#### 5.2 前端回滚
```bash
# 回滚到上一个版本
# 1. 恢复旧版本前端文件
rm -rf /opt/baozipu/frontend/dist/*
cp -r /opt/baozipu/frontend/backup/dist/* /opt/baozipu/frontend/dist/

# 2. 重新加载Nginx配置
nginx -t && systemctl reload nginx
```

#### 5.3 数据库回滚
```bash
# 回滚到上一个版本
# 1. 恢复数据库备份
mysql -u root -p openclaw < /opt/baozipu/database/backup/schema-backup-$(date +%Y%m%d).sql
```

### 6. 部署验证

#### 6.1 服务健康检查
```bash
# 检查后端服务
curl http://localhost:8081/health

# 检查前端页面
curl http://localhost/

# 检查API接口
curl http://localhost/api/health
```

#### 6.2 端口监听检查
```bash
# 检查端口监听情况
netstat -tlnp | grep -E '80|8081'
```

## 部署顺序

1. 确保服务器环境已验证（Java 21, MySQL, Redis, Nginx）
2. 初始化数据库并执行schema.sql
3. 部署后端JAR文件并启动服务
4. 部署前端静态文件到Nginx目录
5. 配置并启用Nginx反向代理
6. 验证所有服务正常运行

## 注意事项

- Java服务监听8081端口，Nginx需配置反向代理到8081
- 确保防火墙允许80端口访问
- 配置适当的日志轮转策略
- 监控服务内存使用情况，必要时调整JVM参数