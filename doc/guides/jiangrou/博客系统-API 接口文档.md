# 博客系统后端 API 接口文档

**文档状态:** 正式  
**版本:** v1.0  
**创建日期:** 2026-03-12  
**负责人:** 酱肉 (后端工程师)  
**参考模板:** `templates/api-doc-template.md`

---

## 📋 文档信息

| 项目 | 值 |
|------|-----|
| 项目名称 | 博客系统 |
| 接口版本 | v1 |
| 技术栈 | Java 21 + Spring Boot 3.2 + MyBatis-Plus |
| 数据库 | MySQL 8.0 + Redis 7.0 |
| 认证方式 | JWT Bearer Token |

---

## 1. 接口概述

### 1.1 基础 URL

| 环境 | URL |
|------|-----|
| 开发环境 | http://localhost:8080/api/v1 |
| 测试环境 | http://test-api.example.com/api/v1 |
| 生产环境 | https://api.example.com/api/v1 |

### 1.2 认证方式

**JWT Bearer Token 认证**

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Token 配置:**
```yaml
jwt:
  secret: ${JWT_SECRET}
  expiration: 7200000  # 2 小时
  refresh-expiration: 604800000  # 7 天
```

### 1.3 响应格式

**成功响应:**
```json
{
  "code": 0,
  "message": "success",
  "data": { },
  "timestamp": "2026-03-12T10:30:00+08:00",
  "requestId": "req_123456789"
}
```

**错误响应:**
```json
{
  "code": 1001,
  "message": "参数验证失败",
  "data": null,
  "timestamp": "2026-03-12T10:30:00+08:00",
  "requestId": "req_123456789"
}
```

---

## 2. 认证模块

### 2.1 手机号登录

**接口:** `POST /api/v1/auth/login`

**权限:** 公开（无需登录）

**限流:** 10 次/分钟/IP

**请求参数:**

| 参数 | 类型 | 必填 | 最大长度 | 说明 | 验证规则 |
|------|------|------|----------|------|----------|
| phone | string | 是 | 11 | 手机号 | `^1[3-9]\d{9}$` |

**请求示例:**
```http
POST /api/v1/auth/login HTTP/1.1
Host: api.example.com
Content-Type: application/json

{
  "phone": "13800138000"
}
```

**响应参数:**

| 参数 | 类型 | 说明 |
|------|------|------|
| token | string | JWT Token |
| expiresIn | integer | Token 有效期（秒） |
| user.id | long | 用户 ID |
| user.phone | string | 手机号 |
| user.nickname | string | 昵称 |
| user.avatar | string | 头像 URL |
| user.role | string | 角色：user/author/admin |
| user.accessLevel | integer | 访问级别：0/1/2 |

**响应示例:**
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwicm9sZSI6ImFkbWluIiwiZXhwIjoxNzEwMjQzMDAwfQ.abc123",
    "expiresIn": 7200,
    "user": {
      "id": 1,
      "phone": "13800138000",
      "nickname": "管理员",
      "avatar": "",
      "role": "admin",
      "accessLevel": 2
    }
  },
  "timestamp": "2026-03-12T10:30:00+08:00"
}
```

**错误码:**
| 错误码 | 说明 | HTTP 状态 |
|--------|------|----------|
| 1001 | 参数验证失败 | 400 |
| 1002 | 手机号格式错误 | 400 |

**实现要点:**
```java
@Service
public class AuthServiceImpl implements AuthService {
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private JwtTokenProvider jwtTokenProvider;
    
    @Override
    @Transactional
    public LoginResponse login(String phone) {
        // 1. 验证手机号格式
        if (!PhoneValidator.isValid(phone)) {
            throw new ValidationException("手机号格式错误");
        }
        
        // 2. 查询或创建用户
        User user = userService.findByPhone(phone);
        if (user == null) {
            user = userService.createAutoRegister(phone);
        }
        
        // 3. 生成 JWT Token
        String token = jwtTokenProvider.generateToken(user);
        
        // 4. 更新最后登录时间
        userService.updateLastLogin(user.getId());
        
        return LoginResponse.builder()
            .token(token)
            .expiresIn(7200)
            .user(UserDTO.fromEntity(user))
            .build();
    }
}
```

**测试用例:**
```java
@SpringBootTest
class AuthServiceTest {
    
