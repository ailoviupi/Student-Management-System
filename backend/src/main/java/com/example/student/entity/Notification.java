package com.example.student.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Notification {
    private Integer id;
    private String title;
    private String content;
    private String type;
    private Integer senderId;
    private String senderName;
    private String targetType;
    private Integer targetId;
    private Integer priority;
    private Integer status;
    private LocalDateTime publishTime;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    
    // 关联字段
    private Boolean isRead;
    private LocalDateTime readTime;
    private Integer unreadCount;
}
