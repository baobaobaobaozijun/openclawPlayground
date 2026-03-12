<!-- Last Modified: 2026-03-12 -->

# 包子铺博客系统 - 前端组件设计文档

**文档类型:** 技术规范  
**版本:** v1.0  
**创建日期:** 2026-03-12  
**负责人:** 豆沙 (前端)  
**审核:** 灌汤 (PM)

---

## 📋 组件架构概览

### 技术栈

| 组件 | 技术 | 版本 | 用途 |
|------|------|------|------|
| **框架** | Vue.js | 3.4+ | 前端框架 (Composition API) |
| **语言** | TypeScript | 5.x | 类型安全 |
| **构建** | Vite | 5.x | 快速构建工具 |
| **路由** | Vue Router | 4.x | 路由管理 |
| **状态** | Pinia | 2.x | 状态管理 |
| **UI** | Element Plus | 2.x | UI 组件库 |
| **样式** | Tailwind CSS | 3.x | 原子化 CSS |
| **HTTP** | Axios | 1.x | API 请求 |

---

## 🌲 组件树结构

```
App.vue (根组件)
│
├── RouterView
│   │
│   ├── Home.vue (首页)
│   │   ├── Header.vue
│   │   ├── ArticleList.vue
│   │   │   └── ArticleCard.vue
│   │   ├── Sidebar.vue
│   │   │   ├── CategoryTree.vue
│   │   │   └── TagCloud.vue
│   │   └── Footer.vue
│   │
│   ├── ArticleDetail.vue (文章详情)
│   │   ├── Header.vue
│   │   ├── ArticleContent.vue
│   │   │   └── MarkdownRenderer.vue
│   │   ├── CommentList.vue
│   │   │   └── CommentItem.vue
│   │   ├── CommentForm.vue
│   │   └── Footer.vue
│   │
│   ├── Category.vue (分类页)
│   │   ├── Header.vue
│   │   ├── ArticleList.vue
│   │   └── Footer.vue
│   │
│   ├── Tag.vue (标签页)
│   │   ├── Header.vue
│   │   ├── ArticleList.vue
│   │   └── Footer.vue
│   │
│   ├── About.vue (关于页)
│   │   ├── Header.vue
│   │   └── Footer.vue
│   │
│   └── admin/ (管理后台)
│       ├── Dashboard.vue (仪表盘)
│       │   ├── Header.vue
│       │   ├── Sidebar.vue
│       │   ├── StatCards.vue
│       │   └── RecentArticles.vue
│       │
│       ├── ArticleList.vue (文章管理)
│       │   ├── ArticleTable.vue
│       │   └── Pagination.vue
│       │
│       ├── ArticleEditor.vue (文章编辑)
│       │   ├── MarkdownEditor.vue
│       │   ├── CategorySelector.vue
│       │   ├── TagSelector.vue
│       │   └── PublishSettings.vue
│       │
│       ├── CategoryManage.vue (分类管理)
│       │   └── CategoryTreeEditor.vue
│       │
│       ├── TagManage.vue (标签管理)
│       │   └── TagList.vue
│       │
│       └── CommentManage.vue (评论管理)
│           └── CommentTable.vue
│
└── LoginModal.vue (登录弹窗 - 全局)
```

---

## 📁 目录结构

