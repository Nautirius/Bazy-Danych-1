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
