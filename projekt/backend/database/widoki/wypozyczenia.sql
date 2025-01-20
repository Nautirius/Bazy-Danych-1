CREATE OR REPLACE VIEW biblioteka.widok_wypozyczen AS
SELECT
    wyp.id_wypozyczenia,
    wyp.data_wypozyczenia,
    wyp.data_zwrotu,
    wyp.id_czytelnika,
    wyp.status,
    egz.id_wydania,
    c.imie AS czytelnik_imie,
    c.nazwisko AS czytelnik_nazwisko,
    c.pesel AS czytelnik_pesel,
    ks.tytul AS tytul_ksiazki,
    w.rok_wydania AS rok_wydania,
    wyd.nazwa AS wydawnictwo,
    STRING_AGG(autorzy.imie || ' ' || autorzy.nazwisko, ', ') AS autorzy,
    wyp.kara,
    wyp.id_egzemplarza
FROM biblioteka.wypozyczenia wyp
    JOIN biblioteka.czytelnicy c ON wyp.id_czytelnika = c.id_czytelnika
    JOIN biblioteka.egzemplarze egz ON wyp.id_egzemplarza = egz.id_egzemplarza
    JOIN biblioteka.wydania w ON egz.id_wydania = w.id_wydania
    JOIN biblioteka.wydawnictwa wyd ON w.id_wydawnictwa = wyd.id_wydawnictwa
    JOIN biblioteka.ksiazki ks ON w.id_ksiazki = ks.id_ksiazki
    JOIN biblioteka.ksiazki_autorzy ka ON ks.id_ksiazki = ka.id_ksiazki
    JOIN biblioteka.autorzy ON ka.id_autora = autorzy.id_autora
GROUP BY
    wyp.id_egzemplarza,
    egz.id_wydania,
    egz.id_lokalizacji,
    ks.tytul,
    wyd.nazwa,
    w.rok_wydania,
    egz.stan,
    wyp.id_wypozyczenia,
    wyp.data_wypozyczenia,
    wyp.data_zwrotu,
    wyp.id_czytelnika,
    wyp.status,
    czytelnik_imie, czytelnik_nazwisko, czytelnik_pesel,
    wyp.kara;
