package com.example.student.service.impl;

import com.example.student.entity.Attendance;
import com.example.student.mapper.AttendanceMapper;
import com.example.student.service.AttendanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AttendanceServiceImpl implements AttendanceService {

    @Autowired
    private AttendanceMapper attendanceMapper;

    @Override
    public List<Attendance> findByCondition(Integer studentId, String status, String startDate, String endDate) {
        return attendanceMapper.findByCondition(studentId, status, startDate, endDate);
    }

    @Override
    public Attendance findById(Integer id) {
        return attendanceMapper.findById(id);
    }

    @Override
    public boolean save(Attendance attendance) {
        return attendanceMapper.insert(attendance) > 0;
    }

    @Override
    public boolean update(Attendance attendance) {
        return attendanceMapper.update(attendance) > 0;
    }

    @Override
    public boolean deleteById(Integer id) {
        return attendanceMapper.deleteById(id) > 0;
    }

    @Override
    public Map<String, Object> getStatistics(String startDate, String endDate) {
        Map<String, Object> stats = new HashMap<>();
        List<Map<String, Object>> statusCounts = attendanceMapper.countByStatus(startDate, endDate);
        stats.put("statusCounts", statusCounts);
        return stats;
    }
    
    @Override
    public List<Attendance> findByStudentNo(String studentNo, String status, String startDate, String endDate) {
        return attendanceMapper.findByStudentNo(studentNo, status, startDate, endDate);
    }
    
    @Override
    public Map<String, Object> getStudentStatistics(String studentNo) {
        Map<String, Object> stats = new HashMap<>();
        
        // 获取本学期考勤统计（简化处理，实际应该根据学期计算日期）
        List<Attendance> attendances = attendanceMapper.findByStudentNo(studentNo, null, null, null);
        
        int total = attendances.size();
        int present = 0;
        int absent = 0;
        int late = 0;
        int leave = 0;
        
        for (Attendance a : attendances) {
            if ("出勤".equals(a.getStatus())) {
                present++;
            } else if ("缺勤".equals(a.getStatus())) {
                absent++;
            } else if ("迟到".equals(a.getStatus())) {
                late++;
            } else if ("请假".equals(a.getStatus())) {
                leave++;
            }
        }
        
        stats.put("total", total);
        stats.put("present", present);
        stats.put("absent", absent);
        stats.put("late", late);
        stats.put("leave", leave);
        
        if (total > 0) {
            stats.put("attendanceRate", Math.round((present + late) * 100.0 / total));
        } else {
            stats.put("attendanceRate", 100);
        }
        
        return stats;
    }
}
