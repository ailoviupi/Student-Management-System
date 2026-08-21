package com.example.student.mapper;

import com.example.student.entity.CourseSchedule;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface CourseScheduleMapper {
    
    @Select("<script>" +
            "SELECT cs.*, c.course_name, c.course_code, cl.class_name, " +
            "u.real_name as teacher_name, cr.room_name as classroom_name, cr.room_code, cr.building " +
            "FROM course_schedule cs " +
            "LEFT JOIN course c ON cs.course_id = c.id " +
            "LEFT JOIN class cl ON cs.class_id = cl.id " +
            "LEFT JOIN user u ON cs.teacher_id = u.id " +
            "LEFT JOIN classroom cr ON cs.classroom_id = cr.id " +
            "WHERE cs.status = 1 " +
            "<if test='academicYear != null'> AND cs.academic_year = #{academicYear} </if>" +
            "<if test='semester != null'> AND cs.semester = #{semester} </if>" +
            "<if test='classId != null'> AND cs.class_id = #{classId} </if>" +
            "<if test='teacherId != null'> AND cs.teacher_id = #{teacherId} </if>" +
            "ORDER BY cs.day_of_week, cs.start_slot" +
            "</script>")
    List<CourseSchedule> findByCondition(@Param("academicYear") String academicYear,
                                         @Param("semester") String semester,
                                         @Param("classId") Integer classId,
                                         @Param("teacherId") Integer teacherId);
    
    @Select("SELECT cs.*, c.course_name, c.course_code, cl.class_name, " +
            "u.real_name as teacher_name, cr.room_name as classroom_name, cr.room_code, cr.building " +
            "FROM course_schedule cs " +
            "LEFT JOIN course c ON cs.course_id = c.id " +
            "LEFT JOIN class cl ON cs.class_id = cl.id " +
            "LEFT JOIN user u ON cs.teacher_id = u.id " +
            "LEFT JOIN classroom cr ON cs.classroom_id = cr.id " +
            "WHERE cs.id = #{id}")
    CourseSchedule findById(Integer id);
    
    @Select("SELECT COUNT(*) FROM course_schedule WHERE classroom_id = #{classroomId} AND day_of_week = #{dayOfWeek} " +
            "AND ((start_slot <= #{startSlot} AND end_slot >= #{startSlot}) OR (start_slot <= #{endSlot} AND end_slot >= #{endSlot})) " +
            "AND academic_year = #{academicYear} AND semester = #{semester} AND status = 1")
    int checkClassroomConflict(@Param("classroomId") Integer classroomId,
                               @Param("dayOfWeek") Integer dayOfWeek,
                               @Param("startSlot") Integer startSlot,
                               @Param("endSlot") Integer endSlot,
                               @Param("academicYear") String academicYear,
                               @Param("semester") String semester);
    
    @Select("SELECT COUNT(*) FROM course_schedule WHERE teacher_id = #{teacherId} AND day_of_week = #{dayOfWeek} " +
            "AND ((start_slot <= #{startSlot} AND end_slot >= #{startSlot}) OR (start_slot <= #{endSlot} AND end_slot >= #{endSlot})) " +
            "AND academic_year = #{academicYear} AND semester = #{semester} AND status = 1")
    int checkTeacherConflict(@Param("teacherId") Integer teacherId,
                             @Param("dayOfWeek") Integer dayOfWeek,
                             @Param("startSlot") Integer startSlot,
                             @Param("endSlot") Integer endSlot,
                             @Param("academicYear") String academicYear,
                             @Param("semester") String semester);
    
    @Insert("INSERT INTO course_schedule (course_id, class_id, teacher_id, classroom_id, academic_year, semester, " +
            "day_of_week, start_slot, end_slot, weeks, schedule_type, status) " +
            "VALUES (#{courseId}, #{classId}, #{teacherId}, #{classroomId}, #{academicYear}, #{semester}, " +
            "#{dayOfWeek}, #{startSlot}, #{endSlot}, #{weeks}, #{scheduleType}, #{status})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(CourseSchedule schedule);
    
    @Update("UPDATE course_schedule SET course_id = #{courseId}, class_id = #{classId}, teacher_id = #{teacherId}, " +
            "classroom_id = #{classroomId}, day_of_week = #{dayOfWeek}, start_slot = #{startSlot}, " +
            "end_slot = #{endSlot}, weeks = #{weeks} WHERE id = #{id}")
    int update(CourseSchedule schedule);
    
    @Delete("DELETE FROM course_schedule WHERE id = #{id}")
    int deleteById(Integer id);
    
    @Delete("DELETE FROM course_schedule WHERE academic_year = #{academicYear} AND semester = #{semester} AND schedule_type = 'AUTO'")
    int deleteByTerm(@Param("academicYear") String academicYear, @Param("semester") String semester);
}
