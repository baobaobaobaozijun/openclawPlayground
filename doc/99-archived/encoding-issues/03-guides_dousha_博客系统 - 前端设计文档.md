# 博客系统前端设计文档

**文档状态:** 正式  
**版本:** v1.0  
**创建日期:** 2026-03-12  
**负责人:** 豆沙 (前端工程师)  
**参考模板:** `templates/frontend-design-template.md`

---

## 📋 文档信息

| 项目 | 值 |
|------|-----|
| 项目名称 | 博客系统 |
| 前端版本 | v1 |
| 技术栈 | Vue 3.4 + TypeScript + Vite |
| UI 组件 | Element Plus 2.x |
| Markdown 编辑器 | Editor.md 1.5.0 |

---

## 1. 设计概述

### 1.1 核心原则

⚠️ **重要：本系统聚焦功能实现，不追求 UI/UX 美观度**

- ✅ **功能优先** - 能用就行，不追求视觉效果
- ✅ **Markdown 兼容** - 确保编辑器、渲染、展示全流程支持 Markdown
- ✅ **响应式** - 能适配手机和桌面即可
- ❌ **不要过度设计** - 不需要动画、特效、复杂交互

### 1.2 技术架构

```
┌─────────────────────────────────────────┐
│              浏览器                      │
├─────────────────────────────────────────┤
│           Vue 3 应用                     │
│  ┌─────────────────────────────────┐   │
│  │  页面层 (views/)                 │   │
│  │  - Home.vue                     │   │
│  │  - ArticleDetail.vue            │   │
│  │  - Login.vue                    │   │
│  │  - ArticleEdit.vue              │   │
│  └─────────────────────────────────┘   │
│  ┌─────────────────────────────────┐   │
│  │  组件层 (components/)            │   │
│  │  - NavBar.vue                   │   │
│  │  - MarkdownEditor.vue           │   │
│  │  - ArticleCard.vue              │   │
│  └─────────────────────────────────┘   │
│  ┌─────────────────────────────────┐   │
│  │  状态层 (stores/)                │   │
│  │  - user.ts                      │   │
│  │  - article.ts                   │   │
│  └─────────────────────────────────┘   │
│  ┌─────────────────────────────────┐   │
│  │  服务层 (api/)                   │   │
│  │  - auth.ts                      │   │
│  │  - article.ts                   │   │
│  └─────────────────────────────────┘   │
└─────────────────────────────────────────┘
         │
         │ HTTP/JSON
         ▼
┌─────────────────────────────────────────┐
│          后端 API (8080)                 │
└─────────────────────────────────────────┘
```

### 1.3 技术栈

| 层级 | 技术选型 | 版本 | 说明 |
|------|----------|------|------|
| 框架 | Vue 3 | 3.4+ | Composition API |
| 语言 | TypeScript | 5.x | 类型安全 |
| 构建 | Vite | 5.x | 快速构建 |
| UI 组件 | Element Plus | 2.x | **仅使用基础组件** |
| Markdown 编辑器 | Editor.md | 1.5.0 | **核心组件** |
| Markdown 渲染 | marked + highlight.js | Latest | 渲染 + 代码高亮 |
| 状态管理 | Pinia | 2.x | - |
| 路由 | Vue Router | 4.x | - |
| HTTP | Axios | 1.x | - |

---

## 2. 项目结构

```
code/frontend/
├── public/
│   └── editor.md/           # Editor.md 库
│       ├── css/
│       ├── js/
│       ├── lib/
│       └── plugins/
├── src/
│   ├── main.ts              # 入口文件
│   ├── App.vue              # 根组件
│   ├── api/                 # API 接口
│   │   ├── index.ts         # Axios 实例
│   │   ├── auth.ts          # 认证接口
│   │   ├── article.ts       # 文章接口
│   │   ├── category.ts      # 分类接口
│   │   └── tag.ts           # 标签接口
│   ├── components/          # 公共组件
│   │   ├── NavBar.vue       # 导航栏
│   │   ├── ArticleCard.vue  # 文章卡片
│   │   ├── Pagination.vue   # 分页器
│   │   └── MarkdownEditor.vue # Markdown 编辑器
│   ├── views/               # 页面组件
│   │   ├── Home.vue         # 首页
│   │   ├── ArticleDetail.vue # 文章详情
│   │   ├── Login.vue        # 登录页
│   │   ├── ArticleEdit.vue  # 文章编辑
│   │   ├── ArticleManage.vue # 文章管理
│   │   └── Admin.vue        # 管理后台
│   ├── router/              # 路由配置
│   │   └── index.ts
│   ├── stores/              # Pinia 状态
│   │   ├── user.ts
│   │   └── article.ts
│   ├── utils/               # 工具函数
│   │   ├── request.ts       # HTTP 封装
│   │   ├── markdown.ts      # Markdown 渲染
│   │   └── format.ts        # 格式化工具
│   └── types/               # TypeScript 类型
│       └── index.ts
├── package.json
├── vite.config.ts
├── tsconfig.json
└── index.html
```

