package com.example.student.service.impl;

import com.example.student.entity.*;
import com.example.student.mapper.*;
import com.example.student.service.CourseScheduleService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

/**
 * 智能排课服务 - 优化版
 * 支持：优先级排序、教师偏好、教室容量匹配、连堂课程、固定时间约束
 */
@Slf4j
@Service
public class SmartScheduleServiceImpl implements CourseScheduleService {

    @Autowired
    private ClassroomMapper classroomMapper;

    @Autowired
    private CourseScheduleMapper courseScheduleMapper;

    @Autowired
    private CourseMapper courseMapper;

    @Autowired
    private ClassMapper classMapper;

    @Autowired
    private ClassCourseMapper classCourseMapper;

    @Autowired
    private TeacherPreferenceMapper teacherPreferenceMapper;

    // 时间段配置
    private static final int[] TIME_SLOTS = {1, 3, 5, 7, 9, 11}; // 1-2节, 3-4节, 5-6节, 7-8节, 9-10节, 11-12节
    private static final int DAYS_PER_WEEK = 5; // 周一到周五

    // 排课结果统计
    private static class ScheduleResult {
        int successCount = 0;
        int failCount = 0;
        List<String> failReasons = new ArrayList<>();

        void addSuccess() {
            successCount++;
        }

        void addFail(String reason) {
            failCount++;
            failReasons.add(reason);
        }
    }

    @Override
    @Transactional
    public int autoSchedule(String academicYear, String semester) {
        log.info("开始智能排课: {} {}", academicYear, semester);

        // 清除该学期的自动排课数据
        courseScheduleMapper.deleteByTerm(academicYear, semester);

        // 获取所有班级课程配置
        List<ClassCourse> classCourses = classCourseMapper.findAll();
        if (classCourses.isEmpty()) {
            log.warn("没有配置班级课程");
            return 0;
        }

        // 获取所有教室
        List<Classroom> classrooms = classroomMapper.findAllActive();
        if (classrooms.isEmpty()) {
            log.warn("没有可用教室");
            return 0;
        }

        // 获取所有教师偏好
        Map<Integer, TeacherPreference> teacherPreferences = teacherPreferenceMapper.findAll()
                .stream().collect(Collectors.toMap(TeacherPreference::getTeacherId, p -> p));

        // 按优先级排序（高优先级先排）
        classCourses.sort((a, b) -> b.getPriority().compareTo(a.getPriority()));

        log.info("获取到 {} 个班级课程配置", classCourses.size());
        for (ClassCourse cc : classCourses) {
            log.info("  班级课程: classId={}, courseId={}, className={}, courseName={}, weeklyHours={}, consecutiveCount={}",
                    cc.getClassId(), cc.getCourseId(), cc.getClassName(), cc.getCourseName(), 
                    cc.getWeeklyHours(), cc.getConsecutiveCount());
        }

        ScheduleResult result = new ScheduleResult();

        // 记录已使用的资源
        Set<String> usedSlots = new HashSet<>(); // 格式: "classId-day-slot"
        Set<String> usedTeacherSlots = new HashSet<>(); // 格式: "teacherId-day-slot"
        Set<String> usedClassroomSlots = new HashSet<>(); // 格式: "classroomId-day-slot"
        Map<Integer, Integer> teacherDailyHours = new HashMap<>(); // 教师当天课时
        Map<Integer, Integer> teacherWeeklyHours = new HashMap<>(); // 教师本周课时

        // 将数据库中已有的手动排课（非 AUTO）加载进占用集合，
        // 避免自动排课与手动安排产生冲突（deleteByTerm 只清理 AUTO 安排）
        List<CourseSchedule> existingSchedules = courseScheduleMapper.findByCondition(academicYear, semester, null, null);
        for (CourseSchedule schedule : existingSchedules) {
            if ("AUTO".equals(schedule.getScheduleType())) {
                continue;
            }
            int endSlot = schedule.getEndSlot() != null ? schedule.getEndSlot() : schedule.getStartSlot();
            for (int i = schedule.getStartSlot(); i <= endSlot; i++) {
                usedSlots.add(getSlotKey(schedule.getClassId(), schedule.getDayOfWeek(), i));
                usedTeacherSlots.add(getSlotKey(schedule.getTeacherId(), schedule.getDayOfWeek(), i));
                if (schedule.getClassroomId() != null) {
                    usedClassroomSlots.add(getSlotKey(schedule.getClassroomId(), schedule.getDayOfWeek(), i));
                }
            }
        }
        if (!existingSchedules.isEmpty()) {
            log.info("已加载 {} 条已有安排（含手动安排）作为冲突基准", existingSchedules.size());
        }

        for (ClassCourse classCourse : classCourses) {
            try {
                boolean scheduled = scheduleClassCourse(
                        classCourse, academicYear, semester, classrooms,
                        teacherPreferences, usedSlots, usedTeacherSlots, usedClassroomSlots,
                        teacherDailyHours, teacherWeeklyHours);

                if (scheduled) {
                    result.addSuccess();
                } else {
                    result.addFail("无法为 " + classCourse.getClassName() + " 的 " + classCourse.getCourseName() + " 找到合适的时间段");
                }
            } catch (Exception e) {
                log.error("排课失败: {} - {}", classCourse.getClassName(), classCourse.getCourseName(), e);
                result.addFail(e.getMessage());
            }
        }

        log.info("智能排课完成: 成功 {}, 失败 {}", result.successCount, result.failCount);
        if (!result.failReasons.isEmpty()) {
            log.warn("排课失败原因: {}", result.failReasons);
        }

        return result.successCount;
    }

