USE dbad_s452648;

SELECT * FROM Pracownicy;
SELECT * FROM Projekty;
SELECT * FROM Realizacje;
SELECT * FROM Stanowiska;

CREATE TABLE Kolory
(
       kolor VARCHAR(5)
);

CREATE TABLE Cechy
(
       cecha VARCHAR(5)
);

INSERT INTO Kolory VALUES ('kier'), ('pik'), ('karo'), ('trefl');
INSERT INTO Cechy  VALUES ('as'), ('król'), ('dama'), ('walet'), ('10'), ('9'),
                          ('8'), ('7'), ('6'), ('5'), ('4'), ('3'), ('2');

SELECT * FROM Kolory;
SELECT * FROM Cechy;

SELECT *
FROM   Kolory
       CROSS JOIN Cechy;

SELECT *
FROM   Kolory K
       CROSS JOIN Cechy C;

SELECT C.*,
       K.kolor
FROM   Kolory K
       CROSS JOIN Cechy C;