# 酸菜 (Suancai) - 完整技术文档

🥬 **运维工程师 / 测试专家**

---

## 📚 快速导航

- [身份认知](./IDENTITY.md) - 我是谁
- [职责规范](./ROLE.md) - 我做什么
- [行为准则](./SOUL.md) - 我如何工作
- [DevOps最佳实践](#devops-最佳实践) - 部署运维
- [自动化测试](#自动化测试指南) - 测试策略
- [监控告警](#监控与告警配置) - 系统监控
- [常见问题解决](#故障排查手册) - 故障处理

---

## 👤 Agent 身份

**名称:** 酸菜  
**角色:** 运维工程师 / 测试专家  
**职责:** 负责系统部署、CI/CD、监控告警、自动化测试、质量管理

**核心配置文件:**
- [IDENTITY.md](./IDENTITY.md) - 身份认知
- [ROLE.md](./ROLE.md) - 职责规范
- [SOUL.md](./SOUL.md) - 行为准则

---

## 💻 技术栈规范

### DevOps 工具链

| 技术 | 版本 | 用途 | 说明 |
|------|------|------|------|
| **Docker** | latest | 容器化 | 应用打包和部署 |
| **Docker Compose** | 2.x | 容器编排 | 多容器应用管理 |
| **Kubernetes** | 1.29+ | 容器编排 | 生产环境（可选） |
| **Jenkins** | 2.x | CI/CD | 持续集成和部署 |
| **GitHub Actions** | latest | CI/CD | GitHub 原生 CI/CD |

### 监控与日志

| 技术 | 版本 | 用途 |
|------|------|------|
| **Prometheus** | 2.x | 指标监控 |
| **Grafana** | 10.x | 可视化面板 |
| **ELK Stack** | 8.x | 日志收集和分析 |
| **Alertmanager** | latest | 告警管理 |

### 测试框架

| 技术 | 版本 | 用途 |
|------|------|------|
| **JUnit 5** | 5.10+ | Java 单元测试 |
| **Testcontainers** | 1.19+ | 集成测试 |
| **Mockito** | 5.x | Mock 框架 |
| **Gatling** | 3.10+ | 性能测试 |
| **Playwright** | latest | E2E 测试 |

### 基础设施即代码

| 技术 | 版本 | 用途 |
|------|------|------|
| **Terraform** | 1.6+ | 基础设施管理 |
| **Ansible** | 2.15+ | 配置管理 |
| **Helm** | 3.x | K8s 包管理 |

---

## 🏗️ 项目结构规范

### 运维目录结构

```
deploy/
├── docker/
│   ├── Dockerfile.backend      # 后端 Docker 镜像
│   ├── Dockerfile.frontend     # 前端 Docker 镜像
│   └── docker-compose.yml     # Docker Compose 配置
├── kubernetes/
│   ├── namespace.yaml         # 命名空间定义
│   ├── deployments/
│   │   ├── backend.yaml
│   │   └── frontend.yaml
│   ├── services/
│   │   ├── backend-svc.yaml
│   │   └── frontend-svc.yaml
│   ├── configmaps/
│   │   └── app-config.yaml
│   └── secrets/
│       └── db-secret.yaml
├── jenkins/
│   ├── Jenkinsfile             # Jenkins 流水线
│   └── scripts/
│       └── deploy.sh
├── monitoring/
│   ├── prometheus.yml         # Prometheus 配置
│   ├── alert-rules.yml        # 告警规则
│   └── grafana-dashboards/    # Grafana 仪表板
└── ansible/
    ├── inventory.ini           # 主机清单
    ├── playbooks/
    │   ├── deploy.yml
    │   └── backup.yml
    └── roles/
        ├── webserver/
        └── database/
```

### 测试目录结构

```
tests/
├── unit/                      # 单元测试
│   ├── backend/
│   │   ├── controller/
│   │   ├── service/
│   │   └── repository/
│   └── frontend/
│       ├── components/
│       └── utils/
├── integration/               # 集成测试
│   ├── api/
│   │   ├── ArticleApiTest.java
│   │   └── UserApiTest.java
│   └── database/
│       └── DatabaseMigrationTest.java
├── e2e/                       # E2E 测试
│   ├── specs/
│   │   ├── login.spec.ts
│   │   └── article-management.spec.ts
│   └── fixtures/
│       └── test-data.json
├── performance/               # 性能测试
│   ├── gatling/
│   │   └── simulations/
│   │       └── BlogLoadSimulation.scala
│   └── jmeter/
│       └── blog-test-plan.jmx
└── common/                    # 公共测试工具
    ├── TestDataFactory.java
    └── TestBase.java
```

---

## 🔧 运维最佳实践

### 1. Docker 镜像构建规范

**Dockerfile 示例:**
```dockerfile
# backend/Dockerfile
FROM eclipse-temurin:21-jdk-alpine AS builder

WORKDIR /app

# 复制 Maven 配置，利用缓存
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 复制源代码并构建
COPY src ./src
RUN mvn clean package -DskipTests -B

# 运行阶段
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# 安装必要工具
RUN apk add --no-cache curl jq

# 从构建阶段复制 jar 包
COPY --from=builder /app/target/blog-backend.jar app.jar

# 创建非 root 用户
RUN addgroup -g 1001 appgroup && \
    adduser -u 1001 -G appgroup -D appuser
USER appuser

# 暴露端口
EXPOSE 8080

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

# 启动应用
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### 2. Docker Compose 配置规范

```yaml
# docker-compose.yml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
  container_name: blog-mysql
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}
      MYSQL_DATABASE: blog
      MYSQL_USER: blog_user
      MYSQL_PASSWORD: ${DB_PASSWORD}
    volumes:
      - mysql-data:/var/lib/mysql
      - ./init-scripts:/docker-entrypoint-initdb.d
    networks:
      - blog-network
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
     timeout: 5s
     retries: 5

 redis:
    image: redis:7-alpine
  container_name: blog-redis
   command: redis-server --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis-data:/data
    networks:
      - blog-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
     timeout: 5s
     retries: 5

  backend:
    build:
     context: ../code/backend
      dockerfile: ../../deploy/docker/Dockerfile.backend
  container_name: blog-backend
   ports:
      - "8080:8080"
    environment:
      SPRING_PROFILES_ACTIVE: prod
      DB_HOST: mysql
      DB_PORT: 3306
      DB_NAME: blog
      DB_USERNAME: blog_user
      DB_PASSWORD: ${DB_PASSWORD}
      REDIS_HOST: redis
      REDIS_PORT: 6379
      REDIS_PASSWORD: ${REDIS_PASSWORD}
    depends_on:
      mysql:
       condition: service_healthy
     redis:
       condition: service_healthy
    networks:
      - blog-network
   restart: unless-stopped

  frontend:
    build:
     context: ../code/frontend
      dockerfile: ../../deploy/docker/Dockerfile.frontend
  container_name: blog-frontend
   ports:
      - "80:80"
    depends_on:
      - backend
    networks:
      - blog-network
   restart: unless-stopped

volumes:
  mysql-data:
 redis-data:

networks:
  blog-network:
    driver: bridge
```

### 3. Jenkins Pipeline 配置

```groovy
// Jenkinsfile
pipeline {
   agent any
    
    environment {
        DOCKER_REGISTRY = 'registry.example.com'
        IMAGE_VERSION = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
               git branch: 'main', 
                    url: 'https://github.com/your-repo/blog.git'
            }
        }
        
        stage('Build Backend') {
            steps {
                dir('code/backend') {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }
        
        stage('Unit Tests') {
            steps {
                dir('code/backend') {
                   sh'mvn test'
                }
            }
          post {
               always {
                   junit 'code/backend/target/surefire-reports/*.xml'
               }
           }
        }
        
        stage('Integration Tests') {
            steps {
                script {
                   // 启动测试环境
                    dockerCompose.build()
                   dockerCompose.up()
                }
            }
          post {
               always {
                   dockerCompose.down()
               }
           }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                   docker.build("${DOCKER_REGISTRY}/blog-backend:${IMAGE_VERSION}", 
                               "deploy/docker")
                }
            }
        }
        
        stage('Push to Registry') {
            steps {
                script {
                   docker.withRegistry("https://${DOCKER_REGISTRY}", 'docker-credentials') {
                       docker.image("${DOCKER_REGISTRY}/blog-backend:${IMAGE_VERSION}").push()
                   }
                }
            }
        }
        
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                sh '''
                    kubectl set image deployment/blog-backend \
                        blog-backend=${DOCKER_REGISTRY}/blog-backend:${IMAGE_VERSION}
                '''
            }
        }
    }
    
  post {
       success {
          echo 'Pipeline completed successfully!'
       }
       failure {
          echo 'Pipeline failed! Sending notification...'
           // 发送通知逻辑
       }
   }
}
```

### 4. Prometheus 监控配置

```yaml
# prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

