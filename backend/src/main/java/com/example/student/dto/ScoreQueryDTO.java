package com.example.student.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class ScoreQueryDTO extends PageDTO {
    private Integer studentId;
    private Integer courseId;
    private String examType;
    private String studentName;
}
