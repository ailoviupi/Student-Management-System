DROP TABLE IF EXISTS `chat_message`;
CREATE TABLE `chat_message` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `sender_id` int(11) NOT NULL COMMENT '发送者ID',
  `sender_role` varchar(20) NOT NULL COMMENT '发送者角色: student/teacher',
  `receiver_id` int(11) NOT NULL COMMENT '接收者ID',
  `receiver_role` varchar(20) NOT NULL COMMENT '接收者角色: student/teacher',
  `content` text NOT NULL COMMENT '消息内容',
  `send_time` datetime NOT NULL COMMENT '发送时间',
  `read_status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '阅读状态: 0-未读, 1-已读',
  PRIMARY KEY (`id`),
  INDEX `idx_sender` (`sender_id`, `sender_role`),
  INDEX `idx_receiver` (`receiver_id`, `receiver_role`),
  INDEX `idx_send_time` (`send_time`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '聊天消息表';