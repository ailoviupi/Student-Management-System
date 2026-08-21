<template>
  <div class="classes-mobile">
    <!-- 顶部导航 -->
    <div class="mobile-header">
      <div class="header-title">班级管理</div>
      <el-button type="primary" size="small" circle @click="handleAdd">
        <el-icon><Plus /></el-icon>
      </el-button>
    </div>

    <!-- 搜索筛选栏 -->
    <div class="search-bar">
      <el-input
        v-model="searchKeyword"
        placeholder="搜索班级名称/专业"
        clearable
        size="small"
        @input="handleSearch"
      >
        <template #prefix>
          <el-icon><Search /></el-icon>
        </template>
      </el-input>
    </div>

    <!-- 班级卡片列表 -->
    <div class="class-list" v-loading="loading">
      <div v-if="filteredData.length === 0" class="empty-state">
        <el-icon :size="48" color="#ccc"><School /></el-icon>
        <p>暂无班级数据</p>
      </div>
      
      <div
        v-for="item in filteredData"
        :key="item.id"
        class="class-card"
        @click="handleCardClick(item)"
      >
        <div class="card-header">
          <div class="class-name">{{ item.className }}</div>
          <el-tag size="small" type="info">{{ item.grade }}</el-tag>
        </div>
        
        <div class="card-body">
          <div class="info-row">
            <span class="label">专业：</span>
            <span class="value">{{ item.major }}</span>
          </div>
          <div class="info-row">
            <span class="label">班主任：</span>
            <span class="value">{{ item.teacherName || '未分配' }}</span>
          </div>
          <div class="info-row">
            <span class="label">学生人数：</span>
            <span class="value student-count">{{ item.studentCount }} 人</span>
          </div>
        </div>
        
        <div class="card-footer">
          <span class="create-time">{{ formatDate(item.createTime) }}</span>
          <div class="actions">
            <el-button type="primary" link size="small" @click.stop="handleEdit(item)">
              编辑
            </el-button>
            <el-button type="danger" link size="small" @click.stop="handleDelete(item)">
              删除
            </el-button>
          </div>
        </div>
      </div>
    </div>

    <!-- 底部加载提示 -->
    <div v-if="filteredData.length > 0" class="load-more">
      共 {{ filteredData.length }} 个班级
    </div>

    <!-- 新增/编辑弹窗 -->
    <el-drawer
      v-model="drawerVisible"
      :title="isEdit ? '编辑班级' : '新增班级'"
      direction="btt"
      size="85%"
      :with-header="true"
      :close-on-click-modal="false"
      class="mobile-drawer"
    >
      <el-form :model="form" :rules="rules" ref="formRef" label-position="top">
        <el-form-item label="班级名称" prop="className">
          <el-input v-model="form.className" placeholder="请输入班级名称" />
        </el-form-item>
        <el-form-item label="年级" prop="grade">
          <el-input v-model="form.grade" placeholder="如：2023级" />
        </el-form-item>
        <el-form-item label="专业" prop="major">
          <el-input v-model="form.major" placeholder="请输入专业名称" />
        </el-form-item>
        <el-form-item label="班主任" prop="teacherId">
          <el-select v-model="form.teacherId" placeholder="请选择班主任" style="width: 100%">
            <el-option 
              v-for="item in teacherList" 
              :key="item.id" 
              :label="item.realName" 
              :value="item.id" 
            />
          </el-select>
        </el-form-item>
      </el-form>
      
      <template #footer>
        <div class="drawer-footer">
          <el-button @click="drawerVisible = false" size="large" style="flex: 1">
            取消
          </el-button>
          <el-button type="primary" @click="handleSubmit" size="large" style="flex: 1">
            确定
          </el-button>
        </div>
      </template>
    </el-drawer>

    <!-- 详情抽屉 -->
    <el-drawer
      v-model="detailVisible"
      title="班级详情"
      direction="rtl"
      size="85%"
      class="mobile-drawer"
    >
      <div v-if="currentClass" class="detail-content">
        <div class="detail-header">
          <div class="detail-title">{{ currentClass.className }}</div>
          <el-tag type="info">{{ currentClass.grade }}</el-tag>
        </div>
        
        <div class="detail-section">
          <div class="section-title">基本信息</div>
          <div class="detail-item">
            <span class="detail-label">专业</span>
            <span class="detail-value">{{ currentClass.major }}</span>
          </div>
          <div class="detail-item">
            <span class="detail-label">班主任</span>
            <span class="detail-value">{{ currentClass.teacherName || '未分配' }}</span>
          </div>
          <div class="detail-item">
            <span class="detail-label">学生人数</span>
            <span class="detail-value highlight">{{ currentClass.studentCount }} 人</span>
          </div>
          <div class="detail-item">
            <span class="detail-label">创建时间</span>
            <span class="detail-value">{{ currentClass.createTime }}</span>
          </div>
        </div>
        
        <div class="detail-actions">
          <el-button type="primary" @click="handleEditFromDetail" size="large" style="flex: 1">
            编辑
          </el-button>
          <el-button type="danger" @click="handleDeleteFromDetail" size="large" style="flex: 1">
            删除
          </el-button>
        </div>
      </div>
    </el-drawer>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Search, School } from '@element-plus/icons-vue'
