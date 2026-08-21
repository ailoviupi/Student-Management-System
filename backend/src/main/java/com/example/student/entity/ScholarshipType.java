package com.example.student.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class ScholarshipType {
    private Integer id;
    private String typeName;
    private String typeCode;
    private BigDecimal amount;
    private Integer quota;
    private String description;
    private String requirements;
    private String academicYear;
    private String semester;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