alerting:
  alertmanagers:
    - static_configs:
        - targets: ['alertmanager:9093']

rule_files:
  - alert-rules.yml

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'backend'
   metrics_path: '/actuator/prometheus'
    static_configs:
      - targets: ['backend:8080']

  - job_name: 'mysql'
    static_configs:
      - targets: ['mysqld-exporter:9104']

  - job_name: 'redis'
    static_configs:
      - targets: ['redis-exporter:9121']

  - job_name: 'node'
    static_configs:
      - targets: ['node-exporter:9100']
```

### 5. Grafana 告警规则

```yaml
# alert-rules.yml
groups:
  - name: blog-alerts
    rules:
      - alert: BackendDown
       expr: up{job="backend"} == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "后端服务宕机"
          description: "后端服务 {{ $labels.instance }} 已宕机超过 1 分钟"

      - alert: HighErrorRate
       expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.05
        for: 2m
        labels:
          severity: warning
        annotations:
          summary: "错误率过高"
          description: "API 错误率超过 5% (当前值：{{ $value }})"

      - alert: HighResponseTime
       expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "响应时间过长"
          description: "P95 响应时间超过 1 秒 (当前值：{{ $value }}s)"

      - alert: DatabaseConnectionPoolExhausted
       expr: hikaricp_connections_active / hikaricp_connections_max > 0.9
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "数据库连接池即将耗尽"
          description: "数据库连接池使用率超过 90% (当前值：{{ $value | humanizePercentage }})"
