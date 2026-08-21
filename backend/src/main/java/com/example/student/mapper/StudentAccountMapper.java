package com.example.student.mapper;

import com.example.student.entity.StudentAccount;
import org.apache.ibatis.annotations.*;

/**
 * 学生账号 Mapper：支持按学号查询、首次登录建档、修改密码。
 */
@Mapper
public interface StudentAccountMapper {

    /**
     * 按学号查询学生账号（关联 student 表）
     */
    @Select("SELECT sa.* FROM student_account sa " +
            "JOIN student s ON sa.student_id = s.id " +
            "WHERE s.student_no = #{studentNo}")
    StudentAccount findByStudentNo(@Param("studentNo") String studentNo);

    /**
     * 首次登录自动建档
     */
    @Insert("INSERT INTO student_account (student_id, password, status) VALUES (#{studentId}, #{password}, 1)")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(StudentAccount account);

    /**
     * 修改密码
     */
    @Update("UPDATE student_account SET password = #{password}, update_time = NOW() WHERE id = #{id}")
    int updatePassword(@Param("id") Integer id, @Param("password") String password);
}
