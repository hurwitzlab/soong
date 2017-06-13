-- MySQL dump 10.13  Distrib 5.7.17, for Linux (x86_64)
--
-- Host: localhost    Database: soong
-- ------------------------------------------------------
-- Server version	5.7.17

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
-- Table structure for table `bam_file`
--

DROP TABLE IF EXISTS `bam_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bam_file` (
  `bam_file_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `seq_run_id` int(10) unsigned NOT NULL,
  `publication_id` int(10) unsigned NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `qc_command` text,
  `num_total_reads` int(10) unsigned DEFAULT NULL,
  `num_mapped_reads` int(10) unsigned DEFAULT NULL,
  `culture_result` text,
  `other_results` text,
  `analyses` text,
  PRIMARY KEY (`bam_file_id`),
  UNIQUE KEY `seq_run_id` (`seq_run_id`,`file_name`),
  KEY `seq_run_id_2` (`seq_run_id`),
  KEY `publication_id` (`publication_id`),
  CONSTRAINT `bam_file_ibfk_1` FOREIGN KEY (`seq_run_id`) REFERENCES `seq_run` (`seq_run_id`) ON DELETE CASCADE,
  CONSTRAINT `bam_file_ibfk_2` FOREIGN KEY (`publication_id`) REFERENCES `publication` (`publication_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=242 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `project`
--

DROP TABLE IF EXISTS `project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project` (
  `project_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `project_name` varchar(100) NOT NULL,
  PRIMARY KEY (`project_id`),
  UNIQUE KEY `project_name` (`project_name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `publication`
--

DROP TABLE IF EXISTS `publication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `publication` (
  `publication_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `publication_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`publication_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample`
--

DROP TABLE IF EXISTS `sample`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample` (
  `sample_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `project_id` int(10) unsigned NOT NULL,
  `seq_type_id` int(10) unsigned NOT NULL DEFAULT '1',
  `sample_name` varchar(100) NOT NULL,
  `sample_num` varchar(100) DEFAULT NULL,
  `barcode` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`sample_id`),
  UNIQUE KEY `project_id` (`project_id`,`sample_name`),
  KEY `project_id_2` (`project_id`),
  KEY `seq_type_id` (`seq_type_id`),
  CONSTRAINT `sample_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`) ON DELETE CASCADE,
  CONSTRAINT `sample_ibfk_2` FOREIGN KEY (`seq_type_id`) REFERENCES `seq_type` (`seq_type_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=120 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seq_run`
--

DROP TABLE IF EXISTS `seq_run`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seq_run` (
  `seq_run_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sample_id` int(10) unsigned NOT NULL,
  `run_on_sequencer` varchar(255) DEFAULT NULL,
  `report` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`seq_run_id`),
  KEY `sample_id` (`sample_id`),
  CONSTRAINT `seq_run_ibfk_1` FOREIGN KEY (`sample_id`) REFERENCES `sample` (`sample_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seq_type`
--

DROP TABLE IF EXISTS `seq_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seq_type` (
  `seq_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(100) NOT NULL,
  PRIMARY KEY (`seq_type_id`),
  UNIQUE KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-06-13 13:09:46
