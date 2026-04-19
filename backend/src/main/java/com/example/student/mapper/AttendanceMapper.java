package com.example.student.mapper;

import com.example.student.entity.Attendance;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface AttendanceMapper {

    @Select("<script>" +
            "SELECT a.*, st.name as studentName, st.student_no as studentNo, c.class_name as className " +
            "FROM attendance a " +
            "LEFT JOIN student st ON a.student_id = st.id " +
            "LEFT JOIN class c ON st.class_id = c.id " +
            "<where>" +
            "<if test='studentId != null'> AND a.student_id = #{studentId} </if>" +
            "<if test='status != null and status != \"\"'> AND a.status = #{status} </if>" +
            "<if test='startDate != null and startDate != \"\"'> AND a.attendance_date &gt;= #{startDate} </if>" +
            "<if test='endDate != null and endDate != \"\"'> AND a.attendance_date &lt;= #{endDate} </if>" +
            "</where>" +
            "ORDER BY a.attendance_date DESC, a.create_time DESC" +
            "</script>")
    List<Attendance> findByCondition(@Param("studentId") Integer studentId,
                                      @Param("status") String status,
                                      @Param("startDate") String startDate,
                                      @Param("endDate") String endDate);

    @Select("SELECT a.*, st.name as studentName, st.student_no as studentNo, c.class_name as className " +
            "FROM attendance a " +
            "LEFT JOIN student st ON a.student_id = st.id " +
            "LEFT JOIN class c ON st.class_id = c.id " +
            "WHERE a.id = #{id}")
    Attendance findById(@Param("id") Integer id);

    @Insert("INSERT INTO attendance (student_id, attendance_date, status, remark) " +
            "VALUES (#{studentId}, #{attendanceDate}, #{status}, #{remark})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Attendance attendance);

    @Update("UPDATE attendance SET student_id = #{studentId}, attendance_date = #{attendanceDate}, " +
            "status = #{status}, remark = #{remark} WHERE id = #{id}")
    int update(Attendance attendance);

    @Delete("DELETE FROM attendance WHERE id = #{id}")
    int deleteById(@Param("id") Integer id);

    @Select("SELECT status, COUNT(*) as count FROM attendance " +
            "WHERE attendance_date BETWEEN #{startDate} AND #{endDate} " +
            "GROUP BY status")
    List<java.util.Map<String, Object>> countByStatus(@Param("startDate") String startDate, @Param("endDate") String endDate);
    
    // 学生端查询方法
    @Select("<script>" +
            "SELECT a.*, st.name as studentName, st.student_no as studentNo, c.class_name as className " +
            "FROM attendance a " +
            "LEFT JOIN student st ON a.student_id = st.id " +
            "LEFT JOIN class c ON st.class_id = c.id " +
            "WHERE st.student_no = #{studentNo} " +
            "<if test='status != null and status != \"\"'> AND a.status = #{status} </if>" +
            "<if test='startDate != null and startDate != \"\"'> AND a.attendance_date &gt;= #{startDate} </if>" +
            "<if test='endDate != null and endDate != \"\"'> AND a.attendance_date &lt;= #{endDate} </if>" +
            "ORDER BY a.attendance_date DESC, a.create_time DESC" +
            "</script>")
    List<Attendance> findByStudentNo(@Param("studentNo") String studentNo,
                                      @Param("status") String status,
                                      @Param("startDate") String startDate,
                                      @Param("endDate") String endDate);
}
