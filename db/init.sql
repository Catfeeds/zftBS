CREATE DATABASE IF NOT EXISTS zft CHARACTER SET utf8 COLLATE utf8_general_ci;
USE zft;

create table if not exists buildings
(
  `id` bigint(20) UNSIGNED NOT NULL,
  `projectId` bigint(20) UNSIGNED NOT NULL,
  `locationId` bigint(20) UNSIGNED NOT NULL,
  `group` varchar(10) NOT NULL DEFAULT '',
  `building` varchar(10) NOT NULL DEFAULT '',
  `unit` varchar(10) NOT NULL DEFAULT '',
  `totalFloor` int(11) NOT NULL DEFAULT 0,
  `houseCountOnFloor` int(11) NOT NULL DEFAULT 0,
  `config` text NULL,
  `createdAt` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `deleteAt` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

create table if not exists rooms
(
  `id` bigint(20) UNSIGNED NOT NULL,
  `houseId` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(10) NOT NULL DEFAULT '',
  `people` int(11) NOT NULL DEFAULT 0,
  `type` varchar(8) NOT NULL DEFAULT '',
  `roomArea` int(11) NOT NULL DEFAULT 0,
  `orientation` varchar(2) NOT NULL DEFAULT 'N',
  `config` text NULL,
  `createdAt` datetime(0) NULL,
	`updatedAt` datetime(0) NULL,
	`deletedAt` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

create table if not exists contracts
(
	`id` bigint,
	projectId bigint not null,
	roomId bigint not null,
	userId bigint not null,
	`from` bigint not null,
	`to` bigint not null,
	`actualEndDate` bigint null,
	strategy text null,
	expenses text null,
	contractNumber varchar(50) default '' not null,
	paymentPlan varchar(3) not null,
	signUpTime bigint default '0' not null,
	status varchar(20) default 'ongoing' not null,
	`createdAt` DATETIME NOT NULL,
	`updatedAt` DATETIME NOT NULL,
	`deletedAt` DATETIME,
  	primary key (`id`)
) engine=innodb default charset=utf8;

create table if not exists suspendingRooms
(
	`id` bigint not null,
	projectId bigint not null,
	roomId bigint not null,
	`from` bigint not null,
	`to` bigint null,
	memo text null,
	`createdAt` DATETIME NOT NULL,
	`updatedAt` DATETIME NOT NULL,
	`deletedAt` DATETIME,
  	primary key (`id`)
) engine=innodb default charset=utf8;

create table if not exists bills
(
	id bigint,
	flow varchar(10) default 'receive' not null,
	entityType varchar(10) default 'tenant' not null,
	contractId bigint,
	userId bigint,
	`index` int,
	projectId bigint not null,
	`source` varchar(10) not null,
	`type` varchar(20) not null,
	startDate bigint default 0 not null,
	endDate bigint default 0 not null,
	dueDate bigint default 0 not null,
	dueAmount bigint default 0 not null,
	createdAt bigint default '0' not null,
	remark varchar(255) default '' null,
	metadata text null,
	primary key (`id`)
) engine=innodb default charset=utf8;

create table if not exists billflows
(
	id bigint,
	projectId bigint not null,
	billId bigint not null,
	configId bigint not null,
	relevantId bigint,
	amount bigint default 0 not null,
	createdAt bigint not null,
	deleteAt bigint,
	primary key (`id`)
) engine=innodb default charset=utf8;

create table if not exists billpayment
(
	id bigint,
	`flowId` bigint(20) UNSIGNED NOT NULL,
	projectId bigint(20) not null,
	billId bigint(20),
	orderNo bigint,
	fundChannelId bigint(20) not null,
	amount bigint default 0 not null,
	operator bigint not null,
	paidAt bigint not null,
	remark text,
	status varchar(20) default 'pending' null,
	`createdAt` DATETIME NOT NULL,
    `updatedAt` DATETIME NOT NULL,
    `deletedAt` DATETIME,
	primary key (`id`)
) engine=innodb default charset=utf8;

create table if not exists users
(
	id bigint,
	authId bigint(20) UNSIGNED NOT NULL,
	`name` varchar(24) not null,
	documentId text null,
	documentType int default '1' null,
	gender varchar(1) default 'M' not null,
    primary key (`id`)
) engine=innodb default charset=utf8;

create table if not exists usernotifications
(
	`id` bigint(20) UNSIGNED,
	projectId bigint(20) UNSIGNED NOT NULL,
	userId bigint(20) UNSIGNED NOT NULL,
	title varchar(50) not null,
	`content` varchar(255) not null,
	extras text,
	`createdAt` DATETIME NOT NULL,
	`updatedAt` DATETIME NOT NULL,
	`deletedAt` DATETIME,
    primary key (`id`)
) engine=innodb default charset=utf8;

create table if not exists bindings
(
	id bigint(20) UNSIGNED NOT NULL,
	authId bigint(20) UNSIGNED NOT NULL,
	platform varchar(10) not null,
	deviceId varchar(40) not null,
    `createdAt` DATETIME NOT NULL,
	`updatedAt` DATETIME NOT NULL,
	`deletedAt` DATETIME,
	PRIMARY KEY (`id`)
) engine=innodb default charset=utf8;

CREATE TABLE IF NOT EXISTS `auth`
(
	`id` bigint auto_increment,
	`projectId` bigint(20) UNSIGNED NOT NULL,
	username varchar(32) not null,
	`level` varchar(24) default 'ADMIN' not null,
	`password` VARCHAR(32) NOT NULL,
	`lastLoggedIn` BIGINT UNSIGNED,
	`email` VARCHAR(255) NULL,
	`mobile` VARCHAR(20) NULL,
	`allowReceiveFrom` VARCHAR(10) default 'BOTH' NOT NULL,
	`createdAt` DATETIME NOT NULL,
	`updatedAt` DATETIME NOT NULL,
	`deletedAt` DATETIME,
	constraint auth_username_unique
		unique (username),
	PRIMARY KEY (`id`)
) engine=innodb default charset=utf8;

create table if not exists layouts
(
	`id` bigint(20) UNSIGNED NOT NULL,
  `sourceId` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `bedRoom` int(11) NOT NULL DEFAULT 0,
  `livingRoom` int(11) NOT NULL DEFAULT 0,
  `bathRoom` int(11) NOT NULL DEFAULT 0,
  `orientation` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'N',
  `roomArea` int(11) NOT NULL DEFAULT 0,
  `createdAt` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `deleteAt` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE
) engine=innodb default charset=utf8;

create table if not exists houses
(
	`id` bigint(20) UNSIGNED NOT NULL,
  `houseFormat` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `projectId` bigint(20) UNSIGNED NOT NULL,
  `buildingId` bigint(20) UNSIGNED NOT NULL,
  `code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `layoutId` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `roomNumber` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `currentFloor` int(11) NOT NULL DEFAULT 0,
  `houseKeeper` bigint(20) UNSIGNED NULL DEFAULT 0,
  `desc` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '',
  `status` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'open',
  `config` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `createdAt` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `deleteAt` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) engine=innodb default charset=utf8;

create table if not exists location
(
	`id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
	`code` varchar(12) NOT NULL DEFAULT '',
	`divisionId` bigint(20) UNSIGNED NOT NULL,
	`district` varchar(16) NOT NULL DEFAULT '',
	`name` varchar(32) NOT NULL,
	`address` varchar(32) NOT NULL,
	`longitude` decimal(9, 5) NOT NULL,
	`latitude` decimal(9, 5) NOT NULL,
	PRIMARY KEY (`id`) USING BTREE
) engine=innodb default charset=utf8;

create table if not exists division
(
	id bigint not null auto_increment,
	name varchar(255) not null,
  primary key (`id`)
) engine=innodb default charset=utf8;

create table if not exists `settings`
(
	`id` bigint not null,
	`projectId` bigint null,
	`group` varchar(128) default '' not null,
	`key` varchar(255) default '' not null,
	`value` varchar(255) null,
	`valueRange` TEXT null,
	`enabled` int(1) default 1 not null,
  primary key (`id`)
) engine=innodb default charset=utf8;

create table if not exists `divisions`
(
	`id` int(6) NOT NULL COMMENT '行政区划代码',
	`title` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '行政区划名称',
	`level` int(1) NULL DEFAULT NULL COMMENT '行政区划等级',
	`parent` int(6) NULL DEFAULT NULL COMMENT '上级行政区划',
	`latitude` decimal(9, 5) NOT NULL DEFAULT 0.00000 COMMENT '纬度',
	`longitude` decimal(9, 5) NOT NULL DEFAULT 0.00000 COMMENT '经度',
	`enable` tinyint(1) NOT NULL DEFAULT 1,
	PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB COMMENT = '行政区划';

create table if not exists `housesDevices`
(
	`id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
	`projectId` bigint(20) NOT NULL,
	`sourceId` bigint(20) UNSIGNED NOT NULL,
	`deviceId` varchar(32) NOT NULL,
	`startDate` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
	`endDate` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
	`public` tinyint(1) NOT NULL DEFAULT 0,
	`createdAt`  datetime NOT NULL ,
	`updatedAt`  datetime NOT NULL ,
	`deletedAt`  datetime,
	PRIMARY KEY (`id`) USING BTREE,
	INDEX `sourceId`(`sourceId`) USING BTREE
) ENGINE = InnoDB;

create table if not exists `housesDevicesPrice`
(
	`id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
	`projectId` bigint(20) UNSIGNED NULL DEFAULT NULL,
	`houseId` bigint(20) UNSIGNED NOT NULL,
	`category` varchar(8) NOT NULL DEFAULT 'HOST',
	`type` varchar(10) NOT NULL,
	`price` int(11) NOT NULL DEFAULT 0,
	`startDate` bigint(20) UNSIGNED NOT NULL,
	`endDate` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
	`createdAt`  datetime NOT NULL ,
	`updatedAt`  datetime NOT NULL ,
	`deletedAt`  datetime NULL DEFAULT NULL ,
	PRIMARY KEY (`id`) USING BTREE,
	INDEX `houseId`(`houseId`) USING BTREE
) ENGINE = InnoDB;

create table if not exists `projects`
(
	`id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
	`externalId` varchar(32) NOT NULL,
	`name` varchar(32) NULL,
	`logoUrl` varchar(255) NULL,
	`address` varchar(255) NULL,
	`description` TEXT,
	`telephone` varchar(20) NULL,
	`createdAt` datetime(0) NULL,
    `updatedAt` datetime(0) NULL,
    `deletedAt` datetime(0) NULL DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB;


create table if not exists `fundChannels`
(
	`id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
	`flow` varchar(8) NOT NULL DEFAULT 'receive',
	`projectId` bigint(20) UNSIGNED NOT NULL,
	`category` varchar(10) NOT NULL,
	`tag` varchar(8) NOT NULL,
	`name` varchar(8) NOT NULL,
	`status` varchar(8) NOT NULL DEFAULT 'PENDING',
	`createdAt` datetime(0) NULL,
	`updatedAt` datetime(0) NULL,
	`deletedAt` datetime(0) NULL DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB;

create table if not exists `payChannels`
(
	`id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
	`fundChannelId` bigint(20) NOT NULL,
	`documentId` text NULL,
	`documentType` int(11) NULL DEFAULT 1,
	`account` varchar(64) NOT NULL,
	`subbranch` varchar(32) NULL DEFAULT '',
	`locate` text NULL,
	`reservedmobile` varchar(16) NOT NULL DEFAULT '',
	`linkman` varchar(16) NOT NULL DEFAULT '',
	`mobile` varchar(16) NOT NULL DEFAULT '',
	`createdAt` datetime(0) NULL,
	`updatedAt` datetime(0) NULL,
	`deletedAt` datetime(0) NULL DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB;

create table if not exists `receiveChannels`
(
	`id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
	`fundChannelId` bigint(20) UNSIGNED NOT NULL,
	`fee` int(11) NOT NULL,
	`share` text NULL,
	`setting` text NULL,
	`createdAt` datetime(0) NULL,
	`updatedAt` datetime(0) NULL,
	`deletedAt` datetime(0) NULL DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB;

create table if not exists `devices`
(
	`id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
	`deviceId` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
	`projectId` bigint(20) UNSIGNED NOT NULL,
	`name` varchar(16) NOT NULL DEFAULT '',
	`tag` varchar(16) NOT NULL DEFAULT '',
	`type` varchar(16) NOT NULL,
	`freq` int(11) NOT NULL,
	`driver` varchar(128) NOT NULL DEFAULT '',
	`memo` varchar(255) NOT NULL DEFAULT '',
	`status` text NULL,
	`createdAt` datetime(0) NULL,
	`updatedAt` datetime(0) NULL,
	`deletedAt` datetime(0) NULL DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `DEVICEID`(`deviceId`) USING BTREE
) ENGINE = InnoDB;

create table if not exists `devicesChannels`
(
	`id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
	`deviceId` varchar(32) NOT NULL,
	`channelId` varchar(3) NOT NULL,
	`comi` decimal(10, 6) NOT NULL,
	`scale` bigint(20) NULL DEFAULT NULL,
	`updatedAt` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB;

create table if not exists `deviceData`
(
	`id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
	`channelId` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
	`reading` int(10) UNSIGNED NOT NULL,
	`time` bigint(20) UNSIGNED NOT NULL,
	PRIMARY KEY (`id`, `channelId`) USING BTREE,
	INDEX `CHANNEL`(`channelId`) USING BTREE
) ENGINE = InnoDB;

create table if not exists `eventQueue`
(
  `id` bigint(20) UNSIGNED NOT NULL,
  `messageTypeId` bigint(20) UNSIGNED NOT NULL,
  `timestamp` bigint(20) UNSIGNED NOT NULL,
  `param` text NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB;

create table if not exists `devicePrePaid`
(
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` varchar(16) NOT NULL,
	`flowId` bigint(20) UNSIGNED NOT NULL,
  `contractId` bigint(20) UNSIGNED NOT NULL,
  `projectId` bigint(20) UNSIGNED NOT NULL,
  `deviceId` varchar(32) NOT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `scale` bigint(20) NOT NULL,
  `usage` bigint(20) NOT NULL,
	`price` int(11) NOT NULL,
	`paymentDay` bigint(20) UNSIGNED NOT NULL,
  `share` int(11) NOT NULL DEFAULT 100,
  `createdAt` bigint(20) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB;

create table if not exists `dailyPrePaid`
(
	`id` bigint(20) UNSIGNED NOT NULL,
	`flowId` bigint(20) UNSIGNED NOT NULL,
	`configId` bigint(20) UNSIGNED NOT NULL,
	`contractId` bigint(20) UNSIGNED NOT NULL,
	`projectId` bigint(20) UNSIGNED NOT NULL,
	`amount` int(11) NOT NULL DEFAULT 0,
	`paymentDay` int(11) NOT NULL,
	`createdAt` bigint(20) UNSIGNED NOT NULL,
	PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB ROW_FORMAT = Dynamic;

create table if not exists `topup`
(
  `id` bigint(20) UNSIGNED NOT NULL,
  `orderNo` bigint(20) UNSIGNED NOT NULL,
  `userId` bigint(20) UNSIGNED NOT NULL,
  `externalId` varchar(64) NOT NULL DEFAULT '',
  `contractId` bigint(20) UNSIGNED NOT NULL,
  `projectId` bigint(20) UNSIGNED NOT NULL,
  `flowId` bigint(20) UNSIGNED NOT NULL,
  `amount` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `fundChannelId` bigint(20) UNSIGNED NOT NULL,
  `operator` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `createdAt` datetime(0) NULL,
  `updatedAt` datetime(0) NULL,
  `deletedAt` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB;

create table if not exists `flows`
(
  `id` bigint(20) UNSIGNED NOT NULL,
  `projectId` bigint(20) UNSIGNED NOT NULL,
  `category` varchar(20) default 'rent' NOT NULL,
  `locationId` bigint(20) UNSIGNED NOT NULL,
  `locationName` varchar(16) NULL,
  `amount` bigint(20) UNSIGNED default '0' NOT NULL,
  `fee` bigint(20) UNSIGNED default '0' NOT NULL,
  `direction` varchar(10) default 'receive' not null,
  `createdAt` datetime(0) NULL,
  `updatedAt` datetime(0) NULL,
  `deletedAt` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB;

create table if not exists `cashAccount`
(
  `id` bigint(20) UNSIGNED NOT NULL,
  `userId` bigint(20) UNSIGNED NOT NULL,
  `balance` bigint(20) NULL DEFAULT 0,
  `threshold` bigint(20) NULL DEFAULT 0,
  `locker` int(10) UNSIGNED NULL DEFAULT 0,
  `createdAt` datetime(0) NOT NULL,
  `updatedAt` datetime(0) NOT NULL,
  `deletedAt` datetime(0) NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB;

create table if not exists `wxUser`
(
  `id` bigint auto_increment,
  `openId` varchar(64) NOT NULL,
  `platformId` varchar(64) NULL DEFAULT NULL,
  `userId` varchar(128) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB;

create table if not exists `fundChannelFlows`
(
  `id` bigint(20) UNSIGNED NOT NULL,
  `category` varchar(16) NOT NULL,
  `orderNo` bigint(20) UNSIGNED NOT NULL,
  `billId` bigint(20) UNSIGNED NOT NULL,
  `projectId` bigint(20) UNSIGNED NOT NULL,
  `fundChannelId` bigint(20) UNSIGNED NOT NULL,
  `from` bigint(20) UNSIGNED NOT NULL,
  `to` bigint(20) UNSIGNED NOT NULL,
  `amount` bigint(20) NOT NULL,
  `createdAt` datetime(0) NULL,
  `updatedAt` datetime(0) NULL,
  `deletedAt` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB;

create table if not exists `serviceCharge`
(
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `projectId` bigint(20) UNSIGNED NOT NULL,
  `fundChannelId` bigint(20) UNSIGNED NOT NULL,
  `type` varchar(16) NOT NULL,
  `strategy` text NULL,
  `createdAt` datetime(0) NULL,
  `updatedAt` datetime(0) NULL,
  `deletedAt` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB;

create table if not exists `houseApportionment`
(
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `projectId` bigint(20) UNSIGNED NOT NULL,
  `houseId` bigint(20) UNSIGNED NOT NULL,
  `roomId` bigint(20) UNSIGNED NOT NULL,
  `value` tinyint(1) NOT NULL,
  `createdAt` datetime(0) NULL,
  `updatedAt` datetime(0) NULL,
  `deletedAt` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB;

create table if not exists `withDraw`
(
	`id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
	`projectId` bigint(20) UNSIGNED NOT NULL,
	`amount` bigint(20) NOT NULL,
	`operator` bigint(20) UNSIGNED NOT NULL,
	`auditor` bigint(20) UNSIGNED NOT NULL,
	`fundChannelId` bigint(20) UNSIGNED NOT NULL,
	`status` varchar(16) NULL DEFAULT 'PENDING',
	`createdAt` datetime(0) NULL,
	`updatedAt` datetime(0) NULL,
	`deletedAt` datetime(0) NULL DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 ROW_FORMAT = Dynamic;

create table if not exists `banks`
(
	`id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
	`tag` varchar(16) NOT NULL,
	`name` varchar(16) NOT NULL,
	PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 ROW_FORMAT = Dynamic;

create table if not exists `prePaidFlows`
(
	`id` bigint(20) UNSIGNED NOT NULL,
	`projectId` bigint(20) UNSIGNED NOT NULL,
	`contractId` bigint(20) NOT NULL,
	`category` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
	`paymentDay` bigint(20) NOT NULL,
	`createdAt` datetime(0) NULL,
	`updatedAt` datetime(0) NULL,
	`deletedAt` datetime(0) NULL DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB ROW_FORMAT = Dynamic;

#project demo record
INSERT INTO `zft`.`projects` (`id`, `name`, `externalId`) VALUES ('100', '加州项目', '5938bb4f4d3684627bcabd7f');
INSERT INTO `zft`.`auth` (`id`, `projectId`, `username`, `password`, createdAt, updatedAt)
VALUES (1, 100, 'admin100', '5f4dcc3b5aa765d61d8327deb882cf99',  NOW(),  NOW()),
	(2, 101, 'admin101', '5f4dcc3b5aa765d61d8327deb882cf99',  NOW(),  NOW());
INSERT INTO zft.bindings (`id`, authId, platform, deviceId, createdAt, updatedAt)
    VALUES (6385448056539713536, 1, 'ios', '3227dcbae04c4f3ba5034d86a57c30e0', NOW(), NOW());

INSERT INTO `zft`.`fundChannels` (`flow`, `projectId`, `tag`, `name`, `status`, `createdAt`, `updatedAt`, `deletedAt`)
VALUES ('receive', '100', 'manual', '现金', 'PASSED ', NOW(), NOW(), NULL),
 ('receive', '100', 'alipay', '支付宝', 'PASSED ', NOW(), NOW(), NULL);

INSERT INTO `zft`.`receiveChannels` (`fundChannelId`, `fee`, `share`, `setting`, `createdAt`, `updatedAt`, `deletedAt`)
VALUES ( '1', '0', NULL, NULL, NOW(), NOW(), NULL);
INSERT INTO `zft`.`receiveChannels` (`fundChannelId`, `fee`, `share`, `setting`, `createdAt`, `updatedAt`, `deletedAt`)
VALUES ( '2', '6', NULL, NULL, NOW(), NOW(), NULL);

INSERT INTO `zft`.`fundChannels` (`flow`, `projectId`, `category`, `tag`, `name`, `status`, `createdAt`, `updatedAt`, `deletedAt`) VALUES ('receive', '100', 'offline', 'cash', '现金', 'PASSED ', '2018-01-03 22:23:01', '2018-01-03 22:23:03', NULL);
INSERT INTO `zft`.`fundChannels` (`flow`, `projectId`, `category`, `tag`, `name`, `status`, `createdAt`, `updatedAt`, `deletedAt`) VALUES ('receive', '100', 'online', 'alipay', '支付宝', 'PASSED ', '2018-01-03 22:31:59', '2018-01-03 22:32:02', NULL);
INSERT INTO `zft`.`fundChannels` (`flow`, `projectId`, `category`, `tag`, `name`, `status`, `createdAt`, `updatedAt`, `deletedAt`) VALUES ('pay', '100', 'online', 'icbc', '工商银行', 'PASSED', '2018-01-03 22:33:12', '2018-01-03 22:33:15', NULL);

INSERT INTO zft.serviceCharge (id, projectId, fundChannelId, type, strategy, createdAt, updatedAt, deletedAt) VALUES (1, 100, 1, 'TOPUP', '{"user":40,"project":60,"fee":10}', '2018-01-24 17:59:13', '2018-01-25 08:12:08', null);
INSERT INTO zft.serviceCharge (id, projectId, fundChannelId, type, strategy, createdAt, updatedAt, deletedAt) VALUES (2, 100, 1, 'BILL', '{"user":30,"project":70,"fee":10}', '2018-01-24 17:59:13', '2018-01-25 08:12:08', null);

INSERT INTO `divisions` VALUES (110000, '北京市', 1, 0, 39.90000, 116.40000, 1);
INSERT INTO `divisions` VALUES (110100, '市辖区', 2, 110000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (110101, '东城区', 3, 110100, 39.93000, 116.42000, 0);
INSERT INTO `divisions` VALUES (110102, '西城区', 3, 110100, 39.92000, 116.37000, 0);
INSERT INTO `divisions` VALUES (110105, '朝阳区', 3, 110100, 43.83000, 125.28000, 0);
INSERT INTO `divisions` VALUES (110106, '丰台区', 3, 110100, 39.85000, 116.28000, 0);
INSERT INTO `divisions` VALUES (110107, '石景山区', 3, 110100, 39.90000, 116.22000, 0);
INSERT INTO `divisions` VALUES (110108, '海淀区', 3, 110100, 39.95000, 116.30000, 0);
INSERT INTO `divisions` VALUES (110109, '门头沟区', 3, 110100, 39.93000, 116.10000, 0);
INSERT INTO `divisions` VALUES (110111, '房山区', 3, 110100, 39.75000, 116.13000, 0);
INSERT INTO `divisions` VALUES (110112, '通州区', 3, 110100, 39.92000, 116.65000, 0);
INSERT INTO `divisions` VALUES (110113, '顺义区', 3, 110100, 40.13000, 116.65000, 0);
INSERT INTO `divisions` VALUES (110114, '昌平区', 3, 110100, 40.22000, 116.23000, 0);
INSERT INTO `divisions` VALUES (110115, '大兴区', 3, 110100, 39.73000, 116.33000, 0);
INSERT INTO `divisions` VALUES (110116, '怀柔区', 3, 110100, 40.32000, 116.63000, 0);
INSERT INTO `divisions` VALUES (110117, '平谷区', 3, 110100, 40.13000, 117.12000, 0);
INSERT INTO `divisions` VALUES (110200, '县', 2, 110000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (110228, '密云县', 3, 110200, 40.37000, 116.83000, 0);
INSERT INTO `divisions` VALUES (110229, '延庆县', 3, 110200, 40.45000, 115.97000, 0);
INSERT INTO `divisions` VALUES (120000, '天津市', 1, 0, 39.12000, 117.20000, 1);
INSERT INTO `divisions` VALUES (120100, '市辖区', 2, 120000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (120101, '和平区', 3, 120100, 41.78000, 123.40000, 0);
INSERT INTO `divisions` VALUES (120102, '河东区', 3, 120100, 35.08000, 118.40000, 0);
INSERT INTO `divisions` VALUES (120103, '河西区', 3, 120100, 39.12000, 117.22000, 0);
INSERT INTO `divisions` VALUES (120104, '南开区', 3, 120100, 39.13000, 117.15000, 0);
INSERT INTO `divisions` VALUES (120105, '河北区', 3, 120100, 39.15000, 117.18000, 0);
INSERT INTO `divisions` VALUES (120106, '红桥区', 3, 120100, 39.17000, 117.15000, 0);
INSERT INTO `divisions` VALUES (120110, '东丽区', 3, 120100, 39.08000, 117.30000, 0);
INSERT INTO `divisions` VALUES (120111, '西青区', 3, 120100, 39.13000, 117.00000, 0);
INSERT INTO `divisions` VALUES (120112, '津南区', 3, 120100, 38.98000, 117.38000, 0);
INSERT INTO `divisions` VALUES (120113, '北辰区', 3, 120100, 39.22000, 117.13000, 0);
INSERT INTO `divisions` VALUES (120114, '武清区', 3, 120100, 39.38000, 117.03000, 0);
INSERT INTO `divisions` VALUES (120115, '宝坻区', 3, 120100, 39.72000, 117.30000, 0);
INSERT INTO `divisions` VALUES (120116, '滨海新区', 3, 120100, 39.03000, 117.68000, 0);
INSERT INTO `divisions` VALUES (120200, '县', 2, 120000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (120221, '宁河县', 3, 120200, 39.33000, 117.82000, 0);
INSERT INTO `divisions` VALUES (120223, '静海县', 3, 120200, 38.93000, 116.92000, 0);
INSERT INTO `divisions` VALUES (120225, '蓟县', 3, 120200, 40.05000, 117.40000, 0);
INSERT INTO `divisions` VALUES (130000, '河北省', 1, 0, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (130100, '石家庄市', 2, 130000, 38.05000, 114.52000, 1);
INSERT INTO `divisions` VALUES (130101, '市辖区', 3, 130100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (130102, '长安区', 3, 130100, 34.17000, 108.93000, 0);
INSERT INTO `divisions` VALUES (130103, '桥东区', 3, 130100, 37.07000, 114.50000, 0);
INSERT INTO `divisions` VALUES (130104, '桥西区', 3, 130100, 37.05000, 114.47000, 0);
INSERT INTO `divisions` VALUES (130105, '新华区', 3, 130100, 33.73000, 113.30000, 0);
INSERT INTO `divisions` VALUES (130107, '井陉矿区', 3, 130100, 38.08000, 114.05000, 0);
INSERT INTO `divisions` VALUES (130108, '裕华区', 3, 130100, 38.02000, 114.52000, 0);
INSERT INTO `divisions` VALUES (130121, '井陉县', 3, 130100, 38.03000, 114.13000, 0);
INSERT INTO `divisions` VALUES (130123, '正定县', 3, 130100, 38.15000, 114.57000, 0);
INSERT INTO `divisions` VALUES (130124, '栾城县', 3, 130100, 37.88000, 114.65000, 0);
INSERT INTO `divisions` VALUES (130125, '行唐县', 3, 130100, 38.43000, 114.55000, 0);
INSERT INTO `divisions` VALUES (130126, '灵寿县', 3, 130100, 38.30000, 114.37000, 0);
INSERT INTO `divisions` VALUES (130127, '高邑县', 3, 130100, 37.60000, 114.60000, 0);
INSERT INTO `divisions` VALUES (130128, '深泽县', 3, 130100, 38.18000, 115.20000, 0);
INSERT INTO `divisions` VALUES (130129, '赞皇县', 3, 130100, 37.67000, 114.38000, 0);
INSERT INTO `divisions` VALUES (130130, '无极县', 3, 130100, 38.18000, 114.97000, 0);
INSERT INTO `divisions` VALUES (130131, '平山县', 3, 130100, 38.25000, 114.20000, 0);
INSERT INTO `divisions` VALUES (130132, '元氏县', 3, 130100, 37.75000, 114.52000, 0);
INSERT INTO `divisions` VALUES (130133, '赵县', 3, 130100, 37.75000, 114.77000, 0);
INSERT INTO `divisions` VALUES (130181, '辛集市', 3, 130200, 37.92000, 115.22000, 1);
INSERT INTO `divisions` VALUES (130182, '藁城市', 3, 130200, 38.03000, 114.83000, 1);
INSERT INTO `divisions` VALUES (130183, '晋州市', 3, 130200, 38.03000, 115.03000, 1);
INSERT INTO `divisions` VALUES (130184, '新乐市', 3, 130200, 38.35000, 114.68000, 1);
INSERT INTO `divisions` VALUES (130185, '鹿泉市', 3, 130200, 38.08000, 114.30000, 1);
INSERT INTO `divisions` VALUES (130200, '唐山市', 2, 130000, 39.63000, 118.20000, 1);
INSERT INTO `divisions` VALUES (130201, '市辖区', 3, 130200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (130202, '路南区', 3, 130200, 39.63000, 118.17000, 0);
INSERT INTO `divisions` VALUES (130203, '路北区', 3, 130200, 39.63000, 118.22000, 0);
INSERT INTO `divisions` VALUES (130204, '古冶区', 3, 130200, 39.73000, 118.42000, 0);
INSERT INTO `divisions` VALUES (130205, '开平区', 3, 130200, 39.68000, 118.27000, 0);
INSERT INTO `divisions` VALUES (130207, '丰南区', 3, 130200, 39.57000, 118.10000, 0);
INSERT INTO `divisions` VALUES (130208, '丰润区', 3, 130200, 39.83000, 118.17000, 0);
INSERT INTO `divisions` VALUES (130209, '曹妃甸区', 3, 130200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (130223, '滦县', 3, 130200, 39.75000, 118.70000, 0);
INSERT INTO `divisions` VALUES (130224, '滦南县', 3, 130200, 39.50000, 118.68000, 0);
INSERT INTO `divisions` VALUES (130225, '乐亭县', 3, 130200, 39.42000, 118.90000, 0);
INSERT INTO `divisions` VALUES (130227, '迁西县', 3, 130200, 40.15000, 118.32000, 0);
INSERT INTO `divisions` VALUES (130229, '玉田县', 3, 130200, 39.88000, 117.73000, 0);
INSERT INTO `divisions` VALUES (130281, '遵化市', 3, 130300, 40.18000, 117.95000, 1);
INSERT INTO `divisions` VALUES (130283, '迁安市', 3, 130300, 40.02000, 118.70000, 1);
INSERT INTO `divisions` VALUES (130300, '秦皇岛市', 2, 130000, 39.93000, 119.60000, 1);
INSERT INTO `divisions` VALUES (130301, '市辖区', 3, 130300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (130302, '海港区', 3, 130300, 39.93000, 119.60000, 0);
INSERT INTO `divisions` VALUES (130303, '山海关区', 3, 130300, 40.00000, 119.77000, 0);
INSERT INTO `divisions` VALUES (130304, '北戴河区', 3, 130300, 39.83000, 119.48000, 0);
INSERT INTO `divisions` VALUES (130321, '青龙满族自治县', 3, 130300, 40.40000, 118.95000, 0);
INSERT INTO `divisions` VALUES (130322, '昌黎县', 3, 130300, 39.70000, 119.17000, 0);
INSERT INTO `divisions` VALUES (130323, '抚宁县', 3, 130300, 39.88000, 119.23000, 0);
INSERT INTO `divisions` VALUES (130324, '卢龙县', 3, 130300, 39.88000, 118.87000, 0);
INSERT INTO `divisions` VALUES (130400, '邯郸市', 2, 130000, 36.62000, 114.48000, 1);
INSERT INTO `divisions` VALUES (130401, '市辖区', 3, 130400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (130402, '邯山区', 3, 130400, 36.60000, 114.48000, 0);
INSERT INTO `divisions` VALUES (130403, '丛台区', 3, 130400, 36.63000, 114.48000, 0);
INSERT INTO `divisions` VALUES (130404, '复兴区', 3, 130400, 36.63000, 114.45000, 0);
INSERT INTO `divisions` VALUES (130406, '峰峰矿区', 3, 130400, 36.42000, 114.20000, 0);
INSERT INTO `divisions` VALUES (130421, '邯郸县', 3, 130400, 36.60000, 114.53000, 0);
INSERT INTO `divisions` VALUES (130423, '临漳县', 3, 130400, 36.35000, 114.62000, 0);
INSERT INTO `divisions` VALUES (130424, '成安县', 3, 130400, 36.43000, 114.68000, 0);
INSERT INTO `divisions` VALUES (130425, '大名县', 3, 130400, 36.28000, 115.15000, 0);
INSERT INTO `divisions` VALUES (130426, '涉县', 3, 130400, 36.57000, 113.67000, 0);
INSERT INTO `divisions` VALUES (130427, '磁县', 3, 130400, 36.35000, 114.37000, 0);
INSERT INTO `divisions` VALUES (130428, '肥乡县', 3, 130400, 36.55000, 114.80000, 0);
INSERT INTO `divisions` VALUES (130429, '永年县', 3, 130400, 36.78000, 114.48000, 0);
INSERT INTO `divisions` VALUES (130430, '邱县', 3, 130400, 36.82000, 115.17000, 0);
INSERT INTO `divisions` VALUES (130431, '鸡泽县', 3, 130400, 36.92000, 114.87000, 0);
INSERT INTO `divisions` VALUES (130432, '广平县', 3, 130400, 36.48000, 114.93000, 0);
INSERT INTO `divisions` VALUES (130433, '馆陶县', 3, 130400, 36.53000, 115.30000, 0);
INSERT INTO `divisions` VALUES (130434, '魏县', 3, 130400, 36.37000, 114.93000, 0);
INSERT INTO `divisions` VALUES (130435, '曲周县', 3, 130400, 36.78000, 114.95000, 0);
INSERT INTO `divisions` VALUES (130481, '武安市', 3, 130500, 36.70000, 114.20000, 1);
INSERT INTO `divisions` VALUES (130500, '邢台市', 2, 130000, 37.07000, 114.48000, 1);
INSERT INTO `divisions` VALUES (130501, '市辖区', 3, 130500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (130502, '桥东区', 3, 130500, 37.07000, 114.50000, 0);
INSERT INTO `divisions` VALUES (130503, '桥西区', 3, 130500, 37.05000, 114.47000, 0);
INSERT INTO `divisions` VALUES (130521, '邢台县', 3, 130500, 37.08000, 114.50000, 0);
INSERT INTO `divisions` VALUES (130522, '临城县', 3, 130500, 37.43000, 114.50000, 0);
INSERT INTO `divisions` VALUES (130523, '内丘县', 3, 130500, 37.30000, 114.52000, 0);
INSERT INTO `divisions` VALUES (130524, '柏乡县', 3, 130500, 37.50000, 114.68000, 0);
INSERT INTO `divisions` VALUES (130525, '隆尧县', 3, 130500, 37.35000, 114.77000, 0);
INSERT INTO `divisions` VALUES (130526, '任县', 3, 130500, 37.13000, 114.68000, 0);
INSERT INTO `divisions` VALUES (130527, '南和县', 3, 130500, 37.00000, 114.68000, 0);
INSERT INTO `divisions` VALUES (130528, '宁晋县', 3, 130500, 37.62000, 114.92000, 0);
INSERT INTO `divisions` VALUES (130529, '巨鹿县', 3, 130500, 37.22000, 115.03000, 0);
INSERT INTO `divisions` VALUES (130530, '新河县', 3, 130500, 37.53000, 115.25000, 0);
INSERT INTO `divisions` VALUES (130531, '广宗县', 3, 130500, 37.07000, 115.15000, 0);
INSERT INTO `divisions` VALUES (130532, '平乡县', 3, 130500, 37.07000, 115.03000, 0);
INSERT INTO `divisions` VALUES (130533, '威县', 3, 130500, 36.98000, 115.25000, 0);
INSERT INTO `divisions` VALUES (130534, '清河县', 3, 130500, 37.07000, 115.67000, 0);
INSERT INTO `divisions` VALUES (130535, '临西县', 3, 130500, 36.85000, 115.50000, 0);
INSERT INTO `divisions` VALUES (130581, '南宫市', 3, 130600, 37.35000, 115.38000, 1);
INSERT INTO `divisions` VALUES (130582, '沙河市', 3, 130600, 36.85000, 114.50000, 1);
INSERT INTO `divisions` VALUES (130600, '保定市', 2, 130000, 38.87000, 115.47000, 1);
INSERT INTO `divisions` VALUES (130601, '市辖区', 3, 130600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (130602, '新市区', 3, 130600, 43.85000, 87.60000, 0);
INSERT INTO `divisions` VALUES (130603, '北市区', 3, 130600, 38.87000, 115.48000, 0);
INSERT INTO `divisions` VALUES (130604, '南市区', 3, 130600, 38.85000, 115.50000, 0);
INSERT INTO `divisions` VALUES (130621, '满城县', 3, 130600, 38.95000, 115.32000, 0);
INSERT INTO `divisions` VALUES (130622, '清苑县', 3, 130600, 38.77000, 115.48000, 0);
INSERT INTO `divisions` VALUES (130623, '涞水县', 3, 130600, 39.40000, 115.72000, 0);
INSERT INTO `divisions` VALUES (130624, '阜平县', 3, 130600, 38.85000, 114.18000, 0);
INSERT INTO `divisions` VALUES (130625, '徐水县', 3, 130600, 39.02000, 115.65000, 0);
INSERT INTO `divisions` VALUES (130626, '定兴县', 3, 130600, 39.27000, 115.77000, 0);
INSERT INTO `divisions` VALUES (130627, '唐县', 3, 130600, 38.75000, 114.98000, 0);
INSERT INTO `divisions` VALUES (130628, '高阳县', 3, 130600, 38.68000, 115.78000, 0);
INSERT INTO `divisions` VALUES (130629, '容城县', 3, 130600, 39.05000, 115.87000, 0);
INSERT INTO `divisions` VALUES (130630, '涞源县', 3, 130600, 39.35000, 114.68000, 0);
INSERT INTO `divisions` VALUES (130631, '望都县', 3, 130600, 38.72000, 115.15000, 0);
INSERT INTO `divisions` VALUES (130632, '安新县', 3, 130600, 38.92000, 115.93000, 0);
INSERT INTO `divisions` VALUES (130633, '易县', 3, 130600, 39.35000, 115.50000, 0);
INSERT INTO `divisions` VALUES (130634, '曲阳县', 3, 130600, 38.62000, 114.70000, 0);
INSERT INTO `divisions` VALUES (130635, '蠡县', 3, 130600, 38.48000, 115.57000, 0);
INSERT INTO `divisions` VALUES (130636, '顺平县', 3, 130600, 38.83000, 115.13000, 0);
INSERT INTO `divisions` VALUES (130637, '博野县', 3, 130600, 38.45000, 115.47000, 0);
INSERT INTO `divisions` VALUES (130638, '雄县', 3, 130600, 38.98000, 116.10000, 0);
INSERT INTO `divisions` VALUES (130681, '涿州市', 3, 130700, 39.48000, 115.97000, 1);
INSERT INTO `divisions` VALUES (130682, '定州市', 3, 130700, 38.52000, 114.97000, 1);
INSERT INTO `divisions` VALUES (130683, '安国市', 3, 130700, 38.42000, 115.32000, 1);
INSERT INTO `divisions` VALUES (130684, '高碑店市', 3, 130700, 39.33000, 115.85000, 1);
INSERT INTO `divisions` VALUES (130700, '张家口市', 2, 130000, 40.82000, 114.88000, 1);
INSERT INTO `divisions` VALUES (130701, '市辖区', 3, 130700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (130702, '桥东区', 3, 130700, 37.07000, 114.50000, 0);
INSERT INTO `divisions` VALUES (130703, '桥西区', 3, 130700, 37.05000, 114.47000, 0);
INSERT INTO `divisions` VALUES (130705, '宣化区', 3, 130700, 40.60000, 115.05000, 0);
INSERT INTO `divisions` VALUES (130706, '下花园区', 3, 130700, 40.48000, 115.27000, 0);
INSERT INTO `divisions` VALUES (130721, '宣化县', 3, 130700, 40.55000, 115.02000, 0);
INSERT INTO `divisions` VALUES (130722, '张北县', 3, 130700, 41.15000, 114.70000, 0);
INSERT INTO `divisions` VALUES (130723, '康保县', 3, 130700, 41.85000, 114.62000, 0);
INSERT INTO `divisions` VALUES (130724, '沽源县', 3, 130700, 41.67000, 115.70000, 0);
INSERT INTO `divisions` VALUES (130725, '尚义县', 3, 130700, 41.08000, 113.97000, 0);
INSERT INTO `divisions` VALUES (130726, '蔚县', 3, 130700, 39.85000, 114.57000, 0);
INSERT INTO `divisions` VALUES (130727, '阳原县', 3, 130700, 40.12000, 114.17000, 0);
INSERT INTO `divisions` VALUES (130728, '怀安县', 3, 130700, 40.67000, 114.42000, 0);
INSERT INTO `divisions` VALUES (130729, '万全县', 3, 130700, 40.75000, 114.72000, 0);
INSERT INTO `divisions` VALUES (130730, '怀来县', 3, 130700, 40.40000, 115.52000, 0);
INSERT INTO `divisions` VALUES (130731, '涿鹿县', 3, 130700, 40.38000, 115.22000, 0);
INSERT INTO `divisions` VALUES (130732, '赤城县', 3, 130700, 40.92000, 115.83000, 0);
INSERT INTO `divisions` VALUES (130733, '崇礼县', 3, 130700, 40.97000, 115.27000, 0);
INSERT INTO `divisions` VALUES (130800, '承德市', 2, 130000, 40.97000, 117.93000, 1);
INSERT INTO `divisions` VALUES (130801, '市辖区', 3, 130800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (130802, '双桥区', 3, 130800, 29.48000, 105.78000, 0);
INSERT INTO `divisions` VALUES (130803, '双滦区', 3, 130800, 40.95000, 117.78000, 0);
INSERT INTO `divisions` VALUES (130804, '鹰手营子矿区', 3, 130800, 40.55000, 117.65000, 0);
INSERT INTO `divisions` VALUES (130821, '承德县', 3, 130800, 40.77000, 118.17000, 0);
INSERT INTO `divisions` VALUES (130822, '兴隆县', 3, 130800, 40.43000, 117.52000, 0);
INSERT INTO `divisions` VALUES (130823, '平泉县', 3, 130800, 41.00000, 118.68000, 0);
INSERT INTO `divisions` VALUES (130824, '滦平县', 3, 130800, 40.93000, 117.33000, 0);
INSERT INTO `divisions` VALUES (130825, '隆化县', 3, 130800, 41.32000, 117.72000, 0);
INSERT INTO `divisions` VALUES (130826, '丰宁满族自治县', 3, 130800, 41.20000, 116.65000, 0);
INSERT INTO `divisions` VALUES (130827, '宽城满族自治县', 3, 130800, 40.60000, 118.48000, 0);
INSERT INTO `divisions` VALUES (130828, '围场满族蒙古族自治县', 3, 130800, 41.93000, 117.75000, 0);
INSERT INTO `divisions` VALUES (130900, '沧州市', 2, 130000, 38.30000, 116.83000, 1);
INSERT INTO `divisions` VALUES (130901, '市辖区', 3, 130900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (130902, '新华区', 3, 130900, 33.73000, 113.30000, 0);
INSERT INTO `divisions` VALUES (130903, '运河区', 3, 130900, 38.32000, 116.85000, 0);
INSERT INTO `divisions` VALUES (130921, '沧县', 3, 130900, 38.30000, 116.87000, 0);
INSERT INTO `divisions` VALUES (130922, '青县', 3, 130900, 38.58000, 116.82000, 0);
INSERT INTO `divisions` VALUES (130923, '东光县', 3, 130900, 37.88000, 116.53000, 0);
INSERT INTO `divisions` VALUES (130924, '海兴县', 3, 130900, 38.13000, 117.48000, 0);
INSERT INTO `divisions` VALUES (130925, '盐山县', 3, 130900, 38.05000, 117.22000, 0);
INSERT INTO `divisions` VALUES (130926, '肃宁县', 3, 130900, 38.43000, 115.83000, 0);
INSERT INTO `divisions` VALUES (130927, '南皮县', 3, 130900, 38.03000, 116.70000, 0);
INSERT INTO `divisions` VALUES (130928, '吴桥县', 3, 130900, 37.62000, 116.38000, 0);
INSERT INTO `divisions` VALUES (130929, '献县', 3, 130900, 38.18000, 116.12000, 0);
INSERT INTO `divisions` VALUES (130930, '孟村回族自治县', 3, 130900, 38.07000, 117.10000, 0);
INSERT INTO `divisions` VALUES (130981, '泊头市', 3, 131000, 38.07000, 116.57000, 1);
INSERT INTO `divisions` VALUES (130982, '任丘市', 3, 131000, 38.72000, 116.10000, 1);
INSERT INTO `divisions` VALUES (130983, '黄骅市', 3, 131000, 38.37000, 117.35000, 1);
INSERT INTO `divisions` VALUES (130984, '河间市', 3, 131000, 38.43000, 116.08000, 1);
INSERT INTO `divisions` VALUES (131000, '廊坊市', 2, 130000, 39.52000, 116.70000, 1);
INSERT INTO `divisions` VALUES (131001, '市辖区', 3, 131000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (131002, '安次区', 3, 131000, 39.52000, 116.68000, 0);
INSERT INTO `divisions` VALUES (131003, '广阳区', 3, 131000, 39.53000, 116.72000, 0);
INSERT INTO `divisions` VALUES (131022, '固安县', 3, 131000, 39.43000, 116.30000, 0);
INSERT INTO `divisions` VALUES (131023, '永清县', 3, 131000, 39.32000, 116.50000, 0);
INSERT INTO `divisions` VALUES (131024, '香河县', 3, 131000, 39.77000, 117.00000, 0);
INSERT INTO `divisions` VALUES (131025, '大城县', 3, 131000, 38.70000, 116.63000, 0);
INSERT INTO `divisions` VALUES (131026, '文安县', 3, 131000, 38.87000, 116.47000, 0);
INSERT INTO `divisions` VALUES (131028, '大厂回族自治县', 3, 131000, 39.88000, 116.98000, 0);
INSERT INTO `divisions` VALUES (131081, '霸州市', 3, 131100, 39.10000, 116.40000, 1);
INSERT INTO `divisions` VALUES (131082, '三河市', 3, 131100, 39.98000, 117.07000, 1);
INSERT INTO `divisions` VALUES (131100, '衡水市', 2, 130000, 37.73000, 115.68000, 1);
INSERT INTO `divisions` VALUES (131101, '市辖区', 3, 131100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (131102, '桃城区', 3, 131100, 37.73000, 115.68000, 0);
INSERT INTO `divisions` VALUES (131121, '枣强县', 3, 131100, 37.52000, 115.72000, 0);
INSERT INTO `divisions` VALUES (131122, '武邑县', 3, 131100, 37.82000, 115.88000, 0);
INSERT INTO `divisions` VALUES (131123, '武强县', 3, 131100, 38.03000, 115.98000, 0);
INSERT INTO `divisions` VALUES (131124, '饶阳县', 3, 131100, 38.23000, 115.73000, 0);
INSERT INTO `divisions` VALUES (131125, '安平县', 3, 131100, 38.23000, 115.52000, 0);
INSERT INTO `divisions` VALUES (131126, '故城县', 3, 131100, 37.35000, 115.97000, 0);
INSERT INTO `divisions` VALUES (131127, '景县', 3, 131100, 37.70000, 116.27000, 0);
INSERT INTO `divisions` VALUES (131128, '阜城县', 3, 131100, 37.87000, 116.15000, 0);
INSERT INTO `divisions` VALUES (131181, '冀州市', 3, 131200, 37.57000, 115.57000, 1);
INSERT INTO `divisions` VALUES (131182, '深州市', 3, 131200, 38.02000, 115.55000, 1);
INSERT INTO `divisions` VALUES (140000, '山西省', 1, 0, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (140100, '太原市', 2, 140000, 37.87000, 112.55000, 1);
INSERT INTO `divisions` VALUES (140101, '市辖区', 3, 140100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (140105, '小店区', 3, 140100, 37.73000, 112.57000, 0);
INSERT INTO `divisions` VALUES (140106, '迎泽区', 3, 140100, 37.87000, 112.57000, 0);
INSERT INTO `divisions` VALUES (140107, '杏花岭区', 3, 140100, 37.88000, 112.57000, 0);
INSERT INTO `divisions` VALUES (140108, '尖草坪区', 3, 140100, 37.93000, 112.48000, 0);
INSERT INTO `divisions` VALUES (140109, '万柏林区', 3, 140100, 37.87000, 112.52000, 0);
INSERT INTO `divisions` VALUES (140110, '晋源区', 3, 140100, 37.73000, 112.48000, 0);
INSERT INTO `divisions` VALUES (140121, '清徐县', 3, 140100, 37.60000, 112.35000, 0);
INSERT INTO `divisions` VALUES (140122, '阳曲县', 3, 140100, 38.07000, 112.67000, 0);
INSERT INTO `divisions` VALUES (140123, '娄烦县', 3, 140100, 38.07000, 111.78000, 0);
INSERT INTO `divisions` VALUES (140181, '古交市', 3, 140200, 37.92000, 112.17000, 1);
INSERT INTO `divisions` VALUES (140200, '大同市', 2, 140000, 40.08000, 113.30000, 1);
INSERT INTO `divisions` VALUES (140201, '市辖区', 3, 140200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (140202, '城区', 3, 140200, 35.50000, 112.83000, 0);
INSERT INTO `divisions` VALUES (140203, '矿区', 3, 140200, 37.87000, 113.57000, 0);
INSERT INTO `divisions` VALUES (140211, '南郊区', 3, 140200, 40.00000, 113.13000, 0);
INSERT INTO `divisions` VALUES (140212, '新荣区', 3, 140200, 40.27000, 113.15000, 0);
INSERT INTO `divisions` VALUES (140221, '阳高县', 3, 140200, 40.37000, 113.75000, 0);
INSERT INTO `divisions` VALUES (140222, '天镇县', 3, 140200, 40.42000, 114.08000, 0);
INSERT INTO `divisions` VALUES (140223, '广灵县', 3, 140200, 39.77000, 114.28000, 0);
INSERT INTO `divisions` VALUES (140224, '灵丘县', 3, 140200, 39.43000, 114.23000, 0);
INSERT INTO `divisions` VALUES (140225, '浑源县', 3, 140200, 39.70000, 113.68000, 0);
INSERT INTO `divisions` VALUES (140226, '左云县', 3, 140200, 40.00000, 112.70000, 0);
INSERT INTO `divisions` VALUES (140227, '大同县', 3, 140200, 40.03000, 113.60000, 0);
INSERT INTO `divisions` VALUES (140300, '阳泉市', 2, 140000, 37.85000, 113.57000, 1);
INSERT INTO `divisions` VALUES (140301, '市辖区', 3, 140300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (140302, '城区', 3, 140300, 35.50000, 112.83000, 0);
INSERT INTO `divisions` VALUES (140303, '矿区', 3, 140300, 37.87000, 113.57000, 0);
INSERT INTO `divisions` VALUES (140311, '郊区', 3, 140300, 30.92000, 117.78000, 0);
INSERT INTO `divisions` VALUES (140321, '平定县', 3, 140300, 37.80000, 113.62000, 0);
INSERT INTO `divisions` VALUES (140322, '盂县', 3, 140300, 38.08000, 113.40000, 0);
INSERT INTO `divisions` VALUES (140400, '长治市', 2, 140000, 36.20000, 113.12000, 1);
INSERT INTO `divisions` VALUES (140401, '市辖区', 3, 140400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (140402, '城区', 3, 140400, 35.50000, 112.83000, 0);
INSERT INTO `divisions` VALUES (140411, '郊区', 3, 140400, 30.92000, 117.78000, 0);
INSERT INTO `divisions` VALUES (140421, '长治县', 3, 140400, 36.05000, 113.03000, 0);
INSERT INTO `divisions` VALUES (140423, '襄垣县', 3, 140400, 36.53000, 113.05000, 0);
INSERT INTO `divisions` VALUES (140424, '屯留县', 3, 140400, 36.32000, 112.88000, 0);
INSERT INTO `divisions` VALUES (140425, '平顺县', 3, 140400, 36.20000, 113.43000, 0);
INSERT INTO `divisions` VALUES (140426, '黎城县', 3, 140400, 36.50000, 113.38000, 0);
INSERT INTO `divisions` VALUES (140427, '壶关县', 3, 140400, 36.12000, 113.20000, 0);
INSERT INTO `divisions` VALUES (140428, '长子县', 3, 140400, 36.12000, 112.87000, 0);
INSERT INTO `divisions` VALUES (140429, '武乡县', 3, 140400, 36.83000, 112.85000, 0);
INSERT INTO `divisions` VALUES (140430, '沁县', 3, 140400, 36.75000, 112.70000, 0);
INSERT INTO `divisions` VALUES (140431, '沁源县', 3, 140400, 36.50000, 112.33000, 0);
INSERT INTO `divisions` VALUES (140481, '潞城市', 3, 140500, 36.33000, 113.22000, 1);
INSERT INTO `divisions` VALUES (140500, '晋城市', 2, 140000, 35.50000, 112.83000, 1);
INSERT INTO `divisions` VALUES (140501, '晋城市市辖区', 3, 140500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (140502, '城区', 3, 140500, 35.50000, 112.83000, 0);
INSERT INTO `divisions` VALUES (140521, '沁水县', 3, 140500, 35.68000, 112.18000, 0);
INSERT INTO `divisions` VALUES (140522, '阳城县', 3, 140500, 35.48000, 112.42000, 0);
INSERT INTO `divisions` VALUES (140524, '陵川县', 3, 140500, 35.78000, 113.27000, 0);
INSERT INTO `divisions` VALUES (140525, '泽州县', 3, 140500, 35.50000, 112.83000, 0);
INSERT INTO `divisions` VALUES (140581, '高平市', 3, 140600, 35.80000, 112.92000, 1);
INSERT INTO `divisions` VALUES (140600, '朔州市', 2, 140000, 39.33000, 112.43000, 1);
INSERT INTO `divisions` VALUES (140601, '市辖区', 3, 140600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (140602, '朔城区', 3, 140600, 39.33000, 112.43000, 0);
INSERT INTO `divisions` VALUES (140603, '平鲁区', 3, 140600, 39.53000, 112.12000, 0);
INSERT INTO `divisions` VALUES (140621, '山阴县', 3, 140600, 39.52000, 112.82000, 0);
INSERT INTO `divisions` VALUES (140622, '应县', 3, 140600, 39.55000, 113.18000, 0);
INSERT INTO `divisions` VALUES (140623, '右玉县', 3, 140600, 39.98000, 112.47000, 0);
INSERT INTO `divisions` VALUES (140624, '怀仁县', 3, 140600, 39.83000, 113.08000, 0);
INSERT INTO `divisions` VALUES (140700, '晋中市', 2, 140000, 37.68000, 112.75000, 1);
INSERT INTO `divisions` VALUES (140701, '市辖区', 3, 140700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (140702, '榆次区', 3, 140700, 37.68000, 112.75000, 0);
INSERT INTO `divisions` VALUES (140721, '榆社县', 3, 140700, 37.07000, 112.97000, 0);
INSERT INTO `divisions` VALUES (140722, '左权县', 3, 140700, 37.07000, 113.37000, 0);
INSERT INTO `divisions` VALUES (140723, '和顺县', 3, 140700, 37.33000, 113.57000, 0);
INSERT INTO `divisions` VALUES (140724, '昔阳县', 3, 140700, 37.62000, 113.70000, 0);
INSERT INTO `divisions` VALUES (140725, '寿阳县', 3, 140700, 37.88000, 113.18000, 0);
INSERT INTO `divisions` VALUES (140726, '太谷县', 3, 140700, 37.42000, 112.55000, 0);
INSERT INTO `divisions` VALUES (140727, '祁县', 3, 140700, 37.35000, 112.33000, 0);
INSERT INTO `divisions` VALUES (140728, '平遥县', 3, 140700, 37.18000, 112.17000, 0);
INSERT INTO `divisions` VALUES (140729, '灵石县', 3, 140700, 36.85000, 111.77000, 0);
INSERT INTO `divisions` VALUES (140781, '介休市', 3, 140800, 37.03000, 111.92000, 1);
INSERT INTO `divisions` VALUES (140800, '运城市', 2, 140000, 35.02000, 110.98000, 1);
INSERT INTO `divisions` VALUES (140801, '市辖区', 3, 140800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (140802, '盐湖区', 3, 140800, 35.02000, 110.98000, 0);
INSERT INTO `divisions` VALUES (140821, '临猗县', 3, 140800, 35.15000, 110.77000, 0);
INSERT INTO `divisions` VALUES (140822, '万荣县', 3, 140800, 35.42000, 110.83000, 0);
INSERT INTO `divisions` VALUES (140823, '闻喜县', 3, 140800, 35.35000, 111.22000, 0);
INSERT INTO `divisions` VALUES (140824, '稷山县', 3, 140800, 35.60000, 110.97000, 0);
INSERT INTO `divisions` VALUES (140825, '新绛县', 3, 140800, 35.62000, 111.22000, 0);
INSERT INTO `divisions` VALUES (140826, '绛县', 3, 140800, 35.48000, 111.57000, 0);
INSERT INTO `divisions` VALUES (140827, '垣曲县', 3, 140800, 35.30000, 111.67000, 0);
INSERT INTO `divisions` VALUES (140828, '夏县', 3, 140800, 35.15000, 111.22000, 0);
INSERT INTO `divisions` VALUES (140829, '平陆县', 3, 140800, 34.83000, 111.22000, 0);
INSERT INTO `divisions` VALUES (140830, '芮城县', 3, 140800, 34.70000, 110.68000, 0);
INSERT INTO `divisions` VALUES (140881, '永济市', 3, 140900, 34.88000, 110.42000, 1);
INSERT INTO `divisions` VALUES (140882, '河津市', 3, 140900, 35.60000, 110.70000, 1);
INSERT INTO `divisions` VALUES (140900, '忻州市', 2, 140000, 38.42000, 112.73000, 1);
INSERT INTO `divisions` VALUES (140901, '市辖区', 3, 140900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (140902, '忻府区', 3, 140900, 38.42000, 112.73000, 0);
INSERT INTO `divisions` VALUES (140921, '定襄县', 3, 140900, 38.48000, 112.95000, 0);
INSERT INTO `divisions` VALUES (140922, '五台县', 3, 140900, 38.73000, 113.25000, 0);
INSERT INTO `divisions` VALUES (140923, '代县', 3, 140900, 39.07000, 112.95000, 0);
INSERT INTO `divisions` VALUES (140924, '繁峙县', 3, 140900, 39.18000, 113.25000, 0);
INSERT INTO `divisions` VALUES (140925, '宁武县', 3, 140900, 39.00000, 112.30000, 0);
INSERT INTO `divisions` VALUES (140926, '静乐县', 3, 140900, 38.37000, 111.93000, 0);
INSERT INTO `divisions` VALUES (140927, '神池县', 3, 140900, 39.08000, 112.20000, 0);
INSERT INTO `divisions` VALUES (140928, '五寨县', 3, 140900, 38.90000, 111.85000, 0);
INSERT INTO `divisions` VALUES (140929, '岢岚县', 3, 140900, 38.70000, 111.57000, 0);
INSERT INTO `divisions` VALUES (140930, '河曲县', 3, 140900, 39.38000, 111.13000, 0);
INSERT INTO `divisions` VALUES (140931, '保德县', 3, 140900, 38.01000, 111.09000, 0);
INSERT INTO `divisions` VALUES (140932, '偏关县', 3, 140900, 39.43000, 111.50000, 0);
INSERT INTO `divisions` VALUES (140981, '原平市', 3, 141000, 38.73000, 112.70000, 1);
INSERT INTO `divisions` VALUES (141000, '临汾市', 2, 140000, 36.08000, 111.52000, 1);
INSERT INTO `divisions` VALUES (141001, '市辖区', 3, 141000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (141002, '尧都区', 3, 141000, 36.08000, 111.52000, 0);
INSERT INTO `divisions` VALUES (141021, '曲沃县', 3, 141000, 35.63000, 111.47000, 0);
INSERT INTO `divisions` VALUES (141022, '翼城县', 3, 141000, 35.73000, 111.72000, 0);
INSERT INTO `divisions` VALUES (141023, '襄汾县', 3, 141000, 35.88000, 111.43000, 0);
INSERT INTO `divisions` VALUES (141024, '洪洞县', 3, 141000, 36.25000, 111.67000, 0);
INSERT INTO `divisions` VALUES (141025, '古县', 3, 141000, 36.27000, 111.92000, 0);
INSERT INTO `divisions` VALUES (141026, '安泽县', 3, 141000, 36.15000, 112.25000, 0);
INSERT INTO `divisions` VALUES (141027, '浮山县', 3, 141000, 35.97000, 111.83000, 0);
INSERT INTO `divisions` VALUES (141028, '吉县', 3, 141000, 36.10000, 110.68000, 0);
INSERT INTO `divisions` VALUES (141029, '乡宁县', 3, 141000, 35.97000, 110.83000, 0);
INSERT INTO `divisions` VALUES (141030, '大宁县', 3, 141000, 36.47000, 110.75000, 0);
INSERT INTO `divisions` VALUES (141031, '隰县', 3, 141000, 36.70000, 110.93000, 0);
INSERT INTO `divisions` VALUES (141032, '永和县', 3, 141000, 36.77000, 110.63000, 0);
INSERT INTO `divisions` VALUES (141033, '蒲县', 3, 141000, 36.42000, 111.08000, 0);
INSERT INTO `divisions` VALUES (141034, '汾西县', 3, 141000, 36.65000, 111.57000, 0);
INSERT INTO `divisions` VALUES (141081, '侯马市', 3, 141100, 35.62000, 111.35000, 1);
INSERT INTO `divisions` VALUES (141082, '霍州市', 3, 141100, 36.57000, 111.72000, 1);
INSERT INTO `divisions` VALUES (141100, '吕梁市', 2, 140000, 37.52000, 111.13000, 1);
INSERT INTO `divisions` VALUES (141101, '市辖区', 3, 141100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (141102, '离石区', 3, 141100, 37.52000, 111.13000, 0);
INSERT INTO `divisions` VALUES (141121, '文水县', 3, 141100, 37.43000, 112.02000, 0);
INSERT INTO `divisions` VALUES (141122, '交城县', 3, 141100, 37.55000, 112.15000, 0);
INSERT INTO `divisions` VALUES (141123, '兴县', 3, 141100, 38.47000, 111.12000, 0);
INSERT INTO `divisions` VALUES (141124, '临县', 3, 141100, 37.95000, 110.98000, 0);
INSERT INTO `divisions` VALUES (141125, '柳林县', 3, 141100, 37.43000, 110.90000, 0);
INSERT INTO `divisions` VALUES (141126, '石楼县', 3, 141100, 37.00000, 110.83000, 0);
INSERT INTO `divisions` VALUES (141127, '岚县', 3, 141100, 38.28000, 111.67000, 0);
INSERT INTO `divisions` VALUES (141128, '方山县', 3, 141100, 37.88000, 111.23000, 0);
INSERT INTO `divisions` VALUES (141129, '中阳县', 3, 141100, 37.33000, 111.18000, 0);
INSERT INTO `divisions` VALUES (141130, '交口县', 3, 141100, 36.97000, 111.20000, 0);
INSERT INTO `divisions` VALUES (141181, '孝义市', 3, 141200, 37.15000, 111.77000, 1);
INSERT INTO `divisions` VALUES (141182, '汾阳市', 3, 141200, 37.27000, 111.78000, 1);
INSERT INTO `divisions` VALUES (150000, '内蒙古自治区', 1, 0, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (150100, '呼和浩特市', 2, 150000, 40.83000, 111.73000, 1);
INSERT INTO `divisions` VALUES (150101, '市辖区', 3, 150100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (150102, '新城区', 3, 150100, 34.27000, 108.95000, 0);
INSERT INTO `divisions` VALUES (150103, '回民区', 3, 150100, 40.80000, 111.60000, 0);
INSERT INTO `divisions` VALUES (150104, '玉泉区', 3, 150100, 40.75000, 111.67000, 0);
INSERT INTO `divisions` VALUES (150105, '赛罕区', 3, 150100, 40.80000, 111.68000, 0);
INSERT INTO `divisions` VALUES (150121, '土默特左旗', 3, 150100, 40.72000, 111.13000, 1);
INSERT INTO `divisions` VALUES (150122, '托克托县', 3, 150100, 40.27000, 111.18000, 0);
INSERT INTO `divisions` VALUES (150123, '和林格尔县', 3, 150100, 40.38000, 111.82000, 0);
INSERT INTO `divisions` VALUES (150124, '清水河县', 3, 150100, 39.92000, 111.68000, 0);
INSERT INTO `divisions` VALUES (150125, '武川县', 3, 150100, 41.08000, 111.45000, 0);
INSERT INTO `divisions` VALUES (150200, '包头市', 2, 150000, 40.65000, 109.83000, 1);
INSERT INTO `divisions` VALUES (150201, '市辖区', 3, 150200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (150202, '东河区', 3, 150200, 40.58000, 110.02000, 0);
INSERT INTO `divisions` VALUES (150203, '昆都仑区', 3, 150200, 40.63000, 109.83000, 0);
INSERT INTO `divisions` VALUES (150204, '青山区', 3, 150200, 30.63000, 114.38000, 0);
INSERT INTO `divisions` VALUES (150205, '石拐区', 3, 150200, 40.68000, 110.27000, 0);
INSERT INTO `divisions` VALUES (150207, '九原区', 3, 150200, 40.60000, 109.97000, 0);
INSERT INTO `divisions` VALUES (150221, '土默特右旗', 3, 150200, 40.57000, 110.52000, 1);
INSERT INTO `divisions` VALUES (150222, '固阳县', 3, 150200, 41.03000, 110.05000, 0);
INSERT INTO `divisions` VALUES (150223, '达尔罕茂明安联合旗', 3, 150200, 41.70000, 110.43000, 1);
INSERT INTO `divisions` VALUES (150300, '乌海市', 2, 150000, 39.67000, 106.82000, 1);
INSERT INTO `divisions` VALUES (150301, '市辖区', 3, 150300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (150302, '海勃湾区', 3, 150300, 39.70000, 106.83000, 0);
INSERT INTO `divisions` VALUES (150303, '海南区', 3, 150300, 39.43000, 106.88000, 0);
INSERT INTO `divisions` VALUES (150304, '乌达区', 3, 150300, 39.50000, 106.70000, 0);
INSERT INTO `divisions` VALUES (150400, '赤峰市', 2, 150000, 42.27000, 118.92000, 1);
INSERT INTO `divisions` VALUES (150401, '市辖区', 3, 150400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (150402, '红山区', 3, 150400, 42.28000, 118.97000, 0);
INSERT INTO `divisions` VALUES (150403, '元宝山区', 3, 150400, 42.03000, 119.28000, 0);
INSERT INTO `divisions` VALUES (150404, '松山区', 3, 150400, 42.28000, 118.92000, 0);
INSERT INTO `divisions` VALUES (150421, '阿鲁科尔沁旗', 3, 150400, 43.88000, 120.08000, 1);
INSERT INTO `divisions` VALUES (150422, '巴林左旗', 3, 150400, 43.98000, 119.38000, 1);
INSERT INTO `divisions` VALUES (150423, '巴林右旗', 3, 150400, 43.52000, 118.67000, 1);
INSERT INTO `divisions` VALUES (150424, '林西县', 3, 150400, 43.60000, 118.05000, 0);
INSERT INTO `divisions` VALUES (150425, '克什克腾旗', 3, 150400, 43.25000, 117.53000, 1);
INSERT INTO `divisions` VALUES (150426, '翁牛特旗', 3, 150400, 42.93000, 119.02000, 1);
INSERT INTO `divisions` VALUES (150428, '喀喇沁旗', 3, 150400, 41.93000, 118.70000, 1);
INSERT INTO `divisions` VALUES (150429, '宁城县', 3, 150400, 41.60000, 119.33000, 0);
INSERT INTO `divisions` VALUES (150430, '敖汉旗', 3, 150400, 42.28000, 119.90000, 1);
INSERT INTO `divisions` VALUES (150500, '通辽市', 2, 150000, 43.62000, 122.27000, 1);
INSERT INTO `divisions` VALUES (150501, '市辖区', 3, 150500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (150502, '科尔沁区', 3, 150500, 43.62000, 122.27000, 0);
INSERT INTO `divisions` VALUES (150521, '科尔沁左翼中旗', 3, 150500, 44.13000, 123.32000, 1);
INSERT INTO `divisions` VALUES (150522, '科尔沁左翼后旗', 3, 150500, 42.95000, 122.35000, 1);
INSERT INTO `divisions` VALUES (150523, '开鲁县', 3, 150500, 43.60000, 121.30000, 0);
INSERT INTO `divisions` VALUES (150524, '库伦旗', 3, 150500, 42.73000, 121.77000, 1);
INSERT INTO `divisions` VALUES (150525, '奈曼旗', 3, 150500, 42.85000, 120.65000, 1);
INSERT INTO `divisions` VALUES (150526, '扎鲁特旗', 3, 150500, 44.55000, 120.92000, 1);
INSERT INTO `divisions` VALUES (150581, '霍林郭勒市', 3, 150600, 45.53000, 119.65000, 1);
INSERT INTO `divisions` VALUES (150600, '鄂尔多斯市', 2, 150000, 39.62000, 109.80000, 1);
INSERT INTO `divisions` VALUES (150601, '市辖区', 3, 150600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (150602, '东胜区', 3, 150600, 39.82000, 110.00000, 0);
INSERT INTO `divisions` VALUES (150621, '达拉特旗', 3, 150600, 40.40000, 110.03000, 1);
INSERT INTO `divisions` VALUES (150622, '准格尔旗', 3, 150600, 39.87000, 111.23000, 1);
INSERT INTO `divisions` VALUES (150623, '鄂托克前旗', 3, 150600, 38.18000, 107.48000, 1);
INSERT INTO `divisions` VALUES (150624, '鄂托克旗', 3, 150600, 39.10000, 107.98000, 1);
INSERT INTO `divisions` VALUES (150625, '杭锦旗', 3, 150600, 39.83000, 108.72000, 1);
INSERT INTO `divisions` VALUES (150626, '乌审旗', 3, 150600, 38.60000, 108.85000, 1);
INSERT INTO `divisions` VALUES (150627, '伊金霍洛旗', 3, 150600, 39.57000, 109.73000, 1);
INSERT INTO `divisions` VALUES (150700, '呼伦贝尔市', 2, 150000, 49.22000, 119.77000, 1);
INSERT INTO `divisions` VALUES (150701, '市辖区', 3, 150700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (150702, '海拉尔区', 3, 150700, 49.22000, 119.77000, 0);
INSERT INTO `divisions` VALUES (150721, '阿荣旗', 3, 150700, 48.13000, 123.47000, 1);
INSERT INTO `divisions` VALUES (150722, '莫力达瓦达斡尔族自治旗', 3, 150700, 48.47000, 124.50000, 1);
INSERT INTO `divisions` VALUES (150723, '鄂伦春自治旗', 3, 150700, 50.58000, 123.72000, 1);
INSERT INTO `divisions` VALUES (150724, '鄂温克族自治旗', 3, 150700, 49.13000, 119.75000, 1);
INSERT INTO `divisions` VALUES (150725, '陈巴尔虎旗', 3, 150700, 49.32000, 119.43000, 1);
INSERT INTO `divisions` VALUES (150726, '新巴尔虎左旗', 3, 150700, 48.22000, 118.27000, 1);
INSERT INTO `divisions` VALUES (150727, '新巴尔虎右旗', 3, 150700, 48.67000, 116.82000, 1);
INSERT INTO `divisions` VALUES (150781, '满洲里市', 3, 150800, 49.58000, 117.45000, 1);
INSERT INTO `divisions` VALUES (150782, '牙克石市', 3, 150800, 49.28000, 120.73000, 1);
INSERT INTO `divisions` VALUES (150783, '扎兰屯市', 3, 150800, 47.98000, 122.75000, 1);
INSERT INTO `divisions` VALUES (150784, '额尔古纳市', 3, 150800, 50.23000, 120.18000, 1);
INSERT INTO `divisions` VALUES (150785, '根河市', 3, 150800, 50.78000, 121.52000, 1);
INSERT INTO `divisions` VALUES (150800, '巴彦淖尔市', 2, 150000, 40.75000, 107.42000, 1);
INSERT INTO `divisions` VALUES (150801, '市辖区', 3, 150800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (150802, '临河区', 3, 150800, 40.75000, 107.40000, 0);
INSERT INTO `divisions` VALUES (150821, '五原县', 3, 150800, 41.10000, 108.27000, 0);
INSERT INTO `divisions` VALUES (150822, '磴口县', 3, 150800, 40.33000, 107.02000, 0);
INSERT INTO `divisions` VALUES (150823, '乌拉特前旗', 3, 150800, 40.72000, 108.65000, 1);
INSERT INTO `divisions` VALUES (150824, '乌拉特中旗', 3, 150800, 41.57000, 108.52000, 1);
INSERT INTO `divisions` VALUES (150825, '乌拉特后旗', 3, 150800, 41.10000, 107.07000, 1);
INSERT INTO `divisions` VALUES (150826, '杭锦后旗', 3, 150800, 40.88000, 107.15000, 1);
INSERT INTO `divisions` VALUES (150900, '乌兰察布市', 2, 150000, 40.98000, 113.12000, 1);
INSERT INTO `divisions` VALUES (150901, '市辖区', 3, 150900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (150902, '集宁区', 3, 150900, 41.03000, 113.10000, 0);
INSERT INTO `divisions` VALUES (150921, '卓资县', 3, 150900, 40.90000, 112.57000, 0);
INSERT INTO `divisions` VALUES (150922, '化德县', 3, 150900, 41.90000, 114.00000, 0);
INSERT INTO `divisions` VALUES (150923, '商都县', 3, 150900, 41.55000, 113.53000, 0);
INSERT INTO `divisions` VALUES (150924, '兴和县', 3, 150900, 40.88000, 113.88000, 0);
INSERT INTO `divisions` VALUES (150925, '凉城县', 3, 150900, 40.53000, 112.48000, 0);
INSERT INTO `divisions` VALUES (150926, '察哈尔右翼前旗', 3, 150900, 40.78000, 113.22000, 1);
INSERT INTO `divisions` VALUES (150927, '察哈尔右翼中旗', 3, 150900, 41.27000, 112.63000, 1);
INSERT INTO `divisions` VALUES (150928, '察哈尔右翼后旗', 3, 150900, 41.45000, 113.18000, 1);
INSERT INTO `divisions` VALUES (150929, '四子王旗', 3, 150900, 41.52000, 111.70000, 1);
INSERT INTO `divisions` VALUES (150981, '丰镇市', 3, 151000, 40.43000, 113.15000, 1);
INSERT INTO `divisions` VALUES (152200, '兴安盟', 2, 150000, 46.08000, 122.05000, 1);
INSERT INTO `divisions` VALUES (152201, '乌兰浩特市', 3, 152200, 46.08000, 122.05000, 1);
INSERT INTO `divisions` VALUES (152202, '阿尔山市', 3, 152200, 47.18000, 119.93000, 1);
INSERT INTO `divisions` VALUES (152221, '科尔沁右翼前旗', 3, 152200, 46.07000, 121.92000, 1);
INSERT INTO `divisions` VALUES (152222, '科尔沁右翼中旗', 3, 152200, 45.05000, 121.47000, 1);
INSERT INTO `divisions` VALUES (152223, '扎赉特旗', 3, 152200, 46.73000, 122.90000, 1);
INSERT INTO `divisions` VALUES (152224, '突泉县', 3, 152200, 45.38000, 121.57000, 0);
INSERT INTO `divisions` VALUES (152500, '锡林郭勒盟', 2, 150000, 43.95000, 116.07000, 1);
INSERT INTO `divisions` VALUES (152501, '二连浩特市', 3, 152500, 43.65000, 111.98000, 1);
INSERT INTO `divisions` VALUES (152502, '锡林浩特市', 3, 152500, 43.93000, 116.07000, 1);
INSERT INTO `divisions` VALUES (152522, '阿巴嘎旗', 3, 152500, 44.02000, 114.97000, 1);
INSERT INTO `divisions` VALUES (152523, '苏尼特左旗', 3, 152500, 43.85000, 113.63000, 1);
INSERT INTO `divisions` VALUES (152524, '苏尼特右旗', 3, 152500, 42.75000, 112.65000, 1);
INSERT INTO `divisions` VALUES (152525, '东乌珠穆沁旗', 3, 152500, 45.52000, 116.97000, 1);
INSERT INTO `divisions` VALUES (152526, '西乌珠穆沁旗', 3, 152500, 44.58000, 117.60000, 1);
INSERT INTO `divisions` VALUES (152527, '太仆寺旗', 3, 152500, 41.90000, 115.28000, 1);
INSERT INTO `divisions` VALUES (152528, '镶黄旗', 3, 152500, 42.23000, 113.83000, 1);
INSERT INTO `divisions` VALUES (152529, '正镶白旗', 3, 152500, 42.30000, 115.00000, 1);
INSERT INTO `divisions` VALUES (152530, '正蓝旗', 3, 152500, 42.25000, 116.00000, 1);
INSERT INTO `divisions` VALUES (152531, '多伦县', 3, 152500, 42.18000, 116.47000, 0);
INSERT INTO `divisions` VALUES (152900, '阿拉善盟', 2, 150000, 38.83000, 105.67000, 1);
INSERT INTO `divisions` VALUES (152921, '阿拉善左旗', 3, 152900, 38.83000, 105.67000, 1);
INSERT INTO `divisions` VALUES (152922, '阿拉善右旗', 3, 152900, 39.20000, 101.68000, 1);
INSERT INTO `divisions` VALUES (152923, '额济纳旗', 3, 152900, 41.97000, 101.07000, 1);
INSERT INTO `divisions` VALUES (210000, '辽宁省', 1, 0, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (210100, '沈阳市', 2, 210000, 41.80000, 123.43000, 1);
INSERT INTO `divisions` VALUES (210101, '市辖区', 3, 210100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (210102, '和平区', 3, 210100, 41.78000, 123.40000, 0);
INSERT INTO `divisions` VALUES (210103, '沈河区', 3, 210100, 41.80000, 123.45000, 0);
INSERT INTO `divisions` VALUES (210104, '大东区', 3, 210100, 41.80000, 123.47000, 0);
INSERT INTO `divisions` VALUES (210105, '皇姑区', 3, 210100, 41.82000, 123.42000, 0);
INSERT INTO `divisions` VALUES (210106, '铁西区', 3, 210100, 43.15000, 124.35000, 0);
INSERT INTO `divisions` VALUES (210111, '苏家屯区', 3, 210100, 41.67000, 123.33000, 0);
INSERT INTO `divisions` VALUES (210112, '东陵区', 3, 210100, 41.77000, 123.47000, 0);
INSERT INTO `divisions` VALUES (210113, '沈北新区', 3, 210100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (210114, '于洪区', 3, 210100, 41.78000, 123.30000, 0);
INSERT INTO `divisions` VALUES (210122, '辽中县', 3, 210100, 41.52000, 122.72000, 0);
INSERT INTO `divisions` VALUES (210123, '康平县', 3, 210100, 42.75000, 123.35000, 0);
INSERT INTO `divisions` VALUES (210124, '法库县', 3, 210100, 42.50000, 123.40000, 0);
INSERT INTO `divisions` VALUES (210181, '新民市', 3, 210200, 42.00000, 122.82000, 1);
INSERT INTO `divisions` VALUES (210200, '大连市', 2, 210000, 38.92000, 121.62000, 1);
INSERT INTO `divisions` VALUES (210201, '市辖区', 3, 210200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (210202, '中山区', 3, 210200, 38.92000, 121.63000, 0);
INSERT INTO `divisions` VALUES (210203, '西岗区', 3, 210200, 38.92000, 121.60000, 0);
INSERT INTO `divisions` VALUES (210204, '沙河口区', 3, 210200, 38.90000, 121.58000, 0);
INSERT INTO `divisions` VALUES (210211, '甘井子区', 3, 210200, 38.95000, 121.57000, 0);
INSERT INTO `divisions` VALUES (210212, '旅顺口区', 3, 210200, 38.82000, 121.27000, 0);
INSERT INTO `divisions` VALUES (210213, '金州区', 3, 210200, 39.10000, 121.70000, 0);
INSERT INTO `divisions` VALUES (210224, '长海县', 3, 210200, 39.27000, 122.58000, 0);
INSERT INTO `divisions` VALUES (210281, '瓦房店市', 3, 210300, 39.62000, 122.00000, 1);
INSERT INTO `divisions` VALUES (210282, '普兰店市', 3, 210300, 39.40000, 121.95000, 1);
INSERT INTO `divisions` VALUES (210283, '庄河市', 3, 210300, 39.70000, 122.98000, 1);
INSERT INTO `divisions` VALUES (210300, '鞍山市', 2, 210000, 41.10000, 122.98000, 1);
INSERT INTO `divisions` VALUES (210301, '市辖区', 3, 210300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (210302, '铁东区', 3, 210300, 43.17000, 124.38000, 0);
INSERT INTO `divisions` VALUES (210303, '铁西区', 3, 210300, 43.15000, 124.35000, 0);
INSERT INTO `divisions` VALUES (210304, '立山区', 3, 210300, 41.15000, 123.00000, 0);
INSERT INTO `divisions` VALUES (210311, '千山区', 3, 210300, 41.07000, 122.97000, 0);
INSERT INTO `divisions` VALUES (210321, '台安县', 3, 210300, 41.38000, 122.42000, 0);
INSERT INTO `divisions` VALUES (210323, '岫岩满族自治县', 3, 210300, 40.28000, 123.28000, 0);
INSERT INTO `divisions` VALUES (210381, '海城市', 3, 210400, 40.88000, 122.70000, 1);
INSERT INTO `divisions` VALUES (210400, '抚顺市', 2, 210000, 41.88000, 123.98000, 1);
INSERT INTO `divisions` VALUES (210401, '市辖区', 3, 210400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (210402, '新抚区', 3, 210400, 41.87000, 123.88000, 0);
INSERT INTO `divisions` VALUES (210403, '东洲区', 3, 210400, 41.85000, 124.02000, 0);
INSERT INTO `divisions` VALUES (210404, '望花区', 3, 210400, 41.85000, 123.78000, 0);
INSERT INTO `divisions` VALUES (210411, '顺城区', 3, 210400, 41.88000, 123.93000, 0);
INSERT INTO `divisions` VALUES (210421, '抚顺县', 3, 210400, 41.88000, 123.90000, 0);
INSERT INTO `divisions` VALUES (210422, '新宾满族自治县', 3, 210400, 41.73000, 125.03000, 0);
INSERT INTO `divisions` VALUES (210423, '清原满族自治县', 3, 210400, 42.10000, 124.92000, 0);
INSERT INTO `divisions` VALUES (210500, '本溪市', 2, 210000, 41.30000, 123.77000, 1);
INSERT INTO `divisions` VALUES (210501, '市辖区', 3, 210500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (210502, '平山区', 3, 210500, 41.30000, 123.77000, 0);
INSERT INTO `divisions` VALUES (210503, '溪湖区', 3, 210500, 41.33000, 123.77000, 0);
INSERT INTO `divisions` VALUES (210504, '明山区', 3, 210500, 41.30000, 123.82000, 0);
INSERT INTO `divisions` VALUES (210505, '南芬区', 3, 210500, 41.10000, 123.73000, 0);
INSERT INTO `divisions` VALUES (210521, '本溪满族自治县', 3, 210500, 41.30000, 124.12000, 0);
INSERT INTO `divisions` VALUES (210522, '桓仁满族自治县', 3, 210500, 41.27000, 125.35000, 0);
INSERT INTO `divisions` VALUES (210600, '丹东市', 2, 210000, 40.13000, 124.38000, 1);
INSERT INTO `divisions` VALUES (210601, '市辖区', 3, 210600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (210602, '元宝区', 3, 210600, 40.13000, 124.38000, 0);
INSERT INTO `divisions` VALUES (210603, '振兴区', 3, 210600, 40.08000, 124.35000, 0);
INSERT INTO `divisions` VALUES (210604, '振安区', 3, 210600, 40.17000, 124.42000, 0);
INSERT INTO `divisions` VALUES (210624, '宽甸满族自治县', 3, 210600, 40.73000, 124.78000, 0);
INSERT INTO `divisions` VALUES (210681, '东港市', 3, 210700, 39.87000, 124.15000, 1);
INSERT INTO `divisions` VALUES (210682, '凤城市', 3, 210700, 40.45000, 124.07000, 1);
INSERT INTO `divisions` VALUES (210700, '锦州市', 2, 210000, 41.10000, 121.13000, 1);
INSERT INTO `divisions` VALUES (210701, '市辖区', 3, 210700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (210702, '古塔区', 3, 210700, 41.13000, 121.12000, 0);
INSERT INTO `divisions` VALUES (210703, '凌河区', 3, 210700, 41.12000, 121.15000, 0);
INSERT INTO `divisions` VALUES (210711, '太和区', 3, 210700, 41.10000, 121.10000, 0);
INSERT INTO `divisions` VALUES (210726, '黑山县', 3, 210700, 41.70000, 122.12000, 0);
INSERT INTO `divisions` VALUES (210727, '义县', 3, 210700, 41.53000, 121.23000, 0);
INSERT INTO `divisions` VALUES (210781, '凌海市', 3, 210800, 41.17000, 121.35000, 1);
INSERT INTO `divisions` VALUES (210782, '北镇市', 3, 210800, 41.60000, 121.80000, 1);
INSERT INTO `divisions` VALUES (210800, '营口市', 2, 210000, 40.67000, 122.23000, 1);
INSERT INTO `divisions` VALUES (210801, '市辖区', 3, 210800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (210802, '站前区', 3, 210800, 40.68000, 122.27000, 0);
INSERT INTO `divisions` VALUES (210803, '西市区', 3, 210800, 40.67000, 122.22000, 0);
INSERT INTO `divisions` VALUES (210804, '鲅鱼圈区', 3, 210800, 40.27000, 122.12000, 0);
INSERT INTO `divisions` VALUES (210811, '老边区', 3, 210800, 40.67000, 122.37000, 0);
INSERT INTO `divisions` VALUES (210881, '盖州市', 3, 210900, 40.40000, 122.35000, 1);
INSERT INTO `divisions` VALUES (210882, '大石桥市', 3, 210900, 40.65000, 122.50000, 1);
INSERT INTO `divisions` VALUES (210900, '阜新市', 2, 210000, 42.02000, 121.67000, 1);
INSERT INTO `divisions` VALUES (210901, '市辖区', 3, 210900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (210902, '海州区', 3, 210900, 34.57000, 119.12000, 0);
INSERT INTO `divisions` VALUES (210903, '新邱区', 3, 210900, 41.53000, 119.41000, 0);
INSERT INTO `divisions` VALUES (210904, '太平区', 3, 210900, 42.02000, 121.67000, 0);
INSERT INTO `divisions` VALUES (210905, '清河门区', 3, 210900, 41.75000, 121.42000, 0);
INSERT INTO `divisions` VALUES (210911, '细河区', 3, 210900, 42.03000, 121.68000, 0);
INSERT INTO `divisions` VALUES (210921, '阜新蒙古族自治县', 3, 210900, 42.07000, 121.75000, 0);
INSERT INTO `divisions` VALUES (210922, '彰武县', 3, 210900, 42.38000, 122.53000, 0);
INSERT INTO `divisions` VALUES (211000, '辽阳市', 2, 210000, 41.27000, 123.17000, 1);
INSERT INTO `divisions` VALUES (211001, '市辖区', 3, 211000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (211002, '白塔区', 3, 211000, 41.27000, 123.17000, 0);
INSERT INTO `divisions` VALUES (211003, '文圣区', 3, 211000, 41.27000, 123.18000, 0);
INSERT INTO `divisions` VALUES (211004, '宏伟区', 3, 211000, 41.20000, 123.20000, 0);
INSERT INTO `divisions` VALUES (211005, '弓长岭区', 3, 211000, 41.13000, 123.45000, 0);
INSERT INTO `divisions` VALUES (211011, '太子河区', 3, 211000, 41.25000, 123.18000, 0);
INSERT INTO `divisions` VALUES (211021, '辽阳县', 3, 211000, 41.22000, 123.07000, 0);
INSERT INTO `divisions` VALUES (211081, '灯塔市', 3, 211100, 41.42000, 123.33000, 1);
INSERT INTO `divisions` VALUES (211100, '盘锦市', 2, 210000, 41.12000, 122.07000, 1);
INSERT INTO `divisions` VALUES (211101, '市辖区', 3, 211100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (211102, '双台子区', 3, 211100, 41.20000, 122.05000, 0);
INSERT INTO `divisions` VALUES (211103, '兴隆台区', 3, 211100, 41.12000, 122.07000, 0);
INSERT INTO `divisions` VALUES (211121, '大洼县', 3, 211100, 40.98000, 122.07000, 0);
INSERT INTO `divisions` VALUES (211122, '盘山县', 3, 211100, 41.25000, 122.02000, 0);
INSERT INTO `divisions` VALUES (211200, '铁岭市', 2, 210000, 42.28000, 123.83000, 1);
INSERT INTO `divisions` VALUES (211201, '市辖区', 3, 211200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (211202, '银州区', 3, 211200, 42.28000, 123.85000, 0);
INSERT INTO `divisions` VALUES (211204, '清河区', 3, 211200, 33.60000, 119.02000, 0);
INSERT INTO `divisions` VALUES (211221, '铁岭县', 3, 211200, 42.30000, 123.83000, 0);
INSERT INTO `divisions` VALUES (211223, '西丰县', 3, 211200, 42.73000, 124.72000, 0);
INSERT INTO `divisions` VALUES (211224, '昌图县', 3, 211200, 42.78000, 124.10000, 0);
INSERT INTO `divisions` VALUES (211281, '调兵山市', 3, 211300, 42.47000, 123.55000, 1);
INSERT INTO `divisions` VALUES (211282, '开原市', 3, 211300, 42.55000, 124.03000, 1);
INSERT INTO `divisions` VALUES (211300, '朝阳市', 2, 210000, 41.57000, 120.45000, 1);
INSERT INTO `divisions` VALUES (211301, '市辖区', 3, 211300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (211302, '双塔区', 3, 211300, 41.57000, 120.45000, 0);
INSERT INTO `divisions` VALUES (211303, '龙城区', 3, 211300, 41.60000, 120.43000, 0);
INSERT INTO `divisions` VALUES (211321, '朝阳县', 3, 211300, 41.58000, 120.47000, 0);
INSERT INTO `divisions` VALUES (211322, '建平县', 3, 211300, 41.40000, 119.63000, 0);
INSERT INTO `divisions` VALUES (211324, '喀喇沁左翼蒙古族自治县', 3, 211300, 41.95000, 118.67000, 0);
INSERT INTO `divisions` VALUES (211381, '北票市', 3, 211400, 41.80000, 120.77000, 1);
INSERT INTO `divisions` VALUES (211382, '凌源市', 3, 211400, 41.25000, 119.40000, 1);
INSERT INTO `divisions` VALUES (211400, '葫芦岛市', 2, 210000, 40.72000, 120.83000, 1);
INSERT INTO `divisions` VALUES (211401, '市辖区', 3, 211400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (211402, '连山区', 3, 211400, 40.77000, 120.87000, 0);
INSERT INTO `divisions` VALUES (211403, '龙港区', 3, 211400, 40.72000, 120.93000, 0);
INSERT INTO `divisions` VALUES (211404, '南票区', 3, 211400, 41.10000, 120.75000, 0);
INSERT INTO `divisions` VALUES (211421, '绥中县', 3, 211400, 40.32000, 120.33000, 0);
INSERT INTO `divisions` VALUES (211422, '建昌县', 3, 211400, 40.82000, 119.80000, 0);
INSERT INTO `divisions` VALUES (211481, '兴城市', 3, 211500, 40.62000, 120.72000, 1);
INSERT INTO `divisions` VALUES (220000, '吉林省', 1, 0, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (220100, '长春市', 2, 220000, 43.90000, 125.32000, 1);
INSERT INTO `divisions` VALUES (220101, '市辖区', 3, 220100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (220102, '南关区', 3, 220100, 43.87000, 125.33000, 0);
INSERT INTO `divisions` VALUES (220103, '宽城区', 3, 220100, 43.92000, 125.32000, 0);
INSERT INTO `divisions` VALUES (220104, '朝阳区', 3, 220100, 43.83000, 125.28000, 0);
INSERT INTO `divisions` VALUES (220105, '二道区', 3, 220100, 43.87000, 125.37000, 0);
INSERT INTO `divisions` VALUES (220106, '绿园区', 3, 220100, 43.88000, 125.25000, 0);
INSERT INTO `divisions` VALUES (220112, '双阳区', 3, 220100, 43.52000, 125.67000, 0);
INSERT INTO `divisions` VALUES (220122, '农安县', 3, 220100, 44.43000, 125.18000, 0);
INSERT INTO `divisions` VALUES (220181, '九台市', 3, 220200, 44.15000, 125.83000, 1);
INSERT INTO `divisions` VALUES (220182, '榆树市', 3, 220200, 44.82000, 126.55000, 1);
INSERT INTO `divisions` VALUES (220183, '德惠市', 3, 220200, 44.53000, 125.70000, 1);
INSERT INTO `divisions` VALUES (220200, '吉林市', 2, 220000, 43.83000, 126.55000, 1);
INSERT INTO `divisions` VALUES (220201, '市辖区', 3, 220200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (220202, '昌邑区', 3, 220200, 43.88000, 126.57000, 0);
INSERT INTO `divisions` VALUES (220203, '龙潭区', 3, 220200, 43.92000, 126.57000, 0);
INSERT INTO `divisions` VALUES (220204, '船营区', 3, 220200, 43.83000, 126.53000, 0);
INSERT INTO `divisions` VALUES (220211, '丰满区', 3, 220200, 43.82000, 126.57000, 0);
INSERT INTO `divisions` VALUES (220221, '永吉县', 3, 220200, 43.67000, 126.50000, 0);
INSERT INTO `divisions` VALUES (220281, '蛟河市', 3, 220300, 43.72000, 127.33000, 1);
INSERT INTO `divisions` VALUES (220282, '桦甸市', 3, 220300, 42.97000, 126.73000, 1);
INSERT INTO `divisions` VALUES (220283, '舒兰市', 3, 220300, 44.42000, 126.95000, 1);
INSERT INTO `divisions` VALUES (220284, '磐石市', 3, 220300, 42.95000, 126.05000, 1);
INSERT INTO `divisions` VALUES (220300, '四平市', 2, 220000, 43.17000, 124.35000, 1);
INSERT INTO `divisions` VALUES (220301, '市辖区', 3, 220300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (220302, '铁西区', 3, 220300, 43.15000, 124.35000, 0);
INSERT INTO `divisions` VALUES (220303, '铁东区', 3, 220300, 43.17000, 124.38000, 0);
INSERT INTO `divisions` VALUES (220322, '梨树县', 3, 220300, 43.32000, 124.33000, 0);
INSERT INTO `divisions` VALUES (220323, '伊通满族自治县', 3, 220300, 43.35000, 125.30000, 0);
INSERT INTO `divisions` VALUES (220381, '公主岭市', 3, 220400, 43.50000, 124.82000, 1);
INSERT INTO `divisions` VALUES (220382, '双辽市', 3, 220400, 43.52000, 123.50000, 1);
INSERT INTO `divisions` VALUES (220400, '辽源市', 2, 220000, 42.88000, 125.13000, 1);
INSERT INTO `divisions` VALUES (220401, '市辖区', 3, 220400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (220402, '龙山区', 3, 220400, 42.90000, 125.12000, 0);
INSERT INTO `divisions` VALUES (220403, '西安区', 3, 220400, 44.57000, 129.62000, 0);
INSERT INTO `divisions` VALUES (220421, '东丰县', 3, 220400, 42.68000, 125.53000, 0);
INSERT INTO `divisions` VALUES (220422, '东辽县', 3, 220400, 42.92000, 125.00000, 0);
INSERT INTO `divisions` VALUES (220500, '通化市', 2, 220000, 41.73000, 125.93000, 1);
INSERT INTO `divisions` VALUES (220501, '市辖区', 3, 220500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (220502, '东昌区', 3, 220500, 41.73000, 125.95000, 0);
INSERT INTO `divisions` VALUES (220503, '二道江区', 3, 220500, 41.77000, 126.03000, 0);
INSERT INTO `divisions` VALUES (220521, '通化县', 3, 220500, 41.68000, 125.75000, 0);
INSERT INTO `divisions` VALUES (220523, '辉南县', 3, 220500, 42.68000, 126.03000, 0);
INSERT INTO `divisions` VALUES (220524, '柳河县', 3, 220500, 42.28000, 125.73000, 0);
INSERT INTO `divisions` VALUES (220581, '梅河口市', 3, 220600, 42.53000, 125.68000, 1);
INSERT INTO `divisions` VALUES (220582, '集安市', 3, 220600, 41.12000, 126.18000, 1);
INSERT INTO `divisions` VALUES (220600, '白山市', 2, 220000, 41.93000, 126.42000, 1);
INSERT INTO `divisions` VALUES (220601, '市辖区', 3, 220600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (220602, '浑江区', 3, 220600, 41.97000, 126.40000, 0);
INSERT INTO `divisions` VALUES (220605, '江源区', 3, 220600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (220621, '抚松县', 3, 220600, 42.33000, 127.28000, 0);
INSERT INTO `divisions` VALUES (220622, '靖宇县', 3, 220600, 42.40000, 126.80000, 0);
INSERT INTO `divisions` VALUES (220623, '长白朝鲜族自治县', 3, 220600, 41.42000, 128.20000, 0);
INSERT INTO `divisions` VALUES (220681, '临江市', 3, 220700, 41.80000, 126.90000, 1);
INSERT INTO `divisions` VALUES (220700, '松原市', 2, 220000, 45.13000, 124.82000, 1);
INSERT INTO `divisions` VALUES (220701, '市辖区', 3, 220700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (220702, '宁江区', 3, 220700, 45.17000, 124.80000, 0);
INSERT INTO `divisions` VALUES (220721, '前郭尔罗斯蒙古族自治县', 3, 220700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (220722, '长岭县', 3, 220700, 44.28000, 123.98000, 0);
INSERT INTO `divisions` VALUES (220723, '乾安县', 3, 220700, 45.02000, 124.02000, 0);
INSERT INTO `divisions` VALUES (220724, '扶余县', 3, 220700, 44.98000, 126.02000, 0);
INSERT INTO `divisions` VALUES (220800, '白城市', 2, 220000, 45.62000, 122.83000, 1);
INSERT INTO `divisions` VALUES (220801, '市辖区', 3, 220800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (220802, '洮北区', 3, 220800, 45.62000, 122.85000, 0);
INSERT INTO `divisions` VALUES (220821, '镇赉县', 3, 220800, 45.85000, 123.20000, 0);
INSERT INTO `divisions` VALUES (220822, '通榆县', 3, 220800, 44.82000, 123.08000, 0);
INSERT INTO `divisions` VALUES (220881, '洮南市', 3, 220900, 45.33000, 122.78000, 1);
INSERT INTO `divisions` VALUES (220882, '大安市', 3, 220900, 45.50000, 124.28000, 1);
INSERT INTO `divisions` VALUES (222400, '延边朝鲜族自治州', 2, 220000, 42.88000, 129.50000, 1);
INSERT INTO `divisions` VALUES (222401, '延吉市', 3, 222400, 42.88000, 129.50000, 1);
INSERT INTO `divisions` VALUES (222402, '图们市', 3, 222400, 42.97000, 129.83000, 1);
INSERT INTO `divisions` VALUES (222403, '敦化市', 3, 222400, 43.37000, 128.23000, 1);
INSERT INTO `divisions` VALUES (222404, '珲春市', 3, 222400, 42.87000, 130.37000, 1);
INSERT INTO `divisions` VALUES (222405, '龙井市', 3, 222400, 42.77000, 129.42000, 1);
INSERT INTO `divisions` VALUES (222406, '和龙市', 3, 222400, 42.53000, 129.00000, 1);
INSERT INTO `divisions` VALUES (222424, '汪清县', 3, 222400, 43.32000, 129.75000, 0);
INSERT INTO `divisions` VALUES (222426, '安图县', 3, 222400, 43.12000, 128.90000, 0);
INSERT INTO `divisions` VALUES (230000, '黑龙江省', 1, 0, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (230100, '哈尔滨市', 2, 230000, 45.80000, 126.53000, 1);
INSERT INTO `divisions` VALUES (230101, '市辖区', 3, 230100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (230102, '道里区', 3, 230100, 45.77000, 126.62000, 0);
INSERT INTO `divisions` VALUES (230103, '南岗区', 3, 230100, 45.77000, 126.68000, 0);
INSERT INTO `divisions` VALUES (230104, '道外区', 3, 230100, 45.78000, 126.65000, 0);
INSERT INTO `divisions` VALUES (230108, '平房区', 3, 230100, 45.62000, 126.62000, 0);
INSERT INTO `divisions` VALUES (230109, '松北区', 3, 230100, 45.80000, 126.55000, 0);
INSERT INTO `divisions` VALUES (230110, '香坊区', 3, 230100, 45.72000, 126.68000, 0);
INSERT INTO `divisions` VALUES (230111, '呼兰区', 3, 230100, 45.90000, 126.58000, 0);
INSERT INTO `divisions` VALUES (230112, '阿城区', 3, 230100, 45.52000, 126.95000, 0);
INSERT INTO `divisions` VALUES (230123, '依兰县', 3, 230100, 46.32000, 129.55000, 0);
INSERT INTO `divisions` VALUES (230124, '方正县', 3, 230100, 45.83000, 128.83000, 0);
INSERT INTO `divisions` VALUES (230125, '宾县', 3, 230100, 45.75000, 127.48000, 0);
INSERT INTO `divisions` VALUES (230126, '巴彦县', 3, 230100, 46.08000, 127.40000, 0);
INSERT INTO `divisions` VALUES (230127, '木兰县', 3, 230100, 45.95000, 128.03000, 0);
INSERT INTO `divisions` VALUES (230128, '通河县', 3, 230100, 45.97000, 128.75000, 0);
INSERT INTO `divisions` VALUES (230129, '延寿县', 3, 230100, 45.45000, 128.33000, 0);
INSERT INTO `divisions` VALUES (230182, '双城市', 3, 230200, 45.37000, 126.32000, 1);
INSERT INTO `divisions` VALUES (230183, '尚志市', 3, 230200, 45.22000, 127.95000, 1);
INSERT INTO `divisions` VALUES (230184, '五常市', 3, 230200, 44.92000, 127.15000, 1);
INSERT INTO `divisions` VALUES (230200, '齐齐哈尔市', 2, 230000, 47.33000, 123.95000, 1);
INSERT INTO `divisions` VALUES (230201, '市辖区', 3, 230200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (230202, '龙沙区', 3, 230200, 47.32000, 123.95000, 0);
INSERT INTO `divisions` VALUES (230203, '建华区', 3, 230200, 47.35000, 123.95000, 0);
INSERT INTO `divisions` VALUES (230204, '铁锋区', 3, 230200, 47.35000, 123.98000, 0);
INSERT INTO `divisions` VALUES (230205, '昂昂溪区', 3, 230200, 47.15000, 123.80000, 0);
INSERT INTO `divisions` VALUES (230206, '富拉尔基区', 3, 230200, 47.20000, 123.62000, 0);
INSERT INTO `divisions` VALUES (230207, '碾子山区', 3, 230200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (230208, '梅里斯达斡尔族区', 3, 230200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (230221, '龙江县', 3, 230200, 47.33000, 123.18000, 0);
INSERT INTO `divisions` VALUES (230223, '依安县', 3, 230200, 47.88000, 125.30000, 0);
INSERT INTO `divisions` VALUES (230224, '泰来县', 3, 230200, 46.40000, 123.42000, 0);
INSERT INTO `divisions` VALUES (230225, '甘南县', 3, 230200, 47.92000, 123.50000, 0);
INSERT INTO `divisions` VALUES (230227, '富裕县', 3, 230200, 47.82000, 124.47000, 0);
INSERT INTO `divisions` VALUES (230229, '克山县', 3, 230200, 48.03000, 125.87000, 0);
INSERT INTO `divisions` VALUES (230230, '克东县', 3, 230200, 48.03000, 126.25000, 0);
INSERT INTO `divisions` VALUES (230231, '拜泉县', 3, 230200, 47.60000, 126.08000, 0);
INSERT INTO `divisions` VALUES (230281, '讷河市', 3, 230300, 48.48000, 124.87000, 1);
INSERT INTO `divisions` VALUES (230300, '鸡西市', 2, 230000, 45.30000, 130.97000, 1);
INSERT INTO `divisions` VALUES (230301, '市辖区', 3, 230300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (230302, '鸡冠区', 3, 230300, 45.30000, 130.97000, 0);
INSERT INTO `divisions` VALUES (230303, '恒山区', 3, 230300, 45.20000, 130.93000, 0);
INSERT INTO `divisions` VALUES (230304, '滴道区', 3, 230300, 45.37000, 130.78000, 0);
INSERT INTO `divisions` VALUES (230305, '梨树区', 3, 230300, 45.08000, 130.68000, 0);
INSERT INTO `divisions` VALUES (230306, '城子河区', 3, 230300, 45.33000, 131.00000, 0);
INSERT INTO `divisions` VALUES (230307, '麻山区', 3, 230300, 45.20000, 130.52000, 0);
INSERT INTO `divisions` VALUES (230321, '鸡东县', 3, 230300, 45.25000, 131.13000, 0);
INSERT INTO `divisions` VALUES (230381, '虎林市', 3, 230400, 45.77000, 132.98000, 1);
INSERT INTO `divisions` VALUES (230382, '密山市', 3, 230400, 45.55000, 131.87000, 1);
INSERT INTO `divisions` VALUES (230400, '鹤岗市', 2, 230000, 47.33000, 130.27000, 1);
INSERT INTO `divisions` VALUES (230401, '市辖区', 3, 230400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (230402, '向阳区', 3, 230400, 46.80000, 130.33000, 0);
INSERT INTO `divisions` VALUES (230403, '工农区', 3, 230400, 47.32000, 130.25000, 0);
INSERT INTO `divisions` VALUES (230404, '南山区', 3, 230400, 22.52000, 113.92000, 0);
INSERT INTO `divisions` VALUES (230405, '兴安区', 3, 230400, 47.27000, 130.22000, 0);
INSERT INTO `divisions` VALUES (230406, '东山区', 3, 230400, 43.95000, 87.68000, 0);
INSERT INTO `divisions` VALUES (230407, '兴山区', 3, 230400, 47.37000, 130.30000, 0);
INSERT INTO `divisions` VALUES (230421, '萝北县', 3, 230400, 47.58000, 130.83000, 0);
INSERT INTO `divisions` VALUES (230422, '绥滨县', 3, 230400, 47.28000, 131.85000, 0);
INSERT INTO `divisions` VALUES (230500, '双鸭山市', 2, 230000, 46.63000, 131.15000, 1);
INSERT INTO `divisions` VALUES (230501, '市辖区', 3, 230500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (230502, '尖山区', 3, 230500, 46.63000, 131.17000, 0);
INSERT INTO `divisions` VALUES (230503, '岭东区', 3, 230500, 46.57000, 131.13000, 0);
INSERT INTO `divisions` VALUES (230505, '四方台区', 3, 230500, 46.58000, 131.33000, 0);
INSERT INTO `divisions` VALUES (230506, '宝山区', 3, 230500, 31.40000, 121.48000, 0);
INSERT INTO `divisions` VALUES (230521, '集贤县', 3, 230500, 46.72000, 131.13000, 0);
INSERT INTO `divisions` VALUES (230522, '友谊县', 3, 230500, 46.78000, 131.80000, 0);
INSERT INTO `divisions` VALUES (230523, '宝清县', 3, 230500, 46.32000, 132.20000, 0);
INSERT INTO `divisions` VALUES (230524, '饶河县', 3, 230500, 46.80000, 134.02000, 0);
INSERT INTO `divisions` VALUES (230600, '大庆市', 2, 230000, 46.58000, 125.03000, 1);
INSERT INTO `divisions` VALUES (230601, '市辖区', 3, 230600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (230602, '萨尔图区', 3, 230600, 46.60000, 125.02000, 0);
INSERT INTO `divisions` VALUES (230603, '龙凤区', 3, 230600, 46.53000, 125.10000, 0);
INSERT INTO `divisions` VALUES (230604, '让胡路区', 3, 230600, 46.65000, 124.85000, 0);
INSERT INTO `divisions` VALUES (230605, '红岗区', 3, 230600, 46.40000, 124.88000, 0);
INSERT INTO `divisions` VALUES (230606, '大同区', 3, 230600, 46.03000, 124.82000, 0);
INSERT INTO `divisions` VALUES (230621, '肇州县', 3, 230600, 45.70000, 125.27000, 0);
INSERT INTO `divisions` VALUES (230622, '肇源县', 3, 230600, 45.52000, 125.08000, 0);
INSERT INTO `divisions` VALUES (230623, '林甸县', 3, 230600, 47.18000, 124.87000, 0);
INSERT INTO `divisions` VALUES (230624, '杜尔伯特蒙古族自治县', 3, 230600, 46.87000, 124.45000, 0);
INSERT INTO `divisions` VALUES (230700, '伊春市', 2, 230000, 47.73000, 128.90000, 1);
INSERT INTO `divisions` VALUES (230701, '市辖区', 3, 230700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (230702, '伊春区', 3, 230700, 47.73000, 128.92000, 0);
INSERT INTO `divisions` VALUES (230703, '南岔区', 3, 230700, 47.13000, 129.28000, 0);
INSERT INTO `divisions` VALUES (230704, '友好区', 3, 230700, 47.85000, 128.82000, 0);
INSERT INTO `divisions` VALUES (230705, '西林区', 3, 230700, 47.48000, 129.28000, 0);
INSERT INTO `divisions` VALUES (230706, '翠峦区', 3, 230700, 47.72000, 128.65000, 0);
INSERT INTO `divisions` VALUES (230707, '新青区', 3, 230700, 48.28000, 129.53000, 0);
INSERT INTO `divisions` VALUES (230708, '美溪区', 3, 230700, 47.63000, 129.13000, 0);
INSERT INTO `divisions` VALUES (230709, '金山屯区', 3, 230700, 47.42000, 129.43000, 0);
INSERT INTO `divisions` VALUES (230710, '五营区', 3, 230700, 48.12000, 129.25000, 0);
INSERT INTO `divisions` VALUES (230711, '乌马河区', 3, 230700, 47.72000, 128.78000, 0);
INSERT INTO `divisions` VALUES (230712, '汤旺河区', 3, 230700, 48.45000, 129.57000, 0);
INSERT INTO `divisions` VALUES (230713, '带岭区', 3, 230700, 47.02000, 129.02000, 0);
INSERT INTO `divisions` VALUES (230714, '乌伊岭区', 3, 230700, 48.60000, 129.42000, 0);
INSERT INTO `divisions` VALUES (230715, '红星区', 3, 230700, 48.23000, 129.38000, 0);
INSERT INTO `divisions` VALUES (230716, '上甘岭区', 3, 230700, 47.97000, 129.02000, 0);
INSERT INTO `divisions` VALUES (230722, '嘉荫县', 3, 230700, 48.88000, 130.38000, 0);
INSERT INTO `divisions` VALUES (230781, '铁力市', 3, 230800, 46.98000, 128.02000, 1);
INSERT INTO `divisions` VALUES (230800, '佳木斯市', 2, 230000, 46.82000, 130.37000, 1);
INSERT INTO `divisions` VALUES (230801, '市辖区', 3, 230800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (230803, '向阳区', 3, 230800, 46.80000, 130.33000, 0);
INSERT INTO `divisions` VALUES (230804, '前进区', 3, 230800, 46.82000, 130.37000, 0);
INSERT INTO `divisions` VALUES (230805, '东风区', 3, 230800, 46.82000, 130.40000, 0);
INSERT INTO `divisions` VALUES (230811, '郊区', 3, 230800, 30.92000, 117.78000, 0);
INSERT INTO `divisions` VALUES (230822, '桦南县', 3, 230800, 46.23000, 130.57000, 0);
INSERT INTO `divisions` VALUES (230826, '桦川县', 3, 230800, 47.02000, 130.72000, 0);
INSERT INTO `divisions` VALUES (230828, '汤原县', 3, 230800, 46.73000, 129.90000, 0);
INSERT INTO `divisions` VALUES (230833, '抚远县', 3, 230800, 48.37000, 134.28000, 0);
INSERT INTO `divisions` VALUES (230881, '同江市', 3, 230900, 47.65000, 132.52000, 1);
INSERT INTO `divisions` VALUES (230882, '富锦市', 3, 230900, 47.25000, 132.03000, 1);
INSERT INTO `divisions` VALUES (230900, '七台河市', 2, 230000, 45.78000, 130.95000, 1);
INSERT INTO `divisions` VALUES (230901, '市辖区', 3, 230900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (230902, '新兴区', 3, 230900, 45.80000, 130.83000, 0);
INSERT INTO `divisions` VALUES (230903, '桃山区', 3, 230900, 45.77000, 130.97000, 0);
INSERT INTO `divisions` VALUES (230904, '茄子河区', 3, 230900, 45.77000, 131.07000, 0);
INSERT INTO `divisions` VALUES (230921, '勃利县', 3, 230900, 45.75000, 130.57000, 0);
INSERT INTO `divisions` VALUES (231000, '牡丹江市', 2, 230000, 44.58000, 129.60000, 1);
INSERT INTO `divisions` VALUES (231001, '市辖区', 3, 231000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (231002, '东安区', 3, 231000, 44.58000, 129.62000, 0);
INSERT INTO `divisions` VALUES (231003, '阳明区', 3, 231000, 44.60000, 129.63000, 0);
INSERT INTO `divisions` VALUES (231004, '爱民区', 3, 231000, 44.58000, 129.58000, 0);
INSERT INTO `divisions` VALUES (231005, '西安区', 3, 231000, 44.57000, 129.62000, 0);
INSERT INTO `divisions` VALUES (231024, '东宁县', 3, 231000, 44.07000, 131.12000, 0);
INSERT INTO `divisions` VALUES (231025, '林口县', 3, 231000, 45.30000, 130.27000, 0);
INSERT INTO `divisions` VALUES (231081, '绥芬河市', 3, 231100, 44.42000, 131.15000, 1);
INSERT INTO `divisions` VALUES (231083, '海林市', 3, 231100, 44.57000, 129.38000, 1);
INSERT INTO `divisions` VALUES (231084, '宁安市', 3, 231100, 44.35000, 129.47000, 1);
INSERT INTO `divisions` VALUES (231085, '穆棱市', 3, 231100, 44.92000, 130.52000, 1);
INSERT INTO `divisions` VALUES (231100, '黑河市', 2, 230000, 50.25000, 127.48000, 1);
INSERT INTO `divisions` VALUES (231101, '市辖区', 3, 231100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (231102, '爱辉区', 3, 231100, 50.25000, 127.48000, 0);
INSERT INTO `divisions` VALUES (231121, '嫩江县', 3, 231100, 49.17000, 125.20000, 0);
INSERT INTO `divisions` VALUES (231123, '逊克县', 3, 231100, 49.58000, 128.47000, 0);
INSERT INTO `divisions` VALUES (231124, '孙吴县', 3, 231100, 49.42000, 127.32000, 0);
INSERT INTO `divisions` VALUES (231181, '北安市', 3, 231200, 48.23000, 126.52000, 1);
INSERT INTO `divisions` VALUES (231182, '五大连池市', 3, 231200, 48.52000, 126.20000, 1);
INSERT INTO `divisions` VALUES (231200, '绥化市', 2, 230000, 46.63000, 126.98000, 1);
INSERT INTO `divisions` VALUES (231201, '市辖区', 3, 231200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (231202, '北林区', 3, 231200, 46.63000, 126.98000, 0);
INSERT INTO `divisions` VALUES (231221, '望奎县', 3, 231200, 46.83000, 126.48000, 0);
INSERT INTO `divisions` VALUES (231222, '兰西县', 3, 231200, 46.27000, 126.28000, 0);
INSERT INTO `divisions` VALUES (231223, '青冈县', 3, 231200, 46.68000, 126.10000, 0);
INSERT INTO `divisions` VALUES (231224, '庆安县', 3, 231200, 46.88000, 127.52000, 0);
INSERT INTO `divisions` VALUES (231225, '明水县', 3, 231200, 47.18000, 125.90000, 0);
INSERT INTO `divisions` VALUES (231226, '绥棱县', 3, 231200, 47.25000, 127.10000, 0);
INSERT INTO `divisions` VALUES (231281, '安达市', 3, 231300, 46.40000, 125.33000, 1);
INSERT INTO `divisions` VALUES (231282, '肇东市', 3, 231300, 46.07000, 125.98000, 1);
INSERT INTO `divisions` VALUES (231283, '海伦市', 3, 231300, 47.47000, 126.97000, 1);
INSERT INTO `divisions` VALUES (232700, '大兴安岭地区', 2, 230000, 50.42000, 124.12000, 0);
INSERT INTO `divisions` VALUES (232721, '呼玛县', 3, 232700, 51.73000, 126.65000, 0);
INSERT INTO `divisions` VALUES (232722, '塔河县', 3, 232700, 52.32000, 124.70000, 0);
INSERT INTO `divisions` VALUES (232723, '漠河县', 3, 232700, 52.97000, 122.53000, 0);
INSERT INTO `divisions` VALUES (310000, '上海市', 1, 0, 31.23000, 121.47000, 1);
INSERT INTO `divisions` VALUES (310100, '市辖区', 2, 310000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (310101, '黄浦区', 3, 310100, 31.23000, 121.48000, 0);
INSERT INTO `divisions` VALUES (310104, '徐汇区', 3, 310100, 31.18000, 121.43000, 0);
INSERT INTO `divisions` VALUES (310105, '长宁区', 3, 310100, 31.22000, 121.42000, 0);
INSERT INTO `divisions` VALUES (310106, '静安区', 3, 310100, 31.23000, 121.45000, 0);
INSERT INTO `divisions` VALUES (310107, '普陀区', 3, 310100, 29.95000, 122.30000, 0);
INSERT INTO `divisions` VALUES (310108, '闸北区', 3, 310100, 31.25000, 121.45000, 0);
INSERT INTO `divisions` VALUES (310109, '虹口区', 3, 310100, 31.27000, 121.50000, 0);
INSERT INTO `divisions` VALUES (310110, '杨浦区', 3, 310100, 31.27000, 121.52000, 0);
INSERT INTO `divisions` VALUES (310112, '闵行区', 3, 310100, 31.12000, 121.38000, 0);
INSERT INTO `divisions` VALUES (310113, '宝山区', 3, 310100, 31.40000, 121.48000, 0);
INSERT INTO `divisions` VALUES (310114, '嘉定区', 3, 310100, 31.38000, 121.27000, 0);
INSERT INTO `divisions` VALUES (310115, '浦东新区', 3, 310100, 31.22000, 121.53000, 0);
INSERT INTO `divisions` VALUES (310116, '金山区', 3, 310100, 30.75000, 121.33000, 0);
INSERT INTO `divisions` VALUES (310117, '松江区', 3, 310100, 31.03000, 121.22000, 0);
INSERT INTO `divisions` VALUES (310118, '青浦区', 3, 310100, 31.15000, 121.12000, 0);
INSERT INTO `divisions` VALUES (310120, '奉贤区', 3, 310100, 30.92000, 121.47000, 0);
INSERT INTO `divisions` VALUES (310200, '县', 2, 310000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (310230, '崇明县', 3, 310200, 31.62000, 121.40000, 0);
INSERT INTO `divisions` VALUES (320000, '江苏省', 1, 0, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (320100, '南京市', 2, 320000, 32.07000, 118.78000, 1);
INSERT INTO `divisions` VALUES (320101, '市辖区', 3, 320100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (320102, '玄武区', 3, 320100, 32.05000, 118.80000, 0);
INSERT INTO `divisions` VALUES (320103, '白下区', 3, 320100, 32.03000, 118.78000, 0);
INSERT INTO `divisions` VALUES (320104, '秦淮区', 3, 320100, 32.02000, 118.80000, 0);
INSERT INTO `divisions` VALUES (320105, '建邺区', 3, 320100, 32.03000, 118.75000, 0);
INSERT INTO `divisions` VALUES (320106, '鼓楼区', 3, 320100, 34.78000, 114.35000, 0);
INSERT INTO `divisions` VALUES (320107, '下关区', 3, 320100, 32.08000, 118.73000, 0);
INSERT INTO `divisions` VALUES (320111, '浦口区', 3, 320100, 32.05000, 118.62000, 0);
INSERT INTO `divisions` VALUES (320113, '栖霞区', 3, 320100, 32.12000, 118.88000, 0);
INSERT INTO `divisions` VALUES (320114, '雨花台区', 3, 320100, 32.00000, 118.77000, 0);
INSERT INTO `divisions` VALUES (320115, '江宁区', 3, 320100, 31.95000, 118.85000, 0);
INSERT INTO `divisions` VALUES (320116, '六合区', 3, 320100, 32.35000, 118.83000, 0);
INSERT INTO `divisions` VALUES (320124, '溧水县', 3, 320100, 31.65000, 119.02000, 0);
INSERT INTO `divisions` VALUES (320125, '高淳县', 3, 320100, 31.33000, 118.88000, 0);
INSERT INTO `divisions` VALUES (320200, '无锡市', 2, 320000, 31.57000, 120.30000, 1);
INSERT INTO `divisions` VALUES (320201, '市辖区', 3, 320200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (320202, '崇安区', 3, 320200, 31.58000, 120.30000, 0);
INSERT INTO `divisions` VALUES (320203, '南长区', 3, 320200, 31.57000, 120.30000, 0);
INSERT INTO `divisions` VALUES (320204, '北塘区', 3, 320200, 31.58000, 120.28000, 0);
INSERT INTO `divisions` VALUES (320205, '锡山区', 3, 320200, 31.60000, 120.35000, 0);
INSERT INTO `divisions` VALUES (320206, '惠山区', 3, 320200, 31.68000, 120.28000, 0);
INSERT INTO `divisions` VALUES (320211, '滨湖区', 3, 320200, 31.57000, 120.27000, 0);
INSERT INTO `divisions` VALUES (320281, '江阴市', 3, 320300, 31.90000, 120.27000, 1);
INSERT INTO `divisions` VALUES (320282, '宜兴市', 3, 320300, 31.35000, 119.82000, 1);
INSERT INTO `divisions` VALUES (320300, '徐州市', 2, 320000, 34.27000, 117.18000, 1);
INSERT INTO `divisions` VALUES (320301, '市辖区', 3, 320300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (320302, '鼓楼区', 3, 320300, 34.78000, 114.35000, 0);
INSERT INTO `divisions` VALUES (320303, '云龙区', 3, 320300, 34.25000, 117.22000, 0);
INSERT INTO `divisions` VALUES (320305, '贾汪区', 3, 320300, 34.45000, 117.45000, 0);
INSERT INTO `divisions` VALUES (320311, '泉山区', 3, 320300, 34.25000, 117.18000, 0);
INSERT INTO `divisions` VALUES (320312, '铜山区', 3, 320300, 34.26000, 117.20000, 0);
INSERT INTO `divisions` VALUES (320321, '丰县', 3, 320300, 34.70000, 116.60000, 0);
INSERT INTO `divisions` VALUES (320322, '沛县', 3, 320300, 34.73000, 116.93000, 0);
INSERT INTO `divisions` VALUES (320324, '睢宁县', 3, 320300, 33.90000, 117.95000, 0);
INSERT INTO `divisions` VALUES (320381, '新沂市', 3, 320400, 34.38000, 118.35000, 1);
INSERT INTO `divisions` VALUES (320382, '邳州市', 3, 320400, 34.32000, 117.95000, 1);
INSERT INTO `divisions` VALUES (320400, '常州市', 2, 320000, 31.78000, 119.95000, 1);
INSERT INTO `divisions` VALUES (320401, '市辖区', 3, 320400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (320402, '天宁区', 3, 320400, 31.75000, 119.93000, 0);
INSERT INTO `divisions` VALUES (320404, '钟楼区', 3, 320400, 31.78000, 119.93000, 0);
INSERT INTO `divisions` VALUES (320405, '戚墅堰区', 3, 320400, 31.73000, 120.05000, 0);
INSERT INTO `divisions` VALUES (320411, '新北区', 3, 320400, 31.83000, 119.97000, 0);
INSERT INTO `divisions` VALUES (320412, '武进区', 3, 320400, 31.72000, 119.93000, 0);
INSERT INTO `divisions` VALUES (320481, '溧阳市', 3, 320500, 31.42000, 119.48000, 1);
INSERT INTO `divisions` VALUES (320482, '金坛市', 3, 320500, 31.75000, 119.57000, 1);
INSERT INTO `divisions` VALUES (320500, '苏州市', 2, 320000, 31.30000, 120.58000, 1);
INSERT INTO `divisions` VALUES (320501, '市辖区', 3, 320500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (320505, '虎丘区', 3, 320500, 31.30000, 120.57000, 0);
INSERT INTO `divisions` VALUES (320506, '吴中区', 3, 320500, 31.27000, 120.63000, 0);
INSERT INTO `divisions` VALUES (320507, '相城区', 3, 320500, 31.37000, 120.63000, 0);
INSERT INTO `divisions` VALUES (320508, '姑苏区', 3, 320500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (320509, '吴江区', 3, 320500, 31.16000, 120.63000, 0);
INSERT INTO `divisions` VALUES (320581, '常熟市', 3, 320600, 31.65000, 120.75000, 1);
INSERT INTO `divisions` VALUES (320582, '张家港市', 3, 320600, 31.87000, 120.55000, 1);
INSERT INTO `divisions` VALUES (320583, '昆山市', 3, 320600, 31.38000, 120.98000, 1);
INSERT INTO `divisions` VALUES (320585, '太仓市', 3, 320600, 31.45000, 121.10000, 1);
INSERT INTO `divisions` VALUES (320600, '南通市', 2, 320000, 31.98000, 120.88000, 1);
INSERT INTO `divisions` VALUES (320601, '市辖区', 3, 320600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (320602, '崇川区', 3, 320600, 32.00000, 120.85000, 0);
INSERT INTO `divisions` VALUES (320611, '港闸区', 3, 320600, 32.03000, 120.80000, 0);
INSERT INTO `divisions` VALUES (320612, '通州区', 3, 320600, 39.92000, 116.65000, 0);
INSERT INTO `divisions` VALUES (320621, '海安县', 3, 320600, 32.55000, 120.45000, 0);
INSERT INTO `divisions` VALUES (320623, '如东县', 3, 320600, 32.32000, 121.18000, 0);
INSERT INTO `divisions` VALUES (320681, '启东市', 3, 320700, 31.82000, 121.65000, 1);
INSERT INTO `divisions` VALUES (320682, '如皋市', 3, 320700, 32.40000, 120.57000, 1);
INSERT INTO `divisions` VALUES (320684, '海门市', 3, 320700, 31.90000, 121.17000, 1);
INSERT INTO `divisions` VALUES (320700, '连云港市', 2, 320000, 34.60000, 119.22000, 1);
INSERT INTO `divisions` VALUES (320701, '市辖区', 3, 320700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (320703, '连云区', 3, 320700, 34.75000, 119.37000, 0);
INSERT INTO `divisions` VALUES (320705, '新浦区', 3, 320700, 34.60000, 119.17000, 0);
INSERT INTO `divisions` VALUES (320706, '海州区', 3, 320700, 34.57000, 119.12000, 0);
INSERT INTO `divisions` VALUES (320721, '赣榆县', 3, 320700, 34.83000, 119.12000, 0);
INSERT INTO `divisions` VALUES (320722, '东海县', 3, 320700, 34.53000, 118.77000, 0);
INSERT INTO `divisions` VALUES (320723, '灌云县', 3, 320700, 34.30000, 119.25000, 0);
INSERT INTO `divisions` VALUES (320724, '灌南县', 3, 320700, 34.08000, 119.35000, 0);
INSERT INTO `divisions` VALUES (320800, '淮安市', 2, 320000, 33.62000, 119.02000, 1);
INSERT INTO `divisions` VALUES (320801, '市辖区', 3, 320800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (320802, '清河区', 3, 320800, 33.60000, 119.02000, 0);
INSERT INTO `divisions` VALUES (320803, '淮安区', 3, 320800, 33.50000, 119.15000, 0);
INSERT INTO `divisions` VALUES (320804, '淮阴区', 3, 320800, 33.63000, 119.03000, 0);
INSERT INTO `divisions` VALUES (320811, '清浦区', 3, 320800, 33.58000, 119.03000, 0);
INSERT INTO `divisions` VALUES (320826, '涟水县', 3, 320800, 33.78000, 119.27000, 0);
INSERT INTO `divisions` VALUES (320829, '洪泽县', 3, 320800, 33.30000, 118.83000, 0);
INSERT INTO `divisions` VALUES (320830, '盱眙县', 3, 320800, 33.00000, 118.48000, 0);
INSERT INTO `divisions` VALUES (320831, '金湖县', 3, 320800, 33.02000, 119.02000, 0);
INSERT INTO `divisions` VALUES (320900, '盐城市', 2, 320000, 33.35000, 120.15000, 1);
INSERT INTO `divisions` VALUES (320901, '市辖区', 3, 320900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (320902, '亭湖区', 3, 320900, 33.40000, 120.13000, 0);
INSERT INTO `divisions` VALUES (320903, '盐都区', 3, 320900, 33.33000, 120.15000, 0);
INSERT INTO `divisions` VALUES (320921, '响水县', 3, 320900, 34.20000, 119.57000, 0);
INSERT INTO `divisions` VALUES (320922, '滨海县', 3, 320900, 33.98000, 119.83000, 0);
INSERT INTO `divisions` VALUES (320923, '阜宁县', 3, 320900, 33.78000, 119.80000, 0);
INSERT INTO `divisions` VALUES (320924, '射阳县', 3, 320900, 33.78000, 120.25000, 0);
INSERT INTO `divisions` VALUES (320925, '建湖县', 3, 320900, 33.47000, 119.80000, 0);
INSERT INTO `divisions` VALUES (320981, '东台市', 3, 321000, 32.85000, 120.30000, 1);
INSERT INTO `divisions` VALUES (320982, '大丰市', 3, 321000, 33.20000, 120.47000, 1);
INSERT INTO `divisions` VALUES (321000, '扬州市', 2, 320000, 32.40000, 119.40000, 1);
INSERT INTO `divisions` VALUES (321001, '市辖区', 3, 321000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (321002, '广陵区', 3, 321000, 32.38000, 119.43000, 0);
INSERT INTO `divisions` VALUES (321003, '邗江区', 3, 321000, 32.38000, 119.40000, 0);
INSERT INTO `divisions` VALUES (321012, '江都区', 3, 321000, 119.55000, 32.43000, 0);
INSERT INTO `divisions` VALUES (321023, '宝应县', 3, 321000, 33.23000, 119.30000, 0);
INSERT INTO `divisions` VALUES (321081, '仪征市', 3, 321100, 32.27000, 119.18000, 1);
INSERT INTO `divisions` VALUES (321084, '高邮市', 3, 321100, 32.78000, 119.43000, 1);
INSERT INTO `divisions` VALUES (321100, '镇江市', 2, 320000, 32.20000, 119.45000, 1);
INSERT INTO `divisions` VALUES (321101, '市辖区', 3, 321100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (321102, '京口区', 3, 321100, 32.20000, 119.47000, 0);
INSERT INTO `divisions` VALUES (321111, '润州区', 3, 321100, 32.20000, 119.40000, 0);
INSERT INTO `divisions` VALUES (321112, '丹徒区', 3, 321100, 32.13000, 119.45000, 0);
INSERT INTO `divisions` VALUES (321181, '丹阳市', 3, 321200, 32.00000, 119.57000, 1);
INSERT INTO `divisions` VALUES (321182, '扬中市', 3, 321200, 32.23000, 119.82000, 1);
INSERT INTO `divisions` VALUES (321183, '句容市', 3, 321200, 31.95000, 119.17000, 1);
INSERT INTO `divisions` VALUES (321200, '泰州市', 2, 320000, 32.45000, 119.92000, 1);
INSERT INTO `divisions` VALUES (321201, '市辖区', 3, 321200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (321202, '海陵区', 3, 321200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (321203, '高港区', 3, 321200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (321281, '兴化市', 3, 321300, 32.92000, 119.85000, 1);
INSERT INTO `divisions` VALUES (321282, '靖江市', 3, 321300, 32.02000, 120.27000, 1);
INSERT INTO `divisions` VALUES (321283, '泰兴市', 3, 321300, 32.17000, 120.02000, 1);
INSERT INTO `divisions` VALUES (321284, '姜堰市', 3, 321300, 32.52000, 120.15000, 1);
INSERT INTO `divisions` VALUES (321300, '宿迁市', 2, 320000, 33.97000, 118.28000, 1);
INSERT INTO `divisions` VALUES (321301, '市辖区', 3, 321300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (321302, '宿城区', 3, 321300, 33.97000, 118.25000, 0);
INSERT INTO `divisions` VALUES (321311, '宿豫区', 3, 321300, 33.95000, 118.32000, 0);
INSERT INTO `divisions` VALUES (321322, '沭阳县', 3, 321300, 34.13000, 118.77000, 0);
INSERT INTO `divisions` VALUES (321323, '泗阳县', 3, 321300, 33.72000, 118.68000, 0);
INSERT INTO `divisions` VALUES (321324, '泗洪县', 3, 321300, 33.47000, 118.22000, 0);
INSERT INTO `divisions` VALUES (330000, '浙江省', 1, 0, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (330100, '杭州市', 2, 330000, 30.28000, 120.15000, 1);
INSERT INTO `divisions` VALUES (330101, '市辖区', 3, 330100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (330102, '上城区', 3, 330100, 30.25000, 120.17000, 0);
INSERT INTO `divisions` VALUES (330103, '下城区', 3, 330100, 30.28000, 120.17000, 0);
INSERT INTO `divisions` VALUES (330104, '江干区', 3, 330100, 30.27000, 120.20000, 0);
INSERT INTO `divisions` VALUES (330105, '拱墅区', 3, 330100, 30.32000, 120.13000, 0);
INSERT INTO `divisions` VALUES (330106, '西湖区', 3, 330100, 28.67000, 115.87000, 0);
INSERT INTO `divisions` VALUES (330108, '滨江区', 3, 330100, 30.20000, 120.20000, 0);
INSERT INTO `divisions` VALUES (330109, '萧山区', 3, 330100, 30.17000, 120.27000, 0);
INSERT INTO `divisions` VALUES (330110, '余杭区', 3, 330100, 30.42000, 120.30000, 0);
INSERT INTO `divisions` VALUES (330122, '桐庐县', 3, 330100, 29.80000, 119.67000, 0);
INSERT INTO `divisions` VALUES (330127, '淳安县', 3, 330100, 29.60000, 119.03000, 0);
INSERT INTO `divisions` VALUES (330182, '建德市', 3, 330200, 29.48000, 119.28000, 1);
INSERT INTO `divisions` VALUES (330183, '富阳市', 3, 330200, 30.05000, 119.95000, 1);
INSERT INTO `divisions` VALUES (330185, '临安市', 3, 330200, 30.23000, 119.72000, 1);
INSERT INTO `divisions` VALUES (330200, '宁波市', 2, 330000, 29.88000, 121.55000, 1);
INSERT INTO `divisions` VALUES (330201, '市辖区', 3, 330200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (330203, '海曙区', 3, 330200, 29.87000, 121.55000, 0);
INSERT INTO `divisions` VALUES (330204, '江东区', 3, 330200, 29.87000, 121.57000, 0);
INSERT INTO `divisions` VALUES (330205, '江北区', 3, 330200, 29.60000, 106.57000, 0);
INSERT INTO `divisions` VALUES (330206, '北仑区', 3, 330200, 29.93000, 121.85000, 0);
INSERT INTO `divisions` VALUES (330211, '镇海区', 3, 330200, 29.95000, 121.72000, 0);
INSERT INTO `divisions` VALUES (330212, '鄞州区', 3, 330200, 29.83000, 121.53000, 0);
INSERT INTO `divisions` VALUES (330225, '象山县', 3, 330200, 29.48000, 121.87000, 0);
INSERT INTO `divisions` VALUES (330226, '宁海县', 3, 330200, 29.28000, 121.43000, 0);
INSERT INTO `divisions` VALUES (330281, '余姚市', 3, 330300, 30.03000, 121.15000, 1);
INSERT INTO `divisions` VALUES (330282, '慈溪市', 3, 330300, 30.17000, 121.23000, 1);
INSERT INTO `divisions` VALUES (330283, '奉化市', 3, 330300, 29.65000, 121.40000, 1);
INSERT INTO `divisions` VALUES (330300, '温州市', 2, 330000, 28.00000, 120.70000, 1);
INSERT INTO `divisions` VALUES (330301, '市辖区', 3, 330300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (330302, '鹿城区', 3, 330300, 28.02000, 120.65000, 0);
INSERT INTO `divisions` VALUES (330303, '龙湾区', 3, 330300, 27.93000, 120.82000, 0);
INSERT INTO `divisions` VALUES (330304, '瓯海区', 3, 330300, 28.01000, 120.65000, 0);
INSERT INTO `divisions` VALUES (330322, '洞头县', 3, 330300, 27.83000, 121.15000, 0);
INSERT INTO `divisions` VALUES (330324, '永嘉县', 3, 330300, 28.15000, 120.68000, 0);
INSERT INTO `divisions` VALUES (330326, '平阳县', 3, 330300, 27.67000, 120.57000, 0);
INSERT INTO `divisions` VALUES (330327, '苍南县', 3, 330300, 27.50000, 120.40000, 0);
INSERT INTO `divisions` VALUES (330328, '文成县', 3, 330300, 27.78000, 120.08000, 0);
INSERT INTO `divisions` VALUES (330329, '泰顺县', 3, 330300, 27.57000, 119.72000, 0);
INSERT INTO `divisions` VALUES (330381, '瑞安市', 3, 330400, 27.78000, 120.63000, 1);
INSERT INTO `divisions` VALUES (330382, '乐清市', 3, 330400, 28.13000, 120.95000, 1);
INSERT INTO `divisions` VALUES (330400, '嘉兴市', 2, 330000, 30.75000, 120.75000, 1);
INSERT INTO `divisions` VALUES (330401, '市辖区', 3, 330400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (330402, '南湖区', 3, 330400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (330411, '秀洲区', 3, 330400, 30.77000, 120.70000, 0);
INSERT INTO `divisions` VALUES (330421, '嘉善县', 3, 330400, 30.85000, 120.92000, 0);
INSERT INTO `divisions` VALUES (330424, '海盐县', 3, 330400, 30.53000, 120.95000, 0);
INSERT INTO `divisions` VALUES (330481, '海宁市', 3, 330500, 30.53000, 120.68000, 1);
INSERT INTO `divisions` VALUES (330482, '平湖市', 3, 330500, 30.70000, 121.02000, 1);
INSERT INTO `divisions` VALUES (330483, '桐乡市', 3, 330500, 30.63000, 120.57000, 1);
INSERT INTO `divisions` VALUES (330500, '湖州市', 2, 330000, 30.90000, 120.08000, 1);
INSERT INTO `divisions` VALUES (330501, '市辖区', 3, 330500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (330502, '吴兴区', 3, 330500, 30.87000, 120.12000, 0);
INSERT INTO `divisions` VALUES (330503, '南浔区', 3, 330500, 30.88000, 120.43000, 0);
INSERT INTO `divisions` VALUES (330521, '德清县', 3, 330500, 30.53000, 119.97000, 0);
INSERT INTO `divisions` VALUES (330522, '长兴县', 3, 330500, 31.02000, 119.90000, 0);
INSERT INTO `divisions` VALUES (330523, '安吉县', 3, 330500, 30.63000, 119.68000, 0);
INSERT INTO `divisions` VALUES (330600, '绍兴市', 2, 330000, 30.00000, 120.57000, 1);
INSERT INTO `divisions` VALUES (330601, '市辖区', 3, 330600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (330602, '越城区', 3, 330600, 30.00000, 120.57000, 0);
INSERT INTO `divisions` VALUES (330621, '绍兴县', 3, 330600, 30.08000, 120.47000, 0);
INSERT INTO `divisions` VALUES (330624, '新昌县', 3, 330600, 29.50000, 120.90000, 0);
INSERT INTO `divisions` VALUES (330681, '诸暨市', 3, 330700, 29.72000, 120.23000, 1);
INSERT INTO `divisions` VALUES (330682, '上虞市', 3, 330700, 30.03000, 120.87000, 1);
INSERT INTO `divisions` VALUES (330683, '嵊州市', 3, 330700, 29.58000, 120.82000, 1);
INSERT INTO `divisions` VALUES (330700, '金华市', 2, 330000, 29.08000, 119.65000, 1);
INSERT INTO `divisions` VALUES (330701, '市辖区', 3, 330700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (330702, '婺城区', 3, 330700, 29.08000, 119.65000, 0);
INSERT INTO `divisions` VALUES (330703, '金东区', 3, 330700, 29.08000, 119.70000, 0);
INSERT INTO `divisions` VALUES (330723, '武义县', 3, 330700, 28.90000, 119.82000, 0);
INSERT INTO `divisions` VALUES (330726, '浦江县', 3, 330700, 29.45000, 119.88000, 0);
INSERT INTO `divisions` VALUES (330727, '磐安县', 3, 330700, 29.05000, 120.43000, 0);
INSERT INTO `divisions` VALUES (330781, '兰溪市', 3, 330800, 29.22000, 119.45000, 1);
INSERT INTO `divisions` VALUES (330782, '义乌市', 3, 330800, 29.30000, 120.07000, 1);
INSERT INTO `divisions` VALUES (330783, '东阳市', 3, 330800, 29.28000, 120.23000, 1);
INSERT INTO `divisions` VALUES (330784, '永康市', 3, 330800, 28.90000, 120.03000, 1);
INSERT INTO `divisions` VALUES (330800, '衢州市', 2, 330000, 28.93000, 118.87000, 1);
INSERT INTO `divisions` VALUES (330801, '市辖区', 3, 330800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (330802, '柯城区', 3, 330800, 28.93000, 118.87000, 0);
INSERT INTO `divisions` VALUES (330803, '衢江区', 3, 330800, 28.98000, 118.93000, 0);
INSERT INTO `divisions` VALUES (330822, '常山县', 3, 330800, 28.90000, 118.52000, 0);
INSERT INTO `divisions` VALUES (330824, '开化县', 3, 330800, 29.13000, 118.42000, 0);
INSERT INTO `divisions` VALUES (330825, '龙游县', 3, 330800, 29.03000, 119.17000, 0);
INSERT INTO `divisions` VALUES (330881, '江山市', 3, 330900, 28.75000, 118.62000, 1);
INSERT INTO `divisions` VALUES (330900, '舟山市', 2, 330000, 30.00000, 122.20000, 1);
INSERT INTO `divisions` VALUES (330901, '市辖区', 3, 330900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (330902, '定海区', 3, 330900, 30.02000, 122.10000, 0);
INSERT INTO `divisions` VALUES (330903, '普陀区', 3, 330900, 29.95000, 122.30000, 0);
INSERT INTO `divisions` VALUES (330921, '岱山县', 3, 330900, 30.25000, 122.20000, 0);
INSERT INTO `divisions` VALUES (330922, '嵊泗县', 3, 330900, 30.73000, 122.45000, 0);
INSERT INTO `divisions` VALUES (331000, '台州市', 2, 330000, 28.68000, 121.43000, 1);
INSERT INTO `divisions` VALUES (331001, '市辖区', 3, 331000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (331002, '椒江区', 3, 331000, 28.68000, 121.43000, 0);
INSERT INTO `divisions` VALUES (331003, '黄岩区', 3, 331000, 28.65000, 121.27000, 0);
INSERT INTO `divisions` VALUES (331004, '路桥区', 3, 331000, 28.58000, 121.38000, 0);
INSERT INTO `divisions` VALUES (331021, '玉环县', 3, 331000, 28.13000, 121.23000, 0);
INSERT INTO `divisions` VALUES (331022, '三门县', 3, 331000, 29.12000, 121.38000, 0);
INSERT INTO `divisions` VALUES (331023, '天台县', 3, 331000, 29.13000, 121.03000, 0);
INSERT INTO `divisions` VALUES (331024, '仙居县', 3, 331000, 28.87000, 120.73000, 0);
INSERT INTO `divisions` VALUES (331081, '温岭市', 3, 331100, 28.37000, 121.37000, 1);
INSERT INTO `divisions` VALUES (331082, '临海市', 3, 331100, 28.85000, 121.12000, 1);
INSERT INTO `divisions` VALUES (331100, '丽水市', 2, 330000, 28.45000, 119.92000, 1);
INSERT INTO `divisions` VALUES (331101, '市辖区', 3, 331100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (331102, '莲都区', 3, 331100, 28.45000, 119.92000, 0);
INSERT INTO `divisions` VALUES (331121, '青田县', 3, 331100, 28.15000, 120.28000, 0);
INSERT INTO `divisions` VALUES (331122, '缙云县', 3, 331100, 28.65000, 120.07000, 0);
INSERT INTO `divisions` VALUES (331123, '遂昌县', 3, 331100, 28.60000, 119.27000, 0);
INSERT INTO `divisions` VALUES (331124, '松阳县', 3, 331100, 28.45000, 119.48000, 0);
INSERT INTO `divisions` VALUES (331125, '云和县', 3, 331100, 28.12000, 119.57000, 0);
INSERT INTO `divisions` VALUES (331126, '庆元县', 3, 331100, 27.62000, 119.05000, 0);
INSERT INTO `divisions` VALUES (331127, '景宁畲族自治县', 3, 331100, 27.98000, 119.63000, 0);
INSERT INTO `divisions` VALUES (331181, '龙泉市', 3, 331200, 28.08000, 119.13000, 1);
INSERT INTO `divisions` VALUES (340000, '安徽省', 1, 0, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (340100, '合肥市', 2, 340000, 31.83000, 117.25000, 1);
INSERT INTO `divisions` VALUES (340101, '市辖区', 3, 340100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (340102, '瑶海区', 3, 340100, 31.87000, 117.30000, 0);
INSERT INTO `divisions` VALUES (340103, '庐阳区', 3, 340100, 31.88000, 117.25000, 0);
INSERT INTO `divisions` VALUES (340104, '蜀山区', 3, 340100, 31.85000, 117.27000, 0);
INSERT INTO `divisions` VALUES (340111, '包河区', 3, 340100, 31.80000, 117.30000, 0);
INSERT INTO `divisions` VALUES (340121, '长丰县', 3, 340100, 32.48000, 117.17000, 0);
INSERT INTO `divisions` VALUES (340122, '肥东县', 3, 340100, 31.88000, 117.47000, 0);
INSERT INTO `divisions` VALUES (340123, '肥西县', 3, 340100, 31.72000, 117.17000, 0);
INSERT INTO `divisions` VALUES (340124, '庐江县', 3, 340100, 31.25000, 117.28000, 0);
INSERT INTO `divisions` VALUES (340181, '巢湖市', 3, 340200, 31.60000, 117.87000, 1);
INSERT INTO `divisions` VALUES (340200, '芜湖市', 2, 340000, 31.33000, 118.38000, 1);
INSERT INTO `divisions` VALUES (340201, '市辖区', 3, 340200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (340202, '镜湖区', 3, 340200, 31.35000, 118.37000, 0);
INSERT INTO `divisions` VALUES (340203, '弋江区', 3, 340200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (340207, '鸠江区', 3, 340200, 31.37000, 118.38000, 0);
INSERT INTO `divisions` VALUES (340208, '三山区', 3, 340200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (340221, '芜湖县', 3, 340200, 31.15000, 118.57000, 0);
INSERT INTO `divisions` VALUES (340222, '繁昌县', 3, 340200, 31.08000, 118.20000, 0);
INSERT INTO `divisions` VALUES (340223, '南陵县', 3, 340200, 30.92000, 118.33000, 0);
INSERT INTO `divisions` VALUES (340225, '无为县', 3, 340200, 31.30000, 117.92000, 0);
INSERT INTO `divisions` VALUES (340300, '蚌埠市', 2, 340000, 32.92000, 117.38000, 1);
INSERT INTO `divisions` VALUES (340301, '市辖区', 3, 340300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (340302, '龙子湖区', 3, 340300, 32.95000, 117.38000, 0);
INSERT INTO `divisions` VALUES (340303, '蚌山区', 3, 340300, 32.95000, 117.35000, 0);
INSERT INTO `divisions` VALUES (340304, '禹会区', 3, 340300, 32.93000, 117.33000, 0);
INSERT INTO `divisions` VALUES (340311, '淮上区', 3, 340300, 32.97000, 117.35000, 0);
INSERT INTO `divisions` VALUES (340321, '怀远县', 3, 340300, 32.97000, 117.18000, 0);
INSERT INTO `divisions` VALUES (340322, '五河县', 3, 340300, 33.15000, 117.88000, 0);
INSERT INTO `divisions` VALUES (340323, '固镇县', 3, 340300, 33.32000, 117.32000, 0);
INSERT INTO `divisions` VALUES (340400, '淮南市', 2, 340000, 32.63000, 117.00000, 1);
INSERT INTO `divisions` VALUES (340401, '市辖区', 3, 340400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (340402, '大通区', 3, 340400, 32.63000, 117.05000, 0);
INSERT INTO `divisions` VALUES (340403, '田家庵区', 3, 340400, 32.67000, 117.00000, 0);
INSERT INTO `divisions` VALUES (340404, '谢家集区', 3, 340400, 32.60000, 116.85000, 0);
INSERT INTO `divisions` VALUES (340405, '八公山区', 3, 340400, 32.63000, 116.83000, 0);
INSERT INTO `divisions` VALUES (340406, '潘集区', 3, 340400, 32.78000, 116.82000, 0);
INSERT INTO `divisions` VALUES (340421, '凤台县', 3, 340400, 32.70000, 116.72000, 0);
INSERT INTO `divisions` VALUES (340500, '马鞍山市', 2, 340000, 31.70000, 118.50000, 1);
INSERT INTO `divisions` VALUES (340501, '市辖区', 3, 340500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (340503, '花山区', 3, 340500, 31.72000, 118.50000, 0);
INSERT INTO `divisions` VALUES (340504, '雨山区', 3, 340500, 31.68000, 118.48000, 0);
INSERT INTO `divisions` VALUES (340506, '博望区', 3, 340500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (340521, '当涂县', 3, 340500, 31.55000, 118.48000, 0);
INSERT INTO `divisions` VALUES (340522, '含山县', 3, 340500, 31.72000, 118.10000, 0);
INSERT INTO `divisions` VALUES (340523, '和县', 3, 340500, 31.72000, 118.37000, 0);
INSERT INTO `divisions` VALUES (340600, '淮北市', 2, 340000, 33.95000, 116.80000, 1);
INSERT INTO `divisions` VALUES (340601, '市辖区', 3, 340600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (340602, '杜集区', 3, 340600, 34.00000, 116.82000, 0);
INSERT INTO `divisions` VALUES (340603, '相山区', 3, 340600, 33.95000, 116.80000, 0);
INSERT INTO `divisions` VALUES (340604, '烈山区', 3, 340600, 33.90000, 116.80000, 0);
INSERT INTO `divisions` VALUES (340621, '濉溪县', 3, 340600, 33.92000, 116.77000, 0);
INSERT INTO `divisions` VALUES (340700, '铜陵市', 2, 340000, 30.93000, 117.82000, 1);
INSERT INTO `divisions` VALUES (340701, '市辖区', 3, 340700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (340702, '铜官山区', 3, 340700, 30.93000, 117.82000, 0);
INSERT INTO `divisions` VALUES (340703, '狮子山区', 3, 340700, 30.95000, 117.85000, 0);
INSERT INTO `divisions` VALUES (340711, '郊区', 3, 340700, 30.92000, 117.78000, 0);
INSERT INTO `divisions` VALUES (340721, '铜陵县', 3, 340700, 30.95000, 117.78000, 0);
INSERT INTO `divisions` VALUES (340800, '安庆市', 2, 340000, 30.53000, 117.05000, 1);
INSERT INTO `divisions` VALUES (340801, '市辖区', 3, 340800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (340802, '迎江区', 3, 340800, 30.50000, 117.05000, 0);
INSERT INTO `divisions` VALUES (340803, '大观区', 3, 340800, 30.52000, 117.03000, 0);
INSERT INTO `divisions` VALUES (340811, '宜秀区', 3, 340800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (340822, '怀宁县', 3, 340800, 30.72000, 116.83000, 0);
INSERT INTO `divisions` VALUES (340823, '枞阳县', 3, 340800, 30.70000, 117.20000, 0);
INSERT INTO `divisions` VALUES (340824, '潜山县', 3, 340800, 30.63000, 116.57000, 0);
INSERT INTO `divisions` VALUES (340825, '太湖县', 3, 340800, 30.43000, 116.27000, 0);
INSERT INTO `divisions` VALUES (340826, '宿松县', 3, 340800, 30.15000, 116.12000, 0);
INSERT INTO `divisions` VALUES (340827, '望江县', 3, 340800, 30.13000, 116.68000, 0);
INSERT INTO `divisions` VALUES (340828, '岳西县', 3, 340800, 30.85000, 116.35000, 0);
INSERT INTO `divisions` VALUES (340881, '桐城市', 3, 340900, 31.05000, 116.95000, 1);
INSERT INTO `divisions` VALUES (341000, '黄山市', 2, 340000, 29.72000, 118.33000, 1);
INSERT INTO `divisions` VALUES (341001, '市辖区', 3, 341000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (341002, '屯溪区', 3, 341000, 29.72000, 118.33000, 0);
INSERT INTO `divisions` VALUES (341003, '黄山区', 3, 341000, 30.30000, 118.13000, 0);
INSERT INTO `divisions` VALUES (341004, '徽州区', 3, 341000, 29.82000, 118.33000, 0);
INSERT INTO `divisions` VALUES (341021, '歙县', 3, 341000, 29.87000, 118.43000, 0);
INSERT INTO `divisions` VALUES (341022, '休宁县', 3, 341000, 29.78000, 118.18000, 0);
INSERT INTO `divisions` VALUES (341023, '黟县', 3, 341000, 29.93000, 117.93000, 0);
INSERT INTO `divisions` VALUES (341024, '祁门县', 3, 341000, 29.87000, 117.72000, 0);
INSERT INTO `divisions` VALUES (341100, '滁州市', 2, 340000, 32.30000, 118.32000, 1);
INSERT INTO `divisions` VALUES (341101, '市辖区', 3, 341100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (341102, '琅琊区', 3, 341100, 32.30000, 118.30000, 0);
INSERT INTO `divisions` VALUES (341103, '南谯区', 3, 341100, 32.32000, 118.30000, 0);
INSERT INTO `divisions` VALUES (341122, '来安县', 3, 341100, 32.45000, 118.43000, 0);
INSERT INTO `divisions` VALUES (341124, '全椒县', 3, 341100, 32.10000, 118.27000, 0);
INSERT INTO `divisions` VALUES (341125, '定远县', 3, 341100, 32.53000, 117.67000, 0);
INSERT INTO `divisions` VALUES (341126, '凤阳县', 3, 341100, 32.87000, 117.57000, 0);
INSERT INTO `divisions` VALUES (341181, '天长市', 3, 341200, 32.70000, 119.00000, 1);
INSERT INTO `divisions` VALUES (341182, '明光市', 3, 341200, 32.78000, 117.98000, 1);
INSERT INTO `divisions` VALUES (341200, '阜阳市', 2, 340000, 32.90000, 115.82000, 1);
INSERT INTO `divisions` VALUES (341201, '市辖区', 3, 341200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (341202, '颍州区', 3, 341200, 32.88000, 115.80000, 0);
INSERT INTO `divisions` VALUES (341203, '颍东区', 3, 341200, 32.92000, 115.85000, 0);
INSERT INTO `divisions` VALUES (341204, '颍泉区', 3, 341200, 32.93000, 115.80000, 0);
INSERT INTO `divisions` VALUES (341221, '临泉县', 3, 341200, 33.07000, 115.25000, 0);
INSERT INTO `divisions` VALUES (341222, '太和县', 3, 341200, 33.17000, 115.62000, 0);
INSERT INTO `divisions` VALUES (341225, '阜南县', 3, 341200, 32.63000, 115.58000, 0);
INSERT INTO `divisions` VALUES (341226, '颍上县', 3, 341200, 32.63000, 116.27000, 0);
INSERT INTO `divisions` VALUES (341282, '界首市', 3, 341300, 33.24000, 115.34000, 1);
INSERT INTO `divisions` VALUES (341300, '宿州市', 2, 340000, 33.63000, 116.98000, 1);
INSERT INTO `divisions` VALUES (341301, '市辖区', 3, 341300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (341302, '埇桥区', 3, 341300, 33.63000, 116.97000, 0);
INSERT INTO `divisions` VALUES (341321, '砀山县', 3, 341300, 34.42000, 116.35000, 0);
INSERT INTO `divisions` VALUES (341322, '萧县', 3, 341300, 34.18000, 116.93000, 0);
INSERT INTO `divisions` VALUES (341323, '灵璧县', 3, 341300, 33.55000, 117.55000, 0);
INSERT INTO `divisions` VALUES (341324, '泗县', 3, 341300, 33.48000, 117.88000, 0);
INSERT INTO `divisions` VALUES (341500, '六安市', 2, 340000, 31.77000, 116.50000, 1);
INSERT INTO `divisions` VALUES (341501, '市辖区', 3, 341500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (341502, '金安区', 3, 341500, 31.77000, 116.50000, 0);
INSERT INTO `divisions` VALUES (341503, '裕安区', 3, 341500, 31.77000, 116.48000, 0);
INSERT INTO `divisions` VALUES (341521, '寿县', 3, 341500, 32.58000, 116.78000, 0);
INSERT INTO `divisions` VALUES (341522, '霍邱县', 3, 341500, 32.33000, 116.27000, 0);
INSERT INTO `divisions` VALUES (341523, '舒城县', 3, 341500, 31.47000, 116.93000, 0);
INSERT INTO `divisions` VALUES (341524, '金寨县', 3, 341500, 31.72000, 115.92000, 0);
INSERT INTO `divisions` VALUES (341525, '霍山县', 3, 341500, 31.40000, 116.33000, 0);
INSERT INTO `divisions` VALUES (341600, '亳州市', 2, 340000, 33.85000, 115.78000, 1);
INSERT INTO `divisions` VALUES (341601, '市辖区', 3, 341600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (341602, '谯城区', 3, 341600, 33.88000, 115.77000, 0);
INSERT INTO `divisions` VALUES (341621, '涡阳县', 3, 341600, 33.52000, 116.22000, 0);
INSERT INTO `divisions` VALUES (341622, '蒙城县', 3, 341600, 33.27000, 116.57000, 0);
INSERT INTO `divisions` VALUES (341623, '利辛县', 3, 341600, 33.15000, 116.20000, 0);
INSERT INTO `divisions` VALUES (341700, '池州市', 2, 340000, 30.67000, 117.48000, 1);
INSERT INTO `divisions` VALUES (341701, '市辖区', 3, 341700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (341702, '贵池区', 3, 341700, 30.65000, 117.48000, 0);
INSERT INTO `divisions` VALUES (341721, '东至县', 3, 341700, 30.10000, 117.02000, 0);
INSERT INTO `divisions` VALUES (341722, '石台县', 3, 341700, 30.22000, 117.48000, 0);
INSERT INTO `divisions` VALUES (341723, '青阳县', 3, 341700, 30.65000, 117.85000, 0);
INSERT INTO `divisions` VALUES (341800, '宣城市', 2, 340000, 30.95000, 118.75000, 1);
INSERT INTO `divisions` VALUES (341801, '市辖区', 3, 341800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (341802, '宣州区', 3, 341800, 30.95000, 118.75000, 0);
INSERT INTO `divisions` VALUES (341821, '郎溪县', 3, 341800, 31.13000, 119.17000, 0);
INSERT INTO `divisions` VALUES (341822, '广德县', 3, 341800, 30.90000, 119.42000, 0);
INSERT INTO `divisions` VALUES (341823, '泾县', 3, 341800, 30.70000, 118.40000, 0);
INSERT INTO `divisions` VALUES (341824, '绩溪县', 3, 341800, 30.07000, 118.60000, 0);
INSERT INTO `divisions` VALUES (341825, '旌德县', 3, 341800, 30.28000, 118.53000, 0);
INSERT INTO `divisions` VALUES (341881, '宁国市', 3, 341900, 30.63000, 118.98000, 1);
INSERT INTO `divisions` VALUES (350000, '福建省', 1, 0, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (350100, '福州市', 2, 350000, 26.08000, 119.30000, 1);
INSERT INTO `divisions` VALUES (350101, '市辖区', 3, 350100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (350102, '鼓楼区', 3, 350100, 34.78000, 114.35000, 0);
INSERT INTO `divisions` VALUES (350103, '台江区', 3, 350100, 26.07000, 119.30000, 0);
INSERT INTO `divisions` VALUES (350104, '仓山区', 3, 350100, 26.05000, 119.32000, 0);
INSERT INTO `divisions` VALUES (350105, '马尾区', 3, 350100, 26.00000, 119.45000, 0);
INSERT INTO `divisions` VALUES (350111, '晋安区', 3, 350100, 26.08000, 119.32000, 0);
INSERT INTO `divisions` VALUES (350121, '闽侯县', 3, 350100, 26.15000, 119.13000, 0);
INSERT INTO `divisions` VALUES (350122, '连江县', 3, 350100, 26.20000, 119.53000, 0);
INSERT INTO `divisions` VALUES (350123, '罗源县', 3, 350100, 26.48000, 119.55000, 0);
INSERT INTO `divisions` VALUES (350124, '闽清县', 3, 350100, 26.22000, 118.85000, 0);
INSERT INTO `divisions` VALUES (350125, '永泰县', 3, 350100, 25.87000, 118.93000, 0);
INSERT INTO `divisions` VALUES (350128, '平潭县', 3, 350100, 25.52000, 119.78000, 0);
INSERT INTO `divisions` VALUES (350181, '福清市', 3, 350200, 25.72000, 119.38000, 1);
INSERT INTO `divisions` VALUES (350182, '长乐市', 3, 350200, 25.97000, 119.52000, 1);
INSERT INTO `divisions` VALUES (350200, '厦门市', 2, 350000, 24.48000, 118.08000, 1);
INSERT INTO `divisions` VALUES (350201, '市辖区', 3, 350200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (350203, '思明区', 3, 350200, 24.45000, 118.08000, 0);
INSERT INTO `divisions` VALUES (350205, '海沧区', 3, 350200, 24.47000, 117.98000, 0);
INSERT INTO `divisions` VALUES (350206, '湖里区', 3, 350200, 24.52000, 118.08000, 0);
INSERT INTO `divisions` VALUES (350211, '集美区', 3, 350200, 24.57000, 118.10000, 0);
INSERT INTO `divisions` VALUES (350212, '同安区', 3, 350200, 24.73000, 118.15000, 0);
INSERT INTO `divisions` VALUES (350213, '翔安区', 3, 350200, 24.62000, 118.23000, 0);
INSERT INTO `divisions` VALUES (350300, '莆田市', 2, 350000, 25.43000, 119.00000, 1);
INSERT INTO `divisions` VALUES (350301, '市辖区', 3, 350300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (350302, '城厢区', 3, 350300, 25.43000, 119.00000, 0);
INSERT INTO `divisions` VALUES (350303, '涵江区', 3, 350300, 25.45000, 119.10000, 0);
INSERT INTO `divisions` VALUES (350304, '荔城区', 3, 350300, 25.43000, 119.02000, 0);
INSERT INTO `divisions` VALUES (350305, '秀屿区', 3, 350300, 25.32000, 119.08000, 0);
INSERT INTO `divisions` VALUES (350322, '仙游县', 3, 350300, 25.37000, 118.68000, 0);
INSERT INTO `divisions` VALUES (350400, '三明市', 2, 350000, 26.27000, 117.62000, 1);
INSERT INTO `divisions` VALUES (350401, '市辖区', 3, 350400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (350402, '梅列区', 3, 350400, 26.27000, 117.63000, 0);
INSERT INTO `divisions` VALUES (350403, '三元区', 3, 350400, 26.23000, 117.60000, 0);
INSERT INTO `divisions` VALUES (350421, '明溪县', 3, 350400, 26.37000, 117.20000, 0);
INSERT INTO `divisions` VALUES (350423, '清流县', 3, 350400, 26.18000, 116.82000, 0);
INSERT INTO `divisions` VALUES (350424, '宁化县', 3, 350400, 26.27000, 116.65000, 0);
INSERT INTO `divisions` VALUES (350425, '大田县', 3, 350400, 25.70000, 117.85000, 0);
INSERT INTO `divisions` VALUES (350426, '尤溪县', 3, 350400, 26.17000, 118.18000, 0);
INSERT INTO `divisions` VALUES (350427, '沙县', 3, 350400, 26.40000, 117.78000, 0);
INSERT INTO `divisions` VALUES (350428, '将乐县', 3, 350400, 26.73000, 117.47000, 0);
INSERT INTO `divisions` VALUES (350429, '泰宁县', 3, 350400, 26.90000, 117.17000, 0);
INSERT INTO `divisions` VALUES (350430, '建宁县', 3, 350400, 26.83000, 116.83000, 0);
INSERT INTO `divisions` VALUES (350481, '永安市', 3, 350500, 25.98000, 117.37000, 1);
INSERT INTO `divisions` VALUES (350500, '泉州市', 2, 350000, 24.88000, 118.67000, 1);
INSERT INTO `divisions` VALUES (350501, '市辖区', 3, 350500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (350502, '鲤城区', 3, 350500, 24.92000, 118.60000, 0);
INSERT INTO `divisions` VALUES (350503, '丰泽区', 3, 350500, 24.92000, 118.60000, 0);
INSERT INTO `divisions` VALUES (350504, '洛江区', 3, 350500, 24.95000, 118.67000, 0);
INSERT INTO `divisions` VALUES (350505, '泉港区', 3, 350500, 25.12000, 118.88000, 0);
INSERT INTO `divisions` VALUES (350521, '惠安县', 3, 350500, 25.03000, 118.80000, 0);
INSERT INTO `divisions` VALUES (350524, '安溪县', 3, 350500, 25.07000, 118.18000, 0);
INSERT INTO `divisions` VALUES (350525, '永春县', 3, 350500, 25.32000, 118.30000, 0);
INSERT INTO `divisions` VALUES (350526, '德化县', 3, 350500, 25.50000, 118.23000, 0);
INSERT INTO `divisions` VALUES (350527, '金门县', 3, 350500, 24.43000, 118.32000, 0);
INSERT INTO `divisions` VALUES (350581, '石狮市', 3, 350600, 24.73000, 118.65000, 1);
INSERT INTO `divisions` VALUES (350582, '晋江市', 3, 350600, 24.82000, 118.58000, 1);
INSERT INTO `divisions` VALUES (350583, '南安市', 3, 350600, 24.97000, 118.38000, 1);
INSERT INTO `divisions` VALUES (350600, '漳州市', 2, 350000, 24.52000, 117.65000, 1);
INSERT INTO `divisions` VALUES (350601, '市辖区', 3, 350600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (350602, '芗城区', 3, 350600, 24.52000, 117.65000, 0);
INSERT INTO `divisions` VALUES (350603, '龙文区', 3, 350600, 24.52000, 117.72000, 0);
INSERT INTO `divisions` VALUES (350622, '云霄县', 3, 350600, 23.95000, 117.33000, 0);
INSERT INTO `divisions` VALUES (350623, '漳浦县', 3, 350600, 24.13000, 117.62000, 0);
INSERT INTO `divisions` VALUES (350624, '诏安县', 3, 350600, 23.72000, 117.18000, 0);
INSERT INTO `divisions` VALUES (350625, '长泰县', 3, 350600, 24.62000, 117.75000, 0);
INSERT INTO `divisions` VALUES (350626, '东山县', 3, 350600, 23.70000, 117.43000, 0);
INSERT INTO `divisions` VALUES (350627, '南靖县', 3, 350600, 24.52000, 117.37000, 0);
INSERT INTO `divisions` VALUES (350628, '平和县', 3, 350600, 24.37000, 117.30000, 0);
INSERT INTO `divisions` VALUES (350629, '华安县', 3, 350600, 25.02000, 117.53000, 0);
INSERT INTO `divisions` VALUES (350681, '龙海市', 3, 350700, 24.45000, 117.82000, 1);
INSERT INTO `divisions` VALUES (350700, '南平市', 2, 350000, 26.65000, 118.17000, 1);
INSERT INTO `divisions` VALUES (350701, '市辖区', 3, 350700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (350702, '延平区', 3, 350700, 26.65000, 118.17000, 0);
INSERT INTO `divisions` VALUES (350721, '顺昌县', 3, 350700, 26.80000, 117.80000, 0);
INSERT INTO `divisions` VALUES (350722, '浦城县', 3, 350700, 27.92000, 118.53000, 0);
INSERT INTO `divisions` VALUES (350723, '光泽县', 3, 350700, 27.55000, 117.33000, 0);
INSERT INTO `divisions` VALUES (350724, '松溪县', 3, 350700, 27.53000, 118.78000, 0);
INSERT INTO `divisions` VALUES (350725, '政和县', 3, 350700, 27.37000, 118.85000, 0);
INSERT INTO `divisions` VALUES (350781, '邵武市', 3, 350800, 27.37000, 117.48000, 1);
INSERT INTO `divisions` VALUES (350782, '武夷山市', 3, 350800, 27.77000, 118.03000, 1);
INSERT INTO `divisions` VALUES (350783, '建瓯市', 3, 350800, 27.03000, 118.32000, 1);
INSERT INTO `divisions` VALUES (350784, '建阳市', 3, 350800, 27.33000, 118.12000, 1);
INSERT INTO `divisions` VALUES (350800, '龙岩市', 2, 350000, 25.10000, 117.03000, 1);
INSERT INTO `divisions` VALUES (350801, '市辖区', 3, 350800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (350802, '新罗区', 3, 350800, 25.10000, 117.03000, 0);
INSERT INTO `divisions` VALUES (350821, '长汀县', 3, 350800, 25.83000, 116.35000, 0);
INSERT INTO `divisions` VALUES (350822, '永定县', 3, 350800, 24.72000, 116.73000, 0);
INSERT INTO `divisions` VALUES (350823, '上杭县', 3, 350800, 25.05000, 116.42000, 0);
INSERT INTO `divisions` VALUES (350824, '武平县', 3, 350800, 25.10000, 116.10000, 0);
INSERT INTO `divisions` VALUES (350825, '连城县', 3, 350800, 25.72000, 116.75000, 0);
INSERT INTO `divisions` VALUES (350881, '漳平市', 3, 350900, 25.30000, 117.42000, 1);
INSERT INTO `divisions` VALUES (350900, '宁德市', 2, 350000, 26.67000, 119.52000, 1);
INSERT INTO `divisions` VALUES (350901, '市辖区', 3, 350900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (350902, '蕉城区', 3, 350900, 26.67000, 119.52000, 0);
INSERT INTO `divisions` VALUES (350921, '霞浦县', 3, 350900, 26.88000, 120.00000, 0);
INSERT INTO `divisions` VALUES (350922, '古田县', 3, 350900, 26.58000, 118.75000, 0);
INSERT INTO `divisions` VALUES (350923, '屏南县', 3, 350900, 26.92000, 118.98000, 0);
INSERT INTO `divisions` VALUES (350924, '寿宁县', 3, 350900, 27.47000, 119.50000, 0);
INSERT INTO `divisions` VALUES (350925, '周宁县', 3, 350900, 27.12000, 119.33000, 0);
INSERT INTO `divisions` VALUES (350926, '柘荣县', 3, 350900, 27.23000, 119.90000, 0);
INSERT INTO `divisions` VALUES (350981, '福安市', 3, 351000, 27.08000, 119.65000, 1);
INSERT INTO `divisions` VALUES (350982, '福鼎市', 3, 351000, 27.33000, 120.22000, 1);
INSERT INTO `divisions` VALUES (360000, '江西省', 1, 0, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (360100, '南昌市', 2, 360000, 28.68000, 115.85000, 1);
INSERT INTO `divisions` VALUES (360101, '市辖区', 3, 360100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (360102, '东湖区', 3, 360100, 28.68000, 115.90000, 0);
INSERT INTO `divisions` VALUES (360103, '西湖区', 3, 360100, 28.67000, 115.87000, 0);
INSERT INTO `divisions` VALUES (360104, '青云谱区', 3, 360100, 28.63000, 115.92000, 0);
INSERT INTO `divisions` VALUES (360105, '湾里区', 3, 360100, 28.72000, 115.73000, 0);
INSERT INTO `divisions` VALUES (360111, '青山湖区', 3, 360100, 28.68000, 115.95000, 0);
INSERT INTO `divisions` VALUES (360121, '南昌县', 3, 360100, 28.55000, 115.93000, 0);
INSERT INTO `divisions` VALUES (360122, '新建县', 3, 360100, 28.70000, 115.82000, 0);
INSERT INTO `divisions` VALUES (360123, '安义县', 3, 360100, 28.85000, 115.55000, 0);
INSERT INTO `divisions` VALUES (360124, '进贤县', 3, 360100, 28.37000, 116.27000, 0);
INSERT INTO `divisions` VALUES (360200, '景德镇市', 2, 360000, 29.27000, 117.17000, 1);
INSERT INTO `divisions` VALUES (360201, '市辖区', 3, 360200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (360202, '昌江区', 3, 360200, 29.27000, 117.17000, 0);
INSERT INTO `divisions` VALUES (360203, '珠山区', 3, 360200, 29.30000, 117.20000, 0);
INSERT INTO `divisions` VALUES (360222, '浮梁县', 3, 360200, 29.37000, 117.25000, 0);
INSERT INTO `divisions` VALUES (360281, '乐平市', 3, 360300, 28.97000, 117.12000, 1);
INSERT INTO `divisions` VALUES (360300, '萍乡市', 2, 360000, 27.63000, 113.85000, 1);
INSERT INTO `divisions` VALUES (360301, '市辖区', 3, 360300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (360302, '安源区', 3, 360300, 27.65000, 113.87000, 0);
INSERT INTO `divisions` VALUES (360313, '湘东区', 3, 360300, 27.65000, 113.73000, 0);
INSERT INTO `divisions` VALUES (360321, '莲花县', 3, 360300, 27.13000, 113.95000, 0);
INSERT INTO `divisions` VALUES (360322, '上栗县', 3, 360300, 27.88000, 113.80000, 0);
INSERT INTO `divisions` VALUES (360323, '芦溪县', 3, 360300, 27.63000, 114.03000, 0);
INSERT INTO `divisions` VALUES (360400, '九江市', 2, 360000, 29.70000, 116.00000, 1);
INSERT INTO `divisions` VALUES (360401, '市辖区', 3, 360400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (360402, '庐山区', 3, 360400, 29.68000, 115.98000, 0);
INSERT INTO `divisions` VALUES (360403, '浔阳区', 3, 360400, 29.73000, 115.98000, 0);
INSERT INTO `divisions` VALUES (360421, '九江县', 3, 360400, 29.62000, 115.88000, 0);
INSERT INTO `divisions` VALUES (360423, '武宁县', 3, 360400, 29.27000, 115.10000, 0);
INSERT INTO `divisions` VALUES (360424, '修水县', 3, 360400, 29.03000, 114.57000, 0);
INSERT INTO `divisions` VALUES (360425, '永修县', 3, 360400, 29.03000, 115.80000, 0);
INSERT INTO `divisions` VALUES (360426, '德安县', 3, 360400, 29.33000, 115.77000, 0);
INSERT INTO `divisions` VALUES (360427, '星子县', 3, 360400, 29.45000, 116.03000, 0);
INSERT INTO `divisions` VALUES (360428, '都昌县', 3, 360400, 29.27000, 116.18000, 0);
INSERT INTO `divisions` VALUES (360429, '湖口县', 3, 360400, 29.73000, 116.22000, 0);
INSERT INTO `divisions` VALUES (360430, '彭泽县', 3, 360400, 29.90000, 116.55000, 0);
INSERT INTO `divisions` VALUES (360481, '瑞昌市', 3, 360500, 29.68000, 115.67000, 1);
INSERT INTO `divisions` VALUES (360482, '共青城市', 3, 360500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (360500, '新余市', 2, 360000, 27.82000, 114.92000, 1);
INSERT INTO `divisions` VALUES (360501, '市辖区', 3, 360500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (360502, '渝水区', 3, 360500, 27.80000, 114.93000, 0);
INSERT INTO `divisions` VALUES (360521, '分宜县', 3, 360500, 27.82000, 114.67000, 0);
INSERT INTO `divisions` VALUES (360600, '鹰潭市', 2, 360000, 28.27000, 117.07000, 1);
INSERT INTO `divisions` VALUES (360601, '市辖区', 3, 360600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (360602, '月湖区', 3, 360600, 28.23000, 117.05000, 0);
INSERT INTO `divisions` VALUES (360622, '余江县', 3, 360600, 28.20000, 116.82000, 0);
INSERT INTO `divisions` VALUES (360681, '贵溪市', 3, 360700, 28.28000, 117.22000, 1);
INSERT INTO `divisions` VALUES (360700, '赣州市', 2, 360000, 25.83000, 114.93000, 1);
INSERT INTO `divisions` VALUES (360701, '市辖区', 3, 360700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (360702, '章贡区', 3, 360700, 25.87000, 114.93000, 0);
INSERT INTO `divisions` VALUES (360721, '赣县', 3, 360700, 25.87000, 115.00000, 0);
INSERT INTO `divisions` VALUES (360722, '信丰县', 3, 360700, 25.38000, 114.93000, 0);
INSERT INTO `divisions` VALUES (360723, '大余县', 3, 360700, 25.40000, 114.35000, 0);
INSERT INTO `divisions` VALUES (360724, '上犹县', 3, 360700, 25.80000, 114.53000, 0);
INSERT INTO `divisions` VALUES (360725, '崇义县', 3, 360700, 25.70000, 114.30000, 0);
INSERT INTO `divisions` VALUES (360726, '安远县', 3, 360700, 25.13000, 115.38000, 0);
INSERT INTO `divisions` VALUES (360727, '龙南县', 3, 360700, 24.92000, 114.78000, 0);
INSERT INTO `divisions` VALUES (360728, '定南县', 3, 360700, 24.78000, 115.03000, 0);
INSERT INTO `divisions` VALUES (360729, '全南县', 3, 360700, 24.75000, 114.52000, 0);
INSERT INTO `divisions` VALUES (360730, '宁都县', 3, 360700, 26.48000, 116.02000, 0);
INSERT INTO `divisions` VALUES (360731, '于都县', 3, 360700, 25.95000, 115.42000, 0);
INSERT INTO `divisions` VALUES (360732, '兴国县', 3, 360700, 26.33000, 115.35000, 0);
INSERT INTO `divisions` VALUES (360733, '会昌县', 3, 360700, 25.60000, 115.78000, 0);
INSERT INTO `divisions` VALUES (360734, '寻乌县', 3, 360700, 24.95000, 115.65000, 0);
INSERT INTO `divisions` VALUES (360735, '石城县', 3, 360700, 26.33000, 116.33000, 0);
INSERT INTO `divisions` VALUES (360781, '瑞金市', 3, 360800, 25.88000, 116.03000, 1);
INSERT INTO `divisions` VALUES (360782, '南康市', 3, 360800, 25.65000, 114.75000, 1);
INSERT INTO `divisions` VALUES (360800, '吉安市', 2, 360000, 27.12000, 114.98000, 1);
INSERT INTO `divisions` VALUES (360801, '市辖区', 3, 360800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (360802, '吉州区', 3, 360800, 27.12000, 114.98000, 0);
INSERT INTO `divisions` VALUES (360803, '青原区', 3, 360800, 27.10000, 115.00000, 0);
INSERT INTO `divisions` VALUES (360821, '吉安县', 3, 360800, 27.05000, 114.90000, 0);
INSERT INTO `divisions` VALUES (360822, '吉水县', 3, 360800, 27.22000, 115.13000, 0);
INSERT INTO `divisions` VALUES (360823, '峡江县', 3, 360800, 27.62000, 115.33000, 0);
INSERT INTO `divisions` VALUES (360824, '新干县', 3, 360800, 27.77000, 115.40000, 0);
INSERT INTO `divisions` VALUES (360825, '永丰县', 3, 360800, 27.32000, 115.43000, 0);
INSERT INTO `divisions` VALUES (360826, '泰和县', 3, 360800, 26.80000, 114.88000, 0);
INSERT INTO `divisions` VALUES (360827, '遂川县', 3, 360800, 26.33000, 114.52000, 0);
INSERT INTO `divisions` VALUES (360828, '万安县', 3, 360800, 26.47000, 114.78000, 0);
INSERT INTO `divisions` VALUES (360829, '安福县', 3, 360800, 27.38000, 114.62000, 0);
INSERT INTO `divisions` VALUES (360830, '永新县', 3, 360800, 26.95000, 114.23000, 0);
INSERT INTO `divisions` VALUES (360881, '井冈山市', 3, 360900, 26.72000, 114.27000, 1);
INSERT INTO `divisions` VALUES (360900, '宜春市', 2, 360000, 27.80000, 114.38000, 1);
INSERT INTO `divisions` VALUES (360901, '市辖区', 3, 360900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (360902, '袁州区', 3, 360900, 27.80000, 114.38000, 0);
INSERT INTO `divisions` VALUES (360921, '奉新县', 3, 360900, 28.70000, 115.38000, 0);
INSERT INTO `divisions` VALUES (360922, '万载县', 3, 360900, 28.12000, 114.43000, 0);
INSERT INTO `divisions` VALUES (360923, '上高县', 3, 360900, 28.23000, 114.92000, 0);
INSERT INTO `divisions` VALUES (360924, '宜丰县', 3, 360900, 28.38000, 114.78000, 0);
INSERT INTO `divisions` VALUES (360925, '靖安县', 3, 360900, 28.87000, 115.35000, 0);
INSERT INTO `divisions` VALUES (360926, '铜鼓县', 3, 360900, 28.53000, 114.37000, 0);
INSERT INTO `divisions` VALUES (360981, '丰城市', 3, 361000, 28.20000, 115.78000, 1);
INSERT INTO `divisions` VALUES (360982, '樟树市', 3, 361000, 28.07000, 115.53000, 1);
INSERT INTO `divisions` VALUES (360983, '高安市', 3, 361000, 28.42000, 115.37000, 1);
INSERT INTO `divisions` VALUES (361000, '抚州市', 2, 360000, 28.00000, 116.35000, 1);
INSERT INTO `divisions` VALUES (361001, '市辖区', 3, 361000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (361002, '临川区', 3, 361000, 27.98000, 116.35000, 0);
INSERT INTO `divisions` VALUES (361021, '南城县', 3, 361000, 27.55000, 116.63000, 0);
INSERT INTO `divisions` VALUES (361022, '黎川县', 3, 361000, 27.30000, 116.92000, 0);
INSERT INTO `divisions` VALUES (361023, '南丰县', 3, 361000, 27.22000, 116.53000, 0);
INSERT INTO `divisions` VALUES (361024, '崇仁县', 3, 361000, 27.77000, 116.05000, 0);
INSERT INTO `divisions` VALUES (361025, '乐安县', 3, 361000, 27.43000, 115.83000, 0);
INSERT INTO `divisions` VALUES (361026, '宜黄县', 3, 361000, 27.55000, 116.22000, 0);
INSERT INTO `divisions` VALUES (361027, '金溪县', 3, 361000, 27.92000, 116.77000, 0);
INSERT INTO `divisions` VALUES (361028, '资溪县', 3, 361000, 27.70000, 117.07000, 0);
INSERT INTO `divisions` VALUES (361029, '东乡县', 3, 361000, 28.23000, 116.62000, 0);
INSERT INTO `divisions` VALUES (361030, '广昌县', 3, 361000, 26.83000, 116.32000, 0);
INSERT INTO `divisions` VALUES (361100, '上饶市', 2, 360000, 28.45000, 117.97000, 1);
INSERT INTO `divisions` VALUES (361101, '市辖区', 3, 361100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (361102, '信州区', 3, 361100, 28.43000, 117.95000, 0);
INSERT INTO `divisions` VALUES (361121, '上饶县', 3, 361100, 28.43000, 117.92000, 0);
INSERT INTO `divisions` VALUES (361122, '广丰县', 3, 361100, 28.43000, 118.18000, 0);
INSERT INTO `divisions` VALUES (361123, '玉山县', 3, 361100, 28.68000, 118.25000, 0);
INSERT INTO `divisions` VALUES (361124, '铅山县', 3, 361100, 28.32000, 117.70000, 0);
INSERT INTO `divisions` VALUES (361125, '横峰县', 3, 361100, 28.42000, 117.60000, 0);
INSERT INTO `divisions` VALUES (361126, '弋阳县', 3, 361100, 28.40000, 117.43000, 0);
INSERT INTO `divisions` VALUES (361127, '余干县', 3, 361100, 28.70000, 116.68000, 0);
INSERT INTO `divisions` VALUES (361128, '鄱阳县', 3, 361100, 29.00000, 116.67000, 0);
INSERT INTO `divisions` VALUES (361129, '万年县', 3, 361100, 28.70000, 117.07000, 0);
INSERT INTO `divisions` VALUES (361130, '婺源县', 3, 361100, 29.25000, 117.85000, 0);
INSERT INTO `divisions` VALUES (361181, '德兴市', 3, 361200, 28.95000, 117.57000, 1);
INSERT INTO `divisions` VALUES (370000, '山东省', 1, 0, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (370100, '济南市', 2, 370000, 36.67000, 116.98000, 1);
INSERT INTO `divisions` VALUES (370101, '市辖区', 3, 370100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (370102, '历下区', 3, 370100, 36.67000, 117.08000, 0);
INSERT INTO `divisions` VALUES (370103, '市中区', 3, 370100, 29.57000, 103.77000, 0);
INSERT INTO `divisions` VALUES (370104, '槐荫区', 3, 370100, 36.65000, 116.93000, 0);
INSERT INTO `divisions` VALUES (370105, '天桥区', 3, 370100, 36.68000, 116.98000, 0);
INSERT INTO `divisions` VALUES (370112, '历城区', 3, 370100, 36.68000, 117.07000, 0);
INSERT INTO `divisions` VALUES (370113, '长清区', 3, 370100, 36.55000, 116.73000, 0);
INSERT INTO `divisions` VALUES (370124, '平阴县', 3, 370100, 36.28000, 116.45000, 0);
INSERT INTO `divisions` VALUES (370125, '济阳县', 3, 370100, 36.98000, 117.22000, 0);
INSERT INTO `divisions` VALUES (370126, '商河县', 3, 370100, 37.32000, 117.15000, 0);
INSERT INTO `divisions` VALUES (370181, '章丘市', 3, 370200, 36.72000, 117.53000, 1);
INSERT INTO `divisions` VALUES (370200, '青岛市', 2, 370000, 36.07000, 120.38000, 1);
INSERT INTO `divisions` VALUES (370201, '市辖区', 3, 370200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (370202, '市南区', 3, 370200, 36.07000, 120.38000, 0);
INSERT INTO `divisions` VALUES (370203, '市北区', 3, 370200, 36.08000, 120.38000, 0);
INSERT INTO `divisions` VALUES (370205, '四方区', 3, 370200, 36.10000, 120.35000, 0);
INSERT INTO `divisions` VALUES (370211, '黄岛区', 3, 370200, 35.97000, 120.18000, 0);
INSERT INTO `divisions` VALUES (370212, '崂山区', 3, 370200, 36.10000, 120.47000, 0);
INSERT INTO `divisions` VALUES (370213, '李沧区', 3, 370200, 36.15000, 120.43000, 0);
INSERT INTO `divisions` VALUES (370214, '城阳区', 3, 370200, 36.30000, 120.37000, 0);
INSERT INTO `divisions` VALUES (370281, '胶州市', 3, 370300, 36.27000, 120.03000, 1);
INSERT INTO `divisions` VALUES (370282, '即墨市', 3, 370300, 36.38000, 120.45000, 1);
INSERT INTO `divisions` VALUES (370283, '平度市', 3, 370300, 36.78000, 119.95000, 1);
INSERT INTO `divisions` VALUES (370284, '胶南市', 3, 370300, 35.87000, 120.03000, 1);
INSERT INTO `divisions` VALUES (370285, '莱西市', 3, 370300, 36.87000, 120.50000, 1);
INSERT INTO `divisions` VALUES (370300, '淄博市', 2, 370000, 36.82000, 118.05000, 1);
INSERT INTO `divisions` VALUES (370301, '市辖区', 3, 370300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (370302, '淄川区', 3, 370300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (370303, '张店区', 3, 370300, 36.82000, 118.03000, 0);
INSERT INTO `divisions` VALUES (370304, '博山区', 3, 370300, 36.50000, 117.85000, 0);
INSERT INTO `divisions` VALUES (370305, '临淄区', 3, 370300, 36.82000, 118.30000, 0);
INSERT INTO `divisions` VALUES (370306, '周村区', 3, 370300, 36.80000, 117.87000, 0);
INSERT INTO `divisions` VALUES (370321, '桓台县', 3, 370300, 36.97000, 118.08000, 0);
INSERT INTO `divisions` VALUES (370322, '高青县', 3, 370300, 37.17000, 117.82000, 0);
INSERT INTO `divisions` VALUES (370323, '沂源县', 3, 370300, 36.18000, 118.17000, 0);
INSERT INTO `divisions` VALUES (370400, '枣庄市', 2, 370000, 34.82000, 117.32000, 1);
INSERT INTO `divisions` VALUES (370401, '市辖区', 3, 370400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (370402, '市中区', 3, 370400, 29.57000, 103.77000, 0);
INSERT INTO `divisions` VALUES (370403, '薛城区', 3, 370400, 34.80000, 117.25000, 0);
INSERT INTO `divisions` VALUES (370404, '峄城区', 3, 370400, 34.77000, 117.58000, 0);
INSERT INTO `divisions` VALUES (370405, '台儿庄区', 3, 370400, 34.57000, 117.73000, 0);
INSERT INTO `divisions` VALUES (370406, '山亭区', 3, 370400, 35.08000, 117.45000, 0);
INSERT INTO `divisions` VALUES (370481, '滕州市', 3, 370500, 35.08000, 117.15000, 1);
INSERT INTO `divisions` VALUES (370500, '东营市', 2, 370000, 37.43000, 118.67000, 1);
INSERT INTO `divisions` VALUES (370501, '市辖区', 3, 370500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (370502, '东营区', 3, 370500, 37.47000, 118.50000, 0);
INSERT INTO `divisions` VALUES (370503, '河口区', 3, 370500, 37.88000, 118.53000, 0);
INSERT INTO `divisions` VALUES (370521, '垦利县', 3, 370500, 37.58000, 118.55000, 0);
INSERT INTO `divisions` VALUES (370522, '利津县', 3, 370500, 37.48000, 118.25000, 0);
INSERT INTO `divisions` VALUES (370523, '广饶县', 3, 370500, 37.07000, 118.40000, 0);
INSERT INTO `divisions` VALUES (370600, '烟台市', 2, 370000, 37.45000, 121.43000, 1);
INSERT INTO `divisions` VALUES (370601, '市辖区', 3, 370600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (370602, '芝罘区', 3, 370600, 37.53000, 121.38000, 0);
INSERT INTO `divisions` VALUES (370611, '福山区', 3, 370600, 37.50000, 121.25000, 0);
INSERT INTO `divisions` VALUES (370612, '牟平区', 3, 370600, 37.38000, 121.60000, 0);
INSERT INTO `divisions` VALUES (370613, '莱山区', 3, 370600, 37.50000, 121.43000, 0);
INSERT INTO `divisions` VALUES (370634, '长岛县', 3, 370600, 37.92000, 120.73000, 0);
INSERT INTO `divisions` VALUES (370681, '龙口市', 3, 370700, 37.65000, 120.52000, 1);
INSERT INTO `divisions` VALUES (370682, '莱阳市', 3, 370700, 36.98000, 120.70000, 1);
INSERT INTO `divisions` VALUES (370683, '莱州市', 3, 370700, 37.18000, 119.93000, 1);
INSERT INTO `divisions` VALUES (370684, '蓬莱市', 3, 370700, 37.82000, 120.75000, 1);
INSERT INTO `divisions` VALUES (370685, '招远市', 3, 370700, 37.37000, 120.40000, 1);
INSERT INTO `divisions` VALUES (370686, '栖霞市', 3, 370700, 37.30000, 120.83000, 1);
INSERT INTO `divisions` VALUES (370687, '海阳市', 3, 370700, 36.78000, 121.15000, 1);
INSERT INTO `divisions` VALUES (370700, '潍坊市', 2, 370000, 36.70000, 119.15000, 1);
INSERT INTO `divisions` VALUES (370701, '市辖区', 3, 370700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (370702, '潍城区', 3, 370700, 36.72000, 119.10000, 0);
INSERT INTO `divisions` VALUES (370703, '寒亭区', 3, 370700, 36.77000, 119.22000, 0);
INSERT INTO `divisions` VALUES (370704, '坊子区', 3, 370700, 36.67000, 119.17000, 0);
INSERT INTO `divisions` VALUES (370705, '奎文区', 3, 370700, 36.72000, 119.12000, 0);
INSERT INTO `divisions` VALUES (370724, '临朐县', 3, 370700, 36.52000, 118.53000, 0);
INSERT INTO `divisions` VALUES (370725, '昌乐县', 3, 370700, 36.70000, 118.82000, 0);
INSERT INTO `divisions` VALUES (370781, '青州市', 3, 370800, 36.68000, 118.47000, 1);
INSERT INTO `divisions` VALUES (370782, '诸城市', 3, 370800, 36.00000, 119.40000, 1);
INSERT INTO `divisions` VALUES (370783, '寿光市', 3, 370800, 36.88000, 118.73000, 1);
INSERT INTO `divisions` VALUES (370784, '安丘市', 3, 370800, 36.43000, 119.20000, 1);
INSERT INTO `divisions` VALUES (370785, '高密市', 3, 370800, 36.38000, 119.75000, 1);
INSERT INTO `divisions` VALUES (370786, '昌邑市', 3, 370800, 36.87000, 119.40000, 1);
INSERT INTO `divisions` VALUES (370800, '济宁市', 2, 370000, 35.42000, 116.58000, 1);
INSERT INTO `divisions` VALUES (370801, '市辖区', 3, 370800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (370802, '市中区', 3, 370800, 29.57000, 103.77000, 0);
INSERT INTO `divisions` VALUES (370811, '任城区', 3, 370800, 35.42000, 116.58000, 0);
INSERT INTO `divisions` VALUES (370826, '微山县', 3, 370800, 34.82000, 117.13000, 0);
INSERT INTO `divisions` VALUES (370827, '鱼台县', 3, 370800, 35.00000, 116.65000, 0);
INSERT INTO `divisions` VALUES (370828, '金乡县', 3, 370800, 35.07000, 116.30000, 0);
INSERT INTO `divisions` VALUES (370829, '嘉祥县', 3, 370800, 35.42000, 116.33000, 0);
INSERT INTO `divisions` VALUES (370830, '汶上县', 3, 370800, 35.73000, 116.48000, 0);
INSERT INTO `divisions` VALUES (370831, '泗水县', 3, 370800, 35.67000, 117.27000, 0);
INSERT INTO `divisions` VALUES (370832, '梁山县', 3, 370800, 35.80000, 116.08000, 0);
INSERT INTO `divisions` VALUES (370881, '曲阜市', 3, 370900, 35.58000, 116.98000, 1);
INSERT INTO `divisions` VALUES (370882, '兖州市', 3, 370900, 35.55000, 116.83000, 1);
INSERT INTO `divisions` VALUES (370883, '邹城市', 3, 370900, 35.40000, 116.97000, 1);
INSERT INTO `divisions` VALUES (370900, '泰安市', 2, 370000, 36.20000, 117.08000, 1);
INSERT INTO `divisions` VALUES (370901, '市辖区', 3, 370900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (370902, '泰山区', 3, 370900, 36.18000, 117.13000, 0);
INSERT INTO `divisions` VALUES (370911, '岱岳区', 3, 370900, 36.18000, 117.00000, 0);
INSERT INTO `divisions` VALUES (370921, '宁阳县', 3, 370900, 35.77000, 116.80000, 0);
INSERT INTO `divisions` VALUES (370923, '东平县', 3, 370900, 35.93000, 116.47000, 0);
INSERT INTO `divisions` VALUES (370982, '新泰市', 3, 371000, 35.92000, 117.77000, 1);
INSERT INTO `divisions` VALUES (370983, '肥城市', 3, 371000, 36.18000, 116.77000, 1);
INSERT INTO `divisions` VALUES (371000, '威海市', 2, 370000, 37.52000, 122.12000, 1);
INSERT INTO `divisions` VALUES (371001, '市辖区', 3, 371000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (371002, '环翠区', 3, 371000, 37.50000, 122.12000, 0);
INSERT INTO `divisions` VALUES (371081, '文登市', 3, 371100, 37.20000, 122.05000, 1);
INSERT INTO `divisions` VALUES (371082, '荣成市', 3, 371100, 37.17000, 122.42000, 1);
INSERT INTO `divisions` VALUES (371083, '乳山市', 3, 371100, 36.92000, 121.53000, 1);
INSERT INTO `divisions` VALUES (371100, '日照市', 2, 370000, 35.42000, 119.52000, 1);
INSERT INTO `divisions` VALUES (371101, '市辖区', 3, 371100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (371102, '东港区', 3, 371100, 35.42000, 119.45000, 0);
INSERT INTO `divisions` VALUES (371103, '岚山区', 3, 371100, 35.10000, 119.33000, 0);
INSERT INTO `divisions` VALUES (371121, '五莲县', 3, 371100, 35.75000, 119.20000, 0);
INSERT INTO `divisions` VALUES (371122, '莒县', 3, 371100, 35.58000, 118.83000, 0);
INSERT INTO `divisions` VALUES (371200, '莱芜市', 2, 370000, 36.22000, 117.67000, 1);
INSERT INTO `divisions` VALUES (371201, '市辖区', 3, 371200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (371202, '莱城区', 3, 371200, 36.20000, 117.65000, 0);
INSERT INTO `divisions` VALUES (371203, '钢城区', 3, 371200, 36.07000, 117.80000, 0);
INSERT INTO `divisions` VALUES (371300, '临沂市', 2, 370000, 35.05000, 118.35000, 1);
INSERT INTO `divisions` VALUES (371301, '市辖区', 3, 371300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (371302, '兰山区', 3, 371300, 35.07000, 118.33000, 0);
INSERT INTO `divisions` VALUES (371311, '罗庄区', 3, 371300, 34.98000, 118.28000, 0);
INSERT INTO `divisions` VALUES (371312, '河东区', 3, 371300, 35.08000, 118.40000, 0);
INSERT INTO `divisions` VALUES (371321, '沂南县', 3, 371300, 35.55000, 118.47000, 0);
INSERT INTO `divisions` VALUES (371322, '郯城县', 3, 371300, 34.62000, 118.35000, 0);
INSERT INTO `divisions` VALUES (371323, '沂水县', 3, 371300, 35.78000, 118.62000, 0);
INSERT INTO `divisions` VALUES (371324, '苍山县', 3, 371300, 34.85000, 118.05000, 0);
INSERT INTO `divisions` VALUES (371325, '费县', 3, 371300, 35.27000, 117.97000, 0);
INSERT INTO `divisions` VALUES (371326, '平邑县', 3, 371300, 35.50000, 117.63000, 0);
INSERT INTO `divisions` VALUES (371327, '莒南县', 3, 371300, 35.18000, 118.83000, 0);
INSERT INTO `divisions` VALUES (371328, '蒙阴县', 3, 371300, 35.72000, 117.93000, 0);
INSERT INTO `divisions` VALUES (371329, '临沭县', 3, 371300, 34.92000, 118.65000, 0);
INSERT INTO `divisions` VALUES (371400, '德州市', 2, 370000, 37.45000, 116.30000, 1);
INSERT INTO `divisions` VALUES (371401, '市辖区', 3, 371400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (371402, '德城区', 3, 371400, 37.45000, 116.30000, 0);
INSERT INTO `divisions` VALUES (371421, '陵县', 3, 371400, 37.33000, 116.57000, 0);
INSERT INTO `divisions` VALUES (371422, '宁津县', 3, 371400, 37.65000, 116.78000, 0);
INSERT INTO `divisions` VALUES (371423, '庆云县', 3, 371400, 37.78000, 117.38000, 0);
INSERT INTO `divisions` VALUES (371424, '临邑县', 3, 371400, 37.18000, 116.87000, 0);
INSERT INTO `divisions` VALUES (371425, '齐河县', 3, 371400, 36.80000, 116.75000, 0);
INSERT INTO `divisions` VALUES (371426, '平原县', 3, 371400, 37.17000, 116.43000, 0);
INSERT INTO `divisions` VALUES (371427, '夏津县', 3, 371400, 36.95000, 116.00000, 0);
INSERT INTO `divisions` VALUES (371428, '武城县', 3, 371400, 37.22000, 116.07000, 0);
INSERT INTO `divisions` VALUES (371481, '乐陵市', 3, 371500, 37.73000, 117.23000, 1);
INSERT INTO `divisions` VALUES (371482, '禹城市', 3, 371500, 36.93000, 116.63000, 1);
INSERT INTO `divisions` VALUES (371500, '聊城市', 2, 370000, 36.45000, 115.98000, 1);
INSERT INTO `divisions` VALUES (371501, '市辖区', 3, 371500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (371502, '东昌府区', 3, 371500, 36.45000, 115.98000, 0);
INSERT INTO `divisions` VALUES (371521, '阳谷县', 3, 371500, 36.12000, 115.78000, 0);
INSERT INTO `divisions` VALUES (371522, '莘县', 3, 371500, 36.23000, 115.67000, 0);
INSERT INTO `divisions` VALUES (371523, '茌平县', 3, 371500, 36.58000, 116.25000, 0);
INSERT INTO `divisions` VALUES (371524, '东阿县', 3, 371500, 36.33000, 116.25000, 0);
INSERT INTO `divisions` VALUES (371525, '冠县', 3, 371500, 36.48000, 115.43000, 0);
INSERT INTO `divisions` VALUES (371526, '高唐县', 3, 371500, 36.87000, 116.23000, 0);
INSERT INTO `divisions` VALUES (371581, '临清市', 3, 371600, 36.85000, 115.70000, 1);
INSERT INTO `divisions` VALUES (371600, '滨州市', 2, 370000, 37.38000, 117.97000, 1);
INSERT INTO `divisions` VALUES (371601, '市辖区', 3, 371600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (371602, '滨城区', 3, 371600, 37.38000, 118.00000, 0);
INSERT INTO `divisions` VALUES (371621, '惠民县', 3, 371600, 37.48000, 117.50000, 0);
INSERT INTO `divisions` VALUES (371622, '阳信县', 3, 371600, 37.63000, 117.58000, 0);
INSERT INTO `divisions` VALUES (371623, '无棣县', 3, 371600, 37.73000, 117.60000, 0);
INSERT INTO `divisions` VALUES (371624, '沾化县', 3, 371600, 37.70000, 118.13000, 0);
INSERT INTO `divisions` VALUES (371625, '博兴县', 3, 371600, 37.15000, 118.13000, 0);
INSERT INTO `divisions` VALUES (371626, '邹平县', 3, 371600, 36.88000, 117.73000, 0);
INSERT INTO `divisions` VALUES (371700, '菏泽市', 2, 370000, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (371701, '市辖区', 3, 371700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (371702, '牡丹区', 3, 371700, 35.25000, 115.43000, 0);
INSERT INTO `divisions` VALUES (371721, '曹县', 3, 371700, 34.83000, 115.53000, 0);
INSERT INTO `divisions` VALUES (371722, '单县', 3, 371700, 34.80000, 116.08000, 0);
INSERT INTO `divisions` VALUES (371723, '成武县', 3, 371700, 34.95000, 115.88000, 0);
INSERT INTO `divisions` VALUES (371724, '巨野县', 3, 371700, 35.40000, 116.08000, 0);
INSERT INTO `divisions` VALUES (371725, '郓城县', 3, 371700, 35.60000, 115.93000, 0);
INSERT INTO `divisions` VALUES (371726, '鄄城县', 3, 371700, 35.57000, 115.50000, 0);
INSERT INTO `divisions` VALUES (371727, '定陶县', 3, 371700, 35.07000, 115.57000, 0);
INSERT INTO `divisions` VALUES (371728, '东明县', 3, 371700, 35.28000, 115.08000, 0);
INSERT INTO `divisions` VALUES (410000, '河南省', 1, 0, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (410100, '郑州市', 2, 410000, 34.75000, 113.62000, 1);
INSERT INTO `divisions` VALUES (410101, '市辖区', 3, 410100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (410102, '中原区', 3, 410100, 34.75000, 113.60000, 0);
INSERT INTO `divisions` VALUES (410103, '二七区', 3, 410100, 34.73000, 113.65000, 0);
INSERT INTO `divisions` VALUES (410104, '管城回族区', 3, 410100, 34.75000, 113.67000, 0);
INSERT INTO `divisions` VALUES (410105, '金水区', 3, 410100, 34.78000, 113.65000, 0);
INSERT INTO `divisions` VALUES (410106, '上街区', 3, 410100, 34.82000, 113.28000, 0);
INSERT INTO `divisions` VALUES (410108, '惠济区', 3, 410100, 34.87000, 113.60000, 0);
INSERT INTO `divisions` VALUES (410122, '中牟县', 3, 410100, 34.72000, 113.97000, 0);
INSERT INTO `divisions` VALUES (410181, '巩义市', 3, 410200, 34.77000, 112.98000, 1);
INSERT INTO `divisions` VALUES (410182, '荥阳市', 3, 410200, 34.78000, 113.40000, 1);
INSERT INTO `divisions` VALUES (410183, '新密市', 3, 410200, 34.53000, 113.38000, 1);
INSERT INTO `divisions` VALUES (410184, '新郑市', 3, 410200, 34.40000, 113.73000, 1);
INSERT INTO `divisions` VALUES (410185, '登封市', 3, 410200, 34.47000, 113.03000, 1);
INSERT INTO `divisions` VALUES (410200, '开封市', 2, 410000, 34.80000, 114.30000, 1);
INSERT INTO `divisions` VALUES (410201, '市辖区', 3, 410200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (410202, '龙亭区', 3, 410200, 34.80000, 114.35000, 0);
INSERT INTO `divisions` VALUES (410203, '顺河回族区', 3, 410200, 34.80000, 114.35000, 0);
INSERT INTO `divisions` VALUES (410204, '鼓楼区', 3, 410200, 34.78000, 114.35000, 0);
INSERT INTO `divisions` VALUES (410205, '禹王台区', 3, 410200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (410211, '金明区', 3, 410200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (410221, '杞县', 3, 410200, 34.55000, 114.78000, 0);
INSERT INTO `divisions` VALUES (410222, '通许县', 3, 410200, 34.48000, 114.47000, 0);
INSERT INTO `divisions` VALUES (410223, '尉氏县', 3, 410200, 34.42000, 114.18000, 0);
INSERT INTO `divisions` VALUES (410224, '开封县', 3, 410200, 34.77000, 114.43000, 0);
INSERT INTO `divisions` VALUES (410225, '兰考县', 3, 410200, 34.82000, 114.82000, 0);
INSERT INTO `divisions` VALUES (410300, '洛阳市', 2, 410000, 34.62000, 112.45000, 1);
INSERT INTO `divisions` VALUES (410301, '市辖区', 3, 410300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (410302, '老城区', 3, 410300, 34.68000, 112.47000, 0);
INSERT INTO `divisions` VALUES (410303, '西工区', 3, 410300, 34.67000, 112.43000, 0);
INSERT INTO `divisions` VALUES (410304, '瀍河回族区', 3, 410300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (410305, '涧西区', 3, 410300, 34.67000, 112.40000, 0);
INSERT INTO `divisions` VALUES (410306, '吉利区', 3, 410300, 34.90000, 112.58000, 0);
INSERT INTO `divisions` VALUES (410311, '洛龙区', 3, 410300, 34.62000, 112.45000, 0);
INSERT INTO `divisions` VALUES (410322, '孟津县', 3, 410300, 34.83000, 112.43000, 0);
INSERT INTO `divisions` VALUES (410323, '新安县', 3, 410300, 34.72000, 112.15000, 0);
INSERT INTO `divisions` VALUES (410324, '栾川县', 3, 410300, 33.78000, 111.62000, 0);
INSERT INTO `divisions` VALUES (410325, '嵩县', 3, 410300, 34.15000, 112.10000, 0);
INSERT INTO `divisions` VALUES (410326, '汝阳县', 3, 410300, 34.15000, 112.47000, 0);
INSERT INTO `divisions` VALUES (410327, '宜阳县', 3, 410300, 34.52000, 112.17000, 0);
INSERT INTO `divisions` VALUES (410328, '洛宁县', 3, 410300, 34.38000, 111.65000, 0);
INSERT INTO `divisions` VALUES (410329, '伊川县', 3, 410300, 34.42000, 112.42000, 0);
INSERT INTO `divisions` VALUES (410381, '偃师市', 3, 410400, 34.73000, 112.78000, 1);
INSERT INTO `divisions` VALUES (410400, '平顶山市', 2, 410000, 33.77000, 113.18000, 1);
INSERT INTO `divisions` VALUES (410401, '市辖区', 3, 410400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (410402, '新华区', 3, 410400, 33.73000, 113.30000, 0);
INSERT INTO `divisions` VALUES (410403, '卫东区', 3, 410400, 33.73000, 113.33000, 0);
INSERT INTO `divisions` VALUES (410404, '石龙区', 3, 410400, 33.90000, 112.88000, 0);
INSERT INTO `divisions` VALUES (410411, '湛河区', 3, 410400, 33.73000, 113.28000, 0);
INSERT INTO `divisions` VALUES (410421, '宝丰县', 3, 410400, 33.88000, 113.07000, 0);
INSERT INTO `divisions` VALUES (410422, '叶县', 3, 410400, 33.62000, 113.35000, 0);
INSERT INTO `divisions` VALUES (410423, '鲁山县', 3, 410400, 33.73000, 112.90000, 0);
INSERT INTO `divisions` VALUES (410425, '郏县', 3, 410400, 33.97000, 113.22000, 0);
INSERT INTO `divisions` VALUES (410481, '舞钢市', 3, 410500, 33.30000, 113.52000, 1);
INSERT INTO `divisions` VALUES (410482, '汝州市', 3, 410500, 34.17000, 112.83000, 1);
INSERT INTO `divisions` VALUES (410500, '安阳市', 2, 410000, 36.10000, 114.38000, 1);
INSERT INTO `divisions` VALUES (410501, '市辖区', 3, 410500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (410502, '文峰区', 3, 410500, 36.08000, 114.35000, 0);
INSERT INTO `divisions` VALUES (410503, '北关区', 3, 410500, 36.12000, 114.35000, 0);
INSERT INTO `divisions` VALUES (410505, '殷都区', 3, 410500, 36.12000, 114.30000, 0);
INSERT INTO `divisions` VALUES (410506, '龙安区', 3, 410500, 36.10000, 114.32000, 0);
INSERT INTO `divisions` VALUES (410522, '安阳县', 3, 410500, 36.10000, 114.35000, 0);
INSERT INTO `divisions` VALUES (410523, '汤阴县', 3, 410500, 35.92000, 114.35000, 0);
INSERT INTO `divisions` VALUES (410526, '滑县', 3, 410500, 35.58000, 114.52000, 0);
INSERT INTO `divisions` VALUES (410527, '内黄县', 3, 410500, 35.95000, 114.90000, 0);
INSERT INTO `divisions` VALUES (410581, '林州市', 3, 410600, 36.07000, 113.82000, 1);
INSERT INTO `divisions` VALUES (410600, '鹤壁市', 2, 410000, 35.75000, 114.28000, 1);
INSERT INTO `divisions` VALUES (410601, '市辖区', 3, 410600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (410602, '鹤山区', 3, 410600, 35.95000, 114.15000, 0);
INSERT INTO `divisions` VALUES (410603, '山城区', 3, 410600, 35.90000, 114.18000, 0);
INSERT INTO `divisions` VALUES (410611, '淇滨区', 3, 410600, 35.73000, 114.30000, 0);
INSERT INTO `divisions` VALUES (410621, '浚县', 3, 410600, 35.67000, 114.55000, 0);
INSERT INTO `divisions` VALUES (410622, '淇县', 3, 410600, 35.60000, 114.20000, 0);
INSERT INTO `divisions` VALUES (410700, '新乡市', 2, 410000, 35.30000, 113.90000, 1);
INSERT INTO `divisions` VALUES (410701, '市辖区', 3, 410700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (410702, '红旗区', 3, 410700, 35.30000, 113.87000, 0);
INSERT INTO `divisions` VALUES (410703, '卫滨区', 3, 410700, 35.30000, 113.85000, 0);
INSERT INTO `divisions` VALUES (410704, '凤泉区', 3, 410700, 35.38000, 113.92000, 0);
INSERT INTO `divisions` VALUES (410711, '牧野区', 3, 410700, 35.32000, 113.90000, 0);
INSERT INTO `divisions` VALUES (410721, '新乡县', 3, 410700, 35.20000, 113.80000, 0);
INSERT INTO `divisions` VALUES (410724, '获嘉县', 3, 410700, 35.27000, 113.65000, 0);
INSERT INTO `divisions` VALUES (410725, '原阳县', 3, 410700, 35.05000, 113.97000, 0);
INSERT INTO `divisions` VALUES (410726, '延津县', 3, 410700, 35.15000, 114.20000, 0);
INSERT INTO `divisions` VALUES (410727, '封丘县', 3, 410700, 35.05000, 114.42000, 0);
INSERT INTO `divisions` VALUES (410728, '长垣县', 3, 410700, 35.20000, 114.68000, 0);
INSERT INTO `divisions` VALUES (410781, '卫辉市', 3, 410800, 35.40000, 114.07000, 1);
INSERT INTO `divisions` VALUES (410782, '辉县市', 3, 410800, 35.47000, 113.80000, 1);
INSERT INTO `divisions` VALUES (410800, '焦作市', 2, 410000, 35.22000, 113.25000, 1);
INSERT INTO `divisions` VALUES (410801, '市辖区', 3, 410800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (410802, '解放区', 3, 410800, 35.25000, 113.22000, 0);
INSERT INTO `divisions` VALUES (410803, '中站区', 3, 410800, 35.23000, 113.17000, 0);
INSERT INTO `divisions` VALUES (410804, '马村区', 3, 410800, 35.27000, 113.32000, 0);
INSERT INTO `divisions` VALUES (410811, '山阳区', 3, 410800, 35.22000, 113.25000, 0);
INSERT INTO `divisions` VALUES (410821, '修武县', 3, 410800, 35.23000, 113.43000, 0);
INSERT INTO `divisions` VALUES (410822, '博爱县', 3, 410800, 35.17000, 113.07000, 0);
INSERT INTO `divisions` VALUES (410823, '武陟县', 3, 410800, 35.10000, 113.38000, 0);
INSERT INTO `divisions` VALUES (410825, '温县', 3, 410800, 34.93000, 113.08000, 0);
INSERT INTO `divisions` VALUES (410882, '沁阳市', 3, 410900, 35.08000, 112.93000, 1);
INSERT INTO `divisions` VALUES (410883, '孟州市', 3, 410900, 34.90000, 112.78000, 1);
INSERT INTO `divisions` VALUES (410900, '濮阳市', 2, 410000, 35.77000, 115.03000, 1);
INSERT INTO `divisions` VALUES (410901, '市辖区', 3, 410900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (410902, '华龙区', 3, 410900, 35.78000, 115.07000, 0);
INSERT INTO `divisions` VALUES (410922, '清丰县', 3, 410900, 35.90000, 115.12000, 0);
INSERT INTO `divisions` VALUES (410923, '南乐县', 3, 410900, 36.08000, 115.20000, 0);
INSERT INTO `divisions` VALUES (410926, '范县', 3, 410900, 35.87000, 115.50000, 0);
INSERT INTO `divisions` VALUES (410927, '台前县', 3, 410900, 36.00000, 115.85000, 0);
INSERT INTO `divisions` VALUES (410928, '濮阳县', 3, 410900, 35.70000, 115.02000, 0);
INSERT INTO `divisions` VALUES (411000, '许昌市', 2, 410000, 34.03000, 113.85000, 1);
INSERT INTO `divisions` VALUES (411001, '市辖区', 3, 411000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (411002, '魏都区', 3, 411000, 34.03000, 113.82000, 0);
INSERT INTO `divisions` VALUES (411023, '许昌县', 3, 411000, 34.00000, 113.83000, 0);
INSERT INTO `divisions` VALUES (411024, '鄢陵县', 3, 411000, 34.10000, 114.20000, 0);
INSERT INTO `divisions` VALUES (411025, '襄城县', 3, 411000, 33.85000, 113.48000, 0);
INSERT INTO `divisions` VALUES (411081, '禹州市', 3, 411100, 34.17000, 113.47000, 1);
INSERT INTO `divisions` VALUES (411082, '长葛市', 3, 411100, 34.22000, 113.77000, 1);
INSERT INTO `divisions` VALUES (411100, '漯河市', 2, 410000, 33.58000, 114.02000, 1);
INSERT INTO `divisions` VALUES (411101, '市辖区', 3, 411100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (411102, '源汇区', 3, 411100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (411103, '郾城区', 3, 411100, 33.58000, 114.00000, 0);
INSERT INTO `divisions` VALUES (411104, '召陵区', 3, 411100, 33.57000, 114.07000, 0);
INSERT INTO `divisions` VALUES (411121, '舞阳县', 3, 411100, 33.43000, 113.60000, 0);
INSERT INTO `divisions` VALUES (411122, '临颍县', 3, 411100, 33.82000, 113.93000, 0);
INSERT INTO `divisions` VALUES (411200, '三门峡市', 2, 410000, 34.78000, 111.20000, 1);
INSERT INTO `divisions` VALUES (411201, '市辖区', 3, 411200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (411202, '湖滨区', 3, 411200, 34.78000, 111.20000, 0);
INSERT INTO `divisions` VALUES (411221, '渑池县', 3, 411200, 34.77000, 111.75000, 0);
INSERT INTO `divisions` VALUES (411222, '陕县', 3, 411200, 34.70000, 111.08000, 0);
INSERT INTO `divisions` VALUES (411224, '卢氏县', 3, 411200, 34.05000, 111.05000, 0);
INSERT INTO `divisions` VALUES (411281, '义马市', 3, 411300, 34.75000, 111.87000, 1);
INSERT INTO `divisions` VALUES (411282, '灵宝市', 3, 411300, 34.52000, 110.87000, 1);
INSERT INTO `divisions` VALUES (411300, '南阳市', 2, 410000, 33.00000, 112.52000, 1);
INSERT INTO `divisions` VALUES (411301, '市辖区', 3, 411300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (411302, '宛城区', 3, 411300, 33.02000, 112.55000, 0);
INSERT INTO `divisions` VALUES (411303, '卧龙区', 3, 411300, 32.98000, 112.53000, 0);
INSERT INTO `divisions` VALUES (411321, '南召县', 3, 411300, 33.50000, 112.43000, 0);
INSERT INTO `divisions` VALUES (411322, '方城县', 3, 411300, 33.27000, 113.00000, 0);
INSERT INTO `divisions` VALUES (411323, '西峡县', 3, 411300, 33.28000, 111.48000, 0);
INSERT INTO `divisions` VALUES (411324, '镇平县', 3, 411300, 33.03000, 112.23000, 0);
INSERT INTO `divisions` VALUES (411325, '内乡县', 3, 411300, 33.05000, 111.85000, 0);
INSERT INTO `divisions` VALUES (411326, '淅川县', 3, 411300, 33.13000, 111.48000, 0);
INSERT INTO `divisions` VALUES (411327, '社旗县', 3, 411300, 33.05000, 112.93000, 0);
INSERT INTO `divisions` VALUES (411328, '唐河县', 3, 411300, 32.70000, 112.83000, 0);
INSERT INTO `divisions` VALUES (411329, '新野县', 3, 411300, 32.52000, 112.35000, 0);
INSERT INTO `divisions` VALUES (411330, '桐柏县', 3, 411300, 32.37000, 113.40000, 0);
INSERT INTO `divisions` VALUES (411381, '邓州市', 3, 411400, 32.68000, 112.08000, 1);
INSERT INTO `divisions` VALUES (411400, '商丘市', 2, 410000, 34.45000, 115.65000, 1);
INSERT INTO `divisions` VALUES (411401, '市辖区', 3, 411400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (411402, '梁园区', 3, 411400, 34.45000, 115.63000, 0);
INSERT INTO `divisions` VALUES (411403, '睢阳区', 3, 411400, 34.38000, 115.63000, 0);
INSERT INTO `divisions` VALUES (411421, '民权县', 3, 411400, 34.65000, 115.13000, 0);
INSERT INTO `divisions` VALUES (411422, '睢县', 3, 411400, 34.45000, 115.07000, 0);
INSERT INTO `divisions` VALUES (411423, '宁陵县', 3, 411400, 34.45000, 115.32000, 0);
INSERT INTO `divisions` VALUES (411424, '柘城县', 3, 411400, 34.07000, 115.30000, 0);
INSERT INTO `divisions` VALUES (411425, '虞城县', 3, 411400, 34.40000, 115.85000, 0);
INSERT INTO `divisions` VALUES (411426, '夏邑县', 3, 411400, 34.23000, 116.13000, 0);
INSERT INTO `divisions` VALUES (411481, '永城市', 3, 411500, 33.92000, 116.43000, 1);
INSERT INTO `divisions` VALUES (411500, '信阳市', 2, 410000, 32.13000, 114.07000, 1);
INSERT INTO `divisions` VALUES (411501, '市辖区', 3, 411500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (411502, '浉河区', 3, 411500, 32.12000, 114.05000, 0);
INSERT INTO `divisions` VALUES (411503, '平桥区', 3, 411500, 32.10000, 114.12000, 0);
INSERT INTO `divisions` VALUES (411521, '罗山县', 3, 411500, 32.20000, 114.53000, 0);
INSERT INTO `divisions` VALUES (411522, '光山县', 3, 411500, 32.02000, 114.90000, 0);
INSERT INTO `divisions` VALUES (411523, '新县', 3, 411500, 31.63000, 114.87000, 0);
INSERT INTO `divisions` VALUES (411524, '商城县', 3, 411500, 31.80000, 115.40000, 0);
INSERT INTO `divisions` VALUES (411525, '固始县', 3, 411500, 32.18000, 115.68000, 0);
INSERT INTO `divisions` VALUES (411526, '潢川县', 3, 411500, 32.13000, 115.03000, 0);
INSERT INTO `divisions` VALUES (411527, '淮滨县', 3, 411500, 32.43000, 115.40000, 0);
INSERT INTO `divisions` VALUES (411528, '息县', 3, 411500, 32.35000, 114.73000, 0);
INSERT INTO `divisions` VALUES (411600, '周口市', 2, 410000, 33.62000, 114.65000, 1);
INSERT INTO `divisions` VALUES (411601, '市辖区', 3, 411600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (411602, '川汇区', 3, 411600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (411621, '扶沟县', 3, 411600, 34.07000, 114.38000, 0);
INSERT INTO `divisions` VALUES (411622, '西华县', 3, 411600, 33.80000, 114.53000, 0);
INSERT INTO `divisions` VALUES (411623, '商水县', 3, 411600, 33.53000, 114.60000, 0);
INSERT INTO `divisions` VALUES (411624, '沈丘县', 3, 411600, 33.40000, 115.07000, 0);
INSERT INTO `divisions` VALUES (411625, '郸城县', 3, 411600, 33.65000, 115.20000, 0);
INSERT INTO `divisions` VALUES (411626, '淮阳县', 3, 411600, 33.73000, 114.88000, 0);
INSERT INTO `divisions` VALUES (411627, '太康县', 3, 411600, 34.07000, 114.85000, 0);
INSERT INTO `divisions` VALUES (411628, '鹿邑县', 3, 411600, 33.87000, 115.48000, 0);
INSERT INTO `divisions` VALUES (411681, '项城市', 3, 411700, 33.45000, 114.90000, 1);
INSERT INTO `divisions` VALUES (411700, '驻马店市', 2, 410000, 32.98000, 114.02000, 1);
INSERT INTO `divisions` VALUES (411701, '市辖区', 3, 411700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (411702, '驿城区', 3, 411700, 32.97000, 114.05000, 0);
INSERT INTO `divisions` VALUES (411721, '西平县', 3, 411700, 33.38000, 114.02000, 0);
INSERT INTO `divisions` VALUES (411722, '上蔡县', 3, 411700, 33.27000, 114.27000, 0);
INSERT INTO `divisions` VALUES (411723, '平舆县', 3, 411700, 32.97000, 114.63000, 0);
INSERT INTO `divisions` VALUES (411724, '正阳县', 3, 411700, 32.60000, 114.38000, 0);
INSERT INTO `divisions` VALUES (411725, '确山县', 3, 411700, 32.80000, 114.02000, 0);
INSERT INTO `divisions` VALUES (411726, '泌阳县', 3, 411700, 32.72000, 113.32000, 0);
INSERT INTO `divisions` VALUES (411727, '汝南县', 3, 411700, 33.00000, 114.35000, 0);
INSERT INTO `divisions` VALUES (411728, '遂平县', 3, 411700, 33.15000, 114.00000, 0);
INSERT INTO `divisions` VALUES (411729, '新蔡县', 3, 411700, 32.75000, 114.98000, 0);
INSERT INTO `divisions` VALUES (419000, '省直辖县级行政区划', 2, 420000, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (419001, '济源市', 3, 419000, 35.07000, 112.58000, 1);
INSERT INTO `divisions` VALUES (420000, '湖北省', 1, 0, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (420100, '武汉市', 2, 420000, 30.60000, 114.30000, 1);
INSERT INTO `divisions` VALUES (420101, '市辖区', 3, 420100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (420102, '江岸区', 3, 420100, 30.60000, 114.30000, 0);
INSERT INTO `divisions` VALUES (420103, '江汉区', 3, 420100, 30.60000, 114.27000, 0);
INSERT INTO `divisions` VALUES (420104, '硚口区', 3, 420100, 30.57000, 114.27000, 0);
INSERT INTO `divisions` VALUES (420105, '汉阳区', 3, 420100, 30.55000, 114.27000, 0);
INSERT INTO `divisions` VALUES (420106, '武昌区', 3, 420100, 30.57000, 114.30000, 0);
INSERT INTO `divisions` VALUES (420107, '青山区', 3, 420100, 30.63000, 114.38000, 0);
INSERT INTO `divisions` VALUES (420111, '洪山区', 3, 420100, 30.50000, 114.33000, 0);
INSERT INTO `divisions` VALUES (420112, '东西湖区', 3, 420100, 30.62000, 114.13000, 0);
INSERT INTO `divisions` VALUES (420113, '汉南区', 3, 420100, 30.32000, 114.08000, 0);
INSERT INTO `divisions` VALUES (420114, '蔡甸区', 3, 420100, 30.58000, 114.03000, 0);
INSERT INTO `divisions` VALUES (420115, '江夏区', 3, 420100, 30.35000, 114.32000, 0);
INSERT INTO `divisions` VALUES (420116, '黄陂区', 3, 420100, 30.87000, 114.37000, 0);
INSERT INTO `divisions` VALUES (420117, '新洲区', 3, 420100, 30.85000, 114.80000, 0);
INSERT INTO `divisions` VALUES (420200, '黄石市', 2, 420000, 30.20000, 115.03000, 1);
INSERT INTO `divisions` VALUES (420201, '市辖区', 3, 420200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (420202, '黄石港区', 3, 420200, 30.23000, 115.07000, 0);
INSERT INTO `divisions` VALUES (420203, '西塞山区', 3, 420200, 30.20000, 115.12000, 0);
INSERT INTO `divisions` VALUES (420204, '下陆区', 3, 420200, 30.18000, 114.97000, 0);
INSERT INTO `divisions` VALUES (420205, '铁山区', 3, 420200, 30.20000, 114.90000, 0);
INSERT INTO `divisions` VALUES (420222, '阳新县', 3, 420200, 29.85000, 115.20000, 0);
INSERT INTO `divisions` VALUES (420281, '大冶市', 3, 420300, 30.10000, 114.97000, 1);
INSERT INTO `divisions` VALUES (420300, '十堰市', 2, 420000, 32.65000, 110.78000, 1);
INSERT INTO `divisions` VALUES (420301, '市辖区', 3, 420300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (420302, '茅箭区', 3, 420300, 32.60000, 110.82000, 0);
INSERT INTO `divisions` VALUES (420303, '张湾区', 3, 420300, 32.65000, 110.78000, 0);
INSERT INTO `divisions` VALUES (420321, '郧县', 3, 420300, 32.83000, 110.82000, 0);
INSERT INTO `divisions` VALUES (420322, '郧西县', 3, 420300, 33.00000, 110.42000, 0);
INSERT INTO `divisions` VALUES (420323, '竹山县', 3, 420300, 32.23000, 110.23000, 0);
INSERT INTO `divisions` VALUES (420324, '竹溪县', 3, 420300, 32.32000, 109.72000, 0);
INSERT INTO `divisions` VALUES (420325, '房县', 3, 420300, 32.07000, 110.73000, 0);
INSERT INTO `divisions` VALUES (420381, '丹江口市', 3, 420400, 32.55000, 111.52000, 1);
INSERT INTO `divisions` VALUES (420500, '宜昌市', 2, 420000, 30.70000, 111.28000, 1);
INSERT INTO `divisions` VALUES (420501, '市辖区', 3, 420500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (420502, '西陵区', 3, 420500, 30.70000, 111.27000, 0);
INSERT INTO `divisions` VALUES (420503, '伍家岗区', 3, 420500, 30.65000, 111.35000, 0);
INSERT INTO `divisions` VALUES (420504, '点军区', 3, 420500, 30.70000, 111.27000, 0);
INSERT INTO `divisions` VALUES (420505, '猇亭区', 3, 420500, 30.53000, 111.42000, 0);
INSERT INTO `divisions` VALUES (420506, '夷陵区', 3, 420500, 30.77000, 111.32000, 0);
INSERT INTO `divisions` VALUES (420525, '远安县', 3, 420500, 31.07000, 111.63000, 0);
INSERT INTO `divisions` VALUES (420526, '兴山县', 3, 420500, 31.35000, 110.75000, 0);
INSERT INTO `divisions` VALUES (420527, '秭归县', 3, 420500, 30.83000, 110.98000, 0);
INSERT INTO `divisions` VALUES (420528, '长阳土家族自治县', 3, 420500, 30.47000, 111.18000, 0);
INSERT INTO `divisions` VALUES (420529, '五峰土家族自治县', 3, 420500, 30.20000, 110.67000, 0);
INSERT INTO `divisions` VALUES (420581, '宜都市', 3, 420600, 30.40000, 111.45000, 1);
INSERT INTO `divisions` VALUES (420582, '当阳市', 3, 420600, 30.82000, 111.78000, 1);
INSERT INTO `divisions` VALUES (420583, '枝江市', 3, 420600, 30.43000, 111.77000, 1);
INSERT INTO `divisions` VALUES (420600, '襄阳市', 2, 420000, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (420601, '市辖区', 3, 420600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (420602, '襄城区', 3, 420600, 32.02000, 112.15000, 0);
INSERT INTO `divisions` VALUES (420606, '樊城区', 3, 420600, 32.03000, 112.13000, 0);
INSERT INTO `divisions` VALUES (420607, '襄州区', 3, 420600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (420624, '南漳县', 3, 420600, 31.78000, 111.83000, 0);
INSERT INTO `divisions` VALUES (420625, '谷城县', 3, 420600, 32.27000, 111.65000, 0);
INSERT INTO `divisions` VALUES (420626, '保康县', 3, 420600, 31.88000, 111.25000, 0);
INSERT INTO `divisions` VALUES (420682, '老河口市', 3, 420700, 32.38000, 111.67000, 1);
INSERT INTO `divisions` VALUES (420683, '枣阳市', 3, 420700, 32.13000, 112.75000, 1);
INSERT INTO `divisions` VALUES (420684, '宜城市', 3, 420700, 31.72000, 112.25000, 1);
INSERT INTO `divisions` VALUES (420700, '鄂州市', 2, 420000, 30.40000, 114.88000, 1);
INSERT INTO `divisions` VALUES (420701, '市辖区', 3, 420700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (420702, '梁子湖区', 3, 420700, 30.08000, 114.67000, 0);
INSERT INTO `divisions` VALUES (420703, '华容区', 3, 420700, 30.53000, 114.73000, 0);
INSERT INTO `divisions` VALUES (420704, '鄂城区', 3, 420700, 30.40000, 114.88000, 0);
INSERT INTO `divisions` VALUES (420800, '荆门市', 2, 420000, 31.03000, 112.20000, 1);
INSERT INTO `divisions` VALUES (420801, '市辖区', 3, 420800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (420802, '东宝区', 3, 420800, 31.05000, 112.20000, 0);
INSERT INTO `divisions` VALUES (420804, '掇刀区', 3, 420800, 30.98000, 112.20000, 0);
INSERT INTO `divisions` VALUES (420821, '京山县', 3, 420800, 31.02000, 113.10000, 0);
INSERT INTO `divisions` VALUES (420822, '沙洋县', 3, 420800, 30.70000, 112.58000, 0);
INSERT INTO `divisions` VALUES (420881, '钟祥市', 3, 420900, 31.17000, 112.58000, 1);
INSERT INTO `divisions` VALUES (420900, '孝感市', 2, 420000, 30.93000, 113.92000, 1);
INSERT INTO `divisions` VALUES (420901, '市辖区', 3, 420900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (420902, '孝南区', 3, 420900, 30.92000, 113.92000, 0);
INSERT INTO `divisions` VALUES (420921, '孝昌县', 3, 420900, 31.25000, 113.97000, 0);
INSERT INTO `divisions` VALUES (420922, '大悟县', 3, 420900, 31.57000, 114.12000, 0);
INSERT INTO `divisions` VALUES (420923, '云梦县', 3, 420900, 31.02000, 113.75000, 0);
INSERT INTO `divisions` VALUES (420981, '应城市', 3, 421000, 30.95000, 113.57000, 1);
INSERT INTO `divisions` VALUES (420982, '安陆市', 3, 421000, 31.27000, 113.68000, 1);
INSERT INTO `divisions` VALUES (420984, '汉川市', 3, 421000, 30.65000, 113.83000, 1);
INSERT INTO `divisions` VALUES (421000, '荆州市', 2, 420000, 30.33000, 112.23000, 1);
INSERT INTO `divisions` VALUES (421001, '市辖区', 3, 421000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (421002, '沙市区', 3, 421000, 30.32000, 112.25000, 0);
INSERT INTO `divisions` VALUES (421003, '荆州区', 3, 421000, 30.35000, 112.18000, 0);
INSERT INTO `divisions` VALUES (421022, '公安县', 3, 421000, 30.07000, 112.23000, 0);
INSERT INTO `divisions` VALUES (421023, '监利县', 3, 421000, 29.82000, 112.88000, 0);
INSERT INTO `divisions` VALUES (421024, '江陵县', 3, 421000, 30.03000, 112.42000, 0);
INSERT INTO `divisions` VALUES (421081, '石首市', 3, 421100, 29.73000, 112.40000, 1);
INSERT INTO `divisions` VALUES (421083, '洪湖市', 3, 421100, 29.80000, 113.45000, 1);
INSERT INTO `divisions` VALUES (421087, '松滋市', 3, 421100, 30.18000, 111.77000, 1);
INSERT INTO `divisions` VALUES (421100, '黄冈市', 2, 420000, 30.45000, 114.87000, 1);
INSERT INTO `divisions` VALUES (421101, '市辖区', 3, 421100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (421102, '黄州区', 3, 421100, 30.43000, 114.88000, 0);
INSERT INTO `divisions` VALUES (421121, '团风县', 3, 421100, 30.63000, 114.87000, 0);
INSERT INTO `divisions` VALUES (421122, '红安县', 3, 421100, 31.28000, 114.62000, 0);
INSERT INTO `divisions` VALUES (421123, '罗田县', 3, 421100, 30.78000, 115.40000, 0);
INSERT INTO `divisions` VALUES (421124, '英山县', 3, 421100, 30.75000, 115.67000, 0);
INSERT INTO `divisions` VALUES (421125, '浠水县', 3, 421100, 30.45000, 115.27000, 0);
INSERT INTO `divisions` VALUES (421126, '蕲春县', 3, 421100, 30.23000, 115.43000, 0);
INSERT INTO `divisions` VALUES (421127, '黄梅县', 3, 421100, 30.08000, 115.93000, 0);
INSERT INTO `divisions` VALUES (421181, '麻城市', 3, 421200, 31.18000, 115.03000, 1);
INSERT INTO `divisions` VALUES (421182, '武穴市', 3, 421200, 29.85000, 115.55000, 1);
INSERT INTO `divisions` VALUES (421200, '咸宁市', 2, 420000, 29.85000, 114.32000, 1);
INSERT INTO `divisions` VALUES (421201, '市辖区', 3, 421200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (421202, '咸安区', 3, 421200, 29.87000, 114.30000, 0);
INSERT INTO `divisions` VALUES (421221, '嘉鱼县', 3, 421200, 29.98000, 113.90000, 0);
INSERT INTO `divisions` VALUES (421222, '通城县', 3, 421200, 29.25000, 113.82000, 0);
INSERT INTO `divisions` VALUES (421223, '崇阳县', 3, 421200, 29.55000, 114.03000, 0);
INSERT INTO `divisions` VALUES (421224, '通山县', 3, 421200, 29.60000, 114.52000, 0);
INSERT INTO `divisions` VALUES (421281, '赤壁市', 3, 421300, 29.72000, 113.88000, 1);
INSERT INTO `divisions` VALUES (421300, '随州市', 2, 420000, 31.72000, 113.37000, 1);
INSERT INTO `divisions` VALUES (421301, '市辖区', 3, 421300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (421303, '曾都区', 3, 421300, 31.72000, 113.37000, 0);
INSERT INTO `divisions` VALUES (421321, '随县', 3, 421300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (421381, '广水市', 3, 421400, 31.62000, 113.82000, 1);
INSERT INTO `divisions` VALUES (422800, '恩施土家族苗族自治州', 2, 420000, 30.30000, 109.47000, 1);
INSERT INTO `divisions` VALUES (422801, '恩施市', 3, 422800, 30.30000, 109.47000, 1);
INSERT INTO `divisions` VALUES (422802, '利川市', 3, 422800, 30.30000, 108.93000, 1);
INSERT INTO `divisions` VALUES (422822, '建始县', 3, 422800, 30.60000, 109.73000, 0);
INSERT INTO `divisions` VALUES (422823, '巴东县', 3, 422800, 31.05000, 110.33000, 0);
INSERT INTO `divisions` VALUES (422825, '宣恩县', 3, 422800, 29.98000, 109.48000, 0);
INSERT INTO `divisions` VALUES (422826, '咸丰县', 3, 422800, 29.68000, 109.15000, 0);
INSERT INTO `divisions` VALUES (422827, '来凤县', 3, 422800, 29.52000, 109.40000, 0);
INSERT INTO `divisions` VALUES (422828, '鹤峰县', 3, 422800, 29.90000, 110.03000, 0);
INSERT INTO `divisions` VALUES (429000, '省直辖县级行政区划', 2, 430000, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (429004, '仙桃市', 3, 429000, 30.37000, 113.45000, 1);
INSERT INTO `divisions` VALUES (429005, '潜江市', 3, 429000, 30.42000, 112.88000, 1);
INSERT INTO `divisions` VALUES (429006, '天门市', 3, 429000, 30.67000, 113.17000, 1);
INSERT INTO `divisions` VALUES (429021, '神农架林区', 3, 429000, 31.75000, 110.67000, 0);
INSERT INTO `divisions` VALUES (430000, '湖南省', 1, 0, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (430100, '长沙市', 2, 430000, 28.23000, 112.93000, 1);
INSERT INTO `divisions` VALUES (430101, '市辖区', 3, 430100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (430102, '芙蓉区', 3, 430100, 28.18000, 113.03000, 0);
INSERT INTO `divisions` VALUES (430103, '天心区', 3, 430100, 28.12000, 112.98000, 0);
INSERT INTO `divisions` VALUES (430104, '岳麓区', 3, 430100, 28.23000, 112.93000, 0);
INSERT INTO `divisions` VALUES (430105, '开福区', 3, 430100, 28.25000, 112.98000, 0);
INSERT INTO `divisions` VALUES (430111, '雨花区', 3, 430100, 28.13000, 113.03000, 0);
INSERT INTO `divisions` VALUES (430112, '望城区', 3, 430100, 28.37000, 112.80000, 0);
INSERT INTO `divisions` VALUES (430121, '长沙县', 3, 430100, 28.25000, 113.07000, 0);
INSERT INTO `divisions` VALUES (430124, '宁乡县', 3, 430100, 28.25000, 112.55000, 0);
INSERT INTO `divisions` VALUES (430181, '浏阳市', 3, 430200, 28.15000, 113.63000, 1);
INSERT INTO `divisions` VALUES (430200, '株洲市', 2, 430000, 27.83000, 113.13000, 1);
INSERT INTO `divisions` VALUES (430201, '市辖区', 3, 430200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (430202, '荷塘区', 3, 430200, 27.87000, 113.17000, 0);
INSERT INTO `divisions` VALUES (430203, '芦淞区', 3, 430200, 27.83000, 113.15000, 0);
INSERT INTO `divisions` VALUES (430204, '石峰区', 3, 430200, 27.87000, 113.10000, 0);
INSERT INTO `divisions` VALUES (430211, '天元区', 3, 430200, 27.83000, 113.12000, 0);
INSERT INTO `divisions` VALUES (430221, '株洲县', 3, 430200, 27.72000, 113.13000, 0);
INSERT INTO `divisions` VALUES (430223, '攸县', 3, 430200, 27.00000, 113.33000, 0);
INSERT INTO `divisions` VALUES (430224, '茶陵县', 3, 430200, 26.80000, 113.53000, 0);
INSERT INTO `divisions` VALUES (430225, '炎陵县', 3, 430200, 26.48000, 113.77000, 0);
INSERT INTO `divisions` VALUES (430281, '醴陵市', 3, 430300, 27.67000, 113.48000, 1);
INSERT INTO `divisions` VALUES (430300, '湘潭市', 2, 430000, 27.83000, 112.93000, 1);
INSERT INTO `divisions` VALUES (430301, '市辖区', 3, 430300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (430302, '雨湖区', 3, 430300, 27.87000, 112.90000, 0);
INSERT INTO `divisions` VALUES (430304, '岳塘区', 3, 430300, 27.87000, 112.95000, 0);
INSERT INTO `divisions` VALUES (430321, '湘潭县', 3, 430300, 27.78000, 112.95000, 0);
INSERT INTO `divisions` VALUES (430381, '湘乡市', 3, 430400, 27.73000, 112.53000, 1);
INSERT INTO `divisions` VALUES (430382, '韶山市', 3, 430400, 27.93000, 112.52000, 1);
INSERT INTO `divisions` VALUES (430400, '衡阳市', 2, 430000, 26.90000, 112.57000, 1);
INSERT INTO `divisions` VALUES (430401, '市辖区', 3, 430400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (430405, '珠晖区', 3, 430400, 26.90000, 112.62000, 0);
INSERT INTO `divisions` VALUES (430406, '雁峰区', 3, 430400, 26.88000, 112.60000, 0);
INSERT INTO `divisions` VALUES (430407, '石鼓区', 3, 430400, 26.90000, 112.60000, 0);
INSERT INTO `divisions` VALUES (430408, '蒸湘区', 3, 430400, 26.90000, 112.60000, 0);
INSERT INTO `divisions` VALUES (430412, '南岳区', 3, 430400, 27.25000, 112.73000, 0);
INSERT INTO `divisions` VALUES (430421, '衡阳县', 3, 430400, 26.97000, 112.37000, 0);
INSERT INTO `divisions` VALUES (430422, '衡南县', 3, 430400, 26.73000, 112.67000, 0);
INSERT INTO `divisions` VALUES (430423, '衡山县', 3, 430400, 27.23000, 112.87000, 0);
INSERT INTO `divisions` VALUES (430424, '衡东县', 3, 430400, 27.08000, 112.95000, 0);
INSERT INTO `divisions` VALUES (430426, '祁东县', 3, 430400, 26.78000, 112.12000, 0);
INSERT INTO `divisions` VALUES (430481, '耒阳市', 3, 430500, 26.42000, 112.85000, 1);
INSERT INTO `divisions` VALUES (430482, '常宁市', 3, 430500, 26.42000, 112.38000, 1);
INSERT INTO `divisions` VALUES (430500, '邵阳市', 2, 430000, 27.25000, 111.47000, 1);
INSERT INTO `divisions` VALUES (430501, '市辖区', 3, 430500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (430502, '双清区', 3, 430500, 27.23000, 111.47000, 0);
INSERT INTO `divisions` VALUES (430503, '大祥区', 3, 430500, 27.23000, 111.45000, 0);
INSERT INTO `divisions` VALUES (430511, '北塔区', 3, 430500, 27.25000, 111.45000, 0);
INSERT INTO `divisions` VALUES (430521, '邵东县', 3, 430500, 27.25000, 111.75000, 0);
INSERT INTO `divisions` VALUES (430522, '新邵县', 3, 430500, 27.32000, 111.45000, 0);
INSERT INTO `divisions` VALUES (430523, '邵阳县', 3, 430500, 27.00000, 111.27000, 0);
INSERT INTO `divisions` VALUES (430524, '隆回县', 3, 430500, 27.12000, 111.03000, 0);
INSERT INTO `divisions` VALUES (430525, '洞口县', 3, 430500, 27.05000, 110.57000, 0);
INSERT INTO `divisions` VALUES (430527, '绥宁县', 3, 430500, 26.58000, 110.15000, 0);
INSERT INTO `divisions` VALUES (430528, '新宁县', 3, 430500, 26.43000, 110.85000, 0);
INSERT INTO `divisions` VALUES (430529, '城步苗族自治县', 3, 430500, 26.37000, 110.32000, 0);
INSERT INTO `divisions` VALUES (430581, '武冈市', 3, 430600, 26.73000, 110.63000, 1);
INSERT INTO `divisions` VALUES (430600, '岳阳市', 2, 430000, 29.37000, 113.12000, 1);
INSERT INTO `divisions` VALUES (430601, '市辖区', 3, 430600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (430602, '岳阳楼区', 3, 430600, 29.37000, 113.10000, 0);
INSERT INTO `divisions` VALUES (430603, '云溪区', 3, 430600, 29.47000, 113.30000, 0);
INSERT INTO `divisions` VALUES (430611, '君山区', 3, 430600, 29.43000, 113.00000, 0);
INSERT INTO `divisions` VALUES (430621, '岳阳县', 3, 430600, 29.15000, 113.12000, 0);
INSERT INTO `divisions` VALUES (430623, '华容县', 3, 430600, 29.52000, 112.57000, 0);
INSERT INTO `divisions` VALUES (430624, '湘阴县', 3, 430600, 28.68000, 112.88000, 0);
INSERT INTO `divisions` VALUES (430626, '平江县', 3, 430600, 28.72000, 113.58000, 0);
INSERT INTO `divisions` VALUES (430681, '汨罗市', 3, 430700, 28.80000, 113.08000, 1);
INSERT INTO `divisions` VALUES (430682, '临湘市', 3, 430700, 29.48000, 113.47000, 1);
INSERT INTO `divisions` VALUES (430700, '常德市', 2, 430000, 29.05000, 111.68000, 1);
INSERT INTO `divisions` VALUES (430701, '市辖区', 3, 430700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (430702, '武陵区', 3, 430700, 29.03000, 111.68000, 0);
INSERT INTO `divisions` VALUES (430703, '鼎城区', 3, 430700, 29.02000, 111.68000, 0);
INSERT INTO `divisions` VALUES (430721, '安乡县', 3, 430700, 29.42000, 112.17000, 0);
INSERT INTO `divisions` VALUES (430722, '汉寿县', 3, 430700, 28.90000, 111.97000, 0);
INSERT INTO `divisions` VALUES (430723, '澧县', 3, 430700, 29.63000, 111.75000, 0);
INSERT INTO `divisions` VALUES (430724, '临澧县', 3, 430700, 29.45000, 111.65000, 0);
INSERT INTO `divisions` VALUES (430725, '桃源县', 3, 430700, 28.90000, 111.48000, 0);
INSERT INTO `divisions` VALUES (430726, '石门县', 3, 430700, 29.58000, 111.38000, 0);
INSERT INTO `divisions` VALUES (430781, '津市市', 3, 430800, 29.62000, 111.88000, 1);
INSERT INTO `divisions` VALUES (430800, '张家界市', 2, 430000, 29.13000, 110.47000, 1);
INSERT INTO `divisions` VALUES (430801, '市辖区', 3, 430800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (430802, '永定区', 3, 430800, 29.13000, 110.48000, 0);
INSERT INTO `divisions` VALUES (430811, '武陵源区', 3, 430800, 29.35000, 110.53000, 0);
INSERT INTO `divisions` VALUES (430821, '慈利县', 3, 430800, 29.42000, 111.12000, 0);
INSERT INTO `divisions` VALUES (430822, '桑植县', 3, 430800, 29.40000, 110.15000, 0);
INSERT INTO `divisions` VALUES (430900, '益阳市', 2, 430000, 28.60000, 112.32000, 1);
INSERT INTO `divisions` VALUES (430901, '市辖区', 3, 430900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (430902, '资阳区', 3, 430900, 28.60000, 112.32000, 0);
INSERT INTO `divisions` VALUES (430903, '赫山区', 3, 430900, 28.60000, 112.37000, 0);
INSERT INTO `divisions` VALUES (430921, '南县', 3, 430900, 29.38000, 112.40000, 0);
INSERT INTO `divisions` VALUES (430922, '桃江县', 3, 430900, 28.53000, 112.12000, 0);
INSERT INTO `divisions` VALUES (430923, '安化县', 3, 430900, 28.38000, 111.22000, 0);
INSERT INTO `divisions` VALUES (430981, '沅江市', 3, 431000, 28.85000, 112.38000, 1);
INSERT INTO `divisions` VALUES (431000, '郴州市', 2, 430000, 25.78000, 113.02000, 1);
INSERT INTO `divisions` VALUES (431001, '市辖区', 3, 431000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (431002, '北湖区', 3, 431000, 25.80000, 113.02000, 0);
INSERT INTO `divisions` VALUES (431003, '苏仙区', 3, 431000, 25.80000, 113.03000, 0);
INSERT INTO `divisions` VALUES (431021, '桂阳县', 3, 431000, 25.73000, 112.73000, 0);
INSERT INTO `divisions` VALUES (431022, '宜章县', 3, 431000, 25.40000, 112.95000, 0);
INSERT INTO `divisions` VALUES (431023, '永兴县', 3, 431000, 26.13000, 113.10000, 0);
INSERT INTO `divisions` VALUES (431024, '嘉禾县', 3, 431000, 25.58000, 112.37000, 0);
INSERT INTO `divisions` VALUES (431025, '临武县', 3, 431000, 25.28000, 112.55000, 0);
INSERT INTO `divisions` VALUES (431026, '汝城县', 3, 431000, 25.55000, 113.68000, 0);
INSERT INTO `divisions` VALUES (431027, '桂东县', 3, 431000, 26.08000, 113.93000, 0);
INSERT INTO `divisions` VALUES (431028, '安仁县', 3, 431000, 26.70000, 113.27000, 0);
INSERT INTO `divisions` VALUES (431081, '资兴市', 3, 431100, 25.98000, 113.23000, 1);
INSERT INTO `divisions` VALUES (431100, '永州市', 2, 430000, 26.43000, 111.62000, 1);
INSERT INTO `divisions` VALUES (431101, '市辖区', 3, 431100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (431102, '零陵区', 3, 431100, 26.22000, 111.63000, 0);
INSERT INTO `divisions` VALUES (431103, '冷水滩区', 3, 431100, 26.43000, 111.60000, 0);
INSERT INTO `divisions` VALUES (431121, '祁阳县', 3, 431100, 26.58000, 111.85000, 0);
INSERT INTO `divisions` VALUES (431122, '东安县', 3, 431100, 26.40000, 111.28000, 0);
INSERT INTO `divisions` VALUES (431123, '双牌县', 3, 431100, 25.97000, 111.65000, 0);
INSERT INTO `divisions` VALUES (431124, '道县', 3, 431100, 25.53000, 111.58000, 0);
INSERT INTO `divisions` VALUES (431125, '江永县', 3, 431100, 25.28000, 111.33000, 0);
INSERT INTO `divisions` VALUES (431126, '宁远县', 3, 431100, 25.60000, 111.93000, 0);
INSERT INTO `divisions` VALUES (431127, '蓝山县', 3, 431100, 25.37000, 112.18000, 0);
INSERT INTO `divisions` VALUES (431128, '新田县', 3, 431100, 25.92000, 112.22000, 0);
INSERT INTO `divisions` VALUES (431129, '江华瑶族自治县', 3, 431100, 25.18000, 111.58000, 0);
INSERT INTO `divisions` VALUES (431200, '怀化市', 2, 430000, 27.57000, 110.00000, 1);
INSERT INTO `divisions` VALUES (431201, '市辖区', 3, 431200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (431202, '鹤城区', 3, 431200, 27.55000, 109.95000, 0);
INSERT INTO `divisions` VALUES (431221, '中方县', 3, 431200, 27.40000, 109.93000, 0);
INSERT INTO `divisions` VALUES (431222, '沅陵县', 3, 431200, 28.47000, 110.38000, 0);
INSERT INTO `divisions` VALUES (431223, '辰溪县', 3, 431200, 28.00000, 110.18000, 0);
INSERT INTO `divisions` VALUES (431224, '溆浦县', 3, 431200, 27.92000, 110.58000, 0);
INSERT INTO `divisions` VALUES (431225, '会同县', 3, 431200, 26.87000, 109.72000, 0);
INSERT INTO `divisions` VALUES (431226, '麻阳苗族自治县', 3, 431200, 27.87000, 109.80000, 0);
INSERT INTO `divisions` VALUES (431227, '新晃侗族自治县', 3, 431200, 27.37000, 109.17000, 0);
INSERT INTO `divisions` VALUES (431228, '芷江侗族自治县', 3, 431200, 27.45000, 109.68000, 0);
INSERT INTO `divisions` VALUES (431229, '靖州苗族侗族自治县', 3, 431200, 26.58000, 109.68000, 0);
INSERT INTO `divisions` VALUES (431230, '通道侗族自治县', 3, 431200, 26.17000, 109.78000, 0);
INSERT INTO `divisions` VALUES (431281, '洪江市', 3, 431300, 27.20000, 109.82000, 1);
INSERT INTO `divisions` VALUES (431300, '娄底市', 2, 430000, 27.73000, 112.00000, 1);
INSERT INTO `divisions` VALUES (431301, '市辖区', 3, 431300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (431302, '娄星区', 3, 431300, 27.73000, 112.00000, 0);
INSERT INTO `divisions` VALUES (431321, '双峰县', 3, 431300, 27.45000, 112.20000, 0);
INSERT INTO `divisions` VALUES (431322, '新化县', 3, 431300, 27.75000, 111.30000, 0);
INSERT INTO `divisions` VALUES (431381, '冷水江市', 3, 431400, 27.68000, 111.43000, 1);
INSERT INTO `divisions` VALUES (431382, '涟源市', 3, 431400, 27.70000, 111.67000, 1);
INSERT INTO `divisions` VALUES (433100, '湘西土家族苗族自治州', 2, 430000, 28.32000, 109.73000, 1);
INSERT INTO `divisions` VALUES (433101, '吉首市', 3, 433100, 28.32000, 109.73000, 1);
INSERT INTO `divisions` VALUES (433122, '泸溪县', 3, 433100, 28.22000, 110.22000, 0);
INSERT INTO `divisions` VALUES (433123, '凤凰县', 3, 433100, 27.95000, 109.60000, 0);
INSERT INTO `divisions` VALUES (433124, '花垣县', 3, 433100, 28.58000, 109.48000, 0);
INSERT INTO `divisions` VALUES (433125, '保靖县', 3, 433100, 28.72000, 109.65000, 0);
INSERT INTO `divisions` VALUES (433126, '古丈县', 3, 433100, 28.62000, 109.95000, 0);
INSERT INTO `divisions` VALUES (433127, '永顺县', 3, 433100, 29.00000, 109.85000, 0);
INSERT INTO `divisions` VALUES (433130, '龙山县', 3, 433100, 29.47000, 109.43000, 0);
INSERT INTO `divisions` VALUES (440000, '广东省', 1, 0, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (440100, '广州市', 2, 440000, 23.13000, 113.27000, 1);
INSERT INTO `divisions` VALUES (440101, '市辖区', 3, 440100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (440103, '荔湾区', 3, 440100, 23.13000, 113.23000, 0);
INSERT INTO `divisions` VALUES (440104, '越秀区', 3, 440100, 23.13000, 113.27000, 0);
INSERT INTO `divisions` VALUES (440105, '海珠区', 3, 440100, 23.10000, 113.25000, 0);
INSERT INTO `divisions` VALUES (440106, '天河区', 3, 440100, 23.12000, 113.35000, 0);
INSERT INTO `divisions` VALUES (440111, '白云区', 3, 440100, 26.68000, 106.65000, 0);
INSERT INTO `divisions` VALUES (440112, '黄埔区', 3, 440100, 23.10000, 113.45000, 0);
INSERT INTO `divisions` VALUES (440113, '番禺区', 3, 440100, 22.95000, 113.35000, 0);
INSERT INTO `divisions` VALUES (440114, '花都区', 3, 440100, 23.40000, 113.22000, 0);
INSERT INTO `divisions` VALUES (440115, '南沙区', 3, 440100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (440116, '萝岗区', 3, 440100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (440183, '增城市', 3, 440200, 23.30000, 113.83000, 1);
INSERT INTO `divisions` VALUES (440184, '从化市', 3, 440200, 23.55000, 113.58000, 1);
INSERT INTO `divisions` VALUES (440200, '韶关市', 2, 440000, 24.82000, 113.60000, 1);
INSERT INTO `divisions` VALUES (440201, '市辖区', 3, 440200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (440203, '武江区', 3, 440200, 24.80000, 113.57000, 0);
INSERT INTO `divisions` VALUES (440204, '浈江区', 3, 440200, 24.80000, 113.60000, 0);
INSERT INTO `divisions` VALUES (440205, '曲江区', 3, 440200, 24.68000, 113.60000, 0);
INSERT INTO `divisions` VALUES (440222, '始兴县', 3, 440200, 24.95000, 114.07000, 0);
INSERT INTO `divisions` VALUES (440224, '仁化县', 3, 440200, 25.08000, 113.75000, 0);
INSERT INTO `divisions` VALUES (440229, '翁源县', 3, 440200, 24.35000, 114.13000, 0);
INSERT INTO `divisions` VALUES (440232, '乳源瑶族自治县', 3, 440200, 24.78000, 113.27000, 0);
INSERT INTO `divisions` VALUES (440233, '新丰县', 3, 440200, 24.07000, 114.20000, 0);
INSERT INTO `divisions` VALUES (440281, '乐昌市', 3, 440300, 25.13000, 113.35000, 1);
INSERT INTO `divisions` VALUES (440282, '南雄市', 3, 440300, 25.12000, 114.30000, 1);
INSERT INTO `divisions` VALUES (440300, '深圳市', 2, 440000, 22.55000, 114.05000, 1);
INSERT INTO `divisions` VALUES (440301, '市辖区', 3, 440300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (440303, '罗湖区', 3, 440300, 22.55000, 114.12000, 0);
INSERT INTO `divisions` VALUES (440304, '福田区', 3, 440300, 22.53000, 114.05000, 0);
INSERT INTO `divisions` VALUES (440305, '南山区', 3, 440300, 22.52000, 113.92000, 0);
INSERT INTO `divisions` VALUES (440306, '宝安区', 3, 440300, 22.57000, 113.90000, 0);
INSERT INTO `divisions` VALUES (440307, '龙岗区', 3, 440300, 22.73000, 114.27000, 0);
INSERT INTO `divisions` VALUES (440308, '盐田区', 3, 440300, 22.55000, 114.22000, 0);
INSERT INTO `divisions` VALUES (440400, '珠海市', 2, 440000, 22.27000, 113.57000, 1);
INSERT INTO `divisions` VALUES (440401, '市辖区', 3, 440400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (440402, '香洲区', 3, 440400, 22.27000, 113.55000, 0);
INSERT INTO `divisions` VALUES (440403, '斗门区', 3, 440400, 22.22000, 113.28000, 0);
INSERT INTO `divisions` VALUES (440404, '金湾区', 3, 440400, 22.07000, 113.40000, 0);
INSERT INTO `divisions` VALUES (440500, '汕头市', 2, 440000, 23.35000, 116.68000, 1);
INSERT INTO `divisions` VALUES (440501, '市辖区', 3, 440500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (440507, '龙湖区', 3, 440500, 23.37000, 116.72000, 0);
INSERT INTO `divisions` VALUES (440511, '金平区', 3, 440500, 23.37000, 116.70000, 0);
INSERT INTO `divisions` VALUES (440512, '濠江区', 3, 440500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (440513, '潮阳区', 3, 440500, 23.27000, 116.60000, 0);
INSERT INTO `divisions` VALUES (440514, '潮南区', 3, 440500, 23.25000, 116.43000, 0);
INSERT INTO `divisions` VALUES (440515, '澄海区', 3, 440500, 23.48000, 116.77000, 0);
INSERT INTO `divisions` VALUES (440523, '南澳县', 3, 440500, 23.42000, 117.02000, 0);
INSERT INTO `divisions` VALUES (440600, '佛山市', 2, 440000, 23.02000, 113.12000, 1);
INSERT INTO `divisions` VALUES (440601, '市辖区', 3, 440600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (440604, '禅城区', 3, 440600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (440605, '南海区', 3, 440600, 23.03000, 113.15000, 0);
INSERT INTO `divisions` VALUES (440606, '顺德区', 3, 440600, 22.80000, 113.30000, 0);
INSERT INTO `divisions` VALUES (440607, '三水区', 3, 440600, 23.17000, 112.87000, 0);
INSERT INTO `divisions` VALUES (440608, '高明区', 3, 440600, 22.90000, 112.88000, 0);
INSERT INTO `divisions` VALUES (440700, '江门市', 2, 440000, 22.58000, 113.08000, 1);
INSERT INTO `divisions` VALUES (440701, '市辖区', 3, 440700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (440703, '蓬江区', 3, 440700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (440704, '江海区', 3, 440700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (440705, '新会区', 3, 440700, 22.47000, 113.03000, 0);
INSERT INTO `divisions` VALUES (440781, '台山市', 3, 440800, 22.25000, 112.78000, 1);
INSERT INTO `divisions` VALUES (440783, '开平市', 3, 440800, 22.38000, 112.67000, 1);
INSERT INTO `divisions` VALUES (440784, '鹤山市', 3, 440800, 22.77000, 112.97000, 1);
INSERT INTO `divisions` VALUES (440785, '恩平市', 3, 440800, 22.18000, 112.30000, 1);
INSERT INTO `divisions` VALUES (440800, '湛江市', 2, 440000, 21.27000, 110.35000, 1);
INSERT INTO `divisions` VALUES (440801, '市辖区', 3, 440800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (440802, '赤坎区', 3, 440800, 21.27000, 110.37000, 0);
INSERT INTO `divisions` VALUES (440803, '霞山区', 3, 440800, 21.20000, 110.40000, 0);
INSERT INTO `divisions` VALUES (440804, '坡头区', 3, 440800, 21.23000, 110.47000, 0);
INSERT INTO `divisions` VALUES (440811, '麻章区', 3, 440800, 21.27000, 110.32000, 0);
INSERT INTO `divisions` VALUES (440823, '遂溪县', 3, 440800, 21.38000, 110.25000, 0);
INSERT INTO `divisions` VALUES (440825, '徐闻县', 3, 440800, 20.33000, 110.17000, 0);
INSERT INTO `divisions` VALUES (440881, '廉江市', 3, 440900, 21.62000, 110.27000, 1);
INSERT INTO `divisions` VALUES (440882, '雷州市', 3, 440900, 20.92000, 110.08000, 1);
INSERT INTO `divisions` VALUES (440883, '吴川市', 3, 440900, 21.43000, 110.77000, 1);
INSERT INTO `divisions` VALUES (440900, '茂名市', 2, 440000, 21.67000, 110.92000, 1);
INSERT INTO `divisions` VALUES (440901, '市辖区', 3, 440900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (440902, '茂南区', 3, 440900, 21.63000, 110.92000, 0);
INSERT INTO `divisions` VALUES (440903, '茂港区', 3, 440900, 21.47000, 111.02000, 0);
INSERT INTO `divisions` VALUES (440923, '电白县', 3, 440900, 21.50000, 111.00000, 0);
INSERT INTO `divisions` VALUES (440981, '高州市', 3, 441000, 21.92000, 110.85000, 1);
INSERT INTO `divisions` VALUES (440982, '化州市', 3, 441000, 21.67000, 110.63000, 1);
INSERT INTO `divisions` VALUES (440983, '信宜市', 3, 441000, 22.35000, 110.95000, 1);
INSERT INTO `divisions` VALUES (441200, '肇庆市', 2, 440000, 23.05000, 112.47000, 1);
INSERT INTO `divisions` VALUES (441201, '市辖区', 3, 441200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (441202, '端州区', 3, 441200, 23.05000, 112.48000, 0);
INSERT INTO `divisions` VALUES (441203, '鼎湖区', 3, 441200, 23.17000, 112.57000, 0);
INSERT INTO `divisions` VALUES (441223, '广宁县', 3, 441200, 23.63000, 112.43000, 0);
INSERT INTO `divisions` VALUES (441224, '怀集县', 3, 441200, 23.92000, 112.18000, 0);
INSERT INTO `divisions` VALUES (441225, '封开县', 3, 441200, 23.43000, 111.50000, 0);
INSERT INTO `divisions` VALUES (441226, '德庆县', 3, 441200, 23.15000, 111.77000, 0);
INSERT INTO `divisions` VALUES (441283, '高要市', 3, 441300, 23.03000, 112.45000, 1);
INSERT INTO `divisions` VALUES (441284, '四会市', 3, 441300, 23.33000, 112.68000, 1);
INSERT INTO `divisions` VALUES (441300, '惠州市', 2, 440000, 23.12000, 114.42000, 1);
INSERT INTO `divisions` VALUES (441301, '市辖区', 3, 441300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (441302, '惠城区', 3, 441300, 23.08000, 114.40000, 0);
INSERT INTO `divisions` VALUES (441303, '惠阳区', 3, 441300, 22.80000, 114.47000, 0);
INSERT INTO `divisions` VALUES (441322, '博罗县', 3, 441300, 23.18000, 114.28000, 0);
INSERT INTO `divisions` VALUES (441323, '惠东县', 3, 441300, 22.98000, 114.72000, 0);
INSERT INTO `divisions` VALUES (441324, '龙门县', 3, 441300, 23.73000, 114.25000, 0);
INSERT INTO `divisions` VALUES (441400, '梅州市', 2, 440000, 24.28000, 116.12000, 1);
INSERT INTO `divisions` VALUES (441401, '市辖区', 3, 441400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (441402, '梅江区', 3, 441400, 24.32000, 116.12000, 0);
INSERT INTO `divisions` VALUES (441421, '梅县', 3, 441400, 24.28000, 116.05000, 0);
INSERT INTO `divisions` VALUES (441422, '大埔县', 3, 441400, 24.35000, 116.70000, 0);
INSERT INTO `divisions` VALUES (441423, '丰顺县', 3, 441400, 23.77000, 116.18000, 0);
INSERT INTO `divisions` VALUES (441424, '五华县', 3, 441400, 23.93000, 115.77000, 0);
INSERT INTO `divisions` VALUES (441426, '平远县', 3, 441400, 24.57000, 115.88000, 0);
INSERT INTO `divisions` VALUES (441427, '蕉岭县', 3, 441400, 24.67000, 116.17000, 0);
INSERT INTO `divisions` VALUES (441481, '兴宁市', 3, 441500, 24.15000, 115.73000, 1);
INSERT INTO `divisions` VALUES (441500, '汕尾市', 2, 440000, 22.78000, 115.37000, 1);
INSERT INTO `divisions` VALUES (441501, '市辖区', 3, 441500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (441502, '城区', 3, 441500, 35.50000, 112.83000, 0);
INSERT INTO `divisions` VALUES (441521, '海丰县', 3, 441500, 22.97000, 115.33000, 0);
INSERT INTO `divisions` VALUES (441523, '陆河县', 3, 441500, 23.30000, 115.65000, 0);
INSERT INTO `divisions` VALUES (441581, '陆丰市', 3, 441600, 22.95000, 115.65000, 1);
INSERT INTO `divisions` VALUES (441600, '河源市', 2, 440000, 23.73000, 114.70000, 1);
INSERT INTO `divisions` VALUES (441601, '市辖区', 3, 441600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (441602, '源城区', 3, 441600, 23.73000, 114.70000, 0);
INSERT INTO `divisions` VALUES (441621, '紫金县', 3, 441600, 23.63000, 115.18000, 0);
INSERT INTO `divisions` VALUES (441622, '龙川县', 3, 441600, 24.10000, 115.25000, 0);
INSERT INTO `divisions` VALUES (441623, '连平县', 3, 441600, 24.37000, 114.48000, 0);
INSERT INTO `divisions` VALUES (441624, '和平县', 3, 441600, 24.45000, 114.93000, 0);
INSERT INTO `divisions` VALUES (441625, '东源县', 3, 441600, 23.82000, 114.77000, 0);
INSERT INTO `divisions` VALUES (441700, '阳江市', 2, 440000, 21.87000, 111.98000, 1);
INSERT INTO `divisions` VALUES (441701, '市辖区', 3, 441700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (441702, '江城区', 3, 441700, 21.87000, 111.95000, 0);
INSERT INTO `divisions` VALUES (441721, '阳西县', 3, 441700, 21.75000, 111.62000, 0);
INSERT INTO `divisions` VALUES (441723, '阳东县', 3, 441700, 21.88000, 112.02000, 0);
INSERT INTO `divisions` VALUES (441781, '阳春市', 3, 441800, 22.18000, 111.78000, 1);
INSERT INTO `divisions` VALUES (441800, '清远市', 2, 440000, 23.70000, 113.03000, 1);
INSERT INTO `divisions` VALUES (441801, '市辖区', 3, 441800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (441802, '清城区', 3, 441800, 23.70000, 113.02000, 0);
INSERT INTO `divisions` VALUES (441821, '佛冈县', 3, 441800, 23.88000, 113.53000, 0);
INSERT INTO `divisions` VALUES (441823, '阳山县', 3, 441800, 24.48000, 112.63000, 0);
INSERT INTO `divisions` VALUES (441825, '连山壮族瑶族自治县', 3, 441800, 24.57000, 112.08000, 0);
INSERT INTO `divisions` VALUES (441826, '连南瑶族自治县', 3, 441800, 24.72000, 112.28000, 0);
INSERT INTO `divisions` VALUES (441827, '清新县', 3, 441800, 23.73000, 112.98000, 0);
INSERT INTO `divisions` VALUES (441881, '英德市', 3, 441900, 24.18000, 113.40000, 1);
INSERT INTO `divisions` VALUES (441882, '连州市', 3, 441900, 24.78000, 112.38000, 1);
INSERT INTO `divisions` VALUES (441900, '东莞市', 2, 440000, 23.05000, 113.75000, 1);
INSERT INTO `divisions` VALUES (442000, '中山市', 2, 440000, 22.52000, 113.38000, 1);
INSERT INTO `divisions` VALUES (445100, '潮州市', 2, 450000, 23.67000, 116.62000, 1);
INSERT INTO `divisions` VALUES (445101, '市辖区', 3, 445100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (445102, '湘桥区', 3, 445100, 23.68000, 116.63000, 0);
INSERT INTO `divisions` VALUES (445121, '潮安县', 3, 445100, 23.45000, 116.68000, 0);
INSERT INTO `divisions` VALUES (445122, '饶平县', 3, 445100, 23.67000, 117.00000, 0);
INSERT INTO `divisions` VALUES (445200, '揭阳市', 2, 450000, 23.55000, 116.37000, 1);
INSERT INTO `divisions` VALUES (445201, '市辖区', 3, 445200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (445202, '榕城区', 3, 445200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (445221, '揭东县', 3, 445200, 23.57000, 116.42000, 0);
INSERT INTO `divisions` VALUES (445222, '揭西县', 3, 445200, 23.43000, 115.83000, 0);
INSERT INTO `divisions` VALUES (445224, '惠来县', 3, 445200, 23.03000, 116.28000, 0);
INSERT INTO `divisions` VALUES (445281, '普宁市', 3, 445300, 23.30000, 116.18000, 1);
INSERT INTO `divisions` VALUES (445300, '云浮市', 2, 450000, 22.92000, 112.03000, 1);
INSERT INTO `divisions` VALUES (445301, '市辖区', 3, 445300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (445302, '云城区', 3, 445300, 22.93000, 112.03000, 0);
INSERT INTO `divisions` VALUES (445321, '新兴县', 3, 445300, 22.70000, 112.23000, 0);
INSERT INTO `divisions` VALUES (445322, '郁南县', 3, 445300, 23.23000, 111.53000, 0);
INSERT INTO `divisions` VALUES (445323, '云安县', 3, 445300, 23.08000, 112.00000, 0);
INSERT INTO `divisions` VALUES (445381, '罗定市', 3, 445400, 22.77000, 111.57000, 1);
INSERT INTO `divisions` VALUES (450000, '广西壮族自治区', 1, 0, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450100, '南宁市', 2, 450000, 22.82000, 108.37000, 1);
INSERT INTO `divisions` VALUES (450101, '市辖区', 3, 450100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450102, '兴宁区', 3, 450100, 22.87000, 108.38000, 0);
INSERT INTO `divisions` VALUES (450103, '青秀区', 3, 450100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450105, '江南区', 3, 450100, 22.78000, 108.28000, 0);
INSERT INTO `divisions` VALUES (450107, '西乡塘区', 3, 450100, 22.83000, 108.30000, 0);
INSERT INTO `divisions` VALUES (450108, '良庆区', 3, 450100, 22.77000, 108.32000, 0);
INSERT INTO `divisions` VALUES (450109, '邕宁区', 3, 450100, 22.75000, 108.48000, 0);
INSERT INTO `divisions` VALUES (450122, '武鸣县', 3, 450100, 23.17000, 108.27000, 0);
INSERT INTO `divisions` VALUES (450123, '隆安县', 3, 450100, 23.18000, 107.68000, 0);
INSERT INTO `divisions` VALUES (450124, '马山县', 3, 450100, 23.72000, 108.17000, 0);
INSERT INTO `divisions` VALUES (450125, '上林县', 3, 450100, 23.43000, 108.60000, 0);
INSERT INTO `divisions` VALUES (450126, '宾阳县', 3, 450100, 23.22000, 108.80000, 0);
INSERT INTO `divisions` VALUES (450127, '横县', 3, 450100, 22.68000, 109.27000, 0);
INSERT INTO `divisions` VALUES (450200, '柳州市', 2, 450000, 24.33000, 109.42000, 1);
INSERT INTO `divisions` VALUES (450201, '市辖区', 3, 450200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450202, '城中区', 3, 450200, 36.62000, 101.78000, 0);
INSERT INTO `divisions` VALUES (450203, '鱼峰区', 3, 450200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450204, '柳南区', 3, 450200, 24.35000, 109.38000, 0);
INSERT INTO `divisions` VALUES (450205, '柳北区', 3, 450200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450221, '柳江县', 3, 450200, 24.27000, 109.33000, 0);
INSERT INTO `divisions` VALUES (450222, '柳城县', 3, 450200, 24.65000, 109.23000, 0);
INSERT INTO `divisions` VALUES (450223, '鹿寨县', 3, 450200, 24.48000, 109.73000, 0);
INSERT INTO `divisions` VALUES (450224, '融安县', 3, 450200, 25.23000, 109.40000, 0);
INSERT INTO `divisions` VALUES (450225, '融水苗族自治县', 3, 450200, 25.07000, 109.25000, 0);
INSERT INTO `divisions` VALUES (450226, '三江侗族自治县', 3, 450200, 25.78000, 109.60000, 0);
INSERT INTO `divisions` VALUES (450300, '桂林市', 2, 450000, 25.28000, 110.28000, 1);
INSERT INTO `divisions` VALUES (450301, '市辖区', 3, 450300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450302, '秀峰区', 3, 450300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450303, '叠彩区', 3, 450300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450304, '象山区', 3, 450300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450305, '七星区', 3, 450300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450311, '雁山区', 3, 450300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450321, '阳朔县', 3, 450300, 24.78000, 110.48000, 0);
INSERT INTO `divisions` VALUES (450322, '临桂县', 3, 450300, 25.23000, 110.20000, 0);
INSERT INTO `divisions` VALUES (450323, '灵川县', 3, 450300, 25.42000, 110.32000, 0);
INSERT INTO `divisions` VALUES (450324, '全州县', 3, 450300, 25.93000, 111.07000, 0);
INSERT INTO `divisions` VALUES (450325, '兴安县', 3, 450300, 25.62000, 110.67000, 0);
INSERT INTO `divisions` VALUES (450326, '永福县', 3, 450300, 24.98000, 109.98000, 0);
INSERT INTO `divisions` VALUES (450327, '灌阳县', 3, 450300, 25.48000, 111.15000, 0);
INSERT INTO `divisions` VALUES (450328, '龙胜各族自治县', 3, 450300, 25.80000, 110.00000, 0);
INSERT INTO `divisions` VALUES (450329, '资源县', 3, 450300, 26.03000, 110.63000, 0);
INSERT INTO `divisions` VALUES (450330, '平乐县', 3, 450300, 24.63000, 110.63000, 0);
INSERT INTO `divisions` VALUES (450331, '荔浦县', 3, 450300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450332, '恭城瑶族自治县', 3, 450300, 24.83000, 110.83000, 0);
INSERT INTO `divisions` VALUES (450400, '梧州市', 2, 450000, 23.48000, 111.27000, 1);
INSERT INTO `divisions` VALUES (450401, '市辖区', 3, 450400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450403, '万秀区', 3, 450400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450404, '蝶山区', 3, 450400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450405, '长洲区', 3, 450400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450421, '苍梧县', 3, 450400, 23.42000, 111.23000, 0);
INSERT INTO `divisions` VALUES (450422, '藤县', 3, 450400, 23.38000, 110.92000, 0);
INSERT INTO `divisions` VALUES (450423, '蒙山县', 3, 450400, 24.20000, 110.52000, 0);
INSERT INTO `divisions` VALUES (450481, '岑溪市', 3, 450500, 22.92000, 110.98000, 1);
INSERT INTO `divisions` VALUES (450500, '北海市', 2, 450000, 21.48000, 109.12000, 1);
INSERT INTO `divisions` VALUES (450501, '市辖区', 3, 450500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450502, '海城区', 3, 450500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450503, '银海区', 3, 450500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450512, '铁山港区', 3, 450500, 21.53000, 109.43000, 0);
INSERT INTO `divisions` VALUES (450521, '合浦县', 3, 450500, 21.67000, 109.20000, 0);
INSERT INTO `divisions` VALUES (450600, '防城港市', 2, 450000, 21.70000, 108.35000, 1);
INSERT INTO `divisions` VALUES (450601, '市辖区', 3, 450600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450602, '港口区', 3, 450600, 21.65000, 108.37000, 0);
INSERT INTO `divisions` VALUES (450603, '防城区', 3, 450600, 21.77000, 108.35000, 0);
INSERT INTO `divisions` VALUES (450621, '上思县', 3, 450600, 22.15000, 107.98000, 0);
INSERT INTO `divisions` VALUES (450681, '东兴市', 3, 450700, 21.53000, 107.97000, 1);
INSERT INTO `divisions` VALUES (450700, '钦州市', 2, 450000, 21.95000, 108.62000, 1);
INSERT INTO `divisions` VALUES (450701, '市辖区', 3, 450700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450702, '钦南区', 3, 450700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450703, '钦北区', 3, 450700, 21.98000, 108.63000, 0);
INSERT INTO `divisions` VALUES (450721, '灵山县', 3, 450700, 22.43000, 109.30000, 0);
INSERT INTO `divisions` VALUES (450722, '浦北县', 3, 450700, 22.27000, 109.55000, 0);
INSERT INTO `divisions` VALUES (450800, '贵港市', 2, 450000, 23.10000, 109.60000, 1);
INSERT INTO `divisions` VALUES (450801, '市辖区', 3, 450800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450802, '港北区', 3, 450800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450803, '港南区', 3, 450800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450804, '覃塘区', 3, 450800, 23.13000, 109.42000, 0);
INSERT INTO `divisions` VALUES (450821, '平南县', 3, 450800, 23.55000, 110.38000, 0);
INSERT INTO `divisions` VALUES (450881, '桂平市', 3, 450900, 23.40000, 110.08000, 1);
INSERT INTO `divisions` VALUES (450900, '玉林市', 2, 450000, 22.63000, 110.17000, 1);
INSERT INTO `divisions` VALUES (450901, '市辖区', 3, 450900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450902, '玉州区', 3, 450900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (450921, '容县', 3, 450900, 22.87000, 110.55000, 0);
INSERT INTO `divisions` VALUES (450922, '陆川县', 3, 450900, 22.33000, 110.27000, 0);
INSERT INTO `divisions` VALUES (450923, '博白县', 3, 450900, 22.28000, 109.97000, 0);
INSERT INTO `divisions` VALUES (450924, '兴业县', 3, 450900, 22.75000, 109.87000, 0);
INSERT INTO `divisions` VALUES (450981, '北流市', 3, 451000, 22.72000, 110.35000, 1);
INSERT INTO `divisions` VALUES (451000, '百色市', 2, 450000, 23.90000, 106.62000, 1);
INSERT INTO `divisions` VALUES (451001, '市辖区', 3, 451000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (451002, '右江区', 3, 451000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (451021, '田阳县', 3, 451000, 23.73000, 106.92000, 0);
INSERT INTO `divisions` VALUES (451022, '田东县', 3, 451000, 23.60000, 107.12000, 0);
INSERT INTO `divisions` VALUES (451023, '平果县', 3, 451000, 23.32000, 107.58000, 0);
INSERT INTO `divisions` VALUES (451024, '德保县', 3, 451000, 23.33000, 106.62000, 0);
INSERT INTO `divisions` VALUES (451025, '靖西县', 3, 451000, 23.13000, 106.42000, 0);
INSERT INTO `divisions` VALUES (451026, '那坡县', 3, 451000, 23.42000, 105.83000, 0);
INSERT INTO `divisions` VALUES (451027, '凌云县', 3, 451000, 24.35000, 106.57000, 0);
INSERT INTO `divisions` VALUES (451028, '乐业县', 3, 451000, 24.78000, 106.55000, 0);
INSERT INTO `divisions` VALUES (451029, '田林县', 3, 451000, 24.30000, 106.23000, 0);
INSERT INTO `divisions` VALUES (451030, '西林县', 3, 451000, 24.50000, 105.10000, 0);
INSERT INTO `divisions` VALUES (451031, '隆林各族自治县', 3, 451000, 24.77000, 105.33000, 0);
INSERT INTO `divisions` VALUES (451100, '贺州市', 2, 450000, 24.42000, 111.55000, 1);
INSERT INTO `divisions` VALUES (451101, '市辖区', 3, 451100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (451102, '八步区', 3, 451100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (451121, '昭平县', 3, 451100, 24.17000, 110.80000, 0);
INSERT INTO `divisions` VALUES (451122, '钟山县', 3, 451100, 24.53000, 111.30000, 0);
INSERT INTO `divisions` VALUES (451123, '富川瑶族自治县', 3, 451100, 24.83000, 111.27000, 0);
INSERT INTO `divisions` VALUES (451200, '河池市', 2, 450000, 24.70000, 108.07000, 1);
INSERT INTO `divisions` VALUES (451201, '市辖区', 3, 451200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (451202, '金城江区', 3, 451200, 24.70000, 108.05000, 0);
INSERT INTO `divisions` VALUES (451221, '南丹县', 3, 451200, 24.98000, 107.53000, 0);
INSERT INTO `divisions` VALUES (451222, '天峨县', 3, 451200, 25.00000, 107.17000, 0);
INSERT INTO `divisions` VALUES (451223, '凤山县', 3, 451200, 24.55000, 107.05000, 0);
INSERT INTO `divisions` VALUES (451224, '东兰县', 3, 451200, 24.52000, 107.37000, 0);
INSERT INTO `divisions` VALUES (451225, '罗城仫佬族自治县', 3, 451200, 24.78000, 108.90000, 0);
INSERT INTO `divisions` VALUES (451226, '环江毛南族自治县', 3, 451200, 24.83000, 108.25000, 0);
INSERT INTO `divisions` VALUES (451227, '巴马瑶族自治县', 3, 451200, 24.15000, 107.25000, 0);
INSERT INTO `divisions` VALUES (451228, '都安瑶族自治县', 3, 451200, 23.93000, 108.10000, 0);
INSERT INTO `divisions` VALUES (451229, '大化瑶族自治县', 3, 451200, 23.73000, 107.98000, 0);
INSERT INTO `divisions` VALUES (451281, '宜州市', 3, 451300, 24.50000, 108.67000, 1);
INSERT INTO `divisions` VALUES (451300, '来宾市', 2, 450000, 23.73000, 109.23000, 1);
INSERT INTO `divisions` VALUES (451301, '市辖区', 3, 451300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (451302, '兴宾区', 3, 451300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (451321, '忻城县', 3, 451300, 24.07000, 108.67000, 0);
INSERT INTO `divisions` VALUES (451322, '象州县', 3, 451300, 23.97000, 109.68000, 0);
INSERT INTO `divisions` VALUES (451323, '武宣县', 3, 451300, 23.60000, 109.67000, 0);
INSERT INTO `divisions` VALUES (451324, '金秀瑶族自治县', 3, 451300, 24.13000, 110.18000, 0);
INSERT INTO `divisions` VALUES (451381, '合山市', 3, 451400, 23.82000, 108.87000, 1);
INSERT INTO `divisions` VALUES (451400, '崇左市', 2, 450000, 22.40000, 107.37000, 1);
INSERT INTO `divisions` VALUES (451401, '市辖区', 3, 451400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (451402, '江洲区', 3, 451400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (451421, '扶绥县', 3, 451400, 22.63000, 107.90000, 0);
INSERT INTO `divisions` VALUES (451422, '宁明县', 3, 451400, 22.13000, 107.07000, 0);
INSERT INTO `divisions` VALUES (451423, '龙州县', 3, 451400, 22.35000, 106.85000, 0);
INSERT INTO `divisions` VALUES (451424, '大新县', 3, 451400, 22.83000, 107.20000, 0);
INSERT INTO `divisions` VALUES (451425, '天等县', 3, 451400, 23.08000, 107.13000, 0);
INSERT INTO `divisions` VALUES (451481, '凭祥市', 3, 451500, 22.12000, 106.75000, 1);
INSERT INTO `divisions` VALUES (460000, '海南省', 1, 0, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (460100, '海口市', 2, 460000, 20.03000, 110.32000, 1);
INSERT INTO `divisions` VALUES (460101, '市辖区', 3, 460100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (460105, '秀英区', 3, 460100, 20.02000, 110.28000, 0);
INSERT INTO `divisions` VALUES (460106, '龙华区', 3, 460100, 20.03000, 110.30000, 0);
INSERT INTO `divisions` VALUES (460107, '琼山区', 3, 460100, 20.00000, 110.35000, 0);
INSERT INTO `divisions` VALUES (460108, '美兰区', 3, 460100, 20.03000, 110.37000, 0);
INSERT INTO `divisions` VALUES (460200, '三亚市', 2, 460000, 18.25000, 109.50000, 1);
INSERT INTO `divisions` VALUES (460201, '市辖区', 3, 460200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (460300, '三沙市', 2, 460000, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (460321, '西沙群岛', 3, 460300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (460322, '南沙群岛', 3, 460300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (460323, '中沙群岛的岛礁及其海域', 3, 460300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (469000, '省直辖县级行政区划', 2, 470000, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (469001, '五指山市', 3, 469000, 18.78000, 109.52000, 1);
INSERT INTO `divisions` VALUES (469002, '琼海市', 3, 469000, 19.25000, 110.47000, 1);
INSERT INTO `divisions` VALUES (469003, '儋州市', 3, 469000, 19.52000, 109.57000, 1);
INSERT INTO `divisions` VALUES (469005, '文昌市', 3, 469000, 19.55000, 110.80000, 1);
INSERT INTO `divisions` VALUES (469006, '万宁市', 3, 469000, 18.80000, 110.40000, 1);
INSERT INTO `divisions` VALUES (469007, '东方市', 3, 469000, 19.10000, 108.63000, 1);
INSERT INTO `divisions` VALUES (469021, '定安县', 3, 469000, 19.70000, 110.32000, 0);
INSERT INTO `divisions` VALUES (469022, '屯昌县', 3, 469000, 19.37000, 110.10000, 0);
INSERT INTO `divisions` VALUES (469023, '澄迈县', 3, 469000, 19.73000, 110.00000, 0);
INSERT INTO `divisions` VALUES (469024, '临高县', 3, 469000, 19.92000, 109.68000, 0);
INSERT INTO `divisions` VALUES (469025, '白沙黎族自治县', 3, 469000, 19.23000, 109.45000, 0);
INSERT INTO `divisions` VALUES (469026, '昌江黎族自治县', 3, 469000, 19.25000, 109.05000, 0);
INSERT INTO `divisions` VALUES (469027, '乐东黎族自治县', 3, 469000, 18.75000, 109.17000, 0);
INSERT INTO `divisions` VALUES (469028, '陵水黎族自治县', 3, 469000, 18.50000, 110.03000, 0);
INSERT INTO `divisions` VALUES (469029, '保亭黎族苗族自治县', 3, 469000, 18.63000, 109.70000, 0);
INSERT INTO `divisions` VALUES (469030, '琼中黎族苗族自治县', 3, 469000, 19.03000, 109.83000, 0);
INSERT INTO `divisions` VALUES (500000, '重庆市', 1, 0, 29.57000, 106.55000, 1);
INSERT INTO `divisions` VALUES (500100, '市辖区', 2, 500000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (500101, '万州区', 3, 500100, 30.82000, 108.40000, 0);
INSERT INTO `divisions` VALUES (500102, '涪陵区', 3, 500100, 29.72000, 107.40000, 0);
INSERT INTO `divisions` VALUES (500103, '渝中区', 3, 500100, 29.55000, 106.57000, 0);
INSERT INTO `divisions` VALUES (500104, '大渡口区', 3, 500100, 29.48000, 106.48000, 0);
INSERT INTO `divisions` VALUES (500105, '江北区', 3, 500100, 29.60000, 106.57000, 0);
INSERT INTO `divisions` VALUES (500106, '沙坪坝区', 3, 500100, 29.53000, 106.45000, 0);
INSERT INTO `divisions` VALUES (500107, '九龙坡区', 3, 500100, 29.50000, 106.50000, 0);
INSERT INTO `divisions` VALUES (500108, '南岸区', 3, 500100, 29.52000, 106.57000, 0);
INSERT INTO `divisions` VALUES (500109, '北碚区', 3, 500100, 29.80000, 106.40000, 0);
INSERT INTO `divisions` VALUES (500110, '綦江区', 3, 500100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (500111, '大足区', 3, 500100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (500112, '渝北区', 3, 500100, 29.72000, 106.63000, 0);
INSERT INTO `divisions` VALUES (500113, '巴南区', 3, 500100, 29.38000, 106.52000, 0);
INSERT INTO `divisions` VALUES (500114, '黔江区', 3, 500100, 29.53000, 108.77000, 0);
INSERT INTO `divisions` VALUES (500115, '长寿区', 3, 500100, 29.87000, 107.08000, 0);
INSERT INTO `divisions` VALUES (500116, '江津区', 3, 500100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (500117, '合川区', 3, 500100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (500118, '永川区', 3, 500100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (500119, '南川区', 3, 500100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (500200, '县', 2, 500000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (500223, '潼南县', 3, 500200, 30.18000, 105.83000, 0);
INSERT INTO `divisions` VALUES (500224, '铜梁县', 3, 500200, 29.85000, 106.05000, 0);
INSERT INTO `divisions` VALUES (500226, '荣昌县', 3, 500200, 29.40000, 105.58000, 0);
INSERT INTO `divisions` VALUES (500227, '璧山县', 3, 500200, 29.60000, 106.22000, 0);
INSERT INTO `divisions` VALUES (500228, '梁平县', 3, 500200, 30.68000, 107.80000, 0);
INSERT INTO `divisions` VALUES (500229, '城口县', 3, 500200, 31.95000, 108.67000, 0);
INSERT INTO `divisions` VALUES (500230, '丰都县', 3, 500200, 29.87000, 107.73000, 0);
INSERT INTO `divisions` VALUES (500231, '垫江县', 3, 500200, 30.33000, 107.35000, 0);
INSERT INTO `divisions` VALUES (500232, '武隆县', 3, 500200, 29.33000, 107.75000, 0);
INSERT INTO `divisions` VALUES (500233, '忠县', 3, 500200, 30.30000, 108.02000, 0);
INSERT INTO `divisions` VALUES (500234, '开县', 3, 500200, 31.18000, 108.42000, 0);
INSERT INTO `divisions` VALUES (500235, '云阳县', 3, 500200, 30.95000, 108.67000, 0);
INSERT INTO `divisions` VALUES (500236, '奉节县', 3, 500200, 31.02000, 109.47000, 0);
INSERT INTO `divisions` VALUES (500237, '巫山县', 3, 500200, 31.08000, 109.88000, 0);
INSERT INTO `divisions` VALUES (500238, '巫溪县', 3, 500200, 31.40000, 109.63000, 0);
INSERT INTO `divisions` VALUES (500240, '石柱土家族自治县', 3, 500200, 30.00000, 108.12000, 0);
INSERT INTO `divisions` VALUES (500241, '秀山土家族苗族自治县', 3, 500200, 28.45000, 108.98000, 0);
INSERT INTO `divisions` VALUES (500242, '酉阳土家族苗族自治县', 3, 500200, 28.85000, 108.77000, 0);
INSERT INTO `divisions` VALUES (500243, '彭水苗族土家族自治县', 3, 500200, 29.30000, 108.17000, 0);
INSERT INTO `divisions` VALUES (510000, '四川省', 1, 0, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (510100, '成都市', 2, 510000, 30.67000, 104.07000, 1);
INSERT INTO `divisions` VALUES (510101, '市辖区', 3, 510100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (510104, '锦江区', 3, 510100, 30.67000, 104.08000, 0);
INSERT INTO `divisions` VALUES (510105, '青羊区', 3, 510100, 30.68000, 104.05000, 0);
INSERT INTO `divisions` VALUES (510106, '金牛区', 3, 510100, 30.70000, 104.05000, 0);
INSERT INTO `divisions` VALUES (510107, '武侯区', 3, 510100, 30.65000, 104.05000, 0);
INSERT INTO `divisions` VALUES (510108, '成华区', 3, 510100, 30.67000, 104.10000, 0);
INSERT INTO `divisions` VALUES (510112, '龙泉驿区', 3, 510100, 30.57000, 104.27000, 0);
INSERT INTO `divisions` VALUES (510113, '青白江区', 3, 510100, 30.88000, 104.23000, 0);
INSERT INTO `divisions` VALUES (510114, '新都区', 3, 510100, 30.83000, 104.15000, 0);
INSERT INTO `divisions` VALUES (510115, '温江区', 3, 510100, 30.70000, 103.83000, 0);
INSERT INTO `divisions` VALUES (510121, '金堂县', 3, 510100, 30.85000, 104.43000, 0);
INSERT INTO `divisions` VALUES (510122, '双流县', 3, 510100, 30.58000, 103.92000, 0);
INSERT INTO `divisions` VALUES (510124, '郫县', 3, 510100, 30.82000, 103.88000, 0);
INSERT INTO `divisions` VALUES (510129, '大邑县', 3, 510100, 30.58000, 103.52000, 0);
INSERT INTO `divisions` VALUES (510131, '蒲江县', 3, 510100, 30.20000, 103.50000, 0);
INSERT INTO `divisions` VALUES (510132, '新津县', 3, 510100, 30.42000, 103.82000, 0);
INSERT INTO `divisions` VALUES (510181, '都江堰市', 3, 510200, 31.00000, 103.62000, 1);
INSERT INTO `divisions` VALUES (510182, '彭州市', 3, 510200, 30.98000, 103.93000, 1);
INSERT INTO `divisions` VALUES (510183, '邛崃市', 3, 510200, 30.42000, 103.47000, 1);
INSERT INTO `divisions` VALUES (510184, '崇州市', 3, 510200, 30.63000, 103.67000, 1);
INSERT INTO `divisions` VALUES (510300, '自贡市', 2, 510000, 29.35000, 104.78000, 1);
INSERT INTO `divisions` VALUES (510301, '市辖区', 3, 510300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (510302, '自流井区', 3, 510300, 29.35000, 104.77000, 0);
INSERT INTO `divisions` VALUES (510303, '贡井区', 3, 510300, 29.35000, 104.72000, 0);
INSERT INTO `divisions` VALUES (510304, '大安区', 3, 510300, 29.37000, 104.77000, 0);
INSERT INTO `divisions` VALUES (510311, '沿滩区', 3, 510300, 29.27000, 104.87000, 0);
INSERT INTO `divisions` VALUES (510321, '荣县', 3, 510300, 29.47000, 104.42000, 0);
INSERT INTO `divisions` VALUES (510322, '富顺县', 3, 510300, 29.18000, 104.98000, 0);
INSERT INTO `divisions` VALUES (510400, '攀枝花市', 2, 510000, 26.58000, 101.72000, 1);
INSERT INTO `divisions` VALUES (510401, '市辖区', 3, 510400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (510402, '东区', 3, 510400, 26.55000, 101.70000, 0);
INSERT INTO `divisions` VALUES (510403, '西区', 3, 510400, 26.60000, 101.60000, 0);
INSERT INTO `divisions` VALUES (510411, '仁和区', 3, 510400, 26.50000, 101.73000, 0);
INSERT INTO `divisions` VALUES (510421, '米易县', 3, 510400, 26.88000, 102.12000, 0);
INSERT INTO `divisions` VALUES (510422, '盐边县', 3, 510400, 26.70000, 101.85000, 0);
INSERT INTO `divisions` VALUES (510500, '泸州市', 2, 510000, 28.87000, 105.43000, 1);
INSERT INTO `divisions` VALUES (510501, '市辖区', 3, 510500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (510502, '江阳区', 3, 510500, 28.88000, 105.45000, 0);
INSERT INTO `divisions` VALUES (510503, '纳溪区', 3, 510500, 28.77000, 105.37000, 0);
INSERT INTO `divisions` VALUES (510504, '龙马潭区', 3, 510500, 28.90000, 105.43000, 0);
INSERT INTO `divisions` VALUES (510521, '泸县', 3, 510500, 29.15000, 105.38000, 0);
INSERT INTO `divisions` VALUES (510522, '合江县', 3, 510500, 28.82000, 105.83000, 0);
INSERT INTO `divisions` VALUES (510524, '叙永县', 3, 510500, 28.17000, 105.43000, 0);
INSERT INTO `divisions` VALUES (510525, '古蔺县', 3, 510500, 28.05000, 105.82000, 0);
INSERT INTO `divisions` VALUES (510600, '德阳市', 2, 510000, 31.13000, 104.38000, 1);
INSERT INTO `divisions` VALUES (510601, '市辖区', 3, 510600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (510603, '旌阳区', 3, 510600, 31.13000, 104.38000, 0);
INSERT INTO `divisions` VALUES (510623, '中江县', 3, 510600, 31.03000, 104.68000, 0);
INSERT INTO `divisions` VALUES (510626, '罗江县', 3, 510600, 31.32000, 104.50000, 0);
INSERT INTO `divisions` VALUES (510681, '广汉市', 3, 510700, 30.98000, 104.28000, 1);
INSERT INTO `divisions` VALUES (510682, '什邡市', 3, 510700, 31.13000, 104.17000, 1);
INSERT INTO `divisions` VALUES (510683, '绵竹市', 3, 510700, 31.35000, 104.20000, 1);
INSERT INTO `divisions` VALUES (510700, '绵阳市', 2, 510000, 31.47000, 104.73000, 1);
INSERT INTO `divisions` VALUES (510701, '市辖区', 3, 510700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (510703, '涪城区', 3, 510700, 31.47000, 104.73000, 0);
INSERT INTO `divisions` VALUES (510704, '游仙区', 3, 510700, 31.47000, 104.75000, 0);
INSERT INTO `divisions` VALUES (510722, '三台县', 3, 510700, 31.10000, 105.08000, 0);
INSERT INTO `divisions` VALUES (510723, '盐亭县', 3, 510700, 31.22000, 105.38000, 0);
INSERT INTO `divisions` VALUES (510724, '安县', 3, 510700, 31.53000, 104.57000, 0);
INSERT INTO `divisions` VALUES (510725, '梓潼县', 3, 510700, 31.63000, 105.17000, 0);
INSERT INTO `divisions` VALUES (510726, '北川羌族自治县', 3, 510700, 31.82000, 104.45000, 0);
INSERT INTO `divisions` VALUES (510727, '平武县', 3, 510700, 32.42000, 104.53000, 0);
INSERT INTO `divisions` VALUES (510781, '江油市', 3, 510800, 31.78000, 104.75000, 1);
INSERT INTO `divisions` VALUES (510800, '广元市', 2, 510000, 32.43000, 105.83000, 1);
INSERT INTO `divisions` VALUES (510801, '市辖区', 3, 510800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (510802, '利州区', 3, 510800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (510811, '元坝区', 3, 510800, 32.32000, 105.97000, 0);
INSERT INTO `divisions` VALUES (510812, '朝天区', 3, 510800, 32.65000, 105.88000, 0);
INSERT INTO `divisions` VALUES (510821, '旺苍县', 3, 510800, 32.23000, 106.28000, 0);
INSERT INTO `divisions` VALUES (510822, '青川县', 3, 510800, 32.58000, 105.23000, 0);
INSERT INTO `divisions` VALUES (510823, '剑阁县', 3, 510800, 32.28000, 105.52000, 0);
INSERT INTO `divisions` VALUES (510824, '苍溪县', 3, 510800, 31.73000, 105.93000, 0);
INSERT INTO `divisions` VALUES (510900, '遂宁市', 2, 510000, 30.52000, 105.57000, 1);
INSERT INTO `divisions` VALUES (510901, '市辖区', 3, 510900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (510903, '船山区', 3, 510900, 30.52000, 105.57000, 0);
INSERT INTO `divisions` VALUES (510904, '安居区', 3, 510900, 30.35000, 105.45000, 0);
INSERT INTO `divisions` VALUES (510921, '蓬溪县', 3, 510900, 30.78000, 105.72000, 0);
INSERT INTO `divisions` VALUES (510922, '射洪县', 3, 510900, 30.87000, 105.38000, 0);
INSERT INTO `divisions` VALUES (510923, '大英县', 3, 510900, 30.58000, 105.25000, 0);
INSERT INTO `divisions` VALUES (511000, '内江市', 2, 510000, 29.58000, 105.05000, 1);
INSERT INTO `divisions` VALUES (511001, '市辖区', 3, 511000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (511002, '市中区', 3, 511000, 29.57000, 103.77000, 0);
INSERT INTO `divisions` VALUES (511011, '东兴区', 3, 511000, 29.60000, 105.07000, 0);
INSERT INTO `divisions` VALUES (511024, '威远县', 3, 511000, 29.53000, 104.67000, 0);
INSERT INTO `divisions` VALUES (511025, '资中县', 3, 511000, 29.78000, 104.85000, 0);
INSERT INTO `divisions` VALUES (511028, '隆昌县', 3, 511000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (511100, '乐山市', 2, 510000, 29.57000, 103.77000, 1);
INSERT INTO `divisions` VALUES (511101, '市辖区', 3, 511100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (511102, '市中区', 3, 511100, 29.57000, 103.77000, 0);
INSERT INTO `divisions` VALUES (511111, '沙湾区', 3, 511100, 29.42000, 103.55000, 0);
INSERT INTO `divisions` VALUES (511112, '五通桥区', 3, 511100, 29.40000, 103.82000, 0);
INSERT INTO `divisions` VALUES (511113, '金口河区', 3, 511100, 29.25000, 103.08000, 0);
INSERT INTO `divisions` VALUES (511123, '犍为县', 3, 511100, 29.22000, 103.95000, 0);
INSERT INTO `divisions` VALUES (511124, '井研县', 3, 511100, 29.65000, 104.07000, 0);
INSERT INTO `divisions` VALUES (511126, '夹江县', 3, 511100, 29.73000, 103.57000, 0);
INSERT INTO `divisions` VALUES (511129, '沐川县', 3, 511100, 28.97000, 103.90000, 0);
INSERT INTO `divisions` VALUES (511132, '峨边彝族自治县', 3, 511100, 29.23000, 103.27000, 0);
INSERT INTO `divisions` VALUES (511133, '马边彝族自治县', 3, 511100, 28.83000, 103.55000, 0);
INSERT INTO `divisions` VALUES (511181, '峨眉山市', 3, 511200, 29.60000, 103.48000, 1);
INSERT INTO `divisions` VALUES (511300, '南充市', 2, 510000, 30.78000, 106.08000, 1);
INSERT INTO `divisions` VALUES (511301, '市辖区', 3, 511300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (511302, '顺庆区', 3, 511300, 30.78000, 106.08000, 0);
INSERT INTO `divisions` VALUES (511303, '高坪区', 3, 511300, 30.77000, 106.10000, 0);
INSERT INTO `divisions` VALUES (511304, '嘉陵区', 3, 511300, 30.77000, 106.05000, 0);
INSERT INTO `divisions` VALUES (511321, '南部县', 3, 511300, 31.35000, 106.07000, 0);
INSERT INTO `divisions` VALUES (511322, '营山县', 3, 511300, 31.08000, 106.57000, 0);
INSERT INTO `divisions` VALUES (511323, '蓬安县', 3, 511300, 31.03000, 106.42000, 0);
INSERT INTO `divisions` VALUES (511324, '仪陇县', 3, 511300, 31.27000, 106.28000, 0);
INSERT INTO `divisions` VALUES (511325, '西充县', 3, 511300, 31.00000, 105.88000, 0);
INSERT INTO `divisions` VALUES (511381, '阆中市', 3, 511400, 31.55000, 106.00000, 1);
INSERT INTO `divisions` VALUES (511400, '眉山市', 2, 510000, 30.05000, 103.83000, 1);
INSERT INTO `divisions` VALUES (511401, '市辖区', 3, 511400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (511402, '东坡区', 3, 511400, 30.05000, 103.83000, 0);
INSERT INTO `divisions` VALUES (511421, '仁寿县', 3, 511400, 30.00000, 104.15000, 0);
INSERT INTO `divisions` VALUES (511422, '彭山县', 3, 511400, 30.20000, 103.87000, 0);
INSERT INTO `divisions` VALUES (511423, '洪雅县', 3, 511400, 29.92000, 103.37000, 0);
INSERT INTO `divisions` VALUES (511424, '丹棱县', 3, 511400, 30.02000, 103.52000, 0);
INSERT INTO `divisions` VALUES (511425, '青神县', 3, 511400, 29.83000, 103.85000, 0);
INSERT INTO `divisions` VALUES (511500, '宜宾市', 2, 510000, 28.77000, 104.62000, 1);
INSERT INTO `divisions` VALUES (511501, '市辖区', 3, 511500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (511502, '翠屏区', 3, 511500, 28.77000, 104.62000, 0);
INSERT INTO `divisions` VALUES (511503, '南溪区', 3, 511500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (511521, '宜宾县', 3, 511500, 28.70000, 104.55000, 0);
INSERT INTO `divisions` VALUES (511523, '江安县', 3, 511500, 28.73000, 105.07000, 0);
INSERT INTO `divisions` VALUES (511524, '长宁县', 3, 511500, 28.58000, 104.92000, 0);
INSERT INTO `divisions` VALUES (511525, '高县', 3, 511500, 28.43000, 104.52000, 0);
INSERT INTO `divisions` VALUES (511526, '珙县', 3, 511500, 28.45000, 104.72000, 0);
INSERT INTO `divisions` VALUES (511527, '筠连县', 3, 511500, 28.17000, 104.52000, 0);
INSERT INTO `divisions` VALUES (511528, '兴文县', 3, 511500, 28.30000, 105.23000, 0);
INSERT INTO `divisions` VALUES (511529, '屏山县', 3, 511500, 28.83000, 104.33000, 0);
INSERT INTO `divisions` VALUES (511600, '广安市', 2, 510000, 30.47000, 106.63000, 1);
INSERT INTO `divisions` VALUES (511601, '市辖区', 3, 511600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (511602, '广安区', 3, 511600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (511621, '岳池县', 3, 511600, 30.55000, 106.43000, 0);
INSERT INTO `divisions` VALUES (511622, '武胜县', 3, 511600, 30.35000, 106.28000, 0);
INSERT INTO `divisions` VALUES (511623, '邻水县', 3, 511600, 30.33000, 106.93000, 0);
INSERT INTO `divisions` VALUES (511681, '华蓥市', 3, 511700, 30.38000, 106.77000, 1);
INSERT INTO `divisions` VALUES (511700, '达州市', 2, 510000, 31.22000, 107.50000, 1);
INSERT INTO `divisions` VALUES (511701, '市辖区', 3, 511700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (511702, '通川区', 3, 511700, 31.22000, 107.48000, 0);
INSERT INTO `divisions` VALUES (511721, '达县', 3, 511700, 31.20000, 107.50000, 0);
INSERT INTO `divisions` VALUES (511722, '宣汉县', 3, 511700, 31.35000, 107.72000, 0);
INSERT INTO `divisions` VALUES (511723, '开江县', 3, 511700, 31.08000, 107.87000, 0);
INSERT INTO `divisions` VALUES (511724, '大竹县', 3, 511700, 30.73000, 107.20000, 0);
INSERT INTO `divisions` VALUES (511725, '渠县', 3, 511700, 30.83000, 106.97000, 0);
INSERT INTO `divisions` VALUES (511781, '万源市', 3, 511800, 32.07000, 108.03000, 1);
INSERT INTO `divisions` VALUES (511800, '雅安市', 2, 510000, 29.98000, 103.00000, 1);
INSERT INTO `divisions` VALUES (511801, '市辖区', 3, 511800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (511802, '雨城区', 3, 511800, 29.98000, 103.00000, 0);
INSERT INTO `divisions` VALUES (511803, '名山区', 3, 511800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (511822, '荥经县', 3, 511800, 29.80000, 102.85000, 0);
INSERT INTO `divisions` VALUES (511823, '汉源县', 3, 511800, 29.35000, 102.65000, 0);
INSERT INTO `divisions` VALUES (511824, '石棉县', 3, 511800, 29.23000, 102.37000, 0);
INSERT INTO `divisions` VALUES (511825, '天全县', 3, 511800, 30.07000, 102.75000, 0);
INSERT INTO `divisions` VALUES (511826, '芦山县', 3, 511800, 30.15000, 102.92000, 0);
INSERT INTO `divisions` VALUES (511827, '宝兴县', 3, 511800, 30.37000, 102.82000, 0);
INSERT INTO `divisions` VALUES (511900, '巴中市', 2, 510000, 31.85000, 106.77000, 1);
INSERT INTO `divisions` VALUES (511901, '市辖区', 3, 511900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (511902, '巴州区', 3, 511900, 31.85000, 106.77000, 0);
INSERT INTO `divisions` VALUES (511921, '通江县', 3, 511900, 31.92000, 107.23000, 0);
INSERT INTO `divisions` VALUES (511922, '南江县', 3, 511900, 32.35000, 106.83000, 0);
INSERT INTO `divisions` VALUES (511923, '平昌县', 3, 511900, 31.57000, 107.10000, 0);
INSERT INTO `divisions` VALUES (512000, '资阳市', 2, 510000, 30.12000, 104.65000, 1);
INSERT INTO `divisions` VALUES (512001, '市辖区', 3, 512000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (512002, '雁江区', 3, 512000, 30.12000, 104.65000, 0);
INSERT INTO `divisions` VALUES (512021, '安岳县', 3, 512000, 30.10000, 105.33000, 0);
INSERT INTO `divisions` VALUES (512022, '乐至县', 3, 512000, 30.28000, 105.02000, 0);
INSERT INTO `divisions` VALUES (512081, '简阳市', 3, 512100, 30.40000, 104.55000, 1);
INSERT INTO `divisions` VALUES (513200, '阿坝藏族羌族自治州', 2, 510000, 31.90000, 102.22000, 1);
INSERT INTO `divisions` VALUES (513221, '汶川县', 3, 513200, 31.48000, 103.58000, 0);
INSERT INTO `divisions` VALUES (513222, '理县', 3, 513200, 31.43000, 103.17000, 0);
INSERT INTO `divisions` VALUES (513223, '茂县', 3, 513200, 31.68000, 103.85000, 0);
INSERT INTO `divisions` VALUES (513224, '松潘县', 3, 513200, 32.63000, 103.60000, 0);
INSERT INTO `divisions` VALUES (513225, '九寨沟县', 3, 513200, 33.27000, 104.23000, 0);
INSERT INTO `divisions` VALUES (513226, '金川县', 3, 513200, 31.48000, 102.07000, 0);
INSERT INTO `divisions` VALUES (513227, '小金县', 3, 513200, 31.00000, 102.37000, 0);
INSERT INTO `divisions` VALUES (513228, '黑水县', 3, 513200, 32.07000, 102.98000, 0);
INSERT INTO `divisions` VALUES (513229, '马尔康县', 3, 513200, 31.90000, 102.22000, 0);
INSERT INTO `divisions` VALUES (513230, '壤塘县', 3, 513200, 32.27000, 100.98000, 0);
INSERT INTO `divisions` VALUES (513231, '阿坝县', 3, 513200, 32.90000, 101.70000, 0);
INSERT INTO `divisions` VALUES (513232, '若尔盖县', 3, 513200, 33.58000, 102.95000, 0);
INSERT INTO `divisions` VALUES (513233, '红原县', 3, 513200, 32.80000, 102.55000, 0);
INSERT INTO `divisions` VALUES (513300, '甘孜藏族自治州', 2, 510000, 30.05000, 101.97000, 1);
INSERT INTO `divisions` VALUES (513321, '康定县', 3, 513300, 30.05000, 101.97000, 0);
INSERT INTO `divisions` VALUES (513322, '泸定县', 3, 513300, 29.92000, 102.23000, 0);
INSERT INTO `divisions` VALUES (513323, '丹巴县', 3, 513300, 30.88000, 101.88000, 0);
INSERT INTO `divisions` VALUES (513324, '九龙县', 3, 513300, 29.00000, 101.50000, 0);
INSERT INTO `divisions` VALUES (513325, '雅江县', 3, 513300, 30.03000, 101.02000, 0);
INSERT INTO `divisions` VALUES (513326, '道孚县', 3, 513300, 30.98000, 101.12000, 0);
INSERT INTO `divisions` VALUES (513327, '炉霍县', 3, 513300, 31.40000, 100.68000, 0);
INSERT INTO `divisions` VALUES (513328, '甘孜县', 3, 513300, 31.62000, 99.98000, 0);
INSERT INTO `divisions` VALUES (513329, '新龙县', 3, 513300, 30.95000, 100.32000, 0);
INSERT INTO `divisions` VALUES (513330, '德格县', 3, 513300, 31.82000, 98.58000, 0);
INSERT INTO `divisions` VALUES (513331, '白玉县', 3, 513300, 31.22000, 98.83000, 0);
INSERT INTO `divisions` VALUES (513332, '石渠县', 3, 513300, 32.98000, 98.10000, 0);
INSERT INTO `divisions` VALUES (513333, '色达县', 3, 513300, 32.27000, 100.33000, 0);
INSERT INTO `divisions` VALUES (513334, '理塘县', 3, 513300, 30.00000, 100.27000, 0);
INSERT INTO `divisions` VALUES (513335, '巴塘县', 3, 513300, 30.00000, 99.10000, 0);
INSERT INTO `divisions` VALUES (513336, '乡城县', 3, 513300, 28.93000, 99.80000, 0);
INSERT INTO `divisions` VALUES (513337, '稻城县', 3, 513300, 29.03000, 100.30000, 0);
INSERT INTO `divisions` VALUES (513338, '得荣县', 3, 513300, 28.72000, 99.28000, 0);
INSERT INTO `divisions` VALUES (513400, '凉山彝族自治州', 2, 510000, 27.90000, 102.27000, 1);
INSERT INTO `divisions` VALUES (513401, '西昌市', 3, 513400, 27.90000, 102.27000, 1);
INSERT INTO `divisions` VALUES (513422, '木里藏族自治县', 3, 513400, 27.93000, 101.28000, 0);
INSERT INTO `divisions` VALUES (513423, '盐源县', 3, 513400, 27.43000, 101.50000, 0);
INSERT INTO `divisions` VALUES (513424, '德昌县', 3, 513400, 27.40000, 102.18000, 0);
INSERT INTO `divisions` VALUES (513425, '会理县', 3, 513400, 26.67000, 102.25000, 0);
INSERT INTO `divisions` VALUES (513426, '会东县', 3, 513400, 26.63000, 102.58000, 0);
INSERT INTO `divisions` VALUES (513427, '宁南县', 3, 513400, 27.07000, 102.77000, 0);
INSERT INTO `divisions` VALUES (513428, '普格县', 3, 513400, 27.38000, 102.53000, 0);
INSERT INTO `divisions` VALUES (513429, '布拖县', 3, 513400, 27.72000, 102.82000, 0);
INSERT INTO `divisions` VALUES (513430, '金阳县', 3, 513400, 27.70000, 103.25000, 0);
INSERT INTO `divisions` VALUES (513431, '昭觉县', 3, 513400, 28.02000, 102.85000, 0);
INSERT INTO `divisions` VALUES (513432, '喜德县', 3, 513400, 28.32000, 102.42000, 0);
INSERT INTO `divisions` VALUES (513433, '冕宁县', 3, 513400, 28.55000, 102.17000, 0);
INSERT INTO `divisions` VALUES (513434, '越西县', 3, 513400, 28.65000, 102.52000, 0);
INSERT INTO `divisions` VALUES (513435, '甘洛县', 3, 513400, 28.97000, 102.77000, 0);
INSERT INTO `divisions` VALUES (513436, '美姑县', 3, 513400, 28.33000, 103.13000, 0);
INSERT INTO `divisions` VALUES (513437, '雷波县', 3, 513400, 28.27000, 103.57000, 0);
INSERT INTO `divisions` VALUES (520000, '贵州省', 1, 0, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (520100, '贵阳市', 2, 520000, 26.65000, 106.63000, 1);
INSERT INTO `divisions` VALUES (520101, '市辖区', 3, 520100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (520102, '南明区', 3, 520100, 26.57000, 106.72000, 0);
INSERT INTO `divisions` VALUES (520103, '云岩区', 3, 520100, 26.62000, 106.72000, 0);
INSERT INTO `divisions` VALUES (520111, '花溪区', 3, 520100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (520112, '乌当区', 3, 520100, 26.63000, 106.75000, 0);
INSERT INTO `divisions` VALUES (520113, '白云区', 3, 520100, 26.68000, 106.65000, 0);
INSERT INTO `divisions` VALUES (520114, '小河区', 3, 520100, 26.53000, 106.70000, 0);
INSERT INTO `divisions` VALUES (520121, '开阳县', 3, 520100, 27.07000, 106.97000, 0);
INSERT INTO `divisions` VALUES (520122, '息烽县', 3, 520100, 27.10000, 106.73000, 0);
INSERT INTO `divisions` VALUES (520123, '修文县', 3, 520100, 26.83000, 106.58000, 0);
INSERT INTO `divisions` VALUES (520181, '清镇市', 3, 520200, 26.55000, 106.47000, 1);
INSERT INTO `divisions` VALUES (520200, '六盘水市', 2, 520000, 26.60000, 104.83000, 1);
INSERT INTO `divisions` VALUES (520201, '钟山区', 3, 520200, 26.60000, 104.83000, 0);
INSERT INTO `divisions` VALUES (520203, '六枝特区', 3, 520200, 26.22000, 105.48000, 0);
INSERT INTO `divisions` VALUES (520221, '水城县', 3, 520200, 26.55000, 104.95000, 0);
INSERT INTO `divisions` VALUES (520222, '盘县', 3, 520200, 25.72000, 104.47000, 0);
INSERT INTO `divisions` VALUES (520300, '遵义市', 2, 520000, 27.73000, 106.92000, 1);
INSERT INTO `divisions` VALUES (520301, '市辖区', 3, 520300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (520302, '红花岗区', 3, 520300, 27.65000, 106.92000, 0);
INSERT INTO `divisions` VALUES (520303, '汇川区', 3, 520300, 27.73000, 106.92000, 0);
INSERT INTO `divisions` VALUES (520321, '遵义县', 3, 520300, 27.53000, 106.83000, 0);
INSERT INTO `divisions` VALUES (520322, '桐梓县', 3, 520300, 28.13000, 106.82000, 0);
INSERT INTO `divisions` VALUES (520323, '绥阳县', 3, 520300, 27.95000, 107.18000, 0);
INSERT INTO `divisions` VALUES (520324, '正安县', 3, 520300, 28.55000, 107.43000, 0);
INSERT INTO `divisions` VALUES (520325, '道真仡佬族苗族自治县', 3, 520300, 28.88000, 107.60000, 0);
INSERT INTO `divisions` VALUES (520326, '务川仡佬族苗族自治县', 3, 520300, 28.53000, 107.88000, 0);
INSERT INTO `divisions` VALUES (520327, '凤冈县', 3, 520300, 27.97000, 107.72000, 0);
INSERT INTO `divisions` VALUES (520328, '湄潭县', 3, 520300, 27.77000, 107.48000, 0);
INSERT INTO `divisions` VALUES (520329, '余庆县', 3, 520300, 27.22000, 107.88000, 0);
INSERT INTO `divisions` VALUES (520330, '习水县', 3, 520300, 28.32000, 106.22000, 0);
INSERT INTO `divisions` VALUES (520381, '赤水市', 3, 520400, 28.58000, 105.70000, 1);
INSERT INTO `divisions` VALUES (520382, '仁怀市', 3, 520400, 27.82000, 106.42000, 1);
INSERT INTO `divisions` VALUES (520400, '安顺市', 2, 520000, 26.25000, 105.95000, 1);
INSERT INTO `divisions` VALUES (520401, '市辖区', 3, 520400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (520402, '西秀区', 3, 520400, 26.25000, 105.92000, 0);
INSERT INTO `divisions` VALUES (520421, '平坝县', 3, 520400, 26.42000, 106.25000, 0);
INSERT INTO `divisions` VALUES (520422, '普定县', 3, 520400, 26.32000, 105.75000, 0);
INSERT INTO `divisions` VALUES (520423, '镇宁布依族苗族自治县', 3, 520400, 26.07000, 105.77000, 0);
INSERT INTO `divisions` VALUES (520424, '关岭布依族苗族自治县', 3, 520400, 25.95000, 105.62000, 0);
INSERT INTO `divisions` VALUES (520425, '紫云苗族布依族自治县', 3, 520400, 25.75000, 106.08000, 0);
INSERT INTO `divisions` VALUES (520500, '毕节市', 2, 520000, 27.30000, 105.28000, 1);
INSERT INTO `divisions` VALUES (520502, '七星关区', 3, 520500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (520521, '大方县', 3, 520500, 27.15000, 105.60000, 0);
INSERT INTO `divisions` VALUES (520522, '黔西县', 3, 520500, 27.03000, 106.03000, 0);
INSERT INTO `divisions` VALUES (520523, '金沙县', 3, 520500, 27.47000, 106.22000, 0);
INSERT INTO `divisions` VALUES (520524, '织金县', 3, 520500, 26.67000, 105.77000, 0);
INSERT INTO `divisions` VALUES (520525, '纳雍县', 3, 520500, 26.78000, 105.38000, 0);
INSERT INTO `divisions` VALUES (520526, '威宁彝族回族苗族自治县', 3, 520500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (520527, '赫章县', 3, 520500, 27.13000, 104.72000, 0);
INSERT INTO `divisions` VALUES (520600, '铜仁市', 2, 520000, 27.72000, 109.18000, 1);
INSERT INTO `divisions` VALUES (520602, '碧江区', 3, 520600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (520603, '万山区', 3, 520600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (520621, '江口县', 3, 520600, 27.70000, 108.85000, 0);
INSERT INTO `divisions` VALUES (520622, '玉屏侗族自治县', 3, 520600, 27.23000, 108.92000, 0);
INSERT INTO `divisions` VALUES (520623, '石阡县', 3, 520600, 27.52000, 108.23000, 0);
INSERT INTO `divisions` VALUES (520624, '思南县', 3, 520600, 27.93000, 108.25000, 0);
INSERT INTO `divisions` VALUES (520625, '印江土家族苗族自治县', 3, 520600, 28.00000, 108.40000, 0);
INSERT INTO `divisions` VALUES (520626, '德江县', 3, 520600, 28.27000, 108.12000, 0);
INSERT INTO `divisions` VALUES (520627, '沿河土家族自治县', 3, 520600, 28.57000, 108.50000, 0);
INSERT INTO `divisions` VALUES (520628, '松桃苗族自治县', 3, 520600, 28.17000, 109.20000, 0);
INSERT INTO `divisions` VALUES (522300, '黔西南布依族苗族自治州', 2, 520000, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (522301, '兴义市', 3, 522300, 25.08000, 104.90000, 1);
INSERT INTO `divisions` VALUES (522322, '兴仁县', 3, 522300, 25.43000, 105.18000, 0);
INSERT INTO `divisions` VALUES (522323, '普安县', 3, 522300, 25.78000, 104.95000, 0);
INSERT INTO `divisions` VALUES (522324, '晴隆县', 3, 522300, 25.83000, 105.22000, 0);
INSERT INTO `divisions` VALUES (522325, '贞丰县', 3, 522300, 25.38000, 105.65000, 0);
INSERT INTO `divisions` VALUES (522326, '望谟县', 3, 522300, 25.17000, 106.10000, 0);
INSERT INTO `divisions` VALUES (522327, '册亨县', 3, 522300, 24.98000, 105.82000, 0);
INSERT INTO `divisions` VALUES (522328, '安龙县', 3, 522300, 25.12000, 105.47000, 0);
INSERT INTO `divisions` VALUES (522600, '黔东南苗族侗族自治州', 2, 520000, 26.58000, 107.97000, 1);
INSERT INTO `divisions` VALUES (522601, '凯里市', 3, 522600, 26.58000, 107.97000, 1);
INSERT INTO `divisions` VALUES (522622, '黄平县', 3, 522600, 26.90000, 107.90000, 0);
INSERT INTO `divisions` VALUES (522623, '施秉县', 3, 522600, 27.03000, 108.12000, 0);
INSERT INTO `divisions` VALUES (522624, '三穗县', 3, 522600, 26.97000, 108.68000, 0);
INSERT INTO `divisions` VALUES (522625, '镇远县', 3, 522600, 27.05000, 108.42000, 0);
INSERT INTO `divisions` VALUES (522626, '岑巩县', 3, 522600, 27.18000, 108.82000, 0);
INSERT INTO `divisions` VALUES (522627, '天柱县', 3, 522600, 26.92000, 109.20000, 0);
INSERT INTO `divisions` VALUES (522628, '锦屏县', 3, 522600, 26.68000, 109.20000, 0);
INSERT INTO `divisions` VALUES (522629, '剑河县', 3, 522600, 26.73000, 108.45000, 0);
INSERT INTO `divisions` VALUES (522630, '台江县', 3, 522600, 26.67000, 108.32000, 0);
INSERT INTO `divisions` VALUES (522631, '黎平县', 3, 522600, 26.23000, 109.13000, 0);
INSERT INTO `divisions` VALUES (522632, '榕江县', 3, 522600, 25.93000, 108.52000, 0);
INSERT INTO `divisions` VALUES (522633, '从江县', 3, 522600, 25.75000, 108.90000, 0);
INSERT INTO `divisions` VALUES (522634, '雷山县', 3, 522600, 26.38000, 108.07000, 0);
INSERT INTO `divisions` VALUES (522635, '麻江县', 3, 522600, 26.50000, 107.58000, 0);
INSERT INTO `divisions` VALUES (522636, '丹寨县', 3, 522600, 26.20000, 107.80000, 0);
INSERT INTO `divisions` VALUES (522700, '黔南布依族苗族自治州', 2, 520000, 26.27000, 107.52000, 1);
INSERT INTO `divisions` VALUES (522701, '都匀市', 3, 522700, 26.27000, 107.52000, 1);
INSERT INTO `divisions` VALUES (522702, '福泉市', 3, 522700, 26.70000, 107.50000, 1);
INSERT INTO `divisions` VALUES (522722, '荔波县', 3, 522700, 25.42000, 107.88000, 0);
INSERT INTO `divisions` VALUES (522723, '贵定县', 3, 522700, 26.58000, 107.23000, 0);
INSERT INTO `divisions` VALUES (522725, '瓮安县', 3, 522700, 27.07000, 107.47000, 0);
INSERT INTO `divisions` VALUES (522726, '独山县', 3, 522700, 25.83000, 107.53000, 0);
INSERT INTO `divisions` VALUES (522727, '平塘县', 3, 522700, 25.83000, 107.32000, 0);
INSERT INTO `divisions` VALUES (522728, '罗甸县', 3, 522700, 25.43000, 106.75000, 0);
INSERT INTO `divisions` VALUES (522729, '长顺县', 3, 522700, 26.03000, 106.45000, 0);
INSERT INTO `divisions` VALUES (522730, '龙里县', 3, 522700, 26.45000, 106.97000, 0);
INSERT INTO `divisions` VALUES (522731, '惠水县', 3, 522700, 26.13000, 106.65000, 0);
INSERT INTO `divisions` VALUES (522732, '三都水族自治县', 3, 522700, 25.98000, 107.87000, 0);
INSERT INTO `divisions` VALUES (530000, '云南省', 1, 0, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (530100, '昆明市', 2, 530000, 25.05000, 102.72000, 1);
INSERT INTO `divisions` VALUES (530101, '市辖区', 3, 530100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (530102, '五华区', 3, 530100, 25.05000, 102.70000, 0);
INSERT INTO `divisions` VALUES (530103, '盘龙区', 3, 530100, 25.03000, 102.72000, 0);
INSERT INTO `divisions` VALUES (530111, '官渡区', 3, 530100, 25.02000, 102.75000, 0);
INSERT INTO `divisions` VALUES (530112, '西山区', 3, 530100, 25.03000, 102.67000, 0);
INSERT INTO `divisions` VALUES (530113, '东川区', 3, 530100, 26.08000, 103.18000, 0);
INSERT INTO `divisions` VALUES (530114, '呈贡区', 3, 530100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (530122, '晋宁县', 3, 530100, 24.67000, 102.60000, 0);
INSERT INTO `divisions` VALUES (530124, '富民县', 3, 530100, 25.22000, 102.50000, 0);
INSERT INTO `divisions` VALUES (530125, '宜良县', 3, 530100, 24.92000, 103.15000, 0);
INSERT INTO `divisions` VALUES (530126, '石林彝族自治县', 3, 530100, 24.77000, 103.27000, 0);
INSERT INTO `divisions` VALUES (530127, '嵩明县', 3, 530100, 25.35000, 103.03000, 0);
INSERT INTO `divisions` VALUES (530128, '禄劝彝族苗族自治县', 3, 530100, 25.55000, 102.47000, 0);
INSERT INTO `divisions` VALUES (530129, '寻甸回族彝族自治县', 3, 530100, 25.57000, 103.25000, 0);
INSERT INTO `divisions` VALUES (530181, '安宁市', 3, 530200, 24.92000, 102.48000, 1);
INSERT INTO `divisions` VALUES (530300, '曲靖市', 2, 530000, 25.50000, 103.80000, 1);
INSERT INTO `divisions` VALUES (530301, '市辖区', 3, 530300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (530302, '麒麟区', 3, 530300, 25.50000, 103.80000, 0);
INSERT INTO `divisions` VALUES (530321, '马龙县', 3, 530300, 25.43000, 103.58000, 0);
INSERT INTO `divisions` VALUES (530322, '陆良县', 3, 530300, 25.03000, 103.67000, 0);
INSERT INTO `divisions` VALUES (530323, '师宗县', 3, 530300, 24.83000, 103.98000, 0);
INSERT INTO `divisions` VALUES (530324, '罗平县', 3, 530300, 24.88000, 104.30000, 0);
INSERT INTO `divisions` VALUES (530325, '富源县', 3, 530300, 25.67000, 104.25000, 0);
INSERT INTO `divisions` VALUES (530326, '会泽县', 3, 530300, 26.42000, 103.30000, 0);
INSERT INTO `divisions` VALUES (530328, '沾益县', 3, 530300, 25.62000, 103.82000, 0);
INSERT INTO `divisions` VALUES (530381, '宣威市', 3, 530400, 26.22000, 104.10000, 1);
INSERT INTO `divisions` VALUES (530400, '玉溪市', 2, 530000, 24.35000, 102.55000, 1);
INSERT INTO `divisions` VALUES (530402, '红塔区', 3, 530400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (530421, '江川县', 3, 530400, 24.28000, 102.75000, 0);
INSERT INTO `divisions` VALUES (530422, '澄江县', 3, 530400, 24.67000, 102.92000, 0);
INSERT INTO `divisions` VALUES (530423, '通海县', 3, 530400, 24.12000, 102.75000, 0);
INSERT INTO `divisions` VALUES (530424, '华宁县', 3, 530400, 24.20000, 102.93000, 0);
INSERT INTO `divisions` VALUES (530425, '易门县', 3, 530400, 24.67000, 102.17000, 0);
INSERT INTO `divisions` VALUES (530426, '峨山彝族自治县', 3, 530400, 24.18000, 102.40000, 0);
INSERT INTO `divisions` VALUES (530427, '新平彝族傣族自治县', 3, 530400, 24.07000, 101.98000, 0);
INSERT INTO `divisions` VALUES (530428, '元江哈尼族彝族傣族自治县', 3, 530400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (530500, '保山市', 2, 530000, 25.12000, 99.17000, 1);
INSERT INTO `divisions` VALUES (530501, '市辖区', 3, 530500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (530502, '隆阳区', 3, 530500, 25.12000, 99.17000, 0);
INSERT INTO `divisions` VALUES (530521, '施甸县', 3, 530500, 24.73000, 99.18000, 0);
INSERT INTO `divisions` VALUES (530522, '腾冲县', 3, 530500, 25.03000, 98.50000, 0);
INSERT INTO `divisions` VALUES (530523, '龙陵县', 3, 530500, 24.58000, 98.68000, 0);
INSERT INTO `divisions` VALUES (530524, '昌宁县', 3, 530500, 24.83000, 99.60000, 0);
INSERT INTO `divisions` VALUES (530600, '昭通市', 2, 530000, 27.33000, 103.72000, 1);
INSERT INTO `divisions` VALUES (530601, '市辖区', 3, 530600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (530602, '昭阳区', 3, 530600, 27.33000, 103.72000, 0);
INSERT INTO `divisions` VALUES (530621, '鲁甸县', 3, 530600, 27.20000, 103.55000, 0);
INSERT INTO `divisions` VALUES (530622, '巧家县', 3, 530600, 26.92000, 102.92000, 0);
INSERT INTO `divisions` VALUES (530623, '盐津县', 3, 530600, 28.12000, 104.23000, 0);
INSERT INTO `divisions` VALUES (530624, '大关县', 3, 530600, 27.75000, 103.88000, 0);
INSERT INTO `divisions` VALUES (530625, '永善县', 3, 530600, 28.23000, 103.63000, 0);
INSERT INTO `divisions` VALUES (530626, '绥江县', 3, 530600, 28.60000, 103.95000, 0);
INSERT INTO `divisions` VALUES (530627, '镇雄县', 3, 530600, 27.45000, 104.87000, 0);
INSERT INTO `divisions` VALUES (530628, '彝良县', 3, 530600, 27.63000, 104.05000, 0);
INSERT INTO `divisions` VALUES (530629, '威信县', 3, 530600, 27.85000, 105.05000, 0);
INSERT INTO `divisions` VALUES (530630, '水富县', 3, 530600, 28.63000, 104.40000, 0);
INSERT INTO `divisions` VALUES (530700, '丽江市', 2, 530000, 26.88000, 100.23000, 1);
INSERT INTO `divisions` VALUES (530701, '市辖区', 3, 530700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (530702, '古城区', 3, 530700, 26.88000, 100.23000, 0);
INSERT INTO `divisions` VALUES (530721, '玉龙纳西族自治县', 3, 530700, 26.82000, 100.23000, 0);
INSERT INTO `divisions` VALUES (530722, '永胜县', 3, 530700, 26.68000, 100.75000, 0);
INSERT INTO `divisions` VALUES (530723, '华坪县', 3, 530700, 26.63000, 101.27000, 0);
INSERT INTO `divisions` VALUES (530724, '宁蒗彝族自治县', 3, 530700, 27.28000, 100.85000, 0);
INSERT INTO `divisions` VALUES (530800, '普洱市', 2, 530000, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (530801, '市辖区', 3, 530800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (530802, '思茅区', 3, 530800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (530821, '宁洱哈尼族彝族自治县', 3, 530800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (530822, '墨江哈尼族自治县', 3, 530800, 23.43000, 101.68000, 0);
INSERT INTO `divisions` VALUES (530823, '景东彝族自治县', 3, 530800, 24.45000, 100.83000, 0);
INSERT INTO `divisions` VALUES (530824, '景谷傣族彝族自治县', 3, 530800, 23.50000, 100.70000, 0);
INSERT INTO `divisions` VALUES (530825, '镇沅彝族哈尼族拉祜族自治县', 3, 530800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (530826, '江城哈尼族彝族自治县', 3, 530800, 22.58000, 101.85000, 0);
INSERT INTO `divisions` VALUES (530827, '孟连傣族拉祜族佤族自治县', 3, 530800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (530828, '澜沧拉祜族自治县', 3, 530800, 22.55000, 99.93000, 0);
INSERT INTO `divisions` VALUES (530829, '西盟佤族自治县', 3, 530800, 22.63000, 99.62000, 0);
INSERT INTO `divisions` VALUES (530900, '临沧市', 2, 530000, 23.88000, 100.08000, 1);
INSERT INTO `divisions` VALUES (530901, '市辖区', 3, 530900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (530902, '临翔区', 3, 530900, 23.88000, 100.08000, 0);
INSERT INTO `divisions` VALUES (530921, '凤庆县', 3, 530900, 24.60000, 99.92000, 0);
INSERT INTO `divisions` VALUES (530922, '云县', 3, 530900, 24.45000, 100.13000, 0);
INSERT INTO `divisions` VALUES (530923, '永德县', 3, 530900, 24.03000, 99.25000, 0);
INSERT INTO `divisions` VALUES (530924, '镇康县', 3, 530900, 23.78000, 98.83000, 0);
INSERT INTO `divisions` VALUES (530925, '双江拉祜族佤族布朗族傣族自治县', 3, 530900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (530926, '耿马傣族佤族自治县', 3, 530900, 23.55000, 99.40000, 0);
INSERT INTO `divisions` VALUES (530927, '沧源佤族自治县', 3, 530900, 23.15000, 99.25000, 0);
INSERT INTO `divisions` VALUES (532300, '楚雄彝族自治州', 2, 530000, 25.03000, 101.55000, 1);
INSERT INTO `divisions` VALUES (532301, '楚雄市', 3, 532300, 25.03000, 101.55000, 1);
INSERT INTO `divisions` VALUES (532322, '双柏县', 3, 532300, 24.70000, 101.63000, 0);
INSERT INTO `divisions` VALUES (532323, '牟定县', 3, 532300, 25.32000, 101.53000, 0);
INSERT INTO `divisions` VALUES (532324, '南华县', 3, 532300, 25.20000, 101.27000, 0);
INSERT INTO `divisions` VALUES (532325, '姚安县', 3, 532300, 25.50000, 101.23000, 0);
INSERT INTO `divisions` VALUES (532326, '大姚县', 3, 532300, 25.73000, 101.32000, 0);
INSERT INTO `divisions` VALUES (532327, '永仁县', 3, 532300, 26.07000, 101.67000, 0);
INSERT INTO `divisions` VALUES (532328, '元谋县', 3, 532300, 25.70000, 101.88000, 0);
INSERT INTO `divisions` VALUES (532329, '武定县', 3, 532300, 25.53000, 102.40000, 0);
INSERT INTO `divisions` VALUES (532331, '禄丰县', 3, 532300, 25.15000, 102.08000, 0);
INSERT INTO `divisions` VALUES (532500, '红河哈尼族彝族自治州', 2, 530000, 23.37000, 103.40000, 1);
INSERT INTO `divisions` VALUES (532501, '个旧市', 3, 532500, 23.37000, 103.15000, 1);
INSERT INTO `divisions` VALUES (532502, '开远市', 3, 532500, 23.72000, 103.27000, 1);
INSERT INTO `divisions` VALUES (532503, '蒙自市', 3, 532500, 23.36000, 103.41000, 1);
INSERT INTO `divisions` VALUES (532523, '屏边苗族自治县', 3, 532500, 22.98000, 103.68000, 0);
INSERT INTO `divisions` VALUES (532524, '建水县', 3, 532500, 23.62000, 102.83000, 0);
INSERT INTO `divisions` VALUES (532525, '石屏县', 3, 532500, 23.72000, 102.50000, 0);
INSERT INTO `divisions` VALUES (532526, '弥勒县', 3, 532500, 24.40000, 103.43000, 0);
INSERT INTO `divisions` VALUES (532527, '泸西县', 3, 532500, 24.53000, 103.77000, 0);
INSERT INTO `divisions` VALUES (532528, '元阳县', 3, 532500, 23.23000, 102.83000, 0);
INSERT INTO `divisions` VALUES (532529, '红河县', 3, 532500, 23.37000, 102.42000, 0);
INSERT INTO `divisions` VALUES (532530, '金平苗族瑶族傣族自治县', 3, 532500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (532531, '绿春县', 3, 532500, 23.00000, 102.40000, 0);
INSERT INTO `divisions` VALUES (532532, '河口瑶族自治县', 3, 532500, 22.52000, 103.97000, 0);
INSERT INTO `divisions` VALUES (532600, '文山壮族苗族自治州', 2, 530000, 23.37000, 104.25000, 1);
INSERT INTO `divisions` VALUES (532601, '文山市', 3, 532600, 23.37000, 104.24000, 1);
INSERT INTO `divisions` VALUES (532622, '砚山县', 3, 532600, 23.62000, 104.33000, 0);
INSERT INTO `divisions` VALUES (532623, '西畴县', 3, 532600, 23.45000, 104.67000, 0);
INSERT INTO `divisions` VALUES (532624, '麻栗坡县', 3, 532600, 23.12000, 104.70000, 0);
INSERT INTO `divisions` VALUES (532625, '马关县', 3, 532600, 23.02000, 104.40000, 0);
INSERT INTO `divisions` VALUES (532626, '丘北县', 3, 532600, 24.05000, 104.18000, 0);
INSERT INTO `divisions` VALUES (532627, '广南县', 3, 532600, 24.05000, 105.07000, 0);
INSERT INTO `divisions` VALUES (532628, '富宁县', 3, 532600, 23.63000, 105.62000, 0);
INSERT INTO `divisions` VALUES (532800, '西双版纳傣族自治州', 2, 530000, 22.02000, 100.80000, 1);
INSERT INTO `divisions` VALUES (532801, '景洪市', 3, 532800, 22.02000, 100.80000, 1);
INSERT INTO `divisions` VALUES (532822, '勐海县', 3, 532800, 21.97000, 100.45000, 0);
INSERT INTO `divisions` VALUES (532823, '勐腊县', 3, 532800, 21.48000, 101.57000, 0);
INSERT INTO `divisions` VALUES (532900, '大理白族自治州', 2, 530000, 25.60000, 100.23000, 1);
INSERT INTO `divisions` VALUES (532901, '大理市', 3, 532900, 25.60000, 100.23000, 1);
INSERT INTO `divisions` VALUES (532922, '漾濞彝族自治县', 3, 532900, 25.67000, 99.95000, 0);
INSERT INTO `divisions` VALUES (532923, '祥云县', 3, 532900, 25.48000, 100.55000, 0);
INSERT INTO `divisions` VALUES (532924, '宾川县', 3, 532900, 25.83000, 100.58000, 0);
INSERT INTO `divisions` VALUES (532925, '弥渡县', 3, 532900, 25.35000, 100.48000, 0);
INSERT INTO `divisions` VALUES (532926, '南涧彝族自治县', 3, 532900, 25.05000, 100.52000, 0);
INSERT INTO `divisions` VALUES (532927, '巍山彝族回族自治县', 3, 532900, 25.23000, 100.30000, 0);
INSERT INTO `divisions` VALUES (532928, '永平县', 3, 532900, 25.47000, 99.53000, 0);
INSERT INTO `divisions` VALUES (532929, '云龙县', 3, 532900, 25.88000, 99.37000, 0);
INSERT INTO `divisions` VALUES (532930, '洱源县', 3, 532900, 26.12000, 99.95000, 0);
INSERT INTO `divisions` VALUES (532931, '剑川县', 3, 532900, 26.53000, 99.90000, 0);
INSERT INTO `divisions` VALUES (532932, '鹤庆县', 3, 532900, 26.57000, 100.18000, 0);
INSERT INTO `divisions` VALUES (533100, '德宏傣族景颇族自治州', 2, 530000, 24.43000, 98.58000, 1);
INSERT INTO `divisions` VALUES (533102, '瑞丽市', 3, 533100, 24.02000, 97.85000, 1);
INSERT INTO `divisions` VALUES (533103, '芒市', 3, 533100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (533122, '梁河县', 3, 533100, 24.82000, 98.30000, 0);
INSERT INTO `divisions` VALUES (533123, '盈江县', 3, 533100, 24.72000, 97.93000, 0);
INSERT INTO `divisions` VALUES (533124, '陇川县', 3, 533100, 24.20000, 97.80000, 0);
INSERT INTO `divisions` VALUES (533300, '怒江傈僳族自治州', 2, 530000, 25.85000, 98.85000, 1);
INSERT INTO `divisions` VALUES (533321, '泸水县', 3, 533300, 25.85000, 98.85000, 0);
INSERT INTO `divisions` VALUES (533323, '福贡县', 3, 533300, 26.90000, 98.87000, 0);
INSERT INTO `divisions` VALUES (533324, '贡山独龙族怒族自治县', 3, 533300, 27.73000, 98.67000, 0);
INSERT INTO `divisions` VALUES (533325, '兰坪白族普米族自治县', 3, 533300, 26.45000, 99.42000, 0);
INSERT INTO `divisions` VALUES (533400, '迪庆藏族自治州', 2, 530000, 27.83000, 99.70000, 1);
INSERT INTO `divisions` VALUES (533421, '香格里拉县', 3, 533400, 27.83000, 99.70000, 0);
INSERT INTO `divisions` VALUES (533422, '德钦县', 3, 533400, 28.48000, 98.92000, 0);
INSERT INTO `divisions` VALUES (533423, '维西傈僳族自治县', 3, 533400, 27.18000, 99.28000, 0);
INSERT INTO `divisions` VALUES (540000, '西藏自治区', 1, 0, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (540100, '拉萨市', 2, 540000, 29.65000, 91.13000, 1);
INSERT INTO `divisions` VALUES (540101, '市辖区', 3, 540100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (540102, '城关区', 3, 540100, 36.05000, 103.83000, 0);
INSERT INTO `divisions` VALUES (540121, '林周县', 3, 540100, 29.90000, 91.25000, 0);
INSERT INTO `divisions` VALUES (540122, '当雄县', 3, 540100, 30.48000, 91.10000, 0);
INSERT INTO `divisions` VALUES (540123, '尼木县', 3, 540100, 29.45000, 90.15000, 0);
INSERT INTO `divisions` VALUES (540124, '曲水县', 3, 540100, 29.37000, 90.73000, 0);
INSERT INTO `divisions` VALUES (540125, '堆龙德庆县', 3, 540100, 29.65000, 91.00000, 0);
INSERT INTO `divisions` VALUES (540126, '达孜县', 3, 540100, 29.68000, 91.35000, 0);
INSERT INTO `divisions` VALUES (540127, '墨竹工卡县', 3, 540100, 29.83000, 91.73000, 0);
INSERT INTO `divisions` VALUES (542100, '昌都地区', 2, 540000, 31.13000, 97.18000, 0);
INSERT INTO `divisions` VALUES (542121, '昌都县', 3, 542100, 31.13000, 97.18000, 0);
INSERT INTO `divisions` VALUES (542122, '江达县', 3, 542100, 31.50000, 98.22000, 0);
INSERT INTO `divisions` VALUES (542123, '贡觉县', 3, 542100, 30.87000, 98.27000, 0);
INSERT INTO `divisions` VALUES (542124, '类乌齐县', 3, 542100, 31.22000, 96.60000, 0);
INSERT INTO `divisions` VALUES (542125, '丁青县', 3, 542100, 31.42000, 95.60000, 0);
INSERT INTO `divisions` VALUES (542126, '察雅县', 3, 542100, 30.65000, 97.57000, 0);
INSERT INTO `divisions` VALUES (542127, '八宿县', 3, 542100, 30.05000, 96.92000, 0);
INSERT INTO `divisions` VALUES (542128, '左贡县', 3, 542100, 29.67000, 97.85000, 0);
INSERT INTO `divisions` VALUES (542129, '芒康县', 3, 542100, 29.68000, 98.60000, 0);
INSERT INTO `divisions` VALUES (542132, '洛隆县', 3, 542100, 30.75000, 95.83000, 0);
INSERT INTO `divisions` VALUES (542133, '边坝县', 3, 542100, 30.93000, 94.70000, 0);
INSERT INTO `divisions` VALUES (542200, '山南地区', 2, 540000, 29.23000, 91.77000, 0);
INSERT INTO `divisions` VALUES (542221, '乃东县', 3, 542200, 29.23000, 91.77000, 0);
INSERT INTO `divisions` VALUES (542222, '扎囊县', 3, 542200, 29.25000, 91.33000, 0);
INSERT INTO `divisions` VALUES (542223, '贡嘎县', 3, 542200, 29.30000, 90.98000, 0);
INSERT INTO `divisions` VALUES (542224, '桑日县', 3, 542200, 29.27000, 92.02000, 0);
INSERT INTO `divisions` VALUES (542225, '琼结县', 3, 542200, 29.03000, 91.68000, 0);
INSERT INTO `divisions` VALUES (542226, '曲松县', 3, 542200, 29.07000, 92.20000, 0);
INSERT INTO `divisions` VALUES (542227, '措美县', 3, 542200, 28.43000, 91.43000, 0);
INSERT INTO `divisions` VALUES (542228, '洛扎县', 3, 542200, 28.38000, 90.87000, 0);
INSERT INTO `divisions` VALUES (542229, '加查县', 3, 542200, 29.15000, 92.58000, 0);
INSERT INTO `divisions` VALUES (542231, '隆子县', 3, 542200, 28.42000, 92.47000, 0);
INSERT INTO `divisions` VALUES (542232, '错那县', 3, 542200, 28.00000, 91.95000, 0);
INSERT INTO `divisions` VALUES (542233, '浪卡子县', 3, 542200, 28.97000, 90.40000, 0);
INSERT INTO `divisions` VALUES (542300, '日喀则地区', 2, 540000, 29.27000, 88.88000, 0);
INSERT INTO `divisions` VALUES (542301, '日喀则市', 3, 542300, 29.27000, 88.88000, 1);
INSERT INTO `divisions` VALUES (542322, '南木林县', 3, 542300, 29.68000, 89.10000, 0);
INSERT INTO `divisions` VALUES (542323, '江孜县', 3, 542300, 28.92000, 89.60000, 0);
INSERT INTO `divisions` VALUES (542324, '定日县', 3, 542300, 28.67000, 87.12000, 0);
INSERT INTO `divisions` VALUES (542325, '萨迦县', 3, 542300, 28.90000, 88.02000, 0);
INSERT INTO `divisions` VALUES (542326, '拉孜县', 3, 542300, 29.08000, 87.63000, 0);
INSERT INTO `divisions` VALUES (542327, '昂仁县', 3, 542300, 29.30000, 87.23000, 0);
INSERT INTO `divisions` VALUES (542328, '谢通门县', 3, 542300, 29.43000, 88.27000, 0);
INSERT INTO `divisions` VALUES (542329, '白朗县', 3, 542300, 29.12000, 89.27000, 0);
INSERT INTO `divisions` VALUES (542330, '仁布县', 3, 542300, 29.23000, 89.83000, 0);
INSERT INTO `divisions` VALUES (542331, '康马县', 3, 542300, 28.57000, 89.68000, 0);
INSERT INTO `divisions` VALUES (542332, '定结县', 3, 542300, 28.37000, 87.77000, 0);
INSERT INTO `divisions` VALUES (542333, '仲巴县', 3, 542300, 29.77000, 84.03000, 0);
INSERT INTO `divisions` VALUES (542334, '亚东县', 3, 542300, 27.48000, 88.90000, 0);
INSERT INTO `divisions` VALUES (542335, '吉隆县', 3, 542300, 28.85000, 85.30000, 0);
INSERT INTO `divisions` VALUES (542336, '聂拉木县', 3, 542300, 28.17000, 85.98000, 0);
INSERT INTO `divisions` VALUES (542337, '萨嘎县', 3, 542300, 29.33000, 85.23000, 0);
INSERT INTO `divisions` VALUES (542338, '岗巴县', 3, 542300, 28.28000, 88.52000, 0);
INSERT INTO `divisions` VALUES (542400, '那曲地区', 2, 540000, 31.48000, 92.07000, 0);
INSERT INTO `divisions` VALUES (542421, '那曲县', 3, 542400, 31.48000, 92.07000, 0);
INSERT INTO `divisions` VALUES (542422, '嘉黎县', 3, 542400, 30.65000, 93.25000, 0);
INSERT INTO `divisions` VALUES (542423, '比如县', 3, 542400, 31.48000, 93.68000, 0);
INSERT INTO `divisions` VALUES (542424, '聂荣县', 3, 542400, 32.12000, 92.30000, 0);
INSERT INTO `divisions` VALUES (542425, '安多县', 3, 542400, 32.27000, 91.68000, 0);
INSERT INTO `divisions` VALUES (542426, '申扎县', 3, 542400, 30.93000, 88.70000, 0);
INSERT INTO `divisions` VALUES (542427, '索县', 3, 542400, 31.88000, 93.78000, 0);
INSERT INTO `divisions` VALUES (542428, '班戈县', 3, 542400, 31.37000, 90.02000, 0);
INSERT INTO `divisions` VALUES (542429, '巴青县', 3, 542400, 31.93000, 94.03000, 0);
INSERT INTO `divisions` VALUES (542430, '尼玛县', 3, 542400, 31.78000, 87.23000, 0);
INSERT INTO `divisions` VALUES (542500, '阿里地区', 2, 540000, 32.50000, 80.10000, 0);
INSERT INTO `divisions` VALUES (542521, '普兰县', 3, 542500, 30.30000, 81.17000, 0);
INSERT INTO `divisions` VALUES (542522, '札达县', 3, 542500, 31.48000, 79.80000, 0);
INSERT INTO `divisions` VALUES (542523, '噶尔县', 3, 542500, 32.50000, 80.10000, 0);
INSERT INTO `divisions` VALUES (542524, '日土县', 3, 542500, 33.38000, 79.72000, 0);
INSERT INTO `divisions` VALUES (542525, '革吉县', 3, 542500, 32.40000, 81.12000, 0);
INSERT INTO `divisions` VALUES (542526, '改则县', 3, 542500, 32.30000, 84.07000, 0);
INSERT INTO `divisions` VALUES (542527, '措勤县', 3, 542500, 31.02000, 85.17000, 0);
INSERT INTO `divisions` VALUES (542600, '林芝地区', 2, 540000, 29.68000, 94.37000, 0);
INSERT INTO `divisions` VALUES (542621, '林芝县', 3, 542600, 29.68000, 94.37000, 0);
INSERT INTO `divisions` VALUES (542622, '工布江达县', 3, 542600, 29.88000, 93.25000, 0);
INSERT INTO `divisions` VALUES (542623, '米林县', 3, 542600, 29.22000, 94.22000, 0);
INSERT INTO `divisions` VALUES (542624, '墨脱县', 3, 542600, 29.33000, 95.33000, 0);
INSERT INTO `divisions` VALUES (542625, '波密县', 3, 542600, 29.87000, 95.77000, 0);
INSERT INTO `divisions` VALUES (542626, '察隅县', 3, 542600, 28.67000, 97.47000, 0);
INSERT INTO `divisions` VALUES (542627, '朗县', 3, 542600, 29.05000, 93.07000, 0);
INSERT INTO `divisions` VALUES (610000, '陕西省', 1, 0, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (610100, '西安市', 2, 610000, 34.27000, 108.93000, 1);
INSERT INTO `divisions` VALUES (610101, '市辖区', 3, 610100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (610102, '新城区', 3, 610100, 34.27000, 108.95000, 0);
INSERT INTO `divisions` VALUES (610103, '碑林区', 3, 610100, 34.23000, 108.93000, 0);
INSERT INTO `divisions` VALUES (610104, '莲湖区', 3, 610100, 34.27000, 108.93000, 0);
INSERT INTO `divisions` VALUES (610111, '灞桥区', 3, 610100, 34.27000, 109.07000, 0);
INSERT INTO `divisions` VALUES (610112, '未央区', 3, 610100, 34.28000, 108.93000, 0);
INSERT INTO `divisions` VALUES (610113, '雁塔区', 3, 610100, 34.22000, 108.95000, 0);
INSERT INTO `divisions` VALUES (610114, '阎良区', 3, 610100, 34.65000, 109.23000, 0);
INSERT INTO `divisions` VALUES (610115, '临潼区', 3, 610100, 34.37000, 109.22000, 0);
INSERT INTO `divisions` VALUES (610116, '长安区', 3, 610100, 34.17000, 108.93000, 0);
INSERT INTO `divisions` VALUES (610122, '蓝田县', 3, 610100, 34.15000, 109.32000, 0);
INSERT INTO `divisions` VALUES (610124, '周至县', 3, 610100, 34.17000, 108.20000, 0);
INSERT INTO `divisions` VALUES (610125, '户县', 3, 610100, 34.10000, 108.60000, 0);
INSERT INTO `divisions` VALUES (610126, '高陵县', 3, 610100, 34.53000, 109.08000, 0);
INSERT INTO `divisions` VALUES (610200, '铜川市', 2, 610000, 34.90000, 108.93000, 1);
INSERT INTO `divisions` VALUES (610201, '市辖区', 3, 610200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (610202, '王益区', 3, 610200, 35.07000, 109.07000, 0);
INSERT INTO `divisions` VALUES (610203, '印台区', 3, 610200, 35.10000, 109.10000, 0);
INSERT INTO `divisions` VALUES (610204, '耀州区', 3, 610200, 34.92000, 108.98000, 0);
INSERT INTO `divisions` VALUES (610222, '宜君县', 3, 610200, 35.40000, 109.12000, 0);
INSERT INTO `divisions` VALUES (610300, '宝鸡市', 2, 610000, 34.37000, 107.13000, 1);
INSERT INTO `divisions` VALUES (610301, '市辖区', 3, 610300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (610302, '渭滨区', 3, 610300, 34.37000, 107.15000, 0);
INSERT INTO `divisions` VALUES (610303, '金台区', 3, 610300, 34.38000, 107.13000, 0);
INSERT INTO `divisions` VALUES (610304, '陈仓区', 3, 610300, 34.37000, 107.37000, 0);
INSERT INTO `divisions` VALUES (610322, '凤翔县', 3, 610300, 34.52000, 107.38000, 0);
INSERT INTO `divisions` VALUES (610323, '岐山县', 3, 610300, 34.45000, 107.62000, 0);
INSERT INTO `divisions` VALUES (610324, '扶风县', 3, 610300, 34.37000, 107.87000, 0);
INSERT INTO `divisions` VALUES (610326, '眉县', 3, 610300, 34.28000, 107.75000, 0);
INSERT INTO `divisions` VALUES (610327, '陇县', 3, 610300, 34.90000, 106.85000, 0);
INSERT INTO `divisions` VALUES (610328, '千阳县', 3, 610300, 34.65000, 107.13000, 0);
INSERT INTO `divisions` VALUES (610329, '麟游县', 3, 610300, 34.68000, 107.78000, 0);
INSERT INTO `divisions` VALUES (610330, '凤县', 3, 610300, 33.92000, 106.52000, 0);
INSERT INTO `divisions` VALUES (610331, '太白县', 3, 610300, 34.07000, 107.32000, 0);
INSERT INTO `divisions` VALUES (610400, '咸阳市', 2, 610000, 34.33000, 108.70000, 1);
INSERT INTO `divisions` VALUES (610401, '市辖区', 3, 610400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (610402, '秦都区', 3, 610400, 34.35000, 108.72000, 0);
INSERT INTO `divisions` VALUES (610403, '杨陵区', 3, 610400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (610404, '渭城区', 3, 610400, 34.33000, 108.73000, 0);
INSERT INTO `divisions` VALUES (610422, '三原县', 3, 610400, 34.62000, 108.93000, 0);
INSERT INTO `divisions` VALUES (610423, '泾阳县', 3, 610400, 34.53000, 108.83000, 0);
INSERT INTO `divisions` VALUES (610424, '乾县', 3, 610400, 34.53000, 108.23000, 0);
INSERT INTO `divisions` VALUES (610425, '礼泉县', 3, 610400, 34.48000, 108.42000, 0);
INSERT INTO `divisions` VALUES (610426, '永寿县', 3, 610400, 34.70000, 108.13000, 0);
INSERT INTO `divisions` VALUES (610427, '彬县', 3, 610400, 35.03000, 108.08000, 0);
INSERT INTO `divisions` VALUES (610428, '长武县', 3, 610400, 35.20000, 107.78000, 0);
INSERT INTO `divisions` VALUES (610429, '旬邑县', 3, 610400, 35.12000, 108.33000, 0);
INSERT INTO `divisions` VALUES (610430, '淳化县', 3, 610400, 34.78000, 108.58000, 0);
INSERT INTO `divisions` VALUES (610431, '武功县', 3, 610400, 34.27000, 108.20000, 0);
INSERT INTO `divisions` VALUES (610481, '兴平市', 3, 610500, 34.30000, 108.48000, 1);
INSERT INTO `divisions` VALUES (610500, '渭南市', 2, 610000, 34.50000, 109.50000, 1);
INSERT INTO `divisions` VALUES (610501, '市辖区', 3, 610500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (610502, '临渭区', 3, 610500, 34.50000, 109.48000, 0);
INSERT INTO `divisions` VALUES (610521, '华县', 3, 610500, 34.52000, 109.77000, 0);
INSERT INTO `divisions` VALUES (610522, '潼关县', 3, 610500, 34.55000, 110.23000, 0);
INSERT INTO `divisions` VALUES (610523, '大荔县', 3, 610500, 34.80000, 109.93000, 0);
INSERT INTO `divisions` VALUES (610524, '合阳县', 3, 610500, 35.23000, 110.15000, 0);
INSERT INTO `divisions` VALUES (610525, '澄城县', 3, 610500, 35.18000, 109.93000, 0);
INSERT INTO `divisions` VALUES (610526, '蒲城县', 3, 610500, 34.95000, 109.58000, 0);
INSERT INTO `divisions` VALUES (610527, '白水县', 3, 610500, 35.18000, 109.58000, 0);
INSERT INTO `divisions` VALUES (610528, '富平县', 3, 610500, 34.75000, 109.18000, 0);
INSERT INTO `divisions` VALUES (610581, '韩城市', 3, 610600, 35.48000, 110.43000, 1);
INSERT INTO `divisions` VALUES (610582, '华阴市', 3, 610600, 34.57000, 110.08000, 1);
INSERT INTO `divisions` VALUES (610600, '延安市', 2, 610000, 36.60000, 109.48000, 1);
INSERT INTO `divisions` VALUES (610601, '市辖区', 3, 610600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (610602, '宝塔区', 3, 610600, 36.60000, 109.48000, 0);
INSERT INTO `divisions` VALUES (610621, '延长县', 3, 610600, 36.58000, 110.00000, 0);
INSERT INTO `divisions` VALUES (610622, '延川县', 3, 610600, 36.88000, 110.18000, 0);
INSERT INTO `divisions` VALUES (610623, '子长县', 3, 610600, 37.13000, 109.67000, 0);
INSERT INTO `divisions` VALUES (610624, '安塞县', 3, 610600, 36.87000, 109.32000, 0);
INSERT INTO `divisions` VALUES (610625, '志丹县', 3, 610600, 36.82000, 108.77000, 0);
INSERT INTO `divisions` VALUES (610626, '吴起县', 3, 610600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (610627, '甘泉县', 3, 610600, 36.28000, 109.35000, 0);
INSERT INTO `divisions` VALUES (610628, '富县', 3, 610600, 35.98000, 109.37000, 0);
INSERT INTO `divisions` VALUES (610629, '洛川县', 3, 610600, 35.77000, 109.43000, 0);
INSERT INTO `divisions` VALUES (610630, '宜川县', 3, 610600, 36.05000, 110.17000, 0);
INSERT INTO `divisions` VALUES (610631, '黄龙县', 3, 610600, 35.58000, 109.83000, 0);
INSERT INTO `divisions` VALUES (610632, '黄陵县', 3, 610600, 35.58000, 109.25000, 0);
INSERT INTO `divisions` VALUES (610700, '汉中市', 2, 610000, 33.07000, 107.02000, 1);
INSERT INTO `divisions` VALUES (610701, '市辖区', 3, 610700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (610702, '汉台区', 3, 610700, 33.07000, 107.03000, 0);
INSERT INTO `divisions` VALUES (610721, '南郑县', 3, 610700, 33.00000, 106.93000, 0);
INSERT INTO `divisions` VALUES (610722, '城固县', 3, 610700, 33.15000, 107.33000, 0);
INSERT INTO `divisions` VALUES (610723, '洋县', 3, 610700, 33.22000, 107.55000, 0);
INSERT INTO `divisions` VALUES (610724, '西乡县', 3, 610700, 32.98000, 107.77000, 0);
INSERT INTO `divisions` VALUES (610725, '勉县', 3, 610700, 33.15000, 106.67000, 0);
INSERT INTO `divisions` VALUES (610726, '宁强县', 3, 610700, 32.83000, 106.25000, 0);
INSERT INTO `divisions` VALUES (610727, '略阳县', 3, 610700, 33.33000, 106.15000, 0);
INSERT INTO `divisions` VALUES (610728, '镇巴县', 3, 610700, 32.53000, 107.90000, 0);
INSERT INTO `divisions` VALUES (610729, '留坝县', 3, 610700, 33.62000, 106.92000, 0);
INSERT INTO `divisions` VALUES (610730, '佛坪县', 3, 610700, 33.53000, 107.98000, 0);
INSERT INTO `divisions` VALUES (610800, '榆林市', 2, 610000, 38.28000, 109.73000, 1);
INSERT INTO `divisions` VALUES (610801, '市辖区', 3, 610800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (610802, '榆阳区', 3, 610800, 38.28000, 109.75000, 0);
INSERT INTO `divisions` VALUES (610821, '神木县', 3, 610800, 38.83000, 110.50000, 0);
INSERT INTO `divisions` VALUES (610822, '府谷县', 3, 610800, 39.03000, 111.07000, 0);
INSERT INTO `divisions` VALUES (610823, '横山县', 3, 610800, 37.95000, 109.28000, 0);
INSERT INTO `divisions` VALUES (610824, '靖边县', 3, 610800, 37.60000, 108.80000, 0);
INSERT INTO `divisions` VALUES (610825, '定边县', 3, 610800, 37.58000, 107.60000, 0);
INSERT INTO `divisions` VALUES (610826, '绥德县', 3, 610800, 37.50000, 110.25000, 0);
INSERT INTO `divisions` VALUES (610827, '米脂县', 3, 610800, 37.75000, 110.18000, 0);
INSERT INTO `divisions` VALUES (610828, '佳县', 3, 610800, 38.02000, 110.48000, 0);
INSERT INTO `divisions` VALUES (610829, '吴堡县', 3, 610800, 37.45000, 110.73000, 0);
INSERT INTO `divisions` VALUES (610830, '清涧县', 3, 610800, 37.08000, 110.12000, 0);
INSERT INTO `divisions` VALUES (610831, '子洲县', 3, 610800, 37.62000, 110.03000, 0);
INSERT INTO `divisions` VALUES (610900, '安康市', 2, 610000, 32.68000, 109.02000, 1);
INSERT INTO `divisions` VALUES (610901, '市辖区', 3, 610900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (610902, '汉滨区', 3, 610900, 32.68000, 109.02000, 0);
INSERT INTO `divisions` VALUES (610921, '汉阴县', 3, 610900, 32.90000, 108.50000, 0);
INSERT INTO `divisions` VALUES (610922, '石泉县', 3, 610900, 33.05000, 108.25000, 0);
INSERT INTO `divisions` VALUES (610923, '宁陕县', 3, 610900, 33.32000, 108.32000, 0);
INSERT INTO `divisions` VALUES (610924, '紫阳县', 3, 610900, 32.52000, 108.53000, 0);
INSERT INTO `divisions` VALUES (610925, '岚皋县', 3, 610900, 32.32000, 108.90000, 0);
INSERT INTO `divisions` VALUES (610926, '平利县', 3, 610900, 32.40000, 109.35000, 0);
INSERT INTO `divisions` VALUES (610927, '镇坪县', 3, 610900, 31.88000, 109.52000, 0);
INSERT INTO `divisions` VALUES (610928, '旬阳县', 3, 610900, 32.83000, 109.38000, 0);
INSERT INTO `divisions` VALUES (610929, '白河县', 3, 610900, 32.82000, 110.10000, 0);
INSERT INTO `divisions` VALUES (611000, '商洛市', 2, 610000, 33.87000, 109.93000, 1);
INSERT INTO `divisions` VALUES (611001, '市辖区', 3, 611000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (611002, '商州区', 3, 611000, 33.87000, 109.93000, 0);
INSERT INTO `divisions` VALUES (611021, '洛南县', 3, 611000, 34.08000, 110.13000, 0);
INSERT INTO `divisions` VALUES (611022, '丹凤县', 3, 611000, 33.70000, 110.33000, 0);
INSERT INTO `divisions` VALUES (611023, '商南县', 3, 611000, 33.53000, 110.88000, 0);
INSERT INTO `divisions` VALUES (611024, '山阳县', 3, 611000, 33.53000, 109.88000, 0);
INSERT INTO `divisions` VALUES (611025, '镇安县', 3, 611000, 33.43000, 109.15000, 0);
INSERT INTO `divisions` VALUES (611026, '柞水县', 3, 611000, 33.68000, 109.10000, 0);
INSERT INTO `divisions` VALUES (620000, '甘肃省', 1, 0, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (620100, '兰州市', 2, 620000, 36.07000, 103.82000, 1);
INSERT INTO `divisions` VALUES (620101, '市辖区', 3, 620100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (620102, '城关区', 3, 620100, 36.05000, 103.83000, 0);
INSERT INTO `divisions` VALUES (620103, '七里河区', 3, 620100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (620104, '西固区', 3, 620100, 36.10000, 103.62000, 0);
INSERT INTO `divisions` VALUES (620105, '安宁区', 3, 620100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (620111, '红古区', 3, 620100, 36.33000, 102.87000, 0);
INSERT INTO `divisions` VALUES (620121, '永登县', 3, 620100, 36.73000, 103.27000, 0);
INSERT INTO `divisions` VALUES (620122, '皋兰县', 3, 620100, 36.33000, 103.95000, 0);
INSERT INTO `divisions` VALUES (620123, '榆中县', 3, 620100, 35.85000, 104.12000, 0);
INSERT INTO `divisions` VALUES (620200, '嘉峪关市', 2, 620000, 39.80000, 98.27000, 1);
INSERT INTO `divisions` VALUES (620201, '市辖区', 3, 620200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (620300, '金昌市', 2, 620000, 38.50000, 102.18000, 1);
INSERT INTO `divisions` VALUES (620301, '市辖区', 3, 620300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (620302, '金川区', 3, 620300, 38.50000, 102.18000, 0);
INSERT INTO `divisions` VALUES (620321, '永昌县', 3, 620300, 38.25000, 101.97000, 0);
INSERT INTO `divisions` VALUES (620400, '白银市', 2, 620000, 36.55000, 104.18000, 1);
INSERT INTO `divisions` VALUES (620401, '市辖区', 3, 620400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (620402, '白银区', 3, 620400, 36.55000, 104.18000, 0);
INSERT INTO `divisions` VALUES (620403, '平川区', 3, 620400, 36.73000, 104.83000, 0);
INSERT INTO `divisions` VALUES (620421, '靖远县', 3, 620400, 36.57000, 104.68000, 0);
INSERT INTO `divisions` VALUES (620422, '会宁县', 3, 620400, 35.70000, 105.05000, 0);
INSERT INTO `divisions` VALUES (620423, '景泰县', 3, 620400, 37.15000, 104.07000, 0);
INSERT INTO `divisions` VALUES (620500, '天水市', 2, 620000, 34.58000, 105.72000, 1);
INSERT INTO `divisions` VALUES (620501, '市辖区', 3, 620500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (620502, '秦州区', 3, 620500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (620503, '麦积区', 3, 620500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (620521, '清水县', 3, 620500, 34.75000, 106.13000, 0);
INSERT INTO `divisions` VALUES (620522, '秦安县', 3, 620500, 34.87000, 105.67000, 0);
INSERT INTO `divisions` VALUES (620523, '甘谷县', 3, 620500, 34.73000, 105.33000, 0);
INSERT INTO `divisions` VALUES (620524, '武山县', 3, 620500, 34.72000, 104.88000, 0);
INSERT INTO `divisions` VALUES (620525, '张家川回族自治县', 3, 620500, 35.00000, 106.22000, 0);
INSERT INTO `divisions` VALUES (620600, '武威市', 2, 620000, 37.93000, 102.63000, 1);
INSERT INTO `divisions` VALUES (620601, '市辖区', 3, 620600, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (620602, '凉州区', 3, 620600, 37.93000, 102.63000, 0);
INSERT INTO `divisions` VALUES (620621, '民勤县', 3, 620600, 38.62000, 103.08000, 0);
INSERT INTO `divisions` VALUES (620622, '古浪县', 3, 620600, 37.47000, 102.88000, 0);
INSERT INTO `divisions` VALUES (620623, '天祝藏族自治县', 3, 620600, 36.98000, 103.13000, 0);
INSERT INTO `divisions` VALUES (620700, '张掖市', 2, 620000, 38.93000, 100.45000, 1);
INSERT INTO `divisions` VALUES (620701, '市辖区', 3, 620700, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (620702, '甘州区', 3, 620700, 38.93000, 100.45000, 0);
INSERT INTO `divisions` VALUES (620721, '肃南裕固族自治县', 3, 620700, 38.83000, 99.62000, 0);
INSERT INTO `divisions` VALUES (620722, '民乐县', 3, 620700, 38.43000, 100.82000, 0);
INSERT INTO `divisions` VALUES (620723, '临泽县', 3, 620700, 39.13000, 100.17000, 0);
INSERT INTO `divisions` VALUES (620724, '高台县', 3, 620700, 39.38000, 99.82000, 0);
INSERT INTO `divisions` VALUES (620725, '山丹县', 3, 620700, 38.78000, 101.08000, 0);
INSERT INTO `divisions` VALUES (620800, '平凉市', 2, 620000, 35.55000, 106.67000, 1);
INSERT INTO `divisions` VALUES (620801, '市辖区', 3, 620800, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (620802, '崆峒区', 3, 620800, 35.55000, 106.67000, 0);
INSERT INTO `divisions` VALUES (620821, '泾川县', 3, 620800, 35.33000, 107.37000, 0);
INSERT INTO `divisions` VALUES (620822, '灵台县', 3, 620800, 35.07000, 107.62000, 0);
INSERT INTO `divisions` VALUES (620823, '崇信县', 3, 620800, 35.30000, 107.03000, 0);
INSERT INTO `divisions` VALUES (620824, '华亭县', 3, 620800, 35.22000, 106.65000, 0);
INSERT INTO `divisions` VALUES (620825, '庄浪县', 3, 620800, 35.20000, 106.05000, 0);
INSERT INTO `divisions` VALUES (620826, '静宁县', 3, 620800, 35.52000, 105.72000, 0);
INSERT INTO `divisions` VALUES (620900, '酒泉市', 2, 620000, 39.75000, 98.52000, 1);
INSERT INTO `divisions` VALUES (620901, '市辖区', 3, 620900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (620902, '肃州区', 3, 620900, 39.75000, 98.52000, 0);
INSERT INTO `divisions` VALUES (620921, '金塔县', 3, 620900, 39.98000, 98.90000, 0);
INSERT INTO `divisions` VALUES (620922, '瓜州县', 3, 620900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (620923, '肃北蒙古族自治县', 3, 620900, 39.52000, 94.88000, 0);
INSERT INTO `divisions` VALUES (620924, '阿克塞哈萨克族自治县', 3, 620900, 39.63000, 94.33000, 0);
INSERT INTO `divisions` VALUES (620981, '玉门市', 3, 621000, 40.28000, 97.05000, 1);
INSERT INTO `divisions` VALUES (620982, '敦煌市', 3, 621000, 40.13000, 94.67000, 1);
INSERT INTO `divisions` VALUES (621000, '庆阳市', 2, 620000, 35.73000, 107.63000, 1);
INSERT INTO `divisions` VALUES (621001, '市辖区', 3, 621000, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (621002, '西峰区', 3, 621000, 35.73000, 107.63000, 0);
INSERT INTO `divisions` VALUES (621021, '庆城县', 3, 621000, 36.00000, 107.88000, 0);
INSERT INTO `divisions` VALUES (621022, '环县', 3, 621000, 36.58000, 107.30000, 0);
INSERT INTO `divisions` VALUES (621023, '华池县', 3, 621000, 36.47000, 107.98000, 0);
INSERT INTO `divisions` VALUES (621024, '合水县', 3, 621000, 35.82000, 108.02000, 0);
INSERT INTO `divisions` VALUES (621025, '正宁县', 3, 621000, 35.50000, 108.37000, 0);
INSERT INTO `divisions` VALUES (621026, '宁县', 3, 621000, 35.50000, 107.92000, 0);
INSERT INTO `divisions` VALUES (621027, '镇原县', 3, 621000, 35.68000, 107.20000, 0);
INSERT INTO `divisions` VALUES (621100, '定西市', 2, 620000, 35.58000, 104.62000, 1);
INSERT INTO `divisions` VALUES (621101, '市辖区', 3, 621100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (621102, '安定区', 3, 621100, 35.58000, 104.62000, 0);
INSERT INTO `divisions` VALUES (621121, '通渭县', 3, 621100, 35.20000, 105.25000, 0);
INSERT INTO `divisions` VALUES (621122, '陇西县', 3, 621100, 35.00000, 104.63000, 0);
INSERT INTO `divisions` VALUES (621123, '渭源县', 3, 621100, 35.13000, 104.22000, 0);
INSERT INTO `divisions` VALUES (621124, '临洮县', 3, 621100, 35.38000, 103.87000, 0);
INSERT INTO `divisions` VALUES (621125, '漳县', 3, 621100, 34.85000, 104.47000, 0);
INSERT INTO `divisions` VALUES (621126, '岷县', 3, 621100, 34.43000, 104.03000, 0);
INSERT INTO `divisions` VALUES (621200, '陇南市', 2, 620000, 33.40000, 104.92000, 1);
INSERT INTO `divisions` VALUES (621201, '市辖区', 3, 621200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (621202, '武都区', 3, 621200, 33.40000, 104.92000, 0);
INSERT INTO `divisions` VALUES (621221, '成县', 3, 621200, 33.73000, 105.72000, 0);
INSERT INTO `divisions` VALUES (621222, '文县', 3, 621200, 32.95000, 104.68000, 0);
INSERT INTO `divisions` VALUES (621223, '宕昌县', 3, 621200, 34.05000, 104.38000, 0);
INSERT INTO `divisions` VALUES (621224, '康县', 3, 621200, 33.33000, 105.60000, 0);
INSERT INTO `divisions` VALUES (621225, '西和县', 3, 621200, 34.02000, 105.30000, 0);
INSERT INTO `divisions` VALUES (621226, '礼县', 3, 621200, 34.18000, 105.17000, 0);
INSERT INTO `divisions` VALUES (621227, '徽县', 3, 621200, 33.77000, 106.08000, 0);
INSERT INTO `divisions` VALUES (621228, '两当县', 3, 621200, 33.92000, 106.30000, 0);
INSERT INTO `divisions` VALUES (622900, '临夏回族自治州', 2, 620000, 35.60000, 103.22000, 1);
INSERT INTO `divisions` VALUES (622901, '临夏市', 3, 622900, 35.60000, 103.22000, 1);
INSERT INTO `divisions` VALUES (622921, '临夏县', 3, 622900, 35.50000, 103.00000, 0);
INSERT INTO `divisions` VALUES (622922, '康乐县', 3, 622900, 35.37000, 103.72000, 0);
INSERT INTO `divisions` VALUES (622923, '永靖县', 3, 622900, 35.93000, 103.32000, 0);
INSERT INTO `divisions` VALUES (622924, '广河县', 3, 622900, 35.48000, 103.58000, 0);
INSERT INTO `divisions` VALUES (622925, '和政县', 3, 622900, 35.43000, 103.35000, 0);
INSERT INTO `divisions` VALUES (622926, '东乡族自治县', 3, 622900, 35.67000, 103.40000, 0);
INSERT INTO `divisions` VALUES (622927, '积石山保安族东乡族撒拉族自治县', 3, 622900, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (623000, '甘南藏族自治州', 2, 620000, 34.98000, 102.92000, 1);
INSERT INTO `divisions` VALUES (623001, '合作市', 3, 623000, 34.98000, 102.92000, 1);
INSERT INTO `divisions` VALUES (623021, '临潭县', 3, 623000, 34.70000, 103.35000, 0);
INSERT INTO `divisions` VALUES (623022, '卓尼县', 3, 623000, 34.58000, 103.50000, 0);
INSERT INTO `divisions` VALUES (623023, '舟曲县', 3, 623000, 33.78000, 104.37000, 0);
INSERT INTO `divisions` VALUES (623024, '迭部县', 3, 623000, 34.05000, 103.22000, 0);
INSERT INTO `divisions` VALUES (623025, '玛曲县', 3, 623000, 34.00000, 102.07000, 0);
INSERT INTO `divisions` VALUES (623026, '碌曲县', 3, 623000, 34.58000, 102.48000, 0);
INSERT INTO `divisions` VALUES (623027, '夏河县', 3, 623000, 35.20000, 102.52000, 0);
INSERT INTO `divisions` VALUES (630000, '青海省', 1, 0, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (630100, '西宁市', 2, 630000, 36.62000, 101.78000, 1);
INSERT INTO `divisions` VALUES (630101, '市辖区', 3, 630100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (630102, '城东区', 3, 630100, 36.62000, 101.80000, 0);
INSERT INTO `divisions` VALUES (630103, '城中区', 3, 630100, 36.62000, 101.78000, 0);
INSERT INTO `divisions` VALUES (630104, '城西区', 3, 630100, 36.62000, 101.77000, 0);
INSERT INTO `divisions` VALUES (630105, '城北区', 3, 630100, 36.67000, 101.77000, 0);
INSERT INTO `divisions` VALUES (630121, '大通回族土族自治县', 3, 630100, 36.93000, 101.68000, 0);
INSERT INTO `divisions` VALUES (630122, '湟中县', 3, 630100, 36.50000, 101.57000, 0);
INSERT INTO `divisions` VALUES (630123, '湟源县', 3, 630100, 36.68000, 101.27000, 0);
INSERT INTO `divisions` VALUES (632100, '海东地区', 2, 630000, 36.50000, 102.12000, 0);
INSERT INTO `divisions` VALUES (632121, '平安县', 3, 632100, 36.50000, 102.12000, 0);
INSERT INTO `divisions` VALUES (632122, '民和回族土族自治县', 3, 632100, 36.33000, 102.80000, 0);
INSERT INTO `divisions` VALUES (632123, '乐都县', 3, 632100, 36.48000, 102.40000, 0);
INSERT INTO `divisions` VALUES (632126, '互助土族自治县', 3, 632100, 36.83000, 101.95000, 0);
INSERT INTO `divisions` VALUES (632127, '化隆回族自治县', 3, 632100, 36.10000, 102.27000, 0);
INSERT INTO `divisions` VALUES (632128, '循化撒拉族自治县', 3, 632100, 35.85000, 102.48000, 0);
INSERT INTO `divisions` VALUES (632200, '海北藏族自治州', 2, 630000, 36.97000, 100.90000, 1);
INSERT INTO `divisions` VALUES (632221, '门源回族自治县', 3, 632200, 37.38000, 101.62000, 0);
INSERT INTO `divisions` VALUES (632222, '祁连县', 3, 632200, 38.18000, 100.25000, 0);
INSERT INTO `divisions` VALUES (632223, '海晏县', 3, 632200, 36.90000, 100.98000, 0);
INSERT INTO `divisions` VALUES (632224, '刚察县', 3, 632200, 37.33000, 100.13000, 0);
INSERT INTO `divisions` VALUES (632300, '黄南藏族自治州', 2, 630000, 35.52000, 102.02000, 1);
INSERT INTO `divisions` VALUES (632321, '同仁县', 3, 632300, 35.52000, 102.02000, 0);
INSERT INTO `divisions` VALUES (632322, '尖扎县', 3, 632300, 35.93000, 102.03000, 0);
INSERT INTO `divisions` VALUES (632323, '泽库县', 3, 632300, 35.03000, 101.47000, 0);
INSERT INTO `divisions` VALUES (632324, '河南蒙古族自治县', 3, 632300, 34.73000, 101.60000, 0);
INSERT INTO `divisions` VALUES (632500, '海南藏族自治州', 2, 630000, 36.28000, 100.62000, 1);
INSERT INTO `divisions` VALUES (632521, '共和县', 3, 632500, 36.28000, 100.62000, 0);
INSERT INTO `divisions` VALUES (632522, '同德县', 3, 632500, 35.25000, 100.57000, 0);
INSERT INTO `divisions` VALUES (632523, '贵德县', 3, 632500, 36.05000, 101.43000, 0);
INSERT INTO `divisions` VALUES (632524, '兴海县', 3, 632500, 35.58000, 99.98000, 0);
INSERT INTO `divisions` VALUES (632525, '贵南县', 3, 632500, 35.58000, 100.75000, 0);
INSERT INTO `divisions` VALUES (632600, '果洛藏族自治州', 2, 630000, 34.48000, 100.23000, 1);
INSERT INTO `divisions` VALUES (632621, '玛沁县', 3, 632600, 34.48000, 100.23000, 0);
INSERT INTO `divisions` VALUES (632622, '班玛县', 3, 632600, 32.93000, 100.73000, 0);
INSERT INTO `divisions` VALUES (632623, '甘德县', 3, 632600, 33.97000, 99.90000, 0);
INSERT INTO `divisions` VALUES (632624, '达日县', 3, 632600, 33.75000, 99.65000, 0);
INSERT INTO `divisions` VALUES (632625, '久治县', 3, 632600, 33.43000, 101.48000, 0);
INSERT INTO `divisions` VALUES (632626, '玛多县', 3, 632600, 34.92000, 98.18000, 0);
INSERT INTO `divisions` VALUES (632700, '玉树藏族自治州', 2, 630000, 33.00000, 97.02000, 1);
INSERT INTO `divisions` VALUES (632721, '玉树县', 3, 632700, 33.00000, 97.02000, 0);
INSERT INTO `divisions` VALUES (632722, '杂多县', 3, 632700, 32.90000, 95.30000, 0);
INSERT INTO `divisions` VALUES (632723, '称多县', 3, 632700, 33.37000, 97.10000, 0);
INSERT INTO `divisions` VALUES (632724, '治多县', 3, 632700, 33.85000, 95.62000, 0);
INSERT INTO `divisions` VALUES (632725, '囊谦县', 3, 632700, 32.20000, 96.48000, 0);
INSERT INTO `divisions` VALUES (632726, '曲麻莱县', 3, 632700, 34.13000, 95.80000, 0);
INSERT INTO `divisions` VALUES (632800, '海西蒙古族藏族自治州', 2, 630000, 37.37000, 97.37000, 1);
INSERT INTO `divisions` VALUES (632801, '格尔木市', 3, 632800, 36.42000, 94.90000, 1);
INSERT INTO `divisions` VALUES (632802, '德令哈市', 3, 632800, 37.37000, 97.37000, 1);
INSERT INTO `divisions` VALUES (632821, '乌兰县', 3, 632800, 36.93000, 98.48000, 0);
INSERT INTO `divisions` VALUES (632822, '都兰县', 3, 632800, 36.30000, 98.08000, 0);
INSERT INTO `divisions` VALUES (632823, '天峻县', 3, 632800, 37.30000, 99.02000, 0);
INSERT INTO `divisions` VALUES (640000, '宁夏回族自治区', 1, 0, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (640100, '银川市', 2, 640000, 38.47000, 106.28000, 1);
INSERT INTO `divisions` VALUES (640101, '市辖区', 3, 640100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (640104, '兴庆区', 3, 640100, 38.48000, 106.28000, 0);
INSERT INTO `divisions` VALUES (640105, '西夏区', 3, 640100, 38.48000, 106.18000, 0);
INSERT INTO `divisions` VALUES (640106, '金凤区', 3, 640100, 38.47000, 106.25000, 0);
INSERT INTO `divisions` VALUES (640121, '永宁县', 3, 640100, 38.28000, 106.25000, 0);
INSERT INTO `divisions` VALUES (640122, '贺兰县', 3, 640100, 38.55000, 106.35000, 0);
INSERT INTO `divisions` VALUES (640181, '灵武市', 3, 640200, 38.10000, 106.33000, 1);
INSERT INTO `divisions` VALUES (640200, '石嘴山市', 2, 640000, 39.02000, 106.38000, 1);
INSERT INTO `divisions` VALUES (640201, '市辖区', 3, 640200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (640202, '大武口区', 3, 640200, 39.02000, 106.38000, 0);
INSERT INTO `divisions` VALUES (640205, '惠农区', 3, 640200, 39.25000, 106.78000, 0);
INSERT INTO `divisions` VALUES (640221, '平罗县', 3, 640200, 38.90000, 106.53000, 0);
INSERT INTO `divisions` VALUES (640300, '吴忠市', 2, 640000, 37.98000, 106.20000, 1);
INSERT INTO `divisions` VALUES (640301, '市辖区', 3, 640300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (640302, '利通区', 3, 640300, 37.98000, 106.20000, 0);
INSERT INTO `divisions` VALUES (640303, '红寺堡区', 3, 640300, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (640323, '盐池县', 3, 640300, 37.78000, 107.40000, 0);
INSERT INTO `divisions` VALUES (640324, '同心县', 3, 640300, 36.98000, 105.92000, 0);
INSERT INTO `divisions` VALUES (640381, '青铜峡市', 3, 640400, 38.02000, 106.07000, 1);
INSERT INTO `divisions` VALUES (640400, '固原市', 2, 640000, 36.00000, 106.28000, 1);
INSERT INTO `divisions` VALUES (640401, '市辖区', 3, 640400, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (640402, '原州区', 3, 640400, 36.00000, 106.28000, 0);
INSERT INTO `divisions` VALUES (640422, '西吉县', 3, 640400, 35.97000, 105.73000, 0);
INSERT INTO `divisions` VALUES (640423, '隆德县', 3, 640400, 35.62000, 106.12000, 0);
INSERT INTO `divisions` VALUES (640424, '泾源县', 3, 640400, 35.48000, 106.33000, 0);
INSERT INTO `divisions` VALUES (640425, '彭阳县', 3, 640400, 35.85000, 106.63000, 0);
INSERT INTO `divisions` VALUES (640500, '中卫市', 2, 640000, 37.52000, 105.18000, 1);
INSERT INTO `divisions` VALUES (640501, '市辖区', 3, 640500, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (640502, '沙坡头区', 3, 640500, 37.52000, 105.18000, 0);
INSERT INTO `divisions` VALUES (640521, '中宁县', 3, 640500, 37.48000, 105.67000, 0);
INSERT INTO `divisions` VALUES (640522, '海原县', 3, 640500, 36.57000, 105.65000, 0);
INSERT INTO `divisions` VALUES (650000, '新疆维吾尔自治区', 1, 0, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (650100, '乌鲁木齐市', 2, 650000, 43.82000, 87.62000, 1);
INSERT INTO `divisions` VALUES (650101, '市辖区', 3, 650100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (650102, '天山区', 3, 650100, 43.78000, 87.65000, 0);
INSERT INTO `divisions` VALUES (650103, '沙依巴克区', 3, 650100, 43.78000, 87.60000, 0);
INSERT INTO `divisions` VALUES (650104, '新市区', 3, 650100, 43.85000, 87.60000, 0);
INSERT INTO `divisions` VALUES (650105, '水磨沟区', 3, 650100, 43.83000, 87.63000, 0);
INSERT INTO `divisions` VALUES (650106, '头屯河区', 3, 650100, 43.87000, 87.42000, 0);
INSERT INTO `divisions` VALUES (650107, '达坂城区', 3, 650100, 43.35000, 88.30000, 0);
INSERT INTO `divisions` VALUES (650109, '米东区', 3, 650100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (650121, '乌鲁木齐县', 3, 650100, 43.80000, 87.60000, 0);
INSERT INTO `divisions` VALUES (650200, '克拉玛依市', 2, 650000, 45.60000, 84.87000, 1);
INSERT INTO `divisions` VALUES (650201, '市辖区', 3, 650200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (650202, '独山子区', 3, 650200, 44.32000, 84.85000, 0);
INSERT INTO `divisions` VALUES (650203, '克拉玛依区', 3, 650200, 45.60000, 84.87000, 0);
INSERT INTO `divisions` VALUES (650204, '白碱滩区', 3, 650200, 45.70000, 85.13000, 0);
INSERT INTO `divisions` VALUES (650205, '乌尔禾区', 3, 650200, 46.08000, 85.68000, 0);
INSERT INTO `divisions` VALUES (652100, '吐鲁番地区', 2, 650000, 42.95000, 89.17000, 0);
INSERT INTO `divisions` VALUES (652101, '吐鲁番市', 3, 652100, 42.95000, 89.17000, 1);
INSERT INTO `divisions` VALUES (652122, '鄯善县', 3, 652100, 42.87000, 90.22000, 0);
INSERT INTO `divisions` VALUES (652123, '托克逊县', 3, 652100, 42.78000, 88.65000, 0);
INSERT INTO `divisions` VALUES (652200, '哈密地区', 2, 650000, 42.83000, 93.52000, 0);
INSERT INTO `divisions` VALUES (652201, '哈密市', 3, 652200, 42.83000, 93.52000, 1);
INSERT INTO `divisions` VALUES (652222, '巴里坤哈萨克自治县', 3, 652200, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (652223, '伊吾县', 3, 652200, 43.25000, 94.70000, 0);
INSERT INTO `divisions` VALUES (652300, '昌吉回族自治州', 2, 650000, 44.02000, 87.30000, 1);
INSERT INTO `divisions` VALUES (652301, '昌吉市', 3, 652300, 44.02000, 87.30000, 1);
INSERT INTO `divisions` VALUES (652302, '阜康市', 3, 652300, 44.15000, 87.98000, 1);
INSERT INTO `divisions` VALUES (652323, '呼图壁县', 3, 652300, 44.18000, 86.90000, 0);
INSERT INTO `divisions` VALUES (652324, '玛纳斯县', 3, 652300, 44.30000, 86.22000, 0);
INSERT INTO `divisions` VALUES (652325, '奇台县', 3, 652300, 44.02000, 89.58000, 0);
INSERT INTO `divisions` VALUES (652327, '吉木萨尔县', 3, 652300, 44.00000, 89.18000, 0);
INSERT INTO `divisions` VALUES (652328, '木垒哈萨克自治县', 3, 652300, 43.83000, 90.28000, 0);
INSERT INTO `divisions` VALUES (652700, '博尔塔拉蒙古自治州', 2, 650000, 44.90000, 82.07000, 1);
INSERT INTO `divisions` VALUES (652701, '博乐市', 3, 652700, 44.90000, 82.07000, 1);
INSERT INTO `divisions` VALUES (652722, '精河县', 3, 652700, 44.60000, 82.88000, 0);
INSERT INTO `divisions` VALUES (652723, '温泉县', 3, 652700, 44.97000, 81.03000, 0);
INSERT INTO `divisions` VALUES (652800, '巴音郭楞蒙古自治州', 2, 650000, 41.77000, 86.15000, 1);
INSERT INTO `divisions` VALUES (652801, '库尔勒市', 3, 652800, 41.77000, 86.15000, 1);
INSERT INTO `divisions` VALUES (652822, '轮台县', 3, 652800, 41.78000, 84.27000, 0);
INSERT INTO `divisions` VALUES (652823, '尉犁县', 3, 652800, 41.33000, 86.25000, 0);
INSERT INTO `divisions` VALUES (652824, '若羌县', 3, 652800, 39.02000, 88.17000, 0);
INSERT INTO `divisions` VALUES (652825, '且末县', 3, 652800, 38.13000, 85.53000, 0);
INSERT INTO `divisions` VALUES (652826, '焉耆回族自治县', 3, 652800, 42.07000, 86.57000, 0);
INSERT INTO `divisions` VALUES (652827, '和静县', 3, 652800, 42.32000, 86.40000, 0);
INSERT INTO `divisions` VALUES (652828, '和硕县', 3, 652800, 42.27000, 86.87000, 0);
INSERT INTO `divisions` VALUES (652829, '博湖县', 3, 652800, 41.98000, 86.63000, 0);
INSERT INTO `divisions` VALUES (652900, '阿克苏地区', 2, 650000, 41.17000, 80.27000, 0);
INSERT INTO `divisions` VALUES (652901, '阿克苏市', 3, 652900, 41.17000, 80.27000, 1);
INSERT INTO `divisions` VALUES (652922, '温宿县', 3, 652900, 41.28000, 80.23000, 0);
INSERT INTO `divisions` VALUES (652923, '库车县', 3, 652900, 41.72000, 82.97000, 0);
INSERT INTO `divisions` VALUES (652924, '沙雅县', 3, 652900, 41.22000, 82.78000, 0);
INSERT INTO `divisions` VALUES (652925, '新和县', 3, 652900, 41.55000, 82.60000, 0);
INSERT INTO `divisions` VALUES (652926, '拜城县', 3, 652900, 41.80000, 81.87000, 0);
INSERT INTO `divisions` VALUES (652927, '乌什县', 3, 652900, 41.22000, 79.23000, 0);
INSERT INTO `divisions` VALUES (652928, '阿瓦提县', 3, 652900, 40.63000, 80.38000, 0);
INSERT INTO `divisions` VALUES (652929, '柯坪县', 3, 652900, 40.50000, 79.05000, 0);
INSERT INTO `divisions` VALUES (653000, '克孜勒苏柯尔克孜自治州', 2, 650000, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (653001, '阿图什市', 3, 653000, 39.72000, 76.17000, 1);
INSERT INTO `divisions` VALUES (653022, '阿克陶县', 3, 653000, 39.15000, 75.95000, 0);
INSERT INTO `divisions` VALUES (653023, '阿合奇县', 3, 653000, 40.93000, 78.45000, 0);
INSERT INTO `divisions` VALUES (653024, '乌恰县', 3, 653000, 39.72000, 75.25000, 0);
INSERT INTO `divisions` VALUES (653100, '喀什地区', 2, 650000, 39.47000, 75.98000, 0);
INSERT INTO `divisions` VALUES (653101, '喀什市', 3, 653100, 39.47000, 75.98000, 1);
INSERT INTO `divisions` VALUES (653121, '疏附县', 3, 653100, 39.38000, 75.85000, 0);
INSERT INTO `divisions` VALUES (653122, '疏勒县', 3, 653100, 39.40000, 76.05000, 0);
INSERT INTO `divisions` VALUES (653123, '英吉沙县', 3, 653100, 38.93000, 76.17000, 0);
INSERT INTO `divisions` VALUES (653124, '泽普县', 3, 653100, 38.18000, 77.27000, 0);
INSERT INTO `divisions` VALUES (653125, '莎车县', 3, 653100, 38.42000, 77.23000, 0);
INSERT INTO `divisions` VALUES (653126, '叶城县', 3, 653100, 37.88000, 77.42000, 0);
INSERT INTO `divisions` VALUES (653127, '麦盖提县', 3, 653100, 38.90000, 77.65000, 0);
INSERT INTO `divisions` VALUES (653128, '岳普湖县', 3, 653100, 39.23000, 76.77000, 0);
INSERT INTO `divisions` VALUES (653129, '伽师县', 3, 653100, 39.50000, 76.73000, 0);
INSERT INTO `divisions` VALUES (653130, '巴楚县', 3, 653100, 39.78000, 78.55000, 0);
INSERT INTO `divisions` VALUES (653131, '塔什库尔干塔吉克自治县', 3, 653100, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (653200, '和田地区', 2, 650000, 37.12000, 79.92000, 0);
INSERT INTO `divisions` VALUES (653201, '和田市', 3, 653200, 37.12000, 79.92000, 1);
INSERT INTO `divisions` VALUES (653221, '和田县', 3, 653200, 37.10000, 79.93000, 0);
INSERT INTO `divisions` VALUES (653222, '墨玉县', 3, 653200, 37.27000, 79.73000, 0);
INSERT INTO `divisions` VALUES (653223, '皮山县', 3, 653200, 37.62000, 78.28000, 0);
INSERT INTO `divisions` VALUES (653224, '洛浦县', 3, 653200, 37.07000, 80.18000, 0);
INSERT INTO `divisions` VALUES (653225, '策勒县', 3, 653200, 37.00000, 80.80000, 0);
INSERT INTO `divisions` VALUES (653226, '于田县', 3, 653200, 36.85000, 81.67000, 0);
INSERT INTO `divisions` VALUES (653227, '民丰县', 3, 653200, 37.07000, 82.68000, 0);
INSERT INTO `divisions` VALUES (654000, '伊犁哈萨克自治州', 2, 650000, 43.92000, 81.32000, 1);
INSERT INTO `divisions` VALUES (654002, '伊宁市', 3, 654000, 43.92000, 81.32000, 1);
INSERT INTO `divisions` VALUES (654003, '奎屯市', 3, 654000, 44.42000, 84.90000, 1);
INSERT INTO `divisions` VALUES (654021, '伊宁县', 3, 654000, 43.98000, 81.52000, 0);
INSERT INTO `divisions` VALUES (654022, '察布查尔锡伯自治县', 3, 654000, 43.83000, 81.15000, 0);
INSERT INTO `divisions` VALUES (654023, '霍城县', 3, 654000, 44.05000, 80.88000, 0);
INSERT INTO `divisions` VALUES (654024, '巩留县', 3, 654000, 43.48000, 82.23000, 0);
INSERT INTO `divisions` VALUES (654025, '新源县', 3, 654000, 43.43000, 83.25000, 0);
INSERT INTO `divisions` VALUES (654026, '昭苏县', 3, 654000, 43.15000, 81.13000, 0);
INSERT INTO `divisions` VALUES (654027, '特克斯县', 3, 654000, 43.22000, 81.83000, 0);
INSERT INTO `divisions` VALUES (654028, '尼勒克县', 3, 654000, 43.78000, 82.50000, 0);
INSERT INTO `divisions` VALUES (654200, '塔城地区', 2, 650000, 46.75000, 82.98000, 0);
INSERT INTO `divisions` VALUES (654201, '塔城市', 3, 654200, 46.75000, 82.98000, 1);
INSERT INTO `divisions` VALUES (654202, '乌苏市', 3, 654200, 44.43000, 84.68000, 1);
INSERT INTO `divisions` VALUES (654221, '额敏县', 3, 654200, 46.53000, 83.63000, 0);
INSERT INTO `divisions` VALUES (654223, '沙湾县', 3, 654200, 44.33000, 85.62000, 0);
INSERT INTO `divisions` VALUES (654224, '托里县', 3, 654200, 45.93000, 83.60000, 0);
INSERT INTO `divisions` VALUES (654225, '裕民县', 3, 654200, 46.20000, 82.98000, 0);
INSERT INTO `divisions` VALUES (654226, '和布克赛尔蒙古自治县', 3, 654200, 46.80000, 85.72000, 0);
INSERT INTO `divisions` VALUES (654300, '阿勒泰地区', 2, 650000, 47.85000, 88.13000, 0);
INSERT INTO `divisions` VALUES (654301, '阿勒泰市', 3, 654300, 47.85000, 88.13000, 1);
INSERT INTO `divisions` VALUES (654321, '布尔津县', 3, 654300, 47.70000, 86.85000, 0);
INSERT INTO `divisions` VALUES (654322, '富蕴县', 3, 654300, 47.00000, 89.52000, 0);
INSERT INTO `divisions` VALUES (654323, '福海县', 3, 654300, 47.12000, 87.50000, 0);
INSERT INTO `divisions` VALUES (654324, '哈巴河县', 3, 654300, 48.07000, 86.42000, 0);
INSERT INTO `divisions` VALUES (654325, '青河县', 3, 654300, 46.67000, 90.38000, 0);
INSERT INTO `divisions` VALUES (654326, '吉木乃县', 3, 654300, 47.43000, 85.88000, 0);
INSERT INTO `divisions` VALUES (659000, '自治区直辖县级行政区划', 2, 660000, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (659001, '石河子市', 3, 659000, 44.30000, 86.03000, 1);
INSERT INTO `divisions` VALUES (659002, '阿拉尔市', 3, 659000, 40.55000, 81.28000, 1);
INSERT INTO `divisions` VALUES (659003, '图木舒克市', 3, 659000, 39.85000, 79.13000, 1);
INSERT INTO `divisions` VALUES (659004, '五家渠市', 3, 659000, 44.17000, 87.53000, 1);
INSERT INTO `divisions` VALUES (710000, '台湾省', 1, 0, 0.00000, 0.00000, 1);
INSERT INTO `divisions` VALUES (810000, '香港特别行政区', 1, 0, 0.00000, 0.00000, 0);
INSERT INTO `divisions` VALUES (820000, '澳门特别行政区', 1, 0, 0.00000, 0.00000, 0);


INSERT INTO `settings` (`id`, `group`, `key`) VALUES
(1012, '零散租期非整月', '不设置零散租金'),
(1013, '零散租期非整月', '零散期前置'),
(1014, '零散租期非整月', '零散期后置'),
(1015, '零散租期非整月', '零散期前后置（灵活）'),
(1021, '零散租期整月', '不设置零散租金'),
(1022, '零散租期整月', '零散期前后置（月末）'),
(1023, '零散租期整月', '零散期前后置（灵活）'),
(1031, '付款方式', '1月一付'),
(1032, '付款方式', '2月一付'),
(1033, '付款方式', '3月一付'),
(1034, '付款方式', '4月一付'),
(1035, '付款方式', '半年一付'),
(1036, '付款方式', '1年一付'),
(1037, '付款方式', '一次付清'),
(1041, '加收费用', '电费'),
(1042, '加收费用', '煤气费'),
(1043, '加收费用', '冷水费'),
(1044, '加收费用', '热水费'),
(1045, '加收费用', '网费'),
(1046, '加收费用', '电视费'),
(1047, '加收费用', '物业费'),
(1048, '加收费用', '维修费'),
(1049, '加收费用', '保洁费'),
(1050, '加收费用', '保险费'),
(1051, '加收费用', '服务费'),
(1061, '零散租期非整月', '常规押金'),
(1062, '零散租期非整月', '门卡押金'),
(1063, '零散租期非整月', '钥匙押金'),
(1064, '零散租期非整月', '家具押金'),
(1065, '零散租期非整月', '家电押金');

INSERT INTO `settings` (`id`, `group`, `key`, `value`) VALUES
(1071, '默认显示押金', '常规押金', 123400);

INSERT INTO `settings` (`id`, `group`, `key`, `value`, `valueRange`) VALUES
(1081, '支付时间', '账单开始前提前', '0天', '["0天", "1天", "2天"]'),
(1082, '支付时间', '账单开始后固定', '1号', '["1号", "2号", "3号"]'),
(1083, '支付时间', '账单开始前固定', '1号', '["1号", "2号", "3号"]'),
(1084, '支付时间', '账单开始前1个月固定', '1号', '["1号", "2号", "3号"]');


INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (1, 'CDB', '国家开发银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (2, 'ICBC', '中国工商银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (3, 'ABC', '中国农业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (4, 'BOC', '中国银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (5, 'CCB', '中国建设银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (6, 'PSBC', '中国邮政储蓄银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (7, 'COMM', '交通银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (8, 'CMB', '招商银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (9, 'SPDB', '上海浦东发展银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (10, 'CIB', '兴业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (11, 'HXBANK', '华夏银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (12, 'GDB', '广东发展银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (13, 'CMBC', '中国民生银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (14, 'CITIC', '中信银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (15, 'CEB', '中国光大银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (16, 'EGBANK', '恒丰银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (17, 'CZBANK', '浙商银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (18, 'BOHAIB', '渤海银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (19, 'SPABANK', '平安银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (20, 'SHRCB', '上海农村商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (21, 'YXCCB', '玉溪市商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (22, 'YDRCB', '尧都农商行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (23, 'BJBANK', '北京银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (24, 'SHBANK', '上海银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (25, 'JSBANK', '江苏银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (26, 'HZCB', '杭州银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (27, 'NJCB', '南京银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (28, 'NBBANK', '宁波银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (29, 'HSBANK', '徽商银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (30, 'CSCB', '长沙银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (31, 'CDCB', '成都银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (32, 'CQBANK', '重庆银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (33, 'DLB', '大连银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (34, 'NCB', '南昌银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (35, 'FJHXBC', '福建海峡银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (36, 'HKB', '汉口银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (37, 'WZCB', '温州银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (38, 'QDCCB', '青岛银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (39, 'TZCB', '台州银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (40, 'JXBANK', '嘉兴银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (41, 'CSRCB', '常熟农村商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (42, 'NHB', '南海农村信用联社');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (43, 'CZRCB', '常州农村信用联社');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (44, 'H3CB', '内蒙古银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (45, 'SXCB', '绍兴银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (46, 'SDEB', '顺德农商银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (47, 'WJRCB', '吴江农商银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (48, 'ZBCB', '齐商银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (49, 'GYCB', '贵阳市商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (50, 'ZYCBANK', '遵义市商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (51, 'HZCCB', '湖州市商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (52, 'DAQINGB', '龙江银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (53, 'JINCHB', '晋城银行JCBANK');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (54, 'ZJTLCB', '浙江泰隆商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (55, 'GDRCC', '广东省农村信用社联合社');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (56, 'DRCBCL', '东莞农村商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (57, 'MTBANK', '浙江民泰商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (58, 'GCB', '广州银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (59, 'LYCB', '辽阳市商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (60, 'JSRCU', '江苏省农村信用联合社');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (61, 'LANGFB', '廊坊银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (62, 'CZCB', '浙江稠州商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (63, 'DYCB', '德阳商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (64, 'JZBANK', '晋中市商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (65, 'BOSZ', '苏州银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (66, 'GLBANK', '桂林银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (67, 'URMQCCB', '乌鲁木齐市商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (68, 'CDRCB', '成都农商银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (69, 'ZRCBANK', '张家港农村商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (70, 'BOD', '东莞银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (71, 'LSBANK', '莱商银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (72, 'BJRCB', '北京农村商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (73, 'TRCB', '天津农商银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (74, 'SRBANK', '上饶银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (75, 'FDB', '富滇银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (76, 'CRCBANK', '重庆农村商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (77, 'ASCB', '鞍山银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (78, 'NXBANK', '宁夏银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (79, 'BHB', '河北银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (80, 'HRXJB', '华融湘江银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (81, 'ZGCCB', '自贡市商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (82, 'YNRCC', '云南省农村信用社');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (83, 'JLBANK', '吉林银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (84, 'DYCCB', '东营市商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (85, 'KLB', '昆仑银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (86, 'ORBANK', '鄂尔多斯银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (87, 'XTB', '邢台银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (88, 'JSB', '晋商银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (89, 'TCCB', '天津银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (90, 'BOYK', '营口银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (91, 'JLRCU', '吉林农信');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (92, 'SDRCU', '山东农信');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (93, 'XABANK', '西安银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (94, 'HBRCU', '河北省农村信用社');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (95, 'NXRCU', '宁夏黄河农村商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (96, 'GZRCU', '贵州省农村信用社');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (97, 'FXCB', '阜新银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (98, 'HBHSBANK', '湖北银行黄石分行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (99, 'ZJNX', '浙江省农村信用社联合社');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (100, 'XXBANK', '新乡银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (101, 'HBYCBANK', '湖北银行宜昌分行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (102, 'LSCCB', '乐山市商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (103, 'TCRCB', '江苏太仓农村商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (104, 'BZMD', '驻马店银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (105, 'GZB', '赣州银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (106, 'WRCB', '无锡农村商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (107, 'BGB', '广西北部湾银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (108, 'GRCB', '广州农商银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (109, 'JRCB', '江苏江阴农村商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (110, 'BOP', '平顶山银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (111, 'TACCB', '泰安市商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (112, 'CGNB', '南充市商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (113, 'CCQTGB', '重庆三峡银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (114, 'XLBANK', '中山小榄村镇银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (115, 'HDBANK', '邯郸银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (116, 'KORLABANK', '库尔勒市商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (117, 'BOJZ', '锦州银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (118, 'QLBANK', '齐鲁银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (119, 'BOQH', '青海银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (120, 'YQCCB', '阳泉银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (121, 'SJBANK', '盛京银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (122, 'FSCB', '抚顺银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (123, 'ZZBANK', '郑州银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (124, 'SRCB', '深圳农村商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (125, 'BANKWF', '潍坊银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (126, 'JJBANK', '九江银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (127, 'JXRCU', '江西省农村信用');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (128, 'HNRCU', '河南省农村信用');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (129, 'GSRCU', '甘肃省农村信用');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (130, 'SCRCU', '四川省农村信用');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (131, 'GXRCU', '广西省农村信用');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (132, 'SXRCCU', '陕西信合');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (133, 'WHRCB', '武汉农村商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (134, 'YBCCB', '宜宾市商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (135, 'KSRB', '昆山农村商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (136, 'SZSBK', '石嘴山银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (137, 'HSBK', '衡水银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (138, 'XYBANK', '信阳银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (139, 'NBYZ', '鄞州银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (140, 'ZJKCCB', '张家口市商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (141, 'XCYH', '许昌银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (142, 'JNBANK', '济宁银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (143, 'CBKF', '开封市商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (144, 'WHCCB', '威海市商业银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (145, 'HBC', '湖北银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (146, 'BOCD', '承德银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (147, 'BODD', '丹东银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (148, 'JHBANK', '金华银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (149, 'BOCY', '朝阳银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (150, 'LSBC', '临商银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (151, 'BSB', '包商银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (152, 'LZYH', '兰州银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (153, 'BOZK', '周口银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (154, 'DZBANK', '德州银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (155, 'SCCB', '三门峡银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (156, 'AYCB', '安阳银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (157, 'ARCU', '安徽省农村信用社');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (158, 'HURCB', '湖北省农村信用社');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (159, 'HNRCC', '湖南省农村信用社');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (160, 'NYNB', '广东南粤银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (161, 'LYBANK', '洛阳银行');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (162, 'NHQS', '农信银清算中心');
INSERT INTO `zft`.`banks`(`id`, `tag`, `name`) VALUES (163, 'CBBQS', '城市商业银行资金清算中心');


