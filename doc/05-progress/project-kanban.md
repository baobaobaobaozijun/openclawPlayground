# 包子铺项目看板

**最后更新:** 2026-03-23 15:40
**上线目标:** 2026-04-04 (12 天后)
**当前阶段:** 阶段 1 - 基础设施

---

## 项目总览

| 阶段 | 时间 | 状态 | 进度 |
|------|------|------|------|
| 阶段 1: 基础设施 | 03-23 ~ 03-25 | 进行中 | 40% |
| 阶段 2: 核心 API | 03-26 ~ 03-29 | 未开始 | 0% |
| 阶段 3: 前端页面 | 03-27 ~ 04-01 | 未开始 | 0% |
| 阶段 4: 联调测试 | 04-02 ~ 04-03 | 未开始 | 0% |
| 阶段 5: 部署上线 | 04-04 | 未开始 | 0% |

---

## 酱肉 (后端)

**仓库:** openclaw-backend | **最后推送:** 03-23 14:36 | **未提交文件:** 1

| 状态 | 任务 | 验证 |
|------|------|------|
| done | 后端项目初始化 (pom.xml + 基础结构) | pom.xml EXISTS |
| done | Entity 层 (User/Article/Category/Tag) | 4 文件 EXISTS |
| done | Mapper 层 (4 个 Mapper) | 4 文件 EXISTS |
| done | AuthController + JWT 认证 | AuthController.java EXISTS |
| done | ArticleController | ArticleController.java EXISTS |
| done | UserService + impl | 2 文件 EXISTS |
| done | ArticleService + impl | 2 文件 EXISTS |
| done | DTO 层 (6 个 DTO) | 6 文件 EXISTS |
| done | JAR 打包成功 | backend-1.0.0-SNAPSHOT.jar 30MB EXISTS |
| done | schema.sql DDL 脚本 | scripts/schema.sql EXISTS |
| todo | CategoryController + CategoryService | MISSING |
| todo | TagController + TagService | MISSING |
| todo | Swagger/OpenAPI 配置 | 未验证 |
| todo | 单元测试 (覆盖率 80%) | 未开始 |

---

## 豆沙 (前端)

**仓库:** openclaw-frontend | **最后推送:** 03-23 14:36 | **未提交文件:** 0

| 状态 | 任务 | 验证 |
|------|------|------|
| done | 前端项目初始化 (Vue3 + TS + Vite) | package.json EXISTS |
| done | HomeView 首页 | HomeView.vue EXISTS |
| done | LoginView 登录页 | LoginView.vue EXISTS |
| done | RegisterView 注册页 | RegisterView.vue EXISTS |
| done | auth API 层 | api/auth.ts EXISTS |
| done | auth Store | stores/auth.ts EXISTS |
| done | 路由配置 | router/index.ts EXISTS |
| done | dist 打包成功 | dist/index.html EXISTS |
| blocked | 删除重复 views/auth/LoginView.vue | 仍然 EXISTS (应删除) |
| todo | 断点标准化 breakpoints.css | MISSING |
| todo | ArticleCard 组件 | MISSING |
| todo | article API 层 | MISSING |
| todo | article Store | MISSING |
| todo | ArticleListView 文章列表页 | MISSING |
| todo | ArticleDetailView 文章详情页 | MISSING |
| todo | ArticleEditorView 编辑器 | MISSING |
| todo | MarkdownRenderer 组件 | MISSING |
| todo | 移动端适配 (576/768/992px) | 未开始 |

---

## 酸菜 (运维)

**仓库:** openclaw-devops | **最后推送:** 03-23 14:36 | **服务器:** 8.137.175.240

| 状态 | 任务 | 验证 |
|------|------|------|
| done | 本地 JAVA_HOME 修复 (JDK 21) | java -version OK |
| done | 本地端口 8080 释放 | netstat OK |
| done | 本地 MySQL openclaw 数据库 | SHOW DATABASES OK |
| done | Docker Compose 配置 | docker-compose.yml EXISTS |
| done | Nginx 配置文件 | nginx/nginx.conf EXISTS |
| blocked | 本地 Redis 安装 | redis-cli 命令不存在 |
| todo | 远程服务器 Redis 安装 | 未验证 |
| todo | 远程服务器环境检查 | 未验证 |
| todo | 上传 JAR 到服务器 | 未验证 |
| todo | 上传 dist 到服务器 | 未验证 |
| todo | 远程 Nginx 配置 | 未验证 |
| todo | 部署验证 (浏览器可访问) | 未验证 |
| todo | CI/CD 脚本 | 未开始 |

---

## 灌汤 (PM)

| 状态 | 任务 |
|------|------|
| done | PRD 文档 |
| done | 技术方案文档 |
| done | v2 开发计划 |
| done | 三份 Agent 执行清单 |
| done | Cron 优化 (心跳三合一 + 健康告警) |
| done | 主动汇报机制 |
| done | Git 仓库修复 (4 个仓库) |
| done | doc 目录清理 + ARCHITECTURE 更新 |
| done | 服务器配置管理 (.local/) |
| todo | 项目看板持续更新 |
| todo | 联调协调 |
| todo | 上线验收 |

---

## 阻塞问题

| 问题 | 阻塞谁 | 状态 |
|------|--------|------|
| 远程 Redis 未安装 | 酱肉后端启动 | 酸菜处理中 |
| 远程服务器部署未完成 | 全员 | 酸菜处理中 |
| MySQL 远程密码未确认 | 后端配置 | 待酸菜确认 |

---

## Git 仓库状态

| 仓库 | 最后推送 | 未提交 |
|------|---------|--------|
| openclawPlayground (agent) | 03-23 15:15 | 有 |
| openclaw-backend | 03-23 14:36 | 1 文件 |
| openclaw-frontend | 03-23 14:36 | 0 |
| openclaw-devops | 03-23 14:36 | 0 |
| openclaw-test | 03-23 14:36 | 0 |

---

*自动更新: 心跳检查时 / PM 查询进度时*
*维护者: 灌汤 (PM)*
