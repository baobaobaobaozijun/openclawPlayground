# 前后端联调任务清单

**生成时间:** 2026-03-25 22:56  
**分析人:** 任务拆分器（PM 灌汤委派）

---

## 🔴 P0 核心流程（必须完成）

### 模块 1: 用户认证

| 接口 | 前端定义 | 后端定义 | 状态 | 任务 |
|------|---------|---------|------|------|
| **POST /auth/login** | `request.post('/auth/login', { username, password })`<br>期望响应：`{ code, message, data: { id, username, email, avatar, token }, timestamp }` | `@PostMapping("/auth/login")`<br>返回：`Result<UserDTO>`<br>`UserDTO: { id, username, email, avatar, token }` | ✅ 匹配 | 无需调整 |
| **POST /auth/register** | `request.post('/auth/register', { username, email, password, nickname? })`<br>期望响应：同 login | `@PostMapping("/auth/register")`<br>返回：`Result<UserDTO>`<br>但 `RegisterRequest` 需检查字段 | ⚠️ 需验证 | 检查后端 RegisterRequest 是否包含 nickname 字段 |
| **GET /auth/me** | `request.get('/auth/me')`<br>请求头：`Authorization: Bearer {token}`<br>期望响应：`{ code, message, data: { id, username, email, avatar }, timestamp }` | `@GetMapping("/me")`<br>要求请求头：`Authorization: Bearer {token}`<br>返回：`Result<UserDTO>`（token 字段设为 null） | ✅ 匹配 | 无需调整 |

### 模块 2: 文章管理

| 接口 | 前端定义 | 后端定义 | 状态 | 任务 |
|------|---------|---------|------|------|
| **GET /articles** | `request.get('/articles', { params: { page, size, keyword, categoryId } })` | `@GetMapping`<br>参数：`page, size, keyword, categoryId`<br>返回：`Result<Page<ArticleResponseDTO>>` | ✅ 匹配 | 无需调整 |
| **GET /articles/:id** | `request.get('/articles/:id')` | `@GetMapping("/{id}")`<br>返回：`Result<ArticleResponseDTO>` | ✅ 匹配 | 无需调整 |
| **POST /articles** | `request.post('/articles', { title, content, summary?, categoryId?, status })`<br>**注意：** 前端未传 authorId | `@PostMapping`<br>要求请求头：`X-User-Id: {authorId}`<br>DTO: `ArticleCreateDTO` | ❌ **不匹配** | **后端需要 authorId，前端未传** |
| **PUT /articles/:id** | `request.put('/articles/:id', { title?, content?, categoryId? })` | `@PutMapping("/{id}")`<br>DTO: `ArticleUpdateDTO` | ⚠️ 需验证 | 检查 ArticleUpdateDTO 字段是否匹配 |
| **DELETE /articles/:id** | `request.delete('/articles/:id')` | `@DeleteMapping("/{id}")`<br>返回：`Result<Void>` | ✅ 匹配 | 无需调整 |

### 模块 3: 分类管理

| 接口 | 前端定义 | 后端定义 | 状态 | 任务 |
|------|---------|---------|------|------|
| **GET /categories** | `request({ url: '/api/categories', method: 'get' })` | `@GetMapping`<br>返回：`Result<List<Category>>` | ✅ 匹配 | 无需调整 |
| **GET /categories/:id** | `request({ url: '/api/categories/:id', method: 'get' })` | `@GetMapping("/{id}")`<br>返回：`Result<Category>` | ✅ 匹配 | 无需调整 |
| **POST /categories** | `request({ url: '/api/categories', method: 'post', data })` | `@PostMapping`<br>接收：`@RequestBody Category` | ⚠️ 需验证 | 检查 Category 实体字段 |
| **PUT /categories/:id** | `request({ url: '/api/categories/:id', method: 'put', data })` | `@PutMapping("/{id}")`<br>接收：`@RequestBody Category` | ✅ 匹配 | 无需调整 |
| **DELETE /categories/:id** | `request({ url: '/api/categories/:id', method: 'delete' })` | `@DeleteMapping("/{id}")`<br>返回：`Result<Void>` | ✅ 匹配 | 无需调整 |

---

## 🟡 P1 重要功能

### 模块 4: 标签管理

| 接口 | 前端定义 | 后端定义 | 状态 | 任务 |
|------|---------|---------|------|------|
| **GET /tags** | ❌ **前端未定义** | `@GetMapping`<br>返回：`Result<List<Tag>>` | ❌ 缺失 | 前端需补充 `@/api/tag.ts` |
| **GET /tags/:id** | ❌ **前端未定义** | `@GetMapping("/{id}")`<br>返回：`Result<Tag>` | ❌ 缺失 | 前端需补充 |
| **POST /tags** | ❌ **前端未定义** | `@PostMapping`<br>接收：`@RequestBody Tag` | ❌ 缺失 | 前端需补充 |
| **DELETE /tags/:id** | ❌ **前端未定义** | `@DeleteMapping("/{id}")`<br>返回：`Result<Void>` | ❌ 缺失 | 前端需补充 |

### 模块 5: 文章高级查询

| 接口 | 前端定义 | 后端定义 | 状态 | 任务 |
|------|---------|---------|------|------|
| **GET /articles/page** | ❌ **前端未定义** | `@GetMapping("/page")`<br>参数：`pageNum, pageSize`<br>返回：`Result<Page<ArticleResponseDTO>>` | ❌ 缺失 | 前端可选择性补充（与 GET /articles 功能重叠） |
| **GET /articles/author/:authorId** | ❌ **前端未定义** | `@GetMapping("/author/{authorId}")`<br>返回：`Result<List<ArticleResponseDTO>>` | ❌ 缺失 | 前端可选择性补充（个人中心用） |
| **GET /articles/status/:status** | ❌ **前端未定义** | `@GetMapping("/status/{status}")`<br>返回：`Result<List<ArticleResponseDTO>>` | ❌ 缺失 | 前端可选择性补充（草稿箱用） |

