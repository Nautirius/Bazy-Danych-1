-- Utworzenie schematu projektu biblioteka
CREATE SCHEMA biblioteka;

-- Tabela przechowująca informacje o dziedzinach (rekurencyjna)
CREATE TABLE biblioteka.kategorie (
    id_kategorii SERIAL PRIMARY KEY,
    nazwa VARCHAR(100) NOT NULL,
    id_kategorii_nadrzednej INT,
    FOREIGN KEY (id_kategorii_nadrzednej) REFERENCES biblioteka.kategorie (id_kategorii)
);

-- Tabela przechowująca informacje o książkach
CREATE TABLE biblioteka.ksiazki (
    id_ksiazki SERIAL PRIMARY KEY,
    tytul VARCHAR(255) NOT NULL,
    jezyk_oryginalu VARCHAR(100),
    id_kategorii INT,
    opis TEXT,
    FOREIGN KEY (id_kategorii) REFERENCES biblioteka.kategorie (id_kategorii)
);

-- Tabela przechowująca informacje o wydawnictwach
CREATE TABLE biblioteka.wydawnictwa (
    id_wydawnictwa SERIAL PRIMARY KEY,
    nazwa VARCHAR(255) NOT NULL,
    kraj VARCHAR(100),
    miejscowosc VARCHAR(100),
    ulica VARCHAR(100),
    numer_domu VARCHAR(10),
    kod_pocztowy VARCHAR(15),
    telefon VARCHAR(15),
    email VARCHAR(100)
);

-- Tabela przechowująca informacje o wydaniach książek
CREATE TABLE biblioteka.wydania (
    id_wydania SERIAL PRIMARY KEY,
    id_ksiazki INT NOT NULL,
    id_wydawnictwa INT,
    rok_wydania INT,
    jezyk VARCHAR(100) NOT NULL,
    liczba_stron INT,
    sciezka_do_okladki VARCHAR(100) DEFAULT 'uploads/covers/default_cover.png',
    FOREIGN KEY (id_ksiazki) REFERENCES biblioteka.ksiazki (id_ksiazki) ON DELETE CASCADE,
    FOREIGN KEY (id_wydawnictwa) REFERENCES biblioteka.wydawnictwa (id_wydawnictwa) ON DELETE SET NULL
);

-- Tabela przechowująca informacje o egzemplarzach książek
CREATE TABLE biblioteka.egzemplarze (
    id_egzemplarza SERIAL PRIMARY KEY,
    id_wydania INT NOT NULL,
    stan VARCHAR(50) CHECK (stan IN ('dostępny', 'wypożyczony', 'zniszczony')),
    FOREIGN KEY (id_wydania) REFERENCES biblioteka.wydania (id_wydania) ON DELETE CASCADE
);

-- Tabela przechowująca informacje o autorach
CREATE TABLE biblioteka.autorzy (
    id_autora SERIAL PRIMARY KEY,
    imie VARCHAR(100),
    nazwisko VARCHAR(100),
    pseudonim VARCHAR(150),
    rok_urodzenia INT,
    kraj_pochodzenia VARCHAR(100),
    notka_biograficzna TEXT,
    CHECK ((imie IS NOT NULL AND nazwisko IS NOT NULL) OR pseudonim IS NOT NULL)
);

-- Tabela asocjacyjna dla relacji książki-autorzy
CREATE TABLE biblioteka.ksiazki_autorzy (
    id_ksiazki INT,
    id_autora INT,
    PRIMARY KEY (id_ksiazki, id_autora),
    FOREIGN KEY (id_ksiazki) REFERENCES biblioteka.ksiazki (id_ksiazki) ON DELETE CASCADE,
    FOREIGN KEY (id_autora) REFERENCES biblioteka.autorzy (id_autora) ON DELETE CASCADE
);

-- Tabela przechowująca informacje o czytelnikach
CREATE TABLE biblioteka.czytelnicy (
    id_czytelnika SERIAL PRIMARY KEY,
    imie VARCHAR(100) NOT NULL,
    nazwisko VARCHAR(100) NOT NULL,
    data_urodzin DATE NOT NULL,
    pesel CHAR(11) UNIQUE,
    kraj VARCHAR(100),
    miejscowosc VARCHAR(100),
    ulica VARCHAR(100),
    numer_domu VARCHAR(10),
    kod_pocztowy VARCHAR(15),
    telefon VARCHAR(15),
    email VARCHAR(100) NOT NULL UNIQUE,
    haslo VARCHAR(255) NOT NULL
);

-- Tabela przechowująca wypożyczenia książek
CREATE TABLE biblioteka.wypozyczenia (
    id_wypozyczenia SERIAL PRIMARY KEY,
    id_egzemplarza INT NOT NULL,
    id_czytelnika INT NOT NULL,
    data_wypozyczenia DATE NOT NULL,
    data_zwrotu DATE,
    status VARCHAR(20) DEFAULT 'aktywne' CHECK (status IN ('aktywne', 'oddane', 'zakonczone')),
    kara NUMERIC(10, 2) DEFAULT 0.00,
    FOREIGN KEY (id_egzemplarza) REFERENCES biblioteka.egzemplarze (id_egzemplarza) ON DELETE CASCADE,
    FOREIGN KEY (id_czytelnika) REFERENCES biblioteka.czytelnicy (id_czytelnika) ON DELETE CASCADE
);
ALTER TABLE biblioteka.wypozyczenia
    ADD CONSTRAINT check_data_zwrotu
        CHECK (data_zwrotu IS NULL OR data_zwrotu > data_wypozyczenia);


-- Tabela rezerwacji
CREATE TABLE biblioteka.rezerwacje (
    id_rezerwacji SERIAL PRIMARY KEY,
    id_wydania INT NOT NULL,
    id_czytelnika INT NOT NULL,
    data_rezerwacji DATE NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (id_wydania) REFERENCES biblioteka.wydania (id_wydania) ON DELETE CASCADE,
    FOREIGN KEY (id_czytelnika) REFERENCES biblioteka.czytelnicy (id_czytelnika) ON DELETE CASCADE
);

-- Tabela ocen książek
CREATE TABLE biblioteka.oceny (
    id_oceny SERIAL PRIMARY KEY,
    id_ksiazki INT NOT NULL,
    id_czytelnika INT NOT NULL,
    ocena INT CHECK (ocena BETWEEN 1 AND 5),
    komentarz TEXT,
    data_dodania DATE NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (id_ksiazki) REFERENCES biblioteka.ksiazki (id_ksiazki) ON DELETE CASCADE,
    FOREIGN KEY (id_czytelnika) REFERENCES biblioteka.czytelnicy (id_czytelnika) ON DELETE CASCADE
);
ALTER TABLE biblioteka.oceny
    ADD CONSTRAINT unique_rating UNIQUE (id_ksiazki, id_czytelnika);

-- Tabela lokalizacji książek
CREATE TABLE biblioteka.lokalizacje (
    id_lokalizacji SERIAL PRIMARY KEY,
    numer_polki INT NOT NULL,
    opis TEXT
);

-- Powiązanie egzemplarzy z lokalizacjami
ALTER TABLE biblioteka.egzemplarze
ADD COLUMN id_lokalizacji INT,
ADD FOREIGN KEY (id_lokalizacji) REFERENCES biblioteka.lokalizacje (id_lokalizacji) ON DELETE  SET NULL;
