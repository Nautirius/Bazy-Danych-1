CREATE OR REPLACE VIEW biblioteka.widok_rezerwacji AS
SELECT
    rez.id_rezerwacji,
    rez.data_rezerwacji,
    rez.id_czytelnika,
    rez.id_wydania,
    c.imie AS czytelnik_imie,
    c.nazwisko AS czytelnik_nazwisko,
    c.pesel AS czytelnik_pesel,
    ks.tytul AS tytul_ksiazki,
    w.rok_wydania AS rok_wydania,
    wyd.nazwa AS wydawnictwo,
    STRING_AGG(autorzy.imie || ' ' || autorzy.nazwisko, ', ') AS autorzy
FROM biblioteka.rezerwacje rez
    JOIN biblioteka.czytelnicy c ON rez.id_czytelnika = c.id_czytelnika
    JOIN biblioteka.wydania w ON rez.id_wydania = w.id_wydania
    JOIN biblioteka.ksiazki ks ON w.id_ksiazki = ks.id_ksiazki
    JOIN biblioteka.wydawnictwa wyd ON w.id_wydawnictwa = wyd.id_wydawnictwa
    JOIN biblioteka.ksiazki_autorzy ka ON ks.id_ksiazki = ka.id_ksiazki
    JOIN biblioteka.autorzy ON ka.id_autora = autorzy.id_autora
GROUP BY
    rez.id_rezerwacji,
    rez.data_rezerwacji,
    rez.id_czytelnika,
    c.imie, c.nazwisko, c.pesel,
    ks.tytul,
    w.rok_wydania,
    wyd.nazwa;
