// TypeScript 类型定义

/**
 * 文章接口类型
 */
export interface Article {
  id: number
  title: string
  content: string
  summary: string
  author: Author
  category: Category
  tags: Tag[]
  status: ArticleStatus
  viewCount: number
  likeCount: number
  commentCount: number
  createdAt: string
  updatedAt: string
  publishedAt?: string
  coverImage?: string
}

/**
 * 文章状态
 */
export type ArticleStatus = 'draft' | 'published' | 'archived'

/**
 * 作者信息
 */
export interface Author {
  id: number
  name: string
  avatar?: string
  bio?: string
}

/**
 * 分类信息
 */
export interface Category {
  id: number
  name: string
  slug: string
  description?: string
}

/**
 * 标签信息
 */
export interface Tag {
  id: number
  name: string
  slug: string
}

/**
 * 文章列表查询参数
 */
export interface ArticleQuery {
  page?: number
  size?: number
  keyword?: string
  categoryId?: number
  tagId?: number
  status?: ArticleStatus
  sortBy?: 'createdAt' | 'publishedAt' | 'viewCount' | 'likeCount'
  sortOrder?: 'asc' | 'desc'
}

/**
 * 文章列表响应
 */
export interface ArticleListResponse {
  data: Article[]
  total: number
  page: number
  size: number
  totalPages: number
}

/**
 * 创建/更新文章请求
 */
export interface ArticleCreateRequest {
  title: string
  content: string
  summary: string
  categoryId: number
  tagIds?: number[]
  status?: ArticleStatus
  coverImage?: string
}

export interface ArticleUpdateRequest extends Partial<ArticleCreateRequest> {
  id: number
}

/**
 * 分页参数
 */
export interface Pagination {
  page: number
  size: number
  total: number
  totalPages: number
}
