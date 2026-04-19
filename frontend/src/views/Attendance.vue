<template>
  <div class="attendance">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>考勤管理</span>
          <el-button type="primary" @click="handleAdd">录入考勤</el-button>
        </div>
      </template>

      <el-form :model="queryForm" inline class="search-form">
        <el-form-item label="学生">
          <el-select-v2
            v-model="queryForm.studentId"
            :options="studentOptions"
            placeholder="请选择学生"
            filterable
            clearable
            style="width: 200px"
          />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="queryForm.status" placeholder="请选择状态" clearable style="width: 120px">
            <el-option label="出勤" value="出勤" />
            <el-option label="缺勤" value="缺勤" />
            <el-option label="迟到" value="迟到" />
            <el-option label="早退" value="早退" />
            <el-option label="请假" value="请假" />
          </el-select>
        </el-form-item>
        <el-form-item label="日期范围">
          <el-date-picker
            v-model="dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="YYYY-MM-DD"
            @change="handleDateChange"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>

      <el-table :data="tableData" v-loading="loading" border>
        <el-table-column prop="studentNo" label="学号" width="120" />
        <el-table-column prop="studentName" label="姓名" width="100" />
        <el-table-column prop="className" label="班级" width="150" />
        <el-table-column prop="attendanceDate" label="考勤日期" width="120" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.status)">{{ row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="remark" label="备注" min-width="200" show-overflow-tooltip />
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" link @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
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
        <el-form-item label="考勤日期" prop="attendanceDate">
          <el-date-picker v-model="form.attendanceDate" type="date" placeholder="选择日期" style="width: 100%" value-format="YYYY-MM-DD" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="form.status" placeholder="请选择状态" style="width: 100%">
            <el-option label="出勤" value="出勤" />
            <el-option label="缺勤" value="缺勤" />
            <el-option label="迟到" value="迟到" />
            <el-option label="早退" value="早退" />
            <el-option label="请假" value="请假" />
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
import { getAttendanceList, addAttendance, updateAttendance, deleteAttendance } from '../api/attendance'
import { getStudentList } from '../api/student'

const loading = ref(false)
const tableData = ref([])
const studentList = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const isEdit = ref(false)
const formRef = ref()
const dateRange = ref([])

const studentOptions = computed(() => {
  return studentList.value.map(s => ({
    value: s.id,
    label: `${s.studentNo} - ${s.name}`
  }))
})

const queryForm = reactive({
  studentId: null,
  status: '',
  startDate: '',
  endDate: ''
})

const form = reactive({
  id: null,
  studentId: null,
  attendanceDate: '',
  status: '出勤',
  remark: ''
})

const rules = {
  studentId: [{ required: true, message: '请选择学生', trigger: 'change' }],
  attendanceDate: [{ required: true, message: '请选择考勤日期', trigger: 'change' }],
  status: [{ required: true, message: '请选择状态', trigger: 'change' }]
}

const getStatusType = (status) => {
  const types = { '出勤': 'success', '缺勤': 'danger', '迟到': 'warning', '早退': 'info', '请假': '' }
  return types[status] || ''
}

const loadData = async () => {
  loading.value = true
  try {
    const params = {}
    if (queryForm.studentId) params.studentId = queryForm.studentId
    if (queryForm.status) params.status = queryForm.status
    if (queryForm.startDate) params.startDate = queryForm.startDate
    if (queryForm.endDate) params.endDate = queryForm.endDate
    const res = await getAttendanceList(params)
    if (res.code === 200) {
      tableData.value = res.data
    }
  } finally {
    loading.value = false
  }
}

const loadStudents = async () => {
  const res = await getStudentList({ pageNum: 1, pageSize: 1000 })
  if (res.code === 200) {
    studentList.value = res.data.list
  }
}

const handleDateChange = (val) => {
  if (val && val.length === 2) {
    queryForm.startDate = val[0]
    queryForm.endDate = val[1]
  } else {
    queryForm.startDate = ''
    queryForm.endDate = ''
  }
}

const handleSearch = () => {
  loadData()
}

const handleReset = () => {
  queryForm.studentId = null
  queryForm.status = ''
  queryForm.startDate = ''
  queryForm.endDate = ''
  dateRange.value = []
  loadData()
}

const resetForm = () => {
  Object.assign(form, {
    id: null,
    studentId: null,
    attendanceDate: '',
    status: '出勤',
    remark: ''
  })
}

const handleAdd = () => {
  isEdit.value = false
  dialogTitle.value = '录入考勤'
  resetForm()
  dialogVisible.value = true
  nextTick(() => {
    formRef.value?.clearValidate()
  })
}

const handleEdit = (row) => {
  isEdit.value = true
  dialogTitle.value = '编辑考勤'
  Object.assign(form, {
    id: row.id,
    studentId: row.studentId,
    attendanceDate: row.attendanceDate,
    status: row.status,
    remark: row.remark
  })
  dialogVisible.value = true
  nextTick(() => {
    formRef.value?.clearValidate()
  })
}

const handleSubmit = async () => {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return

  const api = isEdit.value ? updateAttendance : addAttendance
  const res = await api(form)
  if (res.code === 200) {
    ElMessage.success(isEdit.value ? '修改成功' : '录入成功')
    dialogVisible.value = false
    loadData()
  }
}

const handleDelete = (row) => {
  ElMessageBox.confirm('确定要删除该考勤记录吗？', '提示', { type: 'warning' }).then(async () => {
    const res = await deleteAttendance(row.id)
    if (res.code === 200) {
      ElMessage.success('删除成功')
      loadData()
    }
  })
}

onMounted(() => {
  loadData()
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
</style>