---

## 3. 页面设计

### 3.1 页面清单

| 页面名称 | 路由 | 权限 | 优先级 | 状态 |
|----------|------|------|--------|------|
| 首页 | `/` | 公开 | P0 | ✅ |
| 文章详情 | `/article/:id` | 公开/受限 | P0 | ✅ |
| 登录页 | `/login` | 公开 | P0 | ✅ |
| 文章编辑 | `/article/edit` | author/admin | P0 | ✅ |
| 文章管理 | `/article/manage` | author/admin | P1 | ⏳ |
| 管理后台 | `/admin` | admin | P1 | ⏳ |

---

### 3.2 首页（文章列表）

**路由:** `/`  
**权限:** 公开

**页面结构:**
```
┌─────────────────────────────────────┐
│           导航栏                     │
│   博客系统    [登录] [管理后台]      │
├─────────────────────────────────────┤
│  搜索框  [分类筛选] [标签筛选] [搜索] │
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐    │
│  │  文章卡片 1                   │    │
│  │  标题、摘要、作者、时间        │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │  文章卡片 2                   │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │  文章卡片 3                   │    │
│  └─────────────────────────────┘    │
├─────────────────────────────────────┤
│         分页器                       │
│   < 1 2 3 4 5 >  共 100 条           │
└─────────────────────────────────────┘
```

**组件结构:**
```vue
<!-- Home.vue -->
<template>
  <div class="home-page">
    <NavBar />
    <div class="content">
      <!-- 搜索筛选栏 -->
      <div class="search-bar">
        <el-input 
          v-model="keyword" 
          placeholder="搜索文章"
          clearable
          @keyup.enter="handleSearch"
        />
        <el-select v-model="categoryId" placeholder="选择分类" clearable>
          <el-option 
            v-for="cat in categories" 
            :key="cat.id"
            :label="cat.name"
            :value="cat.id"
          />
        </el-select>
        <el-select v-model="tagId" placeholder="选择标签" clearable>
          <el-option 
            v-for="tag in tags" 
            :key="tag.id"
            :label="tag.name"
            :value="tag.id"
          />
        </el-select>
        <el-button type="primary" @click="handleSearch">搜索</el-button>
      </div>
      
      <!-- 文章列表 -->
      <div class="article-list">
        <ArticleCard 
          v-for="article in articleList" 
          :key="article.id"
          :article="article"
          @click="goToDetail(article.id)"
        />
      </div>
      
      <!-- 分页器 -->
      <el-pagination
        v-model:current-page="page"
        v-model:page-size="pageSize"
        :total="total"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next"
        @current-change="loadArticles"
        @size-change="loadArticles"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { articleApi } from '@/api/article'
import { categoryApi } from '@/api/category'
import { tagApi } from '@/api/tag'
import ArticleCard from '@/components/ArticleCard.vue'

const router = useRouter()

// 响应式数据
const keyword = ref('')
const categoryId = ref<number | undefined>()
const tagId = ref<number | undefined>()
const page = ref(1)
const pageSize = ref(20)
const total = ref(0)
const articleList = ref<any[]>([])
const categories = ref<any[]>([])
const tags = ref<any[]>([])

// 加载文章
const loadArticles = async () => {
  try {
    const res = await articleApi.getList({
      page: page.value,
      pageSize: pageSize.value,
      categoryId: categoryId.value,
      tagId: tagId.value,
      keyword: keyword.value
    })
    articleList.value = res.list
    total.value = res.pagination.total
  } catch (error) {
    console.error('加载文章失败', error)
  }
}

// 加载分类和标签
const loadCategories = async () => {
  categories.value = await categoryApi.getList()
}

const loadTags = async () => {
  tags.value = await tagApi.getList()
}

// 搜索
const handleSearch = () => {
  page.value = 1
  loadArticles()
}

// 跳转详情
const goToDetail = (id: number) => {
  router.push(`/article/${id}`)
}

// 初始化
onMounted(() => {
  loadArticles()
  loadCategories()
  loadTags()
})
</script>

<style scoped lang="scss">
.home-page {
  min-height: 100vh;
  background: #f5f5f5;
}

.content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.search-bar {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
  background: #fff;
  padding: 20px;
  border-radius: 4px;
}

.article-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}
</style>
```

