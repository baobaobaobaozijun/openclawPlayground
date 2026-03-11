<template>
  <div class="article-management">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-left">
        <h2 class="page-title">文章管理</h2>
        <p class="page-subtitle">管理和发布您的博客文章</p>
      </div>
      <div class="header-right">
        <el-input
          v-model="searchKeyword"
          placeholder="搜索文章标题..."
          class="search-input"
          clearable
          @clear="handleSearch"
          @keyup.enter="handleSearch"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
        <el-button type="primary" @click="handleCreate">
          <el-icon><Plus /></el-icon>
          新建文章
        </el-button>
      </div>
    </div>

    <!-- 筛选区域 -->
    <div class="filter-area">
      <el-form :inline="true" :model="filterForm" class="filter-form">
        <el-form-item label="分类">
          <el-select
            v-model="filterForm.categoryId"
            placeholder="全部分类"
            clearable
            @change="handleFilterChange"
          >
            <el-option
              v-for="category in articleStore.categories"
              :key="category.id"
              :label="category.name"
              :value="category.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select
            v-model="filterForm.status"
            placeholder="全部状态"
            clearable
            @change="handleFilterChange"
          >
            <el-option label="已发布" value="published" />
            <el-option label="草稿" value="draft" />
            <el-option label="已归档" value="archived" />
          </el-select>
        </el-form-item>
        <el-form-item label="排序">
          <el-select
            v-model="filterForm.sortBy"
            @change="handleFilterChange"
          >
            <el-option label="最新发布" value="createdAt" />
            <el-option label="最多浏览" value="viewCount" />
            <el-option label="最多点赞" value="likeCount" />
          </el-select>
        </el-form-item>
      </el-form>
    </div>

    <!-- 文章列表 -->
    <div class="article-list">
      <el-table
        v-loading="articleStore.loading"
        :data="articleStore.articles"
        style="width: 100%"
        row-key="id"
        @row-click="handleRowClick"
      >
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column label="标题" min-width="300">
          <template #default="{ row }">
            <div class="article-title">
              <span class="title-text">{{ row.title }}</span>
              <el-tag
                v-if="row.status === 'draft'"
                size="small"
                type="warning"
              >
                草稿
              </el-tag>
              <el-tag
                v-else-if="row.status === 'published'"
                size="small"
                type="success"
              >
                已发布
              </el-tag>
              <el-tag
                v-else-if="row.status === 'archived'"
                size="small"
                type="info"
              >
                已归档
              </el-tag>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="category.name" label="分类" width="120" />
        <el-table-column prop="author.name" label="作者" width="120" />
        <el-table-column label="统计" width="200">
          <template #default="{ row }">
            <div class="article-stats">
              <span class="stat-item">
                <el-icon><View /></el-icon>
                {{ row.viewCount }}
              </span>
              <span class="stat-item">
                <el-icon><Star /></el-icon>
                {{ row.likeCount }}
              </span>
              <span class="stat-item">
                <el-icon><ChatDotRound /></el-icon>
                {{ row.commentCount }}
              </span>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="创建时间" width="180">
          <template #default="{ row }">
            {{ formatDate(row.createdAt) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button
              link
              type="primary"
              @click.stop="handleEdit(row)"
            >
              编辑
            </el-button>
            <el-button
              v-if="row.status === 'draft'"
              link
              type="success"
              @click.stop="handlePublish(row)"
            >
              发布
            </el-button>
            <el-button
              link
              type="danger"
              @click.stop="handleDelete(row)"
            >
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination-wrapper">
        <el-pagination
          v-model:current-page="pagination.page"
          v-model:page-size="pagination.size"
          :total="pagination.total"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handlePageChange"
        />
      </div>
    </div>

    <!-- 空状态 -->
    <el-empty
      v-if="!articleStore.loading && !articleStore.hasArticles"
      description="暂无文章，点击右上角新建文章"
    >
      <el-button type="primary" @click="handleCreate">
        创建第一篇文章
      </el-button>
    </el-empty>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  Search,
  Plus,
  View,
  Star,
  ChatDotRound
} from '@element-plus/icons-vue'
import { useArticleStore } from '@/stores/article'
import type { Article, ArticleQuery } from '@/types'
import dayjs from 'dayjs'

const router = useRouter()
const articleStore = useArticleStore()

// 搜索关键词
const searchKeyword = ref('')

// 筛选表单
const filterForm = reactive<ArticleQuery>({
  categoryId: undefined,
  status: undefined,
  sortBy: 'createdAt',
  sortOrder: 'desc'
})

// 分页
const pagination = reactive({
  page: 1,
  size: 10,
  total: 0
})

// 格式化日期
const formatDate = (date: string) => {
  return dayjs(date).format('YYYY-MM-DD HH:mm')
}

// 加载文章列表
const loadArticles = async () => {
  try {
    const response = await articleStore.fetchArticleList({
      page: pagination.page,
      size: pagination.size,
      keyword: searchKeyword.value || undefined,
      ...filterForm
    })
    
    pagination.total = response.total
  } catch (error) {
    console.error('加载文章列表失败:', error)
  }
}

// 搜索
const handleSearch = () => {
  pagination.page = 1
  loadArticles()
}

// 筛选变化
const handleFilterChange = () => {
  pagination.page = 1
  loadArticles()
}

// 分页变化
const handlePageChange = (page: number) => {
  pagination.page = page
  loadArticles()
}

const handleSizeChange = (size: number) => {
  pagination.size = size
  pagination.page = 1
  loadArticles()
}

// 行点击
const handleRowClick = (row: Article) => {
  router.push(`/article/${row.id}`)
}

// 新建文章
const handleCreate = () => {
  router.push('/article/create')
}

// 编辑文章
const handleEdit = (row: Article) => {
  router.push(`/article/${row.id}/edit`)
}

// 发布文章
const handlePublish = async (row: Article) => {
  try {
    await ElMessageBox.confirm(
      '确定要发布这篇文章吗？',
      '提示',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    
    await articleStore.publishExistingArticle(row.id)
    ElMessage.success('文章发布成功')
    loadArticles()
  } catch (error: any) {
    if (error !== 'cancel') {
      console.error('发布文章失败:', error)
    }
  }
}

// 删除文章
const handleDelete = async (row: Article) => {
  try {
    await ElMessageBox.confirm(
      '确定要删除这篇文章吗？此操作不可恢复。',
      '警告',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'error'
      }
    )
    
    await articleStore.removeArticle(row.id)
    ElMessage.success('文章删除成功')
    loadArticles()
  } catch (error: any) {
    if (error !== 'cancel') {
      console.error('删除文章失败:', error)
    }
  }
}

// 初始化
onMounted(async () => {
  await articleStore.fetchCategories()
  await articleStore.fetchTags()
  await loadArticles()
})
</script>

<style scoped lang="scss">
.article-management {
  padding: 24px;
  background: #fff;
  border-radius: 8px;
  min-height: calc(100vh - 120px);
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  
  .header-left {
    .page-title {
      margin: 0 0 8px 0;
      font-size: 24px;
      font-weight: 600;
      color: #1a1a1a;
    }
    
    .page-subtitle {
      margin: 0;
      font-size: 14px;
      color: #666;
    }
  }
  
  .header-right {
    display: flex;
    gap: 12px;
    
    .search-input {
      width: 240px;
    }
  }
}

.filter-area {
  margin-bottom: 24px;
  padding: 16px;
  background: #f5f7fa;
  border-radius: 8px;
  
  .filter-form {
    margin: 0;
  }
}

.article-list {
  .article-title {
    display: flex;
    align-items: center;
    gap: 8px;
    
    .title-text {
      font-weight: 500;
      color: #1a1a1a;
    }
  }
  
  .article-stats {
    display: flex;
    gap: 16px;
    color: #666;
    font-size: 13px;
    
    .stat-item {
      display: flex;
      align-items: center;
      gap: 4px;
    }
  }
  
  .pagination-wrapper {
    margin-top: 24px;
    display: flex;
    justify-content: flex-end;
  }
}

:deep(.el-table) {
  .el-table__row {
    cursor: pointer;
    
    &:hover {
      background-color: #f5f7fa;
    }
  }
}
</style>
