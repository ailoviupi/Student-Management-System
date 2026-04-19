<template>
  <div class="dashboard">
    <div class="page-header">
      <h2 class="page-title">数据概览</h2>
      <p class="page-desc">系统核心数据一览</p>
    </div>

    <div class="stat-grid">
      <div v-for="item in statCards" :key="item.title" class="stat-card" :class="item.class">
        <div class="stat-top">
          <div class="stat-icon-wrap">
            <el-icon size="22" color="#fff">
              <component :is="item.icon" />
            </el-icon>
          </div>
          <div class="stat-trend">
            <span class="trend-badge up">↑</span>
          </div>
        </div>
        <div class="stat-body">
          <div class="stat-value">{{ item.value }}</div>
          <div class="stat-title">{{ item.title }}</div>
        </div>
        <div class="stat-bar">
          <div class="stat-bar-fill" :style="{ width: item.value > 0 ? '100%' : '0%' }"></div>
        </div>
      </div>
    </div>

    <el-row :gutter="20" style="margin-top: 20px" class="chart-row">
      <el-col :xs="24" :sm="24" :md="12" :lg="12" :xl="12" class="chart-col">
        <el-card class="chart-card">
          <template #header>
            <div class="chart-header">
              <span class="chart-title">性别分布</span>
              <span class="chart-sub">Gender Distribution</span>
            </div>
          </template>
          <div ref="genderChart" class="chart-container"></div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="24" :md="12" :lg="12" :xl="12" class="chart-col">
        <el-card class="chart-card">
          <template #header>
            <div class="chart-header">
              <span class="chart-title">班级分布</span>
              <span class="chart-sub">Class Distribution</span>
            </div>
          </template>
          <div ref="classChart" class="chart-container"></div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px" class="chart-row">
      <el-col :xs="24" :sm="24" :md="12" :lg="12" :xl="12" class="chart-col">
        <el-card class="chart-card">
          <template #header>
            <div class="chart-header">
              <span class="chart-title">学生状态分布</span>
              <span class="chart-sub">Status Distribution</span>
            </div>
          </template>
          <div ref="statusChart" class="chart-container"></div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="24" :md="12" :lg="12" :xl="12" class="chart-col">
        <el-card class="chart-card">
          <template #header>
            <div class="chart-header">
              <span class="chart-title">课程平均分</span>
              <span class="chart-sub">Course Average</span>
            </div>
          </template>
          <div ref="scoreChart" class="chart-container"></div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue'
import * as echarts from 'echarts'
import { User, School, Reading, Trophy } from '@element-plus/icons-vue'
import { getStatistics } from '../api/statistics'
import { getScoreStatistics } from '../api/score'

const genderChart = ref()
const classChart = ref()
const statusChart = ref()
const scoreChart = ref()

const statCards = ref([
  { title: '学生总数', value: 0, icon: 'User', class: 'indigo' },
  { title: '班级总数', value: 0, icon: 'School', class: 'emerald' },
  { title: '课程总数', value: 0, icon: 'Reading', class: 'amber' },
  { title: '用户总数', value: 0, icon: 'Trophy', class: 'rose' }
])

const chartColors = ['#6366f1', '#06b6d4', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6']

onMounted(async () => {
  const res = await getStatistics()
  if (res.code === 200) {
    const data = res.data
    statCards.value[0].value = data.totalStudents
    statCards.value[1].value = data.totalClasses
    statCards.value[2].value = data.totalCourses
    statCards.value[3].value = data.totalUsers

    await nextTick()

    initGenderChart(data.genderDistribution)
    initClassChart(data.classDistribution)
    initStatusChart(data.statusDistribution)
  }

  const scoreRes = await getScoreStatistics()
  if (scoreRes.code === 200) {
    initScoreChart(scoreRes.data.courseAverageScores)
  }
})

const initGenderChart = (data) => {
  const chart = echarts.init(genderChart.value)
  chart.setOption({
    tooltip: { trigger: 'item', backgroundColor: '#1e293b', borderColor: 'transparent', textStyle: { color: '#fff', fontSize: 13 } },
    legend: { bottom: '5%', textStyle: { color: '#64748b' } },
    series: [{
      type: 'pie',
      radius: ['45%', '72%'],
      center: ['50%', '45%'],
      avoidLabelOverlap: false,
      itemStyle: { borderRadius: 8, borderColor: '#fff', borderWidth: 3 },
      label: { show: false },
      emphasis: { label: { show: true, fontSize: 14, fontWeight: 600 }, itemStyle: { shadowBlur: 10, shadowColor: 'rgba(0,0,0,0.15)' }},
      data: Object.entries(data || {}).map(([name, value], i) => ({ name, value, itemStyle: { color: chartColors[i] } }))
    }]
  })
}

const initClassChart = (data) => {
  const chart = echarts.init(classChart.value)
  chart.setOption({
    tooltip: { trigger: 'axis', backgroundColor: '#1e293b', borderColor: 'transparent', textStyle: { color: '#fff', fontSize: 13 } },
    grid: { left: '3%', right: '4%', bottom: '12%', top: '8%', containLabel: true },
    xAxis: { type: 'category', data: Object.keys(data || {}), axisLabel: { rotate: 30, color: '#64748b', fontSize: 12 }, axisLine: { lineStyle: { color: '#e2e8f0' } }, axisTick: { show: false } },
    yAxis: { type: 'value', axisLabel: { color: '#94a3b8' }, splitLine: { lineStyle: { color: '#f1f5f9' } }, axisLine: { show: false }, axisTick: { show: false } },
    series: [{
      data: Object.values(data || {}),
      type: 'bar',
      barWidth: '40%',
      itemStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{ offset: 0, color: '#6366f1' }, { offset: 1, color: '#818cf8' }]), borderRadius: [6, 6, 0, 0] }
    }]
  })
}

