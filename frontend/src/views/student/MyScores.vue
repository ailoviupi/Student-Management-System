<template>
  <div class="my-scores-page">
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">我的成绩</h1>
        <p class="page-subtitle">查看个人各科成绩及统计分析</p>
      </div>
    </div>

    <!-- 统计卡片 -->
    <div class="stats-cards" v-if="statistics">
      <div class="stat-card">
        <div class="stat-icon" style="background: linear-gradient(135deg, #6366f1, #8b5cf6);">
          <el-icon><Trophy /></el-icon>
        </div>
        <div class="stat-info">
          <span class="stat-value">{{ statistics.averageScore || 0 }}</span>
          <span class="stat-label">平均分</span>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background: linear-gradient(135deg, #10b981, #34d399);">
          <el-icon><CircleCheck /></el-icon>
        </div>
        <div class="stat-info">
          <span class="stat-value">{{ statistics.passRate || 0 }}%</span>
          <span class="stat-label">及格率</span>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background: linear-gradient(135deg, #f59e0b, #f97316);">
          <el-icon><Medal /></el-icon>
        </div>
        <div class="stat-info">
          <span class="stat-value">{{ statistics.maxScore || 0 }}</span>
          <span class="stat-label">最高分</span>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background: linear-gradient(135deg, #06b6d4, #0ea5e9);">
          <el-icon><Collection /></el-icon>
        </div>
        <div class="stat-info">
          <span class="stat-value">{{ statistics.totalCourses || 0 }}</span>
          <span class="stat-label">课程数</span>
        </div>
      </div>
    </div>

    <!-- 成绩列表 -->
    <div class="scores-section">
      <div class="section-header">
        <h3 class="section-title">
          <el-icon><Document /></el-icon>
          成绩明细
        </h3>
      </div>
      
      <el-table :data="scores" style="width: 100%" v-loading="loading">
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column prop="courseName" label="课程名称" min-width="150" />
        <el-table-column prop="courseCode" label="课程代码" width="120" />
        <el-table-column prop="score" label="成绩" width="100" align="center">
          <template #default="{ row }">
            <span :class="getScoreClass(row.score)">{{ row.score }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="examType" label="考试类型" width="120">
          <template #default="{ row }">
            <el-tag :type="getExamTypeType(row.examType)" size="small">
              {{ row.examType }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="examDate" label="考试日期" width="120">
          <template #default="{ row }">
            {{ formatDate(row.examDate) }}
          </template>
        </el-table-column>
        <el-table-column prop="remark" label="备注" min-width="150" show-overflow-tooltip />
      </el-table>

      <el-empty v-if="!loading && scores.length === 0" description="暂无成绩数据" />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Trophy, CircleCheck, Medal, Collection, Document } from '@element-plus/icons-vue'
import { getMyScores, getMyStatistics } from '../../api/score'

const scores = ref([])
const statistics = ref(null)
const loading = ref(false)

const fetchData = async () => {
  loading.value = true
  try {
    const [scoresRes, statsRes] = await Promise.all([
      getMyScores(),
      getMyStatistics()
    ])
    
    if (scoresRes.code === 200) {
      scores.value = scoresRes.data || []
    }
    
    if (statsRes.code === 200) {
      statistics.value = statsRes.data
    }
  } catch (error) {
    ElMessage.error('获取成绩数据失败')
  } finally {
    loading.value = false
  }
}

const getScoreClass = (score) => {
  if (score >= 90) return 'score-excellent'
  if (score >= 80) return 'score-good'
  if (score >= 70) return 'score-medium'
  if (score >= 60) return 'score-pass'
  return 'score-fail'
}

const getExamTypeType = (type) => {
  const types = {
    '期中': 'warning',
    '期末': 'danger',
    '平时': 'success',
    '补考': 'info'
  }
  return types[type] || ''
}

const formatDate = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleDateString('zh-CN')
}

onMounted(() => {
  fetchData()
})
</script>

<style scoped>
.my-scores-page {
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

.scores-section {
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

.score-excellent {
  color: #10b981;
  font-weight: 600;
}

.score-good {
  color: #6366f1;
  font-weight: 600;
}

.score-medium {
  color: #f59e0b;
  font-weight: 600;
}

.score-pass {
  color: #06b6d4;
  font-weight: 600;
}

.score-fail {
  color: #ef4444;
  font-weight: 600;
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
