<template>
  <div class="export-management">
    <div class="page-header">
      <h2 class="page-title">数据导出与报表</h2>
      <p class="page-desc">支持Excel格式的数据导出和报表生成</p>
    </div>

    <el-row :gutter="20">
      <!-- 学生数据导出 -->
      <el-col :xs="24" :sm="12" :md="8">
        <el-card class="export-card">
          <div class="export-icon student">
            <el-icon size="40"><User /></el-icon>
          </div>
          <h3 class="export-title">学生信息导出</h3>
          <p class="export-desc">导出所有学生的基本信息，包括学号、姓名、班级、联系方式等</p>
          <el-button type="primary" @click="handleExportStudents" :loading="loading.students">
            <el-icon><Download /></el-icon>
            导出Excel
          </el-button>
        </el-card>
      </el-col>

      <!-- 成绩数据导出 -->
      <el-col :xs="24" :sm="12" :md="8">
        <el-card class="export-card">
          <div class="export-icon score">
            <el-icon size="40"><Trophy /></el-icon>
          </div>
          <h3 class="export-title">成绩数据导出</h3>
          <p class="export-desc">按班级或课程筛选导出成绩数据，支持批量导出</p>
          <div class="filter-section">
            <el-select v-model="scoreFilter.classId" placeholder="选择班级" clearable size="small">
              <el-option v-for="cls in classList" :key="cls.id" :label="cls.className" :value="cls.id" />
            </el-select>
            <el-select v-model="scoreFilter.courseId" placeholder="选择课程" clearable size="small" style="margin-top: 8px">
              <el-option v-for="course in courseList" :key="course.id" :label="course.courseName" :value="course.id" />
            </el-select>
          </div>
          <el-button type="primary" @click="handleExportScores" :loading="loading.scores">
            <el-icon><Download /></el-icon>
            导出Excel
          </el-button>
        </el-card>
      </el-col>

      <!-- 考勤数据导出 -->
      <el-col :xs="24" :sm="12" :md="8">
        <el-card class="export-card">
          <div class="export-icon attendance">
            <el-icon size="40"><Calendar /></el-icon>
          </div>
          <h3 class="export-title">考勤记录导出</h3>
          <p class="export-desc">导出考勤记录，支持按班级和日期范围筛选</p>
          <div class="filter-section">
            <el-select v-model="attendanceFilter.classId" placeholder="选择班级" clearable size="small">
              <el-option v-for="cls in classList" :key="cls.id" :label="cls.className" :value="cls.id" />
            </el-select>
            <el-date-picker
              v-model="attendanceDateRange"
              type="daterange"
              range-separator="至"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              size="small"
              style="margin-top: 8px; width: 100%"
              value-format="YYYY-MM-DD"
            />
          </div>
          <el-button type="primary" @click="handleExportAttendance" :loading="loading.attendance">
            <el-icon><Download /></el-icon>
            导出Excel
          </el-button>
        </el-card>
      </el-col>

      <!-- 预警数据导出 -->
      <el-col :xs="24" :sm="12" :md="8">
        <el-card class="export-card">
          <div class="export-icon warning">
            <el-icon size="40"><Warning /></el-icon>
          </div>
          <h3 class="export-title">学业预警导出</h3>
          <p class="export-desc">导出学业预警记录，便于分析和跟进处理</p>
          <div class="filter-section">
            <el-select v-model="warningFilter.status" placeholder="处理状态" clearable size="small">
              <el-option label="待处理" value="PENDING" />
              <el-option label="处理中" value="PROCESSING" />
              <el-option label="已解决" value="RESOLVED" />
              <el-option label="已忽略" value="IGNORED" />
            </el-select>
            <el-select v-model="warningFilter.warningLevel" placeholder="预警等级" clearable size="small" style="margin-top: 8px">
              <el-option label="黄色" value="YELLOW" />
              <el-option label="橙色" value="ORANGE" />
              <el-option label="红色" value="RED" />
            </el-select>
          </div>
          <el-button type="primary" @click="handleExportWarnings" :loading="loading.warnings">
            <el-icon><Download /></el-icon>
            导出Excel
          </el-button>
        </el-card>
      </el-col>

      <!-- 课程统计导出 -->
      <el-col :xs="24" :sm="12" :md="8">
        <el-card class="export-card">
          <div class="export-icon course">
            <el-icon size="40"><Reading /></el-icon>
          </div>
          <h3 class="export-title">课程统计导出</h3>
          <p class="export-desc">导出各课程的统计分析数据，包括平均分、及格率、优秀率等</p>
          <el-button type="primary" @click="handleExportCourseStats" :loading="loading.courseStats">
            <el-icon><Download /></el-icon>
            导出Excel
          </el-button>
        </el-card>
      </el-col>

      <!-- 个人成绩单导出 -->
      <el-col :xs="24" :sm="12" :md="8">
        <el-card class="export-card">
          <div class="export-icon personal">
            <el-icon size="40"><Document /></el-icon>
          </div>
          <h3 class="export-title">个人成绩单</h3>
          <p class="export-desc">导出指定学生的完整成绩单，包含所有课程成绩和平均分</p>
          <div class="filter-section">
            <el-select-v2
              v-model="personalFilter.studentId"
              :options="studentOptions"
              placeholder="选择学生"
              clearable
              filterable
              size="small"
              style="width: 100%"
            />
          </div>
          <el-button type="primary" @click="handleExportPersonalScores" :loading="loading.personal">
            <el-icon><Download /></el-icon>
            导出成绩单
          </el-button>
        </el-card>
      </el-col>
    </el-row>

    <!-- 导出历史记录 -->
    <el-card class="history-card" style="margin-top: 20px">
      <template #header>
        <div class="card-header">
          <span>导出说明</span>
        </div>
      </template>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="导出格式">Excel (.xlsx)</el-descriptions-item>
        <el-descriptions-item label="编码格式">UTF-8</el-descriptions-item>
        <el-descriptions-item label="数据范围">根据筛选条件动态确定</el-descriptions-item>
        <el-descriptions-item label="文件命名">自动根据导出内容生成文件名</el-descriptions-item>
        <el-descriptions-item label="注意事项" :span="2">
          1. 导出大量数据时可能需要等待片刻<br>
          2. 建议使用较新版本的Excel打开导出文件<br>
          3. 如需导出PDF格式，可使用Excel的另存为功能转换
        </el-descriptions-item>
      </el-descriptions>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage } from 'element-plus'
