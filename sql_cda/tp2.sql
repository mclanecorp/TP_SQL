
DROP DATABASE IF EXISTS invitation;


CREATE DATABASE invitation CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE invitation;


CREATE TABLE IF NOT EXISTS inv_personne (
    id INT PRIMARY KEY,
    prenom VARCHAR(50) NOT NULL,
    nom VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    inscription DATE NOT NULL,
    etat BOOLEAN NOT NULL,
    statut ENUM('membre', 'non membre') NOT NULL,
    cv TEXT NOT NULL,
    salaire DECIMAL(15, 2) NOT NULL,
    CONSTRAINT pk_personne PRIMARY KEY (id)
)ENGINE=INNODB;


INSERT INTO inv_personne (id, prenom, nom, age, inscription, etat, statut, cv, salaire) VALUES
(1, 'Brad', 'PITT', 60, '1970-01-01', TRUE, 'non membre', 'lorem ipsum', 2000000.00),
(2, 'George', 'CLONEY', 62, '1999-01-01', TRUE, 'membre', 'juste beau', 4000000.00),
(3, 'Jean', 'DUJARDIN', 51, '1994-01-01', FALSE, 'membre', 'brice de nice', 1000000.00);