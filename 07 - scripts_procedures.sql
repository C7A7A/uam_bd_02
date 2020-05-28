-- Zadanie 1
DECLARE @zdanie VARCHAR(1000) = 'Ala ma ko   ta                 i  psa';
DECLARE @separator CHAR(1) = ' ';
DECLARE @dl INT;

DECLARE @tabelaWyrazowa TABLE
(
	wyraz VARCHAR(8000)
);

WHILE 1 = 1
	BEGIN
		IF (CHARINDEX(@separator, @zdanie) != 0)
			BEGIN
				SET @dl = CHARINDEX(@separator, @zdanie)

				IF (@dl != 1)
					BEGIN
						INSERT INTO @tabelaWyrazowa
						SELECT LEFT(@zdanie, @dl)
					END

				SET @zdanie = RIGHT(@zdanie, LEN(@zdanie) - @dl)
			END
		ELSE IF (LEN(@zdanie) != 0)
			BEGIN
				INSERT INTO @tabelaWyrazowa
				SELECT @zdanie

				SET @zdanie = ' '
				BREAK;
			END
		ELSE
			BREAK;
	END;

SELECT *
FROM @tabelaWyrazowa;
GO

-- Zadanie 2
CREATE OR ALTER PROCEDURE usp_podwyzka
	@proc TINYINT = 10,
	@kwota MONEY OUTPUT
AS
	SET @kwota = (SELECT SUM(placa) FROM Pracownicy);

	UPDATE Pracownicy
	SET placa = placa + placa * @proc/100
	WHERE placa < 3000;

	SET @kwota = (SELECT SUM(placa) FROM Pracownicy) - @kwota;
GO	

SELECT   *
FROM     Pracownicy
ORDER BY placa;

DECLARE @wynik AS MONEY;

EXEC usp_podwyzka 
     10,
     @wynik OUTPUT;

SELECT @wynik;

SELECT   *
FROM     Pracownicy
ORDER BY placa; 

GO

-- Zadanie 3
CREATE OR ALTER PROCEDURE usp_wstaw_pracownika
	@nazwisko VARCHAR(50),
	@stanowisko VARCHAR(40) = 'doktorant',
	@szef VARCHAR(50),
	@placa MONEY,
	@zatrudniony DATETIME = NULL

AS
	DECLARE @szef_id INT;
	DECLARE @pracownik_id INT;

	IF NOT EXISTS (
		SELECT nazwisko
		FROM Pracownicy
		WHERE nazwisko = @szef
	)
		BEGIN
			RAISERROR(N'Nie ma szefa o takim nazwisku: %s', 16, 1);
			RETURN;
		END

	IF NOT EXISTS (
		SELECT nazwa
		FROM Stanowiska
		WHERE nazwa = @stanowisko
	)
		BEGIN
			RAISERROR(N'Nie ma takiego stanowiska: %s', 16, 1);
			RETURN;
		END

	SET @szef_id = (
		SELECT id
		FROM Pracownicy
		WHERE nazwisko = @szef
	);

	SET @pracownik_id = (
		SELECT ISNULL(MAX(id), 0) + 10
		FROM Pracownicy
	);

	IF @zatrudniony IS NULL
		SET @zatrudniony = GETDATE();

	INSERT INTO Pracownicy(id, nazwisko, szef, placa, stanowisko, zatrudniony)
	VALUES (@pracownik_id, @nazwisko, @szef_id, @placa, @stanowisko, @zatrudniony);
GO

BEGIN TRY
    --EXEC usp_wstaw_pracownika 'Nowak', 'adiunktTT', 'Jankowiak', 2200;
    --EXEC usp_wstaw_pracownika 'Nowak', 'asystent',  'Jankowski', 2200;
    --EXEC usp_wstaw_pracownika 'Nowak', 'adiunkt',   'Wróbel', 2200;
    EXEC usp_wstaw_pracownika 'Nowak', DEFAULT,     'Jankowski', 2200;
    --EXEC usp_wstaw_pracownika @nazwisko = 'Nowak', @szef = 'Jankowski', @placa = 2200, @zatrudniony = '2018-01-01';

    SELECT * 
    FROM   Pracownicy;

    DELETE FROM Pracownicy 
    WHERE  nazwisko = 'Nowak';
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER()  AS ErrorNumber, 
           ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
