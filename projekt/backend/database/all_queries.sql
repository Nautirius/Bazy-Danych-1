-- Utworzenie schematu projektu biblioteka
CREATE SCHEMA biblioteka;

-- TABELE
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


-- WYZWALACZE

-- funkcja walidująca PESEL
CREATE OR REPLACE FUNCTION sprawdz_pesel(pesel CHAR(11))
    RETURNS BOOLEAN AS $$
DECLARE
    suma INT;
    liczba_kontrolna INT;
BEGIN
    IF LENGTH(pesel) <> 11 THEN
        RETURN FALSE;
    END IF;

    -- obliczenie sumy kontrolnej
    suma := 1 * CAST(SUBSTRING(pesel, 1, 1) AS INT) +
            3 * CAST(SUBSTRING(pesel, 2, 1) AS INT) +
            7 * CAST(SUBSTRING(pesel, 3, 1) AS INT) +
            9 * CAST(SUBSTRING(pesel, 4, 1) AS INT) +
            1 * CAST(SUBSTRING(pesel, 5, 1) AS INT) +
            3 * CAST(SUBSTRING(pesel, 6, 1) AS INT) +
            7 * CAST(SUBSTRING(pesel, 7, 1) AS INT) +
            9 * CAST(SUBSTRING(pesel, 8, 1) AS INT) +
            1 * CAST(SUBSTRING(pesel, 9, 1) AS INT) +
            3 * CAST(SUBSTRING(pesel, 10, 1) AS INT);

    liczba_kontrolna := (10 - (suma % 10)) % 10;

    RETURN liczba_kontrolna = CAST(SUBSTRING(pesel, 11, 1) AS INT);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION waliduj_pesel()
    RETURNS TRIGGER AS $$
BEGIN
    IF NOT sprawdz_pesel(NEW.pesel) THEN
        RAISE EXCEPTION 'Nieprawidłowy numer PESEL: %', NEW.pesel;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_waliduj_pesel
    BEFORE INSERT OR UPDATE OF pesel ON biblioteka.czytelnicy
    FOR EACH ROW
EXECUTE FUNCTION waliduj_pesel();

-- walidacja daty urodzin
CREATE OR REPLACE FUNCTION waliduj_date_urodzin()
    RETURNS TRIGGER AS $$
BEGIN
    IF NEW.data_urodzin > CURRENT_DATE THEN
        RAISE EXCEPTION 'Data urodzin nie może być późniejsza niż dzisiejsza data: %', NEW.data_urodzin;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_waliduj_date_urodzin
    BEFORE INSERT OR UPDATE OF data_urodzin ON biblioteka.czytelnicy
    FOR EACH ROW
EXECUTE FUNCTION waliduj_date_urodzin();


CREATE OR REPLACE FUNCTION aktualizuj_kategorie_przy_usuwaniu() RETURNS TRIGGER AS $$
BEGIN
    -- ustawienie książkom rodzica usuniętej kategorii
    UPDATE biblioteka.ksiazki
    SET id_kategorii = OLD.id_kategorii_nadrzednej
    WHERE id_kategorii = OLD.id_kategorii;

    -- ustawienie kategoriom rodzica usuniętej kategorii
    UPDATE biblioteka.kategorie
    SET id_kategorii_nadrzednej = OLD.id_kategorii_nadrzednej
    WHERE id_kategorii_nadrzednej = OLD.id_kategorii;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_aktualizuj_kategorie
    BEFORE DELETE ON biblioteka.kategorie
    FOR EACH ROW
EXECUTE FUNCTION aktualizuj_kategorie_przy_usuwaniu();


-- sprawdzenie czy nie powstaje pętla hierarchii
CREATE OR REPLACE FUNCTION biblioteka.sprawdz_petle_hierarchii()
    RETURNS TRIGGER AS $$
DECLARE
    petla INT;
