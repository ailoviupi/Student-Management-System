import request from '../utils/request'

// 作业管理
export const getHomeworkList = (params) => {
  return request.get('/homework', { params })
}

export const getHomeworkById = (id) => {
  return request.get(`/homework/${id}`)
}

export const addHomework = (data) => {
  return request.post('/homework', data)
}

export const updateHomework = (data) => {
  return request.put('/homework', data)
}

export const deleteHomework = (id) => {
  return request.delete(`/homework/${id}`)
}

// 作业提交
export const getSubmissions = (homeworkId, params) => {
  return request.get(`/homework/${homeworkId}/submissions`, { params })
}

export const getSubmissionById = (id) => {
  return request.get(`/homework/submissions/${id}`)
}

export const submitHomework = (data) => {
  return request.post('/homework/submissions', data)
}

export const gradeSubmission = (id, params) => {
  return request.put(`/homework/submissions/${id}/grade`, null, { params })
}

// 统计
export const getHomeworkStatistics = (homeworkId) => {
  return request.get(`/homework/${homeworkId}/statistics`)
}

// 学生端
export const getMyHomework = () => {
  return request.get('/homework/my-homework')
}

export const getMySubmission = (homeworkId) => {
  return request.get(`/homework/${homeworkId}/my-submission`)
}