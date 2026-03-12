<template>
  <nav class="navbar" :class="{ 'dark-mode': isDarkMode }">
    <div class="navbar-content">
      <!-- Logo -->
      <div class="logo" @click="goHome">
        <span class="logo-icon">🥟</span>
        <span class="logo-text">包子铺博客</span>
      </div>

      <!-- 导航菜单 -->
      <div class="nav-menu">
        <router-link to="/" class="nav-item">首页</router-link>
        <router-link to="/categories" class="nav-item">分类</router-link>
        <router-link to="/tags" class="nav-item">标签</router-link>
        <router-link to="/about" class="nav-item">关于</router-link>
      </div>

      <!-- 右侧操作 -->
      <div class="nav-actions">
        <!-- 搜索 -->
        <div class="search-box">
          <el-input
            v-model="searchKeyword"
            placeholder="搜索文章..."
            size="default"
            clearable
            @keyup.enter="handleSearch"
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>
        </div>

        <!-- 暗色模式切换 -->
        <el-button
          class="theme-toggle"
          :icon="isDarkMode ? 'Sunny' : 'Moon'"
          circle
          @click="$emit('toggle-theme')"
        />

        <!-- 登录按钮 -->
        <el-button type="primary" @click="goLogin">
          登录
        </el-button>
      </div>

      <!-- 移动端菜单按钮 -->
      <div class="mobile-menu-btn" @click="toggleMobileMenu">
        <el-icon :size="24"><Menu /></el-icon>
      </div>
    </div>

    <!-- 移动端菜单 -->
    <div v-if="showMobileMenu" class="mobile-menu">
      <router-link to="/" class="mobile-nav-item">首页</router-link>
      <router-link to="/categories" class="mobile-nav-item">分类</router-link>
      <router-link to="/tags" class="mobile-nav-item">标签</router-link>
      <router-link to="/about" class="mobile-nav-item">关于</router-link>
      <el-button type="primary" class="mobile-login-btn" @click="goLogin">
        登录
      </el-button>
    </div>
  </nav>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { Search, Menu } from '@element-plus/icons-vue'

defineProps<{
  isDarkMode: boolean
}>()

defineEmits<{
  (e: 'toggle-theme'): void
}>()

const router = useRouter()
const searchKeyword = ref('')
const showMobileMenu = ref(false)

const goHome = () => {
  router.push('/')
}

const goLogin = () => {
  router.push('/login')
}

const handleSearch = () => {
  if (searchKeyword.value.trim()) {
    router.push({ path: '/search', query: { q: searchKeyword.value } })
  }
}

const toggleMobileMenu = () => {
  showMobileMenu.value = !showMobileMenu.value
}
</script>

<style scoped lang="scss">
.navbar {
  background: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 1000;

  &.dark-mode {
    background: #1a1a2e;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
  }
}

.navbar-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  max-width: 1200px;
  margin: 0 auto;
  padding: 16px 24px;
  gap: 24px;
}

.logo {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  transition: opacity 0.2s ease;

  &:hover {
    opacity: 0.8;
  }

  .logo-icon {
    font-size: 28px;
  }

  .logo-text {
    font-size: 20px;
    font-weight: 700;
    color: #1a1a1a;

    .dark-mode & {
      color: #e0e0e0;
    }
  }
}

.nav-menu {
  display: flex;
  gap: 24px;

  @media (max-width: 768px) {
    display: none;
  }

  .nav-item {
    color: #666;
    text-decoration: none;
    font-size: 15px;
    transition: color 0.2s ease;
    padding: 8px 0;
    position: relative;

    .dark-mode & {
      color: #999;
    }

    &:hover {
      color: #667eea;
    }

    &.router-link-active {
      color: #667eea;
      font-weight: 500;

      &::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        height: 2px;
        background: #667eea;
      }
    }
  }
}

.nav-actions {
  display: flex;
  align-items: center;
  gap: 16px;

  @media (max-width: 768px) {
    display: none;
  }

  .search-box {
    width: 200px;
  }

  .theme-toggle {
    border: none;
    background: #f5f7fa;

    .dark-mode & {
      background: #2a2a3e;
    }
  }
}

.mobile-menu-btn {
  display: none;
  cursor: pointer;
  padding: 8px;

  @media (max-width: 768px) {
    display: block;
  }
}

.mobile-menu {
  display: flex;
  flex-direction: column;
  padding: 16px 24px;
  background: white;
  border-top: 1px solid #f0f0f0;

  .dark-mode & {
    background: #1a1a2e;
    border-top-color: #2a2a3e;
  }

  .mobile-nav-item {
    color: #666;
    text-decoration: none;
    font-size: 15px;
    padding: 12px 0;
    border-bottom: 1px solid #f0f0f0;

    .dark-mode & {
      color: #999;
      border-bottom-color: #2a2a3e;
    }

    &:hover {
      color: #667eea;
    }
  }

  .mobile-login-btn {
    margin-top: 16px;
  }
}
</style>
