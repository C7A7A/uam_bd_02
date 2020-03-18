--USE master;
--DROP DATABASE Aviation;
--GO

--CREATE DATABASE Aviation;
--GO

--USE Aviation;
--GO

------------ USUÑ TABELE ------------

DROP TABLE IF EXISTS Skills;
DROP TABLE IF EXISTS Pilots;
DROP TABLE IF EXISTS Hangar;

------------ CREATE - UTWÓRZ TABELE I POWI¥ZANIA ------------

CREATE TABLE Pilots
(
    pilot VARCHAR(20)
);

CREATE TABLE Hangar
(
    plane VARCHAR(20)
);

CREATE TABLE Skills
(
    pilot VARCHAR(20),
    plane VARCHAR(20)
);

GO

------------ INSERT - WSTAW DANE ------------

INSERT INTO Pilots VALUES
('Celko'  ),
('Higgins'),
('Jones'  ),
('Smith'  ),
('Wilson' );

INSERT INTO Hangar VALUES
('B-1 Bomber'  ),
('B-52 Bomber' ),
('F-14 Fighter');

GO

INSERT INTO Skills VALUES
('Celko'   , 'Piper Cub'   ),
('Higgins' , 'B-52 Bomber' ),
('Higgins' , 'F-14 Fighter'),
('Higgins' , 'Piper Cub'   ),
('Jones'   , 'B-52 Bomber' ),
('Jones'   , 'F-14 Fighter'),
('Smith'   , 'B-1 Bomber'  ),
('Smith'   , 'B-52 Bomber' ),
('Smith'   , 'F-14 Fighter'),
('Wilson'  , 'B-1 Bomber'  ),
('Wilson'  , 'B-52 Bomber' ),
('Wilson'  , 'F-14 Fighter'),
('Wilson'  , 'F-17 Fighter');

GO

------------ SELECT ------------

SELECT * FROM Pilots;
SELECT * FROM Hangar;
SELECT * FROM Skills;