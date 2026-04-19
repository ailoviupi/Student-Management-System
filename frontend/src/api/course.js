import request from '../utils/request'

export const getCourseList = () => {
  return request.get('/courses')
}

export const getCourseById = (id) => {
  return request.get(`/courses/${id}`)
}

export const addCourse = (data) => {
  return request.post('/courses', data)
}

export const updateCourse = (data) => {
  return request.put('/courses', data)
}

export const deleteCourse = (id) => {
  return request.delete(`/courses/${id}`)
}
