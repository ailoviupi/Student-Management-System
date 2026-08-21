package com.example.student.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

@Component
public class WebSocketAuthInterceptor implements HandshakeInterceptor {

    @Autowired
    private JwtConfig jwtConfig;

    @Override
    public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response,
                                   WebSocketHandler wsHandler, Map<String, Object> attributes) throws Exception {
        
        String token = null;
        
        if (request instanceof ServletServerHttpRequest) {
            HttpServletRequest httpRequest = ((ServletServerHttpRequest) request).getServletRequest();
            token = httpRequest.getHeader("Authorization");
        }
        
        if (token == null) {
            String query = request.getURI().getQuery();
            if (query != null && query.contains("token=")) {
                token = query.substring(query.indexOf("token=") + 6);
            }
        }
        
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7);
        }
        
        if (token == null || !jwtConfig.validateToken(token)) {
            return false;
        }
        
        Integer userId = jwtConfig.getUserIdFromToken(token);
        String role = jwtConfig.getRoleFromToken(token);
        
        attributes.put("userId", userId);
        attributes.put("role", role);
        attributes.put("token", token);
        
        return true;
    }

    @Override
    public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response,
                              WebSocketHandler wsHandler, Exception exception) {
    }
}