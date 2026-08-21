<template>
  <div class="chat-container">
    <div class="chat-sidebar">
      <div class="sidebar-header">
        <h3 class="sidebar-title">消息中心</h3>
        <div class="header-actions">
          <el-button size="small" @click="showNewChatDialog = true">
            <el-icon><Plus /></el-icon>
            发起对话
          </el-button>
        </div>
      </div>
      
      <div class="search-box">
        <el-input 
          v-model="searchKeyword" 
          placeholder="搜索联系人..." 
          size="small"
          prefix-icon="Search"
        />
      </div>

      <div class="conversation-list">
        <div 
          v-for="conv in filteredConversations" 
          :key="conv.targetId"
          class="conversation-item"
          :class="{ active: currentTargetId === conv.targetId }"
          @click="selectConversation(conv)"
        >
          <div class="conv-avatar">
            {{ conv.targetAvatar || '?' }}
          </div>
          <div class="conv-info">
            <div class="conv-name">{{ conv.targetName }}</div>
            <div class="conv-preview">{{ conv.lastContent }}</div>
          </div>
          <div class="conv-meta">
            <div class="conv-time">{{ formatTime(conv.lastTime) }}</div>
            <div v-if="conv.unreadCount > 0" class="unread-badge">
              {{ conv.unreadCount }}
            </div>
          </div>
        </div>
        
        <div v-if="filteredConversations.length === 0" class="empty-state">
          <el-icon size="48" color="#94a3b8"><Message /></el-icon>
          <p>暂无消息</p>
          <p class="empty-hint">点击上方"发起对话"开始聊天</p>
        </div>
      </div>
    </div>

    <div class="chat-main">
      <div v-if="currentConversation" class="chat-content">
        <div class="chat-header">
          <div class="chat-title">
            <div class="chat-avatar">{{ currentConversation.targetAvatar || '?' }}</div>
            <div class="chat-info">
              <div class="chat-name">{{ currentConversation.targetName }}</div>
              <div class="chat-subtitle">
                {{ currentConversation.targetRole === 'teacher' ? '教师' : '学生' }}
                <span v-if="currentConversation.studentNo"> | {{ currentConversation.studentNo }}</span>
                <span v-if="currentConversation.className"> | {{ currentConversation.className }}</span>
              </div>
            </div>
          </div>
          <div class="chat-actions">
            <el-button size="small" @click="refreshMessages">
              <el-icon><Refresh /></el-icon>
            </el-button>
          </div>
        </div>

        <div ref="messageList" class="message-list">
          <div 
            v-for="msg in messages" 
            :key="msg.id"
            class="message-item"
            :class="{ 'message-mine': msg.isMine }"
          >
            <div class="message-avatar">{{ msg.senderAvatar || '?' }}</div>
            <div class="message-content">
              <div class="message-bubble">
                {{ msg.content }}
              </div>
              <div class="message-time">{{ formatTime(msg.sendTime) }}</div>
            </div>
          </div>
          
          <div v-if="messages.length === 0" class="no-messages">
            <el-icon size="32" color="#cbd5e1"><ChatDotSquare /></el-icon>
            <p>还没有消息，开始对话吧</p>
          </div>
        </div>

        <div class="chat-input-area">
          <el-input 
            v-model="messageInput" 
            placeholder="输入消息..."
            size="large"
            @keyup.enter="sendMessage"
            :disabled="!currentTargetId"
          />
          <el-button type="primary" size="large" @click="sendMessage" :disabled="!messageInput.trim() || !currentTargetId">
            <el-icon><ChatRound /></el-icon>
            发送
          </el-button>
        </div>
      </div>

      <div v-else class="chat-empty">
        <el-icon size="64" color="#94a3b8"><Message /></el-icon>
        <p>选择一个联系人开始聊天</p>
        <el-button type="primary" size="medium" @click="showNewChatDialog = true">
          <el-icon><Plus /></el-icon>
          发起对话
        </el-button>
      </div>
    </div>

    <el-dialog v-model="showNewChatDialog" title="发起新对话" width="500px">
      <div class="new-chat-dialog">
        <el-input 
          v-model="newChatKeyword" 
          placeholder="搜索姓名或学号..." 
          size="small"
          prefix-icon="Search"
          @input="searchContacts"
        />
        <div class="contact-list">
          <div 
            v-for="contact in availableContacts" 
            :key="contact.id"
            class="contact-item"
            @click="startNewChat(contact)"
          >
            <div class="contact-avatar">{{ contact.avatar || '?' }}</div>
            <div class="contact-info">
              <div class="contact-name">{{ contact.name }}</div>
              <div class="contact-subtitle">
                {{ role === 'teacher' ? '学生' : '教师' }}
                <span v-if="contact.studentNo"> | {{ contact.studentNo }}</span>
                <span v-if="contact.className"> | {{ contact.className }}</span>
              </div>
            </div>
            <el-icon class="contact-arrow"><ArrowRight /></el-icon>
          </div>
          <div v-if="availableContacts.length === 0" class="no-contacts">
            <el-icon size="32" color="#94a3b8"><User /></el-icon>
            <p>未找到匹配的联系人</p>
          </div>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, nextTick, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { Message, Refresh, ChatDotSquare, ChatRound, Plus, ArrowRight, User } from '@element-plus/icons-vue'
