EXEC sp_tables   
   @table_name = '%',
   @table_owner = 'dbo',
   @table_type = "'view'";
GO

-- Zadanie 1
CREATE VIEW AktualneProjekty(nazwa, kierownik, [liczba pracowników])
AS
(
    SELECT nazwa, nazwisko, COUNT(Realizacje.idPrac) AS [liczba pracowników]
	FROM Projekty
		JOIN Pracownicy
			ON Projekty.kierownik = Pracownicy.id
		JOIN Realizacje
			ON Realizacje.idProj = Projekty.id
	WHERE dataZakonczFakt IS NULL
	GROUP BY nazwisko, nazwa
);
GO

SELECT TOP 1 nazwa, [liczba pracowników]
FROM AktualneProjekty
ORDER BY [liczba pracowników] DESC;

-- Zadanie 2
CREATE TABLE Nauczyciele
(
    id_nauczyciela INT NOT NULL PRIMARY KEY,
    imie           VARCHAR(30),
    nazwisko       VARCHAR(30),
    dyzur          VARCHAR(30),
    zarobek        FLOAT
);

INSERT INTO Nauczyciele VALUES
(1, 'Józef',   'Kowalski',  'wtorek',       2000),
(2, 'Jan',     'Nowak',     'poniedzia³ek', 1900),
(3, 'Tomasz',  'Iksiñski',  'czwartek',     3200),
(4, 'Alicja',  'Goldstein', 'wtorek',       2500),
(5, 'Halina',  'Nowak',     'œroda',        1200),
(6, 'Gra¿yna', 'Rotfeld',   'pi¹tek',       5000);

CREATE TABLE #Nauczyciele_do_usuniecia
(
	id INT NOT NULL PRIMARY KEY,
);

INSERT INTO #Nauczyciele_do_usuniecia
SELECT id_nauczyciela
FROM Nauczyciele
WHERE nazwisko = 'Nowak';

DELETE FROM Nauczyciele
WHERE id_nauczyciela IN(
	SELECT *
	FROM #Nauczyciele_do_usuniecia
);

SELECT * FROM Nauczyciele;

-- Zadanie 3
Declare @NauczycielePoZwolnieniach TABLE
(
	id_nauczyciela INT NOT NULL Primary Key,
	imie VARCHAR(40),
	nazwisko VARCHAR(50),
	zarobek FLOAT
);

INSERT INTO @NauczycielePoZwolnieniach
SELECT	id_nauczyciela, imie, nazwisko, zarobek
FROM	Nauczyciele;

SELECT * 
FROM   @NauczycielePoZwolnieniach;

UPDATE @NauczycielePoZwolnieniach
SET		zarobek = zarobek * 1.1;

SELECT * 
FROM   @NauczycielePoZwolnieniach;

-- Zadanie 4
WITH P
AS
(
	SELECT	nazwisko, placa, dod_funkc, (placa + ISNULL(dod_funkc, 0)) AS [miesiêczna pensja]
	FROM	Pracownicy
)
SELECT	*
FROM	P
WHERE	"miesiêczna pensja" > 2000;

SELECT * FROM Pracownicy
GO

-- Zadanie 5
WITH Kierownicy
AS
(
	SELECT Pracownicy.id, nazwisko, nazwa AS [nazwa projektu]
	FROM Pracownicy
			JOIN Projekty
					ON Pracownicy.id = Projekty.kierownik
),
NajlepiejNajgorzejOplacani
AS
(
	SELECT	szef,
			MAX(placa) AS [najwiêksza p³aca],
			MiN(placa) AS [najni¿sza p³aca]
	FROM Pracownicy
	WHERE szef IS NOT NULL
	GROUP BY szef
)
SELECT N.szef, K.*, N.[najwiêksza p³aca], N.[najni¿sza p³aca]
FROM Kierownicy K
			JOIN NajlepiejNajgorzejOplacani N
					ON K.id = N.szef;

-- Zadanie 6
WITH CTE_Mielcarz(nazwisko, id, poziom)
AS
(
	SELECT	nazwisko,
			id,
			1
	FROM	Pracownicy
	WHERE	szef = (
				SELECT id
				FROM Pracownicy
				WHERE nazwisko = 'Mielcarz'
			)

	UNION ALL

	SELECT	P.nazwisko,
			P.id,
			M.poziom + 1
	FROM	CTE_Mielcarz M
			JOIN Pracownicy P
			  ON M.id = P.szef
)
SELECT * FROM CTE_Mielcarz;
SELECT * FROM Pracownicy;

-- Zadanie 7
WITH CTE_Przelozeni(nazwisko, szef, poziom)
AS
(
	SELECT	nazwisko,
			szef,
			1
	FROM	Pracownicy P
	WHERE	P.id = (SELECT szef FROM Pracownicy WHERE nazwisko = 'Andrzejewicz')

	UNION ALL

	SELECT	P.nazwisko,
			P.szef,
			Prz.poziom + 1
	FROM Pracownicy P
			JOIN CTE_Przelozeni Prz
				ON P.id = Prz.szef
)
SELECT * FROM CTE_Przelozeni;

-- Zadania domowe
-- Zadanie 1
GO
CREATE VIEW ProduktPC(producent, model, szybkosc, ram, dysk, cen)
AS
(
	SELECT P.producent, P.model, PC.szybkosc, PC.ram, PC.dysk, PC.cena
	FROM Produkt P
		JOIN PC
		  ON P.model = PC.model
);
GO

SELECT * FROM ProduktPC;

-- Zadanie 2
GO
CREATE VIEW tmp1
AS
(
    SELECT placa 
    FROM   Pracownicy

    UNION ALL

    SELECT placa 
    FROM   Pracownicy
);
GO
SELECT * FROM tmp1;
GO

CREATE OR ALTER VIEW tmp2
AS
(
    SELECT placa 
    FROM   tmp1 T1
    WHERE  (SELECT COUNT(*) 
            FROM   tmp1 T2 
            WHERE  T2.placa >= T1.placa) >= (SELECT COUNT(*)
                                             FROM   Pracownicy)
           AND (SELECT COUNT(*) 
                FROM   tmp1 T3 
                WHERE  T3.placa <= T1.placa) >= (SELECT COUNT(*)
                                                 FROM   Pracownicy)
);
GO
SELECT * FROM tmp2;
GO

CREATE VIEW Zagadka
AS
(
    SELECT AVG(DISTINCT placa) 'zagadkowa wartosc' 
    FROM   tmp2
);
GO

SELECT *
FROM   Zagadka;