package com.example.student.service.impl;

import com.example.student.dto.ScoreQueryDTO;
import com.example.student.entity.Score;
import com.example.student.mapper.ScoreMapper;
import com.example.student.service.ScoreService;
import com.example.student.vo.PageVO;
import com.example.student.vo.ScoreRankVO;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ScoreServiceImpl implements ScoreService {
    
    @Autowired
    private ScoreMapper scoreMapper;
    
    @Override
    public PageVO<Score> findByCondition(ScoreQueryDTO queryDTO) {
        PageHelper.startPage(queryDTO.getPageNum(), queryDTO.getPageSize());
        List<Score> list = scoreMapper.findByCondition(
            queryDTO.getStudentId(),
            queryDTO.getCourseId(),
            queryDTO.getExamType(),
            queryDTO.getStudentName()
        );
        PageInfo<Score> pageInfo = new PageInfo<>(list);
        return new PageVO<>(pageInfo.getList(), pageInfo.getTotal(), pageInfo.getPageNum(), pageInfo.getPageSize());
    }
    
    @Override
    public Score findById(Integer id) {
        return scoreMapper.findById(id);
    }
    
    @Override
    public boolean save(Score score) {
        // 先查询是否已存在相同学生、课程、考试类型的成绩记录
        Score existingScore = scoreMapper.findByStudentAndCourseAndExamType(
            score.getStudentId(), 
            score.getCourseId(), 
            score.getExamType()
        );
        
        if (existingScore != null) {
            // 已存在则更新
            score.setId(existingScore.getId());
            return scoreMapper.update(score) > 0;
        } else {
            // 不存在则插入
            return scoreMapper.insert(score) > 0;
        }
    }
    
    @Override
    public boolean update(Score score) {
        return scoreMapper.update(score) > 0;
    }
    
    @Override
    public boolean deleteById(Integer id) {
        return scoreMapper.deleteById(id) > 0;
    }
    
    @Override
    public Map<String, Object> getStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        List<Map<String, Object>> courseScores = scoreMapper.getCourseAverageScores();
        stats.put("courseAverageScores", courseScores);
        
        int total = scoreMapper.countTotalScores();
        int pass = scoreMapper.countPassScores();
        
        if (total > 0) {
            BigDecimal passRate = new BigDecimal(pass)
                    .multiply(new BigDecimal(100))
                    .divide(new BigDecimal(total), 2, RoundingMode.HALF_UP);
            stats.put("passRate", passRate);
        } else {
            stats.put("passRate", BigDecimal.ZERO);
        }
        
        return stats;
    }
    
    @Override
    public List<Score> findAllForExport() {
        return scoreMapper.findAllForExport();
    }
    
    @Override
    public List<ScoreRankVO> findRankByCourse(Integer courseId) {
        return scoreMapper.findRankByCourse(courseId);
    }
    
    @Override
    public List<ScoreRankVO> findOverallRank() {
        return scoreMapper.findOverallRank();
    }
    
    @Override
    public Map<String, Object> getScoreAnalysis() {
        Map<String, Object> analysis = new HashMap<>();
        
        // 成绩分布统计
        analysis.put("distribution", scoreMapper.getScoreDistribution());
        
        // 各课程成绩分析
        analysis.put("courseAnalysis", scoreMapper.getCourseScoreAnalysis());
        
        // 成绩趋势（近6个月）
        analysis.put("trend", scoreMapper.getScoreTrend());
        
        return analysis;
    }
    
    @Override
    public List<Score> findByStudentNo(String studentNo) {
        return scoreMapper.findByStudentNo(studentNo);
    }
    
    @Override
    public Map<String, Object> getStudentStatistics(String studentNo) {
        Map<String, Object> stats = new HashMap<>();
        
        List<Score> scores = scoreMapper.findByStudentNo(studentNo);
        stats.put("scores", scores);
        
        if (scores != null && !scores.isEmpty()) {
            // 计算平均分
            BigDecimal total = BigDecimal.ZERO;
            int count = 0;
            int passCount = 0;
            BigDecimal maxScore = BigDecimal.ZERO;
            BigDecimal minScore = new BigDecimal(100);
            
            for (Score score : scores) {
                if (score.getScore() != null) {
                    total = total.add(score.getScore());
                    count++;
                    if (score.getScore().compareTo(new BigDecimal(60)) >= 0) {
                        passCount++;
                    }
                    if (score.getScore().compareTo(maxScore) > 0) {
                        maxScore = score.getScore();
                    }
                    if (score.getScore().compareTo(minScore) < 0) {
                        minScore = score.getScore();
                    }
                }
            }
            
            if (count > 0) {
                stats.put("averageScore", total.divide(new BigDecimal(count), 2, RoundingMode.HALF_UP));
                stats.put("maxScore", maxScore);
                stats.put("minScore", minScore);
                stats.put("totalCourses", count);
                stats.put("passCount", passCount);
                stats.put("passRate", new BigDecimal(passCount)
                        .multiply(new BigDecimal(100))
                        .divide(new BigDecimal(count), 2, RoundingMode.HALF_UP));
            }
        }
        
        return stats;
    }
}
