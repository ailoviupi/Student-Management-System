import { ElMessage, ElNotification } from 'element-plus'

// 错误类型枚举
export const ErrorType = {
  NETWORK: 'network',       // 网络错误
  TIMEOUT: 'timeout',       // 超时错误
  AUTH: 'auth',             // 认证错误
  PERMISSION: 'permission', // 权限错误
  VALIDATION: 'validation', // 验证错误
  SERVER: 'server',         // 服务器错误
  BUSINESS: 'business',     // 业务错误
  UNKNOWN: 'unknown'        // 未知错误
}

// 错误处理配置
const errorConfig = {
  // 是否显示错误消息
  showMessage: true,
  // 是否显示详细错误
  showDetail: process.env.NODE_ENV === 'development',
  // 消息持续时间
  duration: 3000,
  // 最大错误消息数
  maxMessages: 3
}

// 错误消息队列
let messageQueue = []

// 显示错误消息（带防抖）
const showErrorMessage = (message, type = 'error') => {
  // 添加到队列
  messageQueue.push({ message, type, time: Date.now() })

  // 清理过期消息（5秒内的）
  messageQueue = messageQueue.filter(m => Date.now() - m.time < 5000)

  // 如果队列超过最大值，只显示最新的
  if (messageQueue.length > errorConfig.maxMessages) {
    messageQueue = messageQueue.slice(-errorConfig.maxMessages)
    return
  }

  // 防抖：如果相同消息在2秒内已显示，则跳过
  const recentSameMessage = messageQueue.find(m =>
    m.message === message &&
    Date.now() - m.time < 2000 &&
    m !== messageQueue[messageQueue.length - 1]
  )

  if (recentSameMessage) {
    return
  }

  ElMessage({
    message,
    type,
    duration: errorConfig.duration,
    showClose: true
  })
}

// 分类处理错误
export const handleError = (error, options = {}) => {
  const { silent = false, context = '' } = options

  let errorType = ErrorType.UNKNOWN
  let errorMessage = '未知错误'
  let errorDetail = ''

  // 解析错误类型
  if (error.response) {
    const { status, data } = error.response

    switch (status) {
      case 400:
        errorType = ErrorType.VALIDATION
        errorMessage = data?.message || '请求参数错误'
        break
      case 401:
        errorType = ErrorType.AUTH
        errorMessage = '登录已过期，请重新登录'
        break
      case 403:
        errorType = ErrorType.PERMISSION
        errorMessage = '没有权限执行此操作'
        break
      case 404:
        errorType = ErrorType.BUSINESS
        errorMessage = '请求的资源不存在'
        break
      case 408:
        errorType = ErrorType.TIMEOUT
        errorMessage = '请求超时，请稍后重试'
        break
      case 500:
      case 502:
      case 503:
      case 504:
        errorType = ErrorType.SERVER
        errorMessage = '服务器繁忙，请稍后重试'
        break
      default:
        errorType = ErrorType.UNKNOWN
        errorMessage = data?.message || `请求失败 (${status})`
    }

    errorDetail = data?.detail || data?.stack || ''
  } else if (error.request) {
    if (error.message.includes('timeout')) {
      errorType = ErrorType.TIMEOUT
      errorMessage = '请求超时，请检查网络后重试'
    } else {
      errorType = ErrorType.NETWORK
      errorMessage = '网络连接失败，请检查网络设置'
    }
  } else {
    errorType = ErrorType.UNKNOWN
    errorMessage = error.message || '发生未知错误'
  }

  // 记录错误日志
  console.error(`[${context}] ${errorType}:`, errorMessage, error)

  // 显示错误消息
  if (!silent && errorConfig.showMessage) {
    showErrorMessage(errorMessage, 'error')
  }

  // 开发环境显示详细错误
  if (errorConfig.showDetail && errorDetail) {
    console.error('错误详情:', errorDetail)
  }

  return {
    type: errorType,
    message: errorMessage,
    detail: errorDetail,
    original: error
  }
}

// 显示成功消息
export const showSuccess = (message, options = {}) => {
  const { duration = 2000 } = options
  ElMessage({
    message,
    type: 'success',
    duration,
    showClose: true
  })
}

// 显示警告消息
export const showWarning = (message, options = {}) => {
  const { duration = 3000 } = options
  ElMessage({
    message,
    type: 'warning',
    duration,
    showClose: true
  })
}

// 显示通知
export const showNotification = (title, message, type = 'info') => {
  ElNotification({
    title,
    message,
    type,
    duration: 4500,
    position: 'top-right'
  })
}

// 全局错误捕获
export const setupGlobalErrorHandler = (app) => {
  // Vue 错误处理
  app.config.errorHandler = (err, vm, info) => {
    console.error('Vue Error:', err, info)
    handleError(err, { context: 'Vue', silent: true })
  }

  // 未处理的 Promise 错误
  window.addEventListener('unhandledrejection', (event) => {
    console.error('Unhandled Promise Rejection:', event.reason)
    handleError(event.reason, { context: 'Promise', silent: true })
  })

  // JS 运行时错误
  window.addEventListener('error', (event) => {
    console.error('Runtime Error:', event.error)
    handleError(event.error, { context: 'Runtime', silent: true })
  })
}

// 重试机制
export const withRetry = async (fn, options = {}) => {
  const {
    maxRetries = 3,
    retryDelay = 1000,
    onRetry = null
  } = options

  let lastError

  for (let i = 0; i <= maxRetries; i++) {
    try {
      return await fn()
    } catch (error) {
      lastError = error

      // 只有网络错误和超时错误才重试
      const shouldRetry = error.message?.includes('timeout') ||
                         error.message?.includes('Network Error') ||
                         error.response?.status >= 500

      if (!shouldRetry || i === maxRetries) {
        throw error
      }

      // 延迟重试
      if (onRetry) {
        onRetry(i + 1, maxRetries)
      }

      await new Promise(resolve => setTimeout(resolve, retryDelay * (i + 1)))
    }
  }

  throw lastError
}

export default {
  ErrorType,
  handleError,
  showSuccess,
  showWarning,
  showNotification,
  setupGlobalErrorHandler,
  withRetry
}
