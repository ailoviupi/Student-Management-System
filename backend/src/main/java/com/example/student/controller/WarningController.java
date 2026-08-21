package com.example.student.controller;

import com.example.student.common.RequireRole;
import com.example.student.entity.StudentWarning;
import com.example.student.entity.WarningRule;
import com.example.student.service.WarningService;
import com.example.student.common.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/warning")
@RequireRole({"admin", "teacher"})
public class WarningController {

    @Autowired
    private WarningService warningService;

    // ============== 预警规则管理 ==============

    @GetMapping("/rules")
    public Result<List<WarningRule>> getAllRules() {
        return Result.success(warningService.getAllRules());
    }

    @GetMapping("/rules/active")
    public Result<List<WarningRule>> getActiveRules() {
        return Result.success(warningService.getActiveRules());
    }

    @GetMapping("/rules/{id}")
    public Result<WarningRule> getRuleById(@PathVariable Integer id) {
        WarningRule rule = warningService.getRuleById(id);
        return rule != null ? Result.success(rule) : Result.error("规则不存在");
    }

    @PostMapping("/rules")
    public Result<Void> addRule(@RequestBody WarningRule rule) {
        return warningService.addRule(rule) ? Result.success() : Result.error("添加失败");
    }

    @PutMapping("/rules/{id}")
    public Result<Void> updateRule(@PathVariable Integer id, @RequestBody WarningRule rule) {
        rule.setId(id);
        return warningService.updateRule(rule) ? Result.success() : Result.error("更新失败");
    }

    @DeleteMapping("/rules/{id}")
    public Result<Void> deleteRule(@PathVariable Integer id) {
        return warningService.deleteRule(id) ? Result.success() : Result.error("删除失败");
    }

    // ============== 学生预警管理 ==============

    @GetMapping("/list")
    public Result<List<StudentWarning>> getWarnings(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String warningLevel,
            @RequestParam(required = false) String warningType,
            @RequestParam(required = false) Integer studentId) {
        return Result.success(warningService.getWarnings(status, warningLevel, warningType, studentId));
    }

    @GetMapping("/{id}")
    public Result<StudentWarning> getWarningById(@PathVariable Integer id) {
        StudentWarning warning = warningService.getWarningById(id);
        return warning != null ? Result.success(warning) : Result.error("预警记录不存在");
    }

    @PostMapping("/handle/{id}")
    public Result<Void> handleWarning(
            @PathVariable Integer id,
            @RequestParam String status,
            @RequestParam Integer handlerId,
            @RequestParam(required = false) String handleRemark) {
        return warningService.handleWarning(id, status, handlerId, handleRemark) 
                ? Result.success() : Result.error("处理失败");
    }

    @DeleteMapping("/{id}")
    public Result<Void> deleteWarning(@PathVariable Integer id) {
        return warningService.deleteWarning(id) ? Result.success() : Result.error("删除失败");
    }

    // ============== 统计与检查 ==============

    @GetMapping("/statistics")
    public Result<Map<String, Object>> getStatistics() {
        return Result.success(warningService.getWarningStatistics());
    }

    @PostMapping("/check")
    public Result<Void> checkWarnings() {
        warningService.checkAndGenerateWarnings();
        return Result.success();
    }
}
