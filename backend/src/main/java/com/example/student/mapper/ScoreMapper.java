package com.example.student.mapper;

import com.example.student.entity.Score;
import com.example.student.vo.ScoreRankVO;
import org.apache.ibatis.annotations.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Mapper
public interface ScoreMapper {
    
    @Select("<script>" +
            "SELECT s.*, st.name as studentName, st.student_no as studentNo, c.course_name as courseName " +
            "FROM score s " +
            "LEFT JOIN student st ON s.student_id = st.id " +
            "LEFT JOIN course c ON s.course_id = c.id " +
            "<where>" +
            "<if test='studentId != null'> AND s.student_id = #{studentId} </if>" +
            "<if test='courseId != null'> AND s.course_id = #{courseId} </if>" +
            "<if test='examType != null and examType != \"\"'> AND s.exam_type = #{examType} </if>" +
            "<if test='studentName != null and studentName != \"\"'> AND st.name LIKE CONCAT('%', #{studentName}, '%') </if>" +
            "</where>" +
            "ORDER BY s.create_time DESC" +
            "</script>")
    List<Score> findByCondition(@Param("studentId") Integer studentId, 
                                 @Param("courseId") Integer courseId,
                                 @Param("examType") String examType,
                                 @Param("studentName") String studentName);
    
    @Select("SELECT s.*, st.name as studentName, st.student_no as studentNo, c.course_name as courseName " +
            "FROM score s " +
            "LEFT JOIN student st ON s.student_id = st.id " +
            "LEFT JOIN course c ON s.course_id = c.id " +
            "WHERE s.id = #{id}")
    Score findById(@Param("id") Integer id);
    
    @Insert("INSERT INTO score (student_id, course_id, score, exam_date, exam_type, remark) " +
            "VALUES (#{studentId}, #{courseId}, #{score}, #{examDate}, #{examType}, #{remark})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Score score);
    
    @Update("UPDATE score SET student_id = #{studentId}, course_id = #{courseId}, score = #{score}, " +
            "exam_date = #{examDate}, exam_type = #{examType}, remark = #{remark} WHERE id = #{id}")
    int update(Score score);
    
    @Delete("DELETE FROM score WHERE id = #{id}")
    int deleteById(@Param("id") Integer id);
    
    @Select("SELECT AVG(score) FROM score WHERE course_id = #{courseId}")
    BigDecimal getAverageScoreByCourse(@Param("courseId") Integer courseId);
    
    @Select("SELECT c.course_name as courseName, AVG(s.score) as averageScore " +
            "FROM score s JOIN course c ON s.course_id = c.id GROUP BY s.course_id")
    List<Map<String, Object>> getCourseAverageScores();
    
    @Select("SELECT COUNT(*) FROM score WHERE score >= 60")
    int countPassScores();
    
    @Select("SELECT COUNT(*) FROM score")
    int countTotalScores();
    
    @Select("SELECT * FROM score WHERE student_id = #{studentId} AND course_id = #{courseId} AND exam_type = #{examType}")
    Score findByStudentAndCourseAndExamType(@Param("studentId") Integer studentId, 
                                             @Param("courseId") Integer courseId, 
                                             @Param("examType") String examType);
    
    @Select("SELECT s.*, st.name as studentName, st.student_no as studentNo, c.course_name as courseName, c.course_code as courseCode, cl.class_name as className " +
            "FROM score s " +
            "LEFT JOIN student st ON s.student_id = st.id " +
            "LEFT JOIN course c ON s.course_id = c.id " +
            "LEFT JOIN class cl ON st.class_id = cl.id " +
            "ORDER BY s.create_time DESC")
    List<Score> findAllForExport();
    
    @Select("SELECT st.student_no as studentNo, st.name as studentName, cl.class_name as className, " +
            "c.course_name as courseName, s.score " +
            "FROM score s " +
            "LEFT JOIN student st ON s.student_id = st.id " +
            "LEFT JOIN course c ON s.course_id = c.id " +
            "LEFT JOIN class cl ON st.class_id = cl.id " +
            "WHERE s.course_id = #{courseId} " +
            "ORDER BY s.score DESC")
    List<ScoreRankVO> findRankByCourse(@Param("courseId") Integer courseId);
    
    @Select("SELECT st.student_no as studentNo, st.name as studentName, cl.class_name as className, " +
            "AVG(s.score) as averageScore, COUNT(DISTINCT s.course_id) as totalCourses " +
            "FROM score s " +
            "LEFT JOIN student st ON s.student_id = st.id " +
            "LEFT JOIN class cl ON st.class_id = cl.id " +
            "GROUP BY s.student_id, st.student_no, st.name, cl.class_name " +
            "ORDER BY averageScore DESC")
    List<ScoreRankVO> findOverallRank();
    
    @Select("SELECT " +
            "  COUNT(CASE WHEN score >= 90 THEN 1 END) as excellent, " +
            "  COUNT(CASE WHEN score >= 80 AND score < 90 THEN 1 END) as good, " +
            "  COUNT(CASE WHEN score >= 70 AND score < 80 THEN 1 END) as medium, " +
            "  COUNT(CASE WHEN score >= 60 AND score < 70 THEN 1 END) as pass, " +
            "  COUNT(CASE WHEN score < 60 THEN 1 END) as fail " +
            "FROM score")
    Map<String, Object> getScoreDistribution();
    
    @Select("SELECT " +
            "  c.course_name as courseName, " +
            "  COUNT(CASE WHEN s.score >= 90 THEN 1 END) as excellent, " +
            "  COUNT(CASE WHEN s.score >= 80 AND s.score < 90 THEN 1 END) as good, " +
            "  COUNT(CASE WHEN s.score >= 70 AND s.score < 80 THEN 1 END) as medium, " +
            "  COUNT(CASE WHEN s.score >= 60 AND s.score < 70 THEN 1 END) as pass, " +
            "  COUNT(CASE WHEN s.score < 60 THEN 1 END) as fail, " +
            "  AVG(s.score) as averageScore, " +
            "  MAX(s.score) as maxScore, " +
            "  MIN(s.score) as minScore " +
            "FROM score s " +
            "JOIN course c ON s.course_id = c.id " +
            "GROUP BY s.course_id, c.course_name")
    List<Map<String, Object>> getCourseScoreAnalysis();
    
    @Select("SELECT " +
            "  DATE_FORMAT(s.exam_date, '%Y-%m') as month, " +
            "  AVG(s.score) as averageScore, " +
            "  COUNT(*) as totalExams " +
            "FROM score s " +
            "WHERE s.exam_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) " +
            "GROUP BY DATE_FORMAT(s.exam_date, '%Y-%m') " +
            "ORDER BY month")
    List<Map<String, Object>> getScoreTrend();
    
    // 学生端查询方法
    @Select("SELECT s.*, st.name as studentName, st.student_no as studentNo, c.course_name as courseName, c.course_code as courseCode, cl.class_name as className " +
            "FROM score s " +
            "LEFT JOIN student st ON s.student_id = st.id " +
            "LEFT JOIN course c ON s.course_id = c.id " +
            "LEFT JOIN class cl ON st.class_id = cl.id " +
            "WHERE st.student_no = #{studentNo} " +
            "ORDER BY s.exam_date DESC")
    List<Score> findByStudentNo(@Param("studentNo") String studentNo);
}
