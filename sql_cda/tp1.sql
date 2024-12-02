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