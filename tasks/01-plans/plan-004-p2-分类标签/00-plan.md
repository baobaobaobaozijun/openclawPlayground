<!-- Last Modified: 2026-03-25 23:25 -->

# Plan-04: 分类标签与完善

**计划状态:** ⏳ 待执行  
**创建日期:** 2026-03-25 23:25  
**负责人:** 灌汤 (PM)  
**执行周期:** 2026-03-26 05:00 ~ 2026-03-26 06:00（1 小时）  
**总轮次:** 5 轮

---

## 📋 计划目标

实现分类标签管理，完善剩余 P1/P2 功能（用户信息字段补全、Token 响应格式）。

### 覆盖的差异问题
| 编号 | 问题 | 类别 | 优先级 |
|------|------|------|--------|
| 🔴 #3 | 用户信息字段缺失（完整） | 实现偏离 | P1 |
| 🟢 #4 | 功能缺失（分类标签管理） | 功能缺失 | P2 |
| 🔴 #4 | Token 响应格式（完整） | 实现偏离 | P2 |

---

## 🎯 成功标准

- [ ] categories 表创建成功
- [ ] tags 表创建成功
- [ ] CategoryController 可调用
- [ ] TagController 可调用
- [ ] UserInfo 包含 phone/avatar/role
- [ ] 所有响应包含 timestamp
- [ ] 前端分类页可访问

---

## 📅 轮次安排

### 第 1 轮：UserInfo 字段补全

**负责人:** 酱肉 🍖  
**预计耗时:** 15 分钟  
**触发条件:** Plan-03 完成

**任务:**
1. 修改 UserDto，添加 phone/avatar/role 字段
2. 修改 UserServiceImpl.login()，返回完整用户信息
3. 修改前端 auth.ts LoginResponse 接口
4. 修改前端 stores/auth.ts UserInfo 接口

**交付物:**
- `F:\openclaw\code\backend\src\main\java\com\baozipu\entity\dto\UserDto.java`（修改）
- `F:\openclaw\code\backend\src\main\java\com\baozipu\service\impl\UserServiceImpl.java`（修改）
- `F:\openclaw\code\frontend\src\api\auth.ts`（修改）
- `F:\openclaw\code\frontend\src\stores\auth.ts`（修改）
- `F:\openclaw\agent\workinglog\jiangrou\{timestamp}-jiangrou-plan04-round1.md`

**验收标准:**
- [ ] UserDto 包含 phone, avatar, role
- [ ] login() 返回完整用户信息
- [ ] 前端接口定义一致
- [ ] 编译通过

**PM 验证:** 代码检查 + Postman 测试

---

### 第 2 轮：分类数据库 + Mapper

**负责人:** 酱肉 🍖  
**预计耗时:** 20 分钟  
**触发条件:** 第 1 轮验收通过

**任务:**
1. 创建 categories 表 SQL 脚本
2. 创建 Category.java（Entity）
3. 创建 CategoryMapper.java
4. Maven 编译验证

**交付物:**
- `F:\openclaw\code\backend\src\main\resources\db\migration\V3__create_categories_table.sql`
- `F:\openclaw\code\backend\src\main\java\com\baozipu\entity\Category.java`
- `F:\openclaw\code\backend\src\main\java\com\baozipu\mapper\CategoryMapper.java`
- `F:\openclaw\agent\workinglog\jiangrou\{timestamp}-jiangrou-plan04-round2.md`

**验收标准:**
- [ ] categories 表包含 id, name, slug, parent_id, description, sort_order
- [ ] 支持多级分类（parent_id 自关联）
- [ ] Entity 和 Mapper 语法正确
- [ ] 编译通过

**PM 验证:** 编译命令 + 代码检查

---

### 第 3 轮：标签数据库 + Mapper

**负责人:** 酱肉 🍖  
**预计耗时:** 20 分钟  
**触发条件:** 第 2 轮验收通过

**任务:**
1. 创建 tags 表 SQL 脚本
2. 创建 Tag.java（Entity）
3. 创建 TagMapper.java
4. Maven 编译验证

**交付物:**
- `F:\openclaw\code\backend\src\main\resources\db\migration\V4__create_tags_table.sql`
- `F:\openclaw\code\backend\src\main\java\com\baozipu\entity\Tag.java`
- `F:\openclaw\code\backend\src\main\java\com\baozipu\mapper\TagMapper.java`
- `F:\openclaw\agent\workinglog\jiangrou\{timestamp}-jiangrou-plan04-round3.md`

