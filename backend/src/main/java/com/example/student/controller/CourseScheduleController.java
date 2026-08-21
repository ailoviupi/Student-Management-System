package com.example.student.controller;

import com.example.student.common.RequireRole;
import com.example.student.common.Result;
import com.example.student.entity.ClassCourse;
import com.example.student.entity.Classroom;
import com.example.student.entity.CourseSchedule;
import com.example.student.entity.TeacherPreference;
import com.example.student.service.CourseScheduleService;
import com.example.student.mapper.ClassCourseMapper;
import com.example.student.mapper.TeacherPreferenceMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/schedule")
@RequireRole({"admin", "teacher"})
public class CourseScheduleController {

    @Autowired
    private CourseScheduleService courseScheduleService;

    @Autowired
    private ClassCourseMapper classCourseMapper;

    @Autowired
    private TeacherPreferenceMapper teacherPreferenceMapper;

    // ============== 教室管理 ==============

    @GetMapping("/classrooms")
    public Result<List<Classroom>> getAllClassrooms() {
        return Result.success(courseScheduleService.getAllClassrooms());
    }

    @GetMapping("/classrooms/active")
    public Result<List<Classroom>> getActiveClassrooms() {
        return Result.success(courseScheduleService.getActiveClassrooms());
    }

    @PostMapping("/classrooms")
    public Result<Void> addClassroom(@RequestBody Classroom classroom) {
        return courseScheduleService.addClassroom(classroom) ? Result.success() : Result.error("添加失败");
    }

    @PutMapping("/classrooms/{id}")
    public Result<Void> updateClassroom(@PathVariable Integer id, @RequestBody Classroom classroom) {
        classroom.setId(id);
        return courseScheduleService.updateClassroom(classroom) ? Result.success() : Result.error("更新失败");
    }

    @DeleteMapping("/classrooms/{id}")
    public Result<Void> deleteClassroom(@PathVariable Integer id) {
        return courseScheduleService.deleteClassroom(id) ? Result.success() : Result.error("删除失败");
    }

    // ============== 课程安排 ==============

    @GetMapping("/list")
    public Result<List<CourseSchedule>> getSchedules(
            @RequestParam(required = false) String academicYear,
            @RequestParam(required = false) String semester,
            @RequestParam(required = false) Integer classId,
            @RequestParam(required = false) Integer teacherId) {
        return Result.success(courseScheduleService.getSchedules(academicYear, semester, classId, teacherId));
    }

    @PostMapping
    public Result<Void> addSchedule(@RequestBody CourseSchedule schedule) {
        Map<String, Object> conflict = courseScheduleService.checkConflict(schedule);
        if ((Boolean) conflict.get("hasConflict")) {
            return Result.error("课程安排存在冲突，请检查教室或教师时间");
        }
        return courseScheduleService.addSchedule(schedule) ? Result.success() : Result.error("添加失败");
    }

    @PutMapping("/{id}")
    public Result<Void> updateSchedule(@PathVariable Integer id, @RequestBody CourseSchedule schedule) {
        schedule.setId(id);
        Map<String, Object> conflict = courseScheduleService.checkConflict(schedule);
        if ((Boolean) conflict.get("hasConflict")) {
            return Result.error("课程安排存在冲突，请检查教室或教师时间");
        }
        return courseScheduleService.updateSchedule(schedule) ? Result.success() : Result.error("更新失败");
    }

    @DeleteMapping("/{id}")
    public Result<Void> deleteSchedule(@PathVariable Integer id) {
        return courseScheduleService.deleteSchedule(id) ? Result.success() : Result.error("删除失败");
    }

    // ============== 自动排课 ==============

    @PostMapping("/auto-schedule")
    public Result<Map<String, Object>> autoSchedule(@RequestBody AutoScheduleRequest request) {
        int count = courseScheduleService.autoSchedule(request.getAcademicYear(), request.getSemester());
        Map<String, Object> result = new HashMap<>();
        result.put("scheduledCount", count);
        result.put("message", "成功安排 " + count + " 门课程");
        return Result.success(result);
    }

