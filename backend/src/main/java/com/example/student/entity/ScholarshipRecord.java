package com.example.student.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class ScholarshipRecord {
    private Integer id;
    private Integer studentId;
    private Integer scholarshipTypeId;
    private String academicYear;
    private String semester;
    private BigDecimal gpa;
    private Integer ranking;
    private BigDecimal totalScore;
    private String scoreDetails;
    private String status;
    private Integer reviewerId;
    private String reviewRemark;
    private LocalDateTime reviewTime;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    
    // 关联字段
    private String studentName;
    private String studentNo;
    private String className;
    private String scholarshipTypeName;
    private BigDecimal scholarshipAmount;
    private String reviewerName;
}
