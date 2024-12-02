DROP DATABASE IF EXISTS location_ski;

CREATE DATABASE location_ski CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE location_ski;

-- -----------------------------------------------------
-- Table `location_ski`.`clients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `location_ski`.`clients` (
  `noCli` INT NOT NULL,
  `nom` VARCHAR(30) NOT NULL,
  `prenom` VARCHAR(30) NULL,
  `adresse` VARCHAR(120) NULL,
  `cpo` VARCHAR(5) NOT NULL,
  `ville` VARCHAR(80) NOT NULL,
  PRIMARY KEY (`noCli`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `location_ski`.`fiches`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `location_ski`.`fiches` (
  `noFic` INT NOT NULL,
  `dateCrea` DATE NOT NULL,
  `datePaiement` DATE NULL,
  `etat` ENUM('SO', 'EC', 'RE') NOT NULL,
  `noCli` INT NOT NULL,
  PRIMARY KEY (`noFic`),
  INDEX `fk_fiches_clients1_idx` (`noCli` ASC) VISIBLE,
  CONSTRAINT `fk_fiches_clients1`
    FOREIGN KEY (`noCli`)
    REFERENCES `location_ski`.`clients` (`noCli`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `location_ski`.`categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `location_ski`.`categories` (
  `codeCate` CHAR(5) NOT NULL,
  `libelle` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`codeCate`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `location_ski`.`gammes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `location_ski`.`gammes` (
  `codeGam` CHAR(5) NOT NULL,
  `libelle` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`codeGam`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `location_ski`.`articles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `location_ski`.`articles` (
  `refart` CHAR(8) NOT NULL,
  `designation` VARCHAR(80) NOT NULL,
  `codeCate` CHAR(5) NULL,
  `codeGam` CHAR(5) NULL,
  PRIMARY KEY (`refart`),
  INDEX `fk_articles_categories1_idx` (`codeCate` ASC) VISIBLE,
  INDEX `fk_articles_gammes1_idx` (`codeGam` ASC) VISIBLE,
  CONSTRAINT `fk_articles_categories1`
    FOREIGN KEY (`codeCate`)
    REFERENCES `location_ski`.`categories` (`codeCate`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_articles_gammes1`
    FOREIGN KEY (`codeGam`)
    REFERENCES `location_ski`.`gammes` (`codeGam`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `location_ski`.`lignesFic`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `location_ski`.`lignesFic` (
  `noLig` INT NOT NULL,
  `depart` DATE NOT NULL,
  `retour` DATE NULL,
  `noFic` INT NOT NULL,
  `refart` CHAR(8) NOT NULL,
  PRIMARY KEY (`noLig`, `noFic`),
  INDEX `fk_lignesFic_fiches1_idx` (`noFic` ASC) VISIBLE,
  INDEX `fk_lignesFic_articles1_idx` (`refart` ASC) VISIBLE,
  CONSTRAINT `fk_lignesFic_fiches1`
    FOREIGN KEY (`noFic`)
    REFERENCES `location_ski`.`fiches` (`noFic`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_lignesFic_articles1`
    FOREIGN KEY (`refart`)
    REFERENCES `location_ski`.`articles` (`refart`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `location_ski`.`tarifs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `location_ski`.`tarifs` (
  `codeTarif` CHAR(5) NOT NULL,
  `libelle` VARCHAR(30) NOT NULL,
  `prixJour` DECIMAL NOT NULL,
  PRIMARY KEY (`codeTarif`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `location_ski`.`grilleTarifs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `location_ski`.`grilleTarifs` (
  `codeGam` CHAR(5) NOT NULL,
  `codeCate` CHAR(5) NOT NULL,
  `codeTarif` CHAR(5) NULL,
  PRIMARY KEY (`codeGam`, `codeCate`),
  INDEX `fk_grilleTarifs_categories1_idx` (`codeCate` ASC) VISIBLE,
  INDEX `fk_grilleTarifs_tarifs1_idx` (`codeTarif` ASC) VISIBLE,
  CONSTRAINT `fk_grilleTarifs_gammes1`
    FOREIGN KEY (`codeGam`)
    REFERENCES `location_ski`.`gammes` (`codeGam`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_grilleTarifs_categories1`
    FOREIGN KEY (`codeCate`)
    REFERENCES `location_ski`.`categories` (`codeCate`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_grilleTarifs_tarifs1`
    FOREIGN KEY (`codeTarif`)
    REFERENCES `location_ski`.`tarifs` (`codeTarif`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- 1️⃣ Liste des clients (toutes les informations) dont le nom commence par un D
SELECT * FROM clients WHERE nom LIKE 'D%';

-- 2️⃣ Nom et prénom de tous les clients
SELECT prenom, nom FROM clients;

-- 3️⃣ Liste des fiches (n°, état) pour les clients (nom, prénom) qui habitent en Loire Atlantique (44)
SELECT fiches.noFic, fiches.etat, clients.nom, clients.prenom
FROM fiches
JOIN clients ON fiches.noCli = clients.noCli
WHERE clients.cpo = '44000';

-- 4️⃣ Détail de la fiche n°1002
SELECT fiches.noFic, clients.nom, clients.prenom, articles.refart, articles.designation, lignesFic.depart, lignesFic.retour, tarifs.prixJour, (tarifs.prixJour * DATEDIFF(IFNULL(lignesFic.retour, NOW()), lignesFic.depart)) AS montant
FROM fiches
JOIN clients ON fiches.noCli = clients.noCli
JOIN lignesFic ON fiches.noFic = lignesFic.noFic
JOIN articles ON lignesFic.refart = articles.refart
JOIN grilleTarifs ON articles.codeCate = grilleTarifs.codeCate AND articles.codeGam = grilleTarifs.codeGam
JOIN tarifs ON grilleTarifs.codeTarif = tarifs.codeTarif
WHERE fiches.noFic = 1002;

-- 6️⃣ Détail de la fiche n°1002 avec le total
SELECT fiches.noFic, clients.nom, clients.prenom, articles.refart, articles.designation, lignesFic.depart, lignesFic.retour, tarifs.prixJour, (tarifs.prixJour * DATEDIFF(IFNULL(lignesFic.retour, NOW()), lignesFic.depart)) AS montant,
SUM(tarifs.prixJour * DATEDIFF(IFNULL(lignesFic.retour, NOW()), lignesFic.depart)) OVER (PARTITION BY fiches.noFic) AS Total
FROM fiches
JOIN clients ON fiches.noCli = clients.noCli
JOIN lignesFic ON fiches.noFic = lignesFic.noFic
JOIN articles ON lignesFic.refart = articles.refart
JOIN grilleTarifs ON articles.codeCate = grilleTarifs.codeCate AND articles.codeGam = grilleTarifs.codeGam
JOIN tarifs ON grilleTarifs.codeTarif = tarifs.codeTarif
WHERE fiches.noFic = 1002;

-- 7️⃣ Grille des tarifs
SELECT categories.libelle AS categorie, gammes.libelle AS gamme, tarifs.libelle AS tarif, tarifs.prixJour
FROM grilleTarifs
JOIN categories ON grilleTarifs.codeCate = categories.codeCate
JOIN gammes ON grilleTarifs.codeGam = gammes.codeGam
JOIN tarifs ON grilleTarifs.codeTarif = tarifs.codeTarif;

-- 9️⃣ Calcul du nombre moyen d’articles loués par fiche de location
SELECT AVG(nb_lignes) AS nb_lignes_moyen_par_fiche
FROM (
    SELECT COUNT(*) AS nb_lignes
    FROM lignesFic
    GROUP BY noFic
) AS lignes_par_fiche;