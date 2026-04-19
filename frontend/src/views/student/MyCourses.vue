<template>
  <div class="my-courses-page">
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">我的课程</h1>
        <p class="page-subtitle">查看本学期课程安排</p>
      </div>
    </div>

    <!-- 课程表 -->
    <div class="courses-section">
      <div class="section-header">
        <h3 class="section-title">
          <el-icon><Calendar /></el-icon>
          课程表
        </h3>
      </div>

      <div class="schedule-container">
        <div class="schedule-header">
          <div class="time-slot">时间</div>
          <div class="day-header" v-for="day in weekDays" :key="day.value">
            {{ day.label }}
          </div>
        </div>
        
        <div class="schedule-body">
          <div class="time-row" v-for="period in periods" :key="period.value">
            <div class="time-label">{{ period.label }}</div>
            <div 
              class="course-cell" 
              v-for="day in weekDays" 
              :key="day.value"
              :class="{ 'has-course': getCourse(day.value, period.value) }"
            >
              <div v-if="getCourse(day.value, period.value)" class="course-item">
                <div class="course-name">{{ getCourse(day.value, period.value).courseName }}</div>
                <div class="course-info">{{ getCourse(day.value, period.value).teacher }}</div>
                <div class="course-room">{{ getCourse(day.value, period.value).classroom }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <el-empty v-if="courses.length === 0" description="暂无课程数据" />
    </div>

    <!-- 课程列表 -->
    <div class="course-list-section">
      <div class="section-header">
        <h3 class="section-title">
          <el-icon><Reading /></el-icon>
          课程列表
        </h3>
      </div>

      <div class="course-cards">
        <div class="course-card" v-for="course in courses" :key="course.id">
          <div class="course-header">
            <div class="course-code">{{ course.courseCode }}</div>
            <el-tag size="small" :type="course.type === '必修' ? 'danger' : 'success'">
              {{ course.type }}
            </el-tag>
          </div>
          <h4 class="course-title">{{ course.courseName }}</h4>
          <div class="course-details">
            <div class="detail-item">
              <el-icon><User /></el-icon>
              <span>{{ course.teacher }}</span>
            </div>
            <div class="detail-item">
              <el-icon><Location /></el-icon>
              <span>{{ course.classroom }}</span>
            </div>
            <div class="detail-item">
              <el-icon><Clock /></el-icon>
              <span>{{ course.schedule }}</span>
            </div>
            <div class="detail-item">
              <el-icon><Collection /></el-icon>
              <span>{{ course.credits }}学分</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Calendar, Reading, User, Location, Clock, Collection } from '@element-plus/icons-vue'

const weekDays = [
  { label: '周一', value: 1 },
  { label: '周二', value: 2 },
  { label: '周三', value: 3 },
  { label: '周四', value: 4 },
  { label: '周五', value: 5 }
]

const periods = [
  { label: '第1-2节\n08:00-09:40', value: 1 },
  { label: '第3-4节\n10:00-11:40', value: 2 },
  { label: '第5-6节\n14:00-15:40', value: 3 },
  { label: '第7-8节\n16:00-17:40', value: 4 },
  { label: '第9-10节\n19:00-20:40', value: 5 }
]

const courses = ref([])

// 模拟课程数据
const mockCourses = [
  {
    id: 1,
    courseCode: 'CS101',
    courseName: '计算机导论',
    teacher: '张教授',
    classroom: 'A101',
    credits: 3,
    type: '必修',
    schedule: '周一 第1-2节',
    day: 1,
    period: 1
  },
  {
    id: 2,
    courseCode: 'MATH201',
    courseName: '高等数学',
    teacher: '李教授',
    classroom: 'B203',
    credits: 4,
    type: '必修',
    schedule: '周二 第3-4节',
    day: 2,
    period: 2
  },
  {
    id: 3,
    courseCode: 'ENG101',
    courseName: '大学英语',
    teacher: '王老师',
    classroom: 'C305',
    credits: 2,
    type: '必修',
    schedule: '周三 第1-2节',
    day: 3,
    period: 1
  },
  {
    id: 4,
    courseCode: 'CS201',
    courseName: '数据结构',
    teacher: '刘教授',
    classroom: 'A102',
    credits: 4,
    type: '必修',
    schedule: '周四 第5-6节',
    day: 4,
    period: 3
  },
  {
    id: 5,
    courseCode: 'PE101',
    courseName: '体育',
    teacher: '陈老师',
    classroom: '体育馆',
    credits: 1,
    type: '选修',
    schedule: '周五 第3-4节',
    day: 5,
    period: 2
  }
]