    @Autowired
    private AuthService authService;
    
    @Test
    @DisplayName("有效手机号登录")
    void testLogin_ValidPhone() {
        LoginResponse response = authService.login("13800138000");
        assertNotNull(response.getToken());
        assertEquals(7200, response.getExpiresIn());
        assertNotNull(response.getUser());
    }
    
    @Test
    @DisplayName("新手机号自动注册")
    void testLogin_NewPhone() {
        LoginResponse response = authService.login("13900000000");
        assertNotNull(response.getToken());
        assertEquals("13900000000", response.getUser().getPhone());
    }
    
    @Test
    @DisplayName("手机号格式错误")
    void testLogin_InvalidPhone() {
        assertThrows(ValidationException.class, () -> {
            authService.login("12345");
        });
    }
}
```

---

### 2.2 获取当前用户信息

**接口:** `GET /api/v1/auth/me`

**权限:** 已登录用户

**请求头:**
```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**响应参数:**

| 参数 | 类型 | 说明 |
|------|------|------|
| id | long | 用户 ID |
| phone | string | 手机号 |
| nickname | string | 昵称 |
| avatar | string | 头像 URL |
| role | string | 角色 |
| accessLevel | integer | 访问级别 |
| createdAt | datetime | 创建时间 |
| lastLoginAt | datetime | 最后登录时间 |

**响应示例:**
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "id": 1,
    "phone": "13800138000",
    "nickname": "管理员",
    "avatar": "",
    "role": "admin",
    "accessLevel": 2,
    "createdAt": "2026-03-10T00:00:00+08:00",
    "lastLoginAt": "2026-03-12T10:30:00+08:00"
  }
}
```

**错误码:**
| 错误码 | 说明 | HTTP 状态 |
|--------|------|----------|
| 2000 | 未提供 Token | 401 |
| 2001 | Token 已过期 | 401 |
| 2002 | Token 无效 | 401 |

---

## 3. 文章模块

### 3.1 获取文章列表

**接口:** `GET /api/v1/articles`

**权限:** 公开

**请求参数:**

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| page | integer | 否 | 1 | 页码 |
| pageSize | integer | 否 | 20 | 每页数量（最大 100） |
| categoryId | long | 否 | - | 分类 ID |
| tagId | long | 否 | - | 标签 ID |
| keyword | string | 否 | - | 关键词 |
| sortBy | string | 否 | publishedAt | 排序字段 |
| sortOrder | string | 否 | desc | 排序方向（asc/desc） |

**请求示例:**
```http
GET /api/v1/articles?page=1&pageSize=20&categoryId=1&keyword=工作日志
```

**响应参数:**

| 参数 | 类型 | 说明 |
|------|------|------|
| list | array | 文章列表 |
| list[].id | long | 文章 ID |
| list[].title | string | 标题 |
| list[].slug | string | URL 别名 |
| list[].summary | string | 摘要 |
| list[].coverImage | string | 封面图 URL |
| list[].categoryId | long | 分类 ID |
| list[].categoryName | string | 分类名 |
| list[].authorId | long | 作者 ID |
| list[].authorName | string | 作者名 |
| list[].accessLevel | integer | 访问级别 |
| list[].viewCount | integer | 浏览量 |
| list[].likeCount | integer | 点赞数 |
| list[].publishedAt | datetime | 发布时间 |
| list[].tags | array | 标签列表 |
| pagination | object | 分页信息 |

**响应示例:**
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "list": [
      {
        "id": 1,
        "title": "灌汤的工作日志 - 2026-03-12",
        "slug": "guantang-log-20260312",
        "summary": "今日完成需求分析和任务分发...",
        "coverImage": "",
        "categoryId": 2,
        "categoryName": "工作日志",
        "authorId": 1,
        "authorName": "灌汤",
        "accessLevel": 0,
        "viewCount": 120,
        "likeCount": 5,
        "publishedAt": "2026-03-12T18:00:00+08:00",
        "tags": [
          {"id": 6, "name": "灌汤", "slug": "guantang"}
        ]
      }
    ],
    "pagination": {
      "page": 1,
      "pageSize": 20,
      "total": 100,
      "totalPages": 5
    }
  }
}
```

