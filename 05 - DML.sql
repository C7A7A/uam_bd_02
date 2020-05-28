-- zad 1
CREATE TABLE KursyKopia
(
    Kod        INT IDENTITY(100, 100) CONSTRAINT pk_kursy_kopia_kod PRIMARY KEY,
    nazwa      VARCHAR(50) CONSTRAINT uq_kursy_kopia_nazwa UNIQUE,
    liczba_dni INT,
    cena       AS liczba_dni * 1000,
    CONSTRAINT ck_kursy_kopia_dni CHECK (liczba_dni BETWEEN 1 AND 5)
);

EXEC sp_helpconstraint @objname = 'KursyKopia';

-- zad 2
-- a)
INSERT INTO Uczestnicy (PESEL, nazwisko, email)
VALUES ('12312312312', 'Czajka', 'czmateusz@XD.pl');

-- b)
INSERT INTO Uczestnicy (PESEL, nazwisko, email)
VALUES ('12312312312', 'Czajka', 'czmateusz@XD.pl');
-- b³¹d - primary key

-- c)
INSERT INTO Udzial
VALUES (
	'12312312312',
	(SELECT kod FROM Kursy WHERE nazwa='Analiza danych'),
	'2017-10-20',
	'2017-10-22',
	'ukonczony'
);

-- zad 3
-- a)
UPDATE Kursy
SET liczba_dni = liczba_dni + 1
WHERE nazwa LIKE '%MySQL%';

-- b)
ALTER TABLE Uczestnicy
ADD Rok_urodzenia INT;

UPDATE Uczestnicy
SET Rok_urodzenia = CONCAT('19', LEFT(PESEL, 2));

SELECT * FROM Uczestnicy;

-- zad 4
SELECT * FROM MapujMiasta;
SELECT miasto FROM Uczestnicy;

UPDATE Uczestnicy
SET miasto = MapujMiasta.forma_poprawna
FROM Uczestnicy
	INNER JOIN MapujMiasta
	ON miasto = MapujMiasta.forma_niepoprawna;

-- zad 5
SELECT * FROM Uczestnicy;
SELECT * FROM Udzial;
-- a)
DELETE FROM Uczestnicy
WHERE nazwisko = 'Jakubowicz';

-- b) ON DELETE SET NULL 
DELETE FROM Uczestnicy
WHERE nazwisko = 'Jakubowicz';

-- c) ON DELETE CASCADE
DELETE FROM Uczestnicy
WHERE nazwisko = 'Jakubowicz';

-- zad 6
SELECT * FROM Uczestnicy;
SELECT * FROM UczestnicyAktualnie;

MERGE Uczestnicy
USING UczestnicyAktualnie
	  ON Uczestnicy.PESEL = UczestnicyAktualnie.PESEL
WHEN  MATCHED THEN
	  UPDATE SET Uczestnicy.miasto = UczestnicyAKtualnie.miasto
WHEN  NOT MATCHED THEN
	  INSERT (PESEL, nazwisko, miasto, email)
	  VALUES (UczestnicyAKtualnie.PESEL, UczestnicyAKtualnie.nazwisko, UczestnicyAKtualnie.miasto, UczestnicyAKtualnie.email)
OUTPUT deleted.*,
	   inserted.*;

-- Zadanie domowe
SELECT * FROM Produkt;
SELECT * FROM PC;
SELECT * FROM Laptop;
SELECT * FROM Drukarka;
-- i
INSERT INTO PC
VALUES ('1100', '3.2', '1024', '180','2499');

INSERT INTO Produkt
VALUES ('C', '1100', 'pc');

-- ii

-- iii
DELETE FROM PC
WHERE PC.dysk < 100

-- iv

-- v

-- vi

-- vii
