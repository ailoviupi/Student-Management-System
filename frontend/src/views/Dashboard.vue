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

    <!-- 新增趋势折线图 -->
    <el-row :gutter="20" style="margin-top: 20px" class="chart-row">
      <el-col :span="24">
        <el-card class="chart-card">
          <template #header>
            <div class="chart-header">
              <div>
                <span class="chart-title">近7天数据趋势</span>
                <span class="chart-sub">7-Day Data Trend</span>
              </div>
              <el-radio-group v-model="trendType" size="small" @change="updateTrendChart">
                <el-radio-button value="score">成绩录入</el-radio-button>
                <el-radio-button value="attendance">考勤记录</el-radio-button>
                <el-radio-button value="login">用户活跃</el-radio-button>
              </el-radio-group>
            </div>
          </template>
          <div ref="trendChart" class="chart-container" style="height: 350px"></div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px" class="chart-row">
      <el-col :xs="24" :sm="24" :md="12" :lg="12" :xl="12" class="chart-col">
        <el-card class="chart-card">
          <template #header>
            <div class="chart-header">
              <span class="chart-title">消息发送分布</span>
              <span class="chart-sub">Message Distribution</span>
            </div>
          </template>
          <div ref="chatChart" class="chart-container"></div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="24" :md="12" :lg="12" :xl="12" class="chart-col">
        <el-card class="chart-card">
          <template #header>
            <div class="chart-header">
              <span class="chart-title">近7天消息趋势</span>
              <span class="chart-sub">Chat Trend</span>
            </div>
          </template>
          <div ref="chatTrendChart" class="chart-container"></div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick, onUnmounted } from 'vue'
import * as echarts from 'echarts'
import { User, School, Reading, Trophy, MessageBox, UserFilled, ChatDotRound, ChatLineRound } from '@element-plus/icons-vue'
import { getStatistics } from '../api/statistics'
import { getScoreStatistics } from '../api/score'
import { getChatStatistics, getDetailedStatistics } from '../api/chat'

const genderChart = ref()
const classChart = ref()
const statusChart = ref()
const scoreChart = ref()
const trendChart = ref()
let trendChartInstance = null

const trendType = ref('score')

const statCards = ref([
  { title: '学生总数', value: 0, icon: 'User', class: 'indigo' },
  { title: '班级总数', value: 0, icon: 'School', class: 'emerald' },
  { title: '课程总数', value: 0, icon: 'Reading', class: 'amber' },
  { title: '用户总数', value: 0, icon: 'Trophy', class: 'rose' },
  { title: '今日消息', value: 0, icon: 'MessageBox', class: 'cyan' },
  { title: '在线人数', value: 0, icon: 'UserFilled', class: 'purple' },
  { title: '消息总数', value: 0, icon: 'ChatDotRound', class: 'pink' },
  { title: '对话数', value: 0, icon: 'ChatLineRound', class: 'lime' }
])

const chatChart = ref()
const chatTrendChart = ref()
let chatChartInstance = null
let chatTrendChartInstance = null

const chartColors = ['#0d9488', '#06b6d4', '#10b981', '#f59e0b', '#ef4444', '#0891b2']

// 生成近7天日期
const getLast7Days = () => {
  const days = []
  for (let i = 6; i >= 0; i--) {
    const date = new Date()
    date.setDate(date.getDate() - i)
    days.push(date.toLocaleDateString('zh-CN', { month: 'short', day: 'numeric' }))
  }
  return days
}

