DROP DATABASE IF EXISTS  netflix;

CREATE DATABASE netflix CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE netflix;


CREATE TABLE categ (
    id INT AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL,
    CONSTRAINT pk_categ PRIMARY KEY (id)
    CONSTRAINT unique_nom UNIQUE (nom)
) ENGINE=INNODB;


CREATE TABLE film (
    id INT AUTO_INCREMENT,
    titre VARCHAR(255) NOT NULL,
    sortie date NOT NULL,
    categ_name VARCHAR(255)
    CONSTRAINT pk_film PRIMARY KEY (id),
    CONSTRAINT fk_categ FOREIGN KEY (categ_name) REFERENCES categ(nom)
) ENGINE=INNODB;


INSERT INTO categ (nom) VALUES
('Sciences Fiction'),
('Thriller');



INSERT INTO film (titre, sortie, categ_name) VALUES
('STAR WARS', '1977-05-25', 'Sciences Fiction'),
('The Matrix', '1999-06-23', 'Sciences Fiction'),
('Pulp Fiction', '1994-10-26', 'Thriller');
