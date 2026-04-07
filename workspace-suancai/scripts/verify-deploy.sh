#!/bin/bash

echo "=== 部署验证 ==="

# 检查后端端口
if netstat -tlnp | grep :8081 > /dev/null; then
    echo "✅ 后端端口 8081 监听中"
else
    echo "❌ 后端端口 8081 未监听"
fi

# 检查前端静态文件
if [ -d "/var/www/html/dist" ] || [ -d "/opt/baozipu/frontend/dist" ]; then
    echo "✅ 前端静态文件存在"
else
    echo "❌ 前端静态文件不存在"
fi

# 检查 Nginx 配置
if nginx -t > /dev/null 2>&1; then
    echo "✅ Nginx 配置语法正确"
else
    echo "❌ Nginx 配置语法错误"
fi

# 测试 API
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8081/api/articles)
if [ "$response" = "200" ]; then
    echo "✅ API 响应正常"
else
    echo "❌ API 响应异常 (HTTP $response)"
fi

echo "=== 验证完成 ==="