import { getClassList, addClass, updateClass, deleteClass } from '../../api/class'
import { getUsersByRole } from '../../api/user'

const loading = ref(false)
const tableData = ref([])
const teacherList = ref([])
const drawerVisible = ref(false)
const detailVisible = ref(false)
const isEdit = ref(false)
const formRef = ref()
const searchKeyword = ref('')
const currentClass = ref(null)

const form = reactive({
  id: null,
  className: '',
  grade: '',
  major: '',
  teacherId: null
})

const rules = {
  className: [{ required: true, message: '请输入班级名称', trigger: 'blur' }],
  grade: [{ required: true, message: '请输入年级', trigger: 'blur' }],
  major: [{ required: true, message: '请输入专业', trigger: 'blur' }]
}

// 过滤后的数据
const filteredData = computed(() => {
  if (!searchKeyword.value) return tableData.value
  const keyword = searchKeyword.value.toLowerCase()
  return tableData.value.filter(item => 
    item.className?.toLowerCase().includes(keyword) ||
    item.major?.toLowerCase().includes(keyword)
  )
})

const loadData = async () => {
  loading.value = true
  try {
    const res = await getClassList()
    if (res.code === 200) {
      tableData.value = res.data
    }
  } finally {
    loading.value = false
  }
}

const loadTeacherList = async () => {
  try {
    const res = await getUsersByRole('teacher')
    if (res.code === 200) {
      teacherList.value = res.data
    }
  } catch (error) {
    console.error('获取教师列表失败:', error)
  }
}

const resetForm = () => {
  Object.assign(form, {
    id: null,
    className: '',
    grade: '',
    major: '',
    teacherId: null
  })
}

const handleAdd = () => {
  isEdit.value = false
  resetForm()
  loadTeacherList()
  drawerVisible.value = true
}

const handleEdit = (row) => {
  isEdit.value = true
  Object.assign(form, row)
  loadTeacherList()
  drawerVisible.value = true
}

const handleEditFromDetail = () => {
  detailVisible.value = false
  if (currentClass.value) {
    handleEdit(currentClass.value)
  }
}

const handleSubmit = async () => {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return

  const api = isEdit.value ? updateClass : addClass
  const res = await api(form)
  if (res.code === 200) {
    ElMessage.success(isEdit.value ? '修改成功' : '新增成功')
    drawerVisible.value = false
    loadData()
  }
}

const handleDelete = (row) => {
  ElMessageBox.confirm(
    `确定要删除班级「${row.className}」吗？`,
    '提示',
    { 
      type: 'warning',
      confirmButtonText: '删除',
      confirmButtonClass: 'el-button--danger'
    }
  ).then(async () => {
    const res = await deleteClass(row.id)
    if (res.code === 200) {
      ElMessage.success('删除成功')
      loadData()
    } else {
      ElMessage.error(res.message || '删除失败')
    }
  })
}

