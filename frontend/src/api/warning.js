import request from '../utils/request'

// 预警规则管理
export function getWarningRules() {
  return request.get('/warning/rules')
}

export function getActiveWarningRules() {
  return request.get('/warning/rules/active')
}

export function getWarningRuleById(id) {
  return request.get(`/warning/rules/${id}`)
}

export function addWarningRule(data) {
  return request.post('/warning/rules', data)
}

export function updateWarningRule(id, data) {
  return request.put(`/warning/rules/${id}`, data)
}

export function deleteWarningRule(id) {
  return request.delete(`/warning/rules/${id}`)
}

// 学生预警管理
export function getStudentWarnings(params) {
  return request.get('/warning/list', { params })
}

export function getStudentWarningById(id) {
  return request.get(`/warning/${id}`)
}

export function handleWarning(id, data) {
  return request.post(`/warning/handle/${id}`, null, { params: data })
}

export function deleteStudentWarning(id) {
  return request.delete(`/warning/${id}`)
}

// 统计与检查
export function getWarningStatistics() {
  return request.get('/warning/statistics')
}

export function checkWarnings() {
  return request.post('/warning/check')
}
