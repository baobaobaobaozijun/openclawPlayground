#!/bin/bash
# API 测试脚本 - Plan-015

BASE_URL="http://localhost:8080/api"

echo "======================================"
echo "  OpenClaw Blog API 测试"
echo "======================================"

# 测试 1: 健康检查
echo -e "\n[测试 1] 健康检查..."
curl -s -w "\nHTTP Status: %{http_code}\n" "$BASE_URL/health"

# 测试 2: 获取文章列表
echo -e "\n[测试 2] 获取文章列表..."
curl -s -w "\nHTTP Status: %{http_code}\n" "$BASE_URL/articles"

# 测试 3: 用户登录
echo -e "\n[测试 3] 用户登录..."
curl -s -w "\nHTTP Status: %{http_code}\n" \
  -X POST "$BASE_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"Test123456"}'

# 测试 4: 用户注册
echo -e "\n[测试 4] 用户注册..."
curl -s -w "\nHTTP Status: %{http_code}\n" \
  -X POST "$BASE_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d '{"username":"newuser","email":"new@example.com","password":"Test123456"}'

# 测试 5: 获取分类列表
echo -e "\n[测试 5] 获取分类列表..."
curl -s -w "\nHTTP Status: %{http_code}\n" "$BASE_URL/categories"

# 测试 6: 获取标签列表
echo -e "\n[测试 6] 获取标签列表..."
curl -s -w "\nHTTP Status: %{http_code}\n" "$BASE_URL/tags"

echo -e "\n======================================"
echo "  测试完成"
echo "======================================"