**API 调用:**
```typescript
// api/article.ts
import request from '@/utils/request'

export interface Article {
  id: number
  title: string
  slug: string
  summary: string
  coverImage: string
  categoryId: number
  categoryName: string
  authorId: number
  authorName: string
  accessLevel: number
  viewCount: number
  likeCount: number
  publishedAt: string
  tags: Array<{ id: number; name: string; slug: string }>
}

export interface ArticleListParams {
  page?: number
  pageSize?: number
  categoryId?: number
  tagId?: number
  keyword?: string
}

export interface ArticleListResponse {
  list: Article[]
  pagination: {
    page: number
    pageSize: number
    total: number
    totalPages: number
  }
}

export const articleApi = {
  // 获取文章列表
  getList(params: ArticleListParams): Promise<ArticleListResponse> {
    return request.get('/articles', { params })
  }
}
```

---

### 3.3 文章详情页

**路由:** `/article/:id`  
**权限:** 根据文章 access_level 决定

**页面结构:**
```
┌─────────────────────────────────────┐
│           导航栏                     │
├─────────────────────────────────────┤
│  ← 返回                             │
├─────────────────────────────────────┤
│           文章标题                   │
│   作者 | 发布时间 | 浏览数           │
├─────────────────────────────────────┤
│                                     │
│         文章正文（HTML 渲染）         │
│                                     │
│   # 工作日志                         │
│   ## 完成的任务                      │
│   - [x] 需求分析                    │
│   - [x] 任务分发                    │
│                                     │
│   ```java                           │
│   public class Test {}              │
│   ```                               │
│                                     │
├─────────────────────────────────────┤
│   分类：技术文章                     │
│   标签：Java, Spring Boot           │
├─────────────────────────────────────┤
│   [编辑] [删除]  (仅作者/管理员显示)  │
└─────────────────────────────────────┘
```

**组件结构:**
```vue
<!-- ArticleDetail.vue -->
<template>
  <div class="article-detail">
    <NavBar />
    <div class="content">
      <!-- 返回按钮 -->
      <el-button @click="$router.back()">← 返回</el-button>
      
      <!-- 文章头部 -->
      <div class="article-header">
        <h1>{{ article.title }}</h1>
        <div class="meta">
          <span class="author">
            <el-avatar :size="24" :src="article.authorAvatar" />
            {{ article.authorName }}
          </span>
          <span class="time">{{ formatTime(article.publishedAt) }}</span>
          <span class="views">浏览 {{ article.viewCount }}</span>
        </div>
      </div>
      
      <!-- 文章内容 -->
      <div class="article-content" v-html="article.contentHtml" />
      
      <!-- 标签 -->
      <div class="tags">
        <el-tag 
          v-for="tag in article.tags" 
          :key="tag.id"
          size="small"
        >
          {{ tag.name }}
        </el-tag>
      </div>
      
      <!-- 操作按钮 -->
      <div class="actions" v-if="canEdit">
        <el-button @click="handleEdit">编辑</el-button>
        <el-button type="danger" @click="handleDelete">删除</el-button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { articleApi } from '@/api/article'
import { useUserStore } from '@/stores/user'
import { renderMarkdown } from '@/utils/markdown'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const article = ref<any>(null)
const loading = ref(true)

// 是否可以编辑
const canEdit = computed(() => {
  if (!userStore.isLoggedIn) return false
  const role = userStore.user?.role
  if (role === 'admin') return true
  return article.value?.authorId === userStore.user?.id
})

// 加载文章
const loadArticle = async () => {
  try {
    loading.value = true
    const res = await articleApi.getById(Number(route.params.id))
    article.value = res
  } catch (error) {
    console.error('加载文章失败', error)
  } finally {
    loading.value = false
  }
}

// 编辑
const handleEdit = () => {
  router.push(`/article/edit/${article.value.id}`)
}

// 删除
const handleDelete = async () => {
  try {
    await ElMessageBox.confirm('确定删除该文章？', '提示', {
      type: 'warning'
    })
    await articleApi.delete(article.value.id)
    ElMessage.success('删除成功')
    router.back()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除失败', error)
    }
  }
}

// 格式化时间
const formatTime = (time: string) => {
  return new Date(time).toLocaleString('zh-CN')
}

onMounted(() => {
  loadArticle()
})
</script>

<style scoped lang="scss">
.article-detail {
  min-height: 100vh;
  background: #fff;
}

.content {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
}

.article-header {
  margin-bottom: 30px;
  border-bottom: 1px solid #eee;
  padding-bottom: 20px;
  
  h1 {
    font-size: 28px;
    margin-bottom: 16px;
  }
  
  .meta {
    display: flex;
    align-items: center;
    gap: 16px;
    color: #666;
    font-size: 14px;
  }
}

.article-content {
  :deep(h1), :deep(h2), :deep(h3) {
    margin-top: 24px;
    margin-bottom: 16px;
  }
  
  :deep(p) {
    line-height: 1.8;
    margin-bottom: 16px;
  }
  
  :deep(pre) {
    background: #f6f8fa;
    padding: 16px;
    border-radius: 4px;
    overflow-x: auto;
  }
  
  :deep(table) {
    width: 100%;
    border-collapse: collapse;
    margin: 16px 0;
    
    th, td {
      border: 1px solid #dfe2e5;
      padding: 8px 12px;
    }
    
    th {
      background: #f6f8fa;
    }
  }
}

.tags {
  margin-top: 20px;
  display: flex;
  gap: 8px;
}

.actions {
  margin-top: 30px;
  padding-top: 20px;
  border-top: 1px solid #eee;
}
</style>
```

