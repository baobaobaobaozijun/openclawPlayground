<!-- Last Modified: 2026-03-27 23:15 -->

# 前端整合设计文档 v1.0

**文档状态:** 草稿  
**创建日期:** 2026-03-27 23:15  
**负责人:** 灌汤 (PM)  
**版本:** 1.0

---

## 📋 目录

1. [现状分析](#现状分析)
2. [文档矛盾点](#文档矛盾点)
3. [功能定位](#功能定位)
4. [架构设计](#架构设计)
5. [后端改造需求](#后端改造需求)
6. [前端改造需求](#前端改造需求)
7. [执行计划](#执行计划)

---

## 现状分析

### 现有前端页面

| 页面 | 路由 | 组件 | 状态 |
|------|------|------|------|
| 首页 | `/` | ArticlesView | ✅ 卡片布局 |
| 文章详情 | `/article/:id` | ArticleDetail | ✅ 已集成评论区 |
| 分类 | `/categories` | CategoryView | ⚠️ 独立页面 |
| 标签 | `/tags` | TagManagement | ⚠️ 独立页面 |
| 登录 | ❌ 缺失 | LoginView | ❌ 路由未配置 |
| 注册 | ❌ 缺失 | RegisterView | ❌ 路由未配置 |
| 用户中心 | `/user-center` | UserCenter | ⚠️ 功能不完整 |
| Agent 状态 | `/admin/agents` | AgentStatusView | ⚠️ 路径混乱 |

### 现有后端接口

| 模块 | 接口 | 状态 |
|------|------|------|
| 认证 | POST /auth/login, POST /auth/register, GET /auth/me, POST /auth/refresh | ✅ 完整 |
| 文章 | GET /articles/, GET /articles/{id}, POST/PUT/DELETE | ✅ 完整 |
| 分类 | GET /categories | ✅ 有 |
| 标签 | GET /tags | ✅ 有 |
| Agent 状态 | GET /admin/agents | ✅ 有 |
| 评论 | ❌ 无 | ❌ 缺失 |
| VIP 权限 | ❌ 无 is_vip 字段 | ❌ 缺失 |

---

## 文档矛盾点

### 矛盾 1：登录方式不一致

| 文档 | 描述 | 实际实现 |
|------|------|---------|
| blog-system-requirements.md | 手机号登录，无需验证码 | ✅ 已实现 username/password 登录 |
| auth-api-spec.md | 用户名 + 密码登录 | ✅ 实际代码 |
| database-design.md | users 表有 phone 字段 | ⚠️ 但登录用 username |

**结论：** 需求文档写手机号登录，实际实现是用户名/密码登录。**保持现状**，不修改。

---

### 矛盾 2：VIP 权限定义不一致

| 文档 | 描述 | 实际实现 |
|------|------|---------|
| blog-system-requirements.md | access_level: 0-普通 1-VIP 2-管理员 | ⚠️ User 实体有 access_level |
| database-design.md | users.access_level TINYINT | ✅ 数据库有字段 |
| 实际代码 | UserDTO 无 access_level/is_vip 字段 | ❌ 后端未返回 |

**结论：** 数据库有 access_level 字段，但后端 DTO 未返回，前端无法判断 VIP 状态。**需要后端修复**。

---

### 矛盾 3：文章 VIP 权限缺失

| 文档 | 描述 | 实际实现 |
|------|------|---------|
| blog-system-requirements.md | articles.access_level: 0-公开 1-登录 2-VIP | ❌ 实际代码无此字段 |
| database-design.md | articles.access_level TINYINT | ❌ 数据库无此字段 |

**结论：** 需求和数据库设计都写了 access_level，但实际数据库和实体类都**没有这个字段**。**需要后端添加**。

---

### 矛盾 4：评论系统状态

| 文档 | 描述 | 实际实现 |
|------|------|---------|
| blog-system-requirements.md (2026-03-10) | 不包含评论系统 (阶段 2) | ✅ 当时正确 |
| 前端代码 (2026-03-27) | CommentList.vue 已集成 | ✅ 豆沙已实现 |
| 后端代码 | 无 Comment 实体/Controller | ❌ 缺失 |

**结论：** 前端评论组件已实现，但后端无接口。**需要后端补充**。

---

### 矛盾 5：路由设计混乱

| 文档 | 描述 | 实际实现 |
|------|------|---------|
| router-design.md (不存在) | 无文档 | ❌ 无设计文档 |
| 实际代码 | /admin/agents 有前缀，/user-center 没有 | ⚠️ 不一致 |

**结论：** 无路由设计文档，路径命名不一致。**需要统一规范**。

---

### 矛盾 6：Agent 状态模块定位

| 文档 | 描述 | 实际实现 |
|------|------|---------|
| blog-system-requirements.md | Agent 状态展示 (P1 需求) | ✅ 有需求 |
| 系统架构.md | Agent 状态是内部工具 | ⚠️ 开发调试用 |
| 实际前端 | /admin/agents 隐藏路径 | ✅ 实际未公开 |

**结论：** Agent 状态是开发调试工具，不是博客功能。**建议移除或隐藏**。

---

## 功能定位

### 个人博客核心功能

```
博客系统 = 文章展示 (核心) + 用户权限 (VIP) + 评论互动 (可选)
```

**核心用户旅程：**
```
访客 → 浏览公开文章 → (可选) 登录 → 查看 VIP 文章 → (可选) 评论
作者 → 登录 → 写文章 → 管理评论 → 查看数据
```

### 功能优先级

| 优先级 | 模块 | 功能 | 必要性 |
|--------|------|------|--------|
| P0 | 文章模块 | 列表/详情/分类/标签 | ⭐⭐⭐ 核心 |
| P0 | 用户模块 | 登录/注册/VIP 权限 | ⭐⭐⭐ 核心 |
| P1 | 评论模块 | 发表评论/评论列表 | ⭐⭐ 重要 |
| P2 | 个人中心 | VIP 状态/我的评论 | ⭐ 基础 |
| ❌ | Agent 状态 | Agent 工作展示 | 砍掉 (内部工具) |
| ❌ | 计划管理 | 计划创建/列表 | 砍掉 (作者后台) |

---

## 架构设计

### 前端架构

```
src/
├── layouts/
│   └── MainLayout.vue       # 统一布局
├── components/
│   ├── NavBar.vue           # 导航栏 (含登录状态)
│   ├── Footer.vue           # 页脚
│   ├── ArticleCard.vue      # 文章卡片
│   ├── CommentList.vue      # 评论列表
│   └── CommentForm.vue      # 评论表单
├── views/
│   ├── ArticlesView.vue     # 首页 (文章列表)
│   ├── ArticleDetail.vue    # 文章详情
│   ├── CategoryView.vue     # 分类浏览
│   ├── TagView.vue          # 标签浏览
│   ├── LoginView.vue        # 登录页
│   ├── RegisterView.vue     # 注册页
│   └── UserCenter.vue       # 用户中心
└── router/
    └── index.ts             # 路由配置
```

### 路由设计

```typescript
const routes = [
  // 公开页面
  { path: '/', name: 'Home', component: ArticlesView },
  { path: '/article/:id', name: 'ArticleDetail', component: ArticleDetail },
  { path: '/categories', name: 'Categories', component: CategoryView },
  { path: '/tags', name: 'Tags', component: TagView },
  
  // 用户认证
  { path: '/login', name: 'Login', component: LoginView },
  { path: '/register', name: 'Register', component: RegisterView },
  
  // 需要登录
  { path: '/user-center', name: 'UserCenter', component: UserCenter, meta: { requiresAuth: true } },
]
```

---

## 后端改造需求

### 1. User 实体/DTO 增加 VIP 字段

```java
// User.java
private Integer accessLevel;  // 0-普通 1-VIP 2-管理员

// UserDTO.java
private Integer accessLevel;  // 新增字段
```

**API 影响：**
- GET /auth/me → 返回 accessLevel
- POST /auth/login → 返回 accessLevel

---

### 2. Article 实体增加 VIP 字段

```java
// Article.java
private Integer accessLevel;  // 0-公开 1-登录 2-VIP

// ArticleResponseDTO.java
private Integer accessLevel;  // 新增字段
```

**API 影响：**
- GET /articles/ → 返回 accessLevel
- GET /articles/{id} → 返回 accessLevel

---

### 3. 文章详情接口增加权限检查

```java
// ArticleController.java
@GetMapping("/{id}")
public ArticleResponseDTO getArticleById(
    @PathVariable Long id,
    @RequestHeader(value = "Authorization", required = false) String token) {
    
    Article article = articleService.getById(id);
    
    // 检查权限
    if (article.getAccessLevel() > 0) {
        if (token == null) {
            throw new AuthException("请先登录");
        }
        Long userId = jwtUtil.getUserIdFromToken(token);
        User user = userService.getById(userId);
        if (user.getAccessLevel() < article.getAccessLevel()) {
            throw new AuthException("需要 VIP 权限");
        }
    }
    
    return articleService.convertToDTO(article);
}
```

---

### 4. 新增 Comment 模块

```java
// Comment.java
@Entity
public class Comment {
    @Id
    private Long id;
    private Long articleId;
    private Long userId;
    private String content;
    private LocalDateTime createdAt;
    private Integer deleted;
}

// CommentController.java
@RestController
@RequestMapping("/comments")
public class CommentController {
    
    @GetMapping("/")
    public List<Comment> getComments(@RequestParam Long articleId) {
        return commentService.getByArticleId(articleId);
    }
    
    @PostMapping("/")
    public Comment createComment(
        @RequestBody CommentCreateDTO dto,
        @RequestHeader("Authorization") String token) {
        Long userId = jwtUtil.getUserIdFromToken(token);
        return commentService.create(dto, userId);
    }
    
    @DeleteMapping("/{id}")
    public void deleteComment(
        @PathVariable Long id,
        @RequestHeader("Authorization") String token) {
        commentService.delete(id, userId);
    }
}
```

---

### 5. 数据库修改

```sql
-- 1. articles 表添加 access_level
ALTER TABLE articles ADD COLUMN access_level TINYINT DEFAULT 0 COMMENT '访问级别：0-公开 1-登录 2-VIP';

-- 2. 创建 comments 表
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

---

## 前端改造需求

### 阶段 1：统一布局（30 分钟）

| 任务 | 交付物 | 说明 |
|------|--------|------|
| 创建 MainLayout | `src/layouts/MainLayout.vue` | NavBar + router-view + Footer |
| 创建 NavBar | `src/components/NavBar.vue` | Logo + 导航 + 登录状态 |
| 创建 Footer | `src/components/Footer.vue` | 版权信息 |
| 更新路由 | `src/router/index.ts` | 添加 Layout 包裹 + login/register 路由 |

---

### 阶段 2：VIP 权限集成（40 分钟）

| 任务 | 交付物 | 说明 |
|------|--------|------|
| ArticleCard 显示 VIP 标识 | 锁图标 | access_level > 0 时显示 |
| ArticleDetail 权限检查 | 无权限提示 | 403 时显示"登录查看" |
| UserCenter 显示 VIP 状态 | accessLevel 字段 | 从 /auth/me 获取 |
| 路由守卫 | requiresAuth 检查 | 未登录跳转 /login |

---

### 阶段 3：评论功能（40 分钟）

| 任务 | 交付物 | 说明 |
|------|--------|------|
| CommentList 组件 | 评论列表 | 调用 GET /api/comments?articleId={id} |
| CommentForm 组件 | 评论表单 | POST /api/comments，登录后可用 |
| ArticleDetail 集成 | 评论区 | 文章下方显示 |

---

## 执行计划

### Plan-011: 后端改造

| 轮次 | 任务 | 负责人 | 预计时间 |
|------|------|--------|---------|
| R1 | User/Article 实体增加 accessLevel 字段 | 酱肉 | 30min |
| R2 | ArticleController 增加权限检查逻辑 | 酱肉 | 30min |
| R3 | Comment 模块 (Entity/Mapper/Service/Controller) | 酱肉 | 60min |
| R4 | 数据库修改 SQL 脚本 + 执行 | 酱肉 | 20min |

---

### Plan-012: 前端整合

| 轮次 | 任务 | 负责人 | 预计时间 |
|------|------|--------|---------|
| R1 | MainLayout + NavBar + Footer + 路由配置 | 豆沙 | 40min |
| R2 | VIP 权限集成（锁图标/权限检查/路由守卫） | 豆沙 | 40min |
| R3 | 评论功能（CommentList + CommentForm + 集成） | 豆沙 | 40min |

---

### Plan-013: 联调测试

| 轮次 | 任务 | 负责人 | 预计时间 |
|------|------|--------|---------|
| R1 | VIP 权限测试（公开/登录/VIP 文章） | 酸菜 | 30min |
| R2 | 评论功能测试（发表/删除） | 酸菜 | 30min |
| R3 | 端到端测试（用户旅程） | 酸菜 | 30min |

---

## 风险与决策

### 风险 1：后端改造影响现有功能

**缓解：** 
- accessLevel 字段默认值为 0（公开）
- 现有文章不受影响
- 灰度发布，先测试环境验证

---

### 风险 2：评论模块复杂度

**决策：**
- 只做单层评论，无嵌套回复
- 无举报功能（作者后台删除）
- 无点赞功能（阶段 2）

---

### 风险 3：Docker 部署问题

**状态：** Plan-008 R5 部署中，Docker 服务已修复

**决策：** 后端改造完成后重新部署

---

## 验收标准

### 后端验收

- [ ] UserDTO 返回 accessLevel 字段
- [ ] ArticleResponseDTO 返回 accessLevel 字段
- [ ] GET /articles/{id} 权限检查正常
- [ ] Comment 模块 CRUD 接口正常
- [ ] 数据库 access_level/comments 表创建完成

---

### 前端验收

- [ ] MainLayout 应用到所有页面
- [ ] NavBar 显示登录状态
- [ ] VIP 文章显示锁图标
- [ ] 无权限时显示"登录查看"
- [ ] 评论区正常显示和发表

---

*文档版本：v1.0 | 创建者：灌汤 PM | 2026-03-27 23:15*
