package com.example.student.controller;

import com.example.student.common.RequireRole;
import com.example.student.common.Result;
import com.example.student.dto.StudentQueryDTO;
import com.example.student.entity.Student;
import com.example.student.service.StudentService;
import com.example.student.vo.PageVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/students")
@CrossOrigin
@RequireRole({"admin", "teacher"})
public class StudentController {

    @Autowired
    private StudentService studentService;

    @GetMapping
    public Result<PageVO<Student>> list(StudentQueryDTO queryDTO) {
        return Result.success(studentService.findByCondition(queryDTO));
    }

    @GetMapping("/{id}")
    public Result<Student> getById(@PathVariable Integer id) {
        Student student = studentService.findById(id);
        if (student != null) {
            return Result.success(student);
        }
        return Result.error("学生不存在");
    }

    @PostMapping
    public Result<Void> save(@RequestBody Student student) {
        if (student.getStudentNo() == null || student.getName() == null) {
            return Result.error(400, "学号和姓名不能为空");
        }
        Student exist = studentService.findByStudentNo(student.getStudentNo());
        if (exist != null) {
            return Result.error(400, "学号已存在");
        }
        if (studentService.save(student)) {
            return Result.success();
        }
        return Result.error("新增失败");
    }

    @PutMapping
    public Result<Void> update(@RequestBody Student student) {
        if (student.getId() == null) {
            return Result.error(400, "学生ID不能为空");
        }
        Student existStudent = studentService.findById(student.getId());
        if (existStudent == null) {
            return Result.error(404, "学生不存在");
        }
        Student exist = studentService.findByStudentNo(student.getStudentNo());
        if (exist != null && !exist.getId().equals(student.getId())) {
            return Result.error(400, "学号已存在");
        }
        if (studentService.update(student)) {
            return Result.success();
        }
        return Result.error("修改失败");
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Integer id) {
        Student student = studentService.findById(id);
        if (student == null) {
            return Result.error(404, "学生不存在");
        }
        if (studentService.deleteById(id)) {
            return Result.success();
        }
        return Result.error("删除失败，该学生可能有关联数据");
    }
}
