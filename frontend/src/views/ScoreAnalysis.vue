<template>
  <div class="score-analysis">
    <div class="page-header">
      <h2 class="page-title">成绩分析报表</h2>
      <p class="page-desc">多维度成绩数据统计与分析</p>
    </div>

    <!-- 统计卡片 -->
    <div class="stat-grid">
      <div class="stat-card blue">
        <div class="stat-icon">
          <el-icon size="24"><Trophy /></el-icon>
        </div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.excellentRate }}%</div>
          <div class="stat-label">优秀率</div>
        </div>
      </div>
      <div class="stat-card green">
        <div class="stat-icon">
          <el-icon size="24"><TrendCharts /></el-icon>
        </div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.passRate }}%</div>
          <div class="stat-label">及格率</div>
        </div>
      </div>
      <div class="stat-card orange">
        <div class="stat-icon">
          <el-icon size="24"><DataLine /></el-icon>
        </div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.averageScore }}</div>
          <div class="stat-label">总平均分</div>
        </div>
      </div>
      <div class="stat-card purple">
        <div class="stat-icon">
          <el-icon size="24"><Collection /></el-icon>
        </div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.totalRecords }}</div>
          <div class="stat-label">成绩记录数</div>
        </div>
      </div>
    </div>

    <!-- 图表区域 -->
    <el-row :gutter="20" style="margin-top: 24px">
      <el-col :span="12">
        <el-card class="chart-card">
          <template #header>
            <div class="chart-header">
              <span class="chart-title">成绩分布</span>
              <span class="chart-subtitle">Score Distribution</span>
            </div>
          </template>
          <div ref="distributionChart" style="height: 320px"></div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card class="chart-card">
          <template #header>
            <div class="chart-header">
              <span class="chart-title">成绩趋势</span>
              <span class="chart-subtitle">Score Trend (6 Months)</span>
            </div>
          </template>
          <div ref="trendChart" style="height: 320px"></div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 课程分析表格 -->
    <el-card class="table-card" style="margin-top: 20px">
      <template #header>
        <div class="table-header">
          <div class="table-title-section">
            <span class="chart-title">课程成绩分析</span>
            <span class="chart-subtitle">Course Score Analysis</span>
          </div>
          <el-button type="primary" @click="exportAnalysis" :icon="Download">
            导出报表
          </el-button>
        </div>
      </template>
      <el-table :data="courseAnalysisData" border v-loading="loading" stripe>
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column prop="courseName" label="课程名称" min-width="150" />
        <el-table-column label="成绩分布" min-width="280">
          <template #default="{ row }">
            <div class="score-bars">
              <div class="score-bar-item">
                <span class="bar-label">优</span>
                <el-progress :percentage="getPercentage(row.excellent, row.total)" :color="'#10b981'" :show-text="false" :stroke-width="8" />
                <span class="bar-value">{{ row.excellent }}</span>
              </div>
              <div class="score-bar-item">
                <span class="bar-label">良</span>
                <el-progress :percentage="getPercentage(row.good, row.total)" :color="'#3b82f6'" :show-text="false" :stroke-width="8" />
                <span class="bar-value">{{ row.good }}</span>
              </div>
              <div class="score-bar-item">
                <span class="bar-label">中</span>
                <el-progress :percentage="getPercentage(row.medium, row.total)" :color="'#f59e0b'" :show-text="false" :stroke-width="8" />
                <span class="bar-value">{{ row.medium }}</span>
              </div>
              <div class="score-bar-item">
                <span class="bar-label">及格</span>
                <el-progress :percentage="getPercentage(row.pass, row.total)" :color="'#8b5cf6'" :show-text="false" :stroke-width="8" />
                <span class="bar-value">{{ row.pass }}</span>
              </div>
              <div class="score-bar-item">
                <span class="bar-label">不及格</span>
                <el-progress :percentage="getPercentage(row.fail, row.total)" :color="'#ef4444'" :show-text="false" :stroke-width="8" />
                <span class="bar-value">{{ row.fail }}</span>
              </div>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="averageScore" label="平均分" width="100" align="center">
          <template #default="{ row }">
            <el-tag :type="getScoreType(row.averageScore)" size="small">
              {{ formatNumber(row.averageScore) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="maxScore" label="最高分" width="90" align="center">
          <template #default="{ row }">
            <span class="score-high">{{ formatNumber(row.maxScore) }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="minScore" label="最低分" width="90" align="center">
          <template #default="{ row }">
            <span class="score-low">{{ formatNumber(row.minScore) }}</span>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue'
import * as echarts from 'echarts'
import { ElMessage } from 'element-plus'
import { Trophy, TrendCharts, DataLine, Collection, Download } from '@element-plus/icons-vue'
import { getScoreAnalysis } from '../api/score'

const distributionChart = ref()
const trendChart = ref()
const loading = ref(false)

const stats = ref({
  excellentRate: 0,
  passRate: 0,
  averageScore: 0,
  totalRecords: 0
})

const courseAnalysisData = ref([])

const getScoreType = (score) => {
  if (score >= 90) return 'success'
  if (score >= 60) return 'warning'
  return 'danger'
}

const formatNumber = (num) => {
  return num ? parseFloat(num).toFixed(1) : '0.0'
}

const getPercentage = (value, total) => {
  if (!total || total === 0) return 0
  return Math.round((value / total) * 100)
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await getScoreAnalysis()
    if (res.code === 200) {
      const data = res.data
      
      // 处理成绩分布数据
      const distribution = data.distribution || {}
      const total = parseInt(distribution.excellent || 0) + 
                    parseInt(distribution.good || 0) + 
                    parseInt(distribution.medium || 0) + 
                    parseInt(distribution.pass || 0) + 
                    parseInt(distribution.fail || 0)
      
      stats.value.totalRecords = total
      
      if (total > 0) {
        const excellent = parseInt(distribution.excellent || 0)
        const pass = excellent + parseInt(distribution.good || 0) + 
                     parseInt(distribution.medium || 0) + parseInt(distribution.pass || 0)
        
        stats.value.excellentRate = ((excellent / total) * 100).toFixed(1)
        stats.value.passRate = ((pass / total) * 100).toFixed(1)
        
        // 计算总平均分
        let totalScore = 0
        let count = 0
        
        // 处理课程分析数据
        courseAnalysisData.value = (data.courseAnalysis || []).map(item => {
          const itemTotal = parseInt(item.excellent || 0) + parseInt(item.good || 0) + 
                           parseInt(item.medium || 0) + parseInt(item.pass || 0) + parseInt(item.fail || 0)
          totalScore += parseFloat(item.averageScore || 0)
          count++
          return {
            ...item,
            total: itemTotal
          }
        })
        
        stats.value.averageScore = count > 0 ? (totalScore / count).toFixed(1) : '0.0'
        
        await nextTick()
        initDistributionChart(distribution)
        initTrendChart(data.trend || [])
      }
    }
  } catch (error) {
    ElMessage.error('加载数据失败')
  } finally {
    loading.value = false
  }
}

const initDistributionChart = (data) => {
  const chart = echarts.init(distributionChart.value)
  chart.setOption({
    tooltip: {
      trigger: 'item',
      backgroundColor: '#1e293b',
      borderColor: 'transparent',
      textStyle: { color: '#fff', fontSize: 13 },
      formatter: '{b}: {c}人 ({d}%)'
    },
    legend: {
      orient: 'vertical',
      right: '5%',
      top: 'center',
      textStyle: { color: '#64748b', fontSize: 12 }
    },
    series: [{
      type: 'pie',
      radius: ['45%', '70%'],
      center: ['35%', '50%'],
      avoidLabelOverlap: false,
      itemStyle: {
        borderRadius: 8,
        borderColor: '#fff',
        borderWidth: 3
      },
      label: {
        show: false
      },
      emphasis: {
        label: {
          show: true,
          fontSize: 14,
          fontWeight: 600
        },
        itemStyle: {
          shadowBlur: 10,
          shadowColor: 'rgba(0,0,0,0.15)'
        }
      },
      data: [
        { name: '优秀(90-100)', value: parseInt(data.excellent || 0), itemStyle: { color: '#10b981' } },
        { name: '良好(80-89)', value: parseInt(data.good || 0), itemStyle: { color: '#3b82f6' } },
        { name: '中等(70-79)', value: parseInt(data.medium || 0), itemStyle: { color: '#f59e0b' } },
        { name: '及格(60-69)', value: parseInt(data.pass || 0), itemStyle: { color: '#8b5cf6' } },
        { name: '不及格(<60)', value: parseInt(data.fail || 0), itemStyle: { color: '#ef4444' } }
      ]
    }]
  })
}

const initTrendChart = (data) => {
  const chart = echarts.init(trendChart.value)
  chart.setOption({
    tooltip: {
      trigger: 'axis',
      backgroundColor: '#1e293b',
      borderColor: 'transparent',
      textStyle: { color: '#fff', fontSize: 13 }
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '12%',
      top: '8%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      data: data.map(item => item.month),
      axisLabel: {
        color: '#64748b',
        fontSize: 12
      },
      axisLine: {
        lineStyle: { color: '#e2e8f0' }
      },
      axisTick: { show: false }
    },
    yAxis: {
      type: 'value',
      max: 100,
      axisLabel: {
        color: '#94a3b8'
      },
      splitLine: {
        lineStyle: { color: '#f1f5f9' }
      },
      axisLine: { show: false },
      axisTick: { show: false }
    },
    series: [{
      name: '平均分',
      data: data.map(item => parseFloat(item.averageScore || 0).toFixed(1)),
      type: 'line',
      smooth: true,
      symbol: 'circle',
      symbolSize: 8,
      lineStyle: {
        color: '#6366f1',
        width: 3
      },
      itemStyle: {
        color: '#6366f1',
        borderWidth: 2,
        borderColor: '#fff'
      },
      areaStyle: {
        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
          { offset: 0, color: 'rgba(99, 102, 241, 0.3)' },
          { offset: 1, color: 'rgba(99, 102, 241, 0.05)' }
        ])
      }
    }]
  })
}