const handleDeleteFromDetail = () => {
  detailVisible.value = false
  if (currentClass.value) {
    handleDelete(currentClass.value)
  }
}

const handleCardClick = (item) => {
  currentClass.value = item
  detailVisible.value = true
}

const handleSearch = () => {
  // 实时搜索，无需额外操作
}

const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.classes-mobile {
  min-height: 100vh;
  background: #f5f5f5;
  padding-bottom: 20px;
}

.mobile-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  background: linear-gradient(135deg, #0d9488 0%, #0f766e 100%);
  color: white;
}

.header-title {
  font-size: 18px;
  font-weight: 600;
}

.search-bar {
  padding: 12px 16px;
  background: white;
  border-bottom: 1px solid #e5e5e5;
}

.class-list {
  padding: 12px;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  color: #999;
}

.empty-state p {
  margin-top: 12px;
  font-size: 14px;
}

.class-card {
  background: white;
  border-radius: 12px;
  padding: 16px;
  margin-bottom: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  transition: all 0.3s ease;
}

.class-card:active {
  transform: scale(0.98);
  background: #f9f9f9;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.class-name {
  font-size: 16px;
  font-weight: 600;
  color: #333;
}

.card-body {
  margin-bottom: 12px;
}

.info-row {
  display: flex;
  justify-content: space-between;
  padding: 6px 0;
  border-bottom: 1px solid #f0f0f0;
}

.info-row:last-child {
  border-bottom: none;
}

.label {
  color: #666;
  font-size: 13px;
}

.value {
  color: #333;
  font-size: 13px;
  font-weight: 500;
}

.student-count {
  color: #0d9488;
  font-weight: 600;
}

.card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 12px;
  border-top: 1px solid #f0f0f0;
}

.create-time {
  font-size: 12px;
  color: #999;
}

.actions {
  display: flex;
  gap: 8px;
}

.load-more {
  text-align: center;
  padding: 16px;
  color: #999;
  font-size: 13px;
}

/* 抽屉底部按钮 */
.drawer-footer {
  display: flex;
  gap: 12px;
  padding: 16px;
}

/* 详情页样式 */
.detail-content {
  padding: 0 4px;
}

.detail-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 16px;
  border-bottom: 1px solid #e5e5e5;
  margin-bottom: 20px;
}

.detail-title {
  font-size: 20px;
  font-weight: 600;
  color: #333;
}

.detail-section {
  margin-bottom: 24px;
}

.section-title {
  font-size: 14px;
  font-weight: 600;
  color: #666;
  margin-bottom: 16px;
  padding-left: 8px;
  border-left: 3px solid #0d9488;
}

.detail-item {
  display: flex;
  justify-content: space-between;
  padding: 12px 0;
  border-bottom: 1px solid #f0f0f0;
}

.detail-item:last-child {
  border-bottom: none;
}

.detail-label {
  color: #666;
  font-size: 14px;
}

.detail-value {
  color: #333;
  font-size: 14px;
  font-weight: 500;
}

.detail-value.highlight {
  color: #0d9488;
  font-weight: 600;
}

.detail-actions {
  display: flex;
  gap: 12px;
  padding-top: 20px;
  border-top: 1px solid #e5e5e5;
}
</style>

<style>
/* 全局样式覆盖 */
.mobile-drawer .el-drawer__header {
  padding: 16px;
  margin-bottom: 0;
  border-bottom: 1px solid #e5e5e5;
}

.mobile-drawer .el-drawer__body {
  padding: 16px;
}

.mobile-drawer .el-drawer__footer {
  padding: 0;
  border-top: 1px solid #e5e5e5;
}

.mobile-drawer .el-form-item {
  margin-bottom: 20px;
}

.mobile-drawer .el-form-item__label {
  font-weight: 500;
  color: #333;
  padding-bottom: 8px;
}
</style>
