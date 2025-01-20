CREATE SCHEMA lab_13;

-- Tworzenie tabel
CREATE TABLE lab_13.czytelnik (
    czytelnik_id SERIAL PRIMARY KEY,
    imie TEXT NOT NULL,
    nazwisko TEXT NOT NULL
);

CREATE TABLE lab_13.ksiazka (
    ksiazka_id SERIAL PRIMARY KEY,
    autor_imie TEXT NOT NULL,
    autor_nazwisko TEXT NOT NULL,
    tytul TEXT NOT NULL,
    cena NUMERIC CHECK (cena >= 100.0),
    rok_wydania INTEGER CHECK (rok_wydania BETWEEN 1995 AND 2020),
    ilosc_egzemplarzy INTEGER CHECK (ilosc_egzemplarzy >= 0)
);

CREATE TABLE lab_13.kara (
    kara_id SERIAL PRIMARY KEY,
    opoznienie_min INTEGER NOT NULL,
    opoznienie_max INTEGER NOT NULL,
    CONSTRAINT opoznienie_spojnosc CHECK (opoznienie_min < opoznienie_max)
);

CREATE TABLE lab_13.wypozyczenie (
    wypozyczenie_id SERIAL PRIMARY KEY,
    czytelnik_id INTEGER NOT NULL REFERENCES lab_13.czytelnik(czytelnik_id),
    data_wypozyczenia DATE NOT NULL,
    data_zwrotu DATE
);

CREATE TABLE lab_13.ksiazka_wypozyczenie (
    ksiazka_wypozyczenie_id SERIAL PRIMARY KEY,
    ksiazka_id INTEGER NOT NULL REFERENCES lab_13.ksiazka(ksiazka_id),
    wypozyczenie_id INTEGER NOT NULL REFERENCES lab_13.wypozyczenie(wypozyczenie_id)
);

-- Wstawianie przykładowych danych
INSERT INTO lab_13.czytelnik (imie, nazwisko) VALUES
('Jan', 'Kowalski'),
('Anna', 'Nowak'),
('Piotr', 'Wiśniewski'),
('Maria', 'Zielińska'),
('Tomasz', 'Nowicki'),
('Katarzyna', 'Adamska');

INSERT INTO lab_13.ksiazka (autor_imie, autor_nazwisko, tytul, cena, rok_wydania, ilosc_egzemplarzy) VALUES
('Adam', 'Mickiewicz', 'Pan Tadeusz', 150.0, 1998, 10),
('Henryk', 'Sienkiewicz', 'Potop', 120.0, 2005, 5),
('Juliusz', 'Słowacki', 'Kordian', 100.0, 2010, 7),
('Bolesław', 'Prus', 'Lalka', 130.0, 2000, 6),
('Stefan', 'Żeromski', 'Przedwiośnie', 110.0, 2015, 4);

INSERT INTO lab_13.kara (opoznienie_min, opoznienie_max) VALUES
(0, 4),    -- brak kary
(5, 6),    -- kara 1
(7, 8),    -- kara 2
(9, 15);   -- kara 3

INSERT INTO lab_13.wypozyczenie (czytelnik_id, data_wypozyczenia, data_zwrotu) VALUES
(1, '2025-01-01', '2025-01-04'),
(2, '2025-01-02', '2025-01-08'),
(3, '2025-01-03', NULL),
(4, '2025-01-05', '2025-01-12'),
(5, '2025-01-06', '2025-01-07'),
(6, '2025-01-07', '2025-01-16'),
(1, '2025-01-10', '2025-01-15'),
(3, '2025-01-08', '2025-01-16');

