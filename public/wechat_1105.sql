-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: ????    Database: wechat
-- ------------------------------------------------------
-- Server version	5.7.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups` (
  `group_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_name` varchar(255) NOT NULL,
  `group_avatar` varchar(255) DEFAULT 'http://sugarblack.top/img/qr.png',
  `creator_id` int(12) NOT NULL,
  `create_at` datetime NOT NULL,
  `multi` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`group_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
INSERT INTO `groups` VALUES (15,'1728804850','http://sugarblack.top/img/qr.png',13,'2024-10-13 15:34:10',0),(18,'1728822221','http://sugarblack.top/img/qr.png',13,'2024-10-13 20:23:41',0),(19,'1728822233','http://sugarblack.top/img/qr.png',13,'2024-10-13 20:23:54',0),(21,'1728822971','http://sugarblack.top/img/qr.png',13,'2024-10-13 20:36:12',0),(25,'test','http://sugarblack.top/img/qr.png',13,'2024-10-13 20:42:25',1),(26,'test','http://sugarblack.top/img/qr.png',13,'2024-10-13 20:43:13',1),(27,'test','http://sugarblack.top/img/qr.png',13,'2024-10-13 20:45:32',1),(49,'1729346764','http://sugarblack.top/img/qr.png',13,'2024-10-19 22:06:04',0),(50,'1730267616','http://sugarblack.top/img/qr.png',13,'2024-10-30 13:53:36',0),(51,'1730267634','http://sugarblack.top/img/qr.png',13,'2024-10-30 13:53:54',0),(53,'1730270554','http://sugarblack.top/img/qr.png',15,'2024-10-30 14:42:34',0),(54,'拿下诺贝尔','http://sugarblack.top/img/qr.png',13,'2024-10-30 17:21:08',1),(55,'1730372204','http://sugarblack.top/img/qr.png',13,'2024-10-31 18:56:45',0),(56,'ddddd','http://sugarblack.top/img/qr.png',13,'2024-10-31 18:57:38',1),(57,'下次一定','http://sugarblack.top/img/qr.png',13,'2024-10-31 20:48:38',1),(58,'22221','http://sugarblack.top/img/qr.png',13,'2024-10-31 20:52:17',1),(59,'1255555','http://sugarblack.top/img/qr.png',13,'2024-10-31 20:54:57',1),(61,'qqq','http://sugarblack.top/img/qr.png',13,'2024-11-02 11:56:13',1);
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `messages` (
  `mid` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `content` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `send_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`mid`) USING BTREE,
  KEY `user_id` (`uid`) USING BTREE,
  KEY `group_id` (`group_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=493 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (314,13,7,'八嘎呀路！','2024-11-01 11:43:20'),(315,13,12,'hhel~\n','2024-11-02 10:40:03'),(316,13,7,' i love u\n','2024-11-02 11:21:52'),(317,13,7,'1111\n','2024-11-02 11:28:18'),(318,13,7,'111122\n','2024-11-02 11:30:13'),(319,13,1,'nihao ','2024-11-02 12:49:11'),(320,13,0,'112121','2024-11-02 23:14:28'),(321,13,0,'12121','2024-11-02 23:15:24'),(322,13,0,'2121','2024-11-02 23:15:30'),(323,13,0,'212121','2024-11-02 23:16:06'),(324,13,12,'2121','2024-11-02 23:16:31'),(325,13,25,'2121','2024-11-02 23:18:04'),(326,13,61,'武切维奇','2024-11-02 23:22:37'),(327,8,60,'2121','2024-11-02 23:24:54'),(328,13,60,'2121','2024-11-02 23:25:08'),(329,13,60,'2121','2024-11-02 23:28:02'),(330,13,60,'23232','2024-11-02 23:28:08'),(331,13,8,'2121','2024-11-02 23:28:15'),(332,8,13,'2121','2024-11-02 23:28:27'),(333,13,8,'21','2024-11-02 23:28:35'),(334,13,8,'电动蝶阀','2024-11-02 23:28:48'),(335,13,8,'但是但是多所多所多所','2024-11-02 23:29:11'),(336,13,8,'212121','2024-11-02 23:29:22'),(337,13,25,'121312','2024-11-03 15:57:54'),(338,13,25,'我去恶趣味\n','2024-11-03 15:58:33'),(339,7,61,'21312312','2024-11-03 16:01:39'),(340,7,61,'恶趣味去\n','2024-11-03 16:01:46'),(341,7,61,'3213123 \n','2024-11-03 16:02:09'),(342,13,8,'我去恶趣味\n','2024-11-03 16:02:23'),(343,7,13,'额为全额\n','2024-11-03 16:02:45'),(344,13,8,'撒大苏打\n','2024-11-03 16:03:13'),(345,7,13,'撒旦撒\n','2024-11-03 16:03:16'),(346,13,61,'我去恶趣味\n','2024-11-03 16:04:40'),(347,13,61,'发额青蛙\n','2024-11-03 16:04:55'),(348,8,0,'我去恶趣味','2024-11-03 16:10:57'),(349,8,0,'十大\n','2024-11-03 16:11:09'),(350,13,0,'sadasd \n\\','2024-11-03 16:11:12'),(351,13,0,'\n','2024-11-03 16:11:12'),(352,13,0,'asSA \n','2024-11-03 16:11:33'),(353,13,0,'ds \n','2024-11-03 16:11:51'),(354,13,0,'rewr ewfdsfdsfdsfdsfdsfdsfwefewfwf\n','2024-11-03 16:11:56'),(355,8,0,'a ?\n','2024-11-03 16:13:37'),(356,13,8,'但是但是多','2024-11-03 22:27:15'),(357,13,8,'颠三倒四','2024-11-03 22:27:18'),(358,13,8,'颠三倒四 ','2024-11-03 22:27:23'),(359,8,13,'2121','2024-11-03 22:27:54'),(360,13,8,'但是但是多所vfgf','2024-11-03 22:28:11'),(361,8,13,'所思多死所','2024-11-03 22:28:25'),(362,13,8,'的地位反而','2024-11-03 22:28:28'),(363,13,8,'DASDAS\n','2024-11-03 22:34:03'),(364,13,8,'DASDAS \n','2024-11-03 22:34:14'),(365,8,13,'DCADSD A\n','2024-11-03 22:34:47'),(366,8,13,'212121','2024-11-03 22:36:48'),(367,13,0,'WAQSDSAD \n','2024-11-03 22:41:13'),(368,8,13,'大撒大撒\n','2024-11-03 22:43:45'),(369,13,61,'实打实打算\n','2024-11-03 22:45:25'),(370,13,61,'大撒大撒','2024-11-03 22:45:53'),(371,8,61,'大撒大撒','2024-11-03 22:45:57'),(372,8,61,'大撒大撒\n','2024-11-03 22:48:31'),(373,13,61,'大苏打','2024-11-03 22:56:38'),(374,13,8,'我去恶趣味','2024-11-03 22:57:39'),(375,13,8,'大撒大撒','2024-11-03 22:59:57'),(376,13,8,'大撒大撒','2024-11-03 23:00:12'),(377,13,8,'撒大苏打','2024-11-03 23:00:32'),(378,13,8,'的撒大','2024-11-03 23:00:51'),(379,8,13,'sdsad ','2024-11-03 23:01:02'),(380,8,13,'123','2024-11-03 23:02:19'),(381,8,13,'123123','2024-11-03 23:02:36'),(382,8,13,'sss\n','2024-11-03 23:03:00'),(383,13,8,'你好\n','2024-11-03 23:04:27'),(384,13,8,'test\n','2024-11-03 23:07:03'),(385,13,8,'test\n','2024-11-03 23:07:38'),(386,13,8,'12133\n','2024-11-03 23:12:20'),(387,13,8,'1313131313','2024-11-03 23:16:21'),(388,8,13,'88888888','2024-11-03 23:16:31'),(389,13,8,'212121','2024-11-03 23:18:07'),(390,13,8,'sdasd','2024-11-03 23:26:00'),(391,13,8,'dsadasd','2024-11-03 23:26:12'),(392,13,8,'ddd\n','2024-11-03 23:32:21'),(393,13,8,'通融通融\n','2024-11-03 23:32:26'),(394,13,8,'11','2024-11-03 23:33:05'),(395,13,8,'大撒大撒','2024-11-03 23:35:49'),(396,13,8,'认为人情味','2024-11-03 23:38:44'),(397,8,61,'dsadas','2024-11-03 23:39:36'),(398,8,61,'dasdasdasdwqdqwd','2024-11-03 23:42:02'),(399,13,61,'大撒大撒','2024-11-03 23:42:48'),(400,13,61,'大撒大撒大撒','2024-11-03 23:44:50'),(401,13,61,'大撒大撒好好好','2024-11-03 23:45:55'),(402,8,61,'ttttttttt','2024-11-03 23:46:06'),(403,13,61,'瑞特瑞特与他如有','2024-11-03 23:46:34'),(404,13,8,'反对反对反对','2024-11-03 23:47:09'),(405,13,8,'通融通融通融','2024-11-03 23:49:24'),(406,13,8,'哈哈哈哈哈哈哈哈哈','2024-11-03 23:58:08'),(407,13,61,'iiiiiiiiiiiiiiiii','2024-11-03 23:58:20'),(408,8,13,'2121','2024-11-04 10:06:36'),(409,8,13,'2121','2024-11-04 10:23:49'),(410,13,8,'发发发发发发付付付','2024-11-04 10:24:15'),(411,8,13,'热热热热热若','2024-11-04 10:24:22'),(412,8,13,'灌灌灌灌','2024-11-04 10:24:45'),(413,8,13,'vvvaasa\n','2024-11-04 10:25:21'),(414,8,13,'发发发','2024-11-04 10:41:44'),(415,8,13,'fffrrrrr','2024-11-04 10:43:58'),(416,8,13,'rrrfefeDSD\n','2024-11-04 10:44:07'),(417,13,8,'DSDSDS','2024-11-04 10:44:12'),(418,8,13,'热热热热热若\n','2024-11-04 10:47:01'),(419,8,13,'dsds','2024-11-04 10:47:33'),(420,8,7,'1111\n','2024-11-04 10:47:42'),(421,8,13,'1111\n','2024-11-04 10:47:45'),(422,8,13,'dsds','2024-11-04 10:48:04'),(423,8,13,'dddd','2024-11-04 10:48:16'),(424,8,13,'tere','2024-11-04 10:48:49'),(425,8,13,'rrr','2024-11-04 10:49:05'),(426,8,13,'发得发得','2024-11-04 10:50:58'),(427,8,13,'俄文翁无','2024-11-04 10:51:02'),(428,8,13,'热热热','2024-11-04 10:51:07'),(429,13,8,'颠三倒四','2024-11-04 10:57:46'),(430,13,8,'你好你好哈哈哈\n','2024-11-04 11:04:09'),(431,13,8,'好耶！\n','2024-11-04 11:04:22'),(432,13,8,'干翻腾讯！\n???????????????','2024-11-04 11:04:48'),(433,8,13,'我支持你！\n','2024-11-04 11:04:59'),(434,13,8,'干翻腾讯！\n???????????????\n','2024-11-04 11:05:10'),(435,8,13,'干翻腾讯！\n???????????????\n','2024-11-04 11:05:13'),(436,13,8,'武切维奇','2024-11-04 22:35:56'),(437,13,61,'才不是平的呢\n','2024-11-04 23:03:55'),(438,13,8,'法国发过黄精环境看','2024-11-04 23:09:44'),(439,13,8,'当时的是多少大V发v','2024-11-04 23:09:55'),(440,13,59,'2121212121当时的','2024-11-04 23:10:20'),(441,8,61,'地大物阜','2024-11-04 23:11:11'),(442,8,61,'呃呃呃呃呃','2024-11-04 23:11:36'),(443,8,61,'耳热','2024-11-04 23:12:50'),(444,13,61,'尔尔','2024-11-04 23:12:56'),(445,8,61,'颠三倒四','2024-11-04 23:13:17'),(446,13,61,'诶诶诶多','2024-11-04 23:13:25'),(447,13,61,'颠三倒四','2024-11-04 23:13:39'),(448,8,61,'但是但是若若拖群群群群群群群群','2024-11-04 23:13:47'),(449,8,61,'我我我我我我','2024-11-04 23:13:57'),(450,13,61,'我我我我我我','2024-11-04 23:14:00'),(451,13,61,'热热热热热若','2024-11-04 23:14:11'),(452,13,61,'发发发发发发付','2024-11-04 23:14:16'),(453,8,61,'俄文无','2024-11-04 23:14:47'),(454,8,61,'212121','2024-11-04 23:18:04'),(455,13,61,'4434343','2024-11-04 23:18:30'),(456,8,61,'7676767','2024-11-04 23:20:25'),(457,8,61,'热热','2024-11-04 23:21:01'),(458,8,61,'发得发得','2024-11-04 23:21:12'),(459,8,61,'得的','2024-11-04 23:22:14'),(460,8,0,'突然踢人踢人','2024-11-04 23:22:57'),(461,8,61,'热热热','2024-11-04 23:23:04'),(462,8,13,'发发发发发发','2024-11-04 23:25:10'),(463,8,61,'德尔的','2024-11-04 23:25:55'),(464,8,13,'热热热','2024-11-04 23:35:51'),(465,13,8,'但是但是所多','2024-11-04 23:35:57'),(466,8,61,'热热热热对的对的','2024-11-04 23:37:14'),(467,13,61,'辅导费到访到访的','2024-11-04 23:38:29'),(468,13,0,'热热\n','2024-11-05 09:59:04'),(469,13,0,'夫人夫人\n','2024-11-05 09:59:14'),(470,8,0,'212121','2024-11-05 13:33:40'),(471,13,0,'212121','2024-11-05 13:34:02'),(472,8,0,'767676','2024-11-05 13:34:47'),(473,8,0,'rerererett','2024-11-05 13:35:17'),(474,8,0,'ewewewew','2024-11-05 13:37:16'),(475,13,0,'dsdsdsfrfrfr','2024-11-05 13:38:47'),(476,8,0,'dsdsds','2024-11-05 13:39:27'),(477,8,61,'212132324343','2024-11-05 13:41:21'),(478,13,0,'dsdsds','2024-11-05 13:41:53'),(479,13,61,'dsdsfdfd','2024-11-05 13:41:59'),(480,8,61,'gffgfgfg','2024-11-05 13:42:06'),(481,8,61,'212121','2024-11-05 13:55:24'),(482,13,61,'颠三倒四','2024-11-05 14:02:11'),(483,8,61,'踢人踢人她让她','2024-11-05 14:02:25'),(484,13,61,'夫人夫人 ','2024-11-05 14:03:44'),(485,8,61,'2121323232大赛','2024-11-05 14:05:28'),(486,13,61,'得的','2024-11-05 14:06:52'),(487,8,13,'喔喔喔我才对才对','2024-11-05 14:07:09'),(488,13,8,'你好\n','2024-11-05 14:07:23'),(489,8,61,'得的','2024-11-05 14:09:04'),(490,13,61,'发发发发发发付付付付付付\n','2024-11-05 14:10:35'),(491,13,61,'咕咕咕咕咕咕过过过过过过\n','2024-11-05 14:10:57'),(492,7,61,'gggggggggggggggggg\n','2024-11-05 14:11:13');
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;

--
-- Table structure for table `relationships`
--

DROP TABLE IF EXISTS `relationships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `relationships` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `group_id` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `nickname` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'http://sugarblack.top/img/qr.png',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relationships`
--

/*!40000 ALTER TABLE `relationships` DISABLE KEYS */;
INSERT INTO `relationships` VALUES (29,15,12,NULL,'http://sugarblack.top/img/qr.png'),(30,15,13,NULL,'http://sugarblack.top/img/qr.png'),(31,15,14,NULL,'http://sugarblack.top/img/qr.png'),(34,15,16,'3049','http://sugarblack.top/img/qr.png'),(40,18,12,'1114','http://sugarblack.top/img/qr.png'),(41,18,14,'1114','http://sugarblack.top/img/qr.png'),(42,18,13,'3049','http://sugarblack.top/img/qr.png'),(43,18,12,'1114','http://sugarblack.top/img/qr.png'),(110,49,13,'user13','http://sugarblack.top/img/qr.png'),(111,49,8,'user8','http://sugarblack.top/img/qr.png'),(112,50,13,'user13','http://sugarblack.top/img/qr.png'),(113,50,7,'user7','http://sugarblack.top/img/qr.png'),(114,51,13,'user13','http://sugarblack.top/img/qr.png'),(115,51,12,'user12','http://sugarblack.top/img/qr.png'),(118,53,15,'user15','http://sugarblack.top/img/qr.png'),(119,53,8,'user8','http://sugarblack.top/img/qr.png'),(120,54,8,'user8','http://sugarblack.top/img/qr.png'),(121,54,7,'user7','http://sugarblack.top/img/qr.png'),(122,25,13,'test','http://sugarblack.top/img/qr.png'),(123,55,13,'user13','http://sugarblack.top/img/qr.png'),(124,55,1,'sdsdsd','http://sugarblack.top/img/qr.png'),(125,56,8,'user8','http://sugarblack.top/img/qr.png'),(126,56,12,'user12','http://sugarblack.top/img/qr.png'),(127,56,1,'sdsdsd','http://sugarblack.top/img/qr.png'),(128,57,8,'user8','http://sugarblack.top/img/qr.png'),(129,57,7,'user7','http://sugarblack.top/img/qr.png'),(130,57,12,'user12','http://sugarblack.top/img/qr.png'),(131,58,8,'user8','http://sugarblack.top/img/qr.png'),(132,58,7,'user7','http://sugarblack.top/img/qr.png'),(133,58,12,'user12','http://sugarblack.top/img/qr.png'),(134,59,7,'user7','http://sugarblack.top/img/qr.png'),(135,59,8,'user8','http://sugarblack.top/img/qr.png'),(136,59,12,'user12','http://sugarblack.top/img/qr.png'),(137,59,13,'user13','http://sugarblack.top/img/qr.png'),(141,61,8,'user8','http://sugarblack.top/img/qr.png'),(142,61,7,'user7','http://sugarblack.top/img/qr.png'),(143,61,13,'user13','http://sugarblack.top/img/qr.png');
/*!40000 ALTER TABLE `relationships` ENABLE KEYS */;

--
-- Table structure for table `temp`
--

DROP TABLE IF EXISTS `temp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temp` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '注册邮箱',
  `code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temp`
--

/*!40000 ALTER TABLE `temp` DISABLE KEYS */;
INSERT INTO `temp` VALUES (1,'11111@qq.com','81479'),(2,'11141@qq.com','11111'),(3,'3049788545@qq.com','69158'),(4,'2424203450@qq.com','95408');
/*!40000 ALTER TABLE `temp` ENABLE KEYS */;

--
-- Table structure for table `test`
--

DROP TABLE IF EXISTS `test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test` (
  `group_id` int(11) NOT NULL,
  `group_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `group_avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `creator_id` int(11) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `multi` int(11) DEFAULT NULL,
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test`
--

/*!40000 ALTER TABLE `test` DISABLE KEYS */;
INSERT INTO `test` VALUES (51,'test','test',1,'2024-10-30 22:09:08',1);
/*!40000 ALTER TABLE `test` ENABLE KEYS */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nickname` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'http://sugarblack.top/img/qr.png',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '未设置',
  `sign` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '未设置',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'12345@qq.com','12345@qq.com','sdsdsd','http://sugarblack.top/img/1.png','2024-10-13 13:43:38','111','renshng'),(7,'11311@qq.com','11311@qq.com','user7','http://sugarblack.top/img/2.png','2024-10-12 04:09:08','222','wobuai'),(8,'1113111@qq.com','1113111@qq.com','user8','http://sugarblack.top/img/3.png','2024-10-12 04:22:51','333','woxiangni'),(12,'11141@qq.com','11141@qq.com','user12','http://sugarblack.top/img/4.png','2024-10-13 03:01:18','444','来吧'),(13,'3049788545@qq.com','3049788545@qq.com','user13','http://sugarblack.top/img/favicon.jpg','2024-10-13 03:05:26','555','55'),(14,'11322111@qq.com','11322111@qq.com','user14','http://sugarblack.top/img/5.png','2024-10-12 04:04:43','666','sicnu'),(15,'2424203450@qq.com','111111ls','user15','http://sugarblack.top/img/qr.png','2024-10-30 06:36:30','未设置','未设置');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;

--
-- Dumping routines for database 'wechat'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-05 23:46:07
