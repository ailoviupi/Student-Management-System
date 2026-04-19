package com.example.student.vo;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class ScoreRankVO {
    private Integer rank;
    private String studentNo;
    private String studentName;
    private String className;
    private String courseName;
    private BigDecimal score;
    private BigDecimal averageScore;
    private Integer totalCourses;
}
