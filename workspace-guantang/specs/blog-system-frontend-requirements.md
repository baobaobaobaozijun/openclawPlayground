# 博客系统前端需求文档 v2.0 (简化版)

**文档状态:** 已批准  
**创建日期:** 2026-03-12  
**最后更新:** 2026-03-12  
**负责人:** 豆沙 (前端)  
**版本:** 2.0

---

## 📋 核心原则

**⚠️ 重要：本系统聚焦功能实现，不追求 UI/UX 美观度**

- ✅ **功能优先** - 能用就行，不追求视觉效果
- ✅ **Markdown 兼容** - 确保编辑器、渲染、展示全流程支持 Markdown
- ✅ **响应式** - 能适配手机和桌面即可
- ❌ **不要过度设计** - 不需要动画、特效、复杂交互

---

## 技术栈

| 组件 | 技术选型 | 版本 | 说明 |
|------|----------|------|------|
| 框架 | Vue 3 | 3.4+ | Composition API |
| 语言 | TypeScript | 5.x | 类型安全 |
| 构建 | Vite | 5.x | 快速构建 |
| UI 组件 | Element Plus | 2.x | **仅使用基础组件** |
| Markdown 编辑器 | Editor.md | 1.5.0 | **核心组件** |
| Markdown 渲染 | marked + highlight.js | Latest | 渲染 + 代码高亮 |
| 状态管理 | Pinia | 2.x | - |
| 路由 | Vue Router | 4.x | - |
| HTTP | Axios | 1.x | - |

---

## 页面清单

### 必须实现的页面

| 页面 | 路由 | 权限 | 优先级 |
|------|------|------|--------|
| 首页（文章列表） | `/` | 公开 | P0 |
| 文章详情 | `/article/:id` | 公开/受限 | P0 |
| 登录页 | `/login` | 公开 | P0 |
| 文章编辑 | `/article/edit` | author/admin | P0 |
| 文章管理列表 | `/article/manage` | author/admin | P1 |
| 管理后台首页 | `/admin` | admin | P1 |

### 不需要实现的页面

- ❌ 个人中心页（功能简单，不需要独立页面）
- ❌ 设置页（无配置需求）
- ❌ 关于页（无此需求）
- ❌ 404 页（用浏览器默认即可）

---

## 页面详细需求

### 1. 首页（文章列表）

**路由:** `/`  
**权限:** 公开

**功能:**
- [ ] 展示文章列表（标题、摘要、作者、发布时间）
- [ ] 支持分页（上一页/下一页）
- [ ] 支持按分类筛选（下拉框）
- [ ] 支持按标签筛选（下拉框）
- [ ] 支持关键词搜索（搜索框）
- [ ] 点击文章标题跳转到详情页

**UI 要求:**
- 使用 Element Plus 的 `el-card` 展示文章
- 使用 `el-pagination` 做分页
- 使用 `el-select` 做分类/标签筛选
- **不需要封面图轮播、不需要复杂布局**

**API 调用:**
```
GET /api/v1/articles?page=1&pageSize=20&categoryId=1&tagId=2&keyword=xxx
```

**组件结构:**
```
src/views/Home.vue
├── 搜索栏 (el-input + el-button)
├── 筛选栏 (el-select x2)
├── 文章列表 (el-card x N)
└── 分页器 (el-pagination)
```

---

### 2. 文章详情页

**路由:** `/article/:id`  
**权限:** 根据文章 access_level 决定

**功能:**
- [ ] 展示文章标题、作者、发布时间
- [ ] **渲染 Markdown 内容为 HTML**
- [ ] **支持代码高亮**
- [ ] **支持表格展示**
- [ ] **支持任务列表（复选框）**
- [ ] 显示分类和标签
- [ ] 显示浏览量、点赞数
- [ ] 作者/管理员显示编辑和删除按钮

**UI 要求:**
- 使用 `el-article` 或简单 `div` 包裹内容
- Markdown 渲染内容用 `v-html` 绑定
- **不需要复杂的排版、不需要侧边栏**

**API 调用:**
```
GET /api/v1/articles/:id
```

**Markdown 渲染要求:**

必须支持的语法：
```markdown
# 标题
## 二级标题

**粗体** *斜体*

[链接](url)
![图片](url)

```java
// 代码块
public class Test {}
```

| 表格 | 列 2 |
|------|------|
| A    | B    |

- [x] 已完成的任务
- [ ] 未完成的任务

> 引用内容

---
```

**组件结构:**
```
src/views/ArticleDetail.vue
├── 文章标题 (h1)
├── 元信息 (作者、时间、分类、标签)
├── 文章内容 (div v-html="contentHtml")
├── 操作按钮 (编辑/删除，仅作者/管理员)
└── 返回按钮 (el-button)
```

---

### 3. 登录页

**路由:** `/login`  
**权限:** 公开

**功能:**
- [ ] 输入手机号（11 位）
- [ ] 点击登录按钮
- [ ] 登录成功后跳转到首页
- [ ] 显示错误提示（手机号格式错误等）

