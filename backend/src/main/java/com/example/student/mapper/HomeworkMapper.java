package com.example.student.mapper;

import com.example.student.entity.Homework;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface HomeworkMapper {

    @Select("<script>" +
            "SELECT h.*, c.course_name as courseName, cl.class_name as className " +
            "FROM homework h " +
            "LEFT JOIN course c ON h.course_id = c.id " +
            "LEFT JOIN class cl ON h.class_id = cl.id " +
            "<where>" +
            "<if test='courseId != null'> AND h.course_id = #{courseId} </if>" +
            "<if test='classId != null'> AND h.class_id = #{classId} </if>" +
            "<if test='status != null'> AND h.status = #{status} </if>" +
            "<if test='title != null and title != \"\"'> AND h.title LIKE CONCAT('%', #{title}, '%') </if>" +
            "</where>" +
            "ORDER BY h.deadline DESC" +
            "</script>")
    List<Homework> findByCondition(@Param("courseId") Integer courseId,
                                    @Param("classId") Integer classId,
                                    @Param("status") Integer status,
                                    @Param("title") String title);

    @Select("SELECT h.*, c.course_name as courseName, cl.class_name as className " +
            "FROM homework h " +
            "LEFT JOIN course c ON h.course_id = c.id " +
            "LEFT JOIN class cl ON h.class_id = cl.id " +
            "WHERE h.id = #{id}")
    Homework findById(@Param("id") Integer id);

    @Insert("INSERT INTO homework (title, course_id, class_id, description, total_score, deadline, status, create_user) " +
            "VALUES (#{title}, #{courseId}, #{classId}, #{description}, #{totalScore}, #{deadline}, #{status}, #{createUser})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Homework homework);

    @Update("UPDATE homework SET title = #{title}, course_id = #{courseId}, class_id = #{classId}, " +
            "description = #{description}, total_score = #{totalScore}, deadline = #{deadline}, " +
            "status = #{status} WHERE id = #{id}")
    int update(Homework homework);

    @Delete("DELETE FROM homework WHERE id = #{id}")
    int deleteById(@Param("id") Integer id);

    @Select("SELECT h.*, c.course_name as courseName, cl.class_name as className " +
            "FROM homework h " +
            "LEFT JOIN course c ON h.course_id = c.id " +
            "LEFT JOIN class cl ON h.class_id = cl.id " +
            "WHERE h.class_id = #{classId} AND h.status = 1 " +
            "ORDER BY h.deadline ASC")
    List<Homework> findActiveByClassId(@Param("classId") Integer classId);
}