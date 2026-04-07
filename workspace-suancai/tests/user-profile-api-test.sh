#!/bin/bash

# 用户中心模块 API 集成测试脚本
# Plan-016 R3 - API 测试

set -e

echo "开始执行用户中心模块 API 集成测试..."

BASE_URL="http://localhost:8080"

# 测试变量
TEST_USER_ID="1"
TEST_USERNAME="testuser"
TEST_EMAIL="testuser@example.com"

# 1. GET /api/user/profile/{userId} 测试
echo "1. 测试 GET /api/user/profile/{userId}"
curl -X GET "${BASE_URL}/api/user/profile/${TEST_USER_ID}" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer test-token" \
  -w "\nHTTP Status: %{http_code}\n" \
  -s

echo ""

# 2. PUT /api/user/profile 测试
echo "2. 测试 PUT /api/user/profile"
curl -X PUT "${BASE_URL}/api/user/profile" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer test-token" \
  -d '{
    "userId": "'${TEST_USER_ID}'",
    "username": "'${TEST_USERNAME}'",
    "email": "'${TEST_EMAIL}'",
    "nickname": "Test User",
    "avatar": "/images/default-avatar.png"
  }' \
  -w "\nHTTP Status: %{http_code}\n" \
  -s

echo ""

# 3. 头像上传接口测试
echo "3. 测试头像上传接口"
curl -X POST "${BASE_URL}/api/user/profile/upload-avatar" \
  -H "Authorization: Bearer test-token" \
  -F "avatar=@./test-data/test-avatar.jpg" \
  -w "\nHTTP Status: %{http_code}\n" \
  -s

echo ""

echo "API 集成测试完成"