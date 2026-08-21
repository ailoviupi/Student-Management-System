/*
 Navicat Premium Dump SQL

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50744 (5.7.44-log)
 Source Host           : localhost:3306
 Source Schema         : student_db

 Target Server Type    : MySQL
 Target Server Version : 50744 (5.7.44-log)
 File Encoding         : 65001

 Date: 26/05/2026 15:52:09
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for attendance
-- ----------------------------
DROP TABLE IF EXISTS `attendance`;
CREATE TABLE `attendance`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '鑰冨嫟ID',
  `student_id` int(11) NOT NULL COMMENT '瀛︾敓ID',
  `attendance_date` date NOT NULL COMMENT '鑰冨嫟鏃ユ湡',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '鑰冨嫟鐘舵?: 鍑哄嫟/缂哄嫟/杩熷埌/鏃╅?/璇峰亣',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '澶囨敞',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `student_id`(`student_id`) USING BTREE,
  CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '鑰冨嫟璁板綍琛' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of attendance
-- ----------------------------
INSERT INTO `attendance` VALUES (21, 7, '2026-04-22', '缺勤', '', '2026-04-22 21:06:58', '2026-04-22 21:06:58');

-- ----------------------------
-- Table structure for class
-- ----------------------------
DROP TABLE IF EXISTS `class`;
CREATE TABLE `class`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '鐝?骇ID',
  `class_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '鐝?骇鍚嶇О',
  `grade` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '骞寸骇',
  `major` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '涓撲笟',
  `teacher_id` int(11) NULL DEFAULT NULL COMMENT '鐝?富浠籌D',
  `student_count` int(11) NULL DEFAULT 0 COMMENT '瀛︾敓浜烘暟',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `teacher_id`(`teacher_id`) USING BTREE,
  CONSTRAINT `class_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '鐝?骇琛' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of class
-- ----------------------------
INSERT INTO `class` VALUES (1, '计算机1班', '2023级', '计算机科学与技术', 2, 0, '2026-04-17 14:43:17');
INSERT INTO `class` VALUES (2, '计算机2班', '2023级', '计算机科学与技术', 3, 0, '2026-04-17 14:43:17');
INSERT INTO `class` VALUES (3, '软件工程1班', '2023级', '软件工程', 2, 0, '2026-04-17 14:43:17');
INSERT INTO `class` VALUES (4, '软件高级班', '2021级', '软件技术', NULL, 0, '2026-04-22 20:51:27');

-- ----------------------------
-- Table structure for class_course
-- ----------------------------
DROP TABLE IF EXISTS `class_course`;
CREATE TABLE `class_course`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '鍏宠仈ID',
  `class_id` int(11) NOT NULL COMMENT '鐝?骇ID',
  `course_id` int(11) NOT NULL COMMENT '璇剧▼ID',
  `weekly_hours` int(11) NULL DEFAULT 2 COMMENT '姣忓懆璇炬椂鏁',
  `is_consecutive` tinyint(4) NULL DEFAULT 1 COMMENT '鏄?惁杩炲爞: 0-鍚? 1-鏄',
  `consecutive_count` int(11) NULL DEFAULT 2 COMMENT '杩炲爞鑺傛暟锛堥粯璁?锛',
  `priority` int(11) NULL DEFAULT 5 COMMENT '浼樺厛绾э紙1-10锛屾暟瀛楄秺澶т紭鍏堢骇瓒婇珮锛',
  `required_room_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'NORMAL' COMMENT '鎸囧畾鏁欏?绫诲瀷: NORMAL-鏅??鏁欏?, MEDIA-澶氬獟浣? LAB-瀹為獙瀹',
  `min_capacity` int(11) NULL DEFAULT 0 COMMENT '鏈?皯闇??鏁欏?瀹归噺',
  `fixed_days` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '鎸囧畾鏄熸湡锛堝?锛?,3,5琛ㄧず鍛ㄤ竴涓変簲锛',
  `fixed_slots` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '鎸囧畾鏃堕棿娈',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '澶囨敞',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_class_course`(`class_id`, `course_id`) USING BTREE,
  INDEX `course_id`(`course_id`) USING BTREE,
  CONSTRAINT `class_course_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `class` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `class_course_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '鐝?骇璇剧▼鍏宠仈琛' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of class_course
-- ----------------------------
INSERT INTO `class_course` VALUES (12, 3, 1, 4, 1, 2, 8, 'LAB', 40, NULL, NULL, 'Java程序设计', '2026-05-13 22:14:51', '2026-05-13 22:14:51');
INSERT INTO `class_course` VALUES (13, 3, 2, 4, 1, 2, 9, 'MEDIA', 50, NULL, NULL, '数据结构与算法', '2026-05-13 22:14:51', '2026-05-13 22:14:51');
INSERT INTO `class_course` VALUES (14, 3, 3, 2, 1, 2, 7, 'NORMAL', 0, NULL, NULL, '数据库原理', '2026-05-13 22:14:51', '2026-05-13 22:14:51');
INSERT INTO `class_course` VALUES (15, 3, 4, 2, 1, 2, 6, 'NORMAL', 0, NULL, NULL, 'Web前端开发', '2026-05-13 22:14:51', '2026-05-13 22:14:51');
INSERT INTO `class_course` VALUES (16, 1, 1, 4, 1, 2, 8, 'LAB', 40, NULL, NULL, 'Java程序设计', '2026-05-13 22:14:51', '2026-05-13 22:14:51');
INSERT INTO `class_course` VALUES (17, 1, 2, 4, 1, 2, 9, 'MEDIA', 50, NULL, NULL, '数据结构与算法', '2026-05-13 22:14:51', '2026-05-13 22:14:51');

-- ----------------------------
-- Table structure for classroom
-- ----------------------------
DROP TABLE IF EXISTS `classroom`;
CREATE TABLE `classroom`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '教室ID',
  `room_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '教室编号',
  `room_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '教室名称',
  `building` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '教学楼',
  `floor` int(11) NULL DEFAULT NULL COMMENT '楼层',
  `capacity` int(11) NULL DEFAULT NULL COMMENT '容纳人数',
  `room_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'NORMAL' COMMENT '教室类型: NORMAL-普通教室, LAB-实验室, MEDIA-多媒体教室',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-可用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `room_code`(`room_code`) USING BTREE,
  INDEX `idx_capacity`(`capacity`) USING BTREE,
  INDEX `idx_room_type`(`room_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '教室表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of classroom
-- ----------------------------
INSERT INTO `classroom` VALUES (1, 'A101', 'A101教室', 'A教学楼', 1, 60, 'NORMAL', 1, '2026-04-22 23:29:41', '2026-04-22 23:29:41');
INSERT INTO `classroom` VALUES (2, 'A102', 'A102教室', 'A教学楼', 1, 60, 'NORMAL', 1, '2026-04-22 23:29:41', '2026-04-22 23:29:41');
INSERT INTO `classroom` VALUES (3, 'A201', 'A201多媒体教室', 'A教学楼', 2, 80, 'MEDIA', 1, '2026-04-22 23:29:41', '2026-04-22 23:29:41');
INSERT INTO `classroom` VALUES (4, 'A202', 'A202多媒体教室', 'A教学楼', 2, 80, 'MEDIA', 1, '2026-04-22 23:29:41', '2026-04-22 23:29:41');
INSERT INTO `classroom` VALUES (5, 'B101', 'B101实验室', 'B教学楼', 1, 40, 'LAB', 1, '2026-04-22 23:29:41', '2026-04-22 23:29:41');
INSERT INTO `classroom` VALUES (6, 'B102', 'B102实验室', 'B教学楼', 1, 40, 'LAB', 1, '2026-04-22 23:29:41', '2026-04-22 23:29:41');
INSERT INTO `classroom` VALUES (7, 'C101', 'C101大教室', 'C教学楼', 1, 120, 'MEDIA', 1, '2026-04-22 23:29:41', '2026-04-22 23:29:41');
INSERT INTO `classroom` VALUES (8, 'C102', 'C102大教室', 'C教学楼', 1, 120, 'MEDIA', 1, '2026-04-22 23:29:41', '2026-04-22 23:29:41');

-- ----------------------------
-- Table structure for course
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '璇剧▼ID',
  `course_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '璇剧▼浠ｇ爜',
  `course_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '璇剧▼鍚嶇О',
  `credit` decimal(3, 1) NULL DEFAULT 2.0 COMMENT '瀛﹀垎',
  `hours` int(11) NULL DEFAULT 32 COMMENT '璇炬椂',
  `teacher_id` int(11) NULL DEFAULT NULL COMMENT '鎺堣?鏁欏笀ID',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '璇剧▼鎻忚堪',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `course_code`(`course_code`) USING BTREE,
  INDEX `teacher_id`(`teacher_id`) USING BTREE,
  CONSTRAINT `course_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '璇剧▼琛' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course
-- ----------------------------
INSERT INTO `course` VALUES (1, 'CS101', 'Java程序设计', 4.0, 64, 2, 'Java基础与面向对象编程', '2026-04-17 14:43:17');
INSERT INTO `course` VALUES (2, 'CS102', '数据结构与算法', 3.5, 56, 2, '常用数据结构与算法分析', '2026-04-17 14:43:17');
INSERT INTO `course` VALUES (3, 'CS103', '数据库原理', 3.0, 48, 3, '关系型数据库设计与SQL', '2026-04-17 14:43:17');
INSERT INTO `course` VALUES (4, 'CS104', 'Web前端开发', 3.0, 48, 3, 'HTML、CSS、JavaScript基础', '2026-04-17 14:43:17');
INSERT INTO `course` VALUES (5, 'CS105', 'vue3', 5.0, 16, 3, 'good\n', '2026-04-17 19:54:33');

-- ----------------------------
-- Table structure for course_schedule
-- ----------------------------
DROP TABLE IF EXISTS `course_schedule`;
CREATE TABLE `course_schedule`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '安排ID',
  `course_id` int(11) NOT NULL COMMENT '课程ID',
  `class_id` int(11) NOT NULL COMMENT '班级ID',
  `teacher_id` int(11) NOT NULL COMMENT '教师ID',
  `classroom_id` int(11) NULL DEFAULT NULL COMMENT '教室ID',
  `academic_year` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '学年',
  `semester` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '学期',
  `day_of_week` tinyint(4) NOT NULL COMMENT '星期几: 1-7',
  `start_slot` tinyint(4) NOT NULL COMMENT '开始节次: 1-12',
  `end_slot` tinyint(4) NOT NULL COMMENT '结束节次: 1-12',
  `weeks` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '上课周次，如: 1-16',
  `schedule_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'AUTO' COMMENT '排课类型: AUTO-自动, MANUAL-手动',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 0-取消, 1-正常',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_schedule`(`course_id`, `class_id`, `academic_year`, `semester`, `day_of_week`, `start_slot`) USING BTREE,
  INDEX `idx_teacher_time`(`teacher_id`, `day_of_week`, `start_slot`) USING BTREE,
  INDEX `idx_class_time`(`class_id`, `day_of_week`, `start_slot`) USING BTREE,
  INDEX `idx_classroom_time`(`classroom_id`, `day_of_week`, `start_slot`) USING BTREE,
  CONSTRAINT `course_schedule_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `course_schedule_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `class` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `course_schedule_ibfk_3` FOREIGN KEY (`teacher_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `course_schedule_ibfk_4` FOREIGN KEY (`classroom_id`) REFERENCES `classroom` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 167 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '课程安排表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course_schedule
-- ----------------------------
INSERT INTO `course_schedule` VALUES (1, 1, 1, 2, 2, '2023-2024', 'FIRST', 1, 1, 2, '1-16', 'AUTO', 1, '2026-04-23 07:24:42', '2026-04-23 07:24:42');
INSERT INTO `course_schedule` VALUES (2, 2, 1, 3, 1, '2023-2024', 'FIRST', 1, 3, 4, '1-16', 'AUTO', 1, '2026-04-23 07:24:42', '2026-04-23 07:24:42');
INSERT INTO `course_schedule` VALUES (3, 3, 2, 2, 2, '2023-2024', 'FIRST', 2, 1, 2, '1-16', 'AUTO', 1, '2026-04-23 07:24:42', '2026-04-23 07:24:42');
INSERT INTO `course_schedule` VALUES (119, 2, 3, 2, 3, '2024-2025', '上学期', 1, 1, 2, '1-16', 'AUTO', 1, '2026-05-13 22:08:56', '2026-05-13 22:08:56');
INSERT INTO `course_schedule` VALUES (120, 2, 3, 2, 3, '2024-2025', '上学期', 1, 3, 4, '1-16', 'AUTO', 1, '2026-05-13 22:08:56', '2026-05-13 22:08:56');
INSERT INTO `course_schedule` VALUES (121, 1, 3, 2, 5, '2024-2025', '上学期', 2, 1, 2, '1-16', 'AUTO', 1, '2026-05-13 22:08:56', '2026-05-13 22:08:56');
INSERT INTO `course_schedule` VALUES (122, 1, 3, 2, 5, '2024-2025', '上学期', 2, 3, 4, '1-16', 'AUTO', 1, '2026-05-13 22:08:56', '2026-05-13 22:08:56');
INSERT INTO `course_schedule` VALUES (123, 3, 3, 3, 1, '2024-2025', '上学期', 3, 1, 2, '1-16', 'AUTO', 1, '2026-05-13 22:08:56', '2026-05-13 22:08:56');
INSERT INTO `course_schedule` VALUES (124, 4, 3, 3, 1, '2024-2025', '上学期', 4, 1, 2, '1-16', 'AUTO', 1, '2026-05-13 22:08:56', '2026-05-13 22:08:56');
INSERT INTO `course_schedule` VALUES (125, 1, 1, 2, 2, '2024-2025', '上学期', 3, 1, 2, '1-16', 'AUTO', 1, '2026-05-13 22:08:56', '2026-05-13 22:08:56');
INSERT INTO `course_schedule` VALUES (140, 2, 3, 2, 3, '2024-2025', '下学期', 1, 1, 2, '1-16', 'AUTO', 1, '2026-05-13 22:09:08', '2026-05-13 22:09:08');
INSERT INTO `course_schedule` VALUES (141, 2, 3, 2, 3, '2024-2025', '下学期', 1, 3, 4, '1-16', 'AUTO', 1, '2026-05-13 22:09:08', '2026-05-13 22:09:08');
INSERT INTO `course_schedule` VALUES (142, 1, 3, 2, 5, '2024-2025', '下学期', 2, 1, 2, '1-16', 'AUTO', 1, '2026-05-13 22:09:08', '2026-05-13 22:09:08');
INSERT INTO `course_schedule` VALUES (143, 1, 3, 2, 5, '2024-2025', '下学期', 2, 3, 4, '1-16', 'AUTO', 1, '2026-05-13 22:09:08', '2026-05-13 22:09:08');
INSERT INTO `course_schedule` VALUES (144, 3, 3, 3, 1, '2024-2025', '下学期', 3, 1, 2, '1-16', 'AUTO', 1, '2026-05-13 22:09:08', '2026-05-13 22:09:08');
INSERT INTO `course_schedule` VALUES (145, 4, 3, 3, 1, '2024-2025', '下学期', 4, 1, 2, '1-16', 'AUTO', 1, '2026-05-13 22:09:08', '2026-05-13 22:09:08');
INSERT INTO `course_schedule` VALUES (146, 1, 1, 2, 2, '2024-2025', '下学期', 3, 1, 2, '1-16', 'AUTO', 1, '2026-05-13 22:09:08', '2026-05-13 22:09:08');
INSERT INTO `course_schedule` VALUES (157, 2, 3, 2, 3, '2023-2024', '上学期', 1, 1, 2, '1-16', 'AUTO', 1, '2026-05-13 22:17:33', '2026-05-13 22:17:33');
INSERT INTO `course_schedule` VALUES (158, 2, 3, 2, 3, '2023-2024', '上学期', 1, 3, 4, '1-16', 'AUTO', 1, '2026-05-13 22:17:33', '2026-05-13 22:17:33');
INSERT INTO `course_schedule` VALUES (159, 2, 1, 2, 3, '2023-2024', '上学期', 2, 1, 2, '1-16', 'AUTO', 1, '2026-05-13 22:17:33', '2026-05-13 22:17:33');
INSERT INTO `course_schedule` VALUES (160, 2, 1, 2, 3, '2023-2024', '上学期', 2, 3, 4, '1-16', 'AUTO', 1, '2026-05-13 22:17:33', '2026-05-13 22:17:33');
INSERT INTO `course_schedule` VALUES (161, 1, 3, 2, 5, '2023-2024', '上学期', 3, 1, 2, '1-16', 'AUTO', 1, '2026-05-13 22:17:33', '2026-05-13 22:17:33');
INSERT INTO `course_schedule` VALUES (162, 1, 3, 2, 5, '2023-2024', '上学期', 3, 3, 4, '1-16', 'AUTO', 1, '2026-05-13 22:17:33', '2026-05-13 22:17:33');
INSERT INTO `course_schedule` VALUES (163, 1, 1, 2, 5, '2023-2024', '上学期', 4, 1, 2, '1-16', 'AUTO', 1, '2026-05-13 22:17:33', '2026-05-13 22:17:33');
INSERT INTO `course_schedule` VALUES (164, 1, 1, 2, 5, '2023-2024', '上学期', 4, 3, 4, '1-16', 'AUTO', 1, '2026-05-13 22:17:33', '2026-05-13 22:17:33');
INSERT INTO `course_schedule` VALUES (165, 3, 3, 3, 1, '2023-2024', '上学期', 2, 1, 2, '1-16', 'AUTO', 1, '2026-05-13 22:17:33', '2026-05-13 22:17:33');
INSERT INTO `course_schedule` VALUES (166, 4, 3, 3, 1, '2023-2024', '上学期', 4, 1, 2, '1-16', 'AUTO', 1, '2026-05-13 22:17:33', '2026-05-13 22:17:33');

-- ----------------------------
-- Table structure for notification
-- ----------------------------
DROP TABLE IF EXISTS `notification`;
CREATE TABLE `notification`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '消息标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '消息内容',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'SYSTEM' COMMENT '消息类型: SYSTEM-系统公告, SCORE-成绩通知, ATTENDANCE-考勤通知, WARNING-预警通知',
  `sender_id` int(11) NULL DEFAULT NULL COMMENT '发送人ID',
  `sender_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发送人姓名',
  `target_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'ALL' COMMENT '目标类型: ALL-全部, ROLE-角色, USER-指定用户, CLASS-指定班级',
  `target_id` int(11) NULL DEFAULT NULL COMMENT '目标ID',
  `priority` tinyint(4) NULL DEFAULT 1 COMMENT '优先级: 0-低, 1-普通, 2-高, 3-紧急',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 0-草稿, 1-已发布, 2-已撤回',
  `publish_time` datetime NULL DEFAULT NULL COMMENT '发布时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '消息通知表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notification
-- ----------------------------

-- ----------------------------
-- Table structure for operation_log
-- ----------------------------
DROP TABLE IF EXISTS `operation_log`;
CREATE TABLE `operation_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '操作用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作用户名',
  `real_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作人姓名',
  `operation_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作类型: INSERT-新增, UPDATE-修改, DELETE-删除, LOGIN-登录, LOGOUT-登出, EXPORT-导出, QUERY-查询',
  `operation_module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作模块: STUDENT-学生, COURSE-课程, SCORE-成绩, CLASS-班级, USER-用户, SYSTEM-系统',
  `operation_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '操作描述',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求方法: GET, POST, PUT, DELETE',
  `request_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求URL',
  `request_params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求参数',
  `response_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '响应数据',
  `ip_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `user_agent` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '浏览器UA',
  `execution_time` int(11) NULL DEFAULT NULL COMMENT '执行时长(毫秒)',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '操作状态: 0-失败, 1-成功',
  `error_msg` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '错误信息',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_operation_type`(`operation_type`) USING BTREE,
  INDEX `idx_operation_module`(`operation_module`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 140 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '操作日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of operation_log
-- ----------------------------
INSERT INTO `operation_log` VALUES (1, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/notification/unread-count', '', '{\"code\":200,\"data\":0,\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 20, 1, NULL, '2026-05-15 12:19:50');
INSERT INTO `operation_log` VALUES (2, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/notification/list', '', '{\"code\":200,\"data\":[{\"content\":\"全体sp\\n\",\"createTime\":1778679519000,\"id\":1,\"priority\":3,\"senderId\":1,\"senderName\":\"管理员\",\"status\":1,\"targetType\":\"ALL\",\"title\":\"codes\",\"type\":\"SYSTEM\",\"updateTime\":1778679519000}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 27, 1, NULL, '2026-05-15 12:19:50');
INSERT INTO `operation_log` VALUES (3, NULL, 'anonymous', 'anonymous', 'DELETE', 'SYSTEM', '删除系统数据', 'DELETE', '/api/notification/1', '1', '{\"code\":200,\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 4, 1, NULL, '2026-05-15 12:19:51');
INSERT INTO `operation_log` VALUES (4, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/notification/list', '', '{\"code\":200,\"data\":[],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 1, 1, NULL, '2026-05-15 12:19:51');
INSERT INTO `operation_log` VALUES (5, NULL, 'anonymous', 'anonymous', 'INSERT', 'AUTH', '登录系统数据', 'POST', '/api/auth/login', '{\"password\":\"admin123\",\"username\":\"admin\"}', '{\"code\":200,\"data\":{\"realName\":\"管理员\",\"role\":\"admin\",\"id\":1,\"token\":\"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsInJvbGUiOiJhZG1pbiIsImlhdCI6MTc3ODgyNTk4MywiZXhwIjoxNzc4OTEyMzgzfQ._pXr52WC47jdcxwZnO6Wkx0pi-PG7iFkvyQydqHC_U30aTrE7kusnpbd0yrAYj51JS4wIX3jLqgrfl2BnUqyiQ\",\"username\":\"admin\"},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 248, 1, NULL, '2026-05-15 14:19:43');
INSERT INTO `operation_log` VALUES (6, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/statistics', '', '{\"code\":200,\"data\":{\"classDistribution\":{\"软件高级班\":50,\"计算机1班\":51,\"计算机2班\":50,\"软件工程1班\":50},\"genderDistribution\":{\"女\":97,\"男\":104},\"statusDistribution\":{\"在读\":200,\"毕业\":1},\"totalClasses\":4,\"totalCourses\":5,\"totalStudents\":201,\"totalUsers\":3},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 35, 1, NULL, '2026-05-15 14:19:44');
INSERT INTO `operation_log` VALUES (7, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores/statistics', '', '{\"code\":200,\"data\":{\"passRate\":100.00,\"courseAverageScores\":[{\"courseName\":\"Java程序设计\",\"averageScore\":60.000000}]},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 11, 1, NULL, '2026-05-15 14:19:44');
INSERT INTO `operation_log` VALUES (8, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/statistics', '', '{\"code\":200,\"data\":{\"classDistribution\":{\"软件高级班\":50,\"计算机1班\":51,\"计算机2班\":50,\"软件工程1班\":50},\"genderDistribution\":{\"女\":97,\"男\":104},\"statusDistribution\":{\"在读\":200,\"毕业\":1},\"totalClasses\":4,\"totalCourses\":5,\"totalStudents\":201,\"totalUsers\":3},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 20, 1, NULL, '2026-05-15 14:19:52');
INSERT INTO `operation_log` VALUES (9, NULL, 'anonymous', 'anonymous', 'QUERY', 'CLASS', '查询班级信息', 'GET', '/api/classes', '', '{\"code\":200,\"data\":[{\"className\":\"计算机1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":1,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"软件工程1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":3,\"major\":\"软件工程\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"计算机2班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":2,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"className\":\"软件高级班\",\"createTime\":1776862287000,\"grade\":\"2021级\",\"id\":4,\"major\":\"软件技术\",\"studentCount\":0,\"teacherId\":4,\"teacherName\":\"何坤坤\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 13, 1, NULL, '2026-05-15 14:19:53');
INSERT INTO `operation_log` VALUES (10, NULL, 'anonymous', 'anonymous', 'QUERY', 'STUDENT', '查询学生信息', 'GET', '/api/students', '{\"gender\":\"\",\"name\":\"\",\"pageNum\":1,\"pageSize\":10,\"studentNo\":\"\",\"studentStatus\":\"\"}', '{\"code\":200,\"data\":{\"list\":[{\"age\":20,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778682512000,\"email\":\"test@example.com\",\"enrollmentDate\":1725120000000,\"gender\":\"男\",\"id\":206,\"name\":\"测试学生\",\"phone\":\"13800138000\",\"studentNo\":\"TEST001\",\"studentStatus\":\"在读\",\"updateTime\":1778682512000},{\"address\":\"北京市朝阳区13号\",\"age\":22,\"classId\":2,\"className\":\"计算机2班\",\"createTime\":1776901643000,\"email\":\"student2024002014@example.com\",\"enrollmentDate\":1725465600000,\"gender\":\"女\",\"id\":69,\"name\":\"吕娜娜\",\"phone\":\"16805781152\",\"studentNo\":\"2024002014\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区25号\",\"age\":20,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001029@example.com\",\"enrollmentDate\":1691596800000,\"gender\":\"男\",\"id\":36,\"name\":\"鲍洋\",\"phone\":\"17492988777\",\"studentNo\":\"2024001029\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市朝阳区47号\",\"age\":22,\"classId\":2,\"className\":\"计算机2班\",\"createTime\":1776901643000,\"email\":\"student2024002016@example.com\",\"enrollmentDate\":1705939200000,\"gender\":\"男\",\"id\":71,\"name\":\"常皓\",\"phone\":\"19538424034\",\"studentNo\":\"2024002016\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区59号\",\"age\":18,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001031@example.com\",\"enrollmentDate\":1719590400000,\"gender\":\"男\",\"id\":38,\"name\":\"邹明\",\"phone\":\"16531999121\",\"studentNo\":\"2024001031\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区3号\",\"age\":23,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001033@example.com\",\"enrollmentDate\":1732636800000,\"gender\":\"男\",\"id\":40,\"name\":\"傅勇\",\"phone\":\"16617264985\",\"studentNo\":\"2024001033\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区24号\",\"age\":18,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001035@example.com\",\"enrollmentDate\":1728144000000,\"gender\":\"男\",\"id\":42,\"name\":\"史昊\",\"phone\":\"19514505693\",\"studentNo\":\"2024001035\",\"studentStatus\":\"在读...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 56, 1, NULL, '2026-05-15 14:19:53');
INSERT INTO `operation_log` VALUES (11, NULL, 'anonymous', 'anonymous', 'QUERY', 'CLASS', '查询班级信息', 'GET', '/api/classes', '', '{\"code\":200,\"data\":[{\"className\":\"计算机1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":1,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"软件工程1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":3,\"major\":\"软件工程\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"计算机2班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":2,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"className\":\"软件高级班\",\"createTime\":1776862287000,\"grade\":\"2021级\",\"id\":4,\"major\":\"软件技术\",\"studentCount\":0,\"teacherId\":4,\"teacherName\":\"何坤坤\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 6, 1, NULL, '2026-05-15 14:19:54');
INSERT INTO `operation_log` VALUES (12, NULL, 'anonymous', 'anonymous', 'QUERY', 'COURSE', '查询课程信息', 'GET', '/api/courses', '', '{\"code\":200,\"data\":[{\"courseCode\":\"CS101\",\"courseName\":\"Java程序设计\",\"createTime\":1776408197000,\"credit\":4.0,\"description\":\"Java基础与面向对象编程\",\"hours\":64,\"id\":1,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS102\",\"courseName\":\"数据结构与算法\",\"createTime\":1776408197000,\"credit\":3.5,\"description\":\"常用数据结构与算法分析\",\"hours\":56,\"id\":2,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS103\",\"courseName\":\"数据库原理\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"关系型数据库设计与SQL\",\"hours\":48,\"id\":3,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS104\",\"courseName\":\"Web前端开发\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"HTML、CSS、JavaScript基础\",\"hours\":48,\"id\":4,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS105\",\"courseName\":\"vue3\",\"createTime\":1776426873000,\"credit\":5.0,\"description\":\"good\\n\",\"hours\":16,\"id\":5,\"teacherId\":3,\"teacherName\":\"李老师\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 7, 1, NULL, '2026-05-15 14:19:54');
INSERT INTO `operation_log` VALUES (13, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/settings/map', '', '{\"code\":200,\"data\":{\"attendance_warning_days\":\"3\",\"school_address\":\"123 Demo Street\",\"pass_score\":\"60\",\"system_version\":\"v1.0.0\",\"school_phone\":\"010-12345678\",\"current_semester\":\"2024-2025 Semester 1\",\"school_name\":\"vue3 spring-boot\",\"excellent_score\":\"95\"},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 25, 1, NULL, '2026-05-15 14:19:59');
INSERT INTO `operation_log` VALUES (14, NULL, 'anonymous', 'anonymous', 'QUERY', 'AUTH', '查询系统数据', 'GET', '/api/auth/info', '\"admin\", \"admin\"', '{\"code\":200,\"data\":{\"realName\":\"管理员\",\"role\":\"admin\",\"id\":1,\"username\":\"admin\"},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 3, 1, NULL, '2026-05-15 14:19:59');
INSERT INTO `operation_log` VALUES (15, NULL, 'anonymous', 'anonymous', 'QUERY', 'AUTH', '查询系统数据', 'GET', '/api/auth/info', '\"admin\", \"admin\"', '{\"code\":200,\"data\":{\"realName\":\"管理员\",\"role\":\"admin\",\"id\":1,\"username\":\"admin\"},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 1, 1, NULL, '2026-05-15 14:20:02');
INSERT INTO `operation_log` VALUES (16, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/statistics', '', '{\"code\":200,\"data\":{\"classDistribution\":{\"软件高级班\":50,\"计算机1班\":51,\"计算机2班\":50,\"软件工程1班\":50},\"genderDistribution\":{\"女\":97,\"男\":104},\"statusDistribution\":{\"在读\":200,\"毕业\":1},\"totalClasses\":4,\"totalCourses\":5,\"totalStudents\":201,\"totalUsers\":3},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 18, 1, NULL, '2026-05-15 14:20:03');
INSERT INTO `operation_log` VALUES (17, NULL, 'anonymous', 'anonymous', 'QUERY', 'CLASS', '查询班级信息', 'GET', '/api/classes', '', '{\"code\":200,\"data\":[{\"className\":\"计算机1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":1,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"软件工程1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":3,\"major\":\"软件工程\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"计算机2班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":2,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"className\":\"软件高级班\",\"createTime\":1776862287000,\"grade\":\"2021级\",\"id\":4,\"major\":\"软件技术\",\"studentCount\":0,\"teacherId\":4,\"teacherName\":\"何坤坤\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 3, 1, NULL, '2026-05-15 14:20:05');
INSERT INTO `operation_log` VALUES (18, NULL, 'anonymous', 'anonymous', 'QUERY', 'STUDENT', '查询学生信息', 'GET', '/api/students', '{\"gender\":\"\",\"name\":\"\",\"pageNum\":1,\"pageSize\":10,\"studentNo\":\"\",\"studentStatus\":\"\"}', '{\"code\":200,\"data\":{\"list\":[{\"age\":20,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778682512000,\"email\":\"test@example.com\",\"enrollmentDate\":1725120000000,\"gender\":\"男\",\"id\":206,\"name\":\"测试学生\",\"phone\":\"13800138000\",\"studentNo\":\"TEST001\",\"studentStatus\":\"在读\",\"updateTime\":1778682512000},{\"address\":\"北京市海淀区76号\",\"age\":21,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001048@example.com\",\"enrollmentDate\":1717516800000,\"gender\":\"男\",\"id\":55,\"name\":\"贺明轩\",\"phone\":\"19633297953\",\"studentNo\":\"2024001048\",\"studentStatus\":\"毕业\",\"updateTime\":1777087074000},{\"address\":\"北京市海淀区18号\",\"age\":19,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001014@example.com\",\"enrollmentDate\":1729267200000,\"gender\":\"女\",\"id\":21,\"name\":\"伍蕾\",\"phone\":\"16598080722\",\"studentNo\":\"2024001014\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市朝阳区88号\",\"age\":20,\"classId\":2,\"className\":\"计算机2班\",\"createTime\":1776901643000,\"email\":\"student2024002001@example.com\",\"enrollmentDate\":1725120000000,\"gender\":\"男\",\"id\":56,\"name\":\"伍浩\",\"phone\":\"17617748506\",\"studentNo\":\"2024002001\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区89号\",\"age\":19,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001016@example.com\",\"enrollmentDate\":1704038400000,\"gender\":\"男\",\"id\":23,\"name\":\"岑辉\",\"phone\":\"17789914181\",\"studentNo\":\"2024001016\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市朝阳区17号\",\"age\":20,\"classId\":2,\"className\":\"计算机2班\",\"createTime\":1776901643000,\"email\":\"student2024002003@example.com\",\"enrollmentDate\":1741104000000,\"gender\":\"男\",\"id\":58,\"name\":\"郝明\",\"phone\":\"17188324246\",\"studentNo\":\"2024002003\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区82号\",\"age\":20,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001018@example.com\",\"enrollmentDate\":1716220800000,\"gender\":\"男\",\"id\":25,\"name\":\"曹辰\",\"phone\":\"15343294146\",\"studentNo\":\"2024001018\",\"studentStatus\":\"在...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 13, 1, NULL, '2026-05-15 14:20:05');
INSERT INTO `operation_log` VALUES (19, NULL, 'anonymous', 'anonymous', 'QUERY', 'CLASS', '查询班级信息', 'GET', '/api/classes', '', '{\"code\":200,\"data\":[{\"className\":\"计算机1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":1,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"软件工程1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":3,\"major\":\"软件工程\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"计算机2班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":2,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"className\":\"软件高级班\",\"createTime\":1776862287000,\"grade\":\"2021级\",\"id\":4,\"major\":\"软件技术\",\"studentCount\":0,\"teacherId\":4,\"teacherName\":\"何坤坤\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 3, 1, NULL, '2026-05-15 14:20:06');
INSERT INTO `operation_log` VALUES (20, NULL, 'anonymous', 'anonymous', 'QUERY', 'COURSE', '查询课程信息', 'GET', '/api/courses', '', '{\"code\":200,\"data\":[{\"courseCode\":\"CS101\",\"courseName\":\"Java程序设计\",\"createTime\":1776408197000,\"credit\":4.0,\"description\":\"Java基础与面向对象编程\",\"hours\":64,\"id\":1,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS102\",\"courseName\":\"数据结构与算法\",\"createTime\":1776408197000,\"credit\":3.5,\"description\":\"常用数据结构与算法分析\",\"hours\":56,\"id\":2,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS103\",\"courseName\":\"数据库原理\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"关系型数据库设计与SQL\",\"hours\":48,\"id\":3,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS104\",\"courseName\":\"Web前端开发\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"HTML、CSS、JavaScript基础\",\"hours\":48,\"id\":4,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS105\",\"courseName\":\"vue3\",\"createTime\":1776426873000,\"credit\":5.0,\"description\":\"good\\n\",\"hours\":16,\"id\":5,\"teacherId\":3,\"teacherName\":\"李老师\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 5, 1, NULL, '2026-05-15 14:20:07');
INSERT INTO `operation_log` VALUES (21, NULL, 'anonymous', 'anonymous', 'QUERY', 'COURSE', '查询课程信息', 'GET', '/api/courses', '', '{\"code\":200,\"data\":[{\"courseCode\":\"CS101\",\"courseName\":\"Java程序设计\",\"createTime\":1776408197000,\"credit\":4.0,\"description\":\"Java基础与面向对象编程\",\"hours\":64,\"id\":1,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS102\",\"courseName\":\"数据结构与算法\",\"createTime\":1776408197000,\"credit\":3.5,\"description\":\"常用数据结构与算法分析\",\"hours\":56,\"id\":2,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS103\",\"courseName\":\"数据库原理\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"关系型数据库设计与SQL\",\"hours\":48,\"id\":3,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS104\",\"courseName\":\"Web前端开发\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"HTML、CSS、JavaScript基础\",\"hours\":48,\"id\":4,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS105\",\"courseName\":\"vue3\",\"createTime\":1776426873000,\"credit\":5.0,\"description\":\"good\\n\",\"hours\":16,\"id\":5,\"teacherId\":3,\"teacherName\":\"李老师\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 4, 1, NULL, '2026-05-15 14:20:08');
INSERT INTO `operation_log` VALUES (22, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores', '{\"examType\":\"\",\"pageNum\":1,\"pageSize\":10,\"studentName\":\"\"}', '{\"code\":200,\"data\":{\"list\":[{\"courseId\":1,\"courseName\":\"Java程序设计\",\"createTime\":1776863116000,\"examDate\":1776700800000,\"examType\":\"期中\",\"id\":14,\"remark\":\"\",\"score\":60.00,\"studentId\":6,\"studentName\":\"小红\",\"studentNo\":\"20212022\",\"updateTime\":1776863116000}],\"pageNum\":1,\"pageSize\":10,\"pages\":1,\"total\":1},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 16, 1, NULL, '2026-05-15 14:20:08');
INSERT INTO `operation_log` VALUES (23, NULL, 'anonymous', 'anonymous', 'QUERY', 'STUDENT', '查询学生信息', 'GET', '/api/students', '{\"pageNum\":1,\"pageSize\":1000}', '{\"code\":200,\"data\":{\"list\":[{\"age\":20,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778682512000,\"email\":\"test@example.com\",\"enrollmentDate\":1725120000000,\"gender\":\"男\",\"id\":206,\"name\":\"测试学生\",\"phone\":\"13800138000\",\"studentNo\":\"TEST001\",\"studentStatus\":\"在读\",\"updateTime\":1778682512000},{\"address\":\"北京市海淀区16号\",\"age\":23,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001036@example.com\",\"enrollmentDate\":1716480000000,\"gender\":\"女\",\"id\":43,\"name\":\"马芳芳\",\"phone\":\"13551217120\",\"studentNo\":\"2024001036\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区44号\",\"age\":19,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001002@example.com\",\"enrollmentDate\":1727971200000,\"gender\":\"女\",\"id\":9,\"name\":\"吕莉\",\"phone\":\"18767954089\",\"studentNo\":\"2024001002\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区18号\",\"age\":18,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001038@example.com\",\"enrollmentDate\":1692892800000,\"gender\":\"女\",\"id\":45,\"name\":\"安莹\",\"phone\":\"18108257666\",\"studentNo\":\"2024001038\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区84号\",\"age\":23,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001004@example.com\",\"enrollmentDate\":1683648000000,\"gender\":\"男\",\"id\":11,\"name\":\"鲁昊\",\"phone\":\"17428236754\",\"studentNo\":\"2024001004\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区17号\",\"age\":21,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001040@example.com\",\"enrollmentDate\":1709827200000,\"gender\":\"女\",\"id\":47,\"name\":\"酆莉\",\"phone\":\"18573217259\",\"studentNo\":\"2024001040\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区79号\",\"age\":22,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001006@example.com\",\"enrollmentDate\":1698422400000,\"gender\":\"男\",\"id\":13,\"name\":\"穆军\",\"phone\":\"18462688534\",\"studentNo\":\"2024001006\",\"studentStatus\":\"在读...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 54, 1, NULL, '2026-05-15 14:20:08');
INSERT INTO `operation_log` VALUES (24, NULL, 'anonymous', 'anonymous', 'QUERY', 'COURSE', '查询课程信息', 'GET', '/api/courses', '', '{\"code\":200,\"data\":[{\"courseCode\":\"CS101\",\"courseName\":\"Java程序设计\",\"createTime\":1776408197000,\"credit\":4.0,\"description\":\"Java基础与面向对象编程\",\"hours\":64,\"id\":1,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS102\",\"courseName\":\"数据结构与算法\",\"createTime\":1776408197000,\"credit\":3.5,\"description\":\"常用数据结构与算法分析\",\"hours\":56,\"id\":2,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS103\",\"courseName\":\"数据库原理\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"关系型数据库设计与SQL\",\"hours\":48,\"id\":3,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS104\",\"courseName\":\"Web前端开发\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"HTML、CSS、JavaScript基础\",\"hours\":48,\"id\":4,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS105\",\"courseName\":\"vue3\",\"createTime\":1776426873000,\"credit\":5.0,\"description\":\"good\\n\",\"hours\":16,\"id\":5,\"teacherId\":3,\"teacherName\":\"李老师\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 5, 1, NULL, '2026-05-15 14:20:08');
INSERT INTO `operation_log` VALUES (25, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores/rank/overall', '', '{\"code\":200,\"data\":[{\"averageScore\":60.000000,\"className\":\"计算机1班\",\"studentName\":\"小红\",\"studentNo\":\"20212022\",\"totalCourses\":1}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 7, 1, NULL, '2026-05-15 14:20:08');
INSERT INTO `operation_log` VALUES (26, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores/rank/course/1', '1', '{\"code\":200,\"data\":[{\"className\":\"计算机1班\",\"courseName\":\"Java程序设计\",\"score\":60.00,\"studentName\":\"小红\",\"studentNo\":\"20212022\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 3, 1, NULL, '2026-05-15 14:20:08');
INSERT INTO `operation_log` VALUES (27, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores/analysis', '', '{\"code\":200,\"data\":{\"courseAnalysis\":[{\"fail\":0,\"courseName\":\"Java程序设计\",\"minScore\":60.00,\"excellent\":0,\"pass\":1,\"medium\":0,\"maxScore\":60.00,\"good\":0,\"averageScore\":60.000000}],\"trend\":[{\"month\":\"2026-04\",\"totalExams\":1,\"averageScore\":60.000000}],\"distribution\":{\"fail\":0,\"excellent\":0,\"pass\":1,\"medium\":0,\"good\":0}},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 8, 1, NULL, '2026-05-15 14:20:09');
INSERT INTO `operation_log` VALUES (28, NULL, 'anonymous', 'anonymous', 'QUERY', 'ATTENDANCE', '查询考勤记录', 'GET', '/api/attendance', '', '{\"code\":200,\"data\":[{\"attendanceDate\":1776787200000,\"className\":\"计算机1班\",\"createTime\":1776863218000,\"id\":21,\"remark\":\"\",\"status\":\"缺勤\",\"studentId\":7,\"studentName\":\"花花\",\"studentNo\":\"20212021\",\"updateTime\":1776863218000}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 14, 1, NULL, '2026-05-15 14:20:09');
INSERT INTO `operation_log` VALUES (29, NULL, 'anonymous', 'anonymous', 'QUERY', 'STUDENT', '查询学生信息', 'GET', '/api/students', '{\"pageNum\":1,\"pageSize\":1000}', '{\"code\":200,\"data\":{\"list\":[{\"age\":20,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778682512000,\"email\":\"test@example.com\",\"enrollmentDate\":1725120000000,\"gender\":\"男\",\"id\":206,\"name\":\"测试学生\",\"phone\":\"13800138000\",\"studentNo\":\"TEST001\",\"studentStatus\":\"在读\",\"updateTime\":1778682512000},{\"address\":\"北京市海淀区5号\",\"age\":20,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001043@example.com\",\"enrollmentDate\":1742659200000,\"gender\":\"女\",\"id\":50,\"name\":\"韩秀秀\",\"phone\":\"18984949292\",\"studentNo\":\"2024001043\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区14号\",\"age\":22,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001009@example.com\",\"enrollmentDate\":1727107200000,\"gender\":\"女\",\"id\":16,\"name\":\"谢雪\",\"phone\":\"13829048664\",\"studentNo\":\"2024001009\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区84号\",\"age\":22,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001045@example.com\",\"enrollmentDate\":1740240000000,\"gender\":\"女\",\"id\":52,\"name\":\"蒋晶\",\"phone\":\"13481414340\",\"studentNo\":\"2024001045\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区37号\",\"age\":23,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001011@example.com\",\"enrollmentDate\":1729267200000,\"gender\":\"男\",\"id\":18,\"name\":\"沈博文\",\"phone\":\"17544487034\",\"studentNo\":\"2024001011\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区94号\",\"age\":19,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001047@example.com\",\"enrollmentDate\":1733414400000,\"gender\":\"女\",\"id\":54,\"name\":\"平丽\",\"phone\":\"15232776313\",\"studentNo\":\"2024001047\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区5号\",\"age\":22,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001013@example.com\",\"enrollmentDate\":1705766400000,\"gender\":\"女\",\"id\":20,\"name\":\"卫娜\",\"phone\":\"15468956361\",\"studentNo\":\"2024001013\",\"studentStatus\":\"在读...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 39, 1, NULL, '2026-05-15 14:20:09');
INSERT INTO `operation_log` VALUES (30, NULL, 'anonymous', 'anonymous', 'QUERY', 'WARNING', '查询预警记录', 'GET', '/api/warning/list', '\"\", \"\", \"\", ', '{\"code\":200,\"data\":[],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 10, 1, NULL, '2026-05-15 14:20:10');
INSERT INTO `operation_log` VALUES (31, NULL, 'anonymous', 'anonymous', 'QUERY', 'WARNING', '查询预警记录', 'GET', '/api/warning/rules', '', '{\"code\":200,\"data\":[{\"createTime\":1776871781000,\"description\":\"单科成绩低于60分\",\"id\":1,\"ruleName\":\"成绩不及格预警\",\"ruleType\":\"SCORE\",\"status\":1,\"thresholdValue\":60.0,\"updateTime\":1776871781000,\"warningLevel\":\"YELLOW\"},{\"createTime\":1776871781000,\"description\":\"单科成绩低于40分\",\"id\":2,\"ruleName\":\"成绩严重不及格预警\",\"ruleType\":\"SCORE\",\"status\":1,\"thresholdValue\":40.0,\"updateTime\":1776871781000,\"warningLevel\":\"RED\"},{\"createTime\":1776871781000,\"description\":\"累计缺勤3次及以上\",\"id\":3,\"ruleName\":\"缺勤预警\",\"ruleType\":\"ATTENDANCE\",\"status\":1,\"thresholdCount\":3,\"updateTime\":1776871781000,\"warningLevel\":\"YELLOW\"},{\"createTime\":1776871781000,\"description\":\"累计缺勤5次及以上\",\"id\":4,\"ruleName\":\"严重缺勤预警\",\"ruleType\":\"ATTENDANCE\",\"status\":1,\"thresholdCount\":5,\"updateTime\":1776871781000,\"warningLevel\":\"RED\"},{\"createTime\":1776871781000,\"description\":\"2科及以上成绩不及格\",\"id\":5,\"ruleName\":\"多科不及格预警\",\"ruleType\":\"COMPREHENSIVE\",\"status\":1,\"thresholdCount\":2,\"thresholdValue\":60.0,\"updateTime\":1776871781000,\"warningLevel\":\"ORANGE\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 15, 1, NULL, '2026-05-15 14:20:10');
INSERT INTO `operation_log` VALUES (32, NULL, 'anonymous', 'anonymous', 'QUERY', 'WARNING', '查询预警记录', 'GET', '/api/warning/statistics', '', '{\"code\":200,\"data\":{\"yellowCount\":0,\"totalPending\":0,\"redCount\":0,\"orangeCount\":0},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 20, 1, NULL, '2026-05-15 14:20:10');
INSERT INTO `operation_log` VALUES (33, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/notification/unread-count', '', '{\"code\":200,\"data\":0,\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 7, 1, NULL, '2026-05-15 14:20:12');
INSERT INTO `operation_log` VALUES (34, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/notification/list', '', '{\"code\":200,\"data\":[],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 11, 1, NULL, '2026-05-15 14:20:12');
INSERT INTO `operation_log` VALUES (35, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCHOLARSHIP', '查询奖学金', 'GET', '/api/scholarship/types', '', '{\"code\":200,\"data\":[{\"academicYear\":\"2024-2025\",\"amount\":1200.00,\"createTime\":1777022669000,\"description\":\"....\",\"id\":7,\"quota\":2,\"requirements\":\"优先\",\"semester\":\"全年\",\"status\":1,\"typeCode\":\"koko\",\"typeName\":\"EZ\",\"updateTime\":1777022669000}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 28, 1, NULL, '2026-05-15 14:20:13');
INSERT INTO `operation_log` VALUES (36, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCHOLARSHIP', '查询奖学金', 'GET', '/api/scholarship/types/active', '', '{\"code\":200,\"data\":[{\"academicYear\":\"2024-2025\",\"amount\":1200.00,\"createTime\":1777022669000,\"description\":\"....\",\"id\":7,\"quota\":2,\"requirements\":\"优先\",\"semester\":\"全年\",\"status\":1,\"typeCode\":\"koko\",\"typeName\":\"EZ\",\"updateTime\":1777022669000}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 27, 1, NULL, '2026-05-15 14:20:13');
INSERT INTO `operation_log` VALUES (37, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCHOLARSHIP', '查询奖学金', 'GET', '/api/scholarship/records', '\"2023-2024\", \"上学期\", \"\", ', '{\"code\":200,\"data\":[],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 32, 1, NULL, '2026-05-15 14:20:13');
INSERT INTO `operation_log` VALUES (38, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCHOLARSHIP', '查询奖学金', 'GET', '/api/scholarship/statistics', '\"2023-2024\", \"上学期\"', '{\"code\":200,\"data\":{\"totalAmount\":0,\"typeStatistics\":{},\"pendingCount\":0,\"averageGpa\":0.00,\"rejectedCount\":0,\"totalApplications\":0,\"approvedCount\":0,\"averageRanking\":0.0},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 42, 1, NULL, '2026-05-15 14:20:13');
INSERT INTO `operation_log` VALUES (39, NULL, 'anonymous', 'anonymous', 'QUERY', 'STUDENT', '查询学生信息', 'GET', '/api/students', '{\"pageNum\":1,\"pageSize\":9999}', '{\"code\":200,\"data\":{\"list\":[{\"age\":20,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778682512000,\"email\":\"test@example.com\",\"enrollmentDate\":1725120000000,\"gender\":\"男\",\"id\":206,\"name\":\"测试学生\",\"phone\":\"13800138000\",\"studentNo\":\"TEST001\",\"studentStatus\":\"在读\",\"updateTime\":1778682512000},{\"address\":\"北京市海淀区3号\",\"age\":23,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001033@example.com\",\"enrollmentDate\":1732636800000,\"gender\":\"男\",\"id\":40,\"name\":\"傅勇\",\"phone\":\"16617264985\",\"studentNo\":\"2024001033\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区24号\",\"age\":18,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001035@example.com\",\"enrollmentDate\":1728144000000,\"gender\":\"男\",\"id\":42,\"name\":\"史昊\",\"phone\":\"19514505693\",\"studentNo\":\"2024001035\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区4号\",\"age\":22,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001001@example.com\",\"enrollmentDate\":1728144000000,\"gender\":\"男\",\"id\":8,\"name\":\"蒋斌\",\"phone\":\"15582344126\",\"studentNo\":\"2024001001\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区10号\",\"age\":18,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001037@example.com\",\"enrollmentDate\":1739721600000,\"gender\":\"女\",\"id\":44,\"name\":\"喻丽丽\",\"phone\":\"16543819934\",\"studentNo\":\"2024001037\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区74号\",\"age\":18,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001003@example.com\",\"enrollmentDate\":1685808000000,\"gender\":\"女\",\"id\":10,\"name\":\"彭蓉\",\"phone\":\"15626583270\",\"studentNo\":\"2024001003\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区21号\",\"age\":20,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001039@example.com\",\"enrollmentDate\":1696694400000,\"gender\":\"女\",\"id\":46,\"name\":\"史琳\",\"phone\":\"15310631828\",\"studentNo\":\"2024001039\",\"studentStatus\":\"在读\",...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 56, 1, NULL, '2026-05-15 14:20:13');
INSERT INTO `operation_log` VALUES (40, NULL, 'anonymous', 'anonymous', 'QUERY', 'CLASS', '查询班级信息', 'GET', '/api/classes', '', '{\"code\":200,\"data\":[{\"className\":\"计算机1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":1,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"软件工程1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":3,\"major\":\"软件工程\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"计算机2班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":2,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"className\":\"软件高级班\",\"createTime\":1776862287000,\"grade\":\"2021级\",\"id\":4,\"major\":\"软件技术\",\"studentCount\":0,\"teacherId\":4,\"teacherName\":\"何坤坤\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 4, 1, NULL, '2026-05-15 14:20:13');
INSERT INTO `operation_log` VALUES (41, NULL, 'anonymous', 'anonymous', 'QUERY', 'COURSE', '查询课程信息', 'GET', '/api/courses', '', '{\"code\":200,\"data\":[{\"courseCode\":\"CS101\",\"courseName\":\"Java程序设计\",\"createTime\":1776408197000,\"credit\":4.0,\"description\":\"Java基础与面向对象编程\",\"hours\":64,\"id\":1,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS102\",\"courseName\":\"数据结构与算法\",\"createTime\":1776408197000,\"credit\":3.5,\"description\":\"常用数据结构与算法分析\",\"hours\":56,\"id\":2,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS103\",\"courseName\":\"数据库原理\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"关系型数据库设计与SQL\",\"hours\":48,\"id\":3,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS104\",\"courseName\":\"Web前端开发\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"HTML、CSS、JavaScript基础\",\"hours\":48,\"id\":4,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS105\",\"courseName\":\"vue3\",\"createTime\":1776426873000,\"credit\":5.0,\"description\":\"good\\n\",\"hours\":16,\"id\":5,\"teacherId\":3,\"teacherName\":\"李老师\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 5, 1, NULL, '2026-05-15 14:20:13');
INSERT INTO `operation_log` VALUES (42, NULL, 'anonymous', 'anonymous', 'QUERY', 'USER', '查询用户信息', 'GET', '/api/users', '', '{\"code\":200,\"data\":[{\"createTime\":1776862173000,\"id\":4,\"realName\":\"何坤坤\",\"role\":\"teacher\",\"status\":1,\"updateTime\":1776869843000,\"username\":\"噜噜\"},{\"createTime\":1776408197000,\"id\":1,\"realName\":\"管理员\",\"role\":\"admin\",\"status\":1,\"updateTime\":1776412187000,\"username\":\"admin\"},{\"createTime\":1776408197000,\"id\":2,\"realName\":\"张老师\",\"role\":\"teacher\",\"status\":1,\"updateTime\":1776481301000,\"username\":\"teacher1\"},{\"createTime\":1776408197000,\"id\":3,\"realName\":\"李老师\",\"role\":\"teacher\",\"status\":1,\"updateTime\":1776412187000,\"username\":\"teacher2\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 8, 1, NULL, '2026-05-15 14:20:13');
INSERT INTO `operation_log` VALUES (43, NULL, 'anonymous', 'anonymous', 'QUERY', 'COURSE', '查询课程信息', 'GET', '/api/schedule/classrooms/active', '', '{\"code\":200,\"data\":[{\"building\":\"A教学楼\",\"capacity\":60,\"createTime\":1776871781000,\"floor\":1,\"id\":1,\"roomCode\":\"A101\",\"roomName\":\"A101教室\",\"roomType\":\"NORMAL\",\"status\":1,\"updateTime\":1776871781000},{\"building\":\"A教学楼\",\"capacity\":60,\"createTime\":1776871781000,\"floor\":1,\"id\":2,\"roomCode\":\"A102\",\"roomName\":\"A102教室\",\"roomType\":\"NORMAL\",\"status\":1,\"updateTime\":1776871781000},{\"building\":\"A教学楼\",\"capacity\":80,\"createTime\":1776871781000,\"floor\":2,\"id\":3,\"roomCode\":\"A201\",\"roomName\":\"A201多媒体教室\",\"roomType\":\"MEDIA\",\"status\":1,\"updateTime\":1776871781000},{\"building\":\"A教学楼\",\"capacity\":80,\"createTime\":1776871781000,\"floor\":2,\"id\":4,\"roomCode\":\"A202\",\"roomName\":\"A202多媒体教室\",\"roomType\":\"MEDIA\",\"status\":1,\"updateTime\":1776871781000},{\"building\":\"B教学楼\",\"capacity\":40,\"createTime\":1776871781000,\"floor\":1,\"id\":5,\"roomCode\":\"B101\",\"roomName\":\"B101实验室\",\"roomType\":\"LAB\",\"status\":1,\"updateTime\":1776871781000},{\"building\":\"B教学楼\",\"capacity\":40,\"createTime\":1776871781000,\"floor\":1,\"id\":6,\"roomCode\":\"B102\",\"roomName\":\"B102实验室\",\"roomType\":\"LAB\",\"status\":1,\"updateTime\":1776871781000},{\"building\":\"C教学楼\",\"capacity\":120,\"createTime\":1776871781000,\"floor\":1,\"id\":7,\"roomCode\":\"C101\",\"roomName\":\"C101大教室\",\"roomType\":\"MEDIA\",\"status\":1,\"updateTime\":1776871781000},{\"building\":\"C教学楼\",\"capacity\":120,\"createTime\":1776871781000,\"floor\":1,\"id\":8,\"roomCode\":\"C102\",\"roomName\":\"C102大教室\",\"roomType\":\"MEDIA\",\"status\":1,\"updateTime\":1776871781000}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 22, 1, NULL, '2026-05-15 14:20:13');
INSERT INTO `operation_log` VALUES (44, NULL, 'anonymous', 'anonymous', 'QUERY', 'AUTH', '查询系统数据', 'GET', '/api/auth/info', '\"admin\", \"admin\"', '{\"code\":200,\"data\":{\"realName\":\"管理员\",\"role\":\"admin\",\"id\":1,\"username\":\"admin\"},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 2, 1, NULL, '2026-05-15 14:20:14');
INSERT INTO `operation_log` VALUES (45, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/settings/map', '', '{\"code\":200,\"data\":{\"attendance_warning_days\":\"3\",\"school_address\":\"123 Demo Street\",\"pass_score\":\"60\",\"system_version\":\"v1.0.0\",\"school_phone\":\"010-12345678\",\"current_semester\":\"2024-2025 Semester 1\",\"school_name\":\"vue3 spring-boot\",\"excellent_score\":\"95\"},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 6, 1, NULL, '2026-05-15 14:20:15');
INSERT INTO `operation_log` VALUES (46, NULL, 'anonymous', 'anonymous', 'QUERY', 'AUTH', '查询系统数据', 'GET', '/api/auth/info', '\"admin\", \"admin\"', '{\"code\":200,\"data\":{\"realName\":\"管理员\",\"role\":\"admin\",\"id\":1,\"username\":\"admin\"},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 2, 1, NULL, '2026-05-15 14:20:18');
INSERT INTO `operation_log` VALUES (47, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/settings/map', '', '{\"code\":200,\"data\":{\"attendance_warning_days\":\"3\",\"school_address\":\"123 Demo Street\",\"pass_score\":\"60\",\"system_version\":\"v1.0.0\",\"school_phone\":\"010-12345678\",\"current_semester\":\"2024-2025 Semester 1\",\"school_name\":\"vue3 spring-boot\",\"excellent_score\":\"95\"},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 6, 1, NULL, '2026-05-15 14:20:18');
INSERT INTO `operation_log` VALUES (48, NULL, 'anonymous', 'anonymous', 'INSERT', 'AUTH', '登录系统数据', 'POST', '/api/auth/login', '{\"password\":\"admin123\",\"username\":\"admin\"}', '{\"code\":200,\"data\":{\"realName\":\"管理员\",\"role\":\"admin\",\"id\":1,\"token\":\"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsInJvbGUiOiJhZG1pbiIsImlhdCI6MTc3ODgyNjE2NywiZXhwIjoxNzc4OTEyNTY3fQ.-aprd7EKnYmF8IJAFk89eK-6MY656NIPPXitlEI_ungocZVFQYUrwx5YHwKF0Iq-V13ZEYZRQhanBMrtcZcAqg\",\"username\":\"admin\"},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 4, 1, NULL, '2026-05-15 14:22:47');
INSERT INTO `operation_log` VALUES (49, NULL, 'anonymous', 'anonymous', 'INSERT', 'AUTH', '登录系统数据', 'POST', '/api/auth/login', '{\"password\":\"admin123\",\"username\":\"admin\"}', '{\"code\":200,\"data\":{\"realName\":\"管理员\",\"role\":\"admin\",\"id\":1,\"token\":\"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsInJvbGUiOiJhZG1pbiIsImlhdCI6MTc3ODgyNjE2NywiZXhwIjoxNzc4OTEyNTY3fQ.-aprd7EKnYmF8IJAFk89eK-6MY656NIPPXitlEI_ungocZVFQYUrwx5YHwKF0Iq-V13ZEYZRQhanBMrtcZcAqg\",\"username\":\"admin\"},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 4, 1, NULL, '2026-05-15 14:22:47');
INSERT INTO `operation_log` VALUES (50, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/statistics', '', '{\"code\":200,\"data\":{\"classDistribution\":{\"软件高级班\":50,\"计算机1班\":51,\"计算机2班\":50,\"软件工程1班\":50},\"genderDistribution\":{\"女\":97,\"男\":104},\"statusDistribution\":{\"在读\":200,\"毕业\":1},\"totalClasses\":4,\"totalCourses\":5,\"totalStudents\":201,\"totalUsers\":3},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 21, 1, NULL, '2026-05-15 14:22:48');
INSERT INTO `operation_log` VALUES (51, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores/statistics', '', '{\"code\":200,\"data\":{\"passRate\":100.00,\"courseAverageScores\":[{\"courseName\":\"Java程序设计\",\"averageScore\":60.000000}]},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 11, 1, NULL, '2026-05-15 14:22:48');
INSERT INTO `operation_log` VALUES (52, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/statistics', '', '{\"code\":200,\"data\":{\"classDistribution\":{\"软件高级班\":50,\"计算机1班\":51,\"计算机2班\":50,\"软件工程1班\":50},\"genderDistribution\":{\"女\":97,\"男\":104},\"statusDistribution\":{\"在读\":200,\"毕业\":1},\"totalClasses\":4,\"totalCourses\":5,\"totalStudents\":201,\"totalUsers\":3},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 18, 1, NULL, '2026-05-15 14:25:18');
INSERT INTO `operation_log` VALUES (53, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores/statistics', '', '{\"code\":200,\"data\":{\"passRate\":100.00,\"courseAverageScores\":[{\"courseName\":\"Java程序设计\",\"averageScore\":60.000000}]},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 20, 1, NULL, '2026-05-15 14:25:19');
INSERT INTO `operation_log` VALUES (54, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/statistics', '', '{\"code\":200,\"data\":{\"classDistribution\":{\"软件高级班\":50,\"计算机1班\":51,\"计算机2班\":50,\"软件工程1班\":50},\"genderDistribution\":{\"女\":97,\"男\":104},\"statusDistribution\":{\"在读\":200,\"毕业\":1},\"totalClasses\":4,\"totalCourses\":5,\"totalStudents\":201,\"totalUsers\":3},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 21, 1, NULL, '2026-05-15 14:25:21');
INSERT INTO `operation_log` VALUES (55, NULL, 'anonymous', 'anonymous', 'QUERY', 'CLASS', '查询班级信息', 'GET', '/api/classes', '', '{\"code\":200,\"data\":[{\"className\":\"计算机1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":1,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"软件工程1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":3,\"major\":\"软件工程\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"计算机2班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":2,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"className\":\"软件高级班\",\"createTime\":1776862287000,\"grade\":\"2021级\",\"id\":4,\"major\":\"软件技术\",\"studentCount\":0,\"teacherId\":4,\"teacherName\":\"何坤坤\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 4, 1, NULL, '2026-05-15 14:25:27');
INSERT INTO `operation_log` VALUES (56, NULL, 'anonymous', 'anonymous', 'QUERY', 'STUDENT', '查询学生信息', 'GET', '/api/students', '{\"gender\":\"\",\"name\":\"\",\"pageNum\":1,\"pageSize\":10,\"studentNo\":\"\",\"studentStatus\":\"\"}', '{\"code\":200,\"data\":{\"list\":[{\"age\":20,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778682512000,\"email\":\"test@example.com\",\"enrollmentDate\":1725120000000,\"gender\":\"男\",\"id\":206,\"name\":\"测试学生\",\"phone\":\"13800138000\",\"studentNo\":\"TEST001\",\"studentStatus\":\"在读\",\"updateTime\":1778682512000},{\"address\":\"广州市天河区13号\",\"age\":22,\"classId\":4,\"className\":\"软件高级班\",\"createTime\":1776901643000,\"email\":\"student2024004033@example.com\",\"enrollmentDate\":1684339200000,\"gender\":\"女\",\"id\":188,\"name\":\"王琳\",\"phone\":\"17520724331\",\"studentNo\":\"2024004033\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"上海市浦东新区97号\",\"age\":22,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003049@example.com\",\"enrollmentDate\":1690041600000,\"gender\":\"女\",\"id\":154,\"name\":\"苗倩\",\"phone\":\"18396579005\",\"studentNo\":\"2024003049\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"广州市天河区27号\",\"age\":19,\"classId\":4,\"className\":\"软件高级班\",\"createTime\":1776901643000,\"email\":\"student2024004035@example.com\",\"enrollmentDate\":1722960000000,\"gender\":\"女\",\"id\":190,\"name\":\"袁蓉\",\"phone\":\"15597667158\",\"studentNo\":\"2024004035\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"广州市天河区21号\",\"age\":18,\"classId\":4,\"className\":\"软件高级班\",\"createTime\":1776901643000,\"email\":\"student2024004001@example.com\",\"enrollmentDate\":1745164800000,\"gender\":\"女\",\"id\":156,\"name\":\"薛静\",\"phone\":\"15289558745\",\"studentNo\":\"2024004001\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"广州市天河区14号\",\"age\":23,\"classId\":4,\"className\":\"软件高级班\",\"createTime\":1776901643000,\"email\":\"student2024004037@example.com\",\"enrollmentDate\":1740844800000,\"gender\":\"女\",\"id\":192,\"name\":\"周霞\",\"phone\":\"19706324239\",\"studentNo\":\"2024004037\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"广州市天河区25号\",\"age\":20,\"classId\":4,\"className\":\"软件高级班\",\"createTime\":1776901643000,\"email\":\"student2024004003@example.com\",\"enrollmentDate\":1744560000000,\"gender\":\"女\",\"id\":158,\"name\":\"云娜\",\"phone\":\"14935554173\",\"studentNo\":\"2024004003\",\"studentSta...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 7, 1, NULL, '2026-05-15 14:25:27');
INSERT INTO `operation_log` VALUES (57, NULL, 'anonymous', 'anonymous', 'INSERT', 'STUDENT', '操作学生信息', 'POST', '/api/students', '{\"address\":\"四川遂宁\",\"age\":21,\"classId\":1,\"email\":\"2113267199@qq.com\",\"enrollmentDate\":1778688000000,\"gender\":\"男\",\"name\":\"QQH\",\"phone\":\"18848328887\",\"studentNo\":\"20210001\",\"studentStatus\":\"毕业\"}', '{\"code\":200,\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 7, 1, NULL, '2026-05-15 14:27:17');
INSERT INTO `operation_log` VALUES (58, NULL, 'anonymous', 'anonymous', 'QUERY', 'STUDENT', '查询学生信息', 'GET', '/api/students', '{\"gender\":\"\",\"name\":\"\",\"pageNum\":1,\"pageSize\":10,\"studentNo\":\"\",\"studentStatus\":\"\"}', '{\"code\":200,\"data\":{\"list\":[{\"address\":\"四川遂宁\",\"age\":21,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778826437000,\"email\":\"2113267199@qq.com\",\"enrollmentDate\":1778688000000,\"gender\":\"男\",\"id\":207,\"name\":\"QQH\",\"phone\":\"18848328887\",\"studentNo\":\"20210001\",\"studentStatus\":\"毕业\",\"updateTime\":1778826437000},{\"age\":20,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778682512000,\"email\":\"test@example.com\",\"enrollmentDate\":1725120000000,\"gender\":\"男\",\"id\":206,\"name\":\"测试学生\",\"phone\":\"13800138000\",\"studentNo\":\"TEST001\",\"studentStatus\":\"在读\",\"updateTime\":1778682512000},{\"address\":\"广州市天河区80号\",\"age\":22,\"classId\":4,\"className\":\"软件高级班\",\"createTime\":1776901643000,\"email\":\"student2024004020@example.com\",\"enrollmentDate\":1695916800000,\"gender\":\"男\",\"id\":175,\"name\":\"金军\",\"phone\":\"13333028964\",\"studentNo\":\"2024004020\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"上海市浦东新区39号\",\"age\":19,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003036@example.com\",\"enrollmentDate\":1690214400000,\"gender\":\"男\",\"id\":141,\"name\":\"范凯\",\"phone\":\"15323552864\",\"studentNo\":\"2024003036\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区10号\",\"age\":18,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001037@example.com\",\"enrollmentDate\":1739721600000,\"gender\":\"女\",\"id\":44,\"name\":\"喻丽丽\",\"phone\":\"16543819934\",\"studentNo\":\"2024001037\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区74号\",\"age\":18,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001003@example.com\",\"enrollmentDate\":1685808000000,\"gender\":\"女\",\"id\":10,\"name\":\"彭蓉\",\"phone\":\"15626583270\",\"studentNo\":\"2024001003\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"广州市天河区61号\",\"age\":18,\"classId\":4,\"className\":\"软件高级班\",\"createTime\":1776901643000,\"email\":\"student2024004022@example.com\",\"enrollmentDate\":1692374400000,\"gender\":\"男\",\"id\":177,\"name\":\"水超\",\"phone\":\"17451932466\",\"studentNo\":\"2024004022\",\"studentStatus\":\"在读\",\"updateTi...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 7, 1, NULL, '2026-05-15 14:27:17');
INSERT INTO `operation_log` VALUES (59, NULL, 'anonymous', 'anonymous', 'QUERY', 'CLASS', '查询班级信息', 'GET', '/api/classes', '', '{\"code\":200,\"data\":[{\"className\":\"计算机1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":1,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"软件工程1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":3,\"major\":\"软件工程\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"计算机2班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":2,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"className\":\"软件高级班\",\"createTime\":1776862287000,\"grade\":\"2021级\",\"id\":4,\"major\":\"软件技术\",\"studentCount\":0,\"teacherId\":4,\"teacherName\":\"何坤坤\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 3, 1, NULL, '2026-05-15 14:27:21');
INSERT INTO `operation_log` VALUES (60, NULL, 'anonymous', 'anonymous', 'QUERY', 'CLASS', '查询班级信息', 'GET', '/api/classes', '', '{\"code\":200,\"data\":[{\"className\":\"计算机1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":1,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"软件工程1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":3,\"major\":\"软件工程\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"计算机2班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":2,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"className\":\"软件高级班\",\"createTime\":1776862287000,\"grade\":\"2021级\",\"id\":4,\"major\":\"软件技术\",\"studentCount\":0,\"teacherId\":4,\"teacherName\":\"何坤坤\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 3, 1, NULL, '2026-05-15 14:27:22');
INSERT INTO `operation_log` VALUES (61, NULL, 'anonymous', 'anonymous', 'QUERY', 'STUDENT', '查询学生信息', 'GET', '/api/students', '{\"gender\":\"\",\"name\":\"\",\"pageNum\":1,\"pageSize\":10,\"studentNo\":\"\",\"studentStatus\":\"\"}', '{\"code\":200,\"data\":{\"list\":[{\"address\":\"四川遂宁\",\"age\":21,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778826437000,\"email\":\"2113267199@qq.com\",\"enrollmentDate\":1778688000000,\"gender\":\"男\",\"id\":207,\"name\":\"QQH\",\"phone\":\"18848328887\",\"studentNo\":\"20210001\",\"studentStatus\":\"毕业\",\"updateTime\":1778826437000},{\"age\":20,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778682512000,\"email\":\"test@example.com\",\"enrollmentDate\":1725120000000,\"gender\":\"男\",\"id\":206,\"name\":\"测试学生\",\"phone\":\"13800138000\",\"studentNo\":\"TEST001\",\"studentStatus\":\"在读\",\"updateTime\":1778682512000},{\"address\":\"广州市天河区80号\",\"age\":22,\"classId\":4,\"className\":\"软件高级班\",\"createTime\":1776901643000,\"email\":\"student2024004020@example.com\",\"enrollmentDate\":1695916800000,\"gender\":\"男\",\"id\":175,\"name\":\"金军\",\"phone\":\"13333028964\",\"studentNo\":\"2024004020\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"上海市浦东新区39号\",\"age\":19,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003036@example.com\",\"enrollmentDate\":1690214400000,\"gender\":\"男\",\"id\":141,\"name\":\"范凯\",\"phone\":\"15323552864\",\"studentNo\":\"2024003036\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区34号\",\"age\":23,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001046@example.com\",\"enrollmentDate\":1727884800000,\"gender\":\"男\",\"id\":53,\"name\":\"严明\",\"phone\":\"14709326310\",\"studentNo\":\"2024001046\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区14号\",\"age\":23,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001012@example.com\",\"enrollmentDate\":1728057600000,\"gender\":\"男\",\"id\":19,\"name\":\"奚睿\",\"phone\":\"17589680685\",\"studentNo\":\"2024001012\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"广州市天河区61号\",\"age\":18,\"classId\":4,\"className\":\"软件高级班\",\"createTime\":1776901643000,\"email\":\"student2024004022@example.com\",\"enrollmentDate\":1692374400000,\"gender\":\"男\",\"id\":177,\"name\":\"水超\",\"phone\":\"17451932466\",\"studentNo\":\"2024004022\",\"studentStatus\":\"在读\",\"updateTim...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 9, 1, NULL, '2026-05-15 14:27:22');
INSERT INTO `operation_log` VALUES (62, NULL, 'anonymous', 'anonymous', 'QUERY', 'CLASS', '查询班级信息', 'GET', '/api/classes', '', '{\"code\":200,\"data\":[{\"className\":\"计算机1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":1,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"软件工程1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":3,\"major\":\"软件工程\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"计算机2班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":2,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"className\":\"软件高级班\",\"createTime\":1776862287000,\"grade\":\"2021级\",\"id\":4,\"major\":\"软件技术\",\"studentCount\":0,\"teacherId\":4,\"teacherName\":\"何坤坤\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 2, 1, NULL, '2026-05-15 14:27:23');
INSERT INTO `operation_log` VALUES (63, NULL, 'anonymous', 'anonymous', 'QUERY', 'USER', '查询用户信息', 'GET', '/api/users/by-role', '\"teacher\", ', '{\"code\":200,\"data\":[{\"createTime\":1776862173000,\"id\":4,\"realName\":\"何坤坤\",\"role\":\"teacher\",\"status\":1,\"updateTime\":1776869843000,\"username\":\"噜噜\"},{\"createTime\":1776408197000,\"id\":2,\"realName\":\"张老师\",\"role\":\"teacher\",\"status\":1,\"updateTime\":1776481301000,\"username\":\"teacher1\"},{\"createTime\":1776408197000,\"id\":3,\"realName\":\"李老师\",\"role\":\"teacher\",\"status\":1,\"updateTime\":1776412187000,\"username\":\"teacher2\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 3, 1, NULL, '2026-05-15 14:27:26');
INSERT INTO `operation_log` VALUES (64, NULL, 'anonymous', 'anonymous', 'QUERY', 'USER', '查询用户信息', 'GET', '/api/users/by-role', '\"teacher\", ', '{\"code\":200,\"data\":[{\"createTime\":1776862173000,\"id\":4,\"realName\":\"何坤坤\",\"role\":\"teacher\",\"status\":1,\"updateTime\":1776869843000,\"username\":\"噜噜\"},{\"createTime\":1776408197000,\"id\":2,\"realName\":\"张老师\",\"role\":\"teacher\",\"status\":1,\"updateTime\":1776481301000,\"username\":\"teacher1\"},{\"createTime\":1776408197000,\"id\":3,\"realName\":\"李老师\",\"role\":\"teacher\",\"status\":1,\"updateTime\":1776412187000,\"username\":\"teacher2\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 1, 1, NULL, '2026-05-15 14:27:35');
INSERT INTO `operation_log` VALUES (65, NULL, 'anonymous', 'anonymous', 'QUERY', 'COURSE', '查询课程信息', 'GET', '/api/courses', '', '{\"code\":200,\"data\":[{\"courseCode\":\"CS101\",\"courseName\":\"Java程序设计\",\"createTime\":1776408197000,\"credit\":4.0,\"description\":\"Java基础与面向对象编程\",\"hours\":64,\"id\":1,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS102\",\"courseName\":\"数据结构与算法\",\"createTime\":1776408197000,\"credit\":3.5,\"description\":\"常用数据结构与算法分析\",\"hours\":56,\"id\":2,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS103\",\"courseName\":\"数据库原理\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"关系型数据库设计与SQL\",\"hours\":48,\"id\":3,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS104\",\"courseName\":\"Web前端开发\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"HTML、CSS、JavaScript基础\",\"hours\":48,\"id\":4,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS105\",\"courseName\":\"vue3\",\"createTime\":1776426873000,\"credit\":5.0,\"description\":\"good\\n\",\"hours\":16,\"id\":5,\"teacherId\":3,\"teacherName\":\"李老师\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 3, 1, NULL, '2026-05-15 14:27:37');
INSERT INTO `operation_log` VALUES (66, NULL, 'anonymous', 'anonymous', 'QUERY', 'CLASS', '查询班级信息', 'GET', '/api/classes', '', '{\"code\":200,\"data\":[{\"className\":\"计算机1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":1,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"软件工程1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":3,\"major\":\"软件工程\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"计算机2班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":2,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"className\":\"软件高级班\",\"createTime\":1776862287000,\"grade\":\"2021级\",\"id\":4,\"major\":\"软件技术\",\"studentCount\":0,\"teacherId\":4,\"teacherName\":\"何坤坤\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 3, 1, NULL, '2026-05-15 14:27:41');
INSERT INTO `operation_log` VALUES (67, NULL, 'anonymous', 'anonymous', 'QUERY', 'COURSE', '查询课程信息', 'GET', '/api/courses', '', '{\"code\":200,\"data\":[{\"courseCode\":\"CS101\",\"courseName\":\"Java程序设计\",\"createTime\":1776408197000,\"credit\":4.0,\"description\":\"Java基础与面向对象编程\",\"hours\":64,\"id\":1,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS102\",\"courseName\":\"数据结构与算法\",\"createTime\":1776408197000,\"credit\":3.5,\"description\":\"常用数据结构与算法分析\",\"hours\":56,\"id\":2,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS103\",\"courseName\":\"数据库原理\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"关系型数据库设计与SQL\",\"hours\":48,\"id\":3,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS104\",\"courseName\":\"Web前端开发\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"HTML、CSS、JavaScript基础\",\"hours\":48,\"id\":4,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS105\",\"courseName\":\"vue3\",\"createTime\":1776426873000,\"credit\":5.0,\"description\":\"good\\n\",\"hours\":16,\"id\":5,\"teacherId\":3,\"teacherName\":\"李老师\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 3, 1, NULL, '2026-05-15 14:27:59');
INSERT INTO `operation_log` VALUES (68, NULL, 'anonymous', 'anonymous', 'QUERY', 'COURSE', '查询课程信息', 'GET', '/api/courses', '', '{\"code\":200,\"data\":[{\"courseCode\":\"CS101\",\"courseName\":\"Java程序设计\",\"createTime\":1776408197000,\"credit\":4.0,\"description\":\"Java基础与面向对象编程\",\"hours\":64,\"id\":1,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS102\",\"courseName\":\"数据结构与算法\",\"createTime\":1776408197000,\"credit\":3.5,\"description\":\"常用数据结构与算法分析\",\"hours\":56,\"id\":2,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS103\",\"courseName\":\"数据库原理\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"关系型数据库设计与SQL\",\"hours\":48,\"id\":3,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS104\",\"courseName\":\"Web前端开发\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"HTML、CSS、JavaScript基础\",\"hours\":48,\"id\":4,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS105\",\"courseName\":\"vue3\",\"createTime\":1776426873000,\"credit\":5.0,\"description\":\"good\\n\",\"hours\":16,\"id\":5,\"teacherId\":3,\"teacherName\":\"李老师\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 7, 1, NULL, '2026-05-15 14:28:07');
INSERT INTO `operation_log` VALUES (69, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores', '{\"examType\":\"\",\"pageNum\":1,\"pageSize\":10,\"studentName\":\"\"}', '{\"code\":200,\"data\":{\"list\":[{\"courseId\":1,\"courseName\":\"Java程序设计\",\"createTime\":1776863116000,\"examDate\":1776700800000,\"examType\":\"期中\",\"id\":14,\"remark\":\"\",\"score\":60.00,\"studentId\":6,\"studentName\":\"小红\",\"studentNo\":\"20212022\",\"updateTime\":1776863116000}],\"pageNum\":1,\"pageSize\":10,\"pages\":1,\"total\":1},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 12, 1, NULL, '2026-05-15 14:28:07');
INSERT INTO `operation_log` VALUES (70, NULL, 'anonymous', 'anonymous', 'QUERY', 'STUDENT', '查询学生信息', 'GET', '/api/students', '{\"pageNum\":1,\"pageSize\":1000}', '{\"code\":200,\"data\":{\"list\":[{\"address\":\"四川遂宁\",\"age\":21,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778826437000,\"email\":\"2113267199@qq.com\",\"enrollmentDate\":1778688000000,\"gender\":\"男\",\"id\":207,\"name\":\"QQH\",\"phone\":\"18848328887\",\"studentNo\":\"20210001\",\"studentStatus\":\"毕业\",\"updateTime\":1778826437000},{\"age\":20,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778682512000,\"email\":\"test@example.com\",\"enrollmentDate\":1725120000000,\"gender\":\"男\",\"id\":206,\"name\":\"测试学生\",\"phone\":\"13800138000\",\"studentNo\":\"TEST001\",\"studentStatus\":\"在读\",\"updateTime\":1778682512000},{\"address\":\"广州市天河区75号\",\"age\":23,\"classId\":4,\"className\":\"软件高级班\",\"createTime\":1776901643000,\"email\":\"student2024004023@example.com\",\"enrollmentDate\":1690560000000,\"gender\":\"男\",\"id\":178,\"name\":\"傅鹏\",\"phone\":\"13264871640\",\"studentNo\":\"2024004023\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"上海市浦东新区80号\",\"age\":19,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003039@example.com\",\"enrollmentDate\":1691596800000,\"gender\":\"男\",\"id\":144,\"name\":\"史文\",\"phone\":\"19199056346\",\"studentNo\":\"2024003039\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"广州市天河区3号\",\"age\":18,\"classId\":4,\"className\":\"软件高级班\",\"createTime\":1776901643000,\"email\":\"student2024004025@example.com\",\"enrollmentDate\":1724428800000,\"gender\":\"女\",\"id\":180,\"name\":\"袁艳\",\"phone\":\"14337922908\",\"studentNo\":\"2024004025\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"上海市浦东新区89号\",\"age\":21,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003041@example.com\",\"enrollmentDate\":1682352000000,\"gender\":\"男\",\"id\":146,\"name\":\"金洋\",\"phone\":\"14828922332\",\"studentNo\":\"2024003041\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"广州市天河区29号\",\"age\":21,\"classId\":4,\"className\":\"软件高级班\",\"createTime\":1776901643000,\"email\":\"student2024004027@example.com\",\"enrollmentDate\":1738166400000,\"gender\":\"男\",\"id\":182,\"name\":\"陈伟\",\"phone\":\"17218027279\",\"studentNo\":\"2024004027\",\"studentStatus\":\"在读\",\"update...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 44, 1, NULL, '2026-05-15 14:28:07');
INSERT INTO `operation_log` VALUES (71, NULL, 'anonymous', 'anonymous', 'DELETE', 'SCORE', '删除成绩信息', 'DELETE', '/api/scores/14', '14', '{\"code\":200,\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 5, 1, NULL, '2026-05-15 14:28:15');
INSERT INTO `operation_log` VALUES (72, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores', '{\"examType\":\"\",\"pageNum\":1,\"pageSize\":10,\"studentName\":\"\"}', '{\"code\":200,\"data\":{\"list\":[],\"pageNum\":1,\"pageSize\":10,\"pages\":0,\"total\":0},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 4, 1, NULL, '2026-05-15 14:28:15');
INSERT INTO `operation_log` VALUES (73, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores/rank/overall', '', '{\"code\":200,\"data\":[],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 2, 1, NULL, '2026-05-15 14:28:21');
INSERT INTO `operation_log` VALUES (74, NULL, 'anonymous', 'anonymous', 'QUERY', 'COURSE', '查询课程信息', 'GET', '/api/courses', '', '{\"code\":200,\"data\":[{\"courseCode\":\"CS101\",\"courseName\":\"Java程序设计\",\"createTime\":1776408197000,\"credit\":4.0,\"description\":\"Java基础与面向对象编程\",\"hours\":64,\"id\":1,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS102\",\"courseName\":\"数据结构与算法\",\"createTime\":1776408197000,\"credit\":3.5,\"description\":\"常用数据结构与算法分析\",\"hours\":56,\"id\":2,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS103\",\"courseName\":\"数据库原理\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"关系型数据库设计与SQL\",\"hours\":48,\"id\":3,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS104\",\"courseName\":\"Web前端开发\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"HTML、CSS、JavaScript基础\",\"hours\":48,\"id\":4,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS105\",\"courseName\":\"vue3\",\"createTime\":1776426873000,\"credit\":5.0,\"description\":\"good\\n\",\"hours\":16,\"id\":5,\"teacherId\":3,\"teacherName\":\"李老师\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 5, 1, NULL, '2026-05-15 14:28:21');
INSERT INTO `operation_log` VALUES (75, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores/rank/course/1', '1', '{\"code\":200,\"data\":[],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 1, 1, NULL, '2026-05-15 14:28:21');
INSERT INTO `operation_log` VALUES (76, NULL, 'anonymous', 'anonymous', 'QUERY', 'COURSE', '查询课程信息', 'GET', '/api/courses', '', '{\"code\":200,\"data\":[{\"courseCode\":\"CS101\",\"courseName\":\"Java程序设计\",\"createTime\":1776408197000,\"credit\":4.0,\"description\":\"Java基础与面向对象编程\",\"hours\":64,\"id\":1,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS102\",\"courseName\":\"数据结构与算法\",\"createTime\":1776408197000,\"credit\":3.5,\"description\":\"常用数据结构与算法分析\",\"hours\":56,\"id\":2,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS103\",\"courseName\":\"数据库原理\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"关系型数据库设计与SQL\",\"hours\":48,\"id\":3,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS104\",\"courseName\":\"Web前端开发\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"HTML、CSS、JavaScript基础\",\"hours\":48,\"id\":4,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS105\",\"courseName\":\"vue3\",\"createTime\":1776426873000,\"credit\":5.0,\"description\":\"good\\n\",\"hours\":16,\"id\":5,\"teacherId\":3,\"teacherName\":\"李老师\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 3, 1, NULL, '2026-05-15 14:28:22');
INSERT INTO `operation_log` VALUES (77, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores', '{\"examType\":\"\",\"pageNum\":1,\"pageSize\":10,\"studentName\":\"\"}', '{\"code\":200,\"data\":{\"list\":[],\"pageNum\":1,\"pageSize\":10,\"pages\":0,\"total\":0},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 6, 1, NULL, '2026-05-15 14:28:22');
INSERT INTO `operation_log` VALUES (78, NULL, 'anonymous', 'anonymous', 'QUERY', 'STUDENT', '查询学生信息', 'GET', '/api/students', '{\"pageNum\":1,\"pageSize\":1000}', '{\"code\":200,\"data\":{\"list\":[{\"address\":\"四川遂宁\",\"age\":21,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778826437000,\"email\":\"2113267199@qq.com\",\"enrollmentDate\":1778688000000,\"gender\":\"男\",\"id\":207,\"name\":\"QQH\",\"phone\":\"18848328887\",\"studentNo\":\"20210001\",\"studentStatus\":\"毕业\",\"updateTime\":1778826437000},{\"age\":20,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778682512000,\"email\":\"test@example.com\",\"enrollmentDate\":1725120000000,\"gender\":\"男\",\"id\":206,\"name\":\"测试学生\",\"phone\":\"13800138000\",\"studentNo\":\"TEST001\",\"studentStatus\":\"在读\",\"updateTime\":1778682512000},{\"address\":\"广州市天河区80号\",\"age\":22,\"classId\":4,\"className\":\"软件高级班\",\"createTime\":1776901643000,\"email\":\"student2024004020@example.com\",\"enrollmentDate\":1695916800000,\"gender\":\"男\",\"id\":175,\"name\":\"金军\",\"phone\":\"13333028964\",\"studentNo\":\"2024004020\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"上海市浦东新区39号\",\"age\":19,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003036@example.com\",\"enrollmentDate\":1690214400000,\"gender\":\"男\",\"id\":141,\"name\":\"范凯\",\"phone\":\"15323552864\",\"studentNo\":\"2024003036\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区34号\",\"age\":23,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001046@example.com\",\"enrollmentDate\":1727884800000,\"gender\":\"男\",\"id\":53,\"name\":\"严明\",\"phone\":\"14709326310\",\"studentNo\":\"2024001046\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市海淀区14号\",\"age\":23,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1776901643000,\"email\":\"student2024001012@example.com\",\"enrollmentDate\":1728057600000,\"gender\":\"男\",\"id\":19,\"name\":\"奚睿\",\"phone\":\"17589680685\",\"studentNo\":\"2024001012\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"广州市天河区61号\",\"age\":18,\"classId\":4,\"className\":\"软件高级班\",\"createTime\":1776901643000,\"email\":\"student2024004022@example.com\",\"enrollmentDate\":1692374400000,\"gender\":\"男\",\"id\":177,\"name\":\"水超\",\"phone\":\"17451932466\",\"studentNo\":\"2024004022\",\"studentStatus\":\"在读\",\"updateTim...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 46, 1, NULL, '2026-05-15 14:28:22');
INSERT INTO `operation_log` VALUES (79, NULL, 'anonymous', 'anonymous', 'QUERY', 'COURSE', '查询课程信息', 'GET', '/api/courses', '', '{\"code\":200,\"data\":[{\"courseCode\":\"CS101\",\"courseName\":\"Java程序设计\",\"createTime\":1776408197000,\"credit\":4.0,\"description\":\"Java基础与面向对象编程\",\"hours\":64,\"id\":1,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS102\",\"courseName\":\"数据结构与算法\",\"createTime\":1776408197000,\"credit\":3.5,\"description\":\"常用数据结构与算法分析\",\"hours\":56,\"id\":2,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS103\",\"courseName\":\"数据库原理\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"关系型数据库设计与SQL\",\"hours\":48,\"id\":3,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS104\",\"courseName\":\"Web前端开发\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"HTML、CSS、JavaScript基础\",\"hours\":48,\"id\":4,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS105\",\"courseName\":\"vue3\",\"createTime\":1776426873000,\"credit\":5.0,\"description\":\"good\\n\",\"hours\":16,\"id\":5,\"teacherId\":3,\"teacherName\":\"李老师\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 2, 1, NULL, '2026-05-15 14:28:23');
INSERT INTO `operation_log` VALUES (80, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores/rank/course/1', '1', '{\"code\":200,\"data\":[],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 2, 1, NULL, '2026-05-15 14:28:23');
INSERT INTO `operation_log` VALUES (81, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores/analysis', '', '{\"code\":200,\"data\":{\"courseAnalysis\":[],\"trend\":[],\"distribution\":{\"fail\":0,\"excellent\":0,\"pass\":0,\"medium\":0,\"good\":0}},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 8, 1, NULL, '2026-05-15 14:28:24');
INSERT INTO `operation_log` VALUES (82, NULL, 'anonymous', 'anonymous', 'QUERY', 'COURSE', '查询课程信息', 'GET', '/api/courses', '', '{\"code\":200,\"data\":[{\"courseCode\":\"CS101\",\"courseName\":\"Java程序设计\",\"createTime\":1776408197000,\"credit\":4.0,\"description\":\"Java基础与面向对象编程\",\"hours\":64,\"id\":1,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS102\",\"courseName\":\"数据结构与算法\",\"createTime\":1776408197000,\"credit\":3.5,\"description\":\"常用数据结构与算法分析\",\"hours\":56,\"id\":2,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS103\",\"courseName\":\"数据库原理\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"关系型数据库设计与SQL\",\"hours\":48,\"id\":3,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS104\",\"courseName\":\"Web前端开发\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"HTML、CSS、JavaScript基础\",\"hours\":48,\"id\":4,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS105\",\"courseName\":\"vue3\",\"createTime\":1776426873000,\"credit\":5.0,\"description\":\"good\\n\",\"hours\":16,\"id\":5,\"teacherId\":3,\"teacherName\":\"李老师\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 3, 1, NULL, '2026-05-15 14:28:25');
INSERT INTO `operation_log` VALUES (83, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores/rank/course/1', '1', '{\"code\":200,\"data\":[],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 3, 1, NULL, '2026-05-15 14:28:25');
INSERT INTO `operation_log` VALUES (84, NULL, 'anonymous', 'anonymous', 'QUERY', 'COURSE', '查询课程信息', 'GET', '/api/courses', '', '{\"code\":200,\"data\":[{\"courseCode\":\"CS101\",\"courseName\":\"Java程序设计\",\"createTime\":1776408197000,\"credit\":4.0,\"description\":\"Java基础与面向对象编程\",\"hours\":64,\"id\":1,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS102\",\"courseName\":\"数据结构与算法\",\"createTime\":1776408197000,\"credit\":3.5,\"description\":\"常用数据结构与算法分析\",\"hours\":56,\"id\":2,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS103\",\"courseName\":\"数据库原理\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"关系型数据库设计与SQL\",\"hours\":48,\"id\":3,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS104\",\"courseName\":\"Web前端开发\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"HTML、CSS、JavaScript基础\",\"hours\":48,\"id\":4,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS105\",\"courseName\":\"vue3\",\"createTime\":1776426873000,\"credit\":5.0,\"description\":\"good\\n\",\"hours\":16,\"id\":5,\"teacherId\":3,\"teacherName\":\"李老师\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 5, 1, NULL, '2026-05-15 14:28:27');
INSERT INTO `operation_log` VALUES (85, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores', '{\"examType\":\"\",\"pageNum\":1,\"pageSize\":10,\"studentName\":\"\"}', '{\"code\":200,\"data\":{\"list\":[],\"pageNum\":1,\"pageSize\":10,\"pages\":0,\"total\":0},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 9, 1, NULL, '2026-05-15 14:28:27');
INSERT INTO `operation_log` VALUES (86, NULL, 'anonymous', 'anonymous', 'QUERY', 'STUDENT', '查询学生信息', 'GET', '/api/students', '{\"pageNum\":1,\"pageSize\":1000}', '{\"code\":200,\"data\":{\"list\":[{\"address\":\"四川遂宁\",\"age\":21,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778826437000,\"email\":\"2113267199@qq.com\",\"enrollmentDate\":1778688000000,\"gender\":\"男\",\"id\":207,\"name\":\"QQH\",\"phone\":\"18848328887\",\"studentNo\":\"20210001\",\"studentStatus\":\"毕业\",\"updateTime\":1778826437000},{\"age\":20,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778682512000,\"email\":\"test@example.com\",\"enrollmentDate\":1725120000000,\"gender\":\"男\",\"id\":206,\"name\":\"测试学生\",\"phone\":\"13800138000\",\"studentNo\":\"TEST001\",\"studentStatus\":\"在读\",\"updateTime\":1778682512000},{\"address\":\"上海市浦东新区63号\",\"age\":18,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003012@example.com\",\"enrollmentDate\":1721318400000,\"gender\":\"女\",\"id\":117,\"name\":\"朱蕾\",\"phone\":\"15240480157\",\"studentNo\":\"2024003012\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市朝阳区92号\",\"age\":22,\"classId\":2,\"className\":\"计算机2班\",\"createTime\":1776901643000,\"email\":\"student2024002028@example.com\",\"enrollmentDate\":1708099200000,\"gender\":\"男\",\"id\":83,\"name\":\"孔刚\",\"phone\":\"19725461688\",\"studentNo\":\"2024002028\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"上海市浦东新区73号\",\"age\":18,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003014@example.com\",\"enrollmentDate\":1705075200000,\"gender\":\"男\",\"id\":119,\"name\":\"卞波\",\"phone\":\"14681567209\",\"studentNo\":\"2024003014\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市朝阳区26号\",\"age\":20,\"classId\":2,\"className\":\"计算机2班\",\"createTime\":1776901643000,\"email\":\"student2024002030@example.com\",\"enrollmentDate\":1716480000000,\"gender\":\"男\",\"id\":85,\"name\":\"鲁健\",\"phone\":\"14231443425\",\"studentNo\":\"2024002030\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"上海市浦东新区50号\",\"age\":18,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003016@example.com\",\"enrollmentDate\":1689436800000,\"gender\":\"女\",\"id\":121,\"name\":\"尹婷\",\"phone\":\"14834209237\",\"studentNo\":\"2024003016\",\"studentStatus\":\"在读\",\"updat...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 44, 1, NULL, '2026-05-15 14:28:27');
INSERT INTO `operation_log` VALUES (87, NULL, 'anonymous', 'anonymous', 'QUERY', 'COURSE', '查询课程信息', 'GET', '/api/courses', '', '{\"code\":200,\"data\":[{\"courseCode\":\"CS101\",\"courseName\":\"Java程序设计\",\"createTime\":1776408197000,\"credit\":4.0,\"description\":\"Java基础与面向对象编程\",\"hours\":64,\"id\":1,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS102\",\"courseName\":\"数据结构与算法\",\"createTime\":1776408197000,\"credit\":3.5,\"description\":\"常用数据结构与算法分析\",\"hours\":56,\"id\":2,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS103\",\"courseName\":\"数据库原理\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"关系型数据库设计与SQL\",\"hours\":48,\"id\":3,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS104\",\"courseName\":\"Web前端开发\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"HTML、CSS、JavaScript基础\",\"hours\":48,\"id\":4,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS105\",\"courseName\":\"vue3\",\"createTime\":1776426873000,\"credit\":5.0,\"description\":\"good\\n\",\"hours\":16,\"id\":5,\"teacherId\":3,\"teacherName\":\"李老师\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 2, 1, NULL, '2026-05-15 14:28:33');
INSERT INTO `operation_log` VALUES (88, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores/rank/course/1', '1', '{\"code\":200,\"data\":[],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 3, 1, NULL, '2026-05-15 14:28:33');
INSERT INTO `operation_log` VALUES (89, NULL, 'anonymous', 'anonymous', 'QUERY', 'COURSE', '查询课程信息', 'GET', '/api/courses', '', '{\"code\":200,\"data\":[{\"courseCode\":\"CS101\",\"courseName\":\"Java程序设计\",\"createTime\":1776408197000,\"credit\":4.0,\"description\":\"Java基础与面向对象编程\",\"hours\":64,\"id\":1,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS102\",\"courseName\":\"数据结构与算法\",\"createTime\":1776408197000,\"credit\":3.5,\"description\":\"常用数据结构与算法分析\",\"hours\":56,\"id\":2,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS103\",\"courseName\":\"数据库原理\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"关系型数据库设计与SQL\",\"hours\":48,\"id\":3,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS104\",\"courseName\":\"Web前端开发\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"HTML、CSS、JavaScript基础\",\"hours\":48,\"id\":4,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS105\",\"courseName\":\"vue3\",\"createTime\":1776426873000,\"credit\":5.0,\"description\":\"good\\n\",\"hours\":16,\"id\":5,\"teacherId\":3,\"teacherName\":\"李老师\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 6, 1, NULL, '2026-05-15 14:28:33');
INSERT INTO `operation_log` VALUES (90, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores', '{\"examType\":\"\",\"pageNum\":1,\"pageSize\":10,\"studentName\":\"\"}', '{\"code\":200,\"data\":{\"list\":[],\"pageNum\":1,\"pageSize\":10,\"pages\":0,\"total\":0},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 7, 1, NULL, '2026-05-15 14:28:33');
INSERT INTO `operation_log` VALUES (91, NULL, 'anonymous', 'anonymous', 'QUERY', 'STUDENT', '查询学生信息', 'GET', '/api/students', '{\"pageNum\":1,\"pageSize\":1000}', '{\"code\":200,\"data\":{\"list\":[{\"address\":\"四川遂宁\",\"age\":21,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778826437000,\"email\":\"2113267199@qq.com\",\"enrollmentDate\":1778688000000,\"gender\":\"男\",\"id\":207,\"name\":\"QQH\",\"phone\":\"18848328887\",\"studentNo\":\"20210001\",\"studentStatus\":\"毕业\",\"updateTime\":1778826437000},{\"age\":20,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778682512000,\"email\":\"test@example.com\",\"enrollmentDate\":1725120000000,\"gender\":\"男\",\"id\":206,\"name\":\"测试学生\",\"phone\":\"13800138000\",\"studentNo\":\"TEST001\",\"studentStatus\":\"在读\",\"updateTime\":1778682512000},{\"address\":\"上海市浦东新区63号\",\"age\":18,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003012@example.com\",\"enrollmentDate\":1721318400000,\"gender\":\"女\",\"id\":117,\"name\":\"朱蕾\",\"phone\":\"15240480157\",\"studentNo\":\"2024003012\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市朝阳区92号\",\"age\":22,\"classId\":2,\"className\":\"计算机2班\",\"createTime\":1776901643000,\"email\":\"student2024002028@example.com\",\"enrollmentDate\":1708099200000,\"gender\":\"男\",\"id\":83,\"name\":\"孔刚\",\"phone\":\"19725461688\",\"studentNo\":\"2024002028\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"上海市浦东新区73号\",\"age\":18,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003014@example.com\",\"enrollmentDate\":1705075200000,\"gender\":\"男\",\"id\":119,\"name\":\"卞波\",\"phone\":\"14681567209\",\"studentNo\":\"2024003014\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市朝阳区26号\",\"age\":20,\"classId\":2,\"className\":\"计算机2班\",\"createTime\":1776901643000,\"email\":\"student2024002030@example.com\",\"enrollmentDate\":1716480000000,\"gender\":\"男\",\"id\":85,\"name\":\"鲁健\",\"phone\":\"14231443425\",\"studentNo\":\"2024002030\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"上海市浦东新区50号\",\"age\":18,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003016@example.com\",\"enrollmentDate\":1689436800000,\"gender\":\"女\",\"id\":121,\"name\":\"尹婷\",\"phone\":\"14834209237\",\"studentNo\":\"2024003016\",\"studentStatus\":\"在读\",\"updat...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 45, 1, NULL, '2026-05-15 14:28:33');
INSERT INTO `operation_log` VALUES (92, NULL, 'anonymous', 'anonymous', 'QUERY', 'COURSE', '查询课程信息', 'GET', '/api/courses', '', '{\"code\":200,\"data\":[{\"courseCode\":\"CS101\",\"courseName\":\"Java程序设计\",\"createTime\":1776408197000,\"credit\":4.0,\"description\":\"Java基础与面向对象编程\",\"hours\":64,\"id\":1,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS102\",\"courseName\":\"数据结构与算法\",\"createTime\":1776408197000,\"credit\":3.5,\"description\":\"常用数据结构与算法分析\",\"hours\":56,\"id\":2,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS103\",\"courseName\":\"数据库原理\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"关系型数据库设计与SQL\",\"hours\":48,\"id\":3,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS104\",\"courseName\":\"Web前端开发\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"HTML、CSS、JavaScript基础\",\"hours\":48,\"id\":4,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS105\",\"courseName\":\"vue3\",\"createTime\":1776426873000,\"credit\":5.0,\"description\":\"good\\n\",\"hours\":16,\"id\":5,\"teacherId\":3,\"teacherName\":\"李老师\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 7, 1, NULL, '2026-05-15 15:00:15');
INSERT INTO `operation_log` VALUES (93, NULL, 'anonymous', 'anonymous', 'QUERY', 'CLASS', '查询班级信息', 'GET', '/api/classes', '', '{\"code\":200,\"data\":[{\"className\":\"计算机1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":1,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"软件工程1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":3,\"major\":\"软件工程\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"计算机2班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":2,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"className\":\"软件高级班\",\"createTime\":1776862287000,\"grade\":\"2021级\",\"id\":4,\"major\":\"软件技术\",\"studentCount\":0,\"teacherId\":4,\"teacherName\":\"何坤坤\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 34, 1, NULL, '2026-05-15 15:00:18');
INSERT INTO `operation_log` VALUES (94, NULL, 'anonymous', 'anonymous', 'QUERY', 'CLASS', '查询班级信息', 'GET', '/api/classes', '', '{\"code\":200,\"data\":[{\"className\":\"计算机1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":1,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"软件工程1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":3,\"major\":\"软件工程\",\"studentCount\":0,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"计算机2班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":2,\"major\":\"计算机科学与技术\",\"studentCount\":0,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"className\":\"软件高级班\",\"createTime\":1776862287000,\"grade\":\"2021级\",\"id\":4,\"major\":\"软件技术\",\"studentCount\":0,\"teacherId\":4,\"teacherName\":\"何坤坤\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 6, 1, NULL, '2026-05-15 15:00:21');
INSERT INTO `operation_log` VALUES (95, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/statistics', '', '{\"code\":200,\"data\":{\"classDistribution\":{\"软件高级班\":50,\"计算机1班\":52,\"计算机2班\":50,\"软件工程1班\":50},\"genderDistribution\":{\"女\":97,\"男\":105},\"statusDistribution\":{\"在读\":200,\"毕业\":2},\"totalClasses\":4,\"totalCourses\":5,\"totalStudents\":202,\"totalUsers\":3},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 110, 1, NULL, '2026-05-15 16:33:12');
INSERT INTO `operation_log` VALUES (96, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores/statistics', '', '{\"code\":200,\"data\":{\"passRate\":94.79,\"courseAverageScores\":[{\"courseName\":\"Java程序设计\",\"averageScore\":77.597030},{\"courseName\":\"数据结构与算法\",\"averageScore\":77.553795},{\"courseName\":\"数据库原理\",\"averageScore\":77.948515},{\"courseName\":\"Web前端开发\",\"averageScore\":77.160561},{\"courseName\":\"vue3\",\"averageScore\":78.063696}]},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 15, 1, NULL, '2026-05-15 16:33:13');
INSERT INTO `operation_log` VALUES (97, NULL, 'anonymous', 'anonymous', 'INSERT', 'AUTH', '登录系统数据', 'POST', '/api/auth/login', '{\"password\":\"admin123\",\"username\":\"admin\"}', '{\"code\":200,\"data\":{\"realName\":\"管理员\",\"role\":\"admin\",\"id\":1,\"token\":\"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsInJvbGUiOiJhZG1pbiIsImlhdCI6MTc3ODgzNDAwMywiZXhwIjoxNzc4OTIwNDAzfQ.OLzpz3SB06xsMVeF0EhkRT5hpr1ZlyojQwbv5ISBHlhOCCmPWN7lLQOIxWtedVMveHsVlC989K2VaIUk6ka6xw\",\"username\":\"admin\"},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 18, 1, NULL, '2026-05-15 16:33:23');
INSERT INTO `operation_log` VALUES (98, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/statistics', '', '{\"code\":200,\"data\":{\"classDistribution\":{\"软件高级班\":50,\"计算机1班\":52,\"计算机2班\":50,\"软件工程1班\":50},\"genderDistribution\":{\"女\":97,\"男\":105},\"statusDistribution\":{\"在读\":200,\"毕业\":2},\"totalClasses\":4,\"totalCourses\":5,\"totalStudents\":202,\"totalUsers\":3},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 21, 1, NULL, '2026-05-15 16:33:23');
INSERT INTO `operation_log` VALUES (99, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores/statistics', '', '{\"code\":200,\"data\":{\"passRate\":94.79,\"courseAverageScores\":[{\"courseName\":\"Java程序设计\",\"averageScore\":77.597030},{\"courseName\":\"数据结构与算法\",\"averageScore\":77.553795},{\"courseName\":\"数据库原理\",\"averageScore\":77.948515},{\"courseName\":\"Web前端开发\",\"averageScore\":77.160561},{\"courseName\":\"vue3\",\"averageScore\":78.063696}]},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 14, 1, NULL, '2026-05-15 16:33:23');
INSERT INTO `operation_log` VALUES (100, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/statistics', '', '{\"code\":200,\"data\":{\"classDistribution\":{\"软件高级班\":50,\"计算机1班\":52,\"计算机2班\":50,\"软件工程1班\":50},\"genderDistribution\":{\"女\":97,\"男\":105},\"statusDistribution\":{\"在读\":200,\"毕业\":2},\"totalClasses\":4,\"totalCourses\":5,\"totalStudents\":202,\"totalUsers\":3},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 26, 1, NULL, '2026-05-15 16:33:33');
INSERT INTO `operation_log` VALUES (101, NULL, 'anonymous', 'anonymous', 'QUERY', 'CLASS', '查询班级信息', 'GET', '/api/classes', '', '{\"code\":200,\"data\":[{\"className\":\"计算机1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":1,\"major\":\"计算机科学与技术\",\"studentCount\":52,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"软件工程1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":3,\"major\":\"软件工程\",\"studentCount\":50,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"计算机2班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":2,\"major\":\"计算机科学与技术\",\"studentCount\":50,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"className\":\"软件高级班\",\"createTime\":1776862287000,\"grade\":\"2021级\",\"id\":4,\"major\":\"软件技术\",\"studentCount\":50,\"teacherId\":4,\"teacherName\":\"何坤坤\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 16, 1, NULL, '2026-05-15 16:33:34');
INSERT INTO `operation_log` VALUES (102, NULL, 'anonymous', 'anonymous', 'QUERY', 'STUDENT', '查询学生信息', 'GET', '/api/students', '{\"gender\":\"\",\"name\":\"\",\"pageNum\":1,\"pageSize\":10,\"studentNo\":\"\",\"studentStatus\":\"\"}', '{\"code\":200,\"data\":{\"list\":[{\"address\":\"四川遂宁\",\"age\":21,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778826437000,\"email\":\"2113267199@qq.com\",\"enrollmentDate\":1778688000000,\"gender\":\"男\",\"id\":207,\"name\":\"QQH\",\"phone\":\"18848328887\",\"studentNo\":\"20210001\",\"studentStatus\":\"毕业\",\"updateTime\":1778826437000},{\"age\":20,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778682512000,\"email\":\"test@example.com\",\"enrollmentDate\":1725120000000,\"gender\":\"男\",\"id\":206,\"name\":\"测试学生\",\"phone\":\"13800138000\",\"studentNo\":\"TEST001\",\"studentStatus\":\"在读\",\"updateTime\":1778682512000},{\"address\":\"上海市浦东新区80号\",\"age\":20,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003010@example.com\",\"enrollmentDate\":1699804800000,\"gender\":\"男\",\"id\":115,\"name\":\"何辰\",\"phone\":\"14884585779\",\"studentNo\":\"2024003010\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市朝阳区84号\",\"age\":22,\"classId\":2,\"className\":\"计算机2班\",\"createTime\":1776901643000,\"email\":\"student2024002026@example.com\",\"enrollmentDate\":1741276800000,\"gender\":\"男\",\"id\":81,\"name\":\"费峰\",\"phone\":\"19401600313\",\"studentNo\":\"2024002026\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"上海市浦东新区63号\",\"age\":18,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003012@example.com\",\"enrollmentDate\":1721318400000,\"gender\":\"女\",\"id\":117,\"name\":\"朱蕾\",\"phone\":\"15240480157\",\"studentNo\":\"2024003012\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市朝阳区92号\",\"age\":22,\"classId\":2,\"className\":\"计算机2班\",\"createTime\":1776901643000,\"email\":\"student2024002028@example.com\",\"enrollmentDate\":1708099200000,\"gender\":\"男\",\"id\":83,\"name\":\"孔刚\",\"phone\":\"19725461688\",\"studentNo\":\"2024002028\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"上海市浦东新区73号\",\"age\":18,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003014@example.com\",\"enrollmentDate\":1705075200000,\"gender\":\"男\",\"id\":119,\"name\":\"卞波\",\"phone\":\"14681567209\",\"studentNo\":\"2024003014\",\"studentStatus\":\"在读\",\"updat...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 120, 1, NULL, '2026-05-15 16:33:34');
INSERT INTO `operation_log` VALUES (103, NULL, 'anonymous', 'anonymous', 'QUERY', 'CLASS', '查询班级信息', 'GET', '/api/classes', '', '{\"code\":200,\"data\":[{\"className\":\"计算机1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":1,\"major\":\"计算机科学与技术\",\"studentCount\":52,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"软件工程1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":3,\"major\":\"软件工程\",\"studentCount\":50,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"计算机2班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":2,\"major\":\"计算机科学与技术\",\"studentCount\":50,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"className\":\"软件高级班\",\"createTime\":1776862287000,\"grade\":\"2021级\",\"id\":4,\"major\":\"软件技术\",\"studentCount\":50,\"teacherId\":4,\"teacherName\":\"何坤坤\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 5, 1, NULL, '2026-05-15 16:33:35');
INSERT INTO `operation_log` VALUES (104, NULL, 'anonymous', 'anonymous', 'QUERY', 'COURSE', '查询课程信息', 'GET', '/api/courses', '', '{\"code\":200,\"data\":[{\"courseCode\":\"CS101\",\"courseName\":\"Java程序设计\",\"createTime\":1776408197000,\"credit\":4.0,\"description\":\"Java基础与面向对象编程\",\"hours\":64,\"id\":1,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS102\",\"courseName\":\"数据结构与算法\",\"createTime\":1776408197000,\"credit\":3.5,\"description\":\"常用数据结构与算法分析\",\"hours\":56,\"id\":2,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS103\",\"courseName\":\"数据库原理\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"关系型数据库设计与SQL\",\"hours\":48,\"id\":3,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS104\",\"courseName\":\"Web前端开发\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"HTML、CSS、JavaScript基础\",\"hours\":48,\"id\":4,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS105\",\"courseName\":\"vue3\",\"createTime\":1776426873000,\"credit\":5.0,\"description\":\"good\\n\",\"hours\":16,\"id\":5,\"teacherId\":3,\"teacherName\":\"李老师\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 14, 1, NULL, '2026-05-15 16:33:36');
INSERT INTO `operation_log` VALUES (105, NULL, 'anonymous', 'anonymous', 'QUERY', 'COURSE', '查询课程信息', 'GET', '/api/courses', '', '{\"code\":200,\"data\":[{\"courseCode\":\"CS101\",\"courseName\":\"Java程序设计\",\"createTime\":1776408197000,\"credit\":4.0,\"description\":\"Java基础与面向对象编程\",\"hours\":64,\"id\":1,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS102\",\"courseName\":\"数据结构与算法\",\"createTime\":1776408197000,\"credit\":3.5,\"description\":\"常用数据结构与算法分析\",\"hours\":56,\"id\":2,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS103\",\"courseName\":\"数据库原理\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"关系型数据库设计与SQL\",\"hours\":48,\"id\":3,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS104\",\"courseName\":\"Web前端开发\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"HTML、CSS、JavaScript基础\",\"hours\":48,\"id\":4,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS105\",\"courseName\":\"vue3\",\"createTime\":1776426873000,\"credit\":5.0,\"description\":\"good\\n\",\"hours\":16,\"id\":5,\"teacherId\":3,\"teacherName\":\"李老师\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 7, 1, NULL, '2026-05-15 16:33:37');
INSERT INTO `operation_log` VALUES (106, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores', '{\"examType\":\"\",\"pageNum\":1,\"pageSize\":10,\"studentName\":\"\"}', '{\"code\":200,\"data\":{\"list\":[{\"courseId\":1,\"courseName\":\"Java程序设计\",\"createTime\":1778833794000,\"examDate\":1719763200000,\"examType\":\"期末\",\"id\":470,\"remark\":\"2023-2024学年第二学期期末成绩\",\"score\":87.70,\"studentId\":97,\"studentName\":\"傅平\",\"studentNo\":\"2024002042\",\"updateTime\":1778833794000},{\"courseId\":2,\"courseName\":\"数据结构与算法\",\"createTime\":1778833794000,\"examDate\":1719763200000,\"examType\":\"期末\",\"id\":536,\"remark\":\"2023-2024学年第二学期期末成绩\",\"score\":98.30,\"studentId\":110,\"studentName\":\"范凯\",\"studentNo\":\"2024003005\",\"updateTime\":1778833794000},{\"courseId\":5,\"courseName\":\"vue3\",\"createTime\":1778833794000,\"examDate\":1718380800000,\"examType\":\"平时\",\"id\":2225,\"remark\":\"2023-2024学年第二学期平时成绩\",\"score\":93.90,\"studentId\":38,\"studentName\":\"邹明\",\"studentNo\":\"2024001031\",\"updateTime\":1778833794000},{\"courseId\":3,\"courseName\":\"数据库原理\",\"createTime\":1778833794000,\"examDate\":1718380800000,\"examType\":\"平时\",\"id\":2813,\"remark\":\"2023-2024学年第二学期平时成绩\",\"score\":81.90,\"studentId\":156,\"studentName\":\"薛静\",\"studentNo\":\"2024004001\",\"updateTime\":1778833794000},{\"courseId\":1,\"courseName\":\"Java程序设计\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1688,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":56.80,\"studentId\":136,\"studentName\":\"穆明轩\",\"studentNo\":\"2024003031\",\"updateTime\":1778833794000},{\"courseId\":2,\"courseName\":\"数据结构与算法\",\"createTime\":1778833794000,\"examDate\":1719763200000,\"examType\":\"期末\",\"id\":336,\"remark\":\"2023-2024学年第二学期期末成绩\",\"score\":64.90,\"studentId\":70,\"studentName\":\"潘婷\",\"studentNo\":\"2024002015\",\"updateTime\":1778833794000},{\"courseId\":5,\"courseName\":\"vue3\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":2012,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":61.70,\"studentId\":200,\"studentName\":\"邬雪\",\"studentNo\":\"2024004045\",\"updateTime\":1778833794000},{\"courseId\":3,\"courseName\":\"数据库原理\",\"createTime\":1778833794000,\"examDate\":1718380800000,\"examType\":\"平时\",\"id\":2613,\"remark\":\"2023-2024学年第二学期平时成绩\",\"score\":90.00,\"studentId\":116,\"studentName\":\"罗宇\",\"studentNo\":\"2024003011\",\"updateTime\":1778833794000},{...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 30, 1, NULL, '2026-05-15 16:33:37');
INSERT INTO `operation_log` VALUES (107, NULL, 'anonymous', 'anonymous', 'QUERY', 'STUDENT', '查询学生信息', 'GET', '/api/students', '{\"pageNum\":1,\"pageSize\":1000}', '{\"code\":200,\"data\":{\"list\":[{\"address\":\"四川遂宁\",\"age\":21,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778826437000,\"email\":\"2113267199@qq.com\",\"enrollmentDate\":1778688000000,\"gender\":\"男\",\"id\":207,\"name\":\"QQH\",\"phone\":\"18848328887\",\"studentNo\":\"20210001\",\"studentStatus\":\"毕业\",\"updateTime\":1778826437000},{\"age\":20,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778682512000,\"email\":\"test@example.com\",\"enrollmentDate\":1725120000000,\"gender\":\"男\",\"id\":206,\"name\":\"测试学生\",\"phone\":\"13800138000\",\"studentNo\":\"TEST001\",\"studentStatus\":\"在读\",\"updateTime\":1778682512000},{\"address\":\"广州市天河区5号\",\"age\":21,\"classId\":4,\"className\":\"软件高级班\",\"createTime\":1776901643000,\"email\":\"student2024004029@example.com\",\"enrollmentDate\":1703088000000,\"gender\":\"男\",\"id\":184,\"name\":\"喻斌\",\"phone\":\"17171979466\",\"studentNo\":\"2024004029\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"上海市浦东新区91号\",\"age\":18,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003045@example.com\",\"enrollmentDate\":1720108800000,\"gender\":\"男\",\"id\":150,\"name\":\"孔浩\",\"phone\":\"17274314561\",\"studentNo\":\"2024003045\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"广州市天河区46号\",\"age\":18,\"classId\":4,\"className\":\"软件高级班\",\"createTime\":1776901643000,\"email\":\"student2024004031@example.com\",\"enrollmentDate\":1689782400000,\"gender\":\"男\",\"id\":186,\"name\":\"施宇航\",\"phone\":\"19569055075\",\"studentNo\":\"2024004031\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"上海市浦东新区47号\",\"age\":20,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003047@example.com\",\"enrollmentDate\":1727539200000,\"gender\":\"男\",\"id\":152,\"name\":\"尹波\",\"phone\":\"13253157396\",\"studentNo\":\"2024003047\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"广州市天河区13号\",\"age\":22,\"classId\":4,\"className\":\"软件高级班\",\"createTime\":1776901643000,\"email\":\"student2024004033@example.com\",\"enrollmentDate\":1684339200000,\"gender\":\"女\",\"id\":188,\"name\":\"王琳\",\"phone\":\"17520724331\",\"studentNo\":\"2024004033\",\"studentStatus\":\"在读\",\"updat...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 196, 1, NULL, '2026-05-15 16:33:37');
INSERT INTO `operation_log` VALUES (108, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores', '{\"examType\":\"\",\"pageNum\":6,\"pageSize\":10,\"studentName\":\"\"}', '{\"code\":200,\"data\":{\"list\":[{\"courseId\":5,\"courseName\":\"vue3\",\"createTime\":1778833794000,\"examDate\":1718380800000,\"examType\":\"平时\",\"id\":2530,\"remark\":\"2023-2024学年第二学期平时成绩\",\"score\":71.20,\"studentId\":99,\"studentName\":\"傅秀\",\"studentNo\":\"2024002044\",\"updateTime\":1778833794000},{\"courseId\":4,\"courseName\":\"Web前端开发\",\"createTime\":1778833794000,\"examDate\":1718380800000,\"examType\":\"平时\",\"id\":2599,\"remark\":\"2023-2024学年第二学期平时成绩\",\"score\":91.30,\"studentId\":113,\"studentName\":\"华波\",\"studentNo\":\"2024003008\",\"updateTime\":1778833794000},{\"courseId\":1,\"courseName\":\"Java程序设计\",\"createTime\":1778833794000,\"examDate\":1719763200000,\"examType\":\"期末\",\"id\":730,\"remark\":\"2023-2024学年第二学期期末成绩\",\"score\":87.70,\"studentId\":149,\"studentName\":\"金杰\",\"studentNo\":\"2024003044\",\"updateTime\":1778833794000},{\"courseId\":1,\"courseName\":\"Java程序设计\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1948,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":65.40,\"studentId\":188,\"studentName\":\"王琳\",\"studentNo\":\"2024004033\",\"updateTime\":1778833794000},{\"courseId\":1,\"courseName\":\"Java程序设计\",\"createTime\":1778833794000,\"examDate\":1719763200000,\"examType\":\"期末\",\"id\":530,\"remark\":\"2023-2024学年第二学期期末成绩\",\"score\":75.10,\"studentId\":109,\"studentName\":\"穆敏敏\",\"studentNo\":\"2024003004\",\"updateTime\":1778833794000},{\"courseId\":2,\"courseName\":\"数据结构与算法\",\"createTime\":1778833794000,\"examDate\":1719763200000,\"examType\":\"期末\",\"id\":596,\"remark\":\"2023-2024学年第二学期期末成绩\",\"score\":64.20,\"studentId\":122,\"studentName\":\"余蕾\",\"studentNo\":\"2024003017\",\"updateTime\":1778833794000},{\"courseId\":1,\"courseName\":\"Java程序设计\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1748,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":70.50,\"studentId\":148,\"studentName\":\"许伟\",\"studentNo\":\"2024003043\",\"updateTime\":1778833794000},{\"courseId\":2,\"courseName\":\"数据结构与算法\",\"createTime\":1778833794000,\"examDate\":1719763200000,\"examType\":\"期末\",\"id\":396,\"remark\":\"2023-2024学年第二学期期末成绩\",\"score\":88.00,\"studentId\":82,\"studentName\":\"郎静静\",\"studentNo\":\"2024002027\",\"updateTime\":177883...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 70, 1, NULL, '2026-05-15 16:33:40');
INSERT INTO `operation_log` VALUES (109, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores', '{\"examType\":\"\",\"pageNum\":303,\"pageSize\":10,\"studentName\":\"\"}', '{\"code\":200,\"data\":{\"list\":[{\"courseId\":3,\"courseName\":\"数据库原理\",\"createTime\":1778833794000,\"examDate\":1718380800000,\"examType\":\"平时\",\"id\":2138,\"remark\":\"2023-2024学年第二学期平时成绩\",\"score\":88.80,\"studentId\":21,\"studentName\":\"伍蕾\",\"studentNo\":\"2024001014\",\"updateTime\":1778833794000},{\"courseId\":4,\"courseName\":\"Web前端开发\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1241,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":75.20,\"studentId\":46,\"studentName\":\"史琳\",\"studentNo\":\"2024001039\",\"updateTime\":1778833794000},{\"courseId\":3,\"courseName\":\"数据库原理\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1645,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":58.10,\"studentId\":127,\"studentName\":\"于超\",\"studentNo\":\"2024003022\",\"updateTime\":1778833794000},{\"courseId\":1,\"courseName\":\"Java程序设计\",\"createTime\":1778833794000,\"examDate\":1718380800000,\"examType\":\"平时\",\"id\":3011,\"remark\":\"2023-2024学年第二学期平时成绩\",\"score\":76.80,\"studentId\":196,\"studentName\":\"潘伟\",\"studentNo\":\"2024004041\",\"updateTime\":1778833794000},{\"courseId\":5,\"courseName\":\"vue3\",\"createTime\":1778833794000,\"examDate\":1718380800000,\"examType\":\"平时\",\"id\":2555,\"remark\":\"2023-2024学年第二学期平时成绩\",\"score\":76.30,\"studentId\":104,\"studentName\":\"袁芳芳\",\"studentNo\":\"2024002049\",\"updateTime\":1778833794000},{\"courseId\":4,\"courseName\":\"Web前端开发\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1556,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":83.30,\"studentId\":109,\"studentName\":\"穆敏敏\",\"studentNo\":\"2024003004\",\"updateTime\":1778833794000},{\"courseId\":5,\"courseName\":\"vue3\",\"createTime\":1778833794000,\"examDate\":1719763200000,\"examType\":\"期末\",\"id\":659,\"remark\":\"2023-2024学年第二学期期末成绩\",\"score\":79.60,\"studentId\":134,\"studentName\":\"章珊\",\"studentNo\":\"2024003029\",\"updateTime\":1778833794000},{\"courseId\":1,\"courseName\":\"Java程序设计\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1743,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":78.60,\"studentId\":147,\"studentName\":\"陶建\",\"studentNo\":\"2024003042\",\"updateTime\":177883379400...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 25, 1, NULL, '2026-05-15 16:33:40');
INSERT INTO `operation_log` VALUES (110, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores', '{\"examType\":\"\",\"pageNum\":301,\"pageSize\":10,\"studentName\":\"\"}', '{\"code\":200,\"data\":{\"list\":[{\"courseId\":2,\"courseName\":\"数据结构与算法\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1524,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":73.20,\"studentId\":103,\"studentName\":\"许静静\",\"studentNo\":\"2024002048\",\"updateTime\":1778833794000},{\"courseId\":3,\"courseName\":\"数据库原理\",\"createTime\":1778833794000,\"examDate\":1718380800000,\"examType\":\"平时\",\"id\":2118,\"remark\":\"2023-2024学年第二学期平时成绩\",\"score\":74.60,\"studentId\":17,\"studentName\":\"沈宇\",\"studentNo\":\"2024001010\",\"updateTime\":1778833794000},{\"courseId\":4,\"courseName\":\"Web前端开发\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1221,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":89.40,\"studentId\":42,\"studentName\":\"史昊\",\"studentNo\":\"2024001035\",\"updateTime\":1778833794000},{\"courseId\":3,\"courseName\":\"数据库原理\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1625,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":77.80,\"studentId\":123,\"studentName\":\"元峰\",\"studentNo\":\"2024003018\",\"updateTime\":1778833794000},{\"courseId\":4,\"courseName\":\"Web前端开发\",\"createTime\":1778833794000,\"examDate\":1718380800000,\"examType\":\"平时\",\"id\":2299,\"remark\":\"2023-2024学年第二学期平时成绩\",\"score\":74.80,\"studentId\":53,\"studentName\":\"严明\",\"studentNo\":\"2024001046\",\"updateTime\":1778833794000},{\"courseId\":5,\"courseName\":\"vue3\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1402,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":73.80,\"studentId\":78,\"studentName\":\"许珊\",\"studentNo\":\"2024002023\",\"updateTime\":1778833794000},{\"courseId\":5,\"courseName\":\"vue3\",\"createTime\":1778833794000,\"examDate\":1718380800000,\"examType\":\"平时\",\"id\":2240,\"remark\":\"2023-2024学年第二学期平时成绩\",\"score\":88.80,\"studentId\":41,\"studentName\":\"许燕\",\"studentNo\":\"2024001034\",\"updateTime\":1778833794000},{\"courseId\":3,\"courseName\":\"数据库原理\",\"createTime\":1778833794000,\"examDate\":1718380800000,\"examType\":\"平时\",\"id\":2828,\"remark\":\"2023-2024学年第二学期平时成绩\",\"score\":77.70,\"studentId\":159,\"studentName\":\"韦婷\",\"studentNo\":\"2024004004\",\"updateTime\":1778833794000},{\"co...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 21, 1, NULL, '2026-05-15 16:33:41');
INSERT INTO `operation_log` VALUES (111, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores', '{\"examType\":\"\",\"pageNum\":300,\"pageSize\":10,\"studentName\":\"\"}', '{\"code\":200,\"data\":{\"list\":[{\"courseId\":1,\"courseName\":\"Java程序设计\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1703,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":88.70,\"studentId\":139,\"studentName\":\"孙丽丽\",\"studentNo\":\"2024003034\",\"updateTime\":1778833794000},{\"courseId\":3,\"courseName\":\"数据库原理\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1885,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":68.10,\"studentId\":175,\"studentName\":\"金军\",\"studentNo\":\"2024004020\",\"updateTime\":1778833794000},{\"courseId\":4,\"courseName\":\"Web前端开发\",\"createTime\":1778833794000,\"examDate\":1719763200000,\"examType\":\"期末\",\"id\":988,\"remark\":\"2023-2024学年第二学期期末成绩\",\"score\":98.40,\"studentId\":200,\"studentName\":\"邬雪\",\"studentNo\":\"2024004045\",\"updateTime\":1778833794000},{\"courseId\":4,\"courseName\":\"Web前端开发\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1316,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":92.20,\"studentId\":61,\"studentName\":\"鲁斌\",\"studentNo\":\"2024002006\",\"updateTime\":1778833794000},{\"courseId\":5,\"courseName\":\"vue3\",\"createTime\":1778833794000,\"examDate\":1719763200000,\"examType\":\"期末\",\"id\":419,\"remark\":\"2023-2024学年第二学期期末成绩\",\"score\":84.30,\"studentId\":86,\"studentName\":\"卫明\",\"studentNo\":\"2024002031\",\"updateTime\":1778833794000},{\"courseId\":2,\"courseName\":\"数据结构与算法\",\"createTime\":1778833794000,\"examDate\":1719763200000,\"examType\":\"期末\",\"id\":141,\"remark\":\"2023-2024学年第二学期期末成绩\",\"score\":84.80,\"studentId\":31,\"studentName\":\"曹颖颖\",\"studentNo\":\"2024001024\",\"updateTime\":1778833794000},{\"courseId\":2,\"courseName\":\"数据结构与算法\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1724,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":74.90,\"studentId\":143,\"studentName\":\"奚洁\",\"studentNo\":\"2024003038\",\"updateTime\":1778833794000},{\"courseId\":1,\"courseName\":\"Java程序设计\",\"createTime\":1778833794000,\"examDate\":1718380800000,\"examType\":\"平时\",\"id\":2476,\"remark\":\"2023-2024学年第二学期平时成绩\",\"score\":86.60,\"studentId\":89,\"studentName\":\"谢明轩\",\"studentNo\":\"2024002034\",\"updateTime\":1778833794...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 31, 1, NULL, '2026-05-15 16:33:42');
INSERT INTO `operation_log` VALUES (112, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores', '{\"examType\":\"\",\"pageNum\":299,\"pageSize\":10,\"studentName\":\"\"}', '{\"code\":200,\"data\":{\"list\":[{\"courseId\":4,\"courseName\":\"Web前端开发\",\"createTime\":1778833794000,\"examDate\":1718380800000,\"examType\":\"平时\",\"id\":2479,\"remark\":\"2023-2024学年第二学期平时成绩\",\"score\":94.20,\"studentId\":89,\"studentName\":\"谢明轩\",\"studentNo\":\"2024002034\",\"updateTime\":1778833794000},{\"courseId\":5,\"courseName\":\"vue3\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1582,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":55.80,\"studentId\":114,\"studentName\":\"罗梅\",\"studentNo\":\"2024003009\",\"updateTime\":1778833794000},{\"courseId\":1,\"courseName\":\"Java程序设计\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1903,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":61.70,\"studentId\":179,\"studentName\":\"朱蕾\",\"studentNo\":\"2024004024\",\"updateTime\":1778833794000},{\"courseId\":3,\"courseName\":\"数据库原理\",\"createTime\":1778833794000,\"examDate\":1718380800000,\"examType\":\"平时\",\"id\":2098,\"remark\":\"2023-2024学年第二学期平时成绩\",\"score\":88.80,\"studentId\":13,\"studentName\":\"穆军\",\"studentNo\":\"2024001006\",\"updateTime\":1778833794000},{\"courseId\":4,\"courseName\":\"Web前端开发\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1201,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":61.70,\"studentId\":38,\"studentName\":\"邹明\",\"studentNo\":\"2024001031\",\"updateTime\":1778833794000},{\"courseId\":3,\"courseName\":\"数据库原理\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1605,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":55.00,\"studentId\":119,\"studentName\":\"卞波\",\"studentNo\":\"2024003014\",\"updateTime\":1778833794000},{\"courseId\":4,\"courseName\":\"Web前端开发\",\"createTime\":1778833794000,\"examDate\":1718380800000,\"examType\":\"平时\",\"id\":2279,\"remark\":\"2023-2024学年第二学期平时成绩\",\"score\":81.10,\"studentId\":49,\"studentName\":\"姜强\",\"studentNo\":\"2024001042\",\"updateTime\":1778833794000},{\"courseId\":5,\"courseName\":\"vue3\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1382,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":59.70,\"studentId\":74,\"studentName\":\"蒋娜\",\"studentNo\":\"2024002019\",\"updateTime\":1778833794000},{...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 28, 1, NULL, '2026-05-15 16:33:42');
INSERT INTO `operation_log` VALUES (113, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores', '{\"examType\":\"\",\"pageNum\":298,\"pageSize\":10,\"studentName\":\"\"}', '{\"code\":200,\"data\":{\"list\":[{\"courseId\":5,\"courseName\":\"vue3\",\"createTime\":1778833794000,\"examDate\":1719763200000,\"examType\":\"期末\",\"id\":199,\"remark\":\"2023-2024学年第二学期期末成绩\",\"score\":67.00,\"studentId\":42,\"studentName\":\"史昊\",\"studentNo\":\"2024001035\",\"updateTime\":1778833794000},{\"courseId\":1,\"courseName\":\"Java程序设计\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1283,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":77.00,\"studentId\":55,\"studentName\":\"贺明轩\",\"studentNo\":\"2024001048\",\"updateTime\":1778833794000},{\"courseId\":3,\"courseName\":\"数据库原理\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1465,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":55.30,\"studentId\":91,\"studentName\":\"卫娜\",\"studentNo\":\"2024002036\",\"updateTime\":1778833794000},{\"courseId\":4,\"courseName\":\"Web前端开发\",\"createTime\":1778833794000,\"examDate\":1719763200000,\"examType\":\"期末\",\"id\":568,\"remark\":\"2023-2024学年第二学期期末成绩\",\"score\":64.00,\"studentId\":116,\"studentName\":\"罗宇\",\"studentNo\":\"2024003011\",\"updateTime\":1778833794000},{\"courseId\":4,\"courseName\":\"Web前端开发\",\"createTime\":1778833794000,\"examDate\":1718380800000,\"examType\":\"平时\",\"id\":2534,\"remark\":\"2023-2024学年第二学期平时成绩\",\"score\":71.80,\"studentId\":100,\"studentName\":\"赵玲\",\"studentNo\":\"2024002045\",\"updateTime\":1778833794000},{\"courseId\":2,\"courseName\":\"数据结构与算法\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1504,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":74.80,\"studentId\":99,\"studentName\":\"傅秀\",\"studentNo\":\"2024002044\",\"updateTime\":1778833794000},{\"courseId\":1,\"courseName\":\"Java程序设计\",\"createTime\":1778833794000,\"examDate\":1718380800000,\"examType\":\"平时\",\"id\":2256,\"remark\":\"2023-2024学年第二学期平时成绩\",\"score\":75.70,\"studentId\":45,\"studentName\":\"安莹\",\"studentNo\":\"2024001038\",\"updateTime\":1778833794000},{\"courseId\":2,\"courseName\":\"数据结构与算法\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1304,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":89.70,\"studentId\":59,\"studentName\":\"廉洁\",\"studentNo\":\"2024002004\",\"updateTime\":1778833794000...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 28, 1, NULL, '2026-05-15 16:33:42');
INSERT INTO `operation_log` VALUES (114, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores', '{\"examType\":\"\",\"pageNum\":296,\"pageSize\":10,\"studentName\":\"\"}', '{\"code\":200,\"data\":{\"list\":[{\"courseId\":3,\"courseName\":\"数据库原理\",\"createTime\":1778833794000,\"examDate\":1718380800000,\"examType\":\"平时\",\"id\":2768,\"remark\":\"2023-2024学年第二学期平时成绩\",\"score\":74.10,\"studentId\":147,\"studentName\":\"陶建\",\"studentNo\":\"2024003042\",\"updateTime\":1778833794000},{\"courseId\":1,\"courseName\":\"Java程序设计\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1263,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":62.70,\"studentId\":51,\"studentName\":\"褚伟\",\"studentNo\":\"2024001044\",\"updateTime\":1778833794000},{\"courseId\":3,\"courseName\":\"数据库原理\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1845,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":66.90,\"studentId\":167,\"studentName\":\"俞华\",\"studentNo\":\"2024004012\",\"updateTime\":1778833794000},{\"courseId\":4,\"courseName\":\"Web前端开发\",\"createTime\":1778833794000,\"examDate\":1719763200000,\"examType\":\"期末\",\"id\":948,\"remark\":\"2023-2024学年第二学期期末成绩\",\"score\":60.70,\"studentId\":192,\"studentName\":\"周霞\",\"studentNo\":\"2024004037\",\"updateTime\":1778833794000},{\"courseId\":3,\"courseName\":\"数据库原理\",\"createTime\":1778833794000,\"examDate\":1719763200000,\"examType\":\"期末\",\"id\":592,\"remark\":\"2023-2024学年第二学期期末成绩\",\"score\":60.90,\"studentId\":121,\"studentName\":\"尹婷\",\"studentNo\":\"2024003016\",\"updateTime\":1778833794000},{\"courseId\":3,\"courseName\":\"数据库原理\",\"createTime\":1778833794000,\"examDate\":1718380800000,\"examType\":\"平时\",\"id\":2568,\"remark\":\"2023-2024学年第二学期平时成绩\",\"score\":74.10,\"studentId\":107,\"studentName\":\"赵强\",\"studentNo\":\"2024003002\",\"updateTime\":1778833794000},{\"courseId\":2,\"courseName\":\"数据结构与算法\",\"createTime\":1778833794000,\"examDate\":1719763200000,\"examType\":\"期末\",\"id\":271,\"remark\":\"2023-2024学年第二学期期末成绩\",\"score\":88.00,\"studentId\":57,\"studentName\":\"朱凯\",\"studentNo\":\"2024002002\",\"updateTime\":1778833794000},{\"courseId\":3,\"courseName\":\"数据库原理\",\"createTime\":1778833794000,\"examDate\":1719763200000,\"examType\":\"期末\",\"id\":392,\"remark\":\"2023-2024学年第二学期期末成绩\",\"score\":60.70,\"studentId\":81,\"studentName\":\"费峰\",\"studentNo\":\"2024002026\",\"updateTime\":1778833794000},{\"co...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 23, 1, NULL, '2026-05-15 16:33:43');
INSERT INTO `operation_log` VALUES (115, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores/analysis', '', '{\"code\":200,\"data\":{\"courseAnalysis\":[{\"fail\":35,\"courseName\":\"Java程序设计\",\"minScore\":55.20,\"excellent\":81,\"pass\":110,\"medium\":195,\"maxScore\":98.90,\"good\":185,\"averageScore\":77.597030},{\"fail\":26,\"courseName\":\"数据结构与算法\",\"minScore\":55.00,\"excellent\":74,\"pass\":115,\"medium\":206,\"maxScore\":99.40,\"good\":185,\"averageScore\":77.553795},{\"fail\":25,\"courseName\":\"数据库原理\",\"minScore\":55.00,\"excellent\":92,\"pass\":125,\"medium\":183,\"maxScore\":98.20,\"good\":181,\"averageScore\":77.948515},{\"fail\":36,\"courseName\":\"Web前端开发\",\"minScore\":55.20,\"excellent\":70,\"pass\":114,\"medium\":195,\"maxScore\":99.90,\"good\":191,\"averageScore\":77.160561},{\"fail\":36,\"courseName\":\"vue3\",\"minScore\":55.10,\"excellent\":90,\"pass\":117,\"medium\":168,\"maxScore\":99.80,\"good\":195,\"averageScore\":78.063696}],\"trend\":[],\"distribution\":{\"fail\":158,\"excellent\":407,\"pass\":581,\"medium\":947,\"good\":937}},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 20, 1, NULL, '2026-05-15 16:33:45');
INSERT INTO `operation_log` VALUES (116, NULL, 'anonymous', 'anonymous', 'QUERY', 'COURSE', '查询课程信息', 'GET', '/api/courses', '', '{\"code\":200,\"data\":[{\"courseCode\":\"CS101\",\"courseName\":\"Java程序设计\",\"createTime\":1776408197000,\"credit\":4.0,\"description\":\"Java基础与面向对象编程\",\"hours\":64,\"id\":1,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS102\",\"courseName\":\"数据结构与算法\",\"createTime\":1776408197000,\"credit\":3.5,\"description\":\"常用数据结构与算法分析\",\"hours\":56,\"id\":2,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"courseCode\":\"CS103\",\"courseName\":\"数据库原理\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"关系型数据库设计与SQL\",\"hours\":48,\"id\":3,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS104\",\"courseName\":\"Web前端开发\",\"createTime\":1776408197000,\"credit\":3.0,\"description\":\"HTML、CSS、JavaScript基础\",\"hours\":48,\"id\":4,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"courseCode\":\"CS105\",\"courseName\":\"vue3\",\"createTime\":1776426873000,\"credit\":5.0,\"description\":\"good\\n\",\"hours\":16,\"id\":5,\"teacherId\":3,\"teacherName\":\"李老师\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 8, 1, NULL, '2026-05-15 16:33:53');
INSERT INTO `operation_log` VALUES (117, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores', '{\"examType\":\"\",\"pageNum\":1,\"pageSize\":10,\"studentName\":\"\"}', '{\"code\":200,\"data\":{\"list\":[{\"courseId\":1,\"courseName\":\"Java程序设计\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1858,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":57.80,\"studentId\":170,\"studentName\":\"韦瑶\",\"studentNo\":\"2024004015\",\"updateTime\":1778833794000},{\"courseId\":3,\"courseName\":\"数据库原理\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1095,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":80.00,\"studentId\":17,\"studentName\":\"沈宇\",\"studentNo\":\"2024001010\",\"updateTime\":1778833794000},{\"courseId\":1,\"courseName\":\"Java程序设计\",\"createTime\":1778833794000,\"examDate\":1719763200000,\"examType\":\"期末\",\"id\":475,\"remark\":\"2023-2024学年第二学期期末成绩\",\"score\":95.20,\"studentId\":98,\"studentName\":\"喻子轩\",\"studentNo\":\"2024002043\",\"updateTime\":1778833794000},{\"courseId\":1,\"courseName\":\"Java程序设计\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1658,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":56.70,\"studentId\":130,\"studentName\":\"戚颖颖\",\"studentNo\":\"2024003025\",\"updateTime\":1778833794000},{\"courseId\":4,\"courseName\":\"Web前端开发\",\"createTime\":1778833794000,\"examDate\":1719763200000,\"examType\":\"期末\",\"id\":433,\"remark\":\"2023-2024学年第二学期期末成绩\",\"score\":86.90,\"studentId\":89,\"studentName\":\"谢明轩\",\"studentNo\":\"2024002034\",\"updateTime\":1778833794000},{\"courseId\":2,\"courseName\":\"数据结构与算法\",\"createTime\":1778833794000,\"examDate\":1714492800000,\"examType\":\"期中\",\"id\":1759,\"remark\":\"2023-2024学年第二学期期中成绩\",\"score\":68.30,\"studentId\":150,\"studentName\":\"孔浩\",\"studentNo\":\"2024003045\",\"updateTime\":1778833794000},{\"courseId\":5,\"courseName\":\"vue3\",\"createTime\":1778833794000,\"examDate\":1718380800000,\"examType\":\"平时\",\"id\":2215,\"remark\":\"2023-2024学年第二学期平时成绩\",\"score\":96.30,\"studentId\":36,\"studentName\":\"鲍洋\",\"studentNo\":\"2024001029\",\"updateTime\":1778833794000},{\"courseId\":3,\"courseName\":\"数据库原理\",\"createTime\":1778833794000,\"examDate\":1718380800000,\"examType\":\"平时\",\"id\":2803,\"remark\":\"2023-2024学年第二学期平时成绩\",\"score\":94.20,\"studentId\":154,\"studentName\":\"苗倩\",\"studentNo\":\"2024003049\",\"updateTime\":1778833794...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 24, 1, NULL, '2026-05-15 16:33:53');
INSERT INTO `operation_log` VALUES (118, NULL, 'anonymous', 'anonymous', 'QUERY', 'STUDENT', '查询学生信息', 'GET', '/api/students', '{\"pageNum\":1,\"pageSize\":1000}', '{\"code\":200,\"data\":{\"list\":[{\"address\":\"四川遂宁\",\"age\":21,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778826437000,\"email\":\"2113267199@qq.com\",\"enrollmentDate\":1778688000000,\"gender\":\"男\",\"id\":207,\"name\":\"QQH\",\"phone\":\"18848328887\",\"studentNo\":\"20210001\",\"studentStatus\":\"毕业\",\"updateTime\":1778826437000},{\"age\":20,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778682512000,\"email\":\"test@example.com\",\"enrollmentDate\":1725120000000,\"gender\":\"男\",\"id\":206,\"name\":\"测试学生\",\"phone\":\"13800138000\",\"studentNo\":\"TEST001\",\"studentStatus\":\"在读\",\"updateTime\":1778682512000},{\"address\":\"北京市朝阳区40号\",\"age\":23,\"classId\":2,\"className\":\"计算机2班\",\"createTime\":1776901643000,\"email\":\"student2024002025@example.com\",\"enrollmentDate\":1741363200000,\"gender\":\"男\",\"id\":80,\"name\":\"葛睿\",\"phone\":\"16363708679\",\"studentNo\":\"2024002025\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"上海市浦东新区70号\",\"age\":20,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003011@example.com\",\"enrollmentDate\":1733068800000,\"gender\":\"男\",\"id\":116,\"name\":\"罗宇\",\"phone\":\"18381875568\",\"studentNo\":\"2024003011\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市朝阳区13号\",\"age\":23,\"classId\":2,\"className\":\"计算机2班\",\"createTime\":1776901643000,\"email\":\"student2024002027@example.com\",\"enrollmentDate\":1744732800000,\"gender\":\"女\",\"id\":82,\"name\":\"郎静静\",\"phone\":\"14796298429\",\"studentNo\":\"2024002027\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"上海市浦东新区87号\",\"age\":20,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003013@example.com\",\"enrollmentDate\":1683129600000,\"gender\":\"男\",\"id\":118,\"name\":\"冯凯\",\"phone\":\"14620759555\",\"studentNo\":\"2024003013\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市朝阳区75号\",\"age\":20,\"classId\":2,\"className\":\"计算机2班\",\"createTime\":1776901643000,\"email\":\"student2024002029@example.com\",\"enrollmentDate\":1717257600000,\"gender\":\"女\",\"id\":84,\"name\":\"伍敏\",\"phone\":\"17520545916\",\"studentNo\":\"2024002029\",\"studentStatus\":\"在读\",\"updateT...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 62, 1, NULL, '2026-05-15 16:33:53');
INSERT INTO `operation_log` VALUES (119, NULL, 'anonymous', 'anonymous', 'INSERT', 'AUTH', '登录系统数据', 'POST', '/api/auth/login', '{\"password\":\"admin123\",\"username\":\"admin\"}', '{\"code\":200,\"data\":{\"realName\":\"管理员\",\"role\":\"admin\",\"id\":1,\"token\":\"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsInJvbGUiOiJhZG1pbiIsImlhdCI6MTc3OTc4MTQyMCwiZXhwIjoxNzc5ODY3ODIwfQ.vqw5ImwQ62g2f0qivLXvmhSMcC7TyOwuwycIIdFcF16oD_6dQ8vt-3ounSOecXZSEKYXc4kS4u7Eg04nQRs3jQ\",\"username\":\"admin\"},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 374, 1, NULL, '2026-05-26 15:43:40');
INSERT INTO `operation_log` VALUES (120, NULL, 'anonymous', 'anonymous', 'INSERT', 'AUTH', '登录系统数据', 'POST', '/api/auth/login', '{\"password\":\"admin123\",\"username\":\"admin\"}', '{\"code\":200,\"data\":{\"realName\":\"管理员\",\"role\":\"admin\",\"id\":1,\"token\":\"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsInJvbGUiOiJhZG1pbiIsImlhdCI6MTc3OTc4MTQyMCwiZXhwIjoxNzc5ODY3ODIwfQ.vqw5ImwQ62g2f0qivLXvmhSMcC7TyOwuwycIIdFcF16oD_6dQ8vt-3ounSOecXZSEKYXc4kS4u7Eg04nQRs3jQ\",\"username\":\"admin\"},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 374, 1, NULL, '2026-05-26 15:43:40');
INSERT INTO `operation_log` VALUES (121, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/statistics', '', '{\"code\":200,\"data\":{\"classDistribution\":{\"软件高级班\":50,\"计算机1班\":52,\"计算机2班\":50,\"软件工程1班\":50},\"genderDistribution\":{\"女\":97,\"男\":105},\"statusDistribution\":{\"在读\":200,\"毕业\":2},\"totalClasses\":4,\"totalCourses\":5,\"totalStudents\":202,\"totalUsers\":3},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 74, 1, NULL, '2026-05-26 15:43:41');
INSERT INTO `operation_log` VALUES (122, NULL, 'anonymous', 'anonymous', 'QUERY', 'SCORE', '查询成绩信息', 'GET', '/api/scores/statistics', '', '{\"code\":200,\"data\":{\"passRate\":94.79,\"courseAverageScores\":[{\"courseName\":\"Java程序设计\",\"averageScore\":77.597030},{\"courseName\":\"数据结构与算法\",\"averageScore\":77.553795},{\"courseName\":\"数据库原理\",\"averageScore\":77.948515},{\"courseName\":\"Web前端开发\",\"averageScore\":77.160561},{\"courseName\":\"vue3\",\"averageScore\":78.063696}]},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 44, 1, NULL, '2026-05-26 15:43:41');
INSERT INTO `operation_log` VALUES (123, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/statistics', '', '{\"code\":200,\"data\":{\"classDistribution\":{\"软件高级班\":50,\"计算机1班\":52,\"计算机2班\":50,\"软件工程1班\":50},\"genderDistribution\":{\"女\":97,\"男\":105},\"statusDistribution\":{\"在读\":200,\"毕业\":2},\"totalClasses\":4,\"totalCourses\":5,\"totalStudents\":202,\"totalUsers\":3},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 28, 1, NULL, '2026-05-26 15:43:49');
INSERT INTO `operation_log` VALUES (124, NULL, 'anonymous', 'anonymous', 'QUERY', 'CLASS', '查询班级信息', 'GET', '/api/classes', '', '{\"code\":200,\"data\":[{\"className\":\"计算机1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":1,\"major\":\"计算机科学与技术\",\"studentCount\":52,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"软件工程1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":3,\"major\":\"软件工程\",\"studentCount\":50,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"计算机2班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":2,\"major\":\"计算机科学与技术\",\"studentCount\":50,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"className\":\"软件高级班\",\"createTime\":1776862287000,\"grade\":\"2021级\",\"id\":4,\"major\":\"软件技术\",\"studentCount\":50,\"teacherId\":4,\"teacherName\":\"何坤坤\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 16, 1, NULL, '2026-05-26 15:43:53');
INSERT INTO `operation_log` VALUES (125, NULL, 'anonymous', 'anonymous', 'QUERY', 'STUDENT', '查询学生信息', 'GET', '/api/students', '{\"gender\":\"\",\"name\":\"\",\"pageNum\":1,\"pageSize\":10,\"studentNo\":\"\",\"studentStatus\":\"\"}', '{\"code\":200,\"data\":{\"list\":[{\"address\":\"四川遂宁\",\"age\":21,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778826437000,\"email\":\"2113267199@qq.com\",\"enrollmentDate\":1778688000000,\"gender\":\"男\",\"id\":207,\"name\":\"QQH\",\"phone\":\"18848328887\",\"studentNo\":\"20210001\",\"studentStatus\":\"毕业\",\"updateTime\":1778826437000},{\"age\":20,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778682512000,\"email\":\"test@example.com\",\"enrollmentDate\":1725120000000,\"gender\":\"男\",\"id\":206,\"name\":\"测试学生\",\"phone\":\"13800138000\",\"studentNo\":\"TEST001\",\"studentStatus\":\"在读\",\"updateTime\":1778682512000},{\"address\":\"广州市天河区52号\",\"age\":20,\"classId\":4,\"className\":\"软件高级班\",\"createTime\":1776901643000,\"email\":\"student2024004050@example.com\",\"enrollmentDate\":1735228800000,\"gender\":\"男\",\"id\":205,\"name\":\"倪皓\",\"phone\":\"17332760699\",\"studentNo\":\"2024004050\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"上海市浦东新区95号\",\"age\":23,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003019@example.com\",\"enrollmentDate\":1741363200000,\"gender\":\"男\",\"id\":124,\"name\":\"曹俊杰\",\"phone\":\"16859797776\",\"studentNo\":\"2024003019\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市朝阳区90号\",\"age\":19,\"classId\":2,\"className\":\"计算机2班\",\"createTime\":1776901643000,\"email\":\"student2024002035@example.com\",\"enrollmentDate\":1719763200000,\"gender\":\"女\",\"id\":90,\"name\":\"葛娜娜\",\"phone\":\"19236225726\",\"studentNo\":\"2024002035\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"上海市浦东新区50号\",\"age\":20,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003021@example.com\",\"enrollmentDate\":1684339200000,\"gender\":\"男\",\"id\":126,\"name\":\"姜凯\",\"phone\":\"16605641424\",\"studentNo\":\"2024003021\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市朝阳区58号\",\"age\":20,\"classId\":2,\"className\":\"计算机2班\",\"createTime\":1776901643000,\"email\":\"student2024002037@example.com\",\"enrollmentDate\":1713974400000,\"gender\":\"女\",\"id\":92,\"name\":\"彭蕾\",\"phone\":\"19638072103\",\"studentNo\":\"2024002037\",\"studentStatus\":\"在读\",\"updat...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 153, 1, NULL, '2026-05-26 15:43:53');
INSERT INTO `operation_log` VALUES (126, NULL, 'anonymous', 'anonymous', 'INSERT', 'AUTH', '登录系统数据', 'POST', '/api/auth/login', '{\"password\":\"210001\",\"username\":\"QQH\"}', '{\"code\":401,\"message\":\"用户名或密码错误\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 11, 1, NULL, '2026-05-26 15:44:15');
INSERT INTO `operation_log` VALUES (127, NULL, 'anonymous', 'anonymous', 'INSERT', 'AUTH', '登录系统数据', 'POST', '/api/auth/login', '{\"password\":\"123456\",\"username\":\"210001\"}', '{\"code\":401,\"message\":\"用户名或密码错误\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 5, 1, NULL, '2026-05-26 15:44:23');
INSERT INTO `operation_log` VALUES (128, NULL, 'anonymous', 'anonymous', 'INSERT', 'AUTH', '登录系统数据', 'POST', '/api/auth/login', '{\"password\":\"admin123\",\"username\":\"admin \"}', '{\"code\":200,\"data\":{\"realName\":\"管理员\",\"role\":\"admin\",\"id\":1,\"token\":\"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsInJvbGUiOiJhZG1pbiIsImlhdCI6MTc3OTc4MTQ3NCwiZXhwIjoxNzc5ODY3ODc0fQ.3DsHEq36LSpBv-Bv9wuE_vxWO1e_aIRE-NU4yjobuhVwfuZ4AldmChPcKbRZx74fiSDu7YaistezrunNuIel5g\",\"username\":\"admin\"},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 6, 1, NULL, '2026-05-26 15:44:34');
INSERT INTO `operation_log` VALUES (129, NULL, 'anonymous', 'anonymous', 'INSERT', 'AUTH', '登录系统数据', 'POST', '/api/auth/login', '{\"password\":\"admin123\",\"username\":\"admin \"}', '{\"code\":200,\"data\":{\"realName\":\"管理员\",\"role\":\"admin\",\"id\":1,\"token\":\"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsInJvbGUiOiJhZG1pbiIsImlhdCI6MTc3OTc4MTQ3NCwiZXhwIjoxNzc5ODY3ODc0fQ.3DsHEq36LSpBv-Bv9wuE_vxWO1e_aIRE-NU4yjobuhVwfuZ4AldmChPcKbRZx74fiSDu7YaistezrunNuIel5g\",\"username\":\"admin\"},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 6, 1, NULL, '2026-05-26 15:44:34');
INSERT INTO `operation_log` VALUES (130, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/statistics', '', '{\"code\":200,\"data\":{\"classDistribution\":{\"软件高级班\":50,\"计算机1班\":52,\"计算机2班\":50,\"软件工程1班\":50},\"genderDistribution\":{\"女\":97,\"男\":105},\"statusDistribution\":{\"在读\":200,\"毕业\":2},\"totalClasses\":4,\"totalCourses\":5,\"totalStudents\":202,\"totalUsers\":3},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 21, 1, NULL, '2026-05-26 15:44:34');
INSERT INTO `operation_log` VALUES (131, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/statistics', '', '{\"code\":200,\"data\":{\"classDistribution\":{\"软件高级班\":50,\"计算机1班\":52,\"计算机2班\":50,\"软件工程1班\":50},\"genderDistribution\":{\"女\":97,\"男\":105},\"statusDistribution\":{\"在读\":200,\"毕业\":2},\"totalClasses\":4,\"totalCourses\":5,\"totalStudents\":202,\"totalUsers\":3},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 31, 1, NULL, '2026-05-26 15:44:40');
INSERT INTO `operation_log` VALUES (132, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/statistics', '', '{\"code\":200,\"data\":{\"classDistribution\":{\"软件高级班\":50,\"计算机1班\":52,\"计算机2班\":50,\"软件工程1班\":50},\"genderDistribution\":{\"女\":97,\"男\":105},\"statusDistribution\":{\"在读\":200,\"毕业\":2},\"totalClasses\":4,\"totalCourses\":5,\"totalStudents\":202,\"totalUsers\":3},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 25, 1, NULL, '2026-05-26 15:44:40');
INSERT INTO `operation_log` VALUES (133, NULL, 'anonymous', 'anonymous', 'QUERY', 'CLASS', '查询班级信息', 'GET', '/api/classes', '', '{\"code\":200,\"data\":[{\"className\":\"计算机1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":1,\"major\":\"计算机科学与技术\",\"studentCount\":52,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"软件工程1班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":3,\"major\":\"软件工程\",\"studentCount\":50,\"teacherId\":2,\"teacherName\":\"张老师\"},{\"className\":\"计算机2班\",\"createTime\":1776408197000,\"grade\":\"2023级\",\"id\":2,\"major\":\"计算机科学与技术\",\"studentCount\":50,\"teacherId\":3,\"teacherName\":\"李老师\"},{\"className\":\"软件高级班\",\"createTime\":1776862287000,\"grade\":\"2021级\",\"id\":4,\"major\":\"软件技术\",\"studentCount\":50,\"teacherId\":4,\"teacherName\":\"何坤坤\"}],\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 12, 1, NULL, '2026-05-26 15:44:41');
INSERT INTO `operation_log` VALUES (134, NULL, 'anonymous', 'anonymous', 'QUERY', 'STUDENT', '查询学生信息', 'GET', '/api/students', '{\"gender\":\"\",\"name\":\"\",\"pageNum\":1,\"pageSize\":10,\"studentNo\":\"\",\"studentStatus\":\"\"}', '{\"code\":200,\"data\":{\"list\":[{\"address\":\"四川遂宁\",\"age\":21,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778826437000,\"email\":\"2113267199@qq.com\",\"enrollmentDate\":1778688000000,\"gender\":\"男\",\"id\":207,\"name\":\"QQH\",\"phone\":\"18848328887\",\"studentNo\":\"20210001\",\"studentStatus\":\"毕业\",\"updateTime\":1778826437000},{\"age\":20,\"classId\":1,\"className\":\"计算机1班\",\"createTime\":1778682512000,\"email\":\"test@example.com\",\"enrollmentDate\":1725120000000,\"gender\":\"男\",\"id\":206,\"name\":\"测试学生\",\"phone\":\"13800138000\",\"studentNo\":\"TEST001\",\"studentStatus\":\"在读\",\"updateTime\":1778682512000},{\"address\":\"广州市天河区52号\",\"age\":20,\"classId\":4,\"className\":\"软件高级班\",\"createTime\":1776901643000,\"email\":\"student2024004050@example.com\",\"enrollmentDate\":1735228800000,\"gender\":\"男\",\"id\":205,\"name\":\"倪皓\",\"phone\":\"17332760699\",\"studentNo\":\"2024004050\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"上海市浦东新区90号\",\"age\":19,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003023@example.com\",\"enrollmentDate\":1744560000000,\"gender\":\"女\",\"id\":128,\"name\":\"柏华\",\"phone\":\"14540485114\",\"studentNo\":\"2024003023\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市朝阳区5号\",\"age\":21,\"classId\":2,\"className\":\"计算机2班\",\"createTime\":1776901643000,\"email\":\"student2024002039@example.com\",\"enrollmentDate\":1709481600000,\"gender\":\"男\",\"id\":94,\"name\":\"常刚\",\"phone\":\"18418146769\",\"studentNo\":\"2024002039\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"上海市浦东新区74号\",\"age\":21,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003025@example.com\",\"enrollmentDate\":1728230400000,\"gender\":\"女\",\"id\":130,\"name\":\"戚颖颖\",\"phone\":\"13946305969\",\"studentNo\":\"2024003025\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000},{\"address\":\"北京市朝阳区95号\",\"age\":18,\"classId\":2,\"className\":\"计算机2班\",\"createTime\":1776901643000,\"email\":\"student2024002041@example.com\",\"enrollmentDate\":1725379200000,\"gender\":\"男\",\"id\":96,\"name\":\"凤军\",\"phone\":\"17671220247\",\"studentNo\":\"2024002041\",\"studentStatus\":\"在读\",\"updateT...', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 22, 1, NULL, '2026-05-26 15:44:41');
INSERT INTO `operation_log` VALUES (135, NULL, 'anonymous', 'anonymous', 'QUERY', 'STUDENT', '查询学生信息', 'GET', '/api/students', '{\"gender\":\"\",\"name\":\"何\",\"pageNum\":1,\"pageSize\":10,\"studentNo\":\"\",\"studentStatus\":\"\"}', '{\"code\":200,\"data\":{\"list\":[{\"address\":\"上海市浦东新区80号\",\"age\":20,\"classId\":3,\"className\":\"软件工程1班\",\"createTime\":1776901643000,\"email\":\"student2024003010@example.com\",\"enrollmentDate\":1699804800000,\"gender\":\"男\",\"id\":115,\"name\":\"何辰\",\"phone\":\"14884585779\",\"studentNo\":\"2024003010\",\"studentStatus\":\"在读\",\"updateTime\":1776901643000}],\"pageNum\":1,\"pageSize\":10,\"pages\":1,\"total\":1},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 16, 1, NULL, '2026-05-26 15:44:50');
INSERT INTO `operation_log` VALUES (136, NULL, 'anonymous', 'anonymous', 'INSERT', 'AUTH', '登录系统数据', 'POST', '/api/auth/login', '{\"password\":\"123456\",\"username\":\"2024003010\"}', '{\"code\":200,\"data\":{\"studentId\":115,\"realName\":\"何辰\",\"role\":\"student\",\"token\":\"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyMDI0MDAzMDEwIiwicm9sZSI6InN0dWRlbnQiLCJpYXQiOjE3Nzk3ODE1MDQsImV4cCI6MTc3OTg2NzkwNH0.2DXPvt74NdmcMSXlPjLgwMWpHcGaMqEDjZcazQJEp_w7uAQnm17VJ0toHYT4XWZIbyuqRCt586IlAZQilEhm4w\",\"username\":\"2024003010\"},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 12, 1, NULL, '2026-05-26 15:45:04');
INSERT INTO `operation_log` VALUES (137, NULL, 'anonymous', 'anonymous', 'INSERT', 'AUTH', '登录系统数据', 'POST', '/api/auth/login', '{\"password\":\"123456\",\"username\":\"2024003010\"}', '{\"code\":200,\"data\":{\"studentId\":115,\"realName\":\"何辰\",\"role\":\"student\",\"token\":\"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyMDI0MDAzMDEwIiwicm9sZSI6InN0dWRlbnQiLCJpYXQiOjE3Nzk3ODE1MDQsImV4cCI6MTc3OTg2NzkwNH0.2DXPvt74NdmcMSXlPjLgwMWpHcGaMqEDjZcazQJEp_w7uAQnm17VJ0toHYT4XWZIbyuqRCt586IlAZQilEhm4w\",\"username\":\"2024003010\"},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 20, 1, NULL, '2026-05-26 15:45:04');
INSERT INTO `operation_log` VALUES (138, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/statistics', '', '{\"code\":200,\"data\":{\"classDistribution\":{\"软件高级班\":50,\"计算机1班\":52,\"计算机2班\":50,\"软件工程1班\":50},\"genderDistribution\":{\"女\":97,\"男\":105},\"statusDistribution\":{\"在读\":200,\"毕业\":2},\"totalClasses\":4,\"totalCourses\":5,\"totalStudents\":202,\"totalUsers\":3},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 17, 1, NULL, '2026-05-26 15:45:04');
INSERT INTO `operation_log` VALUES (139, NULL, 'anonymous', 'anonymous', 'QUERY', 'SYSTEM', '查询系统数据', 'GET', '/api/statistics', '', '{\"code\":200,\"data\":{\"classDistribution\":{\"软件高级班\":50,\"计算机1班\":52,\"计算机2班\":50,\"软件工程1班\":50},\"genderDistribution\":{\"女\":97,\"男\":105},\"statusDistribution\":{\"在读\":200,\"毕业\":2},\"totalClasses\":4,\"totalCourses\":5,\"totalStudents\":202,\"totalUsers\":3},\"message\":\"操作成功\"}', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 16, 1, NULL, '2026-05-26 15:45:10');

-- ----------------------------
-- Table structure for scholarship_record
-- ----------------------------
DROP TABLE IF EXISTS `scholarship_record`;
CREATE TABLE `scholarship_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `student_id` int(11) NOT NULL COMMENT '学生ID',
  `scholarship_type_id` int(11) NOT NULL COMMENT '奖学金类型ID',
  `academic_year` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '学年',
  `semester` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '学期',
  `gpa` decimal(3, 2) NULL DEFAULT NULL COMMENT '绩点',
  `ranking` int(11) NULL DEFAULT NULL COMMENT '班级排名',
  `total_score` decimal(5, 2) NULL DEFAULT NULL COMMENT '综合评分',
  `score_details` json NULL COMMENT '评分详情',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'PENDING' COMMENT '状态: PENDING-待审核, APPROVED-已通过, REJECTED-已拒绝',
  `reviewer_id` int(11) NULL DEFAULT NULL COMMENT '审核人ID',
  `review_remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '审核备注',
  `review_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_student_scholarship`(`student_id`, `scholarship_type_id`, `academic_year`, `semester`) USING BTREE,
  INDEX `scholarship_type_id`(`scholarship_type_id`) USING BTREE,
  INDEX `reviewer_id`(`reviewer_id`) USING BTREE,
  CONSTRAINT `scholarship_record_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `scholarship_record_ibfk_2` FOREIGN KEY (`scholarship_type_id`) REFERENCES `scholarship_type` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `scholarship_record_ibfk_3` FOREIGN KEY (`reviewer_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '奖学金评定记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of scholarship_record
-- ----------------------------
INSERT INTO `scholarship_record` VALUES (9, 7, 7, '2024-2025', '全年', NULL, NULL, NULL, NULL, 'PENDING', NULL, NULL, NULL, '2026-04-24 17:25:31', '2026-04-24 17:25:31');

-- ----------------------------
-- Table structure for scholarship_type
-- ----------------------------
DROP TABLE IF EXISTS `scholarship_type`;
CREATE TABLE `scholarship_type`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '奖学金类型ID',
  `type_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '奖学金名称',
  `type_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '奖学金代码',
  `amount` decimal(10, 2) NOT NULL COMMENT '奖学金额度',
  `quota` int(11) NULL DEFAULT NULL COMMENT '名额限制',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '奖学金描述',
  `requirements` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '评选条件',
  `academic_year` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '学年',
  `semester` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '学期',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `type_code`(`type_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '奖学金类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of scholarship_type
-- ----------------------------
INSERT INTO `scholarship_type` VALUES (7, 'EZ', 'koko', 1200.00, 2, '....', '优先', '2024-2025', '全年', 1, '2026-04-24 17:24:29', '2026-04-24 17:24:29');

-- ----------------------------
-- Table structure for score
-- ----------------------------
DROP TABLE IF EXISTS `score`;
CREATE TABLE `score`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '鎴愮哗ID',
  `student_id` int(11) NOT NULL COMMENT '瀛︾敓ID',
  `course_id` int(11) NOT NULL COMMENT '璇剧▼ID',
  `score` decimal(5, 2) NULL DEFAULT NULL COMMENT '鎴愮哗',
  `exam_date` date NULL DEFAULT NULL COMMENT '鑰冭瘯鏃ユ湡',
  `exam_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '鑰冭瘯绫诲瀷',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '澶囨敞',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_student_course`(`student_id`, `course_id`, `exam_type`) USING BTREE,
  INDEX `course_id`(`course_id`) USING BTREE,
  CONSTRAINT `score_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `score_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3071 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '鎴愮哗琛' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of score
-- ----------------------------
INSERT INTO `score` VALUES (15, 6, 1, 67.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (16, 6, 2, 80.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (17, 6, 3, 77.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (18, 6, 4, 75.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (19, 6, 5, 73.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (20, 7, 1, 98.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (21, 7, 2, 84.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (22, 7, 3, 94.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (23, 7, 4, 77.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (24, 7, 5, 69.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (25, 8, 1, 75.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (26, 8, 2, 85.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (27, 8, 3, 96.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (28, 8, 4, 67.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (29, 8, 5, 70.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (30, 9, 1, 96.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (31, 9, 2, 79.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (32, 9, 3, 73.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (33, 9, 4, 71.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (34, 9, 5, 77.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (35, 10, 1, 68.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (36, 10, 2, 91.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (37, 10, 3, 65.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (38, 10, 4, 80.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (39, 10, 5, 60.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (40, 11, 1, 80.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (41, 11, 2, 72.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (42, 11, 3, 80.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (43, 11, 4, 70.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (44, 11, 5, 65.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (45, 12, 1, 94.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (46, 12, 2, 85.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (47, 12, 3, 62.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (48, 12, 4, 68.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (49, 12, 5, 80.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (50, 13, 1, 64.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (51, 13, 2, 71.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (52, 13, 3, 62.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (53, 13, 4, 92.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (54, 13, 5, 76.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (55, 14, 1, 81.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (56, 14, 2, 89.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (57, 14, 3, 66.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (58, 14, 4, 80.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (59, 14, 5, 84.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (60, 15, 1, 71.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (61, 15, 2, 70.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (62, 15, 3, 62.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (63, 15, 4, 81.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (64, 15, 5, 75.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (65, 16, 1, 87.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (66, 16, 2, 78.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (67, 16, 3, 67.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (68, 16, 4, 80.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (69, 16, 5, 68.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (70, 17, 1, 85.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (71, 17, 2, 83.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (72, 17, 3, 91.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (73, 17, 4, 72.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (74, 17, 5, 86.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (75, 18, 1, 68.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (76, 18, 2, 66.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (77, 18, 3, 70.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (78, 18, 4, 61.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (79, 18, 5, 73.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (80, 19, 1, 70.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (81, 19, 2, 62.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (82, 19, 3, 94.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (83, 19, 4, 86.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (84, 19, 5, 74.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (85, 20, 1, 64.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (86, 20, 2, 70.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (87, 20, 3, 76.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (88, 20, 4, 68.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (89, 20, 5, 79.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (90, 21, 1, 88.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (91, 21, 2, 69.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (92, 21, 3, 64.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (93, 21, 4, 61.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (94, 21, 5, 84.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (95, 22, 1, 84.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (96, 22, 2, 93.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (97, 22, 3, 78.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (98, 22, 4, 60.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (99, 22, 5, 74.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (100, 23, 1, 93.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (101, 23, 2, 75.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (102, 23, 3, 85.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (103, 23, 4, 89.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (104, 23, 5, 86.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (105, 24, 1, 64.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (106, 24, 2, 92.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (107, 24, 3, 87.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (108, 24, 4, 66.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (109, 24, 5, 61.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (110, 25, 1, 92.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (111, 25, 2, 88.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (112, 25, 3, 62.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (113, 25, 4, 93.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (114, 25, 5, 67.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (115, 26, 1, 68.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (116, 26, 2, 72.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (117, 26, 3, 87.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (118, 26, 4, 96.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (119, 26, 5, 65.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (120, 27, 1, 67.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (121, 27, 2, 76.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (122, 27, 3, 83.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (123, 27, 4, 84.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (124, 27, 5, 90.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (125, 28, 1, 75.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (126, 28, 2, 84.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (127, 28, 3, 67.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (128, 28, 4, 62.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (129, 28, 5, 75.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (130, 29, 1, 72.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (131, 29, 2, 70.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (132, 29, 3, 84.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (133, 29, 4, 91.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (134, 29, 5, 69.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (135, 30, 1, 63.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (136, 30, 2, 84.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (137, 30, 3, 70.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (138, 30, 4, 72.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (139, 30, 5, 78.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (140, 31, 1, 90.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (141, 31, 2, 84.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (142, 31, 3, 70.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (143, 31, 4, 73.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (144, 31, 5, 77.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (145, 32, 1, 76.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (146, 32, 2, 96.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (147, 32, 3, 60.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (148, 32, 4, 80.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (149, 32, 5, 69.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (150, 33, 1, 92.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (151, 33, 2, 86.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (152, 33, 3, 79.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (153, 33, 4, 79.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (154, 33, 5, 71.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (155, 34, 1, 83.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (156, 34, 2, 85.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (157, 34, 3, 76.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (158, 34, 4, 86.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (159, 34, 5, 76.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (160, 35, 1, 81.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (161, 35, 2, 90.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (162, 35, 3, 86.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (163, 35, 4, 73.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (164, 35, 5, 97.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (165, 36, 1, 62.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (166, 36, 2, 71.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (167, 36, 3, 76.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (168, 36, 4, 86.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (169, 36, 5, 73.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (170, 37, 1, 64.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (171, 37, 2, 88.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (172, 37, 3, 69.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (173, 37, 4, 67.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (174, 37, 5, 73.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (175, 38, 1, 70.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (176, 38, 2, 86.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (177, 38, 3, 75.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (178, 38, 4, 77.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (179, 38, 5, 80.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (180, 39, 1, 76.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (181, 39, 2, 84.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (182, 39, 3, 86.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (183, 39, 4, 79.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (184, 39, 5, 78.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (185, 40, 1, 62.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (186, 40, 2, 68.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (187, 40, 3, 64.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (188, 40, 4, 91.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (189, 40, 5, 80.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (190, 41, 1, 72.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (191, 41, 2, 64.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (192, 41, 3, 72.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (193, 41, 4, 63.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (194, 41, 5, 62.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (195, 42, 1, 91.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (196, 42, 2, 60.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (197, 42, 3, 90.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (198, 42, 4, 68.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (199, 42, 5, 67.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (200, 43, 1, 93.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (201, 43, 2, 71.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (202, 43, 3, 77.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (203, 43, 4, 73.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (204, 43, 5, 78.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (205, 44, 1, 98.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (206, 44, 2, 82.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (207, 44, 3, 61.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (208, 44, 4, 70.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (209, 44, 5, 73.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (210, 45, 1, 97.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (211, 45, 2, 84.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (212, 45, 3, 83.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (213, 45, 4, 80.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (214, 45, 5, 61.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (215, 46, 1, 62.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (216, 46, 2, 94.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (217, 46, 3, 91.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (218, 46, 4, 75.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (219, 46, 5, 67.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (220, 47, 1, 66.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (221, 47, 2, 86.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (222, 47, 3, 65.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (223, 47, 4, 74.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (224, 47, 5, 62.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (225, 48, 1, 75.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (226, 48, 2, 73.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (227, 48, 3, 64.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (228, 48, 4, 90.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (229, 48, 5, 86.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (230, 49, 1, 67.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (231, 49, 2, 84.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (232, 49, 3, 78.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (233, 49, 4, 81.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (234, 49, 5, 63.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (235, 50, 1, 64.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (236, 50, 2, 68.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (237, 50, 3, 95.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (238, 50, 4, 88.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (239, 50, 5, 88.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (240, 51, 1, 60.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (241, 51, 2, 75.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (242, 51, 3, 77.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (243, 51, 4, 71.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (244, 51, 5, 82.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (245, 52, 1, 78.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (246, 52, 2, 66.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (247, 52, 3, 90.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (248, 52, 4, 95.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (249, 52, 5, 66.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (250, 53, 1, 70.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (251, 53, 2, 88.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (252, 53, 3, 61.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (253, 53, 4, 65.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (254, 53, 5, 80.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (255, 54, 1, 81.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (256, 54, 2, 60.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (257, 54, 3, 68.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (258, 54, 4, 69.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (259, 54, 5, 82.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (260, 55, 1, 94.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (261, 55, 2, 72.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (262, 55, 3, 88.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (263, 55, 4, 71.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (264, 55, 5, 80.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (265, 56, 1, 69.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (266, 56, 2, 73.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (267, 56, 3, 76.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (268, 56, 4, 85.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (269, 56, 5, 95.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (270, 57, 1, 76.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (271, 57, 2, 88.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (272, 57, 3, 60.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (273, 57, 4, 95.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (274, 57, 5, 96.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (275, 58, 1, 76.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (276, 58, 2, 93.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (277, 58, 3, 89.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (278, 58, 4, 85.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (279, 58, 5, 65.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (280, 59, 1, 70.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (281, 59, 2, 93.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (282, 59, 3, 61.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (283, 59, 4, 81.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (284, 59, 5, 62.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (285, 60, 1, 79.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (286, 60, 2, 65.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (287, 60, 3, 72.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (288, 60, 4, 65.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (289, 60, 5, 61.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (290, 61, 1, 68.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (291, 61, 2, 81.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (292, 61, 3, 60.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (293, 61, 4, 74.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (294, 61, 5, 82.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (295, 62, 1, 68.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (296, 62, 2, 66.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (297, 62, 3, 73.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (298, 62, 4, 85.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (299, 62, 5, 67.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (300, 63, 1, 77.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (301, 63, 2, 69.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (302, 63, 3, 69.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (303, 63, 4, 71.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (304, 63, 5, 62.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (305, 64, 1, 87.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (306, 64, 2, 67.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (307, 64, 3, 71.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (308, 64, 4, 83.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (309, 64, 5, 65.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (310, 65, 1, 78.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (311, 65, 2, 60.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (312, 65, 3, 78.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (313, 65, 4, 82.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (314, 65, 5, 74.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (315, 66, 1, 88.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (316, 66, 2, 68.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (317, 66, 3, 67.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (318, 66, 4, 87.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (319, 66, 5, 84.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (320, 67, 1, 83.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (321, 67, 2, 87.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (322, 67, 3, 80.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (323, 67, 4, 66.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (324, 67, 5, 64.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (325, 68, 1, 62.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (326, 68, 2, 70.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (327, 68, 3, 87.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (328, 68, 4, 90.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (329, 68, 5, 79.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (330, 69, 1, 78.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (331, 69, 2, 73.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (332, 69, 3, 78.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (333, 69, 4, 72.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (334, 69, 5, 83.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (335, 70, 1, 75.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (336, 70, 2, 64.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (337, 70, 3, 94.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (338, 70, 4, 70.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (339, 70, 5, 68.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (340, 71, 1, 88.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (341, 71, 2, 73.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (342, 71, 3, 61.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (343, 71, 4, 73.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (344, 71, 5, 83.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (345, 72, 1, 78.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (346, 72, 2, 66.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (347, 72, 3, 61.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (348, 72, 4, 66.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (349, 72, 5, 91.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (350, 73, 1, 63.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (351, 73, 2, 77.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (352, 73, 3, 76.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (353, 73, 4, 67.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (354, 73, 5, 83.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (355, 74, 1, 73.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (356, 74, 2, 86.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (357, 74, 3, 87.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (358, 74, 4, 91.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (359, 74, 5, 67.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (360, 75, 1, 92.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (361, 75, 2, 85.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (362, 75, 3, 63.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (363, 75, 4, 86.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (364, 75, 5, 75.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (365, 76, 1, 81.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (366, 76, 2, 70.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (367, 76, 3, 74.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (368, 76, 4, 68.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (369, 76, 5, 82.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (370, 77, 1, 71.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (371, 77, 2, 78.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (372, 77, 3, 83.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (373, 77, 4, 65.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (374, 77, 5, 69.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (375, 78, 1, 79.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (376, 78, 2, 89.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (377, 78, 3, 83.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (378, 78, 4, 80.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (379, 78, 5, 78.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (380, 79, 1, 79.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (381, 79, 2, 62.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (382, 79, 3, 85.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (383, 79, 4, 65.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (384, 79, 5, 64.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (385, 80, 1, 66.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (386, 80, 2, 64.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (387, 80, 3, 71.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (388, 80, 4, 72.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (389, 80, 5, 98.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (390, 81, 1, 68.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (391, 81, 2, 70.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (392, 81, 3, 60.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (393, 81, 4, 78.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (394, 81, 5, 68.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (395, 82, 1, 80.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (396, 82, 2, 88.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (397, 82, 3, 69.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (398, 82, 4, 65.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (399, 82, 5, 82.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (400, 83, 1, 74.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (401, 83, 2, 64.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (402, 83, 3, 79.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (403, 83, 4, 72.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (404, 83, 5, 85.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (405, 84, 1, 62.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (406, 84, 2, 63.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (407, 84, 3, 73.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (408, 84, 4, 71.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (409, 84, 5, 71.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (410, 85, 1, 78.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (411, 85, 2, 90.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (412, 85, 3, 74.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (413, 85, 4, 67.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (414, 85, 5, 80.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (415, 86, 1, 78.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (416, 86, 2, 80.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (417, 86, 3, 65.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (418, 86, 4, 68.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (419, 86, 5, 84.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (420, 87, 1, 61.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (421, 87, 2, 65.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (422, 87, 3, 82.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (423, 87, 4, 69.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (424, 87, 5, 65.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (425, 88, 1, 79.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (426, 88, 2, 79.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (427, 88, 3, 62.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (428, 88, 4, 83.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (429, 88, 5, 60.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (430, 89, 1, 81.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (431, 89, 2, 65.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (432, 89, 3, 81.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (433, 89, 4, 86.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (434, 89, 5, 65.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (435, 90, 1, 61.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (436, 90, 2, 67.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (437, 90, 3, 80.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (438, 90, 4, 84.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (439, 90, 5, 83.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (440, 91, 1, 68.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (441, 91, 2, 61.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (442, 91, 3, 84.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (443, 91, 4, 68.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (444, 91, 5, 89.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (445, 92, 1, 81.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (446, 92, 2, 60.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (447, 92, 3, 66.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (448, 92, 4, 61.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (449, 92, 5, 76.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (450, 93, 1, 68.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (451, 93, 2, 72.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (452, 93, 3, 74.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (453, 93, 4, 90.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (454, 93, 5, 75.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (455, 94, 1, 75.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (456, 94, 2, 74.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (457, 94, 3, 70.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (458, 94, 4, 90.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (459, 94, 5, 68.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (460, 95, 1, 62.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (461, 95, 2, 83.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (462, 95, 3, 68.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (463, 95, 4, 77.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (464, 95, 5, 89.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (465, 96, 1, 77.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (466, 96, 2, 82.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (467, 96, 3, 67.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (468, 96, 4, 74.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (469, 96, 5, 66.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (470, 97, 1, 87.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (471, 97, 2, 77.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (472, 97, 3, 62.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (473, 97, 4, 81.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (474, 97, 5, 85.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (475, 98, 1, 95.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (476, 98, 2, 68.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (477, 98, 3, 77.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (478, 98, 4, 63.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (479, 98, 5, 65.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (480, 99, 1, 80.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (481, 99, 2, 87.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (482, 99, 3, 71.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (483, 99, 4, 68.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (484, 99, 5, 88.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (485, 100, 1, 74.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (486, 100, 2, 77.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (487, 100, 3, 66.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (488, 100, 4, 81.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (489, 100, 5, 65.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (490, 101, 1, 79.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (491, 101, 2, 81.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (492, 101, 3, 68.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (493, 101, 4, 86.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (494, 101, 5, 86.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (495, 102, 1, 81.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (496, 102, 2, 63.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (497, 102, 3, 61.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (498, 102, 4, 90.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (499, 102, 5, 64.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (500, 103, 1, 83.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (501, 103, 2, 72.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (502, 103, 3, 95.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (503, 103, 4, 81.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (504, 103, 5, 63.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (505, 104, 1, 83.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (506, 104, 2, 70.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (507, 104, 3, 67.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (508, 104, 4, 66.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (509, 104, 5, 69.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (510, 105, 1, 65.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (511, 105, 2, 79.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (512, 105, 3, 93.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (513, 105, 4, 93.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (514, 105, 5, 80.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (515, 106, 1, 62.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (516, 106, 2, 74.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (517, 106, 3, 90.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (518, 106, 4, 65.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (519, 106, 5, 70.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (520, 107, 1, 62.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (521, 107, 2, 70.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (522, 107, 3, 88.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (523, 107, 4, 69.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (524, 107, 5, 86.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (525, 108, 1, 65.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (526, 108, 2, 86.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (527, 108, 3, 72.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (528, 108, 4, 72.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (529, 108, 5, 79.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (530, 109, 1, 75.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (531, 109, 2, 81.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (532, 109, 3, 89.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (533, 109, 4, 84.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (534, 109, 5, 71.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (535, 110, 1, 95.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (536, 110, 2, 98.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (537, 110, 3, 75.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (538, 110, 4, 80.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (539, 110, 5, 80.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (540, 111, 1, 73.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (541, 111, 2, 83.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (542, 111, 3, 67.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (543, 111, 4, 61.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (544, 111, 5, 65.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (545, 112, 1, 62.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (546, 112, 2, 78.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (547, 112, 3, 79.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (548, 112, 4, 69.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (549, 112, 5, 88.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (550, 113, 1, 69.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (551, 113, 2, 66.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (552, 113, 3, 79.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (553, 113, 4, 73.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (554, 113, 5, 66.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (555, 114, 1, 88.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (556, 114, 2, 60.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (557, 114, 3, 81.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (558, 114, 4, 66.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (559, 114, 5, 83.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (560, 115, 1, 83.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (561, 115, 2, 75.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (562, 115, 3, 68.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (563, 115, 4, 66.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (564, 115, 5, 62.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (565, 116, 1, 76.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (566, 116, 2, 62.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (567, 116, 3, 87.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (568, 116, 4, 64.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (569, 116, 5, 82.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (570, 117, 1, 80.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (571, 117, 2, 76.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (572, 117, 3, 68.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (573, 117, 4, 68.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (574, 117, 5, 83.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (575, 118, 1, 92.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (576, 118, 2, 61.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (577, 118, 3, 77.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (578, 118, 4, 66.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (579, 118, 5, 68.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (580, 119, 1, 79.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (581, 119, 2, 78.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (582, 119, 3, 63.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (583, 119, 4, 75.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (584, 119, 5, 84.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (585, 120, 1, 86.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (586, 120, 2, 73.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (587, 120, 3, 73.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (588, 120, 4, 86.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (589, 120, 5, 63.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (590, 121, 1, 76.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (591, 121, 2, 74.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (592, 121, 3, 60.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (593, 121, 4, 75.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (594, 121, 5, 69.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (595, 122, 1, 64.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (596, 122, 2, 64.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (597, 122, 3, 98.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (598, 122, 4, 76.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (599, 122, 5, 73.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (600, 123, 1, 81.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (601, 123, 2, 75.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (602, 123, 3, 63.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (603, 123, 4, 80.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (604, 123, 5, 90.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (605, 124, 1, 64.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (606, 124, 2, 77.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (607, 124, 3, 83.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (608, 124, 4, 70.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (609, 124, 5, 79.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (610, 125, 1, 82.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (611, 125, 2, 86.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (612, 125, 3, 63.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (613, 125, 4, 72.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (614, 125, 5, 67.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (615, 126, 1, 74.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (616, 126, 2, 88.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (617, 126, 3, 69.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (618, 126, 4, 81.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (619, 126, 5, 95.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (620, 127, 1, 79.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (621, 127, 2, 85.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (622, 127, 3, 81.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (623, 127, 4, 77.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (624, 127, 5, 79.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (625, 128, 1, 73.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (626, 128, 2, 90.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (627, 128, 3, 85.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (628, 128, 4, 84.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (629, 128, 5, 75.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (630, 129, 1, 88.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (631, 129, 2, 73.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (632, 129, 3, 65.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (633, 129, 4, 75.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (634, 129, 5, 87.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (635, 130, 1, 75.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (636, 130, 2, 60.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (637, 130, 3, 70.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (638, 130, 4, 84.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (639, 130, 5, 62.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (640, 131, 1, 63.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (641, 131, 2, 86.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (642, 131, 3, 77.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (643, 131, 4, 76.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (644, 131, 5, 60.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (645, 132, 1, 71.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (646, 132, 2, 85.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (647, 132, 3, 98.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (648, 132, 4, 69.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (649, 132, 5, 93.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (650, 133, 1, 63.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (651, 133, 2, 73.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (652, 133, 3, 75.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (653, 133, 4, 65.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (654, 133, 5, 70.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (655, 134, 1, 86.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (656, 134, 2, 89.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (657, 134, 3, 70.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (658, 134, 4, 74.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (659, 134, 5, 79.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (660, 135, 1, 97.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (661, 135, 2, 60.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (662, 135, 3, 73.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (663, 135, 4, 75.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (664, 135, 5, 70.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (665, 136, 1, 79.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (666, 136, 2, 84.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (667, 136, 3, 73.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (668, 136, 4, 77.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (669, 136, 5, 85.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (670, 137, 1, 68.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (671, 137, 2, 62.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (672, 137, 3, 71.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (673, 137, 4, 86.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (674, 137, 5, 74.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (675, 138, 1, 71.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (676, 138, 2, 82.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (677, 138, 3, 88.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (678, 138, 4, 86.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (679, 138, 5, 85.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (680, 139, 1, 88.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (681, 139, 2, 64.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (682, 139, 3, 83.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (683, 139, 4, 85.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (684, 139, 5, 60.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (685, 140, 1, 71.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (686, 140, 2, 72.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (687, 140, 3, 77.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (688, 140, 4, 83.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (689, 140, 5, 68.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (690, 141, 1, 70.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (691, 141, 2, 64.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (692, 141, 3, 74.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (693, 141, 4, 76.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (694, 141, 5, 87.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (695, 142, 1, 96.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (696, 142, 2, 81.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (697, 142, 3, 84.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (698, 142, 4, 76.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (699, 142, 5, 78.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (700, 143, 1, 77.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (701, 143, 2, 82.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (702, 143, 3, 79.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (703, 143, 4, 77.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (704, 143, 5, 68.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (705, 144, 1, 76.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (706, 144, 2, 80.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (707, 144, 3, 81.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (708, 144, 4, 61.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (709, 144, 5, 85.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (710, 145, 1, 90.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (711, 145, 2, 81.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (712, 145, 3, 75.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (713, 145, 4, 85.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (714, 145, 5, 69.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (715, 146, 1, 64.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (716, 146, 2, 84.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (717, 146, 3, 75.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (718, 146, 4, 76.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (719, 146, 5, 85.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (720, 147, 1, 82.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (721, 147, 2, 84.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (722, 147, 3, 77.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (723, 147, 4, 78.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (724, 147, 5, 87.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (725, 148, 1, 68.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (726, 148, 2, 89.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (727, 148, 3, 67.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (728, 148, 4, 66.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (729, 148, 5, 85.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (730, 149, 1, 87.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (731, 149, 2, 80.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (732, 149, 3, 67.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (733, 149, 4, 63.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (734, 149, 5, 73.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (735, 150, 1, 85.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (736, 150, 2, 98.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (737, 150, 3, 88.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (738, 150, 4, 81.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (739, 150, 5, 87.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (740, 151, 1, 65.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (741, 151, 2, 84.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (742, 151, 3, 61.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (743, 151, 4, 80.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (744, 151, 5, 65.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (745, 152, 1, 79.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (746, 152, 2, 91.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (747, 152, 3, 94.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (748, 152, 4, 75.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (749, 152, 5, 68.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (750, 153, 1, 72.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (751, 153, 2, 79.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (752, 153, 3, 67.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (753, 153, 4, 89.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (754, 153, 5, 81.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (755, 154, 1, 92.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (756, 154, 2, 82.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (757, 154, 3, 64.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (758, 154, 4, 95.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (759, 154, 5, 80.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (760, 155, 1, 88.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (761, 155, 2, 88.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (762, 155, 3, 64.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (763, 155, 4, 72.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (764, 155, 5, 76.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (765, 156, 1, 72.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (766, 156, 2, 88.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (767, 156, 3, 86.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (768, 156, 4, 73.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (769, 156, 5, 74.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (770, 157, 1, 60.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (771, 157, 2, 63.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (772, 157, 3, 73.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (773, 157, 4, 78.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (774, 157, 5, 96.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (775, 158, 1, 69.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (776, 158, 2, 63.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (777, 158, 3, 89.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (778, 158, 4, 60.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (779, 158, 5, 63.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (780, 159, 1, 86.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (781, 159, 2, 63.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (782, 159, 3, 85.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (783, 159, 4, 70.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (784, 159, 5, 83.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (785, 160, 1, 85.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (786, 160, 2, 73.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (787, 160, 3, 68.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (788, 160, 4, 70.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (789, 160, 5, 65.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (790, 161, 1, 75.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (791, 161, 2, 76.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (792, 161, 3, 82.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (793, 161, 4, 60.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (794, 161, 5, 79.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (795, 162, 1, 88.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (796, 162, 2, 60.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (797, 162, 3, 73.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (798, 162, 4, 63.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (799, 162, 5, 77.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (800, 163, 1, 62.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (801, 163, 2, 87.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (802, 163, 3, 73.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (803, 163, 4, 71.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (804, 163, 5, 78.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (805, 164, 1, 90.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (806, 164, 2, 65.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (807, 164, 3, 81.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (808, 164, 4, 73.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (809, 164, 5, 90.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (810, 165, 1, 82.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (811, 165, 2, 60.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (812, 165, 3, 78.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (813, 165, 4, 91.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (814, 165, 5, 94.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (815, 166, 1, 86.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (816, 166, 2, 62.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (817, 166, 3, 93.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (818, 166, 4, 84.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (819, 166, 5, 82.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (820, 167, 1, 91.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (821, 167, 2, 87.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (822, 167, 3, 77.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (823, 167, 4, 67.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (824, 167, 5, 70.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (825, 168, 1, 71.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (826, 168, 2, 84.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (827, 168, 3, 85.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (828, 168, 4, 65.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (829, 168, 5, 63.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (830, 169, 1, 86.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (831, 169, 2, 75.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (832, 169, 3, 69.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (833, 169, 4, 85.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (834, 169, 5, 82.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (835, 170, 1, 81.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (836, 170, 2, 63.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (837, 170, 3, 95.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (838, 170, 4, 75.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (839, 170, 5, 77.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (840, 171, 1, 70.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (841, 171, 2, 91.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (842, 171, 3, 65.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (843, 171, 4, 84.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (844, 171, 5, 94.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (845, 172, 1, 90.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (846, 172, 2, 62.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (847, 172, 3, 73.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (848, 172, 4, 81.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (849, 172, 5, 85.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (850, 173, 1, 65.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (851, 173, 2, 77.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (852, 173, 3, 79.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (853, 173, 4, 67.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (854, 173, 5, 85.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (855, 174, 1, 69.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (856, 174, 2, 74.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (857, 174, 3, 77.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (858, 174, 4, 87.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (859, 174, 5, 65.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (860, 175, 1, 83.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (861, 175, 2, 67.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (862, 175, 3, 91.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (863, 175, 4, 91.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (864, 175, 5, 75.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (865, 176, 1, 81.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (866, 176, 2, 92.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (867, 176, 3, 96.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (868, 176, 4, 69.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (869, 176, 5, 67.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (870, 177, 1, 80.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (871, 177, 2, 75.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (872, 177, 3, 88.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (873, 177, 4, 79.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (874, 177, 5, 61.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (875, 178, 1, 70.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (876, 178, 2, 67.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (877, 178, 3, 85.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (878, 178, 4, 76.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (879, 178, 5, 88.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (880, 179, 1, 77.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (881, 179, 2, 91.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (882, 179, 3, 70.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (883, 179, 4, 66.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (884, 179, 5, 84.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (885, 180, 1, 70.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (886, 180, 2, 76.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (887, 180, 3, 66.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (888, 180, 4, 93.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (889, 180, 5, 83.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (890, 181, 1, 83.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (891, 181, 2, 67.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (892, 181, 3, 95.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (893, 181, 4, 88.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (894, 181, 5, 68.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (895, 182, 1, 88.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (896, 182, 2, 79.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (897, 182, 3, 76.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (898, 182, 4, 91.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (899, 182, 5, 68.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (900, 183, 1, 70.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (901, 183, 2, 89.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (902, 183, 3, 91.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (903, 183, 4, 86.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (904, 183, 5, 87.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (905, 184, 1, 71.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (906, 184, 2, 75.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (907, 184, 3, 62.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (908, 184, 4, 88.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (909, 184, 5, 87.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (910, 185, 1, 80.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (911, 185, 2, 86.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (912, 185, 3, 91.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (913, 185, 4, 67.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (914, 185, 5, 68.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (915, 186, 1, 93.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (916, 186, 2, 89.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (917, 186, 3, 85.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (918, 186, 4, 89.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (919, 186, 5, 77.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (920, 187, 1, 81.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (921, 187, 2, 69.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (922, 187, 3, 64.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (923, 187, 4, 91.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (924, 187, 5, 68.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (925, 188, 1, 78.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (926, 188, 2, 78.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (927, 188, 3, 91.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (928, 188, 4, 66.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (929, 188, 5, 68.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (930, 189, 1, 74.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (931, 189, 2, 87.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (932, 189, 3, 61.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (933, 189, 4, 70.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (934, 189, 5, 78.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (935, 190, 1, 97.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (936, 190, 2, 74.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (937, 190, 3, 87.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (938, 190, 4, 89.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (939, 190, 5, 81.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (940, 191, 1, 65.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (941, 191, 2, 78.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (942, 191, 3, 89.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (943, 191, 4, 93.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (944, 191, 5, 71.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (945, 192, 1, 86.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (946, 192, 2, 61.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (947, 192, 3, 87.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (948, 192, 4, 60.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (949, 192, 5, 80.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (950, 193, 1, 67.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (951, 193, 2, 79.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (952, 193, 3, 77.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (953, 193, 4, 67.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (954, 193, 5, 76.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (955, 194, 1, 73.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (956, 194, 2, 78.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (957, 194, 3, 79.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (958, 194, 4, 94.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (959, 194, 5, 87.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (960, 195, 1, 72.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (961, 195, 2, 65.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (962, 195, 3, 85.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (963, 195, 4, 68.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (964, 195, 5, 68.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (965, 196, 1, 63.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (966, 196, 2, 60.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (967, 196, 3, 85.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (968, 196, 4, 62.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (969, 196, 5, 60.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (970, 197, 1, 83.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (971, 197, 2, 68.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (972, 197, 3, 88.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (973, 197, 4, 68.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (974, 197, 5, 78.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (975, 198, 1, 80.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (976, 198, 2, 65.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (977, 198, 3, 67.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (978, 198, 4, 85.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (979, 198, 5, 82.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (980, 199, 1, 67.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (981, 199, 2, 60.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (982, 199, 3, 95.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (983, 199, 4, 80.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (984, 199, 5, 78.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (985, 200, 1, 91.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (986, 200, 2, 76.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (987, 200, 3, 68.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (988, 200, 4, 98.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (989, 200, 5, 80.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (990, 201, 1, 73.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (991, 201, 2, 80.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (992, 201, 3, 81.40, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (993, 201, 4, 84.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (994, 201, 5, 87.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (995, 202, 1, 73.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (996, 202, 2, 74.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (997, 202, 3, 69.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (998, 202, 4, 61.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (999, 202, 5, 86.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1000, 203, 1, 93.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1001, 203, 2, 68.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1002, 203, 3, 91.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1003, 203, 4, 63.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1004, 203, 5, 83.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1005, 204, 1, 85.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1006, 204, 2, 81.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1007, 204, 3, 93.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1008, 204, 4, 80.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1009, 204, 5, 62.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1010, 205, 1, 71.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1011, 205, 2, 78.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1012, 205, 3, 77.10, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1013, 205, 4, 79.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1014, 205, 5, 71.00, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1015, 206, 1, 80.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1016, 206, 2, 68.80, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1017, 206, 3, 84.60, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1018, 206, 4, 69.70, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1019, 206, 5, 89.20, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1020, 207, 1, 61.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1021, 207, 2, 73.50, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1022, 207, 3, 66.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1023, 207, 4, 67.90, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1024, 207, 5, 77.30, '2024-07-01', '期末', '2023-2024学年第二学期期末成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1038, 6, 1, 59.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1039, 6, 2, 73.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1040, 6, 3, 58.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1041, 6, 4, 69.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1042, 6, 5, 81.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1043, 7, 1, 85.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1044, 7, 2, 72.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1045, 7, 3, 79.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1046, 7, 4, 57.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1047, 7, 5, 72.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1048, 8, 1, 70.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1049, 8, 2, 74.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1050, 8, 3, 79.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1051, 8, 4, 74.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1052, 8, 5, 82.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1053, 9, 1, 73.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1054, 9, 2, 68.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1055, 9, 3, 88.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1056, 9, 4, 77.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1057, 9, 5, 77.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1058, 10, 1, 88.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1059, 10, 2, 60.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1060, 10, 3, 63.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1061, 10, 4, 61.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1062, 10, 5, 77.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1063, 11, 1, 77.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1064, 11, 2, 82.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1065, 11, 3, 61.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1066, 11, 4, 87.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1067, 11, 5, 76.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1068, 12, 1, 59.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1069, 12, 2, 64.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1070, 12, 3, 55.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1071, 12, 4, 77.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1072, 12, 5, 85.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1073, 13, 1, 81.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1074, 13, 2, 78.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1075, 13, 3, 84.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1076, 13, 4, 57.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1077, 13, 5, 74.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1078, 14, 1, 85.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1079, 14, 2, 64.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1080, 14, 3, 71.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1081, 14, 4, 91.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1082, 14, 5, 84.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1083, 15, 1, 82.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1084, 15, 2, 71.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1085, 15, 3, 89.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1086, 15, 4, 88.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1087, 15, 5, 79.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1088, 16, 1, 93.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1089, 16, 2, 86.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1090, 16, 3, 77.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1091, 16, 4, 85.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1092, 16, 5, 83.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1093, 17, 1, 81.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1094, 17, 2, 87.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1095, 17, 3, 80.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1096, 17, 4, 69.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1097, 17, 5, 74.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1098, 18, 1, 88.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1099, 18, 2, 79.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1100, 18, 3, 79.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1101, 18, 4, 74.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1102, 18, 5, 82.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1103, 19, 1, 77.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1104, 19, 2, 80.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1105, 19, 3, 73.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1106, 19, 4, 83.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1107, 19, 5, 80.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1108, 20, 1, 73.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1109, 20, 2, 56.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1110, 20, 3, 86.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1111, 20, 4, 55.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1112, 20, 5, 60.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1113, 21, 1, 72.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1114, 21, 2, 78.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1115, 21, 3, 67.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1116, 21, 4, 88.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1117, 21, 5, 82.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1118, 22, 1, 64.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1119, 22, 2, 66.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1120, 22, 3, 86.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1121, 22, 4, 68.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1122, 22, 5, 89.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1123, 23, 1, 60.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1124, 23, 2, 67.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1125, 23, 3, 68.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1126, 23, 4, 79.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1127, 23, 5, 55.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1128, 24, 1, 56.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1129, 24, 2, 83.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1130, 24, 3, 75.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1131, 24, 4, 83.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1132, 24, 5, 65.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1133, 25, 1, 92.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1134, 25, 2, 77.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1135, 25, 3, 66.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1136, 25, 4, 91.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1137, 25, 5, 82.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1138, 26, 1, 67.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1139, 26, 2, 66.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1140, 26, 3, 86.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1141, 26, 4, 63.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1142, 26, 5, 57.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1143, 27, 1, 74.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1144, 27, 2, 75.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1145, 27, 3, 82.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1146, 27, 4, 84.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1147, 27, 5, 64.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1148, 28, 1, 66.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1149, 28, 2, 64.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1150, 28, 3, 82.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1151, 28, 4, 58.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1152, 28, 5, 85.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1153, 29, 1, 59.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1154, 29, 2, 67.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1155, 29, 3, 56.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1156, 29, 4, 57.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1157, 29, 5, 90.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1158, 30, 1, 68.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1159, 30, 2, 62.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1160, 30, 3, 89.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1161, 30, 4, 79.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1162, 30, 5, 74.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1163, 31, 1, 57.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1164, 31, 2, 86.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1165, 31, 3, 57.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1166, 31, 4, 56.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1167, 31, 5, 60.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1168, 32, 1, 80.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1169, 32, 2, 63.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1170, 32, 3, 72.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1171, 32, 4, 75.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1172, 32, 5, 58.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1173, 33, 1, 84.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1174, 33, 2, 60.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1175, 33, 3, 60.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1176, 33, 4, 77.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1177, 33, 5, 65.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1178, 34, 1, 75.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1179, 34, 2, 69.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1180, 34, 3, 65.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1181, 34, 4, 75.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1182, 34, 5, 72.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1183, 35, 1, 56.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1184, 35, 2, 88.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1185, 35, 3, 74.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1186, 35, 4, 82.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1187, 35, 5, 72.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1188, 36, 1, 88.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1189, 36, 2, 88.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1190, 36, 3, 57.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1191, 36, 4, 74.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1192, 36, 5, 55.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1193, 37, 1, 93.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1194, 37, 2, 76.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1195, 37, 3, 74.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1196, 37, 4, 57.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1197, 37, 5, 83.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1198, 38, 1, 63.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1199, 38, 2, 79.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1200, 38, 3, 84.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1201, 38, 4, 61.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1202, 38, 5, 76.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1203, 39, 1, 79.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1204, 39, 2, 76.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1205, 39, 3, 87.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1206, 39, 4, 56.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1207, 39, 5, 82.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1208, 40, 1, 81.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1209, 40, 2, 68.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1210, 40, 3, 56.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1211, 40, 4, 74.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1212, 40, 5, 88.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1213, 41, 1, 55.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1214, 41, 2, 77.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1215, 41, 3, 79.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1216, 41, 4, 57.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1217, 41, 5, 88.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1218, 42, 1, 72.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1219, 42, 2, 75.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1220, 42, 3, 64.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1221, 42, 4, 89.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1222, 42, 5, 65.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1223, 43, 1, 85.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1224, 43, 2, 75.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1225, 43, 3, 63.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1226, 43, 4, 68.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1227, 43, 5, 81.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1228, 44, 1, 73.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1229, 44, 2, 73.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1230, 44, 3, 80.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1231, 44, 4, 73.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1232, 44, 5, 55.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1233, 45, 1, 55.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1234, 45, 2, 84.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1235, 45, 3, 72.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1236, 45, 4, 60.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1237, 45, 5, 65.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1238, 46, 1, 90.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1239, 46, 2, 75.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1240, 46, 3, 86.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1241, 46, 4, 75.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1242, 46, 5, 62.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1243, 47, 1, 57.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1244, 47, 2, 92.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1245, 47, 3, 71.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1246, 47, 4, 75.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1247, 47, 5, 91.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1248, 48, 1, 63.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1249, 48, 2, 85.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1250, 48, 3, 80.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1251, 48, 4, 86.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1252, 48, 5, 70.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1253, 49, 1, 66.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1254, 49, 2, 92.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1255, 49, 3, 72.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1256, 49, 4, 82.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1257, 49, 5, 68.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1258, 50, 1, 80.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1259, 50, 2, 69.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1260, 50, 3, 82.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1261, 50, 4, 75.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1262, 50, 5, 89.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1263, 51, 1, 62.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1264, 51, 2, 84.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1265, 51, 3, 78.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1266, 51, 4, 88.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1267, 51, 5, 68.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1268, 52, 1, 74.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1269, 52, 2, 77.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1270, 52, 3, 69.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1271, 52, 4, 59.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1272, 52, 5, 69.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1273, 53, 1, 58.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1274, 53, 2, 68.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1275, 53, 3, 68.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1276, 53, 4, 56.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1277, 53, 5, 76.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1278, 54, 1, 64.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1279, 54, 2, 57.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1280, 54, 3, 92.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1281, 54, 4, 72.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1282, 54, 5, 84.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1283, 55, 1, 77.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1284, 55, 2, 84.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1285, 55, 3, 86.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1286, 55, 4, 86.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1287, 55, 5, 62.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1288, 56, 1, 60.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1289, 56, 2, 72.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1290, 56, 3, 75.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1291, 56, 4, 88.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1292, 56, 5, 77.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1293, 57, 1, 69.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1294, 57, 2, 75.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1295, 57, 3, 61.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1296, 57, 4, 56.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1297, 57, 5, 84.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1298, 58, 1, 67.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1299, 58, 2, 69.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1300, 58, 3, 62.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1301, 58, 4, 73.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1302, 58, 5, 83.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1303, 59, 1, 58.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1304, 59, 2, 89.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1305, 59, 3, 74.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1306, 59, 4, 82.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1307, 59, 5, 88.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1308, 60, 1, 59.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1309, 60, 2, 57.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1310, 60, 3, 62.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1311, 60, 4, 65.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1312, 60, 5, 81.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1313, 61, 1, 69.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1314, 61, 2, 84.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1315, 61, 3, 75.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1316, 61, 4, 92.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1317, 61, 5, 76.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1318, 62, 1, 60.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1319, 62, 2, 68.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1320, 62, 3, 92.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1321, 62, 4, 65.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1322, 62, 5, 77.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1323, 63, 1, 77.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1324, 63, 2, 60.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1325, 63, 3, 84.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1326, 63, 4, 66.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1327, 63, 5, 77.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1328, 64, 1, 57.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1329, 64, 2, 84.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1330, 64, 3, 55.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1331, 64, 4, 68.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1332, 64, 5, 84.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1333, 65, 1, 84.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1334, 65, 2, 65.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1335, 65, 3, 60.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1336, 65, 4, 84.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1337, 65, 5, 79.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1338, 66, 1, 72.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1339, 66, 2, 70.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1340, 66, 3, 85.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1341, 66, 4, 69.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1342, 66, 5, 57.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1343, 67, 1, 61.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1344, 67, 2, 82.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1345, 67, 3, 78.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1346, 67, 4, 69.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1347, 67, 5, 55.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1348, 68, 1, 74.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1349, 68, 2, 55.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1350, 68, 3, 67.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1351, 68, 4, 55.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1352, 68, 5, 91.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1353, 69, 1, 55.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1354, 69, 2, 82.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1355, 69, 3, 80.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1356, 69, 4, 83.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1357, 69, 5, 79.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1358, 70, 1, 84.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1359, 70, 2, 74.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1360, 70, 3, 55.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1361, 70, 4, 78.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1362, 70, 5, 77.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1363, 71, 1, 80.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1364, 71, 2, 71.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1365, 71, 3, 81.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1366, 71, 4, 76.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1367, 71, 5, 87.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1368, 72, 1, 65.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1369, 72, 2, 86.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1370, 72, 3, 67.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1371, 72, 4, 62.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1372, 72, 5, 75.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1373, 73, 1, 82.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1374, 73, 2, 70.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1375, 73, 3, 83.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1376, 73, 4, 88.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1377, 73, 5, 78.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1378, 74, 1, 60.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1379, 74, 2, 89.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1380, 74, 3, 65.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1381, 74, 4, 76.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1382, 74, 5, 59.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1383, 75, 1, 71.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1384, 75, 2, 87.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1385, 75, 3, 58.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1386, 75, 4, 81.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1387, 75, 5, 65.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1388, 76, 1, 76.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1389, 76, 2, 56.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1390, 76, 3, 85.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1391, 76, 4, 71.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1392, 76, 5, 56.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1393, 77, 1, 78.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1394, 77, 2, 63.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1395, 77, 3, 91.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1396, 77, 4, 71.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1397, 77, 5, 64.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1398, 78, 1, 69.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1399, 78, 2, 78.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1400, 78, 3, 62.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1401, 78, 4, 56.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1402, 78, 5, 73.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1403, 79, 1, 83.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1404, 79, 2, 87.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1405, 79, 3, 73.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1406, 79, 4, 75.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1407, 79, 5, 73.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1408, 80, 1, 76.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1409, 80, 2, 75.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1410, 80, 3, 66.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1411, 80, 4, 84.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1412, 80, 5, 81.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1413, 81, 1, 74.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1414, 81, 2, 73.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1415, 81, 3, 69.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1416, 81, 4, 86.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1417, 81, 5, 60.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1418, 82, 1, 70.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1419, 82, 2, 63.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1420, 82, 3, 59.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1421, 82, 4, 86.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1422, 82, 5, 58.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1423, 83, 1, 60.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1424, 83, 2, 77.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1425, 83, 3, 83.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1426, 83, 4, 58.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1427, 83, 5, 77.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1428, 84, 1, 67.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1429, 84, 2, 92.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1430, 84, 3, 84.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1431, 84, 4, 78.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1432, 84, 5, 72.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1433, 85, 1, 70.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1434, 85, 2, 74.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1435, 85, 3, 60.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1436, 85, 4, 60.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1437, 85, 5, 83.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1438, 86, 1, 58.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1439, 86, 2, 62.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1440, 86, 3, 61.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1441, 86, 4, 66.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1442, 86, 5, 75.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1443, 87, 1, 57.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1444, 87, 2, 71.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1445, 87, 3, 64.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1446, 87, 4, 75.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1447, 87, 5, 62.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1448, 88, 1, 57.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1449, 88, 2, 78.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1450, 88, 3, 69.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1451, 88, 4, 73.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1452, 88, 5, 58.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1453, 89, 1, 72.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1454, 89, 2, 58.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1455, 89, 3, 75.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1456, 89, 4, 57.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1457, 89, 5, 87.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1458, 90, 1, 75.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1459, 90, 2, 76.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1460, 90, 3, 84.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1461, 90, 4, 56.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1462, 90, 5, 62.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1463, 91, 1, 61.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1464, 91, 2, 68.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1465, 91, 3, 55.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1466, 91, 4, 76.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1467, 91, 5, 75.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1468, 92, 1, 65.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1469, 92, 2, 67.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1470, 92, 3, 70.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1471, 92, 4, 71.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1472, 92, 5, 78.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1473, 93, 1, 58.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1474, 93, 2, 74.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1475, 93, 3, 77.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1476, 93, 4, 55.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1477, 93, 5, 72.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1478, 94, 1, 64.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1479, 94, 2, 68.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1480, 94, 3, 63.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1481, 94, 4, 58.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1482, 94, 5, 72.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1483, 95, 1, 56.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1484, 95, 2, 66.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1485, 95, 3, 56.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1486, 95, 4, 76.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1487, 95, 5, 73.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1488, 96, 1, 61.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1489, 96, 2, 81.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1490, 96, 3, 56.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1491, 96, 4, 85.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1492, 96, 5, 73.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1493, 97, 1, 70.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1494, 97, 2, 81.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1495, 97, 3, 66.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1496, 97, 4, 88.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1497, 97, 5, 65.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1498, 98, 1, 67.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1499, 98, 2, 88.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1500, 98, 3, 90.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1501, 98, 4, 81.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1502, 98, 5, 76.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1503, 99, 1, 91.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1504, 99, 2, 74.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1505, 99, 3, 73.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1506, 99, 4, 64.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1507, 99, 5, 56.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1508, 100, 1, 63.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1509, 100, 2, 69.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1510, 100, 3, 61.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1511, 100, 4, 68.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1512, 100, 5, 84.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1513, 101, 1, 59.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1514, 101, 2, 71.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1515, 101, 3, 56.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1516, 101, 4, 80.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1517, 101, 5, 73.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1518, 102, 1, 74.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1519, 102, 2, 64.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1520, 102, 3, 59.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1521, 102, 4, 66.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1522, 102, 5, 90.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1523, 103, 1, 78.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1524, 103, 2, 73.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1525, 103, 3, 74.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1526, 103, 4, 63.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1527, 103, 5, 68.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1528, 104, 1, 58.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1529, 104, 2, 62.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1530, 104, 3, 70.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1531, 104, 4, 56.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1532, 104, 5, 68.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1533, 105, 1, 87.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1534, 105, 2, 62.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1535, 105, 3, 71.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1536, 105, 4, 61.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1537, 105, 5, 60.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1538, 106, 1, 89.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1539, 106, 2, 74.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1540, 106, 3, 87.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1541, 106, 4, 63.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1542, 106, 5, 65.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1543, 107, 1, 80.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1544, 107, 2, 77.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1545, 107, 3, 84.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1546, 107, 4, 68.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1547, 107, 5, 69.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1548, 108, 1, 63.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1549, 108, 2, 57.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1550, 108, 3, 69.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1551, 108, 4, 56.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1552, 108, 5, 83.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1553, 109, 1, 80.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1554, 109, 2, 57.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1555, 109, 3, 73.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1556, 109, 4, 83.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1557, 109, 5, 58.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1558, 110, 1, 66.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1559, 110, 2, 62.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1560, 110, 3, 76.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1561, 110, 4, 61.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1562, 110, 5, 61.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1563, 111, 1, 82.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1564, 111, 2, 72.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1565, 111, 3, 81.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1566, 111, 4, 70.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1567, 111, 5, 89.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1568, 112, 1, 71.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1569, 112, 2, 86.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1570, 112, 3, 62.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1571, 112, 4, 59.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1572, 112, 5, 64.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1573, 113, 1, 86.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1574, 113, 2, 56.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1575, 113, 3, 80.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1576, 113, 4, 66.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1577, 113, 5, 63.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1578, 114, 1, 63.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1579, 114, 2, 85.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1580, 114, 3, 80.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1581, 114, 4, 55.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1582, 114, 5, 55.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1583, 115, 1, 60.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1584, 115, 2, 55.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1585, 115, 3, 79.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1586, 115, 4, 89.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1587, 115, 5, 58.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1588, 116, 1, 83.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1589, 116, 2, 72.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1590, 116, 3, 83.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1591, 116, 4, 65.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1592, 116, 5, 55.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1593, 117, 1, 71.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1594, 117, 2, 65.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1595, 117, 3, 77.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1596, 117, 4, 84.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1597, 117, 5, 65.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1598, 118, 1, 61.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1599, 118, 2, 68.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1600, 118, 3, 77.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1601, 118, 4, 61.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1602, 118, 5, 64.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1603, 119, 1, 65.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1604, 119, 2, 85.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1605, 119, 3, 55.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1606, 119, 4, 58.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1607, 119, 5, 87.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1608, 120, 1, 75.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1609, 120, 2, 85.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1610, 120, 3, 58.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1611, 120, 4, 69.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1612, 120, 5, 59.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1613, 121, 1, 86.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1614, 121, 2, 55.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1615, 121, 3, 75.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1616, 121, 4, 75.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1617, 121, 5, 82.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1618, 122, 1, 79.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1619, 122, 2, 59.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1620, 122, 3, 63.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1621, 122, 4, 62.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1622, 122, 5, 67.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1623, 123, 1, 57.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1624, 123, 2, 76.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1625, 123, 3, 77.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1626, 123, 4, 79.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1627, 123, 5, 91.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1628, 124, 1, 60.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1629, 124, 2, 84.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1630, 124, 3, 83.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1631, 124, 4, 57.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1632, 124, 5, 64.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1633, 125, 1, 73.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1634, 125, 2, 73.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1635, 125, 3, 94.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1636, 125, 4, 69.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1637, 125, 5, 64.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1638, 126, 1, 56.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1639, 126, 2, 75.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1640, 126, 3, 56.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1641, 126, 4, 75.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1642, 126, 5, 55.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1643, 127, 1, 69.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1644, 127, 2, 79.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1645, 127, 3, 58.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1646, 127, 4, 81.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1647, 127, 5, 80.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1648, 128, 1, 70.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1649, 128, 2, 62.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1650, 128, 3, 67.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1651, 128, 4, 56.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1652, 128, 5, 83.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1653, 129, 1, 71.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1654, 129, 2, 58.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1655, 129, 3, 88.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1656, 129, 4, 64.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1657, 129, 5, 76.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1658, 130, 1, 56.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1659, 130, 2, 55.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1660, 130, 3, 86.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1661, 130, 4, 78.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1662, 130, 5, 57.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1663, 131, 1, 62.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1664, 131, 2, 72.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1665, 131, 3, 83.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1666, 131, 4, 60.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1667, 131, 5, 56.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1668, 132, 1, 69.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1669, 132, 2, 68.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1670, 132, 3, 63.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1671, 132, 4, 75.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1672, 132, 5, 83.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1673, 133, 1, 71.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1674, 133, 2, 59.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1675, 133, 3, 71.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1676, 133, 4, 68.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1677, 133, 5, 73.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1678, 134, 1, 70.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1679, 134, 2, 61.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1680, 134, 3, 55.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1681, 134, 4, 70.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1682, 134, 5, 75.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1683, 135, 1, 80.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1684, 135, 2, 57.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1685, 135, 3, 79.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1686, 135, 4, 62.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1687, 135, 5, 80.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1688, 136, 1, 56.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1689, 136, 2, 77.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1690, 136, 3, 68.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1691, 136, 4, 84.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1692, 136, 5, 81.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1693, 137, 1, 57.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1694, 137, 2, 83.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1695, 137, 3, 68.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1696, 137, 4, 83.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1697, 137, 5, 80.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1698, 138, 1, 86.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1699, 138, 2, 56.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1700, 138, 3, 92.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1701, 138, 4, 61.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1702, 138, 5, 68.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1703, 139, 1, 88.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1704, 139, 2, 59.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1705, 139, 3, 70.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1706, 139, 4, 55.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1707, 139, 5, 58.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1708, 140, 1, 78.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1709, 140, 2, 64.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1710, 140, 3, 66.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1711, 140, 4, 59.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1712, 140, 5, 63.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1713, 141, 1, 84.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1714, 141, 2, 83.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1715, 141, 3, 61.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1716, 141, 4, 81.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1717, 141, 5, 81.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1718, 142, 1, 83.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1719, 142, 2, 60.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1720, 142, 3, 93.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1721, 142, 4, 89.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1722, 142, 5, 88.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1723, 143, 1, 55.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1724, 143, 2, 74.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1725, 143, 3, 90.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1726, 143, 4, 66.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1727, 143, 5, 73.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1728, 144, 1, 93.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1729, 144, 2, 88.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1730, 144, 3, 62.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1731, 144, 4, 75.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1732, 144, 5, 63.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1733, 145, 1, 83.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1734, 145, 2, 55.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1735, 145, 3, 84.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1736, 145, 4, 67.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1737, 145, 5, 56.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1738, 146, 1, 67.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1739, 146, 2, 91.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1740, 146, 3, 82.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1741, 146, 4, 91.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1742, 146, 5, 71.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1743, 147, 1, 78.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1744, 147, 2, 87.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1745, 147, 3, 65.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1746, 147, 4, 72.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1747, 147, 5, 62.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1748, 148, 1, 70.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1749, 148, 2, 56.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1750, 148, 3, 72.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1751, 148, 4, 56.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1752, 148, 5, 55.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1753, 149, 1, 79.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1754, 149, 2, 83.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1755, 149, 3, 69.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1756, 149, 4, 83.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1757, 149, 5, 74.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1758, 150, 1, 79.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1759, 150, 2, 68.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1760, 150, 3, 63.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1761, 150, 4, 87.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1762, 150, 5, 55.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1763, 151, 1, 79.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1764, 151, 2, 65.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1765, 151, 3, 76.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1766, 151, 4, 84.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1767, 151, 5, 74.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1768, 152, 1, 86.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1769, 152, 2, 85.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1770, 152, 3, 75.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1771, 152, 4, 75.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1772, 152, 5, 57.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1773, 153, 1, 67.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1774, 153, 2, 61.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1775, 153, 3, 65.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1776, 153, 4, 79.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1777, 153, 5, 78.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1778, 154, 1, 56.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1779, 154, 2, 66.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1780, 154, 3, 65.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1781, 154, 4, 57.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1782, 154, 5, 67.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1783, 155, 1, 62.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1784, 155, 2, 72.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1785, 155, 3, 74.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1786, 155, 4, 57.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1787, 155, 5, 73.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1788, 156, 1, 85.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1789, 156, 2, 66.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1790, 156, 3, 64.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1791, 156, 4, 55.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1792, 156, 5, 58.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1793, 157, 1, 76.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1794, 157, 2, 62.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1795, 157, 3, 76.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1796, 157, 4, 84.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1797, 157, 5, 55.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1798, 158, 1, 74.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1799, 158, 2, 61.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1800, 158, 3, 78.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1801, 158, 4, 91.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1802, 158, 5, 55.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1803, 159, 1, 70.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1804, 159, 2, 58.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1805, 159, 3, 81.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1806, 159, 4, 81.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1807, 159, 5, 80.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1808, 160, 1, 63.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1809, 160, 2, 71.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1810, 160, 3, 61.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1811, 160, 4, 84.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1812, 160, 5, 80.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1813, 161, 1, 56.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1814, 161, 2, 81.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1815, 161, 3, 57.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1816, 161, 4, 72.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1817, 161, 5, 63.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1818, 162, 1, 65.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1819, 162, 2, 71.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1820, 162, 3, 74.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1821, 162, 4, 90.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1822, 162, 5, 83.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1823, 163, 1, 88.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1824, 163, 2, 87.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1825, 163, 3, 68.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1826, 163, 4, 80.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1827, 163, 5, 69.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1828, 164, 1, 85.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1829, 164, 2, 68.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1830, 164, 3, 72.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1831, 164, 4, 56.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1832, 164, 5, 67.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1833, 165, 1, 70.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1834, 165, 2, 75.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1835, 165, 3, 87.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1836, 165, 4, 67.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1837, 165, 5, 89.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1838, 166, 1, 80.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1839, 166, 2, 67.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1840, 166, 3, 76.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1841, 166, 4, 77.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1842, 166, 5, 76.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1843, 167, 1, 66.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1844, 167, 2, 61.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1845, 167, 3, 66.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1846, 167, 4, 56.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1847, 167, 5, 87.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1848, 168, 1, 87.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1849, 168, 2, 86.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1850, 168, 3, 55.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1851, 168, 4, 73.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1852, 168, 5, 71.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1853, 169, 1, 64.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1854, 169, 2, 76.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1855, 169, 3, 82.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1856, 169, 4, 60.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1857, 169, 5, 74.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1858, 170, 1, 57.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1859, 170, 2, 80.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1860, 170, 3, 66.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1861, 170, 4, 62.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1862, 170, 5, 58.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1863, 171, 1, 64.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1864, 171, 2, 76.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1865, 171, 3, 82.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1866, 171, 4, 65.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1867, 171, 5, 62.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1868, 172, 1, 64.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1869, 172, 2, 74.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1870, 172, 3, 76.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1871, 172, 4, 69.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1872, 172, 5, 58.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1873, 173, 1, 64.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1874, 173, 2, 66.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1875, 173, 3, 78.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1876, 173, 4, 62.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1877, 173, 5, 79.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1878, 174, 1, 86.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1879, 174, 2, 77.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1880, 174, 3, 86.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1881, 174, 4, 75.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1882, 174, 5, 69.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1883, 175, 1, 75.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1884, 175, 2, 87.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1885, 175, 3, 68.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1886, 175, 4, 65.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1887, 175, 5, 80.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1888, 176, 1, 59.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1889, 176, 2, 91.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1890, 176, 3, 79.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1891, 176, 4, 79.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1892, 176, 5, 60.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1893, 177, 1, 82.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1894, 177, 2, 85.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1895, 177, 3, 68.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1896, 177, 4, 92.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1897, 177, 5, 81.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1898, 178, 1, 69.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1899, 178, 2, 88.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1900, 178, 3, 71.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1901, 178, 4, 92.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1902, 178, 5, 87.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1903, 179, 1, 61.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1904, 179, 2, 72.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1905, 179, 3, 85.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1906, 179, 4, 78.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1907, 179, 5, 76.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1908, 180, 1, 62.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1909, 180, 2, 80.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1910, 180, 3, 66.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1911, 180, 4, 88.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1912, 180, 5, 71.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1913, 181, 1, 74.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1914, 181, 2, 89.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1915, 181, 3, 82.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1916, 181, 4, 77.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1917, 181, 5, 76.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1918, 182, 1, 58.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1919, 182, 2, 63.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1920, 182, 3, 62.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1921, 182, 4, 84.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1922, 182, 5, 55.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1923, 183, 1, 77.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1924, 183, 2, 59.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1925, 183, 3, 80.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1926, 183, 4, 82.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1927, 183, 5, 88.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1928, 184, 1, 77.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1929, 184, 2, 81.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1930, 184, 3, 59.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1931, 184, 4, 81.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1932, 184, 5, 55.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1933, 185, 1, 77.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1934, 185, 2, 58.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1935, 185, 3, 68.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1936, 185, 4, 62.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1937, 185, 5, 82.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1938, 186, 1, 74.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1939, 186, 2, 73.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1940, 186, 3, 77.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1941, 186, 4, 83.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1942, 186, 5, 69.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1943, 187, 1, 86.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1944, 187, 2, 76.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1945, 187, 3, 85.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1946, 187, 4, 75.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1947, 187, 5, 77.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1948, 188, 1, 65.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1949, 188, 2, 92.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1950, 188, 3, 82.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1951, 188, 4, 88.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1952, 188, 5, 67.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1953, 189, 1, 63.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1954, 189, 2, 87.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1955, 189, 3, 62.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1956, 189, 4, 70.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1957, 189, 5, 59.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1958, 190, 1, 70.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1959, 190, 2, 82.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1960, 190, 3, 64.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1961, 190, 4, 66.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1962, 190, 5, 60.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1963, 191, 1, 67.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1964, 191, 2, 64.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1965, 191, 3, 60.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1966, 191, 4, 57.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1967, 191, 5, 79.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1968, 192, 1, 58.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1969, 192, 2, 70.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1970, 192, 3, 66.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1971, 192, 4, 63.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1972, 192, 5, 82.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1973, 193, 1, 69.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1974, 193, 2, 69.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1975, 193, 3, 62.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1976, 193, 4, 88.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1977, 193, 5, 87.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1978, 194, 1, 81.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1979, 194, 2, 64.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1980, 194, 3, 74.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1981, 194, 4, 60.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1982, 194, 5, 91.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1983, 195, 1, 71.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1984, 195, 2, 71.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1985, 195, 3, 81.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1986, 195, 4, 81.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1987, 195, 5, 66.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1988, 196, 1, 81.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1989, 196, 2, 80.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1990, 196, 3, 79.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1991, 196, 4, 58.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1992, 196, 5, 56.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1993, 197, 1, 79.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1994, 197, 2, 58.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1995, 197, 3, 61.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1996, 197, 4, 87.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1997, 197, 5, 63.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1998, 198, 1, 59.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (1999, 198, 2, 57.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2000, 198, 3, 59.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2001, 198, 4, 85.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2002, 198, 5, 92.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2003, 199, 1, 56.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2004, 199, 2, 58.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2005, 199, 3, 69.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2006, 199, 4, 85.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2007, 199, 5, 56.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2008, 200, 1, 82.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2009, 200, 2, 71.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2010, 200, 3, 70.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2011, 200, 4, 82.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2012, 200, 5, 61.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2013, 201, 1, 84.40, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2014, 201, 2, 84.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2015, 201, 3, 91.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2016, 201, 4, 84.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2017, 201, 5, 63.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2018, 202, 1, 61.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2019, 202, 2, 63.20, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2020, 202, 3, 67.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2021, 202, 4, 73.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2022, 202, 5, 83.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2023, 203, 1, 89.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2024, 203, 2, 84.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2025, 203, 3, 86.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2026, 203, 4, 63.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2027, 203, 5, 74.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2028, 204, 1, 72.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2029, 204, 2, 61.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2030, 204, 3, 68.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2031, 204, 4, 82.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2032, 204, 5, 65.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2033, 205, 1, 69.50, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2034, 205, 2, 89.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2035, 205, 3, 79.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2036, 205, 4, 66.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2037, 205, 5, 57.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2038, 206, 1, 83.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2039, 206, 2, 80.60, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2040, 206, 3, 86.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2041, 206, 4, 65.10, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2042, 206, 5, 72.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2043, 207, 1, 73.80, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2044, 207, 2, 71.90, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2045, 207, 3, 56.70, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2046, 207, 4, 76.30, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2047, 207, 5, 82.00, '2024-05-01', '期中', '2023-2024学年第二学期期中成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2061, 6, 1, 85.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2062, 6, 2, 88.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2063, 6, 3, 92.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2064, 6, 4, 75.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2065, 6, 5, 92.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2066, 7, 1, 80.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2067, 7, 2, 87.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2068, 7, 3, 80.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2069, 7, 4, 83.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2070, 7, 5, 86.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2071, 8, 1, 86.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2072, 8, 2, 70.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2073, 8, 3, 81.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2074, 8, 4, 81.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2075, 8, 5, 90.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2076, 9, 1, 87.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2077, 9, 2, 91.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2078, 9, 3, 70.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2079, 9, 4, 81.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2080, 9, 5, 96.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2081, 10, 1, 98.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2082, 10, 2, 88.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2083, 10, 3, 72.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2084, 10, 4, 71.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2085, 10, 5, 78.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2086, 11, 1, 78.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2087, 11, 2, 92.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2088, 11, 3, 88.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2089, 11, 4, 92.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2090, 11, 5, 97.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2091, 12, 1, 78.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2092, 12, 2, 79.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2093, 12, 3, 71.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2094, 12, 4, 96.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2095, 12, 5, 94.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2096, 13, 1, 78.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2097, 13, 2, 73.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2098, 13, 3, 88.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2099, 13, 4, 74.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2100, 13, 5, 88.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2101, 14, 1, 75.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2102, 14, 2, 89.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2103, 14, 3, 79.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2104, 14, 4, 76.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2105, 14, 5, 89.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2106, 15, 1, 86.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2107, 15, 2, 75.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2108, 15, 3, 92.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2109, 15, 4, 86.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2110, 15, 5, 81.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2111, 16, 1, 72.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2112, 16, 2, 91.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2113, 16, 3, 72.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2114, 16, 4, 73.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2115, 16, 5, 95.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2116, 17, 1, 92.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2117, 17, 2, 70.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2118, 17, 3, 74.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2119, 17, 4, 78.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2120, 17, 5, 74.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2121, 18, 1, 80.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2122, 18, 2, 72.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2123, 18, 3, 95.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2124, 18, 4, 85.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2125, 18, 5, 92.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2126, 19, 1, 86.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2127, 19, 2, 89.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2128, 19, 3, 91.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2129, 19, 4, 76.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2130, 19, 5, 72.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2131, 20, 1, 85.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2132, 20, 2, 86.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2133, 20, 3, 73.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2134, 20, 4, 73.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2135, 20, 5, 80.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2136, 21, 1, 81.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2137, 21, 2, 77.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2138, 21, 3, 88.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2139, 21, 4, 79.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2140, 21, 5, 80.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2141, 22, 1, 85.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2142, 22, 2, 95.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2143, 22, 3, 71.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2144, 22, 4, 76.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2145, 22, 5, 92.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2146, 23, 1, 79.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2147, 23, 2, 93.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2148, 23, 3, 95.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2149, 23, 4, 91.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2150, 23, 5, 87.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2151, 24, 1, 98.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2152, 24, 2, 77.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2153, 24, 3, 70.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2154, 24, 4, 80.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2155, 24, 5, 91.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2156, 25, 1, 83.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2157, 25, 2, 92.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2158, 25, 3, 86.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2159, 25, 4, 90.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2160, 25, 5, 85.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2161, 26, 1, 79.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2162, 26, 2, 93.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2163, 26, 3, 82.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2164, 26, 4, 72.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2165, 26, 5, 93.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2166, 27, 1, 90.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2167, 27, 2, 91.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2168, 27, 3, 77.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2169, 27, 4, 70.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2170, 27, 5, 91.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2171, 28, 1, 91.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2172, 28, 2, 95.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2173, 28, 3, 89.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2174, 28, 4, 81.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2175, 28, 5, 93.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2176, 29, 1, 73.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2177, 29, 2, 74.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2178, 29, 3, 75.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2179, 29, 4, 73.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2180, 29, 5, 77.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2181, 30, 1, 83.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2182, 30, 2, 86.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2183, 30, 3, 79.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2184, 30, 4, 75.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2185, 30, 5, 72.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2186, 31, 1, 85.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2187, 31, 2, 74.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2188, 31, 3, 92.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2189, 31, 4, 86.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2190, 31, 5, 91.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2191, 32, 1, 70.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2192, 32, 2, 82.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2193, 32, 3, 87.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2194, 32, 4, 87.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2195, 32, 5, 88.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2196, 33, 1, 91.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2197, 33, 2, 84.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2198, 33, 3, 80.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2199, 33, 4, 77.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2200, 33, 5, 92.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2201, 34, 1, 86.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2202, 34, 2, 72.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2203, 34, 3, 85.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2204, 34, 4, 80.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2205, 34, 5, 80.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2206, 35, 1, 80.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2207, 35, 2, 92.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2208, 35, 3, 82.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2209, 35, 4, 86.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2210, 35, 5, 75.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2211, 36, 1, 94.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2212, 36, 2, 97.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2213, 36, 3, 91.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2214, 36, 4, 75.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2215, 36, 5, 96.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2216, 37, 1, 76.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2217, 37, 2, 92.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2218, 37, 3, 73.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2219, 37, 4, 71.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2220, 37, 5, 95.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2221, 38, 1, 73.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2222, 38, 2, 76.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2223, 38, 3, 73.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2224, 38, 4, 89.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2225, 38, 5, 93.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2226, 39, 1, 82.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2227, 39, 2, 87.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2228, 39, 3, 84.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2229, 39, 4, 93.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2230, 39, 5, 79.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2231, 40, 1, 76.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2232, 40, 2, 86.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2233, 40, 3, 76.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2234, 40, 4, 71.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2235, 40, 5, 86.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2236, 41, 1, 74.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2237, 41, 2, 98.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2238, 41, 3, 81.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2239, 41, 4, 81.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2240, 41, 5, 88.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2241, 42, 1, 76.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2242, 42, 2, 71.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2243, 42, 3, 89.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2244, 42, 4, 74.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2245, 42, 5, 72.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2246, 43, 1, 74.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2247, 43, 2, 74.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2248, 43, 3, 88.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2249, 43, 4, 91.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2250, 43, 5, 84.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2251, 44, 1, 74.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2252, 44, 2, 71.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2253, 44, 3, 92.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2254, 44, 4, 85.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2255, 44, 5, 87.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2256, 45, 1, 75.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2257, 45, 2, 70.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2258, 45, 3, 75.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2259, 45, 4, 74.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2260, 45, 5, 72.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2261, 46, 1, 91.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2262, 46, 2, 77.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2263, 46, 3, 91.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2264, 46, 4, 77.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2265, 46, 5, 89.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2266, 47, 1, 84.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2267, 47, 2, 90.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2268, 47, 3, 92.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2269, 47, 4, 75.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2270, 47, 5, 79.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2271, 48, 1, 89.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2272, 48, 2, 92.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2273, 48, 3, 74.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2274, 48, 4, 70.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2275, 48, 5, 92.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2276, 49, 1, 82.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2277, 49, 2, 78.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2278, 49, 3, 85.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2279, 49, 4, 81.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2280, 49, 5, 78.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2281, 50, 1, 74.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2282, 50, 2, 80.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2283, 50, 3, 80.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2284, 50, 4, 71.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2285, 50, 5, 77.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2286, 51, 1, 84.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2287, 51, 2, 72.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2288, 51, 3, 75.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2289, 51, 4, 84.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2290, 51, 5, 84.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2291, 52, 1, 77.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2292, 52, 2, 98.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2293, 52, 3, 92.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2294, 52, 4, 78.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2295, 52, 5, 87.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2296, 53, 1, 87.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2297, 53, 2, 88.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2298, 53, 3, 78.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2299, 53, 4, 74.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2300, 53, 5, 98.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2301, 54, 1, 93.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2302, 54, 2, 79.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2303, 54, 3, 80.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2304, 54, 4, 85.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2305, 54, 5, 89.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2306, 55, 1, 89.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2307, 55, 2, 70.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2308, 55, 3, 85.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2309, 55, 4, 83.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2310, 55, 5, 90.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2311, 56, 1, 95.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2312, 56, 2, 96.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2313, 56, 3, 82.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2314, 56, 4, 79.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2315, 56, 5, 83.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2316, 57, 1, 85.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2317, 57, 2, 81.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2318, 57, 3, 72.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2319, 57, 4, 97.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2320, 57, 5, 73.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2321, 58, 1, 93.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2322, 58, 2, 74.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2323, 58, 3, 95.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2324, 58, 4, 72.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2325, 58, 5, 80.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2326, 59, 1, 89.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2327, 59, 2, 95.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2328, 59, 3, 89.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2329, 59, 4, 72.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2330, 59, 5, 89.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2331, 60, 1, 85.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2332, 60, 2, 82.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2333, 60, 3, 97.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2334, 60, 4, 74.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2335, 60, 5, 94.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2336, 61, 1, 84.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2337, 61, 2, 73.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2338, 61, 3, 91.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2339, 61, 4, 70.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2340, 61, 5, 89.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2341, 62, 1, 93.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2342, 62, 2, 88.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2343, 62, 3, 73.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2344, 62, 4, 90.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2345, 62, 5, 97.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2346, 63, 1, 91.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2347, 63, 2, 78.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2348, 63, 3, 89.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2349, 63, 4, 74.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2350, 63, 5, 95.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2351, 64, 1, 83.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2352, 64, 2, 83.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2353, 64, 3, 90.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2354, 64, 4, 79.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2355, 64, 5, 78.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2356, 65, 1, 89.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2357, 65, 2, 96.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2358, 65, 3, 90.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2359, 65, 4, 73.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2360, 65, 5, 86.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2361, 66, 1, 91.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2362, 66, 2, 92.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2363, 66, 3, 77.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2364, 66, 4, 93.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2365, 66, 5, 91.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2366, 67, 1, 70.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2367, 67, 2, 79.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2368, 67, 3, 83.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2369, 67, 4, 77.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2370, 67, 5, 82.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2371, 68, 1, 77.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2372, 68, 2, 70.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2373, 68, 3, 91.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2374, 68, 4, 72.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2375, 68, 5, 80.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2376, 69, 1, 84.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2377, 69, 2, 93.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2378, 69, 3, 75.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2379, 69, 4, 78.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2380, 69, 5, 88.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2381, 70, 1, 73.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2382, 70, 2, 71.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2383, 70, 3, 98.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2384, 70, 4, 97.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2385, 70, 5, 75.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2386, 71, 1, 93.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2387, 71, 2, 86.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2388, 71, 3, 90.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2389, 71, 4, 73.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2390, 71, 5, 79.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2391, 72, 1, 71.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2392, 72, 2, 76.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2393, 72, 3, 90.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2394, 72, 4, 79.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2395, 72, 5, 86.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2396, 73, 1, 81.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2397, 73, 2, 75.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2398, 73, 3, 86.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2399, 73, 4, 97.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2400, 73, 5, 70.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2401, 74, 1, 76.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2402, 74, 2, 71.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2403, 74, 3, 88.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2404, 74, 4, 74.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2405, 74, 5, 92.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2406, 75, 1, 87.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2407, 75, 2, 76.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2408, 75, 3, 71.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2409, 75, 4, 93.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2410, 75, 5, 92.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2411, 76, 1, 89.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2412, 76, 2, 74.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2413, 76, 3, 78.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2414, 76, 4, 80.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2415, 76, 5, 98.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2416, 77, 1, 79.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2417, 77, 2, 82.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2418, 77, 3, 90.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2419, 77, 4, 85.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2420, 77, 5, 75.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2421, 78, 1, 84.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2422, 78, 2, 87.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2423, 78, 3, 91.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2424, 78, 4, 91.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2425, 78, 5, 99.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2426, 79, 1, 84.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2427, 79, 2, 82.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2428, 79, 3, 77.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2429, 79, 4, 79.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2430, 79, 5, 92.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2431, 80, 1, 89.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2432, 80, 2, 75.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2433, 80, 3, 87.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2434, 80, 4, 84.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2435, 80, 5, 88.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2436, 81, 1, 87.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2437, 81, 2, 77.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2438, 81, 3, 81.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2439, 81, 4, 72.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2440, 81, 5, 95.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2441, 82, 1, 81.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2442, 82, 2, 71.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2443, 82, 3, 89.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2444, 82, 4, 81.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2445, 82, 5, 76.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2446, 83, 1, 71.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2447, 83, 2, 73.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2448, 83, 3, 97.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2449, 83, 4, 80.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2450, 83, 5, 71.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2451, 84, 1, 80.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2452, 84, 2, 72.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2453, 84, 3, 95.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2454, 84, 4, 77.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2455, 84, 5, 86.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2456, 85, 1, 84.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2457, 85, 2, 86.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2458, 85, 3, 97.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2459, 85, 4, 74.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2460, 85, 5, 82.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2461, 86, 1, 93.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2462, 86, 2, 90.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2463, 86, 3, 83.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2464, 86, 4, 73.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2465, 86, 5, 92.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2466, 87, 1, 85.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2467, 87, 2, 80.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2468, 87, 3, 79.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2469, 87, 4, 88.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2470, 87, 5, 87.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2471, 88, 1, 80.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2472, 88, 2, 91.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2473, 88, 3, 86.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2474, 88, 4, 76.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2475, 88, 5, 77.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2476, 89, 1, 86.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2477, 89, 2, 83.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2478, 89, 3, 86.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2479, 89, 4, 94.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2480, 89, 5, 94.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2481, 90, 1, 97.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2482, 90, 2, 71.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2483, 90, 3, 78.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2484, 90, 4, 88.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2485, 90, 5, 90.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2486, 91, 1, 91.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2487, 91, 2, 95.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2488, 91, 3, 80.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2489, 91, 4, 86.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2490, 91, 5, 79.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2491, 92, 1, 80.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2492, 92, 2, 73.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2493, 92, 3, 76.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2494, 92, 4, 88.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2495, 92, 5, 77.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2496, 93, 1, 87.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2497, 93, 2, 81.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2498, 93, 3, 70.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2499, 93, 4, 81.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2500, 93, 5, 86.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2501, 94, 1, 82.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2502, 94, 2, 99.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2503, 94, 3, 97.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2504, 94, 4, 82.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2505, 94, 5, 85.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2506, 95, 1, 71.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2507, 95, 2, 90.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2508, 95, 3, 81.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2509, 95, 4, 84.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2510, 95, 5, 77.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2511, 96, 1, 94.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2512, 96, 2, 89.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2513, 96, 3, 76.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2514, 96, 4, 76.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2515, 96, 5, 99.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2516, 97, 1, 90.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2517, 97, 2, 72.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2518, 97, 3, 72.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2519, 97, 4, 92.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2520, 97, 5, 79.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2521, 98, 1, 80.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2522, 98, 2, 92.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2523, 98, 3, 93.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2524, 98, 4, 79.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2525, 98, 5, 78.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2526, 99, 1, 87.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2527, 99, 2, 75.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2528, 99, 3, 74.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2529, 99, 4, 89.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2530, 99, 5, 71.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2531, 100, 1, 93.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2532, 100, 2, 88.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2533, 100, 3, 87.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2534, 100, 4, 71.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2535, 100, 5, 92.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2536, 101, 1, 78.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2537, 101, 2, 71.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2538, 101, 3, 90.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2539, 101, 4, 87.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2540, 101, 5, 88.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2541, 102, 1, 98.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2542, 102, 2, 70.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2543, 102, 3, 88.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2544, 102, 4, 92.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2545, 102, 5, 94.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2546, 103, 1, 75.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2547, 103, 2, 96.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2548, 103, 3, 91.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2549, 103, 4, 95.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2550, 103, 5, 73.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2551, 104, 1, 95.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2552, 104, 2, 87.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2553, 104, 3, 95.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2554, 104, 4, 70.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2555, 104, 5, 76.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2556, 105, 1, 86.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2557, 105, 2, 93.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2558, 105, 3, 70.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2559, 105, 4, 82.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2560, 105, 5, 77.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2561, 106, 1, 87.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2562, 106, 2, 71.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2563, 106, 3, 85.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2564, 106, 4, 89.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2565, 106, 5, 90.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2566, 107, 1, 86.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2567, 107, 2, 73.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2568, 107, 3, 74.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2569, 107, 4, 71.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2570, 107, 5, 84.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2571, 108, 1, 88.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2572, 108, 2, 93.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2573, 108, 3, 74.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2574, 108, 4, 71.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2575, 108, 5, 84.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2576, 109, 1, 74.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2577, 109, 2, 80.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2578, 109, 3, 81.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2579, 109, 4, 85.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2580, 109, 5, 70.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2581, 110, 1, 82.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2582, 110, 2, 72.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2583, 110, 3, 96.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2584, 110, 4, 88.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2585, 110, 5, 80.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2586, 111, 1, 83.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2587, 111, 2, 73.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2588, 111, 3, 87.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2589, 111, 4, 81.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2590, 111, 5, 96.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2591, 112, 1, 81.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2592, 112, 2, 74.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2593, 112, 3, 92.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2594, 112, 4, 91.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2595, 112, 5, 91.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2596, 113, 1, 92.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2597, 113, 2, 76.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2598, 113, 3, 81.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2599, 113, 4, 91.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2600, 113, 5, 83.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2601, 114, 1, 88.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2602, 114, 2, 93.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2603, 114, 3, 91.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2604, 114, 4, 73.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2605, 114, 5, 71.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2606, 115, 1, 85.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2607, 115, 2, 84.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2608, 115, 3, 82.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2609, 115, 4, 94.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2610, 115, 5, 95.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2611, 116, 1, 96.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2612, 116, 2, 90.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2613, 116, 3, 90.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2614, 116, 4, 82.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2615, 116, 5, 86.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2616, 117, 1, 91.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2617, 117, 2, 97.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2618, 117, 3, 84.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2619, 117, 4, 74.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2620, 117, 5, 89.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2621, 118, 1, 77.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2622, 118, 2, 93.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2623, 118, 3, 84.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2624, 118, 4, 86.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2625, 118, 5, 97.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2626, 119, 1, 92.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2627, 119, 2, 85.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2628, 119, 3, 81.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2629, 119, 4, 73.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2630, 119, 5, 91.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2631, 120, 1, 71.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2632, 120, 2, 73.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2633, 120, 3, 74.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2634, 120, 4, 96.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2635, 120, 5, 82.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2636, 121, 1, 72.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2637, 121, 2, 84.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2638, 121, 3, 88.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2639, 121, 4, 93.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2640, 121, 5, 76.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2641, 122, 1, 77.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2642, 122, 2, 85.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2643, 122, 3, 86.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2644, 122, 4, 87.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2645, 122, 5, 77.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2646, 123, 1, 90.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2647, 123, 2, 77.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2648, 123, 3, 97.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2649, 123, 4, 90.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2650, 123, 5, 90.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2651, 124, 1, 91.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2652, 124, 2, 75.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2653, 124, 3, 82.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2654, 124, 4, 73.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2655, 124, 5, 82.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2656, 125, 1, 78.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2657, 125, 2, 87.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2658, 125, 3, 83.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2659, 125, 4, 94.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2660, 125, 5, 80.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2661, 126, 1, 89.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2662, 126, 2, 85.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2663, 126, 3, 90.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2664, 126, 4, 82.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2665, 126, 5, 80.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2666, 127, 1, 95.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2667, 127, 2, 78.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2668, 127, 3, 87.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2669, 127, 4, 74.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2670, 127, 5, 76.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2671, 128, 1, 75.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2672, 128, 2, 71.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2673, 128, 3, 75.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2674, 128, 4, 92.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2675, 128, 5, 76.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2676, 129, 1, 86.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2677, 129, 2, 73.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2678, 129, 3, 81.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2679, 129, 4, 70.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2680, 129, 5, 92.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2681, 130, 1, 88.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2682, 130, 2, 73.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2683, 130, 3, 80.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2684, 130, 4, 81.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2685, 130, 5, 92.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2686, 131, 1, 77.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2687, 131, 2, 80.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2688, 131, 3, 93.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2689, 131, 4, 72.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2690, 131, 5, 86.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2691, 132, 1, 78.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2692, 132, 2, 98.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2693, 132, 3, 71.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2694, 132, 4, 70.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2695, 132, 5, 94.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2696, 133, 1, 77.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2697, 133, 2, 96.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2698, 133, 3, 71.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2699, 133, 4, 71.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2700, 133, 5, 76.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2701, 134, 1, 89.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2702, 134, 2, 75.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2703, 134, 3, 83.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2704, 134, 4, 81.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2705, 134, 5, 95.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2706, 135, 1, 75.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2707, 135, 2, 85.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2708, 135, 3, 78.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2709, 135, 4, 90.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2710, 135, 5, 88.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2711, 136, 1, 91.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2712, 136, 2, 96.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2713, 136, 3, 70.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2714, 136, 4, 87.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2715, 136, 5, 93.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2716, 137, 1, 80.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2717, 137, 2, 82.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2718, 137, 3, 84.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2719, 137, 4, 82.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2720, 137, 5, 78.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2721, 138, 1, 70.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2722, 138, 2, 88.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2723, 138, 3, 86.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2724, 138, 4, 76.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2725, 138, 5, 87.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2726, 139, 1, 84.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2727, 139, 2, 83.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2728, 139, 3, 87.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2729, 139, 4, 74.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2730, 139, 5, 83.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2731, 140, 1, 84.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2732, 140, 2, 94.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2733, 140, 3, 90.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2734, 140, 4, 71.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2735, 140, 5, 74.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2736, 141, 1, 85.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2737, 141, 2, 77.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2738, 141, 3, 95.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2739, 141, 4, 93.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2740, 141, 5, 84.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2741, 142, 1, 78.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2742, 142, 2, 80.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2743, 142, 3, 95.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2744, 142, 4, 84.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2745, 142, 5, 78.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2746, 143, 1, 75.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2747, 143, 2, 79.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2748, 143, 3, 93.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2749, 143, 4, 94.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2750, 143, 5, 74.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2751, 144, 1, 98.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2752, 144, 2, 91.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2753, 144, 3, 88.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2754, 144, 4, 81.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2755, 144, 5, 82.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2756, 145, 1, 89.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2757, 145, 2, 73.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2758, 145, 3, 75.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2759, 145, 4, 84.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2760, 145, 5, 91.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2761, 146, 1, 88.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2762, 146, 2, 84.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2763, 146, 3, 79.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2764, 146, 4, 73.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2765, 146, 5, 90.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2766, 147, 1, 71.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2767, 147, 2, 92.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2768, 147, 3, 74.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2769, 147, 4, 94.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2770, 147, 5, 77.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2771, 148, 1, 94.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2772, 148, 2, 84.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2773, 148, 3, 87.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2774, 148, 4, 94.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2775, 148, 5, 88.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2776, 149, 1, 84.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2777, 149, 2, 92.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2778, 149, 3, 74.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2779, 149, 4, 82.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2780, 149, 5, 94.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2781, 150, 1, 94.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2782, 150, 2, 85.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2783, 150, 3, 73.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2784, 150, 4, 89.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2785, 150, 5, 83.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2786, 151, 1, 70.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2787, 151, 2, 86.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2788, 151, 3, 86.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2789, 151, 4, 74.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2790, 151, 5, 73.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2791, 152, 1, 78.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2792, 152, 2, 76.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2793, 152, 3, 92.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2794, 152, 4, 76.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2795, 152, 5, 97.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2796, 153, 1, 75.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2797, 153, 2, 83.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2798, 153, 3, 94.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2799, 153, 4, 85.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2800, 153, 5, 73.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2801, 154, 1, 77.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2802, 154, 2, 73.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2803, 154, 3, 94.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2804, 154, 4, 74.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2805, 154, 5, 82.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2806, 155, 1, 80.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2807, 155, 2, 87.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2808, 155, 3, 91.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2809, 155, 4, 80.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2810, 155, 5, 77.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2811, 156, 1, 84.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2812, 156, 2, 82.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2813, 156, 3, 81.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2814, 156, 4, 99.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2815, 156, 5, 86.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2816, 157, 1, 91.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2817, 157, 2, 90.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2818, 157, 3, 70.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2819, 157, 4, 88.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2820, 157, 5, 83.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2821, 158, 1, 76.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2822, 158, 2, 87.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2823, 158, 3, 94.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2824, 158, 4, 75.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2825, 158, 5, 72.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2826, 159, 1, 87.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2827, 159, 2, 72.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2828, 159, 3, 77.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2829, 159, 4, 70.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2830, 159, 5, 75.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2831, 160, 1, 98.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2832, 160, 2, 83.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2833, 160, 3, 89.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2834, 160, 4, 79.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2835, 160, 5, 89.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2836, 161, 1, 95.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2837, 161, 2, 87.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2838, 161, 3, 81.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2839, 161, 4, 82.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2840, 161, 5, 76.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2841, 162, 1, 86.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2842, 162, 2, 83.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2843, 162, 3, 85.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2844, 162, 4, 79.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2845, 162, 5, 82.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2846, 163, 1, 83.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2847, 163, 2, 83.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2848, 163, 3, 92.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2849, 163, 4, 73.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2850, 163, 5, 90.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2851, 164, 1, 72.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2852, 164, 2, 82.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2853, 164, 3, 90.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2854, 164, 4, 82.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2855, 164, 5, 74.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2856, 165, 1, 85.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2857, 165, 2, 94.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2858, 165, 3, 79.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2859, 165, 4, 79.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2860, 165, 5, 71.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2861, 166, 1, 70.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2862, 166, 2, 74.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2863, 166, 3, 92.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2864, 166, 4, 82.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2865, 166, 5, 90.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2866, 167, 1, 78.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2867, 167, 2, 89.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2868, 167, 3, 82.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2869, 167, 4, 90.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2870, 167, 5, 79.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2871, 168, 1, 80.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2872, 168, 2, 70.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2873, 168, 3, 81.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2874, 168, 4, 93.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2875, 168, 5, 80.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2876, 169, 1, 85.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2877, 169, 2, 88.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2878, 169, 3, 77.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2879, 169, 4, 80.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2880, 169, 5, 91.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2881, 170, 1, 77.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2882, 170, 2, 73.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2883, 170, 3, 72.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2884, 170, 4, 84.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2885, 170, 5, 82.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2886, 171, 1, 75.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2887, 171, 2, 92.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2888, 171, 3, 90.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2889, 171, 4, 70.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2890, 171, 5, 80.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2891, 172, 1, 84.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2892, 172, 2, 70.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2893, 172, 3, 95.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2894, 172, 4, 82.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2895, 172, 5, 88.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2896, 173, 1, 75.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2897, 173, 2, 88.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2898, 173, 3, 92.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2899, 173, 4, 81.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2900, 173, 5, 93.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2901, 174, 1, 87.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2902, 174, 2, 75.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2903, 174, 3, 78.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2904, 174, 4, 71.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2905, 174, 5, 86.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2906, 175, 1, 77.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2907, 175, 2, 72.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2908, 175, 3, 91.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2909, 175, 4, 77.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2910, 175, 5, 71.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2911, 176, 1, 81.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2912, 176, 2, 93.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2913, 176, 3, 82.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2914, 176, 4, 87.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2915, 176, 5, 81.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2916, 177, 1, 70.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2917, 177, 2, 95.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2918, 177, 3, 82.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2919, 177, 4, 80.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2920, 177, 5, 90.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2921, 178, 1, 95.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2922, 178, 2, 89.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2923, 178, 3, 96.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2924, 178, 4, 88.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2925, 178, 5, 77.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2926, 179, 1, 70.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2927, 179, 2, 74.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2928, 179, 3, 88.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2929, 179, 4, 85.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2930, 179, 5, 97.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2931, 180, 1, 90.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2932, 180, 2, 79.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2933, 180, 3, 75.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2934, 180, 4, 84.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2935, 180, 5, 80.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2936, 181, 1, 97.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2937, 181, 2, 83.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2938, 181, 3, 71.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2939, 181, 4, 94.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2940, 181, 5, 86.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2941, 182, 1, 76.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2942, 182, 2, 97.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2943, 182, 3, 84.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2944, 182, 4, 75.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2945, 182, 5, 87.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2946, 183, 1, 80.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2947, 183, 2, 81.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2948, 183, 3, 73.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2949, 183, 4, 73.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2950, 183, 5, 95.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2951, 184, 1, 92.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2952, 184, 2, 91.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2953, 184, 3, 93.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2954, 184, 4, 93.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2955, 184, 5, 90.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2956, 185, 1, 72.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2957, 185, 2, 70.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2958, 185, 3, 88.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2959, 185, 4, 81.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2960, 185, 5, 95.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2961, 186, 1, 90.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2962, 186, 2, 75.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2963, 186, 3, 88.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2964, 186, 4, 85.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2965, 186, 5, 86.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2966, 187, 1, 78.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2967, 187, 2, 76.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2968, 187, 3, 87.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2969, 187, 4, 90.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2970, 187, 5, 92.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2971, 188, 1, 83.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2972, 188, 2, 89.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2973, 188, 3, 84.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2974, 188, 4, 85.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2975, 188, 5, 86.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2976, 189, 1, 78.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2977, 189, 2, 86.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2978, 189, 3, 80.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2979, 189, 4, 79.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2980, 189, 5, 96.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2981, 190, 1, 96.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2982, 190, 2, 87.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2983, 190, 3, 81.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2984, 190, 4, 83.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2985, 190, 5, 73.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2986, 191, 1, 78.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2987, 191, 2, 91.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2988, 191, 3, 93.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2989, 191, 4, 80.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2990, 191, 5, 85.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2991, 192, 1, 70.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2992, 192, 2, 98.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2993, 192, 3, 82.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2994, 192, 4, 87.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2995, 192, 5, 98.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2996, 193, 1, 84.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2997, 193, 2, 80.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2998, 193, 3, 86.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (2999, 193, 4, 92.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3000, 193, 5, 72.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3001, 194, 1, 81.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3002, 194, 2, 83.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3003, 194, 3, 72.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3004, 194, 4, 72.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3005, 194, 5, 84.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3006, 195, 1, 97.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3007, 195, 2, 93.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3008, 195, 3, 75.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3009, 195, 4, 82.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3010, 195, 5, 83.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3011, 196, 1, 76.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3012, 196, 2, 70.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3013, 196, 3, 93.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3014, 196, 4, 93.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3015, 196, 5, 87.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3016, 197, 1, 89.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3017, 197, 2, 86.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3018, 197, 3, 86.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3019, 197, 4, 76.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3020, 197, 5, 86.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3021, 198, 1, 73.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3022, 198, 2, 74.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3023, 198, 3, 77.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3024, 198, 4, 71.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3025, 198, 5, 83.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3026, 199, 1, 97.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3027, 199, 2, 83.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3028, 199, 3, 74.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3029, 199, 4, 89.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3030, 199, 5, 96.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3031, 200, 1, 96.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3032, 200, 2, 74.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3033, 200, 3, 76.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3034, 200, 4, 87.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3035, 200, 5, 71.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3036, 201, 1, 87.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3037, 201, 2, 83.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3038, 201, 3, 74.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3039, 201, 4, 88.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3040, 201, 5, 74.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3041, 202, 1, 94.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3042, 202, 2, 75.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3043, 202, 3, 81.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3044, 202, 4, 85.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3045, 202, 5, 79.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3046, 203, 1, 75.90, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3047, 203, 2, 76.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3048, 203, 3, 71.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3049, 203, 4, 94.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3050, 203, 5, 93.60, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3051, 204, 1, 93.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3052, 204, 2, 76.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3053, 204, 3, 75.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3054, 204, 4, 82.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3055, 204, 5, 91.50, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3056, 205, 1, 71.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3057, 205, 2, 81.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3058, 205, 3, 71.20, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3059, 205, 4, 88.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3060, 205, 5, 93.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3061, 206, 1, 70.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3062, 206, 2, 92.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3063, 206, 3, 88.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3064, 206, 4, 71.40, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3065, 206, 5, 94.80, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3066, 207, 1, 73.30, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3067, 207, 2, 77.00, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3068, 207, 3, 86.70, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3069, 207, 4, 79.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');
INSERT INTO `score` VALUES (3070, 207, 5, 96.10, '2024-06-15', '平时', '2023-2024学年第二学期平时成绩', '2026-05-15 16:29:54', '2026-05-15 16:29:54');

-- ----------------------------
-- Table structure for student
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '瀛︾敓ID',
  `student_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '瀛﹀彿',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '濮撳悕',
  `age` int(11) NULL DEFAULT NULL COMMENT '骞撮緞',
  `gender` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '鎬у埆',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '鐢佃瘽',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '閭??',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '鍦板潃',
  `class_id` int(11) NULL DEFAULT NULL COMMENT '鐝?骇ID',
  `enrollment_date` date NULL DEFAULT NULL COMMENT '鍏ュ?鏃ユ湡',
  `student_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '鐘舵?',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `student_no`(`student_no`) USING BTREE,
  INDEX `class_id`(`class_id`) USING BTREE,
  CONSTRAINT `student_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `class` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 208 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '瀛︾敓琛' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of student
-- ----------------------------
INSERT INTO `student` VALUES (6, '20212022', '小红', 18, '男', '19902220111', '1@QQ.COM', '123124124', 1, '2026-04-21', '在读', '2026-04-22 20:50:59', '2026-04-24 17:14:12');
INSERT INTO `student` VALUES (7, '20212021', '花花', 20, '男', '11088999977', '12@qq.com', 'poiu', 1, '2026-04-21', '在读', '2026-04-22 21:06:15', '2026-04-24 17:14:05');
INSERT INTO `student` VALUES (8, '2024001001', '蒋斌', 22, '男', '15582344126', 'student2024001001@example.com', '北京市海淀区4号', 1, '2024-10-06', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (9, '2024001002', '吕莉', 19, '女', '18767954089', 'student2024001002@example.com', '北京市海淀区44号', 1, '2024-10-04', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (10, '2024001003', '彭蓉', 18, '女', '15626583270', 'student2024001003@example.com', '北京市海淀区74号', 1, '2023-06-04', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (11, '2024001004', '鲁昊', 23, '男', '17428236754', 'student2024001004@example.com', '北京市海淀区84号', 1, '2023-05-10', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (12, '2024001005', '孙华', 19, '男', '19747724801', 'student2024001005@example.com', '北京市海淀区97号', 1, '2023-08-07', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (13, '2024001006', '穆军', 22, '男', '18462688534', 'student2024001006@example.com', '北京市海淀区79号', 1, '2023-10-28', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (14, '2024001007', '郎燕', 20, '女', '14405108362', 'student2024001007@example.com', '北京市海淀区39号', 1, '2025-01-25', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (15, '2024001008', '郑健', 23, '男', '14773009311', 'student2024001008@example.com', '北京市海淀区67号', 1, '2024-04-16', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (16, '2024001009', '谢雪', 22, '女', '13829048664', 'student2024001009@example.com', '北京市海淀区14号', 1, '2024-09-24', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (17, '2024001010', '沈宇', 21, '男', '16634717770', 'student2024001010@example.com', '北京市海淀区64号', 1, '2023-06-01', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (18, '2024001011', '沈博文', 23, '男', '17544487034', 'student2024001011@example.com', '北京市海淀区37号', 1, '2024-10-19', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (19, '2024001012', '奚睿', 23, '男', '17589680685', 'student2024001012@example.com', '北京市海淀区14号', 1, '2024-10-05', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (20, '2024001013', '卫娜', 22, '女', '15468956361', 'student2024001013@example.com', '北京市海淀区5号', 1, '2024-01-21', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (21, '2024001014', '伍蕾', 19, '女', '16598080722', 'student2024001014@example.com', '北京市海淀区18号', 1, '2024-10-19', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (22, '2024001015', '邬晶晶', 19, '女', '18848422502', 'student2024001015@example.com', '北京市海淀区28号', 1, '2023-07-03', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (23, '2024001016', '岑辉', 19, '男', '17789914181', 'student2024001016@example.com', '北京市海淀区89号', 1, '2024-01-01', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (24, '2024001017', '蒋珊', 20, '女', '17747070652', 'student2024001017@example.com', '北京市海淀区60号', 1, '2023-12-10', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (25, '2024001018', '曹辰', 20, '男', '15343294146', 'student2024001018@example.com', '北京市海淀区82号', 1, '2024-05-21', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (26, '2024001019', '施薇', 20, '女', '17407690679', 'student2024001019@example.com', '北京市海淀区73号', 1, '2023-08-10', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (27, '2024001020', '曹敏敏', 19, '女', '14370744988', 'student2024001020@example.com', '北京市海淀区48号', 1, '2023-07-09', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (28, '2024001021', '严霞', 23, '女', '18973504424', 'student2024001021@example.com', '北京市海淀区53号', 1, '2024-06-24', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (29, '2024001022', '郝晶晶', 22, '女', '17594732158', 'student2024001022@example.com', '北京市海淀区61号', 1, '2023-12-13', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (30, '2024001023', '葛涛', 21, '男', '16283147340', 'student2024001023@example.com', '北京市海淀区79号', 1, '2024-03-26', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (31, '2024001024', '曹颖颖', 18, '女', '13574766622', 'student2024001024@example.com', '北京市海淀区13号', 1, '2023-05-06', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (32, '2024001025', '柳昊', 20, '男', '18839033265', 'student2024001025@example.com', '北京市海淀区57号', 1, '2024-07-05', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (33, '2024001026', '冯娜娜', 21, '女', '15923655956', 'student2024001026@example.com', '北京市海淀区92号', 1, '2024-05-10', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (34, '2024001027', '窦平', 19, '男', '15502913605', 'student2024001027@example.com', '北京市海淀区53号', 1, '2023-09-05', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (35, '2024001028', '吴敏敏', 22, '女', '15991740543', 'student2024001028@example.com', '北京市海淀区79号', 1, '2023-04-25', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (36, '2024001029', '鲍洋', 20, '男', '17492988777', 'student2024001029@example.com', '北京市海淀区25号', 1, '2023-08-10', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (37, '2024001030', '花霞', 21, '女', '15404992869', 'student2024001030@example.com', '北京市海淀区35号', 1, '2024-12-10', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (38, '2024001031', '邹明', 18, '男', '16531999121', 'student2024001031@example.com', '北京市海淀区59号', 1, '2024-06-29', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (39, '2024001032', '秦军', 20, '男', '14936021824', 'student2024001032@example.com', '北京市海淀区13号', 1, '2024-08-31', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (40, '2024001033', '傅勇', 23, '男', '16617264985', 'student2024001033@example.com', '北京市海淀区3号', 1, '2024-11-27', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (41, '2024001034', '许燕', 19, '女', '19284077585', 'student2024001034@example.com', '北京市海淀区87号', 1, '2024-01-24', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (42, '2024001035', '史昊', 18, '男', '19514505693', 'student2024001035@example.com', '北京市海淀区24号', 1, '2024-10-06', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (43, '2024001036', '马芳芳', 23, '女', '13551217120', 'student2024001036@example.com', '北京市海淀区16号', 1, '2024-05-24', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (44, '2024001037', '喻丽丽', 18, '女', '16543819934', 'student2024001037@example.com', '北京市海淀区10号', 1, '2025-02-17', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (45, '2024001038', '安莹', 18, '女', '18108257666', 'student2024001038@example.com', '北京市海淀区18号', 1, '2023-08-25', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (46, '2024001039', '史琳', 20, '女', '15310631828', 'student2024001039@example.com', '北京市海淀区21号', 1, '2023-10-08', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (47, '2024001040', '酆莉', 21, '女', '18573217259', 'student2024001040@example.com', '北京市海淀区17号', 1, '2024-03-08', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (48, '2024001041', '毕辰', 21, '男', '14756077184', 'student2024001041@example.com', '北京市海淀区89号', 1, '2025-02-02', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (49, '2024001042', '姜强', 18, '男', '14905409234', 'student2024001042@example.com', '北京市海淀区89号', 1, '2023-08-19', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (50, '2024001043', '韩秀秀', 20, '女', '18984949292', 'student2024001043@example.com', '北京市海淀区5号', 1, '2025-03-23', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (51, '2024001044', '褚伟', 21, '男', '18184919716', 'student2024001044@example.com', '北京市海淀区8号', 1, '2024-06-25', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (52, '2024001045', '蒋晶', 22, '女', '13481414340', 'student2024001045@example.com', '北京市海淀区84号', 1, '2025-02-23', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (53, '2024001046', '严明', 23, '男', '14709326310', 'student2024001046@example.com', '北京市海淀区34号', 1, '2024-10-03', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (54, '2024001047', '平丽', 19, '女', '15232776313', 'student2024001047@example.com', '北京市海淀区94号', 1, '2024-12-06', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (55, '2024001048', '贺明轩', 21, '男', '19633297953', 'student2024001048@example.com', '北京市海淀区76号', 1, '2024-06-05', '毕业', '2026-04-23 07:47:23', '2026-04-25 11:17:54');
INSERT INTO `student` VALUES (56, '2024002001', '伍浩', 20, '男', '17617748506', 'student2024002001@example.com', '北京市朝阳区88号', 2, '2024-09-01', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (57, '2024002002', '朱凯', 21, '男', '14702132933', 'student2024002002@example.com', '北京市朝阳区61号', 2, '2024-02-05', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (58, '2024002003', '郝明', 20, '男', '17188324246', 'student2024002003@example.com', '北京市朝阳区17号', 2, '2025-03-05', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (59, '2024002004', '廉洁', 19, '女', '16518959382', 'student2024002004@example.com', '北京市朝阳区40号', 2, '2024-06-05', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (60, '2024002005', '平芳芳', 22, '女', '19760728060', 'student2024002005@example.com', '北京市朝阳区100号', 2, '2025-03-06', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (61, '2024002006', '鲁斌', 18, '男', '15994369336', 'student2024002006@example.com', '北京市朝阳区48号', 2, '2024-12-02', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (62, '2024002007', '马蕾', 21, '女', '16752068338', 'student2024002007@example.com', '北京市朝阳区80号', 2, '2024-03-26', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (63, '2024002008', '卞天', 19, '男', '13847861152', 'student2024002008@example.com', '北京市朝阳区52号', 2, '2024-11-10', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (64, '2024002009', '杨莹', 22, '女', '15512959362', 'student2024002009@example.com', '北京市朝阳区16号', 2, '2023-10-12', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (65, '2024002010', '秦蓉', 20, '女', '14116599608', 'student2024002010@example.com', '北京市朝阳区2号', 2, '2023-11-01', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (66, '2024002011', '柳婷', 22, '女', '15177242124', 'student2024002011@example.com', '北京市朝阳区36号', 2, '2023-06-28', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (67, '2024002012', '邹磊', 23, '男', '17506822747', 'student2024002012@example.com', '北京市朝阳区55号', 2, '2023-08-16', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (68, '2024002013', '章睿', 18, '男', '19487722763', 'student2024002013@example.com', '北京市朝阳区8号', 2, '2024-01-12', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (69, '2024002014', '吕娜娜', 22, '女', '16805781152', 'student2024002014@example.com', '北京市朝阳区13号', 2, '2024-09-05', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (70, '2024002015', '潘婷', 20, '女', '16377446056', 'student2024002015@example.com', '北京市朝阳区13号', 2, '2024-01-29', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (71, '2024002016', '常皓', 22, '男', '19538424034', 'student2024002016@example.com', '北京市朝阳区47号', 2, '2024-01-23', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (72, '2024002017', '周健', 20, '男', '19715508746', 'student2024002017@example.com', '北京市朝阳区48号', 2, '2024-05-29', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (73, '2024002018', '邹健', 23, '男', '17653628868', 'student2024002018@example.com', '北京市朝阳区4号', 2, '2023-07-02', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (74, '2024002019', '蒋娜', 21, '女', '15180083193', 'student2024002019@example.com', '北京市朝阳区53号', 2, '2024-05-31', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (75, '2024002020', '薛玲', 18, '女', '15930102224', 'student2024002020@example.com', '北京市朝阳区43号', 2, '2023-11-22', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (76, '2024002021', '鲍波', 20, '男', '19531793315', 'student2024002021@example.com', '北京市朝阳区30号', 2, '2023-11-03', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (77, '2024002022', '薛子轩', 19, '男', '15334518651', 'student2024002022@example.com', '北京市朝阳区89号', 2, '2024-10-09', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (78, '2024002023', '许珊', 23, '女', '18827788801', 'student2024002023@example.com', '北京市朝阳区99号', 2, '2024-10-12', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (79, '2024002024', '郎凯', 22, '男', '15757278565', 'student2024002024@example.com', '北京市朝阳区45号', 2, '2023-09-15', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (80, '2024002025', '葛睿', 23, '男', '16363708679', 'student2024002025@example.com', '北京市朝阳区40号', 2, '2025-03-08', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (81, '2024002026', '费峰', 22, '男', '19401600313', 'student2024002026@example.com', '北京市朝阳区84号', 2, '2025-03-07', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (82, '2024002027', '郎静静', 23, '女', '14796298429', 'student2024002027@example.com', '北京市朝阳区13号', 2, '2025-04-16', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (83, '2024002028', '孔刚', 22, '男', '19725461688', 'student2024002028@example.com', '北京市朝阳区92号', 2, '2024-02-17', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (84, '2024002029', '伍敏', 20, '女', '17520545916', 'student2024002029@example.com', '北京市朝阳区75号', 2, '2024-06-02', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (85, '2024002030', '鲁健', 20, '男', '14231443425', 'student2024002030@example.com', '北京市朝阳区26号', 2, '2024-05-24', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (86, '2024002031', '卫明', 19, '男', '19613444062', 'student2024002031@example.com', '北京市朝阳区25号', 2, '2025-01-05', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (87, '2024002032', '雷梅梅', 23, '女', '18715273190', 'student2024002032@example.com', '北京市朝阳区75号', 2, '2024-05-27', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (88, '2024002033', '安芳', 22, '女', '16352900943', 'student2024002033@example.com', '北京市朝阳区12号', 2, '2024-07-25', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (89, '2024002034', '谢明轩', 23, '男', '14902878343', 'student2024002034@example.com', '北京市朝阳区70号', 2, '2024-01-25', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (90, '2024002035', '葛娜娜', 19, '女', '19236225726', 'student2024002035@example.com', '北京市朝阳区90号', 2, '2024-07-01', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (91, '2024002036', '卫娜', 22, '女', '15174017367', 'student2024002036@example.com', '北京市朝阳区48号', 2, '2023-06-11', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (92, '2024002037', '彭蕾', 20, '女', '19638072103', 'student2024002037@example.com', '北京市朝阳区58号', 2, '2024-04-25', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (93, '2024002038', '毕浩然', 18, '男', '19881888504', 'student2024002038@example.com', '北京市朝阳区79号', 2, '2023-10-12', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (94, '2024002039', '常刚', 21, '男', '18418146769', 'student2024002039@example.com', '北京市朝阳区5号', 2, '2024-03-04', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (95, '2024002040', '章伟', 23, '男', '15485646632', 'student2024002040@example.com', '北京市朝阳区54号', 2, '2024-04-08', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (96, '2024002041', '凤军', 18, '男', '17671220247', 'student2024002041@example.com', '北京市朝阳区95号', 2, '2024-09-04', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (97, '2024002042', '傅平', 21, '男', '16664234836', 'student2024002042@example.com', '北京市朝阳区34号', 2, '2023-06-21', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (98, '2024002043', '喻子轩', 22, '男', '18720832612', 'student2024002043@example.com', '北京市朝阳区59号', 2, '2023-11-19', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (99, '2024002044', '傅秀', 18, '女', '17380099461', 'student2024002044@example.com', '北京市朝阳区66号', 2, '2025-01-14', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (100, '2024002045', '赵玲', 23, '女', '14147282671', 'student2024002045@example.com', '北京市朝阳区51号', 2, '2024-07-10', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (101, '2024002046', '顾皓', 20, '男', '18821553063', 'student2024002046@example.com', '北京市朝阳区85号', 2, '2024-01-09', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (102, '2024002047', '于浩', 20, '男', '19188450481', 'student2024002047@example.com', '北京市朝阳区61号', 2, '2023-11-17', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (103, '2024002048', '许静静', 22, '女', '18243131047', 'student2024002048@example.com', '北京市朝阳区89号', 2, '2024-03-01', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (104, '2024002049', '袁芳芳', 19, '女', '18102721643', 'student2024002049@example.com', '北京市朝阳区73号', 2, '2025-02-17', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (105, '2024002050', '吕杰', 18, '男', '17450737178', 'student2024002050@example.com', '北京市朝阳区76号', 2, '2023-12-23', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (106, '2024003001', '魏涛', 22, '男', '13203702212', 'student2024003001@example.com', '上海市浦东新区61号', 3, '2024-05-30', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (107, '2024003002', '赵强', 19, '男', '15787557850', 'student2024003002@example.com', '上海市浦东新区57号', 3, '2024-11-19', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (108, '2024003003', '余秀秀', 22, '女', '18398763457', 'student2024003003@example.com', '上海市浦东新区72号', 3, '2023-11-20', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (109, '2024003004', '穆敏敏', 18, '女', '19571840187', 'student2024003004@example.com', '上海市浦东新区56号', 3, '2024-04-09', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (110, '2024003005', '范凯', 18, '男', '15216951162', 'student2024003005@example.com', '上海市浦东新区20号', 3, '2024-05-31', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (111, '2024003006', '孔晶', 20, '女', '14925496515', 'student2024003006@example.com', '上海市浦东新区20号', 3, '2024-03-16', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (112, '2024003007', '俞瑶', 18, '女', '19964464303', 'student2024003007@example.com', '上海市浦东新区90号', 3, '2023-07-22', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (113, '2024003008', '华波', 22, '男', '14357674666', 'student2024003008@example.com', '上海市浦东新区85号', 3, '2024-09-03', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (114, '2024003009', '罗梅', 23, '女', '19534186777', 'student2024003009@example.com', '上海市浦东新区49号', 3, '2023-09-21', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (115, '2024003010', '何辰', 20, '男', '14884585779', 'student2024003010@example.com', '上海市浦东新区80号', 3, '2023-11-13', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (116, '2024003011', '罗宇', 20, '男', '18381875568', 'student2024003011@example.com', '上海市浦东新区70号', 3, '2024-12-02', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (117, '2024003012', '朱蕾', 18, '女', '15240480157', 'student2024003012@example.com', '上海市浦东新区63号', 3, '2024-07-19', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (118, '2024003013', '冯凯', 20, '男', '14620759555', 'student2024003013@example.com', '上海市浦东新区87号', 3, '2023-05-04', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (119, '2024003014', '卞波', 18, '男', '14681567209', 'student2024003014@example.com', '上海市浦东新区73号', 3, '2024-01-13', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (120, '2024003015', '薛峰', 20, '男', '15725665564', 'student2024003015@example.com', '上海市浦东新区19号', 3, '2024-05-18', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (121, '2024003016', '尹婷', 18, '女', '14834209237', 'student2024003016@example.com', '上海市浦东新区50号', 3, '2023-07-16', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (122, '2024003017', '余蕾', 19, '女', '17249274960', 'student2024003017@example.com', '上海市浦东新区26号', 3, '2024-06-18', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (123, '2024003018', '元峰', 20, '男', '15661279402', 'student2024003018@example.com', '上海市浦东新区78号', 3, '2025-03-23', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (124, '2024003019', '曹俊杰', 23, '男', '16859797776', 'student2024003019@example.com', '上海市浦东新区95号', 3, '2025-03-08', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (125, '2024003020', '袁娜娜', 19, '女', '19394302008', 'student2024003020@example.com', '上海市浦东新区46号', 3, '2023-08-04', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (126, '2024003021', '姜凯', 20, '男', '16605641424', 'student2024003021@example.com', '上海市浦东新区50号', 3, '2023-05-18', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (127, '2024003022', '于超', 23, '男', '17248305835', 'student2024003022@example.com', '上海市浦东新区9号', 3, '2024-04-21', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (128, '2024003023', '柏华', 19, '女', '14540485114', 'student2024003023@example.com', '上海市浦东新区90号', 3, '2025-04-14', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (129, '2024003024', '穆娜', 20, '女', '19915908807', 'student2024003024@example.com', '上海市浦东新区34号', 3, '2023-06-24', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (130, '2024003025', '戚颖颖', 21, '女', '13946305969', 'student2024003025@example.com', '上海市浦东新区74号', 3, '2024-10-07', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (131, '2024003026', '杨建', 19, '男', '17185201988', 'student2024003026@example.com', '上海市浦东新区32号', 3, '2024-03-27', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (132, '2024003027', '袁明轩', 23, '男', '16981911628', 'student2024003027@example.com', '上海市浦东新区80号', 3, '2024-11-25', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (133, '2024003028', '和艳', 21, '女', '14102140874', 'student2024003028@example.com', '上海市浦东新区44号', 3, '2024-10-16', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (134, '2024003029', '章珊', 19, '女', '18738875285', 'student2024003029@example.com', '上海市浦东新区2号', 3, '2024-04-13', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (135, '2024003030', '任峰', 21, '男', '17107806402', 'student2024003030@example.com', '上海市浦东新区47号', 3, '2024-03-19', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (136, '2024003031', '穆明轩', 20, '男', '13933433812', 'student2024003031@example.com', '上海市浦东新区22号', 3, '2024-11-18', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (137, '2024003032', '岑强', 20, '男', '15704697488', 'student2024003032@example.com', '上海市浦东新区7号', 3, '2024-12-23', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (138, '2024003033', '毕颖', 19, '女', '18620301942', 'student2024003033@example.com', '上海市浦东新区89号', 3, '2024-01-20', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (139, '2024003034', '孙丽丽', 18, '女', '16462473329', 'student2024003034@example.com', '上海市浦东新区37号', 3, '2024-04-12', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (140, '2024003035', '秦明轩', 23, '男', '18884429492', 'student2024003035@example.com', '上海市浦东新区85号', 3, '2024-09-07', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (141, '2024003036', '范凯', 19, '男', '15323552864', 'student2024003036@example.com', '上海市浦东新区39号', 3, '2023-07-25', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (142, '2024003037', '费秀', 23, '女', '17739395499', 'student2024003037@example.com', '上海市浦东新区13号', 3, '2024-08-18', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (143, '2024003038', '奚洁', 21, '女', '17780948287', 'student2024003038@example.com', '上海市浦东新区90号', 3, '2023-06-07', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (144, '2024003039', '史文', 19, '男', '19199056346', 'student2024003039@example.com', '上海市浦东新区80号', 3, '2023-08-10', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (145, '2024003040', '平蕾', 21, '女', '18406482434', 'student2024003040@example.com', '上海市浦东新区25号', 3, '2024-12-07', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (146, '2024003041', '金洋', 21, '男', '14828922332', 'student2024003041@example.com', '上海市浦东新区89号', 3, '2023-04-25', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (147, '2024003042', '陶建', 20, '男', '16977375185', 'student2024003042@example.com', '上海市浦东新区1号', 3, '2024-03-04', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (148, '2024003043', '许伟', 18, '男', '14767675238', 'student2024003043@example.com', '上海市浦东新区58号', 3, '2024-09-16', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (149, '2024003044', '金杰', 19, '男', '15384938912', 'student2024003044@example.com', '上海市浦东新区55号', 3, '2023-09-15', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (150, '2024003045', '孔浩', 18, '男', '17274314561', 'student2024003045@example.com', '上海市浦东新区91号', 3, '2024-07-05', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (151, '2024003046', '郝秀秀', 21, '女', '16667767784', 'student2024003046@example.com', '上海市浦东新区38号', 3, '2023-10-13', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (152, '2024003047', '尹波', 20, '男', '13253157396', 'student2024003047@example.com', '上海市浦东新区47号', 3, '2024-09-29', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (153, '2024003048', '凤莹', 21, '女', '14303840298', 'student2024003048@example.com', '上海市浦东新区35号', 3, '2024-10-07', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (154, '2024003049', '苗倩', 22, '女', '18396579005', 'student2024003049@example.com', '上海市浦东新区97号', 3, '2023-07-23', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (155, '2024003050', '卜文', 23, '男', '19790108446', 'student2024003050@example.com', '上海市浦东新区59号', 3, '2023-11-28', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (156, '2024004001', '薛静', 18, '女', '15289558745', 'student2024004001@example.com', '广州市天河区21号', 4, '2025-04-21', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (157, '2024004002', '袁明轩', 23, '男', '19776967327', 'student2024004002@example.com', '广州市天河区58号', 4, '2023-08-12', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (158, '2024004003', '云娜', 20, '女', '14935554173', 'student2024004003@example.com', '广州市天河区25号', 4, '2025-04-14', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (159, '2024004004', '韦婷', 20, '女', '13178698326', 'student2024004004@example.com', '广州市天河区74号', 4, '2023-07-21', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (160, '2024004005', '殷敏', 22, '女', '15292704155', 'student2024004005@example.com', '广州市天河区76号', 4, '2023-11-06', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (161, '2024004006', '康子轩', 22, '男', '19699408248', 'student2024004006@example.com', '广州市天河区62号', 4, '2024-07-23', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (162, '2024004007', '孟芳芳', 23, '女', '14688789501', 'student2024004007@example.com', '广州市天河区75号', 4, '2024-07-12', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (163, '2024004008', '鲁慧', 22, '女', '14441179011', 'student2024004008@example.com', '广州市天河区94号', 4, '2024-12-09', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (164, '2024004009', '邬华', 18, '男', '19999739478', 'student2024004009@example.com', '广州市天河区6号', 4, '2023-04-26', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (165, '2024004010', '伍艳', 21, '女', '16568896007', 'student2024004010@example.com', '广州市天河区45号', 4, '2024-04-28', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (166, '2024004011', '褚艳', 18, '女', '17327183377', 'student2024004011@example.com', '广州市天河区89号', 4, '2024-09-15', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (167, '2024004012', '俞华', 22, '男', '19825127261', 'student2024004012@example.com', '广州市天河区64号', 4, '2024-10-19', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (168, '2024004013', '郑梅梅', 18, '女', '19811215683', 'student2024004013@example.com', '广州市天河区8号', 4, '2024-01-09', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (169, '2024004014', '马蓉', 22, '女', '14764384432', 'student2024004014@example.com', '广州市天河区39号', 4, '2024-06-19', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (170, '2024004015', '韦瑶', 23, '女', '18761648249', 'student2024004015@example.com', '广州市天河区31号', 4, '2023-06-19', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (171, '2024004016', '袁华', 19, '男', '13653957228', 'student2024004016@example.com', '广州市天河区38号', 4, '2023-05-12', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (172, '2024004017', '钱薇', 20, '女', '19909385346', 'student2024004017@example.com', '广州市天河区66号', 4, '2023-12-16', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (173, '2024004018', '贺洁', 22, '女', '14960574628', 'student2024004018@example.com', '广州市天河区81号', 4, '2024-03-26', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (174, '2024004019', '于辉', 20, '男', '15535106187', 'student2024004019@example.com', '广州市天河区65号', 4, '2024-06-11', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (175, '2024004020', '金军', 22, '男', '13333028964', 'student2024004020@example.com', '广州市天河区80号', 4, '2023-09-29', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (176, '2024004021', '顾辰', 23, '男', '14475491517', 'student2024004021@example.com', '广州市天河区36号', 4, '2024-10-12', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (177, '2024004022', '水超', 18, '男', '17451932466', 'student2024004022@example.com', '广州市天河区61号', 4, '2023-08-19', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (178, '2024004023', '傅鹏', 23, '男', '13264871640', 'student2024004023@example.com', '广州市天河区75号', 4, '2023-07-29', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (179, '2024004024', '朱蕾', 18, '女', '18407330425', 'student2024004024@example.com', '广州市天河区11号', 4, '2023-12-18', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (180, '2024004025', '袁艳', 18, '女', '14337922908', 'student2024004025@example.com', '广州市天河区3号', 4, '2024-08-24', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (181, '2024004026', '余倩', 22, '女', '16973653837', 'student2024004026@example.com', '广州市天河区23号', 4, '2023-11-03', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (182, '2024004027', '陈伟', 21, '男', '17218027279', 'student2024004027@example.com', '广州市天河区29号', 4, '2025-01-30', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (183, '2024004028', '陈洁', 21, '女', '13471335177', 'student2024004028@example.com', '广州市天河区57号', 4, '2025-02-28', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (184, '2024004029', '喻斌', 21, '男', '17171979466', 'student2024004029@example.com', '广州市天河区5号', 4, '2023-12-21', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (185, '2024004030', '窦梓', 20, '男', '19217116782', 'student2024004030@example.com', '广州市天河区9号', 4, '2024-07-06', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (186, '2024004031', '施宇航', 18, '男', '19569055075', 'student2024004031@example.com', '广州市天河区46号', 4, '2023-07-20', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (187, '2024004032', '袁慧', 22, '女', '13941111946', 'student2024004032@example.com', '广州市天河区78号', 4, '2025-02-15', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (188, '2024004033', '王琳', 22, '女', '17520724331', 'student2024004033@example.com', '广州市天河区13号', 4, '2023-05-18', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (189, '2024004034', '柳浩然', 23, '男', '16891499725', 'student2024004034@example.com', '广州市天河区38号', 4, '2025-01-31', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (190, '2024004035', '袁蓉', 19, '女', '15597667158', 'student2024004035@example.com', '广州市天河区27号', 4, '2024-08-07', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (191, '2024004036', '金丽丽', 18, '女', '14396877794', 'student2024004036@example.com', '广州市天河区72号', 4, '2023-06-12', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (192, '2024004037', '周霞', 23, '女', '19706324239', 'student2024004037@example.com', '广州市天河区14号', 4, '2025-03-02', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (193, '2024004038', '殷健', 23, '男', '15314133835', 'student2024004038@example.com', '广州市天河区63号', 4, '2024-09-30', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (194, '2024004039', '郑明轩', 20, '男', '16790899528', 'student2024004039@example.com', '广州市天河区63号', 4, '2024-10-24', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (195, '2024004040', '贺磊', 22, '男', '19469506201', 'student2024004040@example.com', '广州市天河区60号', 4, '2023-11-12', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (196, '2024004041', '潘伟', 19, '男', '14437673593', 'student2024004041@example.com', '广州市天河区40号', 4, '2023-06-25', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (197, '2024004042', '皮皓', 23, '男', '16328743849', 'student2024004042@example.com', '广州市天河区93号', 4, '2023-08-16', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (198, '2024004043', '彭静', 22, '女', '13369080821', 'student2024004043@example.com', '广州市天河区5号', 4, '2025-02-24', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (199, '2024004044', '谢洁', 20, '女', '18103434166', 'student2024004044@example.com', '广州市天河区75号', 4, '2023-04-30', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (200, '2024004045', '邬雪', 22, '女', '19840877865', 'student2024004045@example.com', '广州市天河区77号', 4, '2024-08-22', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (201, '2024004046', '顾静静', 23, '女', '19151155749', 'student2024004046@example.com', '广州市天河区87号', 4, '2024-04-07', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (202, '2024004047', '李明轩', 18, '男', '17609333168', 'student2024004047@example.com', '广州市天河区22号', 4, '2025-04-01', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (203, '2024004048', '穆莉', 23, '女', '17731787442', 'student2024004048@example.com', '广州市天河区18号', 4, '2025-02-18', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (204, '2024004049', '平梅', 22, '女', '18573078317', 'student2024004049@example.com', '广州市天河区29号', 4, '2024-04-30', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (205, '2024004050', '倪皓', 20, '男', '17332760699', 'student2024004050@example.com', '广州市天河区52号', 4, '2024-12-27', '在读', '2026-04-23 07:47:23', '2026-04-23 07:47:23');
INSERT INTO `student` VALUES (206, 'TEST001', '测试学生', 20, '男', '13800138000', 'test@example.com', NULL, 1, '2024-09-01', '在读', '2026-05-13 22:28:32', '2026-05-13 22:28:32');
INSERT INTO `student` VALUES (207, '20210001', 'QQH', 21, '男', '18848328887', '2113267199@qq.com', '四川遂宁', 1, '2026-05-14', '毕业', '2026-05-15 14:27:17', '2026-05-15 14:27:17');

-- ----------------------------
-- Table structure for student_warning
-- ----------------------------
DROP TABLE IF EXISTS `student_warning`;
CREATE TABLE `student_warning`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '棰勮?ID',
  `student_id` int(11) NOT NULL COMMENT '瀛︾敓ID',
  `rule_id` int(11) NULL DEFAULT NULL COMMENT '瑙勫垯ID',
  `warning_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '棰勮?绫诲瀷: SCORE-鎴愮哗, ATTENDANCE-鑰冨嫟, COMPREHENSIVE-缁煎悎',
  `warning_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '棰勮?绛夌骇: YELLOW-榛勮壊, ORANGE-姗欒壊, RED-绾㈣壊',
  `warning_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '棰勮?鍘熷洜',
  `related_course_id` int(11) NULL DEFAULT NULL COMMENT '鐩稿叧璇剧▼ID',
  `related_score` decimal(5, 2) NULL DEFAULT NULL COMMENT '鐩稿叧鎴愮哗',
  `attendance_count` int(11) NULL DEFAULT NULL COMMENT '缂哄嫟娆℃暟',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'PENDING' COMMENT '鐘舵?: PENDING-寰呭?鐞? PROCESSING-澶勭悊涓? RESOLVED-宸茶В鍐? IGNORED-宸插拷鐣',
  `handler_id` int(11) NULL DEFAULT NULL COMMENT '澶勭悊浜篒D',
  `handle_remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '澶勭悊澶囨敞',
  `handle_time` datetime NULL DEFAULT NULL COMMENT '澶勭悊鏃堕棿',
  `notify_status` tinyint(4) NULL DEFAULT 0 COMMENT '閫氱煡鐘舵?: 0-鏈??鐭? 1-宸查?鐭',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `student_id`(`student_id`) USING BTREE,
  INDEX `rule_id`(`rule_id`) USING BTREE,
  INDEX `related_course_id`(`related_course_id`) USING BTREE,
  INDEX `handler_id`(`handler_id`) USING BTREE,
  CONSTRAINT `student_warning_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `student_warning_ibfk_2` FOREIGN KEY (`rule_id`) REFERENCES `warning_rule` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `student_warning_ibfk_3` FOREIGN KEY (`related_course_id`) REFERENCES `course` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `student_warning_ibfk_4` FOREIGN KEY (`handler_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '瀛︾敓棰勮?璁板綍琛' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of student_warning
-- ----------------------------

-- ----------------------------
-- Table structure for system_settings
-- ----------------------------
DROP TABLE IF EXISTS `system_settings`;
CREATE TABLE `system_settings`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '璁剧疆ID',
  `setting_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '璁剧疆閿',
  `setting_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '璁剧疆鍊',
  `setting_desc` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '璁剧疆鎻忚堪',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `setting_key`(`setting_key`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '绯荤粺璁剧疆琛' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_settings
-- ----------------------------
INSERT INTO `system_settings` VALUES (1, 'school_name', 'vue3 spring-boot', 'School Name', '2026-04-19 00:39:50', '2026-04-19 13:42:15');
INSERT INTO `system_settings` VALUES (2, 'school_address', '123 Demo Street', 'School Address', '2026-04-19 00:39:50', '2026-04-19 00:39:50');
INSERT INTO `system_settings` VALUES (3, 'school_phone', '010-12345678', 'Contact Phone', '2026-04-19 00:39:50', '2026-04-19 00:39:50');
INSERT INTO `system_settings` VALUES (4, 'current_semester', '2024-2025 Semester 1', 'Current Semester', '2026-04-19 00:39:50', '2026-04-19 00:39:50');
INSERT INTO `system_settings` VALUES (5, 'pass_score', '60', 'Pass Score', '2026-04-19 00:39:50', '2026-04-19 00:39:50');
INSERT INTO `system_settings` VALUES (6, 'excellent_score', '95', 'Excellent Score', '2026-04-19 00:39:50', '2026-04-19 13:13:03');
INSERT INTO `system_settings` VALUES (7, 'attendance_warning_days', '3', 'Attendance Warning Days', '2026-04-19 00:39:50', '2026-04-19 00:39:50');
INSERT INTO `system_settings` VALUES (8, 'system_version', 'v1.0.0', 'System Version', '2026-04-19 00:39:50', '2026-04-19 00:39:50');

-- ----------------------------
-- Table structure for teacher_preference
-- ----------------------------
DROP TABLE IF EXISTS `teacher_preference`;
CREATE TABLE `teacher_preference`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '鍋忓ソID',
  `teacher_id` int(11) NOT NULL COMMENT '鏁欏笀ID',
  `preferred_days` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '鍋忓ソ鏄熸湡锛?-7锛屽?涓?敤閫楀彿鍒嗛殧锛',
  `preferred_slots` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '鍋忓ソ鏃堕棿娈碉紙濡傦細1-2,3-4,5-6锛',
  `avoided_days` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '涓嶅枩娆㈢殑鏄熸湡',
  `avoided_slots` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '涓嶅枩娆㈢殑鏃堕棿娈',
  `max_daily_hours` int(11) NULL DEFAULT 4 COMMENT '姣忓ぉ鏈??璇炬椂',
  `max_weekly_hours` int(11) NULL DEFAULT 16 COMMENT '姣忓懆鏈??璇炬椂',
  `allow_consecutive` tinyint(4) NULL DEFAULT 1 COMMENT '鏄?惁鍏佽?杩炲爞: 0-鍚? 1-鏄',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '澶囨敞',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_teacher`(`teacher_id`) USING BTREE,
  CONSTRAINT `teacher_preference_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '鏁欏笀鍋忓ソ璁剧疆琛' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of teacher_preference
-- ----------------------------

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '鐢ㄦ埛ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '鐢ㄦ埛鍚',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '瀵嗙爜',
  `real_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '鐪熷疄濮撳悕',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'teacher' COMMENT '瑙掕壊锛歛dmin-绠＄悊鍛? teacher-鏁欏笀, student-瀛︾敓',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '鐘舵?锛?-绂佺敤, 1-鍚?敤',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '鐢ㄦ埛琛' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', 'admin123', '管理员', 'admin', 1, '2026-04-17 14:43:17', '2026-04-17 15:49:47');
INSERT INTO `user` VALUES (2, 'teacher1', 'admin123', '张老师', 'teacher', 1, '2026-04-17 14:43:17', '2026-04-18 11:01:41');
INSERT INTO `user` VALUES (3, 'teacher2', 'admin123', '李老师', 'teacher', 1, '2026-04-17 14:43:17', '2026-04-17 15:49:47');

-- ----------------------------
-- Table structure for user_notification
-- ----------------------------
DROP TABLE IF EXISTS `user_notification`;
CREATE TABLE `user_notification`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `notification_id` int(11) NOT NULL COMMENT '消息ID',
  `is_read` tinyint(4) NULL DEFAULT 0 COMMENT '是否已读: 0-未读, 1-已读',
  `read_time` datetime NULL DEFAULT NULL COMMENT '阅读时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_notification`(`user_id`, `notification_id`) USING BTREE,
  INDEX `notification_id`(`notification_id`) USING BTREE,
  CONSTRAINT `user_notification_ibfk_1` FOREIGN KEY (`notification_id`) REFERENCES `notification` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户消息关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_notification
-- ----------------------------

-- ----------------------------
-- Table structure for warning_rule
-- ----------------------------
DROP TABLE IF EXISTS `warning_rule`;
CREATE TABLE `warning_rule`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '瑙勫垯ID',
  `rule_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '瑙勫垯鍚嶇О',
  `rule_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '瑙勫垯绫诲瀷: SCORE-鎴愮哗, ATTENDANCE-鑰冨嫟, COMPREHENSIVE-缁煎悎',
  `warning_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '棰勮?绛夌骇: YELLOW-榛勮壊, ORANGE-姗欒壊, RED-绾㈣壊',
  `threshold_value` decimal(5, 2) NULL DEFAULT NULL COMMENT '闃堝?',
  `threshold_count` int(11) NULL DEFAULT NULL COMMENT '闃堝?娆℃暟',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '瑙勫垯鎻忚堪',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '鐘舵?: 0-绂佺敤, 1-鍚?敤',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '棰勮?瑙勫垯琛' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of warning_rule
-- ----------------------------
INSERT INTO `warning_rule` VALUES (1, '成绩不及格预警', 'SCORE', 'YELLOW', 60.00, NULL, '单科成绩低于60分', 1, '2026-04-22 23:29:41', '2026-04-22 23:29:41');
INSERT INTO `warning_rule` VALUES (2, '成绩严重不及格预警', 'SCORE', 'RED', 40.00, NULL, '单科成绩低于40分', 1, '2026-04-22 23:29:41', '2026-04-22 23:29:41');
INSERT INTO `warning_rule` VALUES (3, '缺勤预警', 'ATTENDANCE', 'YELLOW', NULL, 3, '累计缺勤3次及以上', 1, '2026-04-22 23:29:41', '2026-04-22 23:29:41');
INSERT INTO `warning_rule` VALUES (4, '严重缺勤预警', 'ATTENDANCE', 'RED', NULL, 5, '累计缺勤5次及以上', 1, '2026-04-22 23:29:41', '2026-04-22 23:29:41');
INSERT INTO `warning_rule` VALUES (5, '多科不及格预警', 'COMPREHENSIVE', 'ORANGE', 60.00, 2, '2科及以上成绩不及格', 1, '2026-04-22 23:29:41', '2026-04-22 23:29:41');

SET FOREIGN_KEY_CHECKS = 1;
