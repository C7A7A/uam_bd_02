---- FUNKCJONALNOŒCI ----
-- Dodanie nowego uczestnika do serwisu
SELECT * FROM U¿ytkownicy;

EXEC insert_new_user 'aukcjonerXYZ', 'Adam', 'Adamowski', 'Bia³ystok, ul. Nowa 12 88-001', 'xyz@gmail.com', NULL, NULL, NULL;

SELECT * FROM U¿ytkownicy;

-- Wystawienie przedmiotu na sprzeda¿ wraz z rozpoczêciem licytacji
SELECT * FROM Przedmioty;
SELECT * FROM Licytacje;

EXEC list_item_start_auction 'klocki Lego', 95, 'zabawka', NULL, NULL, 'aukcjonerXYZ'; 

SELECT * FROM Przedmioty;
SELECT * FROM Licytacje;

-- Dodanie oferty do licytacji
SELECT	*
FROM	Oferty
WHERE	id_licytacja = 6;

DECLARE	@today DATE;
SELECT	@today = GETDATE();
EXEC add_offer_to_auction @today, '17:15', 60, 'useruser', 6; -- kwota mniejsza ni¿ cena wyjœciowa

DECLARE	@today_2 DATE;
SELECT	@today_2 = GETDATE();
EXEC add_offer_to_auction @today_2, '19:11', 100, 'useruser', 6;

DECLARE	@today_3 DATE;
SELECT	@today_3 = GETDATE();
EXEC add_offer_to_auction @today_3, '21:11', 99, 'licytator123', 6; -- kwota nie przebija poprzedniej oferty

-- Zakoñczenie licytacji; w przypadku, gdy licytacja koñczy siê sukcesem (kupnem) zostaje wyznaczony i zapisany zwyciêzca licytacji
SELECT * FROM Licytacje;

EXEC finish_auction 0; -- licytacja nie istnieje
EXEC finish_auction 1; -- licytacja zakoñczona
EXEC finish_auction 5; -- licytacja zakoñczona kupnem

EXEC list_item_start_auction 'The Silmarillion', 70, 'ksi¹¿ka', NULL, NULL, 'aukcjonerXYZ';

EXEC finish_auction 7; -- licytacja zakoñczona bez kupna


---- OGRANICZENIA ----
-- U¿ytkownik nie mo¿e licytowaæ swojego w³asnego przedmiotu
DECLARE @today_4 DATE;
SELECT	@today_4 = GETDATE();
INSERT INTO Oferty(data, godzina, kwota, login, id_licytacja)
VALUES(@today_4, '23:20:05', 100, 'aukcjonerXYZ', 6);

SELECT * FROM Oferty;

-- Kolejna oferta w licytacji musi zawieraæ kwotê wy¿sz¹ ni¿ oferta poprzednia, i przynajmniej tak¹, jak cena wyjœciowa przedmiotu
SELECT	*
FROM	Oferty
WHERE	id_licytacja = 6;

DELETE FROM Oferty
WHERE id_licytacja = 6;

DECLARE	@today_5 DATE;
SELECT	@today_5 = GETDATE();
INSERT INTO Oferty(data, godzina, kwota, login, id_licytacja)
VALUES(@today_5, '17:15', 60, 'useruser', 6) -- kwota mniejsza ni¿ cena wyjœciowa

DECLARE	@today_6 DATE;
SELECT	@today_6 = GETDATE();
INSERT INTO Oferty(data, godzina, kwota, login, id_licytacja)
VALUES(@today_6, '19:11', 100, 'useruser', 6)

DECLARE	@today_7 DATE;
SELECT	@today_7 = GETDATE();
INSERT INTO Oferty(data, godzina, kwota, login, id_licytacja)
VALUES(@today_7, '21:11', 99, 'licytator123', 6) -- kwota nie przebija poprzedniej oferty

-- Nie mo¿na licytowaæ sprzedanego przedmiotu
SELECT * FROM Licytacje;

DECLARE	@today_8 DATE;
SELECT	@today_8 = GETDATE();
INSERT INTO Oferty(data, godzina, kwota, login, id_licytacja)
VALUES(@today_8, '21:11', 9999, 'aukcjonerXYZ', 1)

---- RAPORTY ----
-- winners of auctions + amount of wins
SELECT * FROM Winners
SELECT * FROM Licytacje

-- how many times items were bidded
SELECT * FROM Items
SELECT * FROM Oferty

-- show auctions which are still going
SELECT * FROM Live_auctions
SELECT * FROM Licytacje

-- how many times users bidded
SELECT * FROM Users_bids
SELECT * FROM Oferty

-- check which items starting price is above or equal to x
SELECT * FROM udf_items_starting_price(75)
SELECT * FROM Przedmioty