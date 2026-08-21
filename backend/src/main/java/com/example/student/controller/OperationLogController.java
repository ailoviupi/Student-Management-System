package com.example.student.controller;

import com.example.student.common.RequireRole;
import com.example.student.entity.OperationLog;
import com.example.student.service.OperationLogService;
import com.example.student.common.Result;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/operation-log")
@RequireRole("admin")
public class OperationLogController {

    @Autowired
    private OperationLogService operationLogService;

    // 检查是否为管理员
    private boolean isAdmin(HttpServletRequest request) {
        String role = (String) request.getAttribute("role");
        return "admin".equals(role);
    }

    @GetMapping("/list")
    public Result<List<OperationLog>> getLogs(
            HttpServletRequest request,
            @RequestParam(required = false) Integer userId,
            @RequestParam(required = false) String operationType,
            @RequestParam(required = false) String operationModule,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String startTime,
            @RequestParam(required = false) String endTime,
            @RequestParam(required = false) String keyword) {
        if (!isAdmin(request)) {
            return Result.error("无权访问，仅管理员可查看操作日志");
        }
        return Result.success(operationLogService.getLogs(userId, operationType, operationModule, 
                status, startTime, endTime, keyword));
    }

    @GetMapping("/{id}")
    public Result<OperationLog> getLogById(HttpServletRequest request, @PathVariable Integer id) {
        if (!isAdmin(request)) {
            return Result.error("无权访问，仅管理员可查看操作日志");
        }
        OperationLog log = operationLogService.getLogById(id);
        return log != null ? Result.success(log) : Result.error("日志不存在");
    }

    @DeleteMapping("/cleanup")
    public Result<Void> deleteOldLogs(HttpServletRequest request, @RequestParam int days) {
        if (!isAdmin(request)) {
            return Result.error("无权操作，仅管理员可清理日志");
        }
        return operationLogService.deleteOldLogs(days) ? Result.success() : Result.error("清理失败");
    }

    @GetMapping("/statistics")
    public Result<Map<String, Object>> getStatistics(HttpServletRequest request) {
        if (!isAdmin(request)) {
            return Result.error("无权访问，仅管理员可查看统计数据");
        }
        return Result.success(operationLogService.getStatistics());
    }
}
