# 前端设计文档规范（阿里风格）

**文档状态:** 模板  
**版本:** 1.0  
**创建日期:** 2026-03-12  
**参考:** 阿里巴巴前端设计文档规范

---

## 📋 文档信息

| 项目 | 值 |
|------|-----|
| 文档名称 | {项目名称} 前端设计文档 |
| 版本号 | v{版本号} |
| 创建人 | {作者姓名} |
| 创建日期 | YYYY-MM-DD |
| 最后更新 | YYYY-MM-DD |
| 技术负责人 | {姓名} |
| 产品负责人 | {姓名} |

---

## 1. 文档修订记录

| 版本 | 日期 | 修订人 | 修订说明 | 审批人 |
|------|------|--------|----------|--------|
| v1.0 | YYYY-MM-DD | {姓名} | 初始版本 | {姓名} |
| v1.1 | YYYY-MM-DD | {姓名} | 新增 XX 页面设计 | {姓名} |

---

## 2. 设计概述

### 2.1 产品概述

> 简要描述产品的功能定位和目标用户

**示例:**
```
博客系统是一个轻量级内容管理平台，支持 Markdown 格式文章发布、
分类标签管理、用户权限控制等功能。目标用户为技术团队和个人博主。
```

### 2.2 设计目标

| 目标 | 说明 | 衡量指标 |
|------|------|----------|
| 功能完整 | 覆盖所有核心业务场景 | 需求覆盖率 100% |
| 性能优秀 | 快速加载和响应 | 首屏加载 < 2s |
| 易用性强 | 降低学习成本 | 新用户 5 分钟内完成首次发布 |
| 可维护性 | 代码规范、组件化 | 组件复用率 > 60% |

### 2.3 设计原则

1. **功能优先** - 聚焦核心功能，不追求过度设计
2. **简洁一致** - 统一的交互和视觉风格
3. **渐进增强** - 核心功能优先，高级功能可选
4. **移动优先** - 优先保证移动端体验

---

## 3. 技术架构

### 3.1 技术栈

| 层级 | 技术选型 | 版本 | 说明 |
|------|----------|------|------|
| 框架 | Vue 3 | 3.4+ | Composition API |
| 语言 | TypeScript | 5.x | 类型安全 |
| 构建 | Vite | 5.x | 快速构建 |
| UI 组件 | Element Plus | 2.x | 基础组件库 |
| 状态管理 | Pinia | 2.x | 全局状态 |
| 路由 | Vue Router | 4.x | 页面路由 |
| HTTP | Axios | 1.x | 请求封装 |

### 3.2 项目结构

```
code/frontend/
├── public/              # 静态资源
│   └── editor.md/       # Markdown 编辑器
├── src/
│   ├── main.ts          # 入口文件
│   ├── App.vue          # 根组件
│   ├── api/             # API 接口
│   │   ├── auth.ts      # 认证接口
│   │   ├── article.ts   # 文章接口
│   │   └── index.ts     # 统一导出
│   ├── components/      # 公共组件
│   │   ├── MarkdownEditor.vue
│   │   └── Pagination.vue
│   ├── views/           # 页面组件
│   │   ├── Home.vue
│   │   ├── ArticleDetail.vue
│   │   ├── Login.vue
│   │   └── ArticleEdit.vue
│   ├── router/          # 路由配置
│   │   └── index.ts
│   ├── stores/          # Pinia 状态
│   │   ├── user.ts
│   │   └── article.ts
│   ├── utils/           # 工具函数
│   │   ├── request.ts   # HTTP 封装
│   │   └── markdown.ts  # Markdown 渲染
│   └── types/           # TypeScript 类型
│       └── index.ts
├── package.json
├── vite.config.ts
└── tsconfig.json
```

### 3.3 目录规范

| 目录 | 用途 | 命名规范 |
|------|------|----------|
| api/ | API 接口封装 | 按业务模块命名 |
| components/ | 公共组件 | 大驼峰，如 `MarkdownEditor.vue` |
| views/ | 页面组件 | 大驼峰，如 `ArticleList.vue` |
| stores/ | 状态管理 | 按业务模块命名 |
| utils/ | 工具函数 | 小驼峰，如 `request.ts` |
| types/ | 类型定义 | 小驼峰，如 `index.ts` |

---

## 4. 页面设计

### 4.1 页面清单

