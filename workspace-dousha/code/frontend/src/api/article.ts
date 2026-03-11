/**
 * 文章模块 API 接口
 */
import type { 
  Article, 
  ArticleQuery, 
  ArticleListResponse,
  ArticleCreateRequest,
  ArticleUpdateRequest
} from '@/types'

import request from '@/utils/request'

/**
 * 获取文章列表
 */
export function getArticleList(params: ArticleQuery) {
  return request<ArticleListResponse>({
    url: '/api/articles',
    method: 'get',
    params
  })
}

/**
 * 获取文章详情
 */
export function getArticleDetail(id: number) {
  return request<Article>({
    url: `/api/articles/${id}`,
    method: 'get'
  })
}

/**
 * 创建文章
 */
export function createArticle(data: ArticleCreateRequest) {
  return request<Article>({
    url: '/api/articles',
    method: 'post',
    data
  })
}

/**
 * 更新文章
 */
export function updateArticle(data: ArticleUpdateRequest) {
  const { id, ...rest } = data
  return request<Article>({
    url: `/api/articles/${id}`,
    method: 'put',
    data: rest
  })
}

/**
 * 删除文章
 */
export function deleteArticle(id: number) {
  return request<void>({
    url: `/api/articles/${id}`,
    method: 'delete'
  })
}

/**
 * 发布文章
 */
export function publishArticle(id: number) {
  return request<Article>({
    url: `/api/articles/${id}/publish`,
    method: 'post'
  })
}

/**
 * 获取文章分类列表
 */
export function getCategoryList() {
  return request<Category[]>({
    url: '/api/categories',
    method: 'get'
  })
}

/**
 * 获取标签列表
 */
export function getTagList() {
  return request<Tag[]>({
    url: '/api/tags',
    method: 'get'
  })
}
