USE dbad_s452648;
 
-- zadanie 1
SELECT id, nazwisko, placa, nazwa, placa_min
FROM Pracownicy CROSS JOIN Stanowiska
ORDER BY nazwisko;

SELECT id, nazwisko, placa, nazwa, placa_min
FROM Pracownicy P CROSS JOIN Stanowiska S
WHERE S.nazwa LIKE 'profesor' OR S.nazwa LIKE 'sekretarka'
ORDER BY nazwisko;

-- zadanie 2
SELECT nazwisko, placa, stanowisko, placa_min, placa_max
FROM Pracownicy P JOIN Stanowiska S
	 ON P.stanowisko = S.nazwa;

-- zadanie 3
SELECT P.id, P.nazwisko, Pr.nazwa
FROM Realizacje R 
	JOIN Pracownicy P 
		ON R.idPrac = P.id
	JOIN Projekty Pr
		ON R.idProj = Pr.id
ORDER BY P.nazwisko;

-- zadanie 4
SELECT nazwisko, placa, stanowisko, placa_min, placa_max
FROM Pracownicy JOIN Stanowiska 
	 ON stanowisko = nazwa
WHERE stanowisko = 'doktorant'
	 AND (placa < placa_min OR placa > placa_max);

-- zadanie 5
SELECT P1.nazwisko AS [pracownik], P2.nazwisko AS [szef]
FROM Pracownicy P1 
	JOIN Pracownicy P2
	ON P1.szef = P2.id;

-- zadanie 6
SELECT P1.id, P1.nazwisko, P2.id, P2.nazwisko
FROM Pracownicy P1 
	JOIN Pracownicy P2
	ON P1.nazwisko = P2.nazwisko
WHERE P1.id > P2.id;

-- przyk³ad 4
SELECT P.nazwisko,
       P.id,
       R.kierownik,
       R.nazwa
FROM   Pracownicy P
       LEFT OUTER JOIN Projekty R
                    ON P.id = R.kierownik;

SELECT P.nazwisko,
       P.id,
       R.kierownik,
       R.nazwa
FROM   Pracownicy P
       INNER JOIN Projekty R
               ON P.id = R.kierownik;

-- zadanie 7
SELECT P1.nazwisko AS [pracownik], P2.nazwisko AS [szef]
FROM Pracownicy P1 
	LEFT OUTER JOIN Pracownicy P2
	ON P1.szef = P2.id;

SELECT P1.nazwisko AS [pracownik], P2.nazwisko AS [szef]
FROM Pracownicy P1 
	RIGHT OUTER JOIN Pracownicy P2
	ON P1.szef = P2.id;

-- przyk³ad 5
SELECT nazwa
FROM   Stanowiska S 
       LEFT OUTER JOIN Pracownicy P
                    ON S.nazwa = P.stanowisko
WHERE  P.id IS NULL;

-- zadanie 8
SELECT P.id, P.nazwisko
FROM Pracownicy P
	LEFT OUTER JOIN Projekty
	ON P.id = Projekty.kierownik
WHERE Projekty.id IS NULL;

-- zadanie 9
SELECT P.nazwisko
FROM Pracownicy P
	LEFT OUTER JOIN Realizacje R
		ON P.id = R.idPrac
			AND R.idProj = 10
WHERE R.idProj iS NULL;

-- zadanie 10 TODO
SELECT P.nazwisko, Pr.id AS [kieruje projektem], R.idProj AS [pracuje w projekcie]
FROM Realizacje R
	JOIN Projekty Pr
		ON R.idPrac = Pr.kierownik
			AND Pr.id <> R.idProj
	RIGHT OUTER JOIN Pracownicy P
		ON P.id = R.idPrac

-- przyk³ad 7
SELECT *
FROM   Projekty P1
       LEFT OUTER JOIN Projekty P2
                    ON P1.stawka > P2.stawka;

SELECT P1.*
FROM   Projekty P1
       LEFT OUTER JOIN Projekty P2
                    ON P1.stawka > P2.stawka
WHERE  P2.id IS NULL;

-- zadanie 11
SELECT P1.nazwisko, P1.placa
FROM Pracownicy P1
	LEFT OUTER JOIN Pracownicy P2
		ON P1.placa < P2.placa
WHERE P2.placa IS NULL;

-- æwiczenia dodatkowe
-- i

-- ii

-- iii

-- iv

-- Zadania domowe
-- i

-- ii

-- iii

-- iv

-- v

-- vi

-- vii

-- viii

-- zapisz inaczej