package com.example.student.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.example.student.entity.*;
import com.example.student.mapper.*;
import com.example.student.service.ScholarshipService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 奖学金服务实现类 - 完善版
 * 支持：自动评定、综合评分、名额控制、多级奖学金评定
 */
@Slf4j
@Service
public class ScholarshipServiceImpl implements ScholarshipService {

    @Autowired
    private ScholarshipTypeMapper scholarshipTypeMapper;

    @Autowired
    private ScholarshipRecordMapper scholarshipRecordMapper;

    @Autowired
    private ScoreMapper scoreMapper;

    @Autowired
    private StudentMapper studentMapper;

    @Autowired
    private ObjectMapper objectMapper;

    // 成绩等级权重
    private static final Map<String, BigDecimal> SCORE_LEVEL_WEIGHTS = new HashMap<>();
    static {
        SCORE_LEVEL_WEIGHTS.put("EXCELLENT", new BigDecimal("1.0"));  // 90-100
        SCORE_LEVEL_WEIGHTS.put("GOOD", new BigDecimal("0.8"));       // 80-89
        SCORE_LEVEL_WEIGHTS.put("MEDIUM", new BigDecimal("0.6"));     // 70-79
        SCORE_LEVEL_WEIGHTS.put("PASS", new BigDecimal("0.4"));       // 60-69
        SCORE_LEVEL_WEIGHTS.put("FAIL", new BigDecimal("0"));         // <60
    }

    @Override
    public List<ScholarshipType> getAllTypes() {
        return scholarshipTypeMapper.findAll();
    }

    @Override
    public List<ScholarshipType> getActiveTypes() {
        return scholarshipTypeMapper.findAllActive();
    }

    @Override
    public ScholarshipType getTypeById(Integer id) {
        return scholarshipTypeMapper.findById(id);
    }

    @Override
    public boolean addType(ScholarshipType type) {
        return scholarshipTypeMapper.insert(type) > 0;
    }

    @Override
    public boolean updateType(ScholarshipType type) {
        return scholarshipTypeMapper.update(type) > 0;
    }

    @Override
    public boolean deleteType(Integer id) {
        return scholarshipTypeMapper.deleteById(id) > 0;
    }

    @Override
    public List<ScholarshipRecord> getRecords(String academicYear, String semester, String status,
                                              Integer scholarshipTypeId, Integer studentId) {
        return scholarshipRecordMapper.findByCondition(academicYear, semester, status, scholarshipTypeId, studentId);
    }

    @Override
    public ScholarshipRecord getRecordById(Integer id) {
        return scholarshipRecordMapper.findById(id);
    }

    @Override
    public boolean applyScholarship(ScholarshipRecord record) {
        List<ScholarshipRecord> existing = scholarshipRecordMapper.findByCondition(
                record.getAcademicYear(), record.getSemester(), null, 
                record.getScholarshipTypeId(), record.getStudentId());
        if (!existing.isEmpty()) {
            return false;
        }
        record.setStatus("PENDING");
        return scholarshipRecordMapper.insert(record) > 0;
    }

    @Override
    public boolean reviewScholarship(Integer id, String status, Integer reviewerId, String reviewRemark) {
        return scholarshipRecordMapper.review(id, status, reviewerId, reviewRemark) > 0;
    }

    @Override
    public boolean deleteRecord(Integer id) {
        return scholarshipRecordMapper.deleteById(id) > 0;
    }

