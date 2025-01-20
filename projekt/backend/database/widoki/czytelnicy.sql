CREATE OR REPLACE VIEW biblioteka.widok_czytelnicy AS
SELECT
    c.id_czytelnika,
    c.imie,
    c.nazwisko,
    c.data_urodzin,
    c.pesel,
    c.kraj,
    c.miejscowosc,
    c.ulica,
    c.numer_domu,
    c.kod_pocztowy,
    c.telefon,
    c.email,
    COALESCE(COUNT(w.id_wypozyczenia), 0) AS liczba_wypozyczen,
    COALESCE(SUM(w.kara), 0.00) AS suma_kar
FROM
    biblioteka.czytelnicy c
        LEFT JOIN
    biblioteka.wypozyczenia w ON c.id_czytelnika = w.id_czytelnika
GROUP BY
    c.id_czytelnika, c.imie, c.nazwisko, c.data_urodzin, c.pesel,
    c.kraj, c.miejscowosc, c.ulica, c.numer_domu, c.kod_pocztowy, c.telefon, c.email;
