package com.example.student.controller;

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

    @GetMapping
    public Result<List<User>> getAllUsers(HttpServletRequest request) {
        if (!isAdmin(request)) {
            return Result.error(403, "无权访问，仅管理员可操作");
        }
        return Result.success(userService.findAll());
    }

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
