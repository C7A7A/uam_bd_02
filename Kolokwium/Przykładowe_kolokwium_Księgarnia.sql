SELECT * FROM Autorzy;
SELECT * FROM Ksiazki;

-- 1
SELECT nazwisko, kraj
FROM Autorzy
WHERE  kraj <> 'Polska'
ORDER BY nazwisko;

-- 2
SELECT tytul
FROM Ksiazki
WHERE tytul LIKE '%XML%'
ORDER BY tytul;

-- 3
SELECT   K1.tytul
FROM     Ksiazki K1
         JOIN Ksiazki K2
           ON K2.tytul = 'Fuzzy Logic'
              AND K1.cena > K2.cena
ORDER BY K1.tytul;

-- 4
SELECT tytul
FROM Ksiazki
WHERE cena > (
	SELECT cena
	FROM Ksiazki
	WHERE tytul = 'Fuzzy Logic'
)
ORDER BY tytul;

-- 5
SELECT DISTINCT nazwisko
FROM Autorzy
JOIN Ksiazki
  ON Autorzy.id_autor = Ksiazki.autor
WHERE dzial = 'informatyka'
ORDER BY nazwisko;

-- 6
SELECT DISTINCT nazwisko
FROM Autorzy
WHERE id_autor IN (
	SELECT autor
	FROM Ksiazki
	WHERE dzial = 'informatyka'
);

-- 7
SELECT DISTINCT nazwisko
FROM Autorzy A
JOIN Ksiazki K
  ON A.id_autor = K.autor
WHERE dzial IN (
	SELECT dzial
	FROM Ksiazki
	WHERE autor = (
		SELECT id_autor
		FROM Autorzy
		WHERE  nazwisko = 'Yen'
	)
) AND nazwisko <> 'Yen'
ORDER BY nazwisko;

-- 8
SELECT dzial, COUNT(id_ksiazki) AS [ile]
FROM Ksiazki
GROUP BY dzial
ORDER BY dzial;

-- 9
SELECT AVG(cena) AS [srednia]
FROM Ksiazki
JOIN Autorzy
  ON Ksiazki.autor = Autorzy.id_autor
WHERE nazwisko = 'Sapkowski';

-- 10
SELECT tytul
FROM Ksiazki
WHERE cena = (
	SELECT MIN(cena)
	FROM Ksiazki
	WHERE dzial = 'informatyka'
)

-- 11
SELECT dzial, tytul
FROM Ksiazki
WHERE cena IN (
	SELECT MIN(cena)
	FROM Ksiazki
	GROUP BY dzial
)
ORDER BY dzial;

-- 12
SELECT nazwisko, COUNT(id_autor) AS [ile]
FROM Autorzy
JOIN Ksiazki
  ON Autorzy.id_autor = Ksiazki.autor
WHERE rok_wydania > '1996'
GROUP BY nazwisko
HAVING COUNT(id_autor) > 1;

-- 13
SELECT dzial, COUNT(DISTINCT autor) AS [licz_autorow]
FROM Ksiazki
JOIN Autorzy
  ON Ksiazki.autor = Autorzy.id_autor
GROUP BY dzial
HAVING COUNT(DISTINCT autor) > 1
ORDER BY dzial;

-- 14
SELECT dzial, COUNT(id_ksiazki) AS [ile ksi¹¿ek]
FROM Ksiazki
GROUP BY dzial
HAVING COUNT(id_ksiazki) = (
	SELECT MAX(n) FROM (
		SELECT COUNT(id_ksiazki) AS n
		FROM Ksiazki
		GROUP BY dzial
	) AS XD
);

-- 15
SELECT   A.nazwisko
FROM     Autorzy A
WHERE    NOT EXISTS (SELECT K1.dzial
                     FROM   Ksiazki K1
                     WHERE  NOT EXISTS (SELECT *
                                        FROM   Ksiazki K2
                                        WHERE  K2.dzial = K1.dzial
                                               AND K2.autor = A.id_autor)
                     )
ORDER BY A.nazwisko;

-- 16
SELECT nazwisko
FROM Autorzy
LEFT JOIN Ksiazki
  ON Autorzy.id_autor = Ksiazki.autor
WHERE tytul IS NULL
ORDER BY nazwisko;

-- 17
SELECT nazwisko
FROM Autorzy A
WHERE NOT EXISTS (
	SELECT *
	FROM Ksiazki K
	WHERE K.autor = A.id_autor
);

-- 18
SELECT nazwisko
FROM Autorzy A
WHERE NOT EXISTS (
	SELECT *
	FROM Ksiazki K
	WHERE K.autor = A.id_autor
);

-- 19
SELECT K1.tytul
FROM Ksiazki K1
WHERE cena > ( SELECT AVG(cena)
			   FROM Ksiazki K2
			   WHERE K1.dzial = K2.dzial)
ORDER BY K1.tytul;
