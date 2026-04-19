<template>
  <div class="profile">
    <div class="page-header">
      <h2 class="page-title">个人中心</h2>
      <p class="page-desc">管理您的账号信息和密码</p>
    </div>

    <el-row :gutter="24">
      <el-col :span="10">
        <el-card class="profile-card">
          <div class="profile-banner"></div>
          <div class="profile-body">
            <div class="avatar-wrap">
              <div class="avatar">
                {{ (userInfo.realName || userInfo.username || '?')[0] }}
              </div>
            </div>
            <h3 class="user-name">{{ userInfo.realName || userInfo.username }}</h3>
            <div class="user-role">
              <span class="role-badge" :class="userInfo.role">
                {{ userInfo.role === 'admin' ? '管理员' : userInfo.role === 'teacher' ? '教师' : '学生' }}
              </span>
            </div>
            <div class="info-list">
              <div class="info-row">
                <span class="info-label">用户名</span>
                <span class="info-value">{{ userInfo.username }}</span>
              </div>
              <div class="info-row">
                <span class="info-label">真实姓名</span>
                <span class="info-value">{{ userInfo.realName }}</span>
              </div>
              <div class="info-row">
                <span class="info-label">角色</span>
                <span class="info-value">{{ userInfo.role === 'admin' ? '系统管理员' : userInfo.role === 'teacher' ? '教师' : '学生' }}</span>
              </div>
              <!-- 学生额外信息 -->
              <div class="info-row" v-if="userInfo.role === 'student' && userInfo.studentNo">
                <span class="info-label">学号</span>
                <span class="info-value">{{ userInfo.studentNo }}</span>
              </div>
              <div class="info-row" v-if="userInfo.role === 'student' && userInfo.className">
                <span class="info-label">班级</span>
                <span class="info-value">{{ userInfo.className }}</span>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>

      <el-col :span="14">
        <!-- 学生显示提示信息 -->
        <el-card class="password-card" v-if="userInfo.role === 'student'">
          <template #header>
            <div class="card-header">
              <span class="card-title">账号信息</span>
              <span class="card-sub">学生账号信息展示</span>
            </div>
          </template>
          <div class="student-info">
            <el-alert
              title="学生账号说明"
              description="学生账号默认密码为 123456 或学号后6位。如需修改密码，请联系管理员。"
              type="info"
              :closable="false"
              show-icon
            />
            <div class="info-tips">
              <h4>功能入口：</h4>
              <ul>
                <li>我的成绩 - 查看个人各科成绩及统计</li>
                <li>我的课程 - 查看本学期课程安排</li>
                <li>数据概览 - 查看系统统计数据</li>
              </ul>
            </div>
          </div>
        </el-card>
        
        <!-- 管理员和教师显示修改密码 -->
        <el-card class="password-card" v-else>
          <template #header>
            <div class="card-header">
              <span class="card-title">修改密码</span>
              <span class="card-sub">定期修改密码以保障账号安全</span>
            </div>
          </template>
          <el-form :model="passwordForm" :rules="passwordRules" ref="passwordFormRef" label-width="100px" class="password-form">
            <el-form-item label="旧密码" prop="oldPassword">
              <el-input v-model="passwordForm.oldPassword" type="password" placeholder="请输入旧密码" show-password size="large" />
            </el-form-item>
            <el-form-item label="新密码" prop="newPassword">
              <el-input v-model="passwordForm.newPassword" type="password" placeholder="请输入新密码（至少6位）" show-password size="large" />
            </el-form-item>
            <el-form-item label="确认密码" prop="confirmPassword">
              <el-input v-model="passwordForm.confirmPassword" type="password" placeholder="请再次输入新密码" show-password size="large" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="handleChangePassword" size="large">确认修改</el-button>
              <el-button @click="resetPasswordForm" size="large">重置</el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getUserInfo, changePassword } from '../api/auth'

const userInfo = ref({})
const passwordFormRef = ref()

const passwordForm = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})

const validateConfirmPassword = (rule, value, callback) => {
  if (value !== passwordForm.newPassword) {
    callback(new Error('两次输入的密码不一致'))
  } else {
    callback()
  }
}

