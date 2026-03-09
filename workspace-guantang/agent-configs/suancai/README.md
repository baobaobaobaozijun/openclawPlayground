<!-- Last Modified: 2026-03-08 -->
<!-- Last Modified (CN): 2026-03-08 -->

# 閰歌彍 (杩愮淮/娴嬭瘯宸ョ▼甯? - 瀹屾暣閰嶇疆涓庣煡璇嗗簱

馃ガ **OpenClaw 杩愮淮璐熻矗浜?/ 璐ㄩ噺淇濋殰涓撳**

---

## 馃摎 蹇€熷鑸?
- [韬唤璁ょ煡](./IDENTITY.md) - 鎴戞槸璋?- [鑱岃矗瑙勮寖](./ROLE.md) - 鎴戝仛浠€涔?- [琛屼负鍑嗗垯](./SOUL.md) - 鎴戝浣曞伐浣?- [DevOps鏈€浣冲疄璺礭(#devops-鏈€浣冲疄璺? - 閮ㄧ讲杩愮淮
- [鑷姩鍖栨祴璇昡(#鑷姩鍖栨祴璇曟寚鍗? - 娴嬭瘯绛栫暐
- [鐩戞帶鍛婅](#鐩戞帶涓庡憡璀﹂厤缃? - 绯荤粺鐩戞帶
- [甯歌闂瑙ｅ喅](#鏁呴殰鎺掓煡鎵嬪唽) - 鏁呴殰澶勭悊

---

## 馃懁 Agent 韬唤

**鍚嶇О:** 閰歌彍  
**瑙掕壊:** 杩愮淮宸ョ▼甯?/ 娴嬭瘯涓撳  
**鑱岃矗:** 璐熻矗绯荤粺閮ㄧ讲銆丆I/CD銆佺洃鎺у憡璀︺€佽嚜鍔ㄥ寲娴嬭瘯銆佽川閲忕鐞?
**鏍稿績閰嶇疆鏂囦欢:**
- [IDENTITY.md](./IDENTITY.md) - 韬唤璁ょ煡
- [ROLE.md](./ROLE.md) - 鑱岃矗瑙勮寖
- [SOUL.md](./SOUL.md) - 琛屼负鍑嗗垯

---

## 馃洜锔?DevOps鏈€浣冲疄璺?
### 1. Docker瀹瑰櫒鍖栭儴缃?
#### Dockerfile绀轰緥

```dockerfile
# 鍚庣鏈嶅姟 Dockerfile
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

#### Docker Compose閰嶇疆

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

### 2. CI/CD娴佺▼璁捐

#### GitHub Actions宸ヤ綔娴?
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

## 馃И 鑷姩鍖栨祴璇曟寚鍗?
### 1. 鍗曞厓娴嬭瘯 (JUnit 5)

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
        request.setTitle("娴嬭瘯鏂囩珷");
        request.setContent("鍐呭");
        
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
        assertThat(response.getTitle()).isEqualTo("娴嬭瘯鏂囩珷");
    }
}
```

### 2. 闆嗘垚娴嬭瘯 (Testcontainers)

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
        request.setTitle("闆嗘垚娴嬭瘯鏂囩珷");
        
        // When
        ResponseEntity<ArticleResponse> createResponse = restTemplate.postForEntity(
            "/api/articles", request, ArticleResponse.class);
        
        Long articleId = createResponse.getBody().getId();
        
        // Then
        ResponseEntity<ArticleResponse> getResponse = restTemplate.getForEntity(
            "/api/articles/" + articleId, ArticleResponse.class);
        
        assertThat(getResponse.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(getResponse.getBody().getTitle()).isEqualTo("闆嗘垚娴嬭瘯鏂囩珷");
    }
}
```

### 3. 鎬ц兘娴嬭瘯 (JMeter/Gatling)

```scala
// Gatling鎬ц兘娴嬭瘯鑴氭湰
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
      .body(StringBody("""{"title": "娴嬭瘯", "content": "鍐呭"}"""))
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

## 馃搳 鐩戞帶涓庡憡璀﹂厤缃?
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

### 2. Prometheus鐩戞帶鎸囨爣

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

### 3. Grafana浠〃鏉?
鍏抽敭鐩戞帶闈㈡澘:
- **JVM鎸囨爣**: 鍐呭瓨浣跨敤銆丟C娆℃暟銆佺嚎绋嬫暟
- **HTTP璇锋眰**: QPS銆佸搷搴旀椂闂淬€侀敊璇巼
- **鏁版嵁搴?*: 杩炴帴姹犵姸鎬併€佹煡璇㈣€楁椂
- **缂撳瓨**: Redis鍛戒腑鐜囥€佸唴瀛樹娇鐢?
### 4. 鍛婅瑙勫垯

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
          summary: "閿欒鐜囪繃楂?({{ $value | humanizePercentage }})"
      
      - alert: SlowResponse
        expr: histogram_quantile(0.95, rate(http_server_requests_seconds_bucket[5m])) > 2
        for: 10m
        annotations:
          summary: "P95 鍝嶅簲鏃堕棿瓒呰繃 2 绉?
```

---

## 馃攳 鏁呴殰鎺掓煡鎵嬪唽

### 鎺掓煡娴佺▼

```
1. 鐜拌薄纭 鈫?2. 鏌ョ湅鐩戞帶 鈫?3. 妫€鏌ユ棩蹇?鈫?4. 瀹氫綅闂 鈫?5. 瀹炴柦淇 鈫?6. 楠岃瘉缁撴灉
```

### 甯歌闂

#### 闂 1: 搴旂敤鍚姩澶辫触

**鎺掓煡姝ラ:**
```bash
# 1. 鏌ョ湅瀹瑰櫒鏃ュ織
docker-compose logs backend

# 2. 妫€鏌ョ鍙ｅ崰鐢?netstat -tlnp | grep 8080

# 3. 楠岃瘉鏁版嵁搴撹繛鎺?docker-compose exec backend java -jar app.jar --debug

# 4. 妫€鏌?JVM鍐呭瓨
docker stats
```

#### 闂 2: 鏁版嵁搴撹繛鎺ヨ秴鏃?
**瑙ｅ喅鏂规:**
```yaml
# application.yml
spring:
  datasource:
    hikari:
      connection-timeout: 30000
      maximum-pool-size: 20
      idle-timeout: 600000
```

#### 闂 3: 鍐呭瓨娉勬紡

**璇婃柇鏂规硶:**
```bash
# 瀵煎嚭鍫嗚浆鍌?jmap -dump:format=b,file=heap.hprof <pid>

# 浣跨敤 MAT 鍒嗘瀽
# 鏌ユ壘鍐呭瓨娉勬紡鐐?```

---

## 馃摉 瀛︿範璧勬簮

### 瀹樻柟鏂囨。
- [Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html)
- [Prometheus 鏂囨。](https://prometheus.io/docs/)
- [Docker 鏂囨。](https://docs.docker.com/)
- [JUnit 5 鐢ㄦ埛鎸囧崡](https://junit.org/junit5/docs/current/user-guide/)

### 鏈€浣冲疄璺?- [The Twelve-Factor App](https://12factor.net/)
- [Google SRE Handbook](https://sre.google/sre-book/)

---

*鏈€鍚庢洿鏂帮細2026-03-08*  
*缁存姢鑰咃細閰歌彍Agent*

