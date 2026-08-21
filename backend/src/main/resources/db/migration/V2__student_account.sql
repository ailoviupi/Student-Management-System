-- =====================================================================
-- V2：学生账号表（学生独立密码体系）
-- 说明：老库（手工脚本/student_db.sql 导入）通过 baseline-on-migrate
--       跳过 V1 后执行本脚本；新库在 V1 基础上执行本脚本。
-- =====================================================================

CREATE TABLE IF NOT EXISTS `student_account` (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '账号ID',
    student_id INT NOT NULL UNIQUE COMMENT '学生ID',
    `password` VARCHAR(255) NOT NULL COMMENT 'BCrypt加密密码',
    `status` TINYINT DEFAULT 1 COMMENT '状态: 0-禁用, 1-正常',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生账号表';
