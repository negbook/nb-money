CREATE TABLE IF NOT EXISTS `money` (
  `license` varchar(200) NOT NULL DEFAULT '0',
  `cash` int(200) NOT NULL DEFAULT '0',
  `bank` int(200) NOT NULL DEFAULT '0',
  `cryto` int(200) NOT NULL DEFAULT '0',
  PRIMARY KEY (`license`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;