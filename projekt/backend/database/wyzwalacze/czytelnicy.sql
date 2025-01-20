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
