package com.example.student.interceptor;

import com.example.student.common.Result;
import com.example.student.config.JwtConfig;
import com.example.student.entity.Student;
import com.example.student.entity.User;
import com.example.student.mapper.StudentMapper;
import com.example.student.mapper.UserMapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Component
public class JwtInterceptor implements HandlerInterceptor {
    
    @Autowired
    private JwtConfig jwtConfig;
    
    @Autowired
    private UserMapper userMapper;
    
    @Autowired
    private StudentMapper studentMapper;
    
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 放行 CORS 预检请求
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            return true;
        }

        String token = request.getHeader("Authorization");
        
        if (token == null || !token.startsWith("Bearer ")) {
            response.setStatus(401);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(new ObjectMapper().writeValueAsString(Result.error(401, "未登录或token无效")));
            return false;
        }
        
        token = token.substring(7);
        
        if (!jwtConfig.validateToken(token)) {
            response.setStatus(401);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(new ObjectMapper().writeValueAsString(Result.error(401, "token已过期")));
            return false;
        }
        
        String username = jwtConfig.getUsernameFromToken(token);
        String role = jwtConfig.getRoleFromToken(token);
        Integer userId = jwtConfig.getUserIdFromToken(token);
        
        request.setAttribute("username", username);
        request.setAttribute("role", role);
        request.setAttribute("userId", userId);
        
        if ("student".equals(role)) {
            Student student = studentMapper.findByStudentNo(username);
            if (student != null) {
                request.setAttribute("user", student);
                // 供消息通知按班级定向推送使用
                request.setAttribute("classId", student.getClassId());
            }
        } else {
            User user = userMapper.findByUsername(username);
            if (user != null) {
                request.setAttribute("user", user);
            }
        }
        
        return true;
    }
}