```
src/
├── main.ts                    # 应用入口
├── App.vue                    # 根组件
│
├── components/                # 组件目录
│   ├── common/               # 通用组件
│   │   ├── Header.vue        # 页头
│   │   ├── Footer.vue        # 页脚
│   │   ├── Sidebar.vue       # 侧边栏
│   │   ├── Pagination.vue    # 分页
│   │   ├── Loading.vue       # 加载动画
│   │   └── ErrorView.vue     # 错误页面
│   │
│   ├── article/              # 文章相关组件
│   │   ├── ArticleList.vue   # 文章列表
│   │   ├── ArticleCard.vue   # 文章卡片
│   │   ├── ArticleContent.vue # 文章内容
│   │   └── MarkdownRenderer.vue # Markdown 渲染
│   │
│   ├── category/             # 分类相关组件
│   │   ├── CategoryTree.vue  # 分类树
│   │   └── CategorySelector.vue # 分类选择器
│   │
│   ├── tag/                  # 标签相关组件
│   │   ├── TagCloud.vue      # 标签云
│   │   └── TagSelector.vue   # 标签选择器
│   │
│   ├── comment/              # 评论相关组件
│   │   ├── CommentList.vue   # 评论列表
│   │   ├── CommentItem.vue   # 评论项
│   │   └── CommentForm.vue   # 评论表单
│   │
│   └── admin/                # 管理后台组件
│       ├── StatCards.vue     # 统计卡片
│       ├── ArticleTable.vue  # 文章表格
│       ├── MarkdownEditor.vue # Markdown 编辑器
│       └── ...
│
├── views/                    # 页面组件
│   ├── Home.vue              # 首页
│   ├── ArticleDetail.vue     # 文章详情
│   ├── Category.vue          # 分类页
│   ├── Tag.vue               # 标签页
│   ├── About.vue             # 关于页
│   └── admin/                # 管理后台页面
│       ├── Dashboard.vue
│       ├── ArticleList.vue
│       ├── ArticleEditor.vue
│       └── ...
│
├── router/                   # 路由配置
│   └── index.ts
│
├── stores/                   # Pinia 状态管理
│   ├── article.ts            # 文章状态
│   ├── user.ts               # 用户状态
│   ├── site.ts               # 站点配置
│   └── index.ts
│
├── api/                      # API 客户端
│   ├── article.ts            # 文章 API
│   ├── category.ts           # 分类 API
│   ├── tag.ts                # 标签 API
│   ├── comment.ts            # 评论 API
│   ├── auth.ts               # 认证 API
│   └── index.ts
│
├── types/                    # TypeScript 类型定义
│   ├── article.ts
│   ├── category.ts
│   ├── tag.ts
│   ├── user.ts
│   └── index.ts
│
├── utils/                    # 工具函数
│   ├── request.ts            # Axios 封装
│   ├── format.ts             # 格式化函数
│   └── validate.ts           # 验证函数
│
├── assets/                   # 静态资源
│   ├── styles/               # 样式文件
│   │   ├── main.css          # 全局样式
│   │   └── variables.css     # CSS 变量
│   └── images/               # 图片资源
│
└── composables/              # 组合式函数
    ├── useArticles.ts        # 文章相关逻辑
    ├── useAuth.ts            # 认证相关逻辑
    └── usePagination.ts      # 分页相关逻辑
```

---

## 🎨 页面设计

### 1. 首页 (Home.vue)

**布局结构:**
```
┌─────────────────────────────────────────┐
│              Header                      │
├─────────────────┬───────────────────────┤
│                 │                       │
│   ArticleList   │      Sidebar          │
│   (文章列表)     │   - 分类树             │
│   - 文章卡片     │   - 标签云            │
│   - 分页        │   - 热门文章          │
│                 │                       │
├─────────────────┴───────────────────────┤
│              Footer                      │
└─────────────────────────────────────────┘
```

**组件 Props:**
```typescript
// ArticleList.vue
interface Props {
  categoryId?: number      // 分类 ID 过滤
  tagId?: number          // 标签 ID 过滤
  keyword?: string        // 关键词搜索
  pageSize?: number       // 每页数量，默认 10
}

// ArticleCard.vue
interface Props {
  article: Article        // 文章对象
  showCategory?: boolean  // 是否显示分类，默认 true
  showTags?: boolean      // 是否显示标签，默认 true
}
```

**样式设计 (Tailwind):**
```vue
<template>
  <div class="container mx-auto px-4 py-8">
    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
      <!-- 文章列表 (占 2 列) -->
      <div class="md:col-span-2">
        <ArticleList />
      </div>
      
      <!-- 侧边栏 (占 1 列) -->
      <div class="md:col-span-1">
        <Sidebar />
      </div>
    </div>
  </div>
</template>
```

