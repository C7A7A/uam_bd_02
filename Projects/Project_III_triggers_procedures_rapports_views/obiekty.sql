SELECT * FROM U�ytkownicy;
SELECT * FROM Przedmioty;
SELECT * FROM Kategorie;
SELECT * FROM Dostawy;
SELECT * FROM Opcje_Dostawy;
SELECT * FROM Licytacje;
SELECT * FROM Statusy;
SELECT * FROM Oferty;
GO
---- FUNKCJONALNO�CI ----

-- Dodanie nowego uczestnika do serwisu
CREATE OR ALTER PROCEDURE insert_new_user
	@login		VARCHAR(50),
	@name		VARCHAR(50),
	@surname	VARCHAR(50),
	@address	VARCHAR(150),
	@email		VARCHAR(100),
	@acc_num	NUMERIC(26),
	@del_add	VARCHAR(150),
	@phone		VARCHAR(20)
AS
BEGIN
	INSERT INTO U�ytkownicy(login, imi�, nazwisko, adres_zamieszkania, [e-mail], numer_konta, adres_dostawy, telefon)
	VALUES(@login, @name, @surname, @address, @email, @acc_num, @del_add, @phone);
END;
GO

-- Wystawienie przedmiotu na sprzeda� wraz z rozpocz�ciem licytacji
CREATE OR ALTER PROCEDURE list_item_start_auction
	@name		VARCHAR(150),
	@price		DECIMAL(6, 2),
	@category	VARCHAR(150),
	@descr		TEXT,
	@pur_price	DECIMAL(6, 2),
	@login		VARCHAR(50)
AS
BEGIN
	DECLARE @cat_id INT;

	SELECT	@cat_id = id
	FROM	Kategorie
	WHERE	opis = @category

	INSERT INTO Przedmioty(nazwa, cena_wyj�ciowa, id_kategoria, opis, cena_zakupu, login)
	VALUES(@name, @price, @cat_id, @descr, @pur_price, @login);

	DECLARE @today	DATE;
	DECLARE @status BIT;
	DECLARE @number INT;

	SELECT	@number = SCOPE_IDENTITY();

	SELECT @today = GETDATE();

	SELECT	@status = id
	FROM	Statusy
	WHERE	opis = 'w trakcie';

	INSERT INTO Licytacje(data_rozpocz�cia, data_zako�czenia, id_status, numer_przedmiot, zwyci�zca)
	VALUES(@today, NULL, @status, @number, NULL);
END;
GO

-- Dodanie oferty do licytacji
CREATE OR ALTER PROCEDURE add_offer_to_auction
	@date		DATE,
	@time		TIME,
	@amount		DECIMAL(6, 2),
	@login		VARCHAR(50),
	@auction	INT
AS
BEGIN
	-- check if anyone bidded
	IF	EXISTS (SELECT	kwota
			    FROM	Oferty
			    WHERE	id_licytacja = @auction)
		BEGIN
			IF	@amount <= (SELECT MAX(kwota)
							FROM oferty
							WHERE id_licytacja = @auction)
			BEGIN
				RAISERROR('Twoja oferta musi przebi� poprzedni� ofert�', 11, 1);
				RETURN;
			END;
		END;
	ELSE
		BEGIN
			-- check if amount is greater than starting price
			IF	@amount > (SELECT cena_wyj�ciowa
						   FROM Przedmioty
						   WHERE numer = (SELECT	numer_przedmiot
										  FROM		Licytacje
										  WHERE		id = @auction))
				BEGIN
					INSERT INTO Oferty(data, godzina, kwota, login, id_licytacja)
					VALUES(@date, @time, @amount, @login, @auction);
					PRINT 'Oferta zosta�a dodana';
					RETURN;
				END;
			ELSE
				BEGIN
					RAISERROR('Kwota musi by� wi�ksza ni� cena wyj�ciowa przedmiotu', 11, 1);
					RETURN;
				END;
		END;
