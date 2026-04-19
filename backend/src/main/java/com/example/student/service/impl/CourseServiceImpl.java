package com.example.student.service.impl;

import com.example.student.entity.Course;
import com.example.student.mapper.CourseMapper;
import com.example.student.service.CourseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CourseServiceImpl implements CourseService {
    
    @Autowired
    private CourseMapper courseMapper;
    
    @Override
    public List<Course> findAll() {
        return courseMapper.findAll();
    }
    
    @Override
    public Course findById(Integer id) {
        return courseMapper.findById(id);
    }
    
    @Override
    public boolean save(Course course) {
        return courseMapper.insert(course) > 0;
    }
    
    @Override
    public boolean update(Course course) {
        return courseMapper.update(course) > 0;
    }
    
    @Override
    public boolean deleteById(Integer id) {
        return courseMapper.deleteById(id) > 0;
    }
}
