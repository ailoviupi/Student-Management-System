package com.example.student.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class Homework {
    private Integer id;
    private String title;
    private Integer courseId;
    private String courseName;
    private Integer classId;
    private String className;
    private String description;
    private BigDecimal totalScore;
    private LocalDateTime deadline;
    private Integer status;
    private Integer createUser;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}