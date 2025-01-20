CREATE OR REPLACE VIEW biblioteka.widok_ksiazek AS
SELECT
    ks.id_ksiazki,
    ks.tytul,
    ks.jezyk_oryginalu,
    STRING_AGG(a.imie || ' ' || a.nazwisko, ', ') AS autorzy,
    ks.opis,
    COALESCE(c.nazwa || ' (' || h.sciezka || ')', c.nazwa) AS sciezka_kategorii,
    c.id_kategorii
FROM biblioteka.ksiazki ks
     LEFT JOIN biblioteka.ksiazki_autorzy ka ON ks.id_ksiazki = ka.id_ksiazki
     LEFT JOIN biblioteka.autorzy a ON ka.id_autora = a.id_autora
     LEFT JOIN biblioteka.kategorie c ON ks.id_kategorii = c.id_kategorii
     LEFT JOIN biblioteka.hierarchia_kategorii h ON c.id_kategorii = h.id_kategorii
GROUP BY ks.id_ksiazki, ks.tytul, ks.jezyk_oryginalu, ks.opis, c.nazwa, h.sciezka, c.id_kategorii;

-- widok najlepiej ocenianych ksiazek
CREATE OR REPLACE VIEW biblioteka.widok_najbardziej_popularne_ksiazki AS
SELECT
    k.id_ksiazki,
    k.tytul,
    COUNT(w.id_wypozyczenia) AS liczba_wypozyczen,
    round(AVG(o.ocena), 2) AS srednia_ocen
FROM biblioteka.ksiazki k
     JOIN biblioteka.wydania wyd ON k.id_ksiazki = wyd.id_ksiazki
     JOIN biblioteka.egzemplarze e ON wyd.id_wydania = e.id_wydania
     JOIN biblioteka.wypozyczenia w ON e.id_egzemplarza = w.id_egzemplarza
     JOIN biblioteka.oceny o ON k.id_ksiazki = o.id_ksiazki
     JOIN biblioteka.ksiazki_autorzy ka ON k.id_ksiazki = ka.id_ksiazki
     JOIN biblioteka.autorzy a ON ka.id_autora = a.id_autora
GROUP BY
    k.id_ksiazki, k.tytul
HAVING
    COUNT(w.id_wypozyczenia) >= 2
   AND AVG(o.ocena) >= 4
ORDER BY liczba_wypozyczen DESC, srednia_ocen DESC;
