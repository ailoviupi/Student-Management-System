package com.example.student.controller;

import com.example.student.common.Result;
import com.example.student.entity.Class;
import com.example.student.service.ClassService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/classes")
@CrossOrigin
public class ClassController {
    
    @Autowired
    private ClassService classService;
    
    @GetMapping
    public Result<List<Class>> list() {
        return Result.success(classService.findAll());
    }
    
    @GetMapping("/{id}")
    public Result<Class> getById(@PathVariable Integer id) {
        Class clazz = classService.findById(id);
        if (clazz != null) {
            return Result.success(clazz);
        }
        return Result.error("班级不存在");
    }
    
    @PostMapping
    public Result<Void> save(@RequestBody Class clazz) {
        if (classService.save(clazz)) {
            return Result.success();
        }
        return Result.error("新增失败");
    }
    
    @PutMapping
    public Result<Void> update(@RequestBody Class clazz) {
        if (classService.update(clazz)) {
            return Result.success();
        }
        return Result.error("修改失败");
    }
    
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Integer id) {
        if (classService.deleteById(id)) {
            return Result.success();
        }
        return Result.error("删除失败，该班级下还有学生");
    }
    
    // 学生端接口：获取当前登录学生的班级信息
    @GetMapping("/my-class")
    public Result<Class> getMyClass(@RequestAttribute("username") String username,
                                     @RequestAttribute("role") String role) {
        if (!"student".equals(role)) {
            return Result.error("无权访问");
        }
        return Result.success(classService.findByStudentNo(username));
    }
    
    // 学生端接口：获取当前登录学生的班级同学列表
    @GetMapping("/my-classmates")
    public Result<List<com.example.student.entity.Student>> getMyClassmates(@RequestAttribute("username") String username,
                                                                             @RequestAttribute("role") String role) {
        if (!"student".equals(role)) {
            return Result.error("无权访问");
        }
        return Result.success(classService.findClassmatesByStudentNo(username));
    }
}
