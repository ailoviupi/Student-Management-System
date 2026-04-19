<template>
  <div class="my-attendance-page">
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">我的考勤</h1>
        <p class="page-subtitle">查看个人考勤记录及统计</p>
      </div>
    </div>

    <!-- 统计卡片 -->
    <div class="stats-cards" v-if="statistics">
      <div class="stat-card">
        <div class="stat-icon" style="background: linear-gradient(135deg, #10b981, #34d399);">
          <el-icon><CircleCheck /></el-icon>
        </div>
        <div class="stat-info">
          <span class="stat-value">{{ statistics.present || 0 }}</span>
          <span class="stat-label">出勤</span>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background: linear-gradient(135deg, #ef4444, #f87171);">
          <el-icon><CircleClose /></el-icon>
        </div>
        <div class="stat-info">
          <span class="stat-value">{{ statistics.absent || 0 }}</span>
          <span class="stat-label">缺勤</span>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background: linear-gradient(135deg, #f59e0b, #fbbf24);">
          <el-icon><Timer /></el-icon>
        </div>
        <div class="stat-info">
          <span class="stat-value">{{ statistics.late || 0 }}</span>
          <span class="stat-label">迟到</span>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background: linear-gradient(135deg, #6366f1, #8b5cf6);">
          <el-icon><TrendCharts /></el-icon>
        </div>
        <div class="stat-info">
          <span class="stat-value">{{ statistics.attendanceRate || 0 }}%</span>
          <span class="stat-label">出勤率</span>
        </div>
      </div>
    </div>

    <!-- 筛选器 -->
    <div class="filter-section">
      <el-radio-group v-model="filterStatus" @change="handleFilterChange" size="small">
        <el-radio-button label="">全部</el-radio-button>
        <el-radio-button label="出勤">出勤</el-radio-button>
        <el-radio-button label="缺勤">缺勤</el-radio-button>
        <el-radio-button label="迟到">迟到</el-radio-button>
        <el-radio-button label="请假">请假</el-radio-button>
      </el-radio-group>
    </div>

    <!-- 考勤列表 -->
    <div class="attendance-section">
      <div class="section-header">
        <h3 class="section-title">
          <el-icon><Document /></el-icon>
          考勤记录
        </h3>
      </div>
      
      <el-timeline>
        <el-timeline-item
          v-for="item in attendanceList"
          :key="item.id"
          :type="getTimelineType(item.status)"
          :icon="getTimelineIcon(item.status)"
          :timestamp="formatDate(item.attendanceDate)"
        >
          <div class="attendance-item">
            <div class="attendance-status">
              <el-tag :type="getStatusType(item.status)" size="small" effect="dark">
                {{ item.status }}
              </el-tag>
            </div>
            <div class="attendance-info" v-if="item.remark">
              <span class="remark">备注：{{ item.remark }}</span>
            </div>
          </div>
        </el-timeline-item>
      </el-timeline>

      <el-empty v-if="attendanceList.length === 0" description="暂无考勤记录" />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { CircleCheck, CircleClose, Timer, TrendCharts, Document } from '@element-plus/icons-vue'
import { getMyAttendance, getMyAttendanceStatistics } from '../../api/attendance'

const attendanceList = ref([])
const statistics = ref(null)
const filterStatus = ref('')

const fetchData = async () => {
  try {
    const [listRes, statsRes] = await Promise.all([
      getMyAttendance({ status: filterStatus.value }),
      getMyAttendanceStatistics()
    ])
    
    if (listRes.code === 200) {
      attendanceList.value = listRes.data || []
    }
    
    if (statsRes.code === 200) {
      statistics.value = statsRes.data
    }
  } catch (error) {
    ElMessage.error('获取考勤数据失败')
  }
}

const handleFilterChange = () => {
  fetchData()
}

const getStatusType = (status) => {
  const types = {
    '出勤': 'success',
    '缺勤': 'danger',
    '迟到': 'warning',
    '请假': 'info'
  }
  return types[status] || ''
}

const getTimelineType = (status) => {
  const types = {
    '出勤': 'success',
    '缺勤': 'danger',
    '迟到': 'warning',
    '请假': 'primary'
  }
  return types[status] || ''
}

const getTimelineIcon = (status) => {
  // 使用不同的图标
  return null
}

const formatDate = (date) => {
  if (!date) return '-'
  const d = new Date(date)
  return `${d.getFullYear()}年${d.getMonth() + 1}月${d.getDate()}日`
}

onMounted(() => {
  fetchData()
})
</script>

<style scoped>
.my-attendance-page {
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

.stats-cards {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  margin-bottom: 24px;
}

.stat-card {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 16px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.stat-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 24px;
}

.stat-info {
  display: flex;
  flex-direction: column;
}

.stat-value {
  font-size: 24px;
  font-weight: 700;
  color: #1e293b;
}

.stat-label {
  font-size: 13px;
  color: #64748b;
  margin-top: 2px;
}

.filter-section {
  margin-bottom: 24px;
  background: #fff;
  padding: 16px 20px;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.attendance-section {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
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

.attendance-item {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.attendance-status {
  display: flex;
  align-items: center;
  gap: 12px;
}

.attendance-info {
  font-size: 13px;
  color: #64748b;
}

.remark {
  font-style: italic;
}

@media (max-width: 1200px) {
  .stats-cards {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .stats-cards {
    grid-template-columns: 1fr;
  }
}
</style>
