package com.example.student.mapper;

import com.example.student.entity.ChatMessage;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface ChatMessageMapper {
    int insert(ChatMessage chatMessage);
    
    List<ChatMessage> getMessagesBetween(@Param("userId") Integer userId, @Param("targetId") Integer targetId);
    
    List<ChatMessage> getConversationList(@Param("userId") Integer userId, @Param("role") String role);
    
    int updateReadStatus(@Param("senderId") Integer senderId, @Param("receiverId") Integer receiverId);
    
    int countUnread(@Param("userId") Integer userId, @Param("role") String role);
    
    /** 单个会话内的未读条数（receiver 视角，按对方 senderId 过滤） */
    int countUnreadFrom(@Param("userId") Integer userId, @Param("senderId") Integer senderId);
    
    int countTodayMessages();
    
    int countTotalMessages();
    
    List<Map<String, Object>> getDailyMessageStats(@Param("days") Integer days);
    
    List<Map<String, Object>> getTopActiveUsers(@Param("limit") Integer limit);
    
    int countStudentMessages();
    
    int countTeacherMessages();
    
    int countConversations();
}