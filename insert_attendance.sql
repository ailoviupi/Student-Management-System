-- 插入测试考勤数据
-- 先获取学生ID
SET @student1_id = (SELECT id FROM student WHERE student_no = '210001' LIMIT 1);
SET @student2_id = (SELECT id FROM student WHERE student_no = '210002' LIMIT 1);
SET @student3_id = (SELECT id FROM student WHERE student_no = '210003' LIMIT 1);

-- 为210001学生插入考勤记录
INSERT INTO attendance (student_id, attendance_date, status, remark) 
SELECT @student1_id, '2025-04-01', '出勤', ''
WHERE @student1_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM attendance WHERE student_id = @student1_id AND attendance_date = '2025-04-01');

INSERT INTO attendance (student_id, attendance_date, status, remark) 
SELECT @student1_id, '2025-04-02', '出勤', ''
WHERE @student1_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM attendance WHERE student_id = @student1_id AND attendance_date = '2025-04-02');

INSERT INTO attendance (student_id, attendance_date, status, remark) 
SELECT @student1_id, '2025-04-03', '迟到', '早上堵车'
WHERE @student1_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM attendance WHERE student_id = @student1_id AND attendance_date = '2025-04-03');

INSERT INTO attendance (student_id, attendance_date, status, remark) 
SELECT @student1_id, '2025-04-07', '出勤', ''
WHERE @student1_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM attendance WHERE student_id = @student1_id AND attendance_date = '2025-04-07');

INSERT INTO attendance (student_id, attendance_date, status, remark) 
SELECT @student1_id, '2025-04-08', '请假', '病假'
WHERE @student1_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM attendance WHERE student_id = @student1_id AND attendance_date = '2025-04-08');

INSERT INTO attendance (student_id, attendance_date, status, remark) 
SELECT @student1_id, '2025-04-09', '出勤', ''
WHERE @student1_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM attendance WHERE student_id = @student1_id AND attendance_date = '2025-04-09');

INSERT INTO attendance (student_id, attendance_date, status, remark) 
SELECT @student1_id, '2025-04-10', '缺勤', ''
WHERE @student1_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM attendance WHERE student_id = @student1_id AND attendance_date = '2025-04-10');

INSERT INTO attendance (student_id, attendance_date, status, remark) 
SELECT @student1_id, '2025-04-11', '出勤', ''
WHERE @student1_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM attendance WHERE student_id = @student1_id AND attendance_date = '2025-04-11');

-- 查看插入的考勤数据
SELECT a.*, s.student_no, s.name 
FROM attendance a 
JOIN student s ON a.student_id = s.id 
WHERE s.student_no = '210001'
ORDER BY a.attendance_date DESC;
