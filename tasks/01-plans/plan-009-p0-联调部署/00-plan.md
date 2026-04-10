<!-- Last Modified: 2026-04-10 19:00 -->

# Plan-009: 前后端联调 + 部署验证

**创建时间:** 2026-04-10 19:00  
**优先级:** P0 (最高)  
**状态:** processing  
**总轮数:** 3 轮  
**目标:** 完成前后端 API 联调，验证部署流程

---

## 📋 计划目标

1. **后端 API 可访问** — 启动 Java 服务，API 可被前端调用
2. **前端能获取数据** — HomeView/ArticleList 能显示真实数据
3. **登录流程打通** — LoginView → Auth API → Token 存储
4. **部署脚本验证** — 能在服务器/本地 Docker 部署

---

## 🎯 第 1 轮任务 (19:00 派发)

### 🍖 酱肉 (后端)
**任务:** 启动后端服务 + 验证 API 可访问
**交付物:**
1. `F:\openclaw\code\backend\target\baozipu-backend.jar` (编译产物)
2. `F:\openclaw\agent\workspace-jiangrou\logs\api-verify.md` (API 验证日志)

**验收标准:**
- [ ] mvn compile 通过
- [ ] Java 进程监听 8081 端口
- [ ] GET /api/articles 返回 200
- [ ] Swagger UI 可访问

**禁止:**
- 不要修改现有代码（仅启动验证）
- 不要等待前端完成

---

### 🍡 豆沙 (前端)
**任务:** 配置 API  baseURL + 验证 HomeView 数据获取
**交付物:**
1. `F:\openclaw\code\frontend\src\utils\request.ts` (API 请求配置)
2. `F:\openclaw\agent\workspace-dousha\logs\frontend-api-test.md` (联调日志)

**验收标准:**
- [ ] baseURL 配置为 `http://localhost:8081`
- [ ] HomeView 能调用 /api/articles
- [ ] 控制台无 CORS 错误
- [ ] 页面显示文章列表（或 mock 数据）

**禁止:**
- 不要修改后端代码
- 不要等待后端完成（先用 mock 数据）

---

### 🥬 酸菜 (运维)
**任务:** 验证部署脚本 + 准备部署文档
**交付物:**
1. `F:\openclaw\agent\workspace-suancai\deploy\deploy-checklist.md` (部署检查清单)
2. `F:\openclaw\agent\workspace-suancai\logs\deploy-verify.md` (验证日志)

**验收标准:**
- [ ] docker-compose.yml 语法正确
- [ ] 服务器 SSH 可连接
- [ ] 部署目录 /opt/baozipu/ 存在
- [ ] 备份脚本可执行

**禁止:**
- 不要执行实际部署（仅验证）
- 不要修改 Docker 配置

---

## 📅 预计时间线

| 轮次 | 开始时间 | 预计完成 | 负责人 |
|------|---------|---------|-------|
| Round 1 | 19:00 | 19:30 | 全员 |
| Round 2 | 19:30 | 20:00 | 全员 |
| Round 3 | 20:00 | 20:30 | 全员 |

---

## 📝 执行记录

### Round 1 (19:00 派发) ✅ 已派发
- [ ] 酱肉：后端服务启动 + API 验证 (会话：47c95a3e)
- [ ] 豆沙：前端 API 配置 + HomeView 联调 (会话：03cd04f3)
- [ ] 酸菜：部署脚本验证 + 检查清单 (会话：00acbc7b)

**派发时间:** 19:00  
**预计完成:** 19:30  
**数据库:** pipeline_agent_tasks 已插入 3 条记录

### Round 2 (待派发)
- [ ] 待分配

### Round 3 (待派发)
- [ ] 待分配

---

## 🔗 相关文档

- [系统架构](../../specs/01-architecture/system-architecture.md)
- [API 文档](../../specs/02-business-specs/blog-system-requirements.md)
- [部署方案](../../specs/03-technical-specs/deployment-plan.md)

---

*创建人：灌汤 (PM) 🍲*
