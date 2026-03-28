<!-- Last Modified: 2026-03-28 00:45 -->

# Plan-015 轮次工单记录

---

## R1: 后端改造（酱肉负责）

**状态:** pending  
**前置条件:** Plan-014 完成  
**预计时间:** 3.5 小时

| 序号 | 任务 | 交付物 | 状态 | 完成时间 |
|------|------|--------|------|---------|
| 1.1 | users 表添加 access_level | SQL 脚本 + 执行 | ⏳ pending | - |
| 1.2 | User.java + UserDTO.java | 添加 accessLevel 字段 | ⏳ pending | - |
| 1.3 | Comment 模块开发 | Entity/Mapper/Service/Controller | ⏳ pending | - |
| 1.4 | comments 表创建 | SQL 脚本 + 执行 | ⏳ pending | - |
| 1.5 | ArticleController 权限检查 | 修改 getArticleById | ⏳ pending | - |
| 1.6 | 单元测试 + 自测 | 测试用例 + 测试报告 | ⏳ pending | - |

---

## R2: 前端整合（豆沙负责）

**状态:** pending  
**前置条件:** Plan-015 R1 完成  
**预计时间:** 2.5 小时

| 序号 | 任务 | 交付物 | 状态 | 完成时间 |
|------|------|--------|------|---------|
| 2.1 | NavBar.vue + Footer.vue | 创建布局组件 | ⏳ pending | - |
| 2.2 | 路由配置 | /login /register + 守卫 | ⏳ pending | - |
| 2.3 | VIP 权限集成 | 锁图标 + 权限检查 | ⏳ pending | - |
| 2.4 | TypeScript 类型定义 | types/*.ts | ⏳ pending | - |

---

## R3: 联调测试（酸菜负责）

**状态:** pending  
**前置条件:** Plan-015 R2 完成  
**预计时间:** 3.5 小时

| 序号 | 任务 | 交付物 | 状态 | 完成时间 |
|------|------|--------|------|---------|
| 3.1 | 测试账号 + 数据准备 | VIP/管理员账号 + 脚本 | ⏳ pending | - |
| 3.2 | API 测试 | Postman 测试集合 | ⏳ pending | - |
| 3.3 | E2E 测试 | E2E 测试脚本 | ⏳ pending | - |

---

*Plan-015 | 博客系统前端整合改造 | 灌汤 PM | 2026-03-28 00:45*
