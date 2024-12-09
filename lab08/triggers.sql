-- Zadanie 1
CREATE OR REPLACE FUNCTION lab08.aktualizuj_koszty()
RETURNS TRIGGER AS $$
DECLARE
    koszt_kursu NUMERIC(10, 2);
    ilosc_wykladowcow INTEGER;
    koszt_graniczny NUMERIC := tg_argv[0];
BEGIN
    SELECT
        SUM(w.wynagrodzenie),
        COUNT(w.wykladowca_id)
    INTO
        koszt_kursu, ilosc_wykladowcow
    FROM
        lab08.wykladowca w
    JOIN
        lab08.zajecia z ON w.wykladowca_id = z.wykladowca_id
    WHERE
        z.kurs_id = NEW.kurs_id;

    IF koszt_kursu > koszt_graniczny THEN
        IF EXISTS (
            SELECT 1 FROM lab08.koszty WHERE kurs_id = NEW.kurs_id
        ) THEN
            UPDATE lab08.koszty
            SET wykladowcy = ilosc_wykladowcow,
                koszt_plus = koszt_kursu - koszt_graniczny
            WHERE kurs_id = NEW.kurs_id;
        ELSE
            INSERT INTO lab08.koszty (kurs_id, wykladowcy, koszt_plus)
            VALUES (NEW.kurs_id, ilosc_wykladowcow, koszt_kursu - koszt_graniczny);
        END IF;
    ELSE
        DELETE FROM lab08.koszty WHERE kurs_id = NEW.kurs_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER aktualizuj_koszty_trigger
AFTER INSERT OR UPDATE OR DELETE ON lab08.zajecia
FOR EACH ROW
EXECUTE PROCEDURE lab08.aktualizuj_koszty(10000);

DROP TRIGGER aktualizuj_koszty_trigger  ON lab08.zajecia;



-- Zadanie 2
CREATE OR REPLACE FUNCTION lab08.zwieksz_premie()
RETURNS TRIGGER AS $$
DECLARE
    liczba_kursow INTEGER;
BEGIN
    SELECT COUNT(*) INTO liczba_kursow
    FROM lab08.zajecia
    WHERE wykladowca_id = NEW.wykladowca_id;


    IF liczba_kursow % 3 = 0 THEN
        UPDATE lab08.wykladowca
        SET premia = LEAST(premia + 2, 100)
        WHERE wykladowca_id = NEW.wykladowca_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER zwieksz_premie_trigger
AFTER INSERT ON lab08.zajecia
FOR EACH ROW
EXECUTE PROCEDURE lab08.zwieksz_premie();

DROP TRIGGER zwieksz_premie_trigger  ON lab08.zajecia;


-- Zadanie 3
CREATE OR REPLACE FUNCTION lab08.usuwanie_wykladowcy()
RETURNS TRIGGER AS $$
DECLARE
    niezakonczone_kursy INTEGER;
    jedyny_prowadzacy_kursy INTEGER;
BEGIN
    SELECT COUNT(*) INTO niezakonczone_kursy
    FROM lab08.kurs k
    JOIN lab08.zajecia z ON k.kurs_id = z.kurs_id
    WHERE z.wykladowca_id = OLD.wykladowca_id
      AND k.koniec > CURRENT_DATE;

    IF niezakonczone_kursy > 0 THEN
        RAISE EXCEPTION 'Nie można usunąć wykładowcy %: bierze on udział w niezakończonym kursie.', OLD.wykladowca_id;
    END IF;

    SELECT COUNT(*) INTO jedyny_prowadzacy_kursy
    FROM lab08.kurs k
    WHERE k.kurs_id IN (
        SELECT z.kurs_id
        FROM lab08.zajecia z
        WHERE z.wykladowca_id = OLD.wykladowca_id
        GROUP BY z.kurs_id
        HAVING COUNT(*) = 1
    );

    DELETE FROM lab08.zajecia WHERE wykladowca_id = OLD.wykladowca_id;
    DELETE FROM lab08.koszty WHERE kurs_id IN (
        SELECT kurs_id FROM lab08.zajecia WHERE wykladowca_id = OLD.wykladowca_id
    );

    IF jedyny_prowadzacy_kursy > 0 THEN
        DELETE FROM lab08.kurs
        WHERE kurs_id IN (
            SELECT kurs_id
            FROM lab08.zajecia
            WHERE wykladowca_id = OLD.wykladowca_id
            GROUP BY kurs_id
            HAVING COUNT(*) = 1
        );
    END IF;

    DELETE FROM lab08.wykladowca WHERE wykladowca_id = OLD.wykladowca_id;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER usuwanie_wykladowcy_trigger
BEFORE DELETE ON lab08.wykladowca
FOR EACH ROW
EXECUTE PROCEDURE lab08.usuwanie_wykladowcy();

DROP TRIGGER usuwanie_wykladowcy_trigger ON lab08.wykladowca;

CREATE OR REPLACE FUNCTION lab08.usuwanie_wykladowcy()
RETURNS TRIGGER AS $$
DECLARE
    niezakonczone_kursy INTEGER;
    jedyny_prowadzacy_kursy INTEGER;
BEGIN
    -- Check for unfinished courses
    SELECT COUNT(*) INTO niezakonczone_kursy
    FROM lab08.kurs k
    JOIN lab08.zajecia z ON k.kurs_id = z.kurs_id
    WHERE z.wykladowca_id = OLD.wykladowca_id
      AND (k.koniec IS NULL OR k.koniec > CURRENT_DATE);

    IF niezakonczone_kursy > 0 THEN
        RAISE EXCEPTION 'Nie można usunąć wykładowcy %: bierze on udział w niezakończonym kursie.', OLD.wykladowca_id;
    END IF;

    -- Check if the lecturer is the only one teaching a course
    SELECT COUNT(*) INTO jedyny_prowadzacy_kursy
    FROM (
        SELECT z.kurs_id
        FROM lab08.zajecia z
        WHERE z.wykladowca_id = OLD.wykladowca_id
        GROUP BY z.kurs_id
        HAVING COUNT(*) = 1
    ) AS jedyny_prowadzacy;

    -- Delete associated zajecia entries
    DELETE FROM lab08.zajecia WHERE wykladowca_id = OLD.wykladowca_id;

    -- Delete koszty entries for courses taught by this lecturer
    DELETE FROM lab08.koszty
    WHERE kurs_id IN (
        SELECT kurs_id FROM lab08.zajecia WHERE wykladowca_id = OLD.wykladowca_id
    );

    -- If lecturer is the sole teacher of any course, delete those courses
    IF jedyny_prowadzacy_kursy > 0 THEN
        DELETE FROM lab08.kurs
        WHERE kurs_id IN (
            SELECT z.kurs_id
            FROM lab08.zajecia z
            WHERE z.wykladowca_id = OLD.wykladowca_id
            GROUP BY z.kurs_id
            HAVING COUNT(*) = 1
        );
    END IF;

    -- Delete the lecturer
    DELETE FROM lab08.wykladowca WHERE wykladowca_id = OLD.wykladowca_id;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS usuwanie_wykladowcy_trigger ON lab08.wykladowca;

CREATE TRIGGER usuwanie_wykladowcy_trigger
BEFORE DELETE ON lab08.wykladowca
FOR EACH ROW
EXECUTE PROCEDURE lab08.usuwanie_wykladowcy();