```

---

## 🧪 测试最佳实践

### 1. 单元测试规范 (JUnit 5)

```java
// ArticleServiceTest.java
@SpringBootTest
@ExtendWith(MockitoExtension.class)
class ArticleServiceTest {

    @Mock
    private ArticleRepository articleRepository;

    @InjectMocks
    private ArticleServiceImpl articleService;

    @Test
    @DisplayName("创建文章 - 成功场景")
    void createArticle_Success() {
        // Given
        CreateArticleRequest request = new CreateArticleRequest(
            "测试标题", 
            "测试内容", 
            1L
        );
        
        Article savedArticle = Article.builder()
           .id(1L)
           .title(request.getTitle())
           .content(request.getContent())
           .authorId(request.getAuthorId())
           .build();

        when(articleRepository.save(any(Article.class)))
           .thenReturn(savedArticle);

        // When
        ArticleVO result = articleService.create(request);

        // Then
        assertNotNull(result);
       assertEquals(1L, result.getId());
       assertEquals("测试标题", result.getTitle());
       verify(articleRepository, times(1)).save(any(Article.class));
    }

    @Test
    @DisplayName("获取文章 - 文章不存在")
    void getById_NotFound() {
        // Given
        Long articleId = 999L;
        when(articleRepository.findById(articleId))
           .thenThrow(new ResourceNotFoundException("文章不存在"));

        // When & Then
        assertThrows(ResourceNotFoundException.class, () -> {
          articleService.getById(articleId);
        });
    }

