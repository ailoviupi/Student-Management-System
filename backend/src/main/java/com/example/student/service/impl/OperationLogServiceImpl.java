package com.example.student.service.impl;

import com.example.student.entity.OperationLog;
import com.example.student.mapper.OperationLogMapper;
import com.example.student.service.OperationLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class OperationLogServiceImpl implements OperationLogService {

    @Autowired
    private OperationLogMapper operationLogMapper;

    @Override
    public void saveLog(OperationLog log) {
        operationLogMapper.insert(log);
    }

    @Override
    public List<OperationLog> getLogs(Integer userId, String operationType, String operationModule, 
                                      Integer status, String startTime, String endTime, String keyword) {
        return operationLogMapper.findByCondition(userId, operationType, operationModule, status, startTime, endTime, keyword);
    }

    @Override
    public OperationLog getLogById(Integer id) {
        return operationLogMapper.findById(id);
    }

    @Override
    public boolean deleteOldLogs(int days) {
        return operationLogMapper.deleteOldLogs(days) >= 0;
    }

    @Override
    public Map<String, Object> getStatistics() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalCount", operationLogMapper.countTotal());
        stats.put("failedCount", operationLogMapper.countFailed());
        stats.put("todayCount", operationLogMapper.countToday());
        return stats;
    }
}
