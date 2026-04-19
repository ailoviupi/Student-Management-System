<template>
  <div class="my-class-page">
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">我的班级</h1>
        <p class="page-subtitle">查看班级信息和同学列表</p>
      </div>
    </div>

    <!-- 班级信息卡片 -->
    <div class="class-info-section" v-if="classInfo">
      <el-card class="class-card">
        <div class="class-header">
          <div class="class-icon">
            <el-icon><School /></el-icon>
          </div>
          <div class="class-title">
            <h2>{{ classInfo.className }}</h2>
            <p class="class-subtitle">{{ classInfo.grade }}级 · {{ classInfo.major }}</p>
          </div>
        </div>
        <div class="class-details">
          <div class="detail-item">
            <span class="label">班主任：</span>
            <span class="value">{{ classInfo.teacherName || '暂无' }}</span>
          </div>
          <div class="detail-item">
            <span class="label">班级人数：</span>
            <span class="value">{{ classmates.length + 1 }}人</span>
          </div>
        </div>
      </el-card>
    </div>

    <!-- 同学列表 -->
    <div class="classmates-section">
      <div class="section-header">
        <h3 class="section-title">
          <el-icon><User /></el-icon>
          同学列表
        </h3>
        <el-input
          v-model="searchKeyword"
          placeholder="搜索同学姓名"
          size="small"
          clearable
          style="width: 200px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
      </div>

      <div class="classmates-grid">
        <div class="classmate-card" v-for="student in filteredClassmates" :key="student.id">
          <div class="classmate-avatar">
            {{ student.name[0] }}
          </div>
          <div class="classmate-info">
            <h4 class="classmate-name">{{ student.name }}</h4>
            <p class="classmate-no">{{ student.studentNo }}</p>
          </div>
          <div class="classmate-tag">
            <el-tag size="small" :type="student.gender === '男' ? 'primary' : 'danger'">
              {{ student.gender }}
            </el-tag>
          </div>
        </div>
      </div>

      <el-empty v-if="filteredClassmates.length === 0" description="暂无同学数据" />
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { School, User, Search } from '@element-plus/icons-vue'
import { getMyClass, getMyClassmates } from '../../api/class'

const classInfo = ref(null)
const classmates = ref([])
const searchKeyword = ref('')

const filteredClassmates = computed(() => {
  if (!searchKeyword.value) return classmates.value
  return classmates.value.filter(s => 
    s.name.includes(searchKeyword.value) || 
    s.studentNo.includes(searchKeyword.value)
  )
})

const fetchData = async () => {
  try {
    const [classRes, classmatesRes] = await Promise.all([
      getMyClass(),
      getMyClassmates()
    ])
    
    if (classRes.code === 200) {
      classInfo.value = classRes.data
    }
    
    if (classmatesRes.code === 200) {
      classmates.value = classmatesRes.data || []
    }
  } catch (error) {
    ElMessage.error('获取班级数据失败')
  }
}

onMounted(() => {
  fetchData()
})
</script>

<style scoped>
.my-class-page {
  padding: 0;
}

.page-header {
  margin-bottom: 24px;
}

.page-title {
  font-size: 24px;
  font-weight: 600;
  color: #1e293b;
  margin: 0 0 8px 0;
}

.page-subtitle {
  font-size: 14px;
  color: #64748b;
  margin: 0;
}

.class-info-section {
  margin-bottom: 24px;
}

.class-card {
  border-radius: 12px;
}

.class-header {
  display: flex;
  align-items: center;
  gap: 20px;
  margin-bottom: 20px;
}

.class-icon {
  width: 64px;
  height: 64px;
  border-radius: 16px;
  background: linear-gradient(135deg, #6366f1, #8b5cf6);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 32px;
}

.class-title h2 {
  font-size: 20px;
  font-weight: 600;
  color: #1e293b;
  margin: 0 0 4px 0;
}

.class-subtitle {
  font-size: 14px;
  color: #64748b;
  margin: 0;
}

.class-details {
  display: flex;
  gap: 40px;
  padding-top: 16px;
  border-top: 1px solid #f1f5f9;
}

.detail-item {
  display: flex;
  align-items: center;
  gap: 8px;
}

.label {
  font-size: 14px;
  color: #64748b;
}

.value {
  font-size: 14px;
  font-weight: 500;
  color: #1e293b;
}

.classmates-section {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.section-title {
  font-size: 16px;
  font-weight: 600;
  color: #1e293b;
  margin: 0;
  display: flex;
  align-items: center;
  gap: 8px;
}

.classmates-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 16px;
}

.classmate-card {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px;
  background: #f8fafc;
  border-radius: 10px;
  border: 1px solid #e2e8f0;
  transition: all 0.3s;
}

.classmate-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  transform: translateY(-2px);
}

.classmate-avatar {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  background: linear-gradient(135deg, #6366f1, #8b5cf6);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
  font-weight: 600;
}

.classmate-info {
  flex: 1;
}

.classmate-name {
  font-size: 14px;
  font-weight: 600;
  color: #1e293b;
  margin: 0 0 2px 0;
}

.classmate-no {
  font-size: 12px;
  color: #94a3b8;
  margin: 0;
}

@media (max-width: 768px) {
  .classmates-grid {
    grid-template-columns: 1fr;
  }
  
  .class-details {
    flex-direction: column;
    gap: 12px;
  }
}
</style>
