package com.example.student.service;

import com.example.student.entity.Homework;
import com.example.student.entity.HomeworkSubmission;
import com.example.student.vo.PageVO;

import java.util.List;
import java.util.Map;

public interface HomeworkService {
    PageVO<Homework> findByCondition(Integer courseId, Integer classId, Integer status, String title, int page, int size);
    Homework findById(Integer id);
    boolean save(Homework homework);
    boolean update(Homework homework);
    boolean deleteById(Integer id);

    // 作业提交相关
    PageVO<HomeworkSubmission> findSubmissions(Integer homeworkId, Integer status, int page, int size);
    HomeworkSubmission findSubmissionById(Integer id);
    boolean submit(HomeworkSubmission submission);
    boolean updateSubmission(HomeworkSubmission submission);
    boolean gradeSubmission(Integer id, Double score, String feedback, Integer gradeUser);

    // 统计
    Map<String, Object> getStatistics(Integer homeworkId);

    // 学生端
    List<Homework> findMyHomework(Integer classId);
    HomeworkSubmission findMySubmission(Integer homeworkId, Integer studentId);
}