const getCourse = (day, period) => {
  return courses.value.find(c => c.day === day && c.period === period)
}

const fetchCourses = async () => {
  // 这里应该调用API获取课程数据
  // 暂时使用模拟数据
  courses.value = mockCourses
}

onMounted(() => {
  fetchCourses()
})
</script>

<style scoped>
.my-courses-page {
  padding: 0;
}

.page-header {
  margin-bottom: 24px;
}

.page-title {
  font-size: 24px;
  font-weight: 600;
  color: #1e293b;
  margin: 0 0 8px 0;
}

.page-subtitle {
  font-size: 14px;
  color: #64748b;
  margin: 0;
}

.courses-section,
.course-list-section {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  margin-bottom: 24px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.section-title {
  font-size: 16px;
  font-weight: 600;
  color: #1e293b;
  margin: 0;
  display: flex;
  align-items: center;
  gap: 8px;
}

/* 课程表样式 */
.schedule-container {
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  overflow: hidden;
}

.schedule-header {
  display: grid;
  grid-template-columns: 100px repeat(5, 1fr);
  background: #f8fafc;
  border-bottom: 1px solid #e2e8f0;
}

.time-slot {
  padding: 12px;
  font-weight: 600;
  color: #475569;
  text-align: center;
  border-right: 1px solid #e2e8f0;
}

.day-header {
  padding: 12px;
  font-weight: 600;
  color: #1e293b;
  text-align: center;
}

.schedule-body {
  display: flex;
  flex-direction: column;
}

.time-row {
  display: grid;
  grid-template-columns: 100px repeat(5, 1fr);
  min-height: 100px;
  border-bottom: 1px solid #e2e8f0;
}

.time-row:last-child {
  border-bottom: none;
}

.time-label {
  padding: 12px;
  background: #f8fafc;
  font-size: 12px;
  color: #64748b;
  text-align: center;
  border-right: 1px solid #e2e8f0;
  white-space: pre-line;
  display: flex;
  align-items: center;
  justify-content: center;
}

.course-cell {
  padding: 8px;
  border-right: 1px solid #e2e8f0;
  display: flex;
  align-items: center;
  justify-content: center;
}

.course-cell:last-child {
  border-right: none;
}

.course-cell.has-course {
  background: #f0f9ff;
}

.course-item {
  text-align: center;
  width: 100%;
}

.course-name {
  font-weight: 600;
  color: #0369a1;
  font-size: 13px;
  margin-bottom: 4px;
}

.course-info {
  font-size: 11px;
  color: #64748b;
  margin-bottom: 2px;
}

.course-room {
  font-size: 11px;
  color: #94a3b8;
}

/* 课程卡片样式 */
.course-cards {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 16px;
}

.course-card {
  background: #f8fafc;
  border-radius: 10px;
  padding: 16px;
  border: 1px solid #e2e8f0;
  transition: all 0.3s;
}

.course-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  transform: translateY(-2px);
}

.course-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.course-code {
  font-size: 12px;
  color: #64748b;
  font-weight: 500;
}

.course-title {
  font-size: 16px;
  font-weight: 600;
  color: #1e293b;
  margin: 0 0 12px 0;
}

.course-details {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.detail-item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  color: #64748b;
}

.detail-item .el-icon {
  font-size: 14px;
  color: #94a3b8;
}

@media (max-width: 768px) {
  .page-title {
    font-size: 20px;
  }
  
  .page-subtitle {
    font-size: 12px;
  }
  
  .courses-section,
  .course-list-section {
    padding: 16px;
    margin-bottom: 16px;
  }
  
  .schedule-container {
    overflow-x: auto;
  }
  
  .schedule-header,
  .time-row {
    min-width: 600px;
  }
  
  .course-cards {
    grid-template-columns: 1fr;
    gap: 12px;
  }
  
  .course-card {
    padding: 12px;
  }
  
  .course-title {
    font-size: 14px;
  }
  
  .section-title {
    font-size: 14px;
  }
}

@media (max-width: 480px) {
  .page-title {
    font-size: 18px;
  }
  
  .courses-section,
  .course-list-section {
    padding: 12px;
  }
  
  .course-cards {
    grid-template-columns: 1fr;
  }
}
</style>
