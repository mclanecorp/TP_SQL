DROP DATABASE IF EXISTS spa;

CREATE DATABASE spa CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE spa;


CREATE TABLE couleur (
    id INT AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL,
    CONSTRAINT pk_couleur PRIMARY KEY (id)
) ENGINE=INNODB;


CREATE TABLE chats (
    id INT AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    couleur_id INT NULL,
    CONSTRAINT pk_chats PRIMARY KEY (id),
    CONSTRAINT fk_couleur FOREIGN KEY (couleur_id) REFERENCES couleur(id)
) ENGINE=INNODB;


INSERT INTO couleur (nom) VALUES
('marron'),
('bleu');
('vert')

-- Insérer des données dans la table chats
INSERT INTO chats (nom, age, couleur_id) VALUES
('Maine coon', 20, 1),
('Siamois', 15, 2),
('Bengal', 18, 1),
('Scottish Fold', 10, 1);
('domestique',21, null)