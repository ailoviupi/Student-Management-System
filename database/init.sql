-- 创建数据库
CREATE DATABASE IF NOT EXISTS student_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE student_db;

-- 创建用户表
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

-- 创建班级表
CREATE TABLE IF NOT EXISTS `class` (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '班级ID',
    class_name VARCHAR(50) NOT NULL COMMENT '班级名称',
    grade VARCHAR(20) COMMENT '年级',
    major VARCHAR(100) COMMENT '专业',
    teacher_id INT COMMENT '班主任ID',
    student_count INT DEFAULT 0 COMMENT '学生人数',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (teacher_id) REFERENCES `user`(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='班级表';

-- 创建学生表
CREATE TABLE IF NOT EXISTS student (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '学生ID',
    student_no VARCHAR(20) NOT NULL UNIQUE COMMENT '学号',
    `name` VARCHAR(50) NOT NULL COMMENT '姓名',
    age INT COMMENT '年龄',
    gender VARCHAR(10) COMMENT '性别',
    phone VARCHAR(20) COMMENT '电话',
    email VARCHAR(100) COMMENT '邮箱',
    `address` VARCHAR(200) COMMENT '地址',
    class_id INT COMMENT '班级ID',
    enrollment_date DATE COMMENT '入学日期',
    student_status VARCHAR(20) COMMENT '状态',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (class_id) REFERENCES `class`(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生表';

-- 创建课程表
CREATE TABLE IF NOT EXISTS course (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '课程ID',
    course_code VARCHAR(20) NOT NULL UNIQUE COMMENT '课程代码',
    course_name VARCHAR(100) NOT NULL COMMENT '课程名称',
    credit DECIMAL(3,1) DEFAULT 2.0 COMMENT '学分',
    hours INT DEFAULT 32 COMMENT '课时',
    teacher_id INT COMMENT '授课教师ID',
    description TEXT COMMENT '课程描述',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (teacher_id) REFERENCES `user`(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程表';

-- 创建成绩表
CREATE TABLE IF NOT EXISTS `score` (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '成绩ID',
    student_id INT NOT NULL COMMENT '学生ID',
    course_id INT NOT NULL COMMENT '课程ID',
    `score` DECIMAL(5,2) COMMENT '成绩',
    exam_date DATE COMMENT '考试日期',
    exam_type VARCHAR(20) COMMENT '考试类型',
    remark VARCHAR(200) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES course(id) ON DELETE CASCADE,
    UNIQUE KEY uk_student_course (student_id, course_id, exam_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='成绩表';

-- 插入初始管理员用户
-- 密码均为: admin123 (BCrypt加密后的密码)
INSERT INTO `user` (username, `password`, real_name, `role`, `status`) VALUES 
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '管理员', 'admin', 1),
('teacher1', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '张老师', 'teacher', 1),
('teacher2', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '李老师', 'teacher', 1);

-- 插入班级数据
INSERT INTO `class` (class_name, grade, major, teacher_id) VALUES 
('计算机1班', '2023级', '计算机科学与技术', 2),
('计算机2班', '2023级', '计算机科学与技术', 3),
('软件工程1班', '2023级', '软件工程', 2);

-- 插入学生数据
INSERT INTO student (student_no, `name`, age, gender, phone, email, class_id, enrollment_date, student_status) VALUES 
('2023001', '张三', 20, '男', '13800138001', 'zhangsan@example.com', 1, '2023-09-01', '在读'),
('2023002', '李四', 19, '女', '13800138002', 'lisi@example.com', 1, '2023-09-01', '在读'),
('2023003', '王五', 21, '男', '13800138003', 'wangwu@example.com', 2, '2023-09-01', '在读'),
('2023004', '赵六', 20, '女', '13800138004', 'zhaoliu@example.com', 2, '2023-09-01', '在读'),
('2023005', '钱七', 19, '男', '13800138005', 'qianqi@example.com', 3, '2023-09-01', '在读');

-- 插入课程数据
INSERT INTO course (course_code, course_name, credit, hours, teacher_id, description) VALUES 
('CS101', 'Java程序设计', 4.0, 64, 2, 'Java基础与面向对象编程'),
('CS102', '数据结构与算法', 3.5, 56, 2, '常用数据结构与算法分析'),
('CS103', '数据库原理', 3.0, 48, 3, '关系型数据库设计与SQL'),
('CS104', 'Web前端开发', 3.0, 48, 3, 'HTML、CSS、JavaScript基础');

-- 插入成绩数据
INSERT INTO `score` (student_id, course_id, `score`, exam_date, exam_type) VALUES 
(1, 1, 85.50, '2024-01-15', '期末'),
(1, 2, 78.00, '2024-01-16', '期末'),
(1, 3, 92.00, '2024-01-17', '期末'),
(2, 1, 88.00, '2024-01-15', '期末'),
(2, 2, 91.50, '2024-01-16', '期末'),
(3, 1, 76.00, '2024-01-15', '期末'),
(3, 3, 85.00, '2024-01-17', '期末'),
(4, 2, 82.50, '2024-01-16', '期末'),
(4, 4, 95.00, '2024-01-18', '期末'),
(5, 1, 90.00, '2024-01-15', '期末'),
(5, 4, 87.50, '2024-01-18', '期末');
