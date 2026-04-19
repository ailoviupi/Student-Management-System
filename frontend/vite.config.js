import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  base: '/Student-Management-System/',
  server: {
    port: 3000,
    host: '0.0.0.0',  // 允许外部访问
    proxy: {
      '/api': {
        target: 'http://localhost:8083',
        changeOrigin: true
      }
    }
  },
  build: {
    outDir: 'dist',
    assetsDir: 'assets'
  }
})
