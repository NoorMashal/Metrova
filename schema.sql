-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: trainschema
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `employee_id` int NOT NULL,
  `ssn` char(11) NOT NULL,
  PRIMARY KEY (`employee_id`),
  UNIQUE KEY `ssn` (`ssn`),
  CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (3,'123-45-6789');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `queries`
--

DROP TABLE IF EXISTS `queries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `queries` (
  `query_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `query_text` text NOT NULL,
  `reply_text` text,
  `query_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `reply_date` timestamp NULL DEFAULT NULL,
  `status` enum('open','solved') DEFAULT 'open',
  PRIMARY KEY (`query_id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `queries_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `queries`
--

LOCK TABLES `queries` WRITE;
/*!40000 ALTER TABLE `queries` DISABLE KEYS */;
/*!40000 ALTER TABLE `queries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `replies`
--

DROP TABLE IF EXISTS `replies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `replies` (
  `reply_id` int NOT NULL AUTO_INCREMENT,
  `query_id` int NOT NULL,
  `representative_id` int DEFAULT NULL,
  `customer_id` int DEFAULT NULL,
  `reply_text` text NOT NULL,
  `reply_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`reply_id`),
  KEY `query_id` (`query_id`),
  KEY `representative_id` (`representative_id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `replies_ibfk_1` FOREIGN KEY (`query_id`) REFERENCES `queries` (`query_id`) ON DELETE CASCADE,
  CONSTRAINT `replies_ibfk_2` FOREIGN KEY (`representative_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `replies_ibfk_3` FOREIGN KEY (`customer_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `replies`
--

LOCK TABLES `replies` WRITE;
/*!40000 ALTER TABLE `replies` DISABLE KEYS */;
/*!40000 ALTER TABLE `replies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservation`
--

DROP TABLE IF EXISTS `reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservation` (
  `reservation_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `origin_stop_id` int NOT NULL,
  `destination_stop_id` int NOT NULL,
  `fare` decimal(10,2) NOT NULL,
  `booking_date` date NOT NULL,
  PRIMARY KEY (`reservation_id`),
  KEY `fk_user` (`user_id`),
  KEY `fk_origin_stop` (`origin_stop_id`),
  KEY `fk_destination_stop` (`destination_stop_id`),
  CONSTRAINT `fk_destination_stop` FOREIGN KEY (`destination_stop_id`) REFERENCES `stops` (`stop_id`),
  CONSTRAINT `fk_origin_stop` FOREIGN KEY (`origin_stop_id`) REFERENCES `stops` (`stop_id`),
  CONSTRAINT `fk_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `check_different_stops` CHECK ((`origin_stop_id` <> `destination_stop_id`))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservation`
--

LOCK TABLES `reservation` WRITE;
/*!40000 ALTER TABLE `reservation` DISABLE KEYS */;
INSERT INTO `reservation` VALUES (1,2,202,203,29.50,'2024-12-07'),(2,1,83,88,5.83,'2024-12-06');
/*!40000 ALTER TABLE `reservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stations`
--

DROP TABLE IF EXISTS `stations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stations` (
  `station_id` int NOT NULL AUTO_INCREMENT,
  `station_name` varchar(100) NOT NULL,
  `city` varchar(100) NOT NULL,
  `state` char(2) NOT NULL,
  PRIMARY KEY (`station_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stations`
--

LOCK TABLES `stations` WRITE;
/*!40000 ALTER TABLE `stations` DISABLE KEYS */;
INSERT INTO `stations` VALUES (1,'Trenton Transit Center','Trenton','NJ'),(2,'Princeton Junction','Princeton','NJ'),(3,'New Brunswick','New Brunswick','NJ'),(4,'Newark Penn Station','Newark','NJ'),(5,'Hoboken Terminal','Hoboken','NJ'),(6,'Secaucus Junction','Secaucus','NJ'),(7,'Summit','Summit','NJ'),(8,'Roselle Park','Roselle Park','NJ'),(9,'Dover','Dover','NJ'),(10,'Morristown','Morristown','NJ'),(11,'Plainfield','Plainfield','NJ'),(12,'Cranford','Cranford','NJ'),(13,'Elizabeth','Elizabeth','NJ'),(14,'Rahway','Rahway','NJ'),(15,'Woodbridge','Woodbridge','NJ'),(16,'Metropark','Iselin','NJ'),(17,'South Amboy','South Amboy','NJ'),(18,'Aberdeen-Matawan','Matawan','NJ'),(19,'Red Bank','Red Bank','NJ'),(20,'Long Branch','Long Branch','NJ'),(21,'Bay Head','Bay Head','NJ'),(22,'Asbury Park','Asbury Park','NJ'),(23,'Edison','Edison','NJ'),(24,'Highland Park','Highland Park','NJ'),(25,'Metuchen','Metuchen','NJ');
/*!40000 ALTER TABLE `stations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stops`
--

DROP TABLE IF EXISTS `stops`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stops` (
  `stop_id` int NOT NULL AUTO_INCREMENT,
  `train_id` int NOT NULL,
  `station_id` int NOT NULL,
  `stop_number` int NOT NULL,
  `arrival_time` time DEFAULT NULL,
  `departure_time` time DEFAULT NULL,
  PRIMARY KEY (`stop_id`),
  KEY `train_id` (`train_id`),
  KEY `station_id` (`station_id`),
  CONSTRAINT `stops_ibfk_1` FOREIGN KEY (`train_id`) REFERENCES `train` (`train_id`),
  CONSTRAINT `stops_ibfk_2` FOREIGN KEY (`station_id`) REFERENCES `stations` (`station_id`)
) ENGINE=InnoDB AUTO_INCREMENT=332 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stops`
--

LOCK TABLES `stops` WRITE;
/*!40000 ALTER TABLE `stops` DISABLE KEYS */;
INSERT INTO `stops` VALUES (1,1,23,1,'05:15:00','05:25:00'),(2,1,22,2,'05:25:00','05:35:00'),(3,1,12,3,'05:35:00','05:45:00'),(4,1,15,4,'05:45:00','05:55:00'),(5,1,10,5,'05:55:00','06:05:00'),(6,1,14,6,'06:05:00','06:15:00'),(7,1,3,7,'06:15:00','06:25:00'),(8,1,2,8,'06:25:00','06:35:00'),(9,1,17,9,'06:35:00','06:45:00'),(10,1,8,10,'06:45:00','06:55:00'),(11,1,25,11,'06:55:00','07:05:00'),(12,1,5,12,'07:05:00','07:15:00'),(13,1,4,13,'07:15:00','07:25:00'),(14,1,18,14,'07:25:00','07:35:00'),(15,2,24,1,'06:59:00','07:07:00'),(16,2,8,2,'07:07:00','07:15:00'),(17,2,21,3,'07:15:00','07:23:00'),(18,2,22,4,'07:23:00','07:31:00'),(19,2,2,5,'07:31:00','07:39:00'),(20,2,20,6,'07:39:00','07:47:00'),(21,2,10,7,'07:47:00','07:55:00'),(22,2,12,8,'07:55:00','08:03:00'),(23,2,18,9,'08:03:00','08:11:00'),(24,2,16,10,'08:11:00','08:19:00'),(25,2,11,11,'08:19:00','08:27:00'),(26,2,4,12,'08:27:00','08:35:00'),(27,2,1,13,'08:35:00','08:43:00'),(28,2,15,14,'08:43:00','08:51:00'),(29,2,17,15,'08:51:00','08:59:00'),(30,2,23,16,'08:59:00','09:07:00'),(31,2,9,17,'09:07:00','09:15:00'),(32,2,25,18,'09:15:00','09:23:00'),(33,2,6,19,'09:23:00','09:31:00'),(34,3,24,1,'08:02:00','08:16:00'),(35,3,3,2,'08:16:00','08:30:00'),(36,3,23,3,'08:30:00','08:44:00'),(37,3,16,4,'08:44:00','08:58:00'),(38,3,17,5,'08:58:00','09:12:00'),(39,3,12,6,'09:12:00','09:26:00'),(40,3,11,7,'09:26:00','09:40:00'),(41,3,22,8,'09:40:00','09:54:00'),(42,3,25,9,'09:54:00','10:08:00'),(43,3,20,10,'10:08:00','10:22:00'),(44,3,9,11,'10:22:00','10:36:00'),(45,3,10,12,'10:36:00','10:50:00'),(46,3,5,13,'10:50:00','11:04:00'),(47,3,14,14,'11:04:00','11:18:00'),(48,3,21,15,'11:18:00','11:32:00'),(49,3,6,16,'11:32:00','11:46:00'),(50,3,13,17,'11:46:00','12:00:00'),(51,3,4,18,'12:00:00','12:14:00'),(52,4,10,1,'06:26:00','06:35:00'),(53,4,7,2,'06:35:00','06:44:00'),(54,4,14,3,'06:44:00','06:53:00'),(55,4,9,4,'06:53:00','07:02:00'),(56,4,25,5,'07:02:00','07:11:00'),(57,4,11,6,'07:11:00','07:20:00'),(58,4,5,7,'07:20:00','07:29:00'),(59,4,1,8,'07:29:00','07:38:00'),(60,4,23,9,'07:38:00','07:47:00'),(61,4,6,10,'07:47:00','07:56:00'),(62,4,12,11,'07:56:00','08:05:00'),(63,4,22,12,'08:05:00','08:14:00'),(64,4,4,13,'08:14:00','08:23:00'),(65,4,18,14,'08:23:00','08:32:00'),(66,4,8,15,'08:32:00','08:41:00'),(67,4,20,16,'08:41:00','08:50:00'),(68,4,15,17,'08:50:00','08:59:00'),(69,4,24,18,'08:59:00','09:08:00'),(70,4,2,19,'09:08:00','09:17:00'),(71,4,3,20,'09:17:00','09:26:00'),(72,5,20,1,'07:08:00','07:14:00'),(73,5,1,2,'07:14:00','07:20:00'),(74,5,3,3,'07:20:00','07:26:00'),(75,5,11,4,'07:26:00','07:32:00'),(76,5,12,5,'07:32:00','07:38:00'),(77,5,10,6,'07:38:00','07:44:00'),(78,5,4,7,'07:44:00','07:50:00'),(79,5,22,8,'07:50:00','07:56:00'),(80,5,16,9,'07:56:00','08:02:00'),(81,5,23,10,'08:02:00','08:08:00'),(82,5,24,11,'08:08:00','08:14:00'),(83,5,7,12,'08:14:00','08:20:00'),(84,5,9,13,'08:20:00','08:26:00'),(85,5,6,14,'08:26:00','08:32:00'),(86,5,17,15,'08:32:00','08:38:00'),(87,5,19,16,'08:38:00','08:44:00'),(88,5,13,17,'08:44:00','08:50:00'),(89,5,14,18,'08:50:00','08:56:00'),(90,6,13,1,'07:30:00','07:36:00'),(91,6,22,2,'07:36:00','07:42:00'),(92,6,11,3,'07:42:00','07:48:00'),(93,6,16,4,'07:48:00','07:54:00'),(94,6,9,5,'07:54:00','08:00:00'),(95,6,12,6,'08:00:00','08:06:00'),(96,6,20,7,'08:06:00','08:12:00'),(97,6,19,8,'08:12:00','08:18:00'),(98,6,3,9,'08:18:00','08:24:00'),(99,6,6,10,'08:24:00','08:30:00'),(100,6,2,11,'08:30:00','08:36:00'),(101,6,23,12,'08:36:00','08:42:00'),(102,6,18,13,'08:42:00','08:48:00'),(103,7,8,1,'07:04:00','07:10:00'),(104,7,3,2,'07:10:00','07:16:00'),(105,7,25,3,'07:16:00','07:22:00'),(106,7,20,4,'07:22:00','07:28:00'),(107,7,9,5,'07:28:00','07:34:00'),(108,7,4,6,'07:34:00','07:40:00'),(109,7,18,7,'07:40:00','07:46:00'),(110,7,11,8,'07:46:00','07:52:00'),(111,7,21,9,'07:52:00','07:58:00'),(112,7,15,10,'07:58:00','08:04:00'),(113,7,16,11,'08:04:00','08:10:00'),(114,7,2,12,'08:10:00','08:16:00'),(115,7,1,13,'08:16:00','08:22:00'),(116,7,5,14,'08:22:00','08:28:00'),(117,7,22,15,'08:28:00','08:34:00'),(118,7,7,16,'08:34:00','08:40:00'),(119,7,19,17,'08:40:00','08:46:00'),(120,7,24,18,'08:46:00','08:52:00'),(121,8,18,1,'07:37:00','07:50:00'),(122,8,2,2,'07:50:00','08:03:00'),(123,8,6,3,'08:03:00','08:16:00'),(124,8,3,4,'08:16:00','08:29:00'),(125,8,16,5,'08:29:00','08:42:00'),(126,8,21,6,'08:42:00','08:55:00'),(127,8,7,7,'08:55:00','09:08:00'),(128,8,22,8,'09:08:00','09:21:00'),(129,8,19,9,'09:21:00','09:34:00'),(130,8,25,10,'09:34:00','09:47:00'),(131,8,23,11,'09:47:00','10:00:00'),(132,8,10,12,'10:00:00','10:13:00'),(133,8,5,13,'10:13:00','10:26:00'),(134,8,17,14,'10:26:00','10:39:00'),(135,8,8,15,'10:39:00','10:52:00'),(136,8,4,16,'10:52:00','11:05:00'),(137,8,24,17,'11:05:00','11:18:00'),(138,9,24,1,'06:15:00','06:25:00'),(139,9,3,2,'06:25:00','06:35:00'),(140,9,20,3,'06:35:00','06:45:00'),(141,9,10,4,'06:45:00','06:55:00'),(142,9,7,5,'06:55:00','07:05:00'),(143,9,12,6,'07:05:00','07:15:00'),(144,9,2,7,'07:15:00','07:25:00'),(145,9,4,8,'07:25:00','07:35:00'),(146,9,25,9,'07:35:00','07:45:00'),(147,9,16,10,'07:45:00','07:55:00'),(148,9,21,11,'07:55:00','08:05:00'),(149,9,22,12,'08:05:00','08:15:00'),(150,9,18,13,'08:15:00','08:25:00'),(151,10,23,1,'05:51:00','06:01:00'),(152,10,7,2,'06:01:00','06:11:00'),(153,10,16,3,'06:11:00','06:21:00'),(154,10,4,4,'06:21:00','06:31:00'),(155,10,19,5,'06:31:00','06:41:00'),(156,10,6,6,'06:41:00','06:51:00'),(157,10,1,7,'06:51:00','07:01:00'),(158,10,22,8,'07:01:00','07:11:00'),(159,10,9,9,'07:11:00','07:21:00'),(160,10,18,10,'07:21:00','07:31:00'),(161,10,21,11,'07:31:00','07:41:00'),(162,10,8,12,'07:41:00','07:51:00'),(163,10,2,13,'07:51:00','08:01:00'),(164,10,13,14,'08:01:00','08:11:00'),(165,10,17,15,'08:11:00','08:21:00'),(166,11,9,1,'05:52:00','06:03:00'),(167,11,10,2,'06:03:00','06:14:00'),(168,11,8,3,'06:14:00','06:25:00'),(169,11,18,4,'06:25:00','06:36:00'),(170,11,11,5,'06:36:00','06:47:00'),(171,11,15,6,'06:47:00','06:58:00'),(172,11,2,7,'06:58:00','07:09:00'),(173,11,17,8,'07:09:00','07:20:00'),(174,11,24,9,'07:20:00','07:31:00'),(175,11,5,10,'07:31:00','07:42:00'),(176,11,7,11,'07:42:00','07:53:00'),(177,11,3,12,'07:53:00','08:04:00'),(178,11,23,13,'08:04:00','08:15:00'),(179,11,6,14,'08:15:00','08:26:00'),(180,11,14,15,'08:26:00','08:37:00'),(181,11,20,16,'08:37:00','08:48:00'),(182,12,24,1,'06:26:00','06:34:00'),(183,12,2,2,'06:34:00','06:42:00'),(184,12,25,3,'06:42:00','06:50:00'),(185,12,14,4,'06:50:00','06:58:00'),(186,12,16,5,'06:58:00','07:06:00'),(187,12,6,6,'07:06:00','07:14:00'),(188,12,13,7,'07:14:00','07:22:00'),(189,12,20,8,'07:22:00','07:30:00'),(190,12,12,9,'07:30:00','07:38:00'),(191,12,4,10,'07:38:00','07:46:00'),(192,12,5,11,'07:46:00','07:54:00'),(193,12,22,12,'07:54:00','08:02:00'),(194,12,21,13,'08:02:00','08:10:00'),(195,12,15,14,'08:10:00','08:18:00'),(196,12,18,15,'08:18:00','08:26:00'),(197,12,17,16,'08:26:00','08:34:00'),(198,12,23,17,'08:34:00','08:42:00'),(199,12,19,18,'08:42:00','08:50:00'),(200,13,24,1,'06:25:00','06:39:00'),(201,13,7,2,'06:39:00','06:53:00'),(202,13,4,3,'06:53:00','07:07:00'),(203,13,9,4,'07:07:00','07:21:00'),(204,13,2,5,'07:21:00','07:35:00'),(205,13,13,6,'07:35:00','07:49:00'),(206,13,25,7,'07:49:00','08:03:00'),(207,13,5,8,'08:03:00','08:17:00'),(208,13,21,9,'08:17:00','08:31:00'),(209,13,23,10,'08:31:00','08:45:00'),(210,13,8,11,'08:45:00','08:59:00'),(211,13,6,12,'08:59:00','09:13:00'),(212,13,1,13,'09:13:00','09:27:00'),(213,14,21,1,'05:53:00','06:01:00'),(214,14,16,2,'06:01:00','06:09:00'),(215,14,18,3,'06:09:00','06:17:00'),(216,14,14,4,'06:17:00','06:25:00'),(217,14,5,5,'06:25:00','06:33:00'),(218,14,8,6,'06:33:00','06:41:00'),(219,14,13,7,'06:41:00','06:49:00'),(220,14,11,8,'06:49:00','06:57:00'),(221,14,1,9,'06:57:00','07:05:00'),(222,14,19,10,'07:05:00','07:13:00'),(223,14,25,11,'07:13:00','07:21:00'),(224,14,7,12,'07:21:00','07:29:00'),(225,14,3,13,'07:29:00','07:37:00'),(226,14,15,14,'07:37:00','07:45:00'),(227,14,10,15,'07:45:00','07:53:00'),(228,14,22,16,'07:53:00','08:01:00'),(229,14,12,17,'08:01:00','08:09:00'),(230,14,20,18,'08:09:00','08:17:00'),(231,14,6,19,'08:17:00','08:25:00'),(232,14,17,20,'08:25:00','08:33:00'),(233,15,25,1,'06:40:00','06:52:00'),(234,15,2,2,'06:52:00','07:04:00'),(235,15,22,3,'07:04:00','07:16:00'),(236,15,18,4,'07:16:00','07:28:00'),(237,15,14,5,'07:28:00','07:40:00'),(238,15,11,6,'07:40:00','07:52:00'),(239,15,17,7,'07:52:00','08:04:00'),(240,15,10,8,'08:04:00','08:16:00'),(241,15,15,9,'08:16:00','08:28:00'),(242,15,20,10,'08:28:00','08:40:00'),(243,15,12,11,'08:40:00','08:52:00'),(244,15,8,12,'08:52:00','09:04:00'),(245,15,23,13,'09:04:00','09:16:00'),(246,15,19,14,'09:16:00','09:28:00'),(247,16,14,1,'06:02:00','06:10:00'),(248,16,13,2,'06:10:00','06:18:00'),(249,16,18,3,'06:18:00','06:26:00'),(250,16,23,4,'06:26:00','06:34:00'),(251,16,12,5,'06:34:00','06:42:00'),(252,16,17,6,'06:42:00','06:50:00'),(253,16,19,7,'06:50:00','06:58:00'),(254,16,2,8,'06:58:00','07:06:00'),(255,16,8,9,'07:06:00','07:14:00'),(256,16,6,10,'07:14:00','07:22:00'),(257,16,10,11,'07:22:00','07:30:00'),(258,16,9,12,'07:30:00','07:38:00'),(259,16,15,13,'07:38:00','07:46:00'),(260,16,20,14,'07:46:00','07:54:00'),(261,17,14,1,'05:42:00','05:57:00'),(262,17,16,2,'05:57:00','06:12:00'),(263,17,18,3,'06:12:00','06:27:00'),(264,17,21,4,'06:27:00','06:42:00'),(265,17,24,5,'06:42:00','06:57:00'),(266,17,11,6,'06:57:00','07:12:00'),(267,17,15,7,'07:12:00','07:27:00'),(268,17,2,8,'07:27:00','07:42:00'),(269,17,25,9,'07:42:00','07:57:00'),(270,17,12,10,'07:57:00','08:12:00'),(271,17,7,11,'08:12:00','08:27:00'),(272,17,1,12,'08:27:00','08:42:00'),(273,17,9,13,'08:42:00','08:57:00'),(274,17,8,14,'08:57:00','09:12:00'),(275,17,4,15,'09:12:00','09:27:00'),(276,17,19,16,'09:27:00','09:42:00'),(277,17,17,17,'09:42:00','09:57:00'),(278,17,5,18,'09:57:00','10:12:00'),(279,17,20,19,'10:12:00','10:27:00'),(280,18,14,1,'06:28:00','06:34:00'),(281,18,1,2,'06:34:00','06:40:00'),(282,18,2,3,'06:40:00','06:46:00'),(283,18,8,4,'06:46:00','06:52:00'),(284,18,16,5,'06:52:00','06:58:00'),(285,18,6,6,'06:58:00','07:04:00'),(286,18,23,7,'07:04:00','07:10:00'),(287,18,3,8,'07:10:00','07:16:00'),(288,18,12,9,'07:16:00','07:22:00'),(289,18,15,10,'07:22:00','07:28:00'),(290,18,24,11,'07:28:00','07:34:00'),(291,18,18,12,'07:34:00','07:40:00'),(292,18,5,13,'07:40:00','07:46:00'),(293,18,7,14,'07:46:00','07:52:00'),(294,18,22,15,'07:52:00','07:58:00'),(295,19,11,1,'07:27:00','07:39:00'),(296,19,21,2,'07:39:00','07:51:00'),(297,19,17,3,'07:51:00','08:03:00'),(298,19,12,4,'08:03:00','08:15:00'),(299,19,13,5,'08:15:00','08:27:00'),(300,19,23,6,'08:27:00','08:39:00'),(301,19,10,7,'08:39:00','08:51:00'),(302,19,18,8,'08:51:00','09:03:00'),(303,19,9,9,'09:03:00','09:15:00'),(304,19,20,10,'09:15:00','09:27:00'),(305,19,7,11,'09:27:00','09:39:00'),(306,19,24,12,'09:39:00','09:51:00'),(307,19,22,13,'09:51:00','10:03:00'),(308,19,14,14,'10:03:00','10:15:00'),(309,19,2,15,'10:15:00','10:27:00'),(310,19,8,16,'10:27:00','10:39:00'),(311,19,16,17,'10:39:00','10:51:00'),(312,19,6,18,'10:51:00','11:03:00'),(313,20,2,1,'05:39:00','05:46:00'),(314,20,9,2,'05:46:00','05:53:00'),(315,20,7,3,'05:53:00','06:00:00'),(316,20,13,4,'06:00:00','06:07:00'),(317,20,20,5,'06:07:00','06:14:00'),(318,20,17,6,'06:14:00','06:21:00'),(319,20,22,7,'06:21:00','06:28:00'),(320,20,3,8,'06:28:00','06:35:00'),(321,20,4,9,'06:35:00','06:42:00'),(322,20,8,10,'06:42:00','06:49:00'),(323,20,18,11,'06:49:00','06:56:00'),(324,20,24,12,'06:56:00','07:03:00'),(325,20,12,13,'07:03:00','07:10:00'),(326,20,25,14,'07:10:00','07:17:00'),(327,20,16,15,'07:17:00','07:24:00'),(328,20,10,16,'07:24:00','07:31:00'),(329,20,14,17,'07:31:00','07:38:00'),(330,20,23,18,'07:38:00','07:45:00'),(331,20,1,19,'07:45:00','07:52:00');
/*!40000 ALTER TABLE `stops` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `train`
--

DROP TABLE IF EXISTS `train`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `train` (
  `train_id` int NOT NULL AUTO_INCREMENT,
  `line_name` varchar(255) NOT NULL,
  `num_stops` int NOT NULL,
  `total_fare` decimal(10,2) NOT NULL,
  `total_travel_time` time NOT NULL,
  `origin_station_id` int DEFAULT NULL,
  `destination_station_id` int DEFAULT NULL,
  PRIMARY KEY (`train_id`),
  KEY `origin_station_id` (`origin_station_id`),
  KEY `destination_station_id` (`destination_station_id`),
  CONSTRAINT `train_ibfk_1` FOREIGN KEY (`origin_station_id`) REFERENCES `stations` (`station_id`),
  CONSTRAINT `train_ibfk_2` FOREIGN KEY (`destination_station_id`) REFERENCES `stations` (`station_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `train`
--

LOCK TABLES `train` WRITE;
/*!40000 ALTER TABLE `train` DISABLE KEYS */;
INSERT INTO `train` VALUES (1,'Line 1',14,23.00,'05:00:00',23,18),(2,'Line 2',19,26.00,'05:00:00',24,6),(3,'Line 3',18,29.00,'05:00:00',24,4),(4,'Line 4',20,32.00,'05:00:00',10,3),(5,'Line 5',18,35.00,'05:00:00',20,14),(6,'Line 6',13,38.00,'05:00:00',13,18),(7,'Line 7',18,41.00,'05:00:00',8,24),(8,'Line 8',17,44.00,'05:00:00',18,24),(9,'Line 9',13,47.00,'05:00:00',24,18),(10,'Line 10',15,50.00,'05:00:00',23,17),(11,'Line 11',16,53.00,'05:00:00',9,20),(12,'Line 12',18,56.00,'05:00:00',24,19),(13,'Line 13',13,59.00,'05:00:00',24,1),(14,'Line 14',20,62.00,'05:00:00',21,17),(15,'Line 15',14,65.00,'05:00:00',25,19),(16,'Line 16',14,68.00,'05:00:00',14,20),(17,'Line 17',19,71.00,'05:00:00',14,20),(18,'Line 18',15,74.00,'05:00:00',14,22),(19,'Line 19',18,77.00,'05:00:00',11,6),(20,'Line 20',19,80.00,'05:00:00',2,1);
/*!40000 ALTER TABLE `train` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `username` varchar(50) NOT NULL,
  `password` char(60) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `first_name` varchar(60) DEFAULT NULL,
  `last_name` varchar(60) DEFAULT NULL,
  `role` enum('customer','representative','manager') NOT NULL DEFAULT 'customer',
  `user_id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username_email` (`username`, `email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('noorRep','repPassword123','representativeMail@gmail.com','Rep','Resentative','representative',1),('noor123','noor2020','noorMail@gmailc.om','Noor','Mashal','customer',2),('manager','manager123','manager@gmail.com','manager','themanager','manager',3),('customer2','noor','noordin@gmail.com','Noor2','Mashal2','customer',4);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-10  5:22:18
