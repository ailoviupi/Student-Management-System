package com.example.student.service;

import com.example.student.entity.ScholarshipRecord;
import com.example.student.entity.ScholarshipType;
import java.util.List;
import java.util.Map;

public interface ScholarshipService {
    
    // 奖学金类型管理
    List<ScholarshipType> getAllTypes();
    
    List<ScholarshipType> getActiveTypes();
    
    ScholarshipType getTypeById(Integer id);
    
    boolean addType(ScholarshipType type);
    
    boolean updateType(ScholarshipType type);
    
    boolean deleteType(Integer id);
    
    // 奖学金评定
    List<ScholarshipRecord> getRecords(String academicYear, String semester, String status, 
                                       Integer scholarshipTypeId, Integer studentId);
    
    ScholarshipRecord getRecordById(Integer id);
    
    boolean applyScholarship(ScholarshipRecord record);
    
    boolean reviewScholarship(Integer id, String status, Integer reviewerId, String reviewRemark);
    
    boolean deleteRecord(Integer id);
    
    // 自动评定
    void autoEvaluate(String academicYear, String semester);
    
    Map<String, Object> getStatistics(String academicYear, String semester);
}
