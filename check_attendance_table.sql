-- 查看考勤表结构
DESCRIBE attendance;

-- 查看考勤表数据
SELECT * FROM attendance LIMIT 10;

-- 查看学生表数据
SELECT id, student_no, name FROM student WHERE student_no = '210001';

-- 检查关联查询
SELECT a.*, st.student_no, st.name 
FROM attendance a 
JOIN student st ON a.student_id = st.id 
WHERE st.student_no = '210001';
