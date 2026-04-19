-- 创建系统设置表
CREATE TABLE IF NOT EXISTS system_settings (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '设置ID',
    setting_key VARCHAR(50) NOT NULL UNIQUE COMMENT '设置键',
    setting_value VARCHAR(500) COMMENT '设置值',
    setting_desc VARCHAR(200) COMMENT '设置描述',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统设置表';

-- 插入默认设置
INSERT INTO system_settings (setting_key, setting_value, setting_desc) VALUES
('school_name', 'Demo School', 'School Name'),
('school_address', '123 Demo Street', 'School Address'),
('school_phone', '010-12345678', 'Contact Phone'),
('current_semester', '2024-2025 Semester 1', 'Current Semester'),
('pass_score', '60', 'Pass Score'),
('excellent_score', '90', 'Excellent Score'),
('attendance_warning_days', '3', 'Attendance Warning Days'),
('system_version', 'v1.0.0', 'System Version')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);
