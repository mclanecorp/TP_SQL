DROP DATABASE IF EXISTS netflix;

CREATE DATABASE netflix CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE netflix;


CREATE TABLE acteur (
    id INT AUTO_INCREMENT,
    prenom VARCHAR(255) NOT NULL,
    nom VARCHAR(255) NOT NULL,
    CONSTRAINT pk_acteur PRIMARY KEY (id)
) ENGINE=INNODB;

CREATE TABLE film (
    id INT AUTO_INCREMENT,
    titre VARCHAR(255) NOT NULL,
    CONSTRAINT pk_film PRIMARY KEY (id)
) ENGINE=INNODB;


CREATE TABLE film_has_acteur (
    acteur_id INT,
    film_id INT,
    CONSTRAINT fk_acteur FOREIGN KEY (acteur_id) REFERENCES acteur(id),
    CONSTRAINT fk_film FOREIGN KEY (film_id) REFERENCES film(id),
    CONSTRAINT pk_acteur_film PRIMARY KEY (acteur_id, film_id)
) ENGINE=INNODB;


INSERT INTO acteur (prenom, nom) VALUES
('Brad', 'Pitt'),
('Leonardo', 'Dicaprio');


INSERT INTO film (titre) VALUES
('Fight Club'),
('Once Upon a Time in Hollywood'),
('TItanic');


INSERT INTO film_has_acteur (acteur_id, film_id) VALUES
(1, 1), 
(2, 1), 
(2, 2); 


SELECT film.titre
FROM film
JOIN film_has_acteur ON film.id = film_has_acteur.film_id
JOIN acteur ON film_has_acteur.acteur_id = acteur.id
WHERE acteur.prenom = 'Léonardo' AND acteur.nom = 'Dicaprio';

SELECT acteur.prenom, acteur.nom, COUNT(film_has_acteur.film_id) AS nombre_de_films
FROM acteur
JOIN film_has_acteur ON acteur.id = film_has_acteur.acteur_id
GROUP BY acteur.id;

SELECT film.titre
FROM film
LEFT JOIN film_has_acteur ON film.id = film_has_acteur.film_id
WHERE film_has_acteur.film_id IS NULL;