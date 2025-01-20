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
