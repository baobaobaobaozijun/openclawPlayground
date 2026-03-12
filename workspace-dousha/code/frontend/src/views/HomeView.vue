<template>
  <div class="home-container" :class="{ 'dark-mode': isDarkMode }">
    <!-- 导航栏 -->
    <NavBar 
      :is-dark-mode="isDarkMode" 
      @toggle-theme="toggleTheme" 
    />

    <!-- 主内容区 -->
    <div class="main-content">
      <!-- 左侧文章列表 -->
      <div class="content-area">
        <!-- Banner -->
        <div class="banner">
          <h1 class="banner-title">包子铺博客</h1>
          <p class="banner-subtitle">记录 Agent 团队的成长足迹</p>
        </div>

        <!-- 文章列表 -->
        <div class="article-section">
          <div class="section-header">
            <h2 class="section-title">最新文章</h2>
            <el-select
              v-model="sortBy"
              placeholder="排序"
              size="default"
              @change="handleSortChange"
            >
              <el-option label="最新发布" value="createdAt" />
              <el-option label="最多浏览" value="viewCount" />
              <el-option label="最多点赞" value="likeCount" />
            </el-select>
          </div>

          <!-- 文章卡片列表 -->
          <div class="article-list">
            <ArticleCard
              v-for="article in articleStore.articles"
              :key="article.id"
              :article="article"
              @click="navigateToArticle(article.id)"
            />
          </div>

          <!-- 空状态 -->
          <el-empty
            v-if="!articleStore.loading && !articleStore.hasArticles"
            description="暂无文章，敬请期待"
          />

          <!-- 加载状态 -->
          <div v-if="articleStore.loading" class="loading-container">
            <el-skeleton :rows="5" animated />
          </div>

          <!-- 分页 -->
          <div class="pagination-wrapper" v-if="!articleStore.loading && articleStore.hasArticles">
            <el-pagination
              v-model:current-page="currentPage"
              v-model:page-size="pageSize"
              :total="total"
              :page-sizes="[10, 20, 50]"
              layout="total, sizes, prev, pager, next"
              @size-change="handleSizeChange"
              @current-change="handlePageChange"
            />
          </div>
        </div>
      </div>

      <!-- 右侧边栏 -->
      <aside class="sidebar">
        <!-- 作者信息 -->
        <div class="sidebar-widget author-widget">
          <div class="author-avatar">
            <el-avatar :size="80" src="https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png" />
          </div>
          <h3 class="author-name">包子铺团队</h3>
          <p class="author-bio">Agent 团队协作开发，记录技术成长</p>
          <div class="author-stats">
            <div class="stat-item">
              <span class="stat-value">12</span>
              <span class="stat-label">文章</span>
            </div>
            <div class="stat-item">
              <span class="stat-value">1.2k</span>
              <span class="stat-label">阅读</span>
            </div>
            <div class="stat-item">
              <span class="stat-value">89</span>
              <span class="stat-label">关注</span>
            </div>
          </div>
        </div>

        <!-- 分类列表 -->
        <div class="sidebar-widget category-widget">
          <h3 class="widget-title">分类</h3>
          <ul class="category-list">
            <li
              v-for="category in articleStore.categories"
              :key="category.id"
              class="category-item"
              :class="{ active: currentCategory === category.id }"
              @click="selectCategory(category.id)"
            >
              <span>{{ category.name }}</span>
              <el-tag size="small" type="info">{{ category.count || 0 }}</el-tag>
            </li>
          </ul>
        </div>

        <!-- 标签云 -->
        <div class="sidebar-widget tag-widget">
          <h3 class="widget-title">标签</h3>
          <div class="tag-cloud">
            <el-tag
              v-for="tag in articleStore.tags"
              :key="tag.id"
              class="tag-item"
              :type="getTagType(tag)"
              @click="selectTag(tag.id)"
            >
              #{{ tag.name }}
            </el-tag>
          </div>
        </div>
      </aside>
    </div>

    <!-- 页脚 -->
    <Footer />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useArticleStore } from '@/stores/article'
import NavBar from '@/components/NavBar.vue'
import ArticleCard from '@/components/ArticleCard.vue'
import Footer from '@/components/Footer.vue'

const router = useRouter()
const articleStore = useArticleStore()

// 暗色模式
const isDarkMode = ref(false)

// 分页
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)

// 排序
const sortBy = ref('createdAt')

// 分类筛选
const currentCategory = ref<number | undefined>(undefined)

// 切换暗色模式
const toggleTheme = () => {
  isDarkMode.value = !isDarkMode.value
  document.documentElement.classList.toggle('dark', isDarkMode.value)
  localStorage.setItem('darkMode', isDarkMode.value.toString())
}

// 跳转文章详情
const navigateToArticle = (id: number) => {
  router.push(`/article/${id}`)
}

// 排序变化
const handleSortChange = () => {
  currentPage.value = 1
  loadArticles()
}

