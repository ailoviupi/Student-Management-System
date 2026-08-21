package com.example.student.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class HomeworkSubmission {
    private Integer id;
    private Integer homeworkId;
    private Integer studentId;
    private String studentName;
    private String studentNo;
    private String content;
    private String fileUrl;
    private LocalDateTime submitTime;
    private BigDecimal score;
    private String feedback;
    private LocalDateTime gradeTime;
    private Integer gradeUser;
    private Integer status;
}