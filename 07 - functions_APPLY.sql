-- Zadanie 1
CREATE OR ALTER FUNCTION udf_licz_lata
(
    @zatrudniony DATE
)
    RETURNS INT
AS
BEGIN
    RETURN YEAR(GETDATE()) - YEAR(@zatrudniony)
END;
GO

SELECT *, dbo.udf_licz_lata(zatrudniony) AS 'przepracowanych lat'
FROM Pracownicy

SELECT dbo.udf_licz_lata('1999-07-09')
GO

-- Zadanie 2
CREATE OR ALTER FUNCTION udf_staz_pracy
(
    @x INT
)
    RETURNS TABLE
AS
    RETURN SELECT *
           FROM   Pracownicy
           WHERE  dbo.udf_licz_lata(zatrudniony) > @x
GO

SELECT *, dbo.udf_licz_lata(zatrudniony)
FROM dbo.udf_staz_pracy(15)
GO

-- Zadanie 3
CREATE OR ALTER FUNCTION udf_staz_pracy_2
(
	@x INT
)
	RETURNS @lata TABLE(nazwisko VARCHAR(50), przepracowane_lata INT)
	AS
	BEGIN
			INSERT INTO @lata
			SELECT nazwisko, dbo.udf_licz_lata(zatrudniony)
			FROM Pracownicy
			WHERE dbo.udf_licz_lata(zatrudniony) > @x
		RETURN;
	END;
GO

SELECT *
FROM dbo.udf_staz_pracy_2(15)
GO

-- Zadanie 4
CREATE OR ALTER FUNCTION udf_check_stawka
(
    @x MONEY
)
    RETURNS BIT
AS
BEGIN
    IF EXISTS (
			SELECT stawka
            FROM   Projekty 
            WHERE stawka > (
				SELECT MAX(dod_funkc)
				FROM Pracownicy
			)
		)
        RETURN 0;
    RETURN 1;
END;
GO

ALTER TABLE Projekty
ADD CONSTRAINT ck_projekty_stawka
CHECK (dbo.udf_check_stawka(stawka) = 1);

INSERT INTO Projekty VALUES ('image processing', '01-01-2019', '01-21-2019', NULL, 4, 100);
INSERT INTO Projekty VALUES ('computer vision',  '01-01-2019', '01-21-2019', NULL, 6, 1000);

DELETE FROM Projekty
WHERE  id > 40;

ALTER TABLE     Projekty
DROP CONSTRAINT ck_projekty_stawka;

DROP FUNCTION udf_check_stawka;

-- Zadanie 5
