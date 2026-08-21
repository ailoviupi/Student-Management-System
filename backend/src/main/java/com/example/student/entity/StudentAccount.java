package com.example.student.entity;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 学生账号表实体。
 *
 * <p>学生独立密码体系：管理员/教师密码存于 user 表，学生密码存于 student_account 表。
 * 首次使用默认密码（学号后6位或 123456）登录时自动建档，登录后可在个人中心修改密码。</p>
 */
@Data
public class StudentAccount {
    private Integer id;
    /** 学生ID（关联 student.id） */
    private Integer studentId;
    /** BCrypt 加密后的密码 */
    private String password;
    /** 状态: 0-禁用, 1-正常 */
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
