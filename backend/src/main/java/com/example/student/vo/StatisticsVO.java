package com.example.student.vo;

import lombok.Data;
import java.math.BigDecimal;
import java.util.Map;

@Data
public class StatisticsVO {
    private Long totalStudents;
    private Long totalClasses;
    private Long totalCourses;
    private Long totalUsers;
    
    private Map<String, Long> genderDistribution;
    private Map<String, Long> statusDistribution;
    private Map<String, Long> classDistribution;
    
    private BigDecimal averageScore;
    private BigDecimal passRate;
    private Map<String, BigDecimal> courseAverageScores;
}
