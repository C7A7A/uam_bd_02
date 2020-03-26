--USE master;
--DROP DATABASE Fabryka_Sprzetu_IT;
--GO

--CREATE DATABASE Fabryka_Sprzetu_IT;
--GO

--USE Fabryka_Sprzetu_IT;
--GO

------------ USUÑ TABELE ------------

DROP TABLE IF EXISTS PC;
DROP TABLE IF EXISTS Laptop;
DROP TABLE IF EXISTS Drukarka;
DROP TABLE IF EXISTS Produkt;

------------ CREATE - UTWÓRZ TABELE I POWI¥ZANIA ------------

CREATE TABLE Produkt
(
    producent VARCHAR(20),
    model     INTEGER PRIMARY KEY,
    typ       VARCHAR(20) CONSTRAINT ck_produkt_typ CHECK (typ IN('PC', 'laptop', 'drukarka'))
);

CREATE TABLE PC
(
    model    INTEGER PRIMARY KEY REFERENCES Produkt(model),
    szybkosc DECIMAL(10, 2),
    ram      INTEGER,
    dysk     INTEGER,
    cena     INTEGER,
	CONSTRAINT ck_PC_szybkosc_or_cena CHECK (szybkosc > 2.0 OR cena <= 600)
);

CREATE TABLE Laptop
(
    model    INTEGER PRIMARY KEY REFERENCES Produkt(model),
    szybkosc DECIMAL(10, 2) CONSTRAINT ck_laptop_szybkosc CHECK (szybkosc >= 2.0),
    ram      INTEGER,
    dysk     INTEGER,
    ekran    DECIMAL(10, 1),
    cena     INTEGER,
	CONSTRAINT ck_ekran_or_dysk_or_cena CHECK (ekran > 15 OR dysk > 40 OR cena < 1000)
);

CREATE TABLE Drukarka
(
    model INTEGER PRIMARY KEY REFERENCES Produkt(model),
    kolor BIT,
    typ   VARCHAR(20) CONSTRAINT ck_drukarka_typ CHECK (typ IN('laserowa', 'atramentowa', 'pêcherzykowa')),
    cena  INTEGER
);

GO

------------ INSERT - WSTAW DANE ------------

INSERT INTO Produkt VALUES
('A', 1001, 'pc'      ),
('A', 1002, 'pc'      ),
('A', 1003, 'pc'      ),
('A', 2004, 'laptop'  ),
('A', 2005, 'laptop'  ),
('A', 2006, 'laptop'  ),
('B', 1004, 'pc'      ),
('B', 1005, 'pc'      ),
('B', 1006, 'pc'      ),
('B', 2007, 'laptop'  ),
('C', 1007, 'pc'      ),
('D', 1008, 'pc'      ),
('D', 1009, 'pc'      ),
('D', 1010, 'pc'      ),
('D', 3004, 'drukarka'),
('D', 3005, 'drukarka'),
('E', 1011, 'pc'      ),
('E', 1012, 'pc'      ),
('E', 1013, 'pc'      ),
('E', 2001, 'laptop'  ),
('E', 2002, 'laptop'  ),
('E', 2003, 'laptop'  ),
('E', 3001, 'drukarka'),
('E', 3002, 'drukarka'),
('E', 3003, 'drukarka'),
('F', 2008, 'laptop'  ),
('F', 2009, 'laptop'  ),
('G', 2010, 'laptop'  ),
('H', 3006, 'drukarka'),
('H', 3007, 'drukarka');

INSERT INTO PC VALUES
(1001, 2.66, 1024, 250, 2114),
(1002, 2.10, 512 , 250, 995 ),
(1003, 1.42, 512 , 80 , 478 ),
(1004, 2.80, 1024, 250, 649 ),
(1005, 3.20, 512 , 250, 630 ),
(1006, 3.20, 1024, 320, 1049),
(1007, 2.20, 1024, 200, 510 ),
(1008, 2.20, 2048, 250, 770 ),
(1009, 2.00, 1024, 250, 650 ),
(1010, 2.80, 2048, 300, 770 ),
(1011, 1.86, 2048, 160, 959 ),
(1012, 2.80, 1024, 160, 649 ),
(1013, 3.06, 512 , 80 , 529 );

INSERT INTO Laptop VALUES
(2001, 2.00, 2048, 240, 20.1, 3673),
(2002, 1.73, 1024, 80 , 17.0, 949 ),
(2003, 1.80, 512 , 60 , 15.4, 549 ),
(2004, 2.00, 512 , 60 , 13.3, 1150),
(2005, 2.16, 1024, 120, 17.0, 2500),
(2006, 2.00, 2048, 80 , 15.4, 1700),
(2007, 1.83, 1024, 120, 13.3, 1429),
(2008, 1.60, 1024, 100, 15.4, 900 ),
(2009, 1.60, 512 , 80 , 14.1, 680 ),
(2010, 2.00, 2048, 160, 15.4, 2300);

INSERT INTO Drukarka VALUES
(3001, 'true' , 'atramentowa', 99 ),
(3002, 'false', 'laserowa'   , 239),
(3003, 'true' , 'laserowa'   , 899),
(3004, 'true' , 'atramentowa', 120),
(3005, 'false', 'laserowa'   , 120),
(3006, 'true' , 'atramentowa', 100),
(3007, 'true' , 'laserowa'   , 200);

------------ SELECT ------------

SELECT * FROM Produkt;
SELECT * FROM PC;
SELECT * FROM Laptop;
SELECT * FROM Drukarka;
