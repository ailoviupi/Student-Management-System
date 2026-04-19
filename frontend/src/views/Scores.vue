<template>
  <div class="scores">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>成绩管理</span>
          <div>
            <el-button type="success" @click="handleExport" style="margin-right: 10px;">导出Excel</el-button>
            <el-button type="primary" @click="handleAdd">录入成绩</el-button>
          </div>
        </div>
      </template>

      <el-form :model="queryForm" inline class="search-form">
        <el-form-item label="学生">
          <el-input v-model="queryForm.studentName" placeholder="请输入学生姓名" clearable />
        </el-form-item>
        <el-form-item label="课程">
          <el-select v-model="queryForm.courseId" placeholder="请选择课程" clearable style="width: 180px">
            <el-option v-for="item in courseList" :key="item.id" :label="item.courseName" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="考试类型">
          <el-select v-model="queryForm.examType" placeholder="请选择类型" clearable style="width: 120px">
            <el-option label="期中" value="期中" />
            <el-option label="期末" value="期末" />
            <el-option label="平时" value="平时" />
            <el-option label="补考" value="补考" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>

      <el-table :data="tableData" v-loading="loading" border>
        <el-table-column prop="studentNo" label="学号" width="120" />
        <el-table-column prop="studentName" label="姓名" width="100" />
        <el-table-column prop="courseName" label="课程" min-width="150" />
        <el-table-column prop="score" label="成绩" width="100">
          <template #default="{ row }">
            <el-tag :type="getScoreType(row.score)">{{ row.score }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="examType" label="考试类型" width="100" />
        <el-table-column prop="examDate" label="考试日期" width="120" />
        <el-table-column prop="remark" label="备注" min-width="150" show-overflow-tooltip />
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" link @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination">
        <el-pagination
          v-model:current-page="queryForm.pageNum"
          v-model:page-size="queryForm.pageSize"
          :page-sizes="[10, 20, 50, 100]"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>

    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="500px">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="学生" prop="studentId">
          <el-select-v2
            v-model="form.studentId"
            :options="studentOptions"
            placeholder="请选择学生"
            filterable
            clearable
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="课程" prop="courseId">
          <el-select v-model="form.courseId" placeholder="请选择课程" style="width: 100%">
            <el-option v-for="item in courseList" :key="item.id" :label="item.courseName" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="成绩" prop="score">
          <el-input-number v-model="form.score" :min="0" :max="100" :precision="2" style="width: 100%" />
        </el-form-item>
        <el-form-item label="考试日期" prop="examDate">
          <el-date-picker v-model="form.examDate" type="date" placeholder="选择日期" style="width: 100%" />
        </el-form-item>
        <el-form-item label="考试类型" prop="examType">
          <el-select v-model="form.examType" placeholder="请选择考试类型" style="width: 100%">
            <el-option label="期中" value="期中" />
            <el-option label="期末" value="期末" />
            <el-option label="平时" value="平时" />
            <el-option label="补考" value="补考" />
          </el-select>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" :rows="2" placeholder="请输入备注" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed, nextTick } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getScoreList, addScore, updateScore, deleteScore } from '../api/score'
import { getCourseList } from '../api/course'
import { getStudentList } from '../api/student'

const loading = ref(false)
const tableData = ref([])
const total = ref(0)
const courseList = ref([])
const studentList = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const isEdit = ref(false)
const formRef = ref()

const studentOptions = computed(() => {
  return studentList.value.map(s => ({
    value: s.id,
    label: `${s.studentNo} - ${s.name}`
  }))
})

const queryForm = reactive({
  studentName: '',
  courseId: null,
  examType: '',
  pageNum: 1,
  pageSize: 10
})

const form = reactive({
  id: null,
  studentId: null,
  courseId: null,
  score: 60,
  examDate: null,
  examType: '期末',
  remark: ''
})

const rules = {
  studentId: [{ required: true, message: '请选择学生', trigger: 'change' }],
  courseId: [{ required: true, message: '请选择课程', trigger: 'change' }],
  score: [{ required: true, message: '请输入成绩', trigger: 'blur' }],
  examType: [{ required: true, message: '请选择考试类型', trigger: 'change' }]
}

const getScoreType = (score) => {
  if (score >= 90) return 'success'
  if (score >= 60) return 'warning'
  return 'danger'
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await getScoreList(queryForm)
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

const loadStudents = async () => {
  const res = await getStudentList({ pageNum: 1, pageSize: 1000 })
  if (res.code === 200) {
    studentList.value = res.data.list
  }
}

const handleSearch = () => {
  queryForm.pageNum = 1
  loadData()
}

const handleReset = () => {
  Object.keys(queryForm).forEach(key => {
    if (key !== 'pageNum' && key !== 'pageSize') {
      queryForm[key] = key === 'courseId' ? null : ''
    }
  })
  handleSearch()
}

const handleSizeChange = (val) => {
  queryForm.pageSize = val
  loadData()
}

const handleCurrentChange = (val) => {
  queryForm.pageNum = val
  loadData()
}

const resetForm = () => {
  Object.assign(form, {
    id: null,
    studentId: null,
    courseId: null,
    score: 60,
    examDate: null,
    examType: '期末',
    remark: ''
  })
}

const handleAdd = () => {
  isEdit.value = false
  dialogTitle.value = '录入成绩'
  resetForm()
  dialogVisible.value = true
  // 清除表单验证错误
  nextTick(() => {
    formRef.value?.clearValidate()
  })
}

const handleEdit = (row) => {
  isEdit.value = true
  dialogTitle.value = '编辑成绩'
  // 只赋值需要的字段，避免提交额外的字段如 studentName, courseName
  Object.assign(form, {
    id: row.id,
    studentId: row.studentId,
    courseId: row.courseId,
    score: row.score,
    examDate: row.examDate,
    examType: row.examType,
    remark: row.remark
  })
  dialogVisible.value = true
  // 清除表单验证错误
  nextTick(() => {
    formRef.value?.clearValidate()
  })
}

const handleSubmit = async () => {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return

  const api = isEdit.value ? updateScore : addScore
  const res = await api(form)
  if (res.code === 200) {
    ElMessage.success(isEdit.value ? '修改成功' : '录入成功')
    dialogVisible.value = false
    // 重置到第一页并刷新数据
    queryForm.pageNum = 1
    loadData()
  }
}

const handleDelete = (row) => {
  ElMessageBox.confirm('确定要删除该成绩记录吗？', '提示', { type: 'warning' }).then(async () => {
    const res = await deleteScore(row.id)
    if (res.code === 200) {
      ElMessage.success('删除成功')
      loadData()
    }
  })
}

const handleExport = () => {
  const token = localStorage.getItem('token')
  const baseURL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8083/api'
  const url = `${baseURL}/scores/export`
  
  fetch(url, {
    headers: {
      'Authorization': `Bearer ${token}`
    }
  })
  .then(response => {
    if (!response.ok) throw new Error('导出失败')
    return response.blob()
  })
  .then(blob => {
    const link = document.createElement('a')
    link.href = URL.createObjectURL(blob)
    link.download = '成绩报表.xlsx'
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    ElMessage.success('导出成功')
  })
  .catch(() => {
    ElMessage.error('导出失败')
  })
}

onMounted(() => {
  loadData()
  loadCourses()
  loadStudents()
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

/* 移动端表格横向滚动 */
:deep(.el-table) {
  width: 100%;
}

:deep(.el-table__body-wrapper) {
  overflow-x: auto;
}

@media (max-width: 768px) {
  .card-header {
    flex-direction: column;
    gap: 10px;
    align-items: flex-start;
  }
  
  .card-header > div {
    display: flex;
    gap: 8px;
    width: 100%;
  }
  
  .card-header .el-button {
    flex: 1;
    margin-right: 0 !important;
  }
  
  :deep(.el-dialog) {
    width: 90% !important;
    margin: 0 auto;
  }
  
  :deep(.el-dialog__body) {
    padding: 16px !important;
  }
  
  :deep(.el-form-item__label) {
    width: 80px !important;
  }
  
  :deep(.el-form-item__content) {
    margin-left: 80px !important;
  }
  
  .pagination {
    justify-content: center;
    flex-wrap: wrap;
    gap: 10px;
  }
  
  :deep(.el-pagination__sizes) {
    display: none;
  }
  
  :deep(.el-pagination__jump) {
    display: none;
  }
}

@media (max-width: 480px) {
  :deep(.el-form-item__label) {
    width: 70px !important;
    font-size: 12px;
  }
  
  :deep(.el-form-item__content) {
    margin-left: 70px !important;
  }
}
</style>
