-- Generated by Oracle SQL Developer Data Modeler 19.4.0.350.1424
--   at:        2020-05-14 15:29:47 CEST
--   site:      SQL Server 2012
--   type:      SQL Server 2012

-- DELETE TABLES
DROP TABLE IF EXISTS Opcje_Dostawy;
DROP TABLE IF EXISTS Dostawy;
DROP TABLE IF EXISTS Oferty;
DROP TABLE IF EXISTS Licytacje;
DROP TABLE IF EXISTS Przedmioty;
DROP TABLE IF EXISTS Kategorie;
DROP TABLE IF EXISTS Statusy;
DROP TABLE IF EXISTS U�ytkownicy;

SET LANGUAGE polski
GO

-- CREATE TABLES

CREATE TABLE U�ytkownicy 
    (
     login VARCHAR (50) NOT NULL, 
     imi� VARCHAR (50) NOT NULL, 
     nazwisko VARCHAR (50) NOT NULL , 
     adres_zamieszkania VARCHAR (150) NOT NULL, 
     "e-mail" VARCHAR (100) NOT NULL, 
     numer_konta NUMERIC (26), 
     adres_dostawy VARCHAR (150), 
     telefon VARCHAR (20) 
    )
GO

ALTER TABLE U�ytkownicy
	ADD CONSTRAINT U�ytkownicy_PK PRIMARY KEY (login)
GO

ALTER TABLE U�ytkownicy
	ADD CONSTRAINT unq_email UNIQUE ("e-mail")
GO

ALTER TABLE U�ytkownicy
	ADD CONSTRAINT chk_email CHECK ("e-mail" LIKE '%@%.%')
GO

CREATE TABLE Przedmioty 
    (
     numer INTEGER NOT NULL, 
     nazwa VARCHAR (150) NOT NULL, 
     cena_wyj�ciowa DECIMAL (6,2) NOT NULL, 
     id_kategoria INTEGER NOT NULL, 
     opis TEXT, 
     cena_zakupu DECIMAL (6,2), 
     login VARCHAR (50) NOT NULL 
    )
GO

ALTER TABLE Przedmioty
	ADD CONSTRAINT Przedmioty_PK PRIMARY KEY (numer)
GO

ALTER TABLE Przedmioty 
    ADD CONSTRAINT Przedmioty_U�ytkownicy_FK FOREIGN KEY 
    (login) REFERENCES U�ytkownicy(login) 
			ON DELETE NO ACTION 
			ON UPDATE NO ACTION 
GO

CREATE TABLE Kategorie 
    (
     id INTEGER NOT NULL, 
     opis VARCHAR (150) NOT NULL 
    )
GO

ALTER TABLE Kategorie
	ADD CONSTRAINT Kategorie_PK PRIMARY KEY (id);

ALTER TABLE Przedmioty 
    ADD CONSTRAINT Przedmioty_Kategorie_FK FOREIGN KEY 
	(id_kategoria) REFERENCES Kategorie(id) 
				   ON DELETE NO ACTION 
				   ON UPDATE NO ACTION 
GO

CREATE TABLE Licytacje 
    (
     id INTEGER NOT NULL, 
     data_rozpocz�cia DATE NOT NULL, 
     data_zako�czenia DATE, 
     id_status INTEGER NOT NULL, 
     numer_przedmiot INTEGER NOT NULL, 
     zwyci�zca VARCHAR (50) 
    )
GO

ALTER TABLE Licytacje
	ADD CONSTRAINT Licytacje_PK PRIMARY KEY (id)
GO

ALTER TABLE Licytacje 
    ADD CONSTRAINT Licytacje_Przedmioty_FK FOREIGN KEY 
    (numer_przedmiot) REFERENCES Przedmioty(numer) 
					   ON DELETE NO ACTION 
					   ON UPDATE NO ACTION 
GO

ALTER TABLE Licytacje 
    ADD CONSTRAINT Licytacje_U�ytkownicy_FK FOREIGN KEY 
    (zwyci�zca) REFERENCES U�ytkownicy(login) 
						ON DELETE NO ACTION 
						ON UPDATE NO ACTION 
GO

CREATE TABLE Statusy 
    (
     id INTEGER NOT NULL, 
     opis VARCHAR (150) NOT NULL 
    )
GO

ALTER TABLE Statusy
	ADD CONSTRAINT Statusy_PK PRIMARY KEY (id)
GO

ALTER TABLE Licytacje 
    ADD CONSTRAINT Licytacje_Statusy_FK FOREIGN KEY 
    (id_status) REFERENCES Statusy(id) 
				 ON DELETE NO ACTION 
				 ON UPDATE NO ACTION 
GO

CREATE TABLE Oferty 
    (
     data DATE NOT NULL, 
     godzina TIME NOT NULL, 
     kwota DECIMAL (6,2) NOT NULL, 
     login VARCHAR (50) NOT NULL, 
     id_licytacja INTEGER NOT NULL 
    )
GO

ALTER TABLE Oferty
	ADD CONSTRAINT Oferty_PK PRIMARY KEY (login, id_licytacja, data, godzina)
GO

ALTER TABLE Oferty 
    ADD CONSTRAINT Oferty_Licytacje_FK FOREIGN KEY 
    (id_licytacja) REFERENCES Licytacje(id) 
				   ON DELETE NO ACTION 
				   ON UPDATE NO ACTION 
GO

ALTER TABLE Oferty 
    ADD CONSTRAINT Oferty_U�ytkownicy_FK FOREIGN KEY 
    (login) REFERENCES U�ytkownicy(login) 
						ON DELETE NO ACTION 
						ON UPDATE NO ACTION 