const exportAnalysis = () => {
  // 导出CSV格式的分析报表
  let csvContent = '课程名称,优秀人数,良好人数,中等人数,及格人数,不及格人数,平均分,最高分,最低分\n'
  
  courseAnalysisData.value.forEach(item => {
    csvContent += `${item.courseName},${item.excellent},${item.good},${item.medium},${item.pass},${item.fail},${formatNumber(item.averageScore)},${formatNumber(item.maxScore)},${formatNumber(item.minScore)}\n`
  })
  
  const blob = new Blob(['\ufeff' + csvContent], { type: 'text/csv;charset=utf-8;' })
  const link = document.createElement('a')
  link.href = URL.createObjectURL(blob)
  link.download = `成绩分析报表_${new Date().toLocaleDateString()}.csv`
  link.click()
  
  ElMessage.success('报表导出成功')
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.page-header {
  margin-bottom: 24px;
}

.page-title {
  font-size: 22px;
  font-weight: 700;
  color: #1e293b;
  margin: 0 0 4px 0;
}

.page-desc {
  font-size: 14px;
  color: #94a3b8;
  margin: 0;
}

.stat-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.stat-card {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 16px;
  transition: all 0.3s ease;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px -4px rgba(0, 0, 0, 0.08);
}

.stat-icon {
  width: 52px;
  height: 52px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
}

.stat-card.blue .stat-icon {
  background: linear-gradient(135deg, #3b82f6, #60a5fa);
}

.stat-card.green .stat-icon {
  background: linear-gradient(135deg, #10b981, #34d399);
}

.stat-card.orange .stat-icon {
  background: linear-gradient(135deg, #f59e0b, #fbbf24);
}

.stat-card.purple .stat-icon {
  background: linear-gradient(135deg, #8b5cf6, #a78bfa);
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 26px;
  font-weight: 700;
  color: #1e293b;
  line-height: 1.2;
}

.stat-label {
  font-size: 13px;
  color: #94a3b8;
  margin-top: 4px;
}

.chart-card {
  border-radius: 12px;
}

.chart-header {
  display: flex;
  flex-direction: column;
}

.chart-title {
  font-size: 15px;
  font-weight: 600;
  color: #1e293b;
}

.chart-subtitle {
  font-size: 12px;
  color: #94a3b8;
  margin-top: 2px;
}

.table-card {
  border-radius: 12px;
}

.table-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.table-title-section {
  display: flex;
  flex-direction: column;
}

.score-bars {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.score-bar-item {
  display: flex;
  align-items: center;
  gap: 8px;
}

.bar-label {
  width: 40px;
  font-size: 12px;
  color: #64748b;
  text-align: right;
}

.bar-value {
  width: 30px;
  font-size: 12px;
  color: #1e293b;
  font-weight: 500;
  text-align: right;
}

:deep(.el-progress) {
  flex: 1;
}

.score-high {
  color: #10b981;
  font-weight: 600;
}

.score-low {
  color: #ef4444;
  font-weight: 600;
}

@media (max-width: 1200px) {
  .stat-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .stat-grid {
    grid-template-columns: 1fr;
  }
}
</style>
