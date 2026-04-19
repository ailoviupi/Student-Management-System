import { createRouter, createWebHashHistory } from 'vue-router'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue')
  },
  {
    path: '/',
    name: 'Layout',
    component: () => import('../views/Layout.vue'),
    redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: () => import('../views/Dashboard.vue'),
        meta: { title: '数据概览', icon: 'Odometer' }
      },
      {
        path: 'students',
        name: 'Students',
        component: () => import('../views/Students.vue'),
        meta: { title: '学生管理', icon: 'User' }
      },
      {
        path: 'classes',
        name: 'Classes',
        component: () => import('../views/Classes.vue'),
        meta: { title: '班级管理', icon: 'School' }
      },
      {
        path: 'courses',
        name: 'Courses',
        component: () => import('../views/Courses.vue'),
        meta: { title: '课程管理', icon: 'Reading' }
      },
      {
        path: 'scores',
        name: 'Scores',
        component: () => import('../views/Scores.vue'),
        meta: { title: '成绩管理', icon: 'Trophy' }
      },
      {
        path: 'score-rank',
        name: 'ScoreRank',
        component: () => import('../views/ScoreRank.vue'),
        meta: { title: '成绩排名', icon: 'Medal' }
      },
      {
        path: 'score-analysis',
        name: 'ScoreAnalysis',
        component: () => import('../views/ScoreAnalysis.vue'),
        meta: { title: '成绩分析', icon: 'DataLine' }
      },
      {
        path: 'attendance',
        name: 'Attendance',
        component: () => import('../views/Attendance.vue'),
        meta: { title: '考勤管理', icon: 'Calendar' }
      },
      {
        path: 'profile',
        name: 'Profile',
        component: () => import('../views/Profile.vue'),
        meta: { title: '个人中心', icon: 'UserFilled' }
      },
      // 学生端专属页面
      {
        path: 'my-scores',
        name: 'MyScores',
        component: () => import('../views/student/MyScores.vue'),
        meta: { title: '我的成绩', icon: 'Trophy', studentOnly: true }
      },
      {
        path: 'my-courses',
        name: 'MyCourses',
        component: () => import('../views/student/MyCourses.vue'),
        meta: { title: '我的课程', icon: 'Reading', studentOnly: true }
      },
      {
        path: 'my-attendance',
        name: 'MyAttendance',
        component: () => import('../views/student/MyAttendance.vue'),
        meta: { title: '我的考勤', icon: 'Calendar', studentOnly: true }
      },
      {
        path: 'my-class',
        name: 'MyClass',
        component: () => import('../views/student/MyClass.vue'),
        meta: { title: '我的班级', icon: 'School', studentOnly: true }
      },
      {
        path: 'settings',
        name: 'Settings',
        component: () => import('../views/Settings.vue'),
        meta: { title: '系统设置', icon: 'Setting' }
      },
      {
        path: 'users',
        name: 'Users',
        component: () => import('../views/Users.vue'),
        meta: { title: '用户管理', icon: 'Setting' }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token')
  if (to.path !== '/login' && !token) {
    next('/login')
  } else if (to.path === '/login' && token) {
    next('/')
  } else {
    next()
  }
})

export default router
