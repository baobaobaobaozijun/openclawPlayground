<!-- Last Modified: 2026-03-27 -->

# 工作日志

## 修改信息
- **修改人:** 酱肉
- **修改时间:** 2026-03-27 14:03:00
- **任务类型:** code

## 任务内容
修复文章创建 authorId 问题：从前端请求参数获取 authorId 改为从 JWT token 中解析获取

## 修改的文件
- `F:\openclaw\code\backend\src\main\java\com\openclaw\controller\ArticleController.java` - 修改 createArticle 方法，从 Authorization header 提取 Bearer token 并解析出 authorId

## 关联通知
- [ ] 已通知相关 Agent 更新配置
- [ ] 已推送到 GitHub

---

*日志自动生成*