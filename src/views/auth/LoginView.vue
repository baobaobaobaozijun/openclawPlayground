<template>
  <div class="login-container">
    <div class="login-form">
      <h2>用户登录</h2>
      <form @submit.prevent="handleLogin">
        <div class="form-group">
          <label for="username">用户名</label>
          <input 
            id="username" 
            v-model="loginForm.username" 
            type="text" 
            placeholder="请输入用户名"
            :class="{ 'error': errors.username }"
          />
          <span v-if="errors.username" class="error-message">{{ errors.username }}</span>
        </div>
        
        <div class="form-group">
          <label for="password">密码</label>
          <input 
            id="password" 
            v-model="loginForm.password" 
            type="password" 
            placeholder="请输入密码"
            :class="{ 'error': errors.password }"
          />
          <span v-if="errors.password" class="error-message">{{ errors.password }}</span>
        </div>
        
        <div class="form-actions">
          <button type="submit" :disabled="loading" class="login-btn">
            <span v-if="loading">登录中...</span>
            <span v-else>登录</span>
          </button>
        </div>
        
        <div class="form-footer">
          <p>还没有账号？<router-link to="/register">立即注册</router-link></p>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'

// 模拟API调用
const mockLogin = async (credentials: { username: string; password: string }) => {
  // 模拟API延迟
  await new Promise(resolve => setTimeout(resolve, 1000))
  
  // 模拟成功响应
  if (credentials.username && credentials.password.length >= 6) {
    return {
      code: 200,
      data: {
        token: 'mock-jwt-token-' + Date.now(),
        user: {
          id: 1,
          username: credentials.username,
          email: `${credentials.username}@example.com`
        }
      },
      message: 'success'
    }
  } else {
    throw new Error('用户名或密码错误')
  }
}

const router = useRouter()
const loading = ref(false)
const errors = reactive({
  username: '',
  password: ''
})

const loginForm = reactive({
  username: '',
  password: ''
})

const validateForm = (): boolean => {
  // 清除之前的错误
  errors.username = ''
  errors.password = ''
  
  let isValid = true
  
  if (!loginForm.username.trim()) {
    errors.username = '请输入用户名'
    isValid = false
  }
  
  if (!loginForm.password) {
    errors.password = '请输入密码'
    isValid = false
  } else if (loginForm.password.length < 6) {
    errors.password = '密码长度至少6位'
    isValid = false
  }
  
  return isValid
}

const handleLogin = async () => {
  if (!validateForm()) {
    return
  }
  
  loading.value = true
  try {
    const response = await mockLogin(loginForm)
    console.log('Login success:', response)
    
    // 模拟存储token
    localStorage.setItem('token', response.data.token)
    
    // 跳转到首页
    router.push('/dashboard')
  } catch (error: any) {
    console.error('Login failed:', error.message)
    alert(error.message || '登录失败，请重试')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background-color: #f5f5f5;
  padding: 20px;
}

.login-form {
  width: 100%;
  max-width: 400px;
  background: white;
  padding: 30px;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.login-form h2 {
  text-align: center;
  margin-bottom: 24px;
  color: #333;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 6px;
  font-weight: 500;
  color: #333;
}

.form-group input {
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 16px;
  transition: border-color 0.3s;
  box-sizing: border-box;
}

.form-group input:focus {
  outline: none;
  border-color: #409eff;
}

.form-group input.error {
  border-color: #f56c6c;
}

.error-message {
  color: #f56c6c;
  font-size: 14px;
  margin-top: 6px;
  display: block;
}

.form-actions {
  margin: 24px 0;
}

.login-btn {
  width: 100%;
  padding: 12px;
  background-color: #409eff;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.login-btn:hover:not(:disabled) {
  background-color: #66b1ff;
}

.login-btn:disabled {
  background-color: #a0cfff;
  cursor: not-allowed;
}

.form-footer {
  text-align: center;
}

.form-footer a {
  color: #409eff;
  text-decoration: none;
}

.form-footer a:hover {
  text-decoration: underline;
}
</style>