# 博客系统 API 接口文档 v1.0

**文档状态:** 已批准  
**创建日期:** 2026-03-12  
**最后更新:** 2026-03-12  
**负责人:** 酱肉 (后端)  
**版本:** 1.0

---

## 📋 目录

1. [API 设计规范](#api 设计规范)
2. [认证模块](#认证模块)
3. [文章模块](#文章模块)
4. [分类标签模块](#分类标签模块)
5. [日志提交模块](#日志提交模块)
6. [错误码定义](#错误码定义)

---

## API 设计规范

### 基础规范

| 项目 | 规范 |
|------|------|
| 协议 | HTTP/1.1 + HTTPS |
| 数据格式 | JSON (application/json) |
| 字符编码 | UTF-8 |
| 时间格式 | ISO 8601 (YYYY-MM-DDTHH:mm:ss+08:00) |
| 认证方式 | JWT Bearer Token |

### 基础 URL

```
生产环境：https://api.example.com/v1
开发环境：http://localhost:8080/api/v1
```

### 响应格式

**成功响应:**
```json
{
  "code": 0,
  "message": "success",
  "data": { ... },
  "timestamp": "2026-03-12T10:30:00+08:00"
}
```

**错误响应:**
```json
{
  "code": 1001,
  "message": "参数验证失败",
  "data": null,
  "timestamp": "2026-03-12T10:30:00+08:00"
}
```

### 分页响应

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "list": [ ... ],
    "pagination": {
      "page": 1,
      "pageSize": 20,
      "total": 100,
      "totalPages": 5
    }
  },
  "timestamp": "2026-03-12T10:30:00+08:00"
}
```

---

## 认证模块

### 1. 手机号登录

**接口:** `POST /auth/login`

**权限:** 公开（无需登录）

**请求:**
```json
{
  "phone": "13800138000"
}
```

**请求参数:**

| 字段 | 类型 | 必填 | 说明 | 验证规则 |
|------|------|------|------|----------|
| phone | string | 是 | 手机号 | `^1[3-9]\d{9}$` |

**响应:**
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
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

**响应字段:**

| 字段 | 类型 | 说明 |
|------|------|------|
| token | string | JWT Token |
| expiresIn | number | Token 有效期 (秒) |
| user.id | number | 用户 ID |
| user.phone | string | 手机号 |
| user.nickname | string | 昵称 |
| user.avatar | string | 头像 URL |
| user.role | string | 角色：user/author/admin |
| user.accessLevel | number | 访问级别：0/1/2 |

**测试用例:**

| 用例 ID | 测试场景 | 输入 | 预期结果 |
|---------|----------|------|----------|
| AUTH-001 | 有效手机号登录 | `{"phone": "13800138000"}` | 返回 200，包含 token |
| AUTH-002 | 新手机号自动注册 | `{"phone": "13900000000"}` | 返回 200，创建新用户 |
| AUTH-003 | 手机号格式错误 | `{"phone": "12345"}` | 返回 400，code=1001 |
| AUTH-004 | 空手机号 | `{}` | 返回 400，code=1001 |

---

### 2. Token 验证

**接口:** `GET /auth/me`

**权限:** 已登录用户

**请求头:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**响应:**
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
  },
  "timestamp": "2026-03-12T10:30:00+08:00"
}
```

**测试用例:**

| 用例 ID | 测试场景 | 输入 | 预期结果 |
|---------|----------|------|----------|
| AUTH-011 | 有效 Token | 正确 Bearer Token | 返回 200，用户信息 |
| AUTH-012 | Token 过期 | 过期 Token | 返回 401，code=2001 |
| AUTH-013 | Token 无效 | 伪造 Token | 返回 401，code=2002 |
| AUTH-014 | 无 Token | 无 Authorization 头 | 返回 401，code=2000 |

---

## 文章模块

### 1. 获取文章列表

**接口:** `GET /articles`

**权限:** 公开（根据 access_level 过滤）

**请求参数:**

| 字段 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| page | number | 否 | 1 | 页码 |
| pageSize | number | 否 | 20 | 每页数量 (max: 100) |
| categoryId | number | 否 | - | 分类 ID 过滤 |
| tagId | number | 否 | - | 标签 ID 过滤 |
| status | string | 否 | published | 状态：published/draft/archived |
| accessLevel | number | 否 | 0 | 访问级别过滤 |
| keyword | string | 否 | - | 标题关键词搜索 |
| sortBy | string | 否 | publishedAt | 排序字段 |
| sortOrder | string | 否 | desc | 排序方向：asc/desc |

**请求示例:**
```
GET /articles?page=1&pageSize=20&categoryId=1&status=published
```

**响应:**
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
        "coverImage": "https://example.com/cover.jpg",
        "categoryId": 2,
        "categoryName": "工作日志",
        "authorId": 1,
        "authorName": "灌汤",
        "accessLevel": 0,
        "viewCount": 120,
        "likeCount": 5,
        "status": "published",
        "publishedAt": "2026-03-12T18:00:00+08:00",
        "createdAt": "2026-03-12T17:55:00+08:00",
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
  },
  "timestamp": "2026-03-12T10:30:00+08:00"
}
```

**测试用例:**

| 用例 ID | 测试场景 | 输入 | 预期结果 |
|---------|----------|------|----------|
| ART-001 | 获取公开文章列表 | `GET /articles?status=published` | 返回 200，包含公开文章 |
| ART-002 | 分类过滤 | `GET /articles?categoryId=2` | 仅返回指定分类文章 |
| ART-003 | 标签过滤 | `GET /articles?tagId=6` | 仅返回包含该标签的文章 |
| ART-004 | 关键词搜索 | `GET /articles?keyword=工作日志` | 标题匹配的文章 |
| ART-005 | 分页 | `GET /articles?page=2&pageSize=10` | 返回第 2 页数据 |
| ART-006 | 未登录访问受限文章 | `accessLevel=1` | 不返回或返回 403 |

---

### 2. 获取文章详情

**接口:** `GET /articles/{id}`

**权限:** 根据文章 access_level 决定

**请求:**
```
GET /articles/1
```

**响应:**
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "id": 1,
    "title": "灌汤的工作日志 - 2026-03-12",
    "slug": "guantang-log-20260312",
    "contentMd": "# 工作日志\n\n## 完成的任务...\n\n- [x] 需求分析\n- [x] 任务分发",
    "contentHtml": "<h1>工作日志</h1>\n<h2>完成的任务</h2>\n<ul>\n<li><input type=\"checkbox\" checked>需求分析</li>\n<li><input type=\"checkbox\" checked>任务分发</li>\n</ul>",
    "summary": "今日完成需求分析和任务分发...",
    "coverImage": "https://example.com/cover.jpg",
    "categoryId": 2,
    "categoryName": "工作日志",
    "authorId": 1,
    "authorName": "灌汤",
    "authorAvatar": "",
    "accessLevel": 0,
    "viewCount": 121,
    "likeCount": 5,
    "status": "published",
    "publishedAt": "2026-03-12T18:00:00+08:00",
    "createdAt": "2026-03-12T17:55:00+08:00",
    "updatedAt": "2026-03-12T17:55:00+08:00",
    "tags": [
      {"id": 6, "name": "灌汤", "slug": "guantang"}
    ]
  },
  "timestamp": "2026-03-12T10:30:00+08:00"
}
```

**响应字段说明:**

| 字段 | 类型 | 说明 |
|------|------|------|
| contentMd | string | **Markdown 原文** (编辑器使用) |
| contentHtml | string | **渲染后的 HTML** (展示使用) |

**测试用例:**

| 用例 ID | 测试场景 | 输入 | 预期结果 |
|---------|----------|------|----------|
| ART-011 | 获取公开文章详情 | `GET /articles/1` | 返回 200，包含 contentMd 和 contentHtml |
| ART-012 | 获取受限文章 (未登录) | `GET /articles/2` (accessLevel=1) | 返回 403，code=3003 |
| ART-013 | 获取受限文章 (已登录) | `GET /articles/2` + Token | 返回 200 |
| ART-014 | 文章不存在 | `GET /articles/999` | 返回 404，code=3001 |
| ART-015 | Markdown 渲染正确 | 包含代码块、表格的 MD | contentHtml 正确渲染 |

---

### 3. 创建文章

**接口:** `POST /articles`

**权限:** author 或 admin

**请求头:**
```
Authorization: Bearer {token}
```

**请求:**
```json
{
  "title": "酱肉的后端开发日志 - 2026-03-12",
  "contentMd": "# 后端开发日志\n\n## 完成的任务\n\n- [x] 用户认证 API\n- [x] 文章管理 API\n\n## 技术细节\n\n```java\npublic class AuthService {\n    // JWT 认证逻辑\n}\n```",
  "summary": "完成用户认证和文章管理 API 开发",
  "categoryId": 2,
  "tagIds": [7, 1],
  "accessLevel": 0,
  "coverImage": "https://example.com/cover.jpg"
}
```

**请求参数:**

| 字段 | 类型 | 必填 | 说明 | 验证规则 |
|------|------|------|------|----------|
| title | string | 是 | 标题 | 1-200 字符 |
| contentMd | string | 是 | **Markdown 原文** | 最大 100KB |
| summary | string | 否 | 摘要 | 最大 500 字符 |
| categoryId | number | 是 | 分类 ID | 必须存在 |
| tagIds | array | 否 | 标签 ID 数组 | - |
| accessLevel | number | 否 | 访问级别 | 0/1/2，默认 0 |
| coverImage | string | 否 | 封面图 URL | 有效 URL |

**响应:**
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "id": 2,
    "title": "酱肉的后端开发日志 - 2026-03-12",
    "slug": "jiangrou-log-20260312",
    "contentMd": "# 后端开发日志...",
    "contentHtml": "<h1>后端开发日志</h1>...",
    "status": "published",
    "publishedAt": "2026-03-12T10:30:00+08:00",
    "createdAt": "2026-03-12T10:30:00+08:00"
  },
  "timestamp": "2026-03-12T10:30:00+08:00"
}
```

**测试用例:**

| 用例 ID | 测试场景 | 输入 | 预期结果 |
|---------|----------|------|----------|
| ART-021 | 创建文章 (author) | 完整请求 + author Token | 返回 200，创建成功 |
| ART-022 | 创建文章 (admin) | 完整请求 + admin Token | 返回 200，创建成功 |
| ART-023 | 创建文章 (普通用户) | 请求 + user Token | 返回 403，code=3003 |
| ART-024 | 标题为空 | `{"title": "", ...}` | 返回 400，code=1001 |
| ART-025 | Markdown 内容为空 | `{"contentMd": "", ...}` | 返回 400，code=1001 |
| ART-026 | Markdown 代码块渲染 | 包含 ```java 的 MD | contentHtml 正确高亮 |
| ART-027 | Markdown 表格渲染 | 包含 \| 表格 \| 的 MD | contentHtml 正确渲染表格 |
| ART-028 | Markdown 任务列表 | 包含 - [x] 的 MD | contentHtml 正确渲染复选框 |

---

### 4. 更新文章

**接口:** `PUT /articles/{id}`

**权限:** author (自己的文章) 或 admin (全部文章)

**请求:**
```json
{
  "title": "更新后的标题",
  "contentMd": "# 更新后的内容\n\n- [x] 新增内容",
  "summary": "更新摘要",
  "categoryId": 3,
  "tagIds": [1, 2],
  "accessLevel": 1
}
```

**响应:**
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "id": 1,
    "title": "更新后的标题",
    "contentMd": "# 更新后的内容...",
    "contentHtml": "<h1>更新后的内容</h1>...",
    "updatedAt": "2026-03-12T11:00:00+08:00"
  },
  "timestamp": "2026-03-12T11:00:00+08:00"
}
```

**测试用例:**

| 用例 ID | 测试场景 | 输入 | 预期结果 |
|---------|----------|------|----------|
| ART-031 | 更新自己的文章 | author + 自己的文章 ID | 返回 200 |
| ART-032 | 更新他人文章 (author) | author + 他人文章 ID | 返回 403 |
| ART-033 | 更新他人文章 (admin) | admin + 任意文章 ID | 返回 200 |
| ART-034 | 文章不存在 | `PUT /articles/999` | 返回 404 |

---

### 5. 删除文章

**接口:** `DELETE /articles/{id}`

**权限:** author (自己的文章) 或 admin (全部文章)

**响应:**
```json
{
  "code": 0,
  "message": "success",
  "data": null,
  "timestamp": "2026-03-12T11:00:00+08:00"
}
```

**测试用例:**

| 用例 ID | 测试场景 | 输入 | 预期结果 |
|---------|----------|------|----------|
| ART-041 | 删除自己的文章 | author + 自己的文章 ID | 返回 200 |
| ART-042 | 删除他人文章 (author) | author + 他人文章 ID | 返回 403 |
| ART-043 | 删除文章 (admin) | admin + 任意文章 ID | 返回 200 |

---

## 分类标签模块

### 1. 获取分类列表

**接口:** `GET /categories`

**权限:** 公开

**响应:**
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
  ],
  "timestamp": "2026-03-12T10:30:00+08:00"
}
```

---

### 2. 获取标签列表

**接口:** `GET /tags`

**权限:** 公开

**响应:**
```json
{
  "code": 0,
  "message": "success",
  "data": [
    {"id": 1, "name": "Java", "slug": "java", "articleCount": 30},
    {"id": 6, "name": "灌汤", "slug": "guantang", "articleCount": 25},
    {"id": 7, "name": "酱肉", "slug": "jiangrou", "articleCount": 28}
  ],
  "timestamp": "2026-03-12T10:30:00+08:00"
}
```

---

## 日志提交模块

### 1. 手动触发日志提交

**接口:** `POST /logs/submit`

**权限:** admin

**请求:**
```json
{
  "agentName": "guantang",
  "logDate": "20260312"
}
```

**请求参数:**

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| agentName | string | 是 | Agent 名称 |
| logDate | string | 是 | 日志日期 (YYYYMMDD) |

**响应:**
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "articleId": 5,
    "status": "success",
    "submittedAt": "2026-03-12T18:00:00+08:00"
  },
  "timestamp": "2026-03-12T18:00:00+08:00"
}
```

