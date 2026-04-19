package com.example.student.service;

import com.example.student.dto.ScoreQueryDTO;
import com.example.student.entity.Score;
import com.example.student.vo.PageVO;
import com.example.student.vo.ScoreRankVO;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public interface ScoreService {
    PageVO<Score> findByCondition(ScoreQueryDTO queryDTO);
    Score findById(Integer id);
    boolean save(Score score);
    boolean update(Score score);
    boolean deleteById(Integer id);
    Map<String, Object> getStatistics();
    List<Score> findAllForExport();
    List<ScoreRankVO> findRankByCourse(Integer courseId);
    List<ScoreRankVO> findOverallRank();
    Map<String, Object> getScoreAnalysis();
    
    // 学生端方法
    List<Score> findByStudentNo(String studentNo);
    Map<String, Object> getStudentStatistics(String studentNo);
}
