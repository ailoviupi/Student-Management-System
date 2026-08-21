import request from '../utils/request'

export const getConversations = () => {
  return request.get('/chat/conversations')
}

export const getMessages = (targetId) => {
  return request.get('/chat/messages', { params: { targetId } })
}

export const markAsRead = (senderId) => {
  return request.post('/chat/read', { senderId })
}

export const getUnreadCount = () => {
  return request.get('/chat/unread-count')
}

export const getChatStatistics = () => {
  return request.get('/chat/statistics')
}

export const getDetailedStatistics = () => {
  return request.get('/chat/statistics/detailed')
}

export const getDailyMessageStats = (days = 7) => {
  return request.get('/chat/statistics/daily', { params: { days } })
}

export const getTopActiveUsers = (limit = 10) => {
  return request.get('/chat/statistics/top-users', { params: { limit } })
}

export const getAvailableStudents = (keyword) => {
  return request.get('/chat/students', { params: { keyword } })
}

export const getAvailableTeachers = () => {
  return request.get('/chat/teachers')
}