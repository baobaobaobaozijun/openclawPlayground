<!-- Last Modified: 2026-03-12 -->

# 包子铺博客系统 - 前后端联调方案

**文档类型:** 实施指南  
**版本:** v1.0  
**创建日期:** 2026-03-12  
**负责人:** 酱肉 (后端) & 豆沙 (前端)  
**审核:** 灌汤 (PM)

---

## 📋 联调目标

**第一阶段目标:** 完成文章模块前后端联调，实现 Demo 版本可访问

**验收标准:**
- ✅ 首页可以展示文章列表
- ✅ 可以查看文章详情
- ✅ 管理员可以登录后台
- ✅ 后台可以创建/编辑文章
- ✅ 服务器 {SERVER_IP} 可访问

---

## 🏗️ 联调架构

### 开发环境架构

```
┌─────────────────┐
│   前端开发机     │
│  (本地开发)     │
│                 │
│  npm run dev    │
│  Port: 3000     │
│                 │
│  Vite Proxy ────┼────────────┐
│  /api → :8080   │            │
└─────────────────┘            │
                               │
                               │ HTTP
                               │
                               ▼
┌─────────────────┐
│   后端开发机     │
│  (本地开发)     │
│                 │
│  Spring Boot    │
│  Port: 8080     │
│                 │
│  MySQL ─────────┤
│  Port: 3306     │
└─────────────────┘
```

### 生产环境架构

```
┌─────────────────┐
│   服务器         │
│  {SERVER_IP}  │
│                 │
│  Nginx          │
│  Port: 80       │
│                 │
│  ├─ / → :3000   │  (前端静态文件)
│  └─ /api/ → :8080│  (后端 API 代理)
│                 │
│  Spring Boot    │
│  Port: 8080     │
│                 │
│  MySQL          │
│  Port: 3306     │
└─────────────────┘
```

---

## 📅 联调流程

### Day 1 (2026-03-12) - 环境准备

#### 后端任务 (酱肉)

**1. 确认 API 可用**
```bash
# 启动后端服务
cd F:\openclaw\code\backend
mvn spring-boot:run

# 测试健康检查接口
curl http://localhost:8080/api/health
```

**2. 准备测试数据**
```sql
-- 插入测试文章
INSERT INTO articles (title, slug, content, summary, author_id, status, access_level) VALUES
('测试文章 1', 'test-1', '# Hello', '测试内容', 1, 'PUBLISHED', 0),
('测试文章 2', 'test-2', '# World', '测试内容', 1, 'PUBLISHED', 0);
```

**3. 配置 CORS**
```java
// 确保允许前端跨域访问
@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOrigins("http://localhost:3000")
                .allowedMethods("*")
                .allowCredentials(true);
    }
}
```

**交付物:**
- [ ] 后端服务可启动
- [ ] API 接口可访问
- [ ] CORS 配置正确
- [ ] 测试数据已准备

---

#### 前端任务 (豆沙)

**1. 配置 Vite 代理**
```typescript
// vite.config.ts
export default defineConfig({
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true
      }
    }
  }
})
```

**2. 准备 Mock 数据**
```typescript
// src/api/mock.ts
export const mockArticles = [
  {
    id: 1,
    title: 'Mock 文章 1',
    summary: 'Mock 内容',
    ...
  }
]
```

**3. 开发首页组件**
```vue
<!-- src/views/Home.vue -->
<template>
  <div>
    <Header />
    <ArticleList />
    <Sidebar />
    <Footer />
  </div>
</template>
```

**交付物:**
- [ ] Vite 代理配置完成
- [ ] 首页组件开发完成
- [ ] Mock 数据可展示

---

### Day 2 (2026-03-13) - 接口联调

#### 联调步骤

**步骤 1: 测试文章列表 API**

前端调用:
```typescript
// src/api/article.ts
export const getArticles = (params: ArticleListParams) => {
  return request.get('/articles', { params })
}
```

