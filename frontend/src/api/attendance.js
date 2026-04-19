import request from '../utils/request'

export const getAttendanceList = (params) => {
  return request.get('/attendance', { params })
}

export const getAttendanceById = (id) => {
  return request.get(`/attendance/${id}`)
}

export const addAttendance = (data) => {
  return request.post('/attendance', data)
}

export const updateAttendance = (data) => {
  return request.put('/attendance', data)
}

export const deleteAttendance = (id) => {
  return request.delete(`/attendance/${id}`)
}

export const getAttendanceStatistics = (params) => {
  return request.get('/attendance/statistics', { params })
}

// 学生端接口
export const getMyAttendance = (params) => {
  return request.get('/attendance/my-attendance', { params })
}

export const getMyAttendanceStatistics = () => {
  return request.get('/attendance/my-statistics')
}