**实现要点:**
```java
@Service
public class ArticleServiceImpl implements ArticleService {
    
    @Autowired
    private ArticleMapper articleMapper;
    
    @Override
    public ArticleListVO getList(ArticleQueryDTO query) {
        // 1. 构建查询条件
        LambdaQueryWrapper<Article> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Article::getStatus, "published");
        wrapper.eq(Article::getAccessLevel, 0); // 公开文章
        wrapper.eq(query.getCategoryId() != null, Article::getCategoryId, query.getCategoryId());
        wrapper.like(StringUtils.isNotBlank(query.getKeyword()), Article::getTitle, query.getKeyword());
        wrapper.orderByDesc(Article::getPublishedAt);
        
        // 2. 分页查询
        Page<Article> page = articleMapper.selectPage(
            new Page<>(query.getPage(), query.getPageSize()),
            wrapper
        );
        
        // 3. 转换为 VO
        return ArticleListVO.fromPage(page);
    }
}
```

---

### 3.2 获取文章详情

**接口:** `GET /api/v1/articles/{id}`

**权限:** 根据文章 access_level 决定

**请求参数:**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| id | long | 是 | 文章 ID |

**响应参数:**

| 参数 | 类型 | 说明 |
|------|------|------|
| id | long | 文章 ID |
| title | string | 标题 |
| slug | string | URL 别名 |
| contentMd | string | **Markdown 原文** |
| contentHtml | string | **渲染后的 HTML** |
| summary | string | 摘要 |
| coverImage | string | 封面图 URL |
| categoryId | long | 分类 ID |
| categoryName | string | 分类名 |
| authorId | long | 作者 ID |
| authorName | string | 作者名 |
| authorAvatar | string | 作者头像 |
| accessLevel | integer | 访问级别 |
| viewCount | integer | 浏览量 |
| likeCount | integer | 点赞数 |
| status | string | 状态 |
| publishedAt | datetime | 发布时间 |
| createdAt | datetime | 创建时间 |
| updatedAt | datetime | 更新时间 |
| tags | array | 标签列表 |

**响应示例:**
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "id": 1,
    "title": "灌汤的工作日志 - 2026-03-12",
    "slug": "guantang-log-20260312",
    "contentMd": "# 工作日志\n\n## 完成的任务\n\n- [x] 需求分析\n- [x] 任务分发",
    "contentHtml": "<h1>工作日志</h1>\n<h2>完成的任务</h2>\n<ul>\n<li><input type=\"checkbox\" checked>需求分析</li>\n<li><input type=\"checkbox\" checked>任务分发</li>\n</ul>",
    "summary": "今日完成需求分析和任务分发...",
    "categoryId": 2,
    "categoryName": "工作日志",
    "authorId": 1,
    "authorName": "灌汤",
    "authorAvatar": "",
    "accessLevel": 0,
    "viewCount": 121,
    "likeCount": 5,
    "publishedAt": "2026-03-12T18:00:00+08:00",
    "tags": [
      {"id": 6, "name": "灌汤", "slug": "guantang"}
    ]
  }
}
```

**错误码:**
| 错误码 | 说明 | HTTP 状态 |
|--------|------|----------|
| 3001 | 文章不存在 | 404 |
| 3003 | 无权访问该文章 | 403 |

**Markdown 渲染实现:**
```java
@Service
public class MarkdownServiceImpl implements MarkdownService {
    
    private final Parser parser;
    private final HtmlRenderer renderer;
    
    public MarkdownServiceImpl() {
        // 配置 commonmark 解析器
        this.parser = Parser.builder()
            .extensions(List.of(
                TablesExtension.create(),
                TaskListItemsExtension.create(),
                StrikethroughExtension.create()
            ))
            .build();
        
        this.renderer = HtmlRenderer.builder()
            .extensions(List.of(
                TablesExtension.create(),
                TaskListItemsExtension.create(),
                StrikethroughExtension.create()
            ))
            .build();
    }
    