    @Override
    @Transactional
    public void autoEvaluate(String academicYear, String semester) {
        log.info("开始自动评定奖学金: {} {}", academicYear, semester);
        
        // 1. 获取所有启用的奖学金类型（按金额降序，确保高金额奖学金优先评定）
        List<ScholarshipType> types = scholarshipTypeMapper.findAllActive();
        types.sort((a, b) -> b.getAmount().compareTo(a.getAmount()));
        
        if (types.isEmpty()) {
            log.warn("没有启用的奖学金类型");
            return;
        }
        
        // 2. 获取所有学生及其成绩
        List<Student> students = studentMapper.findAll();
        if (students.isEmpty()) {
            log.warn("没有学生数据");
            return;
        }
        
        // 3. 计算每个学生的综合评分
        Map<Integer, StudentScoreInfo> studentScores = new HashMap<>();
        for (Student student : students) {
            StudentScoreInfo scoreInfo = calculateStudentScore(student);
            if (scoreInfo != null) {
                studentScores.put(student.getId(), scoreInfo);
            }
        }
        
        // 4. 按综合评分排序（降序）
        List<StudentScoreInfo> sortedStudents = studentScores.values().stream()
                .sorted((a, b) -> b.getTotalScore().compareTo(a.getTotalScore()))
                .collect(Collectors.toList());
        
        // 5. 为每个学生分配排名
        for (int i = 0; i < sortedStudents.size(); i++) {
            sortedStudents.get(i).setRanking(i + 1);
        }
        
        // 6. 清除该学期已有的自动评定记录
        scholarshipRecordMapper.deleteAutoRecordsByTerm(academicYear, semester);
        
        // 7. 按奖学金类型进行评定
        Set<Integer> awardedStudents = new HashSet<>(); // 记录已获得奖学金的学生
        
        for (ScholarshipType type : types) {
            evaluateScholarshipType(type, sortedStudents, awardedStudents, academicYear, semester);
        }
        
        log.info("自动评定完成，共评定 {} 名学生", awardedStudents.size());
    }

    /**
     * 计算学生综合评分
     */
    private StudentScoreInfo calculateStudentScore(Student student) {
        // 获取学生成绩
        List<Score> scores = scoreMapper.findByCondition(student.getId(), null, null, null);
        if (scores.isEmpty()) {
            return null;
        }
        
        BigDecimal totalScore = BigDecimal.ZERO;
        BigDecimal totalWeight = BigDecimal.ZERO;
        int excellentCount = 0;
        int goodCount = 0;
        int failCount = 0;
        
        for (Score score : scores) {
            BigDecimal scoreValue = score.getScore();
            if (scoreValue == null) continue;
            
            // 根据成绩等级计算权重
            BigDecimal weight;
            String level;
            if (scoreValue.compareTo(new BigDecimal("90")) >= 0) {
                weight = SCORE_LEVEL_WEIGHTS.get("EXCELLENT");
                level = "EXCELLENT";
                excellentCount++;
            } else if (scoreValue.compareTo(new BigDecimal("80")) >= 0) {
                weight = SCORE_LEVEL_WEIGHTS.get("GOOD");
                level = "GOOD";
                goodCount++;
            } else if (scoreValue.compareTo(new BigDecimal("70")) >= 0) {
                weight = SCORE_LEVEL_WEIGHTS.get("MEDIUM");
                level = "MEDIUM";
            } else if (scoreValue.compareTo(new BigDecimal("60")) >= 0) {
                weight = SCORE_LEVEL_WEIGHTS.get("PASS");
                level = "PASS";
            } else {
                weight = SCORE_LEVEL_WEIGHTS.get("FAIL");
                level = "FAIL";
                failCount++;
            }
            
            totalScore = totalScore.add(scoreValue.multiply(weight));
            totalWeight = totalWeight.add(weight);
        }
        
        if (totalWeight.compareTo(BigDecimal.ZERO) == 0) {
            return null;
        }
        
        // 计算加权平均分
        BigDecimal averageScore = totalScore.divide(totalWeight, 2, RoundingMode.HALF_UP);
        
        // 计算GPA (4.0制)
        BigDecimal gpa = calculateGPA(averageScore);
        
        // 计算综合评分（包含优秀科目加分和不及格科目扣分）
        BigDecimal bonus = new BigDecimal(excellentCount).multiply(new BigDecimal("0.5"));
        BigDecimal penalty = new BigDecimal(failCount).multiply(new BigDecimal("2"));
        BigDecimal totalScoreFinal = averageScore.add(bonus).subtract(penalty);
        
        // 如果有不及格科目，不能获得奖学金
        if (failCount > 0) {
            totalScoreFinal = totalScoreFinal.multiply(new BigDecimal("0.5"));
        }
        
        StudentScoreInfo info = new StudentScoreInfo();
        info.setStudentId(student.getId());
        info.setStudentName(student.getName());
        info.setStudentNo(student.getStudentNo());
        info.setClassId(student.getClassId());
        info.setGpa(gpa);
        info.setAverageScore(averageScore);
        info.setTotalScore(totalScoreFinal);
        info.setExcellentCount(excellentCount);
        info.setGoodCount(goodCount);
        info.setFailCount(failCount);
        info.setCourseCount(scores.size());
        
        return info;
    }

