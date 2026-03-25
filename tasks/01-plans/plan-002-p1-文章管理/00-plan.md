<!-- Last Modified: 2026-03-25 23:25 -->

# Plan-02: 文章管理模块

**计划状态:** ⏳ 待执行  
**创建日期:** 2026-03-25 23:25  
**负责人:** 灌汤 (PM)  
**执行周期:** 2026-03-26 01:30 ~ 2026-03-26 03:30（2 小时）  
**总轮次:** 5 轮

---

## 📋 计划目标

实现文章管理核心功能，支持文章 CRUD 操作，使系统具备基本内容管理能力。

### 覆盖的差异问题
| 编号 | 问题 | 类别 | 优先级 |
|------|------|------|--------|
| 🔴 #5 | 后端 Controller 缺失（Article） | 实现偏离 | P0 |
| 🟢 #3 | 功能缺失（文章管理 CRUD） | 功能缺失 | P1 |

---

## 🎯 成功标准

- [ ] `articles` 表在 MySQL 中创建成功
- [ ] ArticleController 可正常编译
- [ ] 文章列表 API 可调用（GET /api/articles）
- [ ] 文章详情 API 可调用（GET /api/articles/{id}）
- [ ] 创建文章 API 可调用（POST /api/articles）
- [ ] 前端文章列表页可访问
- [ ] 前端文章详情页可访问
- [ ] 所有代码编译通过（mvn compile + npm run build）

---

## 📅 轮次安排

### 第 1 轮：数据库建表（articles）

**负责人:** 酱肉 🍖  
**预计耗时:** 15 分钟  
**触发条件:** Plan-01 完成

**任务:**
1. 创建 `articles` 表（按 database-design.md）
2. 验证表结构正确
3. 记录工作日志

**交付物:**
- `F:\openclaw\code\backend\src\main\resources\db\migration\V2__create_articles_table.sql`
- `F:\openclaw\agent\workinglog\jiangrou\{timestamp}-jiangrou-plan02-round1.md`

**验收标准:**
- [ ] SQL 脚本语法正确
- [ ] 执行后 articles 表存在
- [ ] 包含所有必需字段（id, title, content, content_html, author_id, status, access_level, view_count, created_at, updated_at）
- [ ] 外键约束正确（author_id → users.id）

**PM 验证:** Test-Path + MySQL 连接验证

---

### 第 2 轮：ArticleMapper + Entity

**负责人:** 酱肉 🍖  
**预计耗时:** 30 分钟  
**触发条件:** 第 1 轮验收通过

**任务:**
1. 创建 Article.java（Entity）
2. 创建 ArticleMapper.java（MyBatis）
3. 创建 ArticleMapper.xml（SQL 映射）
4. Maven 编译验证

**交付物:**
- `F:\openclaw\code\backend\src\main\java\com\baozipu\entity\Article.java`
- `F:\openclaw\code\backend\src\main\java\com\baozipu\mapper\ArticleMapper.java`
- `F:\openclaw\code\backend\src\main\resources\mapper\ArticleMapper.xml`
- `F:\openclaw\agent\workinglog\jiangrou\{timestamp}-jiangrou-plan02-round2.md`

**验收标准:**
- [ ] Article 类包含所有字段
- [ ] Mapper 接口定义 CRUD 方法
- [ ] XML 映射文件语法正确
- [ ] 编译通过（mvn compile -q）

**PM 验证:** 编译命令 + 代码检查

---

### 第 3 轮：ArticleService 实现

**负责人:** 酱肉 🍖  
**预计耗时:** 30 分钟  
**触发条件:** 第 2 轮验收通过

**任务:**
1. 创建 ArticleService.java（接口）
2. 创建 ArticleServiceImpl.java（实现）
3. 实现 CRUD 逻辑（查询、详情、创建、更新、删除）
4. Maven 编译验证

**交付物:**
- `F:\openclaw\code\backend\src\main\java\com\baozipu\service\ArticleService.java`
- `F:\openclaw\code\backend\src\main\java\com\baozipu\service\impl\ArticleServiceImpl.java`
- `F:\openclaw\agent\workinglog\jiangrou\{timestamp}-jiangrou-plan02-round3.md`

