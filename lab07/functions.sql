-- zadanie 1

CREATE OR REPLACE FUNCTION lab07.oblicz_koszty(koszt_graniczny NUMERIC)
RETURNS INTEGER AS $$
DECLARE
    przekroczone_kursy_count INTEGER := 0;
    kurs_cursor CURSOR FOR
        SELECT
            k.kurs_id,
            k.nazwa,
            COUNT(z.wykladowca_id) AS wykladowcy_count,
            SUM(w.wynagrodzenie) AS suma_wynagrodzen
        FROM
            lab07.kurs k
        JOIN
            lab07.zajecia z ON k.kurs_id = z.kurs_id
        JOIN
            lab07.wykladowca w ON z.wykladowca_id = w.wykladowca_id
        GROUP BY
            k.kurs_id, k.nazwa;
BEGIN
    FOR kurs IN kurs_cursor LOOP
        IF kurs.suma_wynagrodzen > koszt_graniczny THEN
            INSERT INTO lab07.koszty (kurs_id, wykladowcy, koszt_plus)
            VALUES (kurs.kurs_id, kurs.wykladowcy_count, kurs.suma_wynagrodzen - koszt_graniczny);
            przekroczone_kursy_count := przekroczone_kursy_count + 1;
        ELSE
            INSERT INTO lab07.koszty (kurs_id, wykladowcy, koszt_plus)
            VALUES (kurs.kurs_id, kurs.wykladowcy_count, 0);
        END IF;

    END LOOP;

    RETURN przekroczone_kursy_count;
END;
$$ LANGUAGE plpgsql;


-- zadanie 2

CREATE OR REPLACE FUNCTION lab07.wypelnij_nagrody()
RETURNS INTEGER AS $$
DECLARE
    rekordy_dopisane INTEGER := 0;
    wykladowca RECORD;
    nagroda NUMERIC(7, 2);
BEGIN
    FOR wykladowca IN
        SELECT
            w.wykladowca_id,
            w.wynagrodzenie,
            COUNT(z.kurs_id) AS liczba_kursow
        FROM
            lab07.wykladowca w
        RIGHT JOIN
            lab07.zajecia z ON w.wykladowca_id = z.wykladowca_id
        GROUP BY
            w.wykladowca_id, w.wynagrodzenie
    LOOP
        IF wykladowca.liczba_kursow = 2 THEN
            nagroda := wykladowca.wynagrodzenie * 0.10;
        ELSIF wykladowca.liczba_kursow BETWEEN 3 AND 5 THEN
            nagroda := wykladowca.wynagrodzenie * 0.20;
        ELSIF wykladowca.liczba_kursow > 5 THEN
            nagroda := wykladowca.wynagrodzenie * 0.30;
        ELSE
            nagroda := 0;
        END IF;

        INSERT INTO lab07.nagrody (wykladowca_id, nagroda, data)
        VALUES (wykladowca.wykladowca_id, nagroda, CURRENT_DATE);

        rekordy_dopisane := rekordy_dopisane + 1;
    END LOOP;

    RETURN rekordy_dopisane;
END;
$$ LANGUAGE plpgsql;


-- zadanie 3

CREATE OR REPLACE FUNCTION rownanie_1(a DOUBLE PRECISION, b DOUBLE PRECISION, c DOUBLE PRECISION)
RETURNS TABLE (equ_solve TEXT) AS $$
DECLARE
    delta DOUBLE PRECISION;
    x1 DOUBLE PRECISION;
    x2 DOUBLE PRECISION;
    real_part DOUBLE PRECISION;
    im_part DOUBLE PRECISION;
BEGIN
    delta := b * b - 4 * a * c;
    RAISE INFO 'INFORMACJA: DELTA = %', delta;

    IF delta > 0 THEN
        x1 := (-b + SQRT(delta)) / (2 * a);
        x2 := (-b - SQRT(delta)) / (2 * a);
        RAISE INFO 'INFORMACJA: Rozwiazanie posiada dwa rzeczywiste pierwiastki';
        RAISE INFO 'x1 = %', x1;
        RAISE INFO 'x2 = %', x2;

        RETURN QUERY SELECT format('(x1 = %s ),(x2 = %s)', x1, x2);
    ELSIF delta = 0 THEN
        x1 := -b / (2 * a);
        RAISE INFO 'INFORMACJA: Rozwiazanie posiada jeden rzeczywisty pierwiastek';
        RAISE INFO 'x1 = %', x1;

        RETURN QUERY SELECT format('(x1 = %s)', x1);
    ELSE
        real_part := -b / (2 * a);
        im_part := SQRT(-delta) / (2 * a);
        RAISE INFO 'INFORMACJA: Rozwiazanie w dziedzinie liczb zespolonych';
        RAISE INFO 'x1 = % + %i', real_part, im_part;
        RAISE INFO 'x2 = % - %i', real_part, im_part;

        RETURN QUERY SELECT format('(x1 = %s + %si ),(x2 = %s - %si)', real_part, im_part, real_part, im_part);
    END IF;
END;
$$ LANGUAGE plpgsql;
