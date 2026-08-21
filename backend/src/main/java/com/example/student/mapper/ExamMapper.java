package com.example.student.mapper;

import com.example.student.entity.Exam;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface ExamMapper {

    @Select("<script>" +
            "SELECT e.*, c.course_name as courseName, cl.class_name as className, cr.room_name as classroomName " +
            "FROM exam e " +
            "LEFT JOIN course c ON e.course_id = c.id " +
            "LEFT JOIN class cl ON e.class_id = cl.id " +
            "LEFT JOIN classroom cr ON e.classroom_id = cr.id " +
            "<where>" +
            "<if test='courseId != null'> AND e.course_id = #{courseId} </if>" +
            "<if test='classId != null'> AND e.class_id = #{classId} </if>" +
            "<if test='status != null'> AND e.status = #{status} </if>" +
            "<if test='examType != null and examType != \"\"'> AND e.exam_type = #{examType} </if>" +
            "<if test='examName != null and examName != \"\"'> AND e.exam_name LIKE CONCAT('%', #{examName}, '%') </if>" +
            "</where>" +
            "ORDER BY e.exam_date DESC, e.start_time ASC" +
            "</script>")
    List<Exam> findByCondition(@Param("courseId") Integer courseId,
                                @Param("classId") Integer classId,
                                @Param("status") Integer status,
                                @Param("examType") String examType,
                                @Param("examName") String examName);

    @Select("SELECT e.*, c.course_name as courseName, cl.class_name as className, cr.room_name as classroomName " +
            "FROM exam e " +
            "LEFT JOIN course c ON e.course_id = c.id " +
            "LEFT JOIN class cl ON e.class_id = cl.id " +
            "LEFT JOIN classroom cr ON e.classroom_id = cr.id " +
            "WHERE e.id = #{id}")
    Exam findById(@Param("id") Integer id);

    @Insert("INSERT INTO exam (exam_name, course_id, class_id, exam_type, exam_date, start_time, end_time, " +
            "classroom_id, total_score, status, remark, create_user) " +
            "VALUES (#{examName}, #{courseId}, #{classId}, #{examType}, #{examDate}, #{startTime}, #{endTime}, " +
            "#{classroomId}, #{totalScore}, #{status}, #{remark}, #{createUser})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Exam exam);

    @Update("UPDATE exam SET exam_name = #{examName}, course_id = #{courseId}, class_id = #{classId}, " +
            "exam_type = #{examType}, exam_date = #{examDate}, start_time = #{startTime}, end_time = #{endTime}, " +
            "classroom_id = #{classroomId}, total_score = #{totalScore}, status = #{status}, remark = #{remark} " +
            "WHERE id = #{id}")
    int update(Exam exam);

    @Delete("DELETE FROM exam WHERE id = #{id}")
    int deleteById(@Param("id") Integer id);

    @Select("SELECT e.*, c.course_name as courseName, cl.class_name as className, cr.room_name as classroomName " +
            "FROM exam e " +
            "LEFT JOIN course c ON e.course_id = c.id " +
            "LEFT JOIN class cl ON e.class_id = cl.id " +
            "LEFT JOIN classroom cr ON e.classroom_id = cr.id " +
            "WHERE e.class_id = #{classId} AND e.status IN (0, 1) " +
            "ORDER BY e.exam_date ASC, e.start_time ASC")
    List<Exam> findUpcomingByClassId(@Param("classId") Integer classId);
}