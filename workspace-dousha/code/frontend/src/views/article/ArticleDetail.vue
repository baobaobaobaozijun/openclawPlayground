<template>
  <div class="article-detail" v-loading="articleStore.loading">
    <template v-if="article">
      <!-- 返回按钮 -->
      <div class="back-nav">
        <el-button @click="goBack">
          <el-icon><ArrowLeft /></el-icon>
          返回列表
        </el-button>
        <div class="action-buttons">
          <el-button
            v-if="article.status === 'draft'"
            type="success"
            @click="handlePublish"
          >
            发布
          </el-button>
          <el-button type="primary" @click="handleEdit">
            编辑
          </el-button>
          <el-button type="danger" @click="handleDelete">
            删除
          </el-button>
        </div>
      </div>

      <!-- 文章头部 -->
      <div class="article-header">
        <h1 class="article-title">{{ article.title }}</h1>
        <div class="article-meta">
          <div class="meta-item">
            <el-avatar :size="32" :src="article.author.avatar">
              {{ article.author.name[0] }}
            </el-avatar>
            <span class="meta-text">{{ article.author.name }}</span>
          </div>
          <div class="meta-item">
            <el-icon><Calendar /></el-icon>
            <span class="meta-text">{{ formatDate(article.createdAt) }}</span>
          </div>
          <div class="meta-item">
            <el-tag :type="getStatusType(article.status)">
              {{ getStatusText(article.status) }}
            </el-tag>
          </div>
          <div class="meta-item">
            <el-tag effect="plain">{{ article.category.name }}</el-tag>
          </div>
        </div>
      </div>

      <!-- 文章标签 -->
      <div class="article-tags" v-if="article.tags?.length">
        <el-tag
          v-for="tag in article.tags"
          :key="tag.id"
          effect="plain"
          size="small"
        >
          #{{ tag.name }}
        </el-tag>
      </div>

      <!-- 文章封面 -->
      <div class="article-cover" v-if="article.coverImage">
        <el-image
          :src="article.coverImage"
          fit="cover"
          class="cover-image"
        />
      </div>

      <!-- 文章摘要 -->
      <div class="article-summary">
        <h3>摘要</h3>
        <p>{{ article.summary }}</p>
      </div>

      <!-- 文章统计 -->
      <div class="article-stats">
        <div class="stat-item">
          <el-icon><View /></el-icon>
          <span>{{ article.viewCount }} 阅读</span>
        </div>
        <div class="stat-item">
          <el-icon><Star /></el-icon>
          <span>{{ article.likeCount }} 点赞</span>
        </div>
        <div class="stat-item">
          <el-icon><ChatDotRound /></el-icon>
          <span>{{ article.commentCount }} 评论</span>
        </div>
      </div>

      <!-- 文章内容 -->
      <div class="article-content">
        <h3>正文</h3>
        <div class="content-body" v-html="renderContent(article.content)"></div>
      </div>

      <!-- 更新时间 -->
      <div class="article-footer">
        <p class="update-time">
          最后更新：{{ formatDate(article.updatedAt) }}
        </p>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  ArrowLeft,
  Calendar,
  View,
  Star,
  ChatDotRound
} from '@element-plus/icons-vue'
import { useArticleStore } from '@/stores/article'
import type { Article } from '@/types'
import dayjs from 'dayjs'

const router = useRouter()
const route = useRoute()
const articleStore = useArticleStore()

// 当前文章
const article = computed(() => articleStore.currentArticle)

// 格式化日期
const formatDate = (date: string) => {
  return dayjs(date).format('YYYY-MM-DD HH:mm:ss')
}

// 获取状态类型
const getStatusType = (status: string) => {
  const types: Record<string, any> = {
    draft: 'warning',
    published: 'success',
    archived: 'info'
  }
  return types[status] || ''
}

// 获取状态文本
const getStatusText = (status: string) => {
  const texts: Record<string, string> = {
    draft: '草稿',
    published: '已发布',
    archived: '已归档'
  }
  return texts[status] || status
}

