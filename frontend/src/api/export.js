import request from '../utils/request'

// 导出学生信息
export function exportStudents() {
  return request.get('/export/students', {
    responseType: 'blob'
  })
}

// 导出成绩
export function exportScores(params) {
  return request.get('/export/scores', {
    params,
    responseType: 'blob'
  })
}

// 导出学生成绩单
export function exportStudentScores(studentId) {
  return request.get(`/export/student/${studentId}/scores`, {
    responseType: 'blob'
  })
}

// 导出考勤记录
export function exportAttendance(params) {
  return request.get('/export/attendance', {
    params,
    responseType: 'blob'
  })
}

// 导出预警记录
export function exportWarnings(params) {
  return request.get('/export/warnings', {
    params,
    responseType: 'blob'
  })
}

// 导出课程统计
export function exportCourseStats() {
  return request.get('/export/course-stats', {
    responseType: 'blob'
  })
}
