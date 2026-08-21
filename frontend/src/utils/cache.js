// 缓存管理器
class CacheManager {
  constructor() {
    this.memoryCache = new Map()
    this.defaultTTL = 5 * 60 * 1000 // 默认5分钟
  }

  // 生成缓存key
  generateKey(url, params = {}) {
    const sortedParams = Object.keys(params)
      .sort()
      .reduce((acc, key) => {
        acc[key] = params[key]
        return acc
      }, {})
    return `${url}:${JSON.stringify(sortedParams)}`
  }

  // 设置缓存
  set(key, data, ttl = this.defaultTTL) {
    const expireTime = Date.now() + ttl
    this.memoryCache.set(key, {
      data,
      expireTime
    })

    // 同时存储到 localStorage（用于页面刷新后恢复）
    try {
      localStorage.setItem(`cache_${key}`, JSON.stringify({
        data,
        expireTime
      }))
    } catch (e) {
      // localStorage 满了，忽略错误
    }
  }

  // 获取缓存
  get(key) {
    // 先检查内存缓存
    const memoryItem = this.memoryCache.get(key)
    if (memoryItem) {
      if (Date.now() < memoryItem.expireTime) {
        return memoryItem.data
      }
      // 过期，删除
      this.memoryCache.delete(key)
    }

    // 检查 localStorage
    try {
      const storageItem = localStorage.getItem(`cache_${key}`)
      if (storageItem) {
        const parsed = JSON.parse(storageItem)
        if (Date.now() < parsed.expireTime) {
          // 恢复到内存缓存
          this.memoryCache.set(key, parsed)
          return parsed.data
        }
        // 过期，删除
        localStorage.removeItem(`cache_${key}`)
      }
    } catch (e) {
      console.warn('Cache parse error:', e)
    }

    return null
  }

  // 删除缓存
  delete(key) {
    this.memoryCache.delete(key)
    try {
      localStorage.removeItem(`cache_${key}`)
    } catch (e) {}
  }

  // 清空缓存
  clear() {
    this.memoryCache.clear()
    // 清理 localStorage 中的缓存
    try {
      const keys = Object.keys(localStorage)
      keys.forEach(key => {
        if (key.startsWith('cache_')) {
          localStorage.removeItem(key)
        }
      })
    } catch (e) {}
  }

  // 清空指定前缀的缓存
  clearByPrefix(prefix) {
    // 清理内存缓存
    for (const key of this.memoryCache.keys()) {
      if (key.startsWith(prefix)) {
        this.memoryCache.delete(key)
      }
    }

    // 清理 localStorage
    try {
      const keys = Object.keys(localStorage)
      keys.forEach(key => {
        if (key.startsWith(`cache_${prefix}`)) {
          localStorage.removeItem(key)
        }
      })
    } catch (e) {}
  }

  // 获取缓存大小
  size() {
    return this.memoryCache.size
  }
}

// 创建单例
const cache = new CacheManager()

// 带缓存的请求包装器
export const withCache = async (requestFn, options = {}) => {
  const {
    key,
    ttl = 5 * 60 * 1000, // 5分钟
    forceRefresh = false, // 强制刷新
    onHit = null, // 缓存命中回调
    onMiss = null // 缓存未命中回调
  } = options

  // 如果不强制刷新，先检查缓存
  if (!forceRefresh) {
    const cached = cache.get(key)
    if (cached !== null) {
      onHit?.(cached)
      return cached
    }
  }

  onMiss?.()

  // 执行请求
  const result = await requestFn()

  // 缓存结果
  cache.set(key, result, ttl)

  return result
}

// 清除特定API的缓存
export const clearApiCache = (urlPattern) => {
  cache.clearByPrefix(urlPattern)
}

// 清除所有缓存
export const clearAllCache = () => {
  cache.clear()
}

export default cache
