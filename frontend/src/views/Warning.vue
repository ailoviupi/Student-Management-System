<template>
  <div class="warning-management">
    <div class="page-header">
      <h2 class="page-title">学业预警系统</h2>
      <p class="page-desc">学生学业风险监控与预警管理</p>
    </div>

    <!-- 统计卡片 -->
    <el-row :gutter="20" class="stats-row">
      <el-col :xs="24" :sm="12" :md="6">
        <div class="stat-card pending">
          <div class="stat-icon">
            <el-icon size="28"><Warning /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ statistics.totalPending || 0 }}</div>
            <div class="stat-label">待处理预警</div>
          </div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6">
        <div class="stat-card yellow">
          <div class="stat-icon">
            <el-icon size="28"><InfoFilled /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ statistics.yellowCount || 0 }}</div>
            <div class="stat-label">黄色预警</div>
          </div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6">
        <div class="stat-card orange">
          <div class="stat-icon">
            <el-icon size="28"><WarningFilled /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ statistics.orangeCount || 0 }}</div>
            <div class="stat-label">橙色预警</div>
          </div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6">
        <div class="stat-card red">
          <div class="stat-icon">
            <el-icon size="28"><CircleCloseFilled /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ statistics.redCount || 0 }}</div>
            <div class="stat-label">红色预警</div>
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- 操作栏 -->
    <el-card class="table-card">
      <template #header>
        <div class="card-header">
          <div class="header-left">
            <el-radio-group v-model="activeTab" size="small">
              <el-radio-button value="warnings">预警记录</el-radio-button>
              <el-radio-button value="rules">预警规则</el-radio-button>
            </el-radio-group>
          </div>
          <div class="header-right">
            <el-button type="primary" size="small" @click="checkWarnings" :loading="checking">
              <el-icon><Refresh /></el-icon>
              扫描预警
            </el-button>
            <el-button v-if="activeTab === 'rules'" type="success" size="small" @click="showRuleDialog()">
              <el-icon><Plus /></el-icon>
              添加规则
            </el-button>
          </div>
        </div>
      </template>

      <!-- 预警记录列表 -->
      <template v-if="activeTab === 'warnings'">
        <div class="filter-bar">
          <el-select v-model="filterForm.status" placeholder="预警状态" clearable size="small" style="width: 120px">
            <el-option label="待处理" value="PENDING" />
            <el-option label="处理中" value="PROCESSING" />
            <el-option label="已解决" value="RESOLVED" />
            <el-option label="已忽略" value="IGNORED" />
          </el-select>
          <el-select v-model="filterForm.warningLevel" placeholder="预警等级" clearable size="small" style="width: 120px; margin-left: 10px">
            <el-option label="黄色" value="YELLOW">
              <el-tag type="warning" size="small">黄色</el-tag>
            </el-option>
            <el-option label="橙色" value="ORANGE">
              <el-tag type="danger" size="small" style="background: #ff8c00; color: #fff; border-color: #ff8c00">橙色</el-tag>
            </el-option>
            <el-option label="红色" value="RED">
              <el-tag type="danger" size="small">红色</el-tag>
            </el-option>
          </el-select>
          <el-select v-model="filterForm.warningType" placeholder="预警类型" clearable size="small" style="width: 120px; margin-left: 10px">
            <el-option label="成绩预警" value="SCORE" />
            <el-option label="考勤预警" value="ATTENDANCE" />
            <el-option label="综合预警" value="COMPREHENSIVE" />
          </el-select>
          <el-button type="primary" size="small" @click="loadWarnings" style="margin-left: 10px">
            <el-icon><Search /></el-icon>
            查询
          </el-button>
          <el-button size="small" @click="resetFilter">重置</el-button>
        </div>

        <el-table :data="warningList" v-loading="loading" stripe>
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
          <el-table-column label="预警等级" width="100">
            <template #default="{ row }">
              <el-tag :type="getLevelType(row.warningLevel)" size="small">
                {{ getLevelText(row.warningLevel) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="预警类型" width="100">
            <template #default="{ row }">
              <el-tag :type="getTypeType(row.warningType)" size="small">
                {{ getTypeText(row.warningType) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="预警原因" min-width="200">
            <template #default="{ row }">
              <div class="warning-reason">{{ row.warningReason }}</div>
              <div v-if="row.courseName" class="course-name">课程: {{ row.courseName }}</div>
              <div v-if="row.relatedScore" class="score-value">成绩: {{ row.relatedScore }}分</div>
              <div v-if="row.attendanceCount" class="attendance-count">缺勤: {{ row.attendanceCount }}次</div>
            </template>
          </el-table-column>
          <el-table-column label="状态" width="100">
            <template #default="{ row }">
              <el-tag :type="getStatusType(row.status)" size="small">
                {{ getStatusText(row.status) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="预警时间" width="150">
            <template #default="{ row }">
              {{ formatDate(row.createTime) }}
            </template>
          </el-table-column>
          <el-table-column label="操作" width="150" fixed="right">
            <template #default="{ row }">
              <el-button v-if="row.status === 'PENDING'" type="primary" size="small" @click="handleWarning(row)">
                处理
              </el-button>
              <el-button type="danger" size="small" @click="deleteWarning(row)">
                删除
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </template>

      <!-- 预警规则列表 -->
      <template v-else>
        <el-table :data="ruleList" v-loading="ruleLoading" stripe>
          <el-table-column type="index" width="50" />
          <el-table-column prop="ruleName" label="规则名称" min-width="150" />
          <el-table-column label="规则类型" width="100">
            <template #default="{ row }">
              {{ getTypeText(row.ruleType) }}
            </template>
          </el-table-column>
          <el-table-column label="预警等级" width="100">
            <template #default="{ row }">
              <el-tag :type="getLevelType(row.warningLevel)" size="small">
                {{ getLevelText(row.warningLevel) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="阈值条件" min-width="150">
            <template #default="{ row }">
              <span v-if="row.thresholdValue">低于 {{ row.thresholdValue }} 分</span>
              <span v-if="row.thresholdCount">达到 {{ row.thresholdCount }} 次</span>
            </template>
          </el-table-column>
          <el-table-column prop="description" label="描述" min-width="200" show-overflow-tooltip />
          <el-table-column label="状态" width="80">
            <template #default="{ row }">
              <el-switch v-model="row.status" :active-value="1" :inactive-value="0" @change="toggleRuleStatus(row)" />
            </template>
          </el-table-column>
          <el-table-column label="操作" width="150" fixed="right">
            <template #default="{ row }">
              <el-button type="primary" size="small" @click="showRuleDialog(row)">编辑</el-button>
              <el-button type="danger" size="small" @click="deleteRule(row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </template>
    </el-card>

    <!-- 处理预警对话框 -->
    <el-dialog v-model="handleDialogVisible" title="处理预警" width="500px">
      <el-form :model="handleForm" label-width="80px">
        <el-form-item label="处理方式">
          <el-radio-group v-model="handleForm.status">
            <el-radio-button value="RESOLVED">已解决</el-radio-button>
            <el-radio-button value="PROCESSING">处理中</el-radio-button>
            <el-radio-button value="IGNORED">忽略</el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="处理备注">
          <el-input v-model="handleForm.handleRemark" type="textarea" rows="4" placeholder="请输入处理备注..." />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="handleDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="confirmHandle" :loading="handling">确认</el-button>
      </template>
    </el-dialog>

    <!-- 规则编辑对话框 -->
    <el-dialog v-model="ruleDialogVisible" :title="ruleForm.id ? '编辑规则' : '添加规则'" width="500px">
      <el-form :model="ruleForm" label-width="100px" :rules="ruleRules" ref="ruleFormRef">
        <el-form-item label="规则名称" prop="ruleName">
          <el-input v-model="ruleForm.ruleName" placeholder="请输入规则名称" />
        </el-form-item>
        <el-form-item label="规则类型" prop="ruleType">
          <el-select v-model="ruleForm.ruleType" placeholder="请选择规则类型" style="width: 100%">
            <el-option label="成绩预警" value="SCORE" />
            <el-option label="考勤预警" value="ATTENDANCE" />
            <el-option label="综合预警" value="COMPREHENSIVE" />
          </el-select>
        </el-form-item>
        <el-form-item label="预警等级" prop="warningLevel">
          <el-select v-model="ruleForm.warningLevel" placeholder="请选择预警等级" style="width: 100%">
            <el-option label="黄色预警" value="YELLOW" />
            <el-option label="橙色预警" value="ORANGE" />
            <el-option label="红色预警" value="RED" />
          </el-select>
        </el-form-item>
        <el-form-item label="成绩阈值" v-if="ruleForm.ruleType === 'SCORE' || ruleForm.ruleType === 'COMPREHENSIVE'">
          <el-input-number v-model="ruleForm.thresholdValue" :min="0" :max="100" style="width: 100%" />
        </el-form-item>
        <el-form-item label="次数阈值" v-if="ruleForm.ruleType === 'ATTENDANCE' || ruleForm.ruleType === 'COMPREHENSIVE'">
          <el-input-number v-model="ruleForm.thresholdCount" :min="1" :max="100" style="width: 100%" />
        </el-form-item>
        <el-form-item label="规则描述">
          <el-input v-model="ruleForm.description" type="textarea" rows="3" placeholder="请输入规则描述" />
        </el-form-item>
        <el-form-item label="启用状态">
          <el-switch v-model="ruleForm.status" :active-value="1" :inactive-value="0" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="ruleDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveRule" :loading="saving">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Warning, InfoFilled, WarningFilled, CircleCloseFilled, Refresh, Plus, Search } from '@element-plus/icons-vue'
import {
  getStudentWarnings,
  getWarningStatistics,
  checkWarnings as apiCheckWarnings,
  handleWarning as apiHandleWarning,
  deleteStudentWarning as apiDeleteWarning,
  getWarningRules,
  addWarningRule,
  updateWarningRule,
  deleteWarningRule
} from '../api/warning'

const activeTab = ref('warnings')
const loading = ref(false)
const ruleLoading = ref(false)
const checking = ref(false)
const handling = ref(false)
const saving = ref(false)

const statistics = reactive({
  totalPending: 0,
  yellowCount: 0,
  orangeCount: 0,
  redCount: 0
})

const filterForm = reactive({
  status: '',
  warningLevel: '',
  warningType: ''
})

const warningList = ref([])
const ruleList = ref([])

const handleDialogVisible = ref(false)
const handleForm = reactive({
  id: null,
  status: 'RESOLVED',
  handleRemark: ''
})

const ruleDialogVisible = ref(false)
const ruleFormRef = ref()
const ruleForm = reactive({
  id: null,
  ruleName: '',
  ruleType: 'SCORE',
  warningLevel: 'YELLOW',
  thresholdValue: 60,
  thresholdCount: null,
  description: '',
  status: 1
})

const ruleRules = {
  ruleName: [{ required: true, message: '请输入规则名称', trigger: 'blur' }],
  ruleType: [{ required: true, message: '请选择规则类型', trigger: 'change' }],
  warningLevel: [{ required: true, message: '请选择预警等级', trigger: 'change' }]
}

const getLevelType = (level) => {
  const map = { YELLOW: 'warning', ORANGE: 'danger', RED: 'danger' }
  return map[level] || 'info'
}

const getLevelText = (level) => {
  const map = { YELLOW: '黄色', ORANGE: '橙色', RED: '红色' }
  return map[level] || level
}

const getTypeType = (type) => {
  const map = { SCORE: 'primary', ATTENDANCE: 'warning', COMPREHENSIVE: 'danger' }
  return map[type] || 'info'
}

const getTypeText = (type) => {
  const map = { SCORE: '成绩', ATTENDANCE: '考勤', COMPREHENSIVE: '综合' }
  return map[type] || type
}

const getStatusType = (status) => {
  const map = { PENDING: 'danger', PROCESSING: 'warning', RESOLVED: 'success', IGNORED: 'info' }
  return map[status] || 'info'
}

const getStatusText = (status) => {
  const map = { PENDING: '待处理', PROCESSING: '处理中', RESOLVED: '已解决', IGNORED: '已忽略' }
  return map[status] || status
}

const formatDate = (date) => {
  if (!date) return ''
  return new Date(date).toLocaleString('zh-CN')
}

const loadStatistics = async () => {
  try {
    const res = await getWarningStatistics()
    if (res.code === 200) {
      Object.assign(statistics, res.data)
    }
  } catch (error) {
    console.error('加载统计数据失败:', error)
  }
}

const loadWarnings = async () => {
  loading.value = true
  try {
    const res = await getStudentWarnings(filterForm)
    if (res.code === 200) {
      warningList.value = res.data || []
    }
  } catch (error) {
    ElMessage.error('加载预警列表失败')
  } finally {
    loading.value = false
  }
}

const loadRules = async () => {
  ruleLoading.value = true
  try {
    const res = await getWarningRules()
    if (res.code === 200) {
      ruleList.value = res.data || []
    }
  } catch (error) {
    ElMessage.error('加载规则列表失败')
  } finally {
    ruleLoading.value = false
  }
}

const resetFilter = () => {
  filterForm.status = ''
  filterForm.warningLevel = ''
  filterForm.warningType = ''
  loadWarnings()
}

const checkWarnings = async () => {
  checking.value = true
  try {
    await apiCheckWarnings()
    ElMessage.success('预警扫描完成')
    loadWarnings()
    loadStatistics()
  } catch (error) {
    ElMessage.error('预警扫描失败')
  } finally {
    checking.value = false
  }
}

const handleWarning = (row) => {
  handleForm.id = row.id
  handleForm.status = 'RESOLVED'
  handleForm.handleRemark = ''
  handleDialogVisible.value = true
}

const confirmHandle = async () => {
  handling.value = true
  try {
    const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
    await apiHandleWarning(handleForm.id, {
      status: handleForm.status,
      handlerId: userInfo.id,
      handleRemark: handleForm.handleRemark
    })
    ElMessage.success('处理成功')
    handleDialogVisible.value = false
    loadWarnings()
    loadStatistics()
  } catch (error) {
    ElMessage.error('处理失败')
  } finally {
    handling.value = false
  }
}

const deleteWarning = (row) => {
  ElMessageBox.confirm('确定删除该预警记录吗？', '提示', {
    type: 'warning'
  }).then(async () => {
    try {
      await apiDeleteWarning(row.id)
      ElMessage.success('删除成功')
      loadWarnings()
      loadStatistics()
    } catch (error) {
      ElMessage.error('删除失败')
    }
  })
}

const showRuleDialog = (row = null) => {
  if (row) {
    Object.assign(ruleForm, row)
  } else {
    ruleForm.id = null
    ruleForm.ruleName = ''
    ruleForm.ruleType = 'SCORE'
    ruleForm.warningLevel = 'YELLOW'
    ruleForm.thresholdValue = 60
    ruleForm.thresholdCount = null
    ruleForm.description = ''
    ruleForm.status = 1
  }
  ruleDialogVisible.value = true
}

const saveRule = async () => {
  const valid = await ruleFormRef.value.validate().catch(() => false)
  if (!valid) return

  saving.value = true
  try {
    if (ruleForm.id) {
      await updateWarningRule(ruleForm.id, ruleForm)
    } else {
      await addWarningRule(ruleForm)
    }
    ElMessage.success('保存成功')
    ruleDialogVisible.value = false
    loadRules()
  } catch (error) {
    ElMessage.error('保存失败')
  } finally {
    saving.value = false
  }
}

const toggleRuleStatus = async (row) => {
  try {
    await updateWarningRule(row.id, row)
    ElMessage.success('状态更新成功')
  } catch (error) {
    row.status = row.status === 1 ? 0 : 1
    ElMessage.error('状态更新失败')
  }
}

const deleteRule = (row) => {
  ElMessageBox.confirm('确定删除该预警规则吗？', '提示', {
    type: 'warning'
  }).then(async () => {
    try {
      await deleteWarningRule(row.id)
      ElMessage.success('删除成功')
      loadRules()
    } catch (error) {
      ElMessage.error('删除失败')
    }
  })
}

onMounted(() => {
  loadStatistics()
  loadWarnings()
  loadRules()
})
</script>

<style scoped>
.warning-management {
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
}

.pending .stat-icon {
  background: linear-gradient(135deg, #0d9488, #14b8a6);
  color: #fff;
}

.yellow .stat-icon {
  background: linear-gradient(135deg, #f59e0b, #fbbf24);
  color: #fff;
}

.orange .stat-icon {
  background: linear-gradient(135deg, #f97316, #fb923c);
  color: #fff;
}

.red .stat-icon {
  background: linear-gradient(135deg, #ef4444, #f87171);
  color: #fff;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 28px;
  font-weight: 700;
  color: #1e293b;
  line-height: 1;
  margin-bottom: 4px;
}

.stat-label {
  font-size: 13px;
  color: #94a3b8;
}

.table-card {
  border-radius: 12px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-right {
  display: flex;
  gap: 10px;
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

.warning-reason {
  color: #1e293b;
  margin-bottom: 4px;
}

.course-name,
.score-value,
.attendance-count {
  font-size: 12px;
  color: #64748b;
}

@media (max-width: 768px) {
  .stats-row .el-col {
    margin-bottom: 12px;
  }

  .filter-bar {
    flex-wrap: wrap;
    gap: 10px;
  }

  .filter-bar .el-select {
    margin-left: 0 !important;
    width: calc(50% - 5px) !important;
  }
}
</style>