const passwordRules = {
  oldPassword: [
    { required: true, message: '请输入旧密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少6位', trigger: 'blur' }
  ],
  newPassword: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少6位', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认新密码', trigger: 'blur' },
    { validator: validateConfirmPassword, trigger: 'blur' }
  ]
}

const loadUserInfo = async () => {
  const res = await getUserInfo()
  if (res.code === 200) {
    userInfo.value = res.data
    localStorage.setItem('userInfo', JSON.stringify(res.data))
  }
}

const handleChangePassword = async () => {
  const valid = await passwordFormRef.value.validate().catch(() => false)
  if (!valid) return

  const res = await changePassword({
    oldPassword: passwordForm.oldPassword,
    newPassword: passwordForm.newPassword
  })

  if (res.code === 200) {
    ElMessage.success('密码修改成功，请重新登录')
    resetPasswordForm()
    setTimeout(() => {
      localStorage.removeItem('token')
      localStorage.removeItem('userInfo')
      window.location.href = '/#/login'
    }, 1500)
  } else {
    ElMessage.error(res.message || '密码修改失败')
  }
}

const resetPasswordForm = () => {
  passwordForm.oldPassword = ''
  passwordForm.newPassword = ''
  passwordForm.confirmPassword = ''
  passwordFormRef.value?.resetFields()
}

onMounted(() => {
  loadUserInfo()
})
</script>

<style scoped>
.page-header {
  margin-bottom: 24px;
}

.page-title {
  font-size: 22px;
  font-weight: 700;
  color: #1e293b;
  margin: 0 0 4px 0;
}

.page-desc {
  font-size: 14px;
  color: #94a3b8;
  margin: 0;
}

.profile-card {
  overflow: hidden;
  border-radius: 12px;
}

.profile-banner {
  height: 80px;
  background: linear-gradient(135deg, #6366f1, #8b5cf6, #06b6d4);
}

.profile-body {
  text-align: center;
  padding: 0 24px 24px;
}

.avatar-wrap {
  margin-top: -36px;
  margin-bottom: 12px;
}

.avatar {
  width: 72px;
  height: 72px;
  border-radius: 16px;
  background: linear-gradient(135deg, #6366f1, #8b5cf6);
  color: #fff;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-size: 28px;
  font-weight: 700;
  border: 4px solid #fff;
  box-shadow: 0 4px 12px rgba(99,102,241,0.3);
}

.user-name {
  font-size: 20px;
  font-weight: 600;
  color: #1e293b;
  margin: 0 0 8px;
}

.user-role {
  margin-bottom: 20px;
}

.role-badge {
  display: inline-block;
  padding: 4px 14px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 500;
}

.role-badge.admin {
  background: rgba(99,102,241,0.1);
  color: #6366f1;
}

.role-badge.teacher {
  background: rgba(16,185,129,0.1);
  color: #10b981;
}

.role-badge.student {
  background: rgba(245,158,11,0.1);
  color: #f59e0b;
}

.info-list {
  text-align: left;
  border-top: 1px solid #f1f5f9;
  padding-top: 16px;
}

.info-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #f8fafc;
}

.info-label {
  font-size: 13px;
  color: #94a3b8;
}

.info-value {
  font-size: 14px;
  color: #1e293b;
  font-weight: 500;
}

.password-card {
  border-radius: 12px;
}

.card-header {
  display: flex;
  flex-direction: column;
}

.card-title {
  font-size: 16px;
  font-weight: 600;
  color: #1e293b;
}

.card-sub {
  font-size: 13px;
  color: #94a3b8;
  margin-top: 2px;
}

.password-form {
  max-width: 400px;
  padding-top: 8px;
}

.student-info {
  padding: 8px 0;
}

.info-tips {
  margin-top: 20px;
  padding: 16px;
  background: #f8fafc;
  border-radius: 8px;
}

.info-tips h4 {
  margin: 0 0 12px 0;
  color: #1e293b;
  font-size: 14px;
}

.info-tips ul {
  margin: 0;
  padding-left: 20px;
  color: #64748b;
  font-size: 13px;
  line-height: 2;
}
</style>