    @Override
    public String render(String markdown) {
        Node document = parser.parse(markdown);
        return renderer.render(document);
    }
}
```

---

### 3.3 创建文章

**接口:** `POST /api/v1/articles`

**权限:** author 或 admin

**请求参数:**

| 参数 | 类型 | 必填 | 最大长度 | 说明 | 验证规则 |
|------|------|------|----------|------|----------|
| title | string | 是 | 200 | 标题 | 1-200 字符 |
| contentMd | string | 是 | 100KB | **Markdown 原文** | 最大 100KB |
| summary | string | 否 | 500 | 摘要 | 最大 500 字符 |
| categoryId | long | 是 | - | 分类 ID | 必须存在 |
| tagIds | array | 否 | - | 标签 ID 数组 | - |
| accessLevel | integer | 否 | - | 访问级别 | 0/1/2，默认 0 |
| coverImage | string | 否 | 255 | 封面图 URL | 有效 URL |

**请求示例:**
```json
{
  "title": "酱肉的后端开发日志 - 2026-03-12",
  "contentMd": "# 后端开发日志\n\n## 完成的任务\n\n- [x] 用户认证 API\n- [x] 文章管理 API\n\n## 技术细节\n\n```java\npublic class AuthService {\n    // JWT 认证逻辑\n}\n```",
  "summary": "完成用户认证和文章管理 API 开发",
  "categoryId": 2,
  "tagIds": [7, 1],
  "accessLevel": 0
}
```

**响应参数:**

| 参数 | 类型 | 说明 |
|------|------|------|
| id | long | 文章 ID |
| title | string | 标题 |
| slug | string | URL 别名 |
| contentMd | string | Markdown 原文 |
| contentHtml | string | 渲染后的 HTML |
| status | string | 状态：published |
| publishedAt | datetime | 发布时间 |
| createdAt | datetime | 创建时间 |

**错误码:**
| 错误码 | 说明 | HTTP 状态 |
|--------|------|----------|
| 1001 | 参数验证失败 | 400 |
| 3003 | 权限不足 | 403 |
| 4001 | 分类不存在 | 404 |

**实现要点:**
```java
@Service
public class ArticleServiceImpl implements ArticleService {
    
    @Autowired
    private ArticleMapper articleMapper;
    
    @Autowired
    private MarkdownService markdownService;
    
    @Autowired
    private SlugGenerator slugGenerator;
    