// 生成模拟趋势数据
const generateTrendData = (type) => {
  const data = []
  for (let i = 0; i < 7; i++) {
    if (type === 'score') {
      data.push(Math.floor(Math.random() * 50) + 20)
    } else if (type === 'attendance') {
      data.push(Math.floor(Math.random() * 100) + 50)
    } else {
      data.push(Math.floor(Math.random() * 30) + 5)
    }
  }
  return data
}

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
    initTrendChart()
  }

  const scoreRes = await getScoreStatistics()
  if (scoreRes.code === 200) {
    initScoreChart(scoreRes.data.courseAverageScores)
  }

  const chatRes = await getChatStatistics()
  if (chatRes.code === 200) {
    const chatData = chatRes.data
    statCards.value[4].value = chatData.todayMessages || 0
    statCards.value[5].value = (chatData.onlineStudents || 0) + (chatData.onlineTeachers || 0)
  }

  const detailedRes = await getDetailedStatistics()
  if (detailedRes.code === 200) {
    const detailedData = detailedRes.data
    statCards.value[6].value = detailedData.totalMessages || 0
    statCards.value[7].value = detailedData.totalConversations || 0
    
    await nextTick()
    initChatChart(detailedData)
    initChatTrendChart(detailedData.dailyStats || [])
  }
  
  startStatisticsPolling()
})

let pollingInterval = null

const startStatisticsPolling = () => {
  pollingInterval = setInterval(async () => {
    try {
      const res = await getChatStatistics()
      if (res.code === 200) {
        const chatData = res.data
        statCards.value[4].value = chatData.todayMessages || 0
        statCards.value[5].value = (chatData.onlineStudents || 0) + (chatData.onlineTeachers || 0)
      }
    } catch (e) {
      console.error('Failed to update statistics:', e)
    }
  }, 5000)
}

onUnmounted(() => {
  if (pollingInterval) {
    clearInterval(pollingInterval)
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
      itemStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{ offset: 0, color: '#0d9488' }, { offset: 1, color: '#14b8a6' }]), borderRadius: [6, 6, 0, 0] }
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

const initTrendChart = () => {
  trendChartInstance = echarts.init(trendChart.value)
  updateTrendChart()
}

const updateTrendChart = () => {
  if (!trendChartInstance) return
  
  const days = getLast7Days()
  const data = generateTrendData(trendType.value)
  
  const colors = {
    score: ['#0d9488', '#14b8a6'],
    attendance: ['#10b981', '#34d399'],
    login: ['#f59e0b', '#fbbf24']
  }
  
  const labels = {
    score: '成绩录入数',
    attendance: '考勤记录数',
    login: '活跃用户数'
  }
  
  trendChartInstance.setOption({
    tooltip: {
      trigger: 'axis',
      backgroundColor: '#1e293b',
      borderColor: 'transparent',
      textStyle: { color: '#fff', fontSize: 13 }
    },
    grid: { left: '3%', right: '4%', bottom: '8%', top: '12%', containLabel: true },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: days,
      axisLabel: { color: '#64748b', fontSize: 12 },
      axisLine: { lineStyle: { color: '#e2e8f0' } },
      axisTick: { show: false }
    },
    yAxis: {
      type: 'value',
      axisLabel: { color: '#94a3b8' },
      splitLine: { lineStyle: { color: '#f1f5f9' } },
      axisLine: { show: false },
      axisTick: { show: false }
    },
    series: [{
      name: labels[trendType.value],
      data: data,
      type: 'line',
      smooth: true,
      symbol: 'circle',
      symbolSize: 8,
      lineStyle: {
        width: 3,
        color: new echarts.graphic.LinearGradient(0, 0, 1, 0, [
          { offset: 0, color: colors[trendType.value][0] },
          { offset: 1, color: colors[trendType.value][1] }
        ])
      },
      areaStyle: {
        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
          { offset: 0, color: colors[trendType.value][0] + '40' },
          { offset: 1, color: colors[trendType.value][0] + '05' }
        ])
      },
      itemStyle: {
        color: colors[trendType.value][0],
        borderWidth: 2,
        borderColor: '#fff'
      }
    }]
  })
}

const initChatChart = (data) => {
  chatChartInstance = echarts.init(chatChart.value)
  chatChartInstance.setOption({
    tooltip: { trigger: 'item', backgroundColor: '#1e293b', borderColor: 'transparent', textStyle: { color: '#fff', fontSize: 13 } },
    legend: { bottom: '5%', textStyle: { color: '#64748b' } },
    series: [{
      type: 'pie',
      radius: ['45%', '72%'],
      center: ['50%', '45%'],
      avoidLabelOverlap: false,
      itemStyle: { borderRadius: 8, borderColor: '#fff', borderWidth: 3 },
      label: { show: false },
      emphasis: { label: { show: true, fontSize: 14, fontWeight: 600 } },
      data: [
        { name: '学生发送', value: data.studentMessages || 0, itemStyle: { color: '#f59e0b' } },
        { name: '教师发送', value: data.teacherMessages || 0, itemStyle: { color: '#0d9488' } }
      ]
    }]
  })
}

