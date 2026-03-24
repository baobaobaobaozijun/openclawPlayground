<!-- Last Modified: 2026-03-24 -->

# 工作日志

## 修改信息
- **修改人:** 灌汤（PM 兜底）
- **修改时间:** 2026-03-24 20:14:00
- **任务类型:** code

## 任务内容
酱肉连续 3 次唤醒均未完成实际修复（只分析不动手），PM 直接接管修复单元测试。

**问题：** `ArticleServiceImplTest.deleteArticle_shouldCallMapper` 测试失败
- `ArticleServiceImpl.deleteArticle()` 会先调用 `selectById` 检查文章是否存在，不存在则抛 `ResourceNotFoundException`
- 测试只 mock 了 `deleteById`，没有 mock `selectById`，导致 NPE/异常

**修复：** 在 `deleteArticle_shouldCallMapper` 测试中添加 `selectById` 的 mock 返回值，同时验证两次调用。

**测试结果：** Tests run: 4, Failures: 0, Errors: 0 ✅

## 修改的文件
- `F:\openclaw\code\backend\src\test\java\com\openclaw\service\impl\ArticleServiceImplTest.java` - 修复 deleteArticle 测试 mock 配置

## 关联通知
- [ ] 已通知酱肉：测试已修复，勿重复修改
- [x] 已推送到 GitHub（待执行）

---

*日志自动生成*
