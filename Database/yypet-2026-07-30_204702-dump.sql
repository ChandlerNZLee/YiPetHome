-- MySQL dump 10.13  Distrib 9.7.1, for Win64 (x86_64)
--
-- Host: 121.37.164.57    Database: yypet
-- ------------------------------------------------------
-- Server version	8.0.35

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `access_token`
--

DROP TABLE IF EXISTS `access_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_token` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` int DEFAULT NULL COMMENT '0-sls 1-wechat',
  `token` varchar(300) DEFAULT NULL,
  `expires_in` mediumtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_token`
--

LOCK TABLES `access_token` WRITE;
/*!40000 ALTER TABLE `access_token` DISABLE KEYS */;
INSERT INTO `access_token` VALUES (1,0,'68176e3e5c8540d3a12af4f69bcaedac115cb661',NULL);
/*!40000 ALTER TABLE `access_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `address`
--

DROP TABLE IF EXISTS `address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `address` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL COMMENT '用户id',
  `home_id` int DEFAULT NULL,
  `detail` varchar(200) DEFAULT NULL COMMENT '地址信息',
  `house_number` varchar(200) DEFAULT NULL COMMENT '门牌号',
  `phone` varchar(20) DEFAULT NULL COMMENT '电话',
  `contact` varchar(20) DEFAULT NULL COMMENT '联系人',
  `longitude` float(12,6) DEFAULT NULL COMMENT '经度',
  `latitude` float(12,6) DEFAULT NULL COMMENT '纬度',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='地址表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address`
--

LOCK TABLES `address` WRITE;
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
INSERT INTO `address` VALUES (7,25,12,'辽宁省沈阳市沈北新区蒲河路31-6号6门','亿宠苑宠物店','18642294362','李先生',123.406059,41.944519,'2024-06-07 08:18:55','2024-06-13 22:58:41'),(10,26,14,'辽宁省沈阳市沈北新区蒲河路','沈北新区道义汇置·尚岛(蒲河路南150米)','13324057515','子麟',123.407211,41.944164,'2024-06-19 22:08:01',NULL),(11,28,16,'Hanyang DistrictGangyaochang Rd','Phase 2, Central Park Hanyang District','18612345678','Qqq',114.242302,30.565952,'2024-06-19 22:55:04',NULL),(12,27,27,'辽宁省沈阳市沈北新区蒲河路31-6号6门','亿宠苑宠物店','15142561188','王元亨',123.406059,41.944519,'2024-07-14 12:13:16',NULL),(13,77,46,'辽宁省沈阳市沈北新区毓秀街与蒲丰路交叉口西南方向195米左右','红豆杉花园b3 -27-10','18240142660','马女士',123.413445,41.948788,'2025-05-25 16:18:23',NULL),(14,77,46,'辽宁省沈阳市沈北新区毓秀街与蒲丰路交叉口西南方向195米左右','红豆杉花园b3-27-10','18240142660','马',123.413368,41.949276,'2025-06-14 17:48:17',NULL);
/*!40000 ALTER TABLE `address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `role` int DEFAULT NULL COMMENT '0-超级管理员 1-普通',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='管理员';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,'admin','123456',0),(2,'hzsd','hzsd2024',1),(5,'orca','Thgy9898',0),(11,'ufo','123456',0);
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apppoint`
--

DROP TABLE IF EXISTS `apppoint`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apppoint` (
  `id` int NOT NULL AUTO_INCREMENT,
  `room_id` int DEFAULT NULL,
  `shop_id` int DEFAULT NULL,
  `category` int DEFAULT NULL,
  `date` date DEFAULT NULL,
  `time` int DEFAULT NULL COMMENT '0 9:00 1 10:00 2 11:00 3 12:00 4 13:00 5 14:00 6 15:00 7 16:00 8 17:00 9 18:00 10 19:00 11 20:00',
  `item_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='预约表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apppoint`
--

LOCK TABLES `apppoint` WRITE;
/*!40000 ALTER TABLE `apppoint` DISABLE KEYS */;
/*!40000 ALTER TABLE `apppoint` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `banner`
--

DROP TABLE IF EXISTS `banner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banner` (
  `id` int NOT NULL AUTO_INCREMENT,
  `shop_id` int DEFAULT NULL,
  `avatar` mediumtext,
  `title` varchar(200) DEFAULT NULL,
  `descripation` mediumtext,
  `active` int DEFAULT NULL COMMENT '0 显示 1 不显示',
  `type` int DEFAULT NULL COMMENT '0 普通 1 弹窗',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='活动表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banner`
--

LOCK TABLES `banner` WRITE;
/*!40000 ALTER TABLE `banner` DISABLE KEYS */;
INSERT INTO `banner` VALUES (1,0,'string','string','string',1,0,'2024-05-22 15:56:56','2024-05-24 18:06:10'),(2,1,'string','banner3','banner3banner3banner3banner3banner3banner3',0,0,'2024-05-22 15:56:56','2024-05-28 11:55:44'),(3,2,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240622180333655.png','banner3','banner3banner3banner3banner3banner3banner3',1,0,'2024-05-22 15:56:56','2024-06-22 18:04:09');
/*!40000 ALTER TABLE `banner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `foster_item`
--

DROP TABLE IF EXISTS `foster_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foster_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `shop_id` int DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `description` text,
  `start_weight` int DEFAULT NULL,
  `end_weight` int DEFAULT NULL,
  `max_appointments` int DEFAULT NULL COMMENT '最大预约人数',
  `category` int DEFAULT NULL COMMENT '0-狗 1-猫',
  `avatar` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='寄养项目';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `foster_item`
--

LOCK TABLES `foster_item` WRITE;
/*!40000 ALTER TABLE `foster_item` DISABLE KEYS */;
INSERT INTO `foster_item` VALUES (1,1,'寄养',39.00,'狗寄养',0,20,3,0,NULL,'2024-06-08 09:39:10',NULL),(2,1,'寄养',59.00,'狗寄养',20,40,2,0,NULL,'2024-06-08 09:39:14',NULL),(3,1,'寄养',79.00,'狗寄养',40,80,1,0,NULL,'2024-06-08 09:39:21',NULL),(4,1,'寄养',99.00,'狗寄养',80,999,1,0,NULL,'2024-06-08 09:39:25',NULL),(5,1,'寄养',49.00,'猫寄养',0,999,4,1,NULL,'2024-06-08 09:39:29',NULL);
/*!40000 ALTER TABLE `foster_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `foster_order`
--

DROP TABLE IF EXISTS `foster_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foster_order` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_number` varchar(20) DEFAULT NULL COMMENT '订单编号',
  `user_id` int DEFAULT NULL COMMENT '用户id',
  `shop_id` int DEFAULT NULL COMMENT '商铺id',
  `foster_item_id` int DEFAULT NULL COMMENT '寄养项目id',
  `start_date` date DEFAULT NULL COMMENT '开始时间',
  `end_date` date DEFAULT NULL COMMENT '结束时间',
  `price` decimal(10,2) DEFAULT NULL COMMENT '总价',
  `status` int DEFAULT NULL COMMENT '0-待付款，1-已支付待寄养，2-寄养中，3已完成，4已超时',
  `admin_id` int DEFAULT NULL COMMENT '如果是管理员创建记录id',
  `is_vip` int DEFAULT NULL COMMENT '0-否 1-是',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='寄养订单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `foster_order`
--

LOCK TABLES `foster_order` WRITE;
/*!40000 ALTER TABLE `foster_order` DISABLE KEYS */;
INSERT INTO `foster_order` VALUES (26,'20240613191119746',25,1,5,'2024-06-13','2024-06-16',196.00,0,NULL,1,'2024-06-13 19:11:19',NULL),(29,'F20240622221731440',28,1,4,'2024-06-22','2024-06-23',1.00,0,NULL,NULL,'2024-06-22 22:17:32',NULL),(30,'F20240624140624095',28,1,4,'2024-06-24','2024-06-25',0.02,0,NULL,NULL,'2024-06-24 14:06:24',NULL);
/*!40000 ALTER TABLE `foster_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `foster_order_item`
--

DROP TABLE IF EXISTS `foster_order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foster_order_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `forster_item_id` int DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `description` text,
  `avatar` varchar(200) DEFAULT NULL,
  `start_weight` int DEFAULT NULL,
  `end_weight` int DEFAULT NULL,
  `category` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='寄养订单项目';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `foster_order_item`
--

LOCK TABLES `foster_order_item` WRITE;
/*!40000 ALTER TABLE `foster_order_item` DISABLE KEYS */;
INSERT INTO `foster_order_item` VALUES (25,26,5,'寄养',49.00,'猫寄养',NULL,0,999,1),(28,29,4,'寄养',0.00,'狗寄养',NULL,80,999,0),(29,30,4,'寄养',0.00,'狗寄养',NULL,80,999,0);
/*!40000 ALTER TABLE `foster_order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `foster_order_pet`
--

DROP TABLE IF EXISTS `foster_order_pet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foster_order_pet` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `pet_id` int DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `avatar` text,
  `gender` int DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  `weight` decimal(5,1) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `foster_order_pet`
--

LOCK TABLES `foster_order_pet` WRITE;
/*!40000 ALTER TABLE `foster_order_pet` DISABLE KEYS */;
INSERT INTO `foster_order_pet` VALUES (25,26,16,NULL,NULL,NULL,NULL,10.0,'1999-06-17'),(28,29,22,'1','2',1,4,222.0,NULL),(29,30,22,'宠物11号','string',0,0,222.0,NULL);
/*!40000 ALTER TABLE `foster_order_pet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `home`
--

DROP TABLE IF EXISTS `home`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `home` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL COMMENT '家庭名',
  `invitation_code` varchar(10) DEFAULT NULL COMMENT '邀请码',
  `balance` decimal(10,2) DEFAULT NULL COMMENT '余额',
  `is_vip` int DEFAULT NULL COMMENT '0-普通 1-会员',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='家庭表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `home`
--

LOCK TABLES `home` WRITE;
/*!40000 ALTER TABLE `home` DISABLE KEYS */;
INSERT INTO `home` VALUES (1,'张小花的家庭','ABCD',NULL,NULL),(2,'毛球的家','EDFG',NULL,NULL),(12,'亿宠苑的家','LS5B',72.00,NULL),(14,'子麒的家','EXCG',NULL,NULL),(15,'小王的家','4UM7',NULL,NULL),(16,'Qqq','WLC2',NULL,NULL),(19,'山人的家','GVAE',NULL,NULL),(20,'自然呆的家','E4WK',NULL,NULL),(21,'赵先生','TBBQ',NULL,NULL),(22,'水源的家','LL9Q',NULL,NULL),(23,'我叫小丝青🐾的家','3Y5I',NULL,NULL),(24,'鬼地方个','MKYR',NULL,NULL),(25,'王大棒子的家','IVP2',NULL,NULL),(26,'撒反对','YVWD',NULL,NULL),(27,'小王的家2','RMNE',NULL,NULL),(28,'Judy的家','V2PV',NULL,NULL),(29,'是安迪阿的家','DUNR',NULL,NULL),(30,'珂珂拿铁的家','323C',NULL,NULL),(31,'蹦蹦的家','AH9P',NULL,NULL),(33,'小宝的家','1VHA',NULL,NULL),(34,'丽萨的家','6O3G',NULL,NULL),(35,'.的家','T6FD',NULL,NULL),(36,'小朋友i的家','0Q3D',NULL,NULL),(37,'郭的家','GHQ7',NULL,NULL),(38,'上善若水的家','6Q70',NULL,NULL),(39,'Sally的家','LZZX',NULL,NULL),(40,'1️⃣的家','FSED',NULL,NULL),(41,'🐶 有趣的灵魂的家','LKNT',NULL,NULL),(42,'甜.的家','8T5N',NULL,NULL),(43,'嘎子粑粑','QS36',NULL,NULL),(44,'orca的家','WNT1',NULL,NULL),(45,'琳子🍓的家','S1HJ',NULL,NULL),(46,'马.不爱回微信的家','9KR4',572.00,NULL),(47,'Leo的家','LG82',NULL,NULL),(48,'🌰的家','MXC8',590.00,NULL),(49,'黑子的家','KH06',NULL,NULL);
/*!40000 ALTER TABLE `home` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
  `duration` int DEFAULT NULL COMMENT '订阅时长（以月为单位）',
  `price` decimal(10,2) DEFAULT NULL,
  `discount_rate1` decimal(3,2) DEFAULT NULL COMMENT '护理项目折扣率0-1',
  `discount_rate2` decimal(3,2) DEFAULT NULL COMMENT '商品项目折扣率',
  `description` mediumtext,
  `create_time` datetime DEFAULT NULL,
  `give` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='VIP表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
INSERT INTO `member` VALUES (1,'银卡会员',12,500.00,0.70,0.90,'','2024-06-13 14:07:18',200.00),(2,'金卡会员',12,1000.00,0.70,0.90,NULL,'2025-04-19 19:33:32',520.00),(3,'黑金会员',12,3000.00,0.70,0.90,NULL,'2025-04-19 19:34:14',2000.00);
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_order`
--

DROP TABLE IF EXISTS `member_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_order` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_number` varchar(20) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `home_id` int DEFAULT NULL,
  `member_id` int DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `status` int DEFAULT NULL COMMENT '0-未支付 1-已支付',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_order`
--

LOCK TABLES `member_order` WRITE;
/*!40000 ALTER TABLE `member_order` DISABLE KEYS */;
INSERT INTO `member_order` VALUES (1,'20240530073335444',6,6,725667841,100.00,1,'2024-05-30 07:33:35'),(2,'20240530073902581',6,6,725667841,100.00,1,'2024-05-30 07:39:03'),(8,'20240613160002944',25,12,1,39.00,1,'2024-06-13 16:00:03'),(9,'20240619220420694',26,14,1,39.00,0,'2024-06-19 22:04:20'),(10,'20240620220819518',28,16,1,39.00,0,'2024-06-20 22:08:19'),(11,'20240620232237764',28,16,1,0.01,1,'2024-06-20 23:22:38'),(12,'M20240629221731346',25,12,1,0.01,0,'2024-06-29 22:17:31'),(13,'M20240629223216439',25,12,1,0.01,0,'2024-06-29 22:32:17'),(14,'M20240629224239996',35,12,1,39.00,0,'2024-06-29 22:42:39'),(15,'M20240629224418089',35,12,1,39.00,0,'2024-06-29 22:44:18'),(16,'M20240629224945817',35,12,1,39.00,0,'2024-06-29 22:49:45'),(17,'M20240630075016793',36,22,1,39.00,1,'2024-06-30 07:50:16'),(18,'M20240630152427837',25,12,1,39.00,0,'2024-06-30 15:24:28'),(19,'M20240630152428176',25,12,1,39.00,0,'2024-06-30 15:24:28'),(20,'M20240630152428182',25,12,1,39.00,0,'2024-06-30 15:24:28'),(21,'M20240630152428817',25,12,1,39.00,0,'2024-06-30 15:24:29'),(22,'M20240630152435677',25,12,1,39.00,0,'2024-06-30 15:24:36'),(23,'M20240630152502089',25,12,1,39.00,0,'2024-06-30 15:25:03'),(24,'M20240630152510908',25,12,1,39.00,0,'2024-06-30 15:25:11'),(25,'M20240630162141311',25,12,1,39.00,0,'2024-06-30 16:21:41'),(26,'M20240630162201813',25,12,1,39.00,0,'2024-06-30 16:22:01'),(27,'M20240701140853142',26,14,1,39.00,0,'2024-07-01 14:08:54'),(28,'M20240701140855504',26,14,1,39.00,0,'2024-07-01 14:08:56'),(29,'M20240701140904696',26,14,1,39.00,0,'2024-07-01 14:09:04'),(30,'M20240701173747474',26,14,1,39.00,0,'2024-07-01 17:37:48'),(31,'M20240701173748337',26,14,1,39.00,0,'2024-07-01 17:37:49'),(32,'M20240701173759549',26,14,1,39.00,0,'2024-07-01 17:37:59'),(33,'M20240701193050142',26,14,1,39.00,0,'2024-07-01 19:30:50'),(34,'M20240709114623738',26,14,1,39.00,0,'2024-07-09 11:46:23'),(35,'M20240714140552688',58,35,1,39.00,0,'2024-07-14 14:05:52'),(36,'M20241008180108413',70,41,1,39.00,0,'2024-10-08 18:01:09'),(37,'M20250419142025946',25,12,1,39.00,0,'2025-04-19 14:20:25'),(66,'M20250510165907332',75,12,3,3000.00,0,'2025-05-10 16:59:08'),(68,'M20250510192222446',75,12,1,500.00,0,'2025-05-10 19:22:23'),(69,'M20250515175657031',77,46,1,500.00,1,'2025-05-15 17:56:58'),(70,'M20250515180236397',74,27,2,1000.00,0,'2025-05-15 18:02:36'),(71,'M20250516195552837',79,48,1,500.00,1,'2025-05-16 19:55:53'),(72,'M20250524130829665',75,12,1,500.00,0,'2025-05-24 13:08:29'),(73,'M20250614172440508',77,46,1,500.00,0,'2025-06-14 17:24:41');
/*!40000 ALTER TABLE `member_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pet`
--

DROP TABLE IF EXISTS `pet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pet` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL COMMENT '宠物名字',
  `gender` int DEFAULT NULL COMMENT '0 公 1 母',
  `fur` int DEFAULT NULL COMMENT '0 长毛 1 短毛',
  `birthday` date DEFAULT NULL COMMENT '生日',
  `weight` decimal(5,1) DEFAULT NULL COMMENT '体重',
  `avatar` mediumtext COMMENT '宠物头像',
  `category_id` int DEFAULT NULL COMMENT '0 狗狗 1 猫猫',
  `home_id` int DEFAULT NULL COMMENT '家id',
  `user_id` int DEFAULT NULL,
  `state` int DEFAULT NULL COMMENT '0 无状态 1 洗护中 2 寄养中',
  `verified` int DEFAULT NULL COMMENT '0-未认证 1-已认证',
  `duration` int DEFAULT NULL COMMENT '洗护周期',
  `vaccine_name` varchar(50) DEFAULT NULL COMMENT '疫苗名称',
  `vaccine_date` datetime DEFAULT NULL COMMENT '疫苗日期',
  `vaccine_count` int DEFAULT NULL COMMENT '疫苗次数',
  `neutered` int DEFAULT NULL COMMENT '是否绝育 0-没有  1-绝育',
  `wash_time` datetime DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='宠物表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pet`
--

LOCK TABLES `pet` WRITE;
/*!40000 ALTER TABLE `pet` DISABLE KEYS */;
INSERT INTO `pet` VALUES (1,'小宝',0,0,'2011-05-01',8.3,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240713123138.jpg',0,33,56,0,1,7,'卫佳捌',NULL,0,NULL,'2024-07-13 12:31:00','2024-07-13 12:31:00',NULL),(2,'小松饼',0,0,'2024-05-04',1.5,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/2024072011525000.jpg',1,36,59,0,1,14,'妙三多','2024-07-20 00:00:00',1,NULL,NULL,'2024-07-20 11:38:00',NULL),(3,'锅巴',0,0,NULL,6.1,NULL,0,37,60,0,1,7,'卫佳捌',NULL,0,NULL,'2024-07-20 17:50:00','2024-07-20 17:53:00',NULL),(16,'小咪',0,0,'1999-06-17',10.0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png',1,12,25,0,1,14,'妙三多',NULL,0,0,'2024-07-08 17:46:15','2024-06-07 10:44:33','2024-07-25 00:16:12'),(32,'辛巴',0,0,'2024-04-01',1.8,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240705132052118.jpg',1,12,25,0,1,14,'妙三多','2024-07-10 00:00:00',2,NULL,NULL,'2024-07-05 13:20:53',NULL),(35,'潘达',1,0,'2024-04-01',1.8,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240709114811443.jpg',1,14,26,0,1,14,'妙三多','2024-07-10 00:00:00',2,0,NULL,'2024-07-09 11:48:12','2024-07-20 12:29:04'),(36,'帕帕',0,0,NULL,5.5,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240709165824324.jpg',0,22,36,0,1,7,'卫佳捌',NULL,0,NULL,'2024-07-12 17:05:03','2024-07-09 16:58:25',NULL),(37,'珂珂',1,0,NULL,15.0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240711205729265.jpg',0,30,53,0,1,7,'卫佳捌',NULL,0,NULL,NULL,'2024-07-11 20:57:30',NULL),(38,'拿铁',0,0,NULL,15.0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240711205754185.jpg',0,30,53,0,1,7,'卫佳捌',NULL,0,NULL,NULL,'2024-07-11 20:57:54',NULL),(39,'小黑',0,0,'2023-07-13',10.0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240713134302719.jpg',0,1,28,0,1,7,'卫佳捌',NULL,1,NULL,NULL,'2024-07-13 13:43:03',NULL),(41,'丽萨',1,0,'2014-06-01',10.0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240713171821036.jpg',0,34,57,0,1,7,'卫佳捌',NULL,0,NULL,'2024-07-13 17:18:00','2024-07-13 17:18:21',NULL),(42,'毛球',0,0,'2021-07-13',7.5,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240713200733492.jpg',0,2,49,0,1,7,'卫佳捌',NULL,0,0,NULL,'2024-07-13 20:07:34','2024-07-20 12:28:21'),(43,'panda',1,0,'2024-04-01',1.8,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240713201234323.jpg',1,27,27,0,1,14,'妙三多','2024-07-10 00:00:00',2,0,NULL,'2024-07-13 20:12:35','2024-07-20 12:27:50'),(44,'小黄',0,0,'2023-07-20',10.0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240720144400613.jpg',0,1,28,0,1,7,'卫佳捌',NULL,0,NULL,NULL,'2024-07-20 14:44:01',NULL),(45,'大宝',0,0,NULL,2.0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240922014953585.jpg',0,31,54,0,1,7,NULL,NULL,NULL,NULL,NULL,'2024-09-22 01:49:54',NULL),(46,'二宝',0,0,NULL,3.0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240922015019340.jpg',0,31,54,0,1,7,NULL,NULL,NULL,NULL,NULL,'2024-09-22 01:50:20',NULL),(47,'tangtang',0,0,'2024-06-21',NULL,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20241024171637305.jpg',1,42,71,0,1,14,NULL,NULL,NULL,NULL,NULL,'2024-10-24 17:16:37',NULL),(48,'咪咔',0,0,'2016-10-19',7.5,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20250515174554231.jpg',0,45,76,0,1,7,NULL,NULL,NULL,NULL,NULL,'2025-05-15 17:45:54',NULL),(50,'',1,0,NULL,NULL,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20250516195428303.jpg',0,48,79,0,1,7,NULL,NULL,NULL,NULL,NULL,'2025-05-16 19:54:28',NULL),(51,'富贵',1,0,'2024-07-13',15.3,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20250516195513702.jpg',0,48,79,0,1,7,NULL,NULL,NULL,NULL,NULL,'2025-05-16 19:55:14',NULL),(52,'黑子',0,0,NULL,12.0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20250730191946209.jpg',0,49,82,0,1,7,NULL,NULL,NULL,NULL,NULL,'2025-07-30 19:19:46',NULL),(53,'糯米',0,0,NULL,1.0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20250802095419314.jpg',0,46,77,0,1,7,NULL,NULL,NULL,NULL,NULL,'2025-08-02 09:54:20',NULL);
/*!40000 ALTER TABLE `pet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pet_weight`
--

DROP TABLE IF EXISTS `pet_weight`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pet_weight` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pet_id` int DEFAULT NULL,
  `weight` decimal(5,1) DEFAULT NULL,
  `record_date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='宠物体重';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pet_weight`
--

LOCK TABLES `pet_weight` WRITE;
/*!40000 ALTER TABLE `pet_weight` DISABLE KEYS */;
INSERT INTO `pet_weight` VALUES (1,1,8.3,'2024-07-13'),(2,43,1.8,'2024-07-13'),(3,37,15.0,'2024-07-11'),(4,38,15.0,'2024-07-11'),(5,39,10.0,'2024-07-13'),(6,16,11.0,'2024-05-01'),(7,16,12.0,'2024-05-12'),(8,16,15.0,'2024-05-26'),(9,16,12.0,'2024-06-13'),(10,16,13.0,'2024-06-28'),(11,41,10.0,'2024-07-13'),(12,42,7.5,'2024-07-13'),(15,16,10.0,'2024-07-08'),(16,36,5.5,'2024-07-12');
/*!40000 ALTER TABLE `pet_weight` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` int DEFAULT NULL COMMENT '0-主粮 1-零食 2玩具 3-日常用品',
  `name` varchar(200) DEFAULT NULL,
  `thumb` varchar(200) DEFAULT NULL,
  `category` int DEFAULT NULL COMMENT '0 通用 1 狗粮 2 猫粮',
  `description` text,
  `shop_id` int DEFAULT NULL COMMENT '0 全部',
  `active` int DEFAULT NULL COMMENT '0-上架 1-下架',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `discount_rate` decimal(3,2) DEFAULT NULL,
  `bar_code` varchar(255) DEFAULT NULL COMMENT '商品条码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,1,'帕特诺尔冻干酸奶魔方80g',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(2,1,'猫太郎牛奶220ml',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(3,1,'猫太郎冻干生骨肉棒棒糖3.5g',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(4,1,'萌宠出动功能性狗条15g*5/盒',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(5,1,'萌宠出动轻养3min-主食狗条15g*10/盒',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(6,1,'路可丝脆米排系列40g',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(7,1,'路可丝脆米卷系列48g',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(8,1,'路可丝磨牙棒210g',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(9,1,'香吉仕风干蒸煮系列宠物零食',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(10,1,'叁拾者也0添加宠物零食',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(11,1,'彼斯特奇肉源可追溯磨牙系列零食',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(12,1,'爱乐纯啵啵骨洁牙系列105g',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(13,1,'FINIKI韩国进口宠物零食薄片80g',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(14,1,'FD韩国进口盒装宠物香肠180g',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(15,1,'NC天然核心韩国进口纯肉宠物零食（小包装40g）',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(16,1,'NC天然核心韩国进口奶酪系列宠物零食',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(17,1,'NEURX肉圈宠物磨牙零食130g',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(18,1,'NEURX宠物水果棒棒糖11g',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(19,1,'帕美德羊奶粉宠物零食薯片40g',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(20,1,'皓宠今日营养酱系列宠物零食16g*21/盒',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(21,1,'皓宠纯肉冻干饼干系列120g',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(22,1,'尽兴手作烘干系列',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(23,1,'尽兴果蔬组合冻干',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(24,1,'爱宠私语鱼皮系列宠物薯片40g',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(25,1,'爱宠私语蛋黄小黄鱼脆',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(26,1,'爱宠私语果蔬甜甜圈35g',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(27,1,'多格漫名仕系列宠物零食',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(28,1,'肉肉怪风干肉干系列宠物零食（添加芝麻）100g',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(29,1,'肉肉怪海苔鱼油蒸煮完整鸡小胸',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(30,1,'肉肉怪缠肉系列新上宠物零食',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(31,1,'肉肉怪犬用零食略略酱90g',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(32,1,'多格漫-无添加鸡小胸干',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(33,1,'猫太郎全价主食猫条15g*6/袋',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(34,1,'萌宠出动bobo酱100g',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(35,1,'萌宠出动功能性口味三合一系列猫条15g*5/盒',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(36,1,'萌宠出动轻养3min 主食猫条15g*10/包',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(37,1,'惜时泰国进口大金罐猫用主食罐头170g',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(38,1,'SC善存益生菌全价主食猫条12g*5/包',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(39,1,'猫宅一生猫用主食罐头双耳杯80g',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(40,1,'它伢猫尾勺猫条13g*5/盒',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(41,1,'路可丝猫零食洁牙系列80g',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(42,1,'大P便当全价主食猫条15g*6/包',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(43,1,'大P便当彩虹七日罐',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(44,1,'FRESHCAT福瑞诗猫餐盒馋嘴条',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(45,1,'FRESHCAT福瑞诗慕斯奶糕零食罐30g*6/盒',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(46,1,'Cater凯特营养猫棒-鸡肉猫草',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(47,1,'肉肉怪摇摇奶昔罐-火鸡配方',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(48,1,'肉肉怪摇摇奶昔罐-鸡肉配方',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(49,1,'肉肉怪猫用零食略略酱40g',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(50,0,'倍内菲猫粮主厨系列1.5kg',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(51,0,'简沫全价低敏系列猫粮1.5kg',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(52,0,'百瑞滋大师系列鲜肉五谷全价猫粮（乳鸽）',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(53,0,'高爷家全价烘焙猫粮',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(54,0,'倍内菲狗粮主厨系列1.5kg',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(55,0,'简沫全价低敏系列犬粮1.5kg',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(56,0,'百瑞滋大师系列鲜肉五谷全价犬粮（乳鸽）',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(57,2,'青蛙双槽內碗可拆卸宠物食盆',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(58,2,'nobleza耐咬磨牙毛绒发声玩具',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(59,2,'motumu超长逗猫棒','',2,'',1,0,NULL,'2024-06-28 09:16:26',1.00,NULL),(60,2,'彩虹棉花糖超长逗猫棒',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(61,2,'仿蜻蜓系列金属加长逗猫棒',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(62,2,'丝绒流苏系列金属加长逗猫棒',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(63,2,'高弹力加量羽毛普通款逗猫棒',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(64,2,'特长木杆系列逗猫棒',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(65,2,'GiGwi贵为进口犬用玩具',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(66,2,'GiGwi贵为进口猫用玩具',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(67,3,'母婴材质充棉脖圈',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(68,3,'竹编透气宠物窝',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(69,3,'安朵朵-满天星蓝白宠物裙',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(70,3,'安朵朵-朝鲜刺绣宠物汉服',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(71,3,'安朵朵-夏凉透气粉色宠物汗衫',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(72,3,'安朵朵-夏凉透气时尚牛仔宠物汗衫',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(73,3,'安朵朵-夏凉透气都市丽人宠物汗衫',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(74,3,'安朵朵-乡村小碎花针织宠物裙',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(75,3,'安朵朵-田园小花格宠物裙粉色',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(76,3,'安朵朵-田园小花格宠物裙蓝色',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(77,4,'hellocat猫包便携双肩书包式大号',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(78,4,'肚兜式滑扣犬用牵引绳-格子系列M号',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(79,4,'肚兜式滑扣犬用牵引绳-手工刺绣系列',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(80,4,'肚兜式滑扣犬用牵引绳-透气材质系列S号',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(81,4,'工字式卡扣宠物牵引绳-随身包系列L号',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(82,4,'防压毛滑扣式犬用牵引绳-蕾丝边系列S号',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(83,4,'撞色防勒手加粗背带式可调节犬用牵引绳',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(84,4,'涤纶防割手可调节腰部牵引撞色犬用牵引绳',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(85,4,'咕噜托特包系列',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(86,5,'拜宠清犬用体内驱虫-复方非班太尔片',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(87,5,'早立安犬用体外驱虫-犬外用护理滴剂',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(88,5,'大宠爱犬猫通用体内外一体-塞拉菌素滴剂',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(89,5,'汉宠欣犬猫通用体外驱虫-非泼罗尼滴剂',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(90,5,'海乐妙猫用体内驱虫-米尔贝肟吡喹酮片',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(91,5,'派福欣-趾琰康趾部护理修复液',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(92,5,'艾贝儿-宠耳康抑菌护理液',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(93,5,'木户元康皮肤喷雾',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(94,5,'派福欣-肠乐宝活性复合益生菌',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(95,5,'围康宠物头套',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(96,5,'HAIMAO宠物底绒除毛梳',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(97,5,'不锈钢制猫砂铲大号',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(98,5,'小欢在家犬猫通用快速吸水尿垫',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(99,5,'多可仕-猫用排毛球片',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(100,5,'多可仕-猫胺片',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(101,5,'多可仕-鲨鱼软骨素关节片',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(102,5,'多可仕功能性软膏150g',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(103,5,'多可仕功能性软膏150g',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(104,5,'猫可丽除臭除菌喷雾450ml',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(105,5,'伊丽Elite圆心派宠物指甲剪',NULL,0,NULL,1,0,NULL,NULL,1.00,NULL),(106,5,'家用优选JCB猫砂盆踏浪款61cm巨大盆',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(107,5,'家用优选JCB猫砂盆简约方格系列-小号',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(108,5,'派可为封闭式小火箭猫砂盆',NULL,2,NULL,1,0,NULL,NULL,1.00,NULL),(109,4,'小欢在家超级吸水防漏母犬安全裤',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL),(110,4,'小欢在家超级吸水防漏公犬纸尿裤',NULL,1,NULL,1,0,NULL,NULL,1.00,NULL);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_order`
--

DROP TABLE IF EXISTS `product_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_order` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_number` varchar(100) DEFAULT NULL COMMENT '订单编号',
  `shop_id` int DEFAULT NULL COMMENT '店铺id',
  `home_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL COMMENT '用户id',
  `address_id` int DEFAULT NULL COMMENT '地址id',
  `contact` varchar(50) DEFAULT NULL COMMENT '联系人',
  `phone` varchar(20) DEFAULT NULL COMMENT '电话',
  `address_detail` varchar(200) DEFAULT NULL COMMENT '地址详情',
  `house_number` varchar(200) DEFAULT NULL COMMENT '门牌号',
  `catagory` int DEFAULT NULL,
  `detail` mediumtext,
  `price` decimal(10,2) DEFAULT NULL,
  `state` int DEFAULT NULL COMMENT '0-代付款 1-已付款  3-已完成 4-已取消',
  `is_vip` int DEFAULT NULL COMMENT '0-否 1-是vip',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品订单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_order`
--

LOCK TABLES `product_order` WRITE;
/*!40000 ALTER TABLE `product_order` DISABLE KEYS */;
INSERT INTO `product_order` VALUES (31,'20240613174824952',1,12,25,7,'李先生','18642294362','辽宁省沈阳市沈北新区蒲河路31-6号6门','亿宠苑宠物店',NULL,NULL,20.00,NULL,1,'2024-06-13 17:48:25',NULL),(32,'20240613174856977',1,12,25,7,'李先生','18642294362','辽宁省沈阳市沈北新区蒲河路31-6号6门','亿宠苑宠物店',NULL,NULL,20.00,NULL,NULL,'2024-06-13 17:48:57',NULL),(33,'20240613174915060',1,12,25,7,'李先生','18642294362','辽宁省沈阳市沈北新区蒲河路31-6号6门','亿宠苑宠物店',NULL,NULL,20.00,NULL,NULL,'2024-06-13 17:49:16',NULL),(39,'P20240624134347615',1,16,28,11,'Qqq','18612345678','Hanyang DistrictGangyaochang Rd','Phase 2, Central Park Hanyang District',NULL,NULL,17.00,0,NULL,'2024-06-24 13:43:47',NULL),(40,'P20240624134410658',1,16,28,11,'Qqq','18612345678','Hanyang DistrictGangyaochang Rd','Phase 2, Central Park Hanyang District',NULL,NULL,17.00,0,NULL,'2024-06-24 13:44:11',NULL),(53,'P20240701153209371',1,12,25,7,'李先生','18642294362','辽宁省沈阳市沈北新区蒲河路31-6号6门','亿宠苑宠物店',NULL,NULL,108.00,0,NULL,'2024-07-01 15:32:10',NULL),(54,'P20240701153307814',1,12,25,7,'李先生','18642294362','辽宁省沈阳市沈北新区蒲河路31-6号6门','亿宠苑宠物店',NULL,NULL,108.00,0,NULL,'2024-07-01 15:33:07',NULL),(55,'P20240701193027715',1,14,26,10,'子麟','13324057515','辽宁省沈阳市沈北新区蒲河路','沈北新区道义汇置·尚岛(蒲河路南150米)',NULL,NULL,108.00,0,NULL,'2024-07-01 19:30:27',NULL),(56,'P20240701193117489',1,14,26,10,'子麟','13324057515','辽宁省沈阳市沈北新区蒲河路','沈北新区道义汇置·尚岛(蒲河路南150米)',NULL,NULL,108.00,0,NULL,'2024-07-01 19:31:18',NULL),(57,'P20240701193128450',1,14,26,10,'子麟','13324057515','辽宁省沈阳市沈北新区蒲河路','沈北新区道义汇置·尚岛(蒲河路南150米)',NULL,NULL,216.00,0,NULL,'2024-07-01 19:31:28',NULL),(58,'P20240826224434994',1,27,27,12,'王元亨','15142561188','辽宁省沈阳市沈北新区蒲河路31-6号6门','亿宠苑宠物店',NULL,NULL,128.00,0,0,'2024-08-26 22:44:35',NULL);
/*!40000 ALTER TABLE `product_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_order_items`
--

DROP TABLE IF EXISTS `product_order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `product_variant_id` int DEFAULT NULL,
  `product_variant_desc` text,
  `name` varchar(200) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `quantity` int DEFAULT NULL COMMENT '数量',
  `total_price` decimal(10,0) DEFAULT NULL COMMENT '总价',
  `thumb` varchar(200) DEFAULT NULL,
  `category` int DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=96 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品订单关联商品';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_order_items`
--

LOCK TABLES `product_order_items` WRITE;
/*!40000 ALTER TABLE `product_order_items` DISABLE KEYS */;
INSERT INTO `product_order_items` VALUES (59,31,16,NULL,NULL,'狗粮2号',20.00,1,NULL,NULL,0,'狗粮2222222'),(60,32,16,NULL,NULL,'狗粮2号',20.00,1,NULL,NULL,0,'狗粮2222222'),(61,33,16,NULL,NULL,'狗粮2号',20.00,1,NULL,NULL,0,'狗粮2222222'),(62,34,16,NULL,NULL,'狗粮2号',20.00,1,NULL,NULL,0,'狗粮2222222'),(71,39,36,107,'鸭肉配方','萌宠出动轻养3min 主食猫条15g*10/包',18.00,1,NULL,NULL,2,NULL),(72,40,36,108,'三文鱼配方','萌宠出动轻养3min 主食猫条15g*10/包',18.00,1,NULL,NULL,2,NULL),(90,53,108,263,'粉色','派可为封闭式小火箭猫砂盆',108.00,1,NULL,NULL,2,NULL),(91,54,108,263,'粉色','派可为封闭式小火箭猫砂盆',108.00,1,NULL,NULL,2,NULL),(92,55,108,263,'粉色','派可为封闭式小火箭猫砂盆',108.00,1,NULL,NULL,2,NULL),(93,56,108,263,'粉色','派可为封闭式小火箭猫砂盆',108.00,1,NULL,NULL,2,NULL),(94,57,108,263,'粉色','派可为封闭式小火箭猫砂盆',108.00,2,NULL,NULL,2,NULL),(95,58,29,83,'35g*30/盒','肉肉怪海苔鱼油蒸煮完整鸡小胸',128.00,1,NULL,NULL,0,NULL);
/*!40000 ALTER TABLE `product_order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_picture`
--

DROP TABLE IF EXISTS `product_picture`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_picture` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int DEFAULT NULL,
  `product_type` int DEFAULT NULL COMMENT '0-product 1-shoppet',
  `image_url` varchar(300) DEFAULT NULL COMMENT '图片地址',
  `sort_index` int DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=482 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='产品详情图片';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_picture`
--

LOCK TABLES `product_picture` WRITE;
/*!40000 ALTER TABLE `product_picture` DISABLE KEYS */;
INSERT INTO `product_picture` VALUES (1,109,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240720111200001.jpg',0),(2,109,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240720111200002.jpg',0),(3,109,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240720111200003.jpg',0),(4,109,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240720111200004.jpg',0),(5,109,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240720111200005.jpg',0),(6,110,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240720111430001.jpg',0),(7,110,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240720111430002.jpg',0),(8,110,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240720111430003.jpg',0),(9,110,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240720111430004.jpg',0),(21,11,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240618134713332.jpg',0),(29,11,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621223253425.jpg',0),(30,11,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621223307902.jpg',0),(31,108,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621223725531.jpg',0),(32,108,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621223730638.jpg',1),(33,107,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621223755928.jpg',0),(34,107,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621223806124.jpg',1),(35,107,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621223811015.jpg',2),(36,106,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621223831017.jpg',0),(37,106,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621223835569.jpg',0),(38,106,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621223839050.jpg',0),(39,105,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621223905418.jpg',0),(40,105,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621223915140.jpg',0),(41,105,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621223919356.jpg',0),(42,105,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621223923539.jpg',0),(43,105,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621223927147.jpg',0),(44,104,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224001267.jpg',0),(45,104,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224005775.jpg',0),(46,104,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224009783.jpg',0),(47,97,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224224709.jpg',0),(48,97,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224228784.jpg',0),(49,97,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224232064.jpg',0),(50,96,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224317531.jpg',0),(51,96,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224321330.jpg',0),(52,96,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224324398.jpg',0),(53,95,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224342980.jpg',0),(54,95,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224347779.jpg',0),(55,95,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224351288.jpg',0),(56,94,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224424695.jpg',0),(57,94,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224428212.jpg',0),(58,93,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224444898.jpg',0),(59,93,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224448612.jpg',0),(60,93,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224452087.jpg',0),(61,93,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224455579.jpg',0),(62,92,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224516462.jpg',0),(63,92,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224520451.jpg',1),(64,90,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224545151.jpg',0),(65,90,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224548627.jpg',0),(66,90,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224552501.jpg',0),(67,90,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224555750.jpg',0),(68,89,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224714402.jpg',0),(69,89,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224717898.jpg',0),(70,89,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224721462.jpg',0),(71,88,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224758576.jpg',0),(72,88,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224802092.jpg',0),(73,88,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224805958.jpg',0),(74,88,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224814041.jpg',0),(75,87,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224856657.jpg',0),(76,87,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224900717.jpg',0),(77,87,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224904018.jpg',0),(78,87,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224907625.jpg',0),(79,86,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224933838.jpg',0),(80,86,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224937609.jpg',0),(81,86,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224941192.jpg',0),(82,86,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621224944739.jpg',0),(83,85,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225004772.jpg',0),(84,85,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225008113.jpg',0),(85,85,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225011443.jpg',0),(86,85,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225016259.jpg',0),(87,85,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225019690.jpg',0),(88,31,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225402062.jpg',0),(89,31,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225405491.jpg',0),(90,31,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225409358.jpg',0),(91,31,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225412945.jpg',0),(92,30,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225443971.jpg',0),(93,30,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225447724.jpg',0),(94,30,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225451631.jpg',0),(95,30,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225454913.jpg',0),(96,30,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225458368.jpg',0),(97,17,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225632022.jpg',0),(98,17,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225635567.jpg',0),(99,16,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225757349.jpg',0),(100,16,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225803321.jpg',0),(101,49,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225846766.jpg',0),(102,49,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225850672.jpg',0),(103,49,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225853928.jpg',0),(104,49,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225857203.jpg',0),(105,49,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225900732.jpg',0),(106,48,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225924040.jpg',0),(107,48,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225926938.jpg',0),(108,48,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621225930284.jpg',0),(109,47,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230012715.jpg',0),(110,47,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230015985.jpg',0),(111,47,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230019149.jpg',0),(112,46,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230036901.jpg',0),(113,45,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230111189.jpg',0),(114,44,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230126381.jpg',0),(115,44,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230129614.jpg',0),(116,44,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230133717.jpg',0),(117,44,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230137937.jpg',0),(118,43,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230157825.jpg',0),(119,43,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230201365.jpg',0),(120,42,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230228914.jpg',0),(121,42,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230232133.jpg',0),(122,41,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230321128.jpg',0),(123,41,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230324137.jpg',0),(124,41,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230328208.jpg',0),(125,41,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230331971.jpg',0),(126,41,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230335227.jpg',0),(127,12,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230545178.jpg',0),(128,12,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230550342.jpg',0),(129,12,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230554482.jpg',0),(130,12,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230557868.jpg',0),(131,12,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230603565.jpg',0),(132,10,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230624748.png',0),(133,2,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230828953.jpg',4),(134,2,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230831335.jpg',5),(135,2,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621230834031.jpg',6),(136,28,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231042268.jpg',0),(137,28,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231047797.jpg',0),(138,28,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231051972.jpg',0),(139,28,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231054923.jpg',0),(140,28,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231057899.jpg',0),(141,28,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231105925.jpg',0),(142,27,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231133397.jpg',0),(143,27,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231136187.jpg',0),(144,27,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231138533.jpg',0),(145,27,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231140911.jpg',0),(146,27,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231143263.jpg',0),(147,26,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231203496.jpg',0),(148,26,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231206834.jpg',0),(149,26,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231211293.jpg',0),(150,26,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231214194.jpg',0),(151,25,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231229449.jpg',0),(152,24,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231243651.jpg',0),(153,24,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231245955.jpg',0),(154,23,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231303815.jpg',0),(155,23,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231306361.jpg',0),(156,23,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231308626.jpg',0),(157,23,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231311002.jpg',0),(158,23,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231313286.jpg',0),(159,22,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231332822.jpg',0),(160,22,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231335276.jpg',0),(161,22,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231338011.jpg',0),(162,22,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231340403.jpg',0),(163,22,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231342772.jpg',0),(164,22,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231345461.jpg',0),(165,21,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231406977.jpg',0),(166,21,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231409699.jpg',0),(167,21,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231413175.jpg',0),(168,20,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231427995.jpg',0),(169,20,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231431866.jpg',0),(170,20,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231434374.jpg',0),(171,20,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231436631.jpg',0),(172,19,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231513243.jpg',0),(173,19,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231516053.jpg',0),(174,19,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231518451.jpg',0),(175,19,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231521006.jpg',0),(176,19,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231525423.jpg',0),(177,18,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231551228.jpg',0),(178,18,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231553890.jpg',0),(179,18,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231556588.jpg',0),(180,18,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231559022.jpg',0),(181,29,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231654074.jpg',0),(182,29,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231657634.jpg',0),(183,29,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231659636.jpg',0),(184,29,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621231701776.jpg',0),(185,50,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621232034106.jpg',0),(186,50,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621232037629.jpg',0),(187,50,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621232040266.jpg',0),(188,54,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621232050186.jpg',0),(189,54,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621232058040.jpg',0),(190,54,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621232100990.jpg',0),(191,54,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240621232103698.jpg',0),(199,111,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240622170056001.png',0),(202,112,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240623205831157.png',1),(204,112,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240623205835261.png',0),(206,103,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161021210.jpg',1),(207,103,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161017172.jpg',4),(208,103,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627160958581.jpg',0),(209,103,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161004927.jpg',2),(210,103,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161025066.jpg',5),(211,103,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161028704.jpg',3),(212,102,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161120502.jpg',0),(213,102,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161137168.jpg',4),(214,102,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161128278.jpg',2),(215,102,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161132212.jpg',3),(216,102,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161123694.jpg',1),(217,102,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161140718.jpg',5),(218,101,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161246047.jpg',0),(219,101,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161250363.jpg',1),(220,101,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161253972.jpg',2),(221,100,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161327937.jpg',0),(222,100,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161346783.jpg',3),(223,100,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161342446.jpg',1),(224,99,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161404365.jpg',0),(225,99,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161408565.jpg',1),(226,99,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161419947.jpg',2),(227,99,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161500120.jpg',3),(228,100,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161509612.jpg',2),(229,98,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161544456.jpg',0),(230,98,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161537335.jpg',3),(231,98,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161532949.jpg',2),(232,98,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161540671.jpg',1),(233,98,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161553332.jpg',5),(234,98,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161549695.jpg',4),(235,91,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161918926.jpg',0),(236,91,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161914887.jpg',1),(237,68,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161950585.jpg',0),(238,68,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161954110.jpg',1),(239,68,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627162001081.jpg',3),(240,68,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627161957383.jpg',2),(241,68,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627162004302.jpg',4),(242,68,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627162007402.jpg',5),(245,53,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627162223546.jpg',0),(246,40,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627162314487.jpg',1),(247,40,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627162319479.jpg',2),(248,40,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627162308760.jpg',0),(249,40,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627162330735.jpg',4),(250,40,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627162335330.jpg',5),(251,40,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627162323686.jpg',3),(252,40,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627162339253.jpg',6),(253,39,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627162406422.jpg',0),(254,39,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627162416227.jpg',2),(255,39,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627162419715.jpg',3),(256,39,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627162411807.jpg',1),(257,37,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627162455175.jpg',3),(258,37,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627162516329.jpg',4),(259,37,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627162458255.jpg',2),(260,37,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627162449926.jpg',1),(261,37,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627162440024.jpg',0),(262,37,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627162537338.jpg',5),(263,36,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627162616897.jpg',0),(264,36,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163125401.jpg',3),(265,36,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163113675.jpg',1),(266,36,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163121221.jpg',2),(267,36,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163131726.jpg',4),(268,36,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163134897.jpg',5),(269,36,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163138485.jpg',6),(270,35,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163216683.jpg',2),(271,35,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163225824.jpg',4),(272,35,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163211224.jpg',1),(273,35,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163207356.jpg',0),(274,35,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163229661.jpg',5),(275,35,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163219895.jpg',3),(276,34,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163342854.jpg',2),(277,34,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163330014.jpg',1),(278,34,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163326541.jpg',0),(279,34,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163356093.jpg',4),(280,34,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163346097.jpg',3),(281,34,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163402702.jpg',5),(282,34,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163408978.jpg',7),(283,34,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163405821.jpg',6),(284,33,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163728097.jpg',3),(285,33,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163722327.jpg',2),(286,33,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163732688.jpg',4),(287,33,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163718389.jpg',1),(288,33,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163703289.jpg',0),(289,15,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163926364.jpg',0),(290,15,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163929870.jpg',1),(291,15,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163945013.jpg',4),(292,15,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163934408.jpg',2),(293,15,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163937537.jpg',3),(294,15,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163949423.jpg',5),(295,15,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163956838.jpg',7),(296,15,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627163952497.jpg',6),(297,14,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164100732.jpg',3),(298,14,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164050818.jpg',0),(299,14,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164057426.jpg',2),(300,14,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164053948.jpg',1),(301,14,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164104474.jpg',4),(302,14,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164108747.jpg',5),(303,14,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164111786.jpg',6),(304,14,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164118616.jpg',8),(305,14,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164050818.jpg',0),(306,14,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164115017.jpg',7),(307,14,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164053948.jpg',1),(308,14,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164121631.jpg',9),(309,14,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164057426.jpg',2),(310,14,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164108747.jpg',5),(311,14,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164100732.jpg',3),(312,14,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164104474.jpg',4),(313,14,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164111786.jpg',6),(314,14,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164115017.jpg',7),(315,14,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164118616.jpg',8),(316,14,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164121631.jpg',9),(317,13,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164141762.jpg',1),(318,13,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164147710.jpg',2),(319,13,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164144854.jpg',0),(320,9,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164248713.jpg',4),(321,9,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164232391.jpg',2),(322,9,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164225717.jpg',0),(323,9,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164236020.jpg',3),(324,9,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164228943.jpg',1),(325,9,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164252324.jpg',5),(326,8,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164455795.jpg',0),(327,8,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164504320.jpg',1),(328,8,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164450836.jpg',5),(329,8,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164447058.jpg',4),(330,8,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164512841.jpg',2),(331,8,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164515561.jpg',3),(332,7,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164546452.jpg',0),(333,7,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164550731.jpg',1),(334,7,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164556002.jpg',2),(335,7,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164559074.jpg',3),(336,7,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164604081.jpg',4),(337,7,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164630785.jpg',5),(338,7,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164641366.jpg',8),(339,7,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164633532.jpg',6),(340,7,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164644403.jpg',9),(341,7,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164647939.jpg',10),(342,7,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164650954.jpg',11),(343,7,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164637897.jpg',7),(344,6,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164753413.jpg',3),(345,6,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164750499.jpg',2),(346,6,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164801542.jpg',5),(347,6,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164758407.jpg',4),(348,6,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164745619.jpg',1),(349,6,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164742648.jpg',0),(350,6,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164819713.jpg',7),(351,6,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164836556.jpg',10),(352,6,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164815735.jpg',6),(353,6,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164832197.jpg',9),(354,6,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164823034.jpg',8),(355,6,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164841902.jpg',11),(356,6,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627164847582.jpg',12),(361,4,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627165029257.jpg',0),(362,4,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627165032504.jpg',1),(363,4,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627165035810.jpg',2),(364,4,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627165042680.jpg',3),(365,3,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627165058563.png',0),(366,3,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627165101678.jpg',1),(367,3,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627165104958.jpg',2),(368,2,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627165146207.jpg',3),(369,2,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627165152459.jpg',2),(370,2,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627165155409.jpg',0),(371,2,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627165149214.jpg',1),(372,1,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627165436187.jpg',2),(373,1,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627165432853.jpg',1),(374,1,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627165440837.jpg',3),(375,1,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627165429552.jpg',0),(376,1,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240627165505584.jpg',4),(377,57,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628085808462.jpg',2),(378,57,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628085801993.jpg',0),(379,57,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628085805790.jpg',1),(380,57,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628085811391.jpg',3),(381,64,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628091140807.jpg',0),(382,64,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628091026380.jpg',2),(383,64,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628091038147.jpg',1),(384,63,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628091247670.jpg',1),(385,63,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628091212780.jpg',0),(386,62,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628091318655.jpg',0),(387,62,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628091323510.jpg',1),(388,61,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628091340805.jpg',0),(389,61,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628091345863.jpg',1),(390,60,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628091444498.jpg',1),(391,60,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628091416200.jpg',2),(392,60,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628091438410.jpg',0),(393,60,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628091431282.jpg',3),(394,59,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628091641289.jpg',0),(395,59,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628091652385.jpg',1),(396,52,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628092628296.jpg',0),(397,52,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628092649334.jpg',4),(398,52,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628092635158.jpg',1),(399,52,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628092640822.jpg',2),(400,52,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628092644022.jpg',3),(401,51,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628092825219.jpg',1),(402,51,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628092831165.jpg',2),(403,51,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628092818478.jpg',0),(404,55,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628092847728.jpg',0),(405,55,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628092944508.jpg',2),(406,55,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628092939899.jpg',1),(407,56,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093120679.jpg',0),(408,84,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093233455.jpg',1),(409,84,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093225950.jpg',0),(410,84,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093239234.jpg',2),(411,83,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093257260.jpg',0),(412,83,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093309226.jpg',1),(413,83,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093319856.jpg',2),(414,82,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093337957.jpg',0),(415,82,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093334567.jpg',1),(416,81,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093356191.jpg',0),(417,81,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093402471.jpg',2),(418,81,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093359556.jpg',1),(419,80,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093417546.jpg',0),(420,80,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093423271.jpg',2),(421,80,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093420187.jpg',1),(422,78,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093617033.jpg',0),(423,78,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093621626.jpg',1),(424,78,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093624837.jpg',2),(425,79,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093657757.jpg',0),(426,79,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093704220.jpg',2),(427,79,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093700851.jpg',1),(430,72,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093853954.jpg',0),(431,71,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093905111.jpg',0),(432,69,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093916827.jpg',0),(433,69,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093922337.jpg',2),(434,69,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628093920038.jpg',1),(435,66,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628102930140.jpg',3),(436,66,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628102918884.jpg',0),(437,66,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628102933915.jpg',4),(438,66,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628102925862.jpg',2),(439,66,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628102922288.jpg',1),(440,66,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628102936751.jpg',5),(441,65,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628102948951.jpg',0),(442,65,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628102957333.jpg',1),(443,65,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628102951753.jpg',2),(444,58,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103022658.jpg',1),(445,58,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103032170.jpg',3),(446,58,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103019317.jpg',0),(447,58,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103029196.jpg',2),(448,58,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103036270.jpg',4),(449,58,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103039091.jpg',5),(450,58,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103041994.jpg',6),(451,58,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103045959.jpg',7),(452,58,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103049849.jpg',8),(453,58,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103053993.jpg',9),(454,58,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103058364.jpg',10),(455,38,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103212772.jpg',1),(456,38,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103210242.jpg',0),(457,38,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103218418.jpg',3),(458,38,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103215968.jpg',2),(459,5,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103255086.jpg',0),(460,5,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103311630.jpg',4),(461,5,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103309064.jpg',3),(462,5,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103302353.jpg',1),(463,5,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103305535.jpg',2),(464,74,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103358582.jpg',0),(465,73,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103409555.jpg',0),(466,73,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103413093.jpg',1),(467,76,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103911182.jpg',0),(468,75,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628103920278.jpg',0),(469,70,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628104013574.jpg',0),(470,77,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628104552779.jpg',0),(471,77,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628104607492.jpg',2),(472,77,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628104603516.jpg',1),(473,77,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628104559302.jpg',4),(474,77,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628104610300.jpg',3),(475,32,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628105409835.jpg',1),(476,32,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628105413322.jpg',2),(477,32,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628105406363.jpg',0),(478,32,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628105416025.jpg',3),(479,67,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628193129554.jpg',0),(480,67,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628193137789.jpg',1),(481,67,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240628193143450.jpg',2);
/*!40000 ALTER TABLE `product_picture` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_variant`
--

DROP TABLE IF EXISTS `product_variant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_variant` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int DEFAULT NULL,
  `variant_desc` varchar(50) DEFAULT NULL COMMENT '描述',
  `price` decimal(10,2) DEFAULT NULL,
  `original_price` decimal(10,2) DEFAULT NULL,
  `stock` int DEFAULT NULL COMMENT '库存',
  `active` int DEFAULT NULL COMMENT '是否激活 0激活 1-没有激活',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=274 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品子类';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_variant`
--

LOCK TABLES `product_variant` WRITE;
/*!40000 ALTER TABLE `product_variant` DISABLE KEYS */;
INSERT INTO `product_variant` VALUES (1,1,'混合装',58.00,NULL,1000,0),(2,1,'蔓越莓味',58.00,NULL,1000,0),(3,1,'鸭肉和梨味',58.00,NULL,1000,0),(4,2,'乳钙',9.00,NULL,1000,0),(5,2,'南瓜',9.00,NULL,1000,0),(6,2,'蛋黄',9.00,NULL,1000,0),(7,3,'鸡肉南瓜',5.00,NULL,1000,0),(8,3,'牛肉火龙火',5.00,NULL,1000,0),(9,3,'鳕鱼菠菜',5.00,NULL,1000,0),(10,4,'鸡肉&苹果&褐藻',9.00,NULL,1000,0),(11,4,'鸡肉&木瓜&姜黄',9.00,NULL,1000,0),(12,4,'鸡肉&蓝莓&沙棘',9.00,NULL,1000,0),(13,5,'牛肉配方',18.00,NULL,1000,0),(14,5,'火鸡配方',18.00,NULL,1000,0),(15,5,'三文鱼配方',18.00,NULL,1000,0),(16,6,'鸡肉排',9.00,NULL,1000,0),(17,6,'牛肉排',9.00,NULL,1000,0),(18,7,'牛肉卷',9.00,NULL,1000,0),(19,7,'鸡肉卷',9.00,NULL,1000,0),(20,8,'鸭肉味',38.00,NULL,1000,0),(21,8,'鸡肉味',38.00,NULL,1000,0),(22,9,'鸡肉缠蛋黄80g',22.00,NULL,1000,0),(23,9,'鸭肉绕雪梨70g',22.00,NULL,1000,0),(24,9,'鸭肉烧红薯135g',22.00,NULL,1000,0),(25,9,'鸡胸肉南瓜25g*6',22.00,NULL,1000,0),(26,9,'鸭肉牛皮卷100g',22.00,NULL,1000,0),(27,10,'纯肉蛋黄卷75g',28.00,NULL,1000,0),(28,10,'鸡肉薄片60g',24.00,NULL,1000,0),(29,11,'香烤牛骨组合500g',38.00,NULL,1000,0),(30,11,'牛蹄骨大号430g',28.00,NULL,1000,0),(31,11,'香酥牛扁骨120g',28.00,NULL,1000,0),(32,12,'鸡肉西兰花',28.00,NULL,1000,0),(33,12,'南瓜',28.00,NULL,1000,0),(34,13,'鳕鱼南瓜',28.00,NULL,1000,0),(35,13,'鳕鱼薄片',28.00,NULL,1000,0),(36,14,'鸡肉肠',28.00,NULL,1000,0),(37,14,'鸭肉肠',28.00,NULL,1000,0),(38,15,'迷你金枪鱼切丝',18.00,NULL,1000,0),(39,15,'迷你鸡肉切丝',18.00,NULL,1000,0),(40,15,'鸡肉切条',18.00,NULL,1000,0),(41,15,'鸭肉切条',18.00,NULL,1000,0),(42,16,'蜂蜜奶酪棒58g',18.00,NULL,1000,0),(43,16,'鸡肉果蔬奶酪骨65g',18.00,NULL,1000,0),(44,17,'鸡肉火鸡圈',48.00,NULL,1000,0),(45,17,'鸭肉圈',48.00,NULL,1000,0),(46,18,'芒果味',5.00,NULL,1000,0),(47,18,'猕猴桃味',5.00,NULL,1000,0),(48,19,'鸡肉香蕉味',18.00,NULL,1000,0),(49,19,'鸡肉蓝莓味',18.00,NULL,1000,0),(50,20,'酱鸭肉-保护视力',38.00,NULL,1000,0),(51,20,'酱牛肉-呵护肠胃',38.00,NULL,1000,0),(52,20,'酱鹌鹑蛋-亮泽毛发',38.00,NULL,1000,0),(53,20,'酱鸡肉-呵护泌尿',38.00,NULL,1000,0),(54,21,'牛肉-鱼肉润肤',48.00,NULL,1000,0),(55,21,'猫草-健康排毛',48.00,NULL,1000,0),(56,22,'鸭肉绕雪梨70g',18.00,NULL,1000,0),(57,22,'鸡肉绕南瓜70g',18.00,NULL,1000,0),(58,22,'牛喉管70g',18.00,NULL,1000,0),(59,22,'鸡肉鳕鱼皮90g',18.00,NULL,1000,0),(60,22,'鸡肉牛皮棒100g',18.00,NULL,1000,0),(61,22,'牛舌70g',18.00,NULL,1000,0),(62,23,'绿色菜25g',22.00,NULL,1000,0),(63,23,'膳食纤维35g',22.00,NULL,1000,0),(64,23,'莓果25g',22.00,NULL,1000,0),(65,23,'紫色菜25g',22.00,NULL,1000,0),(66,23,'混合水果25g',22.00,NULL,1000,0),(67,24,'蛋黄鳕鱼皮-大型犬',28.00,NULL,1000,0),(68,24,'蛋黄鳕鱼皮-小型犬',28.00,NULL,1000,0),(69,24,'鸡肉鳕鱼皮-小型犬',28.00,NULL,1000,0),(70,25,'40g',28.00,NULL,1000,0),(71,26,'甜菜',18.00,NULL,1000,0),(72,26,'蛋黄椰丝',18.00,NULL,1000,0),(73,26,'紫薯',18.00,NULL,1000,0),(74,26,'青汁',18.00,NULL,1000,0),(75,27,'醇柔鸡胸肉生牛皮棒',22.00,NULL,1000,0),(76,27,'迷你鸡胸肉生牛皮卷',22.00,NULL,1000,0),(77,27,'鸡胸肉生牛皮卷',22.00,NULL,1000,0),(78,27,'磨牙饼干鸡肉卷',22.00,NULL,1000,0),(79,27,'磨牙饼干鸭肉卷',22.00,NULL,1000,0),(80,28,'鸭肉干',24.00,NULL,1000,0),(81,28,'鸡肉干',24.00,NULL,1000,0),(82,29,'35g*6/袋',28.00,NULL,1000,0),(83,29,'35g*30/盒',128.00,NULL,1000,0),(84,30,'鸡肉缠奶酪120g',22.00,NULL,1000,0),(85,30,'鸡肉缠椰子80g',22.00,NULL,1000,0),(86,30,'鸭肉缠雪梨100g',22.00,NULL,1000,0),(87,31,'牛肉',9.00,NULL,1000,0),(88,31,'兔肉',9.00,NULL,1000,0),(89,31,'鸡肉',9.00,NULL,1000,0),(90,31,'鸭肉',9.00,NULL,1000,0),(91,32,'90g',28.00,NULL,1000,0),(92,33,'鹿肉味',15.00,NULL,1000,0),(93,33,'兔肉味',15.00,NULL,1000,0),(94,33,'鸽肉味',15.00,NULL,1000,0),(95,34,'铁锅炖大鹅',12.00,NULL,1000,0),(96,34,'清蒸三文鱼',12.00,NULL,1000,0),(97,34,'清炖草原羊',12.00,NULL,1000,0),(98,34,'气锅跑山鸡',12.00,NULL,1000,0),(99,35,'鸡肉&雪梨&沙参猫条',9.00,NULL,1000,0),(100,35,'鸡肉&猕猴桃&柴胡猫条',9.00,NULL,1000,0),(101,35,'鸡肉&桑葚&枸杞猫条',9.00,NULL,1000,0),(102,35,'鸡肉&蓝莓&黄芪猫条',9.00,NULL,1000,0),(103,35,'鸡肉&菠萝&白术猫条',9.00,NULL,1000,0),(104,36,'火鸡配方',18.00,NULL,1000,0),(105,36,'鹅肉配方',18.00,NULL,1000,0),(106,36,'兔肉配方',18.00,NULL,1000,0),(107,36,'鸭肉配方',18.00,NULL,1000,0),(108,36,'三文鱼配方',18.00,NULL,1000,0),(109,37,'金枪鱼+银鱼+鲣鱼花',22.00,NULL,1000,0),(110,37,'金枪鱼+鸡肉+牛肉',22.00,NULL,1000,0),(111,37,'金枪鱼',22.00,NULL,1000,0),(112,38,'兔肉味',9.00,NULL,1000,0),(113,38,'鸡肉味',9.00,NULL,1000,0),(114,39,'磷虾精粹',18.00,NULL,1000,0),(115,39,'猫草原浆',18.00,NULL,1000,0),(116,39,'深海巨藻',18.00,NULL,1000,0),(117,40,'鸡肉鱼油味',28.00,NULL,1000,0),(118,40,'兔肉牛初乳味',28.00,NULL,1000,0),(119,40,'鸽肉蔓越莓味',28.00,NULL,1000,0),(120,41,'洁牙球',28.00,NULL,1000,0),(121,41,'猫枕头',28.00,NULL,1000,0),(122,42,'鸡肉金枪鱼扇贝',9.00,NULL,1000,0),(123,42,'鸡肉银鱼',9.00,NULL,1000,0),(124,42,'鸡肉鳕鱼',9.00,NULL,1000,0),(125,42,'鸡肉虾',9.00,NULL,1000,0),(126,42,'鸡肉三文鱼鱼油',9.00,NULL,1000,0),(127,42,'鸡肉蟹肉',9.00,NULL,1000,0),(128,43,'85g*7/盒',48.00,NULL,1000,0),(129,44,'鸡肉羊奶',18.00,NULL,1000,0),(130,44,'鸡肉牛肉',18.00,NULL,1000,0),(131,44,'吞拿鱼鱼籽',18.00,NULL,1000,0),(132,44,'吞拿鱼猫草',18.00,NULL,1000,0),(133,45,'鸡肉羊奶',38.00,NULL,1000,0),(134,46,'8g',3.00,NULL,1000,0),(135,47,'110ml',5.00,NULL,1000,0),(136,47,'110ml*6/盒',28.00,NULL,1000,0),(137,48,'110ml',5.00,NULL,1000,0),(138,48,'110ml*6/盒',28.00,NULL,1000,0),(139,49,'金枪鱼配方',8.00,NULL,1000,0),(140,49,'鸡肉配方',8.00,NULL,1000,0),(141,49,'鹿肉配方',8.00,NULL,1000,0),(142,49,'牛肉配方',8.00,NULL,1000,0),(143,50,'牛肉',108.00,NULL,1000,0),(144,50,'鸡肉',108.00,NULL,1000,0),(145,51,'牛肉&鲑鱼',88.00,NULL,1000,0),(146,51,'鸡肉&三文鱼',88.00,NULL,1000,0),(147,52,'1.36kg',118.00,NULL,1000,0),(148,53,'1.5kg',118.00,NULL,1000,0),(149,54,'牛肉',108.00,NULL,1000,0),(150,54,'鸡肉',108.00,NULL,1000,0),(151,55,'牛肉山药',88.00,NULL,1000,0),(152,55,'鸡肉燕麦',88.00,NULL,1000,0),(153,56,'1.36kg',108.00,NULL,1000,0),(154,57,'蓝色',18.00,NULL,1000,0),(155,57,'粉色',18.00,NULL,1000,0),(156,58,'兔子哥哥',28.00,NULL,1000,0),(157,58,'兔子弟弟',28.00,NULL,1000,0),(158,58,'愚蠢的猩猩',28.00,NULL,1000,0),(159,58,'可爱小象',28.00,NULL,1000,0),(160,58,'里约的鹦鹉',28.00,NULL,1000,0),(161,58,'聒噪的鹦鹉',28.00,NULL,1000,0),(162,58,'阿凡提的驴',28.00,NULL,1000,0),(163,58,'麻辣兔头',28.00,NULL,1000,0),(164,59,'雀尾绿',28.00,NULL,1000,0),(165,59,'丹叶红',28.00,NULL,1000,0),(166,60,'蓝色心形',28.00,NULL,1000,0),(167,60,'彩色心形',28.00,NULL,1000,0),(168,60,'彩色圆形',28.00,NULL,1000,0),(169,61,'仿蜻蜓樱花羽毛',7.00,NULL,1000,0),(170,61,'仿蜻蜓绿色羽毛',7.00,NULL,1000,0),(171,61,'仿蜻蜓杏黄羽毛',7.00,NULL,1000,0),(172,61,'仿蜻蜓银灰羽毛',7.00,NULL,1000,0),(173,61,'仿蜻蜓朱红羽毛',7.00,NULL,1000,0),(174,62,'黄色',7.00,NULL,1000,0),(175,62,'香橙色',9.00,NULL,1000,0),(176,62,'天蓝色',9.00,NULL,1000,0),(177,62,'嫩羽色',9.00,NULL,1000,0),(178,63,'紫色',5.00,NULL,1000,0),(179,63,'浅蓝',5.00,NULL,1000,0),(180,63,'深蓝',5.00,NULL,1000,0),(181,63,'金色',5.00,NULL,1000,0),(182,63,'黑色',5.00,NULL,1000,0),(183,63,'白色',5.00,NULL,1000,0),(184,63,'黄色',5.00,NULL,1000,0),(185,63,'绿色',5.00,NULL,1000,0),(186,64,'活力紫',15.00,NULL,1000,0),(187,64,'草原绿',15.00,NULL,1000,0),(188,65,'独创G-Ball球',28.00,NULL,1000,0),(189,65,'奶酪洁牙胶片',28.00,NULL,1000,0),(190,65,'大饼干人洁牙胶片',28.00,NULL,1000,0),(191,66,'藤球铃铛熊',28.00,NULL,1000,0),(192,66,'藤球铃铛鼠',28.00,NULL,1000,0),(193,66,'炫律猎物刺猬',28.00,NULL,1000,0),(194,67,'S',28.00,NULL,1000,0),(195,67,'M',28.00,NULL,1000,0),(196,67,'L',28.00,NULL,1000,0),(197,68,'L',45.00,NULL,1000,0),(198,69,'S',28.00,NULL,1000,0),(199,69,'L',38.00,NULL,1000,0),(200,70,'S',38.00,NULL,1000,0),(201,70,'L',58.00,NULL,1000,0),(202,71,'L',28.00,NULL,1000,0),(203,72,'XL',68.00,NULL,1000,0),(204,73,'S',22.00,NULL,1000,0),(205,74,'XL',68.00,NULL,1000,0),(206,75,'S',38.00,NULL,1000,0),(207,76,'XL',48.00,NULL,1000,0),(208,75,'L',48.00,NULL,1000,0),(209,76,'S',38.00,NULL,1000,0),(210,77,'蜂蜜黄',58.00,NULL,1000,0),(211,77,'青蓝色',58.00,NULL,1000,0),(212,78,'红格子蝴蝶结',28.00,NULL,1000,0),(213,78,'蓝格子蝴蝶结',28.00,NULL,1000,0),(214,79,'蓝格子樱桃刺绣M号',28.00,NULL,1000,0),(215,79,'黄格子菠萝刺绣S号',28.00,NULL,1000,0),(216,80,'粉色小狗',28.00,NULL,1000,0),(217,80,'黄色小狗',28.00,NULL,1000,0),(218,80,'蓝色小狗',28.00,NULL,1000,0),(219,80,'绿色小狗',28.00,NULL,1000,0),(220,81,'灰色小狗',28.00,NULL,1000,0),(221,81,'蓝色小狗',28.00,NULL,1000,0),(222,82,'绿色',28.00,NULL,1000,0),(223,82,'粉色',28.00,NULL,1000,0),(224,83,'XL号',28.00,NULL,1000,0),(225,84,'L号',28.00,NULL,1000,0),(226,84,'M号',28.00,NULL,1000,0),(227,85,'绿色',158.00,NULL,1000,0),(228,85,'咖啡色',158.00,NULL,1000,0),(229,85,'粉色',158.00,NULL,1000,0),(230,86,'15mg/片',28.00,NULL,1000,0),(231,87,'2.5ml/管',28.00,NULL,1000,0),(232,88,'0.25ml管',68.00,NULL,1000,0),(233,89,'体重＜10kg',68.00,NULL,1000,0),(234,89,'20＜体重＜40kg',78.00,NULL,1000,0),(235,90,'幼猫',28.00,NULL,1000,0),(236,90,'成猫',38.00,NULL,1000,0),(237,91,'60ml/盒',58.00,NULL,1000,0),(238,92,'60ml/盒',48.00,NULL,1000,0),(239,93,'50ml/盒',68.00,NULL,1000,0),(240,94,'6g/袋*10',48.00,NULL,1000,0),(241,95,'WK-6',12.00,NULL,1000,0),(242,96,'L',38.00,NULL,1000,0),(243,97,'蓝色',18.00,NULL,1000,0),(244,98,'60cm*90cm*22片（L）',45.00,NULL,1000,0),(245,98,'45cm*60cm*50片(M)',45.00,NULL,1000,0),(246,98,'45cm*33cm*100片(S)',45.00,NULL,1000,0),(247,99,'200片',88.00,NULL,1000,0),(248,100,'200片',88.00,NULL,1000,0),(249,101,'200片',88.00,NULL,1000,0),(250,102,'化毛膏',88.00,NULL,1000,0),(251,102,'猫胺膏',88.00,NULL,1000,0),(252,103,'钙肽膏',88.00,NULL,1000,0),(253,104,'西瓜味',38.00,NULL,1000,0),(254,104,'樱花味',38.00,NULL,1000,0),(255,104,'森林味',38.00,NULL,1000,0),(256,104,'蜜桃味',38.00,NULL,1000,0),(257,105,'浅蓝',48.00,NULL,1000,0),(258,105,'咖色',48.00,NULL,1000,0),(259,106,'螺甸蓝',68.00,NULL,1000,0),(260,106,'胭脂粉',68.00,NULL,1000,0),(261,107,'润玉蓝',48.00,NULL,1000,0),(262,107,'晶莹绿',48.00,NULL,1000,0),(263,108,'粉色',108.00,0.00,1000,0),(264,108,'灰色',108.00,0.00,998,0),(265,109,'XS',15.00,0.00,1000,0),(266,109,'S',18.00,0.00,1000,0),(267,109,'M',22.00,0.00,1000,0),(268,109,'L',28.00,0.00,1000,0),(269,109,'XL',32.00,0.00,1000,0),(270,110,'S',18.00,0.00,1000,0),(271,110,'M',22.00,0.00,1000,0),(272,110,'L',28.00,0.00,1000,0),(273,110,'XL',32.00,0.00,1000,0);
/*!40000 ALTER TABLE `product_variant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room`
--

DROP TABLE IF EXISTS `room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `shop_id` int DEFAULT NULL,
  `type` int DEFAULT NULL COMMENT '0 大池子 1 小池子 2 吹毛台 3 0-20寄养 4 20-40寄养 5 48-80寄养 6 80+寄养',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='洗护间表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room`
--

LOCK TABLES `room` WRITE;
/*!40000 ALTER TABLE `room` DISABLE KEYS */;
INSERT INTO `room` VALUES (1,'洗护',1,0),(2,'洗护',1,1),(3,'寄养',1,3),(4,'寄养',1,3);
/*!40000 ALTER TABLE `room` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shop`
--

DROP TABLE IF EXISTS `shop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shop` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(300) DEFAULT NULL,
  `address` mediumtext,
  `longitude` float(12,6) DEFAULT NULL COMMENT '经度',
  `latitude` float(12,6) DEFAULT NULL COMMENT '纬度',
  `admin_id` int DEFAULT NULL COMMENT '店铺管理员账号',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商店表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shop`
--

LOCK TABLES `shop` WRITE;
/*!40000 ALTER TABLE `shop` DISABLE KEYS */;
INSERT INTO `shop` VALUES (1,'亿宠苑汇置店','辽宁省沈阳市沈北新区蒲河路31-6号6门',123.406059,41.944519,2,NULL,NULL);
/*!40000 ALTER TABLE `shop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shoppet`
--

DROP TABLE IF EXISTS `shoppet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shoppet` (
  `id` int NOT NULL AUTO_INCREMENT,
  `shop_id` int DEFAULT NULL,
  `type` int DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL COMMENT '宠物名字',
  `description` mediumtext COMMENT '描述',
  `img_url` varchar(200) DEFAULT NULL COMMENT '图片地址',
  `price` decimal(10,0) DEFAULT NULL COMMENT '价格',
  `gender` int DEFAULT NULL COMMENT '0 公 1 母',
  `age` varchar(20) DEFAULT NULL COMMENT '年龄',
  `fur` int DEFAULT NULL COMMENT '0 长毛 1 短毛',
  `category` int DEFAULT NULL COMMENT '0 狗狗 1 猫猫',
  `active` int DEFAULT NULL COMMENT '0-显示 1-不显示',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商店宠物';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shoppet`
--

LOCK TABLES `shoppet` WRITE;
/*!40000 ALTER TABLE `shoppet` DISABLE KEYS */;
INSERT INTO `shoppet` VALUES (2,1,1,'哈巴狗','可爱的小狗','string',1000,0,'string',0,0,0,'2024-05-23 15:01:38','2024-05-23 15:01:38'),(3,1,3,'哈巴狗','可爱的小狗','string',1000,0,'3个月',0,0,0,'2024-05-23 15:01:38','2024-05-23 15:01:38'),(4,2,4,'哈巴狗','可爱的小狗','string',1000,0,'string',0,0,0,'2024-05-23 15:01:38','2024-05-23 15:01:38'),(5,1,NULL,'猫','可爱的小狗','string',1000,0,'string',0,0,0,'2024-05-23 15:01:38','2024-05-23 15:01:38');
/*!40000 ALTER TABLE `shoppet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shoppet_picture`
--

DROP TABLE IF EXISTS `shoppet_picture`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shoppet_picture` (
  `id` int NOT NULL AUTO_INCREMENT,
  `shoppet_id` int DEFAULT NULL,
  `image_url` varchar(300) DEFAULT NULL COMMENT '图片地址',
  `sort_index` int DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商店宠物图片';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shoppet_picture`
--

LOCK TABLES `shoppet_picture` WRITE;
/*!40000 ALTER TABLE `shoppet_picture` DISABLE KEYS */;
/*!40000 ALTER TABLE `shoppet_picture` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL COMMENT '名字',
  `phone` varchar(20) DEFAULT NULL COMMENT '电话',
  `avatar` mediumtext COMMENT '头像',
  `home_id` int DEFAULT NULL COMMENT '家庭id',
  `open_id` varchar(200) DEFAULT NULL COMMENT '微信ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (25,'亿宠苑','15702458033','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240704103857647.jpeg',12,'oYbIg5UeQcu7pJv0Oc2cIIWiY7E8'),(26,'子麒','13324057515','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240705103220132.jpg',14,'oYbIg5WiFEVzdywPZm3tVB-PGBkk'),(27,'小王','15142561188','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240713201155354.jpg',27,'oYbIg5Q4UzyRK1ydsPavfWMYc3k8'),(28,'666','18641166002','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240713134225307.jpg',1,'oYbIg5ZsYv8qYMv2kjlpxG6QeC6M'),(29,'山人',NULL,NULL,19,'oYbIg5Zpd0dQMD-Q4TKXGtxLiKh4'),(30,'自然呆',NULL,NULL,20,'oYbIg5fpImeHL62trm3E3oH7DCKY'),(31,'赵先生',NULL,NULL,21,'oYbIg5RhrKPLSBoq7Pfe-p729UYo'),(32,NULL,NULL,NULL,NULL,'oYbIg5QF8ShyITW0j7E81lPDtW-w'),(33,NULL,NULL,NULL,NULL,'oYbIg5dq3nCXF4UP01UFC4V-WX1k'),(35,'小李','18642294362','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240705102438489.jpg',12,'oYbIg5UN-xzijTvkhoaHiYktUxXk'),(36,'水源','13149841671','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240709165953001.jpg',22,'oYbIg5UFOL3Jf1lm4ybvVNw5mZRY'),(37,'我叫小丝青🐾',NULL,NULL,23,'oYbIg5cNc0MtfROpB1qLboDEhtUw'),(38,'鬼地方个',NULL,NULL,24,'oYbIg5YqhNhcS7V7IjUvQ13o8nRQ'),(39,'王大棒子',NULL,NULL,25,'oYbIg5T-XtKtpcvJK47X-GdKsIDo'),(40,NULL,NULL,NULL,NULL,'oYbIg5e3hUZB5ZQ7zeFV9HL2FHPM'),(41,'撒反对',NULL,NULL,26,'oYbIg5TAhpA7DqNNUhjVeAbDirvg'),(42,'Judy','','wxfile://tmp_3e77fa35312e4cf83c1fa387076e60891991080fd24185cf.jpg',28,'oYbIg5TORx8OkRr1Gsk-x_qkcTO8'),(43,NULL,NULL,NULL,NULL,'oYbIg5QvQRKInXJkK-NuhMxN6dNU'),(44,NULL,NULL,NULL,NULL,'oYbIg5Y1ht3UuUK-JD5wa7cKIHL0'),(45,NULL,NULL,NULL,NULL,'oYbIg5YgJOiQYVrTIdtzJ36943lA'),(46,NULL,NULL,NULL,NULL,'oYbIg5Q4zptEMzX3ojv1Tx8KjWKM'),(47,NULL,NULL,NULL,NULL,'oYbIg5W-9k7uY0JHWvg--1pab_OM'),(48,NULL,NULL,NULL,NULL,'oYbIg5TWRyp19i0P4JnBjNNt_KeY'),(49,'毛球','13390160999','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240706095804124.jpg',2,'oYbIg5ZEHMi1VsL7Aj7mIVPfg7ek'),(50,NULL,NULL,NULL,NULL,'oYbIg5abeGn4ZDc5orp9d_yd0vC0'),(51,'测试','19182077064','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240709052045538.jpg',NULL,'oYbIg5QiJqJsQBWP3-TGV_wVJOuE'),(52,'是安迪阿','19528845731','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240709174807267.jpg',29,'oYbIg5Z9SUyvo2PUnc4ikWB4hGRw'),(53,'珂珂拿铁','18641104281','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240711205627755.jpg',30,'oYbIg5T7g4PDxURU0VvUieRneX4E'),(54,'蹦蹦','13897998995','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240712172011145.jpg',31,'oYbIg5SOTnooWnL9UDsD4ZkNj5TQ'),(56,'小宝','18611481140','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240713122349632.jpg',33,'oYbIg5V-osgXAE7cfN2ZKyXlc7t0'),(57,'丽萨','13644994442','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240713171715117.jpg',34,'oYbIg5Ymxicfo8VtYQ7reN5KqjHk'),(58,'.','13385105153','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240714140527514.jpg',35,'oYbIg5UK1e2Xl2WMr9N_vaEFBYEM'),(59,'小朋友i','18309822016','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240720113326420.jpg',36,'oYbIg5ccSAeEpUew3A-uALT_5bg4'),(60,'郭','18502472492','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240720173849459.jpg',37,'oYbIg5UAM4oplqIf4PlwvvZYsKmY'),(62,NULL,NULL,NULL,NULL,'oYbIg5cku-QDBfztfqEf8fZci5X0'),(63,'上善若水','13478346500','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240731091844552.jpg',38,'oYbIg5edRHhGN4ydMYCSBZLghA9k'),(64,NULL,NULL,NULL,NULL,'oYbIg5cWmZVdr66vVw0aUnXeylKg'),(65,'Sally','18814548713','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240816110550042.jpg',39,'oYbIg5YQBe_ld8pN_JmYasPL-Yx0'),(66,'fds ','17779594862','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240816135330186.jpeg',NULL,'oYbIg5cMIAYKzk9Qlxt1bXxZygSE'),(67,'1️⃣','15174076796','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240824181237302.jpg',40,'oYbIg5fGCMMjH9RMIwyUpyjLpZzs'),(68,NULL,NULL,NULL,NULL,'oYbIg5SXTQUPn9sq_NLEg-srjPoo'),(69,'','','',NULL,'oYbIg5ZJQcyvAmVm0ESJLPSVr9aM'),(70,'🐶 有趣的灵魂','18328412530','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20241008175942704.jpg',41,'oYbIg5WS8-0xq8JW1esPIexBtkyA'),(71,'甜.','13142121604','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20241024171359958.jpeg',42,'oYbIg5WdEa5vsFI0facA8gzN4-bI'),(72,'123','18540316530','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20241029161421340.jpeg',43,'oYbIg5fLiBklZWJEA8GQ7A75UpC0'),(73,NULL,NULL,NULL,NULL,'oYbIg5aAgVPV8mDZgpjRxpU1c5RE'),(74,'宅','17794350053','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20250306211717104.jpeg',27,'oYbIg5c9EEwdnHUDrHKhuVvcBah8'),(75,'orca','15842606685','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20250419112618674.jpeg',12,'oYbIg5exJelCGc0KbCeolqSVSJ94'),(76,'琳子🍓','18652073045','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20250515174453601.jpg',45,'oYbIg5cqEjQKJ8zSEgN7ZC_UdsbE'),(77,'马.不爱回微信','18240142660','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20250515175334728.jpg',46,'oYbIg5eXOc91hWsnbwrzNGn43B_E'),(78,'Leo','15286579137','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20250516140454188.jpeg',47,'oYbIg5TsbEKP7C4oon8X3qBGo2Aw'),(79,'富贵儿','15604080400','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20250516195105098.jpg',48,'oYbIg5U_17YYvSR8ujl7L1-4HPwU'),(80,'🌰','15942358756','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20250516195326014.jpg',48,'oYbIg5e2FwcB4NHdZxiuv4SZXBWQ'),(81,NULL,NULL,NULL,NULL,'oYbIg5Z3yAIgTDtbAHaqnPyeq1Ig'),(82,'黑子','19524045280','https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20250730191829841.jpg',49,'oYbIg5ZZHWTiMwRILmUY7jw4gxPQ');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_member`
--

DROP TABLE IF EXISTS `user_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_member` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `home_id` int DEFAULT NULL,
  `member_id` int DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `discount_rate1` decimal(3,2) DEFAULT NULL COMMENT '洗护项目折扣率(0-1)',
  `discount_rate2` decimal(3,2) DEFAULT NULL COMMENT '商品折扣率',
  `active` int DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户会员';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_member`
--

LOCK TABLES `user_member` WRITE;
/*!40000 ALTER TABLE `user_member` DISABLE KEYS */;
INSERT INTO `user_member` VALUES (2,6,6,725667841,'2024-05-30','2024-11-30',0.70,0.90,0,'2024-05-30 07:39:03'),(3,53,30,1,'2024-07-11','2025-07-11',0.70,0.90,0,'2024-07-11 23:27:00'),(4,54,31,1,'2024-07-12','2025-07-12',0.70,0.90,0,'2024-07-12 17:23:00'),(5,56,32,1,'2024-07-13','2025-07-13',0.70,0.90,0,'2024-07-13 12:28:00'),(6,49,2,1,'2024-07-13','2025-07-13',0.70,0.90,0,'2024-07-13 20:09:00'),(7,25,12,1,'2024-06-13','2025-06-13',0.70,0.90,0,'2024-06-13 16:00:03'),(8,57,34,1,'2024-07-13','2025-07-13',0.70,0.90,0,'2024-07-13 17:28:00'),(10,28,16,1,'2024-06-20','2025-06-20',0.70,0.90,0,'2024-06-20 23:22:47'),(11,28,16,1,'2024-06-21','2025-06-21',0.70,0.90,0,'2024-06-21 09:10:19'),(12,28,16,1,'2024-06-21','2025-06-21',0.70,0.90,0,'2024-06-21 09:13:23'),(13,36,22,1,'2024-06-30','2025-06-30',0.70,0.90,0,'2024-06-30 07:50:29'),(14,59,36,1,'0024-07-20','0025-07-20',0.70,0.90,0,'0024-07-20 11:37:00'),(15,60,37,1,'2024-07-20','2025-07-20',0.70,0.90,0,'2024-07-20 17:51:00'),(16,75,12,1,'2024-06-13','2025-07-20',0.70,0.90,0,'2024-06-13 16:00:03'),(17,77,46,1,'2025-05-15','2026-05-15',0.70,0.90,0,'2025-05-15 17:57:03'),(18,79,48,1,'2025-05-16','2026-05-16',0.70,0.90,0,'2025-05-16 19:55:59');
/*!40000 ALTER TABLE `user_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_token`
--

DROP TABLE IF EXISTS `user_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_token` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `token` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_token`
--

LOCK TABLES `user_token` WRITE;
/*!40000 ALTER TABLE `user_token` DISABLE KEYS */;
INSERT INTO `user_token` VALUES (2,28,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyOCIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzI0MDQ5MjYyfQ.dIh5lA3x5hPA-2GmuU40P8DgFsT0QpaRMqHQVQEg8gI'),(3,55,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1NSIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzIzNDM2NDQwfQ.gvdvwaoDUE2WbagiA5f7j_VrE4wK5PUZiOTUeHUaCLw'),(4,56,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1NiIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzIzNDM2NjI5fQ.6r943yPvAYSRdBwdyJ7xVLubnhH8KSNI7-zMB7TYMX8'),(5,27,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyNyIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzQ5ODkyMjQwfQ._vzu35MEJsd2QVAY2cV8jrfVt0_r2gWC1R4O9EX6reU'),(6,57,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1NyIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzIzNDU0MjM0fQ.k3UTG9lNwHeHvoV4PAZgUn6IEtPrC7XYQv91Bf9Mbd0'),(7,49,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0OSIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzIzNDY0MzU5fQ.kpYO-zWjpTIFCKG5KpSPcWvw-TvckOMPDdhzMrDbpeM'),(8,35,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzNSIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzQ5NjI5OTE0fQ.7VE-fFe0qakUbVf71qveowEKLMD6Pjjy0VT7k4sUmqU'),(9,25,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyNSIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzUwNjYzNTI1fQ.1t4krEDSUT96c242ipPuLmpziEQVjC4NzVamTUznHrQ'),(10,44,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0NCIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzUwNjY0MjExfQ.PlWYdFUiNYETr5ilGYRFEO8fwsgS_j-qbuZbrLpYIhE'),(11,36,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzNiIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzI2NDU5Nzk2fQ.jOLB7Un5T6daRA3xHu6_lWHeuPEXCvXPmZG-AN83-Go'),(12,58,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1OCIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzIzNTI5MTI3fQ.I9B551T8Zmpbvk9tX5jq4_zt3T4Glgwpp_DhZ48cVoI'),(13,54,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1NCIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzI5NTMyNzUwfQ.BbfXZHBtuj63V9foKYvqSGz8cIybxc1GC8Xfen9tUAA'),(14,59,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1OSIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzI0MDM4NDA2fQ.YDm2jDPiIVTIIxcSsv29cRFo7U3SJ0xzD6b42hPkQQw'),(15,45,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0NSIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzYzMTM5MzY3fQ.Uise2Nvx7D_5gqJ0bEHCFpeXsiRNT53KAGPEjGiuS5I'),(16,43,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0MyIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzY3NzU1NTMzfQ.Yc6f0etUmpnnxoOsMwF3A2v79WPmUPE5RQG6O3PTrzo'),(17,60,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2MCIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzI0MDYwMzI5fQ.APCHpL3EOenReXZRPleNNYRNAUnO9l6ymIUAIvZCC_U'),(18,61,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2MSIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzI0MDYwNjQyfQ.rFRbELo3vRwOulMEyKqn_nuuZM_rrZXQt28RDK3Ygvg'),(19,62,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2MiIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzU4MDkyMTE4fQ.3xz50aP98tUHLIrVkC0q5UTzY_iP-ZRbgGioenbOUKM'),(20,63,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2MyIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzI0OTgwNzI0fQ.m-72ME8qtCEJ_nHsXF2lkYXXXe3Gdcr0uKGXfeaqPxk'),(21,64,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2NCIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzU2NjYwNzI3fQ.9eBj98LTKlFTuD_z2lTiubH9NyRmMqWQ15sKVzPPGCs'),(22,47,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0NyIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzU1NjY3NDc0fQ.5rGSRFhEx22uG_4k8EmM8yJeAjd3RLJPyz4qPZspcjM'),(23,50,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1MCIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzU1ODAyNzkxfQ.kyv5-ZsfnsNXXekTYvI6_IESezPsvIF-U4Xnem4g87c'),(24,65,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2NSIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzI2MzY5NTQ5fQ.2uhwsN2GASPrfrkk2GClQyXEJmfnuTTd0ipTfneOzm0'),(25,66,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2NiIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzI2Mzc5NjIyfQ.Y57IfSmmrCloKHHUdKmLREIBsZPE0bL0q_mVIVoKAyo'),(26,67,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2NyIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzI3MDg2MzU2fQ.ZMhGHu3AaHktR11rOHIu93rurOTsRWDJWH3-enbip7o'),(27,48,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0OCIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzY0NTk1MTAxfQ.u2QKHWr8SNfGG8pe6QNPaAX4wBDO8JEXlEGPkRP-Geo'),(28,52,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1MiIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzI3NTk2NDYxfQ.v4Y8dBSk_z5RRnZueWkpxt4s6LLolK472yHdPPGuo6A'),(29,68,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2OCIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzI4MDc4MTMxfQ.4S5mIciSmhxgqRhTHx8xrCPf733qrYLCwteAui17qFU'),(30,69,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2OSIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzI4MjcwMzkwfQ.MFWqxFPx7D81kcoh8jo_9nLaRoWowtDubq1MK_4_9pw'),(31,46,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0NiIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzUwNjY0MjExfQ.LW4AJ5aCiuSe64vm0AFqmxXpCxo1uTKd83OGWPGcR3M'),(32,70,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3MCIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzMwOTczNTgyfQ.WyBiTyvOTW7j8F6yZBh12UUj_JucYV3CLclXyZshryU'),(33,71,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3MSIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzM2NTgxOTc4fQ.6FF6xrJXK66ll4HY_w1489n1OdhiMzFGZNXuZgGKhgs'),(34,72,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3MiIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzMyNzgxNjYxfQ.lilo-QRU0aAfoiIL2nG2QslBgIR5rJtwsdB8F5JaDGY'),(35,73,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3MyIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzQyMzAzMzgwfQ.N7E4Qa15LotRfpzLPUodOi5-6SBl28E4uJXahloLUao'),(36,74,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NCIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzQ5ODkzNzQ1fQ.n7G3v_lWzd0HS2v9wH_YoaTl0ONF-6esj3HO9sKvrNc'),(37,75,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NSIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzUwNTc1MTc0fQ._USvsYzC8ocpOGvZrEtC5syl7Ks50v94xKvNN2RDYH8'),(38,76,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NiIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzQ5ODk0MjkzfQ.Lgr0V89rC0GlHiHY_61G4K6VDyRj20boGYIhHAaLs4Y'),(39,77,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NyIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzU4MDAzMjAyfQ.6yeXw83Hw5pz5oOQprvav0lgmryzyDPTWhnpOeUzF3o'),(40,78,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3OCIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzQ5OTY3NDkzfQ.g4uKmlNRuJQOZGm5cQJKQKjqrET6r7PVnnWuQG6ZcNc'),(41,79,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3OSIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzY3NjgwOTI2fQ.5whaAtWkyUnisbXrmXk_jsvNjaXde5HpmHo6_Q30kRM'),(42,80,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4MCIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzQ5OTg4NDA1fQ.AEDDaR56exTkr75BAakpparMhgWpqjvBgpOkU0m5gUA'),(43,81,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4MSIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzUxMzA3Njg1fQ.HsuA-r6-5tkbQ8SJ1xSRh31SXdJzBeUcSiT-V7OvfDE'),(44,82,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4MiIsInR5cGUiOiJ1c2VyIiwiZXhwIjoxNzU2NDY2MzA5fQ.7UzOjMbDWCYxbrQg2-1ZbRLdsfc46na426OgpVHCqPA');
/*!40000 ALTER TABLE `user_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wash_item`
--

DROP TABLE IF EXISTS `wash_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wash_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `shop_id` int DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL COMMENT '普通价格',
  `avatar` text COMMENT '头像',
  `description` text,
  `item_type` int DEFAULT NULL COMMENT '0 洗澡 1 美容 2 剃毛',
  `start_weight` int DEFAULT NULL COMMENT '开始体重包括',
  `end_weight` int DEFAULT NULL COMMENT '结束体重 不包括',
  `category` int DEFAULT NULL COMMENT '0 狗狗 1 猫猫',
  `time` decimal(10,1) DEFAULT NULL,
  `fur` int DEFAULT NULL COMMENT '0 长毛 1 短毛',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=211 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='洗护项目表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wash_item`
--

LOCK TABLES `wash_item` WRITE;
/*!40000 ALTER TABLE `wash_item` DISABLE KEYS */;
INSERT INTO `wash_item` VALUES (1,1,'普通清洁洗护',40.00,NULL,'狗洗澡',0,0,3,0,0.5,0),(2,1,'超白闪亮定制洗护',88.00,NULL,'狗洗澡',0,0,3,0,1.0,0),(3,1,'蓬松赛级定制洗护',88.00,NULL,'狗洗澡',0,0,3,0,1.0,0),(4,1,'控油焕肤定制洗护',108.00,NULL,'狗洗澡',0,0,3,0,1.0,0),(5,1,'清爽去屑定制洗护',88.00,NULL,'狗洗澡',0,0,3,0,1.0,0),(6,1,'低敏呵护定制洗护',88.00,NULL,'狗洗澡',0,0,3,0,1.0,0),(7,1,'深层补水定制洗护',88.00,NULL,'狗洗澡',0,0,3,0,1.0,0),(8,1,'抑菌维稳定制洗护',108.00,NULL,'狗洗澡',0,0,3,0,1.0,0),(9,1,'定制造型',68.00,NULL,'狗美容',1,0,3,0,1.5,0),(10,1,'再生净化水疗SPA',60.00,NULL,'狗SPA',2,0,3,0,0.5,0),(11,1,'维稳焕肤镇静精华液',60.00,NULL,'狗SPA',2,0,3,0,0.5,0),(12,1,'抑菌修复水疗SPA',60.00,NULL,'狗SPA',2,0,3,0,0.5,0),(13,1,'亮泽垂顺发膜SPA',60.00,NULL,'狗SPA',2,0,3,0,0.5,0),(14,1,'修复还原水疗SPA',60.00,NULL,'狗SPA',2,0,3,0,0.5,0),(15,1,'普通清洁洗护',60.00,NULL,'狗洗澡',0,3,7,0,1.0,0),(16,1,'超白闪亮定制洗护',108.00,NULL,'狗洗澡',0,3,7,0,1.5,0),(17,1,'蓬松赛级定制洗护',108.00,NULL,'狗洗澡',0,3,7,0,1.5,0),(18,1,'控油焕肤定制洗护',128.00,NULL,'狗洗澡',0,3,7,0,1.5,0),(19,1,'清爽去屑定制洗护',108.00,NULL,'狗洗澡',0,3,7,0,1.5,0),(20,1,'低敏呵护定制洗护',108.00,NULL,'狗洗澡',0,3,7,0,1.5,0),(21,1,'深层补水定制洗护',108.00,NULL,'狗洗澡',0,3,7,0,1.5,0),(22,1,'抑菌维稳定制洗护',128.00,NULL,'狗洗澡',0,3,7,0,1.5,0),(23,1,'定制造型',68.00,NULL,'狗美容',1,3,7,0,1.5,0),(24,1,'再生净化水疗SPA',80.00,NULL,'狗SPA',2,3,7,0,0.5,0),(25,1,'维稳焕肤镇静精华液',80.00,NULL,'狗SPA',2,3,7,0,0.5,0),(26,1,'抑菌修复水疗SPA',80.00,NULL,'狗SPA',2,3,7,0,0.5,0),(27,1,'亮泽垂顺发膜SPA',80.00,NULL,'狗SPA',2,3,7,0,0.5,0),(28,1,'修复还原水疗SPA',80.00,NULL,'狗SPA',2,3,7,0,0.5,0),(29,1,'普通清洁洗护',80.00,NULL,'狗洗澡',0,7,12,0,1.0,0),(30,1,'超白闪亮定制洗护',158.00,NULL,'狗洗澡',0,7,12,0,1.5,0),(31,1,'蓬松赛级定制洗护',158.00,NULL,'狗洗澡',0,7,12,0,1.5,0),(32,1,'控油焕肤定制洗护',178.00,NULL,'狗洗澡',0,7,12,0,1.5,0),(33,1,'清爽去屑定制洗护',158.00,NULL,'狗洗澡',0,7,12,0,1.5,0),(34,1,'低敏呵护定制洗护',158.00,NULL,'狗洗澡',0,7,12,0,1.5,0),(35,1,'深层补水定制洗护',158.00,NULL,'狗洗澡',0,7,12,0,1.5,0),(36,1,'抑菌维稳定制洗护',178.00,NULL,'狗洗澡',0,7,12,0,1.5,0),(37,1,'定制造型',88.00,NULL,'狗美容',1,7,12,0,1.5,0),(38,1,'再生净化水疗SPA',120.00,NULL,'狗SPA',2,7,12,0,0.5,0),(39,1,'维稳焕肤镇静精华液',120.00,NULL,'狗SPA',2,7,12,0,0.5,0),(40,1,'抑菌修复水疗SPA',120.00,NULL,'狗SPA',2,7,12,0,0.5,0),(41,1,'亮泽垂顺发膜SPA',120.00,NULL,'狗SPA',2,7,12,0,0.5,0),(42,1,'修复还原水疗SPA',120.00,NULL,'狗SPA',2,7,12,0,0.5,0),(43,1,'普通清洁洗护',110.00,NULL,'狗洗澡',0,12,17,0,1.0,0),(44,1,'超白闪亮定制洗护',208.00,NULL,'狗洗澡',0,12,17,0,1.5,0),(45,1,'蓬松赛级定制洗护',208.00,NULL,'狗洗澡',0,12,17,0,1.5,0),(46,1,'控油焕肤定制洗护',228.00,NULL,'狗洗澡',0,12,17,0,1.5,0),(47,1,'清爽去屑定制洗护',208.00,NULL,'狗洗澡',0,12,17,0,1.5,0),(48,1,'低敏呵护定制洗护',208.00,NULL,'狗洗澡',0,12,17,0,1.5,0),(49,1,'深层补水定制洗护',208.00,NULL,'狗洗澡',0,12,17,0,1.5,0),(50,1,'抑菌维稳定制洗护',228.00,NULL,'狗洗澡',0,12,17,0,1.5,0),(51,1,'定制造型',98.00,NULL,'狗美容',1,12,17,0,1.5,0),(52,1,'再生净化水疗SPA',130.00,NULL,'狗SPA',2,12,17,0,0.5,0),(53,1,'维稳焕肤镇静精华液',130.00,NULL,'狗SPA',2,12,17,0,0.5,0),(54,1,'抑菌修复水疗SPA',130.00,NULL,'狗SPA',2,12,17,0,0.5,0),(55,1,'亮泽垂顺发膜SPA',130.00,NULL,'狗SPA',2,12,17,0,0.5,0),(56,1,'修复还原水疗SPA',130.00,NULL,'狗SPA',2,12,17,0,0.5,0),(57,1,'普通清洁洗护',140.00,NULL,'狗洗澡',0,17,22,0,1.5,0),(58,1,'超白闪亮定制洗护',258.00,NULL,'狗洗澡',0,17,22,0,2.0,0),(59,1,'蓬松赛级定制洗护',258.00,NULL,'狗洗澡',0,17,22,0,2.0,0),(60,1,'控油焕肤定制洗护',278.00,NULL,'狗洗澡',0,17,22,0,2.0,0),(61,1,'清爽去屑定制洗护',258.00,NULL,'狗洗澡',0,17,22,0,2.0,0),(62,1,'低敏呵护定制洗护',258.00,NULL,'狗洗澡',0,17,22,0,2.0,0),(63,1,'深层补水定制洗护',258.00,NULL,'狗洗澡',0,17,22,0,2.0,0),(64,1,'抑菌维稳定制洗护',278.00,NULL,'狗洗澡',0,17,22,0,2.0,0),(65,1,'定制造型',148.00,NULL,'狗美容',1,17,22,0,1.5,0),(66,1,'再生净化水疗SPA',140.00,NULL,'狗SPA',2,17,22,0,0.5,0),(67,1,'维稳焕肤镇静精华液',140.00,NULL,'狗SPA',2,17,22,0,0.5,0),(68,1,'抑菌修复水疗SPA',140.00,NULL,'狗SPA',2,17,22,0,0.5,0),(69,1,'亮泽垂顺发膜SPA',140.00,NULL,'狗SPA',2,17,22,0,0.5,0),(70,1,'修复还原水疗SPA',140.00,NULL,'狗SPA',2,17,22,0,0.5,0),(71,1,'普通清洁洗护',180.00,NULL,'狗洗澡',0,22,30,0,1.5,0),(72,1,'超白闪亮定制洗护',308.00,NULL,'狗洗澡',0,22,30,0,2.0,0),(73,1,'蓬松赛级定制洗护',308.00,NULL,'狗洗澡',0,22,30,0,2.0,0),(74,1,'控油焕肤定制洗护',328.00,NULL,'狗洗澡',0,22,30,0,2.0,0),(75,1,'清爽去屑定制洗护',308.00,NULL,'狗洗澡',0,22,30,0,2.0,0),(76,1,'低敏呵护定制洗护',308.00,NULL,'狗洗澡',0,22,30,0,2.0,0),(77,1,'深层补水定制洗护',308.00,NULL,'狗洗澡',0,22,30,0,2.0,0),(78,1,'抑菌维稳定制洗护',328.00,NULL,'狗洗澡',0,22,30,0,2.0,0),(79,1,'定制造型',178.00,NULL,'狗美容',1,22,30,0,1.5,0),(80,1,'再生净化水疗SPA',160.00,NULL,'狗SPA',2,22,30,0,0.5,0),(81,1,'维稳焕肤镇静精华液',160.00,NULL,'狗SPA',2,22,30,0,0.5,0),(82,1,'抑菌修复水疗SPA',160.00,NULL,'狗SPA',2,22,30,0,0.5,0),(83,1,'亮泽垂顺发膜SPA',160.00,NULL,'狗SPA',2,22,30,0,0.5,0),(84,1,'修复还原水疗SPA',160.00,NULL,'狗SPA',2,22,30,0,0.5,0),(85,1,'普通清洁洗护',230.00,NULL,'狗洗澡',0,30,999,0,2.0,0),(86,1,'超白闪亮定制洗护',358.00,NULL,'狗洗澡',0,30,999,0,2.5,0),(87,1,'蓬松赛级定制洗护',358.00,NULL,'狗洗澡',0,30,999,0,2.5,0),(88,1,'控油焕肤定制洗护',378.00,NULL,'狗洗澡',0,30,999,0,2.5,0),(89,1,'清爽去屑定制洗护',358.00,NULL,'狗洗澡',0,30,999,0,2.5,0),(90,1,'低敏呵护定制洗护',358.00,NULL,'狗洗澡',0,30,999,0,2.5,0),(91,1,'深层补水定制洗护',358.00,NULL,'狗洗澡',0,30,999,0,2.5,0),(92,1,'抑菌维稳定制洗护',378.00,NULL,'狗洗澡',0,30,999,0,2.5,0),(93,1,'定制造型',238.00,NULL,'狗美容',1,30,999,0,1.5,0),(94,1,'再生净化水疗SPA',180.00,NULL,'狗SPA',2,30,999,0,0.5,0),(95,1,'维稳焕肤镇静精华液',180.00,NULL,'狗SPA',2,30,999,0,0.5,0),(96,1,'抑菌修复水疗SPA',180.00,NULL,'狗SPA',2,30,999,0,0.5,0),(97,1,'亮泽垂顺发膜SPA',180.00,NULL,'狗SPA',2,30,999,0,0.5,0),(98,1,'修复还原水疗SPA',180.00,NULL,'狗SPA',2,30,999,0,0.5,0),(99,1,'普通清洁洗护',80.00,NULL,'猫洗澡',0,0,2,1,1.0,1),(100,1,'超白闪亮定制洗护',128.00,NULL,'猫洗澡',0,0,2,1,1.5,1),(101,1,'蓬松赛级定制洗护',128.00,NULL,'猫洗澡',0,0,2,1,1.5,1),(102,1,'控油焕肤定制洗护',148.00,NULL,'猫洗澡',0,0,2,1,1.5,1),(103,1,'清爽去屑定制洗护',128.00,NULL,'猫洗澡',0,0,2,1,1.5,1),(104,1,'低敏呵护定制洗护',128.00,NULL,'猫洗澡',0,0,2,1,1.5,1),(105,1,'深层补水定制洗护',128.00,NULL,'猫洗澡',0,0,2,1,1.5,1),(106,1,'抑菌维稳定制洗护',148.00,NULL,'猫洗澡',0,0,2,1,1.5,1),(107,1,'定制造型',999.00,NULL,'猫美容',1,0,2,1,999.0,1),(108,1,'再生净化水疗SPA',118.00,NULL,'猫SPA',2,0,2,1,0.5,1),(109,1,'维稳焕肤镇静精华液',118.00,NULL,'猫SPA',2,0,2,1,0.5,1),(110,1,'抑菌修复水疗SPA',118.00,NULL,'猫SPA',2,0,2,1,0.5,1),(111,1,'亮泽垂顺发膜SPA',118.00,NULL,'猫SPA',2,0,2,1,0.5,1),(112,1,'修复还原水疗SPA',118.00,NULL,'猫SPA',2,0,2,1,0.5,1),(113,1,'普通清洁洗护',120.00,NULL,'猫洗澡',0,2,5,1,1.5,1),(114,1,'超白闪亮定制洗护',168.00,NULL,'猫洗澡',0,2,5,1,2.0,1),(115,1,'蓬松赛级定制洗护',168.00,NULL,'猫洗澡',0,2,5,1,2.0,1),(116,1,'控油焕肤定制洗护',188.00,NULL,'猫洗澡',0,2,5,1,2.0,1),(117,1,'清爽去屑定制洗护',168.00,NULL,'猫洗澡',0,2,5,1,2.0,1),(118,1,'低敏呵护定制洗护',168.00,NULL,'猫洗澡',0,2,5,1,2.0,1),(119,1,'深层补水定制洗护',168.00,NULL,'猫洗澡',0,2,5,1,2.0,1),(120,1,'抑菌维稳定制洗护',188.00,NULL,'猫洗澡',0,2,5,1,2.0,1),(121,1,'定制造型',999.00,NULL,'猫美容',1,2,5,1,999.0,1),(122,1,'再生净化水疗SPA',158.00,NULL,'猫SPA',2,2,5,1,0.5,1),(123,1,'维稳焕肤镇静精华液',158.00,NULL,'猫SPA',2,2,5,1,0.5,1),(124,1,'抑菌修复水疗SPA',158.00,NULL,'猫SPA',2,2,5,1,0.5,1),(125,1,'亮泽垂顺发膜SPA',158.00,NULL,'猫SPA',2,2,5,1,0.5,1),(126,1,'修复还原水疗SPA',158.00,NULL,'猫SPA',2,2,5,1,0.5,1),(127,1,'普通清洁洗护',140.00,NULL,'猫洗澡',0,5,8,1,2.0,1),(128,1,'超白闪亮定制洗护',188.00,NULL,'猫洗澡',0,5,8,1,2.5,1),(129,1,'蓬松赛级定制洗护',188.00,NULL,'猫洗澡',0,5,8,1,2.5,1),(130,1,'控油焕肤定制洗护',208.00,NULL,'猫洗澡',0,5,8,1,2.5,1),(131,1,'清爽去屑定制洗护',188.00,NULL,'猫洗澡',0,5,8,1,2.5,1),(132,1,'低敏呵护定制洗护',188.00,NULL,'猫洗澡',0,5,8,1,2.5,1),(133,1,'深层补水定制洗护',188.00,NULL,'猫洗澡',0,5,8,1,2.5,1),(134,1,'抑菌维稳定制洗护',208.00,NULL,'猫洗澡',0,5,8,1,2.5,1),(135,1,'定制造型',999.00,NULL,'猫美容',1,5,8,1,999.0,1),(136,1,'再生净化水疗SPA',178.00,NULL,'猫SPA',2,5,8,1,0.5,1),(137,1,'维稳焕肤镇静精华液',178.00,NULL,'猫SPA',2,5,8,1,0.5,1),(138,1,'抑菌修复水疗SPA',178.00,NULL,'猫SPA',2,5,8,1,0.5,1),(139,1,'亮泽垂顺发膜SPA',178.00,NULL,'猫SPA',2,5,8,1,0.5,1),(140,1,'修复还原水疗SPA',178.00,NULL,'猫SPA',2,5,8,1,0.5,1),(141,1,'普通清洁洗护',180.00,NULL,'猫洗澡',0,8,999,1,2.0,1),(142,1,'超白闪亮定制洗护',218.00,NULL,'猫洗澡',0,8,999,1,2.5,1),(143,1,'蓬松赛级定制洗护',218.00,NULL,'猫洗澡',0,8,999,1,2.5,1),(144,1,'控油焕肤定制洗护',238.00,NULL,'猫洗澡',0,8,999,1,2.5,1),(145,1,'清爽去屑定制洗护',218.00,NULL,'猫洗澡',0,8,999,1,2.5,1),(146,1,'低敏呵护定制洗护',218.00,NULL,'猫洗澡',0,8,999,1,2.5,1),(147,1,'深层补水定制洗护',218.00,NULL,'猫洗澡',0,8,999,1,2.5,1),(148,1,'抑菌维稳定制洗护',238.00,NULL,'猫洗澡',0,8,999,1,2.5,1),(149,1,'定制造型',999.00,NULL,'猫美容',1,8,999,1,999.0,1),(150,1,'再生净化水疗SPA',198.00,NULL,'猫SPA',2,8,999,1,0.5,1),(151,1,'维稳焕肤镇静精华液',198.00,NULL,'猫SPA',2,8,999,1,0.5,1),(152,1,'抑菌修复水疗SPA',198.00,NULL,'猫SPA',2,8,999,1,0.5,1),(153,1,'亮泽垂顺发膜SPA',198.00,NULL,'猫SPA',2,8,999,1,0.5,1),(154,1,'修复还原水疗SPA',198.00,NULL,'猫SPA',2,8,999,1,0.5,1),(155,1,'普通清洁洗护',90.00,NULL,'猫洗澡',0,0,2,1,1.0,0),(156,1,'超白闪亮定制洗护',138.00,NULL,'猫洗澡',0,0,2,1,1.5,0),(157,1,'蓬松赛级定制洗护',138.00,NULL,'猫洗澡',0,0,2,1,1.5,0),(158,1,'控油焕肤定制洗护',158.00,NULL,'猫洗澡',0,0,2,1,1.5,0),(159,1,'清爽去屑定制洗护',138.00,NULL,'猫洗澡',0,0,2,1,1.5,0),(160,1,'低敏呵护定制洗护',138.00,NULL,'猫洗澡',0,0,2,1,1.5,0),(161,1,'深层补水定制洗护',138.00,NULL,'猫洗澡',0,0,2,1,1.5,0),(162,1,'抑菌维稳定制洗护',158.00,NULL,'猫洗澡',0,0,2,1,1.5,0),(163,1,'定制造型',999.00,NULL,'猫美容',1,0,2,1,999.0,0),(164,1,'再生净化水疗SPA',118.00,NULL,'猫SPA',2,0,2,1,0.5,0),(165,1,'维稳焕肤镇静精华液',118.00,NULL,'猫SPA',2,0,2,1,0.5,0),(166,1,'抑菌修复水疗SPA',118.00,NULL,'猫SPA',2,0,2,1,0.5,0),(167,1,'亮泽垂顺发膜SPA',118.00,NULL,'猫SPA',2,0,2,1,0.5,0),(168,1,'修复还原水疗SPA',118.00,NULL,'猫SPA',2,0,2,1,0.5,0),(169,1,'普通清洁洗护',140.00,NULL,'猫洗澡',0,2,5,1,2.0,0),(170,1,'超白闪亮定制洗护',208.00,NULL,'猫洗澡',0,2,5,1,2.5,0),(171,1,'蓬松赛级定制洗护',208.00,NULL,'猫洗澡',0,2,5,1,2.5,0),(172,1,'控油焕肤定制洗护',228.00,NULL,'猫洗澡',0,2,5,1,2.5,0),(173,1,'清爽去屑定制洗护',208.00,NULL,'猫洗澡',0,2,5,1,2.5,0),(174,1,'低敏呵护定制洗护',208.00,NULL,'猫洗澡',0,2,5,1,2.5,0),(175,1,'深层补水定制洗护',208.00,NULL,'猫洗澡',0,2,5,1,2.5,0),(176,1,'抑菌维稳定制洗护',208.00,NULL,'猫洗澡',0,2,5,1,2.5,0),(177,1,'定制造型',999.00,NULL,'猫美容',1,2,5,1,999.0,0),(178,1,'再生净化水疗SPA',158.00,NULL,'猫SPA',2,2,5,1,0.5,0),(179,1,'维稳焕肤镇静精华液',158.00,NULL,'猫SPA',2,2,5,1,0.5,0),(180,1,'抑菌修复水疗SPA',158.00,NULL,'猫SPA',2,2,5,1,0.5,0),(181,1,'亮泽垂顺发膜SPA',158.00,NULL,'猫SPA',2,2,5,1,0.5,0),(182,1,'修复还原水疗SPA',158.00,NULL,'猫SPA',2,2,5,1,0.5,0),(183,1,'普通清洁洗护',180.00,NULL,'猫洗澡',0,5,8,1,2.0,0),(184,1,'超白闪亮定制洗护',258.00,NULL,'猫洗澡',0,5,8,1,2.5,0),(185,1,'蓬松赛级定制洗护',258.00,NULL,'猫洗澡',0,5,8,1,2.5,0),(186,1,'控油焕肤定制洗护',278.00,NULL,'猫洗澡',0,5,8,1,2.5,0),(187,1,'清爽去屑定制洗护',258.00,NULL,'猫洗澡',0,5,8,1,2.5,0),(188,1,'低敏呵护定制洗护',258.00,NULL,'猫洗澡',0,5,8,1,2.5,0),(189,1,'深层补水定制洗护',258.00,NULL,'猫洗澡',0,5,8,1,2.5,0),(190,1,'抑菌维稳定制洗护',278.00,NULL,'猫洗澡',0,5,8,1,2.5,0),(191,1,'定制造型',999.00,NULL,'猫美容',1,5,8,1,999.0,0),(192,1,'再生净化水疗SPA',178.00,NULL,'猫SPA',2,5,8,1,0.5,0),(193,1,'维稳焕肤镇静精华液',178.00,NULL,'猫SPA',2,5,8,1,0.5,0),(194,1,'抑菌修复水疗SPA',178.00,NULL,'猫SPA',2,5,8,1,0.5,0),(195,1,'亮泽垂顺发膜SPA',178.00,NULL,'猫SPA',2,5,8,1,0.5,0),(196,1,'修复还原水疗SPA',178.00,NULL,'猫SPA',2,5,8,1,0.5,0),(197,1,'普通清洁洗护',230.00,NULL,'猫洗澡',0,8,999,1,2.5,0),(198,1,'超白闪亮定制洗护',298.00,NULL,'猫洗澡',0,8,999,1,3.0,0),(199,1,'蓬松赛级定制洗护',298.00,NULL,'猫洗澡',0,8,999,1,3.0,0),(200,1,'控油焕肤定制洗护',318.00,NULL,'猫洗澡',0,8,999,1,3.0,0),(201,1,'清爽去屑定制洗护',298.00,NULL,'猫洗澡',0,8,999,1,3.0,0),(202,1,'低敏呵护定制洗护',298.00,NULL,'猫洗澡',0,8,999,1,3.0,0),(203,1,'深层补水定制洗护',298.00,NULL,'猫洗澡',0,8,999,1,3.0,0),(204,1,'抑菌维稳定制洗护',318.00,NULL,'猫洗澡',0,8,999,1,3.0,0),(205,1,'定制造型',999.00,NULL,'猫美容',1,8,999,1,999.0,0),(206,1,'再生净化水疗SPA',198.00,NULL,'猫SPA',2,8,999,1,0.5,0),(207,1,'维稳焕肤镇静精华液',198.00,NULL,'猫SPA',2,8,999,1,0.5,0),(208,1,'抑菌修复水疗SPA',198.00,NULL,'猫SPA',2,8,999,1,0.5,0),(209,1,'亮泽垂顺发膜SPA',198.00,NULL,'猫SPA',2,8,999,1,0.5,0),(210,1,'修复还原水疗SPA',198.00,NULL,'猫SPA',2,8,999,1,0.5,0);
/*!40000 ALTER TABLE `wash_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wash_item_room`
--

DROP TABLE IF EXISTS `wash_item_room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wash_item_room` (
  `id` int NOT NULL AUTO_INCREMENT,
  `shop_id` int DEFAULT NULL,
  `wash_item_id` int DEFAULT NULL,
  `wash_room_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=211 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='洗护项目关联洗护间';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wash_item_room`
--

LOCK TABLES `wash_item_room` WRITE;
/*!40000 ALTER TABLE `wash_item_room` DISABLE KEYS */;
INSERT INTO `wash_item_room` VALUES (1,1,1,1),(2,1,2,1),(3,1,3,1),(4,1,4,1),(5,1,5,1),(6,1,6,1),(7,1,7,1),(8,1,8,1),(9,1,9,1),(10,1,10,1),(11,1,11,1),(12,1,12,1),(13,1,13,1),(14,1,14,1),(15,1,15,1),(16,1,16,1),(17,1,17,1),(18,1,18,1),(19,1,19,1),(20,1,20,1),(21,1,21,1),(22,1,22,1),(23,1,23,1),(24,1,24,1),(25,1,25,1),(26,1,26,1),(27,1,27,1),(28,1,28,1),(29,1,29,1),(30,1,30,1),(31,1,31,1),(32,1,32,1),(33,1,33,1),(34,1,34,1),(35,1,35,1),(36,1,36,1),(37,1,37,1),(38,1,38,1),(39,1,39,1),(40,1,40,1),(41,1,41,1),(42,1,42,1),(43,1,43,1),(44,1,44,1),(45,1,45,1),(46,1,46,1),(47,1,47,1),(48,1,48,1),(49,1,49,1),(50,1,50,1),(51,1,51,1),(52,1,52,1),(53,1,53,1),(54,1,54,1),(55,1,55,1),(56,1,56,1),(57,1,57,1),(58,1,58,1),(59,1,59,1),(60,1,60,1),(61,1,61,1),(62,1,62,1),(63,1,63,1),(64,1,64,1),(65,1,65,1),(66,1,66,1),(67,1,67,1),(68,1,68,1),(69,1,69,1),(70,1,70,1),(71,1,71,1),(72,1,72,1),(73,1,73,1),(74,1,74,1),(75,1,75,1),(76,1,76,1),(77,1,77,1),(78,1,78,1),(79,1,79,1),(80,1,80,1),(81,1,81,1),(82,1,82,1),(83,1,83,1),(84,1,84,1),(85,1,85,1),(86,1,86,1),(87,1,87,1),(88,1,88,1),(89,1,89,1),(90,1,90,1),(91,1,91,1),(92,1,92,1),(93,1,93,1),(94,1,94,1),(95,1,95,1),(96,1,96,1),(97,1,97,1),(98,1,98,1),(99,1,99,1),(100,1,100,1),(101,1,101,1),(102,1,102,1),(103,1,103,1),(104,1,104,1),(105,1,105,1),(106,1,106,1),(107,1,107,1),(108,1,108,1),(109,1,109,1),(110,1,110,1),(111,1,111,1),(112,1,112,1),(113,1,113,1),(114,1,114,1),(115,1,115,1),(116,1,116,1),(117,1,117,1),(118,1,118,1),(119,1,119,1),(120,1,120,1),(121,1,121,1),(122,1,122,1),(123,1,123,1),(124,1,124,1),(125,1,125,1),(126,1,126,1),(127,1,127,1),(128,1,128,1),(129,1,129,1),(130,1,130,1),(131,1,131,1),(132,1,132,1),(133,1,133,1),(134,1,134,1),(135,1,135,1),(136,1,136,1),(137,1,137,1),(138,1,138,1),(139,1,139,1),(140,1,140,1),(141,1,141,1),(142,1,142,1),(143,1,143,1),(144,1,144,1),(145,1,145,1),(146,1,146,1),(147,1,147,1),(148,1,148,1),(149,1,149,1),(150,1,150,1),(151,1,151,1),(152,1,152,1),(153,1,153,1),(154,1,154,1),(155,1,155,1),(156,1,156,1),(157,1,157,1),(158,1,158,1),(159,1,159,1),(160,1,160,1),(161,1,161,1),(162,1,162,1),(163,1,163,1),(164,1,164,1),(165,1,165,1),(166,1,166,1),(167,1,167,1),(168,1,168,1),(169,1,169,1),(170,1,170,1),(171,1,171,1),(172,1,172,1),(173,1,173,1),(174,1,174,1),(175,1,175,1),(176,1,176,1),(177,1,177,1),(178,1,178,1),(179,1,179,1),(180,1,180,1),(181,1,181,1),(182,1,182,1),(183,1,183,1),(184,1,184,1),(185,1,185,1),(186,1,186,1),(187,1,187,1),(188,1,188,1),(189,1,189,1),(190,1,190,1),(191,1,191,1),(192,1,192,1),(193,1,193,1),(194,1,194,1),(195,1,195,1),(196,1,196,1),(197,1,197,1),(198,1,198,1),(199,1,199,1),(200,1,200,1),(201,1,201,1),(202,1,202,1),(203,1,203,1),(204,1,204,1),(205,1,205,1),(206,1,206,1),(207,1,207,1),(208,1,208,1),(209,1,209,1),(210,1,210,1);
/*!40000 ALTER TABLE `wash_item_room` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wash_order`
--

DROP TABLE IF EXISTS `wash_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wash_order` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_number` varchar(100) DEFAULT NULL,
  `shop_id` int DEFAULT NULL COMMENT '店铺id',
  `user_id` int DEFAULT NULL COMMENT '用户id',
  `wash_item_id` int DEFAULT NULL COMMENT '洗护项目id',
  `wash_room_id` int DEFAULT NULL COMMENT '洗护间id',
  `appointment_date` date DEFAULT NULL COMMENT '预约日期',
  `wash_slot_id` int DEFAULT NULL COMMENT '洗护预约时间',
  `start_time` time DEFAULT NULL COMMENT '预约开始时间',
  `end_time` time DEFAULT NULL COMMENT '预约结束时间',
  `price` decimal(10,2) DEFAULT NULL,
  `status` int DEFAULT NULL COMMENT '0-待付款，1-已支付待洗护，2-洗护中，3已完成，4已超时 5已取消',
  `admin_id` int DEFAULT NULL COMMENT '如果是管理员创建，记录管理员id',
  `is_vip` int DEFAULT NULL COMMENT '0-否 1-是',
  `address_id` int DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='洗护订单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wash_order`
--

LOCK TABLES `wash_order` WRITE;
/*!40000 ALTER TABLE `wash_order` DISABLE KEYS */;
INSERT INTO `wash_order` VALUES (1,'W20240705134822816',1,25,20,1,'2024-07-01',1,'09:00:00','10:00:00',98.00,1,NULL,1,NULL,'2024-07-01 08:30:00',NULL),(85,'W20240705134822817',1,25,21,1,'2024-07-05',17,'17:00:00','19:00:00',118.00,3,NULL,NULL,NULL,'2024-07-05 13:48:22','2024-07-08 17:46:15'),(86,'W20240712075401836',1,36,1,1,'2024-07-12',17,'17:00:00','18:00:00',34.00,3,NULL,NULL,NULL,'2024-07-12 07:54:01','2024-07-12 17:05:03'),(87,'W20240713134339929',1,28,3,1,'2024-07-13',12,'14:30:00','15:30:00',128.00,0,NULL,0,NULL,'2024-07-13 13:43:39',NULL),(88,'W20240804165437180',1,36,2,1,'2024-08-04',17,'17:00:00','18:00:00',55.00,1,NULL,1,NULL,'2024-08-04 16:54:38',NULL),(89,'W20240826225257674',1,27,19,1,'2024-08-27',5,'11:00:00','12:00:00',78.00,0,NULL,0,NULL,'2024-08-26 22:52:58',NULL),(90,'W20250306211553884',1,27,19,1,'2025-03-07',1,'09:00:00','10:00:00',78.00,0,NULL,0,NULL,'2025-03-06 21:15:53',NULL),(91,'W20250426202427495',1,25,197,1,'2025-04-27',1,'09:00:00','12:00:00',428.00,0,NULL,1,NULL,'2025-04-26 20:24:28',NULL),(92,'W20250426202506453',1,25,197,1,'2025-04-27',11,'14:00:00','17:00:00',428.00,0,NULL,1,NULL,'2025-04-26 20:25:06',NULL),(93,'W20250427180726043',1,75,197,1,'2025-04-27',24,'20:30:00','23:30:00',428.00,0,NULL,1,NULL,'2025-04-27 18:07:27',NULL),(94,'W20250427184236485',1,75,197,1,'2025-04-28',1,'09:00:00','12:00:00',428.00,0,NULL,1,NULL,'2025-04-27 18:42:37',NULL),(95,'W20250427190449445',1,75,200,1,'2025-04-28',7,'12:00:00','15:30:00',516.00,0,NULL,1,NULL,'2025-04-27 19:04:49',NULL),(96,'W20250427191141142',1,75,200,1,'2025-04-28',19,'18:00:00','21:30:00',516.00,0,NULL,1,NULL,'2025-04-27 19:11:42',NULL),(97,'W20250429101004158',1,75,197,1,'2025-04-30',1,'09:00:00','11:30:00',230.00,0,NULL,1,NULL,'2025-04-29 10:10:05',NULL),(98,'W20250429114305611',1,75,197,1,'2025-05-01',1,'09:00:00','11:30:00',230.00,0,NULL,1,NULL,'2025-04-29 11:43:06',NULL),(99,'W20250429114412811',1,75,197,1,'2025-05-02',1,'09:00:00','11:30:00',230.00,0,NULL,1,NULL,'2025-04-29 11:44:13',NULL),(100,'W20250429114443020',1,75,197,1,'2025-05-02',9,'13:00:00','15:30:00',230.00,0,NULL,1,NULL,'2025-04-29 11:44:43',NULL),(101,'W20250429114714628',1,75,197,1,'2025-05-03',1,'09:00:00','12:00:00',428.00,0,NULL,1,NULL,'2025-04-29 11:47:15',NULL),(102,'W20250429132210496',1,25,197,1,'2025-04-29',13,'15:00:00','18:00:00',428.00,0,NULL,1,NULL,'2025-04-29 13:22:11',NULL),(103,'W20250429155121582',1,75,197,1,'2025-05-05',1,'09:00:00','12:00:00',428.00,0,NULL,1,0,'2025-04-29 15:51:21',NULL),(104,'W20250429155223496',1,75,197,1,'2025-05-02',23,'20:00:00','23:00:00',428.00,0,NULL,1,0,'2025-04-29 15:52:23',NULL),(105,'W20250429155351506',1,25,197,1,'2025-04-29',23,'20:00:00','23:00:00',428.00,0,NULL,1,0,'2025-04-29 15:53:52',NULL),(106,'W20250429155804181',1,25,197,1,'2025-04-30',11,'14:00:00','17:00:00',428.00,0,NULL,1,0,'2025-04-29 15:58:05',NULL),(107,'W20250429155831868',1,25,199,1,'2025-04-30',1,'09:00:00','12:30:00',496.00,0,NULL,1,0,'2025-04-29 15:58:32',NULL),(108,'W20250429160423992',1,75,197,1,'2025-04-30',24,'20:30:00','23:30:00',428.00,0,NULL,1,0,'2025-04-29 16:04:23',NULL),(109,'W20250429160539092',1,75,204,1,'2025-05-03',7,'12:00:00','15:30:00',516.00,0,NULL,1,0,'2025-04-29 16:05:40',NULL),(110,'W20250429161224600',1,75,197,1,'2025-05-02',14,'15:30:00','18:30:00',428.00,0,NULL,1,0,'2025-04-29 16:12:25',NULL),(111,'W20250429161555811',1,75,197,1,'2025-05-01',12,'14:30:00','17:30:00',428.00,0,NULL,1,0,'2025-04-29 16:15:56',NULL),(112,'W20250429161717827',1,75,197,1,'2025-05-01',18,'17:30:00','20:30:00',428.00,0,NULL,1,0,'2025-04-29 16:17:17',NULL),(113,'W20250429162216908',1,75,204,1,'2025-05-04',7,'12:00:00','15:30:00',516.00,1,NULL,1,0,'2025-04-29 16:22:17',NULL),(114,'W20250429163110749',1,75,204,1,'2025-05-04',14,'15:30:00','19:00:00',516.00,1,NULL,1,7,'2025-04-29 16:31:11',NULL),(115,'W20250510191012417',1,75,197,1,'2025-05-14',1,'09:00:00','12:00:00',428.00,1,NULL,1,0,'2025-05-10 19:10:13',NULL),(116,'W20250510191235122',1,75,197,1,'2025-05-14',11,'14:00:00','17:00:00',428.00,1,NULL,1,0,'2025-05-10 19:12:35',NULL),(117,'W20250512161237910',1,25,197,1,'2025-05-12',19,'18:00:00','21:00:00',428.00,1,NULL,1,0,'2025-05-12 16:12:37',NULL),(118,'W20250515174657020',1,76,29,1,'2025-05-16',1,'09:00:00','10:00:00',80.00,0,NULL,0,0,'2025-05-15 17:46:57',NULL),(119,'W20250515174721294',1,76,29,1,'2025-05-16',7,'12:00:00','13:00:00',80.00,0,NULL,0,0,'2025-05-15 17:47:22',NULL),(120,'W20250515175536330',1,77,15,1,'2025-05-16',15,'16:00:00','18:30:00',128.00,0,NULL,0,0,'2025-05-15 17:55:36',NULL),(121,'W20250515175725493',1,77,15,1,'2025-05-16',5,'11:00:00','13:30:00',128.00,1,NULL,1,0,'2025-05-15 17:57:25',NULL),(122,'W20250515182311707',1,25,197,1,'2025-05-15',21,'19:00:00','21:30:00',230.00,0,NULL,1,0,'2025-05-15 18:23:11',NULL),(123,'W20250516195606478',1,79,43,1,'2025-05-17',1,'09:00:00','10:00:00',110.00,1,NULL,1,0,'2025-05-16 19:56:07',NULL);
/*!40000 ALTER TABLE `wash_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wash_order_items`
--

DROP TABLE IF EXISTS `wash_order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wash_order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL COMMENT '洗护订单id',
  `wash_item_id` int DEFAULT NULL COMMENT '洗护项目id',
  `item_type` int DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `description` text,
  `fur` int DEFAULT NULL,
  `category` int DEFAULT NULL,
  `time` decimal(10,1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='洗护订单关联项目';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wash_order_items`
--

LOCK TABLES `wash_order_items` WRITE;
/*!40000 ALTER TABLE `wash_order_items` DISABLE KEYS */;
INSERT INTO `wash_order_items` VALUES (78,85,21,0,118.00,'洗澡','猫洗澡',0,1,2.0),(79,86,1,0,48.00,'洗护','狗洗澡',0,0,0.5),(80,87,3,0,128.00,'洗护','狗洗澡',0,0,1.0),(81,88,2,0,78.00,'洗护','狗洗澡',0,0,1.0),(82,89,19,0,78.00,'洗澡','猫洗澡',0,1,1.0),(83,90,19,0,78.00,'洗澡','猫洗澡',0,1,1.0),(84,91,197,0,230.00,'普通清洁洗护','猫洗澡',0,1,2.5),(85,92,197,0,230.00,'普通清洁洗护','猫洗澡',0,1,2.5),(86,93,197,0,230.00,'普通清洁洗护','猫洗澡',0,1,2.5),(87,94,197,0,230.00,'普通清洁洗护','猫洗澡',0,1,2.5),(88,95,200,0,318.00,'控油焕肤定制洗护','猫洗澡',0,1,3.0),(89,96,200,0,318.00,'控油焕肤定制洗护','猫洗澡',0,1,3.0),(90,97,197,0,230.00,'普通清洁洗护','猫洗澡',0,1,2.5),(91,98,197,0,230.00,'普通清洁洗护','猫洗澡',0,1,2.5),(92,99,197,0,230.00,'普通清洁洗护','猫洗澡',0,1,2.5),(93,100,197,0,230.00,'普通清洁洗护','猫洗澡',0,1,2.5),(94,101,197,0,230.00,'普通清洁洗护','猫洗澡',0,1,2.5),(95,102,197,0,230.00,'普通清洁洗护','猫洗澡',0,1,2.5),(96,103,197,0,230.00,'普通清洁洗护','猫洗澡',0,1,2.5),(97,104,197,0,230.00,'普通清洁洗护','猫洗澡',0,1,2.5),(98,105,197,0,230.00,'普通清洁洗护','猫洗澡',0,1,2.5),(99,106,197,0,230.00,'普通清洁洗护','猫洗澡',0,1,2.5),(100,107,199,0,298.00,'蓬松赛级定制洗护','猫洗澡',0,1,3.0),(101,108,197,0,230.00,'普通清洁洗护','猫洗澡',0,1,2.5),(102,109,204,0,318.00,'抑菌维稳定制洗护','猫洗澡',0,1,3.0),(103,110,197,0,230.00,'普通清洁洗护','猫洗澡',0,1,2.5),(104,111,197,0,230.00,'普通清洁洗护','猫洗澡',0,1,2.5),(105,112,197,0,230.00,'普通清洁洗护','猫洗澡',0,1,2.5),(106,113,204,0,318.00,'抑菌维稳定制洗护','猫洗澡',0,1,3.0),(107,114,204,0,318.00,'抑菌维稳定制洗护','猫洗澡',0,1,3.0),(108,115,197,0,230.00,'普通清洁洗护','猫洗澡',0,1,2.5),(109,116,197,0,230.00,'普通清洁洗护','猫洗澡',0,1,2.5),(110,117,197,0,230.00,'普通清洁洗护','猫洗澡',0,1,2.5),(111,118,29,0,80.00,'普通清洁洗护','狗洗澡',0,0,1.0),(112,119,29,0,80.00,'普通清洁洗护','狗洗澡',0,0,1.0),(113,120,15,0,60.00,'普通清洁洗护','狗洗澡',0,0,1.0),(114,121,15,0,60.00,'普通清洁洗护','狗洗澡',0,0,1.0),(115,122,197,0,230.00,'普通清洁洗护','猫洗澡',0,1,2.5),(116,123,43,0,110.00,'普通清洁洗护','狗洗澡',0,0,1.0);
/*!40000 ALTER TABLE `wash_order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wash_order_pet`
--

DROP TABLE IF EXISTS `wash_order_pet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wash_order_pet` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pet_id` int DEFAULT NULL COMMENT '宠物id',
  `order_id` int DEFAULT NULL COMMENT '订单id',
  `gender` int DEFAULT NULL COMMENT '0 公 1 母',
  `category_id` int DEFAULT NULL COMMENT '0 狗狗 1 猫猫',
  `avatar` text COMMENT '宠物头像',
  `name` varchar(100) DEFAULT NULL,
  `weight` decimal(5,1) DEFAULT NULL COMMENT '体重',
  `birthday` date DEFAULT NULL COMMENT '生日',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='洗护订单关联宠物';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wash_order_pet`
--

LOCK TABLES `wash_order_pet` WRITE;
/*!40000 ALTER TABLE `wash_order_pet` DISABLE KEYS */;
INSERT INTO `wash_order_pet` VALUES (1,32,1,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240705132052118.jpg','辛巴',3.0,'2024-04-01'),(79,16,85,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(80,36,86,0,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240709165824324.jpg','帕帕',5.0,NULL),(81,39,87,0,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240713134302719.jpg','小黑',10.0,'2023-07-13'),(82,36,88,0,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240709165824324.jpg','帕帕',5.5,NULL),(83,43,89,1,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240713201234323.jpg','panda',1.8,'2024-04-01'),(84,43,90,1,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240713201234323.jpg','panda',1.8,'2024-04-01'),(85,16,91,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(86,16,92,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(87,16,93,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(88,16,94,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(89,16,95,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(90,16,96,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(91,16,97,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(92,16,98,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(93,16,99,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(94,16,100,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(95,16,101,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(96,16,102,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(97,16,103,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(98,16,104,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(99,16,105,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(100,16,106,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(101,16,107,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(102,16,108,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(103,16,109,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(104,16,110,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(105,16,111,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(106,16,112,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(107,16,113,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(108,16,114,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(109,16,115,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(110,16,116,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(111,16,117,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(112,48,118,0,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20250515174554231.jpg','咪咔',7.5,'2016-10-19'),(113,48,119,0,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20250515174554231.jpg','咪咔',7.5,'2016-10-19'),(114,49,120,0,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20250515175456474.jpg','糯米',5.2,'2024-12-15'),(115,49,121,0,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20250515175456474.jpg','糯米',5.2,'2024-12-15'),(116,16,122,0,1,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20240607104432593.png','小咪',10.0,'1999-06-17'),(117,51,123,1,0,'https://yypet-pictures.obs.cn-east-3.myhuaweicloud.com:443/20250516195513702.jpg','富贵',15.3,'2024-07-13');
/*!40000 ALTER TABLE `wash_order_pet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wash_room`
--

DROP TABLE IF EXISTS `wash_room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wash_room` (
  `id` int NOT NULL AUTO_INCREMENT,
  `shop_id` int DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `type` int DEFAULT NULL COMMENT '0 洗护 1 洗护+美容',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='洗护间';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wash_room`
--

LOCK TABLES `wash_room` WRITE;
/*!40000 ALTER TABLE `wash_room` DISABLE KEYS */;
INSERT INTO `wash_room` VALUES (1,1,'美容室',1);
/*!40000 ALTER TABLE `wash_room` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wash_slot`
--

DROP TABLE IF EXISTS `wash_slot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wash_slot` (
  `id` int NOT NULL AUTO_INCREMENT,
  `shop_id` int DEFAULT NULL,
  `start_time` time DEFAULT NULL COMMENT '开始时间',
  `active` int DEFAULT NULL COMMENT '是否激活 0-激活 1-没有',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='洗护预约时间';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wash_slot`
--

LOCK TABLES `wash_slot` WRITE;
/*!40000 ALTER TABLE `wash_slot` DISABLE KEYS */;
INSERT INTO `wash_slot` VALUES (1,NULL,'09:00:00',NULL,'2024-05-26 16:04:05',NULL),(2,NULL,'09:30:00',NULL,'2024-05-26 16:05:31',NULL),(3,NULL,'10:00:00',NULL,'2024-06-13 16:41:29',NULL),(4,NULL,'10:30:00',NULL,'2024-06-13 16:41:54',NULL),(5,NULL,'11:00:00',NULL,'2024-06-01 16:05:47',NULL),(6,NULL,'11:30:00',NULL,'2024-06-01 16:06:01',NULL),(7,NULL,'12:00:00',NULL,'2024-06-01 16:06:14',NULL),(8,NULL,'12:30:00',NULL,'2024-06-01 16:07:56',NULL),(9,NULL,'13:00:00',NULL,'2024-06-13 16:44:59',NULL),(10,NULL,'13:30:00',NULL,'2024-06-13 16:45:18',NULL),(11,NULL,'14:00:00',NULL,'2024-06-13 16:45:31',NULL),(12,NULL,'14:30:00',NULL,'2024-06-13 16:45:44',NULL),(13,NULL,'15:00:00',NULL,'2024-06-13 16:46:00',NULL),(14,NULL,'15:30:00',NULL,'2024-06-13 16:46:26',NULL),(15,NULL,'16:00:00',NULL,'2024-06-13 16:46:41',NULL),(16,NULL,'16:30:00',NULL,'2024-06-13 16:46:54',NULL),(17,NULL,'17:00:00',NULL,'2024-06-13 16:47:08',NULL),(18,NULL,'17:30:00',NULL,'2024-06-13 16:47:22',NULL),(19,NULL,'18:00:00',NULL,'2024-06-13 16:48:07',NULL),(20,NULL,'18:30:00',NULL,'2024-06-13 16:48:25',NULL),(21,NULL,'19:00:00',NULL,'2024-06-13 16:48:40',NULL),(22,NULL,'19:30:00',NULL,'2024-06-13 16:50:27',NULL),(23,NULL,'20:00:00',NULL,'2024-06-13 16:50:41',NULL),(24,NULL,'20:30:00',NULL,'2024-06-13 16:50:53',NULL);
/*!40000 ALTER TABLE `wash_slot` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-30 20:49:13
