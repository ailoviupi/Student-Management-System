<template>
  <div class="login-container">
    <div class="login-bg">
      <div class="orb orb-1"></div>
      <div class="orb orb-2"></div>
      <div class="orb orb-3"></div>
      <div class="grid-overlay"></div>
    </div>
    <div class="login-wrapper">
      <div class="login-left">
        <div class="brand-section">
          <div class="logo-ring">
            <div class="logo-inner">
              <svg viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M20 4L36 12V28L20 36L4 28V12L20 4Z" stroke="#0d9488" stroke-width="2" fill="none"/>
                <path d="M20 10L30 15V25L20 30L10 25V15L20 10Z" fill="rgba(13,148,136,0.12)"/>
                <circle cx="20" cy="20" r="4" fill="#0d9488"/>
              </svg>
            </div>
          </div>
          <h1 class="brand-title">学生管理系统</h1>
          <p class="brand-subtitle">Student Management System</p>
          <div class="brand-divider"></div>
          <div class="brand-features">
            <div class="feature-item">
              <div class="feature-dot"></div>
              <span>高效的学生信息管理</span>
            </div>
            <div class="feature-item">
              <div class="feature-dot"></div>
              <span>便捷的成绩录入查询</span>
            </div>
            <div class="feature-item">
              <div class="feature-dot"></div>
              <span>智能的数据统计分析</span>
            </div>
          </div>
        </div>
      </div>
      
      <div class="login-right">
        <div class="login-box">
          <div class="login-header">
            <h2 class="login-title">欢迎回来</h2>
            <p class="login-subtitle">请登录您的账号以继续</p>
          </div>
          
          <el-form 
            :model="form" 
            :rules="rules" 
            ref="formRef"
            class="login-form"
            @keyup.enter="handleLogin"
          >
            <el-form-item prop="username" class="input-item">
              <div class="input-wrapper">
                <el-icon class="input-icon"><User /></el-icon>
                <input
                  v-model="form.username"
                  type="text"
                  placeholder="请输入用户名"
                  class="custom-input-field"
                  @keyup.enter="handleLogin"
                />
                <div class="input-suffix"></div>
              </div>
            </el-form-item>
            
            <el-form-item prop="password" class="input-item">
              <div class="input-wrapper">
                <el-icon class="input-icon"><Lock /></el-icon>
                <input
                  v-model="form.password"
                  :type="showPassword ? 'text' : 'password'"
                  placeholder="请输入密码"
                  class="custom-input-field"
                  @keyup.enter="handleLogin"
                />
                <el-icon class="eye-icon" @click="showPassword = !showPassword">
                  <View v-if="showPassword" />
                  <Hide v-else />
                </el-icon>
              </div>
            </el-form-item>
            
            <div class="form-options">
              <el-checkbox v-model="rememberMe">记住我</el-checkbox>
            </div>
            
            <el-form-item class="login-button-item">
              <el-button
                type="primary"
                size="large"
                :loading="loading"
                @click="handleLogin"
                class="login-button"
              >
                <span v-if="!loading">登 录</span>
                <span v-else>登录中...</span>
              </el-button>
            </el-form-item>
          </el-form>
          
          <div class="login-footer">
            <p class="login-tip">教师账号：teacher1 / teacher123</p>
            <p class="login-tip">学生使用学号登录，默认密码：123456</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, Lock, View, Hide } from '@element-plus/icons-vue'
import { login } from '../api/auth'

const router = useRouter()
const formRef = ref()
const loading = ref(false)
const rememberMe = ref(false)
const showPassword = ref(false)

const form = reactive({
  username: '',
  password: ''
})

const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '长度在 3 到 20 个字符', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 20, message: '长度在 6 到 20 个字符', trigger: 'blur' }
  ]
}

const fillAccount = (username, password) => {
  form.username = username
  form.password = password
  ElMessage.info(`已填充${username === 'admin' ? '管理员' : '教师'}账号`)
}

const handleLogin = async () => {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return

  loading.value = true
  try {
    const loginData = { username: form.username, password: form.password }
    const res = await login(loginData)
    console.log('Login response:', res)
    
    if (res && (res.code === 200 || res.code === '200') && res.data && res.data.token) {
      localStorage.setItem('token', res.data.token)
      localStorage.setItem('userInfo', JSON.stringify(res.data))
      
      if (rememberMe.value) {
        localStorage.setItem('rememberedUsername', form.username)
      } else {
        localStorage.removeItem('rememberedUsername')
      }
      
      ElMessage.success('登录成功，欢迎回来！')
      router.push('/')
    } else {
      console.error('Login validation failed:', res)
      ElMessage.error(res?.message || '登录失败，返回数据异常')
    }
  } catch (error) {
    console.error('Login error:', error)
    // 区分取消请求和真正的错误
    if (error && error.cancelled) {
      // 请求被取消，不显示错误
      return
    }
    ElMessage.error('登录失败，请检查用户名和密码后重试')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  const rememberedUsername = localStorage.getItem('rememberedUsername')
  if (rememberedUsername) {
    form.username = rememberedUsername
    rememberMe.value = true
  }
})
</script>

