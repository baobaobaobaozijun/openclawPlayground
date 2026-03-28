<!-- Last Modified: 2026-03-28 00:10 -->

# 博客系统前端整合改造 — 详细执行计划

**文档状态:** 已批准  
**创建日期:** 2026-03-28 00:10  
**负责人:** 灌汤 (PM)  
**版本:** 1.0

---

## 📋 目录

1. [改造背景](#改造背景)
2. [代码盘点汇总](#代码盘点汇总)
3. [功能需求清单](#功能需求清单)
4. [执行计划](#执行计划)
5. [依赖关系](#依赖关系)
6. [风险与缓解](#风险与缓解)

---

## 改造背景

### 当前问题

| 问题 | 表现 | 影响 |
|------|------|------|
| 无统一布局 | NavBar/Footer 文件缺失 | 用户无法导航 |
| VIP 权限缺失 | 后端 users 表无 access_level 字段 | 无法区分 VIP 用户 |
| 评论功能无后端 | Comment 模块缺失 | 评论无法使用 |
| 路由混乱 | 无/login /register 路由，无路由守卫 | 用户体验割裂 |

### 改造目标

1. **统一布局** — 创建 NavBar + Footer，所有页面使用 MainLayout
2. **VIP 权限** — 后端添加 access_level 字段，前端展示锁图标和权限检查
3. **评论功能** — 完整 Comment 模块（后端 CRUD + 前端集成）
4. **路由规范** — 添加认证路由和路由守卫

---

## 代码盘点汇总

### 后端盘点（酱肉）

#### ✅ 已实现功能

| 模块 | 文件/接口 | 状态 | 说明 |
|------|---------|------|------|
| 用户管理 | User.java, UserService | ✅ | 实体类存在 |
| 文章管理 | Article.java, ArticleService | ✅ | 实体类存在 |
| 文章权限 | articles.access_level | ✅ | 数据库字段存在 |
| 认证接口 | POST /api/auth/login | ✅ | 登录接口存在 |
| 认证接口 | GET /api/auth/me | ✅ | 获取用户信息接口存在 |
| 认证接口 | POST /api/auth/refresh | ✅ | Token 刷新接口存在 |
| 文章接口 | GET /api/articles | ✅ | 文章列表接口存在 |
| 文章接口 | GET /api/articles/{id} | ✅ | 文章详情接口存在 |

#### ⚠️ 需要改造功能

| 模块 | 改造内容 | 说明 | 预计工作量 |
|------|---------|------|-----------|
| 数据库 | users 表添加 access_level 字段 | TINYINT DEFAULT 0 | 20min |
| User.java | 添加 accessLevel 字段 | Integer 类型 | 10min |
| UserDTO.java | 添加 accessLevel 字段 | Integer 类型 | 10min |
| ArticleController | getArticleById 权限检查 | 401/403 处理 | 30min |

#### ❌ 缺失功能

| 模块 | 需要新建 | 说明 | 预计工作量 |
|------|---------|------|-----------|
| 评论系统 | Comment.java | 实体类 | 20min |
| 评论系统 | CommentMapper.java | Mapper 接口 | 20min |
| 评论系统 | CommentService.java | 服务层 | 30min |
| 评论系统 | CommentServiceImpl.java | 服务实现 | 30min |
| 评论系统 | CommentController.java | Controller | 30min |
| 评论系统 | comments 表 | 数据库建表 | 20min |

---

### 前端盘点（PM 代豆沙）

#### ✅ 已实现功能

| 模块 | 组件/文件 | 状态 | 说明 |
|------|---------|------|------|
| 布局 | MainLayout.vue | ✅ | 存在，引用 NavBar/Footer |
| 文章 | ArticlesView.vue | ✅ | 文章列表页面 |
| 文章 | ArticleCard.vue | ✅ | 卡片组件 |
| 文章 | ArticleDetail.vue | ✅ | 详情页，已集成 CommentList |
| 用户 | LoginView.vue | ✅ | 登录页面存在 |
| 用户 | RegisterView.vue | ✅ | 注册页面存在 |
| 用户 | UserCenter.vue | ✅ | 用户中心存在 |
| 评论 | CommentList.vue | ✅ | 评论列表组件 |
| 评论 | CommentForm.vue | ✅ | 评论表单组件 |

#### ⚠️ 需要改造功能

| 模块 | 组件/文件 | 改造内容 | 预计工作量 |
|------|---------|---------|-----------|
| 布局 | NavBar.vue | 创建组件 + 登录状态判断 | 40min |
| 布局 | Footer.vue | 创建组件 | 20min |
| 路由 | router/index.ts | 添加 /login /register 路由 | 20min |
| 路由 | router/index.ts | 添加路由守卫 (requiresAuth) | 30min |
| 文章 | ArticleCard.vue | 增加 VIP 锁图标 | 20min |
| 文章 | ArticleDetail.vue | 增加 401/403 权限检查 | 30min |
| 类型 | types/ | 创建 article.ts/user.ts/comment.ts | 30min |

#### ❌ 缺失功能

| 模块 | 组件/文件 | 需要新建 | 预计工作量 |
|------|---------|---------|-----------|
| 类型定义 | types/article.ts | Article 类型定义 | 15min |
| 类型定义 | types/user.ts | User 类型定义 | 15min |
| 类型定义 | types/comment.ts | Comment 类型定义 | 15min |

---

### 测试盘点（酸菜）

#### ✅ 已准备

| 项目 | 状态 | 说明 |
|------|------|------|
| 测试数据库 | ✅ | MySQL 正常运行 |
| 测试服务器 | ✅ | 8.137.175.240 可访问 |
| Docker 服务 | ✅ | Docker 已安装可用 |
| 自动化测试框架 | ✅ | JUnit 5 可用 |

#### ⚠️ 需要补充

| 项目 | 需要内容 | 预计工作量 |
|------|---------|-----------|
| 测试账号 | VIP 用户账号 + 管理员账号 | 15min |
| 测试数据 | 测试文章/用户/评论数据初始化脚本 | 30min |

#### ❌ 缺失

| 项目 | 需要新建 | 预计工作量 |
|------|---------|-----------|
| API 测试 | Postman 测试集合 | 1h |
| E2E 测试 | E2E 测试脚本 | 2h |
| API 测试 | e2e-test.ps1 脚本 | 30min |

---

## 功能需求清单

### 1. 后端功能需求

#### 1.1 用户模块改造

**需求：** users 表添加 access_level 字段，User.java 和 UserDTO.java 同步更新

**接口变更：**
- GET /api/auth/me → 返回 accessLevel 字段
- POST /api/auth/login → 返回 accessLevel 字段

**数据库变更：**
```sql
ALTER TABLE users ADD COLUMN access_level TINYINT DEFAULT 0 COMMENT '访问级别：0-普通 1-VIP 2-管理员';
```

---

#### 1.2 文章模块改造

**需求：** ArticleController 增加权限检查逻辑

**接口变更：**
- GET /api/articles/{id} → 增加权限检查（401/403）

**权限检查逻辑：**
```
if (article.accessLevel > 0) {
    if (token == null) → 返回 401 "请先登录"
    if (user.accessLevel < article.accessLevel) → 返回 403 "需要 VIP 权限"
}
```

---

#### 1.3 评论模块新建

**需求：** 完整 Comment 模块（Entity/Mapper/Service/Controller）

**数据库建表：**
```sql
CREATE TABLE comments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '评论 ID',
    article_id BIGINT NOT NULL COMMENT '文章 ID',
    user_id BIGINT NOT NULL COMMENT '用户 ID',
    content TEXT NOT NULL COMMENT '评论内容',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    deleted TINYINT DEFAULT 0 COMMENT '删除标志',
    INDEX idx_article (article_id),
    INDEX idx_user (user_id),
    CONSTRAINT fk_comments_article FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    CONSTRAINT fk_comments_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论表';
```

**接口定义：**
- GET /api/comments?articleId={id}&page=1&size=20 → 获取评论列表
- POST /api/comments → 发表评论（需要登录）
- DELETE /api/comments/{id} → 删除评论（作者或管理员）

---

### 2. 前端功能需求

#### 2.1 布局组件

**NavBar.vue 需求：**
- 显示 Logo + 导航菜单（首页/分类/标签）
- 未登录：显示 [登录] [注册] 按钮
- 已登录：显示用户头像 + 下拉菜单（个人中心/退出登录）
- 从 localStorage 读取 token，调用 /api/auth/me 获取用户信息

**Footer.vue 需求：**
- 显示版权信息
- 显示友情链接（可选）

---

#### 2.2 路由配置

**添加路由：**
```typescript
{ path: '/login', name: 'Login', component: LoginView },
{ path: '/register', name: 'Register', component: RegisterView },
```

**路由守卫：**
```typescript
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token');
  const requiresAuth = to.meta.requiresAuth as boolean;
  
  if (requiresAuth && !token) {
    next({ path: '/login', query: { redirect: to.fullPath } });
  } else {
    next();
  }
});
```

---

#### 2.3 VIP 权限集成

**ArticleCard.vue 改造：**
- 如果 article.accessLevel > 0，显示锁图标
- 使用 Element Plus 的 `<el-icon><Lock /></el-icon>`

**ArticleDetail.vue 改造：**
- 调用 API 时处理 401/403 响应
- 401 → 显示"请先登录" + 跳转登录按钮
- 403 → 显示"需要 VIP 权限" + 升级提示

---

#### 2.4 TypeScript 类型定义

**types/article.ts:**
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
```

**types/user.ts:**
```typescript
export interface User {
  id: number;
  username: string;
  email: string;
  avatar?: string;
  accessLevel: number;  // 0-普通 1-VIP 2-管理员
}
```

**types/comment.ts:**
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
```

---

### 3. 测试功能需求

#### 3.1 测试账号准备

**需要创建：**
- 普通用户账号（accessLevel=0）
- VIP 用户账号（accessLevel=1）
- 管理员账号（accessLevel=2）

---

#### 3.2 测试数据准备

**需要创建：**
- 公开文章（accessLevel=0）
- 登录可见文章（accessLevel=1）
- VIP 文章（accessLevel=2）
- 测试评论数据

---

#### 3.3 API 测试用例

**认证模块：**
| 用例 ID | 接口 | 测试场景 | 预期结果 |
|--------|------|---------|---------|
| AUTH-001 | POST /api/auth/login | 正确用户名密码 | 200 + token + accessLevel |
| AUTH-002 | POST /api/auth/login | 错误密码 | 401 |
| AUTH-003 | GET /api/auth/me | 有效 token | 200 + 用户信息 + accessLevel |
| AUTH-004 | GET /api/auth/me | 过期 token | 401 |
| AUTH-005 | GET /api/auth/me | 无 token | 401 |

**文章模块：**
| 用例 ID | 接口 | 测试场景 | 预期结果 |
|--------|------|---------|---------|
| ART-001 | GET /api/articles | 公开文章列表 | 200 + 文章列表 |
| ART-002 | GET /api/articles/{id} | 公开文章详情 | 200 + 文章详情 |
| ART-003 | GET /api/articles/{id} | VIP 文章详情（无 token） | 401 |
| ART-004 | GET /api/articles/{id} | VIP 文章详情（普通用户 token） | 403 |
| ART-005 | GET /api/articles/{id} | VIP 文章详情（VIP 用户 token） | 200 + 文章详情 |

**评论模块：**
| 用例 ID | 接口 | 测试场景 | 预期结果 |
|--------|------|---------|---------|
| CMT-001 | GET /api/comments?articleId=1 | 获取评论列表 | 200 + 评论列表 |
| CMT-002 | POST /api/comments | 无 token 发表评论 | 401 |
| CMT-003 | POST /api/comments | 有效 token + 空内容 | 400 |
| CMT-004 | POST /api/comments | 有效 token + 正常内容 | 200 + 评论对象 |
| CMT-005 | DELETE /api/comments/{id} | 删除自己的评论 | 200 |
| CMT-006 | DELETE /api/comments/{id} | 删除他人的评论 | 403 |

---

#### 3.4 E2E 测试用例

| 用例 ID | 场景 | 步骤 | 预期结果 |
|--------|------|------|---------|
| E2E-001 | 访客浏览公开文章 | 1. 打开首页 2. 点击文章 3. 查看内容 | 1. 文章列表显示正常 2. 文章详情打开 3. 内容可见 |
| E2E-002 | 用户登录 | 1. 点击登录 2. 输入用户名密码 3. 提交 | 1. 登录页打开 2. 登录成功 3. NavBar 显示用户信息 |
| E2E-003 | VIP 文章访问 | 1. 访客点击 VIP 文章 2. 登录后再次访问 | 1. 提示"请先登录" 2. 登录后可查看 |
| E2E-004 | 发表评论 | 1. 打开文章详情 2. 输入评论内容 3. 提交 | 1. 评论表单显示 2. 评论成功 3. 评论列表更新 |

---

## 执行计划

### Plan-011: 后端改造（酱肉负责）

**总工期:** 3.5 小时

| 轮次 | 任务 | 交付物 | 验收标准 | 预计时间 | 依赖 |
|------|------|--------|---------|---------|------|
| R1 | users 表添加 access_level | SQL 脚本 + 执行完成 | users 表有 access_level 字段 | 20min | 无 |
| R2 | User.java + UserDTO.java | 添加 accessLevel 字段 | 字段可正常读写 | 20min | R1 |
| R3 | Comment 模块开发 | Entity/Mapper/Service/Controller | CRUD 接口全部可用 | 2h | 无 |
| R4 | comments 表创建 | SQL 脚本 + 执行 | comments 表创建成功 | 20min | 无 |
| R5 | ArticleController 权限检查 | 修改 getArticleById 方法 | 公开/登录/VIP 文章权限检查正确 | 30min | R2 |
| R6 | 单元测试 + 自测 | 测试用例 + 测试报告 | 核心功能测试覆盖率≥80% | 30min | R3+R5 |

**关键路径：** R1 → R2 → R5（权限检查依赖 UserDTO 返回 accessLevel）

---

### Plan-012: 前端整合（豆沙负责）

**前置条件:** Plan-011 R2 完成（UserDTO 返回 accessLevel）

**总工期:** 2.5 小时

| 轮次 | 任务 | 交付物 | 验收标准 | 预计时间 | 依赖 |
|------|------|--------|---------|---------|------|
| R1 | NavBar.vue + Footer.vue | 创建布局组件 | NavBar 显示登录状态 | 60min | 无 |
| R2 | 路由配置 | 添加 /login /register + 路由守卫 | 路由可访问，守卫正常工作 | 50min | R1 |
| R3 | VIP 权限集成 | ArticleCard 锁图标 + ArticleDetail 权限检查 | VIP 文章显示锁图标，无权限时正确提示 | 50min | Plan-011 R5 |
| R4 | TypeScript 类型定义 | types/article.ts/user.ts/comment.ts | 类型定义完整 | 30min | 无 |

**关键路径：** R1 → R2（布局完成后配置路由）

---

### Plan-013: 联调测试（酸菜负责）

**前置条件:** Plan-011 + Plan-012 完成

**总工期:** 3.5 小时

| 轮次 | 任务 | 交付物 | 验收标准 | 预计时间 | 依赖 |
|------|------|--------|---------|---------|------|
| R1 | 测试账号 + 数据准备 | VIP/管理员账号 + 测试数据脚本 | 测试账号可用，测试数据完整 | 45min | Plan-011 R4 |
| R2 | API 测试 | Postman 测试集合 | 所有接口测试通过 | 1h | Plan-011 R6 |
| R3 | E2E 测试 | E2E 测试脚本 | 完整用户旅程测试通过 | 2h | Plan-012 R3 |

**关键路径：** R1 → R2 → R3（测试数据准备完成后才能执行 API/E2E 测试）

---

## 依赖关系

### 前后端依赖

```
Plan-011 R1 (users 表 access_level)
    ↓
Plan-011 R2 (User.java/UserDTO.java accessLevel)
    ↓
Plan-012 R3 (前端 VIP 权限集成)
    ↓
Plan-013 R3 (E2E 测试)
```

```
Plan-011 R3+R4 (Comment 模块 + comments 表)
    ↓
Plan-012 R3 (前端评论功能集成)
    ↓
Plan-013 R3 (E2E 测试 - 发表评论)
```

### 并行任务

**可并行执行：**
- Plan-011 R1/R3/R4（数据库修改和 Comment 模块可并行）
- Plan-012 R1/R4（布局组件和类型定义可并行）
- Plan-011 R6（后端单元测试）和 Plan-012（前端整合）可并行

---

## 风险与缓解

| 风险 | 影响 | 概率 | 缓解措施 |
|------|------|------|---------|
| 数据库修改影响现有数据 | 高 | 低 | 先备份，测试环境验证 |
| 后端接口延期 | 高 | 中 | 前后端并行，前端用 Mock 数据 |
| VIP 权限逻辑错误 | 高 | 中 | 详细测试用例，酸菜提前介入 |
| 评论功能性能问题 | 中 | 低 | 分页加载，限制每页数量 |
| NavBar 组件引用错误 | 中 | 低 | MainLayout 已引用，创建时注意路径 |
| 路由守卫死循环 | 中 | 中 | 排除 /login /register 路由 |

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
- [ ] NavBar 显示登录状态（未登录/已登录不同 UI）
- [ ] VIP 文章显示锁图标
- [ ] 无权限时显示"登录查看"或"需要 VIP 权限"
- [ ] 评论区正常显示和发表
- [ ] 路由守卫正常工作（未登录跳转 /login）
- [ ] TypeScript 类型定义完整

---

### 测试验收

- [ ] API 测试全部通过（AUTH-001~005, ART-001~005, CMT-001~006）
- [ ] VIP 权限测试全部通过
- [ ] E2E 测试全部通过（E2E-001~004）
- [ ] 无严重 Bug

---

## 时间规划

**总工期:** 9.5 小时

**关键路径：**
```
Plan-011 (3.5h) → Plan-012 R3 (50min) → Plan-013 R3 (2h) = 6h
```

**建议执行顺序：**
1. Plan-011 R1-R2（后端用户模块改造）
2. Plan-012 R1-R2（前端布局 + 路由）
3. Plan-011 R3-R5（后端 Comment 模块 + 权限检查）
4. Plan-012 R3-R4（前端 VIP 集成 + 类型定义）
5. Plan-011 R6（后端单元测试）
6. Plan-013 R1-R3（测试准备 + API 测试 + E2E 测试）

---

*文档版本：v1.0 | 创建者：灌汤 PM | 2026-03-28 00:10*