const initChatTrendChart = (dailyStats) => {
  chatTrendChartInstance = echarts.init(chatTrendChart.value)
  
  const days = dailyStats.map(item => {
    const date = new Date(item.date)
    return `${date.getMonth() + 1}/${date.getDate()}`
  })
  const data = dailyStats.map(item => item.messageCount || 0)
  
  chatTrendChartInstance.setOption({
    tooltip: { trigger: 'axis', backgroundColor: '#1e293b', borderColor: 'transparent', textStyle: { color: '#fff', fontSize: 13 } },
    grid: { left: '3%', right: '4%', bottom: '12%', top: '8%', containLabel: true },
    xAxis: { type: 'category', data: days, axisLabel: { color: '#64748b', fontSize: 12 }, axisLine: { lineStyle: { color: '#e2e8f0' } }, axisTick: { show: false } },
    yAxis: { type: 'value', axisLabel: { color: '#94a3b8' }, splitLine: { lineStyle: { color: '#f1f5f9' } }, axisLine: { show: false }, axisTick: { show: false } },
    series: [{
      data: data,
      type: 'line',
      smooth: true,
      symbol: 'circle',
      symbolSize: 8,
      lineStyle: { width: 3, color: '#06b6d4' },
      areaStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{ offset: 0, color: '#06b6d440' }, { offset: 1, color: '#06b6d405' }]) },
      itemStyle: { color: '#06b6d4', borderWidth: 2, borderColor: '#fff' }
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
  grid-template-columns: repeat(8, 1fr);
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

.stat-card.indigo::after { background: #0d9488; }
.stat-card.emerald::after { background: #10b981; }
.stat-card.amber::after { background: #f59e0b; }
.stat-card.rose::after { background: #ef4444; }
.stat-card.cyan::after { background: #06b6d4; }
.stat-card.purple::after { background: #0891b2; }
.stat-card.pink::after { background: #ec4899; }
.stat-card.lime::after { background: #84cc16; }

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

.indigo .stat-icon-wrap { background: linear-gradient(135deg, #0d9488, #14b8a6); }
.emerald .stat-icon-wrap { background: linear-gradient(135deg, #10b981, #34d399); }
.amber .stat-icon-wrap { background: linear-gradient(135deg, #f59e0b, #fbbf24); }
.rose .stat-icon-wrap { background: linear-gradient(135deg, #ef4444, #f87171); }
.cyan .stat-icon-wrap { background: linear-gradient(135deg, #06b6d4, #22d3ee); }
.purple .stat-icon-wrap { background: linear-gradient(135deg, #0891b2, #22d3ee); }
.pink .stat-icon-wrap { background: linear-gradient(135deg, #ec4899, #f472b6); }
.lime .stat-icon-wrap { background: linear-gradient(135deg, #84cc16, #a3e635); }

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

.indigo .stat-bar-fill { background: linear-gradient(90deg, #0d9488, #14b8a6); }
.emerald .stat-bar-fill { background: linear-gradient(90deg, #10b981, #34d399); }
.amber .stat-bar-fill { background: linear-gradient(90deg, #f59e0b, #fbbf24); }
.rose .stat-bar-fill { background: linear-gradient(90deg, #ef4444, #f87171); }
.cyan .stat-bar-fill { background: linear-gradient(90deg, #06b6d4, #22d3ee); }
.purple .stat-bar-fill { background: linear-gradient(90deg, #0891b2, #22d3ee); }
.pink .stat-bar-fill { background: linear-gradient(90deg, #ec4899, #f472b6); }
.lime .stat-bar-fill { background: linear-gradient(90deg, #84cc16, #a3e635); }

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
    grid-template-columns: repeat(4, 1fr);
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
