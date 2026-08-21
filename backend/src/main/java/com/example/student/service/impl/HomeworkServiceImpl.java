package com.example.student.service.impl;

import com.example.student.entity.Homework;
import com.example.student.entity.HomeworkSubmission;
import com.example.student.mapper.HomeworkMapper;
import com.example.student.mapper.HomeworkSubmissionMapper;
import com.example.student.service.HomeworkService;
import com.example.student.vo.PageVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class HomeworkServiceImpl implements HomeworkService {

    @Autowired
    private HomeworkMapper homeworkMapper;

    @Autowired
    private HomeworkSubmissionMapper submissionMapper;

    @Override
    public PageVO<Homework> findByCondition(Integer courseId, Integer classId, Integer status, String title, int page, int size) {
        List<Homework> list = homeworkMapper.findByCondition(courseId, classId, status, title);
        int total = list.size();
        int start = (page - 1) * size;
        int end = Math.min(start + size, total);
        List<Homework> pageList = list.subList(start, end);
        return new PageVO<>(pageList, (long) total, page, size);
    }

    @Override
    public Homework findById(Integer id) {
        return homeworkMapper.findById(id);
    }

    @Override
    public boolean save(Homework homework) {
        homework.setStatus(1); // 默认进行中
        return homeworkMapper.insert(homework) > 0;
    }

    @Override
    public boolean update(Homework homework) {
        return homeworkMapper.update(homework) > 0;
    }

    @Override
    public boolean deleteById(Integer id) {
        return homeworkMapper.deleteById(id) > 0;
    }

    @Override
    public PageVO<HomeworkSubmission> findSubmissions(Integer homeworkId, Integer status, int page, int size) {
        List<HomeworkSubmission> list = submissionMapper.findByCondition(homeworkId, null, status);
        int total = list.size();
        int start = (page - 1) * size;
        int end = Math.min(start + size, total);
        List<HomeworkSubmission> pageList = list.subList(start, end);
        return new PageVO<>(pageList, (long) total, page, size);
    }

    @Override
    public HomeworkSubmission findSubmissionById(Integer id) {
        return submissionMapper.findById(id);
    }

    @Override
    public boolean submit(HomeworkSubmission submission) {
        // 检查是否已提交
        HomeworkSubmission existing = submissionMapper.findByHomeworkAndStudent(
                submission.getHomeworkId(), submission.getStudentId());
        if (existing != null) {
            // 更新提交
            submission.setId(existing.getId());
            return submissionMapper.update(submission) > 0;
        }
        return submissionMapper.insert(submission) > 0;
    }

    @Override
    public boolean updateSubmission(HomeworkSubmission submission) {
        return submissionMapper.update(submission) > 0;
    }

    @Override
    public boolean gradeSubmission(Integer id, Double score, String feedback, Integer gradeUser) {
        return submissionMapper.grade(id, score, feedback, gradeUser) > 0;
    }

    @Override
    public Map<String, Object> getStatistics(Integer homeworkId) {
        Map<String, Object> stats = new HashMap<>();
        int total = submissionMapper.countByHomeworkId(homeworkId);
        int graded = submissionMapper.countGradedByHomeworkId(homeworkId);
        stats.put("total", total);
        stats.put("graded", graded);
        stats.put("ungraded", total - graded);
        return stats;
    }

    @Override
    public List<Homework> findMyHomework(Integer classId) {
        return homeworkMapper.findActiveByClassId(classId);
    }

    @Override
    public HomeworkSubmission findMySubmission(Integer homeworkId, Integer studentId) {
        return submissionMapper.findByHomeworkAndStudent(homeworkId, studentId);
    }
}