**响应式设计:**
- PC (≥768px): 2 列布局 (文章 + 侧边栏)
- Mobile (<768px): 单列布局 (侧边栏在底部)

---

### 2. 文章详情页 (ArticleDetail.vue)

**布局结构:**
```
┌─────────────────────────────────────────┐
│              Header                      │
├─────────────────────────────────────────┤
│                                         │
│            ArticleContent               │
│            (文章内容)                    │
│            - 标题                        │
│            - 作者/时间                  │
│            - 封面图                      │
│            - Markdown 内容               │
│            - 标签                        │
│                                         │
├─────────────────────────────────────────┤
│            CommentList                  │
│            (评论列表)                    │
│            - 评论项                      │
│            - 回复嵌套                    │
│                                         │
│            CommentForm                  │
│            (评论表单 - 需登录)           │
│                                         │
├─────────────────────────────────────────┤
│              Footer                      │
└─────────────────────────────────────────┘
```

**组件 Props:**
```typescript
// ArticleContent.vue
interface Props {
  article: Article
  showMeta?: boolean      // 是否显示元信息，默认 true
  showTags?: boolean      // 是否显示标签，默认 true
}

// CommentItem.vue
interface Props {
  comment: Comment
  maxDepth?: number       // 最大嵌套深度，默认 2
}
```

**Markdown 渲染:**
```vue
<template>
  <div class="prose prose-lg max-w-none">
    <div v-html="renderedContent"></div>
  </div>
</template>

<script setup lang="ts">
import { marked } from 'marked'
import hljs from 'highlight.js'

const props = defineProps<{
  content: string
}>()

const renderedContent = computed(() => {
  return marked(props.content, {
    highlight: (code, lang) => {
      return hljs.highlight(code, { language: lang || 'javascript' }).value
    }
  })
})
</script>

<style>
@import 'highlight.js/styles/github.css';
</style>
```

---

### 3. 管理后台 (admin/)

**布局结构:**
```
┌─────────────────────────────────────────┐
│              Header                      │
├──────────┬──────────────────────────────┤
│          │                              │
│ Sidebar  │        MainContent           │
│ (导航菜单)│        (页面内容)             │
│          │                              │
│ - 仪表盘  │                              │
│ - 文章管理│                              │
│ - 分类管理│                              │
│ - 标签管理│                              │
│ - 评论管理│                              │
│          │                              │
└──────────┴──────────────────────────────┘
```

**路由配置:**
```typescript
const adminRoutes: RouteRecordRaw[] = [
  {
    path: '/admin',
    name: 'AdminDashboard',
    component: () => import('@/views/admin/Dashboard.vue'),
    meta: { requiresAuth: true, role: 'ADMIN' }
  },
  {
    path: '/admin/articles',
    name: 'AdminArticles',
    component: () => import('@/views/admin/ArticleList.vue'),
    meta: { requiresAuth: true, role: 'ADMIN' }
  },
  {
    path: '/admin/articles/create',
    name: 'AdminArticleCreate',
    component: () => import('@/views/admin/ArticleEditor.vue'),
    meta: { requiresAuth: true, role: 'ADMIN' }
  },
  {
    path: '/admin/articles/:id/edit',
    name: 'AdminArticleEdit',
    component: () => import('@/views/admin/ArticleEditor.vue'),
    meta: { requiresAuth: true, role: 'ADMIN' }
  }
]
```

---

## 🔌 API 联调方案

### 1. Axios 封装

