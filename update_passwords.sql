-- 更新用户密码为明文，后端会自动加密
-- 管理员密码: admin123
-- 教师密码: teacher123

UPDATE `user` SET `password` = 'admin123' WHERE username = 'admin';
UPDATE `user` SET `password` = 'teacher123' WHERE username = 'teacher1';
UPDATE `user` SET `password` = 'teacher123' WHERE username = 'teacher2';

-- 查看更新后的用户
SELECT username, real_name, role, status FROM `user`;
