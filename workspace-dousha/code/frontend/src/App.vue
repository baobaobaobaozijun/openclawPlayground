<template>
  <div id="app">
    <router-view />
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'

onMounted(() => {
  console.log('应用已启动')
})
</script>

<style>
#app {
  width: 100%;
  min-height: 100vh;
}
</style>
