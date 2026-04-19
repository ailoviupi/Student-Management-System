package com.example.student.service.impl;

import com.example.student.entity.Class;
import com.example.student.entity.Student;
import com.example.student.mapper.ClassMapper;
import com.example.student.mapper.StudentMapper;
import com.example.student.service.ClassService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClassServiceImpl implements ClassService {
    
    @Autowired
    private ClassMapper classMapper;
    
    @Autowired
    private StudentMapper studentMapper;
    
    @Override
    public List<Class> findAll() {
        return classMapper.findAll();
    }
    
    @Override
    public Class findById(Integer id) {
        return classMapper.findById(id);
    }
    
    @Override
    public boolean save(Class clazz) {
        return classMapper.insert(clazz) > 0;
    }
    
    @Override
    public boolean update(Class clazz) {
        return classMapper.update(clazz) > 0;
    }
    
    @Override
    public boolean deleteById(Integer id) {
        int studentCount = classMapper.countStudents(id);
        if (studentCount > 0) {
            return false;
        }
        return classMapper.deleteById(id) > 0;
    }
    
    @Override
    public Class findByStudentNo(String studentNo) {
        Student student = studentMapper.findByStudentNo(studentNo);
        if (student != null && student.getClassId() != null) {
            return classMapper.findById(student.getClassId());
        }
        return null;
    }
    
    @Override
    public List<Student> findClassmatesByStudentNo(String studentNo) {
        Student student = studentMapper.findByStudentNo(studentNo);
        if (student != null && student.getClassId() != null) {
            // 获取同班同学（排除自己）
            List<Student> classmates = studentMapper.findByCondition(null, null, student.getClassId(), null, null);
            classmates.removeIf(s -> s.getStudentNo().equals(studentNo));
            return classmates;
        }
        return null;
    }
}
