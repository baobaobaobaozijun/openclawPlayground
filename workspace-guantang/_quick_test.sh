#!/bin/bash
echo "=== PORTS ==="
ss -tlnp | grep 8081

echo "=== API CATEGORIES ==="
curl -s -w "\nHTTP:%{http_code}" http://localhost:8081/api/categories
echo

echo "=== API TAGS ==="
curl -s -w "\nHTTP:%{http_code}" http://localhost:8081/api/tags
echo

echo "=== API ARTICLES ==="
curl -s -w "\nHTTP:%{http_code}" http://localhost:8081/api/articles
echo

echo "=== AUTH LOGIN ==="
curl -s -w "\nHTTP:%{http_code}" -X POST http://localhost:8081/api/auth/login -H "Content-Type: application/json" -d '{"username":"admin","password":"admin123"}'
echo

echo "=== NGINX PROXY ==="
curl -s -w "\nHTTP:%{http_code}" http://localhost/api/categories
echo

echo "=== HOMEPAGE ==="
curl -s -o /dev/null -w "HTTP:%{http_code}" http://localhost/
echo