    /**
     * 为单个班级课程安排时间
     */
    private boolean scheduleClassCourse(ClassCourse classCourse, String academicYear, String semester,
                                       List<Classroom> classrooms, Map<Integer, TeacherPreference> teacherPreferences,
                                       Set<String> usedSlots, Set<String> usedTeacherSlots, Set<String> usedClassroomSlots,
                                       Map<Integer, Integer> teacherDailyHours, Map<Integer, Integer> teacherWeeklyHours) {

        log.info("尝试排课: {} - {}", classCourse.getClassName(), classCourse.getCourseName());
        
        Course course = courseMapper.findById(classCourse.getCourseId());
        if (course == null || course.getTeacherId() == null) {
            log.warn("课程 {} 没有分配教师", classCourse.getCourseName());
            return false;
        }

        Integer teacherId = course.getTeacherId();
        TeacherPreference preference = teacherPreferences.get(teacherId);

        // 增加空值保护，防止数据库字段为 null 导致计算异常
        int weeklyHours = classCourse.getWeeklyHours() != null ? classCourse.getWeeklyHours() : 2;
        int consecutiveCount = classCourse.getConsecutiveCount() != null && classCourse.getConsecutiveCount() > 0 
                ? classCourse.getConsecutiveCount() : 1;

        // 计算需要安排的次数（每周课时数 / 每次节数）
        int sessionsPerWeek = weeklyHours / consecutiveCount;
        int sessionDuration = consecutiveCount; // 每次连堂节数

        if (sessionsPerWeek < 1) {
            log.warn("课程 {} 的周课时数 {} 小于连堂节数 {}，无法安排", 
                    classCourse.getCourseName(), weeklyHours, consecutiveCount);
            return false;
        }

        log.info("排课参数: sessionsPerWeek={}, sessionDuration={}", sessionsPerWeek, sessionDuration);

        // 获取可用的时间段（考虑固定时间约束）
        List<TimeSlot> availableSlots = getAvailableTimeSlots(
                classCourse, preference, usedSlots, usedTeacherSlots, usedClassroomSlots,
                teacherDailyHours, teacherWeeklyHours, teacherId, classrooms);

        if (availableSlots.size() < sessionsPerWeek) {
            log.warn("{} - {} 可用时间段不足: 需要 {}, 实际 {}",
                    classCourse.getClassName(), classCourse.getCourseName(), sessionsPerWeek, availableSlots.size());
            return false;
        }

        // 按评分排序时间段（优先选择评分高的）
        availableSlots.sort((a, b) -> Double.compare(b.score, a.score));

        // 安排课程
        int scheduledCount = 0;
        for (TimeSlot slot : availableSlots) {
            if (scheduledCount >= sessionsPerWeek) break;

            // 选择合适的教室
            Classroom classroom = selectClassroom(classrooms, classCourse, slot, usedClassroomSlots);
            if (classroom == null) continue;

            // 创建课程安排
            CourseSchedule schedule = new CourseSchedule();
            schedule.setCourseId(classCourse.getCourseId());
            schedule.setClassId(classCourse.getClassId());
            schedule.setTeacherId(teacherId);
            schedule.setClassroomId(classroom.getId());
            schedule.setAcademicYear(academicYear);
            schedule.setSemester(semester);
            schedule.setDayOfWeek(slot.day);
            schedule.setStartSlot(slot.startSlot);
            schedule.setEndSlot(slot.startSlot + sessionDuration - 1);
            schedule.setWeeks("1-16");
            schedule.setScheduleType("AUTO");
            schedule.setStatus(1);

            courseScheduleMapper.insert(schedule);

            // 标记资源已使用
            for (int i = 0; i < sessionDuration; i++) {
                int currentSlot = slot.startSlot + i;
                usedSlots.add(getSlotKey(classCourse.getClassId(), slot.day, currentSlot));
                usedTeacherSlots.add(getSlotKey(teacherId, slot.day, currentSlot));
                usedClassroomSlots.add(getSlotKey(classroom.getId(), slot.day, currentSlot));
            }

            // 更新教师课时统计
            teacherDailyHours.merge(getDailyKey(teacherId, slot.day), sessionDuration, Integer::sum);
            teacherWeeklyHours.merge(teacherId, sessionDuration, Integer::sum);

            scheduledCount++;
            log.debug("已安排: {} - {} 周{} 第{}-{}节 教室{}",
                    classCourse.getClassName(), classCourse.getCourseName(),
                    slot.day, slot.startSlot, slot.startSlot + sessionDuration - 1,
                    classroom.getRoomCode());
        }

        return scheduledCount == sessionsPerWeek;
    }