    /**
     * 计算GPA (4.0制)
     */
    private BigDecimal calculateGPA(BigDecimal averageScore) {
        if (averageScore.compareTo(new BigDecimal("90")) >= 0) {
            return new BigDecimal("4.0");
        } else if (averageScore.compareTo(new BigDecimal("85")) >= 0) {
            return new BigDecimal("3.7");
        } else if (averageScore.compareTo(new BigDecimal("82")) >= 0) {
            return new BigDecimal("3.3");
        } else if (averageScore.compareTo(new BigDecimal("78")) >= 0) {
            return new BigDecimal("3.0");
        } else if (averageScore.compareTo(new BigDecimal("75")) >= 0) {
            return new BigDecimal("2.7");
        } else if (averageScore.compareTo(new BigDecimal("72")) >= 0) {
            return new BigDecimal("2.3");
        } else if (averageScore.compareTo(new BigDecimal("68")) >= 0) {
            return new BigDecimal("2.0");
        } else if (averageScore.compareTo(new BigDecimal("64")) >= 0) {
            return new BigDecimal("1.5");
        } else if (averageScore.compareTo(new BigDecimal("60")) >= 0) {
            return new BigDecimal("1.0");
        } else {
            return BigDecimal.ZERO;
        }
    }

    /**
     * 评定单个奖学金类型
     */
    private void evaluateScholarshipType(ScholarshipType type, List<StudentScoreInfo> sortedStudents,
                                        Set<Integer> awardedStudents, String academicYear, String semester) {
        log.info("评定奖学金类型: {}, 名额: {}, 金额: {}", 
                type.getTypeName(), type.getQuota(), type.getAmount());
        
        // 解析评选条件
        ScholarshipRequirements requirements = parseRequirements(type.getRequirements());
        
        int awardedCount = 0;
        int quota = type.getQuota() != null ? type.getQuota() : 10;
        
        for (StudentScoreInfo student : sortedStudents) {
            // 检查是否已获得其他奖学金（一个学生只能获得一项奖学金）
            if (awardedStudents.contains(student.getStudentId())) {
                continue;
            }
            
            // 检查是否符合该奖学金的评选条件
            if (!meetsRequirements(student, requirements)) {
                continue;
            }
            
            // 检查该学生是否已申请过该奖学金
            List<ScholarshipRecord> existing = scholarshipRecordMapper.findByCondition(
                    academicYear, semester, null, type.getId(), student.getStudentId());
            if (!existing.isEmpty()) {
                continue;
            }
            
            // 创建奖学金记录
            ScholarshipRecord record = new ScholarshipRecord();
            record.setStudentId(student.getStudentId());
            record.setScholarshipTypeId(type.getId());
            record.setAcademicYear(academicYear);
            record.setSemester(semester);
            record.setGpa(student.getGpa());
            record.setRanking(student.getRanking());
            record.setTotalScore(student.getTotalScore());
            
            // 构建评分详情
            Map<String, Object> scoreDetails = new HashMap<>();
            scoreDetails.put("averageScore", student.getAverageScore());
            scoreDetails.put("excellentCount", student.getExcellentCount());
            scoreDetails.put("goodCount", student.getGoodCount());
            scoreDetails.put("failCount", student.getFailCount());
            scoreDetails.put("courseCount", student.getCourseCount());
            
            try {
                record.setScoreDetails(objectMapper.writeValueAsString(scoreDetails));
            } catch (Exception e) {
                log.error("序列化评分详情失败", e);
            }
            
            record.setStatus("PENDING"); // 自动评定为待审核状态
            record.setScholarshipAmount(type.getAmount());
            
            scholarshipRecordMapper.insert(record);
            
            awardedStudents.add(student.getStudentId());
            awardedCount++;
            
            log.info("学生 {} 获得 {} 奖学金，综合评分: {}, 排名: {}", 
                    student.getStudentName(), type.getTypeName(), 
                    student.getTotalScore(), student.getRanking());
            
            // 达到名额上限则停止
            if (awardedCount >= quota) {
                break;
            }
        }
        
        log.info("{} 奖学金评定完成，共 {} 人获得", type.getTypeName(), awardedCount);
    }

