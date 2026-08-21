package com.example.student.service;

import com.example.student.entity.Exam;
import com.example.student.vo.PageVO;

import java.util.List;

public interface ExamService {
    PageVO<Exam> findByCondition(Integer courseId, Integer classId, Integer status, String examType, String examName, int page, int size);
    Exam findById(Integer id);
    boolean save(Exam exam);
    boolean update(Exam exam);
    boolean deleteById(Integer id);

    // 学生端
    List<Exam> findMyExams(Integer classId);
}