CREATE TABLE IF NOT EXISTS `player_xp` (
    `identifier` varchar(60) NOT NULL,
    `xp` int(11) NOT NULL DEFAULT 0,
    `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY (`identifier`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `player_xpLog` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(60) NOT NULL,
    `type` varchar(60) DEFAULT '/',
    `change` varchar(60) DEFAULT '/',
    `oldXP` int(11) NOT NULL,
    `newXP` int(11) NOT NULL,
    `reason` varchar(120) DEFAULT '/',
    `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`identifier`) REFERENCES `player_xp`(`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=1;