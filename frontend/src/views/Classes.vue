<template>
  <component :is="currentComponent" />
</template>

<script setup>
import { shallowRef, onMounted } from 'vue'
import { isMobile } from '../utils/device.js'

const currentComponent = shallowRef(null)

onMounted(async () => {
  if (isMobile()) {
    const module = await import('./mobile/ClassesMobile.vue')
    currentComponent.value = module.default
  } else {
    const module = await import('./ClassesDesktop.vue')
    currentComponent.value = module.default
  }
})
</script>
