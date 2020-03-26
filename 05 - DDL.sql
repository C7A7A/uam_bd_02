-- zad 1

CREATE TABLE Uczestnicy
(
  pesel BIGINT CONSTRAINT pk_uczest_pesel PRIMARY KEY,
  nazwisko VARCHAR(40) CONSTRAINT nnull_uczest_nazwisko NOT NULL,
  miasto VARCHAR(40) CONSTRAINT def_uczest_miasto DEFAULT 'Poznañ'
);

CREATE TABLE Kursy
(
	kod INT IDENTITY(1,1) CONSTRAINT pk_kursy_kod PRIMARY KEY,
	nazwa VARCHAR(50) CONSTRAINT uniq_kursy_nazwa UNIQUE,
	liczba_dni TINYINT CONSTRAINT ck_kursy_liczba_dni CHECK (liczba_dni BETWEEN 1 AND 5),
	cena AS liczba_dni * 1000,
);

CREATE TABLE Udzial
(
	uczestnik BIGINT CONSTRAINT fk_udzial_uczestnik REFERENCES Uczestnicy(pesel),
	kurs INT CONSTRAINT fk_udzial_kurs REFERENCES Kursy(kod),
	data_od DATE,
	data_do DATE,
	status VARCHAR(20) CONSTRAINT ck_udzial_status CHECK (status IN('w trakcie', 'ukonczony', 'nie ukonczony')),
	CONSTRAINT ck_udzial_data_do CHECK (data_do > data_od)
);

EXEC sp_tables
	@table_name = '%',
	@table_owner = 'dbo',
	@table_type = "'table'";

EXEC sp_columns @table_name = 'Kursy';
EXEC sp_helpconstraint @objname = 'Kursy';
EXEC sp_pkeys 'Pracownicy';
EXEC sp_fkeys 'Pracownicy';

-- zad 2
-- a)
ALTER TABLE Uczestnicy
ADD email VARCHAR(50);

-- b)
ALTER TABLE Uczestnicy
ADD CONSTRAINT ck_uczest_pesel CHECK (LEN(pesel) = 11);

INSERT INTO Uczestnicy
VALUES ('12312312312', 'Kowalski', 'Warszawa', 'kowal@wp.pl');

INSERT INTO Uczestnicy
VALUES ('123123123', 'Kowalski', 'Warszawa', 'kowal@wp.pl');

INSERT INTO Uczestnicy
VALUES ('123123123ab', 'Kowalski', 'Warszawa', 'kowal@wp.pl');


-- c)
ALTER TABLE Udzial
ALTER COLUMN uczestnik BIGINT NOT NULL;

ALTER TABLE Udzial
ALTER COLUMN kurs INT NOT NULL;

ALTER TABLE Udzial
ALTER COLUMN data_od DATE NOT NULL;

ALTER TABLE Udzial
ADD CONSTRAINT complex_key_udzial_uczestnik_kurs_data_od PRIMARY KEY (uczestnik, kurs, data_od);

-- d)
ALTER TABLE Kursy
DROP CONSTRAINT ck_kursy_liczba_dni;

-- e)
ALTER TABLE Kursy
ADD kod_2 INT 

CREATE SEQUENCE seq_kod 
	START WITH 0 
	INCREMENT BY 1;
GO

ALTER TABLE Kursy
ADD CONSTRAINT seq_kursy_kod_2 DEFAULT (NEXT VALUE FOR seq_kod) FOR kod_2;

INSERT INTO Kursy(nazwa, liczba_dni) VALUES
('Programowanie', 5),
('Bazy danych',   7);

GO

SELECT * FROM Kursy;
SELECT current_value FROM sys.sequences WHERE name = 'seq_kod';

-- zad 3
DROP TABLE Udzial;
DROP TABLE Kursy;
DROP TABLE Uczestnicy;