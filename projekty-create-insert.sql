/* Baza Projekty, v. 2020-02-20 */

--USE master;
--DROP DATABASE Projekty;
--GO

--CREATE DATABASE Projekty;
--GO

--USE Projekty;
--GO

SET LANGUAGE polski;
GO

-------- USUŃ TABELE --------

DROP TABLE IF EXISTS Realizacje;
DROP TABLE IF EXISTS Projekty;
DROP TABLE IF EXISTS Pracownicy;
DROP TABLE IF EXISTS Stanowiska;

--------- CREATE - UTWÓRZ TABELE I POWIĄZANIA --------

CREATE TABLE Stanowiska
(
    nazwa      VARCHAR(10) PRIMARY KEY,
    placa_min  MONEY,
    placa_max  MONEY,
    CHECK (placa_min < placa_max)
);

CREATE TABLE Pracownicy
(
    id           INT NOT NULL PRIMARY KEY,
    nazwisko     VARCHAR(20) NOT NULL,
    szef         INT REFERENCES Pracownicy(id),
    placa        MONEY,
    dod_funkc    MONEY,
    stanowisko   VARCHAR(10) REFERENCES Stanowiska(nazwa),
    zatrudniony  DATETIME
);

CREATE TABLE Projekty
(
    id               INT IDENTITY(10,10) NOT NULL PRIMARY KEY,
    nazwa            VARCHAR(20) NOT NULL UNIQUE,
    dataRozp         DATETIME NOT NULL,
    dataZakonczPlan  DATETIME NOT NULL,
    dataZakonczFakt  DATETIME NULL,
    kierownik        INT REFERENCES Pracownicy(id),
    stawka           MONEY
);

CREATE TABLE Realizacje
(
    idProj  INT REFERENCES Projekty(id),
    idPrac  INT REFERENCES Pracownicy(id),
    godzin  REAL DEFAULT 8,
    PRIMARY KEY (idProj, idPrac)
);

GO

---------- INSERT - WSTAW DANE --------

INSERT INTO Stanowiska VALUES
('profesor',   4000, 6000),
('adiunkt',    3000, 4000),
('doktorant',  1900, 2300),
('sekretarka', 2500, 3500),
('techniczny', 2500, 3500),
('dziekan',    3700, 5800);

INSERT INTO Pracownicy VALUES
(1,  'Wachowiak', NULL, 5500,  900,   'profesor', '01-09-1990'),
(2,  'Jankowski',    1, 3500, NULL,    'adiunkt', '01-09-2000'),
(3,  'Fiołkowska',   1, 3550, NULL,    'adiunkt', '01-01-1995'),
(4,  'Mielcarz',     1, 5000,  500,   'profesor', '01-12-1990'),
(5,  'Różycka',      4, 3900,  300,   'profesor', '01-09-2011'),
(6,  'Mikołajski',   4, 2100, NULL,  'doktorant', '01-10-2017'),
(7,  'Wójcicki',     5, 2350, NULL,  'doktorant', '01-10-2015'),
(8,  'Listkiewicz',  1, 3200, NULL, 'sekretarka', '01-09-1990'),
(9,  'Wróbel',       1, 2900,  400, 'techniczny', '01-01-2009'),
(10, 'Andrzejewicz', 5, 3900, NULL,    'adiunkt', '01-01-2012'),
(11, 'Jankowski',    5, 3200, NULL, 'techniczny', '01-01-2000');

INSERT INTO Projekty VALUES
('e-learning',     '01-01-2017', '31-05-2018',         NULL, 5, 100),
('web service',    '10-11-2009', '31-12-2010', '20-04-2011', 4,  90),
('semantic web',   '01-09-2018', '01-09-2023',         NULL, 4,  85),
('neural network', '01-01-2011', '30-06-2012', '30-06-2012', 1, 120),
('analiza danych', '01-04-2019', '30-06-2021',         NULL, 10, 85);

INSERT INTO Realizacje VALUES
(10,  5, 8),
(10, 10, 6),
(10,  9, 2),
(20,  4, 8),
(20,  6, 8),
(20,  9, 2),
(30,  4, 8),
(30,  6, 6),
(30, 10, 6),
(30,  9, 2),
(40,  1, 8),
(40,  2, 4),
(40,  3, 4),
(40,  9, 2),
(50,  9, 2);

------------ SELECT --------

SELECT * FROM Stanowiska;
SELECT * FROM Pracownicy;
SELECT * FROM Projekty;
SELECT * FROM Realizacje;