---

## 🟢 P2 增强功能

| 接口 | 前端定义 | 后端定义 | 状态 | 任务 |
|------|---------|---------|------|------|
| **文章搜索** | ✅ 支持（keyword 参数） | ✅ 支持 | ✅ 匹配 | 无需调整 |
| **分类筛选** | ✅ 支持（categoryId 参数） | ✅ 支持 | ✅ 匹配 | 无需调整 |

---

## ⚠️ 风险项

### 🔴 高风险（阻塞联调）

1. **文章创建接口 authorId 传递问题**
   - **问题：** 后端要求 `X-User-Id` 请求头传递 authorId，但前端 `createArticle` 未传
   - **影响：** 文章创建会失败（400 或 500 错误）
   - **解决方案（二选一）：**
     - **方案 A（推荐）：** 后端从 JWT token 解析 userId，不再依赖 `X-User-Id` 请求头
     - **方案 B：** 前端修改 `createArticle`，从 localStorage 获取用户 ID 并通过请求头传递

2. **分类 API 路径不一致**
   - **问题：** 前端 category.ts 中使用 `/api/categories`（带 `/api` 前缀），但 request.ts 的 baseURL 已是 `/api`
   - **影响：** 实际请求会变成 `/api/api/categories` → 404
   - **解决方案：** 修改 category.ts，移除 URL 中的 `/api` 前缀（与 article.ts 保持一致）

### 🟡 中风险（影响部分功能）

3. **标签管理前端缺失**
   - **问题：** 前端完全没有标签 API 定义
   - **影响：** 标签相关功能无法使用
   - **解决方案：** 创建 `@/api/tag.ts`，参考 category.ts 风格

4. **RegisterRequest 字段不匹配**
   - **问题：** 前端注册接口传 `nickname?` 字段，需确认后端 DTO 是否支持
   - **影响：** 注册可能失败或 nickname 被忽略
   - **解决方案：** 检查后端 `RegisterRequest.java`，如缺失则添加

### 🟢 低风险（体验优化）

5. **响应格式不一致**
   - **问题：** 前端期望响应直接是 data，但后端统一返回 `Result<T>` 包装
   - **现状：** request.ts 响应拦截器返回 `response.data`（即整个 Result 对象）
   - **影响：** 前端代码需要解构 `result.data` 获取实际数据
   - **建议：** 统一规范，前端调用时明确 `const { data } = await authApi.login(...)`

---

## 📋 执行计划

### 第一阶段：修复阻塞问题（预计 30min）

**任务 1.1：** 修复分类 API 路径（前端 - 豆沙）
```
文件：F:\openclaw\code\frontend\src\api\category.ts
修改：移除所有 URL 中的 '/api' 前缀
验收：request.get('/categories') 实际请求为 /api/categories
```

**任务 1.2：** 解决文章创建 authorId 问题（后端 - 酱肉）
```
文件：F:\openclaw\code\backend\src\main\java\com\openclaw\controller\ArticleController.java
修改：从 JWT token 解析 userId，移除 @RequestHeader("X-User-Id") 依赖
验收：POST /articles 无需 X-User-Id 请求头即可成功创建
```

### 第二阶段：补充缺失功能（预计 45min）

**任务 2.1：** 创建标签 API（前端 - 豆沙）
```
文件：F:\openclaw\code\frontend\src\api\tag.ts
内容：参考 category.ts，实现 getList, getById, create, delete
验收：4 个接口定义完整，类型安全
```

**任务 2.2：** 检查 RegisterRequest 字段（后端 - 酱肉）
```
文件：F:\openclaw\code\backend\src\main\java\com\openclaw\dto\RegisterRequest.java
检查：是否包含 nickname 字段
验收：如缺失则添加，确保前后端字段一致
```

### 第三阶段：联调测试（预计 60min）

**任务 3.1：** 认证流程联调
- [ ] 注册 → 登录 → 获取用户信息
- [ ] Token 存储与自动携带
- [ ] 401 自动跳转登录

**任务 3.2：** 文章 CRUD 联调
- [ ] 获取文章列表（分页、搜索、分类筛选）
- [ ] 获取文章详情
- [ ] 创建文章（验证 authorId 自动填充）
- [ ] 更新文章
- [ ] 删除文章

**任务 3.3：** 分类 CRUD 联调
- [ ] 获取分类列表
- [ ] 创建分类
- [ ] 更新分类
- [ ] 删除分类

**任务 3.4：** 标签 CRUD 联调（如需要）
- [ ] 获取标签列表
- [ ] 创建标签
- [ ] 删除标签

---

## 📊 总体状态

| 模块 | 接口总数 | ✅ 匹配 | ⚠️ 需调整 | ❌ 缺失 | 完成度 |
|------|---------|--------|----------|--------|--------|
| 用户认证 | 3 | 2 | 1 | 0 | 89% |
| 文章管理 | 5 | 3 | 1 | 1 | 70% |
| 分类管理 | 5 | 4 | 1 | 0 | 80% |
| 标签管理 | 4 | 0 | 0 | 4 | 0% |
| **总计** | **17** | **9** | **3** | **5** | **53%** |

---

## 🎯 下一步行动

1. **立即修复** 2 个高风险问题（任务 1.1 + 1.2）
2. **补充缺失** 标签 API 和 RegisterRequest 字段（任务 2.1 + 2.2）
3. **开始联调** 按认证 → 文章 → 分类 → 标签顺序测试
4. **更新文档** 联调完成后更新 API 文档

---

*文档结束*
