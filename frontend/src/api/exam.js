import request from '../utils/request'

// 考试管理
export const getExamList = (params) => {
  return request.get('/exams', { params })
}

export const getExamById = (id) => {
  return request.get(`/exams/${id}`)
}

export const addExam = (data) => {
  return request.post('/exams', data)
}

export const updateExam = (data) => {
  return request.put('/exams', data)
}

export const deleteExam = (id) => {
  return request.delete(`/exams/${id}`)
}

// 学生端
export const getMyExams = () => {
  return request.get('/exams/my-exams')
}