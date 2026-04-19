import request from '../utils/request'

export const getSettings = () => {
  return request.get('/settings')
}

export const getSettingsMap = () => {
  return request.get('/settings/map')
}

export const updateSetting = (key, value) => {
  return request.put(`/settings/${key}`, { value })
}
