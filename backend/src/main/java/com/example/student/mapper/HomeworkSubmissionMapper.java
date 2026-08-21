package com.example.student.mapper;

import com.example.student.entity.HomeworkSubmission;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface HomeworkSubmissionMapper {

    @Select("<script>" +
            "SELECT hs.*, st.name as studentName, st.student_no as studentNo " +
            "FROM homework_submission hs " +
            "LEFT JOIN student st ON hs.student_id = st.id " +
            "<where>" +
            "<if test='homeworkId != null'> AND hs.homework_id = #{homeworkId} </if>" +
            "<if test='studentId != null'> AND hs.student_id = #{studentId} </if>" +
            "<if test='status != null'> AND hs.status = #{status} </if>" +
            "</where>" +
            "ORDER BY hs.submit_time DESC" +
            "</script>")
    List<HomeworkSubmission> findByCondition(@Param("homeworkId") Integer homeworkId,
                                              @Param("studentId") Integer studentId,
                                              @Param("status") Integer status);

    @Select("SELECT hs.*, st.name as studentName, st.student_no as studentNo " +
            "FROM homework_submission hs " +
            "LEFT JOIN student st ON hs.student_id = st.id " +
            "WHERE hs.id = #{id}")
    HomeworkSubmission findById(@Param("id") Integer id);

    @Select("SELECT hs.*, st.name as studentName, st.student_no as studentNo " +
            "FROM homework_submission hs " +
            "LEFT JOIN student st ON hs.student_id = st.id " +
            "WHERE hs.homework_id = #{homeworkId} AND hs.student_id = #{studentId}")
    HomeworkSubmission findByHomeworkAndStudent(@Param("homeworkId") Integer homeworkId,
                                                 @Param("studentId") Integer studentId);

    @Insert("INSERT INTO homework_submission (homework_id, student_id, content, file_url, status) " +
            "VALUES (#{homeworkId}, #{studentId}, #{content}, #{fileUrl}, 0)")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(HomeworkSubmission submission);

    @Update("UPDATE homework_submission SET content = #{content}, file_url = #{fileUrl} " +
            "WHERE id = #{id}")
    int update(HomeworkSubmission submission);

    @Update("UPDATE homework_submission SET score = #{score}, feedback = #{feedback}, " +
            "grade_time = NOW(), grade_user = #{gradeUser}, status = 1 WHERE id = #{id}")
    int grade(@Param("id") Integer id,
              @Param("score") Double score,
              @Param("feedback") String feedback,
              @Param("gradeUser") Integer gradeUser);

    @Delete("DELETE FROM homework_submission WHERE id = #{id}")
    int deleteById(@Param("id") Integer id);

    @Select("SELECT COUNT(*) FROM homework_submission WHERE homework_id = #{homeworkId}")
    int countByHomeworkId(@Param("homeworkId") Integer homeworkId);

    @Select("SELECT COUNT(*) FROM homework_submission WHERE homework_id = #{homeworkId} AND status = 1")
    int countGradedByHomeworkId(@Param("homeworkId") Integer homeworkId);
}