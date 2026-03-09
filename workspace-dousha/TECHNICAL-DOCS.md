<!-- Last Modified: 2026-03-09 -->
<!-- Last Modified (CN): 2026-03-09 -->

# 豆沙 (Dousha) - 完整技术文档

🍡 **前端工程师 / UI/UX 设计师**

---

## 📎 快速导航

- [身份认知](./IDENTITY.md) - 我是谁？
- [职责规范](./ROLE.md) - 我做什么？
- [行为准则](./SOUL.md) - 我如何工作？
- [技术栈规范](#技术栈规范) - 使用什么技术？
- [开发最佳实践](#开发最佳实践) - 如何做？
- [常见问题与解决方案](#常见问题与解决) - 问题排查

---

## 🏢 Agent 身份

**名称:** 豆沙  
**角色:** 前端工程师 / UI/UX 设计师  
**职责:** 负责所有前端界面开发、UI/UX 设计、用户体验优化

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

### 3. API 调用规范

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
  
  if (to.meta.requiresAuth && !token) {
    next({ name: 'Login' })
  } else {
    next()
  }
})

export default router
```

---

## 🎨 UI/UX 设计规范

### 颜色系统

```css
/* 主色调 */
--color-primary: #007bff;
--color-primary-light: #3395ff;
--color-primary-dark: #0056b3;

/* 功能色 */
--color-success: #28a745;
--color-warning: #ffc107;
--color-danger: #dc3545;
--color-info: #17a2b8;

/* 中性色 */
--color-text-primary: #333333;
--color-text-secondary: #666666;
--color-text-disabled: #999999;
--color-border: #e0e0e0;
--color-background: #f5f5f5;
```

### 间距系统

```css
/* 基于 4px 的倍数 */
--spacing-xs: 4px;
--spacing-sm: 8px;
--spacing-md: 16px;
--spacing-lg: 24px;
--spacing-xl: 32px;
--spacing-2xl: 48px;
```

### 字体系统

```css
/* 字号 */
--font-size-xs: 12px;
--font-size-sm: 14px;
--font-size-md: 16px;
--font-size-lg: 18px;
--font-size-xl: 20px;
--font-size-2xl: 24px;

/* 字重 */
--font-weight-normal: 400;
--font-weight-medium: 500;
--font-weight-bold: 700;
```

---

## 📊 常见问题与解决

### Q1: 如何处理跨域问题？

**解决方案:**

在 `vite.config.ts` 中配置代理：

```typescript
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
   port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true,
       rewrite: (path) => path.replace(/^\/api/, '')
      }
    }
  }
})
```

### Q2: 如何实现权限控制？

**解决方案:**

```typescript
// 路由守卫
router.beforeEach(async (to, from, next) => {
  const token = localStorage.getItem('token')
  const userStore = useUserStore()
  
  // 需要登录的路由
  if (to.meta.requiresAuth && !token) {
    next({ name: 'Login' })
   return
  }
  
  // 已有 token，获取用户信息
  if (token && !userStore.user) {
    try {
      await userStore.fetchUserInfo()
    } catch (error) {
      localStorage.removeItem('token')
      next({ name: 'Login' })
     return
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

**解决方案:**

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

2. **组件懒加载:**
```vue
<script setup lang="ts">
import { defineAsyncComponent } from 'vue'

const ChartComponent = defineAsyncComponent(
  () => import('@/components/ChartComponent.vue')
)
</script>
```

3. **图片懒加载:**
```vue
<img 
  v-lazy="article.coverImage" 
  :alt="article.title"
  loading="lazy"
/>
```

4. **Gzip 压缩:**
```typescript
// vite.config.ts
import compressionPlugin from 'vite-plugin-compression'

export default defineConfig({
  plugins: [
    vue(),
   compressionPlugin({
      algorithm: 'gzip',
      threshold: 10240
    })
  ]
})
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

---

*最后更新：2026-03-09*  
*维护者：豆沙 (Dousha)*  
*版本：1.0*
