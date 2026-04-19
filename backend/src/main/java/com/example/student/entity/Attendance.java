package com.example.student.entity;

import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class Attendance {
    private Integer id;
    private Integer studentId;
    private String studentName;
    private String studentNo;
    private String className;
    private LocalDate attendanceDate;
    private String status;
    private String remark;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
