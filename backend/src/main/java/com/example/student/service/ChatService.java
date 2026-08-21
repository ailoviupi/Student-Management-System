package com.example.student.service;

import com.example.student.entity.ChatMessage;

import java.util.List;
import java.util.Map;

public interface ChatService {
    List<Map<String, Object>> getConversationList(Integer userId, String role);
    
    List<Map<String, Object>> getMessagesBetween(Integer userId, Integer targetId, String role);
    
    void markAsRead(Integer senderId, Integer receiverId);
    
    int getUnreadCount(Integer userId, String role);
    
    Map<String, Object> getChatStatistics();
    
    List<Map<String, Object>> getDailyMessageStats(Integer days);
    
    List<Map<String, Object>> getTopActiveUsers(Integer limit);
    
    Map<String, Object> getDetailedStatistics();
}