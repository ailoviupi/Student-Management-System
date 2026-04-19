<template>
  <el-container class="layout-container">
    <el-aside :width="isCollapse ? '64px' : '220px'" class="aside">
      <div class="logo" @click="$router.push('/')">
        <div class="logo-icon">
          <svg viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M20 4L36 12V28L20 36L4 28V12L20 4Z" stroke="currentColor" stroke-width="2" fill="none"/>
            <circle cx="20" cy="20" r="4" fill="currentColor"/>
          </svg>
        </div>
        <span v-show="!isCollapse" class="logo-text">学生管理系统</span>
      </div>
      <el-menu
        :default-active="$route.path"
        :collapse="isCollapse"
        router
        background-color="transparent"
        text-color="rgba(255,255,255,0.65)"
        active-text-color="#fff"
        class="side-menu"
      >
        <el-menu-item v-for="item in menuItems" :key="item.path" :index="item.path" class="menu-item">
          <el-icon>
            <component :is="item.icon" />
          </el-icon>
          <span>{{ item.title }}</span>
        </el-menu-item>
      </el-menu>
    </el-aside>
    <el-container>
      <el-header class="header">
        <div class="header-left">
          <div class="collapse-btn" @click="isCollapse = !isCollapse">
            <el-icon :size="18"><component :is="isCollapse ? 'Expand' : 'Fold'" /></el-icon>
          </div>
          <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>{{ currentTitle }}</el-breadcrumb-item>
          </el-breadcrumb>
        </div>
        <div class="header-right">
          <div class="role-badge" :class="userRole">
            {{ userRole === 'admin' ? '管理员' : userRole === 'teacher' ? '教师' : '学生' }}
          </div>
          <el-dropdown @command="handleCommand" trigger="click">
            <div class="user-info">
              <div class="avatar">
                {{ (userInfo.realName || userInfo.username || '?')[0] }}
              </div>
              <span class="user-name">{{ userInfo.realName || userInfo.username }}</span>
              <el-icon class="arrow"><ArrowDown /></el-icon>
            </div>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="profile">
                  <el-icon><UserFilled /></el-icon>个人中心
                </el-dropdown-item>
                <el-dropdown-item divided command="logout">
                  <el-icon><SwitchButton /></el-icon>退出登录
                </el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>
      <el-main class="main">
        <router-view v-slot="{ Component }">
          <transition name="fade" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { ArrowDown, UserFilled, SwitchButton, Expand, Fold } from '@element-plus/icons-vue'

const route = useRoute()
const router = useRouter()
const isCollapse = ref(false)

const userInfo = ref(JSON.parse(localStorage.getItem('userInfo') || '{}'))
const userRole = computed(() => userInfo.value?.role || '')

const currentTitle = computed(() => {
  const matched = route.matched[route.matched.length - 1]
  return matched?.meta?.title || ''
})

const menuItems = computed(() => {
  const routes = router.getRoutes().find(r => r.name === 'Layout')?.children || []
  return routes
    .filter(r => {
      // 管理员专属页面
      if (r.path === 'users') return userRole.value === 'admin'
      // 学生专属页面
      if (r.meta?.studentOnly) return userRole.value === 'student'
      // 学生不能访问的管理页面
      if (userRole.value === 'student') {
        const studentForbiddenRoutes = ['students', 'classes', 'courses', 'scores', 'score-rank', 'score-analysis', 'attendance', 'users', 'settings']
        return !studentForbiddenRoutes.includes(r.path)
      }
      // 教师和管理员不显示学生专属页面
      if (r.meta?.studentOnly && userRole.value !== 'student') {
        return false
      }
      return true
    })
    .map(r => ({
      path: '/' + r.path,
      title: r.meta?.title || r.name,
      icon: r.meta?.icon
    }))
})

const handleCommand = (command) => {
  if (command === 'logout') {
    localStorage.removeItem('token')
    localStorage.removeItem('userInfo')
    ElMessage.success('已退出登录')
    router.push('/login')
  } else if (command === 'profile') {
    router.push('/profile')
  }
}
</script>

<style scoped>
.layout-container {
  height: 100vh;
}

.aside {
  background: linear-gradient(180deg, #0f172a 0%, #1e293b 100%);
  transition: width 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  overflow: hidden;
  border-right: 1px solid rgba(255,255,255,0.06);
}

.logo {
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 16px;
  gap: 10px;
  cursor: pointer;
  border-bottom: 1px solid rgba(255,255,255,0.06);
  transition: all 0.3s;
}

.logo:hover {
  background: rgba(255,255,255,0.03);
}

.logo-icon {
  width: 32px;
  height: 32px;
  flex-shrink: 0;
  color: #818cf8;
}

.logo-icon svg {
  width: 100%;
  height: 100%;
}

.logo-text {
  color: #fff;
  font-size: 15px;
  font-weight: 600;
  white-space: nowrap;
  letter-spacing: 0.5px;
}

.side-menu {
  border-right: none !important;
  padding: 8px;
}

.side-menu .menu-item {
  border-radius: 8px !important;
  margin: 2px 0 !important;
  height: 44px !important;
  line-height: 44px !important;
  transition: all 0.2s;
}

.side-menu .menu-item:hover {
  background: rgba(255,255,255,0.06) !important;
}

.side-menu .menu-item.is-active {
  background: linear-gradient(135deg, rgba(99,102,241,0.2), rgba(139,92,246,0.15)) !important;
  color: #fff !important;
  position: relative;
}

.side-menu .menu-item.is-active::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 3px;
  height: 20px;
  background: #6366f1;
  border-radius: 0 3px 3px 0;
}

.header {
  height: 64px;
  background: #fff;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
  z-index: 10;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.collapse-btn {
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  cursor: pointer;
  color: #64748b;
  transition: all 0.2s;
}

.collapse-btn:hover {
  background: #f1f5f9;
  color: #1e293b;
}

:deep(.el-breadcrumb__text) {
  font-size: 13px;
  color: #94a3b8;
}

:deep(.el-breadcrumb__inner.is-link) {
  font-weight: 400;
  color: #94a3b8;
}

:deep(.el-breadcrumb__item:last-child .el-breadcrumb__text) {
  color: #1e293b;
  font-weight: 500;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 16px;
}

.role-badge {
  padding: 4px 12px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 500;
}

.role-badge.admin {
  background: rgba(99,102,241,0.1);
  color: #6366f1;
}

.role-badge.teacher {
  background: rgba(16,185,129,0.1);
  color: #10b981;
}

.role-badge.student {
  background: rgba(245,158,11,0.1);
  color: #f59e0b;
}

.user-info {
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 4px 8px;
  border-radius: 8px;
  transition: all 0.2s;
}

.user-info:hover {
  background: #f1f5f9;
}

.avatar {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  background: linear-gradient(135deg, #6366f1, #8b5cf6);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  font-weight: 600;
}

.user-name {
  font-size: 14px;
  color: #1e293b;
  font-weight: 500;
}

.arrow {
  color: #94a3b8;
  font-size: 12px;
}

.main {
  background: #f1f5f9;
  padding: 24px;
  overflow-y: auto;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
