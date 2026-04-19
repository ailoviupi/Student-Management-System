package com.example.student.controller;

import com.example.student.common.Result;
import com.example.student.entity.Course;
import com.example.student.service.CourseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/courses")
@CrossOrigin
public class CourseController {
    
    @Autowired
    private CourseService courseService;
    
    @GetMapping
    public Result<List<Course>> list() {
        return Result.success(courseService.findAll());
    }
    
    @GetMapping("/{id}")
    public Result<Course> getById(@PathVariable Integer id) {
        Course course = courseService.findById(id);
        if (course != null) {
            return Result.success(course);
        }
        return Result.error("课程不存在");
    }
    
    @PostMapping
    public Result<Void> save(@RequestBody Course course) {
        if (courseService.save(course)) {
            return Result.success();
        }
        return Result.error("新增失败");
    }
    
    @PutMapping
    public Result<Void> update(@RequestBody Course course) {
        if (courseService.update(course)) {
            return Result.success();
        }
        return Result.error("修改失败");
    }
    
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Integer id) {
        if (courseService.deleteById(id)) {
            return Result.success();
        }
        return Result.error("删除失败");
    }
}