    /**
     * 解析评选条件
     */
    private ScholarshipRequirements parseRequirements(String requirements) {
        ScholarshipRequirements req = new ScholarshipRequirements();
        req.setMinGpa(new BigDecimal("2.0")); // 默认最低GPA 2.0
        req.setMaxRanking(100); // 默认排名前100
        req.setMaxFailCount(0); // 默认不允许不及格
        
        if (requirements == null || requirements.trim().isEmpty()) {
            return req;
        }
        
        // 解析条件字符串，格式如：GPA>=3.0,排名<=10,无不及格
        String[] parts = requirements.split(",");
        for (String part : parts) {
            part = part.trim();
            if (part.contains("GPA>=")) {
                try {
                    req.setMinGpa(new BigDecimal(part.replace("GPA>=", "")));
                } catch (Exception ignored) {}
            } else if (part.contains("排名<=")) {
                try {
                    req.setMaxRanking(Integer.parseInt(part.replace("排名<=", "")));
                } catch (Exception ignored) {}
            } else if (part.contains("无不及格")) {
                req.setMaxFailCount(0);
            }
        }
        
        return req;
    }

    /**
     * 检查学生是否符合评选条件
     */
    private boolean meetsRequirements(StudentScoreInfo student, ScholarshipRequirements requirements) {
        // 检查GPA
        if (student.getGpa().compareTo(requirements.getMinGpa()) < 0) {
            return false;
        }
        
        // 检查排名
        if (student.getRanking() > requirements.getMaxRanking()) {
            return false;
        }
        
        // 检查不及格科目
        if (student.getFailCount() > requirements.getMaxFailCount()) {
            return false;
        }
        
        return true;
    }

