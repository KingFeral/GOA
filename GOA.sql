SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

SET CHARACTER SET utf8;

CREATE SCHEMA IF NOT EXISTS `GOA` DEFAULT CHARACTER SET utf8 ;
SHOW WARNINGS;
USE `GOA`;

-- -----------------------------------------------------
-- Table `factions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `factions` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `factions` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `leader` INT UNSIGNED NULL DEFAULT NULL ,
  `name` VARCHAR(50) NOT NULL ,
  `village` VARCHAR(50) NOT NULL ,
  `mouse_icon` VARCHAR(50) NULL DEFAULT NULL ,
  `chat_icon` VARCHAR(50) NOT NULL ,
  `chuunin_item` INT UNSIGNED NULL DEFAULT NULL ,
  `member_limit` INT UNSIGNED NULL DEFAULT 0 ,
  `land_kanji` VARCHAR(50) CHARACTER SET utf8 NOT NULL DEFAULT '無',
  `village_kanji` VARCHAR(50) CHARACTER SET utf8 NOT NULL DEFAULT '抜け忍',
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_factions_players`
    FOREIGN KEY (`leader` )
    REFERENCES `players` (`id` )
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

DELIMITER |
CREATE TRIGGER set_kanji BEFORE INSERT ON factions FOR EACH ROW BEGIN IF NEW.village = 'Konoha' THEN SET NEW.land_kanji = '火'; SET NEW.village_kanji = '木ノ葉'; ELSEIF NEW.village = 'Kiri' THEN SET NEW.land_kanji = '水'; SET NEW.village_kanji = '霧'; ELSEIF NEW.village = 'Suna' THEN SET NEW.land_kanji = '風'; SET NEW.village_kanji = '砂'; END IF; END;|
DELIMITER ;
-- -----------------------------------------------------
-- Data for table `factions`
-- -----------------------------------------------------
SET AUTOCOMMIT=0;
INSERT INTO `factions` (`id`, `leader`, `name`, `village`, `mouse_icon`, `chat_icon`, `chuunin_item`, `member_limit`, `land_kanji`, `village_kanji`) VALUES (NULL, NULL, 'Missing', 'Missing', NULL, 'Missing', NULL, 0, '無', '抜け忍');
INSERT INTO `factions` (`id`, `leader`, `name`, `village`, `mouse_icon`, `chat_icon`, `chuunin_item`, `member_limit`, `land_kanji`, `village_kanji`) VALUES (NULL, NULL, 'Konohagakure', 'Konoha', 'Konoha', 'Konoha', 224, 0, '火', '木ノ葉');
INSERT INTO `factions` (`id`, `leader`, `name`, `village`, `mouse_icon`, `chat_icon`, `chuunin_item`, `member_limit`, `land_kanji`, `village_kanji`) VALUES (NULL, NULL, 'Kirigakure', 'Kiri', 'Kiri', 'Kiri', 226, 0, '水', '霧');
INSERT INTO `factions` (`id`, `leader`, `name`, `village`, `mouse_icon`, `chat_icon`, `chuunin_item`, `member_limit`, `land_kanji`, `village_kanji`) VALUES (NULL, NULL, 'Sunagakure', 'Suna', 'Suna', 'Suna', 225, 0, '風', '砂');

COMMIT;
CREATE INDEX fk_factions_players ON `factions` (`leader` ASC) ;

