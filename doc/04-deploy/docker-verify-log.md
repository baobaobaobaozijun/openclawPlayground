# Docker 部署脚本验证日志

## 验证时间
2026-04-10 19:12:03

## 验证内容
- docker-compose.yml 语法验证
- 部署配置检查

## 验证结果
✅ 语法验证通过

## 详细输出
```
time="2026-04-10T19:12:03+08:00" level=warning msg="F:\\openclaw\\agent\\workspace-suancai\\deploy\\docker-compose.yml: the attribute 'version' is obsolete, it will be ignored, please remove it to avoid potential confusion"
name: deploy
services:
  backend:
    container_name: backend-service
    depends_on:
      mysql:
        condition: service_started
        required: true
      redis:
        condition: service_started
        required: true
    environment:
      DB_HOST: mysql
      DB_NAME: openclaw
      DB_PORT: "3306"
      REDIS_HOST: redis
      REDIS_PORT: "6379"
      SPRING_PROFILES_ACTIVE: prod
    image: openclaw/backend:latest
    networks:
      app-network: null
    ports:
      - mode: ingress
        target: 8081
        published: "8081"
        protocol: tcp
  frontend:
    container_name: frontend-service
    depends_on:
      backend:
        condition: service_started
        required: true
    image: openclaw/frontend:latest
    networks:
      app-network: null
    ports:
      - mode: ingress
        target: 80
        published: "80"
        protocol: tcp
  mysql:
    container_name: mysql-db
    environment:
      MYSQL_DATABASE: openclaw
      MYSQL_PASSWORD: password123
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_USER: openclaw_user
    image: mysql:8.0
    networks:
      app-network: null
    ports:
      - mode: ingress
        target: 3306
        published: "3306"
        protocol: tcp
    volumes:
      - type: volume
        source: mysql_data
        target: /var/lib/mysql
        volume: {}
      - type: bind
        source: F:\openclaw\agent\workspace-suancai\deploy\init
        target: /docker-entrypoint-initdb.d
        bind:
          create_host_path: true
  redis:
    container_name: redis-cache
    image: redis:7-alpine
    networks:
      app-network: null
    ports:
      - mode: ingress
        target: 6379
        published: "6379"
        protocol: tcp
    volumes:
      - type: volume
        source: redis_data
        target: /data
        volume: {}
networks:
  app-network:
    name: deploy_app-network
    driver: bridge
volumes:
  mysql_data:
    name: deploy_mysql_data
  redis_data:
    name: deploy_redis_data
```

## 验证结论
docker-compose.yml 语法正确，配置完整，可以用于部署。