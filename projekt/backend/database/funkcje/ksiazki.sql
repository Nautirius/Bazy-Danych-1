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
