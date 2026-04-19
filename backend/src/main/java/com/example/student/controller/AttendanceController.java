package com.example.student.controller;

import com.example.student.common.Result;
import com.example.student.entity.Attendance;
import com.example.student.service.AttendanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/attendance")
@CrossOrigin
public class AttendanceController {

    @Autowired
    private AttendanceService attendanceService;

    @GetMapping
    public Result<List<Attendance>> list(
            @RequestParam(required = false) Integer studentId,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        return Result.success(attendanceService.findByCondition(studentId, status, startDate, endDate));
    }

    @GetMapping("/{id}")
    public Result<Attendance> getById(@PathVariable Integer id) {
        Attendance attendance = attendanceService.findById(id);
        if (attendance != null) {
            return Result.success(attendance);
        }
        return Result.error("考勤记录不存在");
    }

    @PostMapping
    public Result<Void> save(@RequestBody Attendance attendance) {
        if (attendanceService.save(attendance)) {
            return Result.success();
        }
        return Result.error("新增失败");
    }

    @PutMapping
    public Result<Void> update(@RequestBody Attendance attendance) {
        if (attendanceService.update(attendance)) {
            return Result.success();
        }
        return Result.error("修改失败");
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Integer id) {
        if (attendanceService.deleteById(id)) {
            return Result.success();
        }
        return Result.error("删除失败");
    }

    @GetMapping("/statistics")
    public Result<Map<String, Object>> getStatistics(
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        return Result.success(attendanceService.getStatistics(startDate, endDate));
    }
    
    // 学生端接口：获取当前登录学生的考勤记录
    @GetMapping("/my-attendance")
    public Result<List<Attendance>> getMyAttendance(
            @RequestAttribute("username") String username,
            @RequestAttribute("role") String role,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        if (!"student".equals(role)) {
            return Result.error("无权访问");
        }
        return Result.success(attendanceService.findByStudentNo(username, status, startDate, endDate));
    }
    
    // 学生端接口：获取当前登录学生的考勤统计
    @GetMapping("/my-statistics")
    public Result<Map<String, Object>> getMyStatistics(
            @RequestAttribute("username") String username,
            @RequestAttribute("role") String role) {
        if (!"student".equals(role)) {
            return Result.error("无权访问");
        }
        return Result.success(attendanceService.getStudentStatistics(username));
    }
}
