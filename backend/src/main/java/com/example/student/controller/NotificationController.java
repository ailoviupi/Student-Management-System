package com.example.student.controller;

import com.example.student.common.RequireRole;
import com.example.student.entity.Notification;
import com.example.student.entity.User;
import com.example.student.service.NotificationService;
import com.example.student.common.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/notification")
public class NotificationController {

    @Autowired
    private NotificationService notificationService;

    // 发布通知：管理员/教师
    @RequireRole({"admin", "teacher"})
    @PostMapping
    public Result<Void> createNotification(@RequestBody Notification notification, HttpServletRequest request) {
        User user = (User) request.getAttribute("user");
        if (user != null) {
            notification.setSenderId(user.getId());
            notification.setSenderName(user.getRealName());
        }
        return notificationService.createNotification(notification) ? Result.success() : Result.error("发送失败");
    }

    @GetMapping("/list")
    public Result<List<Notification>> getUserNotifications(HttpServletRequest request) {
        Integer userId = (Integer) request.getAttribute("userId");
        String role = (String) request.getAttribute("role");
        Integer classId = (Integer) request.getAttribute("classId");
        return Result.success(notificationService.getUserNotifications(userId, role, classId));
    }

    @GetMapping("/unread-count")
    public Result<Integer> getUnreadCount(HttpServletRequest request) {
        Integer userId = (Integer) request.getAttribute("userId");
        return Result.success(notificationService.getUnreadCount(userId));
    }

    @PostMapping("/read/{notificationId}")
    public Result<Void> markAsRead(@PathVariable Integer notificationId, HttpServletRequest request) {
        Integer userId = (Integer) request.getAttribute("userId");
        return notificationService.markAsRead(userId, notificationId) ? Result.success() : Result.error("操作失败");
    }

    @PostMapping("/read-all")
    public Result<Void> markAllAsRead(HttpServletRequest request) {
        Integer userId = (Integer) request.getAttribute("userId");
        return notificationService.markAllAsRead(userId) ? Result.success() : Result.error("操作失败");
    }

    // 撤回通知：仅管理员
    @RequireRole("admin")
    @PostMapping("/withdraw/{notificationId}")
    public Result<Void> withdrawNotification(@PathVariable Integer notificationId) {
        return notificationService.withdrawNotification(notificationId) ? Result.success() : Result.error("撤回失败");
    }

    // 删除通知：仅管理员
    @RequireRole("admin")
    @DeleteMapping("/{notificationId}")
    public Result<Void> deleteNotification(@PathVariable Integer notificationId) {
        return notificationService.deleteNotification(notificationId) ? Result.success() : Result.error("删除失败");
    }
}
