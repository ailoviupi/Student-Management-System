import request from '../utils/request'

// 教室管理
export function getClassrooms() {
  return request.get('/schedule/classrooms')
}

export function getActiveClassrooms() {
  return request.get('/schedule/classrooms/active')
}

export function addClassroom(data) {
  return request.post('/schedule/classrooms', data)
}

export function updateClassroom(id, data) {
  return request.put(`/schedule/classrooms/${id}`, data)
}

export function deleteClassroom(id) {
  return request.delete(`/schedule/classrooms/${id}`)
}

// 课程安排
export function getSchedules(params) {
  return request.get('/schedule/list', { params })
}

export function addSchedule(data) {
  return request.post('/schedule', data)
}

export function updateSchedule(id, data) {
  return request.put(`/schedule/${id}`, data)
}

export function deleteSchedule(id) {
  return request.delete(`/schedule/${id}`)
}

// 自动排课
export function autoSchedule(data) {
  return request.post('/schedule/auto-schedule', data)
}

// 获取班级课表
export function getClassTimetable(classId, params) {
  return request.get(`/schedule/timetable/${classId}`, { params })
}

// ==================== 班级课程管理 ====================

export function getClassCourses(classId) {
  return request.get('/schedule/class-course', { params: { classId } })
}

export function getAllClassCourses() {
  return request.get('/schedule/class-course')
}

export function addClassCourse(data) {
  return request.post('/schedule/class-course', data)
}

export function updateClassCourse(id, data) {
  return request.put(`/schedule/class-course/${id}`, data)
}

export function deleteClassCourse(id) {
  return request.delete(`/schedule/class-course/${id}`)
}

// ==================== 教师偏好管理 ====================

export function getTeacherPreferences() {
  return request.get('/schedule/teacher-preference')
}

export function getTeacherPreference(teacherId) {
  return request.get(`/schedule/teacher-preference/${teacherId}`)
}

export function addTeacherPreference(data) {
  return request.post('/schedule/teacher-preference', data)
}

export function updateTeacherPreference(id, data) {
  return request.put(`/schedule/teacher-preference/${id}`, data)
}

export function deleteTeacherPreference(id) {
  return request.delete(`/schedule/teacher-preference/${id}`)
}
