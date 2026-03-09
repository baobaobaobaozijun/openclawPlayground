<!-- Last Modified: 2026-03-09 -->
<!-- Last Modified (CN): 2026-03-09 -->

# 璞嗘矙 (Dousha) - 瀹屾暣鎶€鏈枃妗?

馃崱 **鍓嶇宸ョ▼甯?/ UI/UX璁捐甯?*

---

## 馃摎 蹇€熷鑸?

- [韬唤璁ょ煡](./IDENTITY.md) - 鎴戞槸璋?
- [鑱岃矗瑙勮寖](./ROLE.md) - 鎴戝仛浠€涔?
- [琛屼负鍑嗗垯](./SOUL.md) - 鎴戝浣曞伐浣?
- [鎶€鏈爤瑙勮寖](#鎶€鏈爤瑙勮寖) - 浣跨敤浠€涔堟妧鏈?
- [璁捐鍘熷垯](#uiux-璁捐鍘熷垯) - 璁捐瑙勮寖
- [寮€鍙戞渶浣冲疄璺礭(#鍓嶇寮€鍙戞渶浣冲疄璺? - 寮€鍙戞寚鍗?
- [甯歌闂瑙ｅ喅](#甯歌闂涓庤В鍐虫柟妗? - 闂鎺掓煡

---

## 馃懁 Agent 韬唤

**鍚嶇О:** 璞嗘矙  
**瑙掕壊:** 鍓嶇宸ョ▼甯?/ UI/UX璁捐甯? 
**鑱岃矗:** 璐熻矗鎵€鏈夊墠绔晫闈㈢殑瀹炵幇銆乁I/UX璁捐銆佷氦浜掍紭鍖?

**鏍稿績閰嶇疆鏂囦欢:**
- [IDENTITY.md](./IDENTITY.md) - 韬唤璁ょ煡
- [ROLE.md](./ROLE.md) - 鑱岃矗瑙勮寖
- [SOUL.md](./SOUL.md) - 琛屼负鍑嗗垯

---

## 馃捇 鎶€鏈爤瑙勮寖

### 鏍稿績鎶€鏈爤

```
妗嗘灦锛歏ue 3.4+ (Composition API)
鏋勫缓宸ュ叿锛歏ite 5.x
璇█锛歍ypeScript 5.x
鏍峰紡锛歋CSS + Tailwind CSS
鐘舵€佺鐞嗭細Pinia 2.x
UI 缁勪欢搴擄細Element Plus / Ant Design Vue
HTTP 瀹㈡埛绔細Axios
```

### 瀹屾暣鎶€鏈竻鍗?

| 绫诲埆 | 鎶€鏈€夊瀷 | 鐗堟湰 |
|------|---------|------|
| **鍓嶇妗嗘灦** | Vue.js | 3.4+ |
| **寮€鍙戣瑷€** | TypeScript | 5.x |
| **鏋勫缓宸ュ叿** | Vite | 5.x |
| **鐘舵€佺鐞?* | Pinia | 2.x |
| **璺敱** | Vue Router | 4.x |
| **UI 妗嗘灦** | Element Plus | 2.x |
| **CSS 妗嗘灦** | Tailwind CSS | 3.x |
| **HTTP 搴?* | Axios | 1.x |
| **浠ｇ爜瑙勮寖** | ESLint, Prettier | - |
| **娴嬭瘯** | Vitest, Vue Test Utils | - |

---

## 馃帹 UI/UX璁捐鍘熷垯

### 1. 鑹插僵瑙勮寖

```css
:root {
  /* 涓昏壊璋?*/
  --primary-50: #e3f2fd;
  --primary-500: #2196f3;
  --primary-700: #1976d2;
  
  /* 鍔熻兘鑹?*/
  --success: #4caf50;
  --warning: #ff9800;
  --error: #f44336;
  --info: #2196f3;
}
```

### 2. 鍝嶅簲寮忔柇鐐?

```scss
// 绉诲姩浼樺厛
$breakpoints: (
  'sm': 640px,   // 灏忓钩鏉?
  'md': 768px,   // 骞虫澘
  'lg': 1024px,  // 妗岄潰
  'xl': 1280px   // 澶у睆
);

@mixin respond-to($breakpoint) {
  @media (min-width: map-get($breakpoints, $breakpoint)) {
    @content;
  }
}
```

### 3. 缁勪欢璁捐瑙勮寖

#### 鍗曟枃浠剁粍浠剁粨鏋?

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

## 馃捇 鍓嶇寮€鍙戞渶浣冲疄璺?

### 1. Composition API 绀轰緥

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
      error.value = e instanceof Error ? e.message : '鍔犺浇澶辫触'
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
        this.error = error instanceof Error ? error.message : '鍔犺浇澶辫触'
      } finally {
        this.loading = false
      }
    }
  }
})
```

### 3. API 灏佽

```typescript
// api/index.ts
import axios from 'axios'

const api = axios.create({
  baseURL: '/api',
  timeout: 10000
})

// 璇锋眰鎷︽埅鍣?
api.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// 鍝嶅簲鎷︽埅鍣?
api.interceptors.response.use(
  response => response.data,
  error => {
    if (error.response?.status === 401) {
      // 鏈巿鏉冿紝璺宠浆鐧诲綍
      router.push('/login')
    }
    return Promise.reject(error)
  }
)

export default api
```

---

## 鈿?鎬ц兘浼樺寲

### 1. 鎳掑姞杞借矾鐢?

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

### 2. 铏氭嫙鍒楄〃

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

### 3. 闃叉姈鑺傛祦

```typescript
import { debounce } from 'lodash-es'

// 鎼滅储妗嗛槻鎶?
const handleSearch = debounce((query: string) => {
  api.search(query)
}, 300)

// 婊氬姩鑺傛祦
const handleScroll = throttle(() => {
  loadMore()
}, 200)
```

---

## 鈿狅笍 甯歌闂涓庤В鍐虫柟妗?

### 闂 1: 璺ㄥ煙闂 (CORS)

**寮€鍙戠幆澧冭В鍐虫柟妗?**
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

### 闂 2: 鍐呭瓨娉勬紡

**瑙ｅ喅鏂规:**
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

### 闂 3: 鏍峰紡鍐茬獊

**瑙ｅ喅鏂规:**
```vue
<!-- 浣跨敤 scoped -->
<style scoped lang="scss">
.title {
  color: blue;
}
</style>

<!-- 鎴栦娇鐢?CSS Modules -->
<style module>
.title {
  color: blue;
}
</style>
```

---

## 馃摉 瀛︿範璧勬簮

### 瀹樻柟鏂囨。
- [Vue 3 瀹樻柟鏂囨。](https://vuejs.org/)
- [TypeScript 鏂囨。](https://www.typescriptlang.org/)
- [Vite 鏂囨。](https://vitejs.dev/)
- [Pinia 鏂囨。](https://pinia.vuejs.org/)

### 璁捐瑙勮寖
- [Material Design](https://material.io/design)
- [Ant Design 瑙勮寖](https://ant.design/)

---

*鏈€鍚庢洿鏂帮細2026-03-09*  
*缁存姢鑰咃細璞嗘矙Agent*

