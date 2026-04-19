package com.example.student.service;

import com.example.student.entity.SystemSetting;

import java.util.List;
import java.util.Map;

public interface SystemSettingService {
    List<SystemSetting> findAll();
    SystemSetting findByKey(String key);
    boolean updateByKey(String key, String value);
    Map<String, String> getAllAsMap();
}
