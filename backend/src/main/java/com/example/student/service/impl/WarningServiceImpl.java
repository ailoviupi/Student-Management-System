package com.example.student.service.impl;

import com.example.student.entity.*;
import com.example.student.mapper.*;
import com.example.student.service.WarningService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class WarningServiceImpl implements WarningService {

    @Autowired
    private WarningRuleMapper warningRuleMapper;

    @Autowired
    private StudentWarningMapper studentWarningMapper;

    @Autowired
    private StudentMapper studentMapper;

    @Autowired
    private ScoreMapper scoreMapper;

    @Autowired
    private AttendanceMapper attendanceMapper;

    @Autowired
    private CourseMapper courseMapper;

    @Override
    public List<WarningRule> getAllRules() {
        return warningRuleMapper.findAll();
    }

    @Override
    public List<WarningRule> getActiveRules() {
        return warningRuleMapper.findAllActive();
    }

    @Override
    public WarningRule getRuleById(Integer id) {
        return warningRuleMapper.findById(id);
    }

    @Override
    public boolean addRule(WarningRule rule) {
        return warningRuleMapper.insert(rule) > 0;
    }

    @Override
    public boolean updateRule(WarningRule rule) {
        return warningRuleMapper.update(rule) > 0;
    }

    @Override
    public boolean deleteRule(Integer id) {
        return warningRuleMapper.deleteById(id) > 0;
    }

    @Override
    public List<StudentWarning> getWarnings(String status, String warningLevel, String warningType, Integer studentId) {
        return studentWarningMapper.findByCondition(status, warningLevel, warningType, studentId);
    }

    @Override
    public StudentWarning getWarningById(Integer id) {
        return studentWarningMapper.findById(id);
    }

    @Override
    public boolean handleWarning(Integer id, String status, Integer handlerId, String handleRemark) {
        return studentWarningMapper.handleWarning(id, status, handlerId, handleRemark) > 0;
    }

    @Override
    public boolean deleteWarning(Integer id) {
        return studentWarningMapper.deleteById(id) > 0;
    }

    @Override
    public Map<String, Object> getWarningStatistics() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalPending", studentWarningMapper.countPending());
        stats.put("yellowCount", studentWarningMapper.countByLevel("YELLOW"));
        stats.put("orangeCount", studentWarningMapper.countByLevel("ORANGE"));
        stats.put("redCount", studentWarningMapper.countByLevel("RED"));
        return stats;
    }

    @Override
    @Transactional
    public void checkAndGenerateWarnings() {
        List<WarningRule> rules = warningRuleMapper.findAllActive();
        if (rules.isEmpty()) {
            return;
        }

        // 批量加载所有学生（一次查询，避免逐学生查询）
        List<Student> students = studentMapper.findAll();
        if (students.isEmpty()) {
            return;
        }

        // 批量加载所有未处理预警，按学生分组（一次查询）
        Map<Integer, List<StudentWarning>> warningsByStudent = studentWarningMapper
                .findByCondition("PENDING", null, null, null)
                .stream()
                .collect(Collectors.groupingBy(StudentWarning::getStudentId));

        // 批量加载所有成绩，按学生分组（一次查询）
        Map<Integer, List<Score>> scoresByStudent = scoreMapper
                .findByCondition(null, null, null, null)
                .stream()
                .collect(Collectors.groupingBy(Score::getStudentId));

        // 批量加载所有考勤，按学生分组（一次查询）
        Map<Integer, List<Attendance>> attendanceByStudent = attendanceMapper
                .findByCondition(null, null, null, null)
                .stream()
                .collect(Collectors.groupingBy(Attendance::getStudentId));

        // 批量加载所有课程，用于预警原因展示（一次查询）
        Map<Integer, Course> courseMap = courseMapper.findAll()
                .stream()
                .collect(Collectors.toMap(Course::getId, c -> c));

        for (Student student : students) {
            List<StudentWarning> existingWarnings = warningsByStudent.getOrDefault(
                    student.getId(), Collections.emptyList());
            List<Score> scores = scoresByStudent.getOrDefault(
                    student.getId(), Collections.emptyList());
            List<Attendance> attendances = attendanceByStudent.getOrDefault(
                    student.getId(), Collections.emptyList());

            for (WarningRule rule : rules) {
                checkAndCreateWarning(student, rule, existingWarnings, scores, attendances, courseMap);
            }
        }
    }

    private void checkAndCreateWarning(Student student, WarningRule rule,
                                       List<StudentWarning> existingWarnings,
                                       List<Score> scores,
                                       List<Attendance> attendances,
                                       Map<Integer, Course> courseMap) {
        boolean shouldCreateWarning = false;
        String warningReason = "";
        Integer relatedCourseId = null;
        Double relatedScore = null;
        Integer attendanceCount = null;

        switch (rule.getRuleType()) {
            case "SCORE":
                // 检查成绩预警
                for (Score score : scores) {
                    if (score.getScore() != null && score.getScore().doubleValue() < rule.getThresholdValue()) {
                        // 检查是否已存在该课程的预警
                        boolean exists = existingWarnings.stream()
                                .anyMatch(w -> w.getRelatedCourseId() != null
                                        && w.getRelatedCourseId().equals(score.getCourseId()));
                        if (!exists) {
                            shouldCreateWarning = true;
                            relatedCourseId = score.getCourseId();
                            relatedScore = score.getScore().doubleValue();
                            Course course = courseMap.get(score.getCourseId());
                            warningReason = String.format("%s成绩%.2f分，低于%.2f分",
                                    course != null ? course.getCourseName() : "某课程",
                                    score.getScore().doubleValue(), rule.getThresholdValue());
                            break;
                        }
                    }
                }
                break;

            case "ATTENDANCE":
                // 检查考勤预警（数据库与前端使用中文状态：缺勤）
                long absentCount = attendances.stream()
                        .filter(a -> "缺勤".equals(a.getStatus()) || "ABSENT".equalsIgnoreCase(a.getStatus()))
                        .count();
                if (absentCount >= rule.getThresholdCount()) {
                    boolean exists = existingWarnings.stream()
                            .anyMatch(w -> w.getAttendanceCount() != null
                                    && w.getAttendanceCount() >= rule.getThresholdCount());
                    if (!exists) {
                        shouldCreateWarning = true;
                        attendanceCount = (int) absentCount;
                        warningReason = String.format("累计缺勤%d次，达到预警阈值%d次",
                                absentCount, rule.getThresholdCount());
                    }
                }
                break;

            case "COMPREHENSIVE":
                // 检查综合预警（多科不及格）
                long failCount = scores.stream()
                        .filter(s -> s.getScore() != null && s.getScore().doubleValue() < rule.getThresholdValue())
                        .count();
                if (failCount >= rule.getThresholdCount()) {
                    boolean exists = existingWarnings.stream()
                            .anyMatch(w -> "COMPREHENSIVE".equals(w.getWarningType()));
                    if (!exists) {
                        shouldCreateWarning = true;
                        warningReason = String.format("%d科成绩不及格，达到预警阈值%d科",
                                failCount, rule.getThresholdCount());
                    }
                }
                break;
        }

        if (shouldCreateWarning) {
            StudentWarning warning = new StudentWarning();
            warning.setStudentId(student.getId());
            warning.setRuleId(rule.getId());
            warning.setWarningType(rule.getRuleType());
            warning.setWarningLevel(rule.getWarningLevel());
            warning.setWarningReason(warningReason);
            warning.setRelatedCourseId(relatedCourseId);
            warning.setRelatedScore(relatedScore);
            warning.setAttendanceCount(attendanceCount);
            warning.setStatus("PENDING");
            warning.setNotifyStatus(0);
            studentWarningMapper.insert(warning);
        }
    }
}
