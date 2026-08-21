package com.example.student.controller;

import com.example.student.common.RequireRole;
import com.example.student.entity.ScholarshipRecord;
import com.example.student.entity.ScholarshipType;
import com.example.student.entity.Student;
import com.example.student.service.ScholarshipService;
import com.example.student.common.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/scholarship")
public class ScholarshipController {

    @Autowired
    private ScholarshipService scholarshipService;

    // ============== 奖学金类型管理 ==============

    // 类型浏览：所有登录用户可见（学生需要了解可申请的奖学金）
    @RequireRole({"admin", "teacher", "student"})
    @GetMapping("/types")
    public Result<List<ScholarshipType>> getAllTypes() {
        return Result.success(scholarshipService.getAllTypes());
    }

    @RequireRole({"admin", "teacher", "student"})
    @GetMapping("/types/active")
    public Result<List<ScholarshipType>> getActiveTypes() {
        return Result.success(scholarshipService.getActiveTypes());
    }

    @RequireRole({"admin", "teacher", "student"})
    @GetMapping("/types/{id}")
    public Result<ScholarshipType> getTypeById(@PathVariable Integer id) {
        ScholarshipType type = scholarshipService.getTypeById(id);
        return type != null ? Result.success(type) : Result.error("奖学金类型不存在");
    }

    @RequireRole({"admin", "teacher"})
    @PostMapping("/types")
    public Result<Void> addType(@RequestBody ScholarshipType type) {
        return scholarshipService.addType(type) ? Result.success() : Result.error("添加失败");
    }

    @RequireRole({"admin", "teacher"})
    @PutMapping("/types/{id}")
    public Result<Void> updateType(@PathVariable Integer id, @RequestBody ScholarshipType type) {
        type.setId(id);
        return scholarshipService.updateType(type) ? Result.success() : Result.error("更新失败");
    }

    @RequireRole({"admin", "teacher"})
    @DeleteMapping("/types/{id}")
    public Result<Void> deleteType(@PathVariable Integer id) {
        return scholarshipService.deleteType(id) ? Result.success() : Result.error("删除失败");
    }

    // ============== 奖学金评定 ==============

    @RequireRole({"admin", "teacher"})
    @GetMapping("/records")
    public Result<List<ScholarshipRecord>> getRecords(
            @RequestParam(required = false) String academicYear,
            @RequestParam(required = false) String semester,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Integer scholarshipTypeId,
            @RequestParam(required = false) Integer studentId) {
        return Result.success(scholarshipService.getRecords(academicYear, semester, status, scholarshipTypeId, studentId));
    }

    @RequireRole({"admin", "teacher"})
    @GetMapping("/records/{id}")
    public Result<ScholarshipRecord> getRecordById(@PathVariable Integer id) {
        ScholarshipRecord record = scholarshipService.getRecordById(id);
        return record != null ? Result.success(record) : Result.error("记录不存在");
    }

    // 学生申请（studentId 强制绑定当前登录学生，防止冒用他人身份申请）
    @RequireRole("student")
    @PostMapping("/apply")
    public Result<Void> applyScholarship(@RequestBody ScholarshipRecord record, HttpServletRequest request) {
        Object user = request.getAttribute("user");
        if (!(user instanceof Student)) {
            return Result.error(403, "无权操作");
        }
        record.setStudentId(((Student) user).getId());
        return scholarshipService.applyScholarship(record) ? Result.success() : Result.error("申请失败，可能已申请过该奖学金");
    }

    @RequireRole({"admin", "teacher"})
    @PostMapping("/review/{id}")
    public Result<Void> reviewScholarship(
            @PathVariable Integer id,
            @RequestParam String status,
            @RequestParam Integer reviewerId,
            @RequestParam(required = false) String reviewRemark) {
        return scholarshipService.reviewScholarship(id, status, reviewerId, reviewRemark) 
                ? Result.success() : Result.error("审核失败");
    }

    @RequireRole({"admin", "teacher"})
    @DeleteMapping("/records/{id}")
    public Result<Void> deleteRecord(@PathVariable Integer id) {
        return scholarshipService.deleteRecord(id) ? Result.success() : Result.error("删除失败");
    }

    // ============== 自动评定与统计 ==============

    @RequireRole({"admin", "teacher"})
    @PostMapping("/auto-evaluate")
    public Result<Void> autoEvaluate(
            @RequestParam String academicYear,
            @RequestParam String semester) {
        scholarshipService.autoEvaluate(academicYear, semester);
        return Result.success();
    }

    @RequireRole({"admin", "teacher"})
    @GetMapping("/statistics")
    public Result<Map<String, Object>> getStatistics(
            @RequestParam(required = false) String academicYear,
            @RequestParam(required = false) String semester) {
        return Result.success(scholarshipService.getStatistics(academicYear, semester));
    }
}
