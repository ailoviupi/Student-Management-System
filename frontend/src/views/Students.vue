<template>
  <div class="students">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>学生管理</span>
          <el-button type="primary" @click="handleAdd">新增学生</el-button>
        </div>
      </template>

      <el-form :model="queryForm" inline class="search-form">
        <el-row :gutter="10">
          <el-col :xs="24" :sm="12" :md="8" :lg="6" :xl="4">
            <el-form-item label="姓名" class="mobile-form-item">
              <el-input v-model="queryForm.name" placeholder="请输入姓名" clearable />
            </el-form-item>
          </el-col>
          <el-col :xs="24" :sm="12" :md="8" :lg="6" :xl="4">
            <el-form-item label="学号" class="mobile-form-item">
              <el-input v-model="queryForm.studentNo" placeholder="请输入学号" clearable />
            </el-form-item>
          </el-col>
          <el-col :xs="24" :sm="12" :md="8" :lg="6" :xl="4">
            <el-form-item label="班级" class="mobile-form-item">
              <el-select v-model="queryForm.classId" placeholder="请选择班级" clearable style="width: 100%">
                <el-option v-for="item in classList" :key="item.id" :label="item.className" :value="item.id" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :xs="24" :sm="12" :md="8" :lg="6" :xl="4">
            <el-form-item label="性别" class="mobile-form-item">
              <el-select v-model="queryForm.gender" placeholder="请选择性别" clearable style="width: 100%">
                <el-option label="男" value="男" />
                <el-option label="女" value="女" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :xs="24" :sm="12" :md="8" :lg="6" :xl="4">
            <el-form-item label="状态" class="mobile-form-item">
              <el-select v-model="queryForm.studentStatus" placeholder="请选择状态" clearable style="width: 100%">
                <el-option label="在读" value="在读" />
                <el-option label="休学" value="休学" />
                <el-option label="退学" value="退学" />
                <el-option label="毕业" value="毕业" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :xs="24" :sm="12" :md="8" :lg="6" :xl="4">
            <el-form-item class="mobile-form-item mobile-btn-group">
              <el-button type="primary" @click="handleSearch">查询</el-button>
              <el-button @click="handleReset">重置</el-button>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>

      <el-table :data="tableData" v-loading="loading" border>
        <el-table-column prop="studentNo" label="学号" width="120" />
        <el-table-column prop="name" label="姓名" width="100" />
        <el-table-column prop="age" label="年龄" width="80" />
        <el-table-column prop="gender" label="性别" width="80" />
        <el-table-column prop="phone" label="电话" width="130" />
        <el-table-column prop="email" label="邮箱" min-width="150" show-overflow-tooltip />
        <el-table-column prop="className" label="班级" width="120" />
        <el-table-column prop="studentStatus" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.studentStatus)">{{ row.studentStatus }}</el-tag>
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

    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="600px">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="学号" prop="studentNo">
          <el-input v-model="form.studentNo" placeholder="请输入学号" />
        </el-form-item>
        <el-form-item label="姓名" prop="name">
          <el-input v-model="form.name" placeholder="请输入姓名" />
        </el-form-item>
        <el-form-item label="年龄" prop="age">
          <el-input-number v-model="form.age" :min="15" :max="50" />
        </el-form-item>
        <el-form-item label="性别" prop="gender">
          <el-radio-group v-model="form.gender">
            <el-radio label="男">男</el-radio>
            <el-radio label="女">女</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="电话" prop="phone">
          <el-input v-model="form.phone" placeholder="请输入电话" />
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="form.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="地址" prop="address">
          <el-input v-model="form.address" placeholder="请输入地址" />
        </el-form-item>
        <el-form-item label="班级" prop="classId">
          <el-select v-model="form.classId" placeholder="请选择班级" style="width: 100%">
            <el-option v-for="item in classList" :key="item.id" :label="item.className" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="入学日期" prop="enrollmentDate">
          <el-date-picker v-model="form.enrollmentDate" type="date" placeholder="选择日期" style="width: 100%" />
        </el-form-item>
        <el-form-item label="状态" prop="studentStatus">
          <el-select v-model="form.studentStatus" placeholder="请选择状态" style="width: 100%">
            <el-option label="在读" value="在读" />
            <el-option label="休学" value="休学" />
            <el-option label="退学" value="退学" />
            <el-option label="毕业" value="毕业" />
          </el-select>
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
import { getStudentList, addStudent, updateStudent, deleteStudent } from '../api/student'
import { getClassList } from '../api/class'

