package com.example.student.controller;

import com.example.student.common.RequireRole;
import com.example.student.common.Result;
import com.example.student.config.JwtConfig;
import com.example.student.dto.LoginDTO;
import com.example.student.entity.Student;
import com.example.student.entity.StudentAccount;
import com.example.student.entity.User;
import com.example.student.mapper.StudentAccountMapper;
import com.example.student.service.StudentService;
import com.example.student.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin
public class AuthController {
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private StudentService studentService;
    
    @Autowired
    private JwtConfig jwtConfig;
    
    @Autowired
    private StudentAccountMapper studentAccountMapper;
    
    private BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    
    @PostMapping("/login")
    public Result<Map<String, Object>> login(@Valid @RequestBody LoginDTO loginDTO) {
        String username = loginDTO.getUsername();
        String password = loginDTO.getPassword();
        
        // 首先尝试从用户表登录（管理员、教师）
        User user = userService.findByUsername(username);
        
        if (user != null) {
            if (user.getStatus() == 0) {
                return Result.error(403, "账号已被禁用");
            }
            
            // 验证密码
            String storedPassword = user.getPassword();
            boolean passwordMatch = false;
            
            if (storedPassword != null && (storedPassword.startsWith("$2a$") || storedPassword.startsWith("$2b$") || storedPassword.startsWith("$2y$"))) {
                passwordMatch = passwordEncoder.matches(password, storedPassword);
            } else {
                // 兼容未加密密码（仅首次登录使用，登录后应强制修改密码）
                passwordMatch = password.equals(storedPassword);
            }
            
            if (!passwordMatch) {
                return Result.error(401, "用户名或密码错误");
            }
            
            String token = jwtConfig.generateToken(user.getUsername(), user.getRole(), user.getId());
            
            Map<String, Object> data = new HashMap<>();
            data.put("token", token);
            data.put("id", user.getId());
            data.put("username", user.getUsername());
            data.put("realName", user.getRealName());
            data.put("role", user.getRole());
            
            return Result.success(data);
        }
        
        // 如果用户表没有找到，尝试从学生表登录
        Student student = studentService.findByStudentNo(username);
        
        if (student != null) {
            // 学生账号密码体系：首次登录使用默认密码（学号后6位或 123456）自动建档，
            // 建档后按 BCrypt 校验密码，学生可在个人中心修改密码
            String studentNo = student.getStudentNo();
            String defaultPassword = studentNo;
            if (studentNo != null && studentNo.length() > 6) {
                defaultPassword = studentNo.substring(studentNo.length() - 6);
            }
            
            StudentAccount account = studentAccountMapper.findByStudentNo(studentNo);
            boolean passwordMatch;
            if (account == null) {
                // 首次登录：校验默认密码并自动建档
                passwordMatch = defaultPassword.equals(password) || "123456".equals(password);
                if (passwordMatch) {
                    StudentAccount newAccount = new StudentAccount();
                    newAccount.setStudentId(student.getId());
                    // 保存实际使用的密码（默认密码优先于 123456）
                    newAccount.setPassword(passwordEncoder.encode(defaultPassword.equals(password) ? defaultPassword : "123456"));
                    studentAccountMapper.insert(newAccount);
                }
            } else {
                passwordMatch = passwordEncoder.matches(password, account.getPassword());
            }
            
            if (!passwordMatch) {
                return Result.error(401, "用户名或密码错误");
            }
            
            String token = jwtConfig.generateToken(student.getStudentNo(), "student", student.getId());
            
            Map<String, Object> data = new HashMap<>();
            data.put("token", token);
            data.put("username", student.getStudentNo());
            data.put("realName", student.getName());
            data.put("role", "student");
            data.put("studentId", student.getId());
            
            return Result.success(data);
        }
        
        return Result.error(401, "用户名或密码错误");
    }
    
    @GetMapping("/info")
    public Result<Map<String, Object>> getUserInfo(@RequestAttribute("username") String username,
                                                    @RequestAttribute("role") String role) {
        Map<String, Object> data = new HashMap<>();
        
        // 如果是学生角色，从学生表查询
        if ("student".equals(role)) {
            Student student = studentService.findByStudentNo(username);
            if (student == null) {
                return Result.error("用户不存在");
            }
            data.put("id", student.getId());
            data.put("username", student.getStudentNo());
            data.put("realName", student.getName());
            data.put("role", "student");
            data.put("studentNo", student.getStudentNo());
            data.put("className", student.getClassName());
        } else {
            // 管理员或教师，从用户表查询
            User user = userService.findByUsername(username);
            if (user == null) {
                return Result.error("用户不存在");
            }
            data.put("id", user.getId());
            data.put("username", user.getUsername());
            data.put("realName", user.getRealName());
            data.put("role", user.getRole());
        }
        
        return Result.success(data);
    }
    
    // 修改密码：管理员/教师走 user 表，学生走 student_account 表（BCrypt 校验）
    @RequireRole({"admin", "teacher", "student"})
    @PostMapping("/change-password")
    public Result<Void> changePassword(@RequestAttribute("username") String username,
                                        @RequestAttribute("role") String role,
                                        @RequestBody Map<String, String> params) {
        String oldPassword = params.get("oldPassword");
        String newPassword = params.get("newPassword");
        
        if (oldPassword == null || newPassword == null) {
            return Result.error("参数错误");
        }
        if (newPassword.length() < 6) {
            return Result.error("新密码长度至少6位");
        }
        
        // 学生账号：校验 student_account 中的 BCrypt 密码
        if ("student".equals(role)) {
            StudentAccount account = studentAccountMapper.findByStudentNo(username);
            if (account == null) {
                return Result.error("学生账号未初始化，请先使用默认密码登录");
            }
            if (!passwordEncoder.matches(oldPassword, account.getPassword())) {
                return Result.error("旧密码错误");
            }
            studentAccountMapper.updatePassword(account.getId(), passwordEncoder.encode(newPassword));
            return Result.success();
        }
        
        User user = userService.findByUsername(username);
        if (user == null) {
            return Result.error("用户不存在");
        }
        
        if (userService.updatePassword(user.getId(), oldPassword, newPassword)) {
            return Result.success();
        }
        return Result.error("旧密码错误");
    }
}
