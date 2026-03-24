$apiFile = "F:\openclaw\code\frontend\src\api\article.ts"
$content = Get-Content $apiFile -Encoding UTF8 -Raw

# Add missing exports that other files expect
$additions = @"

// Aliases for backward compatibility
export const getArticle = getArticleById
export const createArticle = (data: { title: string; content: string; summary?: string }) => {
  return request.post('/articles', data)
}
export const updateArticle = (id: number, data: { title?: string; content?: string; summary?: string }) => {
  return request.put(`/articles/`+id, data)
}

// Additional types for store compatibility
export interface ArticleListParams {
  page?: number
  size?: number
  categoryId?: number
  tagId?: number
  keyword?: string
}

export interface PageResult<T> {
  records: T[]
  total: number
  pages: number
  current: number
}
"@

$content = $content + "`n" + $additions
Set-Content -Path $apiFile -Value $content -Encoding UTF8
Write-Output "article.ts updated with missing exports"
