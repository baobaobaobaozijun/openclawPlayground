# 豆沙 (Dousha) - 完整技术文档

🍡 **前端工程师 / UI/UX设计师**

---

## 📚 快速导航

- [身份认知](./IDENTITY.md) - 我是谁
- [职责规范](./ROLE.md) - 我做什么
- [行为准则](./SOUL.md) - 我如何工作
- [技术栈规范](#技术栈规范) - 使用什么技术
- [设计原则](#uiux-设计原则) - 设计规范
- [开发最佳实践](#前端开发最佳实践) - 开发指南
- [常见问题解决](#常见问题与解决方案) - 问题排查

---

## 👤 Agent 身份

**名称:** 豆沙  
**角色:** 前端工程师 / UI/UX设计师  
**职责:** 负责所有前端界面的实现、UI/UX设计、交互优化

**核心配置文件:**
- [IDENTITY.md](./IDENTITY.md) - 身份认知
- [ROLE.md](./ROLE.md) - 职责规范
- [SOUL.md](./SOUL.md) - 行为准则

---

## 💻 技术栈规范

### 核心框架

| 技术 | 版本 | 用途 | 说明 |
|------|------|------|------|
| **Vue.js** | 3.4+ | 前端框架 | Composition API |
| **TypeScript** | 5.3+ | 编程语言 | 类型安全 |
| **Vite** | 5.0+ | 构建工具 | 极速开发体验 |
| **Pinia** | 2.1+ | 状态管理 | Vue 3 官方推荐 |

### UI 框架与组件库

| 技术 | 版本 | 用途 |
|------|------|------|
| **Element Plus** | 2.5+ | PC 端组件库 |
| **Vant** | 4.7+ | 移动端组件库 |
| **Tailwind CSS** | 3.4+ | 原子化 CSS |

### 工具链

| 技术 | 版本 | 用途 |
|------|------|------|
| **Vue Router** | 4.2+ | 路由管理 |
| **Axios** | 1.6+ | HTTP 客户端 |
| **ECharts** | 5.4+ | 数据可视化 |
| **Day.js** | 1.11+ | 日期处理 |

### 设计与协作工具

- **Figma** - UI 设计和原型
- **UnDraw** - 免费插图资源
- **IconFont** - 图标库
- **ColorHunt** - 配色方案

---

## 🏗️ 项目结构规范

```
frontend/
├── public/                 # 静态资源
│   ├── favicon.ico
│   └── logo.png
├── src/
│   ├── assets/            # 项目资源
│   │   ├── images/
│   │   ├── fonts/
│   │   └── styles/       # 全局样式
│   ├── components/        # 公共组件
│   │   ├── common/       # 通用组件
│   │   └── business/     # 业务组件
│   ├── views/            # 页面组件
│   │   ├── home/
│   │   ├── article/
│   │   └── user/
│   ├── router/           # 路由配置
│   │   └── index.ts
│   ├── stores/           # Pinia 状态管理
│   │   ├── user.ts
│   │   └── article.ts
│   ├── api/              # API 接口
│   │   ├── article.ts
│   │   └── user.ts
│   ├── utils/            # 工具函数
│   │   ├── request.ts    # Axios 封装
│   │   └── validate.ts
│   ├── types/            # TypeScript 类型定义
│   │   └── index.ts
│   ├── App.vue          # 根组件
│   └── main.ts          # 入口文件
├── .env.development     # 开发环境变量
├── .env.production      # 生产环境变量
├── vite.config.ts       # Vite 配置
├── tsconfig.json        # TypeScript 配置
└── package.json         # 依赖配置
```

---

## 🔧 开发最佳实践

### 1. Vue 3 Composition API 规范

**✅ 好的写法:**
```typescript
<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useArticleStore } from '@/stores/article'
import type { Article } from '@/types'

// Props
const props = defineProps<{
  articleId: number
}>()

// Emits
const emit = defineEmits<{
  (e: 'update', value: Article): void
}>()

// 响应式数据
const loading = ref(false)
const article = ref<Article | null>(null)

// Store
const articleStore = useArticleStore()

// 计算属性
const articleTitle = computed(() => {
 return article.value?.title || '未命名'
})

// 方法
async function fetchArticle() {
  loading.value = true
  try {
    article.value = await articleStore.getById(props.articleId)
  } finally {
    loading.value = false
  }
}

// 生命周期
onMounted(() => {
  fetchArticle()
})
</script>

<template>
  <div class="article-detail">
    <h1>{{ articleTitle }}</h1>
  </div>
</template>
```

### 2. 组件设计规范

**基础组件示例:**
```vue
<!-- src/components/common/BaseButton.vue -->
<script setup lang="ts">
import type { ButtonType } from '@/types'

interface Props {
  type?: ButtonType // 'primary' | 'success' | 'warning' | 'danger'
  size?: 'small' | 'medium' | 'large'
  disabled?: boolean
  loading?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  type: 'primary',
  size: 'medium',
  disabled: false,
  loading: false
})

defineEmits<{
  click: [event: MouseEvent]
}>()
</script>

<template>
  <button
    :class="['base-button', type, size]"
    :disabled="disabled || loading"
    @click="$emit('click', $event)"
  >
    <span v-if="loading" class="loading-spinner">Loading...</span>
    <slot />
  </button>
</template>

<style scoped>
.base-button {
  padding: 8px 16px;
  border-radius: 4px;
 font-weight: 500;
  transition: all 0.3s;
}

.primary {
  background-color: #007bff;
  color: white;
}

.primary:hover:not(:disabled) {
  background-color: #0056b3;
}
</style>
```

---

## 💻 前端开发最佳实践

### 1. Composition API 示例

**API 封装:**
```typescript
// src/api/article.ts
import request from '@/utils/request'
import type { Article, CreateArticleRequest, UpdateArticleRequest } from '@/types'

export const articleApi = {
  // 获取文章列表
  getList(params: { page: number; size: number }) {
   return request.get<Article[]>('/api/v1/articles', { params })
  },

  // 获取单篇文章
  getById(id: number) {
   return request.get<Article>(`/api/v1/articles/${id}`)
  },

  // 创建文章
 create(data: CreateArticleRequest) {
   return request.post<Article>('/api/v1/articles', data)
  },

  // 更新文章
  update(id: number, data: UpdateArticleRequest) {
   return request.put<Article>(`/api/v1/articles/${id}`, data)
  },

  // 删除文章
  delete(id: number) {
   return request.delete(`/api/v1/articles/${id}`)
  }
}
```

**使用示例:**
```vue
<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { articleApi } from '@/api/article'
import type { Article } from '@/types'

const articles = ref<Article[]>([])
const loading = ref(false)

async function loadArticles() {
  loading.value = true
  try {
   const response = await articleApi.getList({ page: 1, size: 10 })
    articles.value = response.data
  } catch (error) {
   console.error('加载文章失败:', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadArticles()
})
</script>
```

### 4. 状态管理规范 (Pinia)

```typescript
// src/stores/article.ts
import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { Article } from '@/types'
import { articleApi } from '@/api/article'

export const useArticleStore = defineStore('article', () => {
  // State
  const articles = ref<Article[]>([])
  const currentArticle = ref<Article | null>(null)
  const loading = ref(false)

  // Actions
  async function fetchAll() {
    loading.value = true
    try {
     const response = await articleApi.getList({ page: 1, size: 100 })
      articles.value = response.data
    } catch (e) {
      error.value = e instanceof Error ? e.message : '加载失败'
    } finally {
      loading.value = false
    }
  }

  async function fetchById(id: number) {
    loading.value = true
    try {
     const article = await articleApi.getById(id)
      currentArticle.value = article
     return article
    } finally {
      loading.value = false
    }
  }

  async function createArticle(data: CreateArticleRequest) {
   const article = await articleApi.create(data)
    articles.value.unshift(article)
   return article
  }

  // Reset
  function reset() {
    articles.value = []
    currentArticle.value = null
    loading.value = false
  }

 return {
    // State
    articles,
    currentArticle,
    loading,
    // Actions
    fetchAll,
    fetchById,
   createArticle,
   reset
  }
})
```

### 5. 路由配置规范

```typescript
// src/router/index.ts
import { createRouter, createWebHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    name: 'Home',
   component: () => import('@/views/home/HomeView.vue'),
    meta: { title: '首页' }
  },
  {
    path: '/articles',
    name: 'ArticleList',
   component: () => import('@/views/article/ArticleList.vue'),
    meta: { title: '文章列表' }
  },
  {
    path: '/articles/:id',
    name: 'ArticleDetail',
   component: () => import('@/views/article/ArticleDetail.vue'),
    meta: { title: '文章详情' }
  },
  {
    path: '/login',
    name: 'Login',
   component: () => import('@/views/user/LoginView.vue'),
    meta: { requiresAuth: false }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token')
  
  actions: {
    async fetchArticles() {
      this.loading = true
      try {
        const response = await api.getArticles()
        this.articles = response.data
      } catch (error) {
        this.error = error instanceof Error ? error.message : '加载失败'
      } finally {
        this.loading = false
      }
    }
  }
})
```

### 3. API 封装

```typescript
// api/index.ts
import axios from 'axios'

const api = axios.create({
  baseURL: '/api',
  timeout: 10000
})

// 请求拦截器
api.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  const userStore = useUserStore()
  
  // 需要登录的路由
  if (to.meta.requiresAuth && !token) {
    next({ name: 'Login' })
   return
  }
  return config
})

// 响应拦截器
api.interceptors.response.use(
  response => response.data,
  error => {
    if (error.response?.status === 401) {
      // 未授权，跳转登录
      router.push('/login')
    }
  }
  
  // 检查角色权限
  if (to.meta.roles && !to.meta.roles.includes(userStore.user?.role)) {
    next({ name: '403' })
   return
  }
  
  next()
})
```

### Q3: 如何优化首屏加载速度？

## ⚡ 性能优化

### 1. 懒加载路由

1. **路由懒加载:**
```typescript
const routes = [
  {
    path: '/articles',
    name: 'ArticleList',
   component: () => import('@/views/article/ArticleList.vue')
  }
]
```

### 2. 虚拟列表

```vue
<template>
  <VirtualList
    :data-key="'id'"
    :data-sources="articles"
    :estimate-size="100"
  >
    <template #item="{ source }">
      <ArticleItem :article="source" />
    </template>
  </VirtualList>
</template>
```

### 3. 防抖节流

```typescript
import { debounce } from 'lodash-es'

// 搜索框防抖
const handleSearch = debounce((query: string) => {
  api.search(query)
}, 300)

// 滚动节流
const handleScroll = throttle(() => {
  loadMore()
}, 200)
```

---

## ⚠️ 常见问题与解决方案

### 问题 1: 跨域问题 (CORS)

**开发环境解决方案:**
```typescript
// vite.config.ts
export default {
  server: {
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true
      }
    }
  }
}
```

### 问题 2: 内存泄漏

**解决方案:**
```vue
<script setup lang="ts">
import { defineAsyncComponent } from 'vue'

const ChartComponent = defineAsyncComponent(
  () => import('@/components/ChartComponent.vue')
)
</script>
```

### 问题 3: 样式冲突

**解决方案:**
```vue
<!-- 使用 scoped -->
<style scoped lang="scss">
.title {
  color: blue;
}
</style>

<!-- 或使用 CSS Modules -->
<style module>
.title {
  color: blue;
}
</style>
```

---

## ✅ 检查清单

### 代码提交前检查

- [ ] TypeScript 类型检查通过（无编译错误）
- [ ] ESLint 检查通过
- [ ] Prettier 格式化完成
- [ ] 组件都有 Prop 类型定义
- [ ] 使用了 Composition API（不是 Options API）
- [ ] 没有 console.log（生产环境）
- [ ] 关键逻辑有单元测试

### 发布前检查

- [ ] 构建成功且无警告
- [ ] Bundle 体积分析完成
- [ ] Lighthouse 性能测试通过
- [ ] 跨浏览器测试通过
- [ ] 移动端适配测试通过
- [ ] 无障碍访问测试通过
## 📖 学习资源

### 官方文档
- [Vue 3 官方文档](https://vuejs.org/)
- [TypeScript 文档](https://www.typescriptlang.org/)
- [Vite 文档](https://vitejs.dev/)
- [Pinia 文档](https://pinia.vuejs.org/)

### 设计规范
- [Material Design](https://material.io/design)
- [Ant Design 规范](https://ant.design/)

---

*最后更新：2026-03-09*  
*维护者：豆沙 (Dousha)*  
*版本：1.0*
