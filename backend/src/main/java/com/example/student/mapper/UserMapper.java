package com.example.student.mapper;

import com.example.student.entity.User;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface UserMapper {
    
    @Select("SELECT * FROM user WHERE username = #{username}")
    User findByUsername(@Param("username") String username);
    
    @Select("SELECT * FROM user WHERE id = #{id}")
    User findById(@Param("id") Integer id);
    
    @Select("SELECT id, username, real_name, role, status, create_time, update_time FROM user ORDER BY create_time DESC")
    List<User> findAll();
    
    @Insert("INSERT INTO user (username, password, real_name, role, status, create_time, update_time) " +
            "VALUES (#{username}, #{password}, #{realName}, #{role}, #{status}, NOW(), NOW())")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(User user);
    
    @Update("<script>" +
            "UPDATE user " +
            "<set>" +
            "<if test='username != null'>username = #{username},</if>" +
            "<if test='password != null'>password = #{password},</if>" +
            "<if test='realName != null'>real_name = #{realName},</if>" +
            "<if test='role != null'>role = #{role},</if>" +
            "<if test='status != null'>status = #{status},</if>" +
            "update_time = NOW()" +
            "</set>" +
            "WHERE id = #{id}" +
            "</script>")
    int update(User user);
    
    @Delete("DELETE FROM user WHERE id = #{id}")
    int deleteById(@Param("id") Integer id);
    
    @Update("UPDATE user SET status = #{status}, update_time = NOW() WHERE id = #{id}")
    int updateStatus(@Param("id") Integer id, @Param("status") Integer status);
}
