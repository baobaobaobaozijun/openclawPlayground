<template>
  <div class="app-layout">
    <!-- 顶部导航栏 -->
    <header class="navbar">
      <div class="navbar-container">
        <div class="logo-section">
          <router-link to="/" class="logo">
            <img src="/logo.svg" alt="Logo" class="logo-img" />
            <span class="logo-text">{{ siteConfig.siteName }}</span>
          </router-link>
        </div>
        
        <nav class="nav-menu">
          <ul class="nav-list">
            <li class="nav-item">
              <router-link to="/" class="nav-link">首页</router-link>
            </li>
            <li class="nav-item">
              <router-link to="/articles" class="nav-link">文章</router-link>
            </li>
            <li class="nav-item">
              <router-link to="/categories" class="nav-link">分类</router-link>
            </li>
            <li class="nav-item">
              <router-link to="/tags" class="nav-link">标签</router-link>
            </li>
            <li class="nav-item">
              <router-link to="/about" class="nav-link">关于</router-link>
            </li>
          </ul>
        </nav>
        
        <div class="nav-actions">
          <div class="search-box">
            <input 
              type="text" 
              placeholder="搜索文章..." 
              class="search-input"
              @keyup.enter="performSearch"
              v-model="searchQuery"
            />
            <button class="search-btn" @click="performSearch">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="11" cy="11" r="8"></circle>
                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
              </svg>
            </button>
          </div>
          
          <div class="user-actions">
            <button class="login-btn" v-if="!isLoggedIn">登录</button>
            <div class="user-menu" v-else>
              <img :src="currentUser.avatar" :alt="currentUser.username" class="user-avatar" />
              <span class="username">{{ currentUser.username }}</span>
            </div>
          </div>
        </div>
      </div>
    </header>

    <!-- 主内容区域 -->
    <main class="main-content">
      <slot />
    </main>

    <!-- 侧边栏 -->
    <aside class="sidebar" v-if="showSidebar">
      <div class="sidebar-content">
        <!-- 站点信息 -->
        <section class="site-info">
          <h3>{{ siteConfig.siteName }}</h3>
          <p>{{ siteConfig.description }}</p>
        </section>

        <!-- 热门文章 -->
        <section class="popular-posts">
          <h4>热门文章</h4>
          <ul>
            <li v-for="post in popularPosts" :key="post.id">
              <router-link :to="`/article/${post.slug}`">{{ post.title }}</router-link>
            </li>
          </ul>
        </section>

        <!-- 标签云 -->
        <section class="tag-cloud">
          <h4>标签云</h4>
          <div class="tags">
            <span 
              v-for="tag in tags" 
              :key="tag.id" 
              class="tag"
              :style="{ backgroundColor: tag.color + '20', color: tag.color }"
            >
              {{ tag.name }}
            </span>
          </div>
        </section>

        <!-- 社交链接 -->
        <section class="social-links">
          <h4>社交链接</h4>
          <div class="links">
            <a v-for="link in socialLinks" :key="link.name" :href="link.url" target="_blank">
              {{ link.name }}
            </a>
          </div>
        </section>
      </div>
    </aside>

    <!-- 底部 -->
    <footer class="footer">
      <div class="footer-container">
        <div class="footer-info">
          <p>&copy; {{ new Date().getFullYear() }} {{ siteConfig.siteName }}. All rights reserved.</p>
          <p>{{ siteConfig.copyright }}</p>
        </div>
        <div class="footer-links">
          <a href="/privacy">隐私政策</a>
          <a href="/terms">服务条款</a>
          <a href="/contact">联系我们</a>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed } from 'vue';
import { useRoute } from 'vue-router';

// 站点配置
const siteConfig = reactive({
  siteName: 'OpenClaw Blog',
  description: '一个现代化的博客系统',
  copyright: 'Powered by OpenClaw'
});

// 搜索相关
const searchQuery = ref('');

// 用户状态
const isLoggedIn = ref(false);
const currentUser = reactive({
  username: 'John Doe',
  avatar: '/avatar.jpg'
});

// 热门文章
const popularPosts = ref([
  { id: 1, title: 'Vue 3 最佳实践', slug: 'vue3-best-practices' },
  { id: 2, title: 'TypeScript 高级特性', slug: 'typescript-advanced-features' },
  { id: 3, title: '前端性能优化', slug: 'frontend-performance-optimization' }
]);

// 标签
const tags = ref([
  { id: 1, name: 'Vue.js', color: '#40B883' },
  { id: 2, name: 'TypeScript', color: '#3178C6' },
  { id: 3, name: 'CSS', color: '#1572B6' },
  { id: 4, name: 'JavaScript', color: '#F7DF1E' },
  { id: 5, name: 'Node.js', color: '#339933' }
]);

