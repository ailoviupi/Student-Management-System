-- 检查数据库中是否有考勤表
SHOW TABLES LIKE '%attendance%';

-- 查看考勤表结构
DESCRIBE attendance;

-- 查看是否有数据
SELECT COUNT(*) as total FROM attendance;

-- 查看所有考勤数据
SELECT * FROM attendance;

-- 查看学生210001的ID
SELECT id, student_no, name FROM student WHERE student_no = '210001';

-- 直接插入一条测试数据（如果学生存在）
INSERT INTO attendance (student_id, attendance_date, status, remark)
SELECT id, CURDATE(), '出勤', '测试数据'
FROM student WHERE student_no = '210001'
AND NOT EXISTS (SELECT 1 FROM attendance WHERE student_id = (SELECT id FROM student WHERE student_no = '210001') AND attendance_date = CURDATE());

-- 验证插入的数据
SELECT a.*, s.student_no, s.name 
FROM attendance a 
JOIN student s ON a.student_id = s.id 
WHERE s.student_no = '210001';
