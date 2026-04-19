import request from '../utils/request'

export const getClassList = () => {
  return request.get('/classes')
}

export const getClassById = (id) => {
  return request.get(`/classes/${id}`)
}

export const addClass = (data) => {
  return request.post('/classes', data)
}

export const updateClass = (data) => {
  return request.put('/classes', data)
}

export const deleteClass = (id) => {
  return request.delete(`/classes/${id}`)
}

// 学生端接口
export const getMyClass = () => {
  return request.get('/classes/my-class')
}

export const getMyClassmates = () => {
  return request.get('/classes/my-classmates')
}