GO

CREATE TABLE Dostawy 
    (
     id INTEGER NOT NULL, 
     nazwa VARCHAR (100) NOT NULL, 
     firma VARCHAR (150) NOT NULL, 
     cena DECIMAL (6,2) NOT NULL 
    )
GO

ALTER TABLE Dostawy
	ADD CONSTRAINT Dostawy_PK PRIMARY KEY (id)
GO

CREATE TABLE Opcje_Dostawy 
    (
     numer_przedmiot INTEGER NOT NULL, 
     id_dostawa INTEGER NOT NULL 
    )
GO

ALTER TABLE Opcje_Dostawy 
	ADD CONSTRAINT Opcje_Dostawy_PK PRIMARY KEY(numer_przedmiot, id_dostawa)
GO

ALTER TABLE Opcje_Dostawy 
    ADD CONSTRAINT Opcje_Dostawy_Dostawy_FK FOREIGN KEY 
    (id_dostawa) REFERENCES Dostawy(id) 
				 ON DELETE NO ACTION 
				 ON UPDATE NO ACTION 
GO

ALTER TABLE Opcje_Dostawy 
    ADD CONSTRAINT Opcje_Dostawy_Przedmioty_FK FOREIGN KEY 
    (numer_przedmiot) REFERENCES Przedmioty(numer) 
					  ON DELETE NO ACTION 
					  ON UPDATE NO ACTION 
GO
-- INSERT DATA
INSERT INTO U�ytkownicy(login, imi�, nazwisko, adres_zamieszkania, [e-mail], 
						numer_konta, adres_dostawy, telefon) VALUES 
	('hahahahaxD', 'Mateusz', 'Nowak', 'ul. Jaka� 12, 12-003 Pozna�', 'test@test.com', '12312312312312312312312313', 'ul. Jaka� 12, 12-003 Pozna�', '997998999'),
	('licytator123', 'Adrianna', 'Marciniak', 'ul. Marcin 1, 77-123 Wroc�aw', 'Adr@gmail.com', NULL, NULL, NULL),
	('useruser', 'Tomasz', '�apka', 'ul. Akacjowa 18, Krak�w', 'user@interia.pl', NULL, 'ul. Marcin 1, 77-123 Wroc�aw', NULL);

INSERT INTO Kategorie(id, opis) VALUES
	(1, 'zabawka'),
	(2, 'ksi��ka'),
	(3, 'p�yta muzyczna'),
	(4, 'gra'),
	(5, 'RTV');

INSERT INTO Przedmioty(numer, nazwa, cena_wyj�ciowa, id_kategoria, opis, cena_zakupu, login) VALUES
	(1, 'drewniane szachy', 80, 4, 'Stare szachy wykonane z drewna, bardzo dobry stan', NULL, 'licytator123'),
	(2, 'ABC - alfabet dla najm�odszych!', 5, 2, NULL, 1, 'hahahahaxD'),
	(3, 'PlayStation 5', 1300, 5, 'Konsola + pakiet gier', 1800, 'useruser'),
	(4, 'Seer', 50, 3, 'album Seer zespo�u Swans', 80, 'hahahahaxD'),
	(5, 'figurki rycerzy', 70, 1, '100 ma�ych figurek', 120, 'licytator123');

INSERT INTO Statusy(id, opis) VALUES
	(1, 'w trakcie'),
	(2, 'zako�czona kupnem'),
	(3, 'zako�czona bez kupna');

INSERT INTO Licytacje(id, data_rozpocz�cia, data_zako�czenia, id_status, numer_przedmiot, zwyci�zca) VALUES
	(1, '19-05-2020', '21-05-2020', 2, 1, 'hahahahaxD'),
	(2, '19-05-2020', '30-05-2020', 1, 2, NULL),
	(3, '19-05-2020', '22-05-2020', 2, 3, 'licytator123'),
	(4, '14-05-2020', '20-05-2020', 3, 4, NULL),
	(5, '24-05-2020', NULL, 1, 4, NULL);

INSERT INTO Oferty(data, godzina, kwota, login, id_licytacja) VALUES
	('20-05-2020', '23:20:05', 100, 'hahahahaxD', 1),
	('20-05-2020', '23:21:00', 110, 'useruser', 1),
	('20-05-2020', '23:22:21', 120, 'hahahahaxD', 1),
	('21-05-2020', '05:52:54', 10, 'licytator123', 2),
	('22-05-2020', '13:32:21', 15, 'useruser', 2),
	('22-05-2020', '15:01:25', 1500, 'licytator123', 3),
	('24-05-2020', '10:05:47', 65, 'licytator123', 5);

INSERT INTO Dostawy(id, nazwa, firma, cena) VALUES
	(1, 'Paczkomat', 'Inpost', 12),
	(2, 'Kurier', 'UPC', 15),
	(3, 'Kurier', 'Firma kurierska', 14);

INSERT INTO Opcje_Dostawy(numer_przedmiot, id_dostawa) VALUES
	(1, 1),
	(1, 2),
	(1, 3),
	(2, 1),
	(3, 1),
	(4, 2),
	(5, 3);
	
-- SELECT
SELECT * FROM U�ytkownicy;
SELECT * FROM Przedmioty;
SELECT * FROM Kategorie;
SELECT * FROM Licytacje;
SELECT * FROM Statusy;
SELECT * FROM Oferty;
SELECT * FROM Dostawy;
SELECT * FROM Opcje_Dostawy;