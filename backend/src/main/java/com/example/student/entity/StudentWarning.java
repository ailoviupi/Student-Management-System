package com.example.student.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class StudentWarning {
    private Integer id;
    private Integer studentId;
    private Integer ruleId;
    private String warningType;
    private String warningLevel;
    private String warningReason;
    private Integer relatedCourseId;
    private Double relatedScore;
    private Integer attendanceCount;
    private String status;
    private Integer handlerId;
    private String handleRemark;
    private LocalDateTime handleTime;
    private Integer notifyStatus;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    
    // 关联字段
    private String studentName;
    private String studentNo;
    private String className;
    private String courseName;
    private String handlerName;
}
