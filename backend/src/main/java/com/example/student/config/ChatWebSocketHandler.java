package com.example.student.config;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.example.student.entity.ChatMessage;
import com.example.student.entity.Student;
import com.example.student.entity.User;
import com.example.student.mapper.ChatMessageMapper;
import com.example.student.mapper.StudentMapper;
import com.example.student.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class ChatWebSocketHandler extends TextWebSocketHandler {

    public static final Map<Integer, WebSocketSession> studentSessions = new ConcurrentHashMap<>();
    public static final Map<Integer, WebSocketSession> teacherSessions = new ConcurrentHashMap<>();

    @Autowired
    private ChatMessageMapper chatMessageMapper;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private StudentMapper studentMapper;

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        Integer userId = (Integer) session.getAttributes().get("userId");
        String role = (String) session.getAttributes().get("role");
        
        if (userId == null || role == null) {
            session.close();
            return;
        }

        if ("student".equals(role)) {
            studentSessions.put(userId, session);
        } else if ("teacher".equals(role)) {
            teacherSessions.put(userId, session);
        }
        
        broadcastStatisticsUpdate();
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String payload = message.getPayload();
        JSONObject json = JSON.parseObject(payload);
        
        Integer senderId = (Integer) session.getAttributes().get("userId");
        String senderRole = (String) session.getAttributes().get("role");
        Integer receiverId = json.getInteger("receiverId");
        String content = json.getString("content");

        ChatMessage chatMessage = new ChatMessage();
        chatMessage.setSenderId(senderId);
        chatMessage.setSenderRole(senderRole);
        chatMessage.setReceiverId(receiverId);
        chatMessage.setReceiverRole("teacher".equals(senderRole) ? "student" : "teacher");
        chatMessage.setContent(content);
        chatMessage.setSendTime(LocalDateTime.now());
        chatMessage.setReadStatus(0);

        chatMessageMapper.insert(chatMessage);

        WebSocketSession receiverSession = "student".equals(senderRole) 
                ? teacherSessions.get(receiverId) 
                : studentSessions.get(receiverId);

        if (receiverSession != null && receiverSession.isOpen()) {
            JSONObject response = new JSONObject();
            response.put("id", chatMessage.getId());
            response.put("senderId", senderId);
            response.put("senderName", resolveSenderName(senderId, senderRole));
            response.put("senderRole", senderRole);
            response.put("receiverId", receiverId);
            response.put("content", content);
            response.put("sendTime", chatMessage.getSendTime().toString());
            response.put("readStatus", 0);
            
            receiverSession.sendMessage(new TextMessage(response.toJSONString()));
        }
    }

    /**
     * 按角色解析发送者显示名：
     * 教师/管理员查 user 表，学生查 student 表（学生 id 不存在于 user 表，
     * 若一律查 user 表会导致学生发消息时 NPE 或显示错名）。
     */
    private String resolveSenderName(Integer senderId, String senderRole) {
        if ("teacher".equals(senderRole) || "admin".equals(senderRole)) {
            User user = userMapper.findById(senderId);
            if (user != null) {
                return user.getRealName();
            }
        } else {
            Student student = studentMapper.findById(senderId);
            if (student != null) {
                return student.getName();
            }
        }
        return "用户" + senderId;
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        Integer userId = (Integer) session.getAttributes().get("userId");
        String role = (String) session.getAttributes().get("role");

        if ("student".equals(role)) {
            studentSessions.remove(userId);
        } else if ("teacher".equals(role)) {
            teacherSessions.remove(userId);
        }
        
        broadcastStatisticsUpdate();
    }

    private void broadcastStatisticsUpdate() {
        JSONObject stats = new JSONObject();
        stats.put("type", "statistics");
        stats.put("onlineStudents", studentSessions.size());
        stats.put("onlineTeachers", teacherSessions.size());
        stats.put("totalOnline", studentSessions.size() + teacherSessions.size());
        
        String jsonStr = stats.toJSONString();
        for (WebSocketSession session : teacherSessions.values()) {
            if (session.isOpen()) {
                try {
                    session.sendMessage(new TextMessage(jsonStr));
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}