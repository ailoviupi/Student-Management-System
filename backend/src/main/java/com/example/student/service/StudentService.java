package com.example.student.service;

import com.example.student.dto.StudentQueryDTO;
import com.example.student.entity.Student;
import com.example.student.vo.PageVO;
import com.example.student.vo.StatisticsVO;

import java.util.List;

public interface StudentService {
    PageVO<Student> findByCondition(StudentQueryDTO queryDTO);
    Student findById(Integer id);
    Student findByStudentNo(String studentNo);
    boolean save(Student student);
    boolean update(Student student);
    boolean deleteById(Integer id);
    StatisticsVO getStatistics();
}
