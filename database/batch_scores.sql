USE student_db;

-- 批量成绩数据导入脚本
-- 为所有学生导入多门课程的期末成绩

-- 先清理现有成绩数据（可选）
-- DELETE FROM score;

-- 直接插入批量成绩数据
-- 假设：
-- 学生ID范围: 1-N (N为当前学生总数)
-- 课程ID: 1-4 (Java程序设计, 数据结构与算法, 数据库原理, Web前端开发)
-- 考试类型: 期末

INSERT INTO score (student_id, course_id, score, exam_date, exam_type, remark)
SELECT 
    s.id AS student_id,
    c.id AS course_id,
    -- 生成随机成绩，正态分布偏向 60-90 分
    ROUND(
        60 + (RAND() * 40) * (1 - ABS(RAND() - 0.5) * 0.6),  -- 使大部分成绩在60-90之间
        1
    ) AS score,
    '2024-07-01' AS exam_date,
    '期末' AS exam_type,
    CONCAT('2023-2024学年第二学期期末成绩') AS remark
FROM 
    student s
CROSS JOIN 
    course c
WHERE 
    -- 避免重复插入（如果已有该学生该课程的期末成绩则跳过）
    NOT EXISTS (
        SELECT 1 FROM score sc 
        WHERE sc.student_id = s.id 
        AND sc.course_id = c.id 
        AND sc.exam_type = '期末'
    )
ORDER BY 
    s.id, c.id;

-- 插入期中考试成绩
INSERT INTO score (student_id, course_id, score, exam_date, exam_type, remark)
SELECT 
    s.id AS student_id,
    c.id AS course_id,
    ROUND(
        55 + (RAND() * 40) * (1 - ABS(RAND() - 0.5) * 0.5),
        1
    ) AS score,
    '2024-05-01' AS exam_date,
    '期中' AS exam_type,
    CONCAT('2023-2024学年第二学期期中成绩') AS remark
FROM 
    student s
CROSS JOIN 
    course c
WHERE 
    NOT EXISTS (
        SELECT 1 FROM score sc 
        WHERE sc.student_id = s.id 
        AND sc.course_id = c.id 
        AND sc.exam_type = '期中'
    )
ORDER BY 
    s.id, c.id;

-- 插入平时成绩
INSERT INTO score (student_id, course_id, score, exam_date, exam_type, remark)
SELECT 
    s.id AS student_id,
    c.id AS course_id,
    ROUND(
        70 + (RAND() * 30) * (1 - ABS(RAND() - 0.5) * 0.4),
        1
    ) AS score,
    '2024-06-15' AS exam_date,
    '平时' AS exam_type,
    CONCAT('2023-2024学年第二学期平时成绩') AS remark
FROM 
    student s
CROSS JOIN 
    course c
WHERE 
    NOT EXISTS (
        SELECT 1 FROM score sc 
        WHERE sc.student_id = s.id 
        AND sc.course_id = c.id 
        AND sc.exam_type = '平时'
    )
ORDER BY 
    s.id, c.id;

-- 查询插入后的成绩统计信息
SELECT 
    c.course_name AS '课程名称',
    COUNT(sc.id) AS '成绩记录数',
    ROUND(AVG(sc.score), 2) AS '平均分',
    MIN(sc.score) AS '最低分',
    MAX(sc.score) AS '最高分',
    SUM(CASE WHEN sc.score < 60 THEN 1 ELSE 0 END) AS '不及格人数'
FROM 
    course c
LEFT JOIN 
    score sc ON c.id = sc.course_id AND sc.exam_type = '期末'
GROUP BY 
    c.id, c.course_name
ORDER BY 
    c.id;

-- 查询不及格学生名单
SELECT 
    s.student_no AS '学号',
    s.name AS '姓名',
    c.course_name AS '课程名称',
    sc.score AS '成绩'
FROM 
    score sc
JOIN 
    student s ON sc.student_id = s.id
JOIN 
    course c ON sc.course_id = c.id
WHERE 
    sc.score < 60 
    AND sc.exam_type = '期末'
ORDER BY 
    sc.score ASC;