BEGIN
    -- sprawdź czy id_kategorii_nadrzednej nie prowadzi do pętli
    WITH RECURSIVE sprawdzanie_petli AS (
        SELECT id_kategorii_nadrzednej
        FROM biblioteka.kategorie
        WHERE id_kategorii = NEW.id_kategorii_nadrzednej
        UNION ALL
        SELECT k.id_kategorii_nadrzednej
        FROM biblioteka.kategorie k
                 INNER JOIN sprawdzanie_petli sp ON k.id_kategorii = sp.id_kategorii_nadrzednej
    )
    SELECT COUNT(*)
    INTO petla
    FROM sprawdzanie_petli
    WHERE id_kategorii_nadrzednej = NEW.id_kategorii;

    IF petla > 0 THEN
        RAISE EXCEPTION 'Nie można dodać lub edytować kategorii: pętla w hierarchii';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER sprawdz_petle_przed_operacja
    BEFORE INSERT OR UPDATE ON biblioteka.kategorie
    FOR EACH ROW
EXECUTE FUNCTION biblioteka.sprawdz_petle_hierarchii();


CREATE OR REPLACE FUNCTION biblioteka.sprawdz_czy_podwojna_rezerwacja()
    RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM biblioteka.rezerwacje
        WHERE id_czytelnika = NEW.id_czytelnika
          AND id_wydania = NEW.id_wydania
    ) THEN
        RAISE EXCEPTION 'Czytelnik % dokonał już rezerwacji wydania %', NEW.id_czytelnika, NEW.id_wydania;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_sprawdz_czy_podwojna_rezerwacja
    BEFORE INSERT ON biblioteka.rezerwacje
    FOR EACH ROW
EXECUTE FUNCTION biblioteka.sprawdz_czy_podwojna_rezerwacja();


-- wyzwalacz do naliczania kary za opóźniony zwrot książki - 50 groszy za dzień
CREATE OR REPLACE FUNCTION nalicz_kare()
    RETURNS TRIGGER AS $$
BEGIN
    IF NEW.data_zwrotu > NEW.data_wypozyczenia + INTERVAL '30 days' THEN
        NEW.kara := EXTRACT(DAY FROM (NEW.data_zwrotu - (NEW.data_wypozyczenia + INTERVAL '30 days'))) * 0.50;
    ELSE
        NEW.kara := 0.00;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_nalicz_kare
    BEFORE UPDATE OF data_zwrotu ON biblioteka.wypozyczenia
    FOR EACH ROW
EXECUTE FUNCTION nalicz_kare();


CREATE OR REPLACE FUNCTION biblioteka.sprawdz_dostepnosc_egzemplarza()
    RETURNS TRIGGER AS $$
DECLARE
    czy_aktywny BOOLEAN;
BEGIN
    -- sprawdź czy istnieje aktywne wypożyczenie dla danego egzemplarza
    SELECT EXISTS (
        SELECT 1
        FROM biblioteka.wypozyczenia
        WHERE id_egzemplarza = NEW.id_egzemplarza AND status = 'aktywne'
    ) INTO czy_aktywny;

    -- jeśli istnieje aktywne wypożyczenie, zablokuj operację
    IF czy_aktywny THEN
        RAISE EXCEPTION 'Egzemplarz (ID: %) jest już wypożyczony.', NEW.id_egzemplarza;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER przed_dodaniem_wypozyczenia_sprawdz_egzemplarz
    BEFORE INSERT ON biblioteka.wypozyczenia
    FOR EACH ROW
EXECUTE FUNCTION biblioteka.sprawdz_dostepnosc_egzemplarza();


-- funkcja aktualizująca status egzemplarza na "wypożyczony"
CREATE OR REPLACE FUNCTION wypozycz_zmien_stan()
    RETURNS TRIGGER AS $$
BEGIN
    UPDATE biblioteka.egzemplarze
    SET stan = 'wypożyczony'
    WHERE id_egzemplarza = NEW.id_egzemplarza;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- wyzwalacz uruchamiany po dodaniu nowego wypożyczenia
CREATE TRIGGER trigger_wypozycz_egzemplarz
    AFTER INSERT ON biblioteka.wypozyczenia
    FOR EACH ROW
EXECUTE FUNCTION wypozycz_zmien_stan();


CREATE OR REPLACE FUNCTION biblioteka.sprawdz_limit_wypozyczen_rezerwacji()
    RETURNS TRIGGER AS $$
DECLARE
    liczba_aktywna INT;
