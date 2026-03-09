<!-- Last Modified: 2026-03-08 -->
<!-- Last Modified (CN): 2026-03-08 -->

# 閰辫倝 (鍚庣宸ョ▼甯? - 瀹屾暣閰嶇疆涓庣煡璇嗗簱

馃ォ **OpenClaw 鍚庣鏋舵瀯甯?/ 鎶€鏈礋璐ｄ汉**

---

## 馃摎 蹇€熷鑸?
- [韬唤璁ょ煡](./IDENTITY.md) - 鎴戞槸璋?- [鑱岃矗瑙勮寖](./ROLE.md) - 鎴戝仛浠€涔?- [琛屼负鍑嗗垯](./SOUL.md) - 鎴戝浣曞伐浣?- [鎶€鏈爤瑙勮寖](#鎶€鏈爤瑙勮寖) - 浣跨敤浠€涔堟妧鏈?- [寮€鍙戞渶浣冲疄璺礭(#寮€鍙戞渶浣冲疄璺? - 濡備綍鍋?- [甯歌闂瑙ｅ喅](#甯歌闂涓庤В鍐虫柟妗? - 闂鎺掓煡

---

## 馃懁 Agent 韬唤

**鍚嶇О:** 閰辫倝  
**瑙掕壊:** 鍚庣宸ョ▼甯?/ 绯荤粺鏋舵瀯甯? 
**鑱岃矗:** 璐熻矗鎵€鏈夊悗绔笟鍔′唬鐮佺殑瀹炵幇銆佹暟鎹簱璁捐銆佺郴缁熸灦鏋?
**鏍稿績閰嶇疆鏂囦欢:**
- [IDENTITY.md](./IDENTITY.md) - 韬唤璁ょ煡
- [ROLE.md](./ROLE.md) - 鑱岃矗瑙勮寖
- [SOUL.md](./SOUL.md) - 琛屼负鍑嗗垯

---

## 馃捇 鎶€鏈爤瑙勮寖

### 鏍稿績鎶€鏈爤

```
璇█锛欽ava 21 (LTS)
妗嗘灦锛歋pring Boot 3.2+
鏋勫缓宸ュ叿锛歁aven 3.9+ / Gradle 8+
JVM: OpenJDK 21 (HotSpot)
```

### 瀹屾暣鎶€鏈竻鍗?
| 绫诲埆 | 鎶€鏈€夊瀷 | 鐗堟湰 |
|------|---------|------|
| **缂栫▼璇█** | Java | 21 (LTS) |
| **Web 妗嗘灦** | Spring Boot | 3.2+ |
| **Spring 鐢熸€?* | Spring MVC, Spring Data JPA, Spring Security | 6.x |
| **鏁版嵁搴?* | MySQL | 8.0+ |
| **缂撳瓨** | Redis | 7.0+ |
| **ORM** | Hibernate / MyBatis-Plus | 6.x / 3.5+ |
| **璁よ瘉** | Spring Security + JWT | - |
| **API 鏂囨。** | SpringDoc OpenAPI (Swagger) | 2.x |
| **娴嬭瘯** | JUnit 5, Mockito, Testcontainers | 5.10+ |
| **鏋勫缓宸ュ叿** | Maven | 3.9+ |
| **瀹瑰櫒鍖?* | Docker, Docker Compose | - |

---

## 馃彈锔?寮€鍙戞渶浣冲疄璺?
### 1. RESTful API 璁捐瑙勮寖

#### Controller 绀轰緥

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

#### 缁熶竴鍝嶅簲鏍煎紡

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
        return new ApiResponse<>(true, "鎿嶄綔鎴愬姛", data, LocalDateTime.now());
    }
    
    public static <T> ApiResponse<T> error(String message) {
        return new ApiResponse<>(false, message, null, LocalDateTime.now());
    }
}
```

### 2. 鏁版嵁搴撹璁″師鍒?
#### Entity 绀轰緥

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

### 3. Service 灞傚疄鐜?
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

### 4. 鎬ц兘浼樺寲

#### 缂撳瓨閰嶇疆

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

### 5. 瀹夊叏閰嶇疆

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

## 鈿狅笍 甯歌闂涓庤В鍐虫柟妗?
### 闂 1: 鏁版嵁搴撹繛鎺ユ睜鑰楀敖

**閿欒淇℃伅:**
```
HikariPool-1 - Connection is not available, request timed out after 30000ms
```

**瑙ｅ喅鏂规:**
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

### 闂 2: N+1 鏌ヨ闂

**閿欒绀轰緥:**
```java
// 鉂?浼氬鑷?N+1 鏌ヨ
List<Article> articles = articleRepository.findAll();
for (Article article : articles) {
    User author = article.getAuthor(); // 姣忔閮芥煡璇㈡暟鎹簱
}
```

**姝ｇ‘鍋氭硶:**
```java
// 鉁?浣跨敤 JOIN FETCH
@Query("SELECT a FROM Article a JOIN FETCH a.author")
List<Article> findAllWithAuthor();
```

### 闂 3: 浜嬪姟澶辨晥

**甯歌鍘熷洜:**
- 鍚岀被涓柟娉曡皟鐢ㄧ粫杩囦簨鍔′唬鐞?- 寮傚父琚崟鑾锋湭閲嶆柊鎶涘嚭

**瑙ｅ喅鏂规:**
```java
@Service
public class ArticleService {
    
    @Autowired
    private ArticleService self; // 娉ㄥ叆鑷韩
    
    public void createArticle() {
        // ...
        self.notifyAuthor(); // 閫氳繃浠ｇ悊璋冪敤锛岀‘淇濅簨鍔＄敓鏁?    }
    
    @Transactional
    public void notifyAuthor() {
        // ...
    }
}
```

---

## 馃摉 瀛︿範璧勬簮

### 瀹樻柟鏂囨。
- [Spring Boot 瀹樻柟鏂囨。](https://spring.io/projects/spring-boot)
- [Spring Framework 鍙傝€冩枃妗(https://docs.spring.io/spring-framework/docs/current/reference/html/)
- [Hibernate ORM 鎸囧崡](https://hibernate.org/orm/documentation/)

### 鏈€浣冲疄璺?- [Spring Boot 鏈€浣冲疄璺礭(https://github.com/spring-projects/spring-boot/wiki)
- [RESTful API 璁捐鎸囧崡](https://restfulapi.net/)

---

*鏈€鍚庢洿鏂帮細2026-03-08*  
*缁存姢鑰咃細閰辫倝Agent*

