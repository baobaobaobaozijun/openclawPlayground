# 酱肉 (Jiangrou) - 完整技术文档

<!-- Last Modified: 2026-03-10 -->

🍖 **后端工程师 / 系统架构师**

---

## 📎 快速导航

- [身份认知](./IDENTITY.md) - 我是谁？
- [职责规范](./ROLE.md) - 我做什么？
- [行为准则](./SOUL.md) - 我如何工作？
- [技术栈规范](#技术栈规范) - 使用什么技术？
- [开发最佳实践](#开发最佳实践) - 如何做？
- [常见问题与解决方案](#常见问题与解决) - 问题排查

---

## 👤 Agent 身份

**名称:** 酱肉  
**角色:** 后端工程师 / 系统架构师  
**职责:**负责所有后端业务代码的实现、数据库设计、系统架构

**核心配置文件:**
- [IDENTITY.md](./IDENTITY.md) - 身份认知
- [ROLE.md](./ROLE.md) - 职责规范
- [SOUL.md](./SOUL.md) - 行为准则

---

## 💻 技术栈规范

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
```
@RestController
@RequestMapping("/api/v1/articles")
@RequiredArgsConstructor
public class ArticleController {
    
    private final ArticleService articleService;
    
    @GetMapping
    public ResponseEntity<Page<ArticleVO>> getArticles(
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "10") int size
    ) {
       return ResponseEntity.ok(articleService.findAll(page, size));
    }
    
    @PostMapping
    public ResponseEntity<ArticleVO> createArticle(
        @RequestBody @Validated CreateArticleRequest request
    ) {
       return ResponseEntity.status(HttpStatus.CREATED)
            .body(articleService.create(request));
    }
}
```

#### 统一响应格式
```
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ApiResponse<T> {
    private Integer code;
    private String message;
    private T data;
    
    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(true, "操作成功", data, LocalDateTime.now());
    }
    
    public static <T> ApiResponse<T> error(String message) {
       return new ApiResponse<>(500, message, null);
    }
}
```

### 2. 数据库设计原则

#### Entity 示例
```
@Entity
@Table(name = "article")
public class Article {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String title;
    
    @Column(nullable = false)
    private String content;
    
    @Column(nullable = false)
    private Long authorId;
    
    @Column(nullable = false)
    private Integer status;
    
    @Column(nullable = false)
    private Integer viewCount;
    
    @CreationTimestamp
    private LocalDateTime createdAt;
    
    @UpdateTimestamp
    private LocalDateTime updatedAt;
}

```

### 3. Service 层实现
```
@Slf4j
@Service
@RequiredArgsConstructor
public class ArticleServiceImpl implements ArticleService {
    
    @Override
    @Transactional
    public ArticleVO create(CreateArticleRequest request) {
        log.info("开始创建文章，标题：{}", request.getTitle());
        
       try {
            Article article = convertToEntity(request);
            articleRepository.save(article);
            
            log.info("文章创建成功，ID: {}", article.getId());
           return convertToVO(article);
        } catch (Exception e) {
            log.error("创建文章失败", e);
            throw new BusinessException("创建文章失败");
        }
    }
}
```

### 4. 性能优化

#### 缓存配置

### Q1: JWT Token 如何实现？

**解决方案:**

1. **添加依赖:**
```
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.11.5</version>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-impl</artifactId>
    <version>0.11.5</version>
    <scope>runtime</scope>
</dependency>
```

2. **JWT 工具类:**
```
@Component
public class JwtUtil {
    
    @Value("${jwt.secret}")
    private String secretKey;
    
    @Value("${jwt.expiration}")
    private Long expiration;
    
    public String generateToken(UserDetails userDetails) {
       return Jwts.builder()
            .setSubject(userDetails.getUsername())
            .setIssuedAt(new Date())
            .setExpiration(new Date(System.currentTimeMillis() + expiration))
            .signWith(SignatureAlgorithm.HS256, secretKey)
            .compact();
    }
    
    public Boolean validateToken(String token) {
       try {
            Jwts.parser().setSigningKey(secretKey).parseClaimsJws(token);
           return true;
        } catch (Exception e) {
           return false;
        }
    }
}
```

### 5. 安全配置

```
@Configuration
public class CorsConfig {
    
    @Bean
    public CorsFilter corsFilter() {
        CorsConfiguration config = new CorsConfiguration();
       config.addAllowedOriginPattern("*");
       config.addAllowedHeader("*");
       config.addAllowedMethod("*");
       config.setAllowCredentials(true);
        
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
       source.registerCorsConfiguration("/**", config);
        
       return new CorsFilter(source);
    }
}
```

### Q3: 如何实现 Redis 缓存？

**解决方案:**

1. **添加依赖:**
```
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```

2. **配置 Redis:**
```
spring:
 redis:
    host: localhost
   port: 6379
    password: your_password
    database: 0
    lettuce:
     pool:
       max-active: 8
       max-idle: 8
        min-idle: 0
```

3. **使用缓存:**
```
@Service
public class ArticleServiceImpl implements ArticleService {
    
    @Autowired
    private RedisTemplate<String, Object> redisTemplate;
    
    @Override
    public ArticleVO getById(Long id) {
        // 先查缓存
        String key = "article:" + id;
        ArticleVO cached = (ArticleVO) redisTemplate.opsForValue().get(key);
       if (cached != null) {
           return cached;
        }
        
        // 缓存未命中，查数据库
        Article article = articleRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("文章不存在"));
        ArticleVO vo = convertToVO(article);
        
        // 写入缓存（30 分钟过期）
       redisTemplate.opsForValue().set(key, vo, 30, TimeUnit.MINUTES);
        
       return vo;
    }
}
```

---

## 📝 检查清单

### 代码提交前检查

- [ ] 代码通过 SonarQube 扫描（无 Blocker/Critical 问题）
- [ ] 单元测试覆盖率 > 80%
- [ ] 所有 API 都有对应的测试用例
- [ ] 代码格式化（使用 IDEA 默认格式）
- [ ] 没有 System.out.println，使用 Logger
- [ ] 敏感信息（密码、密钥）已移除

### 发布前检查

- [ ] 数据库迁移脚本已准备
- [ ] 配置文件已更新（生产环境）
- [ ] API 文档已更新（Swagger）
- [ ] 性能测试通过（响应时间 < 200ms）
- [ ] 回滚方案已准备

---

*最后更新：2026-03-09*  
*维护者：酱肉 (Jiangrou)*  
*版本：1.0*
