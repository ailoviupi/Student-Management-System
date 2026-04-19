package com.example.student.service;

import com.example.student.entity.Attendance;

import java.util.List;
import java.util.Map;

public interface AttendanceService {
    List<Attendance> findByCondition(Integer studentId, String status, String startDate, String endDate);
    Attendance findById(Integer id);
    boolean save(Attendance attendance);
    boolean update(Attendance attendance);
    boolean deleteById(Integer id);
    Map<String, Object> getStatistics(String startDate, String endDate);
    
    // 学生端方法
    List<Attendance> findByStudentNo(String studentNo, String status, String startDate, String endDate);
    Map<String, Object> getStudentStatistics(String studentNo);
}
