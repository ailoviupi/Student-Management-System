package com.example.student.controller;

import com.example.student.common.RequireRole;
import com.example.student.common.Result;
import com.example.student.entity.Student;
import com.example.student.entity.User;
import com.example.student.mapper.StudentMapper;
import com.example.student.mapper.UserMapper;
import com.example.student.service.ChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/chat")
@CrossOrigin
public class ChatController {

    @Autowired
    private ChatService chatService;

    @Autowired
    private StudentMapper studentMapper;

    @Autowired
    private UserMapper userMapper;

    @GetMapping("/conversations")
    public Result<?> getConversations(@RequestAttribute("userId") Integer userId,
                                       @RequestAttribute("role") String role) {
        return Result.success(chatService.getConversationList(userId, role));
    }

    @GetMapping("/messages")
    public Result<?> getMessages(@RequestAttribute("userId") Integer userId,
                                  @RequestAttribute("role") String role,
                                  @RequestParam("targetId") Integer targetId) {
        return Result.success(chatService.getMessagesBetween(userId, targetId, role));
    }

    @PostMapping("/read")
    public Result<?> markAsRead(@RequestAttribute("userId") Integer userId,
                                 @RequestBody Map<String, Integer> params) {
        Integer senderId = params.get("senderId");
        chatService.markAsRead(senderId, userId);
        return Result.success();
    }

    @GetMapping("/unread-count")
    public Result<?> getUnreadCount(@RequestAttribute("userId") Integer userId,
                                     @RequestAttribute("role") String role) {
        return Result.success(chatService.getUnreadCount(userId, role));
    }

    // 全局聊天统计：供数据概览页使用，仅管理员/教师可见
    @RequireRole({"admin", "teacher"})
    @GetMapping("/statistics")
    public Result<?> getChatStatistics() {
        return Result.success(chatService.getChatStatistics());
    }

    @RequireRole({"admin", "teacher"})
    @GetMapping("/statistics/detailed")
    public Result<?> getDetailedStatistics() {
        return Result.success(chatService.getDetailedStatistics());
    }

    @RequireRole({"admin", "teacher"})
    @GetMapping("/statistics/daily")
    public Result<?> getDailyMessageStats(@RequestParam(value = "days", defaultValue = "7") Integer days) {
        return Result.success(chatService.getDailyMessageStats(days));
    }

    @RequireRole({"admin", "teacher"})
    @GetMapping("/statistics/top-users")
    public Result<?> getTopActiveUsers(@RequestParam(value = "limit", defaultValue = "10") Integer limit) {
        return Result.success(chatService.getTopActiveUsers(limit));
    }

    // 学生列表：教师/管理员选择聊天对象用
    @RequireRole({"admin", "teacher"})
    @GetMapping("/students")
    public Result<?> getAvailableStudents(@RequestParam(value = "keyword", required = false) String keyword) {
        List<Student> students = studentMapper.findAll();
        if (keyword != null && !keyword.isEmpty()) {
            students = students.stream()
                    .filter(s -> s.getName().contains(keyword) || 
                               (s.getStudentNo() != null && s.getStudentNo().contains(keyword)))
                    .collect(Collectors.toList());
        }
        return Result.success(students.stream()
                .map(s -> {
                    Map<String, Object> item = new HashMap<>();
                    item.put("id", s.getId());
                    item.put("name", s.getName());
                    item.put("studentNo", s.getStudentNo());
                    item.put("className", s.getClassName());
                    item.put("avatar", String.valueOf(s.getName().charAt(0)));
                    return item;
                })
                .collect(Collectors.toList()));
    }

    @GetMapping("/teachers")
    public Result<?> getAvailableTeachers() {
        List<User> teachers = userMapper.findByRole("teacher");
        return Result.success(teachers.stream()
                .map(t -> {
                    Map<String, Object> item = new HashMap<>();
                    item.put("id", t.getId());
                    item.put("name", t.getRealName());
                    item.put("avatar", String.valueOf(t.getRealName().charAt(0)));
                    return item;
                })
                .collect(Collectors.toList()));
    }
}