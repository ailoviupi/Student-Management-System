package com.example.student.service.impl;

import com.alibaba.excel.EasyExcel;
import com.alibaba.excel.write.style.column.LongestMatchColumnWidthStyleStrategy;
import com.example.student.entity.*;
import com.example.student.mapper.*;
import com.example.student.service.ExportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ExportServiceImpl implements ExportService {

    @Autowired
    private StudentMapper studentMapper;

    @Autowired
    private ScoreMapper scoreMapper;

    @Autowired
    private CourseMapper courseMapper;

    @Autowired
    private ClassMapper classMapper;

    @Autowired
    private AttendanceMapper attendanceMapper;

    @Autowired
    private StudentWarningMapper warningMapper;

    @Override
    public void exportStudentsToExcel(HttpServletResponse response) throws IOException {
        List<Student> students = studentMapper.findByCondition(null, null, null, null, null);
        
        List<Map<String, Object>> data = new ArrayList<>();
        for (Student student : students) {
            Map<String, Object> row = new HashMap<>();
            row.put("studentNo", student.getStudentNo());
            row.put("name", student.getName());
            row.put("gender", student.getGender());
            row.put("age", student.getAge());
            row.put("phone", student.getPhone());
            row.put("email", student.getEmail());
            row.put("className", student.getClassName());
            row.put("studentStatus", student.getStudentStatus());
            row.put("enrollmentDate", student.getEnrollmentDate());
            data.add(row);
        }

        String[] headers = {"学号", "姓名", "性别", "年龄", "电话", "邮箱", "班级", "状态", "入学日期"};
        String[] fields = {"studentNo", "name", "gender", "age", "phone", "email", "className", "studentStatus", "enrollmentDate"};
        
        exportExcel(response, "学生信息表", headers, fields, data);
    }

    @Override
    public void exportScoresToExcel(Integer classId, Integer courseId, HttpServletResponse response) throws IOException {
        List<Score> scores = scoreMapper.findByCondition(null, courseId, null, null);
        
        List<Map<String, Object>> data = new ArrayList<>();
        for (Score score : scores) {
            Map<String, Object> row = new HashMap<>();
            row.put("studentNo", score.getStudentNo());
            row.put("studentName", score.getStudentName());
            row.put("className", score.getClassName());
            row.put("courseName", score.getCourseName());
            row.put("score", score.getScore());
            row.put("examType", score.getExamType());
            row.put("examDate", score.getExamDate());
            data.add(row);
        }

        String[] headers = {"学号", "姓名", "班级", "课程", "成绩", "考试类型", "考试日期"};
        String[] fields = {"studentNo", "studentName", "className", "courseName", "score", "examType", "examDate"};
        
        exportExcel(response, "成绩表", headers, fields, data);
    }

    @Override
    public void exportStudentScoresToExcel(Integer studentId, HttpServletResponse response) throws IOException {
        // 简化实现
        List<Map<String, Object>> data = new ArrayList<>();
        String[] headers = {"课程名称", "成绩", "考试类型", "考试日期"};
        String[] fields = {"courseName", "score", "examType", "examDate"};
        exportExcel(response, "成绩单", headers, fields, data);
    }

    @Override
    public void exportAttendanceToExcel(Integer classId, String startDate, String endDate, HttpServletResponse response) throws IOException {
        List<Attendance> attendances = attendanceMapper.findByCondition(classId, null, startDate, endDate);
        
        List<Map<String, Object>> data = new ArrayList<>();
        for (Attendance attendance : attendances) {
            Map<String, Object> row = new HashMap<>();
            row.put("studentNo", attendance.getStudentNo());
            row.put("studentName", attendance.getStudentName());
            row.put("className", attendance.getClassName());
            row.put("attendanceDate", attendance.getAttendanceDate());
            row.put("status", getAttendanceStatusText(attendance.getStatus()));
            row.put("remark", attendance.getRemark());
            data.add(row);
        }

        String[] headers = {"学号", "姓名", "班级", "日期", "状态", "备注"};
        String[] fields = {"studentNo", "studentName", "className", "attendanceDate", "status", "remark"};
        
        exportExcel(response, "考勤记录表", headers, fields, data);
    }

    @Override
    public void exportWarningsToExcel(String status, String warningLevel, HttpServletResponse response) throws IOException {
        List<StudentWarning> warnings = warningMapper.findByCondition(status, warningLevel, null, null);
        
        List<Map<String, Object>> data = new ArrayList<>();
        for (StudentWarning warning : warnings) {
            Map<String, Object> row = new HashMap<>();
            row.put("studentNo", warning.getStudentNo());
            row.put("studentName", warning.getStudentName());
            row.put("className", warning.getClassName());
            row.put("warningType", getWarningTypeText(warning.getWarningType()));
            row.put("warningLevel", getWarningLevelText(warning.getWarningLevel()));
            row.put("warningReason", warning.getWarningReason());
            row.put("status", getWarningStatusText(warning.getStatus()));
            row.put("createTime", warning.getCreateTime());
            data.add(row);
        }

        String[] headers = {"学号", "姓名", "班级", "预警类型", "预警等级", "预警原因", "处理状态", "预警时间"};
        String[] fields = {"studentNo", "studentName", "className", "warningType", "warningLevel", "warningReason", "status", "createTime"};
        
        exportExcel(response, "学业预警表", headers, fields, data);
    }

    @Override
    public void exportCourseStatsToExcel(HttpServletResponse response) throws IOException {
        List<Course> courses = courseMapper.findAll();
        
        List<Map<String, Object>> data = new ArrayList<>();
        for (Course course : courses) {
            Map<String, Object> row = new HashMap<>();
            row.put("courseCode", course.getCourseCode());
            row.put("courseName", course.getCourseName());
            row.put("credit", course.getCredit());
            data.add(row);
        }

        String[] headers = {"课程代码", "课程名称", "学分"};
        String[] fields = {"courseCode", "courseName", "credit"};
        
        exportExcel(response, "课程统计表", headers, fields, data);
    }

    private void exportExcel(HttpServletResponse response, String fileName, 
                            String[] headers, String[] fields, List<Map<String, Object>> data) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("utf-8");
        String encodedFileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
        response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + encodedFileName + ".xlsx");

        List<List<String>> head = new ArrayList<>();
        for (String header : headers) {
            List<String> headColumn = new ArrayList<>();
            headColumn.add(header);
            head.add(headColumn);
        }

        List<List<Object>> sheetData = new ArrayList<>();
        for (Map<String, Object> row : data) {
            List<Object> rowData = new ArrayList<>();
            for (String field : fields) {
                rowData.add(row.get(field));
            }
            sheetData.add(rowData);
        }

        EasyExcel.write(response.getOutputStream())
                .head(head)
                .registerWriteHandler(new LongestMatchColumnWidthStyleStrategy())
                .sheet(fileName)
                .doWrite(sheetData);
    }

    private String getAttendanceStatusText(String status) {
        Map<String, String> map = new HashMap<>();
        map.put("PRESENT", "出勤");
        map.put("ABSENT", "缺勤");
        map.put("LATE", "迟到");
        map.put("LEAVE", "请假");
        return map.getOrDefault(status, status);
    }

    private String getWarningTypeText(String type) {
        Map<String, String> map = new HashMap<>();
        map.put("SCORE", "成绩预警");
        map.put("ATTENDANCE", "考勤预警");
        map.put("COMPREHENSIVE", "综合预警");
        return map.getOrDefault(type, type);
    }

    private String getWarningLevelText(String level) {
        Map<String, String> map = new HashMap<>();
        map.put("YELLOW", "黄色");
        map.put("ORANGE", "橙色");
        map.put("RED", "红色");
        return map.getOrDefault(level, level);
    }

    private String getWarningStatusText(String status) {
        Map<String, String> map = new HashMap<>();
        map.put("PENDING", "待处理");
        map.put("PROCESSING", "处理中");
        map.put("RESOLVED", "已解决");
        map.put("IGNORED", "已忽略");
        return map.getOrDefault(status, status);
    }
}
