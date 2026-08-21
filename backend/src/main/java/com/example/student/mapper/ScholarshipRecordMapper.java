package com.example.student.mapper;

import com.example.student.entity.ScholarshipRecord;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface ScholarshipRecordMapper {
    
    @Select("<script>" +
            "SELECT sr.*, s.name as student_name, s.student_no, c.class_name, " +
            "st.type_name as scholarship_type_name, st.amount as scholarship_amount, u.real_name as reviewer_name " +
            "FROM scholarship_record sr " +
            "LEFT JOIN student s ON sr.student_id = s.id " +
            "LEFT JOIN class c ON s.class_id = c.id " +
            "LEFT JOIN scholarship_type st ON sr.scholarship_type_id = st.id " +
            "LEFT JOIN user u ON sr.reviewer_id = u.id " +
            "WHERE 1=1 " +
            "<if test='academicYear != null'> AND sr.academic_year = #{academicYear} </if>" +
            "<if test='semester != null'> AND sr.semester = #{semester} </if>" +
            "<if test='status != null'> AND sr.status = #{status} </if>" +
            "<if test='scholarshipTypeId != null'> AND sr.scholarship_type_id = #{scholarshipTypeId} </if>" +
            "<if test='studentId != null'> AND sr.student_id = #{studentId} </if>" +
            "ORDER BY sr.total_score DESC, sr.create_time DESC" +
            "</script>")
    List<ScholarshipRecord> findByCondition(@Param("academicYear") String academicYear,
                                            @Param("semester") String semester,
                                            @Param("status") String status,
                                            @Param("scholarshipTypeId") Integer scholarshipTypeId,
                                            @Param("studentId") Integer studentId);
    
    @Select("SELECT sr.*, s.name as student_name, s.student_no, c.class_name, " +
            "st.type_name as scholarship_type_name, st.amount as scholarship_amount, u.real_name as reviewer_name " +
            "FROM scholarship_record sr " +
            "LEFT JOIN student s ON sr.student_id = s.id " +
            "LEFT JOIN class c ON s.class_id = c.id " +
            "LEFT JOIN scholarship_type st ON sr.scholarship_type_id = st.id " +
            "LEFT JOIN user u ON sr.reviewer_id = u.id " +
            "WHERE sr.id = #{id}")
    ScholarshipRecord findById(Integer id);
    
    @Insert("INSERT INTO scholarship_record (student_id, scholarship_type_id, academic_year, semester, " +
            "gpa, ranking, total_score, score_details, status) " +
            "VALUES (#{studentId}, #{scholarshipTypeId}, #{academicYear}, #{semester}, " +
            "#{gpa}, #{ranking}, #{totalScore}, #{scoreDetails}, #{status})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(ScholarshipRecord record);
    
    @Update("UPDATE scholarship_record SET status = #{status}, reviewer_id = #{reviewerId}, " +
            "review_remark = #{reviewRemark}, review_time = NOW() WHERE id = #{id}")
    int review(@Param("id") Integer id, @Param("status") String status,
               @Param("reviewerId") Integer reviewerId, @Param("reviewRemark") String reviewRemark);
    
    @Delete("DELETE FROM scholarship_record WHERE id = #{id}")
    int deleteById(Integer id);
    
    @Select("SELECT COUNT(*) FROM scholarship_record WHERE scholarship_type_id = #{typeId} AND status = 'APPROVED'")
    int countApprovedByType(Integer typeId);
    
    @Select("SELECT COUNT(*) FROM scholarship_record WHERE student_id = #{studentId} AND academic_year = #{academicYear} AND semester = #{semester} AND status = 'APPROVED'")
    int countByStudentAndYear(@Param("studentId") Integer studentId, @Param("academicYear") String academicYear, @Param("semester") String semester);

    @Delete("DELETE FROM scholarship_record WHERE academic_year = #{academicYear} AND semester = #{semester} AND status = 'PENDING'")
    int deleteAutoRecordsByTerm(@Param("academicYear") String academicYear, @Param("semester") String semester);
}