// 社交链接
const socialLinks = ref([
  { name: 'GitHub', url: 'https://github.com' },
  { name: 'Twitter', url: 'https://twitter.com' },
  { name: 'LinkedIn', url: 'https://linkedin.com' }
]);

// 获取当前路由以判断是否显示侧边栏
const route = useRoute();
const showSidebar = computed(() => {
  return !['/login', '/register', '/admin'].includes(route.path);
});

// 搜索功能
const performSearch = () => {
  if (searchQuery.value.trim()) {
    console.log('Searching for:', searchQuery.value);
  }
};
</script>

<style scoped>
.app-layout {
  min-height: 100vh;
  display: grid;
  grid-template-rows: auto 1fr auto;
  grid-template-columns: 1fr;
  grid-template-areas:
    "header"
    "main"
    "footer";
}

.navbar {
  grid-area: header;
  background: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 100;
}

.navbar-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 60px;
}

.logo-section {
  display: flex;
  align-items: center;
}

.logo {
  display: flex;
  align-items: center;
  text-decoration: none;
  color: #303133;
  font-weight: 600;
  font-size: 18px;
}

.logo-img {
  height: 32px;
  margin-right: 8px;
}

.nav-menu {
  flex: 1;
  margin-left: 40px;
}

.nav-list {
  display: flex;
  list-style: none;
  margin: 0;
  padding: 0;
  gap: 24px;
}

.nav-link {
  text-decoration: none;
  color: #606266;
  font-weight: 500;
  transition: color 0.3s ease;
}

.nav-link.router-link-active,
.nav-link:hover {
  color: #409EFF;
}

.nav-actions {
  display: flex;
  align-items: center;
  gap: 16px;
}

.search-box {
  position: relative;
}

.search-input {
  padding: 8px 32px 8px 12px;
  border: 1px solid #DCDFE6;
  border-radius: 20px;
  font-size: 14px;
  width: 200px;
  transition: border-color 0.3s ease;
}

.search-input:focus {
  outline: none;
  border-color: #409EFF;
}

.search-btn {
  position: absolute;
  right: 8px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  cursor: pointer;
  color: #909399;
}

.login-btn {
  padding: 6px 16px;
  background-color: #409EFF;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.user-menu {
  display: flex;
  align-items: center;
  gap: 8px;
}

.user-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  object-fit: cover;
}

.main-content {
  grid-area: main;
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
  width: 100%;
}

.sidebar {
  position: fixed;
  right: 0;
  top: 60px;
  bottom: 60px;
  width: 300px;
  padding: 20px;
  background: white;
  box-shadow: -2px 0 8px rgba(0, 0, 0, 0.1);
  overflow-y: auto;
}

.sidebar-content {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.site-info h3 {
  margin: 0 0 8px 0;
  font-size: 18px;
  color: #303133;
}

.site-info p {
  margin: 0;
  font-size: 14px;
  color: #909399;
}

.popular-posts ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.popular-posts li {
  margin-bottom: 8px;
}

.popular-posts a {
  text-decoration: none;
  color: #606266;
  font-size: 14px;
  transition: color 0.3s ease;
}

.popular-posts a:hover {
  color: #409EFF;
}

.tag-cloud .tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.tag {
  padding: 4px 12px;
  border-radius: 16px;
  font-size: 12px;
  border: 1px solid currentColor;
  opacity: 0.8;
}

.social-links .links {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.social-links a {
  text-decoration: none;
  color: #606266;
  font-size: 14px;
  transition: color 0.3s ease;
}

.social-links a:hover {
  color: #409EFF;
}

.footer {
  grid-area: footer;
  background: #FAFAFA;
  border-top: 1px solid #EBEEF5;
  padding: 20px 0;
}

.footer-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
}

.footer-info p {
  margin: 0;
  color: #909399;
  font-size: 14px;
  text-align: center;
}

.footer-links {
  display: flex;
  gap: 20px;
}

.footer-links a {
  text-decoration: none;
  color: #909399;
  font-size: 14px;
  transition: color 0.3s ease;
}

.footer-links a:hover {
  color: #409EFF;
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .sidebar {
    display: none;
  }
  
  .main-content {
    max-width: 800px;
  }
}

@media (max-width: 768px) {
  .navbar-container {
    flex-wrap: wrap;
    height: auto;
    padding: 10px 20px;
  }
  
  .nav-menu {
    order: 2;
    margin: 10px 0 0 0;
    width: 100%;
  }
  
  .nav-list {
    flex-wrap: wrap;
    gap: 12px;
  }
  
  .nav-actions {
    order: 1;
    margin-left: auto;
  }
  
  .search-input {
    width: 150px;
  }
  
  .main-content {
    padding: 16px 12px;
  }
  
  .footer-container {
    padding: 0 12px;
  }
  
  .footer-links {
    flex-wrap: wrap;
    justify-content: center;
  }
}
</style>
