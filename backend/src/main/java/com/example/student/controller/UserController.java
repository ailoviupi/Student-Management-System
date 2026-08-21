package com.example.student.controller;

import com.example.student.common.RequireRole;
import com.example.student.common.Result;
import com.example.student.entity.User;
import com.example.student.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@RestController
@RequestMapping("/api/users")
@CrossOrigin
public class UserController {

    @Autowired
    private UserService userService;

    // 检查是否为管理员
    private boolean isAdmin(HttpServletRequest request) {
        String role = (String) request.getAttribute("role");
        return "admin".equals(role);
    }

    @RequireRole("admin")
    @GetMapping
    public Result<List<User>> getAllUsers(HttpServletRequest request) {
        if (!isAdmin(request)) {
            return Result.error(403, "无权访问，仅管理员可操作");
        }
        return Result.success(userService.findAll());
    }

    // 教师/管理员可按角色获取用户列表（用于班级管理、排课等场景选择教师）
    @RequireRole({"admin", "teacher"})
    @GetMapping("/by-role")
    public Result<List<User>> getUsersByRole(@RequestParam String role, HttpServletRequest request) {
        // 允许所有已登录用户获取教师列表（用于班级管理选择班主任）
        String userRole = (String) request.getAttribute("role");
        if (userRole == null) {
            return Result.error(403, "未登录");
        }
        return Result.success(userService.findByRole(role));
    }

    @RequireRole("admin")
    @GetMapping("/{id}")
    public Result<User> getUserById(@PathVariable Integer id, HttpServletRequest request) {
        if (!isAdmin(request)) {
            return Result.error(403, "无权访问，仅管理员可操作");
        }
        User user = userService.findById(id);
        if (user == null) {
            return Result.error("用户不存在");
        }
        return Result.success(user);
    }

    @RequireRole("admin")
    @PostMapping
    public Result<User> addUser(@RequestBody User user, HttpServletRequest request) {
        if (!isAdmin(request)) {
            return Result.error(403, "无权访问，仅管理员可添加用户");
        }
        if (userService.findByUsername(user.getUsername()) != null) {
            return Result.error("用户名已存在");
        }
        boolean success = userService.save(user);
        if (success) {
            return Result.success(user);
        }
        return Result.error("添加失败");
    }

    @RequireRole("admin")
    @PutMapping("/{id}")
    public Result<User> updateUser(@PathVariable Integer id, @RequestBody User user, HttpServletRequest request) {
        if (!isAdmin(request)) {
            return Result.error(403, "无权访问，仅管理员可修改用户");
        }
        user.setId(id);
        boolean success = userService.update(user);
        if (success) {
            return Result.success(user);
        }
        return Result.error("更新失败");
    }

    @RequireRole("admin")
    @DeleteMapping("/{id}")
    public Result<Void> deleteUser(@PathVariable Integer id, HttpServletRequest request) {
        if (!isAdmin(request)) {
            return Result.error(403, "无权访问，仅管理员可删除用户");
        }
        boolean success = userService.deleteById(id);
        if (success) {
            return Result.success();
        }
        return Result.error("删除失败");
    }

    @RequireRole("admin")
    @PutMapping("/{id}/status")
    public Result<Void> updateUserStatus(@PathVariable Integer id, @RequestParam Integer status, HttpServletRequest request) {
        if (!isAdmin(request)) {
            return Result.error(403, "无权访问，仅管理员可修改用户状态");
        }
        boolean success = userService.updateStatus(id, status);
        if (success) {
            return Result.success();
        }
        return Result.error("更新状态失败");
    }
}
