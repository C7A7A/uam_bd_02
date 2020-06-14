USE dbad_kol_zaklad_zegarmistrzowski;

SELECT * FROM Klienci
SELECT * FROM Naprawy
SELECT * FROM Zegarmistrzowie

-- 1
SELECT imie, nazwisko
FROM Klienci
WHERE imie LIKE 'K%'
ORDER BY imie;

-- 2
SELECT DISTINCT imie, nazwisko
FROM Zegarmistrzowie Z
JOIN Naprawy N
  ON Z.id_zegarmistrza = N.zegarmistrz
WHERE doswiadczenie IN('mistrz', 'czeladnik') 
	  AND status = 'ukonczony'
ORDER BY nazwisko

-- 3
SELECT id_naprawy, koszt, czy_zaplacono
FROM Naprawy
WHERE zegarmistrz IN (SELECT id_zegarmistrza
					  FROM Zegarmistrzowie
					  WHERE doswiadczenie = 'czeladnik')
ORDER BY koszt;

-- 4
SELECT imie, nazwisko, COUNT(*) AS [ile]
FROM Zegarmistrzowie Z
JOIN Naprawy N
  ON Z.id_zegarmistrza = N.zegarmistrz
GROUP BY imie, nazwisko
HAVING COUNT(*) > 1
ORDER BY nazwisko;

-- 5
SELECT imie, nazwisko
FROM Zegarmistrzowie
WHERE id_zegarmistrza = (SELECT zegarmistrz
						 FROM Naprawy
						 WHERE koszt = (SELECT MAX(koszt)
										FROM Naprawy)
						)
-- 6
SELECT YEAR(data_przyjecia) AS [rok], koszt
FROM Naprawy N1
WHERE koszt = (SELECT MAX(N2.koszt)
			   FROM Naprawy N2
			   WHERE YEAR(N2.data_przyjecia) = YEAR(N1.data_przyjecia))
ORDER BY YEAR(data_przyjecia)

-- 7
SELECT imie, nazwisko, nr_telefonu
FROM Klienci K
WHERE NOT EXISTS (SELECT klient
			      FROM Naprawy N
				  WHERE K.id_klienta = N.klient)
ORDER BY nr_telefonu

-- 8

-- 9

-- 10

-- 11

-- 12

-- 13

-- 14

-- 15

-- 16