import { User, Trophy, Calendar, Warning, Reading, Document, Download } from '@element-plus/icons-vue'
import {
  exportStudents as apiExportStudents,
  exportScores as apiExportScores,
  exportAttendance as apiExportAttendance,
  exportWarnings as apiExportWarnings,
  exportCourseStats as apiExportCourseStats,
  exportStudentScores as apiExportStudentScores
} from '../api/export'
import { getClassList } from '../api/class'
import { getCourseList } from '../api/course'
import { getStudentList } from '../api/student'

const loading = reactive({
  students: false,
  scores: false,
  attendance: false,
  warnings: false,
  courseStats: false,
  personal: false
})

const classList = ref([])
const courseList = ref([])
const studentList = ref([])

const scoreFilter = reactive({
  classId: null,
  courseId: null
})

const attendanceFilter = reactive({
  classId: null,
  startDate: '',
  endDate: ''
})

const attendanceDateRange = computed({
  get: () => {
    if (attendanceFilter.startDate && attendanceFilter.endDate) {
      return [attendanceFilter.startDate, attendanceFilter.endDate]
    }
    return []
  },
  set: (val) => {
    if (val && val.length === 2) {
      attendanceFilter.startDate = val[0]
      attendanceFilter.endDate = val[1]
    } else {
      attendanceFilter.startDate = ''
      attendanceFilter.endDate = ''
    }
  }
})

const warningFilter = reactive({
  status: '',
  warningLevel: ''
})

const personalFilter = reactive({
  studentId: null
})

const studentOptions = computed(() => {
  return studentList.value.map(s => ({
    value: s.id,
    label: `${s.studentNo} - ${s.name}`
  }))
})

const downloadFile = (blob, fileName) => {
  const url = window.URL.createObjectURL(new Blob([blob]))
  const link = document.createElement('a')
  link.href = url
  link.setAttribute('download', fileName + '.xlsx')
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
  window.URL.revokeObjectURL(url)
}

