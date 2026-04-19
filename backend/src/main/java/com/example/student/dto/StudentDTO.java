package com.example.student.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.*;
import java.time.LocalDate;

@Data
@Schema(description = "学生信息DTO")
public class StudentDTO {
    
    private Integer id;
    
    @NotBlank(message = "学号不能为空")
    @Size(min = 3, max = 20, message = "学号长度必须在3-20之间")
    @Schema(description = "学号", required = true)
    private String studentNo;
    
    @NotBlank(message = "姓名不能为空")
    @Size(min = 2, max = 50, message = "姓名长度必须在2-50之间")
    @Schema(description = "姓名", required = true)
    private String name;
    
    @Min(value = 15, message = "年龄不能小于15")
    @Max(value = 60, message = "年龄不能大于60")
    @Schema(description = "年龄")
    private Integer age;
    
    @Pattern(regexp = "^(男|女)$", message = "性别必须是男或女")
    @Schema(description = "性别")
    private String gender;
    
    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "手机号格式不正确")
    @Schema(description = "手机号")
    private String phone;
    
    @Email(message = "邮箱格式不正确")
    @Schema(description = "邮箱")
    private String email;
    
    @Size(max = 200, message = "地址长度不能超过200")
    @Schema(description = "地址")
    private String address;
    
    @Schema(description = "班级ID")
    private Integer classId;
    
    @Schema(description = "入学日期")
    private LocalDate enrollmentDate;
    
    @Schema(description = "学生状态")
    private String studentStatus;
}
