package com.example.student.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Data
public class Exam {
    private Integer id;
    private String examName;
    private Integer courseId;
    private String courseName;
    private Integer classId;
    private String className;
    private String examType;
    private LocalDate examDate;
    private LocalTime startTime;
    private LocalTime endTime;
    private Integer classroomId;
    private String classroomName;
    private BigDecimal totalScore;
    private Integer status;
    private String remark;
    private Integer createUser;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}