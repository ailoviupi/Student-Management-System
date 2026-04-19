-- 为数据库中所有学生插入考勤数据
-- 先查看有哪些学生
SELECT id, student_no, name FROM student;

-- 为每个学生插入一些考勤记录
-- 这里使用动态方式，为所有学生插入相同的考勤数据模板

INSERT INTO attendance (student_id, attendance_date, status, remark)
SELECT 
    s.id,
    DATE_SUB(CURDATE(), INTERVAL (FLOOR(RAND() * 30)) DAY) as attendance_date,
    ELT(FLOOR(1 + RAND() * 4), '出勤', '出勤', '出勤', '迟到') as status,
    '' as remark
FROM student s
WHERE NOT EXISTS (
    SELECT 1 FROM attendance a WHERE a.student_id = s.id
)
LIMIT 10;

-- 查看插入结果
SELECT s.student_no, s.name, COUNT(a.id) as attendance_count
FROM student s
LEFT JOIN attendance a ON s.id = a.student_id
GROUP BY s.id, s.student_no, s.name;
