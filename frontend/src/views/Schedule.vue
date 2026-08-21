<template>
  <div class="schedule-management">
    <div class="page-header">
      <h2 class="page-title">智能排课系统</h2>
      <p class="page-desc">基于优先级和约束条件的智能课程安排</p>
    </div>

    <!-- 操作栏 -->
    <el-card class="filter-card">
      <el-form :model="filterForm" inline>
        <el-form-item label="学年">
          <el-select v-model="filterForm.academicYear" placeholder="选择学年" style="width: 140px">
            <el-option label="2023-2024" value="2023-2024" />
            <el-option label="2024-2025" value="2024-2025" />
          </el-select>
        </el-form-item>
        <el-form-item label="学期">
          <el-select v-model="filterForm.semester" placeholder="选择学期" style="width: 120px">
            <el-option label="上学期" value="上学期" />
            <el-option label="下学期" value="下学期" />
          </el-select>
        </el-form-item>
        <el-form-item label="班级">
          <el-select v-model="filterForm.classId" placeholder="选择班级" clearable style="width: 150px">
            <el-option v-for="cls in classList" :key="cls.id" :label="cls.className" :value="cls.id" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="loadSchedules">
            <el-icon><Search /></el-icon>
            查询
          </el-button>
          <el-button @click="resetFilter">重置</el-button>
        </el-form-item>
        <el-form-item style="margin-left: auto">
          <el-button type="success" @click="showAddDialog">
            <el-icon><Plus /></el-icon>
            手动排课
          </el-button>
          <el-button type="warning" @click="showClassCourseDialog">
            <el-icon><Setting /></el-icon>
            班级课程设置
          </el-button>
          <el-button type="info" @click="showTeacherPreferenceDialog">
            <el-icon><User /></el-icon>
            教师偏好
          </el-button>
          <el-button type="danger" @click="autoSchedule" :loading="autoScheduling">
            <el-icon><MagicStick /></el-icon>
            智能排课
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 课表展示 -->
    <el-card class="timetable-card" style="margin-top: 20px">
      <template #header>
        <div class="card-header">
          <span>班级课表</span>
          <el-radio-group v-model="viewMode" size="small">
            <el-radio-button value="timetable">课表视图</el-radio-button>
            <el-radio-button value="list">列表视图</el-radio-button>
          </el-radio-group>
        </div>
      </template>

      <!-- 课表视图 -->
      <div v-if="viewMode === 'timetable'" class="timetable-view">
        <div class="timetable-header">
          <div class="time-column">时间</div>
          <div v-for="day in weekDays" :key="day.value" class="day-column">{{ day.label }}</div>
        </div>
        <div class="timetable-body">
          <div v-for="slot in timeSlots" :key="slot.value" class="timetable-row">
            <div class="time-column">{{ slot.label }}</div>
            <div v-for="day in weekDays" :key="day.value" class="day-column">
              <div v-if="getSchedule(day.value, slot.value)" class="course-cell"
                   :style="{ backgroundColor: getCourseColor(getSchedule(day.value, slot.value).courseId) }">
                <div class="course-name">{{ getSchedule(day.value, slot.value).courseName }}</div>
                <div class="course-info">{{ getSchedule(day.value, slot.value).teacherName }}</div>
                <div class="course-room">{{ getSchedule(day.value, slot.value).roomCode }}</div>
                <el-button type="danger" link size="small" @click="deleteSchedule(getSchedule(day.value, slot.value))">
                  删除
                </el-button>
              </div>
              <div v-else class="empty-cell" @click="quickAdd(day.value, slot.value)">
                <el-icon><Plus /></el-icon>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 列表视图 -->
      <el-table v-else :data="scheduleList" v-loading="loading" stripe>
        <el-table-column type="index" width="50" />
        <el-table-column label="课程" min-width="150">
          <template #default="{ row }">
            <div class="course-name">{{ row.courseName }}</div>
            <div class="course-code">{{ row.courseCode }}</div>
          </template>
        </el-table-column>
        <el-table-column label="班级" width="120">
          <template #default="{ row }">
            {{ row.className }}
          </template>
        </el-table-column>
        <el-table-column label="教师" width="100">
          <template #default="{ row }">
            {{ row.teacherName }}
          </template>
        </el-table-column>
        <el-table-column label="教室" width="120">
          <template #default="{ row }">
            <div>{{ row.building }}</div>
            <div class="room-code">{{ row.roomCode }}</div>
          </template>
        </el-table-column>
        <el-table-column label="时间" min-width="150">
          <template #default="{ row }">
            <div>周{{ weekDayMap[row.dayOfWeek] }} 第{{ row.startSlot }}-{{ row.endSlot }}节</div>
            <div class="weeks">周次: {{ row.weeks }}</div>
          </template>
        </el-table-column>
        <el-table-column label="类型" width="100">
          <template #default="{ row }">
            <el-tag :type="row.scheduleType === 'AUTO' ? 'success' : 'primary'">
              {{ row.scheduleType === 'AUTO' ? '自动' : '手动' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link size="small" @click="editSchedule(row)">编辑</el-button>
            <el-button type="danger" link size="small" @click="deleteSchedule(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 添加/编辑课程安排对话框 -->
    <el-dialog v-model="dialogVisible" :title="form.id ? '编辑课程安排' : '添加课程安排'" width="500px">
      <el-form :model="form" label-width="100px" :rules="rules" ref="formRef">
        <el-form-item label="课程" prop="courseId">
          <el-select v-model="form.courseId" placeholder="选择课程" style="width: 100%" @change="onCourseChange">
            <el-option v-for="course in courseList" :key="course.id" :label="course.courseName" :value="course.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="班级" prop="classId">
          <el-select v-model="form.classId" placeholder="选择班级" style="width: 100%">
            <el-option v-for="cls in classList" :key="cls.id" :label="cls.className" :value="cls.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="教室" prop="classroomId">
          <el-select v-model="form.classroomId" placeholder="选择教室" style="width: 100%">
            <el-option v-for="room in classroomList" :key="room.id" :label="`${room.building} ${room.roomCode} (${room.capacity}人)`" :value="room.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="星期" prop="dayOfWeek">
          <el-select v-model="form.dayOfWeek" placeholder="选择星期" style="width: 100%">
            <el-option v-for="day in weekDays" :key="day.value" :label="day.label" :value="day.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="节次" prop="startSlot">
          <el-select v-model="form.startSlot" placeholder="开始节次" style="width: 48%">
            <el-option v-for="i in 12" :key="i" :label="`第${i}节`" :value="i" />
          </el-select>
          <span style="margin: 0 2%">-</span>
          <el-select v-model="form.endSlot" placeholder="结束节次" style="width: 48%">
            <el-option v-for="i in 12" :key="i" :label="`第${i}节`" :value="i" />
          </el-select>
        </el-form-item>
        <el-form-item label="周次" prop="weeks">
          <el-input v-model="form.weeks" placeholder="如: 1-16" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveSchedule" :loading="saving">保存</el-button>
      </template>
    </el-dialog>

    <!-- 班级课程设置对话框 -->
    <el-dialog v-model="classCourseDialogVisible" title="班级课程设置" width="900px">
      <div class="dialog-toolbar">
        <el-select v-model="selectedClassForCourse" placeholder="选择班级筛选" clearable style="width: 150px; margin-right: 10px">
          <el-option v-for="cls in classList" :key="cls.id" :label="cls.className" :value="cls.id" />
        </el-select>
        <el-button type="primary" @click="showAddClassCourseDialog">
          <el-icon><Plus /></el-icon>
          添加课程
        </el-button>
      </div>
      <el-table :data="filteredClassCourses" style="margin-top: 15px" v-loading="classCourseLoading" stripe>
        <el-table-column type="index" width="50" />
        <el-table-column label="班级" prop="className" width="120" />
        <el-table-column label="课程" min-width="150">
          <template #default="{ row }">
            <div>{{ row.courseName }}</div>
            <div class="course-code">{{ row.courseCode }}</div>
          </template>
        </el-table-column>
        <el-table-column label="周课时" prop="weeklyHours" width="80" />
        <el-table-column label="连堂" width="80">
          <template #default="{ row }">
            {{ row.isConsecutive == 1 ? row.consecutiveCount + '节' : '否' }}
          </template>
        </el-table-column>
        <el-table-column label="优先级" width="90">
          <template #default="{ row }">
            <el-rate v-model="row.priority" :max="10" disabled />
          </template>
        </el-table-column>
        <el-table-column label="教室要求" width="120">
          <template #default="{ row }">
            <el-tag size="small">{{ roomTypeMap[row.requiredRoomType] }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="固定时间" min-width="120">
          <template #default="{ row }">
            <span v-if="row.fixedDays">周{{ formatFixedDays(row.fixedDays) }}</span>
            <span v-if="row.fixedSlots"> {{ row.fixedSlots }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link size="small" @click="editClassCourse(row)">编辑</el-button>
            <el-button type="danger" link size="small" @click="deleteClassCourse(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-dialog>

    <!-- 添加/编辑班级课程对话框 -->
    <el-dialog v-model="classCourseFormVisible" :title="classCourseForm.id ? '编辑班级课程' : '添加班级课程'" width="550px">
      <el-form :model="classCourseForm" label-width="120px" :rules="classCourseRules" ref="classCourseFormRef">
        <el-form-item label="班级" prop="classId">
          <el-select v-model="classCourseForm.classId" placeholder="选择班级" style="width: 100%">
            <el-option v-for="cls in classList" :key="cls.id" :label="cls.className" :value="cls.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="课程" prop="courseId">
          <el-select v-model="classCourseForm.courseId" placeholder="选择课程" style="width: 100%">
            <el-option v-for="course in courseList" :key="course.id" :label="course.courseName" :value="course.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="每周课时" prop="weeklyHours">
          <el-input-number v-model="classCourseForm.weeklyHours" :min="1" :max="10" />
        </el-form-item>
        <el-form-item label="是否连堂">
          <el-switch v-model="classCourseForm.isConsecutive" :active-value="1" :inactive-value="0" />
        </el-form-item>
        <el-form-item label="连堂节数" v-if="classCourseForm.isConsecutive == 1">
          <el-input-number v-model="classCourseForm.consecutiveCount" :min="2" :max="4" />
        </el-form-item>
        <el-form-item label="优先级" prop="priority">
          <el-slider v-model="classCourseForm.priority" :min="1" :max="10" show-stops />
        </el-form-item>
        <el-form-item label="教室类型">
          <el-select v-model="classCourseForm.requiredRoomType" placeholder="选择教室类型" style="width: 100%">
            <el-option label="普通教室" value="NORMAL" />
            <el-option label="多媒体教室" value="MEDIA" />
            <el-option label="实验室" value="LAB" />
          </el-select>
        </el-form-item>
        <el-form-item label="最少容量">
          <el-input-number v-model="classCourseForm.minCapacity" :min="0" :max="200" />
        </el-form-item>
        <el-form-item label="固定星期">
          <el-checkbox-group v-model="selectedFixedDays">
            <el-checkbox label="1">周一</el-checkbox>
            <el-checkbox label="2">周二</el-checkbox>
            <el-checkbox label="3">周三</el-checkbox>
            <el-checkbox label="4">周四</el-checkbox>
            <el-checkbox label="5">周五</el-checkbox>
          </el-checkbox-group>
        </el-form-item>
        <el-form-item label="固定时间段">
          <el-select v-model="classCourseForm.fixedSlots" placeholder="选择时间段" clearable style="width: 100%">
            <el-option label="1-2节" value="1-2" />
            <el-option label="3-4节" value="3-4" />
            <el-option label="5-6节" value="5-6" />
            <el-option label="7-8节" value="7-8" />
            <el-option label="9-10节" value="9-10" />
          </el-select>
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="classCourseForm.remark" type="textarea" rows="2" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="classCourseFormVisible = false">取消</el-button>
        <el-button type="primary" @click="saveClassCourse" :loading="savingClassCourse">保存</el-button>
      </template>
    </el-dialog>

    <!-- 教师偏好设置对话框 -->
    <el-dialog v-model="teacherPrefDialogVisible" title="教师偏好设置" width="900px">
      <el-table :data="teacherPreferenceList" v-loading="teacherPrefLoading" stripe>
        <el-table-column type="index" width="50" />
        <el-table-column label="教师" prop="teacherName" width="100" />
        <el-table-column label="偏好星期" min-width="120">
          <template #default="{ row }">
            <span v-if="row.preferredDays">周{{ formatFixedDays(row.preferredDays) }}</span>
            <span v-else class="text-gray">未设置</span>
          </template>
        </el-table-column>
        <el-table-column label="偏好时间" min-width="120">
          <template #default="{ row }">
            {{ row.preferredSlots || '未设置' }}
          </template>
        </el-table-column>
        <el-table-column label="避免时间" min-width="120">
          <template #default="{ row }">
            <span v-if="row.avoidedDays">周{{ formatFixedDays(row.avoidedDays) }}</span>
            <span v-if="row.avoidedSlots"> {{ row.avoidedSlots }}</span>
          </template>
        </el-table-column>
        <el-table-column label="日/周课时上限" width="120">
          <template #default="{ row }">
            {{ row.maxDailyHours || 4 }} / {{ row.maxWeeklyHours || 16 }}
          </template>
        </el-table-column>
        <el-table-column label="允许连堂" width="90">
          <template #default="{ row }">
            <el-tag :type="row.allowConsecutive ? 'success' : 'danger'">
              {{ row.allowConsecutive ? '是' : '否' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link size="small" @click="editTeacherPreference(row)">编辑</el-button>
            <el-button type="danger" link size="small" @click="deleteTeacherPreference(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div style="margin-top: 15px">
        <el-button type="primary" @click="showAddTeacherPrefDialog">
          <el-icon><Plus /></el-icon>
          添加教师偏好
        </el-button>
      </div>
    </el-dialog>

    <!-- 添加/编辑教师偏好对话框 -->
    <el-dialog v-model="teacherPrefFormVisible" :title="teacherPrefForm.id ? '编辑教师偏好' : '添加教师偏好'" width="550px">
      <el-form :model="teacherPrefForm" label-width="120px" :rules="teacherPrefRules" ref="teacherPrefFormRef">
        <el-form-item label="教师" prop="teacherId">
          <el-select v-model="teacherPrefForm.teacherId" placeholder="选择教师" style="width: 100%">
            <el-option v-for="teacher in teacherList" :key="teacher.id" :label="teacher.realName" :value="teacher.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="偏好星期">
          <el-checkbox-group v-model="selectedPreferredDays">
            <el-checkbox label="1">周一</el-checkbox>
            <el-checkbox label="2">周二</el-checkbox>
            <el-checkbox label="3">周三</el-checkbox>
            <el-checkbox label="4">周四</el-checkbox>
            <el-checkbox label="5">周五</el-checkbox>
          </el-checkbox-group>
        </el-form-item>
        <el-form-item label="偏好时间段">
          <el-select v-model="teacherPrefForm.preferredSlots" placeholder="选择时间段" clearable style="width: 100%">
            <el-option label="1-2节" value="1-2" />
            <el-option label="3-4节" value="3-4" />
            <el-option label="5-6节" value="5-6" />
            <el-option label="7-8节" value="7-8" />
            <el-option label="9-10节" value="9-10" />
          </el-select>
        </el-form-item>
        <el-form-item label="避免星期">
          <el-checkbox-group v-model="selectedAvoidedDays">
            <el-checkbox label="1">周一</el-checkbox>
            <el-checkbox label="2">周二</el-checkbox>
            <el-checkbox label="3">周三</el-checkbox>
            <el-checkbox label="4">周四</el-checkbox>
            <el-checkbox label="5">周五</el-checkbox>
          </el-checkbox-group>
        </el-form-item>
        <el-form-item label="避免时间段">
          <el-select v-model="teacherPrefForm.avoidedSlots" placeholder="选择时间段" clearable style="width: 100%">
            <el-option label="1-2节" value="1-2" />
            <el-option label="3-4节" value="3-4" />
            <el-option label="5-6节" value="5-6" />
            <el-option label="7-8节" value="7-8" />
            <el-option label="9-10节" value="9-10" />
          </el-select>
        </el-form-item>
        <el-form-item label="每天最多课时">
          <el-input-number v-model="teacherPrefForm.maxDailyHours" :min="1" :max="8" />
        </el-form-item>
        <el-form-item label="每周最多课时">
          <el-input-number v-model="teacherPrefForm.maxWeeklyHours" :min="1" :max="20" />
        </el-form-item>
        <el-form-item label="允许连堂">
          <el-switch v-model="teacherPrefForm.allowConsecutive" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="teacherPrefForm.remark" type="textarea" rows="2" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="teacherPrefFormVisible = false">取消</el-button>
        <el-button type="primary" @click="saveTeacherPreference" :loading="savingTeacherPref">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Search, MagicStick, Setting, User } from '@element-plus/icons-vue'
import {
  getSchedules, addSchedule, updateSchedule, deleteSchedule as apiDeleteSchedule,
  autoSchedule as apiAutoSchedule, getActiveClassrooms,
  getClassCourses, getAllClassCourses, addClassCourse, updateClassCourse, deleteClassCourse as apiDeleteClassCourse,
  getTeacherPreferences, addTeacherPreference, updateTeacherPreference, deleteTeacherPreference as apiDeleteTeacherPref
} from '../api/schedule'
import { getCourseList } from '../api/course'
import { getClassList } from '../api/class'
import { getUserList, getUsersByRole } from '../api/user'

const loading = ref(false)
const autoScheduling = ref(false)
const saving = ref(false)
const viewMode = ref('timetable')
const dialogVisible = ref(false)

const weekDays = [
  { label: '周一', value: 1 },
  { label: '周二', value: 2 },
  { label: '周三', value: 3 },
  { label: '周四', value: 4 },
  { label: '周五', value: 5 }
]

const weekDayMap = { 1: '一', 2: '二', 3: '三', 4: '四', 5: '五', 6: '六', 7: '日' }

const roomTypeMap = {
  'NORMAL': '普通教室',
  'MEDIA': '多媒体',
  'LAB': '实验室'
}

const timeSlots = [
  { label: '1-2节', value: 1 },
  { label: '3-4节', value: 3 },
  { label: '5-6节', value: 5 },
  { label: '7-8节', value: 7 },
  { label: '9-10节', value: 9 },
  { label: '11-12节', value: 11 }
]

const filterForm = reactive({
  academicYear: '2023-2024',
  semester: '上学期',
  classId: null
})

const scheduleList = ref([])
const courseList = ref([])
const classList = ref([])
const classroomList = ref([])
const teacherList = ref([])

// 课程颜色映射
const courseColors = {}
const colorPalette = ['#0d9488', '#10b981', '#f59e0b', '#ef4444', '#0891b2', '#06b6d4', '#f97316', '#84cc16']

const getCourseColor = (courseId) => {
  if (!courseColors[courseId]) {
    courseColors[courseId] = colorPalette[Object.keys(courseColors).length % colorPalette.length]
  }
  return courseColors[courseId]
}

const formRef = ref()
const form = reactive({
  id: null,
  courseId: null,
  classId: null,
  classroomId: null,
  dayOfWeek: 1,
  startSlot: 1,
  endSlot: 2,
  weeks: '1-16'
})

const rules = {
  courseId: [{ required: true, message: '请选择课程', trigger: 'change' }],
  classId: [{ required: true, message: '请选择班级', trigger: 'change' }],
  classroomId: [{ required: true, message: '请选择教室', trigger: 'change' }],
  dayOfWeek: [{ required: true, message: '请选择星期', trigger: 'change' }],
  startSlot: [{ required: true, message: '请选择开始节次', trigger: 'change' }],
  endSlot: [{ required: true, message: '请选择结束节次', trigger: 'change' }],
  weeks: [{ required: true, message: '请输入周次', trigger: 'blur' }]
}

const getSchedule = (day, slot) => {
  return scheduleList.value.find(s => s.dayOfWeek === day && s.startSlot === slot)
}

const loadSchedules = async () => {
  if (!filterForm.classId) {
    ElMessage.warning('请选择班级')
    return
  }
  loading.value = true
  try {
    const res = await getSchedules(filterForm)
    if (res.code === 200) {
      scheduleList.value = res.data || []
    }
  } catch (error) {
    ElMessage.error('加载课表失败')
  } finally {
    loading.value = false
  }
}

const resetFilter = () => {
  filterForm.classId = null
  scheduleList.value = []
}

const loadData = async () => {
  try {
    const [courseRes, classRes, roomRes] = await Promise.all([
      getCourseList(),
      getClassList(),
      getActiveClassrooms()
    ])
    if (courseRes.code === 200) courseList.value = courseRes.data
    if (classRes.code === 200) classList.value = classRes.data
    if (roomRes.code === 200) classroomList.value = roomRes.data
    
    try {
      const userRes = await getUserList()
      if (userRes.code === 200) {
        teacherList.value = userRes.data?.filter(u => u.role === 'teacher') || []
      }
    } catch (error) {
      try {
        const teacherRes = await getUsersByRole('teacher')
        if (teacherRes.code === 200) {
          teacherList.value = teacherRes.data || []
        }
      } catch (e) {
        console.error('加载教师列表失败:', e)
      }
    }
  } catch (error) {
    console.error('加载数据失败:', error)
  }
}

const showAddDialog = () => {
  form.id = null
  form.courseId = null
  form.classId = filterForm.classId
  form.classroomId = null
  form.dayOfWeek = 1
  form.startSlot = 1
  form.endSlot = 2
  form.weeks = '1-16'
  dialogVisible.value = true
}

const quickAdd = (day, slot) => {
  if (!filterForm.classId) {
    ElMessage.warning('请先选择班级')
    return
  }
  form.id = null
  form.courseId = null
  form.classId = filterForm.classId
  form.classroomId = null
  form.dayOfWeek = day
  form.startSlot = slot
  form.endSlot = slot + 1
  form.weeks = '1-16'
  dialogVisible.value = true
}

const onCourseChange = (courseId) => {
  const course = courseList.value.find(c => c.id === courseId)
  if (course && course.teacherId) {
    // 自动填充教师信息（如果需要）
  }
}

const editSchedule = (row) => {
  Object.assign(form, row)
  dialogVisible.value = true
}

const saveSchedule = async () => {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return

  saving.value = true
  try {
    if (form.id) {
      await updateSchedule(form.id, form)
    } else {
      await addSchedule(form)
    }
    ElMessage.success('保存成功')
    dialogVisible.value = false
    loadSchedules()
  } catch (error) {
    ElMessage.error(error.response?.data?.message || '保存失败')
  } finally {
    saving.value = false
  }
}

const deleteSchedule = (row) => {
  ElMessageBox.confirm('确定删除该课程安排吗？', '提示', { type: 'warning' })
    .then(async () => {
      try {
        await apiDeleteSchedule(row.id)
        ElMessage.success('删除成功')
        loadSchedules()
      } catch (error) {
        ElMessage.error('删除失败')
      }
    })
}

const autoSchedule = async () => {
  if (!filterForm.academicYear || !filterForm.semester) {
    ElMessage.warning('请先选择学年和学期')
    return
  }
  autoScheduling.value = true
  try {
    const res = await apiAutoSchedule({
      academicYear: filterForm.academicYear,
      semester: filterForm.semester
    })
    if (res.code === 200) {
      const count = res.data?.scheduledCount || 0
      if (count > 0) {
        ElMessage.success(`智能排课完成，成功安排 ${count} 门课程`)
        if (filterForm.classId) {
          loadSchedules()
        } else if (classList.value.length > 0) {
          filterForm.classId = classList.value[0].id
          loadSchedules()
        }
      } else {
        ElMessage.warning('排课完成但未安排任何课程，请检查班级课程设置和教师分配')
      }
    }
  } catch (error) {
    ElMessage.error('智能排课失败')
  } finally {
    autoScheduling.value = false
  }
}

// ==================== 班级课程管理 ====================

const classCourseDialogVisible = ref(false)
const classCourseFormVisible = ref(false)
const classCourseLoading = ref(false)
const savingClassCourse = ref(false)
const selectedClassForCourse = ref(null)
const classCourseList = ref([])
const selectedFixedDays = ref([])

const classCourseFormRef = ref()
const classCourseForm = reactive({
  id: null,
  classId: null,
  courseId: null,
  weeklyHours: 2,
  isConsecutive: 1,
  consecutiveCount: 2,
  priority: 5,
  requiredRoomType: 'NORMAL',
  minCapacity: 0,
  fixedDays: null,
  fixedSlots: null,
  remark: ''
})

const classCourseRules = {
  classId: [{ required: true, message: '请选择班级', trigger: 'change' }],
  courseId: [{ required: true, message: '请选择课程', trigger: 'change' }],
  weeklyHours: [{ required: true, message: '请输入每周课时', trigger: 'blur' }],
  priority: [{ required: true, message: '请设置优先级', trigger: 'change' }]
}

const filteredClassCourses = computed(() => {
  if (selectedClassForCourse.value) {
    return classCourseList.value.filter(c => c.classId === selectedClassForCourse.value)
  }
  return classCourseList.value
})

const formatFixedDays = (days) => {
  if (!days) return ''
  return days.split(',').map(d => weekDayMap[d]).join('、')
}

const showClassCourseDialog = async () => {
  classCourseDialogVisible.value = true
  await loadClassCourses()
}

const loadClassCourses = async () => {
  classCourseLoading.value = true
  try {
    const res = await getAllClassCourses()
    if (res.code === 200) {
      classCourseList.value = res.data || []
    }
  } catch (error) {
    ElMessage.error('加载班级课程失败')
  } finally {
    classCourseLoading.value = false
  }
}

const showAddClassCourseDialog = () => {
  classCourseForm.id = null
  classCourseForm.classId = null
  classCourseForm.courseId = null
  classCourseForm.weeklyHours = 2
  classCourseForm.isConsecutive = 1
  classCourseForm.consecutiveCount = 2
  classCourseForm.priority = 5
  classCourseForm.requiredRoomType = 'NORMAL'
  classCourseForm.minCapacity = 0
  classCourseForm.fixedDays = null
  classCourseForm.fixedSlots = null
  classCourseForm.remark = ''
  selectedFixedDays.value = []
  classCourseFormVisible.value = true
}

const editClassCourse = (row) => {
  Object.assign(classCourseForm, row)
  selectedFixedDays.value = row.fixedDays ? row.fixedDays.split(',') : []
  classCourseFormVisible.value = true
}

const saveClassCourse = async () => {
  const valid = await classCourseFormRef.value.validate().catch(() => false)
  if (!valid) return

  classCourseForm.fixedDays = selectedFixedDays.value.join(',')
  savingClassCourse.value = true
  try {
    if (classCourseForm.id) {
      await updateClassCourse(classCourseForm.id, classCourseForm)
    } else {
      await addClassCourse(classCourseForm)
    }
    ElMessage.success('保存成功')
    classCourseFormVisible.value = false
    loadClassCourses()
  } catch (error) {
    ElMessage.error(error.response?.data?.message || '保存失败')
  } finally {
    savingClassCourse.value = false
  }
}

const deleteClassCourse = (row) => {
  ElMessageBox.confirm('确定删除该班级课程配置吗？', '提示', { type: 'warning' })
    .then(async () => {
      try {
        await apiDeleteClassCourse(row.id)
        ElMessage.success('删除成功')
        loadClassCourses()
      } catch (error) {
        ElMessage.error('删除失败')
      }
    })
}

// ==================== 教师偏好管理 ====================

const teacherPrefDialogVisible = ref(false)
const teacherPrefFormVisible = ref(false)
const teacherPrefLoading = ref(false)
const savingTeacherPref = ref(false)
const teacherPreferenceList = ref([])
const selectedPreferredDays = ref([])
const selectedAvoidedDays = ref([])

const teacherPrefFormRef = ref()
const teacherPrefForm = reactive({
  id: null,
  teacherId: null,
  preferredDays: null,
  preferredSlots: null,
  avoidedDays: null,
  avoidedSlots: null,
  maxDailyHours: 4,
  maxWeeklyHours: 16,
  allowConsecutive: true,
  remark: ''
})

const teacherPrefRules = {
  teacherId: [{ required: true, message: '请选择教师', trigger: 'change' }]
}

const showTeacherPreferenceDialog = async () => {
  teacherPrefDialogVisible.value = true
  await loadTeacherPreferences()
}

const loadTeacherPreferences = async () => {
  teacherPrefLoading.value = true
  try {
    const res = await getTeacherPreferences()
    if (res.code === 200) {
      teacherPreferenceList.value = res.data || []
    }
  } catch (error) {
    ElMessage.error('加载教师偏好失败')
  } finally {
    teacherPrefLoading.value = false
  }
}

const showAddTeacherPrefDialog = () => {
  teacherPrefForm.id = null
  teacherPrefForm.teacherId = null
  teacherPrefForm.preferredDays = null
  teacherPrefForm.preferredSlots = null
  teacherPrefForm.avoidedDays = null
  teacherPrefForm.avoidedSlots = null
  teacherPrefForm.maxDailyHours = 4
  teacherPrefForm.maxWeeklyHours = 16
  teacherPrefForm.allowConsecutive = true
  teacherPrefForm.remark = ''
  selectedPreferredDays.value = []
  selectedAvoidedDays.value = []
  teacherPrefFormVisible.value = true
}

const editTeacherPreference = (row) => {
  Object.assign(teacherPrefForm, row)
  selectedPreferredDays.value = row.preferredDays ? row.preferredDays.split(',') : []
  selectedAvoidedDays.value = row.avoidedDays ? row.avoidedDays.split(',') : []
  teacherPrefFormVisible.value = true
}

const saveTeacherPreference = async () => {
  const valid = await teacherPrefFormRef.value.validate().catch(() => false)
  if (!valid) return

  teacherPrefForm.preferredDays = selectedPreferredDays.value.join(',')
  teacherPrefForm.avoidedDays = selectedAvoidedDays.value.join(',')
  savingTeacherPref.value = true
  try {
    if (teacherPrefForm.id) {
      await updateTeacherPreference(teacherPrefForm.id, teacherPrefForm)
    } else {
      await addTeacherPreference(teacherPrefForm)
    }
    ElMessage.success('保存成功')
    teacherPrefFormVisible.value = false
    loadTeacherPreferences()
  } catch (error) {
    ElMessage.error(error.response?.data?.message || '保存失败')
  } finally {
    savingTeacherPref.value = false
  }
}

const deleteTeacherPreference = (row) => {
  ElMessageBox.confirm('确定删除该教师偏好吗？', '提示', { type: 'warning' })
    .then(async () => {
      try {
        await apiDeleteTeacherPref(row.id)
        ElMessage.success('删除成功')
        loadTeacherPreferences()
      } catch (error) {
        ElMessage.error('删除失败')
      }
    })
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.schedule-management {
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

.filter-card {
  border-radius: 12px;
}

.timetable-card {
  border-radius: 12px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.timetable-view {
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  overflow: hidden;
}

.timetable-header {
  display: flex;
  background: #f8fafc;
  border-bottom: 1px solid #e2e8f0;
}

.timetable-row {
  display: flex;
  border-bottom: 1px solid #e2e8f0;
}

.timetable-row:last-child {
  border-bottom: none;
}

.time-column {
  width: 80px;
  padding: 12px;
  text-align: center;
  font-weight: 600;
  color: #64748b;
  background: #f8fafc;
  border-right: 1px solid #e2e8f0;
  display: flex;
  align-items: center;
  justify-content: center;
}

.day-column {
  flex: 1;
  min-height: 100px;
  padding: 8px;
  border-right: 1px solid #e2e8f0;
}

.day-column:last-child {
  border-right: none;
}

.course-cell {
  padding: 8px;
  border-radius: 6px;
  color: #fff;
  text-align: center;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.course-name {
  font-weight: 600;
  font-size: 13px;
  margin-bottom: 4px;
}

.course-info {
  font-size: 11px;
  opacity: 0.9;
}

.course-room {
  font-size: 11px;
  opacity: 0.8;
  margin-top: 2px;
}

.empty-cell {
  height: 100%;
  min-height: 84px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #cbd5e1;
  cursor: pointer;
  border-radius: 6px;
  transition: all 0.2s;
}

.empty-cell:hover {
  background: #f1f5f9;
  color: #94a3b8;
}

.course-code {
  font-size: 12px;
  color: #64748b;
}

.room-code {
  font-size: 12px;
  color: #64748b;
}

.weeks {
  font-size: 12px;
  color: #94a3b8;
}

.dialog-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.text-gray {
  color: #94a3b8;
}

@media (max-width: 768px) {
  .timetable-view {
    overflow-x: auto;
  }

  .timetable-header,
  .timetable-row {
    min-width: 600px;
  }
}
</style>
