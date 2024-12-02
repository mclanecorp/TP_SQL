
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



-- Afficher le plus gros salaire (avec MAX)
SELECT MAX(salaire) AS plus_gros_salaire FROM inv_personne;

-- Afficher le plus petit salaire (avec MIN)
SELECT MIN(salaire) AS plus_petit_salaire FROM inv_personne;

-- Afficher le nom de l'acteur (et son salaire) qui a le plus petit salaire avec LIMIT & ORDER BY
SELECT prenom, nom, salaire FROM inv_personne ORDER BY salaire ASC LIMIT 1;

-- Afficher le nom de l'acteur (et son salaire) qui a le plus gros salaire avec LIMIT & ORDER BY
SELECT prenom, nom, salaire FROM inv_personne ORDER BY salaire DESC LIMIT 1;

-- Afficher le salaire moyen
SELECT AVG(salaire) AS salaire_moyen FROM inv_personne;

-- Afficher le nombre de personnes
SELECT COUNT(*) AS nombre_de_personnes FROM inv_personne;

-- Afficher les acteurs avec un salaire entre 1 000 000 et 4 000 000 avec BETWEEN
SELECT prenom, nom, salaire FROM inv_personne WHERE salaire BETWEEN 1000000 AND 4000000;

-- Proposer une requête avec UPPER() & LOWER()
SELECT UPPER(prenom) AS prenom_majuscule, LOWER(nom) AS nom_minuscule FROM inv_personne;

-- Afficher les personnes dont le prénom contient 'bra'
SELECT * FROM inv_personne WHERE prenom LIKE '%bra%';

-- Trier par âge les membres
SELECT * FROM inv_personne WHERE statut = 'membre' ORDER BY age;

-- Afficher le nombre d'acteurs "membre"
SELECT COUNT(*) AS nombre_de_membres FROM inv_personne WHERE statut = 'membre';

-- Afficher le nombre des membres et des non membres
SELECT statut, COUNT(*) AS nombre FROM inv_personne GROUP BY statut;