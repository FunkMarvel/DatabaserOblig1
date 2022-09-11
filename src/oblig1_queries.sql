-- Oppgave 1;
-- a):
CREATE SCHEMA Oblig1;

-- b):
CREATE TABLE Oblig1.Film
(
    FNr     INTEGER UNSIGNED NOT NULL,
    Tittel  VARCHAR(40)      NOT NULL,
    År      SMALLINT UNSIGNED,
    Land    VARCHAR(40),
    Sjanger VARCHAR(20),
    Alder   TINYINT UNSIGNED,
    Tid     SMALLINT UNSIGNED,
    Pris    DECIMAL(5, 2),
    PRIMARY KEY (FNr)
);

-- c):
INSERT INTO Oblig1.Film
VALUES (1, 'Casablanca', 1942, 'USA', 'Drama', 15, 102, 149.00),
       (2, 'Fort Apachea', 1948, 'USA', 'Western', 15, 127, NULL),
       (3, 'Apocalypse Now', 1979, 'USA', 'Action', 18, 155, 123.00),
       (4, 'Streets of Fire', 1984, 'USA', 'Action', 15, 93, NULL),
       (5, 'High Noon', 1952, 'USA', 'Western', 15, 85, 123.00),
       (6, 'Cinema Paradiso', 1988, 'Italia', 'Komedie', 11, 123, NULL),
       (7, 'Asterix hos britene', 1988, 'Frankrike', 'Tegnefilm', 7, 78, 149.00),
       (8, 'Veiviseren', 1987, 'Norge', 'Action', 15, 96, 87.00),
       (9, 'Salmer fra kjøkkenet', 2002, 'Norge', 'Komedie', 7, 80, 149.00),
       (10, 'Anastasia', 1997, 'USA', 'Tegnefilm', 7, 94, 123.00),
       (11, 'La Grande bouffe', 1973, 'Frankrike', 'Drama', 15, 129, 87.00),
       (12, 'Blues Brothers 2000', 1998, 'USA', 'Komedie', 11, 124, 135.00),
       (13, 'Beatles: Help', 1965, 'Storbritannia', 'Musikk', 11, 144, NULL);

SELECT *
FROM Oblig1.Film;

-- d):
SELECT Tittel, Sjanger, Pris
FROM Oblig1.Film
WHERE År >= 1988
ORDER BY Pris DESC;

-- e):
SELECT *
FROM Oblig1.Film
WHERE Pris IS NULL
ORDER BY Alder, Sjanger;

-- f):
SELECT Sjanger, COUNT(Sjanger) AS 'Antall filmer', SUM(Pris) AS 'Totalpris'
FROM Oblig1.Film
WHERE Pris IS NOT NULL
GROUP BY Sjanger
ORDER BY Sjanger;

-- g):
INSERT INTO Oblig1.Film
    VALUE (14, 'Ghost in the Shell', 1995, 'Japan', 'Tegnefilm', 13, 83, 95.00);

SELECT *
FROM Oblig1.Film
WHERE Tittel = 'Ghost in the Shell';

-- h):
UPDATE Oblig1.Film
SET Tittel = 'High Moon'
WHERE Tittel = 'High Noon';

SELECT FNr, Tittel
FROM Oblig1.Film
WHERE Tittel = 'High Moon';

-- i):
UPDATE Oblig1.Film
SET Pris = Pris * 1.1
WHERE Sjanger = 'Action';

SELECT Sjanger, Tittel, Pris
FROM Oblig1.Film
WHERE Sjanger = 'Action'
ORDER BY Tittel;

-- j):
DELETE
FROM Oblig1.Film
WHERE Tittel = 'Anastasia';

SELECT Tittel
FROM Oblig1.Film
ORDER BY Tittel;

-- Oppgave 2
-- a):
CREATE TABLE Oblig1.Kunde
(
    KNr       INTEGER UNSIGNED NOT NULL,
    Fornavn   VARCHAR(50),
    Etternavn VARCHAR(50),
    Adresse   VARCHAR(100),
    PostNr    SMALLINT UNSIGNED,
    PRIMARY KEY (KNr)
);

