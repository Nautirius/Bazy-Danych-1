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
