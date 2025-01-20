-- Dziedziny
INSERT INTO biblioteka.kategorie (nazwa) VALUES ('Nauka');
INSERT INTO biblioteka.kategorie (nazwa, id_kategorii_nadrzednej) VALUES ('Fizyka', 1);
INSERT INTO biblioteka.kategorie (nazwa, id_kategorii_nadrzednej) VALUES ('Matematyka', 1);
INSERT INTO biblioteka.kategorie (nazwa, id_kategorii_nadrzednej) VALUES ('Chemia', 1);
INSERT INTO biblioteka.kategorie (nazwa, id_kategorii_nadrzednej) VALUES ('Biologia', 1);

-- Książki
INSERT INTO biblioteka.ksiazki (tytul, jezyk_oryginalu, id_kategorii, opis) VALUES ('Mechanika kwantowa', 'Polski', 2, 'Podstawy mechaniki kwantowej');
INSERT INTO biblioteka.ksiazki (tytul, jezyk_oryginalu, id_kategorii, opis) VALUES ('Analiza matematyczna', 'Polski', 3, 'Kurs analizy matematycznej');
INSERT INTO biblioteka.ksiazki (tytul, jezyk_oryginalu, id_kategorii, opis) VALUES ('Podstawy chemii', 'Polski', 4, 'Wprowadzenie do chemii ogólnej');
INSERT INTO biblioteka.ksiazki (tytul, jezyk_oryginalu, id_kategorii, opis) VALUES ('Genetyka', 'Polski', 5, 'Podstawowe informacje o genetyce i dziedziczeniu');

-- Wydawnictwa
INSERT INTO biblioteka.wydawnictwa (nazwa, kraj, miejscowosc, ulica, numer_domu, kod_pocztowy, telefon, email) VALUES ('PWN', 'Polska', 'Warszawa', 'Al. Jerozolimskie', '123', '00-001', '123456789', 'kontakt@pwn.pl');
INSERT INTO biblioteka.wydawnictwa (nazwa, kraj, miejscowosc, ulica, numer_domu, kod_pocztowy, telefon, email) VALUES ('PIW', 'Polska', 'Gdańsk', 'Długa', '45', '80-831', '987123654', 'kontakt@piw.pl');

-- Wydania
INSERT INTO biblioteka.wydania (id_ksiazki, id_wydawnictwa, rok_wydania, jezyk, liczba_stron) VALUES (1, 1, 2020, 'Polski', 500);
INSERT INTO biblioteka.wydania (id_ksiazki, id_wydawnictwa, rok_wydania, jezyk, liczba_stron) VALUES (2, 1, 2018, 'Polski', 600);
INSERT INTO biblioteka.wydania (id_ksiazki, id_wydawnictwa, rok_wydania, jezyk, liczba_stron) VALUES (3, 2, 2019, 'Polski', 450);
INSERT INTO biblioteka.wydania (id_ksiazki, id_wydawnictwa, rok_wydania, jezyk, liczba_stron) VALUES (4, 2, 2021, 'Polski', 300);

-- Egzemplarze
INSERT INTO biblioteka.egzemplarze (id_wydania, stan) VALUES (1, 'dostępny');
INSERT INTO biblioteka.egzemplarze (id_wydania, stan) VALUES (2, 'dostępny');
INSERT INTO biblioteka.egzemplarze (id_wydania, stan) VALUES (3, 'dostępny');
INSERT INTO biblioteka.egzemplarze (id_wydania, stan) VALUES (4, 'dostępny');

-- Autorzy
INSERT INTO biblioteka.autorzy (imie, nazwisko, rok_urodzenia, kraj_pochodzenia) VALUES ('Jan', 'Kowalski', 1975, 'Polska');
INSERT INTO biblioteka.autorzy (imie, nazwisko, rok_urodzenia, kraj_pochodzenia) VALUES ('Anna', 'Nowak', 1980, 'Polska');
INSERT INTO biblioteka.autorzy (imie, nazwisko, rok_urodzenia, kraj_pochodzenia) VALUES ('Tomasz', 'Mazur', 1970, 'Polska');
INSERT INTO biblioteka.autorzy (imie, nazwisko, rok_urodzenia, kraj_pochodzenia) VALUES ('Ewa', 'Wiśniewska', 1985, 'Polska');

