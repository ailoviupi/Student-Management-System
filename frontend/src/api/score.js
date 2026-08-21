import request, { http } from '../utils/request'
import { withCache } from '../utils/cache'

// 基础CRUD操作
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

// 统计数据 - 带缓存
export const getScoreStatistics = () => {
  return withCache(
    () => request.get('/scores/statistics'),
    {
      key: 'api:scores:statistics',
      ttl: 2 * 60 * 1000 // 2分钟缓存
    }
  )
}

// 排名数据
export const getCourseRank = (courseId) => {
  return request.get(`/scores/rank/course/${courseId}`)
}

export const getOverallRank = () => {
  return withCache(
    () => request.get('/scores/rank/overall'),
    {
      key: 'api:scores:rank:overall',
      ttl: 60 * 1000 // 1分钟缓存
    }
  )
}

// 分析数据 - 带缓存
export const getScoreAnalysis = () => {
  return withCache(
    () => request.get('/scores/analysis'),
    {
      key: 'api:scores:analysis',
      ttl: 3 * 60 * 1000 // 3分钟缓存
    }
  )
}

// 学生端接口
export const getMyScores = () => {
  return request.get('/scores/my-scores')
}

export const getMyStatistics = () => {
  return request.get('/scores/my-statistics')
}

// 批量操作
export const batchAddScores = (dataList) => {
  return request.post('/scores/batch', dataList)
}

export const batchDeleteScores = (ids) => {
  return request.delete('/scores/batch', { data: ids })
}

// 导出成绩
export const exportScores = (params, filename = '成绩表.xlsx') => {
  return http.download('/scores/export', params, filename)
}

// 导入成绩
export const importScores = (file) => {
  return http.upload('/scores/import', file)
}
