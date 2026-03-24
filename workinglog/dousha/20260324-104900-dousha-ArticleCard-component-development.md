# ArticleCard 组件开发日志

**时间:** 2026-03-24 10:49

**任务:** 开发 ArticleCard 组件

## 完成内容

- 创建了 ArticleCard.vue 组件文件 (F:\openclaw\code\frontend\src\components\ArticleCard.vue)
- 实现了文章卡片的所有设计要求：
  - 左侧封面图 + 右侧内容的布局
  - 显示标题、摘要（最多2行截断）
  - 作者头像+名称显示
  - 分类标签和彩色Tags显示
  - 发布时间（相对时间格式）
  - 阅读量/点赞数/评论数统计
  - 置顶文章显示 📌 角标
  - 精选文章显示 ⭐ 角标
  - 鼠标 hover 上浮阴影效果
  - 点击卡片跳转到 `/article/${slug}`
  - 响应式设计（移动端上下布局）
  - TypeScript 类型定义
  - 图片加载错误处理

## 技术实现

- 使用 Vue 3 + TypeScript + `<script setup>`
- 定义了完整的 Article、Author、Category、Tag 接口类型
- 实现了时间格式化函数（如 "3 小时前"）
- 实现了数字格式化函数（如 1000 -> 1K）
- 添加了图片错误处理机制
- 使用 CSS 实现响应式布局

## 文件路径

- 组件文件: F:\openclaw\code\frontend\src\components\ArticleCard.vue