    @Test
    @DisplayName("更新文章 - 乐观锁冲突")
    void updateArticle_OptimisticLockConflict() {
        // Given
       UpdateArticleRequest request = new UpdateArticleRequest(
            "新标题", 
            "新内容", 
           1
        );
        
        when(articleRepository.findById(1L))
           .thenReturn(Optional.of(createArticle()));
        when(articleRepository.save(any()))
           .thenThrow(new OptimisticLockingFailureException("版本冲突"));

        // When & Then
        assertThrows(OptimisticLockingFailureException.class, () -> {
          articleService.update(1L, request);
        });
    }
}
```

### 2. 集成测试规范 (Testcontainers)

```java
// ArticleApiIntegrationTest.java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@Testcontainers
@ActiveProfiles("test")
class ArticleApiIntegrationTest {

    @Container
    static MySQLContainer<?> mysql = new MySQLContainer<>("mysql:8.0")
       .withDatabaseName("test_db")
       .withUsername("test")
       .withPassword("test");

    @Container
    static RedisContainer<?> redis = new RedisContainer<>("redis:7-alpine");

    @DynamicPropertySource
    static void configureTestProperties(DynamicPropertyRegistry registry) {
      registry.add("spring.datasource.url", mysql::getJdbcUrl);
      registry.add("spring.datasource.username", mysql::getUsername);
      registry.add("spring.datasource.password", mysql::getPassword);
      registry.add("spring.redis.host", redis::getHost);
      registry.add("spring.redis.port", () -> redis.getMappedPort(6379).toString());
    }

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    @DisplayName("文章 CRUD 集成测试")
    void articleCRUD_IntegrationTest() {
        // Create
        CreateArticleRequest createRequest = new CreateArticleRequest(
           "集成测试文章", 
           "这是测试内容", 
           1L
        );
        
        ResponseEntity<ArticleVO> createResponse = restTemplate.postForEntity(
           "/api/v1/articles", 
          createRequest, 
           ArticleVO.class
        );
        
       assertEquals(HttpStatus.CREATED, createResponse.getStatusCode());
       assertNotNull(createResponse.getBody());
       Long articleId = createResponse.getBody().getId();

        // Read
        ResponseEntity<ArticleVO> getResponse = restTemplate.getForEntity(
           "/api/v1/articles/" + articleId, 
           ArticleVO.class
        );
        
       assertEquals(HttpStatus.OK, getResponse.getStatusCode());
       assertEquals("集成测试文章", getResponse.getBody().getTitle());

        // Update
       UpdateArticleRequest updateRequest = new UpdateArticleRequest(
           "更新后的标题", 
           "更新后的内容", 
           1
        );
        
      restTemplate.put("/api/v1/articles/" + articleId, updateRequest);

        // Verify update
        ResponseEntity<ArticleVO> getAfterUpdate = restTemplate.getForEntity(
           "/api/v1/articles/" + articleId, 
           ArticleVO.class
        );
        
       assertEquals("更新后的标题", getAfterUpdate.getBody().getTitle());

        // Delete
      restTemplate.delete("/api/v1/articles/" + articleId);

        // Verify delete
        ResponseEntity<ArticleVO> getAfterDelete = restTemplate.getForEntity(
           "/api/v1/articles/" + articleId, 
           ArticleVO.class
        );
        
       assertEquals(HttpStatus.NOT_FOUND, getAfterDelete.getStatusCode());
    }
}
```

### 3. 性能测试规范 (Gatling)

```scala
// BlogLoadSimulation.scala
class BlogLoadSimulation extends Simulation {

  val httpProtocol = http
    .baseUrl("http://localhost:8080")
    .acceptHeader("application/json")
    .contentTypeHeader("application/json")

  val headers = Map(
    "Authorization" -> "Bearer ${token}"
  )

  // 场景 1: 浏览文章列表
  val browseArticles = scenario("Browse Articles")
    .exec(
      http("Get Articles")
        .get("/api/v1/articles?page=0&size=10")
        .headers(headers)
        .check(status.is(200))
    )