import { getConversations, getMessages, getAvailableStudents, getAvailableTeachers } from '../api/chat'

const searchKeyword = ref('')
const conversations = ref([])
const messages = ref([])
const currentTargetId = ref(null)
const currentConversation = ref(null)
const messageInput = ref('')
const messageList = ref(null)
const showNewChatDialog = ref(false)
const newChatKeyword = ref('')
const availableContacts = ref([])

let ws = null

const filteredConversations = computed(() => {
  if (!searchKeyword.value) return conversations.value
  const keyword = searchKeyword.value.toLowerCase()
  return conversations.value.filter(conv => 
    conv.targetName.toLowerCase().includes(keyword) ||
    (conv.studentNo && conv.studentNo.includes(keyword)) ||
    (conv.className && conv.className.toLowerCase().includes(keyword))
  )
})

const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
const role = userInfo.role || ''

// 构造 WebSocket 地址：
//  - 配置了 VITE_API_BASE_URL（独立部署）时，从它推导后端主机名，协议自动用 wss
//  - 未配置（本地开发走 vite 代理）时，沿用当前页面同源地址
const buildWsUrl = (token) => {
  const apiBase = import.meta.env.VITE_API_BASE_URL || ''
  try {
    if (apiBase) {
      const url = new URL(apiBase)
      const protocol = url.protocol === 'https:' ? 'wss:' : 'ws:'
      return `${protocol}//${url.host}/ws/chat?token=${token}`
    }
  } catch (e) {
    console.warn('VITE_API_BASE_URL 无效，回退到同源 WebSocket 地址:', e)
  }
  const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:'
  return `${protocol}//${window.location.host}/ws/chat?token=${token}`
}

const connectWebSocket = () => {
  const token = localStorage.getItem('token')
  if (!token) {
    console.warn('No token found, cannot connect WebSocket')
    return
  }
  
  // 后端独立部署时（前端静态托管 + 后端 Render/云主机），WebSocket 必须连后端域名
  // 而不是前端域名：从 VITE_API_BASE_URL 推导主机名，并自动使用 wss
  const wsUrl = buildWsUrl(token)
  
  ws = new WebSocket(wsUrl)
  
  ws.onopen = () => {
    console.log('WebSocket connected')
    ElMessage.success('实时通信已连接')
  }
  
  ws.onmessage = (event) => {
    try {
      const msg = JSON.parse(event.data)
      
      if (msg.type === 'statistics') {
        handleStatisticsMessage(msg)
        return
      }
      
      if (msg.senderId && msg.content) {
        messages.value.push({
          id: msg.id,
          senderId: msg.senderId,
          senderRole: msg.senderRole,
          senderName: msg.senderName,
          senderAvatar: msg.senderName?.charAt(0) || '?',
          receiverId: msg.receiverId,
          content: msg.content,
          sendTime: msg.sendTime,
          readStatus: msg.readStatus,
          isMine: false
        })
        scrollToBottom()
        loadConversations()
      }
    } catch (e) {
      console.error('Failed to parse WebSocket message:', e)
    }
  }
  
  ws.onclose = (event) => {
    console.log('WebSocket disconnected:', event.code, event.reason)
    if (event.code !== 1000) {
      ElMessage.warning('连接已断开，正在重新连接...')
      setTimeout(connectWebSocket, 3000)
    }
  }
  
  ws.onerror = (error) => {
    console.error('WebSocket error:', error)
    ElMessage.error('连接出错，请检查网络')
  }
}

const handleStatisticsMessage = (msg) => {
  console.log('Received statistics update:', msg)
}

