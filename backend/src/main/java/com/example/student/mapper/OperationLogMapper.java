package com.example.student.mapper;

import com.example.student.entity.OperationLog;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface OperationLogMapper {

    @Insert("INSERT INTO operation_log (user_id, username, real_name, operation_type, operation_module, " +
            "operation_desc, request_method, request_url, request_params, response_data, " +
            "ip_address, user_agent, execution_time, status, error_msg) " +
            "VALUES (#{userId}, #{username}, #{realName}, #{operationType}, #{operationModule}, " +
            "#{operationDesc}, #{requestMethod}, #{requestUrl}, #{requestParams}, #{responseData}, " +
            "#{ipAddress}, #{userAgent}, #{executionTime}, #{status}, #{errorMsg})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(OperationLog log);

    @Select("<script>"
            + "SELECT * FROM operation_log WHERE 1=1 "
            + "<if test='userId != null'> AND user_id = #{userId} </if>"
            + "<if test='operationType != null'> AND operation_type = #{operationType} </if>"
            + "<if test='operationModule != null'> AND operation_module = #{operationModule} </if>"
            + "<if test='status != null'> AND status = #{status} </if>"
            + "<if test='startTime != null'> AND create_time &gt;= #{startTime} </if>"
            + "<if test='endTime != null'> AND create_time &lt;= #{endTime} </if>"
            + "<if test='keyword != null'> AND (username LIKE CONCAT('%', #{keyword}, '%') "
            + "OR operation_desc LIKE CONCAT('%', #{keyword}, '%') OR request_url LIKE CONCAT('%', #{keyword}, '%')) </if>"
            + "ORDER BY create_time DESC"
            + "</script>")
    List<OperationLog> findByCondition(@Param("userId") Integer userId,
                                       @Param("operationType") String operationType,
                                       @Param("operationModule") String operationModule,
                                       @Param("status") Integer status,
                                       @Param("startTime") String startTime,
                                       @Param("endTime") String endTime,
                                       @Param("keyword") String keyword);

    @Select("SELECT * FROM operation_log WHERE id = #{id}")
    OperationLog findById(Integer id);

    int deleteOldLogs(@Param("days") int days);

    @Select("SELECT COUNT(*) FROM operation_log")
    int countTotal();

    @Select("SELECT COUNT(*) FROM operation_log WHERE status = 0")
    int countFailed();

    int countToday();
}
