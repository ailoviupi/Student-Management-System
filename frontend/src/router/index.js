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
        path: 'warning',
        name: 'Warning',
        component: () => import('../views/Warning.vue'),
        meta: { title: '学业预警', icon: 'Warning' }
      },
      {
        path: 'export',
        name: 'Export',
        component: () => import('../views/Export.vue'),
        meta: { title: '数据导出', icon: 'Download' }
      },
      {
        path: 'operation-log',
        name: 'OperationLog',
        component: () => import('../views/OperationLog.vue'),
        meta: { title: '操作日志', icon: 'Document', adminOnly: true }
      },
      {
        path: 'notification',
        name: 'Notification',
        component: () => import('../views/Notification.vue'),
        meta: { title: '消息通知', icon: 'Bell' }
      },
      {
        path: 'chat',
        name: 'Chat',
        component: () => import('../views/Chat.vue'),
        meta: { title: '实时通信', icon: 'ChatDotSquare' }
      },
      {
        path: 'scholarship',
        name: 'Scholarship',
        component: () => import('../views/Scholarship.vue'),
        meta: { title: '奖学金评定', icon: 'Trophy' }
      },
      {
        path: 'schedule',
        name: 'Schedule',
        component: () => import('../views/Schedule.vue'),
        meta: { title: '智能排课', icon: 'Calendar' }
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
        path: 'my-homework',
        name: 'MyHomework',
        component: () => import('../views/student/MyHomework.vue'),
        meta: { title: '我的作业', icon: 'Edit', studentOnly: true }
      },
      {
        path: 'my-exams',
        name: 'MyExams',
        component: () => import('../views/student/MyExams.vue'),
        meta: { title: '我的考试', icon: 'Document', studentOnly: true }
      },
      {
        path: 'homework',
        name: 'Homework',
        component: () => import('../views/Homework.vue'),
        meta: { title: '作业管理', icon: 'Edit' }
      },
      {
        path: 'exams',
        name: 'Exams',
        component: () => import('../views/Exams.vue'),
        meta: { title: '考试管理', icon: 'Document' }
      },
      {
        path: 'settings',
        name: 'Settings',
        component: () => import('../views/Settings.vue'),
        meta: { title: '系统设置', icon: 'Setting', adminOnly: true }
      },
      {
        path: 'users',
        name: 'Users',
        component: () => import('../views/Users.vue'),
        meta: { title: '用户管理', icon: 'Setting', adminOnly: true }
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
  const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
  
  if (to.path !== '/login' && !token) {
    next('/login')
  } else if (to.path === '/login' && token) {
    next('/')
  } else {
    // 学生角色的首页重定向到"我的成绩"（数据概览仅管理员/教师可见）
    if (userInfo?.role === 'student' && to.path === '/dashboard') {
      next('/my-scores')
    } else if (to.meta?.adminOnly && userInfo?.role !== 'admin') {
      next('/dashboard')
    } else if (to.meta?.studentOnly && userInfo?.role !== 'student') {
      next('/dashboard')
    } else {
      next()
    }
  }
})

export default router
