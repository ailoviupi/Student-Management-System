package com.example.student.controller;

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
        if (studentService.save(student)) {
            return Result.success();
        }
        return Result.error("新增失败，学号可能已存在");
    }

    @PutMapping
    public Result<Void> update(@RequestBody Student student) {
        if (studentService.update(student)) {
            return Result.success();
        }
        return Result.error("修改失败，学号可能已存在");
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Integer id) {
        if (studentService.deleteById(id)) {
            return Result.success();
        }
        return Result.error("删除失败");
    }
}
