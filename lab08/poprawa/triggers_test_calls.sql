-- Zadanie 2
CREATE OR REPLACE FUNCTION lab08.zwieksz_premie()
RETURNS TRIGGER AS $$
DECLARE
    liczba_kursow INTEGER;
    nowa_premia REAL;
BEGIN
    SELECT COUNT(*)
    INTO liczba_kursow
    FROM lab08.zajecia
    WHERE wykladowca_id = NEW.wykladowca_id;

    nowa_premia = LEAST((liczba_kursow / 3) * 2, 100);

    UPDATE lab08.wykladowca
    SET premia = nowa_premia
    WHERE wykladowca_id = NEW.wykladowca_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER zwieksz_premie_trigger
AFTER INSERT ON lab08.zajecia
FOR EACH ROW
EXECUTE PROCEDURE lab08.zwieksz_premie();


-- test

-- Zadanie 2
-- 5 kursów - premia = 2
INSERT INTO lab08.zajecia (wykladowca_id, kurs_id) VALUES
(1, 1),
(1, 4),
(1, 3),
(1, 5),
(1, 6);

-- 6 kursów - premia = 4
INSERT INTO lab08.zajecia (wykladowca_id, kurs_id) VALUES
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(2, 5),
(2, 6);

-- dwa kursy - brak premii
INSERT INTO lab08.zajecia (wykladowca_id, kurs_id) VALUES
(3, 1),
(3, 2);

SELECT * FROM lab08.wykladowca ORDER BY premia DESC;