**验收标准:**
- [ ] tags 表包含 id, name, slug, description, article_count
- [ ] Entity 和 Mapper 语法正确
- [ ] 编译通过

**PM 验证:** 编译命令 + 代码检查

---

### 第 4 轮：Category/Tag Controller

**负责人:** 酱肉 🍖  
**预计耗时:** 30 分钟  
**触发条件:** 第 3 轮验收通过

**任务:**
1. 创建 CategoryService + CategoryServiceImpl
2. 创建 CategoryController
3. 创建 TagService + TagServiceImpl
4. 创建 TagController
5. Maven 编译验证

**交付物:**
- `F:\openclaw\code\backend\src\main\java\com\baozipu\service\CategoryService.java`
- `F:\openclaw\code\backend\src\main\java\com\baozipu\controller\CategoryController.java`
- `F:\openclaw\code\backend\src\main\java\com\baozipu\service\TagService.java`
- `F:\openclaw\code\backend\src\main\java\com\baozipu\controller\TagController.java`
- `F:\openclaw\agent\workinglog\jiangrou\{timestamp}-jiangrou-plan04-round4.md`

**验收标准:**
- [ ] GET /api/categories - 分类列表（树形结构）
- [ ] GET /api/tags - 标签列表
- [ ] POST /api/categories - 创建分类
- [ ] POST /api/tags - 创建标签
- [ ] Swagger UI 显示接口
- [ ] 编译通过

**PM 验证:** 编译命令 + Swagger 检查

---

### 第 5 轮：前端组件 + 验证

**负责人:** 豆沙 🍡 + 灌汤 🍲  
**预计耗时:** 15 分钟  
**触发条件:** 第 4 轮验收通过

**任务:**
1. 创建 CategoryView.vue（分类页）
2. 创建标签组件
3. 集成到路由
4. 前端构建验证

**交付物:**
- `F:\openclaw\code\frontend\src\views\CategoryView.vue`
- `F:\openclaw\code\frontend\src\components\TagCloud.vue`
- `F:\openclaw\code\frontend\src\router\index.ts`（修改，添加路由）
- `F:\openclaw\agent\workinglog\dousha\{timestamp}-dousha-plan04-round5.md`
- `F:\openclaw\agent\tasks\plan-04\review.md`（复盘报告）

**验收标准:**
- [ ] CategoryView 调用 GET /api/categories
- [ ] 标签云组件显示
- [ ] 路由 /category 可访问
- [ ] TypeScript 编译通过
- [ ] 复盘报告已创建

**PM 验证:** 浏览器访问 + Postman 测试

---

## 🔧 执行流程

```
Plan-03 完成
    ↓
[轮次 1] 酱肉 - UserInfo 字段补全
    ↓ (PM 验证)
[轮次 2] 酱肉 - 分类数据库 + Mapper
    ↓ (PM 验证)
[轮次 3] 酱肉 - 标签数据库 + Mapper
    ↓ (PM 验证)
[轮次 4] 酱肉 - Category/Tag Controller
    ↓ (PM 验证)
[轮次 5] 豆沙 + 灌汤 - 前端组件 + 验证
    ↓
Plan-04 完成 ✅
```

---

## ⚠️ 风险管理

| 风险 | 概率 | 影响 | 应对措施 |
|------|------|------|---------|
| 多级分类查询复杂 | 中 | 中 | 使用递归查询或缓存 |
| 前后端字段不一致 | 低 | 中 | PM 严格检查接口定义 |
| 路由冲突 | 低 | 低 | 检查现有路由命名 |

---

## 📊 依赖关系

**前置依赖:** Plan-01（基础架构）  
**后续依赖:** Plan-05（文档验收）

**跨 Agent 依赖:**
- 轮次 1-4：酱肉独立完成
- 轮次 5：豆沙执行，灌汤验证

---

## 📁 文件索引

**计划文档:** `F:\openclaw\agent\tasks\plan-04\plan.md`  
**工单目录:** `F:\openclaw\agent\tasks\plan-04\orders\`  
**验证清单:** `F:\openclaw\agent\tasks\plan-04\verify-list.md`  
**复盘报告:** `F:\openclaw\agent\tasks\plan-04\review.md`（待创建）

---

*创建时间：2026-03-25 23:25*  
*下次更新：轮次完成后自动更新*
