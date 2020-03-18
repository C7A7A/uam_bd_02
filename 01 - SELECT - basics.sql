USE Projekty;

SELECT * FROM Stanowiska;
SELECT * FROM Projekty;
SELECT * FROM Pracownicy;
SELECT * FROM Realizacje;

-- zadanie 1
SELECT id, nazwa, stawka
FROM Projekty;

-- zadanie 2
SELECT * FROM Pracownicy;

-- zadanie 3
SELECT  nazwa [nazwa stanowiska],
		placa_min [p³aca minimalna na stanowisku]
FROM Stanowiska;

-- zadanie 4
SELECT nazwa, LEN(nazwa) [liczba znaków] FROM Stanowiska;

-- zadanie 5
SELECT nazwisko, placa * 12 [roczny przychód z pensji] FROM Pracownicy;

-- zadanie 6
SELECT nazwisko, DATEDIFF(mm, 01-01-2020, zatrudniony) [mies. zatrudniony] 
FROM Pracownicy;

-- pzyk³ad 8
SELECT id, 
       nazwisko, 
       ISNULL(szef, id) AS [kto jest szefem]
FROM   Pracownicy;

SELECT id, 
       nazwisko, 
       szef AS [kto jest szefem]
FROM   Pracownicy;

-- zadanie 7
SELECT nazwisko, (placa + ISNULL(dod_funkc, 0)) * 12  [roczne wynagrodzenie]
FROM Pracownicy;

-- zadanie 8
SELECT nazwa, ISNULL(DATEDIFF(mm, dataRozp, dataZakonczFakt), 
			  DATEDIFF(mm, dataRozp, GETDATE())) [czas trwania]
FROM Projekty;

-- zadanie 9
SELECT CONVERT(NUMERIC(3, 2), 2.0/4);

-- zadanie 10
SELECT DISTINCT kierownik FROM Projekty;

-- zadanie 11
SELECT nazwa, placa_min 
FROM Stanowiska
ORDER BY placa_min DESC, nazwa;

-- zadanie 12
SELECT TOP 1 nazwa, dataRozp, kierownik
FROM Projekty
ORDER BY dataRozp DESC; 

-- zadanie 13
SELECT id, nazwisko, placa, stanowisko
FROM Pracownicy
WHERE stanowisko = 'adiunkt' OR stanowisko = 'doktorant' AND placa > 2200;

-- zadanie 14
SELECT nazwa
FROM Projekty
WHERE nazwa LIKE '%web%';

-- zadanie 15
SELECT nazwisko
FROM Pracownicy
WHERE szef IS NULL;

-- zadanie 16
SELECT id, nazwisko, placa, dod_funkc, (placa + ISNULL(dod_funkc, 0)) [pensja]
FROM Pracownicy
WHERE (placa + ISNULL(dod_funkc, 0)) > 3500;

-- zadanie 17
SELECT nazwa,
	CASE 
		WHEN nazwa IN('adiunkt', 'doktorant', 'profesor') THEN 'badawcze'
		ELSE 'administracyjne'
	END AS [typ stanowiska]
FROM Stanowiska;

-- Æwiczenia dodatkowe
-- i
SELECT CONCAT('Pracownik nr. ', ROW_NUMBER() OVER(ORDER BY (SELECT NULL)), ' - ', nazwisko) [informacje]
FROM Pracownicy;

-- ii
SELECT nazwisko, placa, dod_funkc
FROM Pracownicy
WHERE (0.10 * placa) < dod_funkc

-- iii
SELECT id, nazwa, dataZakonczFakt
FROM Projekty
WHERE dataZakonczFakt is NULL;

-- iv
SELECT id, nazwisko,
	CASE
		WHEN dod_funkc IS NULL THEN '100'
		ELSE dod_funkc
	END AS [premia œwi¹teczna]
FROM Pracownicy
WHERE stanowisko NOT LIKE 'profesor';

-- v
-- NULL

-- vi
SELECT id,
       nazwa,
       dataZakonczFakt,
       CASE 
            WHEN dataZakonczFakt IS NULL THEN 0
            ELSE           1
       END AS 'test CASE'
FROM   Projekty;

-- vii
SELECT id, nazwisko, stanowisko
FROM Pracownicy
ORDER BY
	CASE WHEN stanowisko = 'profesor' THEN 0
		 WHEN stanowisko = 'adiunkt' THEN 1
		 WHEN stanowisko = 'doktorant' THEN 2
		 WHEN stanowisko = 'sekretarka' THEN 3
		 ELSE 4
	END

-- Zadanie domowe
USE II_Wojna_Swiatowa;

SELECT * FROM Bitwy;
SELECT * FROM Klasy;
SELECT * FROM Okrety;
SELECT * FROM Skutki;

-- i
SELECT klasa, kraj
FROM Klasy
WHERE liczbaDzial >= 10;

-- ii
SELECT nazwa [nazwaOkretu]
FROM Okrety
WHERE zwodowano < 1918
ORDER BY nazwa;

-- iii
SELECT okret,
	CASE
		WHEN bitwa IS NULL THEN 'brak danych'
		ELSE bitwa
	END AS [bitwa]
FROM Skutki
WHERE efekt = 'zatopiony';

-- iv
SELECT nazwa [nazwaOkretu]
FROM Okrety
WHERE nazwa = klasa;

-- v
SELECT nazwa [nazwaOkretu]
FROM Okrety
WHERE nazwa LIKE 'R%';

SELECT okret [nazwaOkretu]
FROM Skutki
WHERE okret LIKE 'R%';

-- vi
SELECT nazwa [nazwaOkretu]
FROM Okrety
WHERE nazwa LIKE '% % %';

SELECT okret [nazwaOkretu]
FROM Skutki
WHERE okret LIKE '% % %';

-- vii
SELECT DISTINCT bitwa
FROM Skutki
WHERE 
	efekt = 'zatopiony' AND bitwa IS NOT NULL;

-- viii
SELECT TOP 1 zwodowano, nazwa
FROM Okrety
ORDER BY zwodowano DESC;

-- ix
SELECT LEFT(nazwa, 5) [nazwa_5]
FROM Bitwy;

-- x
SELECT nazwa, FORMAT(data, 'MMM dd yyyy') [data bitwy]
FROM Bitwy;

-- xi
SELECT nazwa, DATEDIFF(yy, data, GETDATE()) [ile lat minê³o]
FROM Bitwy
WHERE  DATEDIFF(yy, data, GETDATE()) > 77
ORDER BY data;

-- xii
SELECT nazwa, klasa, zwodowano
FROM Okrety
ORDER BY 3 DESC, 1;

-- xiii
SELECT klasa,
	CASE
		WHEN typ = 'pn' THEN 'pancernik'
		WHEN typ = 'kr' THEN 'kr¹¿ownik'
		ELSE 'nieznany'
	END AS [typ]
FROM Klasy;