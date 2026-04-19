package com.example.student.mapper;

import com.example.student.entity.Class;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface ClassMapper {
    
    @Select("SELECT c.*, u.real_name as teacherName FROM class c LEFT JOIN user u ON c.teacher_id = u.id")
    List<Class> findAll();
    
    @Select("SELECT c.*, u.real_name as teacherName FROM class c LEFT JOIN user u ON c.teacher_id = u.id WHERE c.id = #{id}")
    Class findById(@Param("id") Integer id);
    
    @Insert("INSERT INTO class (class_name, grade, major, teacher_id) VALUES (#{className}, #{grade}, #{major}, #{teacherId})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Class clazz);
    
    @Update("UPDATE class SET class_name = #{className}, grade = #{grade}, major = #{major}, teacher_id = #{teacherId} WHERE id = #{id}")
    int update(Class clazz);
    
    @Delete("DELETE FROM class WHERE id = #{id}")
    int deleteById(@Param("id") Integer id);
    
    @Select("SELECT COUNT(*) FROM student WHERE class_id = #{classId}")
    int countStudents(@Param("classId") Integer classId);
}