    /**
     * 获取可用的时间段列表
     */
    private List<TimeSlot> getAvailableTimeSlots(ClassCourse classCourse, TeacherPreference preference,
                                                  Set<String> usedSlots, Set<String> usedTeacherSlots,
                                                  Set<String> usedClassroomSlots, Map<Integer, Integer> teacherDailyHours,
                                                  Map<Integer, Integer> teacherWeeklyHours, Integer teacherId,
                                                  List<Classroom> classrooms) {
        List<TimeSlot> slots = new ArrayList<>();

        // 解析固定时间约束
        Set<Integer> fixedDays = parseDays(classCourse.getFixedDays());
        Set<Integer> fixedSlots = parseSlots(classCourse.getFixedSlots());

        // 解析教师偏好
        Set<Integer> preferredDays = preference != null ? parseDays(preference.getPreferredDays()) : new HashSet<>();
        Set<Integer> preferredSlots = preference != null ? parseSlots(preference.getPreferredSlots()) : new HashSet<>();
        Set<Integer> avoidedDays = preference != null ? parseDays(preference.getAvoidedDays()) : new HashSet<>();
        Set<Integer> avoidedSlots = preference != null ? parseSlots(preference.getAvoidedSlots()) : new HashSet<>();

        int maxDailyHours = preference != null && preference.getMaxDailyHours() != null ?
                preference.getMaxDailyHours() : 4;
        int maxWeeklyHours = preference != null && preference.getMaxWeeklyHours() != null ?
                preference.getMaxWeeklyHours() : 16;

        int sessionDuration = classCourse.getConsecutiveCount();

        for (int day = 1; day <= DAYS_PER_WEEK; day++) {
            // 检查是否是避免的星期
            if (avoidedDays.contains(day)) continue;

            // 检查教师当天课时是否超限
            int currentDailyHours = teacherDailyHours.getOrDefault(getDailyKey(teacherId, day), 0);
            if (currentDailyHours + sessionDuration > maxDailyHours) continue;

            for (int startSlot : TIME_SLOTS) {
                int endSlot = startSlot + sessionDuration - 1;
                if (endSlot > 12) continue; // 超出最大节次

                // 检查是否是固定的时间段
                if (!fixedSlots.isEmpty() && !fixedSlots.contains(startSlot)) continue;

                // 检查是否是避免的时间段
                boolean hasAvoidedSlot = false;
                for (int i = 0; i < sessionDuration; i++) {
                    if (avoidedSlots.contains(startSlot + i)) {
                        hasAvoidedSlot = true;
                        break;
                    }
                }
                if (hasAvoidedSlot) continue;

                // 检查冲突
                boolean hasConflict = false;
                for (int i = 0; i < sessionDuration; i++) {
                    int currentSlot = startSlot + i;
                    if (usedSlots.contains(getSlotKey(classCourse.getClassId(), day, currentSlot)) ||
                        usedTeacherSlots.contains(getSlotKey(teacherId, day, currentSlot))) {
                        hasConflict = true;
                        break;
                    }
                }
                if (hasConflict) continue;

                // 检查是否有可用教室
                final int finalDay = day;
                final int finalStartSlot = startSlot;
                boolean hasAvailableClassroom = classrooms.stream()
                        .filter(c -> isClassroomSuitable(c, classCourse))
                        .anyMatch(c -> {
                            for (int i = 0; i < sessionDuration; i++) {
                                if (usedClassroomSlots.contains(getSlotKey(c.getId(), finalDay, finalStartSlot + i))) {
                                    return false;
                                }
                            }
                            return true;
                        });
                if (!hasAvailableClassroom) continue;

                // 计算时间段评分
                double score = calculateSlotScore(day, startSlot, preferredDays, preferredSlots,
                        fixedDays, fixedSlots, currentDailyHours);

                slots.add(new TimeSlot(day, startSlot, score));
            }
        }

        return slots;
    }

