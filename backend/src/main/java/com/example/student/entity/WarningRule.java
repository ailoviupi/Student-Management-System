package com.example.student.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class WarningRule {
    private Integer id;
    private String ruleName;
    private String ruleType;
    private String warningLevel;
    private Double thresholdValue;
    private Integer thresholdCount;
    private String description;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
