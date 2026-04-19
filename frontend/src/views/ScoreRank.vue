<template>
  <div class="score-rank">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>成绩排名</span>
        </div>
      </template>

      <el-tabs v-model="activeTab">
        <el-tab-pane label="课程排名" name="course">
          <el-form inline>
            <el-form-item label="选择课程">
              <el-select v-model="selectedCourse" placeholder="请选择课程" style="width: 250px" @change="loadCourseRank">
                <el-option v-for="item in courseList" :key="item.id" :label="item.courseName" :value="item.id" />
              </el-select>
            </el-form-item>
          </el-form>

          <el-table :data="courseRankData" border v-loading="loading">
            <el-table-column type="index" label="排名" width="80" />
            <el-table-column prop="studentNo" label="学号" width="120" />
            <el-table-column prop="studentName" label="姓名" width="100" />
            <el-table-column prop="className" label="班级" width="150" />
            <el-table-column prop="courseName" label="课程" min-width="150" />
            <el-table-column prop="score" label="成绩" width="100">
              <template #default="{ row }">
                <el-tag :type="getScoreType(row.score)">{{ row.score }}</el-tag>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>

        <el-tab-pane label="综合排名" name="overall">
          <el-table :data="overallRankData" border v-loading="loading">
            <el-table-column type="index" label="排名" width="80" />
            <el-table-column prop="studentNo" label="学号" width="120" />
            <el-table-column prop="studentName" label="姓名" width="100" />
            <el-table-column prop="className" label="班级" width="150" />
            <el-table-column prop="totalCourses" label="课程数" width="100" />
            <el-table-column prop="averageScore" label="平均分" width="100">
              <template #default="{ row }">
                <el-tag :type="getScoreType(row.averageScore)">{{ row.averageScore?.toFixed(2) }}</el-tag>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getCourseList } from '../api/course'
import { getCourseRank, getOverallRank } from '../api/score'

const activeTab = ref('course')
const selectedCourse = ref('')
const courseList = ref([])
const courseRankData = ref([])
const overallRankData = ref([])
const loading = ref(false)

const getScoreType = (score) => {
  if (score >= 90) return 'success'
  if (score >= 60) return 'warning'
  return 'danger'
}

const loadCourses = async () => {
  const res = await getCourseList()
  if (res.code === 200) {
    courseList.value = res.data
    if (courseList.value.length > 0) {
      selectedCourse.value = courseList.value[0].id
      loadCourseRank()
    }
  }
}

const loadCourseRank = async () => {
  if (!selectedCourse.value) return
  loading.value = true
  try {
    const res = await getCourseRank(selectedCourse.value)
    if (res.code === 200) {
      courseRankData.value = res.data
    }
  } finally {
    loading.value = false
  }
}

const loadOverallRank = async () => {
  loading.value = true
  try {
    const res = await getOverallRank()
    if (res.code === 200) {
      overallRankData.value = res.data
    }
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadCourses()
  loadOverallRank()
})
</script>

<style scoped>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

/* 移动端表格横向滚动 */
:deep(.el-table) {
  width: 100%;
}

:deep(.el-table__body-wrapper) {
  overflow-x: auto;
}

@media (max-width: 768px) {
  :deep(.el-form-item__label) {
    font-size: 12px;
  }
  
  :deep(.el-select) {
    width: 100% !important;
  }
  
  :deep(.el-form--inline .el-form-item) {
    margin-right: 0;
    width: 100%;
  }
  
  :deep(.el-form--inline .el-form-item__content) {
    width: calc(100% - 70px);
  }
}
</style>