BEGIN
    SELECT COUNT(*) INTO liczba_aktywna
    FROM (
             SELECT id_czytelnika FROM biblioteka.wypozyczenia WHERE id_czytelnika = NEW.id_czytelnika AND status = 'aktywne'
             UNION ALL
             SELECT id_czytelnika FROM biblioteka.rezerwacje WHERE id_czytelnika = NEW.id_czytelnika
         ) AS aktywne;

    IF liczba_aktywna >= 3 THEN
        RAISE EXCEPTION 'Czytelnik (ID: %) przekroczył limit 3 aktywnych wypożyczeń lub rezerwacji.', NEW.id_czytelnika;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_przed_dodaniem_wypozyczenia
    BEFORE INSERT OR UPDATE ON biblioteka.wypozyczenia
    FOR EACH ROW
    WHEN (NEW.status = 'aktywne')
EXECUTE FUNCTION biblioteka.sprawdz_limit_wypozyczen_rezerwacji();


CREATE TRIGGER trigger_przed_dodaniem_rezerwacji
    BEFORE INSERT ON biblioteka.rezerwacje
    FOR EACH ROW
EXECUTE FUNCTION biblioteka.sprawdz_limit_wypozyczen_rezerwacji();


CREATE OR REPLACE FUNCTION biblioteka.obsluz_zwrot_egzemplarza()
    RETURNS TRIGGER AS $$
DECLARE
    id_rezerwacji_z INT;
    id_czytelnika_z INT;
BEGIN
    -- zmień stan egzemplarza na "dostępny"
    UPDATE biblioteka.egzemplarze
    SET stan = 'dostępny'
    WHERE id_egzemplarza = OLD.id_egzemplarza;

    -- sprawdź czy istnieje aktywna rezerwacja na wydanie tego egzemplarza
    SELECT r.id_rezerwacji, r.id_czytelnika
    INTO id_rezerwacji_z, id_czytelnika_z
    FROM biblioteka.rezerwacje r
    WHERE id_wydania = (SELECT id_wydania FROM biblioteka.egzemplarze WHERE id_egzemplarza = OLD.id_egzemplarza)
    ORDER BY data_rezerwacji
    LIMIT 1;

    -- jeśli jest rezerwacja, usuń rezerwację i wypożycz egzemplarz
    IF id_rezerwacji_z IS NOT NULL THEN
        DELETE FROM biblioteka.rezerwacje r WHERE r.id_rezerwacji = id_rezerwacji_z;

        INSERT INTO biblioteka.wypozyczenia (id_egzemplarza, id_czytelnika, data_wypozyczenia, status)
        VALUES (OLD.id_egzemplarza, id_czytelnika_z, CURRENT_DATE, 'aktywne');
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER po_zmianie_statusu_wypozyczenia
    AFTER UPDATE ON biblioteka.wypozyczenia
    FOR EACH ROW
    WHEN (OLD.status = 'aktywne' AND NEW.status IS DISTINCT FROM 'aktywne')
EXECUTE FUNCTION biblioteka.obsluz_zwrot_egzemplarza();

CREATE TRIGGER po_usunieciu_wypozyczenia
    AFTER DELETE ON biblioteka.wypozyczenia
    FOR EACH ROW
EXECUTE FUNCTION biblioteka.obsluz_zwrot_egzemplarza();


-- FUNKCJE

CREATE OR REPLACE FUNCTION biblioteka.wypozycz_egzemplarz(
    id_wydania_input INT,
    id_czytelnika_input INT
)
    RETURNS VOID AS $$
DECLARE
    id_dostepnego_egzemplarza INT;
BEGIN
    -- znajdź dostępny egzemplarz dla danego wydania
    SELECT id_egzemplarza
    INTO id_dostepnego_egzemplarza
    FROM biblioteka.egzemplarze
    WHERE id_wydania = id_wydania_input AND stan = 'dostępny'
    LIMIT 1;

    -- sprawdź czy znaleziono dostępny egzemplarz
    IF id_dostepnego_egzemplarza IS NULL THEN
        RAISE EXCEPTION 'Brak dostępnych egzemplarzy dla wydania ID: %', id_wydania_input;
    END IF;

    -- dodaj wpis do tabeli wypożyczeń
    INSERT INTO biblioteka.wypozyczenia (
        id_egzemplarza, id_czytelnika, data_wypozyczenia, kara
    ) VALUES (
                 id_dostepnego_egzemplarza, id_czytelnika_input, CURRENT_DATE, 0.00
             );

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION biblioteka.zarezerwuj_wydanie(
    id_czytelnika_input INT,
    id_wydania_input INT
)
    RETURNS VOID AS $$
