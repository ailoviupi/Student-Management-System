package com.example.student.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Classroom {
    private Integer id;
    private String roomCode;
    private String roomName;
    private String building;
    private Integer floor;
    private Integer capacity;
    private String roomType;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
