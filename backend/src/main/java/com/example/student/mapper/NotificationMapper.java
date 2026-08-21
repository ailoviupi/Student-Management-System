package com.example.student.mapper;

import com.example.student.entity.Notification;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface NotificationMapper {
    
    @Insert("INSERT INTO notification (title, content, type, sender_id, sender_name, target_type, target_id, priority, status, publish_time) " +
            "VALUES (#{title}, #{content}, #{type}, #{senderId}, #{senderName}, #{targetType}, #{targetId}, #{priority}, #{status}, #{publishTime})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Notification notification);
    
    @Select("<script>" +
            "SELECT n.*, un.is_read, un.read_time FROM notification n " +
            "LEFT JOIN user_notification un ON n.id = un.notification_id AND un.user_id = #{userId} " +
            "WHERE n.status = 1 " +
            "AND (n.target_type = 'ALL' " +
            "<if test='role != null'> OR (n.target_type = 'ROLE' AND n.target_id = #{role}) </if>" +
            "OR (n.target_type = 'USER' AND n.target_id = #{userId}) " +
            "OR (n.target_type = 'CLASS' AND n.target_id = #{classId})) " +
            "ORDER BY n.priority DESC, n.publish_time DESC" +
            "</script>")
    List<Notification> findByUserId(@Param("userId") Integer userId, 
                                     @Param("role") String role, 
                                     @Param("classId") Integer classId);
    
    @Select("SELECT n.* FROM notification n WHERE n.id = #{id}")
    Notification findById(Integer id);
    
    @Select("SELECT COUNT(*) FROM user_notification WHERE user_id = #{userId} AND is_read = 0")
    int countUnread(Integer userId);
    
    @Insert("INSERT INTO user_notification (user_id, notification_id, is_read, read_time) " +
            "VALUES (#{userId}, #{notificationId}, 1, NOW()) " +
            "ON DUPLICATE KEY UPDATE is_read = 1, read_time = NOW()")
    int markAsRead(@Param("userId") Integer userId, @Param("notificationId") Integer notificationId);
    
    @Insert("<script>" +
            "INSERT INTO user_notification (user_id, notification_id) VALUES " +
            "<foreach collection='userIds' item='userId' separator=','>" +
            "(#{userId}, #{notificationId})" +
            "</foreach>" +
            "</script>")
    int batchInsertUserNotification(@Param("notificationId") Integer notificationId, @Param("userIds") List<Integer> userIds);
    
    @Update("UPDATE notification SET status = #{status} WHERE id = #{id}")
    int updateStatus(@Param("id") Integer id, @Param("status") Integer status);
    
    @Delete("DELETE FROM notification WHERE id = #{id}")
    int deleteById(Integer id);
}
