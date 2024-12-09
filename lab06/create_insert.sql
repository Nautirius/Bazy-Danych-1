CREATE SCHEMA IF NOT EXISTS lab06;

-- tworzenie tabel
CREATE TABLE lab06.instytut (
    instytut_id INTEGER PRIMARY KEY,
    nazwa TEXT NOT NULL,
    lokal TEXT NOT NULL
);

CREATE TABLE lab06.funkcja (
    funkcja_id INTEGER PRIMARY KEY,
    nazwa TEXT UNIQUE NOT NULL,
    min_wynagrodzenia INTEGER NOT NULL CHECK (min_wynagrodzenia > 0),
    max_wynagrodzenia INTEGER NOT NULL CHECK (max_wynagrodzenia > min_wynagrodzenia)
);

CREATE TABLE lab06.wykladowca (
    wykladowca_id INTEGER PRIMARY KEY,
    nazwisko TEXT NOT NULL,
    manager_id INTEGER,
    rok_zatrudnienia INTEGER NOT NULL,
    wynagrodzenie INTEGER CHECK (wynagrodzenie >= 1000),
    instytut_id INTEGER,
    FOREIGN KEY (instytut_id) REFERENCES lab06.instytut(instytut_id),
    FOREIGN KEY (manager_id) REFERENCES lab06.wykladowca(wykladowca_id)
);

CREATE TABLE lab06.kurs (
    kurs_id INTEGER PRIMARY KEY,
    nazwa TEXT NOT NULL,
    start DATE NOT NULL,
    koniec DATE
);

CREATE TABLE lab06.zajecia(
    wykladowca_id INTEGER NOT NULL,
    kurs_id INTEGER NOT NULL,
    PRIMARY KEY (wykladowca_id, kurs_id),
    FOREIGN KEY (wykladowca_id) REFERENCES lab06.wykladowca(wykladowca_id),
    FOREIGN KEY (kurs_id) REFERENCES lab06.kurs(kurs_id)
);

-- wypelnianie tabel wartosciami
INSERT INTO lab06.instytut (instytut_id, nazwa, lokal)VALUES
(1, 'Informatyki', 'D-17'),
(2, 'Fizyki', 'D-10'),
(3, 'Matematyki', 'B-9'),
(4, 'Biologii', 'C-2');

INSERT INTO lab06.wykladowca (wykladowca_id, nazwisko, manager_id, rok_zatrudnienia, wynagrodzenie, instytut_id)VALUES
(1, 'Adamski', 1, 2007, 3500, 2),
(2, 'Wieczorak', NULL, 2012, 2200, 1),
(3, 'Sochoń', NULL, 2020, 3300, 1),
(4, 'Stoch', 2, 2008, 6200, 1),
(5, 'Małysz', 2, 2019, 3501, 1),
(6, 'Piątek', NULL, 2013, 7000, 2),
(7, 'Świątek', NULL, 2009, 2200, 2),
(8, 'Maj', 1, 2010, 5120, 2);
INSERT INTO lab06.wykladowca (wykladowca_id, nazwisko, manager_id, rok_zatrudnienia, wynagrodzenie, instytut_id)VALUES
(9, 'Stach', 1, 2006, 3570, 4),
(10, 'Lipa', 2, 2019, 2201, 3);

INSERT INTO lab06.funkcja (funkcja_id, nazwa, min_wynagrodzenia, max_wynagrodzenia)VALUES
(1, 'Asystent', 1000, 3500),
(2, 'Doktor', 3501, 7000),
(3, 'Profesor', 7001, 9000);

INSERT INTO lab06.kurs (kurs_id, nazwa, start, koniec)VALUES
(1, 'Matematyka', '2024-10-11', '2024-12-17'),
(2, 'Informatyka', '2023-03-01', NULL),
(3, 'Programowanie Proceduralne', '2022-11-01', '2022-12-01'),
(4, 'Bazy Danych', '2023-07-03', NULL),
(5, 'Analiza', '2023-09-04', '2023-12-06');

INSERT INTO lab06.zajecia (wykladowca_id, kurs_id)VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 2),
(5, 3),
(5, 1),
(6, 4),
(7, 4),
(8, 3);

CREATE TABLE lab06.staff (empno INT, empname VARCHAR(20), mgrno INT);

INSERT INTO lab06.staff VALUES (100, 'Kowalski', null),
                   ( 101, 'Jasny',      100),
                   ( 102, 'Ciemny',     101),
                   ( 103, 'Szary',     102),
                   ( 104, 'Bury',    101),
                   ( 105, 'Cienki',    104),
                   ( 106, 'Dlugi', 100),
                   ( 107, 'Stary',       106),
                   ( 108, 'Mlody',   106),
                   ( 109, 'Bialy',    107),
                   ( 110, 'Sztuka',      109),
                   ( 111, 'Czarny',       110),
                   ( 112, 'Nowy',     110),
                   ( 113, 'Sredni', 110),
                   ( 114, 'Jeden',      100),
                   ( 115, 'Drugi',    114),
                   ( 116, 'Ostatni',       115),
                   ( 117, 'Lewy',   115);