    @Override
    public Map<String, Object> getStatistics(String academicYear, String semester) {
        Map<String, Object> stats = new HashMap<>();
        
        List<ScholarshipRecord> records = scholarshipRecordMapper.findByCondition(
                academicYear, semester, null, null, null);
        
        long pendingCount = records.stream().filter(r -> "PENDING".equals(r.getStatus())).count();
        long approvedCount = records.stream().filter(r -> "APPROVED".equals(r.getStatus())).count();
        long rejectedCount = records.stream().filter(r -> "REJECTED".equals(r.getStatus())).count();
        
        BigDecimal totalAmount = records.stream()
                .filter(r -> "APPROVED".equals(r.getStatus()))
                .map(r -> r.getScholarshipAmount() != null ? r.getScholarshipAmount() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        // 按奖学金类型统计
        Map<String, Object> typeStats = new HashMap<>();
        List<ScholarshipType> types = scholarshipTypeMapper.findAll();
        for (ScholarshipType type : types) {
            long typeCount = records.stream()
                    .filter(r -> r.getScholarshipTypeId().equals(type.getId()))
                    .filter(r -> "APPROVED".equals(r.getStatus()))
                    .count();
            if (typeCount > 0) {
                typeStats.put(type.getTypeName(), typeCount);
            }
        }
        
        // 计算平均GPA和平均排名
        double avgGpa = records.stream()
                .filter(r -> r.getGpa() != null)
                .mapToDouble(r -> r.getGpa().doubleValue())
                .average()
                .orElse(0.0);
        
        double avgRanking = records.stream()
                .filter(r -> r.getRanking() != null)
                .mapToInt(ScholarshipRecord::getRanking)
                .average()
                .orElse(0.0);
        
        stats.put("totalApplications", records.size());
        stats.put("pendingCount", pendingCount);
        stats.put("approvedCount", approvedCount);
        stats.put("rejectedCount", rejectedCount);
        stats.put("totalAmount", totalAmount);
        stats.put("typeStatistics", typeStats);
        stats.put("averageGpa", BigDecimal.valueOf(avgGpa).setScale(2, RoundingMode.HALF_UP));
        stats.put("averageRanking", BigDecimal.valueOf(avgRanking).setScale(1, RoundingMode.HALF_UP));
        
        return stats;
    }

    /**
     * 学生评分信息内部类
     */
    private static class StudentScoreInfo {
        private Integer studentId;
        private String studentName;
        private String studentNo;
        private Integer classId;
        private BigDecimal gpa;
        private BigDecimal averageScore;
        private BigDecimal totalScore;
        private Integer ranking;
        private int excellentCount;
        private int goodCount;
        private int failCount;
        private int courseCount;

        // Getters and Setters
        public Integer getStudentId() { return studentId; }
        public void setStudentId(Integer studentId) { this.studentId = studentId; }
        public String getStudentName() { return studentName; }
        public void setStudentName(String studentName) { this.studentName = studentName; }
        public String getStudentNo() { return studentNo; }
        public void setStudentNo(String studentNo) { this.studentNo = studentNo; }
        public Integer getClassId() { return classId; }
        public void setClassId(Integer classId) { this.classId = classId; }
        public BigDecimal getGpa() { return gpa; }
        public void setGpa(BigDecimal gpa) { this.gpa = gpa; }
        public BigDecimal getAverageScore() { return averageScore; }
        public void setAverageScore(BigDecimal averageScore) { this.averageScore = averageScore; }
        public BigDecimal getTotalScore() { return totalScore; }
        public void setTotalScore(BigDecimal totalScore) { this.totalScore = totalScore; }
        public Integer getRanking() { return ranking; }
        public void setRanking(Integer ranking) { this.ranking = ranking; }
        public int getExcellentCount() { return excellentCount; }
        public void setExcellentCount(int excellentCount) { this.excellentCount = excellentCount; }
        public int getGoodCount() { return goodCount; }
        public void setGoodCount(int goodCount) { this.goodCount = goodCount; }
        public int getFailCount() { return failCount; }
        public void setFailCount(int failCount) { this.failCount = failCount; }
        public int getCourseCount() { return courseCount; }
        public void setCourseCount(int courseCount) { this.courseCount = courseCount; }
    }

    /**
     * 奖学金评选条件内部类
     */
    private static class ScholarshipRequirements {
        private BigDecimal minGpa;
        private int maxRanking;
        private int maxFailCount;

        public BigDecimal getMinGpa() { return minGpa; }
        public void setMinGpa(BigDecimal minGpa) { this.minGpa = minGpa; }
        public int getMaxRanking() { return maxRanking; }
        public void setMaxRanking(int maxRanking) { this.maxRanking = maxRanking; }
        public int getMaxFailCount() { return maxFailCount; }
        public void setMaxFailCount(int maxFailCount) { this.maxFailCount = maxFailCount; }
    }
}