END;
GO

-- Zako�czenie licytacji; w przypadku, gdy licytacja ko�czy si� sukcesem (kupnem) zostaje wyznaczony i zapisany zwyci�zca licytacji
CREATE OR ALTER PROCEDURE finish_auction
	@id		INT
AS
BEGIN
	-- check if auction exists
	IF	NOT EXISTS (SELECT id
					FROM Licytacje
					WHERE id = @id)
		BEGIN
			RAISERROR('Nie istnieje licytacja o podanym id', 11, 1);
			RETURN;
		END;
	ELSE
		BEGIN
			-- check if auction ended
			IF	EXISTS (SELECT id
						FROM Licytacje
						WHERE id = @id AND data_zako�czenia IS NOT NULL)
				BEGIN
					RAISERROR('Licytacja o podanym id ju� si� zako�czy�a', 11, 1);
					RETURN;
				END;
			ELSE
				BEGIN
					DECLARE	@winner VARCHAR(50);
					DECLARE @status INT;
					DECLARE @today DATE;
					SELECT	@today = GETDATE();
					-- check if anyone bidded
					IF	EXISTS (SELECT login
								FROM Oferty
								WHERE id_licytacja = @id)
						BEGIN
							SELECT	@winner = login
							FROM	Oferty
							WHERE	id_licytacja = @id AND kwota = (SELECT	MAX(kwota)
																	FROM	Oferty
																	WHERE	id_licytacja = @id);
							SELECT	@status = id
							FROM	Statusy
							WHERE	opis = 'zako�czona kupnem';

							UPDATE	Licytacje
							SET		data_zako�czenia = @today,
									id_status		 = @status,
									zwyci�zca		 = @winner
							WHERE	id = @id;

							PRINT 'Licytacja zosta�a zako�czona kupnem';

							RETURN;
						END
					-- ended without buying
					IF NOT EXISTS (SELECT login
								   FROM Oferty
								   WHERE id_licytacja = @id)
						BEGIN
							SELECT	@status = id
							FROM	Statusy
							WHERE opis = 'zako�czona bez kupna';

							UPDATE	Licytacje
							SET		data_zako�czenia = @today,
									id_status		 = @status,
									zwyci�zca		 = NULL
							WHERE	id = @id;

							PRINT 'Licytacja zosta�a zako�czona bez kupna';

							RETURN;
						END;
				END;
	END;
END;
GO

---- OGRANICZENIA ----

-- U�ytkownik nie mo�e licytowa� swojego w�asnego przedmiotu
CREATE OR ALTER TRIGGER tr_prohibit_bidding_item_belonging_to_user
ON Oferty
AFTER INSERT
AS
BEGIN
	DECLARE @row_count	INT;
	SELECT @row_count = @@ROWCOUNT;
	
	IF	@row_count = (SELECT 1)
		BEGIN
			DECLARE @login		VARCHAR(50);
			DECLARE @auction	INT;

			SELECT @login = login, @auction = id_licytacja
			FROM inserted;
		END;
			IF	@auction IN (SELECT id
							 FROM	Licytacje L
							 JOIN	Przedmioty P
							   ON	L.numer_przedmiot = P.numer
							 WHERE	login = @login)
				BEGIN
					RAISERROR('Nie mo�esz licytowa� swojego przedmiotu', 11, 1);
					ROLLBACK TRANSACTION;
				END;
END;
GO