const loadConversations = async () => {
  try {
    const res = await getConversations()
    if (res.code === 200) {
      conversations.value = res.data
    }
  } catch (e) {
    console.error('Failed to load conversations:', e)
  }
}

const searchContacts = async () => {
  try {
    let res
    if (role === 'teacher') {
      res = await getAvailableStudents(newChatKeyword.value)
    } else {
      res = await getAvailableTeachers()
    }
    if (res.code === 200) {
      availableContacts.value = res.data
    }
  } catch (e) {
    console.error('Failed to search contacts:', e)
  }
}

const showNewChatDialogHandler = () => {
  showNewChatDialog.value = true
  newChatKeyword.value = ''
  searchContacts()
}

watch(showNewChatDialog, (val) => {
  if (val) {
    searchContacts()
  }
})

const startNewChat = (contact) => {
  showNewChatDialog.value = false
  currentTargetId.value = contact.id
  currentConversation.value = {
    targetId: contact.id,
    targetName: contact.name,
    targetAvatar: contact.avatar,
    targetRole: role === 'teacher' ? 'student' : 'teacher',
    studentNo: contact.studentNo,
    className: contact.className
  }
  loadMessages(contact.id)
}

const selectConversation = (conv) => {
  currentTargetId.value = conv.targetId
  currentConversation.value = conv
  loadMessages(conv.targetId)
}

const loadMessages = async (targetId) => {
  try {
    const res = await getMessages(targetId)
    if (res.code === 200) {
      messages.value = res.data
      nextTick(() => scrollToBottom())
    }
  } catch (e) {
    console.error('Failed to load messages:', e)
  }
}

const refreshMessages = () => {
  if (currentTargetId.value) {
    loadMessages(currentTargetId.value)
  }
}

const sendMessage = () => {
  if (!messageInput.value.trim() || !currentTargetId.value) return
  
  if (!ws || ws.readyState !== WebSocket.OPEN) {
    ElMessage.error('连接未建立，请稍后重试')
    return
  }
  
  const msg = {
    receiverId: currentTargetId.value,
    content: messageInput.value.trim()
  }
  
  ws.send(JSON.stringify(msg))
  
  messages.value.push({
    id: Date.now(),
    senderId: userInfo.id || userInfo.studentId,
    senderRole: role,
    senderName: userInfo.realName || userInfo.username,
    senderAvatar: (userInfo.realName || userInfo.username)?.charAt(0) || '?',
    receiverId: currentTargetId.value,
    content: messageInput.value.trim(),
    sendTime: new Date().toISOString(),
    readStatus: 1,
    isMine: true
  })
  
  messageInput.value = ''
  scrollToBottom()
}

const scrollToBottom = () => {
  nextTick(() => {
    if (messageList.value) {
      messageList.value.scrollTop = messageList.value.scrollHeight
    }
  })
}

const formatTime = (time) => {
  if (!time) return ''
  const date = new Date(time)
  const now = new Date()
  const diff = now - date
  
  if (diff < 60000) return '刚刚'
  if (diff < 3600000) return `${Math.floor(diff / 60000)}分钟前`
  if (diff < 86400000) return `${Math.floor(diff / 3600000)}小时前`
  
  const month = date.getMonth() + 1
  const day = date.getDate()
  const hour = date.getHours().toString().padStart(2, '0')
  const minute = date.getMinutes().toString().padStart(2, '0')
  
  return `${month}-${day} ${hour}:${minute}`
}

onMounted(() => {
  loadConversations()
  connectWebSocket()
})
</script>

<style scoped>
.chat-container {
  display: flex;
  height: 100%;
  background: #f8fafc;
  border-radius: 12px;
  overflow: hidden;
}

.chat-sidebar {
  width: 360px;
  background: #fff;
  border-right: 1px solid #e2e8f0;
  display: flex;
  flex-direction: column;
}

.sidebar-header {
  padding: 20px;
  border-bottom: 1px solid #e2e8f0;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.sidebar-title {
  font-size: 18px;
  font-weight: 600;
  color: #1e293b;
  margin: 0;
}

.header-actions {
  display: flex;
  gap: 8px;
}

.search-box {
  padding: 12px 16px;
}

.conversation-list {
  flex: 1;
  overflow-y: auto;
  padding: 8px;
}

.conversation-item {
  display: flex;
  align-items: center;
  padding: 12px;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
  margin-bottom: 4px;
}

.conversation-item:hover {
  background: #f1f5f9;
}

