CREATE TABLE `money` (
	`license` VARCHAR(200) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
	`cash` INT(200) NULL DEFAULT NULL,
	`bank` INT(200) NULL DEFAULT NULL,
    `cryto` INT(200) NULL DEFAULT NULL
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;