| 页面名称 | 路由 | 权限 | 优先级 | 状态 |
|----------|------|------|--------|------|
| 首页 | `/` | 公开 | P0 | ✅ |
| 文章详情 | `/article/:id` | 公开/受限 | P0 | ✅ |
| 登录页 | `/login` | 公开 | P0 | ✅ |
| 文章编辑 | `/article/edit` | author/admin | P0 | ✅ |
| 文章管理 | `/article/manage` | author/admin | P1 | ⏳ |
| 管理后台 | `/admin` | admin | P1 | ⏳ |

### 4.2 页面详细设计

#### 4.2.1 首页（文章列表）

**路由:** `/`  
**权限:** 公开

**页面结构:**
```
┌─────────────────────────────────────┐
│           导航栏                     │
├─────────────────────────────────────┤
│  搜索框  [分类筛选] [标签筛选] [搜索] │
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐    │
│  │  文章卡片 1                   │    │
│  │  标题、摘要、作者、时间        │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │  文章卡片 2                   │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │  文章卡片 3                   │    │
│  └─────────────────────────────┘    │
├─────────────────────────────────────┤
│         分页器                       │
└─────────────────────────────────────┘
```

**组件结构:**
```vue
<!-- Home.vue -->
<template>
  <div class="home-page">
    <NavBar />
    <div class="content">
      <SearchBar 
        v-model:keyword="keyword"
        v-model:category="categoryId"
        v-model:tag="tagId"
        @search="handleSearch"
      />
      <ArticleList 
        :list="articleList"
        :loading="loading"
      />
      <Pagination 
        v-model:page="page"
        :total="total"
        @change="loadArticles"
      />
    </div>
  </div>
</template>
```

**API 调用:**
```typescript
// GET /api/v1/articles?page=1&pageSize=20&categoryId=1
const loadArticles = async () => {
  const res = await articleApi.getList({
    page: page.value,
    pageSize: 20,
    categoryId: categoryId.value,
    tagId: tagId.value,
    keyword: keyword.value
  })
  articleList.value = res.data.list
  total.value = res.data.pagination.total
}
```

**交互说明:**
- 搜索框支持关键词输入，点击搜索按钮触发查询
- 分类/标签下拉选择，选择后自动触发查询
- 点击文章卡片跳转到详情页
- 分页器支持页码跳转

---

#### 4.2.2 文章详情页

**路由:** `/article/:id`  
**权限:** 根据文章 access_level 决定

**页面结构:**
```
┌─────────────────────────────────────┐
│           导航栏                     │
├─────────────────────────────────────┤
│  ← 返回                             │
├─────────────────────────────────────┤
│           文章标题                   │
│   作者 | 发布时间 | 浏览数           │
├─────────────────────────────────────┤
│                                     │
│         文章正文（HTML 渲染）         │
│                                     │
├─────────────────────────────────────┤
│   分类：技术文章                     │
│   标签：Java, Spring Boot           │
├─────────────────────────────────────┤
│   [编辑] [删除]  (仅作者/管理员显示)  │
└─────────────────────────────────────┘
```

**组件结构:**
```vue
<!-- ArticleDetail.vue -->
<template>
  <div class="article-detail">
    <NavBar />
    <div class="content">
      <el-button @click="$router.back()">← 返回</el-button>
      <h1>{{ article.title }}</h1>
      <div class="meta">
        <span>{{ article.authorName }}</span>
        <span>{{ formatTime(article.publishedAt) }}</span>
        <span>浏览 {{ article.viewCount }}</span>
      </div>
      <div class="article-content" v-html="article.contentHtml" />
      <div class="tags">
        <el-tag v-for="tag in article.tags">{{ tag.name }}</el-tag>
      </div>
      <div class="actions" v-if="canEdit">
        <el-button @click="handleEdit">编辑</el-button>
        <el-button @click="handleDelete">删除</el-button>
      </div>
    </div>
  </div>
</template>
```

**API 调用:**
```typescript
// GET /api/v1/articles/:id
const loadArticle = async () => {
  const res = await articleApi.getById(route.params.id)
  article.value = res.data
}
```

**Markdown 渲染要求:**
- ✅ 支持代码块 + 语法高亮
- ✅ 支持表格展示
- ✅ 支持任务列表（复选框）
- ✅ 支持引用、分割线

---

#### 4.2.3 登录页

**路由:** `/login`  
**权限:** 公开

**页面结构:**
```
┌─────────────────────────────────────┐
│                                     │
│           博客系统                   │
│                                     │
│    ┌─────────────────────────┐     │
│    │      手机号登录          │     │
│    │                         │     │
│    │  [请输入手机号]          │     │
│    │                         │     │
│    │     [登录按钮]          │     │
│    │                         │     │
│    └─────────────────────────┘     │
│                                     │
└─────────────────────────────────────┘
```

