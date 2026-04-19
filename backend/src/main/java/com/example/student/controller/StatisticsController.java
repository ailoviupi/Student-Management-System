package com.example.student.controller;

import com.example.student.common.Result;
import com.example.student.service.StudentService;
import com.example.student.vo.StatisticsVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/statistics")
@CrossOrigin
public class StatisticsController {
    
    @Autowired
    private StudentService studentService;
    
    @GetMapping
    public Result<StatisticsVO> getStatistics() {
        return Result.success(studentService.getStatistics());
    }
}
