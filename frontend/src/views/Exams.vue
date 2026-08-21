<template>
  <div class="exams">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>考试管理</span>
          <el-button type="primary" @click="handleAdd">安排考试</el-button>
        </div>
      </template>

      <el-form :model="queryForm" inline class="search-form">
        <el-form-item label="课程">
          <el-select v-model="queryForm.courseId" placeholder="请选择课程" clearable style="width: 180px">
            <el-option v-for="item in courseList" :key="item.id" :label="item.courseName" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="考试类型">
          <el-select v-model="queryForm.examType" placeholder="请选择类型" clearable style="width: 120px">
            <el-option label="期中考试" value="期中考试" />
            <el-option label="期末考试" value="期末考试" />
            <el-option label="测验" value="测验" />
            <el-option label="补考" value="补考" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>

      <el-table :data="tableData" v-loading="loading" border>
        <el-table-column prop="examName" label="考试名称" min-width="150" />
        <el-table-column prop="courseName" label="课程" width="120" />
        <el-table-column prop="className" label="班级" width="120" />
        <el-table-column prop="examType" label="考试类型" width="100" />
        <el-table-column prop="examDate" label="考试日期" width="120" />
        <el-table-column label="考试时间" width="120">
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
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="{ row }">
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

    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="600px">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="考试名称" prop="examName">
          <el-input v-model="form.examName" placeholder="请输入考试名称" />
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
        <el-form-item label="考试类型" prop="examType">
          <el-select v-model="form.examType" placeholder="请选择考试类型" style="width: 100%">
            <el-option label="期中考试" value="期中考试" />
            <el-option label="期末考试" value="期末考试" />
            <el-option label="测验" value="测验" />
            <el-option label="补考" value="补考" />
          </el-select>
        </el-form-item>
        <el-form-item label="考试日期" prop="examDate">
          <el-date-picker v-model="form.examDate" type="date" placeholder="选择考试日期" style="width: 100%" />
        </el-form-item>
        <el-form-item label="开始时间" prop="startTime">
          <el-time-picker v-model="form.startTime" placeholder="选择开始时间" style="width: 100%" />
        </el-form-item>
        <el-form-item label="结束时间" prop="endTime">
          <el-time-picker v-model="form.endTime" placeholder="选择结束时间" style="width: 100%" />
        </el-form-item>
        <el-form-item label="教室">
          <el-select v-model="form.classroomId" placeholder="请选择教室" clearable style="width: 100%">
            <el-option v-for="item in classroomList" :key="item.id" :label="item.roomName" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="总分" prop="totalScore">
          <el-input-number v-model="form.totalScore" :min="0" :max="200" :precision="2" style="width: 100%" />
        </el-form-item>
        <el-form-item label="备注">
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
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getExamList, addExam, updateExam, deleteExam } from '../api/exam'
import { getCourseList } from '../api/course'
import { getClassList } from '../api/class'
import request from '../utils/request'

const loading = ref(false)
const tableData = ref([])
const total = ref(0)
const courseList = ref([])
const classList = ref([])
const classroomList = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const isEdit = ref(false)
const formRef = ref()

const queryForm = reactive({
  courseId: null,
  examType: '',
  page: 1,
  size: 10
})

const form = reactive({
  id: null,
  examName: '',
  courseId: null,
  classId: null,
  examType: '期末考试',
  examDate: null,
  startTime: null,
  endTime: null,
  classroomId: null,
  totalScore: 100,
  remark: ''
})

const rules = {
  examName: [{ required: true, message: '请输入考试名称', trigger: 'blur' }],
  courseId: [{ required: true, message: '请选择课程', trigger: 'change' }],
  classId: [{ required: true, message: '请选择班级', trigger: 'change' }],
  examType: [{ required: true, message: '请选择考试类型', trigger: 'change' }],
  examDate: [{ required: true, message: '请选择考试日期', trigger: 'change' }],
  startTime: [{ required: true, message: '请选择开始时间', trigger: 'change' }],
  endTime: [{ required: true, message: '请选择结束时间', trigger: 'change' }]
}

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
    const res = await getExamList(queryForm)
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

const loadClassrooms = async () => {
  const res = await request.get('/classrooms')
  if (res.code === 200) {
    classroomList.value = res.data
  }
}

const handleSearch = () => {
  queryForm.page = 1
  loadData()
}

const handleReset = () => {
  queryForm.courseId = null
  queryForm.examType = ''
  handleSearch()
}

const resetForm = () => {
  Object.assign(form, {
    id: null,
    examName: '',
    courseId: null,
    classId: null,
    examType: '期末考试',
    examDate: null,
    startTime: null,
    endTime: null,
    classroomId: null,
    totalScore: 100,
    remark: ''
  })
}

const handleAdd = () => {
  isEdit.value = false
  dialogTitle.value = '安排考试'
  resetForm()
  dialogVisible.value = true
}

const handleEdit = (row) => {
  isEdit.value = true
  dialogTitle.value = '编辑考试'
  Object.assign(form, {
    id: row.id,
    examName: row.examName,
    courseId: row.courseId,
    classId: row.classId,
    examType: row.examType,
    examDate: row.examDate,
    startTime: row.startTime,
    endTime: row.endTime,
    classroomId: row.classroomId,
    totalScore: row.totalScore,
    remark: row.remark
  })
  dialogVisible.value = true
}

const handleSubmit = async () => {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return

  const api = isEdit.value ? updateExam : addExam
  const res = await api(form)
  if (res.code === 200) {
    ElMessage.success(isEdit.value ? '修改成功' : '安排成功')
    dialogVisible.value = false
    queryForm.page = 1
    loadData()
  }
}

const handleDelete = (row) => {
  ElMessageBox.confirm('确定要删除该考试吗？', '提示', { type: 'warning' }).then(async () => {
    const res = await deleteExam(row.id)
    if (res.code === 200) {
      ElMessage.success('删除成功')
      loadData()
    }
  })
}

onMounted(() => {
  loadData()
  loadCourses()
  loadClasses()
  loadClassrooms()
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