**组件结构:**
```vue
<!-- Login.vue -->
<template>
  <div class="login-page">
    <h1>博客系统</h1>
    <el-form :model="form" :rules="rules" ref="formRef">
      <el-form-item prop="phone">
        <el-input 
          v-model="form.phone" 
          placeholder="请输入手机号"
          maxlength="11"
        />
      </el-form-item>
      <el-form-item>
        <el-button 
          type="primary" 
          :loading="loading"
          @click="handleLogin"
        >
          登录
        </el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script setup lang="ts">
const form = ref({ phone: '' })
const rules = {
  phone: [
    { required: true, message: '请输入手机号' },
    { pattern: /^1[3-9]\d{9}$/, message: '手机号格式错误' }
  ]
}

const handleLogin = async () => {
  await formRef.value.validate()
  loading.value = true
  try {
    const res = await authApi.login(form.value.phone)
    localStorage.setItem('token', res.data.token)
    localStorage.setItem('user', JSON.stringify(res.data.user))
    ElMessage.success('登录成功')
    router.push('/')
  } finally {
    loading.value = false
  }
}
</script>
```

---

#### 4.2.4 文章编辑页

**路由:** `/article/edit` (新建)  
**路由:** `/article/edit/:id` (编辑)  
**权限:** author/admin

**页面结构:**
```
┌─────────────────────────────────────────────┐
│  ← 返回                    [保存] [预览]    │
├─────────────────────────────────────────────┤
│  标题：[_______________________________]    │
├─────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐        │
│  │              │  │              │        │
│  │  Markdown    │  │   实时预览   │        │
│  │  编辑器      │  │              │        │
│  │              │  │              │        │
│  │              │  │              │        │
│  └──────────────┘  └──────────────┘        │
├─────────────────────────────────────────────┤
│  分类：[下拉选择]   标签：[多选]            │
│  访问级别：○ 公开 ○ 登录可见 ○ VIP         │
│  封面图：[_______________________________]  │
└─────────────────────────────────────────────┘
```

**组件结构:**
```vue
<!-- ArticleEdit.vue -->
<template>
  <div class="article-edit">
    <div class="header">
      <el-button @click="$router.back()">← 返回</el-button>
      <el-button @click="handleSave">保存</el-button>
      <el-button @click="handlePreview">预览</el-button>
    </div>
    <el-form :model="form">
      <el-form-item label="标题">
        <el-input v-model="form.title" />
      </el-form-item>
      <MarkdownEditor v-model="form.contentMd" />
      <el-form-item label="分类">
        <el-select v-model="form.categoryId">
          <el-option 
            v-for="cat in categories" 
            :key="cat.id"
            :label="cat.name"
            :value="cat.id"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="访问级别">
        <el-radio-group v-model="form.accessLevel">
          <el-radio :label="0">公开</el-radio>
          <el-radio :label="1">登录可见</el-radio>
          <el-radio :label="2">VIP</el-radio>
        </el-radio-group>
      </el-form-item>
    </el-form>
  </div>
</template>
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
  saveHTMLToTextarea: false,
  search: true,
  fullscreen: true,
  onload: function() {
    this.watch()
  }
}
```

---

## 5. 组件设计规范

### 5.1 组件分类

| 分类 | 说明 | 示例 |
|------|------|------|
| 基础组件 | 直接复用 UI 库组件 | el-button, el-input |
| 业务组件 | 封装业务逻辑 | ArticleList, MarkdownEditor |
| 布局组件 | 页面布局结构 | NavBar, Footer |

### 5.2 组件命名规范

```typescript
// ✅ 正确
MarkdownEditor.vue
ArticleList.vue
NavBar.vue

// ❌ 错误
markdown_editor.vue
article-list.vue
```

### 5.3 组件 Props 规范

```typescript
// ✅ 正确 - 使用 TypeScript 定义
interface Props {
  title: string
  loading?: boolean
  modelValue?: string
}

const props = withDefaults(defineProps<Props>(), {
  loading: false,
  modelValue: ''
})

// ❌ 错误 - 使用 Object 类型
defineProps({
  title: Object,
  loading: Boolean
})
```

---

## 6. 状态管理

### 6.1 Store 结构

