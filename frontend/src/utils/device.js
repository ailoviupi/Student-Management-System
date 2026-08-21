import { ref, onMounted, onUnmounted } from 'vue'

// 检测是否为移动设备
export function isMobileDevice() {
  return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
}

// 检测屏幕宽度是否小于阈值
export function isMobileWidth(breakpoint = 768) {
  return window.innerWidth < breakpoint
}

// 组合检测（用户代理或屏幕宽度）
export function isMobile(breakpoint = 768) {
  return isMobileDevice() || isMobileWidth(breakpoint)
}

// 创建响应式的移动端状态
export function useMobile(breakpoint = 768) {
  const isMobileView = ref(isMobile(breakpoint))

  const updateMobileStatus = () => {
    isMobileView.value = isMobile(breakpoint)
  }

  onMounted(() => {
    window.addEventListener('resize', updateMobileStatus)
  })

  onUnmounted(() => {
    window.removeEventListener('resize', updateMobileStatus)
  })

  return {
    isMobileView,
    isMobileDevice: isMobileDevice(),
    isMobileWidth: isMobileWidth(breakpoint)
  }
}

export default {
  isMobileDevice,
  isMobileWidth,
  isMobile,
  useMobile
}
