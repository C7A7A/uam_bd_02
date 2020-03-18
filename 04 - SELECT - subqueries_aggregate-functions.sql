-- zad 1
SELECT COUNT(P.nazwisko) AS [liczba], AVG(P.placa) AS [srednia]
FROM Pracownicy P
	JOIN Realizacje R
		ON P.id = R.idPrac
	JOIN Projekty Pr
		ON Pr.id = R.idProj
WHERE Pr.nazwa = 'e-learning';

-- zad 2
SELECT P.nazwisko, P.placa
FROM Pracownicy P
WHERE P.placa = (
	SELECT MAX(P2.placa)
	FROM Pracownicy P2
);

-- zad 3
SELECT P.stanowisko, P.nazwisko, P.placa
FROM Pracownicy P
WHERE P.placa IN(
	SELECT MAX(P2.placa)
	FROM Pracownicy P2
	WHERE P2.stanowisko = P.stanowisko
);

-- zad 4
SELECT COUNT(DISTINCT R.idPrac) AS [ilu ró¿nych pracownikó]
FROM Realizacje R;

-- zad 5
SELECT COUNT(DISTINCT P.szef) AS [liczba szefów]
FROM Pracownicy p
WHERE P.szef IS NOT NULL;

-- zad 6
SELECT P.szef, MIN(P.placa) AS [minimum], MAX(P.placa) AS [maximum]
FROM Pracownicy P
GROUP BY P.szef
HAVING P.szef IS NOT NULL;

-- zad 7
SELECT DISTINCT P2.id, P2.nazwisko, COUNT(P1.szef) AS [liczba podw³adnych]
FROM Pracownicy P1
	RIGHT JOIN Pracownicy P2
		ON P1.szef = P2.id
GROUP BY P2.nazwisko, P2.id

SELECT *
FROM Pracownicy P1
	RIGHT JOIN Pracownicy P2
		ON P1.szef = P2.id

-- zad 8
SELECT P.nazwisko, COUNT(R.idProj) AS [liczba ró¿nych projektów]
FROM Pracownicy P
	JOIN Realizacje R
		ON P.id = R.idPrac
WHERE P.stanowisko != 'profesor'
GROUP BY P.nazwisko
HAVING COUNT(R.idProj) > 1;

-- zad 9
SELECT P.nazwisko, COUNT(P.nazwisko) AS [liczba]
FROM Pracownicy P
GROUP BY P.nazwisko
HAVING COUNT(P.nazwisko) > 1;

-- przyk³ad 7
SELECT nazwisko, 
       placa, 
       '> 3500' [przedzial]
FROM   Pracownicy
WHERE  placa > 3500

UNION --ALL

SELECT nazwisko, 
       placa, 
       '<= 2500'
FROM   Pracownicy
WHERE  placa <= 2500;

-- zadanie 10
SELECT Pr.nazwa, Pr.dataZakonczPlan,
	CASE
		WHEN Pr.dataZakonczFakt IS NULL THEN 'projekt trwa'
										ELSE 'projekt zakonczony'
	END AS [Status]
FROM Projekty Pr
ORDER BY Status;

-- zadanie 11
SELECT P.id, P.nazwisko
FROM Pracownicy P

EXCEPT

SELECT DISTINCT P.id, P.nazwisko
FROM Pracownicy P
	JOIN Projekty Pr
		ON Pr.kierownik = P.id

-- zadanie 12
SELECT id, nazwisko, placa, dod_funkc, "pensja"
FROM (
	SELECT P.id, P.nazwisko, P.placa, P.dod_funkc, (P.placa + ISNULL(P.dod_funkc, 0)) AS 'pensja'
	FROM Pracownicy P
) AS T
WHERE "pensja" > 3000;

-- zadanie 13
SELECT id, nazwisko, 
	  ROUND(placa/ (SELECT AVG(P.placa) FROM Pracownicy P) * 100, 2, 1) AS [procent œredniej]
FROM Pracownicy P

-- æw. dodatkowe
-- i

-- ii

-- iii

-- zadanie domowe
-- i

-- ii

-- iii

-- iv

-- v

-- vi

-- vii

-- viii

-- ix

-- x