**验收标准:**
- [ ] Service 接口定义 5 个方法（list, getById, create, update, delete）
- [ ] 实现类包含完整逻辑
- [ ] 分页查询支持（PageHelper）
- [ ] 编译通过

**PM 验证:** 编译命令 + 代码检查

---

### 第 4 轮：ArticleController 实现

**负责人:** 酱肉 🍖  
**预计耗时:** 30 分钟  
**触发条件:** 第 3 轮验收通过

**任务:**
1. 创建 ArticleController.java
2. 实现 RESTful API（GET/POST/PUT/DELETE）
3. 添加 Swagger 注解
4. Maven 编译验证

**交付物:**
- `F:\openclaw\code\backend\src\main\java\com\baozipu\controller\ArticleController.java`
- `F:\openclaw\agent\workinglog\jiangrou\{timestamp}-jiangrou-plan02-round4.md`

**验收标准:**
- [ ] GET /api/articles - 文章列表（分页）
- [ ] GET /api/articles/{id} - 文章详情
- [ ] POST /api/articles - 创建文章
- [ ] PUT /api/articles/{id} - 更新文章
- [ ] DELETE /api/articles/{id} - 删除文章
- [ ] Swagger UI 显示接口文档
- [ ] 编译通过

**PM 验证:** 编译命令 + Swagger 检查

---

### 第 5 轮：前端文章页面 + 验证

**负责人:** 豆沙 🍡 + 灌汤 🍲  
**预计耗时:** 15 分钟  
**触发条件:** 第 4 轮验收通过

**任务:**
1. 检查 Articles.vue（文章列表页）
2. 检查 ArticleDetail.vue（文章详情页）
3. 调用 API 测试数据
4. 前端构建验证

**交付物:**
- `F:\openclaw\code\frontend\src\views\Articles.vue`（检查/修改）
- `F:\openclaw\code\frontend\src\views\ArticleDetail.vue`（检查/修改）
- `F:\openclaw\agent\workinglog\dousha\{timestamp}-dousha-plan02-round5.md`
- `F:\openclaw\agent\tasks\plan-02\review.md`（复盘报告）

**验收标准:**
- [ ] Articles.vue 调用 GET /api/articles
- [ ] ArticleDetail.vue 调用 GET /api/articles/{id}
- [ ] 页面可正常访问（无 404）
- [ ] TypeScript 编译通过（npm run type-check）
- [ ] 复盘报告已创建

**PM 验证:** 浏览器访问 + Postman 测试

---

## 🔧 执行流程

```
Plan-01 完成
    ↓
[轮次 1] 酱肉 - 数据库建表（articles）
    ↓ (PM 验证)
[轮次 2] 酱肉 - ArticleMapper + Entity
    ↓ (PM 验证)
[轮次 3] 酱肉 - ArticleService
    ↓ (PM 验证)
[轮次 4] 酱肉 - ArticleController
    ↓ (PM 验证)
[轮次 5] 豆沙 + 灌汤 - 前端页面 + 验证
    ↓
Plan-02 完成 ✅
```

---

## ⚠️ 风险管理

| 风险 | 概率 | 影响 | 应对措施 |
|------|------|------|---------|
| MyBatis 配置错误 | 中 | 高 | 参考现有 UserMapper 配置 |
| 外键约束失败 | 低 | 高 | 确保 users 表已创建 |
| 前端 API 调用失败 | 中 | 中 | 检查 baseURL 和路径 |
| 分页查询错误 | 低 | 中 | 使用 PageHelper 标准语法 |

---

## 📊 依赖关系

**前置依赖:** Plan-01（基础架构 + AuthController）  
**后续依赖:** Plan-03（特色功能需要文章创建 API）

**跨 Agent 依赖:**
- 轮次 1-4：酱肉独立完成
- 轮次 5：豆沙执行，灌汤验证

---

## 📁 文件索引

**计划文档:** `F:\openclaw\agent\tasks\plan-02\plan.md`  
**工单目录:** `F:\openclaw\agent\tasks\plan-02\orders\`  
**验证清单:** `F:\openclaw\agent\tasks\plan-02\verify-list.md`  
**复盘报告:** `F:\openclaw\agent\tasks\plan-02\review.md`（待创建）

---

*创建时间：2026-03-25 23:25*  
*下次更新：轮次完成后自动更新*
