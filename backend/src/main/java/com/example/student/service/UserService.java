package com.example.student.service;

import com.example.student.entity.User;

import java.util.List;

public interface UserService {
    User findByUsername(String username);
    
    User findById(Integer id);
    
    List<User> findAll();
    
    boolean save(User user);
    
    boolean update(User user);
    
    boolean deleteById(Integer id);
    
    boolean updateStatus(Integer id, Integer status);
    
    boolean updatePassword(Integer id, String oldPassword, String newPassword);
}
