package com.example.student.service.impl;

import com.example.student.entity.User;
import com.example.student.mapper.UserMapper;
import com.example.student.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {
    
    @Autowired
    private UserMapper userMapper;
    
    private BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    
    @Override
    public User findByUsername(String username) {
        return userMapper.findByUsername(username);
    }
    
    @Override
    public User findById(Integer id) {
        return userMapper.findById(id);
    }
    
    @Override
    public List<User> findAll() {
        return userMapper.findAll();
    }
    
    @Override
    public boolean save(User user) {
        if (user.getPassword() == null || user.getPassword().isEmpty()) {
            user.setPassword("123456");
        }
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        if (user.getStatus() == null) {
            user.setStatus(1);
        }
        return userMapper.insert(user) > 0;
    }
    
    @Override
    public boolean update(User user) {
        // 如果密码不为空，则加密
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            user.setPassword(passwordEncoder.encode(user.getPassword()));
        } else {
            // 不更新密码
            user.setPassword(null);
        }
        return userMapper.update(user) > 0;
    }
    
    @Override
    public boolean deleteById(Integer id) {
        // 禁止删除管理员账号
        User user = userMapper.findById(id);
        if (user != null && "admin".equals(user.getUsername())) {
            return false;
        }
        return userMapper.deleteById(id) > 0;
    }
    
    @Override
    public boolean updateStatus(Integer id, Integer status) {
        // 禁止禁用管理员账号
        User user = userMapper.findById(id);
        if (user != null && "admin".equals(user.getUsername()) && status == 0) {
            return false;
        }
        return userMapper.updateStatus(id, status) > 0;
    }
    
    @Override
    public boolean updatePassword(Integer id, String oldPassword, String newPassword) {
        User user = userMapper.findById(id);
        if (user == null) {
            return false;
        }
        
        // 验证旧密码
        String storedPassword = user.getPassword();
        boolean passwordMatch = false;
        
        if (storedPassword != null && (storedPassword.startsWith("$2a$") || storedPassword.startsWith("$2b$") || storedPassword.startsWith("$2y$"))) {
            passwordMatch = passwordEncoder.matches(oldPassword, storedPassword);
        } else {
            passwordMatch = oldPassword.equals(storedPassword);
        }
        
        if (!passwordMatch) {
            return false;
        }
        
        // 更新为新密码
        user.setPassword(passwordEncoder.encode(newPassword));
        return userMapper.update(user) > 0;
    }
}
