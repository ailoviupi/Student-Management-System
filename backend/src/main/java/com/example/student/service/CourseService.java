package com.example.student.service;

import com.example.student.entity.Course;
import java.util.List;

public interface CourseService {
    List<Course> findAll();
    Course findById(Integer id);
    boolean save(Course course);
    boolean update(Course course);
    boolean deleteById(Integer id);
}
