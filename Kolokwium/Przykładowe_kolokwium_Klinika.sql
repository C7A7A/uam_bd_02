SELECT * FROM Lekarze;
SELECT * FROM Pacjenci;
SELECT * FROM Wizyty;

-- 1
SELECT nazwisko, imie, specjalnosc, data_urodzenia
FROM Lekarze
WHERE DATEDIFF(YEAR, data_urodzenia, '2020-03-22') > 50 AND
	  specjalnosc IN('pediatra', 'internista')
ORDER BY data_urodzenia;

-- 2
SELECT data_wizyty
FROM Wizyty
JOIN Lekarze
  ON Lekarze.id_lekarza = Wizyty.lekarz
WHERE nazwisko = 'Maslowski' AND
	  YEAR(data_wizyty) = '2006'
ORDER BY data_wizyty;

-- 3
SELECT DISTINCT L.nazwisko, specjalnosc
FROM Lekarze L
JOIN Wizyty W
  ON L.id_lekarza = W.lekarz
JOIN Pacjenci P
  ON P.id_pacjenta = W.pacjent
WHERE P.nazwisko = 'Witkowski';

-- 4
SELECT nazwisko, specjalnosc
FROM Lekarze
WHERE specjalnosc = ( SELECT specjalnosc
					  FROM Lekarze
					  WHERE nazwisko = 'Stefanowicz'
					)
AND nazwisko <> 'Stefanowicz'
ORDER BY nazwisko;

-- 5
SELECT nazwisko
FROM Pacjenci
LEFT JOIN Wizyty
       ON Pacjenci.id_pacjenta = Wizyty.pacjent
WHERE  data_wizyty IS NULL
ORDER BY nazwisko

-- 6
SELECT nazwisko
FROM Pacjenci
WHERE id_pacjenta NOT IN(
	SELECT pacjent
	FROM Wizyty
)
ORDER BY nazwisko

-- 7
SELECT nazwisko
FROM Pacjenci
WHERE NOT EXISTS(
	SELECT pacjent
	FROM Wizyty
	WHERE Wizyty.pacjent = Pacjenci.id_pacjenta
)
ORDER BY nazwisko

-- 8
SELECT specjalnosc, COUNT(*) AS [ilu lekarzy]
FROM Lekarze
GROUP BY specjalnosc
ORDER BY specjalnosc

-- 9
SELECT nazwisko, data_urodzenia
FROM Lekarze
WHERE data_urodzenia = (SELECT MAX(data_urodzenia)
						FROM Lekarze)

-- 10
SELECT nazwisko, specjalnosc, data_urodzenia
FROM Lekarze L1
WHERE data_urodzenia = (SELECT MAX(data_urodzenia)
						FROM Lekarze L2
						WHERE L2.specjalnosc = L1.specjalnosc)
ORDER BY data_urodzenia;

-- 11
SELECT nazwisko, imie, COUNT(*) AS [ile wizyt]
FROM Lekarze L
JOIN Wizyty W
  ON L.id_lekarza = W.lekarz
GROUP BY nazwisko, imie
HAVING COUNT(*) > 10
ORDER BY nazwisko;

-- 12
SELECT SUM(koszt) AS [suma wydatk�w]
FROM Wizyty W
JOIN Pacjenci P
  ON W.pacjent = P.id_pacjenta
WHERE P.nazwisko = 'Gumowska' AND P.imie = 'Anna';

-- 13
SELECT nazwisko, imie, COUNT(*) AS [ile wizyt]
FROM Lekarze L
JOIN Wizyty W
  ON W.lekarz = L.id_lekarza
GROUP BY nazwisko, imie
HAVING COUNT(*) = (SELECT MAX(n) 
				   FROM(SELECT COUNT(*) AS n
				        FROM Lekarze L2
						JOIN Wizyty W2
						  ON W2.lekarz = L2.id_lekarza
						GROUP BY nazwisko, imie
				        ) AS XD
)
