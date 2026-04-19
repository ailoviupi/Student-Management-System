package com.example.student.service.impl;

import com.example.student.dto.StudentQueryDTO;
import com.example.student.entity.Student;
import com.example.student.mapper.ClassMapper;
import com.example.student.mapper.CourseMapper;
import com.example.student.mapper.ScoreMapper;
import com.example.student.mapper.StudentMapper;
import com.example.student.mapper.UserMapper;
import com.example.student.service.StudentService;
import com.example.student.vo.PageVO;
import com.example.student.vo.StatisticsVO;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class StudentServiceImpl implements StudentService {
    
    @Autowired
    private StudentMapper studentMapper;
    
    @Autowired
    private ClassMapper classMapper;
    
    @Autowired
    private CourseMapper courseMapper;
    
    @Autowired
    private UserMapper userMapper;
    
    @Autowired
    private ScoreMapper scoreMapper;
    
    @Override
    public PageVO<Student> findByCondition(StudentQueryDTO queryDTO) {
        PageHelper.startPage(queryDTO.getPageNum(), queryDTO.getPageSize());
        List<Student> list = studentMapper.findByCondition(
            queryDTO.getName(),
            queryDTO.getStudentNo(),
            queryDTO.getClassId(),
            queryDTO.getGender(),
            queryDTO.getStudentStatus()
        );
        PageInfo<Student> pageInfo = new PageInfo<>(list);
        return new PageVO<>(pageInfo.getList(), pageInfo.getTotal(), pageInfo.getPageNum(), pageInfo.getPageSize());
    }
    
    @Override
    public Student findById(Integer id) {
        return studentMapper.findById(id);
    }
    
    @Override
    public Student findByStudentNo(String studentNo) {
        return studentMapper.findByStudentNo(studentNo);
    }
    
    @Override
    public boolean save(Student student) {
        Student exist = studentMapper.findByStudentNo(student.getStudentNo());
        if (exist != null) {
            return false;
        }
        return studentMapper.insert(student) > 0;
    }
    
    @Override
    public boolean update(Student student) {
        Student exist = studentMapper.findByStudentNo(student.getStudentNo());
        if (exist != null && !exist.getId().equals(student.getId())) {
            return false;
        }
        return studentMapper.update(student) > 0;
    }
    
    @Override
    public boolean deleteById(Integer id) {
        return studentMapper.deleteById(id) > 0;
    }
    
    @Override
    public StatisticsVO getStatistics() {
        StatisticsVO vo = new StatisticsVO();
        
        vo.setTotalStudents(studentMapper.countAll());
        vo.setTotalClasses((long) classMapper.findAll().size());
        vo.setTotalCourses((long) courseMapper.findAll().size());
        vo.setTotalUsers((long) 3);
        
        Map<String, Long> genderDist = new HashMap<>();
        List<Map<String, Object>> genderList = studentMapper.countByGender();
        for (Map<String, Object> map : genderList) {
            String gender = (String) map.get("gender");
            Long count = ((Number) map.get("count")).longValue();
            genderDist.put(gender != null ? gender : "未知", count);
        }
        vo.setGenderDistribution(genderDist);
        
        Map<String, Long> statusDist = new HashMap<>();
        List<Map<String, Object>> statusList = studentMapper.countByStatus();
        for (Map<String, Object> map : statusList) {
            String studentStatus = (String) map.get("studentStatus");
            Long count = ((Number) map.get("count")).longValue();
            statusDist.put(studentStatus != null ? studentStatus : "未知", count);
        }
        vo.setStatusDistribution(statusDist);
        
        Map<String, Long> classDist = new HashMap<>();
        List<Map<String, Object>> classList = studentMapper.countByClass();
        for (Map<String, Object> map : classList) {
            String className = (String) map.get("className");
            Long count = ((Number) map.get("count")).longValue();
            classDist.put(className != null ? className : "未知", count);
        }
        vo.setClassDistribution(classDist);
        
        return vo;
    }
}
