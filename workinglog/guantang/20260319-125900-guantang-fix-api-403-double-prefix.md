<!-- Last Modified: 2026-03-19 -->

# 工作日志

## 修改信息
- **修改人:** 灌汤
- **修改时间:** 2026-03-19 12:59:00
- **任务类型:** fix

## 任务内容
PM 直接动手修复 API 403 Forbidden 关键 Bug。

### 根因
`application.yml` 配置了 `server.servlet.context-path: /api`（Tomcat 层自动加 `/api` 前缀），
但 Controller 的 `@RequestMapping` 又写了 `/api/auth` 和 `/api/articles`，
导致实际请求路径变成 `/api/api/auth/...` 和 `/api/api/articles/...`。
SecurityConfig 中 `permitAll("/api/auth/**")` 匹配的是 Servlet 相对路径 `/api/auth/**`，
而实际 Servlet 相对路径是 `/api/api/auth/**`，所以全部被拦截返回 403。

### 修复方案（方案A：去掉 Controller 层的 `/api` 前缀）

**修改的 3 个文件：**

1. `AuthController.java` — `@RequestMapping("/api/auth")` → `@RequestMapping("/auth")`
2. `ArticleController.java` — `@RequestMapping("/api/articles")` → `@RequestMapping("/articles")`
3. `SecurityConfig.java` — requestMatchers 同步去掉 `/api` 前缀：
   - `/api/auth/**` → `/auth/**`
   - `/api/articles/**` → `/articles/**`

### 修复后路径映射
| 外部请求路径 | context-path 去掉后 | Controller 匹配 | SecurityConfig 匹配 |
|---|---|---|---|
| `POST /api/auth/register` | `/auth/register` | ✅ `/auth/**` | ✅ `permitAll("/auth/**")` |
| `GET /api/articles/1` | `/articles/1` | ✅ `/articles/**` | ✅ `permitAll(GET, "/articles/**")` |

### 编译验证
- `mvn compile -DskipTests` → **BUILD SUCCESS** ✅

## 修改的文件
- `F:\openclaw\code\backend\src\main\java\com\openclaw\controller\AuthController.java` — 去掉 `/api` 前缀
- `F:\openclaw\code\backend\src\main\java\com\openclaw\controller\ArticleController.java` — 去掉 `/api` 前缀
- `F:\openclaw\code\backend\src\main\java\com\openclaw\config\SecurityConfig.java` — 同步更新 requestMatchers 路径

## 关联通知
- [x] 酱肉任务完成情况：子 Agent 仅识别了文件但未执行修改，PM 直接修复
- [x] 酸菜待重新启动验证

## 下一步
- 酸菜需重新执行 `mvn spring-boot:run` 验证服务启动
- 需要确保 MySQL 和 Redis 已启动，否则服务会因连接失败而退出

---

*日志自动生成*
