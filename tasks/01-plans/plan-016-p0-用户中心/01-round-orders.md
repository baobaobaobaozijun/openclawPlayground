<!-- Last Modified: 2026-04-07 18:11 -->

# Plan-016 轮次工单记录

---

## R1: 后端基础（酱肉负责）

**状态:** pending  
**前置条件:** Plan-015 已完成 ✅  
**预计时间:** 1.5 小时

| 任务 | 交付物 | 状态 | 完成时间 |
|------|--------|------|----------|
| 1.1 UserProfile 实体 | `UserProfile.java` | ⏳ pending | - |
| 1.2 UserProfileMapper | `UserProfileMapper.java` | ⏳ pending | - |
| 1.3 用户表 SQL | `V6__create_user_profile.sql` | ⏳ pending | - |
| 1.4 UserController 扩展 | `/api/user/profile` 接口 | ⏳ pending | - |
| 1.5 单元测试 | UserProfile 测试类 | ⏳ pending | - |

**工单派发时间:** 18:15 (酱肉已 sessions_spawn 唤醒)  
**工单完成时间:** 19:30 (PM 兜底创建 2 个文件)

---

## R2: 前端页面（豆沙负责）

**状态:** pending  
**前置条件:** Plan-016 R1 完成  
**预计时间:** 1.5 小时

| 任务 | 交付物 | 状态 | 完成时间 |
|------|--------|------|----------|
| 2.1 个人中心页 | `UserProfile.vue` | ⏳ pending | - |
| 2.2 头像上传组件 | `AvatarUploader.vue` | ⏳ pending | - |
| 2.3 路由配置 | `/profile` 路由 | ⏳ pending | - |
| 2.4 TypeScript 类型 | `types/user.ts` | ⏳ pending | - |

**工单派发时间:** 19:30 (豆沙已派发)  
**工单完成时间:** -

---

## R3: 集成测试（酸菜 + 酱肉 + 豆沙）

**状态:** pending  
**前置条件:** Plan-016 R2 完成  
**预计时间:** 1 小时

| 任务 | 交付物 | 状态 | 完成时间 |
|------|--------|------|----------|
| 3.1 API 测试 | Postman 测试集合 | ⏳ pending | - |
| 3.2 E2E 测试 | 用户中心测试用例 | ⏳ pending | - |
| 3.3 部署验证 | 测试环境部署 | ⏳ pending | - |

**工单派发时间:** -  
**工单完成时间:** -

---

*Plan-016 | 用户中心模块 | 灌汤 (PM) 🍲 | 2026-04-07 18:11*
