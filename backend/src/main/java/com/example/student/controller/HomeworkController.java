package com.example.student.controller;

import com.example.student.common.RequireRole;
import com.example.student.common.Result;
import com.example.student.entity.Homework;
import com.example.student.entity.HomeworkSubmission;
import com.example.student.entity.Student;
import com.example.student.service.HomeworkService;
import com.example.student.service.StudentService;
import com.example.student.vo.PageVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/homework")
@CrossOrigin
@RequireRole({"admin", "teacher"})
public class HomeworkController {

    @Autowired
    private HomeworkService homeworkService;

    @Autowired
    private StudentService studentService;

    @GetMapping
    public Result<PageVO<Homework>> list(
            @RequestParam(required = false) Integer courseId,
            @RequestParam(required = false) Integer classId,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String title,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        return Result.success(homeworkService.findByCondition(courseId, classId, status, title, page, size));
    }

    @GetMapping("/{id}")
    public Result<Homework> getById(@PathVariable Integer id) {
        Homework homework = homeworkService.findById(id);
        if (homework != null) {
            return Result.success(homework);
        }
        return Result.error("作业不存在");
    }

    @PostMapping
    public Result<Void> save(@RequestBody Homework homework) {
        if (homeworkService.save(homework)) {
            return Result.success();
        }
        return Result.error("新增失败");
    }

    @PutMapping
    public Result<Void> update(@RequestBody Homework homework) {
        if (homeworkService.update(homework)) {
            return Result.success();
        }
        return Result.error("修改失败");
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Integer id) {
        if (homeworkService.deleteById(id)) {
            return Result.success();
        }
        return Result.error("删除失败");
    }

    // 作业提交相关
    @GetMapping("/{homeworkId}/submissions")
    public Result<PageVO<HomeworkSubmission>> getSubmissions(
            @PathVariable Integer homeworkId,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        return Result.success(homeworkService.findSubmissions(homeworkId, status, page, size));
    }

    @GetMapping("/submissions/{id}")
    public Result<HomeworkSubmission> getSubmissionById(@PathVariable Integer id) {
        HomeworkSubmission submission = homeworkService.findSubmissionById(id);
        if (submission != null) {
            return Result.success(submission);
        }
        return Result.error("提交记录不存在");
    }

    // 学生端：提交作业（studentId 强制绑定当前登录学生，防止冒用他人身份提交）
    @RequireRole("student")
    @PostMapping("/submissions")
    public Result<Void> submit(@RequestBody HomeworkSubmission submission,
                               @RequestAttribute("username") String username,
                               @RequestAttribute("role") String role) {
        if (!"student".equals(role)) {
            return Result.error("无权访问");
        }
        Student student = studentService.findByStudentNo(username);
        if (student == null) {
            return Result.error("学生信息不存在");
        }
        submission.setStudentId(student.getId());
        if (homeworkService.submit(submission)) {
            return Result.success();
        }
        return Result.error("提交失败");
    }

    @PutMapping("/submissions/{id}/grade")
    public Result<Void> gradeSubmission(
            @PathVariable Integer id,
            @RequestParam Double score,
            @RequestParam(required = false) String feedback,
            @RequestAttribute("userId") Integer userId) {
        if (userId == null) {
            return Result.error("未登录或token无效");
        }
        if (homeworkService.gradeSubmission(id, score, feedback, userId)) {
            return Result.success();
        }
        return Result.error("批改失败");
    }

    @GetMapping("/{homeworkId}/statistics")
    public Result<Map<String, Object>> getStatistics(@PathVariable Integer homeworkId) {
        return Result.success(homeworkService.getStatistics(homeworkId));
    }

    // 学生端接口
    @RequireRole("student")
    @GetMapping("/my-homework")
    public Result<List<Homework>> getMyHomework(@RequestAttribute("username") String username,
                                                 @RequestAttribute("role") String role) {
        if (!"student".equals(role)) {
            return Result.error("无权访问");
        }
        // 根据学号获取学生信息
        Student student = studentService.findByStudentNo(username);
        if (student == null) {
            return Result.error("学生信息不存在");
        }
        return Result.success(homeworkService.findMyHomework(student.getClassId()));
    }

    @RequireRole("student")
    @GetMapping("/{homeworkId}/my-submission")
    public Result<HomeworkSubmission> getMySubmission(@PathVariable Integer homeworkId,
                                                       @RequestAttribute("username") String username,
                                                       @RequestAttribute("role") String role) {
        if (!"student".equals(role)) {
            return Result.error("无权访问");
        }
        Student student = studentService.findByStudentNo(username);
        if (student == null) {
            return Result.error("学生信息不存在");
        }
        HomeworkSubmission submission = homeworkService.findMySubmission(homeworkId, student.getId());
        return Result.success(submission);
    }
}