<!-- Last Modified: 2026-03-08 -->
<!-- Last Modified (CN): 2026-03-08 -->

# 璞嗘矙 (鍓嶇) - 瀹屾暣鐭ヨ瘑搴?
## 馃摎 鐭ヨ瘑搴撶洰褰?
- [韬唤璁ょ煡](./IDENTITY.md)
- [鑱岃矗瑙勮寖](./ROLE.md)
- [琛屼负鍑嗗垯](./SOUL.md)
- [鍓嶇寮€鍙戞渶浣冲疄璺礭(./frontend-best-practices.md)
- [UI/UX璁捐鍘熷垯](./ui-ux-design-principles.md)
- [缁勪欢搴撳缓璁炬寚鍗梋(./component-library-guide.md)
- [鎬ц兘浼樺寲瀹炴垬](./performance-optimization.md)
- [甯歌闂涓庤В鍐虫柟妗圿(./common-issues-solutions.md)

---

## 馃帹 UI/UX璁捐鍘熷垯

### 1. 璁捐绯荤粺鍩虹

#### 鑹插僵瑙勮寖
```css
:root {
  /* 涓昏壊璋?*/
  --primary-50: #e3f2fd;
  --primary-100: #bbdefb;
  --primary-500: #2196f3;  /* 涓昏壊 */
  --primary-700: #1976d2;
  
  /* 鍔熻兘鑹?*/
  --success: #4caf50;
  --warning: #ff9800;
  --error: #f44336;
  --info: #2196f3;
  
  /* 涓€ц壊 */
  --gray-100: #f5f5f5;
  --gray-500: #9e9e9e;
  --gray-900: #212121;
}
```

#### 瀛椾綋鎺掑嵃
```css
:root {
  /* 瀛楀彿 */
  --text-xs: 0.75rem;    /* 12px */
  --text-sm: 0.875rem;   /* 14px */
  --text-base: 1rem;     /* 16px */
  --text-lg: 1.125rem;   /* 18px */
  --text-xl: 1.25rem;    /* 20px */
  
  /* 瀛楅噸 */
  --font-normal: 400;
  --font-medium: 500;
  --font-bold: 700;
  
  /* 琛岄珮 */
  --leading-tight: 1.25;
  --leading-normal: 1.5;
  --leading-relaxed: 1.75;
}
```

### 2. 鍝嶅簲寮忚璁¤鑼?
#### 鏂偣璁剧疆
```css
/* 绉诲姩浼樺厛 */
@media (min-width: 640px) { /* sm - 灏忓钩鏉?*/ }
@media (min-width: 768px) { /* md - 骞虫澘 */ }
@media (min-width: 1024px) { /* lg - 妗岄潰 */ }
@media (min-width: 1280px) { /* xl - 澶у睆妗岄潰 */ }
```

#### 鏍呮牸绯荤粺
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

### 3. 浜や簰璁捐鍘熷垯

#### 鍙嶉鏈哄埗
- 鉁?**鍗虫椂鍙嶉** - 鐢ㄦ埛鎿嶄綔鍚?100ms 鍐呯粰鍑鸿瑙夊弽棣?- 鉁?**鍔犺浇鐘舵€?* - 瓒呰繃 1 绉掔殑鎿嶄綔鏄剧ず鍔犺浇鎸囩ず鍣?- 鉁?**閿欒鎻愮ず** - 娓呮櫚璇存槑闂骞舵彁渚涜В鍐虫柟妗?- 鉁?**鎴愬姛纭** - 閲嶈鎿嶄綔瀹屾垚鍚庣粰浜堟槑纭彁绀?
#### 鍙闂€?(A11y)
```html
<!-- 鉁?鑹ソ鐨勮涔夊寲 -->
<button aria-label="鍏抽棴瀵硅瘽妗? aria-describedby="help-text">
  脳
</button>
<span id="help-text">鐐瑰嚮鍏抽棴褰撳墠瀵硅瘽妗?/span>

<!-- 鉂?閬垮厤浣跨敤鏃犺涔夌殑鍏冪礌 -->
<div onclick="closeDialog()">脳</div>
```

---

## 馃捇 鍓嶇寮€鍙戞渶浣冲疄璺?
### 1. Vue 3 缁勪欢寮€鍙戣鑼?
#### 鍗曟枃浠剁粍浠剁粨鏋?```vue
<template>
  <div class="article-card">
    <h2>{{ article.title }}</h2>
    <p>{{ article.summary }}</p>
  </div>
</template>

<script setup>
import { defineProps, computed } from 'vue'

// Props 瀹氫箟
const props = defineProps({
  article: {
    type: Object,
    required: true,
    validator: (value) => value.id && value.title
  }
})

// 璁＄畻灞炴€?const formattedDate = computed(() => {
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

### 2. 鐘舵€佺鐞嗘渶浣冲疄璺?
#### Pinia Store 璁捐
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

### 3. API 璋冪敤灏佽

#### 缁熶竴鐨勮姹傛嫤鎴櫒
```javascript
// utils/request.js
import axios from 'axios'

const request = axios.create({
  baseURL: '/api',
  timeout: 10000
})

// 璇锋眰鎷︽埅鍣?request.interceptors.request.use(
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

// 鍝嶅簲鎷︽埅鍣?request.interceptors.response.use(
  response => response.data,
  error => {
    if (error.response.status === 401) {
      // 鏈巿鏉冿紝璺宠浆鐧诲綍
      router.push('/login')
    }
    return Promise.reject(error)
  }
)

export default request
```

---

## 鈿?鎬ц兘浼樺寲瀹炴垬

### 1. 棣栧睆鍔犺浇浼樺寲

#### 浠ｇ爜鍒嗗壊
```javascript
// 璺敱鎳掑姞杞?const routes = [
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

#### 鍥剧墖浼樺寲
```vue
<template>
  <!-- 鎳掑姞杞?-->
  <img 
    :src="placeholder" 
    :data-src="imageUrl"
    loading="lazy"
    class="lazy-image"
  />
</template>

<script setup>
// 浣跨敤 Intersection Observer 瀹炵幇鎳掑姞杞?</script>
```

### 2. 娓叉煋鎬ц兘浼樺寲

#### 铏氭嫙鍒楄〃
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

#### 闃叉姈涓庤妭娴?```javascript
import { debounce } from 'lodash-es'

// 鎼滅储妗嗛槻鎶?const handleSearch = debounce((query) => {
  api.search(query)
}, 300)

// 婊氬姩浜嬩欢鑺傛祦
const handleScroll = throttle(() => {
  loadMore()
}, 200)
```

---

## 馃悰 甯歌闂涓庤В鍐虫柟妗?
### 闂 1: 鍐呭瓨娉勬紡

**甯歌鍘熷洜:**
- 鏈竻鐞嗙殑瀹氭椂鍣?- 鏈攢姣佺殑浜嬩欢鐩戝惉鍣?- 澶у瀷瀵硅薄鏈噴鏀?
**瑙ｅ喅鏂规:**
```javascript
// 鉁?鍦ㄧ粍浠跺嵏杞芥椂娓呯悊
onMounted(() => {
  const timer = setInterval(updateData, 1000)
  window.addEventListener('resize', handleResize)
  
  onUnmounted(() => {
    clearInterval(timer)
    window.removeEventListener('resize', handleResize)
  })
})
```

### 闂 2: 璺ㄥ煙闂 (CORS)

**寮€鍙戠幆澧冭В鍐虫柟妗?**
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

### 闂 3: 鏍峰紡鍐茬獊

**瑙ｅ喅鏂规:**
```vue
<!-- 鉁?浣跨敤 scoped 鎴?CSS Modules -->
<style scoped lang="scss">
.title {
  color: blue;
}
</style>

<!-- 鎴栦娇鐢?BEM 鍛藉悕 -->
<style>
.article-card__title {
  color: blue;
}
</style>
```

---

## 馃摉 瀛︿範璧勬簮

### 瀹樻柟鏂囨。
- [Vue 3 瀹樻柟鏂囨。](https://vuejs.org/)
- [Pinia 鐘舵€佺鐞哴(https://pinia.vuejs.org/)
- [Vite 鏋勫缓宸ュ叿](https://vitejs.dev/)

### 璁捐瑙勮寖
- [Material Design](https://material.io/design)
- [Ant Design 瑙勮寖](https://ant.design/docs/spec/introduce-cn)
- [Web Content Accessibility Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

---

*鏈€鍚庢洿鏂帮細2026-03-08*  
*缁存姢鑰咃細璞嗘矙Agent*