  // 场景 2: 查看文章详情
  val viewArticleDetail = scenario("View Article Detail")
    .exec(
      http("Get Article")
        .get("/api/v1/articles/${articleId}")
        .headers(headers)
        .check(status.is(200))
    )
   .feed(feeder)

  // 场景 3: 创建文章
  val createArticle = scenario("Create Article")
    .exec(
      http("Create Article")
        .post("/api/v1/articles")
        .headers(headers)
        .body(StringBody("""{"title": "${title}", "content": "${content}", "authorId": 1}"""))
        .asJson
        .check(status.is(201))
    )
   .feed(articleFeeder)

  // 负载配置
  setUp(
    browseArticles.inject(
     constantUsersPerSec(10).during(60),
      rampUsersPerSec(10).to(50).during(120)
    ),
    viewArticleDetail.inject(
     constantUsersPerSec(5).during(60),
      rampUsersPerSec(5).to(20).during(120)
    ),
  createArticle.inject(
     constantUsersPerSec(1).during(60),
      rampUsersPerSec(1).to(5).during(120)
    )
  ).protocols(httpProtocol)
   .assertions(
     global.responseTime.max.lt(500),
     global.successfulRequests.percent.lte(99)
   )
}
```

---

## 📊 常见问题与解决

### Q1: 如何实现蓝绿部署？

**解决方案:**

```yaml
# Kubernetes 蓝绿部署配置
apiVersion: apps/v1
kind: Deployment
metadata:
  name: blog-backend-blue
spec:
 replicas: 3
  selector:
   matchLabels:
      app: blog-backend
      version: blue
  template:
   metadata:
      labels:
        app: blog-backend
        version: blue
    spec:
     containers:
        - name: backend
          image: registry.example.com/blog-backend:v1.0.0
         ports:
            - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: blog-backend
spec:
  selector:
    app: blog-backend
    version: blue  # 切换到 green 即可完成蓝绿切换
  ports:
    - port: 80
      targetPort: 8080
```

### Q2: 如何处理数据库迁移？

**解决方案:**

使用 Flyway 进行数据库版本管理：

```xml
<!-- pom.xml -->
<dependency>
    <groupId>org.flywaydb</groupId>
    <artifactId>flyway-core</artifactId>
</dependency>
```

```properties
# application.yml
spring:
 flyway:
    enabled: true
    locations: classpath:db/migration
    baseline-on-migrate: true
```

```sql
-- V1__create_articles_table.sql
CREATE TABLE article (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
   title VARCHAR(200) NOT NULL,
   content TEXT NOT NULL,
    author_id BIGINT NOT NULL,
   created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- V2__add_view_count.sql
ALTER TABLE article ADD COLUMN view_count INT DEFAULT 0;
```

### Q3: 如何配置分布式链路追踪？

**解决方案:**

添加 SkyWalking 或 Jaeger：

```xml
<!-- SkyWalking Agent -->
<dependency>
    <groupId>org.apache.skywalking</groupId>
    <artifactId>apm-toolkit-trace</artifactId>
    <version>9.0.0</version>
</dependency>
```

启动时添加 Agent：
```bash
java -javaagent:/path/to/skywalking-agent.jar \
     -Dskywalking.agent.service_name=blog-backend \
     -Dskywalking.collector.backend_service=skywalking-oap:11800 \
     -jar app.jar
```

---

## ✅ 检查清单

### 发布前检查

- [ ] 所有单元测试通过
- [ ] 集成测试通过
- [ ] 性能测试达标（P95 < 500ms）
- [ ] Docker 镜像构建成功
- [ ] 健康检查端点正常
- [ ] 监控告警配置完成
- [ ] 回滚方案已准备
- [ ] 数据库备份已完成

### 日常巡检

- [ ] CPU 使用率 < 70%
- [ ] 内存使用率 < 80%
- [ ] 磁盘使用率 < 85%
- [ ] 错误日志无异常增长
- [ ] API 响应时间正常
- [ ] 数据库连接池使用正常
- [ ] Redis 缓存命中率正常

---

*最后更新：2026-03-09*  
*维护者：酸菜 (Suancai)*  
*版本：1.0*
