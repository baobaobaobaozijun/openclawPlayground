<template>
  <div class="home">
    <h1>OpenClaw Frontend</h1>
    <p>Vue 3 + TypeScript + Vite</p>
    <div class="status">
      <h2>系统状态</h2>
      <ul>
        <li>✅ Vue 3 已初始化</li>
        <li>✅ TypeScript 已配置</li>
        <li>✅ Vue Router 已配置</li>
        <li>✅ Pinia 状态管理已配置</li>
      </ul>
    </div>
  </div>
</template>

<script setup lang="ts">
// Home View Component
</script>

<style scoped>
.home {
  max-width: 800px;
  margin: 0 auto;
  padding: 40px 20px;
  text-align: center;
}

h1 {
  color: #42b983;
  margin-bottom: 10px;
}

p {
  color: #666;
  margin-bottom: 30px;
}

.status {
  background: #f5f5f5;
  border-radius: 8px;
  padding: 20px;
  text-align: left;
}

.status h2 {
  margin-bottom: 15px;
  color: #333;
}

.status ul {
  list-style: none;
  padding: 0;
}

.status li {
  padding: 8px 0;
  color: #555;
}
</style>
