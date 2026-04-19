package com.example.student.service.impl;

import com.example.student.entity.SystemSetting;
import com.example.student.mapper.SystemSettingMapper;
import com.example.student.service.SystemSettingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SystemSettingServiceImpl implements SystemSettingService {

    @Autowired
    private SystemSettingMapper systemSettingMapper;

    @Override
    public List<SystemSetting> findAll() {
        return systemSettingMapper.findAll();
    }

    @Override
    public SystemSetting findByKey(String key) {
        return systemSettingMapper.findByKey(key);
    }

    @Override
    public boolean updateByKey(String key, String value) {
        return systemSettingMapper.updateByKey(key, value) > 0;
    }

    @Override
    public Map<String, String> getAllAsMap() {
        List<SystemSetting> settings = systemSettingMapper.findAll();
        Map<String, String> map = new HashMap<>();
        for (SystemSetting setting : settings) {
            map.put(setting.getSettingKey(), setting.getSettingValue());
        }
        return map;
    }
}