.conversation-item.active {
  background: #e0e7ff;
}

.conv-avatar {
  width: 44px;
  height: 44px;
  border-radius: 10px;
  background: linear-gradient(135deg, #0d9488, #0891b2);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
  font-weight: 600;
  flex-shrink: 0;
}

.conv-info {
  flex: 1;
  margin-left: 12px;
  overflow: hidden;
}

.conv-name {
  font-size: 14px;
  font-weight: 500;
  color: #1e293b;
  margin-bottom: 2px;
}

.conv-preview {
  font-size: 13px;
  color: #64748b;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.conv-meta {
  text-align: right;
  margin-left: 12px;
}

.conv-time {
  font-size: 11px;
  color: #94a3b8;
}

.unread-badge {
  background: #ef4444;
  color: #fff;
  font-size: 11px;
  padding: 1px 6px;
  border-radius: 10px;
  margin-top: 4px;
  font-weight: 600;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 48px 24px;
  color: #94a3b8;
}

.empty-state p {
  margin: 8px 0 0 0;
}

.empty-hint {
  font-size: 13px !important;
  color: #cbd5e1 !important;
}

.chat-main {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.chat-content {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.chat-header {
  padding: 16px 24px;
  background: #fff;
  border-bottom: 1px solid #e2e8f0;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.chat-title {
  display: flex;
  align-items: center;
}

.chat-avatar {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  background: linear-gradient(135deg, #10b981, #34d399);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  font-weight: 600;
}

.chat-info {
  margin-left: 12px;
}

.chat-name {
  font-size: 16px;
  font-weight: 600;
  color: #1e293b;
}

.chat-subtitle {
  font-size: 13px;
  color: #64748b;
}

.message-list {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
  background: #f8fafc;
}

.message-item {
  display: flex;
  margin-bottom: 16px;
}

.message-item.message-mine {
  flex-direction: row-reverse;
}

.message-avatar {
  width: 36px;
  height: 36px;
  border-radius: 8px;
  background: linear-gradient(135deg, #0d9488, #0891b2);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 600;
  flex-shrink: 0;
}

.message-content {
  max-width: 60%;
  margin: 0 10px;
}

.message-bubble {
  padding: 12px 16px;
  border-radius: 12px;
  font-size: 14px;
  line-height: 1.5;
  word-break: break-word;
}

.message-item:not(.message-mine) .message-bubble {
  background: #fff;
  color: #1e293b;
  border-radius: 0 12px 12px 12px;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
}

.message-item.message-mine .message-bubble {
  background: linear-gradient(135deg, #0d9488, #0891b2);
  color: #fff;
  border-radius: 12px 0 12px 12px;
}

.message-time {
  font-size: 11px;
  color: #94a3b8;
  margin-top: 4px;
}

.message-item.message-mine .message-time {
  text-align: right;
}

.no-messages {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 24px;
  color: #94a3b8;
}

.no-messages p {
  margin: 12px 0 0 0;
}

.chat-empty {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #94a3b8;
}

.chat-empty p {
  margin: 16px 0 24px 0;
  font-size: 16px;
}

.chat-input-area {
  padding: 16px 24px;
  background: #fff;
  border-top: 1px solid #e2e8f0;
  display: flex;
  gap: 12px;
}

.chat-input-area :deep(.el-input) {
  flex: 1;
}

.new-chat-dialog {
  padding: 8px 0;
}

.contact-list {
  max-height: 300px;
  overflow-y: auto;
  margin-top: 12px;
}

.contact-item {
  display: flex;
  align-items: center;
  padding: 12px;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
}

.contact-item:hover {
  background: #f1f5f9;
}

.contact-avatar {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  background: linear-gradient(135deg, #10b981, #34d399);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  font-weight: 600;
}

.contact-info {
  flex: 1;
  margin-left: 12px;
}

.contact-name {
  font-size: 14px;
  font-weight: 500;
  color: #1e293b;
}

.contact-subtitle {
  font-size: 13px;
  color: #64748b;
}

.contact-arrow {
  color: #94a3b8;
}

.no-contacts {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 32px;
  color: #94a3b8;
}

.no-contacts p {
  margin: 8px 0 0 0;
}

@media (max-width: 768px) {
  .chat-container {
    flex-direction: column;
  }
  
  .chat-sidebar {
    width: 100%;
    height: 40%;
    border-right: none;
    border-bottom: 1px solid #e2e8f0;
  }
  
  .message-content {
    max-width: 80%;
  }
}
</style>