SELECT *
FROM Oblig1.kunde;

-- b):
INSERT INTO Oblig1.Kunde
VALUES (10001, 'Kari', 'Mo', 'Moldegata 21 H0402', 0445),
       (10002, 'Geir', 'Gallestein', 'Grønnegata 68 H0304', 2317),
       (10003, 'Reidun', 'Roterud', 'Hylleråsvegen 11', 2440);

SELECT *
FROM Oblig1.Kunde;

-- c)
CREATE TABLE Oblig1.Faktura
(
    FakturaNr        INTEGER UNSIGNED NOT NULL,
    KundeNr          INTEGER UNSIGNED NOT NULL,
    FilmNr           INTEGER UNSIGNED NOT NULL,
    Beløp            DECIMAL(7, 2)             DEFAULT NULL,
    Opprettelsesdato DATE             NOT NULL DEFAULT (CURRENT_DATE),
    Forfallsdato     DATE             NOT NULL DEFAULT (Opprettelsesdato + INTERVAL 14 DAY),
    Betalt           BOOL             NOT NULL DEFAULT (FALSE),
    PRIMARY KEY (FakturaNr),
    FOREIGN KEY (KundeNr) REFERENCES Oblig1.Kunde (KNr),
    FOREIGN KEY (FilmNr) REFERENCES Oblig1.Film (FNr)
);

SELECT *
FROM Oblig1.Faktura;

-- e):
INSERT INTO Oblig1.Faktura (FakturaNr, KundeNr, FilmNr, Beløp, Opprettelsesdato, Betalt)
VALUES (10001,
        (SELECT KNr FROM Oblig1.Kunde WHERE Fornavn = 'Kari' AND Etternavn = 'Mo'),
        14,
        (SELECT Pris FROM Oblig1.Film WHERE FNr = 14),
        '2021-12-30',
        TRUE),
       (10002,
        (SELECT KNr FROM Oblig1.Kunde WHERE Fornavn = 'Geir' AND Etternavn = 'Gallestein'),
        11,
        (SELECT Pris FROM Oblig1.Film WHERE FNr = 11),
        '2022-04-01',
        TRUE),
       (13592,
        (SELECT KNr FROM Oblig1.Kunde WHERE Fornavn = 'Kari' AND Etternavn = 'Mo'),
        5,
        (SELECT Pris FROM Oblig1.Film WHERE FNr = 5),
        CURRENT_DATE,
        FALSE);

SELECT *
FROM Oblig1.Faktura
WHERE KundeNr = (SELECT KNr FROM Oblig1.Kunde WHERE Fornavn = 'Kari' AND Etternavn = 'Mo');

-- f):
ALTER TABLE Oblig1.Faktura
    ADD CONSTRAINT Beløpsintervall
        CHECK ( Beløp >= 0.00 AND Beløp <= 10000.00);

-- g):
INSERT INTO Oblig1.Faktura (FakturaNr, KundeNr, FilmNr, Beløp)
    VALUE (1010, 10003, 1, 10000.69);

SELECT *
FROM Oblig1.Faktura;

-- h):
INSERT INTO Oblig1.Faktura (FakturaNr, KundeNr, FilmNr, Beløp)
    VALUE (1010, 10003, 1, 1000.69);

SELECT *
FROM Oblig1.Faktura;

-- Oppgave 3
-- b):
SELECT SUBSTRING_INDEX((SELECT Tittel FROM Oblig1.Film WHERE FNr = 14), ' ', 3);
SELECT SUBSTRING_INDEX((SELECT SUBSTRING_INDEX((SELECT Tittel FROM Oblig1.Film WHERE FNr = 14), ' ', 3)), ' ', -2);

-- Oppgave 4
-- a):
SELECT *
FROM information_schema.TABLES;

-- c):
SELECT *
FROM information_schema.ENGINES;

SELECT *
FROM information_schema.CHECK_CONSTRAINTS;