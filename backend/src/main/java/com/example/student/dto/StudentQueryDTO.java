package com.example.student.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class StudentQueryDTO extends PageDTO {
    private String name;
    private String studentNo;
    private Integer classId;
    private String gender;
    private String studentStatus;
}
