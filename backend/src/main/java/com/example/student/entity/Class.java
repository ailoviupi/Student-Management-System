package com.example.student.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Class {
    private Integer id;
    private String className;
    private String grade;
    private String major;
    private Integer teacherId;
    private String teacherName;
    private Integer studentCount;
    private LocalDateTime createTime;
}
