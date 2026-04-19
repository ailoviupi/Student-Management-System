<template>
  <div class="settings">
    <div class="page-header">
      <h2 class="page-title">系统设置</h2>
      <p class="page-desc">管理系统基础配置参数</p>
    </div>

    <el-row :gutter="20">
      <el-col :span="16">
        <el-card class="settings-card">
          <template #header>
            <div class="card-header">
              <span class="card-title">基础设置</span>
              <el-button type="primary" @click="handleSave" :loading="saving">
                <el-icon><Check /></el-icon>保存设置
              </el-button>
            </div>
          </template>

          <el-form :model="form" label-width="140px" class="settings-form">
            <el-divider content-position="left">学校信息</el-divider>
            
            <el-form-item label="学校名称">
              <el-input v-model="form.school_name" placeholder="请输入学校名称" />
            </el-form-item>
            
            <el-form-item label="学校地址">
              <el-input v-model="form.school_address" placeholder="请输入学校地址" />
            </el-form-item>
            
            <el-form-item label="联系电话">
              <el-input v-model="form.school_phone" placeholder="请输入联系电话" />
            </el-form-item>

            <el-divider content-position="left">学期设置</el-divider>
            
            <el-form-item label="当前学期">
              <el-input v-model="form.current_semester" placeholder="例如：2024-2025学年第一学期" />
            </el-form-item>

            <el-divider content-position="left">成绩设置</el-divider>
            
            <el-form-item label="及格分数线">
              <el-input-number v-model="form.pass_score" :min="0" :max="100" />
              <span class="form-tip">分以下视为不及格</span>
            </el-form-item>
            
            <el-form-item label="优秀分数线">
              <el-input-number v-model="form.excellent_score" :min="0" :max="100" />
              <span class="form-tip">分及以上视为优秀</span>
            </el-form-item>

            <el-divider content-position="left">考勤设置</el-divider>
            
            <el-form-item label="考勤预警天数">
              <el-input-number v-model="form.attendance_warning_days" :min="1" :max="30" />
              <span class="form-tip">天内缺勤超过此天数将预警</span>
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>

      <el-col :span="8">
        <el-card class="info-card">
          <template #header>
            <div class="card-header">
              <span class="card-title">系统信息</span>
            </div>
          </template>
          <div class="info-list">
            <div class="info-item">
              <span class="info-label">系统版本</span>
              <el-tag type="info">{{ form.system_version }}</el-tag>
            </div>
            <div class="info-item">
              <span class="info-label">数据库</span>
              <el-tag type="success">MySQL 5.7</el-tag>
            </div>
            <div class="info-item">
              <span class="info-label">后端框架</span>
              <el-tag type="primary">Spring Boot 2.7</el-tag>
            </div>
            <div class="info-item">
              <span class="info-label">前端框架</span>
              <el-tag type="warning">Vue 3 + Vite</el-tag>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Check } from '@element-plus/icons-vue'
import { getSettingsMap, updateSetting } from '../api/settings'

const form = reactive({
  school_name: '',
  school_address: '',
  school_phone: '',
  current_semester: '',
  pass_score: 60,
  excellent_score: 90,
  attendance_warning_days: 3,
  system_version: 'v1.0.0'
})

const saving = ref(false)

const loadSettings = async () => {
  const res = await getSettingsMap()
  if (res.code === 200) {
    Object.keys(form).forEach(key => {
      if (res.data[key] !== undefined) {
        if (key === 'pass_score' || key === 'excellent_score' || key === 'attendance_warning_days') {
          form[key] = parseInt(res.data[key]) || form[key]
        } else {
          form[key] = res.data[key]
        }
      }
    })
  }
}

const handleSave = async () => {
  saving.value = true
  try {
    const keys = ['school_name', 'school_address', 'school_phone', 'current_semester', 
                  'pass_score', 'excellent_score', 'attendance_warning_days']
    for (const key of keys) {
      await updateSetting(key, String(form[key]))
    }
    ElMessage.success('设置保存成功')
  } catch (error) {
    ElMessage.error('保存失败')
  } finally {
    saving.value = false
  }
}

onMounted(() => {
  loadSettings()
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

.settings-card,
.info-card {
  border-radius: 12px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-title {
  font-size: 16px;
  font-weight: 600;
  color: #1e293b;
}

.settings-form {
  padding: 8px 16px;
}

:deep(.el-divider__text) {
  font-size: 13px;
  color: #64748b;
  font-weight: 500;
}

.form-tip {
  margin-left: 12px;
  color: #94a3b8;
  font-size: 13px;
}

.info-list {
  padding: 8px 0;
}

.info-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 0;
  border-bottom: 1px solid #f1f5f9;
}

.info-item:last-child {
  border-bottom: none;
}

.info-label {
  font-size: 14px;
  color: #64748b;
}
</style>
