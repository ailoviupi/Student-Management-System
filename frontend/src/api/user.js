import request from '../utils/request'

// 获取用户列表
export function getUserList(params) {
  return request.get('/users', { params })
}

// 获取单个用户
export function getUserById(id) {
  return request.get(`/users/${id}`)
}

// 添加用户
export function addUser(data) {
  return request.post('/users', data)
}

// 更新用户
export function updateUser(id, data) {
  return request.put(`/users/${id}`, data)
}

// 删除用户
export function deleteUser(id) {
  return request.delete(`/users/${id}`)
}

// 修改密码
export function changePassword(data) {
  return request.put('/users/password', data)
}

// 根据角色获取用户列表
export function getUsersByRole(role) {
  return request.get('/users/by-role', { params: { role } })
}

// 更新用户状态
export function updateUserStatus(id, status) {
  return request.put(`/users/${id}/status`, null, { params: { status } })
}
