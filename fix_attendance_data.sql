-- 修复考勤数据 - 为数据库中实际存在的学生插入考勤记录

-- 步骤1：查看所有学生
SELECT '学生列表' as info;
SELECT id, student_no, name FROM student;

-- 步骤2：删除旧的测试数据（如果有）
-- DELETE FROM attendance WHERE remark = '测试数据';

-- 步骤3：为每个学生插入考勤记录
-- 使用INSERT IGNORE避免重复插入

-- 先获取所有学生ID，然后为每个学生插入记录
INSERT INTO attendance (student_id, attendance_date, status, remark)
SELECT 
    s.id,
    '2025-04-01',
    '出勤',
    ''
FROM student s
WHERE NOT EXISTS (
    SELECT 1 FROM attendance a 
    WHERE a.student_id = s.id AND a.attendance_date = '2025-04-01'
);

INSERT INTO attendance (student_id, attendance_date, status, remark)
SELECT 
    s.id,
    '2025-04-02',
    '出勤',
    ''
FROM student s
WHERE NOT EXISTS (
    SELECT 1 FROM attendance a 
    WHERE a.student_id = s.id AND a.attendance_date = '2025-04-02'
);

INSERT INTO attendance (student_id, attendance_date, status, remark)
SELECT 
    s.id,
    '2025-04-03',
    '迟到',
    '早上堵车'
FROM student s
WHERE NOT EXISTS (
    SELECT 1 FROM attendance a 
    WHERE a.student_id = s.id AND a.attendance_date = '2025-04-03'
);

INSERT INTO attendance (student_id, attendance_date, status, remark)
SELECT 
    s.id,
    '2025-04-07',
    '出勤',
    ''
FROM student s
WHERE NOT EXISTS (
    SELECT 1 FROM attendance a 
    WHERE a.student_id = s.id AND a.attendance_date = '2025-04-07'
);

INSERT INTO attendance (student_id, attendance_date, status, remark)
SELECT 
    s.id,
    '2025-04-08',
    '请假',
    '病假'
FROM student s
WHERE NOT EXISTS (
    SELECT 1 FROM attendance a 
    WHERE a.student_id = s.id AND a.attendance_date = '2025-04-08'
);

INSERT INTO attendance (student_id, attendance_date, status, remark)
SELECT 
    s.id,
    '2025-04-09',
    '出勤',
    ''
FROM student s
WHERE NOT EXISTS (
    SELECT 1 FROM attendance a 
    WHERE a.student_id = s.id AND a.attendance_date = '2025-04-09'
);

INSERT INTO attendance (student_id, attendance_date, status, remark)
SELECT 
    s.id,
    '2025-04-10',
    '缺勤',
    ''
FROM student s
WHERE NOT EXISTS (
    SELECT 1 FROM attendance a 
    WHERE a.student_id = s.id AND a.attendance_date = '2025-04-10'
);

INSERT INTO attendance (student_id, attendance_date, status, remark)
SELECT 
    s.id,
    '2025-04-11',
    '出勤',
    ''
FROM student s
WHERE NOT EXISTS (
    SELECT 1 FROM attendance a 
    WHERE a.student_id = s.id AND a.attendance_date = '2025-04-11'
);

-- 步骤4：验证插入结果
SELECT '考勤统计' as info;
SELECT s.student_no, s.name, COUNT(a.id) as attendance_count,
       SUM(CASE WHEN a.status = '出勤' THEN 1 ELSE 0 END) as present,
       SUM(CASE WHEN a.status = '缺勤' THEN 1 ELSE 0 END) as absent,
       SUM(CASE WHEN a.status = '迟到' THEN 1 ELSE 0 END) as late,
       SUM(CASE WHEN a.status = '请假' THEN 1 ELSE 0 END) as leave_count
FROM student s
LEFT JOIN attendance a ON s.id = a.student_id
GROUP BY s.id, s.student_no, s.name;

-- 查看详细考勤数据
SELECT '详细考勤数据' as info;
SELECT a.*, s.student_no, s.name 
FROM attendance a 
JOIN student s ON a.student_id = s.id 
ORDER BY s.student_no, a.attendance_date DESC;
