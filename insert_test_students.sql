-- 插入测试学生数据
-- 先检查是否有班级数据，如果没有需要先插入班级
INSERT INTO class (class_name, grade, major, create_time, update_time) 
SELECT '计算机1班', '2021', '计算机科学与技术', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM class WHERE class_name = '计算机1班');

-- 获取班级ID
SET @class_id = (SELECT id FROM class WHERE class_name = '计算机1班' LIMIT 1);

-- 插入测试学生（6位学号）
INSERT INTO student (student_no, name, age, gender, phone, email, address, class_id, enrollment_date, student_status) 
SELECT '210001', '张三', 20, '男', '13800138001', 'zhangsan@example.com', '北京市', @class_id, '2021-09-01', '在读'
WHERE NOT EXISTS (SELECT 1 FROM student WHERE student_no = '210001');

INSERT INTO student (student_no, name, age, gender, phone, email, address, class_id, enrollment_date, student_status) 
SELECT '210002', '李四', 19, '女', '13800138002', 'lisi@example.com', '上海市', @class_id, '2021-09-01', '在读'
WHERE NOT EXISTS (SELECT 1 FROM student WHERE student_no = '210002');

INSERT INTO student (student_no, name, age, gender, phone, email, address, class_id, enrollment_date, student_status) 
SELECT '210003', '王五', 20, '男', '13800138003', 'wangwu@example.com', '广州市', @class_id, '2021-09-01', '在读'
WHERE NOT EXISTS (SELECT 1 FROM student WHERE student_no = '210003');

-- 查看插入的学生数据
SELECT * FROM student;
