/**
 * 路由配置
 */
import { createRouter, createWebHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    redirect: '/article'
  },
  {
    path: '/article',
    name: 'ArticleList',
    component: () => import('@/views/article/ArticleList.vue'),
    meta: {
      title: '文章管理'
    }
  },
  {
    path: '/article/create',
    name: 'ArticleCreate',
    component: () => import('@/views/article/ArticleEdit.vue'),
    meta: {
      title: '新建文章'
    }
  },
  {
    path: '/article/:id',
    name: 'ArticleDetail',
    component: () => import('@/views/article/ArticleDetail.vue'),
    meta: {
      title: '文章详情'
    }
  },
  {
    path: '/article/:id/edit',
    name: 'ArticleEdit',
    component: () => import('@/views/article/ArticleEdit.vue'),
    meta: {
      title: '编辑文章'
    }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  // 设置页面标题
  if (to.meta.title) {
    document.title = `${to.meta.title} - 博客管理系统`
  }
  
  // 检查登录状态（示例）
  const token = localStorage.getItem('access_token')
  const publicPages = ['/login', '/register']
  const authRequired = !publicPages.includes(to.path)
  
  if (authRequired && !token) {
    next('/login')
  } else {
    next()
  }
})

export default router
