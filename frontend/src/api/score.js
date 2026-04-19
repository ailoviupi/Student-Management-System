import request from '../utils/request'

export const getScoreList = (params) => {
  return request.get('/scores', { params })
}

export const getScoreById = (id) => {
  return request.get(`/scores/${id}`)
}

export const addScore = (data) => {
  return request.post('/scores', data)
}

export const updateScore = (data) => {
  return request.put('/scores', data)
}

export const deleteScore = (id) => {
  return request.delete(`/scores/${id}`)
}

export const getScoreStatistics = () => {
  return request.get('/scores/statistics')
}

export const getCourseRank = (courseId) => {
  return request.get(`/scores/rank/course/${courseId}`)
}

export const getOverallRank = () => {
  return request.get('/scores/rank/overall')
}

export const getScoreAnalysis = () => {
  return request.get('/scores/analysis')
}

// 学生端接口
export const getMyScores = () => {
  return request.get('/scores/my-scores')
}

export const getMyStatistics = () => {
  return request.get('/scores/my-statistics')
}