INSERT INTO lab_13.ksiazka_wypozyczenie (ksiazka_id, wypozyczenie_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(1, 6),
(3, 7),
(4, 7),
(4, 7),
(4, 8);

-- Zadanie 2

-- 1. Dla każdego czytelnika (id, nazwisko) zestawienie ilość_kar
SELECT
    c.czytelnik_id,
    c.nazwisko,
    COUNT(k.kara_id) AS ilosc_kar
FROM
    lab_13.czytelnik c
LEFT JOIN
    lab_13.wypozyczenie w ON c.czytelnik_id = w.czytelnik_id
LEFT JOIN
    lab_13.kara k ON GREATEST(EXTRACT(DAY FROM COALESCE(w.data_zwrotu, NOW()) - w.data_wypozyczenia), 0) BETWEEN k.opoznienie_min AND k.opoznienie_max
WHERE
    k.kara_id IS NOT NULL
GROUP BY
    c.czytelnik_id, c.nazwisko;

-- 2. Lista książek (tytuł), które były pożyczone przez co najmniej dwóch różnych czytelników
SELECT
    k.tytul
FROM
    lab_13.ksiazka k
JOIN
    lab_13.ksiazka_wypozyczenie kw ON k.ksiazka_id = kw.ksiazka_id
JOIN
    lab_13.wypozyczenie w ON kw.wypozyczenie_id = w.wypozyczenie_id
GROUP BY
    k.tytul
HAVING
    COUNT(DISTINCT w.czytelnik_id) >= 2;

-- 3. Książka (tytuł), która była pożyczana najczęściej
SELECT tytul FROM (
  SELECT
    k.tytul,
    RANK() OVER (ORDER BY COUNT(kw.ksiazka_id) DESC) AS rnk
  FROM
    lab_13.ksiazka k
  JOIN
    lab_13.ksiazka_wypozyczenie kw ON k.ksiazka_id = kw.ksiazka_id
  GROUP BY
    k.tytul
) ranked WHERE rnk = 1;

-- 4. Dla każdego czytelnika (id, nazwisko) średnia_ilość_dni trwania wypożyczenia
SELECT
    c.czytelnik_id,
    c.nazwisko,
    EXTRACT(DAY FROM AVG(COALESCE(w.data_zwrotu, NOW()) - w.data_wypozyczenia)) AS srednia_ilosc_dni
FROM
    lab_13.czytelnik c
JOIN
    lab_13.wypozyczenie w ON c.czytelnik_id = w.czytelnik_id
GROUP BY
    c.czytelnik_id, c.nazwisko;

-- 5. Lista czytelników (imie, nazwisko), którzy nigdy nie przetrzymali żadnej książki
SELECT
    c.imie,
    c.nazwisko
FROM
    lab_13.czytelnik c
LEFT JOIN
    lab_13.wypozyczenie w ON c.czytelnik_id = w.czytelnik_id
WHERE
    NOT EXISTS (
        SELECT 1
        FROM lab_13.wypozyczenie w2
        WHERE w2.czytelnik_id = c.czytelnik_id
          AND EXTRACT(DAY FROM COALESCE(w2.data_zwrotu, NOW()) - w2.data_wypozyczenia) > 4
    );

-- 6. Ranking czytelników - nazwisko, ilość pożyczonych różnych książek
SELECT
    c.nazwisko,
    COUNT(DISTINCT kw.ksiazka_id) AS ilosc_pozyczonych_ksiazek
FROM
    lab_13.czytelnik c
JOIN
    lab_13.wypozyczenie w ON c.czytelnik_id = w.czytelnik_id
JOIN
    lab_13.ksiazka_wypozyczenie kw ON w.wypozyczenie_id = kw.wypozyczenie_id
GROUP BY
    c.nazwisko
ORDER BY
    ilosc_pozyczonych_ksiazek DESC;

-- 7. Czytelnik (imie, nazwisko), który pożyczył największą ilość książek w jednym wypożyczeniu
SELECT imie, nazwisko FROM (
  SELECT
    c.imie,
    c.nazwisko,
    RANK() OVER (ORDER BY COUNT(kw.ksiazka_id) DESC) AS rnk
  FROM
    lab_13.czytelnik c
  JOIN
    lab_13.wypozyczenie w ON c.czytelnik_id = w.czytelnik_id
  JOIN
    lab_13.ksiazka_wypozyczenie kw ON w.wypozyczenie_id = kw.wypozyczenie_id
  GROUP BY
    c.imie, c.nazwisko
) ranked WHERE rnk = 1;

-- 8. Tytuł książki, która była najczęściej przetrzymywana
SELECT tytul FROM (
  SELECT
    k.tytul,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
  FROM
    lab_13.ksiazka k
  JOIN
    lab_13.ksiazka_wypozyczenie kw ON k.ksiazka_id = kw.ksiazka_id
  JOIN
    lab_13.wypozyczenie w ON kw.wypozyczenie_id = w.wypozyczenie_id
  WHERE
    EXTRACT(DAY FROM COALESCE(w.data_zwrotu, NOW()) - w.data_wypozyczenia) > 4
  GROUP BY
    k.tytul
) ranked WHERE rnk = 1;

-- 9. Ilość wypożyczeń, które zostały przedłużone - zestawienie ilość_dni, ilość_wypożyczeń
SELECT
    k.kara_id,
    CONCAT(k.opoznienie_min, '-', k.opoznienie_max) AS zakres_dni,
    COUNT(w.wypozyczenie_id) AS ilosc_wypozyczen
FROM
    lab_13.wypozyczenie w
JOIN
    lab_13.kara k ON GREATEST(EXTRACT(DAY FROM COALESCE(w.data_zwrotu, NOW()) - w.data_wypozyczenia), 0) BETWEEN k.opoznienie_min AND k.opoznienie_max
GROUP BY
    k.kara_id, k.opoznienie_min, k.opoznienie_max
ORDER BY
    k.opoznienie_min;

-- 10. Zestawienie z wykorzystaniem kwerendy krzyżowej (CASE):
SELECT
    c.nazwisko,
    COUNT(CASE WHEN k.tytul = 'Pan Tadeusz' THEN 1 END) AS Pan_Tadeusz,
    COUNT(CASE WHEN k.tytul = 'Potop' THEN 1 END) AS Potop,
    COUNT(CASE WHEN k.tytul = 'Kordian' THEN 1 END) AS Kordian
FROM
    lab_13.czytelnik c
LEFT JOIN
    lab_13.wypozyczenie w ON c.czytelnik_id = w.czytelnik_id
LEFT JOIN
    lab_13.ksiazka_wypozyczenie kw ON w.wypozyczenie_id = kw.wypozyczenie_id
LEFT JOIN
    lab_13.ksiazka k ON kw.ksiazka_id = k.ksiazka_id
GROUP BY
    c.nazwisko;

-- Usunięcie schematu po zakończeniu
DROP SCHEMA lab_13 CASCADE;