    @Override
    @Transactional
    public ArticleVO create(ArticleCreateDTO dto, Long authorId) {
        // 1. 验证分类存在
        if (!categoryMapper.existsById(dto.getCategoryId())) {
            throw new NotFoundException("分类不存在");
        }
        
        // 2. 生成 slug
        String slug = slugGenerator.generate(dto.getTitle());
        
        // 3. 渲染 Markdown
        String contentHtml = markdownService.render(dto.getContentMd());
        
        // 4. 创建文章
        Article article = Article.builder()
            .title(dto.getTitle())
            .slug(slug)
            .contentMd(dto.getContentMd())
            .contentHtml(contentHtml)
            .summary(dto.getSummary())
            .coverImage(dto.getCoverImage())
            .categoryId(dto.getCategoryId())
            .authorId(authorId)
            .accessLevel(dto.getAccessLevel())
            .status("published")
            .build();
        
        articleMapper.insert(article);
        
        // 5. 关联标签
        if (dto.getTagIds() != null && !dto.getTagIds().isEmpty()) {
            List<ArticleTag> articleTags = dto.getTagIds().stream()
                .map(tagId -> ArticleTag.builder()
                    .articleId(article.getId())
                    .tagId(tagId)
                    .build())
                .collect(Collectors.toList());
            articleTagMapper.insertBatch(articleTags);
        }
        
        return ArticleVO.fromEntity(article);
    }
}
```

---

### 3.4 更新文章

**接口:** `PUT /api/v1/articles/{id}`

**权限:** author (自己的文章) 或 admin (全部文章)

**请求参数:**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| title | string | 否 | 标题 |
| contentMd | string | 否 | Markdown 原文 |
| summary | string | 否 | 摘要 |
| categoryId | long | 否 | 分类 ID |
| tagIds | array | 否 | 标签 ID 数组 |
| accessLevel | integer | 否 | 访问级别 |
| coverImage | string | 否 | 封面图 URL |

**错误码:**
| 错误码 | 说明 | HTTP 状态 |
|--------|------|----------|
| 3001 | 文章不存在 | 404 |
| 3003 | 权限不足 | 403 |

**实现要点:**
```java
@Override
@Transactional
public ArticleVO update(Long id, ArticleUpdateDTO dto, Long currentUserId) {
    // 1. 查询文章
    Article article = articleMapper.selectById(id);
    if (article == null) {
        throw new NotFoundException("文章不存在");
    }
    
    // 2. 权限检查
    User currentUser = userMapper.selectById(currentUserId);
    if (!"admin".equals(currentUser.getRole()) && !article.getAuthorId().equals(currentUserId)) {
        throw new ForbiddenException("无权编辑该文章");
    }
    
    // 3. 更新字段
    if (dto.getTitle() != null) {
        article.setTitle(dto.getTitle());
        article.setSlug(slugGenerator.generate(dto.getTitle()));
    }
    if (dto.getContentMd() != null) {
        article.setContentMd(dto.getContentMd());
        article.setContentHtml(markdownService.render(dto.getContentMd()));
    }
    // ... 其他字段
    
    articleMapper.updateById(article);
    
    // 4. 更新标签关联
    if (dto.getTagIds() != null) {
        articleTagMapper.deleteByArticleId(id);
        List<ArticleTag> articleTags = dto.getTagIds().stream()
            .map(tagId -> ArticleTag.builder().articleId(id).tagId(tagId).build())
            .collect(Collectors.toList());
        articleTagMapper.insertBatch(articleTags);
    }
    
    return ArticleVO.fromEntity(article);
}
```

---

### 3.5 删除文章

**接口:** `DELETE /api/v1/articles/{id}`

**权限:** author (自己的文章) 或 admin (全部文章)

**响应:**
```json
{
  "code": 0,
  "message": "success",
  "data": null
}
```

---

## 4. 分类标签模块

### 4.1 获取分类列表

**接口:** `GET /api/v1/categories`

**权限:** 公开

**响应示例:**
```json
{
  "code": 0,
  "message": "success",
  "data": [
    {
      "id": 1,
      "name": "技术文章",
      "slug": "tech",
      "description": "技术相关的文章",
      "parentId": null,
      "sortOrder": 1,
      "articleCount": 50
    },
    {
      "id": 2,
      "name": "工作日志",
      "slug": "logs",
      "description": "Agent 团队工作日志",
      "parentId": null,
      "sortOrder": 2,
      "articleCount": 120
    }
  ]
}
```

---

### 4.2 获取标签列表

**接口:** `GET /api/v1/tags`

**权限:** 公开

**响应示例:**
```json
{
  "code": 0,
  "message": "success",
  "data": [
    {"id": 1, "name": "Java", "slug": "java", "articleCount": 30},
    {"id": 6, "name": "灌汤", "slug": "guantang", "articleCount": 25},
    {"id": 7, "name": "酱肉", "slug": "jiangrou", "articleCount": 28}
  ]
}
```

---

## 5. 日志提交模块

### 5.1 手动触发日志提交

**接口:** `POST /api/v1/logs/submit`

**权限:** admin

**请求参数:**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| agentName | string | 是 | Agent 名称 |
| logDate | string | 是 | 日志日期（YYYYMMDD） |

**请求示例:**
```json
{
  "agentName": "guantang",
  "logDate": "20260312"
}
```

**响应示例:**
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "articleId": 5,
    "status": "success",
    "submittedAt": "2026-03-12T18:00:00+08:00"
  }
}
```

**错误码:**
| 错误码 | 说明 | HTTP 状态 |
|--------|------|----------|
| 5001 | 该日期的日志已提交 | 400 |
| 5002 | 日志文件不存在 | 404 |
| 5003 | 日志格式解析失败 | 500 |

---

## 6. 错误码定义

### 6.1 全局错误码

| 错误码 | 说明 | HTTP 状态 | 处理建议 |
|--------|------|----------|----------|
| 0 | 成功 | 200 | - |
| 1001 | 参数验证失败 | 400 | 检查请求参数 |
| 1002 | 请求体格式错误 | 400 | 检查 JSON 格式 |
| 2000 | 未提供 Token | 401 | 添加 Authorization 头 |
| 2001 | Token 已过期 | 401 | 重新登录 |
| 2002 | Token 无效 | 401 | 重新登录 |
| 3003 | 权限不足 | 403 | 申请权限 |
| 3004 | 资源不存在 | 404 | 检查资源 ID |
| 5000 | 服务器内部错误 | 500 | 联系运维 |

### 6.2 业务错误码