**UI 要求:**
- 使用 `el-form` + `el-input` + `el-button`
- **不需要验证码、不需要密码、不需要记住我**
- **不需要第三方登录**

**API 调用:**
```
POST /api/v1/auth/login
Body: { "phone": "13800138000" }
```

**组件结构:**
```
src/views/Login.vue
└── 登录表单 (el-form)
    ├── 手机号输入 (el-input)
    └── 登录按钮 (el-button)
```

---

### 4. 文章编辑页

**路由:** `/article/edit` (新建)  
**路由:** `/article/edit/:id` (编辑)  
**权限:** author/admin

**功能:**
- [ ] **集成 Editor.md 编辑器**
- [ ] 支持 Markdown 实时预览
- [ ] 支持导入.md 文件
- [ ] 输入文章标题
- [ ] 选择分类（下拉框）
- [ ] 选择标签（多选框）
- [ ] 设置访问级别（单选框：公开/登录可见/VIP）
- [ ] 输入封面图 URL（可选）
- [ ] 保存按钮（发布文章）
- [ ] 预览按钮（弹窗预览）

**UI 要求:**
- Editor.md 占据主要区域
- 表单项使用 `el-form`
- **不需要复杂的富文本工具栏**

**API 调用:**
```
新建：POST /api/v1/articles
编辑：PUT /api/v1/articles/:id
```

**Editor.md 配置:**
```javascript
{
  width: '100%',
  height: 600,
  path: '/editor.md/lib/',
  theme: 'default',
  previewTheme: 'default',
  codeFold: true,
  saveHTMLToTextarea: false, // 不需要，后端会渲染
  search: true,
  fullscreen: true,
  markdown: '', // 初始内容
  onload: function() {
    // 编辑器加载完成
  }
}
```

**组件结构:**
```
src/views/ArticleEdit.vue
├── 标题输入 (el-input)
├── Editor.md 编辑器 (div#editor)
├── 分类选择 (el-select)
├── 标签选择 (el-select multiple)
├── 访问级别 (el-radio-group)
├── 封面图 URL (el-input)
└── 操作按钮 (保存、预览)
```

---

### 5. 文章管理列表

**路由:** `/article/manage`  
**权限:** author/admin

**功能:**
- [ ] 展示自己/所有文章列表（管理员看所有）
- [ ] 支持编辑（跳转到编辑页）
- [ ] 支持删除（确认后删除）
- [ ] 支持新建（跳转到编辑页）

**UI 要求:**
- 使用 `el-table` 展示
- **不需要复杂操作**

**API 调用:**
```
GET /api/v1/articles?status=published&authorId=xxx
```

**组件结构:**
```
src/views/ArticleManage.vue
├── 新建按钮 (el-button)
├── 文章表格 (el-table)
│   ├── 标题
│   ├── 分类
│   ├── 状态
│   ├── 发布时间
│   └── 操作列 (编辑/删除)
└── 分页器 (el-pagination)
```

---

### 6. 管理后台首页

**路由:** `/admin`  
**权限:** admin

**功能:**
- [ ] 展示简单的统计信息（文章数、用户数）
- [ ] 展示最近的文章列表
- [ ] **不需要复杂的 Dashboard、图表**

**UI 要求:**
- 使用 `el-card` 展示统计
- 使用 `el-table` 展示文章列表
- **不需要图表、不需要数据可视化**

**API 调用:**
```
GET /api/v1/admin/stats
GET /api/v1/articles?status=published&pageSize=10
```

---

## 核心功能详细要求

### Markdown 编辑器集成

**文件:** `src/components/MarkdownEditor.vue`

**要求:**
1. 使用 Editor.md 1.5.0
2. 支持实时预览（左右分栏）
3. 支持代码高亮
4. 支持导入.md 文件
5. 支持全屏编辑
6. 返回 Markdown 原文（给后端）

**代码示例:**
```vue
<template>
  <div>
    <div id="markdown-editor"></div>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'

const emit = defineEmits(['update:modelValue'])
const props = defineProps({
  modelValue: String
})

let editor = null

onMounted(() => {
  editor = editormarkdown('markdown-editor', {
    width: '100%',
    height: 600,
    path: '/editor.md/lib/',
    markdown: props.modelValue || '',
    codeFold: true,
    saveHTMLToTextarea: false,
    search: true,
    fullscreen: true,
    onload: function() {
      // 监听变化
      this.watch(() => {
        emit('update:modelValue', this.getMarkdown())
      })
    }
  })
})

defineExpose({
  getMarkdown: () => editor.getMarkdown()
})
</script>
```

---

### Markdown 渲染

**文件:** `src/utils/markdown.js`

**要求:**
1. 使用 marked 解析 Markdown
2. 使用 highlight.js 代码高亮
3. 支持表格、任务列表、引用等语法

