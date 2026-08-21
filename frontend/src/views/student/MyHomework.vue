<template>
  <div class="my-homework">
    <el-card>
      <template #header>
        <span>我的作业</span>
      </template>

      <el-table :data="homeworkList" v-loading="loading" border>
        <el-table-column prop="title" label="作业标题" min-width="150" />
        <el-table-column prop="courseName" label="课程" width="120" />
        <el-table-column prop="totalScore" label="总分" width="80" />
        <el-table-column prop="deadline" label="截止时间" width="160">
          <template #default="{ row }">
            {{ formatDate(row.deadline) }}
          </template>
        </el-table-column>
        <el-table-column label="提交状态" width="100">
          <template #default="{ row }">
            <el-tag v-if="row.mySubmission" type="success">已提交</el-tag>
            <el-tag v-else type="warning">未提交</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="批改状态" width="100">
          <template #default="{ row }">
            <el-tag v-if="row.mySubmission?.status === 1" type="success">已批改</el-tag>
            <el-tag v-else-if="row.mySubmission?.status === 0" type="info">未批改</el-tag>
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column label="分数" width="80">
          <template #default="{ row }">
            <span v-if="row.mySubmission?.score !== null && row.mySubmission?.score !== undefined">
              {{ row.mySubmission.score }}
            </span>
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="100" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="handleViewOrSubmit(row)">
              {{ row.mySubmission ? '查看' : '提交' }}
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 查看/提交作业对话框 -->
    <el-dialog :title="currentHomework?.title" v-model="dialogVisible" width="600px">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="课程">{{ currentHomework?.courseName }}</el-descriptions-item>
        <el-descriptions-item label="总分">{{ currentHomework?.totalScore }}</el-descriptions-item>
        <el-descriptions-item label="截止时间">{{ formatDate(currentHomework?.deadline) }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag v-if="isExpired" type="danger">已截止</el-tag>
          <el-tag v-else type="success">进行中</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="作业描述" :span="2">{{ currentHomework?.description || '暂无描述' }}</el-descriptions-item>
      </el-descriptions>

      <el-divider />

      <div v-if="submission && submission.status === 1">
        <h4>批改结果</h4>
        <el-descriptions :column="2" border>
          <el-descriptions-item label="分数">
            <el-tag :type="submission.score >= 60 ? 'success' : 'danger'">{{ submission.score }}</el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="批改时间">{{ formatDate(submission.gradeTime) }}</el-descriptions-item>
          <el-descriptions-item label="教师反馈" :span="2">{{ submission.feedback || '暂无反馈' }}</el-descriptions-item>
        </el-descriptions>
        <el-divider />
        <h4>我的提交</h4>
        <p style="white-space: pre-wrap;">{{ submission.content }}</p>
      </div>

      <div v-else>
        <el-form :model="form" ref="formRef" label-width="80px">
          <el-form-item label="作业内容" prop="content">
            <el-input v-model="form.content" type="textarea" :rows="6" placeholder="请输入作业内容" :disabled="isExpired" />
          </el-form-item>
        </el-form>
      </div>

      <template #footer>
        <el-button @click="dialogVisible = false">关闭</el-button>
        <el-button v-if="!submission || submission.status !== 1" type="primary" @click="handleSubmit" :disabled="isExpired">
          {{ submission ? '重新提交' : '提交作业' }}
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage } from 'element-plus'
import { getMyHomework, getMySubmission, submitHomework } from '../../api/homework'

const loading = ref(false)
const homeworkList = ref([])
const dialogVisible = ref(false)
const currentHomework = ref(null)
const submission = ref(null)
const formRef = ref()

const form = reactive({
  homeworkId: null,
  studentId: null,
  content: ''
})

const isExpired = computed(() => {
  if (!currentHomework.value?.deadline) return false
  return new Date(currentHomework.value.deadline) < new Date()
})

const formatDate = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleString('zh-CN')
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await getMyHomework()
    if (res.code === 200) {
      homeworkList.value = res.data
    }
  } finally {
    loading.value = false
  }
}

const handleViewOrSubmit = async (row) => {
  currentHomework.value = row
  
  // 获取提交记录
  try {
    const res = await getMySubmission(row.id)
    if (res.code === 200) {
      submission.value = res.data
      if (submission.value) {
        form.content = submission.value.content
      } else {
        form.content = ''
      }
    }
  } catch (error) {
    submission.value = null
    form.content = ''
  }

  form.homeworkId = row.id
  dialogVisible.value = true
}

const handleSubmit = async () => {
  if (!form.content.trim()) {
    ElMessage.warning('请输入作业内容')
    return
  }

  // 从本地登录信息中取当前学生ID（后端同样会从 token 校验身份，防止冒用他人学号提交）
  const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
  form.studentId = userInfo.studentId || userInfo.id

  const res = await submitHomework(form)
  if (res.code === 200) {
    ElMessage.success('提交成功')
    dialogVisible.value = false
    loadData()
  }
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
h4 {
  margin-bottom: 16px;
  color: #303133;
}
</style>