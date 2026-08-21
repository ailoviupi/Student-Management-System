<template>
  <div class="homework">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>作业管理</span>
          <el-button type="primary" @click="handleAdd">发布作业</el-button>
        </div>
      </template>

      <el-form :model="queryForm" inline class="search-form">
        <el-form-item label="课程">
          <el-select v-model="queryForm.courseId" placeholder="请选择课程" clearable style="width: 180px">
            <el-option v-for="item in courseList" :key="item.id" :label="item.courseName" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="queryForm.status" placeholder="请选择状态" clearable style="width: 120px">
            <el-option label="进行中" :value="1" />
            <el-option label="已结束" :value="0" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>

      <el-table :data="tableData" v-loading="loading" border>
        <el-table-column prop="title" label="作业标题" min-width="150" />
        <el-table-column prop="courseName" label="课程" width="120" />
        <el-table-column prop="className" label="班级" width="120" />
        <el-table-column prop="totalScore" label="总分" width="80" />
        <el-table-column prop="deadline" label="截止时间" width="160">
          <template #default="{ row }">
            {{ formatDate(row.deadline) }}
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'info'">
              {{ row.status === 1 ? '进行中' : '已结束' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="220" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="handleViewSubmissions(row)">查看提交</el-button>
            <el-button type="primary" link @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" link @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination">
        <el-pagination
          v-model:current-page="queryForm.page"
          v-model:page-size="queryForm.size"
          :page-sizes="[10, 20, 50]"
          :total="total"
          layout="total, sizes, prev, pager, next"
          @size-change="loadData"
          @current-change="loadData"
        />
      </div>
    </el-card>

    <!-- 发布/编辑作业对话框 -->
    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="600px">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="作业标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入作业标题" />
        </el-form-item>
        <el-form-item label="课程" prop="courseId">
          <el-select v-model="form.courseId" placeholder="请选择课程" style="width: 100%">
            <el-option v-for="item in courseList" :key="item.id" :label="item.courseName" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="班级" prop="classId">
          <el-select v-model="form.classId" placeholder="请选择班级" style="width: 100%">
            <el-option v-for="item in classList" :key="item.id" :label="item.className" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="作业描述">
          <el-input v-model="form.description" type="textarea" :rows="3" placeholder="请输入作业描述" />
        </el-form-item>
        <el-form-item label="总分" prop="totalScore">
          <el-input-number v-model="form.totalScore" :min="0" :max="200" :precision="2" style="width: 100%" />
        </el-form-item>
        <el-form-item label="截止时间" prop="deadline">
          <el-date-picker v-model="form.deadline" type="datetime" placeholder="选择截止时间" style="width: 100%" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>

    <!-- 查看提交对话框 -->
    <el-dialog title="作业提交列表" v-model="submissionDialogVisible" width="900px">
      <el-table :data="submissionData" v-loading="submissionLoading" border>
        <el-table-column prop="studentNo" label="学号" width="120" />
        <el-table-column prop="studentName" label="姓名" width="100" />
        <el-table-column prop="content" label="作业内容" min-width="150" show-overflow-tooltip />
        <el-table-column prop="submitTime" label="提交时间" width="160">
          <template #default="{ row }">
            {{ formatDate(row.submitTime) }}
          </template>
        </el-table-column>
        <el-table-column prop="score" label="分数" width="80">
          <template #default="{ row }">
            <el-tag v-if="row.score !== null" :type="row.score >= 60 ? 'success' : 'danger'">{{ row.score }}</el-tag>
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="90">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'warning'">
              {{ row.status === 1 ? '已批改' : '未批改' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="100" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="handleGrade(row)">批改</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-dialog>

    <!-- 批改对话框 -->
    <el-dialog title="批改作业" v-model="gradeDialogVisible" width="500px">
      <el-form :model="gradeForm" label-width="80px">
        <el-form-item label="分数">
          <el-input-number v-model="gradeForm.score" :min="0" :max="currentHomework?.totalScore || 100" :precision="2" style="width: 100%" />
        </el-form-item>
        <el-form-item label="反馈">
          <el-input v-model="gradeForm.feedback" type="textarea" :rows="3" placeholder="请输入批改反馈" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="gradeDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmitGrade">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getHomeworkList, addHomework, updateHomework, deleteHomework, getSubmissions, gradeSubmission } from '../api/homework'
import { getCourseList } from '../api/course'
import { getClassList } from '../api/class'

const loading = ref(false)
const tableData = ref([])
const total = ref(0)
const courseList = ref([])
const classList = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const isEdit = ref(false)
const formRef = ref()
const submissionDialogVisible = ref(false)
const submissionData = ref([])
const submissionLoading = ref(false)
const currentHomework = ref(null)
const gradeDialogVisible = ref(false)
const gradeForm = reactive({ id: null, score: 0, feedback: '' })

const queryForm = reactive({
  courseId: null,
  status: null,
  page: 1,
  size: 10
})

const form = reactive({
  id: null,
  title: '',
  courseId: null,
  classId: null,
  description: '',
  totalScore: 100,
  deadline: null
})

const rules = {
  title: [{ required: true, message: '请输入作业标题', trigger: 'blur' }],
  courseId: [{ required: true, message: '请选择课程', trigger: 'change' }],
  classId: [{ required: true, message: '请选择班级', trigger: 'change' }],
  deadline: [{ required: true, message: '请选择截止时间', trigger: 'change' }]
}

const formatDate = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleString('zh-CN')
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await getHomeworkList(queryForm)
    if (res.code === 200) {
      tableData.value = res.data.list
      total.value = res.data.total
    }
  } finally {
    loading.value = false
  }
}

const loadCourses = async () => {
  const res = await getCourseList()
  if (res.code === 200) {
    courseList.value = res.data
  }
}

const loadClasses = async () => {
  const res = await getClassList({ page: 1, size: 100 })
  if (res.code === 200) {
    classList.value = res.data.list
  }
}

const handleSearch = () => {
  queryForm.page = 1
  loadData()
}

const handleReset = () => {
  queryForm.courseId = null
  queryForm.status = null
  handleSearch()
}

const resetForm = () => {
  Object.assign(form, {
    id: null,
    title: '',
    courseId: null,
    classId: null,
    description: '',
    totalScore: 100,
    deadline: null
  })
}

const handleAdd = () => {
  isEdit.value = false
  dialogTitle.value = '发布作业'
  resetForm()
  dialogVisible.value = true
}

const handleEdit = (row) => {
  isEdit.value = true
  dialogTitle.value = '编辑作业'
  Object.assign(form, {
    id: row.id,
    title: row.title,
    courseId: row.courseId,
    classId: row.classId,
    description: row.description,
    totalScore: row.totalScore,
    deadline: row.deadline
  })
  dialogVisible.value = true
}

const handleSubmit = async () => {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return

  const api = isEdit.value ? updateHomework : addHomework
  const res = await api(form)
  if (res.code === 200) {
    ElMessage.success(isEdit.value ? '修改成功' : '发布成功')
    dialogVisible.value = false
    queryForm.page = 1
    loadData()
  }
}

const handleDelete = (row) => {
  ElMessageBox.confirm('确定要删除该作业吗？', '提示', { type: 'warning' }).then(async () => {
    const res = await deleteHomework(row.id)
    if (res.code === 200) {
      ElMessage.success('删除成功')
      loadData()
    }
  })
}

const handleViewSubmissions = async (row) => {
  currentHomework.value = row
  submissionDialogVisible.value = true
  submissionLoading.value = true
  try {
    const res = await getSubmissions(row.id, { page: 1, size: 100 })
    if (res.code === 200) {
      submissionData.value = res.data.list
    }
  } finally {
    submissionLoading.value = false
  }
}

const handleGrade = (row) => {
  gradeForm.id = row.id
  gradeForm.score = row.score || 0
  gradeForm.feedback = row.feedback || ''
  gradeDialogVisible.value = true
}

const handleSubmitGrade = async () => {
  // 从本地登录信息中取当前教师/管理员ID（后端同样会从 token 校验）
  const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
  const res = await gradeSubmission(gradeForm.id, {
    score: gradeForm.score,
    feedback: gradeForm.feedback,
    gradeUser: userInfo.id
  })
  if (res.code === 200) {
    ElMessage.success('批改成功')
    gradeDialogVisible.value = false
    handleViewSubmissions(currentHomework.value)
  }
}

onMounted(() => {
  loadData()
  loadCourses()
  loadClasses()
})
</script>

<style scoped>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.search-form {
  margin-bottom: 20px;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>