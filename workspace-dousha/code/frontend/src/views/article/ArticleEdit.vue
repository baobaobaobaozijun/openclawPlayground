<template>
  <div class="article-editor" v-loading="loading">
    <!-- 页面头部 -->
    <div class="editor-header">
      <div class="header-left">
        <el-button @click="goBack">
          <el-icon><ArrowLeft /></el-icon>
          返回
        </el-button>
        <h2 class="page-title">
          {{ isEdit ? '编辑文章' : '新建文章' }}
        </h2>
      </div>
      <div class="header-right">
        <el-button @click="handleSaveDraft">
          保存草稿
        </el-button>
        <el-button type="primary" @click="handleSubmit">
          {{ isEdit ? '保存' : '发布' }}
        </el-button>
      </div>
    </div>

    <!-- 表单内容 -->
    <el-form
      ref="formRef"
      :model="formData"
      :rules="formRules"
      label-position="top"
      class="editor-form"
    >
      <!-- 标题 -->
      <el-form-item label="文章标题" prop="title">
        <el-input
          v-model="formData.title"
          placeholder="请输入文章标题"
          maxlength="100"
          show-word-limit
          size="large"
        />
      </el-form-item>

      <!-- 摘要 -->
      <el-form-item label="文章摘要" prop="summary">
        <el-input
          v-model="formData.summary"
          type="textarea"
          :rows="3"
          placeholder="请输入文章摘要（200 字以内）"
          maxlength="200"
          show-word-limit
        />
      </el-form-item>

      <!-- 分类和标签 -->
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="文章分类" prop="categoryId">
            <el-select
              v-model="formData.categoryId"
              placeholder="请选择分类"
              style="width: 100%"
            >
              <el-option
                v-for="category in articleStore.categories"
                :key="category.id"
                :label="category.name"
                :value="category.id"
              />
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="文章标签" prop="tagIds">
            <el-select
              v-model="formData.tagIds"
              multiple
              placeholder="请选择标签"
              style="width: 100%"
            >
              <el-option
                v-for="tag in articleStore.tags"
                :key="tag.id"
                :label="tag.name"
                :value="tag.id"
              />
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>

      <!-- 封面图片 -->
      <el-form-item label="封面图片" prop="coverImage">
        <el-input
          v-model="formData.coverImage"
          placeholder="请输入封面图片 URL"
        />
        <div class="cover-preview" v-if="formData.coverImage">
          <el-image
            :src="formData.coverImage"
            fit="cover"
            class="preview-image"
            :preview-src-list="[formData.coverImage]"
          />
        </div>
      </el-form-item>

      <!-- 文章内容 -->
      <el-form-item label="文章内容" prop="content">
        <div class="editor-toolbar">
          <el-button-group>
            <el-button @click="insertMarkdown('**', '**')" title="加粗">
              <strong>B</strong>
            </el-button>
            <el-button @click="insertMarkdown('*', '*')" title="斜体">
              <em>I</em>
            </el-button>
            <el-button @click="insertMarkdown('# ', '')" title="标题">
              H
            </el-button>
            <el-button @click="insertMarkdown('- ', '')" title="列表">
              列表
            </el-button>
            <el-button @click="insertMarkdown('[', '](url)')" title="链接">
              链接
            </el-button>
            <el-button @click="insertMarkdown('![', '](url)')" title="图片">
              图片
            </el-button>
          </el-button-group>
        </div>
        <el-input
          v-model="formData.content"
          type="textarea"
          :rows="20"
          placeholder="请输入文章内容（支持 Markdown 语法）"
          class="content-editor"
        />
        <div class="editor-tips">
          <el-icon><InfoFilled /></el-icon>
          <span>支持 Markdown 语法，预览效果将在保存后显示</span>
        </div>
      </el-form-item>

      <!-- 发布设置 -->
      <el-form-item label="发布设置">
        <el-radio-group v-model="formData.status">
          <el-radio label="draft">草稿</el-radio>
          <el-radio label="published">立即发布</el-radio>
        </el-radio-group>
      </el-form-item>
    </el-form>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage, type FormInstance, type FormRules } from 'element-plus'
import { ArrowLeft, InfoFilled } from '@element-plus/icons-vue'
import { useArticleStore } from '@/stores/article'
import type { ArticleCreateRequest, ArticleUpdateRequest } from '@/types'

const router = useRouter()
const route = useRoute()
const articleStore = useArticleStore()

const formRef = ref<FormInstance>()
const loading = ref(false)

// 是否为编辑模式
const isEdit = computed(() => !!route.params.id)

// 表单数据
const formData = reactive<ArticleCreateRequest & { id?: number }>({
  title: '',
  content: '',
  summary: '',
  categoryId: undefined as any,
  tagIds: [],
  status: 'draft',
  coverImage: ''
})

