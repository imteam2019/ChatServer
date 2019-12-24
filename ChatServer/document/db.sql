-- --------------------------------------------------------
-- 主机:                           47.88.231.69
-- Server version:               5.7.24-0ubuntu0.16.04.1 - (Ubuntu)
-- Server OS:                    Linux
-- HeidiSQL 版本:                  10.1.0.5464
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for chat
CREATE DATABASE IF NOT EXISTS `IMDB` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `IMDB`;

-- Data exporting was unselected.
-- Dumping structure for table IMDB.tb_apply_friend_record
CREATE TABLE IF NOT EXISTS `tb_apply_friend_record` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `from_user` int(11) unsigned NOT NULL DEFAULT '0',
  `to_user` int(11) unsigned NOT NULL DEFAULT '0',
  `state` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '是否已处理',
  `time` char(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='申请好友和申请好友处理信息';

-- Data exporting was unselected.
-- Dumping structure for table IMDB.tb_chart_msg_base64_record
CREATE TABLE IF NOT EXISTS `tb_chart_msg_base64_record` (
  `id` int(11) unsigned NOT NULL,
  `session` char(32) DEFAULT '00000000000000000000000000000000',
  `is_group_msg` int(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否群消息，0:不是群消息，1:群消息',
  `group_id` int(11) unsigned NOT NULL DEFAULT '0',
  `from_user` int(11) unsigned NOT NULL DEFAULT '0',
  `to_user` int(11) unsigned NOT NULL DEFAULT '0',
  `msg_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `msg_type` char(100) NOT NULL DEFAULT '0',
  `msg_content` text NOT NULL,
  `int_time` bigint(20) NOT NULL DEFAULT '0',
  `time` char(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `from_user_to_user_int_time` (`from_user`,`to_user`,`int_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='聊天内容用base64处理后保存，以便特殊字符等能够正确的保存下来';

-- Data exporting was unselected.
-- Dumping structure for table IMDB.tb_connect_record
CREATE TABLE IF NOT EXISTS `tb_connect_record` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `int_time` bigint(20) unsigned DEFAULT NULL,
  `time` char(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `int_time` (`int_time`),
  UNIQUE KEY `int_time_user_id` (`int_time`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='客户端上线记录';

-- Data exporting was unselected.
-- Dumping structure for table IMDB.tb_friend
CREATE TABLE IF NOT EXISTS `tb_friend` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL DEFAULT '0',
  `friend_uid` int(11) unsigned NOT NULL DEFAULT '0',
  `friend_type` int(11) unsigned NOT NULL DEFAULT '1',
  `useable` int(11) unsigned NOT NULL DEFAULT '1' COMMENT '好友关系是否可用，0, 不可用，1,可用',
  `time` char(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id_friend_uid_friend_type` (`user_id`,`friend_uid`,`friend_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='好友关系表';

-- Data exporting was unselected.
-- Dumping structure for table IMDB.tb_friend_type
CREATE TABLE IF NOT EXISTS `tb_friend_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='好友关系类型表';

-- Data exporting was unselected.
-- Dumping structure for table IMDB.tb_group
CREATE TABLE IF NOT EXISTS `tb_group` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '群组id',
  `name` varchar(256) DEFAULT NULL COMMENT '群组名',
  `create_user_id` int(11) DEFAULT NULL COMMENT '创建者id',
  `int_time` bigint(20) DEFAULT '0' COMMENT '创建时间',
  `time` char(20) DEFAULT NULL COMMENT '创建时间',
  `heard_picture` varchar(200) DEFAULT '' COMMENT '群头像',
  `public` smallint(1) NOT NULL DEFAULT '0' COMMENT '0:不公开 1:公开',
  `available` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0:unavailable  1:available',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='群表，群的信息，包括id, 群组名字，创建者，创建时间';


-- Data exporting was unselected.
-- Dumping structure for table IMDB.tb_group_join_reponse_historys
CREATE TABLE IF NOT EXISTS `tb_group_join_reponse_historys` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `request_user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `operator_user_id` int(11) NOT NULL,
  `operator` smallint(11) NOT NULL COMMENT '0, 拒绝， 1, 同意',
  `int_time` bigint(20) NOT NULL,
  `time` char(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table IMDB.tb_group_request_join_historys
CREATE TABLE IF NOT EXISTS `tb_group_request_join_historys` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '申请人ID',
  `group_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '群ID',
  `message` char(100) NOT NULL DEFAULT '0' COMMENT '申请理由',
  `state` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '是否已处理',
  `time` char(20) DEFAULT NULL,
  `int_time` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='申请入群处理信息历史';

-- Data exporting was unselected.
-- Dumping structure for table IMDB.tb_group_request_join_record
CREATE TABLE IF NOT EXISTS `tb_group_request_join_record` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '申请人ID',
  `group_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '群ID',
  `message` char(100) NOT NULL DEFAULT '0' COMMENT '申请理由',
  `state` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '是否已处理',
  `time` char(20) DEFAULT NULL,
  `int_time` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='申请入群处理信息';

-- Dumping structure for table IMDB.tb_group_user
CREATE TABLE IF NOT EXISTS `tb_group_user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `group_id` int(11) unsigned NOT NULL COMMENT '群组id',
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `is_manager` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '是否是管理员 0,普通用户 1,管理员 2群主',
  `is_disturb` int(11) NOT NULL DEFAULT '0' COMMENT '是否接收消息 默认0接收1不接受',
  `group_nick_name` varchar(20) DEFAULT '' COMMENT '群成员昵称',
  `meeting` tinyint(11) DEFAULT '0' COMMENT '0:permission denied 1, permission',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `group_id` (`group_id`,`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='群的用户信息，每个群关联的用户和用户是否是管理员';

-- Data exporting was unselected.
-- Dumping structure for table IMDB.tb_group_user_last_global_id
CREATE TABLE IF NOT EXISTS `tb_group_user_last_global_id` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `group_id` int(11) unsigned NOT NULL,
  `last_global_id` int(11) unsigned DEFAULT '0',
  `int_time` bigint(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户对应的群对话的最新消息id';

-- Data exporting was unselected.
-- Dumping structure for table IMDB.tb_group_user_no_read_number
CREATE TABLE IF NOT EXISTS `tb_group_user_no_read_number` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL COMMENT 'user_id',
  `group_id` int(11) unsigned NOT NULL COMMENT 'group_id',
  `number` int(11) unsigned DEFAULT '0' COMMENT '未读消息数量',
  `time` char(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='群用户对应的群未读消息的数目表';

-- Data exporting was unselected.
-- Dumping structure for table IMDB.tb_group_user_read_global_id
CREATE TABLE IF NOT EXISTS `tb_group_user_read_global_id` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL COMMENT '用户id',
  `group_id` int(11) unsigned NOT NULL COMMENT '群主id',
  `read_global_id` int(11) unsigned DEFAULT '0' COMMENT '用户对应的群已读消息的最新id',
  `int_time` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户对应的群的已读消息的ID';

-- Data exporting was unselected.
-- Dumping structure for table IMDB.tb_login_history
CREATE TABLE IF NOT EXISTS `tb_login_history` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL DEFAULT '0',
  `session` char(32) NOT NULL DEFAULT '',
  `time` char(20) NOT NULL,
  `device` char(11) DEFAULT 'mobile',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='登录历史记录表';

-- Data exporting was unselected.
-- Dumping structure for table IMDB.tb_notify_infochange
CREATE TABLE IF NOT EXISTS `tb_notify_infochange` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `flist` int(11) NOT NULL DEFAULT '0' COMMENT '好友列表',
  `finfo` int(11) NOT NULL DEFAULT '0' COMMENT '好友信息',
  `glist` int(11) NOT NULL DEFAULT '0' COMMENT '群列表',
  `gflist` int(11) NOT NULL DEFAULT '0' COMMENT '群好友列表',
  `ginfo` int(11) NOT NULL DEFAULT '0' COMMENT '群信息',
  `gfinfo` int(11) NOT NULL DEFAULT '0' COMMENT '群好友信息',
  `myinfo` int(11) NOT NULL DEFAULT '0' COMMENT '个人信息',
  `total` int(11) NOT NULL DEFAULT '0' COMMENT '总的',
  PRIMARY KEY (`uid`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table IMDB.tb_no_read_msg_record
CREATE TABLE IF NOT EXISTS `tb_no_read_msg_record` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `from_user` int(11) unsigned NOT NULL,
  `to_user` int(11) unsigned NOT NULL,
  `number` int(11) unsigned NOT NULL DEFAULT '1' COMMENT '未读消息数',
  `time` char(20) DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `from_user` (`from_user`,`to_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='记录用户对应的未读消息数目的表';

-- Data exporting was unselected.
-- Dumping structure for table IMDB.tb_remark
CREATE TABLE IF NOT EXISTS `tb_remark` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT '0',
  `friend_id` int(10) unsigned DEFAULT '0',
  `remark` varchar(100) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id_friend_id` (`user_id`,`friend_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='备注表';


-- Data exporting was unselected.
-- Dumping structure for table IMDB.tb_sys_msg_record
CREATE TABLE IF NOT EXISTS `tb_sys_msg_record` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `from_user` int(11) unsigned NOT NULL DEFAULT '0',
  `to_user` int(11) unsigned NOT NULL DEFAULT '0',
  `group_id` int(11) NOT NULL COMMENT '关联群ID',
  `msg_id` int(11) unsigned NOT NULL DEFAULT '0',
  `msg_type` char(50) NOT NULL DEFAULT '0',
  `msg_content` json NOT NULL,
  `time` char(20) NOT NULL,
  `state` int(11) NOT NULL DEFAULT '0' COMMENT '是否已接收，默认0否1是',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='记录系统消息记录的表';

-- Data exporting was unselected.
-- Dumping structure for table IMDB.tb_user
CREATE TABLE IF NOT EXISTS `tb_user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `password` char(32) NOT NULL DEFAULT '',
  `username` varchar(20) NOT NULL DEFAULT '',
  `telephone` varchar(20) DEFAULT '',
  `email` varchar(50) DEFAULT '',
  `nick_name` varchar(50) DEFAULT '',
  `user_type` tinyint(4) DEFAULT '1' COMMENT '用户类型',
  `instruction` varchar(200) DEFAULT '',
  `head_image` varchar(200) DEFAULT '',
  `state` tinyint(11) NOT NULL DEFAULT '0',
  `time` char(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户信息表';

-- Data exporting was unselected.
-- Dumping structure for table IMDB.tb_user_device_msg_global_id
CREATE TABLE IF NOT EXISTS `tb_user_device_msg_global_id` (
  `id` bigint(64) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT '0' COMMENT '用户id',
  `device` char(10) DEFAULT '0' COMMENT '设备类型',
  `msg_global_id` bigint(64) unsigned DEFAULT '0' COMMENT '用户和这个类型设备对应的消息id',
  `int_time` bigint(20) unsigned DEFAULT '0' COMMENT '时间撮',
  `time` char(50) DEFAULT '0' COMMENT '服务器时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id_device_msg_global_id` (`user_id`,`device`,`msg_global_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户对应的设备对应的最新的消息ID';

-- Data exporting was unselected.
-- Dumping structure for table IMDB.tb_user_last_global_id
CREATE TABLE IF NOT EXISTS `tb_user_last_global_id` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `from_user` int(11) unsigned NOT NULL COMMENT '发送消息的用户id',
  `to_user` int(11) unsigned NOT NULL COMMENT '接收消息的用户id',
  `last_global_id` int(11) unsigned DEFAULT '0' COMMENT '此对话最新的消息id',
  `int_time` bigint(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='保存对话的最新消息id表';

-- Data exporting was unselected.
-- Dumping structure for table IMDB.tb_user_read_global_id
CREATE TABLE IF NOT EXISTS `tb_user_read_global_id` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `from_user` int(11) unsigned NOT NULL COMMENT '发送消息的用户id',
  `to_user` int(11) unsigned NOT NULL COMMENT '接收消息的用户id',
  `read_global_id` int(11) unsigned DEFAULT '0' COMMENT 'from_user已读to_user的最新的消息id',
  `int_time` bigint(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='保存对话的已读最新消息id表';

-- Data exporting was unselected.
-- Dumping structure for table IMDB.tb_user_session
CREATE TABLE IF NOT EXISTS `tb_user_session` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL DEFAULT '0',
  `session` char(50) NOT NULL DEFAULT '',
  `time` char(20) DEFAULT NULL,
  `device` char(10) NOT NULL DEFAULT 'mobile',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`,`session`,`device`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户session表';

-- Data exporting was unselected.
-- Dumping structure for table IMDB.tb_user_type
CREATE TABLE IF NOT EXISTS `tb_user_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) NOT NULL DEFAULT '0',
  `en_type_name` varchar(50) NOT NULL DEFAULT '0',
  `head_image` varchar(200) DEFAULT NULL,
  `visable` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0可见,1不可见',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
