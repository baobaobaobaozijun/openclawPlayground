<!-- Last Modified: 2026-03-09 -->
<!-- Last Modified (CN): 2026-03-09 -->

# 酱肉 (Jiangrou) - 完整技术文档

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

## 🏢 Agent 身份

**名称:** 酱肉  
**角色:** 后端工程师 / 系统架构师  
**职责:** 负责所有后端业务代码的实现、数据库设计、系统架构

**核心配置文件:**
- [IDENTITY.md](./IDENTITY.md) - 身份认知
- [ROLE.md](./ROLE.md) - 职责规范
- [SOUL.md](./SOUL.md) - 行为准则

---

## 💻 技术栈规范

### 语言与框架

| 技术 | 版本 | 用途 | 说明 |
|------|------|------|------|
| **Java** | 21 (LTS) | 主要编程语言 | 必须使用 LTS 版本 |
| **Spring Boot** | 3.2+ | Web 框架 | 提供 RESTful API |
| **Spring Security** | 6.x | 安全框架 | JWT 认证、权限管理 |
| **MyBatis-Plus** | 3.5+ | ORM 框架 | 数据访问层 |

### 数据库

| 技术 | 版本 | 用途 | 说明 |
|------|------|------|------|
| **MySQL** | 8.0+ | 主数据库 | InnoDB 引擎 |
| **Redis** | 7.0+ | 缓存/会话存储 | 支持集群模式 |

### 工具链

| 技术 | 版本 | 用途 |
|------|------|------|
| **Maven** | 3.9+ | 构建工具 |
| **Git** | latest | 版本控制 |
| **Docker** | latest | 容器化部署 |
| **SonarQube** | latest | 代码质量扫描 |

---

## 🏗️ 项目结构规范

```
backend/
├── src/main/java/com/example/blog/
│   ├── controller/           # REST API 控制器层
│   ├── service/              # 业务逻辑层
│   │   └── impl/            # 服务实现
│   ├── repository/          # 数据访问层（DAO）
│   ├── entity/              # 实体类（数据库表映射）
│   ├── dto/                 # 数据传输对象
│   ├── vo/                  # 视图对象（返回给前端）
│   ├── config/              # 配置类
│   ├── security/            # 安全相关（JWT、认证）
│   ├── exception/           # 自定义异常
│   ├── util/                # 工具类
│   └── BlogApplication.java # 启动类
├── src/main/resources/
│   ├── application.yml     # 主配置文件
│   ├── application-dev.yml  # 开发环境配置
│   ├── application-prod.yml # 生产环境配置
│   └── mapper/              # MyBatis XML 映射文件
└── pom.xml                 # Maven 依赖配置
```

---

## 🔧 开发最佳实践

### 1. RESTful API 设计规范

**URL 命名:**
```java
// ✅ 好的设计
GET    /api/v1/articles          // 获取文章列表
POST   /api/v1/articles          // 创建文章
GET    /api/v1/articles/{id}     // 获取单篇文章
PUT    /api/v1/articles/{id}     // 更新文章
DELETE /api/v1/articles/{id}     // 删除文章

// ❌ 差的设计
GET    /api/v1/getArticles       // 动词出现在 URL 中
POST   /api/v1/createArticle     
```

**Controller 示例:**
```java
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

### 2. 统一响应格式

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ApiResponse<T> {
    private Integer code;
    private String message;
    private T data;
    
    public static <T> ApiResponse<T> success(T data) {
       return new ApiResponse<>(200, "success", data);
    }
    
    public static <T> ApiResponse<T> error(String message) {
       return new ApiResponse<>(500, message, null);
    }
}
```

### 3. 异常处理规范

```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(ResourceNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ApiResponse<Void> handleNotFound(ResourceNotFoundException e) {
       return ApiResponse.error(e.getMessage());
    }
    
    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ApiResponse<Map<String, String>> handleValidationErrors(
        MethodArgumentNotValidException ex
    ) {
        Map<String, String> errors = new HashMap<>();
       ex.getBindingResult().getFieldErrors().forEach(error -> 
            errors.put(error.getField(), error.getDefaultMessage())
        );
       return ApiResponse.error("验证失败");
    }
}
```

### 4. 数据库设计规范

**表命名:**
- ✅ `user`, `article`, `comment` (单数)
- ❌ `users`, `articles`, `comments` (复数)

**必填字段:**
```sql
CREATE TABLE article (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键 ID',
   title VARCHAR(200) NOT NULL COMMENT '标题',
   content TEXT NOT NULL COMMENT '内容',
    author_id BIGINT NOT NULL COMMENT '作者 ID',
    status TINYINT DEFAULT 1 COMMENT '状态：0-草稿，1-发布',
    view_count INT DEFAULT 0 COMMENT '浏览量',
   created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_author (author_id),
    INDEX idx_status_created (status, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文章表';
```

### 5. 日志规范

```java
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

---

## 📊 常见问题与解决

### Q1: JWT Token 如何实现？

**解决方案:**

1. **添加依赖:**
```xml
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
```java
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

### Q2: 如何处理跨域问题？

**解决方案:**

```java
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
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```

2. **配置 Redis:**
```yaml
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
```java
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