<style scoped>
.login-container {
  min-height: 100vh;
  display: flex;
  position: relative;
  overflow: hidden;
  background: linear-gradient(135deg, #f0fdfa 0%, #ecfeff 45%, #f8fafc 100%);
}

.login-bg {
  position: absolute;
  inset: 0;
  overflow: hidden;
}

.orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(70px);
  opacity: 0.55;
}

.orb-1 {
  width: 600px;
  height: 600px;
  background: #5eead4;
  top: -200px;
  left: -100px;
  animation: orbFloat1 8s ease-in-out infinite;
}

.orb-2 {
  width: 400px;
  height: 400px;
  background: #a5f3fc;
  bottom: -100px;
  right: 30%;
  animation: orbFloat2 10s ease-in-out infinite;
}

.orb-3 {
  width: 300px;
  height: 300px;
  background: #c7d2fe;
  top: 50%;
  left: 30%;
  animation: orbFloat3 12s ease-in-out infinite;
}

@keyframes orbFloat1 {
  0%, 100% { transform: translate(0, 0) scale(1); }
  50% { transform: translate(50px, 30px) scale(1.1); }
}
@keyframes orbFloat2 {
  0%, 100% { transform: translate(0, 0) scale(1); }
  50% { transform: translate(-30px, -40px) scale(1.05); }
}
@keyframes orbFloat3 {
  0%, 100% { transform: translate(0, 0) scale(1); }
  50% { transform: translate(40px, -20px) scale(0.95); }
}

.grid-overlay {
  position: absolute;
  inset: 0;
  background-image: 
    linear-gradient(rgba(13,148,136,0.045) 1px, transparent 1px),
    linear-gradient(90deg, rgba(13,148,136,0.045) 1px, transparent 1px);
  background-size: 60px 60px;
}

.login-wrapper {
  display: flex;
  width: 100%;
  min-height: 100vh;
  position: relative;
  z-index: 1;
}

.login-left {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 60px;
  position: relative;
}

.brand-section {
  text-align: center;
  color: #1e293b;
  max-width: 480px;
}

.logo-ring {
  width: 80px;
  height: 80px;
  margin: 0 auto 28px;
  border-radius: 20px;
  background: rgba(13,148,136,0.06);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(13,148,136,0.15);
  display: flex;
  align-items: center;
  justify-content: center;
  animation: logoPulse 3s ease-in-out infinite;
}

@keyframes logoPulse {
  0%, 100% { box-shadow: 0 0 0 0 rgba(13,148,136,0.35); }
  50% { box-shadow: 0 0 0 12px rgba(13,148,136,0); }
}

.logo-inner svg {
  width: 44px;
  height: 44px;
}

