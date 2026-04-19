package com.example.student.vo;

import com.alibaba.excel.annotation.ExcelProperty;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class ScoreExportVO {
    
    @ExcelProperty("学号")
    private String studentNo;
    
    @ExcelProperty("姓名")
    private String studentName;
    
    @ExcelProperty("班级")
    private String className;
    
    @ExcelProperty("课程代码")
    private String courseCode;
    
    @ExcelProperty("课程名称")
    private String courseName;
    
    @ExcelProperty("成绩")
    private BigDecimal score;
    
    @ExcelProperty("考试类型")
    private String examType;
    
    @ExcelProperty("考试日期")
    private String examDate;
    
    @ExcelProperty("备注")
    private String remark;
}