```typescript
// src/utils/request.ts
import axios from 'axios'
import type { AxiosInstance, AxiosRequestConfig, AxiosResponse } from 'axios'

const service: AxiosInstance = axios.create({
  baseURL: '/api',
  timeout: 10000
})

// 请求拦截器
service.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// 响应拦截器
service.interceptors.response.use(
  (response: AxiosResponse<ApiResponse<any>>) => {
    const { code, message, data } = response.data
    
    if (code === 200) {
      return data
    } else if (code === 401) {
      // Token 过期，跳转登录
      localStorage.removeItem('token')
      window.location.href = '/login'
      return Promise.reject(new Error(message))
    } else {
      ElMessage.error(message)
      return Promise.reject(new Error(message))
    }
  },
  (error) => {
    ElMessage.error('网络错误，请稍后重试')
    return Promise.reject(error)
  }
)

export default service
```

### 2. API 客户端封装

```typescript
// src/api/article.ts
import request from '@/utils/request'
import type { Article, ArticleListParams, ArticleListResponse } from '@/types'

export const articleApi = {
  // 获取文章列表
  getList(params: ArticleListParams) {
    return request<ArticleListResponse>({
      url: '/articles',
      method: 'get',
      params
    })
  },
  
  // 获取文章详情
  getById(id: number) {
    return request<Article>({
      url: `/articles/${id}`,
      method: 'get'
    })
  },
  
  // 创建文章
  create(data: Partial<Article>) {
    return request<Article>({
      url: '/articles',
      method: 'post',
      data
    })
  },
  
  // 更新文章
  update(id: number, data: Partial<Article>) {
    return request<Article>({
      url: `/articles/${id}`,
      method: 'put',
      data
    })
  },
  
  // 删除文章
  delete(id: number) {
    return request<void>({
      url: `/articles/${id}`,
      method: 'delete'
    })
  },
  
  // 发布文章
  publish(id: number) {
    return request<Article>({
      url: `/articles/${id}/publish`,
      method: 'post'
    })
  }
}
```

### 3. TypeScript 类型定义

```typescript
// src/types/article.ts
export interface Article {
  id: number
  title: string
  slug: string
  content: string
  contentHtml?: string
  summary: string
  coverImage?: string
  author: User
  categories: Category[]
  tags: Tag[]
  viewCount: number
  likeCount: number
  commentCount: number
  isTop: boolean
  isFeatured: boolean
  accessLevel: number
  status: 'DRAFT' | 'PUBLISHED' | 'ARCHIVED'
  publishedAt?: string
  createdAt: string
  updatedAt: string
}

export interface ArticleListParams {
  page?: number
  size?: number
  categoryId?: number
  tagId?: number
  keyword?: string
  sortBy?: string
  sortOrder?: 'asc' | 'desc'
}

export interface ArticleListResponse {
  list: Article[]
  pagination: {
    page: number
    size: number
    total: number
    totalPages: number
  }
}
```

### 4. 组合式函数封装

```typescript
// src/composables/useArticles.ts
import { ref, computed } from 'vue'
import { articleApi } from '@/api/article'
import type { Article, ArticleListParams } from '@/types'

export function useArticles() {
  const articles = ref<Article[]>([])
  const loading = ref(false)
  const error = ref('')
  const pagination = ref({
    page: 1,
    size: 10,
    total: 0,
    totalPages: 0
  })
  
  const fetchArticles = async (params: ArticleListParams = {}) => {
    loading.value = true
    error.value = ''
    
    try {
      const response = await articleApi.getList({
        page: params.page || pagination.value.page,
        size: params.size || pagination.value.size,
        ...params
      })
      
      articles.value = response.list
      pagination.value = response.pagination
    } catch (e: any) {
      error.value = e.message
    } finally {
      loading.value = false
    }
  }
  
  const fetchArticleById = async (id: number) => {
    loading.value = true
    error.value = ''
    
    try {
      return await articleApi.getById(id)
    } catch (e: any) {
      error.value = e.message
      return null
    } finally {
      loading.value = false
    }
  }
  
  return {
    articles,
    loading,
    error,
    pagination,
    fetchArticles,
    fetchArticleById
  }
}
```

---

## 📊 状态管理 (Pinia)

### 用户状态

