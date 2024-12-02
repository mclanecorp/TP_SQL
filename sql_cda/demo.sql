DROP DATABASE IF EXISTS exemple;

CREATE DATABASE exemple CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE exemple;

# version 1
CREATE TABLE chats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50),
    yeux VARCHAR(50),
    age INT
)ENGINE=INNODB;

# version 2
CREATE TABLE chats (
    id INT AUTO_INCREMENT,
    nom VARCHAR(50),
    yeux VARCHAR(50),
    age INT,
    CONSTRAINT pk_chats PRIMARY KEY (id)
)ENGINE=INNODB;

INSERT INTO chats (id, nom, yeux, age) VALUES
('Maine coon', 'marron', 20),
('Siamois', 'bleu', 15),
('Bengal', 'marron', 18),
('Scottish Fold', 'marron', 10);