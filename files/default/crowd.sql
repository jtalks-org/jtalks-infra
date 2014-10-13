-- MySQL dump 10.13  Distrib 5.5.35, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: crowd
-- ------------------------------------------------------
-- Server version       5.5.35-1ubuntu1

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
-- Table structure for table `cwd_app_dir_group_mapping`
--

DROP TABLE IF EXISTS `cwd_app_dir_group_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cwd_app_dir_group_mapping` (
  `id` bigint(20) NOT NULL,
  `app_dir_mapping_id` bigint(20) NOT NULL,
  `application_id` bigint(20) NOT NULL,
  `directory_id` bigint(20) NOT NULL,
  `group_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_dir_mapping_id` (`app_dir_mapping_id`,`group_name`),
  KEY `idx_app_dir_group_group_dir` (`directory_id`,`group_name`),
  KEY `fk_app_dir_group_dir` (`directory_id`),
  KEY `fk_app_dir_group_app` (`application_id`),
  KEY `fk_app_dir_group_mapping` (`app_dir_mapping_id`),
  CONSTRAINT `fk_app_dir_group_app` FOREIGN KEY (`application_id`) REFERENCES `cwd_application` (`id`),
  CONSTRAINT `fk_app_dir_group_dir` FOREIGN KEY (`directory_id`) REFERENCES `cwd_directory` (`id`),
  CONSTRAINT `fk_app_dir_group_mapping` FOREIGN KEY (`app_dir_mapping_id`) REFERENCES `cwd_app_dir_mapping` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cwd_app_dir_group_mapping`
--

LOCK TABLES `cwd_app_dir_group_mapping` WRITE;
/*!40000 ALTER TABLE `cwd_app_dir_group_mapping` DISABLE KEYS */;
INSERT INTO `cwd_app_dir_group_mapping` VALUES (229377,196609,2,32769,'crowd-administrators'),(4718593,1703937,1671169,32769,'ci-admins'),(4718594,1703937,1671169,32769,'jira-developers-JC'),(4718596,1703937,1671169,32769,'jira-developers-COMMON'),(4718597,1703937,1671169,32769,'jira-developers-SWALLOWS'),(4718598,1703937,1671169,32769,'jira-developers-IN'),(4718599,1703937,1671169,32769,'jira-users'),(4718600,1703937,1671169,32769,'testers');
/*!40000 ALTER TABLE `cwd_app_dir_group_mapping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cwd_app_dir_mapping`
--

DROP TABLE IF EXISTS `cwd_app_dir_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cwd_app_dir_mapping` (
  `id` bigint(20) NOT NULL,
  `application_id` bigint(20) NOT NULL,
  `directory_id` bigint(20) NOT NULL,
  `allow_all` char(1) NOT NULL,
  `list_index` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `application_id` (`application_id`,`directory_id`),
  KEY `fk_app_dir_dir` (`directory_id`),
  KEY `fk_app_dir_app` (`application_id`),
  CONSTRAINT `fk_app_dir_app` FOREIGN KEY (`application_id`) REFERENCES `cwd_application` (`id`),
  CONSTRAINT `fk_app_dir_dir` FOREIGN KEY (`directory_id`) REFERENCES `cwd_directory` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cwd_app_dir_mapping`
--

LOCK TABLES `cwd_app_dir_mapping` WRITE;
/*!40000 ALTER TABLE `cwd_app_dir_mapping` DISABLE KEYS */;
INSERT INTO `cwd_app_dir_mapping` VALUES (196609,2,32769,'F',0),(622594,589826,32769,'T',0),(950273,917505,32769,'T',0),(950274,917506,32769,'T',0),(1703937,1671169,32769,'T',0);
/*!40000 ALTER TABLE `cwd_app_dir_mapping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cwd_app_dir_operation`
--

DROP TABLE IF EXISTS `cwd_app_dir_operation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cwd_app_dir_operation` (
  `app_dir_mapping_id` bigint(20) NOT NULL,
  `operation_type` varchar(32) NOT NULL,
  PRIMARY KEY (`app_dir_mapping_id`,`operation_type`),
  KEY `fk_app_dir_mapping` (`app_dir_mapping_id`),
  CONSTRAINT `fk_app_dir_mapping` FOREIGN KEY (`app_dir_mapping_id`) REFERENCES `cwd_app_dir_mapping` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cwd_app_dir_operation`
--

LOCK TABLES `cwd_app_dir_operation` WRITE;
/*!40000 ALTER TABLE `cwd_app_dir_operation` DISABLE KEYS */;
INSERT INTO `cwd_app_dir_operation` VALUES (196609,'CREATE_GROUP'),(196609,'CREATE_ROLE'),(196609,'CREATE_USER'),(196609,'DELETE_GROUP'),(196609,'DELETE_ROLE'),(196609,'DELETE_USER'),(196609,'UPDATE_GROUP'),(196609,'UPDATE_GROUP_ATTRIBUTE'),(196609,'UPDATE_ROLE'),(196609,'UPDATE_ROLE_ATTRIBUTE'),(196609,'UPDATE_USER'),(196609,'UPDATE_USER_ATTRIBUTE'),(622594,'CREATE_GROUP'),(622594,'CREATE_ROLE'),(622594,'CREATE_USER'),(622594,'DELETE_GROUP'),(622594,'DELETE_ROLE'),(622594,'DELETE_USER'),(622594,'UPDATE_GROUP'),(622594,'UPDATE_GROUP_ATTRIBUTE'),(622594,'UPDATE_ROLE'),(622594,'UPDATE_ROLE_ATTRIBUTE'),(622594,'UPDATE_USER'),(622594,'UPDATE_USER_ATTRIBUTE'),(950273,'CREATE_GROUP'),(950273,'CREATE_ROLE'),(950273,'CREATE_USER'),(950273,'DELETE_GROUP'),(950273,'DELETE_ROLE'),(950273,'DELETE_USER'),(950273,'UPDATE_GROUP'),(950273,'UPDATE_GROUP_ATTRIBUTE'),(950273,'UPDATE_ROLE'),(950273,'UPDATE_ROLE_ATTRIBUTE'),(950273,'UPDATE_USER'),(950273,'UPDATE_USER_ATTRIBUTE'),(950274,'CREATE_GROUP'),(950274,'CREATE_ROLE'),(950274,'CREATE_USER'),(950274,'DELETE_GROUP'),(950274,'DELETE_ROLE'),(950274,'DELETE_USER'),(950274,'UPDATE_GROUP'),(950274,'UPDATE_GROUP_ATTRIBUTE'),(950274,'UPDATE_ROLE'),(950274,'UPDATE_ROLE_ATTRIBUTE'),(950274,'UPDATE_USER'),(950274,'UPDATE_USER_ATTRIBUTE'),(1703937,'CREATE_GROUP'),(1703937,'CREATE_ROLE'),(1703937,'CREATE_USER'),(1703937,'DELETE_GROUP'),(1703937,'DELETE_ROLE'),(1703937,'DELETE_USER'),(1703937,'UPDATE_GROUP'),(1703937,'UPDATE_GROUP_ATTRIBUTE'),(1703937,'UPDATE_ROLE'),(1703937,'UPDATE_ROLE_ATTRIBUTE'),(1703937,'UPDATE_USER'),(1703937,'UPDATE_USER_ATTRIBUTE');
/*!40000 ALTER TABLE `cwd_app_dir_operation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cwd_application`
--

DROP TABLE IF EXISTS `cwd_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cwd_application` (
  `id` bigint(20) NOT NULL,
  `application_name` varchar(255) NOT NULL,
  `lower_application_name` varchar(255) NOT NULL,
  `created_date` datetime NOT NULL,
  `updated_date` datetime NOT NULL,
  `active` char(1) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `application_type` varchar(32) NOT NULL,
  `credential` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lower_application_name` (`lower_application_name`),
  KEY `idx_app_active` (`active`),
  KEY `idx_app_type` (`application_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cwd_application`
--

LOCK TABLES `cwd_application` WRITE;
/*!40000 ALTER TABLE `cwd_application` DISABLE KEYS */;
INSERT INTO `cwd_application` VALUES (1,'google-apps','google-apps','2011-04-13 17:16:51','2011-04-13 17:18:30','T','Google Applications Connector','PLUGIN','{PKCS5S2}oHfZH9qwY3CawAVmdduXffggdgdwCh9c7CdmuKrsUbjbU2pX9tDjIz55gRGh5gt9'),(2,'crowd','crowd','2011-04-13 17:18:21','2014-10-13 17:46:31','T','Crowd Console','CROWD','{PKCS5S2}eP/jP42cRqnrsJ7+G5BpwQWdbN5kyF7FZBeg7tUQJIOsKpqLI6UY5RusNKr0fIm/'),(589826,'fisheye','fisheye','2011-04-20 17:31:30','2014-10-13 17:46:44','T','fisheye','FISHEYE','{PKCS5S2}yCfhuwUcHp882AFnWIqWrZlyVglSzNDHU/7as8oTqEnI0fdf3miav8qD67gZi2fs'),(917505,'jira','jira','2011-04-23 08:44:26','2014-10-13 17:47:05','T','jira','JIRA','{PKCS5S2}7Yp95jXCplXDqexZDhGTBWyEaXnsdMOuGITRDXJqHjsd6t7az7FH5hAdv1oIcS97'),(917506,'confluence','confluence','2011-04-23 08:56:57','2014-10-13 17:46:11','T','confluence','CONFLUENCE','{PKCS5S2}ALp+rI1iBcCKM31unKWi92tNL7S9UxDOgpKeBI1SWH9djTCYCeEtlREEHpMIk9De'),(1671169,'jenkins','jenkins','2011-08-06 10:31:02','2014-10-13 17:46:58','T','Jenkins','GENERIC_APPLICATION','{PKCS5S2}bmj4PHMaJN1OFYGcQITNpFIGLXHVYmPgEXUWPQMvLv6WGenY7Xrzmeg9nWdPqcix');
/*!40000 ALTER TABLE `cwd_application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cwd_application_address`
--

DROP TABLE IF EXISTS `cwd_application_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cwd_application_address` (
  `application_id` bigint(20) NOT NULL,
  `remote_address` varchar(255) NOT NULL,
  `remote_address_binary` varchar(255) DEFAULT NULL,
  `remote_address_mask` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`application_id`,`remote_address`,`remote_address_mask`),
  KEY `fk_application_address` (`application_id`),
  CONSTRAINT `fk_application_address` FOREIGN KEY (`application_id`) REFERENCES `cwd_application` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cwd_application_address`
--

LOCK TABLES `cwd_application_address` WRITE;
/*!40000 ALTER TABLE `cwd_application_address` DISABLE KEYS */;
INSERT INTO `cwd_application_address` VALUES (2,'127.0.0.1','fwAAAQ==',0),(2,'62.75.252.5','Pkv8BQ==',0),(2,'64.22.89.180','QBZZtA==',0),(2,'94.41.184.112','Xim4cA==',0),(2,'crowd.jtalks.org',NULL,0),(2,'localhost',NULL,0),(589826,'0:0:0:0:0:0:0:1','AAAAAAAAAAAAAAAAAAAAAQ==',0),(589826,'127.0.0.1','fwAAAQ==',0),(589826,'217.172.172.123','2aysew==',0),(589826,'fisheye.jtalks.org',NULL,0),(917505,'0:0:0:0:0:0:0:1','AAAAAAAAAAAAAAAAAAAAAQ==',0),(917505,'127.0.0.1','fwAAAQ==',0),(917505,'217.172.172.123','2aysew==',0),(917505,'jira.jtalks.org',NULL,0),(917506,'0:0:0:0:0:0:0:1','AAAAAAAAAAAAAAAAAAAAAQ==',0),(917506,'127.0.0.1','fwAAAQ==',0),(917506,'jtalks.org',NULL,0),(917506,'wiki.jtalks.org',NULL,0),(1671169,'0:0:0:0:0:0:0:1','AAAAAAAAAAAAAAAAAAAAAQ==',0),(1671169,'127.0.0.1','fwAAAQ==',0),(1671169,'5.9.40.180','BQkotA==',0),(1671169,'94.41.184.112','Xim4cA==',0),(1671169,'ci.jtalks.org',NULL,0);
/*!40000 ALTER TABLE `cwd_application_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cwd_application_alias`
--

DROP TABLE IF EXISTS `cwd_application_alias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cwd_application_alias` (
  `id` bigint(20) NOT NULL,
  `application_id` bigint(20) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `lower_user_name` varchar(255) NOT NULL,
  `alias_name` varchar(255) NOT NULL,
  `lower_alias_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `application_id` (`application_id`,`lower_user_name`),
  UNIQUE KEY `application_id_2` (`application_id`,`lower_alias_name`),
  KEY `fk_alias_app_id` (`application_id`),
  CONSTRAINT `fk_alias_app_id` FOREIGN KEY (`application_id`) REFERENCES `cwd_application` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cwd_application_alias`
--

LOCK TABLES `cwd_application_alias` WRITE;
/*!40000 ALTER TABLE `cwd_application_alias` DISABLE KEYS */;
/*!40000 ALTER TABLE `cwd_application_alias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cwd_application_attribute`
--

DROP TABLE IF EXISTS `cwd_application_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cwd_application_attribute` (
  `application_id` bigint(20) NOT NULL,
  `attribute_value` varchar(4000) DEFAULT NULL,
  `attribute_name` varchar(255) NOT NULL,
  PRIMARY KEY (`application_id`,`attribute_name`),
  KEY `fk_application_attribute` (`application_id`),
  CONSTRAINT `fk_application_attribute` FOREIGN KEY (`application_id`) REFERENCES `cwd_application` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cwd_application_attribute`
--

LOCK TABLES `cwd_application_attribute` WRITE;
/*!40000 ALTER TABLE `cwd_application_attribute` DISABLE KEYS */;
INSERT INTO `cwd_application_attribute` VALUES (1,'true','atlassian_sha1_applied'),(2,'true','atlassian_sha1_applied'),(589826,'http://fisheye.jtalks.org','applicationURL'),(589826,'true','atlassian_sha1_applied'),(917505,'http://jira.jtalks.org','applicationURL'),(917505,'true','atlassian_sha1_applied'),(917506,'http://jtalks.org','applicationURL'),(917506,'true','atlassian_sha1_applied'),(1671169,'http://ci.jtalks.org','applicationURL'),(1671169,'true','atlassian_sha1_applied');
/*!40000 ALTER TABLE `cwd_application_attribute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cwd_directory`
--

DROP TABLE IF EXISTS `cwd_directory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cwd_directory` (
  `id` bigint(20) NOT NULL,
  `directory_name` varchar(255) NOT NULL,
  `lower_directory_name` varchar(255) NOT NULL,
  `created_date` datetime NOT NULL,
  `updated_date` datetime NOT NULL,
  `active` char(1) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `impl_class` varchar(255) NOT NULL,
  `lower_impl_class` varchar(255) NOT NULL,
  `directory_type` varchar(32) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lower_directory_name` (`lower_directory_name`),
  KEY `idx_dir_type` (`directory_type`),
  KEY `idx_dir_active` (`active`),
  KEY `idx_dir_l_impl_class` (`lower_impl_class`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cwd_directory`
--

LOCK TABLES `cwd_directory` WRITE;
/*!40000 ALTER TABLE `cwd_directory` DISABLE KEYS */;
INSERT INTO `cwd_directory` VALUES (32769,'JTalks Crowd','jtalks crowd','2011-04-13 17:18:01','2011-04-24 12:10:45','T','JTalks Crowd authentication server','com.atlassian.crowd.directory.InternalDirectory','com.atlassian.crowd.directory.internaldirectory','INTERNAL');
/*!40000 ALTER TABLE `cwd_directory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cwd_directory_attribute`
--

DROP TABLE IF EXISTS `cwd_directory_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cwd_directory_attribute` (
  `directory_id` bigint(20) NOT NULL,
  `attribute_value` varchar(4000) DEFAULT NULL,
  `attribute_name` varchar(255) NOT NULL,
  PRIMARY KEY (`directory_id`,`attribute_name`),
  KEY `fk_directory_attribute` (`directory_id`),
  CONSTRAINT `fk_directory_attribute` FOREIGN KEY (`directory_id`) REFERENCES `cwd_directory` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cwd_directory_attribute`
--

LOCK TABLES `cwd_directory_attribute` WRITE;
/*!40000 ALTER TABLE `cwd_directory_attribute` DISABLE KEYS */;
INSERT INTO `cwd_directory_attribute` VALUES (32769,'bamboo-user|confluence-users|jira-users','autoAddGroups'),(32769,'0','password_history_count'),(32769,'0','password_max_attempts'),(32769,'0','password_max_change_time'),(32769,'','password_regex'),(32769,'true','useNestedGroups'),(32769,'atlassian-security','user_encryption_method');
/*!40000 ALTER TABLE `cwd_directory_attribute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cwd_directory_operation`
--

DROP TABLE IF EXISTS `cwd_directory_operation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cwd_directory_operation` (
  `directory_id` bigint(20) NOT NULL,
  `operation_type` varchar(32) NOT NULL,
  PRIMARY KEY (`directory_id`,`operation_type`),
  KEY `fk_directory_operation` (`directory_id`),
  CONSTRAINT `fk_directory_operation` FOREIGN KEY (`directory_id`) REFERENCES `cwd_directory` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cwd_directory_operation`
--

LOCK TABLES `cwd_directory_operation` WRITE;
/*!40000 ALTER TABLE `cwd_directory_operation` DISABLE KEYS */;
INSERT INTO `cwd_directory_operation` VALUES (32769,'CREATE_GROUP'),(32769,'CREATE_USER'),(32769,'DELETE_GROUP'),(32769,'DELETE_USER'),(32769,'UPDATE_GROUP'),(32769,'UPDATE_GROUP_ATTRIBUTE'),(32769,'UPDATE_USER'),(32769,'UPDATE_USER_ATTRIBUTE');
/*!40000 ALTER TABLE `cwd_directory_operation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cwd_group`
--

DROP TABLE IF EXISTS `cwd_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cwd_group` (
  `id` bigint(20) NOT NULL,
  `group_name` varchar(255) NOT NULL,
  `lower_group_name` varchar(255) NOT NULL,
  `active` char(1) NOT NULL,
  `is_local` char(1) NOT NULL,
  `created_date` datetime NOT NULL,
  `updated_date` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `group_type` varchar(32) NOT NULL,
  `directory_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lower_group_name` (`lower_group_name`,`directory_id`),
  KEY `idx_group_active` (`active`,`directory_id`),
  KEY `idx_group_dir_id` (`directory_id`),
  KEY `fk_directory_id` (`directory_id`),
  CONSTRAINT `fk_directory_id` FOREIGN KEY (`directory_id`) REFERENCES `cwd_directory` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cwd_group`
--

LOCK TABLES `cwd_group` WRITE;
/*!40000 ALTER TABLE `cwd_group` DISABLE KEYS */;
INSERT INTO `cwd_group` VALUES (131073,'crowd-administrators','crowd-administrators','T','F','2011-04-13 17:18:20','2011-04-13 17:18:20',NULL,'GROUP',32769),(131074,'confluence-administrators','confluence-administrators','T','F','2011-04-13 17:30:33','2011-04-13 17:30:33','','GROUP',32769),(131075,'confluence-users','confluence-users','T','F','2011-04-13 17:30:55','2011-04-13 17:30:55','','GROUP',32769),(425985,'jira-administrators','jira-administrators','T','F','2011-04-14 18:35:13','2011-04-14 18:35:13','','GROUP',32769),(425986,'jira-developers','jira-developers','T','F','2011-04-14 18:35:29','2011-04-14 18:35:29','','GROUP',32769),(425987,'jira-users','jira-users','T','F','2011-04-14 18:36:03','2011-04-14 18:36:03','','GROUP',32769),(655363,'jira-developers-JC','jira-developers-jc','T','F','2011-04-23 08:00:22','2011-04-23 08:00:22',NULL,'GROUP',32769),(655365,'jira-developers-IN','jira-developers-in','T','F','2011-04-23 08:00:22','2011-04-23 08:00:22',NULL,'GROUP',32769),(655367,'testers','testers','T','F','2011-04-23 08:00:22','2011-04-23 08:00:22',NULL,'GROUP',32769),(786433,'developers','developers','T','F','2011-04-23 08:20:23','2011-04-23 08:20:23',NULL,'GROUP',32769),(786434,'confluence-moderators','confluence-moderators','T','F','2011-04-23 08:20:23','2011-04-23 08:20:23',NULL,'GROUP',32769),(1376260,'jira-developers-COMMON','jira-developers-common','T','F','2011-07-31 10:29:02','2011-07-31 10:29:02',NULL,'GROUP',32769),(1638404,'ci-admins','ci-admins','T','F','2011-08-06 10:29:26','2011-08-06 10:29:26',NULL,'GROUP',32769),(1966083,'jira-developers-SWALLOWS','jira-developers-swallows','T','F','2011-09-07 17:37:50','2011-09-07 17:37:50',NULL,'GROUP',32769),(2719745,'balsamiq-mockups-editors','balsamiq-mockups-editors','T','F','2011-12-17 07:22:04','2011-12-17 07:22:04',NULL,'GROUP',32769),(2719746,'ui-developers','ui-developers','T','F','2012-01-26 19:24:11','2012-01-26 19:24:11',NULL,'GROUP',32769),(4161537,'bamboo-user','bamboo-user','T','F','2012-09-09 19:12:19','2012-09-09 19:12:19','','GROUP',32769),(4882433,'developers-antarcticle','developers-antarcticle','T','F','2012-10-28 20:24:39','2012-10-28 20:24:39',NULL,'GROUP',32769),(5570561,'ci-moderators','ci-moderators','T','F','2013-03-01 06:02:10','2013-03-01 06:02:10',NULL,'GROUP',32769),(7569410,'ci-can-run-jobs','ci-can-run-jobs','T','F','2014-02-06 18:53:52','2014-02-06 18:53:52',NULL,'GROUP',32769),(7569411,'Trusted Users','trusted users','T','F','2014-02-11 20:54:53','2014-02-11 20:54:53',NULL,'GROUP',32769),(7569412,'jira-developers-antarcticle','jira-developers-antarcticle','T','F','2014-02-27 19:32:27','2014-02-27 19:32:27',NULL,'GROUP',32769),(7569413,'can-read-jenkins-notifications','can-read-jenkins-notifications','T','F','2014-06-27 17:15:15','2014-06-27 17:15:15',NULL,'GROUP',32769);
/*!40000 ALTER TABLE `cwd_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cwd_group_attribute`
--

DROP TABLE IF EXISTS `cwd_group_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cwd_group_attribute` (
  `id` bigint(20) NOT NULL,
  `group_id` bigint(20) NOT NULL,
  `directory_id` bigint(20) NOT NULL,
  `attribute_name` varchar(255) NOT NULL,
  `attribute_value` varchar(255) DEFAULT NULL,
  `attribute_lower_value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_id` (`group_id`,`attribute_name`,`attribute_lower_value`),
  KEY `idx_group_attr_dir_name_lval` (`directory_id`,`attribute_name`,`attribute_lower_value`),
  KEY `idx_group_attr_group_id` (`group_id`),
  KEY `fk_group_attr_dir_id` (`directory_id`),
  KEY `fk_group_attr_id_group_id` (`group_id`),
  CONSTRAINT `fk_group_attr_dir_id` FOREIGN KEY (`directory_id`) REFERENCES `cwd_directory` (`id`),
  CONSTRAINT `fk_group_attr_id_group_id` FOREIGN KEY (`group_id`) REFERENCES `cwd_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cwd_group_attribute`
--

LOCK TABLES `cwd_group_attribute` WRITE;
/*!40000 ALTER TABLE `cwd_group_attribute` DISABLE KEYS */;
/*!40000 ALTER TABLE `cwd_group_attribute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cwd_membership`
--

DROP TABLE IF EXISTS `cwd_membership`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cwd_membership` (
  `id` bigint(20) NOT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `child_id` bigint(20) DEFAULT NULL,
  `membership_type` varchar(32) DEFAULT NULL,
  `group_type` varchar(32) NOT NULL,
  `parent_name` varchar(255) NOT NULL,
  `lower_parent_name` varchar(255) NOT NULL,
  `child_name` varchar(255) NOT NULL,
  `lower_child_name` varchar(255) NOT NULL,
  `directory_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `parent_id` (`parent_id`,`child_id`,`membership_type`),
  KEY `idx_mem_dir_child` (`membership_type`,`lower_child_name`,`directory_id`),
  KEY `idx_mem_dir_parent` (`membership_type`,`lower_parent_name`,`directory_id`),
  KEY `idx_mem_dir_parent_child` (`membership_type`,`lower_parent_name`,`lower_child_name`,`directory_id`),
  KEY `fk_membership_dir` (`directory_id`),
  CONSTRAINT `fk_membership_dir` FOREIGN KEY (`directory_id`) REFERENCES `cwd_directory` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cwd_membership`
--

LOCK TABLES `cwd_membership` WRITE;
/*!40000 ALTER TABLE `cwd_membership` DISABLE KEYS */;
INSERT INTO `cwd_membership` VALUES (9601025,2719745,9535489,'GROUP_USER','GROUP','balsamiq-mockups-editors','balsamiq-mockups-editors','admin','admin',32769),(9601026,4161537,9535489,'GROUP_USER','GROUP','bamboo-user','bamboo-user','admin','admin',32769),(9601027,7569413,9535489,'GROUP_USER','GROUP','can-read-jenkins-notifications','can-read-jenkins-notifications','admin','admin',32769),(9601028,1638404,9535489,'GROUP_USER','GROUP','ci-admins','ci-admins','admin','admin',32769),(9601029,7569410,9535489,'GROUP_USER','GROUP','ci-can-run-jobs','ci-can-run-jobs','admin','admin',32769),(9601030,5570561,9535489,'GROUP_USER','GROUP','ci-moderators','ci-moderators','admin','admin',32769),(9601031,131074,9535489,'GROUP_USER','GROUP','confluence-administrators','confluence-administrators','admin','admin',32769),(9601032,786434,9535489,'GROUP_USER','GROUP','confluence-moderators','confluence-moderators','admin','admin',32769),(9601033,131075,9535489,'GROUP_USER','GROUP','confluence-users','confluence-users','admin','admin',32769),(9601034,131073,9535489,'GROUP_USER','GROUP','crowd-administrators','crowd-administrators','admin','admin',32769),(9601035,786433,9535489,'GROUP_USER','GROUP','developers','developers','admin','admin',32769),(9601036,4882433,9535489,'GROUP_USER','GROUP','developers-antarcticle','developers-antarcticle','admin','admin',32769),(9601037,425985,9535489,'GROUP_USER','GROUP','jira-administrators','jira-administrators','admin','admin',32769),(9601038,425986,9535489,'GROUP_USER','GROUP','jira-developers','jira-developers','admin','admin',32769),(9601039,7569412,9535489,'GROUP_USER','GROUP','jira-developers-antarcticle','jira-developers-antarcticle','admin','admin',32769),(9601040,1376260,9535489,'GROUP_USER','GROUP','jira-developers-COMMON','jira-developers-common','admin','admin',32769),(9601041,655365,9535489,'GROUP_USER','GROUP','jira-developers-IN','jira-developers-in','admin','admin',32769),(9601042,655363,9535489,'GROUP_USER','GROUP','jira-developers-JC','jira-developers-jc','admin','admin',32769),(9601043,1966083,9535489,'GROUP_USER','GROUP','jira-developers-SWALLOWS','jira-developers-swallows','admin','admin',32769),(9601044,425987,9535489,'GROUP_USER','GROUP','jira-users','jira-users','admin','admin',32769),(9601045,655367,9535489,'GROUP_USER','GROUP','testers','testers','admin','admin',32769),(9601046,7569411,9535489,'GROUP_USER','GROUP','Trusted Users','trusted users','admin','admin',32769),(9601047,2719746,9535489,'GROUP_USER','GROUP','ui-developers','ui-developers','admin','admin',32769);
/*!40000 ALTER TABLE `cwd_membership` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cwd_property`
--

DROP TABLE IF EXISTS `cwd_property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cwd_property` (
  `property_key` varchar(255) NOT NULL,
  `property_name` varchar(255) NOT NULL,
  `property_value` varchar(4000) DEFAULT NULL,
  PRIMARY KEY (`property_key`,`property_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cwd_property`
--

LOCK TABLES `cwd_property` WRITE;
/*!40000 ALTER TABLE `cwd_property` DISABLE KEYS */;
INSERT INTO `cwd_property` VALUES ('crowd','build.number','522'),('crowd','cache.enabled','true'),('crowd','com.sun.jndi.ldap.connect.pool.authentication','simple'),('crowd','com.sun.jndi.ldap.connect.pool.initsize','1'),('crowd','com.sun.jndi.ldap.connect.pool.maxsize','0'),('crowd','com.sun.jndi.ldap.connect.pool.prefsize','10'),('crowd','com.sun.jndi.ldap.connect.pool.protocol','plain ssl'),('crowd','com.sun.jndi.ldap.connect.pool.timeout','30000'),('crowd','current.license.resource.total','35'),('crowd','database.token.storage.enabled','true'),('crowd','deployment.title','JTalks Crowd'),('crowd','des.encryption.key','+BATBObyMlI='),('crowd','domain','localhost'),('crowd','email.template.forgotten.username','Hello $firstname $lastname,\n\nYou have requested the username for your email address: $email.\n\nYour username(s) are: $username\n\nIf you think this email was sent incorrectly, please contact one of the administrators at: $admincontact\n\n$deploymenttitle Administrator'),('crowd','gzip.enabled','false'),('crowd','mailserver.host','smtp.gmail.com'),('crowd','mailserver.jndi',''),('crowd','mailserver.message.template','Hello $firstname $lastname,\n\nYou (or someone else) have requested to reset your password for $deploymenttitle on $date.\n\nIf you follow the link below you will be able to personally reset your password.\n$resetlink\n\nThis password reset request is valid for the next 24 hours.\n\nHere are the details of your account:\n\nUsername: $username\nFull Name: $firstname $lastname\n\n$deploymenttitle Administrator'),('crowd','mailserver.password',''),('crowd','mailserver.port','25'),('crowd','mailserver.prefix','[JTalks Crowd - Atlassian Crowd]'),('crowd','mailserver.sender','crowd@jtalks.org'),('crowd','mailserver.username',''),('crowd','mailserver.usessl','false'),('crowd','notification.email','wedens13@yandex.ru'),('crowd','secure.cookie','false'),('crowd','session.time','3600000'),('crowd','token.seed','cRSg3wty'),('crowd','trusted.proxy.servers','62.75.252.5');
/*!40000 ALTER TABLE `cwd_property` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cwd_token`
--

DROP TABLE IF EXISTS `cwd_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cwd_token` (
  `id` bigint(20) NOT NULL,
  `directory_id` bigint(20) NOT NULL,
  `entity_name` varchar(255) NOT NULL,
  `random_number` bigint(20) NOT NULL,
  `identifier_hash` varchar(255) NOT NULL,
  `random_hash` varchar(255) NOT NULL,
  `created_date` datetime NOT NULL,
  `last_accessed_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier_hash` (`identifier_hash`),
  KEY `idx_token_key` (`random_hash`),
  KEY `idx_token_dir_id` (`directory_id`),
  KEY `idx_token_name_dir_id` (`directory_id`,`entity_name`),
  KEY `idx_token_last_access` (`last_accessed_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cwd_token`
--

LOCK TABLES `cwd_token` WRITE;
/*!40000 ALTER TABLE `cwd_token` DISABLE KEYS */;
INSERT INTO `cwd_token` VALUES (9633793,32769,'admin',602454350679338995,'re53dJykCGclGuiaw8zZoA00','XFqQ3vnJxLOz0OGooF3rHw00','2014-10-13 17:42:42','2014-10-13 18:01:32'),(9666561,-1,'crowd',1007899766645289971,'HynTzREIXxOhhDEp3DsKxg00','X9u5W80Luo0aFLM0WGJECA00','2014-10-13 17:58:59','2014-10-13 18:01:32');
/*!40000 ALTER TABLE `cwd_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cwd_user`
--

DROP TABLE IF EXISTS `cwd_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cwd_user` (
  `id` bigint(20) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `lower_user_name` varchar(255) NOT NULL,
  `active` char(1) NOT NULL,
  `created_date` datetime NOT NULL,
  `updated_date` datetime NOT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `lower_first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `lower_last_name` varchar(255) DEFAULT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `lower_display_name` varchar(255) DEFAULT NULL,
  `email_address` varchar(255) DEFAULT NULL,
  `lower_email_address` varchar(255) DEFAULT NULL,
  `directory_id` bigint(20) NOT NULL,
  `credential` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lower_user_name` (`lower_user_name`,`directory_id`),
  KEY `idx_user_lower_display_name` (`lower_display_name`,`directory_id`),
  KEY `idx_user_lower_last_name` (`lower_last_name`,`directory_id`),
  KEY `idx_user_active` (`active`,`directory_id`),
  KEY `idx_user_name_dir_id` (`directory_id`),
  KEY `idx_user_lower_first_name` (`lower_first_name`,`directory_id`),
  KEY `idx_user_lower_email_address` (`lower_email_address`,`directory_id`),
  KEY `fk_user_dir_id` (`directory_id`),
  CONSTRAINT `fk_user_dir_id` FOREIGN KEY (`directory_id`) REFERENCES `cwd_directory` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cwd_user`
--

LOCK TABLES `cwd_user` WRITE;
/*!40000 ALTER TABLE `cwd_user` DISABLE KEYS */;
INSERT INTO `cwd_user` VALUES (9535489,'admin','admin','T','2014-10-13 17:38:20','2014-10-13 17:38:20','admin','admin','admin','admin','admin admin','admin admin','admin@jtalks.org','admin@jtalks.org',32769,'{PKCS5S2}LugdpcnXJrFOYynl+D2dLJ+ELmigI0w6prV0xg+FfXAxtYftlLHVAHTTu+xngnXi');
/*!40000 ALTER TABLE `cwd_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cwd_user_attribute`
--

DROP TABLE IF EXISTS `cwd_user_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cwd_user_attribute` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `directory_id` bigint(20) NOT NULL,
  `attribute_name` varchar(255) NOT NULL,
  `attribute_value` varchar(255) DEFAULT NULL,
  `attribute_lower_value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`attribute_name`,`attribute_lower_value`),
  KEY `idx_user_attr_dir_name_lval` (`directory_id`,`attribute_name`,`attribute_lower_value`),
  KEY `idx_user_attr_user_id` (`user_id`),
  KEY `fk_user_attr_dir_id` (`directory_id`),
  KEY `fk_user_attribute_id_user_id` (`user_id`),
  CONSTRAINT `fk_user_attribute_id_user_id` FOREIGN KEY (`user_id`) REFERENCES `cwd_user` (`id`),
  CONSTRAINT `fk_user_attr_dir_id` FOREIGN KEY (`directory_id`) REFERENCES `cwd_directory` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cwd_user_attribute`
--

LOCK TABLES `cwd_user_attribute` WRITE;
/*!40000 ALTER TABLE `cwd_user_attribute` DISABLE KEYS */;
INSERT INTO `cwd_user_attribute` VALUES (9568257,9535489,32769,'requiresPasswordChange','false','false'),(9568258,9535489,32769,'passwordLastChanged','1413221900215','1413221900215'),(9568259,9535489,32769,'invalidPasswordAttempts','0','0'),(9568260,9535489,32769,'lastAuthenticated','1413222162388','1413222162388'),(9568261,9535489,32769,'autoGroupsAdded','true','true');
/*!40000 ALTER TABLE `cwd_user_attribute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cwd_user_credential_record`
--

DROP TABLE IF EXISTS `cwd_user_credential_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cwd_user_credential_record` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `list_index` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_user_cred_user` (`user_id`),
  CONSTRAINT `fk_user_cred_user` FOREIGN KEY (`user_id`) REFERENCES `cwd_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cwd_user_credential_record`
--

LOCK TABLES `cwd_user_credential_record` WRITE;
/*!40000 ALTER TABLE `cwd_user_credential_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `cwd_user_credential_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hibernate_unique_key`
--

DROP TABLE IF EXISTS `hibernate_unique_key`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hibernate_unique_key` (
  `next_hi` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hibernate_unique_key`
--

LOCK TABLES `hibernate_unique_key` WRITE;
/*!40000 ALTER TABLE `hibernate_unique_key` DISABLE KEYS */;
INSERT INTO `hibernate_unique_key` VALUES (296);
/*!40000 ALTER TABLE `hibernate_unique_key` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-10-13 18:06:10