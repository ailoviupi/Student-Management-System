<template>
  <div class="scholarship-management">
    <div class="page-header">
      <h2 class="page-title">奖学金评定</h2>
      <p class="page-desc">奖学金类型管理与学生评定</p>
    </div>

    <!-- 统计卡片 -->
    <el-row :gutter="20" class="stats-row">
      <el-col :xs="24" :sm="12" :md="6">
        <div class="stat-card">
          <div class="stat-icon primary">
            <el-icon size="28"><Trophy /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ statistics.totalApplications || 0 }}</div>
            <div class="stat-label">总申请数</div>
          </div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6">
        <div class="stat-card">
          <div class="stat-icon warning">
            <el-icon size="28"><Timer /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ statistics.pendingCount || 0 }}</div>
            <div class="stat-label">待审核</div>
          </div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6">
        <div class="stat-card">
          <div class="stat-icon success">
            <el-icon size="28"><CircleCheck /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ statistics.approvedCount || 0 }}</div>
            <div class="stat-label">已通过</div>
          </div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6">
        <div class="stat-card">
          <div class="stat-icon info">
            <el-icon size="28"><Money /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">¥{{ formatAmount(statistics.totalAmount) }}</div>
            <div class="stat-label">奖学金总额</div>
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- 详细统计 -->
    <el-row :gutter="20" class="detail-stats-row" v-if="isAdmin">
      <el-col :xs="24" :md="12">
        <el-card class="chart-card">
          <template #header>
            <span>奖学金类型分布</span>
          </template>
          <div class="type-stats">
            <div v-for="(count, type) in statistics.typeStatistics" :key="type" class="type-stat-item">
              <span class="type-name">{{ type }}</span>
              <el-progress :percentage="calculatePercentage(count)" :format="() => count + '人'" />
            </div>
            <el-empty v-if="!statistics.typeStatistics || Object.keys(statistics.typeStatistics).length === 0" description="暂无数据" />
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :md="12">
        <el-card class="chart-card">
          <template #header>
            <span>评定数据概览</span>
          </template>
          <div class="overview-stats">
            <div class="overview-item">
              <div class="overview-label">平均GPA</div>
              <div class="overview-value">{{ statistics.averageGpa || '0.00' }}</div>
            </div>
            <div class="overview-item">
              <div class="overview-label">平均排名</div>
              <div class="overview-value">{{ statistics.averageRanking || '0.0' }}</div>
            </div>
            <div class="overview-item">
              <div class="overview-label">拒绝申请</div>
              <div class="overview-value text-danger">{{ statistics.rejectedCount || 0 }}</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 操作栏 -->
    <el-card class="table-card">
      <template #header>
        <div class="card-header">
          <div class="header-left">
            <el-radio-group v-model="activeTab" size="small">
              <el-radio-button value="records">评定记录</el-radio-button>
              <el-radio-button value="types" v-if="isAdmin">奖学金类型</el-radio-button>
              <el-radio-button value="my" v-if="isStudent">我的奖学金</el-radio-button>
            </el-radio-group>
          </div>
          <div class="header-right">
            <el-select v-model="filterForm.academicYear" placeholder="学年" size="small" style="width: 120px; margin-right: 10px">
              <el-option label="2023-2024" value="2023-2024" />
              <el-option label="2024-2025" value="2024-2025" />
            </el-select>
            <el-select v-model="filterForm.semester" placeholder="学期" size="small" style="width: 100px; margin-right: 10px">
              <el-option label="上学期" value="上学期" />
              <el-option label="下学期" value="下学期" />
              <el-option label="全年" value="全年" />
            </el-select>
            <el-button type="warning" size="small" @click="autoEvaluate" :loading="evaluating" v-if="isAdmin">
              <el-icon><MagicStick /></el-icon>
              自动评定
            </el-button>
            <el-button type="success" size="small" @click="showApplyDialog" v-if="activeTab === 'records' && !isStudent">
              <el-icon><Plus /></el-icon>
              申请奖学金
            </el-button>
            <el-button type="primary" size="small" @click="showStudentApplyDialog" v-if="isStudent && activeTab === 'my'">
              <el-icon><Plus /></el-icon>
              申请奖学金
            </el-button>
            <el-button type="success" size="small" @click="showTypeDialog" v-if="activeTab === 'types' && isAdmin">
              <el-icon><Plus /></el-icon>
              添加类型
            </el-button>
          </div>
        </div>
      </template>

      <!-- 评定记录列表 -->
      <template v-if="activeTab === 'records'">
        <div class="filter-bar">
          <el-select v-model="filterForm.status" placeholder="审核状态" clearable size="small" style="width: 120px">
            <el-option label="待审核" value="PENDING" />
            <el-option label="已通过" value="APPROVED" />
            <el-option label="已拒绝" value="REJECTED" />
          </el-select>
          <el-select v-model="filterForm.scholarshipTypeId" placeholder="奖学金类型" clearable size="small" style="width: 150px; margin-left: 10px">
            <el-option v-for="type in typeList" :key="type.id" :label="type.typeName" :value="type.id" />
          </el-select>
          <el-button type="primary" size="small" @click="loadRecords" style="margin-left: 10px">
            <el-icon><Search /></el-icon>
            查询
          </el-button>
          <el-button size="small" @click="resetFilter">重置</el-button>
        </div>

        <el-table :data="recordList" v-loading="loading" stripe>
          <el-table-column type="index" width="50" />
          <el-table-column label="学生信息" min-width="150">
            <template #default="{ row }">
              <div class="student-info">
                <div class="student-name">{{ row.studentName }}</div>
                <div class="student-no">{{ row.studentNo }}</div>
                <div class="class-name">{{ row.className }}</div>
              </div>
            </template>
          </el-table-column>
          <el-table-column label="奖学金类型" min-width="150">
            <template #default="{ row }">
              <div class="scholarship-type">{{ row.scholarshipTypeName }}</div>
              <div class="scholarship-amount">¥{{ formatAmount(row.scholarshipAmount) }}</div>
            </template>
          </el-table-column>
          <el-table-column label="学年/学期" width="120">
            <template #default="{ row }">
              <div>{{ row.academicYear }}</div>
              <div class="semester">{{ row.semester }}</div>
            </template>
          </el-table-column>
          <el-table-column label="综合评分" width="100">
            <template #default="{ row }">
              <div class="score">{{ row.totalScore }}</div>
              <div class="gpa">GPA: {{ row.gpa }}</div>
            </template>
          </el-table-column>
          <el-table-column label="排名" width="80">
            <template #default="{ row }">
              <span class="ranking">第 {{ row.ranking }} 名</span>
            </template>
          </el-table-column>
          <el-table-column label="状态" width="100">
            <template #default="{ row }">
              <el-tag :type="getStatusType(row.status)" size="small">
                {{ getStatusText(row.status) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="150" fixed="right">
            <template #default="{ row }">
              <el-button v-if="row.status === 'PENDING' && isAdmin" type="primary" size="small" @click="handleReview(row)">
                审核
              </el-button>
              <el-button type="danger" size="small" @click="deleteRecord(row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </template>

      <!-- 我的奖学金 -->
      <template v-else-if="activeTab === 'my'">
        <el-empty v-if="myRecords.length === 0" description="暂无奖学金记录" />
        <el-timeline v-else>
          <el-timeline-item
            v-for="record in myRecords"
            :key="record.id"
            :type="getTimelineType(record.status)"
            :timestamp="formatTime(record.createTime)"
          >
            <el-card>
              <div class="my-scholarship-item">
                <div class="scholarship-header">
                  <span class="scholarship-name">{{ record.scholarshipTypeName }}</span>
                  <el-tag :type="getStatusType(record.status)" size="small">
                    {{ getStatusText(record.status) }}
                  </el-tag>
                </div>
                <div class="scholarship-detail">
                  <div class="detail-item">
                    <span class="label">金额：</span>
                    <span class="value amount">¥{{ formatAmount(record.scholarshipAmount) }}</span>
                  </div>
                  <div class="detail-item">
                    <span class="label">学年学期：</span>
                    <span class="value">{{ record.academicYear }} {{ record.semester }}</span>
                  </div>
                  <div class="detail-item">
                    <span class="label">GPA：</span>
                    <span class="value">{{ record.gpa }}</span>
                  </div>
                  <div class="detail-item">
                    <span class="label">排名：</span>
                    <span class="value">第 {{ record.ranking }} 名</span>
                  </div>
                </div>
                <div v-if="record.reviewRemark" class="review-remark">
                  <el-divider />
                  <div class="remark-content">
                    <span class="label">审核备注：</span>
                    <span class="value">{{ record.reviewRemark }}</span>
                  </div>
                </div>
              </div>
            </el-card>
          </el-timeline-item>
        </el-timeline>
      </template>

      <!-- 奖学金类型列表 -->
      <template v-else>
        <el-table :data="typeList" v-loading="typeLoading" stripe>
          <el-table-column type="index" width="50" />
          <el-table-column prop="typeName" label="奖学金名称" min-width="150" />
          <el-table-column prop="typeCode" label="代码" width="100" />
          <el-table-column label="金额" width="120">
            <template #default="{ row }">
              ¥{{ formatAmount(row.amount) }}
            </template>
          </el-table-column>
          <el-table-column prop="quota" label="名额" width="80" />
          <el-table-column label="学年/学期" width="120">
            <template #default="{ row }">
              <div>{{ row.academicYear }}</div>
              <div class="semester">{{ row.semester }}</div>
            </template>
          </el-table-column>
          <el-table-column prop="requirements" label="评选条件" min-width="200" show-overflow-tooltip />
          <el-table-column label="状态" width="80">
            <template #default="{ row }">
              <el-switch v-model="row.status" :active-value="1" :inactive-value="0" @change="toggleTypeStatus(row)" />
            </template>
          </el-table-column>
          <el-table-column label="操作" width="150" fixed="right">
            <template #default="{ row }">
              <el-button type="primary" size="small" @click="showTypeDialog(row)">编辑</el-button>
              <el-button type="danger" size="small" @click="deleteType(row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </template>
    </el-card>

    <!-- 申请奖学金对话框 -->
    <el-dialog v-model="applyDialogVisible" title="申请奖学金" width="500px">
      <el-form :model="applyForm" label-width="100px" :rules="applyRules" ref="applyFormRef">
        <el-form-item label="选择学生" prop="studentId" v-if="!isStudent">
          <el-select-v2
            v-model="applyForm.studentId"
            :options="studentOptions"
            placeholder="选择学生"
            clearable
            filterable
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="奖学金类型" prop="scholarshipTypeId">
          <el-select v-model="applyForm.scholarshipTypeId" placeholder="选择奖学金类型" style="width: 100%">
            <el-option v-for="type in activeTypeList" :key="type.id" :label="type.typeName" :value="type.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="学年">
          <el-select v-model="applyForm.academicYear" style="width: 100%">
            <el-option label="2023-2024" value="2023-2024" />
            <el-option label="2024-2025" value="2024-2025" />
          </el-select>
        </el-form-item>
        <el-form-item label="学期">
          <el-select v-model="applyForm.semester" style="width: 100%">
            <el-option label="上学期" value="上学期" />
            <el-option label="下学期" value="下学期" />
            <el-option label="全年" value="全年" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="applyDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="confirmApply" :loading="applying">提交申请</el-button>
      </template>
    </el-dialog>

    <!-- 审核对话框 -->
    <el-dialog v-model="reviewDialogVisible" title="审核奖学金申请" width="500px">
      <el-descriptions :column="2" border v-if="currentRecord">
        <el-descriptions-item label="学生">{{ currentRecord.studentName }}</el-descriptions-item>
        <el-descriptions-item label="学号">{{ currentRecord.studentNo }}</el-descriptions-item>
        <el-descriptions-item label="奖学金">{{ currentRecord.scholarshipTypeName }}</el-descriptions-item>
        <el-descriptions-item label="金额">¥{{ formatAmount(currentRecord.scholarshipAmount) }}</el-descriptions-item>
        <el-descriptions-item label="GPA">{{ currentRecord.gpa }}</el-descriptions-item>
        <el-descriptions-item label="排名">第 {{ currentRecord.ranking }} 名</el-descriptions-item>
        <el-descriptions-item label="综合评分">{{ currentRecord.totalScore }}</el-descriptions-item>
      </el-descriptions>
      <el-form :model="reviewForm" label-width="100px" style="margin-top: 20px">
        <el-form-item label="审核结果">
          <el-radio-group v-model="reviewForm.status">
              <el-radio-button value="APPROVED">通过</el-radio-button>
              <el-radio-button value="REJECTED">拒绝</el-radio-button>
            </el-radio-group>
        </el-form-item>
        <el-form-item label="审核备注">
          <el-input v-model="reviewForm.reviewRemark" type="textarea" rows="3" placeholder="请输入审核备注..." />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="reviewDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="confirmReview" :loading="reviewing">确认审核</el-button>
      </template>
    </el-dialog>

    <!-- 奖学金类型编辑对话框 -->
    <el-dialog v-model="typeDialogVisible" :title="typeForm.id ? '编辑奖学金类型' : '添加奖学金类型'" width="500px">
      <el-form :model="typeForm" label-width="100px" :rules="typeRules" ref="typeFormRef">
        <el-form-item label="奖学金名称" prop="typeName">
          <el-input v-model="typeForm.typeName" placeholder="请输入奖学金名称" />
        </el-form-item>
        <el-form-item label="类型代码" prop="typeCode">
          <el-input v-model="typeForm.typeCode" placeholder="请输入类型代码" />
        </el-form-item>
        <el-form-item label="奖学金额度" prop="amount">
          <el-input-number v-model="typeForm.amount" :min="0" :precision="2" style="width: 100%" />
        </el-form-item>
        <el-form-item label="名额限制">
          <el-input-number v-model="typeForm.quota" :min="1" style="width: 100%" />
        </el-form-item>
        <el-form-item label="学年">
          <el-select v-model="typeForm.academicYear" style="width: 100%">
            <el-option label="2023-2024" value="2023-2024" />
            <el-option label="2024-2025" value="2024-2025" />
          </el-select>
        </el-form-item>
        <el-form-item label="学期">
          <el-select v-model="typeForm.semester" style="width: 100%">
            <el-option label="上学期" value="上学期" />
            <el-option label="下学期" value="下学期" />
            <el-option label="全年" value="全年" />
          </el-select>
        </el-form-item>
        <el-form-item label="评选条件">
          <el-input v-model="typeForm.requirements" type="textarea" rows="3" placeholder="请输入评选条件，如：GPA>=3.0,排名<=10,无不及格" />
          <div class="form-tip">格式：GPA>=3.0,排名<=10,无不及格</div>
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="typeForm.description" type="textarea" rows="3" placeholder="请输入奖学金描述" />
        </el-form-item>
        <el-form-item label="启用状态">
          <el-switch v-model="typeForm.status" :active-value="1" :inactive-value="0" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="typeDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveType" :loading="savingType">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Trophy, Timer, CircleCheck, Money, MagicStick, Plus, Search } from '@element-plus/icons-vue'
import {
  getScholarshipTypes,
  getActiveScholarshipTypes,
  addScholarshipType,
  updateScholarshipType,
  deleteScholarshipType,
  getScholarshipRecords,
  applyScholarship,
  reviewScholarship,
  deleteScholarshipRecord,
  autoEvaluateScholarship,
  getScholarshipStatistics
} from '../api/scholarship'
import { getStudentList } from '../api/student'

const activeTab = ref('records')
const loading = ref(false)
const typeLoading = ref(false)
const evaluating = ref(false)
const applying = ref(false)
const reviewing = ref(false)
const savingType = ref(false)

const isAdmin = computed(() => {
  const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
  return userInfo.role === 'admin'
})

const isStudent = computed(() => {
  const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
  return userInfo.role === 'student'
})

const userInfo = computed(() => {
  return JSON.parse(localStorage.getItem('userInfo') || '{}')
})

const statistics = reactive({
  totalApplications: 0,
  pendingCount: 0,
  approvedCount: 0,
  rejectedCount: 0,
  totalAmount: 0,
  typeStatistics: {},
  averageGpa: 0,
  averageRanking: 0
})

const filterForm = reactive({
  academicYear: '2023-2024',
  semester: '上学期',
  status: '',
  scholarshipTypeId: null
})

const recordList = ref([])
const myRecords = ref([])
const typeList = ref([])
const activeTypeList = ref([])
const studentList = ref([])

const studentOptions = computed(() => {
  return studentList.value.map(s => ({
    value: s.id,
    label: `${s.studentNo} - ${s.name}`
  }))
})

const applyDialogVisible = ref(false)
const applyFormRef = ref()
const applyForm = reactive({
  studentId: null,
  scholarshipTypeId: null,
  academicYear: '2023-2024',
  semester: '全年'
})

const applyRules = {
  studentId: [{ required: true, message: '请选择学生', trigger: 'change' }],
  scholarshipTypeId: [{ required: true, message: '请选择奖学金类型', trigger: 'change' }]
}

const reviewDialogVisible = ref(false)
const currentRecord = ref(null)
const reviewForm = reactive({
  status: 'APPROVED',
  reviewRemark: ''
})

const typeDialogVisible = ref(false)
const typeFormRef = ref()
const typeForm = reactive({
  id: null,
  typeName: '',
  typeCode: '',
  amount: 1000,
  quota: 10,
  academicYear: '2023-2024',
  semester: '全年',
  requirements: '',
  description: '',
  status: 1
})

const typeRules = {
  typeName: [{ required: true, message: '请输入奖学金名称', trigger: 'blur' }],
  typeCode: [{ required: true, message: '请输入类型代码', trigger: 'blur' }],
  amount: [{ required: true, message: '请输入奖学金额度', trigger: 'blur' }]
}

const getStatusType = (status) => {
  const map = { PENDING: 'warning', APPROVED: 'success', REJECTED: 'danger' }
  return map[status] || 'info'
}

const getStatusText = (status) => {
  const map = { PENDING: '待审核', APPROVED: '已通过', REJECTED: '已拒绝' }
  return map[status] || status
}

const getTimelineType = (status) => {
  const map = { PENDING: 'warning', APPROVED: 'success', REJECTED: 'danger' }
  return map[status] || 'info'
}

const formatAmount = (amount) => {
  if (!amount) return '0.00'
  return parseFloat(amount).toFixed(2)
}

const formatTime = (time) => {
  if (!time) return ''
  return new Date(time).toLocaleString()
}

const calculatePercentage = (count) => {
  const total = statistics.approvedCount || 1
  return Math.round((count / total) * 100)
}

const loadStatistics = async () => {
  try {
    const res = await getScholarshipStatistics({
      academicYear: filterForm.academicYear,
      semester: filterForm.semester
    })
    if (res.code === 200) {
      Object.assign(statistics, res.data)
    }
  } catch (error) {
    console.error('加载统计数据失败:', error)
  }
}

const loadRecords = async () => {
  loading.value = true
  try {
    const res = await getScholarshipRecords(filterForm)
    if (res.code === 200) {
      recordList.value = res.data || []
    }
  } catch (error) {
    ElMessage.error('加载记录失败')
  } finally {
    loading.value = false
  }
}

const loadMyRecords = async () => {
  loading.value = true
  try {
    const res = await getScholarshipRecords({
      studentId: userInfo.value.studentId,
      academicYear: filterForm.academicYear,
      semester: filterForm.semester
    })
    if (res.code === 200) {
      myRecords.value = res.data || []
    }
  } catch (error) {
    ElMessage.error('加载我的奖学金失败')
  } finally {
    loading.value = false
  }
}

const loadTypes = async () => {
  typeLoading.value = true
  try {
    const res = await getScholarshipTypes()
    if (res.code === 200) {
      typeList.value = res.data || []
    }
  } catch (error) {
    ElMessage.error('加载类型列表失败')
  } finally {
    typeLoading.value = false
  }
}

const loadActiveTypes = async () => {
  try {
    const res = await getActiveScholarshipTypes()
    if (res.code === 200) {
      activeTypeList.value = res.data || []
    }
  } catch (error) {
    console.error('加载活动类型失败:', error)
  }
}

const loadStudents = async () => {
  try {
    const res = await getStudentList({ pageNum: 1, pageSize: 9999 })
    if (res.code === 200) {
      studentList.value = res.data?.list || res.data || []
    }
  } catch (error) {
    console.error('加载学生列表失败:', error)
  }
}

const resetFilter = () => {
  filterForm.status = ''
  filterForm.scholarshipTypeId = null
  loadRecords()
}

const autoEvaluate = async () => {
  evaluating.value = true
  try {
    const res = await autoEvaluateScholarship({
      academicYear: filterForm.academicYear,
      semester: filterForm.semester
    })
    if (res.code === 200) {
      ElMessage.success('自动评定完成')
      loadRecords()
      loadStatistics()
    }
  } catch (error) {
    ElMessage.error('自动评定失败')
  } finally {
    evaluating.value = false
  }
}

const showApplyDialog = () => {
  applyForm.studentId = null
  applyForm.scholarshipTypeId = null
  applyForm.academicYear = filterForm.academicYear
  applyForm.semester = filterForm.semester
  applyDialogVisible.value = true
}

const showStudentApplyDialog = () => {
  applyForm.studentId = userInfo.value.studentId
  applyForm.scholarshipTypeId = null
  applyForm.academicYear = filterForm.academicYear
  applyForm.semester = filterForm.semester
  applyDialogVisible.value = true
}

const confirmApply = async () => {
  const valid = await applyFormRef.value.validate().catch(() => false)
  if (!valid) return

  applying.value = true
  try {
    await applyScholarship(applyForm)
    ElMessage.success('申请成功')
    applyDialogVisible.value = false
    if (isStudent.value) {
      loadMyRecords()
    } else {
      loadRecords()
    }
    loadStatistics()
  } catch (error) {
    ElMessage.error(error.response?.data?.message || '申请失败，可能已申请过该奖学金')
  } finally {
    applying.value = false
  }
}

const handleReview = (row) => {
  currentRecord.value = row
  reviewForm.status = 'APPROVED'
  reviewForm.reviewRemark = ''
  reviewDialogVisible.value = true
}

const confirmReview = async () => {
  reviewing.value = true
  try {
    // 获取审核人ID，优先使用id，如果没有则使用studentId
    const reviewerId = userInfo.value.id || userInfo.value.studentId
    if (!reviewerId) {
      ElMessage.error('无法获取审核人信息，请重新登录')
      reviewing.value = false
      return
    }
    await reviewScholarship(currentRecord.value.id, {
      status: reviewForm.status,
      reviewerId: reviewerId,
      reviewRemark: reviewForm.reviewRemark
    })
    ElMessage.success('审核完成')
    reviewDialogVisible.value = false
    loadRecords()
    loadStatistics()
  } catch (error) {
    ElMessage.error(error.response?.data?.message || '审核失败')
  } finally {
    reviewing.value = false
  }
}

const deleteRecord = (row) => {
  ElMessageBox.confirm('确定删除该申请记录吗？', '提示', { type: 'warning' })
    .then(async () => {
      try {
        await deleteScholarshipRecord(row.id)
        ElMessage.success('删除成功')
        loadRecords()
        loadStatistics()
      } catch (error) {
        ElMessage.error('删除失败')
      }
    })
}

const showTypeDialog = (row = null) => {
  if (row) {
    Object.assign(typeForm, row)
  } else {
    typeForm.id = null
    typeForm.typeName = ''
    typeForm.typeCode = ''
    typeForm.amount = 1000
    typeForm.quota = 10
    typeForm.academicYear = '2023-2024'
    typeForm.semester = '全年'
    typeForm.requirements = ''
    typeForm.description = ''
    typeForm.status = 1
  }
  typeDialogVisible.value = true
}

const saveType = async () => {
  const valid = await typeFormRef.value.validate().catch(() => false)
  if (!valid) return

  savingType.value = true
  try {
    if (typeForm.id) {
      await updateScholarshipType(typeForm.id, typeForm)
    } else {
      await addScholarshipType(typeForm)
    }
    ElMessage.success('保存成功')
    typeDialogVisible.value = false
    loadTypes()
    loadActiveTypes()
  } catch (error) {
    ElMessage.error('保存失败')
  } finally {
    savingType.value = false
  }
}

const toggleTypeStatus = async (row) => {
  try {
    await updateScholarshipType(row.id, row)
    ElMessage.success('状态更新成功')
  } catch (error) {
    row.status = row.status === 1 ? 0 : 1
    ElMessage.error('状态更新失败')
  }
}

const deleteType = (row) => {
  ElMessageBox.confirm('确定删除该奖学金类型吗？', '提示', { type: 'warning' })
    .then(async () => {
      try {
        await deleteScholarshipType(row.id)
        ElMessage.success('删除成功')
        loadTypes()
        loadActiveTypes()
      } catch (error) {
        ElMessage.error('删除失败')
      }
    })
}

onMounted(() => {
  loadStatistics()
  if (isStudent.value) {
    activeTab.value = 'my'
    loadMyRecords()
  } else {
    loadRecords()
  }
  loadTypes()
  loadActiveTypes()
  loadStudents()
})
</script>

<style scoped>
.scholarship-management {
  padding: 0;
}

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

.stats-row {
  margin-bottom: 20px;
}

.detail-stats-row {
  margin-bottom: 20px;
}

.stat-card {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 16px;
  transition: all 0.3s;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px -4px rgba(0, 0, 0, 0.1);
}

.stat-icon {
  width: 56px;
  height: 56px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
}

.stat-icon.primary {
  background: linear-gradient(135deg, #0d9488, #14b8a6);
}

.stat-icon.warning {
  background: linear-gradient(135deg, #f59e0b, #fbbf24);
}

.stat-icon.success {
  background: linear-gradient(135deg, #10b981, #34d399);
}

.stat-icon.info {
  background: linear-gradient(135deg, #06b6d4, #22d3ee);
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 24px;
  font-weight: 700;
  color: #1e293b;
  line-height: 1;
  margin-bottom: 4px;
}

.stat-label {
  font-size: 13px;
  color: #94a3b8;
}

.chart-card {
  border-radius: 12px;
  height: 100%;
}

.type-stats {
  padding: 10px 0;
}

.type-stat-item {
  margin-bottom: 16px;
}

.type-stat-item:last-child {
  margin-bottom: 0;
}

.type-name {
  display: block;
  margin-bottom: 8px;
  font-size: 14px;
  color: #1e293b;
}

.overview-stats {
  display: flex;
  justify-content: space-around;
  padding: 20px 0;
}

.overview-item {
  text-align: center;
}

.overview-label {
  font-size: 13px;
  color: #94a3b8;
  margin-bottom: 8px;
}

.overview-value {
  font-size: 28px;
  font-weight: 700;
  color: #0d9488;
}

.overview-value.text-danger {
  color: #ef4444;
}

.table-card {
  border-radius: 12px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 12px;
}

.header-right {
  display: flex;
  align-items: center;
}

.filter-bar {
  margin-bottom: 20px;
  display: flex;
  align-items: center;
}

.student-info {
  line-height: 1.5;
}

.student-name {
  font-weight: 600;
  color: #1e293b;
}

.student-no {
  font-size: 12px;
  color: #64748b;
}

.class-name {
  font-size: 12px;
  color: #94a3b8;
}

.scholarship-type {
  font-weight: 600;
  color: #1e293b;
}

.scholarship-amount {
  font-size: 12px;
  color: #10b981;
  font-weight: 600;
}

.score {
  font-weight: 600;
  color: #0d9488;
}

.gpa {
  font-size: 12px;
  color: #64748b;
}

.ranking {
  font-weight: 600;
  color: #f59e0b;
}

.semester {
  font-size: 12px;
  color: #94a3b8;
}

.form-tip {
  font-size: 12px;
  color: #94a3b8;
  margin-top: 4px;
}

/* 我的奖学金样式 */
.my-scholarship-item {
  padding: 10px;
}

.scholarship-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.scholarship-name {
  font-size: 16px;
  font-weight: 600;
  color: #1e293b;
}

.scholarship-detail {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
}

.detail-item {
  display: flex;
  align-items: center;
}

.detail-item .label {
  font-size: 13px;
  color: #64748b;
  margin-right: 4px;
}

.detail-item .value {
  font-size: 14px;
  color: #1e293b;
  font-weight: 500;
}

.detail-item .value.amount {
  color: #10b981;
  font-weight: 600;
}

.review-remark {
  margin-top: 12px;
}

.remark-content {
  font-size: 13px;
}

.remark-content .label {
  color: #64748b;
}

.remark-content .value {
  color: #1e293b;
}

@media (max-width: 768px) {
  .stats-row .el-col {
    margin-bottom: 12px;
  }

  .card-header {
    flex-direction: column;
    align-items: flex-start;
  }

  .header-right {
    width: 100%;
    flex-wrap: wrap;
  }

  .overview-stats {
    flex-direction: column;
    gap: 20px;
  }

  .scholarship-detail {
    grid-template-columns: 1fr;
  }
}
</style>