-- Powiązanie książek z autorami
INSERT INTO biblioteka.ksiazki_autorzy (id_ksiazki, id_autora) VALUES (1, 1);
INSERT INTO biblioteka.ksiazki_autorzy (id_ksiazki, id_autora) VALUES (2, 2);
INSERT INTO biblioteka.ksiazki_autorzy (id_ksiazki, id_autora) VALUES (3, 3);
INSERT INTO biblioteka.ksiazki_autorzy (id_ksiazki, id_autora) VALUES (4, 4);

-- Czytelnicy
INSERT INTO biblioteka.czytelnicy (imie, nazwisko, data_urodzin, pesel, kraj, miejscowosc, ulica, numer_domu, kod_pocztowy, telefon, email, haslo) VALUES ('Piotr', 'Zieliński', '1990-05-15', '98100626134', 'Polska', 'Kraków', 'Rynek', '1', '31-001', '987654321', 'piotr.zielinski@mail.com', 'haslo');
INSERT INTO biblioteka.czytelnicy (imie, nazwisko, data_urodzin, pesel, kraj, miejscowosc, ulica, numer_domu, kod_pocztowy, telefon, email, haslo) VALUES ('Anna', 'Kowalczyk', '1988-03-12', '57122015883', 'Polska', 'Poznań', 'Głogowska', '12', '60-101', '123987456', 'anna.kowalczyk@mail.com', 'securepassword');

-- Wypożyczenia
INSERT INTO biblioteka.wypozyczenia (id_egzemplarza, id_czytelnika, data_wypozyczenia, data_zwrotu) VALUES (1, 1, '2024-11-01', '2025-01-10');
INSERT INTO biblioteka.wypozyczenia (id_egzemplarza, id_czytelnika, data_wypozyczenia, data_zwrotu) VALUES (3, 2, '2024-12-01', NULL);
INSERT INTO biblioteka.wypozyczenia (id_egzemplarza, id_czytelnika, data_wypozyczenia, data_zwrotu) VALUES (4, 2, '2024-12-15', '2025-01-13');


-- Rezerwacje
-- INSERT INTO biblioteka.rezerwacje (id_wydania, id_czytelnika) VALUES (2, 1);
-- INSERT INTO biblioteka.rezerwacje (id_wydania, id_czytelnika) VALUES (3, 1);

-- Oceny
INSERT INTO biblioteka.oceny (id_ksiazki, id_czytelnika, ocena, komentarz) VALUES (1, 1, 5, 'Świetna książka!');
INSERT INTO biblioteka.oceny (id_ksiazki, id_czytelnika, ocena, komentarz) VALUES (3, 2, 4, 'Dobra książka, ale mogłaby być bardziej szczegółowa.');
INSERT INTO biblioteka.oceny (id_ksiazki, id_czytelnika, ocena, komentarz) VALUES (4, 1, 5, 'Świetna książka! Polecam każdemu.');

-- Lokalizacje
INSERT INTO biblioteka.lokalizacje (numer_polki, opis) VALUES (1, 'Regał A - Fizyka');
INSERT INTO biblioteka.lokalizacje (numer_polki, opis) VALUES (2, 'Regał B - Matematyka');
INSERT INTO biblioteka.lokalizacje (numer_polki, opis) VALUES (3, 'Regał C - Chemia');
INSERT INTO biblioteka.lokalizacje (numer_polki, opis) VALUES (4, 'Regał D - Biologia');

-- Powiązanie egzemplarzy z lokalizacjami
UPDATE biblioteka.egzemplarze SET id_lokalizacji = 1 WHERE id_egzemplarza = 1;
UPDATE biblioteka.egzemplarze SET id_lokalizacji = 2 WHERE id_egzemplarza = 2;
UPDATE biblioteka.egzemplarze SET id_lokalizacji = 3 WHERE id_egzemplarza = 3;
UPDATE biblioteka.egzemplarze SET id_lokalizacji = 4 WHERE id_egzemplarza = 4;