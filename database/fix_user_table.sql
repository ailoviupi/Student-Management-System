-- 修复用户表数据脚本
-- 在服务器上执行此脚本来修复登录问题

USE student_db;

-- 1. 确保 user 表存在
CREATE TABLE IF NOT EXISTS `user` (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    `password` VARCHAR(255) NOT NULL COMMENT '密码',
    real_name VARCHAR(100) COMMENT '真实姓名',
    `role` VARCHAR(20) COMMENT '角色',
    `status` TINYINT DEFAULT 1 COMMENT '状态',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 2. 删除旧的用户数据（如果存在）
DELETE FROM `user` WHERE username IN ('admin', 'teacher1', 'teacher2');

-- 3. 插入正确的用户数据
-- 密码均为: 123456 (明文密码)
-- role 字段使用小写，与前端代码保持一致
INSERT INTO `user` (username, `password`, real_name, `role`, `status`) VALUES 
('admin', '123456', '管理员', 'admin', 1),
('teacher1', '123456', '张老师', 'teacher', 1),
('teacher2', '123456', '李老师', 'teacher', 1);

-- 4. 验证插入结果
SELECT id, username, real_name, role, status FROM `user`;

-- 完成
SELECT '用户表修复完成！' AS message;
