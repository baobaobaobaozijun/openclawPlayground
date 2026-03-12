<template>
  <article class="article-card" @click="$emit('click')">
    <div class="card-content">
      <!-- 文章标题 -->
      <h3 class="card-title">{{ article.title }}</h3>

      <!-- 文章摘要 -->
      <p class="card-excerpt">{{ article.excerpt || article.content?.substring(0, 200) + '...' }}</p>

      <!-- 文章元信息 -->
      <div class="card-meta">
        <div class="meta-left">
          <!-- 作者 -->
          <div class="meta-item author">
            <el-avatar :size="24" :src="article.author?.avatar" />
            <span class="author-name">{{ article.author?.name || '匿名' }}</span>
          </div>

          <!-- 发布时间 -->
          <div class="meta-item">
            <el-icon><Clock /></el-icon>
            <span>{{ formatDate(article.createdAt) }}</span>
          </div>

          <!-- 分类 -->
          <div class="meta-item" v-if="article.category">
            <el-tag size="small" type="info">
              {{ article.category.name }}
            </el-tag>
          </div>
        </div>

        <div class="meta-right">
          <!-- 浏览数 -->
          <div class="meta-item stat">
            <el-icon><View /></el-icon>
            <span>{{ article.viewCount || 0 }}</span>
          </div>

          <!-- 点赞数 -->
          <div class="meta-item stat">
            <el-icon><Star /></el-icon>
            <span>{{ article.likeCount || 0 }}</span>
          </div>

          <!-- 评论数 -->
          <div class="meta-item stat">
            <el-icon><ChatDotRound /></el-icon>
            <span>{{ article.commentCount || 0 }}</span>
          </div>
        </div>
      </div>

      <!-- 标签列表 -->
      <div class="card-tags" v-if="article.tags && article.tags.length > 0">
        <el-tag
          v-for="tag in article.tags.slice(0, 3)"
          :key="tag.id"
          size="small"
          class="tag-item"
        >
          #{{ tag.name }}
        </el-tag>
      </div>
    </div>

    <!-- 悬停效果装饰 -->
    <div class="card-hover-effect"></div>
  </article>
</template>

<script setup lang="ts">
import { Clock, View, Star, ChatDotRound } from '@element-plus/icons-vue'
import type { Article } from '@/types'
import dayjs from 'dayjs'

defineProps<{
  article: Article
}>()

defineEmits<{
  (e: 'click'): void
}>()

// 格式化日期
const formatDate = (date: string) => {
  return dayjs(date).format('YYYY-MM-DD')
}
</script>

<style scoped lang="scss">
.article-card {
  background: white;
  border-radius: 12px;
  padding: 24px;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
  border: 1px solid #e8e8e8;

  .dark-mode & {
    background: #16213e;
    border-color: #2a2a3e;
  }

  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 24px rgba(102, 126, 234, 0.15);
    border-color: #667eea;

    .dark-mode & {
      box-shadow: 0 8px 24px rgba(102, 126, 234, 0.3);
    }

    .card-hover-effect {
      opacity: 1;
    }
  }
}

.card-hover-effect {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.card-content {
  position: relative;
  z-index: 1;
}

.card-title {
  font-size: 20px;
  font-weight: 600;
  color: #1a1a1a;
  margin: 0 0 12px 0;
  line-height: 1.5;
  transition: color 0.2s ease;

  .dark-mode & {
    color: #e0e0e0;
  }

  &:hover {
    color: #667eea;
  }
}

.card-excerpt {
  font-size: 14px;
  color: #666;
  line-height: 1.8;
  margin: 0 0 16px 0;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;

  .dark-mode & {
    color: #999;
  }
}

.card-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  flex-wrap: wrap;
  gap: 12px;

  .meta-left,
  .meta-right {
    display: flex;
    align-items: center;
    gap: 16px;
    flex-wrap: wrap;
  }

  .meta-item {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 13px;
    color: #999;

    &.author {
      .author-name {
        font-size: 13px;
        color: #666;

        .dark-mode & {
          color: #999;
        }
      }
    }

    &.stat {
      &:hover {
        color: #667eea;
      }
    }
  }
}

.card-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  padding-top: 12px;
  border-top: 1px solid #f0f0f0;

  .dark-mode & {
    border-top-color: #2a2a3e;
  }

  .tag-item {
    cursor: pointer;
    transition: all 0.2s ease;

    &:hover {
      transform: translateY(-1px);
    }
  }
}
</style>
