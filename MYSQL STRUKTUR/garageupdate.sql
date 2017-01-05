-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server Version:               10.1.19-MariaDB - mariadb.org binary distribution
-- Server Betriebssystem:        Win32
-- HeidiSQL Version:             9.4.0.5125
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Exportiere Datenbank Struktur für ultimate_remake
CREATE DATABASE IF NOT EXISTS `ultimate_remake` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `ultimate_remake`;

-- Exportiere Struktur von Tabelle ultimate_remake.garage_system
CREATE TABLE IF NOT EXISTS `garage_system` (
  `id` int(11) DEFAULT NULL,
  `garagepos` varchar(255) DEFAULT '|0|0|0|0',
  `doorpos` varchar(255) DEFAULT '|0|0|0|0',
  `ownedby` varchar(255) DEFAULT 'none',
  `buyprice` int(11) DEFAULT '0',
  `sellprice` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportiere Daten aus Tabelle ultimate_remake.garage_system: ~1 rows (ungefähr)
/*!40000 ALTER TABLE `garage_system` DISABLE KEYS */;
REPLACE INTO `garage_system` (`id`, `garagepos`, `doorpos`, `ownedby`, `buyprice`, `sellprice`) VALUES
	(1, '|-2005.9000244141|213.10000610352|28.799999237061|180', '|-2005.9000244141|208.80000305176|28.299999237061|90', 'Zuck3rFr3i', 250000, 150000);
/*!40000 ALTER TABLE `garage_system` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