const handleExportStudents = async () => {
  loading.students = true
  try {
    const res = await apiExportStudents()
    downloadFile(res, '学生信息表')
    ElMessage.success('导出成功')
  } catch (error) {
    ElMessage.error('导出失败')
  } finally {
    loading.students = false
  }
}

const handleExportScores = async () => {
  loading.scores = true
  try {
    const res = await apiExportScores(scoreFilter)
    const fileName = scoreFilter.classId || scoreFilter.courseId ? '筛选成绩表' : '成绩表'
    downloadFile(res, fileName)
    ElMessage.success('导出成功')
  } catch (error) {
    ElMessage.error('导出失败')
  } finally {
    loading.scores = false
  }
}

const handleExportAttendance = async () => {
  loading.attendance = true
  try {
    const res = await apiExportAttendance(attendanceFilter)
    downloadFile(res, '考勤记录表')
    ElMessage.success('导出成功')
  } catch (error) {
    ElMessage.error('导出失败')
  } finally {
    loading.attendance = false
  }
}

const handleExportWarnings = async () => {
  loading.warnings = true
  try {
    const res = await apiExportWarnings(warningFilter)
    downloadFile(res, '学业预警表')
    ElMessage.success('导出成功')
  } catch (error) {
    ElMessage.error('导出失败')
  } finally {
    loading.warnings = false
  }
}

const handleExportCourseStats = async () => {
  loading.courseStats = true
  try {
    const res = await apiExportCourseStats()
    downloadFile(res, '课程成绩统计表')
    ElMessage.success('导出成功')
  } catch (error) {
    ElMessage.error('导出失败')
  } finally {
    loading.courseStats = false
  }
}

const handleExportPersonalScores = async () => {
  if (!personalFilter.studentId) {
    ElMessage.warning('请选择学生')
    return
  }
  loading.personal = true
  try {
    const res = await apiExportStudentScores(personalFilter.studentId)
    const student = studentList.value.find(s => s.id === personalFilter.studentId)
    const fileName = student ? `${student.name}的成绩单` : '成绩单'
    downloadFile(res, fileName)
    ElMessage.success('导出成功')
  } catch (error) {
    ElMessage.error('导出失败')
  } finally {
    loading.personal = false
  }
}

const loadData = async () => {
  try {
    const [classRes, courseRes, studentRes] = await Promise.all([
      getClassList(),
      getCourseList(),
      getStudentList({ pageNum: 1, pageSize: 9999 })
    ])
    if (classRes.code === 200) classList.value = classRes.data
    if (courseRes.code === 200) courseList.value = courseRes.data
    if (studentRes.code === 200) studentList.value = studentRes.data?.list || studentRes.data || []
  } catch (error) {
    console.error('加载数据失败:', error)
  }
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.export-management {
  padding: 0;
}

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

.export-card {
  margin-bottom: 20px;
  text-align: center;
  transition: all 0.3s;
}

.export-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 24px -8px rgba(0, 0, 0, 0.15);
}

.export-icon {
  width: 80px;
  height: 80px;
  border-radius: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 16px;
  color: #fff;
}

.export-icon.student {
  background: linear-gradient(135deg, #0d9488, #14b8a6);
}

.export-icon.score {
  background: linear-gradient(135deg, #f59e0b, #fbbf24);
}

.export-icon.attendance {
  background: linear-gradient(135deg, #10b981, #34d399);
}

.export-icon.warning {
  background: linear-gradient(135deg, #ef4444, #f87171);
}

.export-icon.course {
  background: linear-gradient(135deg, #0891b2, #22d3ee);
}

.export-icon.personal {
  background: linear-gradient(135deg, #06b6d4, #22d3ee);
}

.export-title {
  font-size: 16px;
  font-weight: 600;
  color: #1e293b;
  margin: 0 0 8px 0;
}

.export-desc {
  font-size: 13px;
  color: #64748b;
  margin: 0 0 16px 0;
  min-height: 40px;
}

.filter-section {
  margin-bottom: 16px;
}

.history-card {
  border-radius: 12px;
}

.card-header {
  font-weight: 600;
  color: #1e293b;
}

@media (max-width: 768px) {
  .export-card {
    margin-bottom: 12px;
  }
}
</style>
