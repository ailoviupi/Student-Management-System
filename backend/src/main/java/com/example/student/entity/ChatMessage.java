package com.example.student.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ChatMessage {
    private Integer id;
    private Integer senderId;
    private String senderRole;
    private Integer receiverId;
    private String receiverRole;
    private String content;
    private LocalDateTime sendTime;
    private Integer readStatus;
}