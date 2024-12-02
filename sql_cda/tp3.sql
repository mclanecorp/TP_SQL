
DROP DATABASE IF EXISTS zoo;

CREATE DATABASE zoo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE zoo;

CREATE TABLE chats (
    id INT AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL,
    yeux VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    CONSTRAINT pk_chats PRIMARY KEY (id)
)ENGINE=INNODB;

INSERT INTO chats (id, nom, yeux, age) VALUES
('Maine coon', 'marron', 20),
('Siamois', 'bleu', 15),
('Bengal', 'marron', 18),
('Scottish Fold', 'marron', 10);

-- Afficher le chat avec l'id :2
SELECT * FROM chat WHERE id = 2;

-- Trier les chats par nom et par age
SELECT * FROM chat ORDER BY nom, age;

-- Afficher les chats qui vivent entre 11 et 19 ans
SELECT * FROM chat WHERE age BETWEEN 11 AND 19;

-- Afficher le ou les chats dont le nom contient 'sia'
SELECT * FROM chat WHERE nom LIKE '%sia%';

-- Afficher le ou les chats dont le nom contient 'a'
SELECT * FROM chat WHERE nom LIKE '%a%';

-- Afficher la moyenne d'âge des chats
SELECT AVG(age) AS moyenne_age FROM chat;

-- Afficher le nombre de chats dans la table
SELECT COUNT(*) AS nombre_de_chats FROM chat;

-- Afficher le nombre de chats avec couleur d'yeux marron
SELECT COUNT(*) AS nombre_de_chats_marron FROM chat WHERE yeux = 'marron';

-- Afficher le nombre de chats par couleur d'yeux
SELECT yeux, COUNT(*) AS nombre_de_chats FROM chat GROUP BY yeux;


--  à partir d'un fichier CSV
LOAD DATA INFILE 'chemin du csv'
INTO TABLE chat
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, nom, yeux, age);