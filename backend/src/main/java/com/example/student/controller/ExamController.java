package com.example.student.controller;

import com.example.student.common.RequireRole;
import com.example.student.common.Result;
import com.example.student.entity.Exam;
import com.example.student.entity.Student;
import com.example.student.service.ExamService;
import com.example.student.service.StudentService;
import com.example.student.vo.PageVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/exams")
@CrossOrigin
@RequireRole({"admin", "teacher"})
public class ExamController {

    @Autowired
    private ExamService examService;

    @Autowired
    private StudentService studentService;

    @GetMapping
    public Result<PageVO<Exam>> list(
            @RequestParam(required = false) Integer courseId,
            @RequestParam(required = false) Integer classId,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String examType,
            @RequestParam(required = false) String examName,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        return Result.success(examService.findByCondition(courseId, classId, status, examType, examName, page, size));
    }

    @GetMapping("/{id}")
    public Result<Exam> getById(@PathVariable Integer id) {
        Exam exam = examService.findById(id);
        if (exam != null) {
            return Result.success(exam);
        }
        return Result.error("考试不存在");
    }

    @PostMapping
    public Result<Void> save(@RequestBody Exam exam) {
        if (examService.save(exam)) {
            return Result.success();
        }
        return Result.error("新增失败");
    }

    @PutMapping
    public Result<Void> update(@RequestBody Exam exam) {
        if (examService.update(exam)) {
            return Result.success();
        }
        return Result.error("修改失败");
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Integer id) {
        if (examService.deleteById(id)) {
            return Result.success();
        }
        return Result.error("删除失败");
    }

    // 学生端接口
    @RequireRole("student")
    @GetMapping("/my-exams")
    public Result<List<Exam>> getMyExams(@RequestAttribute("username") String username,
                                          @RequestAttribute("role") String role) {
        if (!"student".equals(role)) {
            return Result.error("无权访问");
        }
        Student student = studentService.findByStudentNo(username);
        if (student == null) {
            return Result.error("学生信息不存在");
        }
        return Result.success(examService.findMyExams(student.getClassId()));
    }
}