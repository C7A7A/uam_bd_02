--USE master;
--DROP DATABASE II_Wojna_Swiatowa;
--GO

--CREATE DATABASE II_Wojna_Swiatowa;
--GO

--USE II_Wojna_Swiatowa;
--GO

------------ USUÑ TABELE ------------

DROP TABLE IF EXISTS Skutki;
DROP TABLE IF EXISTS Bitwy;
DROP TABLE IF EXISTS Okrety;
DROP TABLE IF EXISTS Klasy;

--DROP TABLE Skutki, Bitwy, Okrety, Klasy

------------ CREATE - UTWÓRZ TABELE I POWI¥ZANIA ------------

CREATE TABLE Klasy
(
    klasa       VARCHAR(20) PRIMARY KEY,
    typ         VARCHAR(20),
    kraj        VARCHAR(20),
    liczbaDzial INTEGER,
    kaliber     INTEGER,
    wypornosc   INTEGER
);

CREATE TABLE Okrety
(
    nazwa     VARCHAR(20) PRIMARY KEY,
    klasa     VARCHAR(20),
    zwodowano INTEGER,
    CONSTRAINT fk_okr_klasa FOREIGN KEY (klasa) REFERENCES Klasy(klasa)
);

CREATE TABLE Bitwy
(
    nazwa VARCHAR(20) PRIMARY KEY,
    data  DATE
);

CREATE TABLE Skutki
(
    okret VARCHAR(20),
    bitwa VARCHAR(20),
    efekt VARCHAR(20),
    CONSTRAINT fk_skut_bitwa FOREIGN KEY (bitwa) REFERENCES Bitwy(nazwa)
    --,CONSTRAINT fk_skut_okret FOREIGN KEY (okret) REFERENCES Okrety(nazwa)
);

GO

------------ INSERT - WSTAW DANE ------------

INSERT INTO Klasy VALUES
('Bismarck'       , 'pn'  , 'Niemcy'          , 8  , 15 , 42000),
('Iowa'           , 'pn'  , 'USA'             , 9  , 16 , 46000),
('Kongo'          , 'kr'  , 'Japonia'         , 8  , 14 , 32000),
('North Carolina' , 'pn'  , 'USA'             , 9  , 16 , 37000),
('Renown'         , 'kr'  , 'Wielka Brytania' , 6  , 15 , 32000),
('Revenge'        , 'pn'  , 'Wielka Brytania' , 8  , 15 , 29000),
('Tennessee'      , 'pn'  , 'USA'             , 12 , 14 , 32000),
('Yamato'         , 'pn'  , 'Japonia'         , 9  , 18 , 65000);

INSERT INTO Okrety VALUES
('California'      , 'Tennessee'      , 1921),
('Haruna'          , 'Kongo'          , 1915),
('Hiei'            , 'Kongo'          , 1914),
('Iowa'            , 'Iowa'           , 1943),
('Kirishima'       , 'Kongo'          , 1915),
('Kongo'           , 'Kongo'          , NULL),
('Missouri'        , 'Iowa'           , 1944),
('Musashi'         , 'Yamato'         , 1942),
('New Jersey'      , 'Iowa'           , 1943),
('North Carolina'  , 'North Carolina' , 1941),
('Ramillies'       , 'Revenge'        , 1917),
('Renown'          , 'Renown'         , 1916),
('Repulse'         , 'Renown'         , 1916),
('Resolution'      , 'Revenge'        , 1916),
('Revenge'         , 'Revenge'        , 1916),
('Royal Oak'       , 'Revenge'        , 1916),
('Royal Sovereign' , 'Revenge'        , NULL),
('Tennessee'       , 'Tennessee'      , 1920),
('Washington'      , 'North Carolina' , 1941),
('Wisconsin'       , 'Iowa'           , 1944),
('Yamato'          , 'Yamato'         , 1941);

INSERT INTO Bitwy VALUES
('Denmark Strait' , '05/24/1941' ),
('Guadalcanal'    , '11/15/1942'),
('North Cape'     , '12/26/1943'),
('Surigao Strait' , '10/25/1944'),
('Pearl Harbor'   , '07/12/1941');

INSERT INTO Skutki VALUES
('Arizona'         , 'Pearl Harbor'   , 'zatopiony' ),
('Bismarck'        , 'Denmark Strait' , 'zatopiony' ),
('California'      , 'Surigao Strait' , 'bez strat' ),
('Duke of York'    , 'North Cape'     , 'bez strat' ),
('Fuso'            , NULL             , 'zatopiony' ),
('Hood'            , 'Denmark Strait' , 'zatopiony' ),
('King George V'   , 'Denmark Strait' , 'bez strat' ),
('Kirishima'       , 'Guadalcanal'    , 'zatopiony' ),
('Prince of Wales' , 'Denmark Strait' , 'uszkodzony'),
('Rodney'          , 'Denmark Strait' , 'bez strat' ),
('Scharnhorst'     , 'North Cape'     , 'zatopiony' ),
('South Dakota'    , 'Guadalcanal'    , 'uszkodzony'),
('Tennessee'       , 'Surigao Strait' , 'bez strat' ),
('Washington'      , 'Guadalcanal'    , 'bez strat' ),
('West Virginia'   , NULL             , 'bez strat' ),
('Yamashiro'       , 'Surigao Strait' , 'zatopiony' );

------------ SELECT ------------

SELECT * FROM Klasy;
SELECT * FROM Okrety;
SELECT * FROM Bitwy;
SELECT * FROM Skutki;
