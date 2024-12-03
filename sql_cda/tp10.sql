-- 1️⃣ Créer la base de données
DROP DATABASE IF EXISTS ecommerce;
CREATE DATABASE ecommerce CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE ecommerce;

-- -----------------------------------------------------
-- Table `article`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `article` (
  `id` INT AUTO_INCREMENT,
  `nom` VARCHAR(255) NOT NULL,
  `prix` DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table `client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `client` (
  `id` INT AUTO_INCREMENT,
  `nom` VARCHAR(255) NOT NULL,
  `prenom` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table `commande`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `commande` (
  `id` INT AUTO_INCREMENT,
  `client_id` INT NOT NULL,
  `date` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_commande_client`
    FOREIGN KEY (`client_id`)
    REFERENCES `client` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table `commande_article`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `commande_article` (
  `commande_id` INT NOT NULL,
  `article_id` INT NOT NULL,
  `quantite` INT NOT NULL,
  PRIMARY KEY (`commande_id`, `article_id`),
  CONSTRAINT `fk_commande_article_commande`
    FOREIGN KEY (`commande_id`)
    REFERENCES `commande` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_commande_article_article`
    FOREIGN KEY (`article_id`)
    REFERENCES `article` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 2️⃣ Ajouter données
-- Insertion des articles
INSERT INTO article (nom, prix) VALUES
('PlayStation 5', 400.00),
('X box', 350.00),
('Machine à café', 300.00),
('PlayStation 3', 100.00);

-- Insertion des clients
INSERT INTO client (nom, prenom) VALUES
('Brad', 'PITT'),
('George', 'Cloney'),
('Jean', 'DUJARDIN');

-- Insertion de la commande de Brad PITT
INSERT INTO commande (client_id, date) VALUES
(1, NOW());

-- Insertion des articles dans la commande
INSERT INTO commande_article (commande_id, article_id, quantite) VALUES
(1, 4, 2), -- 2 PlayStation 3
(1, 3, 1), -- 1 Machine à café
(1, 2, 1); -- 1 X box

-- 3️⃣ Afficher la commande de Brad PITT
SELECT 
  client.nom AS client_nom,
  client.prenom AS client_prenom,
  commande.date AS date_commande,
  article.nom AS article_nom,
  commande_article.quantite,
  article.prix AS prix_unitaire,
  (commande_article.quantite * article.prix) AS total_ht,
  (commande_article.quantite * article.prix) * 0.20 AS tva,
  (commande_article.quantite * article.prix) * 1.20 AS total_ttc
FROM commande
JOIN client ON commande.client_id = client.id
JOIN commande_article ON commande.id = commande_article.commande_id
JOIN article ON commande_article.article_id = article.id
WHERE client.nom = 'Brad' AND client.prenom = 'PITT';