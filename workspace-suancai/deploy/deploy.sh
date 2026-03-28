#!/bin/bash

# OpenClaw Deployment Script
# Deploys the application stack using docker-compose
# Includes health checks to verify services are running properly

set -e  # Exit immediately if a command exits with a non-zero status

echo "🚀 Starting OpenClaw deployment..."

# Pull the latest images
echo "🐳 Pulling latest Docker images..."
docker-compose -f docker-compose.yml pull

# Bring up the services
echo "🏗️  Starting services..."
docker-compose -f docker-compose.yml up -d

# Wait a bit for services to start
echo "⏳ Waiting for services to initialize..."
sleep 10

# Health check functions
check_backend_health() {
    echo "🔍 Checking backend health..."
    if curl -sf http://localhost:8081/actuator/health >/dev/null 2>&1; then
        echo "✅ Backend is healthy"
        return 0
    else
        echo "❌ Backend is not responding"
        return 1
    fi
}

check_frontend_health() {
    echo "🔍 Checking frontend health..."
    if curl -sf http://localhost >/dev/null 2>&1; then
        echo "✅ Frontend is accessible"
        return 0
    else
        echo "❌ Frontend is not responding"
        return 1
    fi
}

check_mysql_health() {
    echo "🔍 Checking MySQL health..."
    if docker exec mysql-db mysqladmin ping -u root -prootpassword --silent; then
        echo "✅ MySQL is healthy"
        return 0
    else
        echo "⚠️  MySQL might not be ready yet, waiting..."
        return 1
    fi
}

check_redis_health() {
    echo "🔍 Checking Redis health..."
    if docker exec redis-cache redis-cli ping | grep -q "PONG"; then
        echo "✅ Redis is healthy"
        return 0
    else
        echo "❌ Redis is not responding"
        return 1
    fi
}

# Perform health checks with retries
MAX_RETRIES=30
RETRY_INTERVAL=10

echo "🏥 Performing health checks..."

for i in $(seq 1 $MAX_RETRIES); do
    echo "🏥 Health check attempt $i/$MAX_RETRIES"
    
    backend_ok=1
    frontend_ok=1
    mysql_ok=1
    redis_ok=1
    
    # Check each service
    if docker-compose ps | grep -q "backend-service.*Up"; then
        check_backend_health && backend_ok=0 || backend_ok=1
    else
        echo "❌ Backend service is not running"
        backend_ok=1
    fi
    
    if docker-compose ps | grep -q "frontend-service.*Up"; then
        check_frontend_health && frontend_ok=0 || frontend_ok=1
    else
        echo "❌ Frontend service is not running"
        frontend_ok=1
    fi
    
    if docker-compose ps | grep -q "mysql-db.*Up"; then
        check_mysql_health && mysql_ok=0 || mysql_ok=1
    else
        echo "❌ MySQL service is not running"
        mysql_ok=1
    fi
    
    if docker-compose ps | grep -q "redis-cache.*Up"; then
        check_redis_health && redis_ok=0 || redis_ok=1
    else
        echo "❌ Redis service is not running"
        redis_ok=1
    fi
    
    # If all services are healthy, break the loop
    if [ $backend_ok -eq 0 ] && [ $frontend_ok -eq 0 ] && [ $mysql_ok -eq 0 ] && [ $redis_ok -eq 0 ]; then
        echo "🎉 All services are healthy!"
        break
    else
        echo "⏳ Waiting $RETRY_INTERVAL seconds before next check..."
        sleep $RETRY_INTERVAL
    fi
done

# Final status report
echo ""
echo "📋 Final deployment status:"
docker-compose ps

# Check if any service failed to become healthy
if [ $backend_ok -ne 0 ] || [ $frontend_ok -ne 0 ] || [ $mysql_ok -ne 0 ] || [ $redis_ok -ne 0 ]; then
    echo "🚨 Some services are not healthy after $((MAX_RETRIES * RETRY_INTERVAL)) seconds."
    echo "📋 Service status:"
    docker-compose ps
    exit 1
fi

echo ""
echo "✅ Deployment completed successfully!"
echo "🌐 Application is now available:"
echo "   Frontend: http://localhost"
echo "   Backend: http://localhost:8081"
echo ""

# Show logs for the last 30 seconds
echo "📝 Recent logs:"
docker-compose logs --tail=10

echo "🎉 Deployment validation passed!"