.brand-title {
  font-size: 38px;
  font-weight: 700;
  margin: 0 0 8px 0;
  letter-spacing: 1px;
  background: linear-gradient(135deg, #0f766e 0%, #0d9488 50%, #06b6d4 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.brand-subtitle {
  font-size: 15px;
  color: rgba(30, 41, 59, 0.5);
  margin: 0 0 32px 0;
  font-weight: 400;
  letter-spacing: 2px;
  text-transform: uppercase;
}

.brand-divider {
  width: 40px;
  height: 3px;
  background: linear-gradient(90deg, #0d9488, #06b6d4);
  margin: 0 auto 32px;
  border-radius: 2px;
}

.brand-features {
  text-align: left;
  display: inline-block;
}

.feature-item {
  display: flex;
  align-items: center;
  margin: 14px 0;
  font-size: 15px;
  color: #475569;
  gap: 12px;
}

.feature-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #0d9488;
  flex-shrink: 0;
  box-shadow: 0 0 8px rgba(13,148,136,0.5);
}

.login-right {
  width: 520px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40px;
  background: rgba(255,255,255,0.65);
  backdrop-filter: blur(20px);
  border-left: 1px solid rgba(229, 234, 240, 0.9);
}

.login-box {
  width: 100%;
  max-width: 400px;
  padding: 40px;
  background: #ffffff;
  border-radius: 20px;
  border: 1px solid #e5eaf0;
  box-shadow: 0 20px 40px -12px rgba(15, 23, 42, 0.12);
}

.login-header {
  text-align: center;
  margin-bottom: 36px;
}

.login-title {
  font-size: 28px;
  font-weight: 700;
  color: #1e293b;
  margin: 0 0 8px 0;
}

.login-subtitle {
  font-size: 14px;
  color: rgba(30, 41, 59, 0.5);
  margin: 0;
}

.login-form {
  margin-top: 28px;
}

.input-item {
  margin-bottom: 20px;
}

.input-item :deep(.el-form-item__error) {
  color: #f87171;
  font-size: 12px;
  margin-top: 6px;
  padding-left: 4px;
}

.input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
  height: 52px;
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  border-radius: 12px;
  padding: 0 16px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.input-wrapper:hover {
  background: #f1f5f9;
  border-color: #cbd5e1;
}

.input-wrapper:focus-within {
  background: #ffffff;
  border-color: #0d9488;
  box-shadow: 0 0 0 4px rgba(13,148,136,0.12);
}

.input-icon {
  color: rgba(100,116,139,0.6);
  font-size: 18px;
  margin-right: 12px;
  flex-shrink: 0;
  transition: color 0.3s;
}

.input-wrapper:focus-within .input-icon {
  color: #0d9488;
}

.custom-input-field {
  flex: 1;
  height: 100%;
  background: transparent;
  border: none;
  outline: none;
  color: #1e293b;
  font-size: 15px;
  font-family: inherit;
}

.custom-input-field::placeholder {
  color: rgba(100,116,139,0.55);
}

.eye-icon {
  color: rgba(100,116,139,0.6);
  font-size: 18px;
  cursor: pointer;
  flex-shrink: 0;
  margin-left: 8px;
  transition: all 0.2s;
  padding: 4px;
  border-radius: 4px;
}

.eye-icon:hover {
  color: #0f766e;
  background: #f1f5f9;
}

.input-suffix {
  width: 18px;
  flex-shrink: 0;
  margin-left: 8px;
  padding: 4px;
}

.form-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin: 4px 0 20px 0;
}

:deep(.el-checkbox__label) {
  color: #475569 !important;
  font-size: 13px;
}

:deep(.el-checkbox__inner) {
  background: #fff;
  border-color: #cbd5e1;
}

.login-button-item {
  margin-bottom: 0;
}

.login-button {
  width: 100%;
  height: 48px;
  font-size: 16px;
  font-weight: 600;
  border-radius: 10px;
  background: linear-gradient(135deg, #0d9488 0%, #06b6d4 100%);
  border: none;
  transition: all 0.3s;
  letter-spacing: 2px;
}

.login-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(13,148,136,0.35);
}

.login-footer {
  margin-top: 28px;
  text-align: center;
}

.login-tip {
  font-size: 13px;
  color: #94a3b8;
  margin: 6px 0;
  line-height: 1.5;
}

.login-divider {
  display: flex;
  align-items: center;
  margin: 28px 0;
  color: #94a3b8;
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.login-divider::before,
.login-divider::after {
  content: '';
  flex: 1;
  height: 1px;
  background: #e5eaf0;
}

.login-divider span {
  padding: 0 12px;
}

.test-accounts {
  display: flex;
  gap: 10px;
  justify-content: center;
}

.account-tag {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 16px;
  background: #f8fafc;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.3s;
  border: 1px solid #e5eaf0;
  flex: 1;
}

.account-tag:hover {
  background: rgba(13,148,136,0.08);
  border-color: rgba(13,148,136,0.3);
  transform: translateY(-2px);
}

.tag-icon {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  color: #fff;
  flex-shrink: 0;
}

.admin-icon {
  background: linear-gradient(135deg, #0d9488, #06b6d4);
}

.teacher-icon {
  background: linear-gradient(135deg, #06b6d4, #0ea5e9);
}

.student-icon {
  background: linear-gradient(135deg, #f59e0b, #f97316);
}

.tag-text {
  display: flex;
  flex-direction: column;
}

.tag-role {
  font-size: 12px;
  color: #334155;
  font-weight: 500;
}

.tag-pwd {
  font-size: 11px;
  color: #94a3b8;
}

.copyright {
  margin-top: 32px;
  text-align: center;
  color: #cbd5e1;
  font-size: 12px;
}

@media (max-width: 992px) {
  .login-left {
    display: none;
  }
  
  .login-right {
    width: 100%;
    border-left: none;
  }
}
</style>
