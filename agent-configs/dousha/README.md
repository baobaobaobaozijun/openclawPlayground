# 豆沙 (前端工程师/UIUX设计师) - 完整配置与知识库

🍡 **OpenClaw 前端负责人 / UI/UX设计师**

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

### 核心技术栈

```
框架：Vue 3.4+ (Composition API)
构建工具：Vite 5.x
语言：TypeScript 5.x
样式：SCSS + Tailwind CSS
状态管理：Pinia 2.x
UI 组件库：Element Plus / Ant Design Vue
HTTP 客户端：Axios
```

### 完整技术清单

| 类别 | 技术选型 | 版本 |
|------|---------|------|
| **前端框架** | Vue.js | 3.4+ |
| **开发语言** | TypeScript | 5.x |
| **构建工具** | Vite | 5.x |
| **状态管理** | Pinia | 2.x |
| **路由** | Vue Router | 4.x |
| **UI 框架** | Element Plus | 2.x |
| **CSS 框架** | Tailwind CSS | 3.x |
| **HTTP 库** | Axios | 1.x |
| **代码规范** | ESLint, Prettier | - |
| **测试** | Vitest, Vue Test Utils | - |

---

## 🎨 UI/UX设计原则

### 1. 色彩规范

```css
:root {
  /* 主色调 */
  --primary-50: #e3f2fd;
  --primary-500: #2196f3;
  --primary-700: #1976d2;
  
  /* 功能色 */
  --success: #4caf50;
  --warning: #ff9800;
  --error: #f44336;
  --info: #2196f3;
}
```

### 2. 响应式断点

```scss
// 移动优先
$breakpoints: (
  'sm': 640px,   // 小平板
  'md': 768px,   // 平板
  'lg': 1024px,  // 桌面
  'xl': 1280px   // 大屏
);

@mixin respond-to($breakpoint) {
  @media (min-width: map-get($breakpoints, $breakpoint)) {
    @content;
  }
}
```

### 3. 组件设计规范

#### 单文件组件结构

```vue
<template>
  <div class="article-card">
    <h2>{{ article.title }}</h2>
    <p>{{ article.summary }}</p>
  </div>
</template>

<script setup lang="ts">
import { defineProps, computed } from 'vue'

interface Article {
  id: number
  title: string
  summary: string
}

const props = defineProps<{
  article: Article
}>()

const formattedDate = computed(() => {
  return new Date(props.article.createdAt).toLocaleDateString('zh-CN')
})
</script>

<style scoped lang="scss">
.article-card {
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}
</style>
```

---

## 💻 前端开发最佳实践

### 1. Composition API 示例

```typescript
// composables/useArticles.ts
import { ref, computed } from 'vue'
import type { Ref } from 'vue'
import api from '@/api'

interface Article {
  id: number
  title: string
  content: string
}

export function useArticles() {
  const articles: Ref<Article[]> = ref([])
  const loading = ref(false)
  const error = ref<string | null>(null)
  
  const fetchArticles = async () => {
    loading.value = true
    try {
      const response = await api.getArticles()
      articles.value = response.data
    } catch (e) {
      error.value = e instanceof Error ? e.message : '加载失败'
    } finally {
      loading.value = false
    }
  }
  
  const publishedArticles = computed(() => 
    articles.value.filter(a => a.status === 'published')
  )
  
  return {
    articles,
    loading,
    error,
    fetchArticles,
    publishedArticles
  }
}
```

### 2. Pinia Store

```typescript
// stores/article.ts
import { defineStore } from 'pinia'

interface ArticleState {
  articles: Article[]
  loading: boolean
  error: string | null
}

export const useArticleStore = defineStore('article', {
  state: (): ArticleState => ({
    articles: [],
    loading: false,
    error: null
  }),
  
  getters: {
    articleCount: (state) => state.articles.length,
    publishedArticles: (state) => 
      state.articles.filter(a => a.status === 'published')
  },
  
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
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
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
    return Promise.reject(error)
  }
)

export default api
```

---

## ⚡ 性能优化

### 1. 懒加载路由

```typescript
// router/index.ts
const routes = [
  {
    path: '/articles',
    component: () => import('@/views/Articles.vue')
  },
  {
    path: '/about',
    component: () => import('@/views/About.vue')
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
import { onMounted, onUnmounted } from 'vue'

onMounted(() => {
  const timer = setInterval(updateData, 1000)
  window.addEventListener('resize', handleResize)
  
  onUnmounted(() => {
    clearInterval(timer)
    window.removeEventListener('resize', handleResize)
  })
})
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

*最后更新：2026-03-08*  
*维护者：豆沙Agent*
