import request from '../utils/request'

// 奖学金类型管理
export function getScholarshipTypes() {
  return request.get('/scholarship/types')
}

export function getActiveScholarshipTypes() {
  return request.get('/scholarship/types/active')
}

export function getScholarshipTypeById(id) {
  return request.get(`/scholarship/types/${id}`)
}

export function addScholarshipType(data) {
  return request.post('/scholarship/types', data)
}

export function updateScholarshipType(id, data) {
  return request.put(`/scholarship/types/${id}`, data)
}

export function deleteScholarshipType(id) {
  return request.delete(`/scholarship/types/${id}`)
}

// 奖学金评定
export function getScholarshipRecords(params) {
  return request.get('/scholarship/records', { params })
}

export function getScholarshipRecordById(id) {
  return request.get(`/scholarship/records/${id}`)
}

export function applyScholarship(data) {
  return request.post('/scholarship/apply', data)
}

export function reviewScholarship(id, data) {
  return request.post(`/scholarship/review/${id}`, null, { params: data })
}

export function deleteScholarshipRecord(id) {
  return request.delete(`/scholarship/records/${id}`)
}

// 自动评定与统计
export function autoEvaluateScholarship(params) {
  return request.post('/scholarship/auto-evaluate', null, { params })
}

export function getScholarshipStatistics(params) {
  return request.get('/scholarship/statistics', { params })
}
