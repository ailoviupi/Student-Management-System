package com.example.student.entity;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 班级课程关联表 - 定义班级需要上的课程
 */
@Data
public class ClassCourse {
    private Integer id;
    private Integer classId;
    private String className;
    private Integer courseId;
    private String courseName;
    private String courseCode;
    
    // 每周课时数
    private Integer weeklyHours;
    
    // 是否连堂（如2节连上）: 0-否, 1-是
    private Integer isConsecutive;
    
    // 连堂节数（默认2）
    private Integer consecutiveCount;
    
    // 优先级（1-10，数字越大优先级越高）
    private Integer priority;
    
    // 指定教室类型（NORMAL-普通教室, MEDIA-多媒体, LAB-实验室）
    private String requiredRoomType;
    
    // 最少需要教室容量
    private Integer minCapacity;
    
    // 指定星期（如：1,3,5表示周一三五）
    private String fixedDays;
    
    // 指定时间段
    private String fixedSlots;
    
    // 备注
    private String remark;
    
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
