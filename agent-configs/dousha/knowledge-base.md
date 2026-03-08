# 豆沙 (前端) - 完整知识库

## 📚 知识库目录

- [身份认知](./IDENTITY.md)
- [职责规范](./ROLE.md)
- [行为准则](./SOUL.md)
- [前端开发最佳实践](./frontend-best-practices.md)
- [UI/UX设计原则](./ui-ux-design-principles.md)
- [组件库建设指南](./component-library-guide.md)
- [性能优化实战](./performance-optimization.md)
- [常见问题与解决方案](./common-issues-solutions.md)

---

## 🎨 UI/UX设计原则

### 1. 设计系统基础

#### 色彩规范
```css
:root {
  /* 主色调 */
  --primary-50: #e3f2fd;
  --primary-100: #bbdefb;
  --primary-500: #2196f3;  /* 主色 */
  --primary-700: #1976d2;
  
  /* 功能色 */
  --success: #4caf50;
  --warning: #ff9800;
  --error: #f44336;
  --info: #2196f3;
  
  /* 中性色 */
  --gray-100: #f5f5f5;
  --gray-500: #9e9e9e;
  --gray-900: #212121;
}
```

#### 字体排印
```css
:root {
  /* 字号 */
  --text-xs: 0.75rem;    /* 12px */
  --text-sm: 0.875rem;   /* 14px */
  --text-base: 1rem;     /* 16px */
  --text-lg: 1.125rem;   /* 18px */
  --text-xl: 1.25rem;    /* 20px */
  
  /* 字重 */
  --font-normal: 400;
  --font-medium: 500;
  --font-bold: 700;
  
  /* 行高 */
  --leading-tight: 1.25;
  --leading-normal: 1.5;
  --leading-relaxed: 1.75;
}
```

### 2. 响应式设计规范

#### 断点设置
```css
/* 移动优先 */
@media (min-width: 640px) { /* sm - 小平板 */ }
@media (min-width: 768px) { /* md - 平板 */ }
@media (min-width: 1024px) { /* lg - 桌面 */ }
@media (min-width: 1280px) { /* xl - 大屏桌面 */ }
```

#### 栅格系统
```css
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 1rem;
}

.grid {
  display: grid;
  gap: 1.5rem;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
}
```

### 3. 交互设计原则

#### 反馈机制
- ✅ **即时反馈** - 用户操作后 100ms 内给出视觉反馈
- ✅ **加载状态** - 超过 1 秒的操作显示加载指示器
- ✅ **错误提示** - 清晰说明问题并提供解决方案
- ✅ **成功确认** - 重要操作完成后给予明确提示

#### 可访问性 (A11y)
```html
<!-- ✅ 良好的语义化 -->
<button aria-label="关闭对话框" aria-describedby="help-text">
  ×
</button>
<span id="help-text">点击关闭当前对话框</span>

<!-- ❌ 避免使用无语义的元素 -->
<div onclick="closeDialog()">×</div>
```

---

## 💻 前端开发最佳实践

### 1. Vue 3 组件开发规范

#### 单文件组件结构
```vue
<template>
  <div class="article-card">
    <h2>{{ article.title }}</h2>
    <p>{{ article.summary }}</p>
  </div>
</template>

<script setup>
import { defineProps, computed } from 'vue'

// Props 定义
const props = defineProps({
  article: {
    type: Object,
    required: true,
    validator: (value) => value.id && value.title
  }
})

// 计算属性
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

### 2. 状态管理最佳实践

#### Pinia Store 设计
```javascript
// stores/article.js
import { defineStore } from 'pinia'

export const useArticleStore = defineStore('article', {
  state: () => ({
    articles: [],
    loading: false,
    error: null
  }),
  
  getters: {
    publishedArticles: (state) => state.articles.filter(a => a.status === 'published'),
    articleCount: (state) => state.articles.length
  },
  
  actions: {
    async fetchArticles() {
      this.loading = true
      try {
        const response = await api.getArticles()
        this.articles = response.data
      } catch (error) {
        this.error = error.message
      } finally {
        this.loading = false
      }
    }
  }
})
```

### 3. API 调用封装

#### 统一的请求拦截器
```javascript
// utils/request.js
import axios from 'axios'

const request = axios.create({
  baseURL: '/api',
  timeout: 10000
})

// 请求拦截器
request.interceptors.request.use(
  config => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// 响应拦截器
request.interceptors.response.use(
  response => response.data,
  error => {
    if (error.response.status === 401) {
      // 未授权，跳转登录
      router.push('/login')
    }
    return Promise.reject(error)
  }
)

export default request
```

---

## ⚡ 性能优化实战

### 1. 首屏加载优化

#### 代码分割
```javascript
// 路由懒加载
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

#### 图片优化
```vue
<template>
  <!-- 懒加载 -->
  <img 
    :src="placeholder" 
    :data-src="imageUrl"
    loading="lazy"
    class="lazy-image"
  />
</template>

<script setup>
// 使用 Intersection Observer 实现懒加载
</script>
```

### 2. 渲染性能优化

#### 虚拟列表
```vue
<template>
  <virtual-list
    :data-key="'id'"
    :data-sources="articles"
    :estimate-size="100"
  >
    <template #item="{ source }">
      <article-item :article="source" />
    </template>
  </virtual-list>
</template>
```

#### 防抖与节流
```javascript
import { debounce } from 'lodash-es'

// 搜索框防抖
const handleSearch = debounce((query) => {
  api.search(query)
}, 300)

// 滚动事件节流
const handleScroll = throttle(() => {
  loadMore()
}, 200)
```

---

## 🐛 常见问题与解决方案

### 问题 1: 内存泄漏

**常见原因:**
- 未清理的定时器
- 未销毁的事件监听器
- 大型对象未释放

**解决方案:**
```javascript
// ✅ 在组件卸载时清理
onMounted(() => {
  const timer = setInterval(updateData, 1000)
  window.addEventListener('resize', handleResize)
  
  onUnmounted(() => {
    clearInterval(timer)
    window.removeEventListener('resize', handleResize)
  })
})
```

### 问题 2: 跨域问题 (CORS)

**开发环境解决方案:**
```javascript
// vite.config.js
export default {
  server: {
    proxy: {
      '/api': {
        target: 'http://localhost:8000',
        changeOrigin: true
      }
    }
  }
}
```

### 问题 3: 样式冲突

**解决方案:**
```vue
<!-- ✅ 使用 scoped 或 CSS Modules -->
<style scoped lang="scss">
.title {
  color: blue;
}
</style>

<!-- 或使用 BEM 命名 -->
<style>
.article-card__title {
  color: blue;
}
</style>
```

---

## 📖 学习资源

### 官方文档
- [Vue 3 官方文档](https://vuejs.org/)
- [Pinia 状态管理](https://pinia.vuejs.org/)
- [Vite 构建工具](https://vitejs.dev/)

### 设计规范
- [Material Design](https://material.io/design)
- [Ant Design 规范](https://ant.design/docs/spec/introduce-cn)
- [Web Content Accessibility Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

---

*最后更新：2026-03-08*  
*维护者：豆沙Agent*