BEGIN
    -- sprawdź czy rezerwacja dla tego czytelnika i wydania już istnieje
    IF EXISTS (
        SELECT 1
        FROM biblioteka.rezerwacje
        WHERE id_czytelnika = id_czytelnika_input AND id_wydania = id_wydania_input
    ) THEN
        RAISE EXCEPTION 'Czytelnik ID: % już zarezerwował wydanie ID: %', id_czytelnika_input, id_wydania_input;
    END IF;

    -- dodaj rezerwację do tabeli rezerwacje
    INSERT INTO biblioteka.rezerwacje (
        id_czytelnika, id_wydania, data_rezerwacji
    ) VALUES (
                 id_czytelnika_input, id_wydania_input, CURRENT_DATE
             );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION biblioteka.dodaj_ksiazke(
    tytul VARCHAR,
    jezyk_oryginalu VARCHAR,
    id_kategorii INT,
    opis TEXT,
    autorzy INT[]
)
    RETURNS VOID AS $$
DECLARE
    nowa_ksiazka_id INT;
BEGIN
    INSERT INTO biblioteka.ksiazki (tytul, jezyk_oryginalu, id_kategorii, opis)
    VALUES (tytul, jezyk_oryginalu, id_kategorii, opis)
    RETURNING id_ksiazki INTO nowa_ksiazka_id;

    -- dodanie wpisów do tabeli asocjacyjnej ksiazki_autorzy
    IF autorzy IS NOT NULL THEN
        INSERT INTO biblioteka.ksiazki_autorzy (id_ksiazki, id_autora)
        SELECT nowa_ksiazka_id, unnest(autorzy);
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION biblioteka.sprawdz_dostepne_egzemplarze(id_wydania_input INT)
    RETURNS INT AS $$
DECLARE
    liczba_dostepnych INT;
BEGIN
    SELECT COUNT(*)
    INTO liczba_dostepnych
    FROM biblioteka.egzemplarze
    WHERE id_wydania = id_wydania_input AND stan = 'dostępny';

    RETURN liczba_dostepnych;
END;
$$ LANGUAGE plpgsql;


-- WIDOKI

CREATE OR REPLACE VIEW biblioteka.hierarchia_kategorii AS
WITH RECURSIVE hierarchia AS (
    SELECT
        id_kategorii,
        nazwa,
        id_kategorii_nadrzednej,
        ARRAY[nazwa::VARCHAR] AS sciezka
    FROM biblioteka.kategorie
    WHERE id_kategorii_nadrzednej IS NULL
    UNION ALL
    SELECT
        k.id_kategorii,
        k.nazwa,
        k.id_kategorii_nadrzednej,
        h.sciezka || k.nazwa::VARCHAR
    FROM biblioteka.kategorie k
             INNER JOIN hierarchia h ON k.id_kategorii_nadrzednej = h.id_kategorii
)
SELECT id_kategorii, nazwa, id_kategorii_nadrzednej, array_to_string(sciezka, ' > ') AS sciezka
FROM hierarchia;


CREATE OR REPLACE VIEW biblioteka.widok_czytelnicy AS
SELECT
    c.id_czytelnika,
    c.imie,
    c.nazwisko,
    c.data_urodzin,
    c.pesel,
    c.kraj,
    c.miejscowosc,
    c.ulica,
    c.numer_domu,
    c.kod_pocztowy,
    c.telefon,
    c.email,
    COALESCE(COUNT(w.id_wypozyczenia), 0) AS liczba_wypozyczen,
    COALESCE(SUM(w.kara), 0.00) AS suma_kar
FROM
    biblioteka.czytelnicy c
        LEFT JOIN
    biblioteka.wypozyczenia w ON c.id_czytelnika = w.id_czytelnika
GROUP BY
    c.id_czytelnika, c.imie, c.nazwisko, c.data_urodzin, c.pesel,
    c.kraj, c.miejscowosc, c.ulica, c.numer_domu, c.kod_pocztowy, c.telefon, c.email;


