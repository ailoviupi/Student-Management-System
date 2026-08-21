<template>
  <div class="notification-center">
    <div class="page-header">
      <h2 class="page-title">消息通知中心</h2>
      <p class="page-desc">系统公告和消息管理</p>
    </div>

    <el-row :gutter="20">
      <!-- 左侧通知列表 -->
      <el-col :xs="24" :sm="24" :md="16">
        <el-card class="notification-list">
          <template #header>
            <div class="list-header">
              <div class="header-tabs">
                <el-radio-group v-model="activeTab" size="small">
                  <el-radio-button value="all">
                    全部消息
                    <el-badge v-if="unreadCount > 0" :value="unreadCount" class="tab-badge" />
                  </el-radio-button>
                  <el-radio-button value="unread">未读消息</el-radio-button>
                  <el-radio-button value="read">已读消息</el-radio-button>
                </el-radio-group>
              </div>
              <div class="header-actions">
                <el-button type="primary" size="small" @click="showSendDialog" v-if="isAdmin">
                  <el-icon><Plus /></el-icon>
                  发送通知
                </el-button>
                <el-button size="small" @click="markAllRead" :disabled="unreadCount === 0">
                  全部已读
                </el-button>
              </div>
            </div>
          </template>

          <div class="notification-items" v-loading="loading">
            <div v-for="item in filteredNotifications" :key="item.id" 
                 class="notification-item" :class="{ unread: !item.isRead }"
                 @click="viewDetail(item)">
              <div class="item-icon" :class="item.type?.toLowerCase()">
                <el-icon size="20">
                  <component :is="getIcon(item.type)" />
                </el-icon>
              </div>
              <div class="item-content">
                <div class="item-header">
                  <span class="item-title">{{ item.title }}</span>
                  <el-tag :type="getPriorityType(item.priority)" size="small" v-if="item.priority > 1">
                    {{ getPriorityText(item.priority) }}
                  </el-tag>
                </div>
                <div class="item-desc">{{ item.content }}</div>
                <div class="item-meta">
                  <span class="sender">{{ item.senderName }}</span>
                  <span class="time">{{ formatTime(item.publishTime || item.createTime) }}</span>
                </div>
              </div>
              <div class="item-actions">
                <el-button v-if="!item.isRead" type="primary" link size="small" @click.stop="markRead(item)">
                  标记已读
                </el-button>
                <el-button v-if="isAdmin" type="danger" link size="small" @click.stop="deleteNotify(item)">
                  删除
                </el-button>
              </div>
            </div>
            <el-empty v-if="filteredNotifications.length === 0" description="暂无消息" />
          </div>
        </el-card>
      </el-col>

      <!-- 右侧统计 -->
      <el-col :xs="24" :sm="24" :md="8">
        <el-card class="stats-card">
          <template #header>
            <span>消息统计</span>
          </template>
          <div class="stats-content">
            <div class="stat-item">
              <div class="stat-label">未读消息</div>
              <div class="stat-value">{{ unreadCount }}</div>
            </div>
            <div class="stat-item">
              <div class="stat-label">系统公告</div>
              <div class="stat-value">{{ systemCount }}</div>
            </div>
            <div class="stat-item">
              <div class="stat-label">成绩通知</div>
              <div class="stat-value">{{ scoreCount }}</div>
            </div>
            <div class="stat-item">
              <div class="stat-label">考勤通知</div>
              <div class="stat-value">{{ attendanceCount }}</div>
            </div>
          </div>
        </el-card>

        <el-card class="type-card" style="margin-top: 20px">
          <template #header>
            <span>消息类型</span>
          </template>
          <div class="type-list">
            <div class="type-item">
              <el-icon color="#0d9488"><Bell /></el-icon>
              <span>系统公告</span>
            </div>
            <div class="type-item">
              <el-icon color="#f59e0b"><Trophy /></el-icon>
              <span>成绩通知</span>
            </div>
            <div class="type-item">
              <el-icon color="#10b981"><Calendar /></el-icon>
              <span>考勤通知</span>
            </div>
            <div class="type-item">
              <el-icon color="#ef4444"><Warning /></el-icon>
              <span>预警通知</span>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 发送通知对话框 -->
    <el-dialog v-model="sendDialogVisible" title="发送通知" width="600px">
      <el-form :model="sendForm" label-width="100px" :rules="sendRules" ref="sendFormRef">
        <el-form-item label="通知标题" prop="title">
          <el-input v-model="sendForm.title" placeholder="请输入通知标题" />
        </el-form-item>
        <el-form-item label="通知内容" prop="content">
          <el-input v-model="sendForm.content" type="textarea" rows="4" placeholder="请输入通知内容" />
        </el-form-item>
        <el-form-item label="消息类型" prop="type">
          <el-select v-model="sendForm.type" placeholder="选择类型" style="width: 100%">
            <el-option label="系统公告" value="SYSTEM" />
            <el-option label="成绩通知" value="SCORE" />
            <el-option label="考勤通知" value="ATTENDANCE" />
            <el-option label="预警通知" value="WARNING" />
          </el-select>
        </el-form-item>
        <el-form-item label="发送对象" prop="targetType">
          <el-select v-model="sendForm.targetType" placeholder="选择发送对象" style="width: 100%">
            <el-option label="全部用户" value="ALL" />
            <el-option label="指定角色" value="ROLE" />
            <el-option label="指定班级" value="CLASS" />
            <el-option label="指定用户" value="USER" />
          </el-select>
        </el-form-item>
        <el-form-item label="优先级">
          <el-radio-group v-model="sendForm.priority">
            <el-radio-button :value="0">低</el-radio-button>
            <el-radio-button :value="1">普通</el-radio-button>
            <el-radio-button :value="2">高</el-radio-button>
            <el-radio-button :value="3">紧急</el-radio-button>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="sendDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="sendNotification" :loading="sending">发送</el-button>
      </template>
    </el-dialog>

    <!-- 消息详情对话框 -->
    <el-dialog v-model="detailDialogVisible" title="消息详情" width="500px">
      <div v-if="currentNotification" class="detail-content">
        <h3 class="detail-title">{{ currentNotification.title }}</h3>
        <div class="detail-meta">
          <span>发送人: {{ currentNotification.senderName }}</span>
          <span>时间: {{ formatTime(currentNotification.publishTime || currentNotification.createTime) }}</span>
        </div>
        <div class="detail-body">{{ currentNotification.content }}</div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Bell, Trophy, Calendar, Warning } from '@element-plus/icons-vue'
