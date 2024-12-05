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


-- 1. Liste des clients (nom, prénom, adresse, code postal, ville) ayant au moins une fiche de location en cours.
SELECT DISTINCT clients.nom, clients.prenom, clients.adresse, clients.cpo, clients.ville
FROM clients
JOIN fiches ON clients.noCli = fiches.noCli
WHERE fiches.etat = 'EC';


-- 2. Détail de la fiche de location de M. Dupond Jean de Paris (avec la désignation des articles loués, la date de départ et de retour).
SELECT fiches.noFic, articles.designation, lignesFic.depart, lignesFic.retour
FROM fiches
JOIN clients ON fiches.noCli = clients.noCli
JOIN lignesFic ON fiches.noFic = lignesFic.noFic
JOIN articles ON lignesFic.refart = articles.refart
WHERE clients.nom = 'Dupond' AND clients.prenom = 'Jean' AND clients.ville = 'Paris';

-- 3. Liste de tous les articles (référence, désignation et libellé de la catégorie) dont le libellé de la catégorie contient ski.
SELECT articles.refart, articles.designation, categories.libelle
FROM articles
JOIN categories ON articles.codeCate = categories.codeCate
WHERE categories.libelle LIKE '%ski%';


-- 4. Calcul du montant de chaque fiche soldée
SELECT fiches.noFic, SUM(tarifs.prixJour * DATEDIFF(IFNULL(lignesFic.retour, NOW()), lignesFic.depart)) AS montant
FROM fiches
JOIN lignesFic ON fiches.noFic = lignesFic.noFic
JOIN articles ON lignesFic.refart = articles.refart
JOIN grilleTarifs ON articles.codeCate = grilleTarifs.codeCate AND articles.codeGam = grilleTarifs.codeGam
JOIN tarifs ON grilleTarifs.codeTarif = tarifs.codeTarif
WHERE fiches.etat = 'SO'
GROUP BY fiches.noFic;

-- 4. Calcul du montant total des fiches soldées
SELECT SUM(montant) AS montant_total
FROM (
    SELECT SUM(tarifs.prixJour * DATEDIFF(IFNULL(lignesFic.retour, NOW()), lignesFic.depart)) AS montant
    FROM fiches
    JOIN lignesFic ON fiches.noFic = lignesFic.noFic
    JOIN articles ON lignesFic.refart = articles.refart
    JOIN grilleTarifs ON articles.codeCate = grilleTarifs.codeCate AND articles.codeGam = grilleTarifs.codeGam
    JOIN tarifs ON grilleTarifs.codeTarif = tarifs.codeTarif
    WHERE fiches.etat = 'SO'
    GROUP BY fiches.noFic
) AS sous_requete;

-- 5. Calcul du nombre d’articles actuellement en cours de location.
SELECT COUNT(DISTINCT lignesFic.refart) AS nombre_articles_en_cours
FROM lignesFic
JOIN fiches ON lignesFic.noFic = fiches.noFic
WHERE fiches.etat = 'EC';

-- 6. Calcul du nombre d’articles loués, par client.
SELECT clients.nom, clients.prenom, COUNT(lignesFic.refart) AS nombre_articles_loues
FROM clients
JOIN fiches ON clients.noCli = fiches.noCli
JOIN lignesFic ON fiches.noFic = lignesFic.noFic
GROUP BY clients.nom, clients.prenom;

-- 7. Liste des clients qui ont effectué (ou sont en train d’effectuer) plus de 200€ de location.
SELECT clients.nom, clients.prenom, SUM(tarifs.prixJour * DATEDIFF(IFNULL(lignesFic.retour, NOW()), lignesFic.depart)) AS montant_total
FROM clients
JOIN fiches ON clients.noCli = fiches.noCli
JOIN lignesFic ON fiches.noFic = lignesFic.noFic
JOIN articles ON lignesFic.refart = articles.refart
JOIN grilleTarifs ON articles.codeCate = grilleTarifs.codeCate AND articles.codeGam = grilleTarifs.codeGam
JOIN tarifs ON grilleTarifs.codeTarif = tarifs.codeTarif
GROUP BY clients.nom, clients.prenom
HAVING montant_total > 200;

-- 8. Liste de tous les articles (loués au moins une fois) et le nombre de fois où ils ont été loués, triés du plus loué au moins loué.
SELECT articles.refart, articles.designation, COUNT(lignesFic.refart) AS nombre_de_locations
FROM articles
JOIN lignesFic ON articles.refart = lignesFic.refart
GROUP BY articles.refart, articles.designation
HAVING nombre_de_locations > 0
ORDER BY nombre_de_locations DESC;

-- 9. Liste des fiches (n°, nom, prénom) de moins de 150€.
SELECT fiches.noFic, clients.nom, clients.prenom, SUM(tarifs.prixJour * DATEDIFF(IFNULL(lignesFic.retour, NOW()), lignesFic.depart)) AS montant_total
FROM fiches
JOIN clients ON fiches.noCli = clients.noCli
JOIN lignesFic ON fiches.noFic = lignesFic.noFic
JOIN articles ON lignesFic.refart = articles.refart
JOIN grilleTarifs ON articles.codeCate = grilleTarifs.codeCate AND articles.codeGam = grilleTarifs.codeGam
JOIN tarifs ON grilleTarifs.codeTarif = tarifs.codeTarif
GROUP BY fiches.noFic, clients.nom, clients.prenom
HAVING montant_total < 150;

-- 10. Calcul de la moyenne des recettes de location de surf (combien peut-on espérer gagner pour une location d'un surf ?).
SELECT AVG(tarifs.prixJour * DATEDIFF(IFNULL(lignesFic.retour, NOW()), lignesFic.depart)) AS moyenne_recettes_surf
FROM lignesFic
JOIN articles ON lignesFic.refart = articles.refart
JOIN grilleTarifs ON articles.codeCate = grilleTarifs.codeCate AND articles.codeGam = grilleTarifs.codeGam
JOIN tarifs ON grilleTarifs.codeTarif = tarifs.codeTarif
JOIN categories ON articles.codeCate = categories.codeCate
WHERE categories.libelle LIKE '%surf%';

-- 11. Calcul de la durée moyenne d'une location d'une paire de skis (en journées entières).
SELECT AVG(DATEDIFF(IFNULL(lignesFic.retour, NOW()), lignesFic.depart)) AS duree_moyenne_location_ski
FROM lignesFic
JOIN articles ON lignesFic.refart = articles.refart
JOIN categories ON articles.codeCate = categories.codeCate
WHERE categories.libelle LIKE '%ski%';