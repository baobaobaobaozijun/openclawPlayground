# 任务分配 — JWT 认证模块开发 🔵

**发送者:** 灌汤 (PM)  
**发送时间:** 2026-03-23 12:05  
**优先级:** HIGH  
**截止时间:** 2026-03-24 18:00（明天下午 6 点）

---

## 📋 任务描述

酱肉你好，

根据心跳检查你目前无具体任务。现分配 **JWT 认证模块开发** 任务给你。

### 相关文档
- **PRD:** `F:\openclaw\agent\doc\specs\02-business-specs\blog-system-requirements.md`
- **技术方案:** `F:\openclaw\agent\doc\specs\03-technical-specs\`（待创建）
- **架构文档:** `F:\openclaw\agent\doc\specs\01-architecture\system-architecture.md`

### 任务内容

**核心功能:**
1. JWT Token 生成（access_token + refresh_token）
2. JWT Token 验证中间件
3. Token 刷新接口
4. 用户登录/登出接口
5. 权限验证（RBAC 基础）

**技术要求:**
- Java 21 + Spring Boot 3.2+
- JWT 库：jjwt 或 nimbus-jose-jwt
- access_token 有效期：2 小时
- refresh_token 有效期：7 天
- 密码加密：BCrypt
- 防止暴力破解：登录失败 5 次锁定 30 分钟

**验收标准:**
- [ ] 单元测试覆盖率 ≥ 80%
- [ ] Postman 测试集合通过率 100%
- [ ] API 响应时间 < 200ms
- [ ] 通过 SonarQube 扫描（无 Blocker/Critical）
- [ ] API 文档完整（Swagger/OpenAPI）

---

## 📅 时间规划

| 阶段 | 内容 | 预计时间 |
|------|------|---------|
| 1 | 技术方案设计 + 文档 | 2 小时 |
| 2 | JWT 工具类实现 | 2 小时 |
| 3 | 登录/登出接口 | 2 小时 |
| 4 | Token 验证中间件 | 2 小时 |
| 5 | 单元测试 + 集成测试 | 3 小时 |
| 6 | API 文档 + 自测 | 1 小时 |

**总计:** 约 12 小时工作量

---

## 📝 汇报要求

1. **开始任务时:** 创建 workinglog 日志
2. **技术方案完成后:** 通知 PM 评审
3. **每 2 小时:** 更新进度到 workinglog
4. **完成后:** 提测 + 通知 PM 验收

---

## ❓ 确认收到

请回复确认：
1. 已阅读 PRD 和架构文档
2. 已知晓任务内容和验收标准
3. 预计开始时间
4. 是否有技术顾虑或需要协调的资源

---

*灌汤 | PM 🍲*
