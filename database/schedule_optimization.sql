-- 智能排课优化 - 数据库表结构

-- 教师偏好设置表
CREATE TABLE IF NOT EXISTS `teacher_preference` (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '偏好ID',
    teacher_id INT NOT NULL COMMENT '教师ID',
    preferred_days VARCHAR(20) COMMENT '偏好星期（1-7，多个用逗号分隔）',
    preferred_slots VARCHAR(50) COMMENT '偏好时间段（如：1-2,3-4,5-6）',
    avoided_days VARCHAR(20) COMMENT '不喜欢的星期',
    avoided_slots VARCHAR(50) COMMENT '不喜欢的时间段',
    max_daily_hours INT DEFAULT 4 COMMENT '每天最多课时',
    max_weekly_hours INT DEFAULT 16 COMMENT '每周最多课时',
    allow_consecutive TINYINT DEFAULT 1 COMMENT '是否允许连堂: 0-否, 1-是',
    remark VARCHAR(200) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (teacher_id) REFERENCES `user`(id) ON DELETE CASCADE,
    UNIQUE KEY uk_teacher (teacher_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='教师偏好设置表';

-- 班级课程关联表 - 定义班级需要上的课程
CREATE TABLE IF NOT EXISTS `class_course` (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '关联ID',
    class_id INT NOT NULL COMMENT '班级ID',
    course_id INT NOT NULL COMMENT '课程ID',
    weekly_hours INT DEFAULT 2 COMMENT '每周课时数',
    is_consecutive TINYINT DEFAULT 1 COMMENT '是否连堂: 0-否, 1-是',
    consecutive_count INT DEFAULT 2 COMMENT '连堂节数（默认2）',
    priority INT DEFAULT 5 COMMENT '优先级（1-10，数字越大优先级越高）',
    required_room_type VARCHAR(20) DEFAULT 'NORMAL' COMMENT '指定教室类型: NORMAL-普通教室, MEDIA-多媒体, LAB-实验室',
    min_capacity INT DEFAULT 0 COMMENT '最少需要教室容量',
    fixed_days VARCHAR(20) COMMENT '指定星期（如：1,3,5表示周一三五）',
    fixed_slots VARCHAR(50) COMMENT '指定时间段',
    remark VARCHAR(200) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (class_id) REFERENCES `class`(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES course(id) ON DELETE CASCADE,
    UNIQUE KEY uk_class_course (class_id, course_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='班级课程关联表';

-- 插入示例数据

-- 教师偏好设置示例
INSERT INTO `teacher_preference` (teacher_id, preferred_days, preferred_slots, avoided_days, avoided_slots, 
    max_daily_hours, max_weekly_hours, allow_consecutive, remark) VALUES
(2, '1,2,3', '1-2,3-4,5-6', '5', '9-10,11-12', 4, 16, 1, '张老师偏好周一到周三上午上课'),
(3, '2,3,4', '3-4,5-6,7-8', '1,5', '1-2', 4, 12, 1, '李老师偏好周二到周四，不喜欢周一和周五第一节');

-- 班级课程关联示例（为软件工程1班设置课程）
INSERT INTO `class_course` (class_id, course_id, weekly_hours, is_consecutive, consecutive_count, 
    priority, required_room_type, min_capacity, fixed_days, remark) VALUES
(3, 1, 4, 1, 2, 8, 'LAB', 40, NULL, 'Java程序设计 - 需要实验室'),
(3, 2, 4, 1, 2, 9, 'MEDIA', 50, NULL, '数据结构与算法 - 高优先级'),
(3, 4, 2, 1, 2, 7, 'LAB', 40, '1,3', 'Web前端开发 - 固定周一、周三');

-- 添加教室容量和类型索引
ALTER TABLE `classroom` ADD INDEX idx_capacity (capacity);
ALTER TABLE `classroom` ADD INDEX idx_room_type (room_type);

-- 添加课程安排索引优化
ALTER TABLE `course_schedule` ADD INDEX idx_teacher_time (teacher_id, day_of_week, start_slot);
ALTER TABLE `course_schedule` ADD INDEX idx_class_time (class_id, day_of_week, start_slot);
ALTER TABLE `course_schedule` ADD INDEX idx_classroom_time (classroom_id, day_of_week, start_slot);
