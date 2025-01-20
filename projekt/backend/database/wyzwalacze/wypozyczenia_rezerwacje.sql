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
    WHEN (OLD.status = 'aktywne' AND NEW.status IS DISTINCT FROM 'aktywne')
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