CREATE OR REPLACE VIEW biblioteka.widok_egzemplarzy AS
SELECT
    e.id_egzemplarza,
    k.tytul AS tytul_ksiazki,
    STRING_AGG(a.imie || ' ' || a.nazwisko, ', ') AS autorzy,
    w.nazwa AS wydawnictwo,
    wd.rok_wydania,
    l.numer_polki,
    l.opis AS opis_lokalizacji,
    wd.sciezka_do_okladki,
    e.stan,
    e.id_wydania,
    e.id_lokalizacji,
    COALESCE(c.nazwa || ' (' || h.sciezka || ')', c.nazwa) AS sciezka_kategorii
FROM biblioteka.egzemplarze e
         LEFT JOIN biblioteka.wydania wd ON e.id_wydania = wd.id_wydania
         LEFT JOIN biblioteka.ksiazki k ON wd.id_ksiazki = k.id_ksiazki
         LEFT JOIN biblioteka.ksiazki_autorzy ka ON k.id_ksiazki = ka.id_ksiazki
         LEFT JOIN biblioteka.autorzy a ON ka.id_autora = a.id_autora
         LEFT JOIN biblioteka.wydawnictwa w ON wd.id_wydawnictwa = w.id_wydawnictwa
         LEFT JOIN biblioteka.kategorie c ON k.id_kategorii = c.id_kategorii
         LEFT JOIN biblioteka.hierarchia_kategorii h ON c.id_kategorii = h.id_kategorii
         LEFT JOIN biblioteka.lokalizacje l ON e.id_lokalizacji = l.id_lokalizacji
GROUP BY
    e.id_egzemplarza,
    k.tytul,
    w.nazwa,
    wd.rok_wydania,
    l.numer_polki,
    l.opis,
    wd.sciezka_do_okladki,
    c.nazwa,
    h.sciezka,
    e.stan,
    e.id_wydania,
    e.id_lokalizacji;


CREATE OR REPLACE VIEW biblioteka.widok_ksiazek AS
SELECT
    ks.id_ksiazki,
    ks.tytul,
    ks.jezyk_oryginalu,
    STRING_AGG(a.imie || ' ' || a.nazwisko, ', ') AS autorzy,
    ks.opis,
    COALESCE(c.nazwa || ' (' || h.sciezka || ')', c.nazwa) AS sciezka_kategorii,
    c.id_kategorii
FROM biblioteka.ksiazki ks
         LEFT JOIN biblioteka.ksiazki_autorzy ka ON ks.id_ksiazki = ka.id_ksiazki
         LEFT JOIN biblioteka.autorzy a ON ka.id_autora = a.id_autora
         LEFT JOIN biblioteka.kategorie c ON ks.id_kategorii = c.id_kategorii
         LEFT JOIN biblioteka.hierarchia_kategorii h ON c.id_kategorii = h.id_kategorii
GROUP BY ks.id_ksiazki, ks.tytul, ks.jezyk_oryginalu, ks.opis, c.nazwa, h.sciezka, c.id_kategorii;

-- widok najlepiej ocenianych ksiazek
CREATE OR REPLACE VIEW biblioteka.widok_najbardziej_popularne_ksiazki AS
SELECT
    k.id_ksiazki,
    k.tytul,
    COUNT(DISTINCT w.id_wypozyczenia) AS liczba_wypozyczen,
    ROUND(AVG(o.ocena), 2) AS srednia_ocen
FROM biblioteka.ksiazki k
         LEFT JOIN biblioteka.wydania wyd ON k.id_ksiazki = wyd.id_ksiazki
         LEFT JOIN biblioteka.egzemplarze e ON wyd.id_wydania = e.id_wydania
         LEFT JOIN biblioteka.wypozyczenia w ON e.id_egzemplarza = w.id_egzemplarza
         LEFT JOIN biblioteka.oceny o ON k.id_ksiazki = o.id_ksiazki
GROUP BY
    k.id_ksiazki, k.tytul
HAVING
    COUNT(DISTINCT w.id_wypozyczenia) >= 2
   AND AVG(o.ocena) >= 4
ORDER BY
    liczba_wypozyczen DESC,
    srednia_ocen DESC;


CREATE OR REPLACE VIEW biblioteka.widok_rezerwacji AS
SELECT
    rez.id_rezerwacji,
    rez.data_rezerwacji,
    rez.id_czytelnika,
    rez.id_wydania,
    c.imie AS czytelnik_imie,
    c.nazwisko AS czytelnik_nazwisko,
    c.pesel AS czytelnik_pesel,
    ks.tytul AS tytul_ksiazki,
    w.rok_wydania AS rok_wydania,
    wyd.nazwa AS wydawnictwo,
    STRING_AGG(autorzy.imie || ' ' || autorzy.nazwisko, ', ') AS autorzy
