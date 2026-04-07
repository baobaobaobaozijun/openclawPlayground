<!-- Last Modified: 2026-03-28 00:45 -->

# Plan-015 — 博客系统前端整合改造

**优先级:** P0  
**创建时间:** 2026-03-28 00:45  
**负责人:** 灌汤 (PM)  
**状态:** completed (2026-04-07 16:15 完成)  
**文档来源:** `doc/02-specs/02-business-specs/blog-system-refactor-plan.md`

---

## 📋 计划目标

解决前端交互凌乱问题，实现：
1. **统一布局** — 创建 NavBar + Footer，所有页面使用 MainLayout
2. **VIP 权限** — 后端添加 access_level 字段，前端展示锁图标和权限检查
3. **评论功能** — 完整 Comment 模块（后端 CRUD + 前端集成）
4. **路由规范** — 添加认证路由和路由守卫

---

## 🔄 轮次规划

### R1: 后端改造（酱肉负责，3.5 小时）

| 序号 | 任务 | 交付物 | 验收标准 | 预计时间 |
|------|------|--------|---------|---------|
| 1.1 | users 表添加 access_level | SQL 脚本 + 执行 | users 表有 access_level 字段 | 20min |
| 1.2 | User.java + UserDTO.java | 添加 accessLevel 字段 | 字段可正常读写 | 20min |
| 1.3 | Comment 模块开发 | Entity/Mapper/Service/Controller | CRUD 接口全部可用 | 2h |
| 1.4 | comments 表创建 | SQL 脚本 + 执行 | comments 表创建成功 | 20min |
| 1.5 | ArticleController 权限检查 | 修改 getArticleById 方法 | 公开/登录/VIP 文章权限检查正确 | 30min |
| 1.6 | 单元测试 + 自测 | 测试用例 + 测试报告 | 核心功能测试覆盖率≥80% | 30min |

---

### R2: 前端整合（豆沙负责，2.5 小时）

**前置条件:** Plan-015 R1 完成

| 序号 | 任务 | 交付物 | 验收标准 | 预计时间 |
|------|------|--------|---------|---------|
| 2.1 | NavBar.vue + Footer.vue | 创建布局组件 | NavBar 显示登录状态 | 60min |
| 2.2 | 路由配置 | 添加 /login /register + 路由守卫 | 路由可访问，守卫正常工作 | 50min |
| 2.3 | VIP 权限集成 | ArticleCard 锁图标 + ArticleDetail 权限检查 | VIP 文章显示锁图标，无权限时正确提示 | 50min |
| 2.4 | TypeScript 类型定义 | types/article.ts/user.ts/comment.ts | 类型定义完整 | 30min |

---

### R3: 联调测试（酸菜负责，3.5 小时）

**前置条件:** Plan-015 R2 完成

| 序号 | 任务 | 交付物 | 验收标准 | 预计时间 |
|------|------|--------|---------|---------|
| 3.1 | 测试账号 + 数据准备 | VIP/管理员账号 + 测试数据脚本 | 测试账号可用，测试数据完整 | 45min |
| 3.2 | API 测试 | Postman 测试集合 | 所有接口测试通过 (AUTH/ART/CMT) | 1h |
| 3.3 | E2E 测试 | E2E 测试脚本 | 完整用户旅程测试通过 (E2E-001~004) | 2h |

---

## 📊 依赖关系

**前置计划:** plan-014 (失联修复机制)  
**原因:** 新机制验证稳定后，再执行大型改造

**轮次依赖:**
```
R1 (后端改造) → R2 (前端整合) → R3 (联调测试)
```

---

## ⏱️ 时间规划

| 阶段 | 开始时间 | 结束时间 | 说明 |
|------|---------|---------|------|
| Plan-014 | 00:25 | 01:25 (预计) | 失联修复机制 |
| Plan-015 R1 | 01:30 (预计) | 05:00 (预计) | 后端改造 |
| Plan-015 R2 | 05:00 (预计) | 07:30 (预计) | 前端整合 |
| Plan-015 R3 | 07:30 (预计) | 11:00 (预计) | 联调测试 |

**总工期:** 9.5 小时

---

## 📄 相关文档

- [整合改造方案](../../doc/02-specs/02-business-specs/blog-system-integration-plan.md)
- [详细执行计划](../../doc/02-specs/02-business-specs/blog-system-refactor-plan.md)
- [PM 创建流程](../../doc/04-processes/pm-plan-creation-process.md)
- [进度汇报模板](../../doc/06-templates/progress-report-template.md)
- [任务交付模板](../../doc/06-templates/task-delivery-template.md)

---

## ⚠️ 风险与缓解

| 风险 | 影响 | 概率 | 缓解措施 |
|------|------|------|---------|
| 数据库修改影响现有数据 | 高 | 低 | 先备份，测试环境验证 |
| 后端接口延期 | 高 | 中 | 前后端并行，前端用 Mock 数据 |
| VIP 权限逻辑错误 | 高 | 中 | 详细测试用例，酸菜提前介入 |
| 评论功能性能问题 | 中 | 低 | 分页加载，限制每页数量 |

---

## ✅ 验收标准

### 后端验收
- [ ] UserDTO 返回 accessLevel 字段
- [ ] ArticleResponseDTO 返回 accessLevel 字段
- [ ] GET /articles/{id} 权限检查正常（公开/登录/VIP）
- [ ] Comment 模块 CRUD 接口正常
- [ ] 数据库 access_level/comments 表创建完成
- [ ] 单元测试覆盖率≥80%

### 前端验收
- [ ] MainLayout 应用到所有页面
- [ ] NavBar 显示登录状态（未登录/已登录不同 UI）
- [ ] VIP 文章显示锁图标
- [ ] 无权限时显示"登录查看"或"需要 VIP 权限"
- [ ] 评论区正常显示和发表
- [ ] 路由守卫正常工作（未登录跳转 /login）
- [ ] TypeScript 类型定义完整

### 测试验收
- [ ] API 测试全部通过（AUTH-001~005, ART-001~005, CMT-001~006）
- [ ] VIP 权限测试全部通过
- [ ] E2E 测试全部通过（E2E-001~004）
- [ ] 无严重 Bug

---

*Plan-015 | 博客系统前端整合改造 | 灌汤 PM | 2026-03-28 00:45*

