import request from '../utils/request'

export const getStudentList = (params) => {
  return request.get('/students', { params })
}

export const getStudentById = (id) => {
  return request.get(`/students/${id}`)
}

export const addStudent = (data) => {
  return request.post('/students', data)
}

export const updateStudent = (data) => {
  return request.put('/students', data)
}

export const deleteStudent = (id) => {
  return request.delete(`/students/${id}`)
}
