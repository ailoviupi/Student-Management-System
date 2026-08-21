package com.example.student.mapper;

import com.example.student.entity.StudentWarning;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface StudentWarningMapper {
    
    @Select("<script>" +
            "SELECT sw.*, s.name as student_name, s.student_no, c.class_name, " +
            "co.course_name, u.real_name as handler_name " +
            "FROM student_warning sw " +
            "LEFT JOIN student s ON sw.student_id = s.id " +
            "LEFT JOIN class c ON s.class_id = c.id " +
            "LEFT JOIN course co ON sw.related_course_id = co.id " +
            "LEFT JOIN user u ON sw.handler_id = u.id " +
            "WHERE 1=1 " +
            "<if test='status != null'> AND sw.status = #{status} </if>" +
            "<if test='warningLevel != null'> AND sw.warning_level = #{warningLevel} </if>" +
            "<if test='warningType != null'> AND sw.warning_type = #{warningType} </if>" +
            "<if test='studentId != null'> AND sw.student_id = #{studentId} </if>" +
            "ORDER BY sw.create_time DESC" +
            "</script>")
    List<StudentWarning> findByCondition(@Param("status") String status,
                                         @Param("warningLevel") String warningLevel,
                                         @Param("warningType") String warningType,
                                         @Param("studentId") Integer studentId);
    
    @Select("SELECT sw.*, s.name as student_name, s.student_no, c.class_name, " +
            "co.course_name, u.real_name as handler_name " +
            "FROM student_warning sw " +
            "LEFT JOIN student s ON sw.student_id = s.id " +
            "LEFT JOIN class c ON s.class_id = c.id " +
            "LEFT JOIN course co ON sw.related_course_id = co.id " +
            "LEFT JOIN user u ON sw.handler_id = u.id " +
            "WHERE sw.id = #{id}")
    StudentWarning findById(Integer id);
    
    @Insert("INSERT INTO student_warning (student_id, rule_id, warning_type, warning_level, " +
            "warning_reason, related_course_id, related_score, attendance_count, status, notify_status) " +
            "VALUES (#{studentId}, #{ruleId}, #{warningType}, #{warningLevel}, " +
            "#{warningReason}, #{relatedCourseId}, #{relatedScore}, #{attendanceCount}, #{status}, #{notifyStatus})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(StudentWarning warning);
    
    @Update("UPDATE student_warning SET status = #{status}, handler_id = #{handlerId}, " +
            "handle_remark = #{handleRemark}, handle_time = NOW() WHERE id = #{id}")
    int handleWarning(@Param("id") Integer id, @Param("status") String status,
                      @Param("handlerId") Integer handlerId, @Param("handleRemark") String handleRemark);
    
    @Update("UPDATE student_warning SET notify_status = 1 WHERE id = #{id}")
    int updateNotifyStatus(Integer id);
    
    @Delete("DELETE FROM student_warning WHERE id = #{id}")
    int deleteById(Integer id);
    
    @Select("SELECT COUNT(*) FROM student_warning WHERE status = 'PENDING'")
    int countPending();
    
    @Select("SELECT COUNT(*) FROM student_warning WHERE warning_level = #{level} AND status = 'PENDING'")
    int countByLevel(String level);
}
