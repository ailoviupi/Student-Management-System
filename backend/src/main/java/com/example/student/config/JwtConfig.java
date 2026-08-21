package com.example.student.config;

import io.jsonwebtoken.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.Date;

@Component
public class JwtConfig {

    private static final Logger log = LoggerFactory.getLogger(JwtConfig.class);

    @Value("${jwt.secret:student-management-secret-key}")
    private String secret;
    
    @Value("${jwt.expiration:86400000}")
    private Long expiration;

    /**
     * 启动时校验 JWT 密钥强度：生产环境应通过环境变量 JWT_SECRET 提供强密钥
     */
    @PostConstruct
    public void validateSecret() {
        if (secret == null || secret.length() < 32) {
            log.warn("JWT 密钥长度不足 32 位，签名强度偏弱，存在安全隐患。请通过环境变量 JWT_SECRET 设置足够长的强密钥。");
        }
    }
    
    public String generateToken(String username, String role) {
        return generateToken(username, role, null);
    }
    
    public String generateToken(String username, String role, Integer userId) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + expiration);
        
        return Jwts.builder()
                .setSubject(username)
                .claim("role", role)
                .claim("userId", userId)
                .setIssuedAt(now)
                .setExpiration(expiryDate)
                .signWith(SignatureAlgorithm.HS512, secret)
                .compact();
    }
    
    public String getUsernameFromToken(String token) {
        Claims claims = parseToken(token);
        return claims != null ? claims.getSubject() : null;
    }
    
    public String getRoleFromToken(String token) {
        Claims claims = parseToken(token);
        return claims != null ? claims.get("role", String.class) : null;
    }
    
    public Integer getUserIdFromToken(String token) {
        Claims claims = parseToken(token);
        return claims != null ? claims.get("userId", Integer.class) : null;
    }
    
    public boolean validateToken(String token) {
        try {
            parseToken(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    private Claims parseToken(String token) {
        return Jwts.parser()
                .setSigningKey(secret)
                .parseClaimsJws(token)
                .getBody();
    }
}