const initStatusChart = (data) => {
  const chart = echarts.init(statusChart.value)
  chart.setOption({
    tooltip: { trigger: 'item', backgroundColor: '#1e293b', borderColor: 'transparent', textStyle: { color: '#fff', fontSize: 13 } },
    legend: { bottom: '5%', textStyle: { color: '#64748b' } },
    series: [{
      type: 'pie',
      radius: '65%',
      center: ['50%', '45%'],
      data: Object.entries(data || {}).map(([name, value], i) => ({ name, value, itemStyle: { color: chartColors[i] } })),
      emphasis: { itemStyle: { shadowBlur: 10, shadowColor: 'rgba(0,0,0,0.15)' } },
      itemStyle: { borderRadius: 6, borderColor: '#fff', borderWidth: 2 }
    }]
  })
}

const initScoreChart = (data) => {
  const chart = echarts.init(scoreChart.value)
  chart.setOption({
    tooltip: { trigger: 'axis', backgroundColor: '#1e293b', borderColor: 'transparent', textStyle: { color: '#fff', fontSize: 13 } },
    grid: { left: '3%', right: '4%', bottom: '12%', top: '8%', containLabel: true },
    xAxis: { type: 'category', data: (data || []).map(item => item.courseName), axisLabel: { rotate: 30, color: '#64748b', fontSize: 12 }, axisLine: { lineStyle: { color: '#e2e8f0' } }, axisTick: { show: false } },
    yAxis: { type: 'value', max: 100, axisLabel: { color: '#94a3b8' }, splitLine: { lineStyle: { color: '#f1f5f9' } }, axisLine: { show: false }, axisTick: { show: false } },
    series: [{
      data: (data || []).map(item => parseFloat(item.averageScore)),
      type: 'bar',
      barWidth: '40%',
      itemStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{ offset: 0, color: '#f59e0b' }, { offset: 1, color: '#fbbf24' }]), borderRadius: [6, 6, 0, 0] }
    }]
  })
}
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
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

.stat-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 24px -8px rgba(0, 0, 0, 0.1);
}

.stat-card::after {
  content: '';
  position: absolute;
  top: 0;
  right: 0;
  width: 80px;
  height: 80px;
  border-radius: 0 0 0 80px;
  opacity: 0.06;
}

.stat-card.indigo::after { background: #6366f1; }
.stat-card.emerald::after { background: #10b981; }
.stat-card.amber::after { background: #f59e0b; }
.stat-card.rose::after { background: #ef4444; }

.stat-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.stat-icon-wrap {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.indigo .stat-icon-wrap { background: linear-gradient(135deg, #6366f1, #818cf8); }
.emerald .stat-icon-wrap { background: linear-gradient(135deg, #10b981, #34d399); }
.amber .stat-icon-wrap { background: linear-gradient(135deg, #f59e0b, #fbbf24); }
.rose .stat-icon-wrap { background: linear-gradient(135deg, #ef4444, #f87171); }

.trend-badge {
  font-size: 11px;
  padding: 2px 6px;
  border-radius: 4px;
  font-weight: 600;
}

.trend-badge.up {
  background: rgba(16,185,129,0.1);
  color: #10b981;
}

.stat-body {
  margin-bottom: 12px;
}

.stat-value {
  font-size: 28px;
  font-weight: 700;
  color: #1e293b;
  line-height: 1;
  margin-bottom: 4px;
}

.stat-title {
  font-size: 13px;
  color: #94a3b8;
  font-weight: 500;
}

.stat-bar {
  height: 3px;
  background: #f1f5f9;
  border-radius: 2px;
  overflow: hidden;
}

.stat-bar-fill {
  height: 100%;
  border-radius: 2px;
  transition: width 1s ease;
}

.indigo .stat-bar-fill { background: linear-gradient(90deg, #6366f1, #818cf8); }
.emerald .stat-bar-fill { background: linear-gradient(90deg, #10b981, #34d399); }
.amber .stat-bar-fill { background: linear-gradient(90deg, #f59e0b, #fbbf24); }
.rose .stat-bar-fill { background: linear-gradient(90deg, #ef4444, #f87171); }

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

.chart-sub {
  font-size: 12px;
  color: #94a3b8;
  margin-top: 2px;
}

.chart-container {
  height: 300px;
}

.chart-col {
  margin-bottom: 20px;
}

@media (max-width: 1200px) {
  .stat-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .stat-grid {
    grid-template-columns: 1fr;
    gap: 12px;
  }
  
  .stat-card {
    padding: 16px;
  }
  
  .stat-value {
    font-size: 24px;
  }
  
  .chart-container {
    height: 250px;
  }
  
  .chart-col {
    margin-bottom: 12px;
  }
  
  .chart-row {
    margin-top: 12px !important;
  }
  
  .page-title {
    font-size: 18px;
  }
  
  .page-desc {
    font-size: 12px;
  }
}

@media (max-width: 480px) {
  .chart-container {
    height: 200px;
  }
  
  .stat-card {
    padding: 12px;
  }
  
  .stat-icon-wrap {
    width: 36px;
    height: 36px;
  }
  
  .stat-value {
    font-size: 20px;
  }
  
  .stat-title {
    font-size: 12px;
  }
}
</style>
