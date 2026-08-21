package com.example.student.service;

import com.example.student.entity.Classroom;
import com.example.student.entity.CourseSchedule;
import java.util.List;
import java.util.Map;

public interface CourseScheduleService {
    
    // 教室管理
    List<Classroom> getAllClassrooms();
    
    List<Classroom> getActiveClassrooms();
    
    Classroom getClassroomById(Integer id);
    
    boolean addClassroom(Classroom classroom);
    
    boolean updateClassroom(Classroom classroom);
    
    boolean deleteClassroom(Integer id);
    
    // 课程安排
    List<CourseSchedule> getSchedules(String academicYear, String semester, Integer classId, Integer teacherId);
    
    CourseSchedule getScheduleById(Integer id);
    
    boolean addSchedule(CourseSchedule schedule);
    
    boolean updateSchedule(CourseSchedule schedule);
    
    boolean deleteSchedule(Integer id);
    
    // 智能排课
    int autoSchedule(String academicYear, String semester);
    
    // 检查冲突
    Map<String, Object> checkConflict(CourseSchedule schedule);
    
    // 获取班级课表
    List<List<CourseSchedule>> getClassTimetable(Integer classId, String academicYear, String semester);
}
