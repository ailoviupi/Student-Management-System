package com.example.student.controller;

import com.example.student.common.Result;
import com.example.student.entity.SystemSetting;
import com.example.student.service.SystemSettingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/settings")
@CrossOrigin
public class SystemSettingController {

    @Autowired
    private SystemSettingService systemSettingService;

    @GetMapping
    public Result<List<SystemSetting>> list() {
        return Result.success(systemSettingService.findAll());
    }

    @GetMapping("/map")
    public Result<Map<String, String>> getAllAsMap() {
        return Result.success(systemSettingService.getAllAsMap());
    }

    @GetMapping("/{key}")
    public Result<SystemSetting> getByKey(@PathVariable String key) {
        SystemSetting setting = systemSettingService.findByKey(key);
        if (setting != null) {
            return Result.success(setting);
        }
        return Result.error("设置项不存在");
    }

    @PutMapping("/{key}")
    public Result<Void> update(@PathVariable String key, @RequestBody Map<String, String> params) {
        String value = params.get("value");
        if (value == null) {
            return Result.error("参数错误");
        }
        if (systemSettingService.updateByKey(key, value)) {
            return Result.success();
        }
        return Result.error("更新失败");
    }
}