---

### 3.4 登录页

**路由:** `/login`  
**权限:** 公开

**页面结构:**
```
┌─────────────────────────────────────┐
│                                     │
│           博客系统                   │
│                                     │
│    ┌─────────────────────────┐     │
│    │      手机号登录          │     │
│    │                         │     │
│    │  [请输入手机号]          │     │
│    │                         │     │
│    │     [登录按钮]          │     │
│    │                         │     │
│    └─────────────────────────┘     │
│                                     │
└─────────────────────────────────────┘
```

**组件结构:**
```vue
<!-- Login.vue -->
<template>
  <div class="login-page">
    <div class="login-box">
      <h1 class="title">博客系统</h1>
      <el-form 
        :model="form" 
        :rules="rules" 
        ref="formRef"
        label-width="0"
      >
        <el-form-item prop="phone">
          <el-input 
            v-model="form.phone" 
            placeholder="请输入手机号"
            maxlength="11"
            size="large"
            prefix-icon="Iphone"
          />
        </el-form-item>
        <el-form-item>
          <el-button 
            type="primary" 
            :loading="loading"
            @click="handleLogin"
            size="large"
            style="width: 100%"
          >
            登录
          </el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElForm, ElFormItem, ElInput, ElButton, ElMessage } from 'element-plus'
import { authApi } from '@/api/auth'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const userStore = useUserStore()
const formRef = ref()

const form = reactive({
  phone: ''
})

const rules = {
  phone: [
    { required: true, message: '请输入手机号', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '手机号格式错误', trigger: 'blur' }
  ]
}

const loading = ref(false)

const handleLogin = async () => {
  try {
    await formRef.value.validate()
    loading.value = true
    
    const res = await authApi.login(form.phone)
    
    // 保存 Token 和用户信息
    userStore.setToken(res.token)
    userStore.setUser(res.user)
    
    ElMessage.success('登录成功')
    router.push('/')
  } catch (error) {
    console.error('登录失败', error)
  } finally {
    loading.value = false
  }
}
</script>

<style scoped lang="scss">
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.login-box {
  width: 400px;
  padding: 40px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  
  .title {
    text-align: center;
    font-size: 24px;
    margin-bottom: 30px;
    color: #333;
  }
}
</style>
```

---

### 3.5 文章编辑页

**路由:** `/article/edit` (新建)  
**路由:** `/article/edit/:id` (编辑)  
**权限:** author/admin

**页面结构:**
```
┌─────────────────────────────────────────────┐
│  ← 返回                    [保存] [预览]    │
├─────────────────────────────────────────────┤
│  标题：[_______________________________]    │
├─────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐        │
│  │              │  │              │        │
│  │  Markdown    │  │   实时预览   │        │
│  │  编辑器      │  │              │        │
│  │              │  │              │        │
│  │              │  │              │        │
│  └──────────────┘  └──────────────┘        │
├─────────────────────────────────────────────┤
│  分类：[下拉选择]   标签：[多选]            │
│  访问级别：○ 公开 ○ 登录可见 ○ VIP         │
│  封面图：[_______________________________]  │
└─────────────────────────────────────────────┘
```