FROM biblioteka.rezerwacje rez
         JOIN biblioteka.czytelnicy c ON rez.id_czytelnika = c.id_czytelnika
         JOIN biblioteka.wydania w ON rez.id_wydania = w.id_wydania
         JOIN biblioteka.ksiazki ks ON w.id_ksiazki = ks.id_ksiazki
         JOIN biblioteka.wydawnictwa wyd ON w.id_wydawnictwa = wyd.id_wydawnictwa
         JOIN biblioteka.ksiazki_autorzy ka ON ks.id_ksiazki = ka.id_ksiazki
         JOIN biblioteka.autorzy ON ka.id_autora = autorzy.id_autora
GROUP BY
    rez.id_rezerwacji,
    rez.data_rezerwacji,
    rez.id_czytelnika,
    c.imie, c.nazwisko, c.pesel,
    ks.tytul,
    w.rok_wydania,
    wyd.nazwa;


CREATE OR REPLACE VIEW biblioteka.widok_wydania AS
SELECT
    wydania.id_wydania,
    wydania.id_ksiazki,
    ksiazki.tytul AS tytul_ksiazki,
    STRING_AGG(autorzy.imie || ' ' || autorzy.nazwisko, ', ') AS autorzy,
    wydania.id_wydawnictwa,
    wydawnictwa.nazwa AS wydawnictwo,
    wydania.rok_wydania,
    wydania.jezyk,
    wydania.liczba_stron,
    wydania.sciezka_do_okladki,
    COALESCE(kategorie.nazwa || ' (' || hierarchia_kategorii.sciezka || ')', kategorie.nazwa) AS sciezka_kategorii,
    ksiazki.opis,
    -- średnia ocen książki
    round((SELECT AVG(oceny.ocena)
           FROM biblioteka.oceny
           WHERE oceny.id_ksiazki = wydania.id_ksiazki)::NUMERIC, 2) AS srednia_ocen,
    -- liczba wypożyczeń wydania
    (SELECT COUNT(*)
     FROM biblioteka.wypozyczenia
     WHERE wypozyczenia.id_egzemplarza IN (
         SELECT id_egzemplarza
         FROM biblioteka.egzemplarze
         WHERE egzemplarze.id_wydania = wydania.id_wydania
     )) AS liczba_wypozyczen
FROM biblioteka.wydania
         LEFT JOIN biblioteka.ksiazki ON wydania.id_ksiazki = ksiazki.id_ksiazki
         LEFT JOIN biblioteka.ksiazki_autorzy ON ksiazki.id_ksiazki = ksiazki_autorzy.id_ksiazki
         LEFT JOIN biblioteka.autorzy ON ksiazki_autorzy.id_autora = autorzy.id_autora
         LEFT JOIN biblioteka.wydawnictwa ON wydania.id_wydawnictwa = wydawnictwa.id_wydawnictwa
         LEFT JOIN biblioteka.kategorie ON ksiazki.id_kategorii = kategorie.id_kategorii
         LEFT JOIN biblioteka.hierarchia_kategorii ON kategorie.id_kategorii = hierarchia_kategorii.id_kategorii
GROUP BY
    wydania.id_wydania,
    ksiazki.tytul,
    wydawnictwa.nazwa,
    wydania.rok_wydania,
    wydania.jezyk,
    wydania.liczba_stron,
    wydania.sciezka_do_okladki,
    kategorie.nazwa,
    hierarchia_kategorii.sciezka,
    ksiazki.opis;


CREATE OR REPLACE VIEW biblioteka.widok_wypozyczen AS
SELECT
    wyp.id_wypozyczenia,
    wyp.data_wypozyczenia,
    wyp.data_zwrotu,
    wyp.id_czytelnika,
    wyp.status,
    egz.id_wydania,
    c.imie AS czytelnik_imie,
    c.nazwisko AS czytelnik_nazwisko,
    c.pesel AS czytelnik_pesel,
    ks.tytul AS tytul_ksiazki,
    w.rok_wydania AS rok_wydania,
    wyd.nazwa AS wydawnictwo,
    STRING_AGG(autorzy.imie || ' ' || autorzy.nazwisko, ', ') AS autorzy,
    wyp.kara,
    wyp.id_egzemplarza
