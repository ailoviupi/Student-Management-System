-- 作业管理系统数据表
-- 使用utf8mb4字符集避免中文乱码
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for homework (作业表)
-- ----------------------------
DROP TABLE IF EXISTS `homework`;
CREATE TABLE `homework` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '作业ID',
  `title` varchar(200) NOT NULL COMMENT '作业标题',
  `course_id` int(11) NOT NULL COMMENT '课程ID',
  `class_id` int(11) DEFAULT NULL COMMENT '班级ID（为空表示所有班级）',
  `description` text COMMENT '作业描述',
  `total_score` decimal(5,2) DEFAULT '100.00' COMMENT '总分',
  `deadline` datetime COMMENT '截止时间',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：0-已结束 1-进行中',
  `create_user` int(11) COMMENT '创建人ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_class_id` (`class_id`),
  KEY `idx_deadline` (`deadline`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='作业表';

-- ----------------------------
-- Table structure for homework_submission (作业提交表)
-- ----------------------------
DROP TABLE IF EXISTS `homework_submission`;
CREATE TABLE `homework_submission` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '提交ID',
  `homework_id` int(11) NOT NULL COMMENT '作业ID',
  `student_id` int(11) NOT NULL COMMENT '学生ID',
  `content` text COMMENT '作业内容',
  `file_url` varchar(500) COMMENT '附件URL',
  `submit_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
  `score` decimal(5,2) COMMENT '分数',
  `feedback` text COMMENT '教师反馈',
  `grade_time` datetime COMMENT '批改时间',
  `grade_user` int(11) COMMENT '批改人ID',
  `status` tinyint(1) DEFAULT '0' COMMENT '状态：0-未批改 1-已批改',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_homework_student` (`homework_id`, `student_id`),
  KEY `idx_student_id` (`student_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='作业提交表';

-- ----------------------------
-- Table structure for exam (考试表)
-- ----------------------------
DROP TABLE IF EXISTS `exam`;
CREATE TABLE `exam` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '考试ID',
  `exam_name` varchar(200) NOT NULL COMMENT '考试名称',
  `course_id` int(11) NOT NULL COMMENT '课程ID',
  `class_id` int(11) DEFAULT NULL COMMENT '班级ID',
  `exam_type` varchar(50) DEFAULT '期末考试' COMMENT '考试类型：期中考试、期末考试、测验等',
  `exam_date` date NOT NULL COMMENT '考试日期',
  `start_time` time COMMENT '开始时间',
  `end_time` time COMMENT '结束时间',
  `classroom_id` int(11) COMMENT '教室ID',
  `total_score` decimal(5,2) DEFAULT '100.00' COMMENT '总分',
  `status` tinyint(1) DEFAULT '0' COMMENT '状态：0-未开始 1-进行中 2-已结束',
  `remark` text COMMENT '备注',
  `create_user` int(11) COMMENT '创建人ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_class_id` (`class_id`),
  KEY `idx_exam_date` (`exam_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='考试表';

-- ----------------------------
-- 测试数据
-- ----------------------------
INSERT INTO `homework` (`title`, `course_id`, `class_id`, `description`, `total_score`, `deadline`, `status`, `create_user`) VALUES
('Java基础编程练习', 1, 1, '完成课本第3章习题1-5', 100.00, '2026-08-05 23:59:59', 1, 1),
('数据库设计作业', 2, 1, '设计一个学生选课系统的ER图', 100.00, '2026-08-10 23:59:59', 1, 1);

INSERT INTO `exam` (`exam_name`, `course_id`, `class_id`, `exam_type`, `exam_date`, `start_time`, `end_time`, `classroom_id`, `total_score`, `status`, `create_user`) VALUES
('Java期末考试', 1, 1, '期末考试', '2026-08-15', '09:00:00', '11:00:00', 1, 100.00, 0, 1),
('数据库原理期末考试', 2, 1, '期末考试', '2026-08-16', '14:00:00', '16:00:00', 1, 100.00, 0, 1);

SET FOREIGN_KEY_CHECKS = 1;