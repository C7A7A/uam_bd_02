-- zadanie 1
SELECT P.nazwisko
FROM Pracownicy P
WHERE P.placa > (
	SELECT P.placa
	FROM Pracownicy P
	WHERE P.nazwisko = 'Ró¿ycka'
);

-- zadanie 2
SELECT P.nazwisko
FROM Pracownicy P
WHERE P.id NOT IN (
	SELECT Pr.kierownik
	FROM Projekty Pr
);

-- zadanie 3
SELECT P.nazwisko
FROM Pracownicy P
WHERE P.id NOT IN (
	SELECT R.idPrac
	FROM Realizacje R
	WHERE R.idProj = 10
);

-- zadanie 4
SELECT P.nazwisko
FROM Pracownicy P
WHERE P.id IN (
	SELECT R.idPrac
	FROM Projekty Pr
		JOIN Realizacje R
			ON Pr.id = R.idProj
	WHERE Pr.nazwa = 'e-learning'
);

-- zadanie 5
SELECT P.nazwisko, P.placa
FROM Pracownicy P
WHERE P.placa >= ALL (
	SELECT P.placa
	FROM Pracownicy P
);

-- przyklad 6
SELECT *
FROM   Pracownicy P
WHERE  P.placa > (SELECT S.placa_max 
                  FROM   Stanowiska S
                  WHERE  S.nazwa = P.stanowisko);

-- zadanie 6
SELECT Pr.id, Pr.nazwa, Pr.stawka, Pr.stawka * 40 AS [tygodniowka], Pr.kierownik, P.nazwisko, P.placa
FROM Projekty Pr
	JOIN Pracownicy P
		ON Pr.kierownik = P.id

SELECT Pr.nazwa
FROM Projekty Pr
WHERE (Pr.stawka * 40) > (
	SELECT P.placa
	FROM Pracownicy P
	WHERE P.id = Pr.kierownik
);

-- zadanie 7
SELECT P.nazwisko, P.id
FROM Pracownicy P
WHERE P.nazwisko IN (
	SELECT P1.nazwisko
	FROM Pracownicy P1 
	WHERE P1.id != P.id 
);

SELECT P.nazwisko 
FROM Pracownicy P 
WHERE P.nazwisko IN ( 
	SELECT P1.nazwisko 
	FROM Pracownicy P1  
	WHERE P1.nazwisko = P.nazwisko    
	  AND P1.id > P.id  
);

-- zadanie 8
SELECT DISTINCT	P.nazwisko
FROM Pracownicy P
	JOIN Realizacje R
		ON P.id = R.idPrac
WHERE P.szef IN (
	SELECT P2.szef
	FROM Pracownicy P2
		JOIN Realizacje R2
			 ON R2.idPrac = P2.szef
	WHERE P.szef = P2.szef
		AND R.idProj = R2.idProj
);

-- zadanie 9
SELECT DISTINCT P.nazwisko
FROM Pracownicy P
	JOIN Realizacje R
		ON P.id = R.idPrac
	JOIN Pracownicy P2
		ON P2.id = P.id
	JOIN Realizacje R2
		ON R2.idPrac = P2.szef
WHERE P.szef = P2.szef 
  AND R.idProj = R2.idProj

-- zadanie 10
SELECT P.nazwisko
FROM Pracownicy P
WHERE NOT EXISTS (
	SELECT Pr.kierownik
	FROM Projekty Pr
	WHERE Pr.kierownik = P.id
);

-- zadanie 11
SELECT id, nazwisko
FROM  Pracownicy
WHERE id NOT IN (
	SELECT szef
	FROM Pracownicy 
);

SELECT id, nazwisko
FROM  Pracownicy P1
WHERE NOT EXISTS (
	SELECT id 
	FROM Pracownicy P2
	WHERE P2.szef = P1.id 
);

-- zadanie 12
SELECT P.nazwisko
FROM Pracownicy P
WHERE NOT EXISTS (
				  SELECT *
				  FROM Projekty Pr
				  WHERE NOT EXISTS (
									SELECT *
									FROM Realizacje R
									WHERE R.idPrac = P.id
									  AND R.idProj = Pr.id
				 )
);

-- æwiczenia dodatkowe
-- i
SELECT P.nazwisko
FROM Pracownicy P
WHERE P.id = (
	SELECT Pr.kierownik
	FROM Projekty Pr
	WHERE Pr.nazwa = 'neural network'
);

-- ii
SELECT Pr.nazwa
FROM Projekty Pr
WHERE Pr.kierownik IN(
	SELECT P.id
	FROM Pracownicy P
	WHERE P.nazwisko = 'Mielcarz'
);

-- iii
SELECT P.nazwisko
FROM Pracownicy P
WHERE P.id NOT IN (
	SELECT DISTINCT P.szef
	FROM Pracownicy P
	WHERE P.szef IS NOT NULL
);

--- iv
-- a)TODO
SELECT P.stanowisko, P.nazwisko
FROM Pracownicy P
WHERE P.placa > ALL (
	SELECT P2.placa 
	FROM Pracownicy P2
	WHERE P.stanowisko = P2.stanowisko
);

-- b)TODO

-- Zadania domowe
-- i
SELECT K.kraj
FROM Klasy K
WHERE K.liczbaDzial >= ALL (
	SELECT K.liczbaDzial
	FROM Klasy K
);

-- ii
SELECT O.klasa
FROM Okrety O
WHERE O.nazwa IN (
	SELECT S.okret
	FROM Skutki S
	WHERE S.efekt = 'zatopiony'
);

-- iii
SELECT O.nazwa
FROM Okrety O
WHERE O.klasa IN (
	SELECT K.klasa
	FROM Klasy K
	WHERE K.kaliber = 16
);

-- iv
SELECT S.bitwa
FROM Skutki S
WHERE S.okret IN (
	SELECT O.nazwa
	FROM Okrety O
	WHERE O.klasa = 'Kongo'
);

-- v TODO
SELECT K.kaliber, O.nazwa, K.liczbaDzial
FROM Klasy K
	JOIN Okrety O
		ON O.klasa = K.klasa
WHERE  (
	SELECT K.liczbaDzial
	FROM Klasy K
);
