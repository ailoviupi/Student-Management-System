import request from '../utils/request'

// 获取操作日志列表
export function getOperationLogs(params) {
  return request.get('/operation-log/list', { params })
}

// 获取日志详情
export function getOperationLogById(id) {
  return request.get(`/operation-log/${id}`)
}

// 清理旧日志
export function cleanupOldLogs(days) {
  return request.delete('/operation-log/cleanup', { params: { days } })
}

// 获取统计数据
export function getLogStatistics() {
  return request.get('/operation-log/statistics')
}
