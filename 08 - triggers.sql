-- Zadanie 1
DROP TABLE Pracownicy_Kopia;

SELECT	*
INTO	Pracownicy_Kopia
FROM	Pracownicy;
GO

-- a
CREATE TRIGGER nie_obnizaj_pensji
ON Pracownicy_Kopia
INSTEAD OF UPDATE
AS
	IF (
			SELECT placa
			FROM deleted
		) < (
			SELECT placa
			FROM inserted
		)
		UPDATE Pracownicy_Kopia
		SET placa = (
			SELECT placa
			FROM inserted
		) 
		WHERE id = (
			SELECT id
			FROM inserted
		);
	ELSE
		RAISERROR('NIE OBNI¯AJ PENSJI!', 16, 1);
GO

SELECT * FROM Pracownicy_Kopia;

UPDATE Pracownicy_Kopia
SET    placa = placa - 1000
WHERE  id = 1;

SELECT * FROM Pracownicy_Kopia;

DROP TRIGGER nie_obnizaj_pensji;
GO
-- b
CREATE TRIGGER nie_obnizaj_pensji_b
ON Pracownicy_Kopia
INSTEAD OF UPDATE
AS
DECLARE @rows INT
	UPDATE	Pracownicy_Kopia
	SET		Pracownicy_Kopia.placa = i.placa
	FROM	Pracownicy_Kopia P
		JOIN	inserted i
		  ON	P.id = i.id 
	WHERE	P.placa < i.placa

	SET @rows = (
		SELECT	COUNT(i.id)
		FROM	deleted d
			JOIN	inserted i
			  ON	i.id = d.id
		WHERE d.placa >= i.placa
	)

	IF @rows > 0
		RAISERROR('Liczba niezmodyfikowanych pracownikó: %i', 16, 1, @rows);
GO

SELECT * FROM Pracownicy_Kopia;

UPDATE Pracownicy_Kopia
SET    placa = 3000;

SELECT * FROM Pracownicy_Kopia;
GO

-- Zadanie 2
CREATE TRIGGER modyfikuj_pensje
ON Pracownicy_Kopia
AFTER UPDATE
AS
	IF(UPDATE(placa))
		BEGIN
			UPDATE	Pracownicy_Kopia
			SET		placa = (P.placa*i.placa) / d.placa
			FROM	Pracownicy_Kopia P
			JOIN	inserted i
			  ON	P.szef = i.id
			JOIN	deleted d
			  ON	d.id = i.id
		END;
GO
SELECT * FROM Pracownicy_Kopia

UPDATE Pracownicy_Kopia
SET    placa = 6000
WHERE  id = 1;
GO

-- Zadanie 3
SELECT *
INTO Projekty_Kopia
FROM Projekty;

ALTER TABLE Projekty_Kopia
ADD status BIT DEFAULT 1 WITH VALUES;

SELECT * FROM Projekty_Kopia;
GO

CREATE TRIGGER projekty_usun_ustaw_status
ON Projekty_Kopia
INSTEAD OF DELETE
AS
	UPDATE Projekty_Kopia
	SET Projekty_Kopia.status = 0
	WHERE id IN (
		SELECT id
		FROM deleted
	)

GO


DELETE FROM Projekty_Kopia
WHERE  id IN (20, 40);

SELECT * FROM Projekty_Kopia

-- Zadanie 4
DROP TABLE IF EXISTS Pracownicy_Kopia;
DROP TABLE IF EXISTS Stanowsika_Kopia;

SELECT * 
INTO Pracownicy_Kopia
FROM Pracownicy;

SELECT *
INTO Stanowiska_Kopia
FROM Stanowiska;

ALTER TABLE Stanowiska_Kopia
ADD suma_pensji INT DEFAULT 0 WITH VALUES;
GO

SELECT * FROM Stanowiska_Kopia;
SELECT * FROM Pracownicy_Kopia;

--SELECT SUM(placa), stanowisko
--FROM Pracownicy
--GROUP BY stanowisko;

WITH T
AS
(
	SELECT	s = SUM(placa), stanowisko
	FROM	Pracownicy
	GROUP BY stanowisko
)
UPDATE	Stanowiska_Kopia
SET		suma_pensji = s
FROM	T 
	JOIN	Stanowiska_Kopia
	  ON	Stanowiska_Kopia.nazwa = T.stanowisko
GO

CREATE TRIGGER suma_pensji_akutalizuj
ON		Pracownicy_Kopia
AFTER	UPDATE, DELETE, INSERT
AS
	WITH T
	AS
	(
		SELECT	s = SUM(placa), stanowisko
		FROM	Pracownicy_Kopia
		WHERE	stanowisko IN (
					SELECT stanowisko
					FROM inserted
					UNION
					SELECT stanowisko
					FROM deleted
		) GROUP BY	stanowisko
	)
	UPDATE	Stanowiska_Kopia
	SET		suma_pensji = s
	FROM T	JOIN Stanowiska_Kopia 
			  ON T.stanowisko = Stanowiska_Kopia.nazwa;
GO

UPDATE Pracownicy_kopia
SET    placa = 9000
WHERE  id IN (3, 5, 7);

SELECT * FROM Stanowiska_Kopia
SELECT * FROM Pracownicy_Kopia;

DELETE
FROM   Pracownicy_kopia
WHERE  id IN (4, 6);

INSERT INTO Pracownicy_kopia VALUES
(11, 'Kozak',       1, 4900,  300, 'techniczny', '01-01-1998'),
(12, 'Blumsztajn',  5, 3200, NULL,    'adiunkt', '01-01-2005'),
(13, 'Goldberg',    5, 3800, NULL,    'adiunkt', '01-01-2005'),
(14, 'BlumsztajnXD',  5, 66666, NULL,    'adiunkt', '01-01-2005');

-- Zadanie 5
SELECT *
FROM sys.triggers
WHERE type = 'TR';

DROP TRIGGER suma_pensji_akutalizuj, projekty_usun_ustaw_status, modyfikuj_pensje, nie_obnizaj_pensji_b