FROM biblioteka.wypozyczenia wyp
         JOIN biblioteka.czytelnicy c ON wyp.id_czytelnika = c.id_czytelnika
         JOIN biblioteka.egzemplarze egz ON wyp.id_egzemplarza = egz.id_egzemplarza
         JOIN biblioteka.wydania w ON egz.id_wydania = w.id_wydania
         JOIN biblioteka.wydawnictwa wyd ON w.id_wydawnictwa = wyd.id_wydawnictwa
         JOIN biblioteka.ksiazki ks ON w.id_ksiazki = ks.id_ksiazki
         JOIN biblioteka.ksiazki_autorzy ka ON ks.id_ksiazki = ka.id_ksiazki
         JOIN biblioteka.autorzy ON ka.id_autora = autorzy.id_autora
GROUP BY
    wyp.id_egzemplarza,
    egz.id_wydania,
    egz.id_lokalizacji,
    ks.tytul,
    wyd.nazwa,
    w.rok_wydania,
    egz.stan,
    wyp.id_wypozyczenia,
    wyp.data_wypozyczenia,
    wyp.data_zwrotu,
    wyp.id_czytelnika,
    wyp.status,
    czytelnik_imie, czytelnik_nazwisko, czytelnik_pesel,
    wyp.kara;


-- WSTAWIANIE DANYCH

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
INSERT INTO biblioteka.egzemplarze (id_wydania, stan) VALUES (1, 'dostępny');
INSERT INTO biblioteka.egzemplarze (id_wydania, stan) VALUES (2, 'dostępny');
INSERT INTO biblioteka.egzemplarze (id_wydania, stan) VALUES (3, 'dostępny');
INSERT INTO biblioteka.egzemplarze (id_wydania, stan) VALUES (4, 'dostępny');

-- Autorzy
INSERT INTO biblioteka.autorzy (imie, nazwisko, rok_urodzenia, kraj_pochodzenia, notka_biograficzna) VALUES ('Jan', 'Kowalski', 1975, 'Polska', 'To jest przykładowa treść notki biograficznej autora.');
INSERT INTO biblioteka.autorzy (imie, nazwisko, rok_urodzenia, kraj_pochodzenia, notka_biograficzna) VALUES ('Anna', 'Nowak', 1980, 'Polska', 'To jest przykładowa treść notki biograficznej autora.');
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
INSERT INTO biblioteka.wypozyczenia (id_egzemplarza, id_czytelnika, data_wypozyczenia, data_zwrotu) VALUES (1, 1, '2024-12-01', '2025-01-10');
INSERT INTO biblioteka.wypozyczenia (id_egzemplarza, id_czytelnika, data_wypozyczenia, data_zwrotu) VALUES (2, 2, '2024-12-12', '2025-01-10');
INSERT INTO biblioteka.wypozyczenia (id_egzemplarza, id_czytelnika, data_wypozyczenia, data_zwrotu) VALUES (3, 2, '2024-12-01', NULL);
INSERT INTO biblioteka.wypozyczenia (id_egzemplarza, id_czytelnika, data_wypozyczenia, data_zwrotu) VALUES (4, 2, '2024-12-15', '2025-01-13');


-- Rezerwacje
-- INSERT INTO biblioteka.rezerwacje (id_wydania, id_czytelnika) VALUES (2, 1);
-- INSERT INTO biblioteka.rezerwacje (id_wydania, id_czytelnika) VALUES (3, 1);

-- Oceny
INSERT INTO biblioteka.oceny (id_ksiazki, id_czytelnika, ocena, komentarz) VALUES (1, 1, 5, 'Świetna książka!');
INSERT INTO biblioteka.oceny (id_ksiazki, id_czytelnika, ocena, komentarz) VALUES (3, 2, 4, 'Dobra książka, ale mogłaby być bardziej szczegółowa.');
INSERT INTO biblioteka.oceny (id_ksiazki, id_czytelnika, ocena, komentarz) VALUES (4, 1, 5, 'Świetna książka! Polecam każdemu.');
INSERT INTO biblioteka.oceny (id_ksiazki, id_czytelnika, ocena, komentarz) VALUES (1, 2, 3, 'Autor mógł się trochę bardziej postarać...');


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