**组件结构:**
```vue
<!-- ArticleEdit.vue -->
<template>
  <div class="article-edit">
    <!-- 顶部操作栏 -->
    <div class="header">
      <el-button @click="$router.back()">← 返回</el-button>
      <div class="actions">
        <el-button @click="handlePreview">预览</el-button>
        <el-button type="primary" :loading="saving" @click="handleSave">
          {{ isEdit ? '保存' : '发布' }}
        </el-button>
      </div>
    </div>
    
    <el-form :model="form" label-width="80px">
      <!-- 标题 -->
      <el-form-item label="标题">
        <el-input v-model="form.title" placeholder="请输入文章标题" />
      </el-form-item>
      
      <!-- Markdown 编辑器 -->
      <el-form-item label="内容">
        <MarkdownEditor v-model="form.contentMd" />
      </el-form-item>
      
      <!-- 摘要 -->
      <el-form-item label="摘要">
        <el-input 
          v-model="form.summary" 
          type="textarea"
          :rows="2"
          placeholder="文章摘要（可选）"
        />
      </el-form-item>
      
      <!-- 分类 -->
      <el-form-item label="分类">
        <el-select v-model="form.categoryId" placeholder="请选择分类">
          <el-option 
            v-for="cat in categories" 
            :key="cat.id"
            :label="cat.name"
            :value="cat.id"
          />
        </el-select>
      </el-form-item>
      
      <!-- 标签 -->
      <el-form-item label="标签">
        <el-select v-model="form.tagIds" multiple placeholder="请选择标签">
          <el-option 
            v-for="tag in tags" 
            :key="tag.id"
            :label="tag.name"
            :value="tag.id"
          />
        </el-select>
      </el-form-item>
      
      <!-- 访问级别 -->
      <el-form-item label="访问级别">
        <el-radio-group v-model="form.accessLevel">
          <el-radio :label="0">公开</el-radio>
          <el-radio :label="1">登录可见</el-radio>
          <el-radio :label="2">VIP</el-radio>
        </el-radio-group>
      </el-form-item>
      
      <!-- 封面图 -->
      <el-form-item label="封面图">
        <el-input v-model="form.coverImage" placeholder="封面图 URL（可选）" />
      </el-form-item>
    </el-form>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { articleApi } from '@/api/article'
import { categoryApi } from '@/api/category'
import { tagApi } from '@/api/tag'
import MarkdownEditor from '@/components/MarkdownEditor.vue'

const route = useRoute()
const router = useRouter()

const isEdit = computed(() => !!route.params.id)
const saving = ref(false)
const categories = ref<any[]>([])
const tags = ref<any[]>([])

const form = reactive({
  title: '',
  contentMd: '',
  summary: '',
  categoryId: undefined as number | undefined,
  tagIds: [] as number[],
  accessLevel: 0,
  coverImage: ''
})

// 加载分类和标签
const loadCategories = async () => {
  categories.value = await categoryApi.getList()
}

const loadTags = async () => {
  tags.value = await tagApi.getList()
}

// 加载文章（编辑模式）
const loadArticle = async () => {
  if (!isEdit.value) return
  const article = await articleApi.getById(Number(route.params.id))
  form.title = article.title
  form.contentMd = article.contentMd
  form.summary = article.summary
  form.categoryId = article.categoryId
  form.tagIds = article.tags.map((t: any) => t.id)
  form.accessLevel = article.accessLevel
  form.coverImage = article.coverImage || ''
}

// 保存
const handleSave = async () => {
  try {
    saving.value = true
    
    if (isEdit.value) {
      await articleApi.update(Number(route.params.id), form)
      ElMessage.success('更新成功')
    } else {
      await articleApi.create(form)
      ElMessage.success('发布成功')
    }
    
    router.push('/article/manage')
  } catch (error) {
    console.error('保存失败', error)
  } finally {
    saving.value = false
  }
}

// 预览
const handlePreview = () => {
  // TODO: 弹窗预览
}

onMounted(() => {
  loadCategories()
  loadTags()
  loadArticle()
})
</script>

<style scoped lang="scss">
.article-edit {
  min-height: 100vh;
  background: #f5f5f5;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: #fff;
  padding: 16px 20px;
  border-bottom: 1px solid #eee;
  
  .actions {
    display: flex;
    gap: 10px;
  }
}

.el-form {
  max-width: 1200px;
  margin: 20px auto;
  padding: 20px;
  background: #fff;
  border-radius: 4px;
}
</style>
```