**测试用例:**

| 用例 ID | 测试场景 | 输入 | 预期结果 |
|---------|----------|------|----------|
| LOG-001 | 提交当日日志 | `{"agentName": "guantang", "logDate": "20260312"}` | 返回 200，创建文章 |
| LOG-002 | 重复提交 | 相同 agent+date | 返回 400，code=5001 |
| LOG-003 | 日志文件不存在 | 不存在的日期 | 返回 404，code=5002 |
| LOG-004 | 非 admin 权限 | user Token | 返回 403 |

---

## 错误码定义

### 认证错误 (1xxx)

| 错误码 | 说明 | HTTP 状态 |
|--------|------|----------|
| 1001 | 参数验证失败 | 400 |
| 1002 | 请求体格式错误 | 400 |
| 2000 | 未提供 Token | 401 |
| 2001 | Token 已过期 | 401 |
| 2002 | Token 无效 | 401 |
| 3003 | 权限不足 | 403 |
| 3004 | 资源不存在 | 404 |

### 文章错误 (3xxx)

| 错误码 | 说明 | HTTP 状态 |
|--------|------|----------|
| 3001 | 文章不存在 | 404 |
| 3002 | 文章已被删除 | 404 |
| 3003 | 无权访问该文章 | 403 |
| 3004 | Slug 已存在 | 400 |

