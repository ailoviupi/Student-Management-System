package com.example.student.mapper;

import com.example.student.entity.Course;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface CourseMapper {
    
    @Select("SELECT c.*, u.real_name as teacherName FROM course c LEFT JOIN user u ON c.teacher_id = u.id")
    List<Course> findAll();
    
    @Select("SELECT c.*, u.real_name as teacherName FROM course c LEFT JOIN user u ON c.teacher_id = u.id WHERE c.id = #{id}")
    Course findById(@Param("id") Integer id);
    
    @Insert("INSERT INTO course (course_code, course_name, credit, hours, teacher_id, description) VALUES (#{courseCode}, #{courseName}, #{credit}, #{hours}, #{teacherId}, #{description})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Course course);
    
    @Update("UPDATE course SET course_code = #{courseCode}, course_name = #{courseName}, credit = #{credit}, hours = #{hours}, teacher_id = #{teacherId}, description = #{description} WHERE id = #{id}")
    int update(Course course);
    
    @Delete("DELETE FROM course WHERE id = #{id}")
    int deleteById(@Param("id") Integer id);
}
