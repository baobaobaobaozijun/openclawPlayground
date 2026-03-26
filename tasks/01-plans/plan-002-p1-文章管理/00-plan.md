# Plan-002 计划详情

## 基本信息

**计划名称:** P1 文章管理模块  
**优先级:** P1 (核心功能)  
**创建时间:** 2026-03-26 08:26  
**负责人:** 灌汤 🍲  

---

## 目标

完成博客系统的文章管理核心功能，包括：
- 后端：Article CRUD 接口 + 数据库表
- 前端：文章列表/详情/编辑页面
- 运维：Docker 部署脚本

---

## 轮次分解

### 第 1 轮：数据库建表 (articles)
**负责人:** 酱肉 🍖  
**预计耗时:** 10 分钟  
**交付物:** `V2__create_articles_table.sql`

### 第 2 轮：Article 实体 + Mapper
**负责人:** 酱肉 🍖  
**预计耗时:** 15 分钟  
**交付物:** `Article.java`, `ArticleMapper.java`

### 第 3 轮：ArticleService + Controller
**负责人:** 酱肉 🍖  
**预计耗时:** 20 分钟  
**交付物:** `ArticleService.java`, `ArticleController.java`

### 第 4 轮：前端文章页面
**负责人:** 豆沙 🍡  
**预计耗时:** 30 分钟  
**交付物:** `ArticleList.vue`, `ArticleDetail.vue`, `ArticleEdit.vue`

### 第 5 轮：部署脚本 + 验证
**负责人:** 酸菜 🥬 + 灌汤 🍲  
**预计耗时:** 15 分钟  
**交付物:** `docker-compose.yml`, `deploy.sh`

---

## 验收标准

- [ ] 后端 Maven 编译通过
- [ ] 前端 npm 构建通过
- [ ] API 接口可正常调用
- [ ] 前端页面可正常访问
- [ ] Docker 部署脚本可用

---

## 依赖关系

- ✅ Plan-001 (Auth 模块) 已完成
- ⏳ Plan-003 (角色权限) - 后续计划

---

*最后更新：2026-03-26 08:26*
