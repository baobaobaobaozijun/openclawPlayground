# 酸菜 (运维/测试工程师) - 完整配置与知识库

🥬 **OpenClaw 运维负责人 / 质量保障专家**

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

## 🛠️ DevOps最佳实践

### 1. Docker容器化部署

#### Dockerfile示例

```dockerfile
# 后端服务 Dockerfile
FROM eclipse-temurin:21-jdk-alpine as builder

WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]
```

#### Docker Compose配置

```yaml
version: '3.8'

services:
  backend:
    build: ./backend
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=prod
      - DB_HOST=mysql
      - REDIS_HOST=redis
    depends_on:
      mysql:
        condition: service_healthy
      redis:
        condition: service_started
    volumes:
      - ./logs:/app/logs
    restart: unless-stopped
    networks:
      - openclaw-net

  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: openclaw
    volumes:
      - mysql_data:/var/lib/mysql
    ports:
      - "3306:3306"
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 3
    networks:
      - openclaw-net

  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data
    ports:
      - "6379:6379"
    networks:
      - openclaw-net

volumes:
  mysql_data:
  redis_data:

networks:
  openclaw-net:
    driver: bridge
```

### 2. CI/CD流程设计

#### GitHub Actions工作流

```yaml
name: Java CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    
    services:
      mysql:
        image: mysql:8.0
        env:
          MYSQL_ROOT_PASSWORD: test_password
          MYSQL_DATABASE: test_db
        options: >-
          --health-cmd="mysqladmin ping"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=3
        ports:
          - 3306:3306
      
      redis:
        image: redis:7-alpine
        options: >-
          --health-cmd="redis-cli ping"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=3
        ports:
          - 6379:6379

    steps:
    - uses: actions/checkout@v4
    
    - name: Set up JDK 21
      uses: actions/setup-java@v4
      with:
        java-version: '21'
        distribution: 'temurin'
        cache: maven
    
    - name: Build with Maven
      run: mvn clean compile
    
    - name: Run tests
      run: mvn test
    
    - name: Code coverage
      run: mvn jacoco:report
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        file: target/site/jacoco/jacoco.xml

  deploy:
    needs: build-and-test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Deploy to server
      run: |
        ssh user@server "cd /app && docker-compose pull && docker-compose up -d"
```

---

## 🧪 自动化测试指南

### 1. 单元测试 (JUnit 5)

```java
@SpringBootTest
class ArticleServiceTest {
    
    @Autowired
    private ArticleService articleService;
    
    @MockBean
    private ArticleRepository articleRepository;
    
    @Test
    void shouldCreateArticle() {
        // Given
        ArticleCreateRequest request = new ArticleCreateRequest();
        request.setTitle("测试文章");
        request.setContent("内容");
        
        when(articleRepository.save(any(Article.class)))
            .thenAnswer(invocation -> {
                Article a = invocation.getArgument(0);
                a.setId(1L);
                return a;
            });
        
        // When
        ArticleResponse response = articleService.create(request);
        
        // Then
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getTitle()).isEqualTo("测试文章");
    }
}
```

### 2. 集成测试 (Testcontainers)

```java
@Testcontainers
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class ArticleApiIntegrationTest {
    
    @Container
    static MySQLContainer<?> mysql = new MySQLContainer<>("mysql:8.0")
            .withDatabaseName("testdb")
            .withUsername("test")
            .withPassword("test");
    
    @Container
    static RedisContainer<?> redis = new RedisContainer<>("redis:7-alpine");
    
    @DynamicPropertySource
    static void configureTestProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", mysql::getJdbcUrl);
        registry.add("spring.datasource.username", mysql::getUsername);
        registry.add("spring.datasource.password", mysql::getPassword);
        registry.add("spring.data.redis.host", redis::getHost);
        registry.add("spring.data.redis.port", () -> redis.getMappedPort(6379).toString());
    }
    
    @Autowired
    private TestRestTemplate restTemplate;
    
    @Test
    void shouldCreateAndRetrieveArticle() {
        // Given
        ArticleCreateRequest request = new ArticleCreateRequest();
        request.setTitle("集成测试文章");
        
        // When
        ResponseEntity<ArticleResponse> createResponse = restTemplate.postForEntity(
            "/api/articles", request, ArticleResponse.class);
        
        Long articleId = createResponse.getBody().getId();
        
        // Then
        ResponseEntity<ArticleResponse> getResponse = restTemplate.getForEntity(
            "/api/articles/" + articleId, ArticleResponse.class);
        
        assertThat(getResponse.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(getResponse.getBody().getTitle()).isEqualTo("集成测试文章");
    }
}
```

