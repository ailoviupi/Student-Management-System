package com.example.student.service;

import com.example.student.entity.StudentWarning;
import com.example.student.entity.WarningRule;
import java.util.List;
import java.util.Map;

public interface WarningService {
    
    List<WarningRule> getAllRules();
    
    List<WarningRule> getActiveRules();
    
    WarningRule getRuleById(Integer id);
    
    boolean addRule(WarningRule rule);
    
    boolean updateRule(WarningRule rule);
    
    boolean deleteRule(Integer id);
    
    List<StudentWarning> getWarnings(String status, String warningLevel, String warningType, Integer studentId);
    
    StudentWarning getWarningById(Integer id);
    
    boolean handleWarning(Integer id, String status, Integer handlerId, String handleRemark);
    
    boolean deleteWarning(Integer id);
    
    Map<String, Object> getWarningStatistics();
    
    void checkAndGenerateWarnings();
}
