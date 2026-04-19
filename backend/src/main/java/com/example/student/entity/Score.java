package com.example.student.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class Score {
    private Integer id;
    private Integer studentId;
    private String studentName;
    private String studentNo;
    private Integer courseId;
    private String courseName;
    private String courseCode;
    private String className;
    private BigDecimal score;
    private LocalDate examDate;
    private String examType;
    private String remark;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
