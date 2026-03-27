<!-- Last Modified: 2026-03-27 23:25 -->

# 博客系统前端整合改造方案 v1.0

**文档状态:** 已批准  
**创建日期:** 2026-03-27 23:25  
**负责人:** 灌汤 (PM)  
**版本:** 1.0

---

## 📋 目录

1. [改造背景与目标](#改造背景与目标)
2. [详细接口定义](#详细接口定义)
3. [数据模型定义](#数据模型定义)
4. [前端组件规范](#前端组件规范)
5. [权限检查流程](#权限检查流程)
6. [执行计划](#执行计划)
7. [测试计划](#测试计划)

---

## 改造背景与目标

### 当前问题

| 问题 | 表现 | 影响 |
|------|------|------|
| 无统一布局 | 每个页面独立渲染，无 NavBar | 用户无法导航 |
| VIP 权限缺失 | 数据库有 access_level 但后端未返回 | 无法区分 VIP 用户 |
| 评论功能无后端 | 前端有 CommentList 但无 API | 评论无法使用 |
| 路由混乱 | /admin/agents 有前缀，/user-center 没有 | 用户体验割裂 |

### 改造目标

1. **统一布局** — 所有页面有 NavBar + Footer
2. **VIP 权限** — 支持公开/登录/VIP 三级文章权限
3. **评论功能** — 完整的评论 CRUD
4. **路由规范** — 统一的命名和权限控制

---

## 详细接口定义

### 1. 认证模块

#### 1.1 用户登录

**接口:** `POST /api/auth/login`

**请求:**
```json
{
  "username": "string",
  "password": "string"
}
```

**响应:**
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": 1,
    "username": "testuser",
    "email": "test@example.com",
    "avatar": "https://...",
    "accessLevel": 0,
    "token": "eyJhbGciOiJIUzI1NiJ9...",
    "expiresIn": 7200
  },
  "timestamp": 1711350000000
}
```

**字段说明:**
| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| id | Long | ✅ | 用户 ID |
| username | String | ✅ | 用户名 |
| email | String | ✅ | 邮箱 |
| avatar | String | ❌ | 头像 URL |
| accessLevel | Integer | ✅ | 访问级别：0-普通 1-VIP 2-管理员 |
| token | String | ✅ | JWT Token |
| expiresIn | Integer | ✅ | Token 有效期（秒） |

---

#### 1.2 获取当前用户信息

**接口:** `GET /api/auth/me`

**请求头:**
```
Authorization: Bearer {token}
```

**响应:**
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": 1,
    "username": "testuser",
    "email": "test@example.com",
    "avatar": "https://...",
    "accessLevel": 1
  },
  "timestamp": 1711350000000
}
```

**错误响应:**
| code | message | 说明 |
|------|---------|------|
| 401 | 未登录 | Token 缺失或过期 |

---

### 2. 文章模块

#### 2.1 获取文章列表

**接口:** `GET /api/articles?page=1&size=10&categoryId=1`

**请求参数:**
| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| page | Integer | ❌ | 页码，默认 1 |
| size | Integer | ❌ | 每页数量，默认 10 |
| categoryId | Long | ❌ | 分类 ID 过滤 |

**响应:**
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "records": [
      {
        "id": 1,
        "title": "文章标题",
        "summary": "文章摘要",
        "coverImage": "https://...",
        "accessLevel": 0,
        "viewCount": 100,
        "createTime": "2026-03-27T10:00:00",
        "category": {
          "id": 1,
          "name": "技术文章"
        },
        "author": {
          "id": 1,
          "username": "admin",
          "avatar": "https://..."
        }
      }
    ],
    "total": 50,
    "page": 1,
    "size": 10
  },
  "timestamp": 1711350000000
}
```

**字段说明 (Article):**
| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 文章 ID |
| title | String | 标题 |
| summary | String | 摘要 |
| coverImage | String | 封面图 URL |
| accessLevel | Integer | 访问级别：0-公开 1-登录 2-VIP |
| viewCount | Integer | 浏览量 |
| createTime | String | 创建时间 |
| category | Object | 分类信息 |
| author | Object | 作者信息 |

---

#### 2.2 获取文章详情

**接口:** `GET /api/articles/{id}`

**请求头:**
```
Authorization: Bearer {token}  // 可选，VIP 文章必需
```

**响应 (公开文章):**
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": 1,
    "title": "文章标题",
    "content": "<p>文章内容</p>",
    "accessLevel": 0,
    "viewCount": 100,
    "createTime": "2026-03-27T10:00:00",
    "category": {
      "id": 1,
      "name": "技术文章"
    },
    "author": {
      "id": 1,
      "username": "admin",
      "avatar": "https://..."
    },
    "tags": [
      {"id": 1, "name": "Java"}
    ]
  },
  "timestamp": 1711350000000
}
```

**错误响应 (VIP 文章未登录):**
```json
{
  "code": 401,
  "message": "请先登录",
  "data": null,
  "timestamp": 1711350000000
}
```

**错误响应 (VIP 文章无权限):**
```json
{
  "code": 403,
  "message": "需要 VIP 权限",
  "data": null,
  "timestamp": 1711350000000
}
```

---

### 3. 评论模块

#### 3.1 获取评论列表

**接口:** `GET /api/comments?articleId=1&page=1&size=20`

**请求参数:**
| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| articleId | Long | ✅ | 文章 ID |
| page | Integer | ❌ | 页码，默认 1 |
| size | Integer | ❌ | 每页数量，默认 20 |

**响应:**
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "records": [
      {
        "id": 1,
        "content": "评论内容",
        "createTime": "2026-03-27T10:00:00",
        "user": {
          "id": 1,
          "username": "user1",
          "avatar": "https://..."
        }
      }
    ],
    "total": 10,
    "page": 1,
    "size": 20
  },
  "timestamp": 1711350000000
}
```

---

#### 3.2 发表评论

**接口:** `POST /api/comments`

**请求头:**
```
Authorization: Bearer {token}
```

**请求体:**
```json
{
  "articleId": 1,
  "content": "评论内容"
}
```

**响应:**
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": 1,
    "content": "评论内容",
    "createTime": "2026-03-27T10:00:00",
    "user": {
      "id": 1,
      "username": "user1",
      "avatar": "https://..."
    }
  },
  "timestamp": 1711350000000
}
```

**错误响应:**
| code | message | 说明 |
|------|---------|------|
| 401 | 请先登录 | Token 缺失 |
| 400 | 评论内容不能为空 | content 为空 |
| 404 | 文章不存在 | articleId 无效 |

---

#### 3.3 删除评论

**接口:** `DELETE /api/comments/{id}`

**请求头:**
```
Authorization: Bearer {token}
```

**响应:**
```json
{
  "code": 200,
  "message": "success",
  "data": null,
  "timestamp": 1711350000000
}
```

**错误响应:**
| code | message | 说明 |
|------|---------|------|
| 401 | 请先登录 | Token 缺失 |
| 403 | 无权限删除 | 不是评论作者或管理员 |
| 404 | 评论不存在 | id 无效 |

---

## 数据模型定义

### 后端实体类

#### User.java
```java
@Data
@TableName("users")
public class User {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private String username;
    private String email;
    private String password;
    private String avatar;
    private Integer accessLevel;  // 0-普通 1-VIP 2-管理员
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
```

#### Article.java
```java
@Data
@TableName("articles")
public class Article {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private String title;
    private String summary;
    private String contentMd;
    private String contentHtml;
    private String coverImage;
    private Integer accessLevel;  // 0-公开 1-登录 2-VIP
    private Long categoryId;
    private Long authorId;
    private Integer viewCount;
    private Integer status;  // 0-草稿 1-已发布 2-已归档
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
```

#### Comment.java
```java
@Data
@TableName("comments")
public class Comment {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private Long articleId;
    private Long userId;
    private String content;
    private Integer deleted;  // 0-正常 1-已删除
    private LocalDateTime createdAt;
}
```

---

### 前端 TypeScript 类型

#### types/user.ts
```typescript
export interface User {
  id: number;
  username: string;
  email: string;
  avatar?: string;
  accessLevel: number;  // 0-普通 1-VIP 2-管理员
}

export interface LoginRequest {
  username: string;
  password: string;
}

export interface LoginResponse {
  code: number;
  message: string;
  data: User & {
    token: string;
    expiresIn: number;
  };
  timestamp: number;
}
```

#### types/article.ts
```typescript
export interface Article {
  id: number;
  title: string;
  summary?: string;
  content?: string;
  coverImage?: string;
  accessLevel: number;  // 0-公开 1-登录 2-VIP
  viewCount: number;
  createTime: string;
  category?: Category;
  author?: Author;
  tags?: Tag[];
}

export interface Category {
  id: number;
  name: string;
  slug?: string;
}

export interface Author {
  id: number;
  username: string;
  avatar?: string;
}

export interface Tag {
  id: number;
  name: string;
}

export interface ArticleListResponse {
  code: number;
  message: string;
  data: {
    records: Article[];
    total: number;
    page: number;
    size: number;
  };
  timestamp: number;
}
```

#### types/comment.ts
```typescript
export interface Comment {
  id: number;
  content: string;
  createTime: string;
  user: {
    id: number;
    username: string;
    avatar?: string;
  };
}

export interface CommentCreateRequest {
  articleId: number;
  content: string;
}

export interface CommentListResponse {
  code: number;
  message: string;
  data: {
    records: Comment[];
    total: number;
    page: number;
    size: number;
  };
  timestamp: number;
}
```

---

## 前端组件规范

### NavBar.vue

**功能:** 全局导航栏，显示登录状态

**模板结构:**
```vue
<template>
  <nav class="navbar">
    <div class="logo">博客系统</div>
    <div class="nav-links">
      <router-link to="/">首页</router-link>
      <router-link to="/categories">分类</router-link>
      <router-link to="/tags">标签</router-link>
    </div>
    <div class="user-menu">
      <template v-if="isLoggedIn">
        <router-link to="/user-center">
          <img :src="user?.avatar" class="avatar" />
          <span>{{ user?.username }}</span>
        </router-link>
        <button @click="logout">退出</button>
      </template>
      <template v-else>
        <router-link to="/login">登录</router-link>
        <router-link to="/register">注册</router-link>
      </template>
    </div>
  </nav>
</template>
```

---

### ArticleCard.vue

**功能:** 文章卡片，显示 VIP 锁图标

**模板结构:**
```vue
<template>
  <div class="article-card">
    <img v-if="article.coverImage" :src="article.coverImage" class="cover" />
    <div class="content">
      <h3 class="title">
        <router-link :to="`/article/${article.id}`">
          {{ article.title }}
        </router-link>
        <el-icon v-if="article.accessLevel > 0" class="vip-icon"><Lock /></el-icon>
      </h3>
      <p class="summary">{{ article.summary }}</p>
      <div class="meta">
        <span class="author">{{ article.author?.username }}</span>
        <span class="views">{{ article.viewCount }} 阅读</span>
      </div>
    </div>
  </div>
</template>
```

---

### CommentList.vue

**功能:** 评论列表

**模板结构:**
```vue
<template>
  <div class="comment-list">
    <div v-for="comment in comments" :key="comment.id" class="comment">
      <img :src="comment.user.avatar" class="avatar" />
      <div class="content">
        <div class="author">{{ comment.user.username }}</div>
        <div class="text">{{ comment.content }}</div>
        <div class="time">{{ formatTime(comment.createTime) }}</div>
      </div>
    </div>
  </div>
</template>
```

---

### CommentForm.vue

**功能:** 发表评论表单

**模板结构:**
```vue
<template>
  <div class="comment-form">
    <el-input
      v-model="content"
      type="textarea"
      :rows="3"
      placeholder="发表评论..."
    />
    <el-button type="primary" @click="submit" :loading="submitting">
      提交评论
    </el-button>
  </div>
</template>
```

---

## 权限检查流程

### 后端权限检查逻辑

```java
// ArticleController.java
@GetMapping("/{id}")
public Result<ArticleResponseDTO> getArticleById(
    @PathVariable Long id,
    @RequestHeader(value = "Authorization", required = false) String authorization) {
    
    // 1. 获取文章
    Article article = articleService.getById(id);
    if (article == null) {
        return Result.error(404, "文章不存在");
    }
    
    // 2. 检查权限
    if (article.getAccessLevel() > 0) {
        // 需要登录或 VIP
        if (authorization == null || !authorization.startsWith("Bearer ")) {
            return Result.error(401, "请先登录");
        }
        
        String token = authorization.substring(7);
        Long userId = jwtUtil.getUserIdFromToken(token);
        User user = userService.getById(userId);
        
        if (user == null) {
            return Result.error(401, "请先登录");
        }
        
        if (user.getAccessLevel() < article.getAccessLevel()) {
            return Result.error(403, "需要 VIP 权限");
        }
    }
    
    // 3. 返回文章
    ArticleResponseDTO dto = articleService.convertToDTO(article);
    return Result.success(dto);
}
```

---

### 前端路由守卫

```typescript
// router/index.ts
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token');
  const requiresAuth = to.meta.requiresAuth as boolean;
  
  if (requiresAuth && !token) {
    // 需要登录但未登录
    next({ path: '/login', query: { redirect: to.fullPath } });
  } else {
    next();
  }
});
```

---

## 执行计划

### Plan-011: 后端改造（酱肉负责）

**总工期:** 4-5 小时

| 轮次 | 任务 | 交付物 | 验收标准 | 预计时间 |
|------|------|--------|---------|---------|
| R1 | 数据库结构修改 | SQL 脚本 + 执行完成 | articles 表有 access_level 字段，comments 表创建成功 | 30min |
| R2 | User 实体/DTO 修改 | User.java + UserDTO.java | accessLevel 字段可正常读写 | 30min |
| R3 | Article 实体/DTO 修改 | Article.java + ArticleResponseDTO.java | accessLevel 字段可正常读写 | 30min |
| R4 | Comment 模块开发 | Comment.java + Mapper + Service + Controller | CRUD 接口全部可用 | 120min |
| R5 | ArticleController 权限检查 | 修改 getArticleById 方法 | 公开/登录/VIP 文章权限检查正确 | 60min |
| R6 | 单元测试 + 自测 | 测试用例 + 测试报告 | 核心功能测试覆盖率≥80% | 45min |

---

### Plan-012: 前端整合（豆沙负责）

**前置条件:** Plan-011 R2 完成（UserDTO 返回 accessLevel）

**总工期:** 2 小时

| 轮次 | 任务 | 交付物 | 验收标准 | 预计时间 |
|------|------|--------|---------|---------|
| R1 | 统一布局 | MainLayout.vue + NavBar.vue + Footer.vue + router/index.ts | 所有页面有统一导航，路由配置正确 | 40min |
| R2 | VIP 权限集成 | ArticleCard.vue(锁图标) + ArticleDetail.vue(权限检查) + 路由守卫 | VIP 文章显示锁图标，无权限时正确提示 | 40min |
| R3 | 评论功能 | CommentList.vue + CommentForm.vue + ArticleDetail 集成 | 评论列表显示正常，登录后可发表评论 | 40min |

---

### Plan-013: 联调测试（酸菜负责）

**前置条件:** Plan-011 + Plan-012 完成

**总工期:** 1.5 小时

| 轮次 | 任务 | 交付物 | 验收标准 | 预计时间 |
|------|------|--------|---------|---------|
| R1 | API 测试 | API 测试报告 | 所有接口返回符合文档定义 | 30min |
| R2 | VIP 权限测试 | 权限测试报告 | 公开/登录/VIP 文章访问控制正确 | 30min |
| R3 | E2E 测试 | E2E 测试报告 | 完整用户旅程测试通过 | 30min |

---

## 测试计划

### API 测试用例（酸菜）

#### 认证模块

| 用例 ID | 接口 | 测试场景 | 预期结果 |
|--------|------|---------|---------|
| AUTH-001 | POST /api/auth/login | 正确用户名密码 | 200 + token + accessLevel |
| AUTH-002 | POST /api/auth/login | 错误密码 | 401 |
| AUTH-003 | GET /api/auth/me | 有效 token | 200 + 用户信息 + accessLevel |
| AUTH-004 | GET /api/auth/me | 过期 token | 401 |
| AUTH-005 | GET /api/auth/me | 无 token | 401 |

---

#### 文章模块

| 用例 ID | 接口 | 测试场景 | 预期结果 |
|--------|------|---------|---------|
| ART-001 | GET /api/articles | 公开文章列表 | 200 + 文章列表 |
| ART-002 | GET /api/articles/{id} | 公开文章详情 | 200 + 文章详情 |
| ART-003 | GET /api/articles/{id} | VIP 文章详情（无 token） | 401 |
| ART-004 | GET /api/articles/{id} | VIP 文章详情（普通用户 token） | 403 |
| ART-005 | GET /api/articles/{id} | VIP 文章详情（VIP 用户 token） | 200 + 文章详情 |

---

#### 评论模块

| 用例 ID | 接口 | 测试场景 | 预期结果 |
|--------|------|---------|---------|
| CMT-001 | GET /api/comments?articleId=1 | 获取评论列表 | 200 + 评论列表 |
| CMT-002 | POST /api/comments | 无 token 发表评论 | 401 |
| CMT-003 | POST /api/comments | 有效 token + 空内容 | 400 |
| CMT-004 | POST /api/comments | 有效 token + 正常内容 | 200 + 评论对象 |
| CMT-005 | DELETE /api/comments/{id} | 删除自己的评论 | 200 |
| CMT-006 | DELETE /api/comments/{id} | 删除他人的评论 | 403 |

---

### E2E 测试用例（酸菜）

#### 用户旅程测试

| 用例 ID | 场景 | 步骤 | 预期结果 |
|--------|------|------|---------|
| E2E-001 | 访客浏览公开文章 | 1. 打开首页<br>2. 点击文章<br>3. 查看内容 | 1. 文章列表显示正常<br>2. 文章详情打开<br>3. 内容可见 |
| E2E-002 | 用户登录 | 1. 点击登录<br>2. 输入用户名密码<br>3. 提交 | 1. 登录页打开<br>2. 登录成功<br>3. NavBar 显示用户信息 |
| E2E-003 | VIP 文章访问 | 1. 访客点击 VIP 文章<br>2. 登录后再次访问 | 1. 提示"请先登录"<br>2. 登录后可查看 |
| E2E-004 | 发表评论 | 1. 打开文章详情<br>2. 输入评论内容<br>3. 提交 | 1. 评论表单显示<br>2. 评论成功<br>3. 评论列表更新 |

---

## 风险与缓解

| 风险 | 影响 | 概率 | 缓解措施 |
|------|------|------|---------|
| 数据库修改影响现有数据 | 高 | 低 | 先备份，测试环境验证 |
| 后端接口延期 | 高 | 中 | 前后端并行，前端用 Mock 数据 |
| VIP 权限逻辑错误 | 高 | 中 | 详细测试用例，酸菜提前介入 |
| 评论功能性能问题 | 中 | 低 | 分页加载，限制每页数量 |

---

## 验收标准

### 后端验收

- [ ] UserDTO 返回 accessLevel 字段
- [ ] ArticleResponseDTO 返回 accessLevel 字段
- [ ] GET /articles/{id} 权限检查正常（公开/登录/VIP）
- [ ] Comment 模块 CRUD 接口正常
- [ ] 数据库 access_level/comments 表创建完成
- [ ] 单元测试覆盖率≥80%

---

### 前端验收

- [ ] MainLayout 应用到所有页面
- [ ] NavBar 显示登录状态
- [ ] VIP 文章显示锁图标
- [ ] 无权限时显示"登录查看"或"需要 VIP 权限"
- [ ] 评论区正常显示和发表
- [ ] 路由守卫正常工作

---

### 测试验收

- [ ] API 测试全部通过
- [ ] VIP 权限测试全部通过
- [ ] E2E 测试全部通过
- [ ] 无严重 Bug

---

*文档版本：v1.0 | 创建者：灌汤 PM | 2026-03-27 23:25*
