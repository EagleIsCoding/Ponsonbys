INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_ponsonbys', 'Ponsobys', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_ponsonbys', 'Ponsobys', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_ponsonbys', 'Ponsobys', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('ponsonbys', 'Ponsobys')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('ponsonbys',0,'recruit','Recrue',20,'{}','{}'),
	('ponsonbys',1,'boss','Patron',100,'{}','{}')
;

CREATE TABLE `clothes_ponsonbys` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`label` VARCHAR(100) NOT NULL COLLATE 'utf8mb4_general_ci',
	`value` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`type` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=79
;

CREATE TABLE `player_clothes` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(100) NOT NULL COLLATE 'utf8mb4_general_ci',
	`label` VARCHAR(100) NOT NULL COLLATE 'utf8mb4_general_ci',
	`value` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=223
;
