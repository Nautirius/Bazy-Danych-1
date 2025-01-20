CREATE OR REPLACE VIEW biblioteka.widok_egzemplarzy AS
SELECT
    e.id_egzemplarza,
    k.tytul AS tytul_ksiazki,
    STRING_AGG(a.imie || ' ' || a.nazwisko, ', ') AS autorzy,
    w.nazwa AS wydawnictwo,
    wd.rok_wydania,
    l.numer_polki,
    l.opis AS opis_lokalizacji,
    wd.sciezka_do_okladki,
    e.stan,
    e.id_wydania,
    e.id_lokalizacji,
    COALESCE(c.nazwa || ' (' || h.sciezka || ')', c.nazwa) AS sciezka_kategorii
FROM biblioteka.egzemplarze e
     LEFT JOIN biblioteka.wydania wd ON e.id_wydania = wd.id_wydania
     LEFT JOIN biblioteka.ksiazki k ON wd.id_ksiazki = k.id_ksiazki
     LEFT JOIN biblioteka.ksiazki_autorzy ka ON k.id_ksiazki = ka.id_ksiazki
     LEFT JOIN biblioteka.autorzy a ON ka.id_autora = a.id_autora
     LEFT JOIN biblioteka.wydawnictwa w ON wd.id_wydawnictwa = w.id_wydawnictwa
     LEFT JOIN biblioteka.kategorie c ON k.id_kategorii = c.id_kategorii
     LEFT JOIN biblioteka.hierarchia_kategorii h ON c.id_kategorii = h.id_kategorii
     LEFT JOIN biblioteka.lokalizacje l ON e.id_lokalizacji = l.id_lokalizacji
GROUP BY
    e.id_egzemplarza,
    k.tytul,
    w.nazwa,
    wd.rok_wydania,
    l.numer_polki,
    l.opis,
    wd.sciezka_do_okladki,
    c.nazwa,
    h.sciezka,
    e.stan,
    e.id_wydania,
    e.id_lokalizacji;