```typescript
// src/stores/user.ts
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { authApi } from '@/api/auth'
import type { User, LoginParams } from '@/types'

export const useUserStore = defineStore('user', () => {
  const user = ref<User | null>(null)
  const token = ref<string | null>(localStorage.getItem('token'))
  
  const isLoggedIn = computed(() => !!token.value)
  const isAdmin = computed(() => user.value?.role === 'ADMIN')
  
  const login = async (params: LoginParams) => {
    const response = await authApi.login(params)
    token.value = response.token
    user.value = response.user
    localStorage.setItem('token', response.token)
  }
  
  const logout = () => {
    token.value = null
    user.value = null
    localStorage.removeItem('token')
  }
  
  const fetchUserInfo = async () => {
    if (!token.value) return
    
    try {
      user.value = await authApi.getMe()
    } catch {
      logout()
    }
  }
  
  return {
    user,
    token,
    isLoggedIn,
    isAdmin,
    login,
    logout,
    fetchUserInfo
  }
})
```

---

## 🧪 组件测试

### ArticleCard 组件测试

```typescript
// tests/unit/components/ArticleCard.spec.ts
import { mount } from '@vue/test-utils'
import { describe, it, expect } from 'vitest'
import ArticleCard from '@/components/article/ArticleCard.vue'
import type { Article } from '@/types'

const mockArticle: Article = {
  id: 1,
  title: '测试文章',
  slug: 'test-article',
  content: '...',
  summary: '测试摘要',
  author: { id: 1, username: 'admin', avatar: '...' },
  categories: [{ id: 1, name: '技术文章', slug: 'tech' }],
  tags: [{ id: 1, name: 'Java', slug: 'java', color: '#409EFF' }],
  viewCount: 100,
  likeCount: 10,
  commentCount: 5,
  isTop: true,
  isFeatured: false,
  accessLevel: 0,
  status: 'PUBLISHED',
  publishedAt: '2026-03-12T01:00:00Z',
  createdAt: '2026-03-12T00:00:00Z',
  updatedAt: '2026-03-12T00:00:00Z'
}

describe('ArticleCard', () => {
  it('renders article title correctly', () => {
    const wrapper = mount(ArticleCard, {
      props: { article: mockArticle }
    })
    
    expect(wrapper.find('.article-title').text()).toBe('测试文章')
  })
  
  it('displays view count', () => {
    const wrapper = mount(ArticleCard, {
      props: { article: mockArticle }
    })
    
    expect(wrapper.find('.view-count').text()).toContain('100')
  })
  
  it('shows top badge when isTop is true', () => {
    const wrapper = mount(ArticleCard, {
      props: { article: mockArticle }
    })
    
    expect(wrapper.find('.top-badge').exists()).toBe(true)
  })
})
```

---

## 📝 开发规范

### 1. 组件命名

- 文件名：PascalCase (如 `ArticleCard.vue`)
- 组件名：与文件名一致
- 目录名：kebab-case (如 `article/`)

### 2. Props 定义

```typescript
// ✅ 推荐：使用 defineProps with type
const props = defineProps<{
  article: Article
  showCategory?: boolean
}>()

// ❌ 不推荐：对象语法
defineProps({
  article: Object,
  showCategory: Boolean
})
```

### 3. 事件命名

```typescript
// 事件名：kebab-case
const emit = defineEmits<{
  (e: 'update:article', value: Article): void
  (e: 'delete', id: number): void
}>()

// 模板中使用
<ArticleCard @update:article="handleUpdate" @delete="handleDelete" />
```

### 4. 样式作用域

```vue
<style scoped>
/* 组件私有样式 */
.article-card {
  @apply rounded-lg shadow-md p-4;
}
</style>

<style>
/* 全局样式 (谨慎使用) */
.prose {
  /* Markdown 内容样式 */
}
</style>
```

---

**维护者:** 豆沙 (前端工程师)  
**更新日期:** 2026-03-12  
**版本:** v1.0
