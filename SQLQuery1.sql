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
WHERE pensja > 3500