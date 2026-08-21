-- =====================================================================
-- V1：学生管理系统基础表结构（全新安装的完整建表脚本）
-- 说明：已有数据库（手工脚本或 student_db.sql 导入）启动时会通过
--       baseline-on-migrate 跳过本脚本，仅全新空库执行。
-- =====================================================================

-- 用户表（管理员/教师）
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

-- 班级表
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

-- 学生表
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

-- 课程表
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

-- 成绩表
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

-- 预警规则表
CREATE TABLE IF NOT EXISTS `warning_rule` (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '规则ID',
    rule_name VARCHAR(100) NOT NULL COMMENT '规则名称',
    rule_type VARCHAR(20) NOT NULL COMMENT '规则类型: SCORE-成绩, ATTENDANCE-考勤, COMPREHENSIVE-综合',
    warning_level VARCHAR(20) NOT NULL COMMENT '预警等级: YELLOW-黄色, ORANGE-橙色, RED-红色',
    threshold_value DECIMAL(5,2) COMMENT '阈值',
    threshold_count INT COMMENT '阈值次数',
    description TEXT COMMENT '规则描述',
    status TINYINT DEFAULT 1 COMMENT '状态: 0-禁用, 1-启用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='预警规则表';

-- 学生预警记录表
CREATE TABLE IF NOT EXISTS `student_warning` (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '预警ID',
    student_id INT NOT NULL COMMENT '学生ID',
    rule_id INT COMMENT '规则ID',
    warning_type VARCHAR(20) NOT NULL COMMENT '预警类型: SCORE-成绩, ATTENDANCE-考勤, COMPREHENSIVE-综合',
    warning_level VARCHAR(20) NOT NULL COMMENT '预警等级: YELLOW-黄色, ORANGE-橙色, RED-红色',
    warning_reason TEXT COMMENT '预警原因',
    related_course_id INT COMMENT '相关课程ID',
    related_score DECIMAL(5,2) COMMENT '相关成绩',
    attendance_count INT COMMENT '缺勤次数',
    status VARCHAR(20) DEFAULT 'PENDING' COMMENT '状态: PENDING-待处理, PROCESSING-处理中, RESOLVED-已解决, IGNORED-已忽略',
    handler_id INT COMMENT '处理人ID',
    handle_remark TEXT COMMENT '处理备注',
    handle_time DATETIME COMMENT '处理时间',
    notify_status TINYINT DEFAULT 0 COMMENT '通知状态: 0-未通知, 1-已通知',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE,
    FOREIGN KEY (rule_id) REFERENCES warning_rule(id) ON DELETE SET NULL,
    FOREIGN KEY (related_course_id) REFERENCES course(id) ON DELETE SET NULL,
    FOREIGN KEY (handler_id) REFERENCES `user`(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生预警记录表';

-- 操作日志表
CREATE TABLE IF NOT EXISTS `operation_log` (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '日志ID',
    user_id INT COMMENT '操作用户ID',
    username VARCHAR(50) COMMENT '操作用户名',
    real_name VARCHAR(100) COMMENT '操作人姓名',
    operation_type VARCHAR(50) NOT NULL COMMENT '操作类型',
    operation_module VARCHAR(50) NOT NULL COMMENT '操作模块',
    operation_desc TEXT COMMENT '操作描述',
    request_method VARCHAR(10) COMMENT '请求方法',
    request_url VARCHAR(500) COMMENT '请求URL',
    request_params TEXT COMMENT '请求参数',
    response_data TEXT COMMENT '响应数据',
    ip_address VARCHAR(50) COMMENT 'IP地址',
    user_agent VARCHAR(500) COMMENT '浏览器UA',
    execution_time INT COMMENT '执行时长(毫秒)',
    status TINYINT DEFAULT 1 COMMENT '操作状态: 0-失败, 1-成功',
    error_msg TEXT COMMENT '错误信息',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_user_id (user_id),
    INDEX idx_operation_type (operation_type),
    INDEX idx_operation_module (operation_module),
    INDEX idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作日志表';

-- 消息通知表
CREATE TABLE IF NOT EXISTS `notification` (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '消息ID',
    title VARCHAR(200) NOT NULL COMMENT '消息标题',
    content TEXT COMMENT '消息内容',
    type VARCHAR(20) DEFAULT 'SYSTEM' COMMENT '消息类型',
    sender_id INT COMMENT '发送人ID',
    sender_name VARCHAR(100) COMMENT '发送人姓名',
    target_type VARCHAR(20) DEFAULT 'ALL' COMMENT '目标类型: ALL-全部, ROLE-角色, USER-指定用户, CLASS-指定班级',
    target_id INT COMMENT '目标ID',
    priority TINYINT DEFAULT 1 COMMENT '优先级',
    status TINYINT DEFAULT 1 COMMENT '状态: 0-草稿, 1-已发布, 2-已撤回',
    publish_time DATETIME COMMENT '发布时间',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='消息通知表';

-- 用户消息关联表
CREATE TABLE IF NOT EXISTS `user_notification` (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    user_id INT NOT NULL COMMENT '用户ID',
    notification_id INT NOT NULL COMMENT '消息ID',
    is_read TINYINT DEFAULT 0 COMMENT '是否已读: 0-未读, 1-已读',
    read_time DATETIME COMMENT '阅读时间',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_user_notification (user_id, notification_id),
    FOREIGN KEY (notification_id) REFERENCES notification(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户消息关联表';

-- 奖学金类型表
CREATE TABLE IF NOT EXISTS `scholarship_type` (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '奖学金类型ID',
    type_name VARCHAR(100) NOT NULL COMMENT '奖学金名称',
    type_code VARCHAR(20) NOT NULL UNIQUE COMMENT '奖学金代码',
    amount DECIMAL(10,2) NOT NULL COMMENT '奖学金额度',
    quota INT COMMENT '名额限制',
    description TEXT COMMENT '奖学金描述',
    requirements TEXT COMMENT '评选条件',
    academic_year VARCHAR(20) COMMENT '学年',
    semester VARCHAR(10) COMMENT '学期',
    status TINYINT DEFAULT 1 COMMENT '状态: 0-禁用, 1-启用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='奖学金类型表';

-- 奖学金评定记录表
CREATE TABLE IF NOT EXISTS `scholarship_record` (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID',
    student_id INT NOT NULL COMMENT '学生ID',
    scholarship_type_id INT NOT NULL COMMENT '奖学金类型ID',
    academic_year VARCHAR(20) NOT NULL COMMENT '学年',
    semester VARCHAR(10) NOT NULL COMMENT '学期',
    gpa DECIMAL(3,2) COMMENT '绩点',
    ranking INT COMMENT '班级排名',
    total_score DECIMAL(5,2) COMMENT '综合评分',
    score_details JSON COMMENT '评分详情',
    status VARCHAR(20) DEFAULT 'PENDING' COMMENT '状态: PENDING-待审核, APPROVED-已通过, REJECTED-已拒绝',
    reviewer_id INT COMMENT '审核人ID',
    review_remark TEXT COMMENT '审核备注',
    review_time DATETIME COMMENT '审核时间',
    scholarship_amount DECIMAL(10,2) COMMENT '评定金额',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE,
    FOREIGN KEY (scholarship_type_id) REFERENCES scholarship_type(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewer_id) REFERENCES `user`(id) ON DELETE SET NULL,
    UNIQUE KEY uk_student_scholarship (student_id, scholarship_type_id, academic_year, semester)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='奖学金评定记录表';

-- 教室表
CREATE TABLE IF NOT EXISTS `classroom` (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '教室ID',
    room_code VARCHAR(20) NOT NULL UNIQUE COMMENT '教室编号',
    room_name VARCHAR(50) NOT NULL COMMENT '教室名称',
    building VARCHAR(50) COMMENT '教学楼',
    floor INT COMMENT '楼层',
    capacity INT COMMENT '容纳人数',
    room_type VARCHAR(20) DEFAULT 'NORMAL' COMMENT '教室类型: NORMAL-普通教室, LAB-实验室, MEDIA-多媒体教室',
    status TINYINT DEFAULT 1 COMMENT '状态: 0-禁用, 1-可用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_capacity (capacity),
    INDEX idx_room_type (room_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='教室表';

-- 课程安排表
CREATE TABLE IF NOT EXISTS `course_schedule` (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '安排ID',
    course_id INT NOT NULL COMMENT '课程ID',
    class_id INT NOT NULL COMMENT '班级ID',
    teacher_id INT NOT NULL COMMENT '教师ID',
    classroom_id INT COMMENT '教室ID',
    academic_year VARCHAR(20) NOT NULL COMMENT '学年',
    semester VARCHAR(10) NOT NULL COMMENT '学期',
    day_of_week TINYINT NOT NULL COMMENT '星期几: 1-7',
    start_slot TINYINT NOT NULL COMMENT '开始节次: 1-12',
    end_slot TINYINT NOT NULL COMMENT '结束节次: 1-12',
    weeks VARCHAR(100) COMMENT '上课周次，如: 1-16',
    schedule_type VARCHAR(20) DEFAULT 'AUTO' COMMENT '排课类型: AUTO-自动, MANUAL-手动',
    status TINYINT DEFAULT 1 COMMENT '状态: 0-取消, 1-正常',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (course_id) REFERENCES course(id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES class(id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY (classroom_id) REFERENCES classroom(id) ON DELETE SET NULL,
    UNIQUE KEY uk_schedule (course_id, class_id, academic_year, semester, day_of_week, start_slot),
    INDEX idx_teacher_time (teacher_id, day_of_week, start_slot),
    INDEX idx_class_time (class_id, day_of_week, start_slot),
    INDEX idx_classroom_time (classroom_id, day_of_week, start_slot)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程安排表';

-- 考勤记录表
CREATE TABLE IF NOT EXISTS attendance (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '考勤ID',
    student_id INT NOT NULL COMMENT '学生ID',
    attendance_date DATE NOT NULL COMMENT '考勤日期',
    status VARCHAR(20) NOT NULL COMMENT '考勤状态: 出勤/缺勤/迟到/早退/请假',
    remark VARCHAR(200) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='考勤记录表';

-- 聊天消息表
CREATE TABLE IF NOT EXISTS `chat_message` (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '消息ID',
    sender_id INT NOT NULL COMMENT '发送者ID',
    sender_role VARCHAR(20) NOT NULL COMMENT '发送者角色: student/teacher',
    receiver_id INT NOT NULL COMMENT '接收者ID',
    receiver_role VARCHAR(20) NOT NULL COMMENT '接收者角色: student/teacher',
    content TEXT NOT NULL COMMENT '消息内容',
    send_time DATETIME NOT NULL COMMENT '发送时间',
    read_status TINYINT NOT NULL DEFAULT 0 COMMENT '阅读状态: 0-未读, 1-已读',
    INDEX idx_sender (sender_id, sender_role),
    INDEX idx_receiver (receiver_id, receiver_role),
    INDEX idx_send_time (send_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='聊天消息表';

-- 系统设置表
CREATE TABLE IF NOT EXISTS system_settings (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '设置ID',
    setting_key VARCHAR(50) NOT NULL UNIQUE COMMENT '设置键',
    setting_value VARCHAR(500) COMMENT '设置值',
    setting_desc VARCHAR(200) COMMENT '设置描述',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统设置表';

-- 教师偏好设置表
CREATE TABLE IF NOT EXISTS `teacher_preference` (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '偏好ID',
    teacher_id INT NOT NULL COMMENT '教师ID',
    preferred_days VARCHAR(20) COMMENT '偏好星期',
    preferred_slots VARCHAR(50) COMMENT '偏好时间段',
    avoided_days VARCHAR(20) COMMENT '不喜欢的星期',
    avoided_slots VARCHAR(50) COMMENT '不喜欢的时间段',
    max_daily_hours INT DEFAULT 4 COMMENT '每天最多课时',
    max_weekly_hours INT DEFAULT 16 COMMENT '每周最多课时',
    allow_consecutive TINYINT DEFAULT 1 COMMENT '是否允许连堂',
    remark VARCHAR(200) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (teacher_id) REFERENCES `user`(id) ON DELETE CASCADE,
    UNIQUE KEY uk_teacher (teacher_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='教师偏好设置表';

-- 班级课程关联表
CREATE TABLE IF NOT EXISTS `class_course` (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '关联ID',
    class_id INT NOT NULL COMMENT '班级ID',
    course_id INT NOT NULL COMMENT '课程ID',
    weekly_hours INT DEFAULT 2 COMMENT '每周课时数',
    is_consecutive TINYINT DEFAULT 1 COMMENT '是否连堂',
    consecutive_count INT DEFAULT 2 COMMENT '连堂节数',
    priority INT DEFAULT 5 COMMENT '优先级（1-10）',
    required_room_type VARCHAR(20) DEFAULT 'NORMAL' COMMENT '指定教室类型',
    min_capacity INT DEFAULT 0 COMMENT '最少需要教室容量',
    fixed_days VARCHAR(20) COMMENT '指定星期',
    fixed_slots VARCHAR(50) COMMENT '指定时间段',
    remark VARCHAR(200) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (class_id) REFERENCES `class`(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES course(id) ON DELETE CASCADE,
    UNIQUE KEY uk_class_course (class_id, course_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='班级课程关联表';

-- 作业表
CREATE TABLE IF NOT EXISTS `homework` (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '作业ID',
    title VARCHAR(200) NOT NULL COMMENT '作业标题',
    course_id INT NOT NULL COMMENT '课程ID',
    class_id INT DEFAULT NULL COMMENT '班级ID（为空表示所有班级）',
    description TEXT COMMENT '作业描述',
    total_score DECIMAL(5,2) DEFAULT 100.00 COMMENT '总分',
    deadline DATETIME COMMENT '截止时间',
    status TINYINT DEFAULT 1 COMMENT '状态：0-已结束 1-进行中',
    create_user INT COMMENT '创建人ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    KEY idx_course_id (course_id),
    KEY idx_class_id (class_id),
    KEY idx_deadline (deadline)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='作业表';

-- 作业提交表
CREATE TABLE IF NOT EXISTS `homework_submission` (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '提交ID',
    homework_id INT NOT NULL COMMENT '作业ID',
    student_id INT NOT NULL COMMENT '学生ID',
    content TEXT COMMENT '作业内容',
    file_url VARCHAR(500) COMMENT '附件URL',
    submit_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
    score DECIMAL(5,2) COMMENT '分数',
    feedback TEXT COMMENT '教师反馈',
    grade_time DATETIME COMMENT '批改时间',
    grade_user INT COMMENT '批改人ID',
    status TINYINT DEFAULT 0 COMMENT '状态：0-未批改 1-已批改',
    UNIQUE KEY uk_homework_student (homework_id, student_id),
    KEY idx_student_id (student_id),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='作业提交表';

-- 考试表
CREATE TABLE IF NOT EXISTS `exam` (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '考试ID',
    exam_name VARCHAR(200) NOT NULL COMMENT '考试名称',
    course_id INT NOT NULL COMMENT '课程ID',
    class_id INT DEFAULT NULL COMMENT '班级ID',
    exam_type VARCHAR(50) DEFAULT '期末考试' COMMENT '考试类型',
    exam_date DATE NOT NULL COMMENT '考试日期',
    start_time TIME COMMENT '开始时间',
    end_time TIME COMMENT '结束时间',
    classroom_id INT COMMENT '教室ID',
    total_score DECIMAL(5,2) DEFAULT 100.00 COMMENT '总分',
    status TINYINT DEFAULT 0 COMMENT '状态：0-未开始 1-进行中 2-已结束',
    remark TEXT COMMENT '备注',
    create_user INT COMMENT '创建人ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    KEY idx_course_id (course_id),
    KEY idx_class_id (class_id),
    KEY idx_exam_date (exam_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='考试表';

-- =====================================================================
-- 初始化数据（仅全新安装时写入）
-- 账号密码: admin/123456、teacher1/123456、teacher2/123456（明文，登录后建议修改）
-- =====================================================================

INSERT INTO `user` (username, `password`, real_name, `role`, `status`) VALUES
('admin', '123456', '管理员', 'admin', 1),
('teacher1', '123456', '张老师', 'teacher', 1),
('teacher2', '123456', '李老师', 'teacher', 1);

INSERT INTO `class` (class_name, grade, major, teacher_id) VALUES
('计算机1班', '2023级', '计算机科学与技术', 2),
('计算机2班', '2023级', '计算机科学与技术', 3),
('软件工程1班', '2023级', '软件工程', 2);

INSERT INTO student (student_no, `name`, age, gender, phone, email, class_id, enrollment_date, student_status) VALUES
('2023001', '张三', 20, '男', '13800138001', 'zhangsan@example.com', 1, '2023-09-01', '在读'),
('2023002', '李四', 19, '女', '13800138002', 'lisi@example.com', 1, '2023-09-01', '在读'),
('2023003', '王五', 21, '男', '13800138003', 'wangwu@example.com', 2, '2023-09-01', '在读'),
('2023004', '赵六', 20, '女', '13800138004', 'zhaoliu@example.com', 2, '2023-09-01', '在读'),
('2023005', '钱七', 19, '男', '13800138005', 'qianqi@example.com', 3, '2023-09-01', '在读');

INSERT INTO course (course_code, course_name, credit, hours, teacher_id, description) VALUES
('CS101', 'Java程序设计', 4.0, 64, 2, 'Java基础与面向对象编程'),
('CS102', '数据结构与算法', 3.5, 56, 2, '常用数据结构与算法分析'),
('CS103', '数据库原理', 3.0, 48, 3, '关系型数据库设计与SQL'),
('CS104', 'Web前端开发', 3.0, 48, 3, 'HTML、CSS、JavaScript基础');

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

INSERT INTO `warning_rule` (rule_name, rule_type, warning_level, threshold_value, threshold_count, description, status) VALUES
('成绩不及格预警', 'SCORE', 'YELLOW', 60.00, NULL, '单科成绩低于60分', 1),
('成绩严重不及格预警', 'SCORE', 'RED', 40.00, NULL, '单科成绩低于40分', 1),
('缺勤预警', 'ATTENDANCE', 'YELLOW', NULL, 3, '累计缺勤3次及以上', 1),
('严重缺勤预警', 'ATTENDANCE', 'RED', NULL, 5, '累计缺勤5次及以上', 1),
('多科不及格预警', 'COMPREHENSIVE', 'ORANGE', 60.00, 2, '2科及以上成绩不及格', 1);

INSERT INTO `scholarship_type` (type_name, type_code, amount, quota, description, requirements, academic_year, semester, status) VALUES
('国家奖学金', 'NATIONAL', 8000.00, 2, '国家级别奖学金，奖励品学兼优的学生', 'GPA>=3.5,排名<=10,无不及格', '2023-2024', '全年', 1),
('校级一等奖学金', 'SCHOOL_FIRST', 5000.00, 5, '校级最高奖学金', 'GPA>=3.2,排名<=20,无不及格', '2023-2024', '全年', 1),
('校级二等奖学金', 'SCHOOL_SECOND', 3000.00, 10, '校级二等奖学金', 'GPA>=3.0,排名<=30,无不及格', '2023-2024', '全年', 1),
('校级三等奖学金', 'SCHOOL_THIRD', 1500.00, 20, '校级三等奖学金', 'GPA>=2.8,排名<=50,无不及格', '2023-2024', '全年', 1),
('励志奖学金', 'INSPIRATION', 2000.00, 15, '鼓励进步学生', '成绩进步显著或特殊贡献', '2023-2024', '全年', 1);

INSERT INTO `classroom` (room_code, room_name, building, floor, capacity, room_type, status) VALUES
('A101', 'A101教室', 'A教学楼', 1, 60, 'NORMAL', 1),
('A102', 'A102教室', 'A教学楼', 1, 60, 'NORMAL', 1),
('A201', 'A201多媒体教室', 'A教学楼', 2, 80, 'MEDIA', 1),
('A202', 'A202多媒体教室', 'A教学楼', 2, 80, 'MEDIA', 1),
('B101', 'B101实验室', 'B教学楼', 1, 40, 'LAB', 1),
('B102', 'B102实验室', 'B教学楼', 1, 40, 'LAB', 1),
('C101', 'C101大教室', 'C教学楼', 1, 120, 'MEDIA', 1),
('C102', 'C102大教室', 'C教学楼', 1, 120, 'MEDIA', 1);

INSERT INTO system_settings (setting_key, setting_value, setting_desc) VALUES
('school_name', 'Demo School', 'School Name'),
('school_address', '123 Demo Street', 'School Address'),
('school_phone', '010-12345678', 'Contact Phone'),
('current_semester', '2024-2025 Semester 1', 'Current Semester'),
('pass_score', '60', 'Pass Score'),
('excellent_score', '90', 'Excellent Score'),
('attendance_warning_days', '3', 'Attendance Warning Days'),
('system_version', 'v1.0.0', 'System Version');

INSERT INTO `teacher_preference` (teacher_id, preferred_days, preferred_slots, avoided_days, avoided_slots,
    max_daily_hours, max_weekly_hours, allow_consecutive, remark) VALUES
(2, '1,2,3', '1-2,3-4,5-6', '5', '9-10,11-12', 4, 16, 1, '张老师偏好周一到周三上午上课'),
(3, '2,3,4', '3-4,5-6,7-8', '1,5', '1-2', 4, 12, 1, '李老师偏好周二到周四，不喜欢周一和周五第一节');

INSERT INTO `class_course` (class_id, course_id, weekly_hours, is_consecutive, consecutive_count,
    priority, required_room_type, min_capacity, fixed_days, remark) VALUES
(3, 1, 4, 1, 2, 8, 'LAB', 40, NULL, 'Java程序设计 - 需要实验室'),
(3, 2, 4, 1, 2, 9, 'MEDIA', 50, NULL, '数据结构与算法 - 高优先级'),
(3, 4, 2, 1, 2, 7, 'LAB', 40, '1,3', 'Web前端开发 - 固定周一、周三');

INSERT INTO `homework` (title, course_id, class_id, description, total_score, deadline, status, create_user) VALUES
('Java基础编程练习', 1, 1, '完成课本第3章习题1-5', 100.00, '2026-08-05 23:59:59', 1, 1),
('数据库设计作业', 2, 1, '设计一个学生选课系统的ER图', 100.00, '2026-08-10 23:59:59', 1, 1);

INSERT INTO `exam` (exam_name, course_id, class_id, exam_type, exam_date, start_time, end_time, classroom_id, total_score, status, create_user) VALUES
('Java期末考试', 1, 1, '期末考试', '2026-08-15', '09:00:00', '11:00:00', 1, 100.00, 0, 1),
('数据库原理期末考试', 2, 1, '期末考试', '2026-08-16', '14:00:00', '16:00:00', 1, 100.00, 0, 1);
