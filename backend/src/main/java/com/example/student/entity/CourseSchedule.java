package com.example.student.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class CourseSchedule {
    private Integer id;
    private Integer courseId;
    private Integer classId;
    private Integer teacherId;
    private Integer classroomId;
    private String academicYear;
    private String semester;
    private Integer dayOfWeek;
    private Integer startSlot;
    private Integer endSlot;
    private String weeks;
    private String scheduleType;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    
    // 关联字段
    private String courseName;
    private String courseCode;
    private String className;
    private String teacherName;
    private String classroomName;
    private String roomCode;
    private String building;
}
