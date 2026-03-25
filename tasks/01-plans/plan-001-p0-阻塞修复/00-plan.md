<!-- Last Modified: 2026-03-25 23:20 -->

# Plan-01: P0 阻塞问题修复

**计划状态:** 待执行  
**创建日期:** 2026-03-25 23:20  
**负责人:** 灌汤 (PM)  
**执行周期:** 2026-03-25 23:30 ~ 2026-03-26 01:30（2 小时）  
**总轮次:** 5 轮

---

## 📋 计划目标

解决代码与文档差异分析中识别的 **P0 阻塞问题**，使系统具备基本可运行能力。

### 待解决问题

| 问题 | 严重度 | 预计耗时 |
|------|--------|---------|
| 1. 数据库未创建（users 表） | 🔴 阻塞 | 10 分钟 |
| 2. AuthController 缺失 | 🔴 阻塞 | 30 分钟 |
| 3. API 路径不一致（/api 前缀） | 🔴 阻塞 | 15 分钟 |
| 4. 认证方式决策（手机号 vs 账号密码） | 🔴 阻塞 | 10 分钟 |
| 5. 编译验证 + 联调测试 | 🔴 阻塞 | 15 分钟 |

---

## 🎯 成功标准

- [ ] users 表在 MySQL 中创建成功
- [ ] AuthController 可正常编译
- [ ] 前端 API 请求路径统一为 `/api/*`
- [ ] 登录接口可调用（Postman 测试通过）
- [ ] 所有代码编译通过（mvn compile + npm run build）

---

## 📅 轮次安排

### 第 1 轮：数据库建表

**负责人:** 酱肉 🍖  
**预计耗时:** 10 分钟  
**触发条件:** Plan-01 启动

**任务:**
1. 创建 `users` 表（按 database-design.md）
2. 验证表结构正确
3. 记录工作日志

**交付物:**
- `F:\openclaw\code\backend\src\main\resources\db\migration\V1__create_users_table.sql`
- `F:\openclaw\agent\workinglog\jiangrou\{timestamp}-jiangrou-db-users.md`

**验收标准:**
- [ ] SQL 脚本语法正确
- [ ] 执行后 users 表存在
- [ ] 包含所有必需字段（id, username, password, email, phone, role, status, created_at, updated_at）

**PM 验证:** Test-Path + MySQL 连接验证

---

### 第 2 轮：创建 AuthController

**负责人:** 酱肉 🍖  
**预计耗时:** 30 分钟  
**触发条件:** 第 1 轮验收通过

**任务:**
1. 创建 AuthController.java
2. 实现 login 接口（username + password）
3. 实现 register 接口
4. 添加 Swagger 注解
5. Maven 编译验证

**交付物:**
- `F:\openclaw\code\backend\src\main\java\com\baozipu\controller\AuthController.java`
- `F:\openclaw\agent\workinglog\jiangrou\{timestamp}-jiangrou-auth-controller.md`

**验收标准:**
- [ ] POST /api/auth/login 可访问
- [ ] POST /api/auth/register 可访问
- [ ] 编译通过（mvn compile -q）
- [ ] Swagger UI 显示接口文档

**PM 验证:** 编译命令 + Swagger 检查

---

### 第 3 轮：修正前端 API 路径

**负责人:** 豆沙 🍡  
**预计耗时:** 15 分钟  
**触发条件:** 第 2 轮验收通过

**任务:**
1. 修改 request.ts，添加 baseURL: '/api'
2. 验证所有 API 调用路径正确
3. TypeScript 编译验证

**交付物:**
- `F:\openclaw\code\frontend\src\utils\request.ts`（修改）
- `F:\openclaw\agent\workinglog\dousha\{timestamp}-dousha-api-baseurl.md`

**验收标准:**
- [ ] request.ts 中设置 baseURL: '/api'
- [ ] auth.ts 调用路径变为 `/api/auth/login`
- [ ] TypeScript 编译通过（npm run type-check）

**PM 验证:** 编译命令 + 代码检查

---

### 第 4 轮：后端编译 + 部署验证

**负责人:** 酸菜 🥬  
**预计耗时:** 15 分钟  
**触发条件:** 第 3 轮验收通过

**任务:**
1. 执行后端完整编译（mvn clean package）
2. 执行前端构建（npm run build）
3. 验证 JAR 包可执行
4. 记录工作日志