**代码示例:**
```javascript
import marked from 'marked'
import hljs from 'highlight.js'
import 'highlight.js/styles/github.css'

// 配置 marked
marked.setOptions({
  highlight: function(code, lang) {
    if (lang && hljs.getLanguage(lang)) {
      return hljs.highlight(code, { language: lang }).value
    }
    return hljs.highlightAuto(code).value
  },
  breaks: true, // 支持换行
  gfm: true // GitHub 风格 Markdown
})

// 渲染函数
export function renderMarkdown(md) {
  return marked.parse(md)
}
```

---

### 认证拦截器

**文件:** `src/utils/request.js`

**要求:**
1. 所有请求自动添加 Token
2. 401 自动跳转登录
3. 403 显示权限不足提示

**代码示例:**
```javascript
import axios from 'axios'
import router from '@/router'

const request = axios.create({
  baseURL: '/api/v1',
  timeout: 10000
})

// 请求拦截器
request.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// 响应拦截器
request.interceptors.response.use(
  response => response.data,
  error => {
    if (error.response?.status === 401) {
      localStorage.removeItem('token')
      router.push('/login')
    } else if (error.response?.status === 403) {
      ElMessage.error('权限不足')
    }
    return Promise.reject(error)
  }
)

export default request
```

---

### 路由守卫

**文件:** `src/router/index.js`

**要求:**
1. 需要登录的页面自动检查 Token
2. 无 Token 跳转登录
3. 需要权限的页面检查角色

**代码示例:**
```javascript
import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  { path: '/', component: () => import('@/views/Home.vue') },
  { path: '/login', component: () => import('@/views/Login.vue') },
  { 
    path: '/article/edit', 
    component: () => import('@/views/ArticleEdit.vue'),
    meta: { requiresAuth: true, requiresRole: ['author', 'admin'] }
  },
  { 
    path: '/admin', 
    component: () => import('@/views/Admin.vue'),
    meta: { requiresAuth: true, requiresRole: ['admin'] }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token')
  const user = JSON.parse(localStorage.getItem('user') || '{}')
  
  if (to.meta.requiresAuth && !token) {
    next('/login')
  } else if (to.meta.requiresRole && !to.meta.requiresRole.includes(user.role)) {
    next('/403')
  } else {
    next()
  }
})

export default router
```

---

## 交付要求

### 必须交付的文件

```
code/frontend/
├── package.json
├── vite.config.ts
├── tsconfig.json
├── index.html
├── src/
│   ├── main.ts
│   ├── App.vue
│   ├── router/index.ts
│   ├── utils/
│   │   ├── request.js (HTTP 封装)
│   │   └── markdown.js (Markdown 渲染)
│   ├── components/
│   │   └── MarkdownEditor.vue (编辑器组件)
│   └── views/
│       ├── Home.vue (首页)
│       ├── ArticleDetail.vue (详情页)
│       ├── Login.vue (登录页)
│       ├── ArticleEdit.vue (编辑页)
│       ├── ArticleManage.vue (管理列表)
│       └── Admin.vue (管理后台)
└── public/
    └── editor.md/ (Editor.md 库)
```

### 构建要求

- [ ] `npm run build` 成功
- [ ] 构建产物在 `dist/` 目录
- [ ] 无 TypeScript 类型错误
- [ ] 无 ESLint 错误

### 功能测试清单

- [ ] 首页能正常展示文章列表
- [ ] 文章详情能正确渲染 Markdown（代码块、表格、任务列表）
- [ ] 登录功能正常（手机号登录）
- [ ] 编辑器能正常编辑 Markdown
- [ ] 保存文章成功
- [ ] 权限控制正确（未登录不能访问受限页面）

---

## 不需要实现的功能

**再次强调，以下功能不需要实现：**

- ❌ 评论系统
- ❌ 点赞功能（只展示数字即可）
- ❌ 收藏功能
- ❌ 分享功能
- ❌ 暗色模式
- ❌ 多语言支持
- ❌ 复杂的动画效果
- ❌ 响应式图片加载
- ❌ 无限滚动（用分页即可）
- ❌ 文章目录/大纲
- ❌ 阅读进度条
- ❌ 相关文章推荐

---

## 验收标准

### 功能验收

- [ ] 所有 P0 页面能正常访问
- [ ] Markdown 编辑器正常工作
- [ ] Markdown 渲染正确（代码高亮、表格、任务列表）
- [ ] 登录功能正常
- [ ] 权限控制正确
- [ ] 文章 CRUD 功能正常

### 代码质量

- [ ] TypeScript 无类型错误
- [ ] 无控制台错误
- [ ] 代码有基本注释
- [ ] 组件拆分合理

### 性能

- [ ] 首页加载时间 < 2s
- [ ] 文章详情加载时间 < 1s
- [ ] 编辑器加载时间 < 1s

---

**文档审批:**

| 角色 | 姓名 | 签字 | 日期 |
|------|------|------|------|
| PM | 灌汤 | - | 2026-03-12 |
| 前端 | 豆沙 | - | - |
| 测试 | 酸菜 | - | - |
