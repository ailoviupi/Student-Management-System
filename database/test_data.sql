USE student_db;

-- 插入通知数据
INSERT INTO `notification` (title, content, type, sender_id, sender_name, target_type, target_id, priority, status, publish_time) VALUES
('System Maintenance', 'System will be maintained this Saturday.', 'SYSTEM', 1, 'Admin', 'ALL', NULL, 2, 1, NOW()),
('Score Published', 'Mid-term exam scores have been published.', 'SCORE', 1, 'Admin', 'ALL', NULL, 1, 1, NOW()),
('Attendance Alert', 'You have 3 absences this month.', 'ATTENDANCE', 1, 'Admin', 'ALL', NULL, 2, 1, NOW()),
('Scholarship Evaluation', 'Scholarship evaluation has started.', 'SYSTEM', 1, 'Admin', 'ALL', NULL, 1, 1, NOW()),
('Final Exam Schedule', 'Final exams start next Monday.', 'SYSTEM', 1, 'Admin', 'ALL', NULL, 3, 1, NOW());

-- 插入奖学金评定记录
INSERT INTO `scholarship_record` (student_id, scholarship_type_id, academic_year, semester, gpa, ranking, total_score, score_details, status, reviewer_id, review_remark, review_time) VALUES
(1, 1, '2023-2024', 'ALL', 3.85, 1, 95.50, '{"academic": 95, "moral": 90, "sports": 98, "practice": 99}', 'APPROVED', 1, 'Excellent performance', NOW()),
(2, 2, '2023-2024', 'ALL', 3.65, 3, 88.20, '{"academic": 88, "moral": 85, "sports": 90, "practice": 90}', 'APPROVED', 1, 'First prize qualified', NOW()),
(3, 3, '2023-2024', 'ALL', 3.42, 8, 82.60, '{"academic": 82, "moral": 80, "sports": 85, "practice": 83}', 'APPROVED', 1, 'Second prize qualified', NOW()),
(4, 4, '2023-2024', 'ALL', 3.15, 15, 78.30, '{"academic": 78, "moral": 75, "sports": 80, "practice": 80}', 'PENDING', NULL, NULL, NULL),
(5, 5, '2023-2024', 'ALL', 2.95, 25, 72.80, '{"academic": 72, "moral": 70, "sports": 75, "practice": 74}', 'PENDING', NULL, NULL, NULL);

-- 插入课程安排数据
INSERT INTO `course_schedule` (course_id, class_id, teacher_id, classroom_id, academic_year, semester, day_of_week, start_slot, end_slot, weeks, schedule_type, status) VALUES
(1, 1, 2, 3, '2023-2024', 'FIRST', 1, 1, 2, '1-16', 'AUTO', 1),
(2, 1, 3, 1, '2023-2024', 'FIRST', 1, 3, 4, '1-16', 'AUTO', 1),
(3, 1, 2, 2, '2023-2024', 'FIRST', 2, 1, 2, '1-16', 'AUTO', 1),
(4, 2, 3, 4, '2023-2024', 'FIRST', 1, 1, 2, '1-16', 'AUTO', 1),
(5, 2, 2, 1, '2023-2024', 'FIRST', 2, 3, 4, '1-16', 'AUTO', 1),
(1, 3, 3, 2, '2023-2024', 'FIRST', 3, 1, 2, '1-16', 'AUTO', 1),
(2, 3, 2, 3, '2023-2024', 'FIRST', 4, 3, 4, '1-16', 'AUTO', 1),
(3, 1, 3, 4, '2023-2024', 'FIRST', 5, 1, 2, '1-16', 'AUTO', 1);
