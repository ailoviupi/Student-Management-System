package com.example.student.service;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public interface ExportService {
    
    void exportStudentsToExcel(HttpServletResponse response) throws IOException;
    
    void exportScoresToExcel(Integer classId, Integer courseId, HttpServletResponse response) throws IOException;
    
    void exportStudentScoresToExcel(Integer studentId, HttpServletResponse response) throws IOException;
    
    void exportAttendanceToExcel(Integer classId, String startDate, String endDate, HttpServletResponse response) throws IOException;
    
    void exportWarningsToExcel(String status, String warningLevel, HttpServletResponse response) throws IOException;
    
    void exportCourseStatsToExcel(HttpServletResponse response) throws IOException;
}
