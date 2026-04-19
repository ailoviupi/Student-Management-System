import request from '../utils/request'

export const getUserList = () => {
  return request.get('/users')
}

export const addUser = (data) => {
  return request.post('/users', data)
}

export const updateUser = (id, data) => {
  return request.put(`/users/${id}`, data)
}

export const deleteUser = (id) => {
  return request.delete(`/users/${id}`)
}

export const updateUserStatus = (id, status) => {
  return request.put(`/users/${id}/status?status=${status}`)
}
