package com.example.student.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class Course {
    private Integer id;
    private String courseCode;
    private String courseName;
    private BigDecimal credit;
    private Integer hours;
    private Integer teacherId;
    private String teacherName;
    private String description;
    private LocalDateTime createTime;
}
