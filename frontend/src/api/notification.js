import request from '../utils/request'

// 创建通知
export function createNotification(data) {
  return request.post('/notification', data)
}

// 获取用户通知列表
export function getUserNotifications() {
  return request.get('/notification/list')
}

// 获取未读消息数
export function getUnreadCount() {
  return request.get('/notification/unread-count')
}

// 标记已读
export function markAsRead(notificationId) {
  return request.post(`/notification/read/${notificationId}`)
}

// 标记全部已读
export function markAllAsRead() {
  return request.post('/notification/read-all')
}

// 撤回通知
export function withdrawNotification(notificationId) {
  return request.post(`/notification/withdraw/${notificationId}`)
}

// 删除通知
export function deleteNotification(notificationId) {
  return request.delete(`/notification/${notificationId}`)
}
