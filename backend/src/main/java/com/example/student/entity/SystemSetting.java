package com.example.student.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class SystemSetting {
    private Integer id;
    private String settingKey;
    private String settingValue;
    private String settingDesc;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