const loading = ref(false)
const tableData = ref([])
const total = ref(0)
const classList = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const isEdit = ref(false)
const formRef = ref()

const queryForm = reactive({
  name: '',
  studentNo: '',
  classId: null,
  gender: '',
  studentStatus: '',
  pageNum: 1,
  pageSize: 10
})

const form = reactive({
  id: null,
  studentNo: '',
  name: '',
  age: 18,
  gender: '男',
  phone: '',
  email: '',
  address: '',
  classId: null,
  enrollmentDate: null,
  studentStatus: '在读'
})

const rules = {
  studentNo: [{ required: true, message: '请输入学号', trigger: 'blur' }],
  name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
  gender: [{ required: true, message: '请选择性别', trigger: 'change' }],
  classId: [{ required: true, message: '请选择班级', trigger: 'change' }]
}

const getStatusType = (status) => {
  const types = { '在读': 'success', '休学': 'warning', '退学': 'danger', '毕业': 'info' }
  return types[status] || 'info'
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await getStudentList(queryForm)
    if (res.code === 200) {
      tableData.value = res.data.list
      total.value = res.data.total
    }
  } finally {
    loading.value = false
  }
}

const loadClasses = async () => {
  const res = await getClassList()
  if (res.code === 200) {
    classList.value = res.data
  }
}

const handleSearch = () => {
  queryForm.pageNum = 1
  loadData()
}

const handleReset = () => {
  Object.keys(queryForm).forEach(key => {
    if (key !== 'pageNum' && key !== 'pageSize') {
      queryForm[key] = key === 'classId' ? null : ''
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
    studentNo: '',
    name: '',
    age: 18,
    gender: '男',
    phone: '',
    email: '',
    address: '',
    classId: null,
    enrollmentDate: null,
    studentStatus: '在读'
  })
}

const handleAdd = () => {
  isEdit.value = false
  dialogTitle.value = '新增学生'
  resetForm()
  dialogVisible.value = true
}

const handleEdit = (row) => {
  isEdit.value = true
  dialogTitle.value = '编辑学生'
  Object.assign(form, row)
  dialogVisible.value = true
}

const handleSubmit = async () => {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return

  const api = isEdit.value ? updateStudent : addStudent
  const res = await api(form)
  if (res.code === 200) {
    ElMessage.success(isEdit.value ? '修改成功' : '新增成功')
    dialogVisible.value = false
    loadData()
  }
}

const handleDelete = (row) => {
  ElMessageBox.confirm('确定要删除该学生吗？', '提示', { type: 'warning' }).then(async () => {
    const res = await deleteStudent(row.id)
    if (res.code === 200) {
      ElMessage.success('删除成功')
      loadData()
    }
  })
}

onMounted(() => {
  loadData()
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

.mobile-form-item {
  margin-bottom: 10px;
  width: 100%;
}

.mobile-form-item :deep(.el-form-item__content) {
  width: calc(100% - 60px);
}

.mobile-btn-group :deep(.el-form-item__content) {
  width: 100%;
  display: flex;
  gap: 10px;
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
  .search-form {
    margin-bottom: 10px;
  }
  
  .mobile-form-item {
    margin-bottom: 8px;
  }
  
  .mobile-form-item :deep(.el-form-item__label) {
    width: 50px !important;
    font-size: 12px;
  }
  
  .mobile-form-item :deep(.el-form-item__content) {
    width: calc(100% - 50px);
    margin-left: 50px !important;
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
  .card-header {
    flex-direction: column;
    gap: 10px;
    align-items: flex-start;
  }
  
  .mobile-form-item :deep(.el-form-item__label) {
    font-size: 11px;
  }
}
</style>
