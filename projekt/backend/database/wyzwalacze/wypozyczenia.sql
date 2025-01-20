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
