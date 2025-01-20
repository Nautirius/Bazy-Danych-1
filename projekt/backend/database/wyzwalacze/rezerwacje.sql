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