// 表单验证规则
const formRules: FormRules = {
  title: [
    { required: true, message: '请输入文章标题', trigger: 'blur' },
    { min: 2, max: 100, message: '标题长度在 2 到 100 个字符', trigger: 'blur' }
  ],
  summary: [
    { required: true, message: '请输入文章摘要', trigger: 'blur' },
    { max: 200, message: '摘要不能超过 200 个字符', trigger: 'blur' }
  ],
  categoryId: [
    { required: true, message: '请选择文章分类', trigger: 'change' }
  ],
  content: [
    { required: true, message: '请输入文章内容', trigger: 'blur' },
    { min: 10, message: '文章内容不能少于 10 个字符', trigger: 'blur' }
  ]
}

// 插入 Markdown 语法
const insertMarkdown = (prefix: string, suffix: string) => {
  const textarea = document.querySelector('.content-editor textarea') as HTMLTextAreaElement
  if (!textarea) return
  
  const start = textarea.selectionStart
  const end = textarea.selectionEnd
  const selectedText = formData.content.substring(start, end)
  
  const before = formData.content.substring(0, start)
  const after = formData.content.substring(end)
  
  formData.content = before + prefix + selectedText + suffix + after
  
  // 恢复光标位置
  setTimeout(() => {
    textarea.focus()
    textarea.selectionStart = start + prefix.length
    textarea.selectionEnd = end + prefix.length
  }, 0)
}

// 返回列表
const goBack = () => {
  router.back()
}

// 加载文章数据
const loadArticle = async () => {
  const id = Number(route.params.id)
  if (id && articleStore.articles.find(a => a.id === id)) {
    const article = articleStore.articles.find(a => a.id === id)!
    formData.title = article.title
    formData.content = article.content
    formData.summary = article.summary
    formData.categoryId = article.category.id
    formData.tagIds = article.tags.map(t => t.id)
    formData.status = article.status
    formData.coverImage = article.coverImage || ''
  } else if (id) {
    loading.value = true
    try {
      const article = await articleStore.fetchArticleDetail(id)
      formData.title = article.title
      formData.content = article.content
      formData.summary = article.summary
      formData.categoryId = article.category.id
      formData.tagIds = article.tags.map(t => t.id)
      formData.status = article.status
      formData.coverImage = article.coverImage || ''
    } catch (error) {
      console.error('加载文章失败:', error)
    } finally {
      loading.value = false
    }
  }
}

// 保存草稿
const handleSaveDraft = async () => {
  formData.status = 'draft'
  await handleSubmit()
}

// 提交表单
const handleSubmit = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    
    loading.value = true
    try {
      if (isEdit.value && route.params.id) {
        // 更新文章
        const data: ArticleUpdateRequest = {
          id: Number(route.params.id),
          title: formData.title,
          content: formData.content,
          summary: formData.summary,
          categoryId: formData.categoryId,
          tagIds: formData.tagIds,
          status: formData.status,
          coverImage: formData.coverImage || undefined
        }
        await articleStore.updateExistingArticle(data)
        ElMessage.success('文章更新成功')
      } else {
        // 创建文章
        const data: ArticleCreateRequest = {
          title: formData.title,
          content: formData.content,
          summary: formData.summary,
          categoryId: formData.categoryId,
          tagIds: formData.tagIds,
          status: formData.status,
          coverImage: formData.coverImage || undefined
        }
        await articleStore.createNewArticle(data)
        ElMessage.success(formData.status === 'published' ? '文章发布成功' : '草稿保存成功')
      }
      
      router.push('/article')
    } catch (error) {
      console.error('保存文章失败:', error)
    } finally {
      loading.value = false
    }
  })
}

// 初始化
onMounted(async () => {
  await articleStore.fetchCategories()
  await articleStore.fetchTags()
  if (isEdit.value) {
    await loadArticle()
  }
})
</script>

<style scoped lang="scss">
.article-editor {
  padding: 24px;
  background: #fff;
  border-radius: 8px;
  min-height: calc(100vh - 120px);
}

.editor-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  padding-bottom: 24px;
  border-bottom: 1px solid #eaeaea;
  
  .header-left {
    display: flex;
    align-items: center;
    gap: 16px;
    
    .page-title {
      margin: 0;
      font-size: 24px;
      font-weight: 600;
      color: #1a1a1a;
    }
  }
}

.editor-form {
  max-width: 900px;
  margin: 0 auto;
  
  :deep(.el-form-item__label) {
    font-weight: 500;
    color: #333;
  }
}

.cover-preview {
  margin-top: 12px;
  
  .preview-image {
    width: 200px;
    height: 120px;
    border-radius: 8px;
    object-fit: cover;
  }
}

.editor-toolbar {
  margin-bottom: 12px;
}

.content-editor {
  :deep(textarea) {
    font-family: 'Consolas', 'Monaco', monospace;
    font-size: 14px;
    line-height: 1.6;
  }
}

.editor-tips {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 8px;
  padding: 8px 12px;
  background: #f0f9eb;
  border-radius: 4px;
  font-size: 13px;
  color: #67c23a;
}
</style>