import {
  getUserNotifications,
  getUnreadCount,
  markAsRead,
  markAllAsRead,
  createNotification,
  deleteNotification
} from '../api/notification'

const loading = ref(false)
const sending = ref(false)
const activeTab = ref('all')
const notifications = ref([])
const unreadCount = ref(0)

const isAdmin = computed(() => {
  const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
  return userInfo.role === 'admin'
})

const filteredNotifications = computed(() => {
  if (activeTab.value === 'unread') {
    return notifications.value.filter(n => !n.isRead)
  } else if (activeTab.value === 'read') {
    return notifications.value.filter(n => n.isRead)
  }
  return notifications.value
})

const systemCount = computed(() => notifications.value.filter(n => n.type === 'SYSTEM').length)
const scoreCount = computed(() => notifications.value.filter(n => n.type === 'SCORE').length)
const attendanceCount = computed(() => notifications.value.filter(n => n.type === 'ATTENDANCE').length)

const sendDialogVisible = ref(false)
const sendFormRef = ref()
const sendForm = reactive({
  title: '',
  content: '',
  type: 'SYSTEM',
  targetType: 'ALL',
  priority: 1
})

const sendRules = {
  title: [{ required: true, message: '请输入标题', trigger: 'blur' }],
  content: [{ required: true, message: '请输入内容', trigger: 'blur' }],
  type: [{ required: true, message: '请选择类型', trigger: 'change' }],
  targetType: [{ required: true, message: '请选择发送对象', trigger: 'change' }]
}

const detailDialogVisible = ref(false)
const currentNotification = ref(null)

const getIcon = (type) => {
  const map = { SYSTEM: 'Bell', SCORE: 'Trophy', ATTENDANCE: 'Calendar', WARNING: 'Warning' }
  return map[type] || 'Bell'
}

const getPriorityType = (priority) => {
  const map = { 0: 'info', 1: '', 2: 'warning', 3: 'danger' }
  return map[priority] || ''
}

const getPriorityText = (priority) => {
  const map = { 0: '低', 1: '普通', 2: '高', 3: '紧急' }
  return map[priority] || '普通'
}

const formatTime = (time) => {
  if (!time) return ''
  return new Date(time).toLocaleString('zh-CN')
}

const loadNotifications = async () => {
  loading.value = true
  try {
    const res = await getUserNotifications()
    if (res.code === 200) {
      notifications.value = res.data || []
    }
  } catch (error) {
    console.error('加载通知失败:', error)
  } finally {
    loading.value = false
  }
}

