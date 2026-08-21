package com.example.student.entity;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 教师偏好设置
 */
@Data
public class TeacherPreference {
    private Integer id;
    private Integer teacherId;
    private String teacherName;
    
    // 偏好星期（1-7，多个用逗号分隔）
    private String preferredDays;
    
    // 偏好时间段（如：1-2,3-4,5-6）
    private String preferredSlots;
    
    // 不喜欢的星期
    private String avoidedDays;
    
    // 不喜欢的时间段
    private String avoidedSlots;
    
    // 每天最多课时
    private Integer maxDailyHours;
    
    // 每周最多课时
    private Integer maxWeeklyHours;
    
    // 是否允许连堂
    private Boolean allowConsecutive;
    
    // 备注
    private String remark;
    
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
