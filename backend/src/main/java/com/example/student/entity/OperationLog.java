package com.example.student.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class OperationLog {
    private Integer id;
    private Integer userId;
    private String username;
    private String realName;
    private String operationType;
    private String operationModule;
    private String operationDesc;
    private String requestMethod;
    private String requestUrl;
    private String requestParams;
    private String responseData;
    private String ipAddress;
    private String userAgent;
    private Integer executionTime;
    private Integer status;
    private String errorMsg;
    private LocalDateTime createTime;
}
