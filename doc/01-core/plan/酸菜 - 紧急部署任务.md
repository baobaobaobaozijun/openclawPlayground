<!-- Last Modified: 2026-03-23 -->

# 🔴 紧急任务：部署到服务器

**负责人:** 酸菜 (Suancai)  
**优先级:** CRITICAL  
**截止时间:** 2026-03-23 20:00

---

## 任务目标

1. 安装并启动 Redis
2. 将后端 JAR 部署到服务器
3. 将前端 dist 部署到 Nginx
4. 验证浏览器可访问

---

## 前置条件

- 酱肉已完成后端打包 (`code/backend/target/*.jar`)
- 豆沙已完成前端打包 (`code/frontend/dist/`)

---

## 执行步骤

### 1. 安装 Redis（之前验证缺失）

```powershell
# 使用 Chocolatey 安装
choco install redis-64 --version 5.0.14.1

# 或手动下载安装
# 下载地址：https://github.com/microsoftarchive/redis/releases

# 启动 Redis 服务
redis-server --service-start

# 验证
redis-cli ping
```

**预期输出:** `PONG`

### 2. 准备部署目录

```powershell
# 创建部署目录
New-Item -ItemType Directory -Path "C:\deploy\baozipu" -Force
New-Item -ItemType Directory -Path "C:\deploy\baozipu\backend" -Force
New-Item -ItemType Directory -Path "C:\deploy\baozipu\frontend" -Force

# 复制后端 JAR
Copy-Item "F:\openclaw\code\backend\target\backend-0.0.1-SNAPSHOT.jar" "C:\deploy\baozipu\backend\"

# 复制前端 dist
Copy-Item "F:\openclaw\code\frontend\dist\*" "C:\deploy\baozipu\frontend\" -Recurse
```

### 3. 配置 application.yml

```powershell
# 编辑 C:\deploy\baozipu\backend\application.yml
# 确保数据库连接、Redis 连接正确
```

**关键配置:**
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/openclaw?useSSL=false&serverTimezone=Asia/Shanghai
    username: root
    password: {你的密码}
  redis:
    host: localhost
    port: 6379

server:
  port: 8080
```

### 4. 启动后端服务

```powershell
cd C:\deploy\baozipu\backend
Start-Process java -ArgumentList "-jar", "backend-0.0.1-SNAPSHOT.jar" -WindowStyle Hidden

# 验证启动
Start-Sleep -Seconds 10
netstat -ano | findstr :8080
```

**预期:** 8080 端口有进程监听

### 5. 配置 Nginx

```powershell
# 编辑 Nginx 配置文件 (通常在 C:\nginx\conf\nginx.conf 或 /etc/nginx/nginx.conf)
```

**配置示例:**
```nginx
server {
    listen 80;
    server_name localhost;

    # 前端静态文件
    location / {
        root C:/deploy/baozipu/frontend;
        index index.html;
        try_files $uri $uri/ /index.html;
    }

    # API 反向代理
    location /api/ {
        proxy_pass http://localhost:8080/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 6. 重启 Nginx

```powershell
# Windows
nginx -s reload

# Linux
sudo systemctl restart nginx
```

### 7. 验证部署

```powershell
# 测试后端 API
Invoke-WebRequest http://localhost:8080/api/auth/login -Method POST -ContentType "application/json" -Body '{}'

# 测试前端页面
Invoke-WebRequest http://localhost/

# 浏览器访问
# http://localhost 或 http://<服务器 IP>
```

### 8. 写工作日志

**文件:** `workinglog/suancai/20260323-XXXXXX-suancai-部署到服务器.md`

**内容:**
- 执行的命令
- 关键配置
- 验证结果（截图或输出）
- 访问地址

---

## 可能的问题及解决

| 问题 | 解决 |
|------|------|
| Redis 安装失败 | 手动下载安装包安装 |
| 后端启动失败 | 检查数据库连接、端口占用 |
| Nginx 配置不生效 | 检查配置文件路径，重新加载 |
| 前端页面空白 | 检查浏览器控制台错误，确认 API 地址 |

---

## 验收标准

- [ ] Redis 已安装并启动 (`redis-cli ping` 返回 PONG)
- [ ] 后端 JAR 已部署并运行 (8080 端口可访问)
- [ ] 前端 dist 已部署到 Nginx
- [ ] 浏览器访问 `http://localhost` 或 `http://<服务器 IP>` 能看到页面
- [ ] 工作日志已写

---

*灌汤 (PM) | 2026-03-23*
