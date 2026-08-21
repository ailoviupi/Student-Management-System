package com.example.student.service.impl;

import com.example.student.entity.Exam;
import com.example.student.mapper.ExamMapper;
import com.example.student.service.ExamService;
import com.example.student.vo.PageVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ExamServiceImpl implements ExamService {

    @Autowired
    private ExamMapper examMapper;

    @Override
    public PageVO<Exam> findByCondition(Integer courseId, Integer classId, Integer status, String examType, String examName, int page, int size) {
        List<Exam> list = examMapper.findByCondition(courseId, classId, status, examType, examName);
        int total = list.size();
        int start = (page - 1) * size;
        int end = Math.min(start + size, total);
        List<Exam> pageList = list.subList(start, end);
        return new PageVO<>(pageList, (long) total, page, size);
    }

    @Override
    public Exam findById(Integer id) {
        return examMapper.findById(id);
    }

    @Override
    public boolean save(Exam exam) {
        exam.setStatus(0); // 默认未开始
        return examMapper.insert(exam) > 0;
    }

    @Override
    public boolean update(Exam exam) {
        return examMapper.update(exam) > 0;
    }

    @Override
    public boolean deleteById(Integer id) {
        return examMapper.deleteById(id) > 0;
    }

    @Override
    public List<Exam> findMyExams(Integer classId) {
        return examMapper.findUpcomingByClassId(classId);
    }
}