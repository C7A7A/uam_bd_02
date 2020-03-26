--USE master;
--DROP DATABASE Szkolenia;
--GO

--CREATE DATABASE Szkolenia;
--GO

--USE Szkolenia;
--GO

------------ USU� TABELE ------------

DROP TABLE IF EXISTS Udzial;
DROP TABLE IF EXISTS Uczestnicy;
DROP TABLE IF EXISTS Kursy;
    
DROP TABLE IF EXISTS MapujMiasta;
DROP TABLE IF EXISTS UczestnicyAktualnie;

GO

SET LANGUAGE polski
GO

------------ CREATE - UTW�RZ TABELE I POWI�ZANIA ------------

CREATE TABLE Uczestnicy
(
    PESEL      CHAR(11) CONSTRAINT pk_uczestnicy_pesel PRIMARY KEY,
    nazwisko   VARCHAR(20) NOT NULL,
    miasto     VARCHAR(20) DEFAULT 'Pozna�',
    email      VARCHAR(100),
    CONSTRAINT ck_uczestnicy_pesel CHECK (PESEL LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);

CREATE TABLE Kursy
(
    Kod        INT IDENTITY(100, 100) CONSTRAINT pk_kursy_kod PRIMARY KEY,
    nazwa      VARCHAR(50) CONSTRAINT uq_kursy_nazwa UNIQUE,
    liczba_dni INT,
    cena       AS liczba_dni * 1000,
    CONSTRAINT ck_kursy_dni CHECK (liczba_dni BETWEEN 1 AND 5)
);

CREATE TABLE Udzial
(
    uczestnik  CHAR(11) CONSTRAINT fk_udzial_uczestnik REFERENCES Uczestnicy(PESEL) ON DELETE CASCADE,
    kurs       INT CONSTRAINT fk_udzial_kurs REFERENCES Kursy(Kod),
    data_od    DATE,
    data_do    DATE,
    [status]   VARCHAR(20),
    CONSTRAINT ck_udzial_status CHECK ([status] IN ('w trakcie','ukonczony', 'nieukonczony')),
    CONSTRAINT ck_udzial_data CHECK (data_do > data_od)
);

GO

------------ INSERT - WSTAW DANE ------------

INSERT INTO Kursy(nazwa, liczba_dni) VALUES
('Administracja MySQL'         , 3),
('Analiza danych'              , 3),
('MS Access (zaawansowany)'    , 2),
('MySQL dla programist�w'      , 2),
('Programowanie VBA w Accessie', 1);

INSERT INTO Uczestnicy VALUES
('91122895863', 'Lewicka',    'Pozna�',         'alewi91@buziaczek.pl'),
('74080812482', 'Kowalski',   'Szczecin',       'kowal@cloud.net'),
('58100387129', 'Najgebauer', 'Lodz',           'jakub@najgebauer.com.pl'),
('69091729555', 'Muszka',     'P-�',            'muszka@wp.pl'),
('83060448424', 'Jakubowicz', 'Bielskobia�a',   'hulk@marvel.com'),
('90121298347', 'Janicka',    'Bielsko Biala',  'janicka@amu.edu.pl')

INSERT INTO Udzial VALUES
('91122895863', 100, '01-03-2015', '03-03-2015', 'ukonczony'),
('83060448424', 300, '12-10-2015', '13-10-2015', 'nieukonczony'),
('83060448424', 200, '15-11-2017', NULL,         'w trakcie'),
('91122895863', 400, '22-02-2014', '23-02-2014', 'nieukonczony'),
('69091729555', 100, '01-03-2015', '03-03-2015', 'ukonczony');

------------ CREATE - UTW�RZ TABELE I POWI�ZANIA ------------

CREATE TABLE MapujMiasta
(
    forma_poprawna    VARCHAR(20),
    forma_niepoprawna VARCHAR(20)
);

CREATE TABLE UczestnicyAktualnie
(
    PESEL      CHAR(11) CONSTRAINT pk_uczestnicyaktualnie_pesel PRIMARY KEY,
    nazwisko   VARCHAR(20) NOT NULL,
    miasto     VARCHAR(20) DEFAULT 'Pozna�',
    email      VARCHAR(100),
);

GO

------------ INSERT - WSTAW DANE ------------

INSERT INTO MapujMiasta VALUES
('Pozna�',        'Poznan'),
('Pozna�',        'P-�'),
('Krak�w',        'Krakow'),
('��d�',          'Lodz'),
('Bielsko-Bia�a', 'Bielsko-Biala'),
('Bielsko-Bia�a', 'Bielsko Biala'),
('Bielsko-Bia�a', 'Bielsko Bia�a');

INSERT INTO UczestnicyAktualnie VALUES
('91122895863', 'Lewicka',           'Pozna�',        'alewi91@buziaczek.pl'),
('74080812482', 'Kowalski',          'Warszawa',      'kowal@cloud.net'),
('58100387129', 'Najgebauer',        'Lodz',          'jakub@najgebauer.com.pl'),
('69091729555', 'Muszka',            'Pozna�',        'muszka@wp.pl'),
('83060448424', 'Jakubowicz',        'Bielsko-Bia�a', 'hulk@marvel.com'),
('90121298347', 'Janicka-Wolska',    'Bielsko-Bia�a', 'janicka@amu.edu.pl'),
('81080803031', 'Nowak',             'Mosina',        'nowakjan@gmail.com');

GO

------------ SELECT ------------

SELECT * FROM Uczestnicy;
SELECT * FROM Kursy;
SELECT * FROM Udzial;

SELECT * FROM MapujMiasta;
SELECT * FROM UczestnicyAktualnie;