    /**
     * 选择最合适的教室
     */
    private Classroom selectClassroom(List<Classroom> classrooms, ClassCourse classCourse,
                                     TimeSlot slot, Set<String> usedClassroomSlots) {
        int sessionDuration = classCourse.getConsecutiveCount();

        return classrooms.stream()
                .filter(c -> isClassroomSuitable(c, classCourse))
                .filter(c -> {
                    for (int i = 0; i < sessionDuration; i++) {
                        if (usedClassroomSlots.contains(getSlotKey(c.getId(), slot.day, slot.startSlot + i))) {
                            return false;
                        }
                    }
                    return true;
                })
                .min(Comparator.comparingInt(Classroom::getCapacity)) // 选择容量最小的合适教室
                .orElse(null);
    }

    /**
     * 检查教室是否适合该课程
     */
    private boolean isClassroomSuitable(Classroom classroom, ClassCourse classCourse) {
        // 检查教室类型
        if (classCourse.getRequiredRoomType() != null &&
                !classCourse.getRequiredRoomType().equals(classroom.getRoomType())) {
            return false;
        }

        // 检查教室容量
        if (classCourse.getMinCapacity() != null &&
                classroom.getCapacity() < classCourse.getMinCapacity()) {
            return false;
        }

        return true;
    }

    /**
     * 计算时间段评分（分数越高越优先）
     */
    private double calculateSlotScore(int day, int startSlot, Set<Integer> preferredDays,
                                     Set<Integer> preferredSlots, Set<Integer> fixedDays,
                                     Set<Integer> fixedSlots, int currentDailyHours) {
        double score = 100.0;

        // 固定时间加分
        if (fixedDays.contains(day)) score += 50;
        if (fixedSlots.contains(startSlot)) score += 50;

        // 偏好时间加分
        if (preferredDays.contains(day)) score += 20;
        if (preferredSlots.contains(startSlot)) score += 20;

        // 上午时间段加分（优先上午）
        if (startSlot <= 4) score += 10;
        else if (startSlot <= 6) score += 5;

        // 分散课时加分（避免同一天太多课）
        score -= currentDailyHours * 5;

        return score;
    }

    /**
     * 解析星期字符串（如 "1,3,5"）
     */
    private Set<Integer> parseDays(String daysStr) {
        Set<Integer> days = new HashSet<>();
        if (daysStr == null || daysStr.trim().isEmpty()) return days;

        for (String day : daysStr.split(",")) {
            try {
                days.add(Integer.parseInt(day.trim()));
            } catch (NumberFormatException ignored) {}
        }
        return days;
    }

    /**
     * 解析时间段字符串（如 "1-2,3-4"）
     */
    private Set<Integer> parseSlots(String slotsStr) {
        Set<Integer> slots = new HashSet<>();
        if (slotsStr == null || slotsStr.trim().isEmpty()) return slots;

        for (String slot : slotsStr.split(",")) {
            try {
                slots.add(Integer.parseInt(slot.trim().split("-")[0]));
            } catch (NumberFormatException ignored) {}
        }
        return slots;
    }

    private String getSlotKey(Integer resourceId, int day, int slot) {
        return resourceId + "-" + day + "-" + slot;
    }

    private int getDailyKey(Integer teacherId, int day) {
        return teacherId * 10 + day;
    }

    // 时间段内部类
    private static class TimeSlot {
        int day;
        int startSlot;
        double score;

        TimeSlot(int day, int startSlot, double score) {
            this.day = day;
            this.startSlot = startSlot;
            this.score = score;
        }
    }

