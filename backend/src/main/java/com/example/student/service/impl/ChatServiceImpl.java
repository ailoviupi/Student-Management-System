package com.example.student.service.impl;

import com.example.student.entity.ChatMessage;
import com.example.student.entity.Student;
import com.example.student.entity.User;
import com.example.student.mapper.ChatMessageMapper;
import com.example.student.mapper.StudentMapper;
import com.example.student.mapper.UserMapper;
import com.example.student.service.ChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class ChatServiceImpl implements ChatService {

    @Autowired
    private ChatMessageMapper chatMessageMapper;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private StudentMapper studentMapper;

    @Override
    public List<Map<String, Object>> getConversationList(Integer userId, String role) {
        List<ChatMessage> messages = chatMessageMapper.getConversationList(userId, role);
        List<Map<String, Object>> result = new ArrayList<>();

        for (ChatMessage msg : messages) {
            Map<String, Object> item = new HashMap<>();
            Integer targetId = msg.getSenderId().equals(userId) ? msg.getReceiverId() : msg.getSenderId();
            String targetRole = msg.getSenderId().equals(userId) ? msg.getReceiverRole() : msg.getSenderRole();

            item.put("targetId", targetId);
            item.put("targetRole", targetRole);
            item.put("lastContent", msg.getContent());
            item.put("lastTime", msg.getSendTime());
            item.put("unreadCount", chatMessageMapper.countUnreadFrom(userId, targetId));

            if ("teacher".equals(targetRole)) {
                User teacher = userMapper.findById(targetId);
                if (teacher != null) {
                    item.put("targetName", teacher.getRealName());
                    item.put("targetAvatar", teacher.getRealName().charAt(0));
                }
            } else {
                Student student = studentMapper.findById(targetId);
                if (student != null) {
                    item.put("targetName", student.getName());
                    item.put("targetAvatar", student.getName().charAt(0));
                    item.put("studentNo", student.getStudentNo());
                    item.put("className", student.getClassName());
                }
            }

            result.add(item);
        }

        return result;
    }

    @Override
    public List<Map<String, Object>> getMessagesBetween(Integer userId, Integer targetId, String role) {
        List<ChatMessage> messages = chatMessageMapper.getMessagesBetween(userId, targetId);
        List<Map<String, Object>> result = new ArrayList<>();

        chatMessageMapper.updateReadStatus(targetId, userId);

        for (ChatMessage msg : messages) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", msg.getId());
            item.put("senderId", msg.getSenderId());
            item.put("senderRole", msg.getSenderRole());
            item.put("receiverId", msg.getReceiverId());
            item.put("content", msg.getContent());
            item.put("sendTime", msg.getSendTime());
            item.put("readStatus", msg.getReadStatus());
            item.put("isMine", msg.getSenderId().equals(userId));

            if ("teacher".equals(msg.getSenderRole())) {
                User teacher = userMapper.findById(msg.getSenderId());
                if (teacher != null) {
                    item.put("senderName", teacher.getRealName());
                    item.put("senderAvatar", teacher.getRealName().charAt(0));
                }
            } else {
                Student student = studentMapper.findById(msg.getSenderId());
                if (student != null) {
                    item.put("senderName", student.getName());
                    item.put("senderAvatar", student.getName().charAt(0));
                }
            }

            result.add(item);
        }

        return result;
    }

    @Override
    public void markAsRead(Integer senderId, Integer receiverId) {
        chatMessageMapper.updateReadStatus(senderId, receiverId);
    }

    @Override
    public int getUnreadCount(Integer userId, String role) {
        return chatMessageMapper.countUnread(userId, role);
    }

    @Override
    public Map<String, Object> getChatStatistics() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalMessages", chatMessageMapper.countTotalMessages());
        stats.put("todayMessages", chatMessageMapper.countTodayMessages());
        stats.put("onlineStudents", com.example.student.config.ChatWebSocketHandler.studentSessions.size());
        stats.put("onlineTeachers", com.example.student.config.ChatWebSocketHandler.teacherSessions.size());
        return stats;
    }

    @Override
    public List<Map<String, Object>> getDailyMessageStats(Integer days) {
        return chatMessageMapper.getDailyMessageStats(days);
    }

    @Override
    public List<Map<String, Object>> getTopActiveUsers(Integer limit) {
        List<Map<String, Object>> result = chatMessageMapper.getTopActiveUsers(limit);
        for (Map<String, Object> item : result) {
            Integer userId = (Integer) item.get("userId");
            String role = (String) item.get("role");
            if ("teacher".equals(role)) {
                User teacher = userMapper.findById(userId);
                if (teacher != null) {
                    item.put("name", teacher.getRealName());
                    item.put("username", teacher.getUsername());
                }
            } else {
                Student student = studentMapper.findById(userId);
                if (student != null) {
                    item.put("name", student.getName());
                    item.put("username", student.getStudentNo());
                }
            }
        }
        return result;
    }

    @Override
    public Map<String, Object> getDetailedStatistics() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalMessages", chatMessageMapper.countTotalMessages());
        stats.put("todayMessages", chatMessageMapper.countTodayMessages());
        stats.put("studentMessages", chatMessageMapper.countStudentMessages());
        stats.put("teacherMessages", chatMessageMapper.countTeacherMessages());
        stats.put("totalConversations", chatMessageMapper.countConversations());
        stats.put("onlineStudents", com.example.student.config.ChatWebSocketHandler.studentSessions.size());
        stats.put("onlineTeachers", com.example.student.config.ChatWebSocketHandler.teacherSessions.size());
        stats.put("totalOnline", com.example.student.config.ChatWebSocketHandler.studentSessions.size() 
                + com.example.student.config.ChatWebSocketHandler.teacherSessions.size());
        stats.put("dailyStats", getDailyMessageStats(7));
        stats.put("topActiveUsers", getTopActiveUsers(10));
        return stats;
    }
}