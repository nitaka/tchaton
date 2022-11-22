-- MySQL dump 10.13  Distrib 8.0.31, for Win64 (x86_64)
--
-- Host: localhost    Database: tchaton
-- ------------------------------------------------------
-- Server version	8.0.31

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
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `idComment` int NOT NULL AUTO_INCREMENT,
  `comment` varchar(500) NOT NULL,
  `authorId` int NOT NULL,
  `postId` int NOT NULL,
  PRIMARY KEY (`idComment`),
  KEY `authorId_idx` (`authorId`),
  KEY `postId_idx` (`postId`),
  CONSTRAINT `author` FOREIGN KEY (`authorId`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `postId` FOREIGN KEY (`postId`) REFERENCES `post` (`postId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
INSERT INTO `comment` VALUES (13,'Nice :D !',28,26),(14,'furssshhhhhh !',30,27);
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `like`
--

DROP TABLE IF EXISTS `like`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `like` (
  `likeId` int NOT NULL AUTO_INCREMENT,
  `postId` int NOT NULL,
  `userId` int NOT NULL,
  PRIMARY KEY (`likeId`),
  KEY `postId_idx` (`postId`),
  KEY `userIdlike_idx` (`userId`),
  CONSTRAINT `postIdlikes` FOREIGN KEY (`postId`) REFERENCES `post` (`postId`) ON DELETE CASCADE,
  CONSTRAINT `userIdlike` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `like`
--

LOCK TABLES `like` WRITE;
/*!40000 ALTER TABLE `like` DISABLE KEYS */;
INSERT INTO `like` VALUES (45,25,28),(46,26,28),(47,27,30);
/*!40000 ALTER TABLE `like` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post`
--

DROP TABLE IF EXISTS `post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post` (
  `postId` int NOT NULL AUTO_INCREMENT,
  `text` varchar(300) DEFAULT NULL,
  `imageUrl` varchar(300) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `like` int DEFAULT '0',
  `authorId` int NOT NULL,
  `comment` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`postId`),
  KEY `authorId_idx` (`authorId`),
  CONSTRAINT `authorId` FOREIGN KEY (`authorId`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post`
--

LOCK TABLES `post` WRITE;
/*!40000 ALTER TABLE `post` DISABLE KEYS */;
INSERT INTO `post` VALUES (25,'Bienvenue sur Tchaton-dev :)','http://localhost:3000/images/post/image1668612574708.png','2022-11-16 16:29:34',1,28,0),(26,'😎🤣🤣','http://localhost:3000/images/post/image1668619502378.jpg','2022-11-16 18:25:02',1,29,1),(27,'Go Mars XD !','http://localhost:3000/images/post/image1669147648216.jpg','2022-11-22 21:07:28',1,30,1);
/*!40000 ALTER TABLE `post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(45) NOT NULL,
  `prenom` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `password` varchar(250) NOT NULL,
  `imgProfil` varchar(500) DEFAULT NULL,
  `admin` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'Admin','admin','admin@admin.com','$2b$10$B2ds3jdGRJ0UabR1CGBXc.PF.sC6GXru/ARU2B9LSwgBbgFulKaOi','http://localhost:3000/images/profil/image1645717383544.jpg',1),(9,'Noisette','Boby','bob@gmail.com','$2b$10$9PmdHNArVI9YBuDeXBbB5.SVEl3VdgvFi2oQtL3rSaNzxND1CZ64m','http://localhost:3000/images/profil/image1645806972879.jpg',0),(28,'Nita','Kala','nita@gmail.com','$2b$10$JNa/N18AGQn6fk.EuInGPekvLV0owULn.A17MuRrEKYa1ziFGDsxK','http://localhost:3000/images/profil/image1668619914864.jpg',0),(29,'Ashil','Omega','ashil@gmail.com','$2b$10$tkIYKg0e1mpMCrhfEgwuReJ3HnaksvkDpqLY/W3BS4Oqk0vtLVnYO','http://localhost:3000/images/profil/image1668619247120.png',0),(30,'Elon','Musk','spacex@gmail.com','$2b$10$qWZt1PLY1O4ERxwkVzxaJu23LXNuspcfGGrmx3f3I55W3O7hQEGd.','http://localhost:3000/images/profil/image1669147529474.jpg',0);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-11-22 22:24:32
