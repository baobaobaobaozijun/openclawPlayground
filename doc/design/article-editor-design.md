# 文章编辑器模块设计

**版本:** v1.0  
**设计时间:** 2026-03-25 22:50  
**负责人:** 豆沙 🍡

---

## 📋 需求概述

在 ArticleEdit.vue 基础上，增强文章编辑功能，支持富文本编辑、图片上传、草稿自动保存。

---

## 🎨 技术方案

### 方案选择：Markdown 编辑器（轻量优先）

**选型理由：**
- 博客系统用户多为技术背景，Markdown 友好
- 轻量，无需复杂 WYSIWYG 依赖
- 后端存储纯文本，前端渲染即可

**推荐库：** `@uiw/react-md-editor` 或 `v-md-editor`（Vue 3 版）

**但考虑项目当前无 npm 依赖管理经验，采用原生 textarea + 预览模式（MVP 方案）**

---

## 📐 MVP 方案设计

### 1. 组件结构

```
ArticleEdit.vue
├── 标题输入框（大字体，placeholder="文章标题"）
├── 分类选择下拉框（调用 categoryApi.getList()）
├── 标签输入框（多选，逗号分隔）
├── 摘要输入框（textarea，3 行，placeholder="文章摘要"）
├── 编辑区域（左右分栏）
│   ├── 左侧：编辑区（textarea，高度 600px，monospace 字体）
│   └── 右侧：预览区（实时渲染 Markdown → HTML）
├── 底部操作栏
│   ├── "发布" 按钮（蓝色，主按钮）
│   ├── "保存草稿" 按钮（灰色）
│   └── "返回" 链接
└── 自动保存提示（右下角，"已自动保存于 HH:mm"）
```

### 2. 功能清单

| 功能 | 优先级 | 说明 |
|------|--------|------|
| Markdown 编辑 | P0 | 左侧 textarea 输入 |
| 实时预览 | P0 | 右侧渲染 HTML（用 marked.js 或简单替换） |
| 分类选择 | P0 | 下拉框，调用 categoryApi |
| 标签输入 | P1 | 文本框，逗号分隔，前端转数组 |
| 草稿自动保存 | P1 | 每 30 秒 localStorage 自动保存 |
| 图片上传 | P2 | 拖拽上传或点击上传，返回 URL 插入 Markdown |
| 字数统计 | P2 | 右下角显示"已输入 X 字" |

### 3. API 接口

```typescript
// @/api/article.ts
export const articleApi = {
  // 创建文章
  create(data: {
    title: string
    content: string
    summary: string
    categoryId: number
    tags?: string[]
    status: 'PUBLISHED' | 'DRAFT'
  }): Promise<Result<ArticleDTO>>

  // 更新文章
  update(id: number, data: {...}): Promise<Result<ArticleDTO>>

  // 获取文章详情（用于编辑）
  getById(id: number): Promise<Result<ArticleDTO>>

  // 自动保存草稿（可选）
  autoSave(data: {...}): Promise<Result<void>>
}
```

### 4. 路由设计

| 路由 | 用途 | 权限 |
|------|------|------|
| `/article/new` | 创建新文章 | 需登录 |
| `/article/:id/edit` | 编辑已有文章 | 需登录（作者或管理员） |

### 5. 样式要求

- 编辑区：`font-family: 'Consolas', 'Monaco', monospace; font-size: 14px; line-height: 1.6;`
- 预览区：`max-width: 800px; margin: 0 auto;`（模拟文章最终展示效果）
- 分栏布局：桌面端左右 50%-50%，移动端上下堆叠
- 自动保存提示：右下角 fixed 定位，淡入淡出动画

---

## 📦 依赖建议（可选）

如后续需要增强：
```json
{
  "dependencies": {
    "marked": "^12.0.0",
    "@types/marked": "^6.0.0"
  }
}
```

---

## ✅ 验收标准

- [ ] 编辑器页面可正常访问（`/article/new`）
- [ ] 左侧输入 Markdown，右侧实时预览 HTML
- [ ] 分类下拉框可正常选择
- [ ] 标签输入支持逗号分隔
- [ ] "发布"按钮调用 articleApi.create(status='PUBLISHED')
- [ ] "保存草稿"按钮调用 articleApi.create(status='DRAFT')
- [ ] 成功后跳转到 `/articles` 或文章详情页
- [ ] 自动保存功能（localStorage，每 30 秒）
- [ ] 响应式适配移动端

---

## 🚀 任务拆分（原子任务模式）

### Round 1: 基础编辑器
- 创建 ArticleEditor.vue 组件（左右分栏 + Markdown 预览）
- 集成到 ArticleEdit.vue

### Round 2: API 集成
- 完善 articleApi.create/update
- 分类/标签选择器
- 发布/草稿按钮功能

### Round 3: 增强功能
- 自动保存（localStorage）
- 图片上传（可选）
- 字数统计

---

*设计完成，等待任务派发*
