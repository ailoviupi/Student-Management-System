package com.example.student.mapper;

import com.example.student.entity.ClassCourse;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface ClassCourseMapper {

    @Select("SELECT cc.*, c.class_name as className, co.course_name as courseName, co.course_code as courseCode " +
            "FROM class_course cc " +
            "LEFT JOIN class c ON cc.class_id = c.id " +
            "LEFT JOIN course co ON cc.course_id = co.id " +
            "WHERE cc.class_id = #{classId} " +
            "ORDER BY cc.priority DESC")
    List<ClassCourse> findByClassId(@Param("classId") Integer classId);

    @Select("SELECT cc.*, c.class_name as className, co.course_name as courseName, co.course_code as courseCode " +
            "FROM class_course cc " +
            "LEFT JOIN class c ON cc.class_id = c.id " +
            "LEFT JOIN course co ON cc.course_id = co.id " +
            "ORDER BY cc.priority DESC")
    List<ClassCourse> findAll();

    @Select("SELECT cc.*, c.class_name as className, co.course_name as courseName, co.course_code as courseCode " +
            "FROM class_course cc " +
            "LEFT JOIN class c ON cc.class_id = c.id " +
            "LEFT JOIN course co ON cc.course_id = co.id " +
            "WHERE cc.id = #{id}")
    ClassCourse findById(@Param("id") Integer id);

    @Insert("INSERT INTO class_course (class_id, course_id, weekly_hours, is_consecutive, consecutive_count, " +
            "priority, required_room_type, min_capacity, fixed_days, fixed_slots, remark) " +
            "VALUES (#{classId}, #{courseId}, #{weeklyHours}, #{isConsecutive}, #{consecutiveCount}, " +
            "#{priority}, #{requiredRoomType}, #{minCapacity}, #{fixedDays}, #{fixedSlots}, #{remark})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(ClassCourse classCourse);

    @Update("UPDATE class_course SET class_id = #{classId}, course_id = #{courseId}, weekly_hours = #{weeklyHours}, " +
            "is_consecutive = #{isConsecutive}, consecutive_count = #{consecutiveCount}, priority = #{priority}, " +
            "required_room_type = #{requiredRoomType}, min_capacity = #{minCapacity}, fixed_days = #{fixedDays}, " +
            "fixed_slots = #{fixedSlots}, remark = #{remark} WHERE id = #{id}")
    int update(ClassCourse classCourse);

    @Delete("DELETE FROM class_course WHERE id = #{id}")
    int deleteById(@Param("id") Integer id);

    @Delete("DELETE FROM class_course WHERE class_id = #{classId}")
    int deleteByClassId(@Param("classId") Integer classId);
}
