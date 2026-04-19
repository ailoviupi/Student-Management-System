package com.example.student.mapper;

import com.example.student.entity.SystemSetting;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface SystemSettingMapper {

    @Select("SELECT * FROM system_settings ORDER BY id")
    List<SystemSetting> findAll();

    @Select("SELECT * FROM system_settings WHERE setting_key = #{key}")
    SystemSetting findByKey(@Param("key") String key);

    @Update("UPDATE system_settings SET setting_value = #{value} WHERE setting_key = #{key}")
    int updateByKey(@Param("key") String key, @Param("value") String value);
}
