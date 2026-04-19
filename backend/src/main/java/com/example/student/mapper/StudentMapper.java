package com.example.student.mapper;

import com.example.student.entity.Student;
import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Map;

@Mapper
public interface StudentMapper {
    
    @Select("<script>" +
            "SELECT s.*, c.class_name as className FROM student s LEFT JOIN class c ON s.class_id = c.id " +
            "<where>" +
            "<if test='name != null and name != \"\"'>AND s.name LIKE CONCAT('%', #{name}, '%')</if>" +
            "<if test='studentNo != null and studentNo != \"\"'>AND s.student_no LIKE CONCAT('%', #{studentNo}, '%')</if>" +
            "<if test='classId != null'>AND s.class_id = #{classId}</if>" +
            "<if test='gender != null and gender != \"\"'>AND s.gender = #{gender}</if>" +
            "<if test='studentStatus != null and studentStatus != \"\"'>AND s.student_status = #{studentStatus}</if>" +
            "</where>" +
            "ORDER BY s.create_time DESC" +
            "</script>")
    List<Student> findByCondition(@Param("name") String name,
                                   @Param("studentNo") String studentNo,
                                   @Param("classId") Integer classId,
                                   @Param("gender") String gender,
                                   @Param("studentStatus") String studentStatus);
    
    @Select("SELECT s.*, c.class_name as className FROM student s LEFT JOIN class c ON s.class_id = c.id WHERE s.id = #{id}")
    Student findById(@Param("id") Integer id);
    
    @Select("SELECT s.*, c.class_name as className FROM student s LEFT JOIN class c ON s.class_id = c.id WHERE s.student_no = #{studentNo}")
    Student findByStudentNo(@Param("studentNo") String studentNo);
    
    @Insert("INSERT INTO student (student_no, name, age, gender, phone, email, address, class_id, enrollment_date, student_status) " +
            "VALUES (#{studentNo}, #{name}, #{age}, #{gender}, #{phone}, #{email}, #{address}, #{classId}, #{enrollmentDate}, #{studentStatus})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Student student);
    
    @Update("UPDATE student SET student_no = #{studentNo}, name = #{name}, age = #{age}, gender = #{gender}, " +
            "phone = #{phone}, email = #{email}, address = #{address}, class_id = #{classId}, " +
            "enrollment_date = #{enrollmentDate}, student_status = #{studentStatus} WHERE id = #{id}")
    int update(Student student);
    
    @Delete("DELETE FROM student WHERE id = #{id}")
    int deleteById(@Param("id") Integer id);
    
    @Select("SELECT gender, COUNT(*) as count FROM student GROUP BY gender")
    List<Map<String, Object>> countByGender();
    
    @Select("SELECT student_status as studentStatus, COUNT(*) as count FROM student GROUP BY student_status")
    List<Map<String, Object>> countByStatus();
    
    @Select("SELECT c.class_name as className, COUNT(*) as count FROM student s JOIN class c ON s.class_id = c.id GROUP BY s.class_id")
    List<Map<String, Object>> countByClass();
    
    @Select("SELECT COUNT(*) FROM student")
    long countAll();
}
