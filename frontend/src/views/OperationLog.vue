<template>
  <div class="operation-log">
    <div class="page-header">
      <h2 class="page-title">操作日志与审计</h2>
      <p class="page-desc">系统操作记录和审计追踪（仅管理员可访问）</p>
    </div>

    <!-- 统计卡片 -->
    <el-row :gutter="20" class="stats-row">
      <el-col :xs="24" :sm="12" :md="8">
        <div class="stat-card total">
          <div class="stat-icon">
            <el-icon size="28"><Document /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ statistics.totalCount || 0 }}</div>
            <div class="stat-label">总记录数</div>
          </div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="12" :md="8">
        <div class="stat-card today">
          <div class="stat-icon">
            <el-icon size="28"><Calendar /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ statistics.todayCount || 0 }}</div>
            <div class="stat-label">今日操作</div>
          </div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="12" :md="8">
        <div class="stat-card failed">
          <div class="stat-icon">
            <el-icon size="28"><CircleClose /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ statistics.failedCount || 0 }}</div>
            <div class="stat-label">失败操作</div>
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- 提示信息 -->
    <el-alert
      v-if="!isAdmin"
      title="权限不足"
      type="error"
      description="操作日志仅管理员可查看"
      show-icon
      :closable="false"
      style="margin-bottom: 20px"
    />

    <!-- 日志列表 -->
    <el-card class="table-card" v-loading="loading">
      <template #header>
        <div class="card-header">
          <span>操作日志列表</span>
          <el-button v-if="isAdmin" type="danger" size="small" @click="showCleanupDialog">
            <el-icon><Delete /></el-icon>
            清理旧日志
          </el-button>
        </div>
      </template>

      <el-table :data="logList" stripe>
        <el-table-column type="index" width="50" />
        <el-table-column label="操作人员" min-width="120">
          <template #default="{ row }">
            <div class="user-info">
              <div class="username">{{ row.realName || row.username }}</div>
              <div class="user-id" v-if="row.username !== row.realName">{{ row.username }}</div>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="操作类型" width="100">
          <template #default="{ row }">
            <el-tag :type="getTypeType(row.operationType)" size="small">
              {{ getTypeText(row.operationType) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作模块" width="100">
          <template #default="{ row }">
            {{ getModuleText(row.operationModule) }}
          </template>
        </el-table-column>
        <el-table-column prop="operationDesc" label="操作描述" min-width="150" show-overflow-tooltip />
        <el-table-column label="请求信息" min-width="200">
          <template #default="{ row }">
            <div class="request-info">
              <el-tag size="small" :type="getMethodType(row.requestMethod)">{{ row.requestMethod }}</el-tag>
              <span class="request-url" :title="row.requestUrl">{{ row.requestUrl }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="执行时长" width="100">
          <template #default="{ row }">
            <span :class="getTimeClass(row.executionTime)">{{ row.executionTime }}ms</span>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="80">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'danger'" size="small">
              {{ row.status === 1 ? '成功' : '失败' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作时间" width="160">
          <template #default="{ row }">
            {{ formatDate(row.createTime) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="100" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="viewDetail(row)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination-container">
        <el-pagination
          v-model:current-page="pageNum"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>

    <!-- 日志详情对话框 -->
    <el-dialog v-model="detailDialogVisible" title="日志详情" width="700px">
      <el-descriptions :column="2" border v-if="currentLog">
        <el-descriptions-item label="日志ID">{{ currentLog.id }}</el-descriptions-item>
        <el-descriptions-item label="操作用户">{{ currentLog.realName }} ({{ currentLog.username }})</el-descriptions-item>
        <el-descriptions-item label="操作类型">
          <el-tag :type="getTypeType(currentLog.operationType)" size="small">
            {{ getTypeText(currentLog.operationType) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="操作模块">{{ getModuleText(currentLog.operationModule) }}</el-descriptions-item>
        <el-descriptions-item label="操作描述" :span="2">{{ currentLog.operationDesc }}</el-descriptions-item>
        <el-descriptions-item label="请求方法">
          <el-tag size="small" :type="getMethodType(currentLog.requestMethod)">{{ currentLog.requestMethod }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="请求URL" :span="1">{{ currentLog.requestUrl }}</el-descriptions-item>
        <el-descriptions-item label="IP地址">{{ currentLog.ipAddress }}</el-descriptions-item>
        <el-descriptions-item label="执行时长">
          <span :class="getTimeClass(currentLog.executionTime)">{{ currentLog.executionTime }}ms</span>
        </el-descriptions-item>
        <el-descriptions-item label="操作状态">
          <el-tag :type="currentLog.status === 1 ? 'success' : 'danger'">
            {{ currentLog.status === 1 ? '成功' : '失败' }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="操作时间" :span="2">{{ formatDate(currentLog.createTime) }}</el-descriptions-item>
        <el-descriptions-item label="请求参数" :span="2">
          <pre class="json-content">{{ formatJson(currentLog.requestParams) }}</pre>
        </el-descriptions-item>
        <el-descriptions-item label="响应数据" :span="2" v-if="currentLog.responseData">
          <pre class="json-content">{{ formatJson(currentLog.responseData) }}</pre>
        </el-descriptions-item>
        <el-descriptions-item label="错误信息" :span="2" v-if="currentLog.errorMsg">
          <div class="error-msg">{{ currentLog.errorMsg }}</div>
        </el-descriptions-item>
      </el-descriptions>
    </el-dialog>

    <!-- 清理日志对话框 -->
    <el-dialog v-model="cleanupDialogVisible" title="清理旧日志" width="400px">
      <el-form :model="cleanupForm" label-width="100px">
        <el-form-item label="保留天数">
          <el-input-number v-model="cleanupForm.days" :min="7" :max="365" style="width: 150px" />
          <span class="form-tip">将删除指定天数之前的日志</span>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="cleanupDialogVisible = false">取消</el-button>
        <el-button type="danger" @click="confirmCleanup" :loading="cleaning">确认清理</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Document, Calendar, CircleClose, Delete } from '@element-plus/icons-vue'
import { getOperationLogs, getLogStatistics, cleanupOldLogs } from '../api/operationLog'

const loading = ref(false)
const cleaning = ref(false)
const logList = ref([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)

const isAdmin = computed(() => {
  const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
  return userInfo.role === 'admin'
})

const statistics = reactive({
  totalCount: 0,
  todayCount: 0,
  failedCount: 0
})

const detailDialogVisible = ref(false)
const currentLog = ref(null)

const cleanupDialogVisible = ref(false)
const cleanupForm = reactive({
  days: 30
})

const getTypeType = (type) => {
  const map = { INSERT: 'success', UPDATE: 'warning', DELETE: 'danger', QUERY: 'info', EXPORT: 'primary' }
  return map[type] || 'info'
}

const getTypeText = (type) => {
  const map = { INSERT: '新增', UPDATE: '修改', DELETE: '删除', QUERY: '查询', EXPORT: '导出', LOGIN: '登录', LOGOUT: '登出' }
  return map[type] || type
}

const getModuleText = (module) => {
  const map = {
    STUDENT: '学生管理',
    COURSE: '课程管理',
    SCORE: '成绩管理',
    CLASS: '班级管理',
    USER: '用户管理',
    ATTENDANCE: '考勤管理',
    WARNING: '预警管理',
    EXPORT: '数据导出',
    SYSTEM: '系统管理',
    AUTH: '认证授权'
  }
  return map[module] || module
}

const getMethodType = (method) => {
  const map = { GET: 'success', POST: 'primary', PUT: 'warning', DELETE: 'danger' }
  return map[method?.toUpperCase()] || 'info'
}

const getTimeClass = (time) => {
  if (time < 100) return 'time-fast'
  if (time < 500) return 'time-normal'
  return 'time-slow'
}

const formatDate = (date) => {
  if (!date) return ''
  return new Date(date).toLocaleString('zh-CN')
}

const formatJson = (json) => {
  if (!json) return ''
  try {
    return JSON.stringify(JSON.parse(json), null, 2)
  } catch {
    return json
  }
}

const loadStatistics = async () => {
  if (!isAdmin.value) return
  try {
    const res = await getLogStatistics()
    if (res.code === 200) {
      Object.assign(statistics, res.data)
    }
  } catch (error) {
    console.error('加载统计数据失败:', error)
  }
}

const loadLogs = async () => {
  if (!isAdmin.value) {
    logList.value = []
    return
  }
  loading.value = true
  try {
    const res = await getOperationLogs({
      pageNum: pageNum.value,
      pageSize: pageSize.value
    })
    if (res.code === 200) {
      logList.value = res.data || []
      total.value = res.total || 0
    }
  } catch (error) {
    console.error('加载日志列表失败:', error)
    ElMessage.error('加载日志列表失败')
  } finally {
    loading.value = false
  }
}

const handleSizeChange = (val) => {
  pageSize.value = val
  loadLogs()
}

const handleCurrentChange = (val) => {
  pageNum.value = val
  loadLogs()
}

const viewDetail = (row) => {
  currentLog.value = row
  detailDialogVisible.value = true
}

const showCleanupDialog = () => {
  cleanupForm.days = 30
  cleanupDialogVisible.value = true
}

const confirmCleanup = () => {
  ElMessageBox.confirm(`确定删除 ${cleanupForm.days} 天前的日志记录吗？此操作不可恢复！`, '警告', {
    type: 'warning',
    confirmButtonClass: 'el-button--danger'
  }).then(async () => {
    cleaning.value = true
    try {
      await cleanupOldLogs(cleanupForm.days)
      ElMessage.success('清理成功')
      cleanupDialogVisible.value = false
      loadLogs()
      loadStatistics()
    } catch (error) {
      ElMessage.error('清理失败')
    } finally {
      cleaning.value = false
    }
  })
}

onMounted(() => {
  loadStatistics()
  loadLogs()
})
</script>

<style scoped>
.operation-log {
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
  color: #fff;
}

.total .stat-icon {
  background: linear-gradient(135deg, #0d9488, #14b8a6);
}

.today .stat-icon {
  background: linear-gradient(135deg, #10b981, #34d399);
}

.failed .stat-icon {
  background: linear-gradient(135deg, #ef4444, #f87171);
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

.user-info {
  line-height: 1.5;
}

.username {
  font-weight: 600;
  color: #1e293b;
}

.user-id {
  font-size: 12px;
  color: #94a3b8;
}

.request-info {
  display: flex;
  align-items: center;
  gap: 8px;
}

.request-url {
  color: #64748b;
  font-size: 12px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  max-width: 150px;
}

.time-fast {
  color: #10b981;
}

.time-normal {
  color: #f59e0b;
}

.time-slow {
  color: #ef4444;
}

.json-content {
  background: #f8fafc;
  padding: 12px;
  border-radius: 6px;
  font-size: 12px;
  max-height: 200px;
  overflow-y: auto;
  white-space: pre-wrap;
  word-break: break-all;
  margin: 0;
}

.error-msg {
  color: #ef4444;
  font-size: 12px;
  background: #fef2f2;
  padding: 8px;
  border-radius: 4px;
}

.form-tip {
  margin-left: 10px;
  color: #94a3b8;
  font-size: 12px;
}

.pagination-container {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

@media (max-width: 768px) {
  .stats-row .el-col {
    margin-bottom: 12px;
  }
}
</style>
