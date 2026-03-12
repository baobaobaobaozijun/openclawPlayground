<template>
  <footer class="footer" :class="{ 'dark-mode': isDarkMode }">
    <div class="footer-content">
      <!-- 友情链接 -->
      <div class="footer-links">
        <div class="link-section">
          <h4>关于我们</h4>
          <ul>
            <li><a href="/about">团队介绍</a></li>
            <li><a href="/contact">联系我们</a></li>
            <li><a href="/join">加入我们</a></li>
          </ul>
        </div>
        <div class="link-section">
          <h4>技术栈</h4>
          <ul>
            <li><a href="https://vuejs.org" target="_blank">Vue 3</a></li>
            <li><a href="https://element-plus.org" target="_blank">Element Plus</a></li>
            <li><a href="https://vitejs.dev" target="_blank">Vite</a></li>
            <li><a href="https://www.typescriptlang.org" target="_blank">TypeScript</a></li>
          </ul>
        </div>
        <div class="link-section">
          <h4>友情链接</h4>
          <ul>
            <li><a href="https://github.com" target="_blank">GitHub</a></li>
            <li><a href="https://juejin.cn" target="_blank">掘金</a></li>
            <li><a href="https://segmentfault.com" target="_blank">SegmentFault</a></li>
          </ul>
        </div>
      </div>

      <!-- 版权信息 -->
      <div class="footer-bottom">
        <div class="copyright">
          <p>© 2026 包子铺博客。All rights reserved.</p>
          <p>Powered by OpenClaw Agent Team</p>
        </div>
        <div class="social-links">
          <a href="https://github.com" target="_blank" class="social-link">
            <el-icon><Platform /></el-icon>
          </a>
          <a href="https://weibo.com" target="_blank" class="social-link">
            <el-icon><VideoPlay /></el-icon>
          </a>
          <a href="mailto:contact@baozipu.com" class="social-link">
            <el-icon><Message /></el-icon>
          </a>
        </div>
      </div>
    </div>
  </footer>
</template>

<script setup lang="ts">
import { Platform, VideoPlay, Message } from '@element-plus/icons-vue'

const isDarkMode = ref(false)

onMounted(() => {
  const savedMode = localStorage.getItem('darkMode')
  isDarkMode.value = savedMode === 'true'
})
</script>

<style scoped lang="scss">
.footer {
  background: white;
  border-top: 1px solid #e0e0e0;
  margin-top: 48px;

  &.dark-mode {
    background: #1a1a2e;
    border-top-color: #2a2a3e;
  }
}

.footer-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 48px 24px 24px;
}

.footer-links {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 32px;
  margin-bottom: 32px;

  @media (max-width: 768px) {
    grid-template-columns: 1fr;
  }

  .link-section {
    h4 {
      font-size: 16px;
      font-weight: 600;
      color: #1a1a1a;
      margin: 0 0 16px 0;

      .dark-mode & {
        color: #e0e0e0;
      }
    }

    ul {
      list-style: none;
      padding: 0;
      margin: 0;

      li {
        margin-bottom: 12px;

        a {
          color: #666;
          text-decoration: none;
          font-size: 14px;
          transition: color 0.2s ease;

          .dark-mode & {
            color: #999;
          }

          &:hover {
            color: #667eea;
          }
        }
      }
    }
  }
}

.footer-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 24px;
  border-top: 1px solid #e0e0e0;

  .dark-mode & {
    border-top-color: #2a2a3e;
  }

  @media (max-width: 768px) {
    flex-direction: column;
    gap: 16px;
    text-align: center;
  }

  .copyright {
    p {
      margin: 4px 0;
      font-size: 14px;
      color: #999;
    }
  }

  .social-links {
    display: flex;
    gap: 16px;

    .social-link {
      display: flex;
      align-items: center;
      justify-content: center;
      width: 40px;
      height: 40px;
      border-radius: 50%;
      background: #f5f7fa;
      color: #666;
      text-decoration: none;
      transition: all 0.2s ease;

      .dark-mode & {
        background: #2a2a3e;
        color: #999;
      }

      &:hover {
        background: #667eea;
        color: white;
        transform: translateY(-2px);
      }
    }
  }
}
</style>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
</script>
