# 博客系统测试用例与验收标准 v1.0

**文档状态:** 已批准  
**创建日期:** 2026-03-12  
**最后更新:** 2026-03-12  
**负责人:** 酸菜 (测试)  
**版本:** 1.0

---

## 📋 目录

1. [测试环境配置](#测试环境配置)
2. [单元测试用例](#单元测试用例)
3. [集成测试用例](#集成测试用例)
4. [端到端测试用例](#端到端测试用例)
5. [性能测试标准](#性能测试标准)
6. [验收检查清单](#验收检查清单)

---

## 测试环境配置

### 环境要求

| 组件 | 版本 | 配置 |
|------|------|------|
| JDK | 21+ | - |
| MySQL | 8.0+ | 1 核 1G |
| Redis | 7.0+ | - |
| Node.js | 18+ | 前端测试 |

### 测试数据库

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/blog_system_test
    username: blog_test
    password: test_password
```

### 测试数据准备

每个测试用例执行前，自动插入以下基础数据：

```sql
-- 测试用户
INSERT INTO users (phone, nickname, role, access_level) VALUES
('13800000001', '测试管理员', 'admin', 2),
('13800000002', '测试作者', 'author', 1),
('13800000003', '测试用户', 'user', 0);

-- 测试分类
INSERT INTO categories (name, slug) VALUES
('测试分类 1', 'test-cat-1'),
('测试分类 2', 'test-cat-2');

-- 测试标签
INSERT INTO tags (name, slug) VALUES
('测试标签 1', 'test-tag-1'),
('测试标签 2', 'test-tag-2');
```

---

## 单元测试用例

### 认证模块测试

**测试类:** `AuthServiceTest.java`

| 用例 ID | 测试方法 | 测试场景 | 输入 | 预期输出 | 优先级 |
|---------|----------|----------|------|----------|--------|
| AUTH-UT-001 | `testLogin_ValidPhone()` | 有效手机号登录 | `phone="13800138000"` | 返回 Token，用户信息 | P0 |
| AUTH-UT-002 | `testLogin_NewPhone()` | 新手机号自动注册 | `phone="13900000000"` | 创建新用户，返回 Token | P0 |
| AUTH-UT-003 | `testLogin_InvalidPhone()` | 手机号格式错误 | `phone="12345"` | 抛出 ValidationException | P0 |
| AUTH-UT-004 | `testLogin_NullPhone()` | 空手机号 | `phone=null` | 抛出 ValidationException | P0 |
| AUTH-UT-005 | `testValidateToken_Valid()` | 验证有效 Token | 有效 JWT | 返回 true | P0 |
| AUTH-UT-006 | `testValidateToken_Expired()` | 验证过期 Token | 过期 JWT | 返回 false | P1 |
| AUTH-UT-007 | `testValidateToken_Invalid()` | 验证伪造 Token | 伪造 JWT | 返回 false | P1 |

**测试代码示例:**
```java
@Test
@DisplayName("AUTH-UT-001: 有效手机号登录")
void testLogin_ValidPhone() {
    // Arrange
    String phone = "13800138000";
    
    // Act
    LoginResponse response = authService.login(phone);
    
    // Assert
    assertNotNull(response);
    assertNotNull(response.getToken());
    assertEquals(7200, response.getExpiresIn());
    assertNotNull(response.getUser());
    assertEquals(phone, response.getUser().getPhone());
}

@Test
@DisplayName("AUTH-UT-003: 手机号格式错误")
void testLogin_InvalidPhone() {
    // Arrange
    String invalidPhone = "12345";
    
    // Act & Assert
    assertThrows(ValidationException.class, () -> {
        authService.login(invalidPhone);
    });
}
```

---

### 文章服务测试

**测试类:** `ArticleServiceTest.java`

| 用例 ID | 测试方法 | 测试场景 | 输入 | 预期输出 | 优先级 |
|---------|----------|----------|------|----------|--------|
| ART-UT-001 | `testGetArticle_Public()` | 获取公开文章 | articleId=1, accessLevel=0 | 返回文章详情 | P0 |
| ART-UT-002 | `testGetArticle_Restricted()` | 获取受限文章 | articleId=2, accessLevel=1 | 未登录抛异常 | P0 |
| ART-UT-003 | `testCreateArticle_Author()` | 作者创建文章 | author + 文章数据 | 创建成功 | P0 |
| ART-UT-004 | `testCreateArticle_User()` | 普通用户创建文章 | user + 文章数据 | 抛权限异常 | P0 |
| ART-UT-005 | `testUpdateArticle_Own()` | 更新自己的文章 | author + 自己的文章 | 更新成功 | P0 |
| ART-UT-006 | `testUpdateArticle_Others()` | 更新他人的文章 | author + 他人文章 | 抛权限异常 | P0 |
| ART-UT-007 | `testDeleteArticle_Admin()` | 管理员删除文章 | admin + 任意文章 | 删除成功 | P1 |
| ART-UT-008 | `testMarkdownRender_CodeBlock()` | Markdown 代码块渲染 | 包含 ```java 的 MD | HTML 包含`<pre><code>` | P0 |
| ART-UT-009 | `testMarkdownRender_Table()` | Markdown 表格渲染 | 包含 \| 表格 \| 的 MD | HTML 包含`<table>` | P0 |
| ART-UT-010 | `testMarkdownRender_TaskList()` | Markdown 任务列表 | 包含 - [x] 的 MD | HTML 包含 checkbox | P1 |

**测试代码示例:**
```java
@Test
@DisplayName("ART-UT-008: Markdown 代码块渲染")
void testMarkdownRender_CodeBlock() {
    // Arrange
    String markdown = """
        # 测试
        
        ```java
        public class Test {}
        ```
        """;
    
    // Act
    String html = markdownService.render(markdown);
    
    // Assert
    assertTrue(html.contains("<pre>"));
    assertTrue(html.contains("<code"));
    assertTrue(html.contains("class=\"language-java\""));
}

@Test
@DisplayName("ART-UT-009: Markdown 表格渲染")
void testMarkdownRender_Table() {
    // Arrange
    String markdown = """
        | 列 1 | 列 2 |
        |------|------|
        | A    | B    |
        """;
    
    // Act
    String html = markdownService.render(markdown);
    
    // Assert
    assertTrue(html.contains("<table>"));
    assertTrue(html.contains("<thead>"));
    assertTrue(html.contains("<tbody>"));
}
```

---

### 日志提交服务测试

**测试类:** `LogSubmissionServiceTest.java`

| 用例 ID | 测试方法 | 测试场景 | 输入 | 预期输出 | 优先级 |
|---------|----------|----------|------|----------|--------|
| LOG-UT-001 | `testSubmitLog_Success()` | 成功提交日志 | agentName, logDate | 创建文章，返回成功 | P0 |
| LOG-UT-002 | `testSubmitLog_Duplicate()` | 重复提交 | 相同 agent+date | 抛重复异常 | P0 |
| LOG-UT-003 | `testSubmitLog_FileNotFound()` | 日志文件不存在 | 不存在的日期 | 抛文件不存在异常 | P1 |
| LOG-UT-004 | `testSubmitLog_ParseFail()` | 日志格式解析失败 | 格式错误的 MD | 抛解析异常 | P1 |
| LOG-UT-005 | `testSubmitLog_Scheduled()` | 定时任务触发 | Cron 触发 | 每日 18:00 执行 | P0 |

---

## 集成测试用例

### API 接口测试

**测试类:** `ArticleApiIntegrationTest.java`

| 用例 ID | 测试方法 | 测试场景 | 请求 | 预期响应 | 优先级 |
|---------|----------|----------|------|----------|--------|
| ART-IT-001 | `testGetArticles_List()` | 获取文章列表 | `GET /api/v1/articles` | 200, 包含文章列表 | P0 |
| ART-IT-002 | `testGetArticles_FilterByCategory()` | 按分类过滤 | `GET /api/v1/articles?categoryId=1` | 200, 仅返回该分类 | P1 |
| ART-IT-003 | `testGetArticles_Pagination()` | 分页 | `GET /api/v1/articles?page=2&pageSize=10` | 200, 返回第 2 页 | P1 |
| ART-IT-004 | `testGetArticle_Detail()` | 获取文章详情 | `GET /api/v1/articles/1` | 200, 包含 contentMd 和 contentHtml | P0 |
| ART-IT-005 | `testCreateArticle_Success()` | 创建文章 | `POST /api/v1/articles` + author Token | 200, 创建成功 | P0 |
| ART-IT-006 | `testCreateArticle_NoAuth()` | 未登录创建 | `POST /api/v1/articles` 无 Token | 401 | P0 |
| ART-IT-007 | `testUpdateArticle_Success()` | 更新文章 | `PUT /api/v1/articles/1` + author Token | 200, 更新成功 | P0 |
| ART-IT-008 | `testDeleteArticle_Success()` | 删除文章 | `DELETE /api/v1/articles/1` + admin Token | 200, 删除成功 | P1 |

**测试代码示例:**
```java
@Test
@DisplayName("ART-IT-005: 创建文章 - 成功")
void testCreateArticle_Success() throws Exception {
    // Arrange
    String token = getAuthorToken();
    ArticleCreateRequest request = new ArticleCreateRequest(
        "测试文章",
        "# 测试内容\n\n- [x] 任务 1",
        "测试摘要",
        1L,
        List.of(1L, 2L),
        0,
        null
    );
    
    // Act
    MvcResult result = mockMvc.perform(post("/api/v1/articles")
            .contentType(MediaType.APPLICATION_JSON)
            .content(objectMapper.writeValueAsString(request))
            .header("Authorization", "Bearer " + token))
        .andExpect(status().isOk())
        .andReturn();
    
    // Assert
    String response = result.getResponse().getContentAsString();
    JsonNode json = objectMapper.readTree(response);
    assertEquals(0, json.get("code").asInt());
    assertNotNull(json.get("data").get("id"));
}
```

---

### 认证流程集成测试

**测试类:** `AuthApiIntegrationTest.java`

| 用例 ID | 测试方法 | 测试场景 | 请求 | 预期响应 | 优先级 |
|---------|----------|----------|------|----------|--------|
| AUTH-IT-001 | `testLogin_GetToken()` | 登录获取 Token | `POST /api/v1/auth/login` | 200, 返回 Token | P0 |
| AUTH-IT-002 | `testLogin_AutoRegister()` | 自动注册 | 新手机号登录 | 200, 创建用户 +Token | P0 |
| AUTH-IT-003 | `testMe_ValidToken()` | 验证 Token | `GET /api/v1/auth/me` + Token | 200, 用户信息 | P0 |
| AUTH-IT-004 | `testMe_ExpiredToken()` | Token 过期 | `GET /api/v1/auth/me` + 过期 Token | 401 | P1 |

---

## 端到端测试用例

### E2E 测试流程

**测试类:** `BlogSystemE2ETest.java`

| 用例 ID | 测试场景 | 步骤 | 预期结果 | 优先级 |
|---------|----------|------|----------|--------|
| E2E-001 | 完整发布流程 | 1. 登录<br>2. 创建文章<br>3. 查看文章列表<br>4. 查看文章详情<br>5. 编辑文章<br>6. 删除文章 | 所有步骤成功 | P0 |
| E2E-002 | 权限控制流程 | 1. 未登录访问受限文章<br>2. 登录后访问<br>3. 普通用户尝试创建文章<br>4. 作者创建文章 | 权限控制正确 | P0 |
| E2E-003 | Markdown 渲染流程 | 1. 创建包含代码块、表格、任务列表的文章<br>2. 查看 HTML 渲染结果 | 所有语法正确渲染 | P0 |
| E2E-004 | 日志自动提交流程 | 1. 准备 Agent 日志文件<br>2. 触发定时任务<br>3. 验证文章创建<br>4. 验证提交记录 | 日志正确转为文章 | P0 |

**测试代码示例:**
```java
@Test
@DisplayName("E2E-003: Markdown 渲染端到端测试")
void testMarkdownRendering_E2E() throws Exception {
    // Arrange
    String token = getAuthorToken();
    String markdown = """
        # 测试文章
        
        ## 代码块
        ```java
        public class Test {}
        ```
        
        ## 表格
        | 列 1 | 列 2 |
        |------|------|
        | A    | B    |
        
        ## 任务列表
        - [x] 已完成
        - [ ] 未完成
        """;
    
    // Act 1: 创建文章
    ArticleCreateRequest request = new ArticleCreateRequest(
        "Markdown 测试",
        markdown,
        "测试 Markdown 渲染",
        1L,
        null,
        0,
        null
    );
    
    String createResponse = mockMvc.perform(post("/api/v1/articles")
            .contentType(MediaType.APPLICATION_JSON)
            .content(objectMapper.writeValueAsString(request))
            .header("Authorization", "Bearer " + token))
        .andExpect(status().isOk())
        .andReturn().getResponse().getContentAsString();
    
    Long articleId = extractArticleId(createResponse);
    
    // Act 2: 获取文章详情
    String detailResponse = mockMvc.perform(get("/api/v1/articles/" + articleId))
        .andExpect(status().isOk())
        .andReturn().getResponse().getContentAsString();
    
    // Assert
    JsonNode json = objectMapper.readTree(detailResponse);
    String html = json.get("data").get("contentHtml").asText();
    
    assertTrue(html.contains("<pre>"));
    assertTrue(html.contains("<table>"));
    assertTrue(html.contains("<input type=\"checkbox\" checked"));
}
```

---

## 性能测试标准

### 性能指标要求

| 指标 | 目标值 | 测量方法 |
|------|--------|----------|
| API 响应时间 (P95) | < 200ms | JMeter 压测 |
| API 响应时间 (P99) | < 500ms | JMeter 压测 |
| 数据库查询时间 (P95) | < 50ms | Slow Query Log |
| 并发用户数 | ≥ 100 | JMeter 线程组 |
| 系统吞吐量 | ≥ 500 req/s | JMeter 聚合报告 |
| 错误率 | < 0.1% | JMeter 响应断言 |

### 性能测试场景

**场景 1: 文章列表查询**

```yaml
testName: Article List Query
threads: 100
rampUp: 10s
duration: 60s
requests:
  - GET /api/v1/articles?page=1&pageSize=20
```

**通过标准:**
- P95 响应时间 < 200ms
- 错误率 < 0.1%
- 吞吐量 > 500 req/s

**场景 2: 文章详情查询**

```yaml
testName: Article Detail Query
threads: 100
rampUp: 10s
duration: 60s
requests:
  - GET /api/v1/articles/{id}
```

**通过标准:**
- P95 响应时间 < 150ms
- 错误率 < 0.1%

**场景 3: 登录接口**

```yaml
testName: Login API
threads: 50
rampUp: 5s
duration: 60s
requests:
  - POST /api/v1/auth/login
    body: {"phone": "13800000001"}
```

**通过标准:**
- P95 响应时间 < 300ms
- 错误率 < 0.1%

---

## 验收检查清单

### 功能验收

#### 认证模块

- [ ] 手机号登录功能正常（符合格式即可登录）
- [ ] 新手机号自动创建用户
- [ ] 手机号格式验证正确（`^1[3-9]\d{9}$`）
- [ ] JWT Token 生成和验证正常
- [ ] Token 过期时间正确（2 小时）
- [ ] 未登录用户访问受限接口返回 401

#### 文章模块

- [ ] 文章列表查询支持分页、过滤、排序
- [ ] 文章详情包含 contentMd 和 contentHtml
- [ ] 访问级别控制正确（公开/登录/VIP）
- [ ] 作者只能编辑/删除自己的文章
- [ ] 管理员可以编辑/删除所有文章
- [ ] 普通用户不能创建文章

#### Markdown 渲染

- [ ] 标题语法正确渲染（# H1, ## H2）
- [ ] 粗体、斜体正确渲染
- [ ] 链接、图片正确渲染
- [ ] **代码块正确渲染 + 语法高亮**
- [ ] **表格正确渲染**
- [ ] **任务列表正确渲染（复选框）**
- [ ] 引用、分割线正确渲染
- [ ] 行内代码正确渲染

#### 分类标签

- [ ] 分类列表查询正常
- [ ] 标签列表查询正常
- [ ] 文章可以关联多个标签
- [ ] 可以按分类/标签过滤文章

#### 日志提交

- [ ] 手动触发日志提交正常
- [ ] 定时任务每日 18:00 自动执行
- [ ] 重复提交正确拦截
- [ ] 日志文件不存在时正确处理
- [ ] 提交记录完整保存

---

### 非功能验收

#### 性能

- [ ] 所有 API P95 响应时间 < 200ms
- [ ] 数据库查询 P95 < 50ms
- [ ] 支持 100 并发用户
- [ ] 系统吞吐量 > 500 req/s

#### 安全

- [ ] 密码加密存储（BCrypt）
- [ ] JWT Token 签名验证
- [ ] SQL 注入防护（参数化查询）
- [ ] XSS 防护（HTML 过滤）
- [ ] 手机号格式验证

#### 代码质量

- [ ] 单元测试覆盖率 ≥ 80%
- [ ] 所有 P0 用例通过
- [ ] 所有 P1 用例通过
- [ ] SonarQube 无 Blocker/Critical 问题
- [ ] API 文档完整（Swagger）

#### 可维护性

- [ ] 日志记录完整
- [ ] 错误码定义清晰
- [ ] 数据库有注释
- [ ] 代码有 JavaDoc

---

### 交付物清单

酱肉（后端）需要交付：

- [ ] 源代码（Git 仓库）
- [ ] 数据库建表脚本
- [ ] API 文档（Swagger）
- [ ] 单元测试代码
- [ ] 集成测试代码
- [ ] 性能测试报告
- [ ] 部署文档

豆沙（前端）需要交付：

- [ ] 源代码（Git 仓库）
- [ ] 构建产物（dist/）
- [ ] 前端测试报告

酸菜（测试）需要交付：

- [ ] 测试用例文档
- [ ] 测试执行报告
- [ ] Bug 列表
- [ ] 性能测试报告

---

## 测试执行计划

### 第一阶段：单元测试

**时间:** 2026-03-13 ~ 2026-03-14  
**执行人:** 酱肉  
**目标:** 所有单元测试通过，覆盖率 ≥ 80%

### 第二阶段：集成测试

**时间:** 2026-03-15 ~ 2026-03-16  
**执行人:** 酸菜  
**目标:** 所有 API 接口测试通过

### 第三阶段：端到端测试

**时间:** 2026-03-17 ~ 2026-03-18  
**执行人:** 酸菜  
**目标:** 完整业务流程测试通过

### 第四阶段：性能测试

**时间:** 2026-03-19  
**执行人:** 酸菜  
**目标:** 性能指标达标

### 第五阶段：验收测试

**时间:** 2026-03-20  
**执行人:** 灌汤  
**目标:** 所有验收检查项通过

---

**文档审批:**

| 角色 | 姓名 | 签字 | 日期 |
|------|------|------|------|
| PM | 灌汤 | - | 2026-03-12 |
| 后端 | 酱肉 | - | - |
| 测试 | 酸菜 | - | - |
