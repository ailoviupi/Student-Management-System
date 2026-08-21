package com.example.student.service.impl;

import com.example.student.entity.Notification;
import com.example.student.mapper.NotificationMapper;
import com.example.student.service.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class NotificationServiceImpl implements NotificationService {

    @Autowired
    private NotificationMapper notificationMapper;

    @Override
    public boolean createNotification(Notification notification) {
        notification.setStatus(1);
        return notificationMapper.insert(notification) > 0;
    }

    @Override
    public List<Notification> getUserNotifications(Integer userId, String role, Integer classId) {
        return notificationMapper.findByUserId(userId, role, classId);
    }

    @Override
    public int getUnreadCount(Integer userId) {
        return notificationMapper.countUnread(userId);
    }

    @Override
    public boolean markAsRead(Integer userId, Integer notificationId) {
        return notificationMapper.markAsRead(userId, notificationId) > 0;
    }

    @Override
    public boolean markAllAsRead(Integer userId) {
        return true;
    }

    @Override
    public boolean withdrawNotification(Integer notificationId) {
        return notificationMapper.updateStatus(notificationId, 2) > 0;
    }

    @Override
    public boolean deleteNotification(Integer notificationId) {
        return notificationMapper.deleteById(notificationId) > 0;
    }

    @Override
    public Map<String, Object> getStatistics() {
        return new HashMap<>();
    }
}