// 渲染内容（简单处理，实际项目可使用 markdown 渲染器）
const renderContent = (content: string) => {
  return content.replace(/\n/g, '<br/>')
}

// 返回列表
const goBack = () => {
  router.back()
}

// 编辑文章
const handleEdit = () => {
  if (article.value) {
    router.push(`/article/${article.value.id}/edit`)
  }
}

// 发布文章
const handlePublish = async () => {
  try {
    await ElMessageBox.confirm('确定要发布这篇文章吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    
    if (article.value) {
      await articleStore.publishExistingArticle(article.value.id)
      ElMessage.success('文章发布成功')
    }
  } catch (error: any) {
    if (error !== 'cancel') {
      console.error('发布文章失败:', error)
    }
  }
}

// 删除文章
const handleDelete = async () => {
  try {
    await ElMessageBox.confirm('确定要删除这篇文章吗？此操作不可恢复。', '警告', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'error'
    })
    
    if (article.value) {
      await articleStore.removeArticle(article.value.id)
      ElMessage.success('文章删除成功')
      router.push('/article')
    }
  } catch (error: any) {
    if (error !== 'cancel') {
      console.error('删除文章失败:', error)
    }
  }
}

// 初始化
onMounted(async () => {
  const id = Number(route.params.id)
  if (id) {
    await articleStore.fetchArticleDetail(id)
  }
})
</script>

<style scoped lang="scss">
.article-detail {
  padding: 24px;
  background: #fff;
  border-radius: 8px;
  min-height: calc(100vh - 120px);
}

.back-nav {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  padding-bottom: 24px;
  border-bottom: 1px solid #eaeaea;
  
  .action-buttons {
    display: flex;
    gap: 12px;
  }
}

.article-header {
  margin-bottom: 24px;
  
  .article-title {
    margin: 0 0 16px 0;
    font-size: 32px;
    font-weight: 700;
    color: #1a1a1a;
    line-height: 1.4;
  }
  
  .article-meta {
    display: flex;
    align-items: center;
    gap: 24px;
    flex-wrap: wrap;
    
    .meta-item {
      display: flex;
      align-items: center;
      gap: 8px;
      
      .meta-text {
        font-size: 14px;
        color: #666;
      }
    }
  }
}

.article-tags {
  display: flex;
  gap: 8px;
  margin-bottom: 24px;
  flex-wrap: wrap;
}

.article-cover {
  margin-bottom: 24px;
  
  .cover-image {
    width: 100%;
    max-height: 400px;
    border-radius: 8px;
  }
}

.article-summary {
  padding: 20px;
  background: #f5f7fa;
  border-radius: 8px;
  margin-bottom: 24px;
  
  h3 {
    margin: 0 0 12px 0;
    font-size: 16px;
    font-weight: 600;
    color: #1a1a1a;
  }
  
  p {
    margin: 0;
    font-size: 14px;
    color: #666;
    line-height: 1.8;
  }
}

.article-stats {
  display: flex;
  gap: 32px;
  padding: 16px 0;
  margin-bottom: 24px;
  border-top: 1px solid #eaeaea;
  border-bottom: 1px solid #eaeaea;
  
  .stat-item {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 14px;
    color: #666;
  }
}

.article-content {
  margin-bottom: 24px;
  
  h3 {
    margin: 0 0 16px 0;
    font-size: 18px;
    font-weight: 600;
    color: #1a1a1a;
  }
  
  .content-body {
    font-size: 16px;
    line-height: 1.8;
    color: #333;
    
    :deep(p) {
      margin-bottom: 16px;
    }
    
    :deep(img) {
      max-width: 100%;
      border-radius: 8px;
    }
  }
}

.article-footer {
  padding-top: 16px;
  border-top: 1px solid #eaeaea;
  
  .update-time {
    margin: 0;
    font-size: 13px;
    color: #999;
  }
}
</style>
