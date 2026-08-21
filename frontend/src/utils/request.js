import axios from 'axios'
import { ElMessage, ElLoading } from 'element-plus'

// 创建axios实例
const request = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || 'http://localhost:8083/api',
  timeout: 15000,
  headers: {
    'Content-Type': 'application/json;charset=UTF-8'
  }
})

// 请求队列（用于取消重复请求）
const pendingRequests = new Map()

// 生成请求唯一标识
const generateRequestKey = (config) => {
  return `${config.method}&${config.url}&${JSON.stringify(config.params)}&${JSON.stringify(config.data)}`
}

// 添加请求到队列
const addPendingRequest = (config) => {
  // 登录请求不加入取消队列，避免被误取消
  if (config.url && config.url.includes('/auth/login')) {
    return
  }
  const requestKey = generateRequestKey(config)
  config.cancelToken = config.cancelToken || new axios.CancelToken(cancel => {
    if (!pendingRequests.has(requestKey)) {
      pendingRequests.set(requestKey, cancel)
    }
  })
}

// 移除请求从队列
const removePendingRequest = (config) => {
  const requestKey = generateRequestKey(config)
  if (pendingRequests.has(requestKey)) {
    const cancel = pendingRequests.get(requestKey)
    cancel('取消重复请求')
    pendingRequests.delete(requestKey)
  }
}

// 清理所有pending请求
const clearPendingRequests = () => {
  pendingRequests.forEach(cancel => cancel('用户已登出'))
  pendingRequests.clear()
}

// 全局loading实例
let globalLoading = null
let loadingCount = 0

// 显示loading
const showLoading = (config) => {
  if (config.showLoading !== false) {
    loadingCount++
    if (loadingCount === 1) {
      globalLoading = ElLoading.service({
        lock: true,
        text: '加载中...',
        background: 'rgba(0, 0, 0, 0.1)'
      })
    }
  }
}

// 隐藏loading
const hideLoading = (config) => {
  if (config.showLoading !== false) {
    loadingCount--
    if (loadingCount <= 0) {
      loadingCount = 0
      if (globalLoading) {
        globalLoading.close()
        globalLoading = null
      }
    }
  }
}

// 请求拦截器
request.interceptors.request.use(
  (config) => {
    // 移除重复请求
    removePendingRequest(config)
    addPendingRequest(config)

    // 添加token
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }

    // 显示loading
    showLoading(config)

    // 添加时间戳防止缓存
    if (config.method === 'get') {
      config.params = { ...config.params, _t: Date.now() }
    }

    return config
  },
  (error) => {
    hideLoading(error.config)
    return Promise.reject(error)
  }
)

// 响应拦截器
request.interceptors.response.use(
  (response) => {
    // 移除已完成的请求
    removePendingRequest(response.config)
    // 隐藏loading
    hideLoading(response.config)

    const res = response.data

    // 处理业务状态码
    if (res.code !== 200) {
      // 特殊状态码处理
      switch (res.code) {
        case 401:
          handleUnauthorized()
          break
        case 403:
          ElMessage.error(res.message || '没有权限执行此操作')
          break
        case 404:
          ElMessage.error(res.message || '请求的资源不存在')
          break
        case 500:
          ElMessage.error(res.message || '服务器内部错误')
          break
        default:
          ElMessage.error(res.message || '操作失败')
      }
      return Promise.reject(new Error(res.message || '请求失败'))
    }

    return res
  },
  (error) => {
    // 隐藏loading
    if (error.config) {
      hideLoading(error.config)
    }

    // 移除失败的请求
    if (error.config) {
      removePendingRequest(error.config)
    }

    // 处理取消请求
    if (axios.isCancel(error)) {
      // 不返回假的成功响应，而是返回错误以便调用方正确处理
      return Promise.reject({ 
        code: 499, 
        message: '请求已取消',
        cancelled: true 
      })
    }

    const { response } = error

    if (response) {
      switch (response.status) {
        case 400:
          ElMessage.error(response.data?.message || '请求参数错误')
          break
        case 401:
          handleUnauthorized()
          break
        case 403:
          ElMessage.error('没有权限访问该资源')
          break
        case 404:
          ElMessage.error('请求的资源不存在')
          break
        case 408:
          ElMessage.error('请求超时，请稍后重试')
          break
        case 500:
          ElMessage.error('服务器内部错误')
          break
        case 502:
          ElMessage.error('网关错误')
          break
        case 503:
          ElMessage.error('服务不可用')
          break
        case 504:
          ElMessage.error('网关超时')
          break
        default:
          ElMessage.error(response.data?.message || `请求失败: ${response.status}`)
      }
    } else {
      // 网络错误处理
      if (error.message.includes('timeout')) {
        ElMessage.error('请求超时，请检查网络后重试')
      } else if (error.message.includes('Network Error')) {
        ElMessage.error('网络连接失败，请检查网络设置')
      } else {
        ElMessage.error(error.message || '网络错误')
      }
    }

    return Promise.reject(error)
  }
)

// 处理未授权
const handleUnauthorized = () => {
  ElMessage.error('登录已过期，请重新登录')
  clearPendingRequests()
  localStorage.removeItem('token')
  localStorage.removeItem('userInfo')
  setTimeout(() => {
    window.location.href = '/#/login'
  }, 1500)
}

// 导出请求方法
export const http = {
  get: (url, config = {}) => request.get(url, config),
  post: (url, data, config = {}) => request.post(url, data, config),
  put: (url, data, config = {}) => request.put(url, data, config),
  delete: (url, config = {}) => request.delete(url, config),
  patch: (url, data, config = {}) => request.patch(url, data, config),
  // 上传文件
  upload: (url, file, config = {}) => {
    const formData = new FormData()
    formData.append('file', file)
    return request.post(url, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
      ...config
    })
  },
  // 下载文件
  download: (url, params, filename) => {
    return request.get(url, {
      params,
      responseType: 'blob'
    }).then(res => {
      const blob = new Blob([res.data])
      const link = document.createElement('a')
      link.href = URL.createObjectURL(blob)
      link.download = filename || 'download'
      link.click()
      URL.revokeObjectURL(link.href)
    })
  },
  // 取消所有请求
  cancelAll: clearPendingRequests
}

export default request
