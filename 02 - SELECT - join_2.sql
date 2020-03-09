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

-- zadanie 10 
SELECT P.nazwisko, Pr.id AS [kieruje projektem], R.idPrac AS [pracuje w projekcie]
FROM Pracownicy P
	JOIN Projekty Pr 
		ON P.id = Pr.kierownik
	LEFT OUTER JOIN Realizacje R
		ON R.idProj = Pr.id AND
		   R.idPrac = Pr.kierownik
WHERE
	R.idPrac IS NULL;

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
SELECT Pr.nazwa
FROM Pracownicy P
	JOIN Projekty Pr
		ON P.id = Pr.kierownik
WHERE P.nazwisko = 'Mielcarz'

-- ii
SELECT Pr.nazwa
FROM Pracownicy P
	JOIN Realizacje R
		ON P.id = R.idPrac
	JOIN Projekty Pr
		ON R.idProj = Pr.id
WHERE P.nazwisko = 'Andrzejewicz';
		

-- iii
SELECT P.nazwisko, P.placa, (
	SELECT P.placa
	FROM Pracownicy P
	WHERE P.nazwisko = 'Ró¿ycka'
) AS [placa Ró¿yckiej]
FROM Pracownicy P
WHERE P.placa > (
	SELECT P.placa AS [placa Ró¿yckiej]
	FROM Pracownicy P
	WHERE P.nazwisko = 'Ró¿ycka'
)

-- iv
SELECT Pr.nazwa
FROM Pracownicy P
	 JOIN Realizacje R
	   ON R.idPrac = P.id
	 RIGHT OUTER JOIN Projekty Pr
	   ON Pr.id = R.idProj
	   AND P.stanowisko = 'doktorant'
WHERE P.id IS NULL;

-- Zadania domowe
SELECT * FROM Bitwy;
SELECT * FROM Okrety;
SELECT * FROM Skutki;
SELECT * FROM Klasy;

-- i
SELECT O.nazwa
FROM Okrety O
JOIN Klasy K
	ON O.klasa = K.klasa
WHERE K.wypornosc > 35000;

-- ii
SELECT O.nazwa, K.wypornosc, K.liczbaDzial
FROM Okrety O
	JOIN Klasy K
		ON O.klasa = K.klasa
	JOIN Skutki S
		ON S.okret = O.nazwa
	JOIN Bitwy B
		ON B.nazwa = S.bitwa
WHERE B.nazwa = 'Guadalcanal';

-- iii TODO
SELECT K.kraj, K.typ
FROM Okrety O
	JOIN Klasy K
		ON K.klasa = O.klasa
WHERE typ IN('pn', 'kr')

-- iv
SELECT K.klasa, K.typ, K.kraj, K.liczbaDzial, K.kaliber, K.wypornosc, O.nazwa, O.klasa, O.zwodowano
FROM Okrety O
	JOIN Klasy K
		ON O.klasa = K.klasa

-- v
SELECT S.okret, K.wypornosc, K.liczbaDzial
FROM Klasy K
	RIGHT OUTER JOIN Okrety O
		ON O.klasa = K.klasa
	RIGHT OUTER JOIN Skutki S
		ON S.okret = O.nazwa
	JOIN Bitwy B
		ON B.nazwa = S.bitwa
WHERE B.nazwa = 'Guadalcanal';

-- vi


-- vii

-- viii

-- zapisz inaczej