后端接口:
```java
// ArticleController.java
@GetMapping
public ResponseEntity<ApiResponse<Page<ArticleDTO>>> getArticles(
    @RequestParam(defaultValue = "1") int page,
    @RequestParam(defaultValue = "10") int size
) {
    return ResponseEntity.ok(articleService.getArticles(page, size));
}
```

**测试流程:**
1. 前端发起请求 `GET /api/articles?page=1&size=10`
2. 后端返回 JSON 数据
3. 前端检查响应格式
4. 前端渲染文章列表

**预期响应:**
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "list": [
      {
        "id": 1,
        "title": "测试文章 1",
        "summary": "测试内容",
        "author": { "username": "admin" },
        "viewCount": 100
      }
    ],
    "pagination": {
      "page": 1,
      "size": 10,
      "total": 2
    }
  }
}
```

---

**步骤 2: 测试文章详情 API**

前端调用:
```typescript
export const getArticle = (id: number) => {
  return request.get(`/articles/${id}`)
}
```

后端接口:
```java
@GetMapping("/{id}")
public ResponseEntity<ApiResponse<ArticleDTO>> getArticle(@PathVariable Long id) {
    return ResponseEntity.ok(articleService.getById(id));
}
```

**测试流程:**
1. 前端发起请求 `GET /api/articles/1`
2. 后端返回文章详情
3. 前端渲染文章内容
4. 检查 Markdown 渲染效果

---

**步骤 3: 测试创建文章 API (需要认证)**

前端调用:
```typescript
export const createArticle = (data: ArticleCreateParams) => {
  return request.post('/articles', data)
}
```

后端接口:
```java
@PostMapping
public ResponseEntity<ApiResponse<ArticleDTO>> createArticle(
    @RequestBody ArticleCreateDTO dto,
    @AuthenticationPrincipal UserDetails userDetails
) {
    Long authorId = ((CustomUserDetails) userDetails).getUserId();
    return ResponseEntity.ok(articleService.create(dto, authorId));
}
```

**测试流程:**
1. 前端登录获取 Token
2. 携带 Token 创建文章
3. 后端验证 Token
4. 创建成功返回文章 ID

---

#### 常见问题排查

**问题 1: CORS 错误**

**现象:**
```
Access to XMLHttpRequest at 'http://localhost:8080/api/articles' 
from origin 'http://localhost:3000' has been blocked by CORS policy
```

**解决方案:**
```java
// 后端添加 CORS 配置
@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOrigins("http://localhost:3000")
                .allowedMethods("*")
                .allowCredentials(true);
    }
}
```

---

**问题 2: Token 认证失败**

**现象:**
```json
{
  "code": 401,
  "message": "Token 无效或已过期"
}
```

**解决方案:**
```typescript
// 前端检查 Token 是否正确附加
axios.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})
```

---

**问题 3: 响应格式不一致**

**现象:**
```typescript
// 前端期望
response.data.data.list

// 后端返回
response.data.list  // 缺少一层 data
```

**解决方案:**
- 统一使用 `ApiResponse<T>` 包装类
- 前端 Axios 响应拦截器统一处理

---

### Day 3 (2026-03-14) - 部署测试

#### 后端部署 (酸菜)

**1. 打包 JAR**
```bash
cd F:\openclaw\code\backend
mvn clean package -DskipTests
```

**2. 上传到服务器**
```bash
scp target/blog-backend-1.0.0.jar root@{SERVER_IP}:/opt/blog-system/app/
```

**3. 启动服务**
```bash
# SSH 到服务器
ssh root@{SERVER_IP}

# 启动服务
java -Xms600m -Xmx600m -jar /opt/blog-system/app/blog-backend-1.0.0.jar &

