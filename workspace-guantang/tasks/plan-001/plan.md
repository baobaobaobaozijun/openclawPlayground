# Plan 001 — 修复构建错误 + 文章创建页

## 复盘发现的问题

1. 🔴 **article.ts export 不匹配** — Home.vue/Articles.vue/ArticleDetail.vue 导入 `articleApi`，但 article.ts 导出的是独立函数（getArticleList 等）。导致 vite build 失败。
2. 🟡 **6 对重复 View 文件** — 同时存在 Home.vue + HomeView.vue、Login.vue + LoginView.vue 等，router 只用其中一个。需要清理。
3. ✅ 后端 mvn compile 通过（0 错误）
4. ✅ Router 引用的所有 View 文件都存在

## Round 1 目标：修复构建错误

| 工单 | Agent | 任务 |
|------|-------|------|
| TASK-037 | 豆沙 | 修复 article.ts，添加 articleApi 命名导出 |
| TASK-038 | 豆沙 | 清理重复 View 文件（删除 *View.vue） |
| TASK-039 | 酱肉 | TagController 补全（前端分类页需要） |

## Round 2 目标：文章创建页 + 部署准备

| 工单 | Agent | 任务 |
|------|-------|------|
| TASK-040 | 豆沙 | ArticleCreateView（文章创建页） |
| TASK-041 | 酸菜 | 一键部署脚本 deploy-all.sh |
| TASK-042 | 酱肉 | application.yml 生产环境配置 |