```typescript
// stores/user.ts
import { defineStore } from 'pinia'

interface UserState {
  token: string | null
  user: UserInfo | null
}

export const useUserStore = defineStore('user', {
  state: (): UserState => ({
    token: localStorage.getItem('token'),
    user: JSON.parse(localStorage.getItem('user') || 'null')
  }),
  
  getters: {
    isLoggedIn: (state) => !!state.token,
    userRole: (state) => state.user?.role
  },
  
  actions: {
    setToken(token: string) {
      this.token = token
      localStorage.setItem('token', token)
    },
    logout() {
      this.token = null
      this.user = null
      localStorage.removeItem('token')
      localStorage.removeItem('user')
    }
  }
})
```

---

## 7. API 封装

### 7.1 HTTP 请求封装

```typescript
// utils/request.ts
import axios from 'axios'
import { ElMessage } from 'element-plus'
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
  response => {
    const { code, message, data } = response.data
    if (code === 0) {
      return data
    } else {
      ElMessage.error(message)
      return Promise.reject(new Error(message))
    }
  },
  error => {
    if (error.response?.status === 401) {
      localStorage.removeItem('token')
      router.push('/login')
    } else if (error.response?.status === 403) {
      ElMessage.error('权限不足')
    } else {
      ElMessage.error(error.message || '请求失败')
    }
    return Promise.reject(error)
  }
)

export default request
```

### 7.2 API 模块封装

```typescript
// api/article.ts
import request from '@/utils/request'

export interface Article {
  id: number
  title: string
  contentMd: string
  contentHtml: string
  categoryId: number
  tagIds: number[]
}

export interface ArticleListParams {
  page?: number
  pageSize?: number
  categoryId?: number
  tagId?: number
  keyword?: string
}

export const articleApi = {
  // 获取文章列表
  getList(params: ArticleListParams) {
    return request.get('/articles', { params })
  },
  
  // 获取文章详情
  getById(id: number) {
    return request.get(`/articles/${id}`)
  },
  
  // 创建文章
  create(data: Partial<Article>) {
    return request.post('/articles', data)
  },
  
  // 更新文章
  update(id: number, data: Partial<Article>) {
    return request.put(`/articles/${id}`, data)
  },
  
  // 删除文章
  delete(id: number) {
    return request.delete(`/articles/${id}`)
  }
}
```

---

## 8. 样式规范

### 8.1 CSS 命名规范

```scss
// ✅ 正确 - BEM 命名
.article-list {
  &__item {
    &--active { }
  }
}

// ❌ 错误
.articleList {
  .item {
    .active { }
  }
}
```

### 8.2 响应式断点

```scss
// 移动端优先
.container {
  padding: 16px;
  
  @media (min-width: 768px) {
    padding: 24px;
  }
  
  @media (min-width: 1024px) {
    padding: 32px;
    max-width: 1200px;
    margin: 0 auto;
  }
}
```

---

## 9. 构建部署

### 9.1 构建命令

```bash
# 安装依赖
npm install

# 开发环境
npm run dev

# 生产构建
npm run build

# 预览构建产物
npm run preview

# 类型检查
npm run type-check

# ESLint 检查
npm run lint
```

### 9.2 构建产物

```
dist/
├── index.html
├── assets/
│   ├── index-xxxxx.js
│   ├── index-xxxxx.css
│   └── editor.md/
└── favicon.ico
```

---

## 10. 验收标准

### 10.1 功能验收

- [ ] 所有 P0 页面能正常访问
- [ ] Markdown 编辑器正常工作
- [ ] Markdown 渲染正确（代码高亮、表格、任务列表）
- [ ] 登录功能正常
- [ ] 权限控制正确
- [ ] 文章 CRUD 功能正常

### 10.2 性能验收

- [ ] 首屏加载时间 < 2s
- [ ] 文章详情加载 < 1s
- [ ] 编辑器加载 < 1s
- [ ] Lighthouse 性能评分 > 80

### 10.3 代码质量

- [ ] TypeScript 无类型错误
- [ ] 无控制台错误
- [ ] ESLint 检查通过
- [ ] 组件有基本注释

---

## 11. 附录

### 11.1 术语表

| 术语 | 说明 |
|------|------|
| SPA | Single Page Application |
| SSR | Server Side Rendering |
| BEM | Block Element Modifier |

### 11.2 参考资料

- [Vue 3 官方文档](https://vuejs.org/)
- [Element Plus 文档](https://element-plus.org/)
- [Editor.md 文档](https://pandao.github.io/editor.md/)

---

**文档结束**