# 或使用 systemd
systemctl start blog-backend
```

**4. 验证服务**
```bash
curl http://localhost:8080/api/health
```

---

#### 前端部署 (酸菜)

**1. 构建生产版本**
```bash
cd F:\openclaw\code\frontend
npm run build
```

**2. 上传到服务器**
```bash
scp -r dist/* root@{SERVER_IP}:/var/www/blog-frontend/
```

**3. 配置 Nginx**
```nginx
server {
    listen 80;
    server_name {SERVER_IP};
    
    # 前端静态文件
    location / {
        root /var/www/blog-frontend;
        try_files $uri $uri/ /index.html;
    }
    
    # 后端 API 代理
    location /api/ {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

**4. 验证访问**
```bash
# 访问首页
curl http://{SERVER_IP}/

# 访问 API
curl http://{SERVER_IP}/api/articles
```

---

## 📊 联调检查清单

### 后端检查项

- [ ] 文章列表 API 可访问
- [ ] 文章详情 API 可访问
- [ ] 创建文章 API 可访问 (需认证)
- [ ] 更新文章 API 可访问 (需认证)
- [ ] 删除文章 API 可访问 (需认证)
- [ ] 分类列表 API 可访问
- [ ] 标签列表 API 可访问
- [ ] 用户登录 API 可访问
- [ ] CORS 配置正确
- [ ] 错误响应格式统一
- [ ] 日志记录完整

---

### 前端检查项

- [ ] 首页文章列表展示正常
- [ ] 文章详情页展示正常
- [ ] Markdown 渲染正常
- [ ] 分页功能正常
- [ ] 分类筛选正常
- [ ] 标签筛选正常
- [ ] 登录功能正常
- [ ] 管理后台可访问
- [ ] 创建文章功能正常
- [ ] 编辑文章功能正常
- [ ] 响应式布局正常
- [ ] 错误处理正常

---

### 运维检查项

- [ ] JDK 21 已安装
- [ ] MySQL 8.0 已安装
- [ ] Nginx 已安装
- [ ] 数据库已初始化
- [ ] 后端服务可启动
- [ ] 前端构建成功
- [ ] Nginx 配置正确
- [ ] 防火墙规则配置
- [ ] 服务开机自启
- [ ] 日志目录权限正确

---

## 🔧 调试工具

### 后端调试

**1. 使用 Postman 测试 API**
```
GET http://localhost:8080/api/articles
Authorization: Bearer <token>
```

**2. 查看后端日志**
```bash
# 开发环境
mvn spring-boot:run

# 生产环境
journalctl -u blog-backend -f
```

**3. 数据库检查**
```sql
-- 检查文章数据
SELECT id, title, status FROM articles LIMIT 10;

-- 检查用户数据
SELECT id, username, role FROM users;
```

---

### 前端调试

**1. 浏览器开发者工具**
```
F12 → Network → 查看 API 请求
F12 → Console → 查看错误日志
F12 → Application → 查看 localStorage
```

**2. Vue DevTools**
```
安装 Vue DevTools 扩展
查看组件树、状态、事件
```

**3. 查看前端日志**
```typescript
// 添加调试日志
console.log('API Response:', response)
```

---

## 📝 联调日志模板

```markdown
## 联调日志 - YYYY-MM-DD

**参与人员:** 酱肉、豆沙、酸菜

### 完成的工作

1. [后端] 文章列表 API 开发完成
2. [前端] 首页组件开发完成
3. [联调] 文章列表接口对接成功

### 遇到的问题

1. **CORS 错误**
   - 现象：前端无法访问后端 API
   - 解决：后端添加 CORS 配置
   - 负责人：酱肉

2. **Token 认证失败**
   - 现象：401 错误
   - 解决：前端修复 Token 附加逻辑
   - 负责人：豆沙

### 明日计划

1. [后端] 开发评论 API
2. [前端] 开发评论组件
3. [联调] 评论功能对接
```

---

## 📞 沟通机制

**日常沟通:** Gateway 实时通信

**联调会议:**
- 每日 10:00 站会 (同步当日计划)
- 每日 18:00 站会 (总结当日进度)

**问题上报:**
- 一般问题：直接沟通解决
- 阻塞问题：上报灌汤协调

---

**维护者:** 酱肉 & 豆沙  
**更新日期:** 2026-03-12  
**版本:** v1.0
