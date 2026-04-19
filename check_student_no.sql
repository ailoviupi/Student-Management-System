-- 查看学生表中的所有学号
SELECT id, student_no, name FROM student;

-- 查看考勤表中的学生ID
SELECT DISTINCT student_id FROM attendance;

-- 检查关联
SELECT a.*, s.student_no, s.name 
FROM attendance a 
LEFT JOIN student s ON a.student_id = s.id;
