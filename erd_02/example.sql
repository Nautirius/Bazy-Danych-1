-- Proszę opracować schemat bazy danych dla drzewa genealogicznego. Baza zawiera informacje o osobach (imię, nazwisko, data urodzenia, miejsce urodzenia, dla osób nieżyjących - data zgonu), informacje o pokrewieństwie oraz informacje o małżeństwach.
-- Zapytania do bazy danych:
--
--     dla wybranej osoby - informacje o danej osobie,
--     dla wybranej osoby - informacje o rodzicach,
--     dla wybranej osoby - czy posiada dzieci, jeżeli tak to podać ich imiona.
--     dla wybranej osoby - rodzeństwo
--
-- Poprawność przedstawionych zapytań proszę przetestować w przykładowej bazie danych – ilość wprowadzonych danych powinna pozwolić na efektywna realizację zapytań.
--
-- Należy przesłać plik .sql zawierający kwerendy tworzące bazę danych (CREATE TABLE), wypełniające danymi ( INSERT  INTO), oraz realizujące zapytania. (SELECT).

CREATE TABLE Osoba (
                osoba_id SERIAL PRIMARY KEY,
                imie VARCHAR NOT NULL,
                nazwisko VARCHAR NOT NULL,
                data_urodzenia DATE NOT NULL,
                miejsce_urodzenia VARCHAR NOT NULL,
                data_zgonu DATE,
                rodzic1 INTEGER,
                rodzic2 INTEGER
);

CREATE TABLE Malzenstwo (
                osoba1 INTEGER NOT NULL,
                osoba2 INTEGER NOT NULL,
                aktualne BOOLEAN DEFAULT TRUE NOT NULL,
                CONSTRAINT malzenstwo_pk PRIMARY KEY (osoba1, osoba2)
);

ALTER TABLE Malzenstwo ADD CONSTRAINT osoba_malzenstwo_fk
FOREIGN KEY (osoba1)
REFERENCES Osoba (osoba_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE Malzenstwo ADD CONSTRAINT osoba_malzenstwo_fk1
FOREIGN KEY (osoba2)
REFERENCES Osoba (osoba_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE Osoba ADD CONSTRAINT malzenstwo_osoba_fk
FOREIGN KEY (rodzic2, rodzic1)
REFERENCES Malzenstwo (osoba2, osoba1)
ON DELETE SET NULL
ON UPDATE CASCADE;

-- Rodzic1 ──┐  ┌── Dziecko1
--           ├──┤
-- Rodzic2 ──┘  └── Dziecko2
--
-- Rodzic3 ──┐
--           ├───── Dziecko 3
-- Rodzic4 ──┘
--
-- Samotnik

INSERT INTO osoba VALUES(DEFAULT, 'Rodzic1', 'Testowy', '1-1-1970', 'Kraków');
INSERT INTO osoba VALUES(DEFAULT, 'Rodzic2', 'Testowy', '10-6-1969', 'Kraków', '12-12-2000');
INSERT INTO osoba VALUES(DEFAULT, 'Rodzic3', 'Kontrolny', '15-12-1995', 'Pabianice');
INSERT INTO osoba VALUES(DEFAULT, 'Rodzic4', 'Kontrolny', '23-3-1994', 'Pabianice');
INSERT INTO osoba VALUES(DEFAULT, 'Samotnik', 'Kontrolny', '8-12-2001', 'Przeworsk');
INSERT INTO malzenstwo VALUES((SELECT osoba_id FROM osoba WHERE imie = 'Rodzic1'), (SELECT osoba_id FROM osoba WHERE imie = 'Rodzic2'));
INSERT INTO malzenstwo VALUES((SELECT osoba_id FROM osoba WHERE imie = 'Rodzic3'), (SELECT osoba_id FROM osoba WHERE imie = 'Rodzic4'));
INSERT INTO osoba VALUES(DEFAULT, 'Dziecko1', 'Testowe', '2-5-1990', 'Kraków', NULL, (SELECT osoba_id FROM osoba WHERE imie = 'Rodzic1'), (SELECT osoba_id FROM osoba WHERE imie = 'Rodzic2'));
INSERT INTO osoba VALUES(DEFAULT, 'Dziecko2', 'Testowe', '3-4-1992', 'Kraków', NULL, (SELECT osoba_id FROM osoba WHERE imie = 'Rodzic1'), (SELECT osoba_id FROM osoba WHERE imie = 'Rodzic2'));
INSERT INTO osoba VALUES(DEFAULT, 'Dziecko3', 'Kontrolne', '22-7-2007', 'Pabianice', NULL, (SELECT osoba_id FROM osoba WHERE imie = 'Rodzic3'), (SELECT osoba_id FROM osoba WHERE imie = 'Rodzic4'));

-- 1
SELECT * FROM osoba WHERE imie = 'Dziecko1';

-- 2
SELECT * FROM osoba WHERE osoba_id IN ((SELECT rodzic1 FROM osoba WHERE imie = 'Dziecko1'), (SELECT rodzic2 FROM osoba WHERE imie = 'Dziecko1'));

-- 3
SELECT imie FROM osoba WHERE (SELECT osoba_id FROM osoba WHERE imie = 'Rodzic1') IN (rodzic1, rodzic2);

-- 4
SELECT osoba.*
FROM osoba, (SELECT rodzic1, rodzic2, osoba_id FROM osoba WHERE imie = 'Dziecko1') AS d
WHERE osoba.osoba_id != d.osoba_id AND ((osoba.rodzic1 = d.rodzic1 AND osoba.rodzic2 = d.rodzic2) OR (osoba.rodzic2 = d.rodzic1 AND osoba.rodzic1 = d.rodzic2));