**交付物:**
- `F:\openclaw\code\backend\target\backend-0.0.1-SNAPSHOT.jar`
- `F:\openclaw\code\frontend\dist\`（构建产物）
- `F:\openclaw\agent\workinglog\suancai\{timestamp}-suancai-build-verify.md`

**验收标准:**
- [ ] Maven 编译成功（无错误）
- [ ] 前端构建成功（dist 目录生成）
- [ ] JAR 包可执行（java -jar 测试）

**PM 验证:** 编译输出检查 + JAR 测试

---

### 第 5 轮：复盘 + 下一计划规划

**负责人:** 灌汤 🍲  
**预计耗时:** 15 分钟  
**触发条件:** 第 4 轮验收通过

**任务:**
1. 验证所有交付物
2. Postman 测试登录接口
3. 生成复盘报告
4. 规划 Plan-02（文章管理模块）

**交付物:**
- `F:\openclaw\agent\tasks\plan-01\review.md`
- `F:\openclaw\agent\tasks\plan-02\plan.md`（草案）

**验收标准:**
- [ ] 登录接口 Postman 测试通过
- [ ] 复盘报告包含问题与改进
- [ ] Plan-02 计划已创建

**PM 验证:** 自查

---

## 🔧 执行流程

```
Plan-01 启动
    ↓
[轮次 1] 酱肉 - 数据库建表
    ↓ (PM 验证)
[轮次 2] 酱肉 - AuthController
    ↓ (PM 验证)
[轮次 3] 豆沙 - 前端 API 路径
    ↓ (PM 验证)
[轮次 4] 酸菜 - 编译验证
    ↓ (PM 验证)
[轮次 5] 灌汤 - 复盘 + Plan-02
    ↓
Plan-01 完成 ✅
```

---

## ⚠️ 风险管理

| 风险 | 概率 | 影响 | 应对措施 |
|------|------|------|---------|
| 数据库连接失败 | 中 | 高 | 提前验证 MySQL 服务状态 |
| Maven 依赖下载慢 | 高 | 中 | 使用阿里云镜像 |
| 前端编译错误 | 低 | 中 | 豆沙现场修复，PM 协助 |
| JAR 包不可执行 | 中 | 高 | 检查 spring-boot-maven-plugin 配置 |
| 认证方式决策延迟 | 低 | 高 | PM 立即决策（建议保持 username/password） |

---

## 📊 依赖关系

**前置依赖:** 无  
**后续依赖:** Plan-02（文章管理模块）

**跨 Agent 依赖:**
- 轮次 2 依赖 轮次 1（Controller 依赖 users 表）
- 轮次 3 依赖 轮次 2（前端依赖后端 API 路径）
- 轮次 4 依赖 轮次 3（编译验证需要前后端代码就绪）

---

## 📝 决策记录

### 认证方式决策（待 PM 确认）

**选项 A:** 保持当前 username/password 登录  
- 优点：实现简单，符合传统习惯
- 缺点：与 PRD 不一致，需要修改文档

**选项 B:** 修改为手机号登录（无需密码）  
- 优点：符合 PRD，用户体验更好
- 缺点：需要重构 AuthController + UserService

**建议:** 选项 A（保持当前实现，修改 PRD 文档）  
**理由:** 项目早期，优先保证可运行，认证方式可在阶段 2 优化

---

## 📈 进度跟踪

| 轮次 | 状态 | 开始时间 | 结束时间 | 实际耗时 | 备注 |
|------|------|---------|---------|---------|------|
| 1 | ⏳ 待执行 | - | - | - | 数据库建表 |
| 2 | ⏳ 待执行 | - | - | - | AuthController |
| 3 | ⏳ 待执行 | - | - | - | 前端 API 路径 |
| 4 | ⏳ 待执行 | - | - | - | 编译验证 |
| 5 | ⏳ 待执行 | - | - | - | 复盘 |

**状态图例:** ⏳ 待执行 | 🟢 进行中 | ✅ 完成 | 🔴 阻塞 | ❌ 失败

---

## 📁 文件索引

**计划文档:** `F:\openclaw\agent\tasks\plan-01\plan.md`  
**工单目录:** `F:\openclaw\agent\tasks\plan-01\orders\`  
**验证清单:** `F:\openclaw\agent\tasks\plan-01\verify-list.md`  
**复盘报告:** `F:\openclaw\agent\tasks\plan-01\review.md`（待创建）

---

*创建时间：2026-03-25 23:20*  
*下次更新：轮次完成后自动更新*
