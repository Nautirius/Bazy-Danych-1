-- Zadanie 1
SELECT * FROM lab08.koszty;

-- Zadanie 2
-- 5 kursów - premia = 2
INSERT INTO lab08.zajecia (wykladowca_id, kurs_id) VALUES
(1, 1),
(1, 4),
(1, 3),
(1, 5),
(1, 6);

-- 6 kursów - premia = 4
INSERT INTO lab08.zajecia (wykladowca_id, kurs_id)VALUES
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(2, 5),
(2, 6);

-- dwa kursy - brak premii
INSERT INTO lab08.zajecia (wykladowca_id, kurs_id)VALUES
(3, 1),
(3, 2);

SELECT * FROM lab08.wykladowca;

-- Zadanie 3
-- usuwanie danych z tabeli wykladowcy
DELETE FROM lab08.wykladowca WHERE wykladowca_id = 4;
-- niezakonczony kurs
DELETE FROM lab08.wykladowca WHERE wykladowca_id = 1;
-- jedyny prowadzacy kurs
DELETE FROM lab08.wykladowca WHERE wykladowca_id = 2;

DELETE FROM lab08.zajecia;
DELETE FROM lab08.wykladowca;
DELETE FROM lab08.instytut;
DELETE FROM lab08.kurs;
DELETE FROM lab08.funkcja;

DROP TABLE lab08.zajecia;
DROP TABLE lab08.wykladowca;
DROP TABLE lab08.instytut;
DROP TABLE lab08.kurs;
DROP TABLE lab08.funkcja;
DROP TABLE lab08.koszty;