const loadUnreadCount = async () => {
  try {
    const res = await getUnreadCount()
    if (res.code === 200) {
      unreadCount.value = res.data || 0
    }
  } catch (error) {
    console.error('加载未读数失败:', error)
  }
}

const showSendDialog = () => {
  sendForm.title = ''
  sendForm.content = ''
  sendForm.type = 'SYSTEM'
  sendForm.targetType = 'ALL'
  sendForm.priority = 1
  sendDialogVisible.value = true
}

const sendNotification = async () => {
  const valid = await sendFormRef.value.validate().catch(() => false)
  if (!valid) return

  sending.value = true
  try {
    await createNotification(sendForm)
    ElMessage.success('发送成功')
    sendDialogVisible.value = false
    loadNotifications()
  } catch (error) {
    ElMessage.error('发送失败')
  } finally {
    sending.value = false
  }
}

const viewDetail = (item) => {
  currentNotification.value = item
  detailDialogVisible.value = true
  if (!item.isRead) {
    markRead(item)
  }
}

const markRead = async (item) => {
  try {
    await markAsRead(item.id)
    item.isRead = true
    loadUnreadCount()
  } catch (error) {
    console.error('标记已读失败:', error)
  }
}

const markAllRead = async () => {
  try {
    await markAllAsRead()
    ElMessage.success('已全部标记为已读')
    notifications.value.forEach(n => n.isRead = true)
    unreadCount.value = 0
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

const deleteNotify = (item) => {
  ElMessageBox.confirm('确定删除该通知吗？', '提示', { type: 'warning' })
    .then(async () => {
      try {
        await deleteNotification(item.id)
        ElMessage.success('删除成功')
        loadNotifications()
      } catch (error) {
        ElMessage.error('删除失败')
      }
    })
}

onMounted(() => {
  loadNotifications()
  loadUnreadCount()
})
</script>

<style scoped>
.notification-center {
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

.list-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 12px;
}

.header-actions {
  display: flex;
  gap: 10px;
}

.tab-badge {
  margin-left: 4px;
}

.notification-items {
  min-height: 400px;
}

.notification-item {
  display: flex;
  align-items: flex-start;
  gap: 16px;
  padding: 16px;
  border-bottom: 1px solid #f1f5f9;
  cursor: pointer;
  transition: background 0.2s;
}

.notification-item:hover {
  background: #f8fafc;
}

.notification-item.unread {
  background: #eff6ff;
}

.notification-item.unread:hover {
  background: #dbeafe;
}

.item-icon {
  width: 44px;
  height: 44px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.item-icon.system {
  background: #e0e7ff;
  color: #0d9488;
}

.item-icon.score {
  background: #fef3c7;
  color: #f59e0b;
}

.item-icon.attendance {
  background: #d1fae5;
  color: #10b981;
}

.item-icon.warning {
  background: #fee2e2;
  color: #ef4444;
}

.item-content {
  flex: 1;
  min-width: 0;
}

.item-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 6px;
}

.item-title {
  font-weight: 600;
  color: #1e293b;
}

.notification-item.unread .item-title {
  color: #3b82f6;
}

.item-desc {
  color: #64748b;
  font-size: 13px;
  line-height: 1.5;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  margin-bottom: 8px;
}

.item-meta {
  display: flex;
  gap: 16px;
  font-size: 12px;
  color: #94a3b8;
}

.item-actions {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.stats-content {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
}

.stat-item {
  text-align: center;
  padding: 16px;
  background: #f8fafc;
  border-radius: 8px;
}

.stat-label {
  font-size: 12px;
  color: #64748b;
  margin-bottom: 4px;
}

.stat-value {
  font-size: 24px;
  font-weight: 700;
  color: #1e293b;
}

.type-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.type-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px;
  background: #f8fafc;
  border-radius: 8px;
}

.detail-content {
  padding: 10px;
}

.detail-title {
  font-size: 18px;
  font-weight: 600;
  color: #1e293b;
  margin: 0 0 12px 0;
}

.detail-meta {
  display: flex;
  flex-direction: column;
  gap: 4px;
  font-size: 13px;
  color: #64748b;
  margin-bottom: 16px;
  padding-bottom: 16px;
  border-bottom: 1px solid #e2e8f0;
}

.detail-body {
  color: #334155;
  line-height: 1.8;
  white-space: pre-wrap;
}

@media (max-width: 768px) {
  .list-header {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>
