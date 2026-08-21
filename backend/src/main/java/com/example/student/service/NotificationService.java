package com.example.student.service;

import com.example.student.entity.Notification;
import java.util.List;
import java.util.Map;

public interface NotificationService {
    
    boolean createNotification(Notification notification);
    
    List<Notification> getUserNotifications(Integer userId, String role, Integer classId);
    
    int getUnreadCount(Integer userId);
    
    boolean markAsRead(Integer userId, Integer notificationId);
    
    boolean markAllAsRead(Integer userId);
    
    boolean withdrawNotification(Integer notificationId);
    
    boolean deleteNotification(Integer notificationId);
    
    Map<String, Object> getStatistics();
}
