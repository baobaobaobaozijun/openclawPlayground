/**
 * 文章模块状态管理
 */
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { 
  Article, 
  ArticleQuery, 
  ArticleListResponse,
  ArticleCreateRequest,
  ArticleUpdateRequest,
  Category,
  Tag
} from '@/types'
import {
  getArticleList,
  getArticleDetail,
  createArticle,
  updateArticle,
  deleteArticle,
  publishArticle,
  getCategoryList,
  getTagList
} from '@/api/article'

export const useArticleStore = defineStore('article', () => {
  // 状态
  const articles = ref<Article[]>([])
  const currentArticle = ref<Article | null>(null)
  const categories = ref<Category[]>([])
  const tags = ref<Tag[]>([])
  const loading = ref(false)
  const pagination = ref({
    page: 1,
    size: 10,
    total: 0,
    totalPages: 0
  })

  // 计算属性
  const hasArticles = computed(() => articles.value.length > 0)
  const total = computed(() => pagination.value.total)

  // Actions
  /**
   * 获取文章列表
   */
  async function fetchArticleList(query: ArticleQuery = {}) {
    loading.value = true
    try {
      const response = await getArticleList({
        page: query.page || 1,
        size: query.size || 10,
        ...query
      })
      
      articles.value = response.data
      pagination.value = {
        page: response.page,
        size: response.size,
        total: response.total,
        totalPages: response.totalPages
      }
      
      return response
    } catch (error) {
      console.error('获取文章列表失败:', error)
      throw error
    } finally {
      loading.value = false
    }
  }

  /**
   * 获取文章详情
   */
  async function fetchArticleDetail(id: number) {
    loading.value = true
    try {
      const article = await getArticleDetail(id)
      currentArticle.value = article
      return article
    } catch (error) {
      console.error('获取文章详情失败:', error)
      throw error
    } finally {
      loading.value = false
    }
  }

  /**
   * 创建文章
   */
  async function createNewArticle(data: ArticleCreateRequest) {
    loading.value = true
    try {
      const article = await createArticle(data)
      articles.value.unshift(article)
      return article
    } catch (error) {
      console.error('创建文章失败:', error)
      throw error
    } finally {
      loading.value = false
    }
  }

  /**
   * 更新文章
   */
  async function updateExistingArticle(data: ArticleUpdateRequest) {
    loading.value = true
    try {
      const article = await updateArticle(data)
      const index = articles.value.findIndex(a => a.id === article.id)
      if (index !== -1) {
        articles.value[index] = article
      }
      if (currentArticle.value?.id === article.id) {
        currentArticle.value = article
      }
      return article
    } catch (error) {
      console.error('更新文章失败:', error)
      throw error
    } finally {
      loading.value = false
    }
  }

  /**
   * 删除文章
   */
  async function removeArticle(id: number) {
    loading.value = true
    try {
      await deleteArticle(id)
      articles.value = articles.value.filter(a => a.id !== id)
      if (currentArticle.value?.id === id) {
        currentArticle.value = null
      }
    } catch (error) {
      console.error('删除文章失败:', error)
      throw error
    } finally {
      loading.value = false
    }
  }

  /**
   * 发布文章
   */
  async function publishExistingArticle(id: number) {
    loading.value = true
    try {
      const article = await publishArticle(id)
      const index = articles.value.findIndex(a => a.id === article.id)
      if (index !== -1) {
        articles.value[index] = article
      }
      if (currentArticle.value?.id === article.id) {
        currentArticle.value = article
      }
      return article
    } catch (error) {
      console.error('发布文章失败:', error)
      throw error
    } finally {
      loading.value = false
    }
  }

  /**
   * 获取分类列表
   */
  async function fetchCategories() {
    try {
      categories.value = await getCategoryList()
      return categories.value
    } catch (error) {
      console.error('获取分类列表失败:', error)
      throw error
    }
  }

  /**
   * 获取标签列表
   */
  async function fetchTags() {
    try {
      tags.value = await getTagList()
      return tags.value
    } catch (error) {
      console.error('获取标签列表失败:', error)
      throw error
    }
  }

  /**
   * 清空当前文章
   */
  function clearCurrentArticle() {
    currentArticle.value = null
  }

  /**
   * 重置状态
   */
  function reset() {
    articles.value = []
    currentArticle.value = null
    categories.value = []
    tags.value = []
    loading.value = false
    pagination.value = {
      page: 1,
      size: 10,
      total: 0,
      totalPages: 0
    }
  }

  return {
    // State
    articles,
    currentArticle,
    categories,
    tags,
    loading,
    pagination,
    // Getters
    hasArticles,
    total,
    // Actions
    fetchArticleList,
    fetchArticleDetail,
    createNewArticle,
    updateExistingArticle,
    removeArticle,
    publishExistingArticle,
    fetchCategories,
    fetchTags,
    clearCurrentArticle,
    reset
  }
})