    // ========== 原有接口实现 ==========

    @Override
    public List<Classroom> getAllClassrooms() {
        return classroomMapper.findAll();
    }

    @Override
    public List<Classroom> getActiveClassrooms() {
        return classroomMapper.findAllActive();
    }

    @Override
    public Classroom getClassroomById(Integer id) {
        return classroomMapper.findById(id);
    }

    @Override
    public boolean addClassroom(Classroom classroom) {
        return classroomMapper.insert(classroom) > 0;
    }

    @Override
    public boolean updateClassroom(Classroom classroom) {
        return classroomMapper.update(classroom) > 0;
    }

    @Override
    public boolean deleteClassroom(Integer id) {
        return classroomMapper.deleteById(id) > 0;
    }

    @Override
    public List<CourseSchedule> getSchedules(String academicYear, String semester, Integer classId, Integer teacherId) {
        return courseScheduleMapper.findByCondition(academicYear, semester, classId, teacherId);
    }

    @Override
    public CourseSchedule getScheduleById(Integer id) {
        return courseScheduleMapper.findById(id);
    }

    @Override
    public boolean addSchedule(CourseSchedule schedule) {
        schedule.setStatus(1);
        return courseScheduleMapper.insert(schedule) > 0;
    }

    @Override
    public boolean updateSchedule(CourseSchedule schedule) {
        return courseScheduleMapper.update(schedule) > 0;
    }

    @Override
    public boolean deleteSchedule(Integer id) {
        return courseScheduleMapper.deleteById(id) > 0;
    }

    @Override
    public Map<String, Object> checkConflict(CourseSchedule schedule) {
        Map<String, Object> result = new HashMap<>();

        int classroomConflict = courseScheduleMapper.checkClassroomConflict(
                schedule.getClassroomId(), schedule.getDayOfWeek(), schedule.getStartSlot(), schedule.getEndSlot(),
                schedule.getAcademicYear(), schedule.getSemester());

        int teacherConflict = courseScheduleMapper.checkTeacherConflict(
                schedule.getTeacherId(), schedule.getDayOfWeek(), schedule.getStartSlot(), schedule.getEndSlot(),
                schedule.getAcademicYear(), schedule.getSemester());

        int classConflict = checkClassConflict(schedule.getClassId(), schedule.getDayOfWeek(),
                schedule.getStartSlot(), schedule.getEndSlot(),
                schedule.getAcademicYear(), schedule.getSemester());

        result.put("hasConflict", classroomConflict > 0 || teacherConflict > 0 || classConflict > 0);
        result.put("classroomConflict", classroomConflict > 0);
        result.put("teacherConflict", teacherConflict > 0);
        result.put("classConflict", classConflict > 0);

        return result;
    }

    private int checkClassConflict(Integer classId, Integer dayOfWeek, Integer startSlot, Integer endSlot,
                                   String academicYear, String semester) {
        List<CourseSchedule> existing = courseScheduleMapper.findByCondition(academicYear, semester, classId, null);
        for (CourseSchedule schedule : existing) {
            if (schedule.getDayOfWeek().equals(dayOfWeek)) {
                int existingStart = schedule.getStartSlot();
                int existingEnd = schedule.getEndSlot();
                if ((existingStart <= startSlot && existingEnd >= startSlot) ||
                    (existingStart <= endSlot && existingEnd >= endSlot)) {
                    return 1;
                }
            }
        }
        return 0;
    }

    @Override
    public List<List<CourseSchedule>> getClassTimetable(Integer classId, String academicYear, String semester) {
        List<CourseSchedule> schedules = courseScheduleMapper.findByCondition(academicYear, semester, classId, null);
        List<List<CourseSchedule>> timetable = new ArrayList<>();
        for (int i = 0; i < 5; i++) {
            List<CourseSchedule> daySchedule = new ArrayList<>();
            for (int j = 0; j < 6; j++) {
                daySchedule.add(null);
            }
            timetable.add(daySchedule);
        }
        for (CourseSchedule schedule : schedules) {
            int dayIndex = schedule.getDayOfWeek() - 1;
            int slotIndex = (schedule.getStartSlot() - 1) / 2;
            if (dayIndex >= 0 && dayIndex < 5 && slotIndex >= 0 && slotIndex < 6) {
                timetable.get(dayIndex).set(slotIndex, schedule);
            }
        }
        return timetable;
    }
}
