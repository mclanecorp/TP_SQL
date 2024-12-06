
https://dbdiagram.io/d/6752b939e9daa85acadfc526



CREATE TABLE regions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL
);

CREATE TABLE producteurs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL,
    region_id INT,
    FOREIGN KEY (region_id) REFERENCES regions(id)
);

CREATE TABLE types_vin (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL
);

CREATE TABLE cepages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL
);

CREATE TABLE categories_alcool (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL
);

CREATE TABLE appellations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL
);

CREATE TABLE bouteilles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL,
    annee INT,
    prix DECIMAL(10, 2),
    tva DECIMAL(5, 2),
    type_vin_id INT,
    producteur_id INT,
    cepage_id INT,
    millesime VARCHAR(255),
    couleur ENUM('rouge', 'blanc', 'rose', 'mousseux'),
    categorie_id INT,
    appellation_id INT,
    FOREIGN KEY (type_vin_id) REFERENCES types_vin(id),
    FOREIGN KEY (producteur_id) REFERENCES producteurs(id),
    FOREIGN KEY (cepage_id) REFERENCES cepages(id),
    FOREIGN KEY (categorie_id) REFERENCES categories_alcool(id),
    FOREIGN KEY (appellation_id) REFERENCES appellations(id)
);

CREATE TABLE utilisateurs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL
);

CREATE TABLE commandes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    utilisateur_id INT,
    date_commande DATE,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id)
);

CREATE TABLE commandes_bouteilles (
    commande_id INT,
    bouteille_id INT,
    quantite INT,
    prix DECIMAL(10, 2),
    tva DECIMAL(5, 2),
    PRIMARY KEY (commande_id, bouteille_id),
    FOREIGN KEY (commande_id) REFERENCES commandes(id),
    FOREIGN KEY (bouteille_id) REFERENCES bouteilles(id)
);