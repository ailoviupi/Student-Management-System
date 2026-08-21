<template>
  <div class="my-exams">
    <el-card>
      <template #header>
        <span>我的考试</span>
      </template>

      <el-table :data="examList" v-loading="loading" border>
        <el-table-column prop="examName" label="考试名称" min-width="150" />
        <el-table-column prop="courseName" label="课程" width="120" />
        <el-table-column prop="examType" label="考试类型" width="100" />
        <el-table-column prop="examDate" label="考试日期" width="120" />
        <el-table-column label="考试时间" width="130">
          <template #default="{ row }">
            {{ row.startTime }} - {{ row.endTime }}
          </template>
        </el-table-column>
        <el-table-column prop="classroomName" label="教室" width="100" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.status)">{{ getStatusText(row.status) }}</el-tag>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getMyExams } from '../../api/exam'

const loading = ref(false)
const examList = ref([])

const getStatusType = (status) => {
  if (status === 0) return 'info'
  if (status === 1) return 'success'
  return 'default'
}

const getStatusText = (status) => {
  if (status === 0) return '未开始'
  if (status === 1) return '进行中'
  return '已结束'
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await getMyExams()
    if (res.code === 200) {
      examList.value = res.data
    }
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
</style>