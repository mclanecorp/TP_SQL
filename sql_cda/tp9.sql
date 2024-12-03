DROP DATABASE IF EXISTS projet_client;

CREATE DATABASE projet_client CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE projet_client;

-- -----------------------------------------------------
-- Table `clients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clients` (
  `id` INT AUTO_INCREMENT,
  `nom` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table `projets`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projets` (
  `id` INT AUTO_INCREMENT,
  `client_id` INT NOT NULL,
  `nom` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_projets_clients`
    FOREIGN KEY (`client_id`)
    REFERENCES `clients` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table `devis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `devis` (
  `id` INT AUTO_INCREMENT,
  `projet_id` INT NOT NULL,
  `version` INT NOT NULL,
  `reference` VARCHAR(255) NOT NULL,
  `montant` DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_devis_projets`
    FOREIGN KEY (`projet_id`)
    REFERENCES `projets` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table `factures`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `factures` (
  `id` INT AUTO_INCREMENT,
  `devis_id` INT NOT NULL,
  `reference` VARCHAR(255) NOT NULL,
  `info` VARCHAR(255) NOT NULL,
  `total` DECIMAL(10, 2) NOT NULL,
  `date` DATE NOT NULL,
  `paiement` DATE NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_factures_devis`
    FOREIGN KEY (`devis_id`)
    REFERENCES `devis` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Insertion des données
-- -----------------------------------------------------
-- Insertion des clients
INSERT INTO clients (nom) VALUES
('Mairie de Rennes'),
('Neo Soft'),
('Sopra'),
('Accenture'),
('Amazon');

-- Insertion des projets
INSERT INTO projets (client_id, nom) VALUES
(1, 'Creation de site internet'),
(2, 'Logiciel CRM'),
(3, 'Logiciel de devis'),
(4, 'Site internet ecommerce'),
(2, 'logiciel ERP'),
(5, 'logiciel Gestion de Stock');

-- Insertion des devis
INSERT INTO devis (projet_id, version, reference, montant) VALUES
(1, 1, 'DEV2100A', 3000.00),
(1, 2, 'DEV2100B', 5000.00),
(2, 1, 'DEV2100C', 5000.00),
(3, 1, 'DEV2100D', 3000.00),
(4, 1, 'DEV2100E', 5000.00),
(5, 1, 'DEV2100F', 2000.00),
(6, 1, 'DEV2100G', 1000.00);

-- Insertion des factures
INSERT INTO factures (devis_id, reference, info, total, date, paiement) VALUES
(1, 'FA001', 'Site internet partie 1', 1500.00, '2023-09-01', '2023-10-01'),
(1, 'FA002', 'Site internet partie 2', 1500.00, '2023-09-20', NULL),
(3, 'FA003', 'Logiciel CRM', 5000.00, '2024-02-01', NULL),
(4, 'FA004', 'Logiciel devis', 3000.00, '2024-03-03', '2024-04-03'),
(5, 'FA005', 'Site internet ecommerce', 5000.00, '2023-03-01', NULL),
(6, 'FA006', 'logiciel ERP', 2000.00, '2023-03-01', NULL);

-- -----------------------------------------------------
-- Requêtes demandées
-- -----------------------------------------------------

-- 1️⃣ Afficher toutes les factures avec le nom des clients
SELECT factures.*, clients.nom AS client_nom
FROM factures
JOIN devis ON factures.devis_id = devis.id
JOIN projets ON devis.projet_id = projets.id
JOIN clients ON projets.client_id = clients.id;

-- 2️⃣ Afficher le nombre de factures par client
SELECT clients.nom AS client_nom, COUNT(factures.id) AS nombre_factures
FROM factures
JOIN devis ON factures.devis_id = devis.id
JOIN projets ON devis.projet_id = projets.id
JOIN clients ON projets.client_id = clients.id
GROUP BY clients.nom;

-- 3️⃣ Afficher le chiffre d'affaire par client
SELECT clients.nom AS client_nom, SUM(factures.total) AS chiffre_affaire
FROM factures
JOIN devis ON factures.devis_id = devis.id
JOIN projets ON devis.projet_id = projets.id
JOIN clients ON projets.client_id = clients.id
GROUP BY clients.nom;

-- 4️⃣ Afficher le CA total
SELECT SUM(total) AS chiffre_affaire_total FROM factures;

-- 5️⃣ Afficher la somme des factures en attente de paiement
SELECT SUM(total) AS total_en_attente
FROM factures
WHERE paiement IS NULL;

-- 6️⃣ Afficher les factures en retard de paiement
SELECT factures.*, clients.nom AS client_nom
FROM factures
JOIN devis ON factures.devis_id = devis.id
JOIN projets ON devis.projet_id = projets.id
JOIN clients ON projets.client_id = clients.id
WHERE paiement IS NULL AND date < CURDATE();

-- 7️⃣ Ajouter une pénalité de 2 euros par jour de retard
SELECT factures.*, clients.nom AS client_nom, 
       DATEDIFF(CURDATE(), date) * 2 AS penalite
FROM factures
JOIN devis ON factures.devis_id = devis.id
JOIN projets ON devis.projet_id = projets.id
JOIN clients ON projets.client_id = clients.id
WHERE paiement IS NULL AND date < CURDATE();