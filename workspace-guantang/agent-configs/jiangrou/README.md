# 酱肉 (后端工程师) - 完整配置与知识库

🥩 **OpenClaw 后端架构师 / 技术负责人**

---

## 📚 快速导航

- [身份认知](./IDENTITY.md) - 我是谁
- [职责规范](./ROLE.md) - 我做什么
- [行为准则](./SOUL.md) - 我如何工作
- [技术栈规范](#技术栈规范) - 使用什么技术
- [开发最佳实践](#开发最佳实践) - 如何做
- [常见问题解决](#常见问题与解决方案) - 问题排查

---

## 👤 Agent 身份

**名称:** 酱肉  
**角色:** 后端工程师 / 系统架构师  
**职责:** 负责所有后端业务代码的实现、数据库设计、系统架构

**核心配置文件:**
- [IDENTITY.md](./IDENTITY.md) - 身份认知
- [ROLE.md](./ROLE.md) - 职责规范
- [SOUL.md](./SOUL.md) - 行为准则

---

## 💻 技术栈规范

### 核心技术栈

```
语言：Java 21 (LTS)
框架：Spring Boot 3.2+
构建工具：Maven 3.9+ / Gradle 8+
JVM: OpenJDK 21 (HotSpot)
```

### 完整技术清单

| 类别 | 技术选型 | 版本 |
|------|---------|------|
| **编程语言** | Java | 21 (LTS) |
| **Web 框架** | Spring Boot | 3.2+ |
| **Spring 生态** | Spring MVC, Spring Data JPA, Spring Security | 6.x |
| **数据库** | MySQL | 8.0+ |
| **缓存** | Redis | 7.0+ |
| **ORM** | Hibernate / MyBatis-Plus | 6.x / 3.5+ |
| **认证** | Spring Security + JWT | - |
| **API 文档** | SpringDoc OpenAPI (Swagger) | 2.x |
| **测试** | JUnit 5, Mockito, Testcontainers | 5.10+ |
| **构建工具** | Maven | 3.9+ |
| **容器化** | Docker, Docker Compose | - |

---

## 🏗️ 开发最佳实践

### 1. RESTful API 设计规范

#### Controller 示例

```java
@RestController
@RequestMapping("/api/articles")
@RequiredArgsConstructor
public class ArticleController {
    
    private final ArticleService articleService;
    
    @GetMapping
    public ResponseEntity<Page<ArticleResponse>> getArticles(Pageable pageable) {
        return ResponseEntity.ok(articleService.findAll(pageable));
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<ArticleResponse> getArticle(@PathVariable Long id) {
        return ResponseEntity.ok(articleService.findById(id));
    }
    
    @PostMapping
    public ResponseEntity<ArticleResponse> createArticle(
            @Valid @RequestBody ArticleCreateRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(articleService.create(request));
    }
}
```

#### 统一响应格式

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ApiResponse<T> {
    private boolean success;
    private String message;
    private T data;
    private LocalDateTime timestamp;
    
    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(true, "操作成功", data, LocalDateTime.now());
    }
    
    public static <T> ApiResponse<T> error(String message) {
        return new ApiResponse<>(false, message, null, LocalDateTime.now());
    }
}
```

### 2. 数据库设计原则

#### Entity 示例

```java
@Entity
@Table(name = "articles")
@Data
@EntityListeners(AuditingEntityListener.class)
public class Article {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, length = 200)
    private String title;
    
    @Column(columnDefinition = "TEXT")
    private String content;
    
    @Enumerated(EnumType.STRING)
    private ArticleStatus status = ArticleStatus.DRAFT;
    
    @CreatedDate
    @Column(updatable = false)
    private LocalDateTime createdAt;
    
    @LastModifiedDate
    private LocalDateTime updatedAt;
}

public enum ArticleStatus {
    DRAFT, PUBLISHED, ARCHIVED
}
```

### 3. Service 层实现

```java
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class ArticleService {
    
    private final ArticleRepository articleRepository;
    
    public Page<ArticleResponse> findAll(Pageable pageable) {
        return articleRepository.findByStatus(ArticleStatus.PUBLISHED, pageable)
                .map(this::toResponse);
    }
    
    @Transactional
    public ArticleResponse create(ArticleCreateRequest request) {
        Article article = new Article();
        article.setTitle(request.getTitle());
        article.setContent(request.getContent());
        return toResponse(articleRepository.save(article));
    }
}
```

### 4. 性能优化

#### 缓存配置

```java
@Service
public class ArticleService {
    
    @Cacheable(value = "articles", key = "#id")
    public ArticleResponse findById(Long id) {
        // ...
    }
    
    @CacheEvict(value = "articles", key = "#id")
    @Transactional
    public void delete(Long id) {
        // ...
    }
}
```

### 5. 安全配置

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        return http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/auth/**").permitAll()
                .anyRequest().authenticated()
            )
            .sessionManagement(sess -> sess.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .build();
    }
}
```

---

## ⚠️ 常见问题与解决方案

### 问题 1: 数据库连接池耗尽

**错误信息:**
```
HikariPool-1 - Connection is not available, request timed out after 30000ms
```

**解决方案:**
```yaml
# application.yml
spring:
  datasource:
    hikari:
      maximum-pool-size: 20
      minimum-idle: 10
      connection-timeout: 30000
      idle-timeout: 600000
      max-lifetime: 1800000
```

### 问题 2: N+1 查询问题

**错误示例:**
```java
// ❌ 会导致 N+1 查询
List<Article> articles = articleRepository.findAll();
for (Article article : articles) {
    User author = article.getAuthor(); // 每次都查询数据库
}
```

**正确做法:**
```java
// ✅ 使用 JOIN FETCH
@Query("SELECT a FROM Article a JOIN FETCH a.author")
List<Article> findAllWithAuthor();
```

### 问题 3: 事务失效

**常见原因:**
- 同类中方法调用绕过事务代理
- 异常被捕获未重新抛出

**解决方案:**
```java
@Service
public class ArticleService {
    
    @Autowired
    private ArticleService self; // 注入自身
    
    public void createArticle() {
        // ...
        self.notifyAuthor(); // 通过代理调用，确保事务生效
    }
    
    @Transactional
    public void notifyAuthor() {
        // ...
    }
}
```

---

## 📖 学习资源

### 官方文档
- [Spring Boot 官方文档](https://spring.io/projects/spring-boot)
- [Spring Framework 参考文档](https://docs.spring.io/spring-framework/docs/current/reference/html/)
- [Hibernate ORM 指南](https://hibernate.org/orm/documentation/)

### 最佳实践
- [Spring Boot 最佳实践](https://github.com/spring-projects/spring-boot/wiki)
- [RESTful API 设计指南](https://restfulapi.net/)

---

*最后更新：2026-03-08*  
*维护者：酱肉Agent*