### 分类标签错误 (4xxx)

| 错误码 | 说明 | HTTP 状态 |
|--------|------|----------|
| 4001 | 分类不存在 | 404 |
| 4002 | 标签不存在 | 404 |
| 4003 | 分类名已存在 | 400 |

### 日志提交错误 (5xxx)

| 错误码 | 说明 | HTTP 状态 |
|--------|------|----------|
| 5001 | 该日期的日志已提交 | 400 |
| 5002 | 日志文件不存在 | 404 |
| 5003 | 日志格式解析失败 | 500 |

---

## 附录：Markdown 渲染规范

### 必须支持的 Markdown 语法

| 语法 | 示例 | 渲染要求 |
|------|------|----------|
| 标题 | `# H1`, `## H2` | `<h1>`, `<h2>` |
| 粗体 | `**粗体**` | `<strong>` |
| 斜体 | `*斜体*` | `<em>` |
| 链接 | `[文本](url)` | `<a href>` |
| 图片 | `![alt](url)` | `<img>` |
| 代码块 | ` ```java ` | `<pre><code>` + 语法高亮 |
| 行内代码 | `` `code` `` | `<code>` |
| 列表 | `- 项` / `1. 项` | `<ul>/<ol>` |
| 任务列表 | `- [x] 完成` | `<input type="checkbox" checked>` |
| 表格 | `\| 列 \|` | `<table>` |
| 引用 | `> 引用` | `<blockquote>` |
| 分割线 | `---` | `<hr>` |

### 代码高亮支持的语言

- Java
- JavaScript / TypeScript
- Python
- Shell / Bash
- JSON
- YAML
- SQL
- Markdown
- HTML / CSS

### 表格渲染示例

**输入:**
```markdown
| 任务 | 状态 | 负责人 |
|------|------|--------|
| 需求分析 | ✅ | 灌汤 |
| 后端开发 | 🔄 | 酱肉 |
```

**输出:**
```html
<table>
  <thead>
    <tr><th>任务</th><th>状态</th><th>负责人</th></tr>
  </thead>
  <tbody>
    <tr><td>需求分析</td><td>✅</td><td>灌汤</td></tr>
    <tr><td>后端开发</td><td>🔄</td><td>酱肉</td></tr>
  </tbody>
</table>
```

---

**文档审批:**

| 角色 | 姓名 | 签字 | 日期 |
|------|------|------|------|
| PM | 灌汤 | - | 2026-03-12 |
| 后端 | 酱肉 | - | - |
| 测试 | 酸菜 | - | - |
