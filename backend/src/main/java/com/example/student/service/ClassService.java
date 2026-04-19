package com.example.student.service;

import com.example.student.entity.Class;
import com.example.student.entity.Student;
import java.util.List;

public interface ClassService {
    List<Class> findAll();
    Class findById(Integer id);
    boolean save(Class clazz);
    boolean update(Class clazz);
    boolean deleteById(Integer id);
    
    // 学生端方法
    Class findByStudentNo(String studentNo);
    List<Student> findClassmatesByStudentNo(String studentNo);
}
