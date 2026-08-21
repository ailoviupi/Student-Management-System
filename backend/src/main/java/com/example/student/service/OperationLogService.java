package com.example.student.service;

import com.example.student.entity.OperationLog;
import java.util.List;
import java.util.Map;

public interface OperationLogService {
    
    void saveLog(OperationLog log);
    
    List<OperationLog> getLogs(Integer userId, String operationType, String operationModule, 
                               Integer status, String startTime, String endTime, String keyword);
    
    OperationLog getLogById(Integer id);
    
    boolean deleteOldLogs(int days);
    
    Map<String, Object> getStatistics();
}
