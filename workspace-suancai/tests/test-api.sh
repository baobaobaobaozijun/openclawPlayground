#!/bin/bash

BASE_URL="http://localhost:8081/api"

echo "=== 测试文章列表 ==="
curl -s "$BASE_URL/articles?page=0&size=10" | jq .

echo "=== 测试文章详情 ==="
curl -s "$BASE_URL/articles/1" | jq .

echo "=== 测试创建文章 ==="
curl -s -X POST "$BASE_URL/articles" \
  -H "Content-Type: application/json" \
  -d '{"title":"测试文章","content":"内容","categoryId":1}' | jq .

echo "=== 测试评论列表 ==="
curl -s "$BASE_URL/comments?articleId=1" | jq .

echo "=== 测试完成 ==="