| 错误码 | 模块 | 说明 | HTTP 状态 |
|--------|------|------|----------|
| 3001 | 文章 | 文章不存在 | 404 |
| 3002 | 文章 | 文章已被删除 | 404 |
| 3003 | 文章 | 无权访问该文章 | 403 |
| 3004 | 文章 | Slug 已存在 | 400 |
| 4001 | 分类 | 分类不存在 | 404 |
| 4002 | 标签 | 标签不存在 | 404 |
| 5001 | 日志 | 该日期的日志已提交 | 400 |
| 5002 | 日志 | 日志文件不存在 | 404 |

---

## 7. 开发规范

### 7.1 项目结构

```
code/backend/
├── src/main/java/com/example/blog/
│   ├── BlogApplication.java
│   ├── config/              # 配置类
│   │   ├── SecurityConfig.java
│   │   ├── CorsConfig.java
│   │   └── SwaggerConfig.java
│   ├── controller/          # 控制器
│   │   ├── AuthController.java
│   │   ├── ArticleController.java
│   │   └── CategoryController.java
│   ├── service/             # 服务层
│   │   ├── AuthService.java
│   │   ├── ArticleService.java
│   │   └── impl/
│   ├── mapper/              # MyBatis Mapper
│   │   ├── UserMapper.java
│   │   └── ArticleMapper.java
│   ├── entity/              # 实体类
│   │   ├── User.java
│   │   └── Article.java
│   ├── dto/                 # 数据传输对象
│   │   ├── request/
│   │   └── response/
│   ├── vo/                  # 视图对象
│   ├── common/              # 公共类
│   │   ├── exception/
│   │   ├── result/
│   │   └── utils/
│   └── security/            # 安全相关
│       ├── JwtTokenProvider.java
│       └── JwtAuthenticationFilter.java
├── src/main/resources/
│   ├── application.yml
│   ├── application-dev.yml
│   ├── application-prod.yml
│   └── mapper/              # MyBatis XML
└── pom.xml
```

### 7.2 代码规范

**统一响应封装:**
```java
@Data
@Builder
public class Result<T> {
    private Integer code;
    private String message;
    private T data;
    private Long timestamp;
    private String requestId;
    
    public static <T> Result<T> success(T data) {
        return Result.<T>builder()
            .code(0)
            .message("success")
            .data(data)
            .timestamp(System.currentTimeMillis())
            .requestId(RequestIdGenerator.generate())
            .build();
    }
    
    public static <T> Result<T> error(Integer code, String message) {
        return Result.<T>builder()
            .code(code)
            .message(message)
            .timestamp(System.currentTimeMillis())
            .requestId(RequestIdGenerator.generate())
            .build();
    }
}
```

**全局异常处理:**
```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(ValidationException.class)
    public Result<Void> handleValidation(ValidationException e) {
        return Result.error(1001, e.getMessage());
    }
    
    @ExceptionHandler(UnauthorizedException.class)
    public Result<Void> handleUnauthorized(UnauthorizedException e) {
        return Result.error(2000, e.getMessage());
    }
    
    @ExceptionHandler(ForbiddenException.class)
    public Result<Void> handleForbidden(ForbiddenException e) {
        return Result.error(3003, e.getMessage());
    }
    
    @ExceptionHandler(NotFoundException.class)
    public Result<Void> handleNotFound(NotFoundException e) {
        return Result.error(404, e.getMessage());
    }
    
    @ExceptionHandler(Exception.class)
    public Result<Void> handleException(Exception e) {
        log.error("服务器内部错误", e);
        return Result.error(5000, "服务器内部错误");
    }
}
```

---

## 8. 验收标准

### 8.1 功能验收

- [ ] 手机号登录功能正常（符合格式即可登录）
- [ ] 新手机号自动创建用户
- [ ] 文章 CRUD 功能正常
- [ ] Markdown 存储原文 + 渲染 HTML
- [ ] 权限控制正确（公开/登录/VIP）
- [ ] 分类标签功能正常

### 8.2 性能验收

- [ ] API 响应时间 P95 < 200ms
- [ ] 数据库查询时间 P95 < 50ms
- [ ] 支持 100 并发用户
- [ ] 系统吞吐量 > 500 req/s

### 8.3 代码质量

- [ ] 单元测试覆盖率 ≥ 80%
- [ ] 所有 P0 测试用例通过
- [ ] SonarQube 无 Blocker/Critical 问题
- [ ] Swagger 文档完整

---

**文档结束**