### 3. 性能测试 (JMeter/Gatling)

```scala
// Gatling性能测试脚本
class ArticleSimulation extends Simulation {
  
  val httpProtocol = http
    .baseUrl("http://localhost:8080")
    .acceptHeader("application/json")
    .contentTypeHeader("application/json")
  
  val scn = scenario("Article API Load Test")
    .exec(http("Get Articles")
      .get("/api/articles"))
    .pause(1)
    .exec(http("Create Article")
      .post("/api/articles")
      .body(StringBody("""{"title": "测试", "content": "内容"}"""))
      .asJson)
  
  setUp(
    scn.inject(
      rampUsersPerSec(1).to(10).during(2.minutes),
      constantUsersPerSec(10).during(5.minutes)
    ).protocols(httpProtocol)
  ).assertions(
    global.responseTime.percentile3.lte(500),
    global.successfulRequests.percent.is(100)
  )
}
```

---

## 📊 监控与告警配置

### 1. Spring Boot Actuator

```yaml
# application.yml
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
  endpoint:
    health:
      show-details: always
  metrics:
    export:
      prometheus:
        enabled: true
```

### 2. Prometheus监控指标

```yaml
# prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'spring-boot'
    metrics_path: '/actuator/prometheus'
    static_configs:
      - targets: ['backend:8080']
```

### 3. Grafana仪表板

关键监控面板:
- **JVM指标**: 内存使用、GC次数、线程数
- **HTTP请求**: QPS、响应时间、错误率
- **数据库**: 连接池状态、查询耗时
- **缓存**: Redis命中率、内存使用

### 4. 告警规则

```yaml
# alerting-rules.yml
groups:
  - name: application_alerts
    rules:
      - alert: HighErrorRate
        expr: sum(rate(http_server_requests_seconds_count{status=~"5.."}[5m])) 
              / sum(rate(http_server_requests_seconds_count[5m])) > 0.05
        for: 5m
        annotations:
          summary: "错误率过高 ({{ $value | humanizePercentage }})"
      
      - alert: SlowResponse
        expr: histogram_quantile(0.95, rate(http_server_requests_seconds_bucket[5m])) > 2
        for: 10m
        annotations:
          summary: "P95 响应时间超过 2 秒"
```

---

## 🔍 故障排查手册

### 排查流程

```
1. 现象确认 → 2. 查看监控 → 3. 检查日志 → 4. 定位问题 → 5. 实施修复 → 6. 验证结果
```

### 常见问题

#### 问题 1: 应用启动失败

**排查步骤:**
```bash
# 1. 查看容器日志
docker-compose logs backend

# 2. 检查端口占用
netstat -tlnp | grep 8080

# 3. 验证数据库连接
docker-compose exec backend java -jar app.jar --debug

# 4. 检查 JVM内存
docker stats
```

#### 问题 2: 数据库连接超时

**解决方案:**
```yaml
# application.yml
spring:
  datasource:
    hikari:
      connection-timeout: 30000
      maximum-pool-size: 20
      idle-timeout: 600000
```

#### 问题 3: 内存泄漏

**诊断方法:**
```bash
# 导出堆转储
jmap -dump:format=b,file=heap.hprof <pid>

# 使用 MAT 分析
# 查找内存泄漏点
```

---

## 📖 学习资源

### 官方文档
- [Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html)
- [Prometheus 文档](https://prometheus.io/docs/)
- [Docker 文档](https://docs.docker.com/)
- [JUnit 5 用户指南](https://junit.org/junit5/docs/current/user-guide/)

### 最佳实践
- [The Twelve-Factor App](https://12factor.net/)
- [Google SRE Handbook](https://sre.google/sre-book/)

---

*最后更新：2026-03-08*  
*维护者：酸菜Agent*