SHOW WARNINGS;
CREATE UNIQUE INDEX name ON `factions` (`name` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `players`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `players` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `players` (
  `id` INT UNSIGNED NOT NULL DEFAULT NULL AUTO_INCREMENT ,
  `ezing` TINYINT UNSIGNED NULL DEFAULT NULL ,
  `mission_cool` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `handle_changes` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `survivalist_cooldown` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `mutevote_cooldown` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `vote_cooldown` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `faction_points` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `headband_position` TINYINT UNSIGNED NULL DEFAULT NULL ,
  `missions_d` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `missions_c` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `missions_b` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `missions_a` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `missions_s` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `bounty` FLOAT UNSIGNED NULL DEFAULT NULL ,
  `hair_color` CHAR(8) NOT NULL DEFAULT '#000000' ,
  `hair_type` TINYINT UNSIGNED NULL DEFAULT NULL ,
  `control` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `strength` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `intelligence` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `reflex` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `skill_points` FLOAT UNSIGNED NULL DEFAULT NULL ,
  `level_points` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `money` FLOAT UNSIGNED NULL DEFAULT NULL ,
  `stamina` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `current_stamina` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `chakra` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `current_chakra` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `max_wounds` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `current_wounds` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `body_points` FLOAT UNSIGNED NULL DEFAULT NULL ,
  `body_level` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `kod` TINYINT UNSIGNED NULL DEFAULT NULL ,
  `x` SMALLINT UNSIGNED NOT NULL ,
  `y` SMALLINT UNSIGNED NOT NULL ,
  `z` SMALLINT UNSIGNED NOT NULL ,
  `last_hosted_chuunin_time` VARCHAR(50) NULL DEFAULT NULL ,
  `handle` VARCHAR(50) NULL DEFAULT NULL ,
  `last_hostile_key` VARCHAR(50) NULL DEFAULT NULL ,
  `rank` VARCHAR(50) NOT NULL ,
  `icon` VARCHAR(50) NOT NULL ,
  `name` VARCHAR(50) NOT NULL ,
  `ckey` VARCHAR(50) NOT NULL ,
  `clan` VARCHAR(50) NOT NULL DEFAULT '' ,
  `skills_passive` LONGTEXT NOT NULL ,
  `puppet1` LONGTEXT NOT NULL ,
  `puppet2` LONGTEXT NOT NULL ,
  `puppet3` LONGTEXT NOT NULL ,
  `equipped` LONGTEXT NOT NULL ,
  `inventory` LONGTEXT NOT NULL ,
  `custmac` LONGTEXT NOT NULL ,
  `elements` LONGTEXT NOT NULL ,
  `macro1` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `macro2` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `macro3` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `macro4` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `macro5` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `macro6` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `macro7` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `macro8` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `macro9` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `macro10` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `squad` INT UNSIGNED NULL DEFAULT NULL ,
  `faction` INT UNSIGNED NOT NULL ,
  `supplies` SMALLINT UNSIGNED NULL DEFAULT NULL ,
  `comment_konoha` LONGTEXT NULL DEFAULT NULL ,
  `comment_kiri` LONGTEXT NULL DEFAULT NULL ,
  `comment_suna` LONGTEXT NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_players_squads`
    FOREIGN KEY (`squad` )
    REFERENCES `squads` (`id` )
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_players_factions`
    FOREIGN KEY (`faction` )
    REFERENCES `factions` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX name ON `players` (`name` ASC) ;

SHOW WARNINGS;
CREATE INDEX fk_players_squads ON `players` (`squad` ASC) ;

SHOW WARNINGS;
CREATE INDEX fk_players_factions ON `players` (`faction` ASC) ;

SHOW WARNINGS;
CREATE INDEX `key` ON `players` (`ckey` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `squads`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `squads` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `squads` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `leader` INT UNSIGNED NOT NULL ,
  `name` VARCHAR(50) NOT NULL ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_squads_players`
    FOREIGN KEY (`leader` )
    REFERENCES `players` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX fk_squads_players ON `squads` (`leader` ASC);

SHOW WARNINGS;
CREATE UNIQUE INDEX name ON `squads` (`name` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `skills`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `skills` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `skills` (
  `id` INT UNSIGNED NOT NULL ,
  `player` INT UNSIGNED NOT NULL ,
  `cooldown` INT UNSIGNED NOT NULL DEFAULT 0 ,
  `uses` INT UNSIGNED NOT NULL DEFAULT 0 ,
  KEY (`id`) ,
  KEY (`player`) ,
  UNIQUE KEY (`id`, `player`) ,
  CONSTRAINT `fk_skills_players`
    FOREIGN KEY (`player`)
    REFERENCES `players` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX fk_skills_players ON `skills` (`player` ASC);

-- -----------------------------------------------------
-- Table `key_bans`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `key_bans` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `key_bans` (
  `key` VARCHAR(50) NOT NULL ,
  PRIMARY KEY (`key`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `ip_bans`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `computer_bans` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `computer_bans` (
  `computer_id` VARCHAR(20) NOT NULL ,
  PRIMARY KEY (`computer_id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `key_ip_pairs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `key_computer_pairs` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `key_computer_pairs` (
  `key` VARCHAR(50) NOT NULL ,
  `computer_id` VARCHAR(20) NOT NULL ,
  PRIMARY KEY(`key`, `computer_id`),
  CONSTRAINT `fk_key_bans`
    FOREIGN KEY (`key` )
    REFERENCES `key_bans` (`key` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_computer_bans`
    FOREIGN KEY (`computer_id` )
    REFERENCES `computer_bans` (`computer_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE);

SHOW WARNINGS;
CREATE INDEX fk_key_bans ON `key_computer_pairs` (`key` ASC) ;

SHOW WARNINGS;
CREATE INDEX fk_computer_bans ON `key_computer_pairs` (`computer_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `economy`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `economy` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `economy` (
  `time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  `inflation_rate` SMALLINT UNSIGNED NOT NULL ,
  `per_capita_savings` FLOAT UNSIGNED NOT NULL ,
  `per_capita_spending` FLOAT UNSIGNED NOT NULL ,
  PRIMARY KEY (`time`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `allowed_servers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `allowed_servers` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `allowed_servers` (
  `ip` VARCHAR(20) NOT NULL ,
  PRIMARY KEY (`ip`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `helpers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `helpers` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `helpers` (
  `helper` INT UNSIGNED NOT NULL ,
  `village` INT UNSIGNED NOT NULL ,
  CONSTRAINT `fk_helpers_players`
    FOREIGN KEY (`helper` )
    REFERENCES `players` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_helpers_factions`
    FOREIGN KEY (`village` )
    REFERENCES `factions` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX fk_helpers_players ON `helpers` (`helper` ASC);

SHOW WARNINGS;
CREATE INDEX fk_helpers_factions ON `helpers` (`village` ASC) ;

SHOW WARNINGS;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