// 分页变化
const handlePageChange = (page: number) => {
  currentPage.value = page
  loadArticles()
}

const handleSizeChange = (size: number) => {
  pageSize.value = size
  currentPage.value = 1
  loadArticles()
}

// 选择分类
const selectCategory = (categoryId: number | undefined) => {
  currentCategory.value = categoryId
  currentPage.value = 1
  loadArticles()
}

// 选择标签
const selectTag = (tagId: number) => {
  console.log('选择标签:', tagId)
  // TODO: 实现标签筛选
}

// 获取标签类型
const getTagType = (tag: any) => {
  const types = ['', 'success', 'warning', 'danger', 'info']
  return types[tag.id % types.length] as any
}

// 加载文章列表
const loadArticles = async () => {
  try {
    await articleStore.fetchArticleList({
      page: currentPage.value,
      size: pageSize.value,
      categoryId: currentCategory.value,
      sortBy: sortBy.value,
      sortOrder: 'desc'
    })
    total.value = articleStore.total
  } catch (error) {
    console.error('加载文章列表失败:', error)
  }
}

// 初始化
onMounted(async () => {
  // 读取暗色模式偏好
  const savedMode = localStorage.getItem('darkMode')
  if (savedMode === 'true') {
    isDarkMode.value = true
    document.documentElement.classList.add('dark')
  }

  // 加载数据
  await articleStore.fetchCategories()
  await articleStore.fetchTags()
  await loadArticles()
})
</script>

<style scoped lang="scss">
.home-container {
  min-height: 100vh;
  background: #f5f7fa;
  transition: background 0.3s ease;

  &.dark-mode {
    background: #1a1a2e;
  }
}

.main-content {
  display: grid;
  grid-template-columns: 1fr 320px;
  gap: 24px;
  max-width: 1200px;
  margin: 0 auto;
  padding: 24px;

  @media (max-width: 992px) {
    grid-template-columns: 1fr;
  }
}

.content-area {
  min-width: 0;
}

.banner {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  padding: 48px;
  margin-bottom: 24px;
  text-align: center;
  color: white;

  .banner-title {
    font-size: 36px;
    font-weight: 700;
    margin: 0 0 12px 0;
  }

  .banner-subtitle {
    font-size: 16px;
    opacity: 0.9;
    margin: 0;
  }
}

.article-section {
  background: white;
  border-radius: 12px;
  padding: 24px;

  .dark-mode & {
    background: #16213e;
  }
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;

  .section-title {
    font-size: 20px;
    font-weight: 600;
    color: #1a1a1a;
    margin: 0;

    .dark-mode & {
      color: #e0e0e0;
    }
  }
}

.article-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.loading-container {
  padding: 24px 0;
}

.pagination-wrapper {
  margin-top: 32px;
  display: flex;
  justify-content: center;
}

// 侧边栏
.sidebar {
  display: flex;
  flex-direction: column;
  gap: 24px;

  @media (max-width: 992px) {
    order: -1;
  }
}

.sidebar-widget {
  background: white;
  border-radius: 12px;
  padding: 24px;

  .dark-mode & {
    background: #16213e;
  }
}

.author-widget {
  text-align: center;

  .author-avatar {
    margin-bottom: 16px;
  }

  .author-name {
    font-size: 18px;
    font-weight: 600;
    color: #1a1a1a;
    margin: 0 0 8px 0;

    .dark-mode & {
      color: #e0e0e0;
    }
  }

  .author-bio {
    font-size: 14px;
    color: #666;
    margin: 0 0 20px 0;

    .dark-mode & {
      color: #999;
    }
  }

  .author-stats {
    display: flex;
    justify-content: space-around;
    padding-top: 16px;
    border-top: 1px solid #eee;

    .dark-mode & {
      border-top-color: #2a2a3e;
    }

    .stat-item {
      display: flex;
      flex-direction: column;
      align-items: center;

      .stat-value {
        font-size: 20px;
        font-weight: 600;
        color: #667eea;
      }

      .stat-label {
        font-size: 12px;
        color: #999;
        margin-top: 4px;
      }
    }
  }
}

.widget-title {
  font-size: 16px;
  font-weight: 600;
  color: #1a1a1a;
  margin: 0 0 16px 0;
  padding-bottom: 12px;
  border-bottom: 2px solid #667eea;

  .dark-mode & {
    color: #e0e0e0;
  }
}

.category-list {
  list-style: none;
  padding: 0;
  margin: 0;

  .category-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12px 0;
    cursor: pointer;
    border-bottom: 1px solid #f0f0f0;
    transition: all 0.2s ease;

    .dark-mode & {
      border-bottom-color: #2a2a3e;
    }

    &:hover {
      color: #667eea;
    }

    &.active {
      color: #667eea;
      font-weight: 500;
    }
  }
}

.tag-cloud {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;

  .tag-item {
    cursor: pointer;
    transition: all 0.2s ease;

    &:hover {
      transform: translateY(-2px);
    }
  }
}
</style>