-- Kolejna oferta w licytacji musi zawiera� kwot� wy�sz� ni� oferta poprzednia, i przynajmniej tak�, jak cena wyj�ciowa przedmiotu
CREATE OR ALTER TRIGGER tr_another_offer_conditions
ON Oferty
AFTER INSERT
AS
BEGIN
	DECLARE @row_count	INT;
	SELECT @row_count = @@ROWCOUNT;
	
	IF	@row_count = (SELECT 1)
		BEGIN
			DECLARE	@auction	INT;
			DECLARE	@amount		DECIMAL(6, 2);
			DECLARE @login		VARCHAR(50);
			
			SELECT	@auction = id_licytacja, @amount = kwota, @login = login
			FROM	inserted;
		END;
			IF	@amount <= (SELECT	cena_wyj�ciowa
							FROM	Przedmioty
							WHERE	numer = @auction)
				BEGIN
					RAISERROR('Twoja oferta musi przebi� cen� wyj�ciow� przedmiotu, kt�ry licytujesz', 11, 1);
					ROLLBACK TRANSACTION;
				END;
			ELSE IF	@amount <= (SELECT	MAX(kwota)
							    FROM Oferty
							    WHERE id_licytacja = @auction AND login <> @login AND kwota <> @amount)
					BEGIN
						RAISERROR('Twoja oferta musi przebi� poprzedni� ofert�', 11, 1);
						ROLLBACK TRANSACTION;
					END;
END;
GO

-- Nie mo�na licytowa� sprzedanego przedmiotu
CREATE OR ALTER TRIGGER tr_prohibit_bidding_sold_item
ON Oferty
AFTER INSERT
AS
BEGIN
	DECLARE @row_count	INT;
	SELECT @row_count = @@ROWCOUNT;
	
	IF	@row_count = (SELECT 1)
		BEGIN
			DECLARE @auction INT;

			SELECT @auction = id_licytacja
			FROM inserted;
		END;
			IF	(SELECT	id_status
				 FROM	Licytacje
				 WHERE	id = @auction) = (SELECT id
										   FROM Statusy
										   WHERE opis = 'zako�czona kupnem')
				BEGIN
					RAISERROR('Nie mo�esz licytowa� przedmiotu, kt�ry zosta� sprzedany', 11, 1);
					ROLLBACK TRANSACTION;
				END;
END;
GO

---- RAPORTY ----

-- winners of auctions + amount of wins
CREATE OR ALTER VIEW Winners(winner, amount_of_wins)
AS
(
	SELECT		zwyci�zca, COUNT(*) AS ilo��_wygranych
	FROM		Licytacje L
	JOIN		U�ytkownicy U
	  ON		L.zwyci�zca = U.login
	GROUP BY	zwyci�zca
);
GO

-- how many times items were bidded
CREATE OR ALTER VIEW Items(item, number_of_bids)
AS
(
	SELECT		nazwa, ISNULL(COUNT(data), 0) AS liczba_licytowa�
	FROM		Przedmioty P
	LEFT JOIN		Licytacje L
	       ON		P.numer = L.numer_przedmiot
	LEFT JOIN		Oferty O
	       ON		O.id_licytacja = L.id
	GROUP BY	nazwa
);
GO

-- show auctions which are still going
CREATE OR ALTER VIEW Live_auctions(id, date_start, status, item)
AS
(
	SELECT		L.id, data_rozpocz�cia, S.opis, nazwa
	FROM		Licytacje L
	JOIN		Statusy S
	  ON		L.id_status = S.id
	JOIN		Przedmioty P
	  ON		L.numer_przedmiot = P.numer
	WHERE		S.opis = 'w trakcie'
);
GO

-- how many times users bidded
CREATE OR ALTER VIEW Users_bids(login, amount_bids)
AS
(
	SELECT		U.login, ISNULL(COUNT(data), 0) AS liczba_licytowa�
	FROM		U�ytkownicy U
	LEFT JOIN		Oferty O
	       ON		U.login = O.login
	GROUP BY	U.login
);
GO

-- check which items starting price is above or equal to x
CREATE OR ALTER FUNCTION udf_items_starting_price
(
	@price	DECIMAL(6,2)
)
	RETURNS Table
AS
	RETURN	SELECT nazwa, cena_wyj�ciowa
			FROM Przedmioty
			WHERE cena_wyj�ciowa >= @price;
GO

---- OGRANICZENIA UDZIA�U CA�KOWITEGO OBUSTRONNEGO ----