---

## 4. Markdown 编辑器组件

### 4.1 组件实现

```vue
<!-- components/MarkdownEditor.vue -->
<template>
  <div class="markdown-editor">
    <div ref="editorContainer"></div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'

const props = defineProps<{
  modelValue?: string
}>()

const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

const editorContainer = ref<HTMLElement>()
let editor: any = null

onMounted(() => {
  if (!editorContainer.value) return
  
  // 初始化 Editor.md
  editor = editormarkdown('markdown-editor', {
    width: '100%',
    height: 600,
    path: '/editor.md/lib/',
    markdown: props.modelValue || '',
    codeFold: true,
    saveHTMLToTextarea: false,
    search: true,
    fullscreen: true,
    onload: function() {
      // 监听变化
      this.watch(() => {
        emit('update:modelValue', this.getMarkdown())
      })
    }
  })
})

// 监听外部变化
watch(() => props.modelValue, (newVal) => {
  if (editor && newVal !== editor.getMarkdown()) {
    editor.setMarkdown(newVal)
  }
})

defineExpose({
  getMarkdown: () => editor?.getMarkdown() || ''
})
</script>

<style scoped lang="scss">
.markdown-editor {
  :deep(.editormd) {
    border: 1px solid #dcdfe6;
    border-radius: 4px;
  }
}
</style>
```

---

## 5. 状态管理

### 5.1 用户状态

```typescript
// stores/user.ts
import { defineStore } from 'pinia'

export interface UserInfo {
  id: number
  phone: string
  nickname: string
  avatar: string
  role: 'user' | 'author' | 'admin'
  accessLevel: number
}

export interface UserState {
  token: string | null
  user: UserInfo | null
}

export const useUserStore = defineStore('user', {
  state: (): UserState => ({
    token: localStorage.getItem('token'),
    user: JSON.parse(localStorage.getItem('user') || 'null')
  }),
  
  getters: {
    isLoggedIn: (state) => !!state.token,
    userRole: (state) => state.user?.role,
    isAdmin: (state) => state.user?.role === 'admin',
    isAuthor: (state) => state.user?.role === 'author'
  },
  
  actions: {
    setToken(token: string) {
      this.token = token
      localStorage.setItem('token', token)
    },
    
    setUser(user: UserInfo) {
      this.user = user
      localStorage.setItem('user', JSON.stringify(user))
    },
    
    logout() {
      this.token = null
      this.user = null
      localStorage.removeItem('token')
      localStorage.removeItem('user')
    }
  }
})
```

---

## 6. API 封装

### 6.1 HTTP 请求封装

```typescript
// utils/request.ts
import axios from 'axios'
import { ElMessage } from 'element-plus'
import router from '@/router'

const request = axios.create({
  baseURL: '/api/v1',
  timeout: 10000
})

// 请求拦截器
request.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// 响应拦截器
request.interceptors.response.use(
  response => {
    const { code, message, data } = response.data
    if (code === 0) {
      return data
    } else {
      ElMessage.error(message)
      return Promise.reject(new Error(message))
    }
  },
  error => {
    if (error.response?.status === 401) {
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      router.push('/login')
    } else if (error.response?.status === 403) {
      ElMessage.error('权限不足')
    } else {
      ElMessage.error(error.message || '请求失败')
    }
    return Promise.reject(error)
  }
)

export default request
```

---

## 7. 验收标准

### 7.1 功能验收

- [ ] 首页能正常展示文章列表
- [ ] 文章详情能正确渲染 Markdown（代码块、表格、任务列表）
- [ ] 登录功能正常（手机号登录）
- [ ] 编辑器能正常编辑 Markdown
- [ ] 保存文章成功
- [ ] 权限控制正确（未登录不能访问受限页面）

### 7.2 性能验收

- [ ] 首屏加载时间 < 2s
- [ ] 文章详情加载 < 1s
- [ ] 编辑器加载 < 1s

### 7.3 代码质量

- [ ] TypeScript 无类型错误
- [ ] 无控制台错误
- [ ] 组件有基本注释

---

**文档结束**