    // ============== 课表查询 ==============

    // 课表查询：所有登录用户可见（学生端"我的课程"使用）
    @RequireRole({"admin", "teacher", "student"})
    @GetMapping("/timetable/{classId}")
    public Result<List<List<CourseSchedule>>> getClassTimetable(
            @PathVariable Integer classId,
            @RequestParam String academicYear,
            @RequestParam String semester) {
        return Result.success(courseScheduleService.getClassTimetable(classId, academicYear, semester));
    }

    // ==================== 班级课程管理 ====================

    @GetMapping("/class-course")
    public Result<List<ClassCourse>> getClassCourses(@RequestParam(required = false) Integer classId) {
        List<ClassCourse> list;
        if (classId != null) {
            list = classCourseMapper.findByClassId(classId);
        } else {
            list = classCourseMapper.findAll();
        }
        return Result.success(list);
    }

    @GetMapping("/class-course/{id}")
    public Result<ClassCourse> getClassCourseById(@PathVariable Integer id) {
        ClassCourse classCourse = classCourseMapper.findById(id);
        return classCourse != null ? Result.success(classCourse) : Result.error("记录不存在");
    }

    @PostMapping("/class-course")
    public Result<Void> addClassCourse(@RequestBody ClassCourse classCourse) {
        int rows = classCourseMapper.insert(classCourse);
        return rows > 0 ? Result.success() : Result.error("添加失败");
    }

    @PutMapping("/class-course/{id}")
    public Result<Void> updateClassCourse(@PathVariable Integer id, @RequestBody ClassCourse classCourse) {
        classCourse.setId(id);
        int rows = classCourseMapper.update(classCourse);
        return rows > 0 ? Result.success() : Result.error("更新失败");
    }

    @DeleteMapping("/class-course/{id}")
    public Result<Void> deleteClassCourse(@PathVariable Integer id) {
        int rows = classCourseMapper.deleteById(id);
        return rows > 0 ? Result.success() : Result.error("删除失败");
    }

    // ==================== 教师偏好管理 ====================

    @GetMapping("/teacher-preference")
    public Result<List<TeacherPreference>> getAllTeacherPreferences() {
        List<TeacherPreference> list = teacherPreferenceMapper.findAll();
        return Result.success(list);
    }

    @GetMapping("/teacher-preference/{teacherId}")
    public Result<TeacherPreference> getTeacherPreference(@PathVariable Integer teacherId) {
        TeacherPreference preference = teacherPreferenceMapper.findByTeacherId(teacherId);
        return preference != null ? Result.success(preference) : Result.error("未设置偏好");
    }

    @PostMapping("/teacher-preference")
    public Result<Void> addTeacherPreference(@RequestBody TeacherPreference preference) {
        int rows = teacherPreferenceMapper.insert(preference);
        return rows > 0 ? Result.success() : Result.error("添加失败");
    }

    @PutMapping("/teacher-preference/{id}")
    public Result<Void> updateTeacherPreference(@PathVariable Integer id, @RequestBody TeacherPreference preference) {
        preference.setId(id);
        int rows = teacherPreferenceMapper.update(preference);
        return rows > 0 ? Result.success() : Result.error("更新失败");
    }

    @DeleteMapping("/teacher-preference/{id}")
    public Result<Void> deleteTeacherPreference(@PathVariable Integer id) {
        int rows = teacherPreferenceMapper.deleteById(id);
        return rows > 0 ? Result.success() : Result.error("删除失败");
    }

    // ============== 内部类 ==============

    public static class AutoScheduleRequest {
        private String academicYear;
        private String semester;

        public String getAcademicYear() { return academicYear; }
        public void setAcademicYear(String academicYear) { this.academicYear = academicYear; }
        public String getSemester() { return semester; }
        public void setSemester(String semester) { this.semester = semester; }
    }
}
