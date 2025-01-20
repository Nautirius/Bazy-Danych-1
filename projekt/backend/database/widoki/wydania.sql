CREATE OR REPLACE VIEW biblioteka.widok_wydania AS
SELECT
    wydania.id_wydania,
    wydania.id_ksiazki,
    ksiazki.tytul AS tytul_ksiazki,
    STRING_AGG(autorzy.imie || ' ' || autorzy.nazwisko, ', ') AS autorzy,
    wydania.id_wydawnictwa,
    wydawnictwa.nazwa AS wydawnictwo,
    wydania.rok_wydania,
    wydania.jezyk,
    wydania.liczba_stron,
    wydania.sciezka_do_okladki,
    COALESCE(kategorie.nazwa || ' (' || hierarchia_kategorii.sciezka || ')', kategorie.nazwa) AS sciezka_kategorii,
    ksiazki.opis,
    -- średnia ocen książki
    round((SELECT AVG(oceny.ocena)
     FROM biblioteka.oceny
     WHERE oceny.id_ksiazki = wydania.id_ksiazki)::NUMERIC, 2) AS srednia_ocen,
    -- liczba wypożyczeń wydania
    (SELECT COUNT(*)
     FROM biblioteka.wypozyczenia
     WHERE wypozyczenia.id_egzemplarza IN (
         SELECT id_egzemplarza
         FROM biblioteka.egzemplarze
         WHERE egzemplarze.id_wydania = wydania.id_wydania
     )) AS liczba_wypozyczen
FROM biblioteka.wydania
    LEFT JOIN biblioteka.ksiazki ON wydania.id_ksiazki = ksiazki.id_ksiazki
    LEFT JOIN biblioteka.ksiazki_autorzy ON ksiazki.id_ksiazki = ksiazki_autorzy.id_ksiazki
    LEFT JOIN biblioteka.autorzy ON ksiazki_autorzy.id_autora = autorzy.id_autora
    LEFT JOIN biblioteka.wydawnictwa ON wydania.id_wydawnictwa = wydawnictwa.id_wydawnictwa
    LEFT JOIN biblioteka.kategorie ON ksiazki.id_kategorii = kategorie.id_kategorii
    LEFT JOIN biblioteka.hierarchia_kategorii ON kategorie.id_kategorii = hierarchia_kategorii.id_kategorii
GROUP BY
    wydania.id_wydania,
    ksiazki.tytul,
    wydawnictwa.nazwa,
    wydania.rok_wydania,
    wydania.jezyk,
    wydania.liczba_stron,
    wydania.sciezka_do_okladki,
    kategorie.nazwa,
    hierarchia_kategorii.sciezka,
    ksiazki.opis;
