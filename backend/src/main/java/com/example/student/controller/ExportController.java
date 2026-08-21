package com.example.student.controller;

import com.example.student.common.RequireRole;
import com.example.student.service.ExportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@RestController
@RequestMapping("/api/export")
@RequireRole({"admin", "teacher"})
public class ExportController {

    @Autowired
    private ExportService exportService;

    @GetMapping("/students")
    public void exportStudents(HttpServletResponse response) throws IOException {
        exportService.exportStudentsToExcel(response);
    }

    @GetMapping("/scores")
    public void exportScores(
            @RequestParam(required = false) Integer classId,
            @RequestParam(required = false) Integer courseId,
            HttpServletResponse response) throws IOException {
        exportService.exportScoresToExcel(classId, courseId, response);
    }

    @GetMapping("/student/{studentId}/scores")
    public void exportStudentScores(
            @PathVariable Integer studentId,
            HttpServletResponse response) throws IOException {
        exportService.exportStudentScoresToExcel(studentId, response);
    }

    @GetMapping("/attendance")
    public void exportAttendance(
            @RequestParam(required = false) Integer classId,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            HttpServletResponse response) throws IOException {
        exportService.exportAttendanceToExcel(classId, startDate, endDate, response);
    }

    @GetMapping("/warnings")
    public void exportWarnings(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String warningLevel,
            HttpServletResponse response) throws IOException {
        exportService.exportWarningsToExcel(status, warningLevel, response);
    }

    @GetMapping("/course-stats")
    public void exportCourseStats(HttpServletResponse response) throws IOException {
        exportService.exportCourseStatsToExcel(response);
    }
}
