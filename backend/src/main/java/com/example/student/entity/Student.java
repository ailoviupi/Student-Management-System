package com.example.student.entity;

import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class Student {
    private Integer id;
    private String studentNo;
    private String name;
    private Integer age;
    private String gender;
    private String phone;
    private String email;
    private String address;
    private Integer classId;
    private String className;
    private LocalDate enrollmentDate;
    private String studentStatus;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
